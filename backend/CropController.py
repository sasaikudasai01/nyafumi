from PySide6.QtCore import QObject, Property, Signal, Slot
from config import cfg
import subprocess
from pathlib import Path


class UIState_crop(QObject):
    widthChanged = Signal()
    heightChanged = Signal()
    imageChanged = Signal()
    xChanged = Signal()
    yChanged = Signal()
    rowsChanged = Signal()

    def __init__(self, image, set_view):
        super().__init__()

        self.image = image

        # отслеживание изменения картинки
        image.imageChanged.connect(self.update_info)

        self.set_view = set_view

        self._width = 0
        self._height = 0

        self._x_coord = 0
        self._y_coord = 0

        # steam
        self._rows = 3
    
    @Slot()
    def update_info(self):
        self._width = 300
        self._height = 300

        self._x_coord = 0
        self._y_coord = 0

        self.widthChanged.emit()
        self.heightChanged.emit()
        self.xChanged.emit()
        self.yChanged.emit()
    


    # получить ширину
    def getWidth(self):
        return self._width

    # изменить ширину
    # value это int из width = Property(int, ...)
    def setWidth(self, value):
        self._width = value
        self.widthChanged.emit()



    # получить высоту
    def getHeight(self):
        return self._height

    # изменить высоту
    def setHeight(self, value):
        self._height = value
        self.heightChanged.emit()
    


    def setXCoord(self, coord):
        self._x_coord = coord
        self.xChanged.emit()

    def getXCoord(self):
        return self._x_coord



    def setYCoord(self, coord):
        self._y_coord = coord
        self.yChanged.emit()

    def getYCoord(self):
        return self._y_coord



    def setRows(self, num):
        # ограничение до цифр от 1 до 3
        if num in [1, 2, 3]:
            self._rows = num
            self.rowsChanged.emit()
        else:
            self._rows = 3
            self.rowsChanged.emit()
    
    def getRows(self):
        return self._rows

    width = Property(int, getWidth, setWidth, notify=widthChanged)
    height = Property(int, getHeight, setHeight, notify=heightChanged)
    x_coord = Property(int, getXCoord, setXCoord, notify=xChanged)
    y_coord = Property(int, getYCoord, setYCoord, notify=yChanged)
    rows = Property(int, getRows, setRows, notify=rowsChanged)

    @Slot(int, int, int, int)
    def crop(self, crop_width, crop_height, x, y):
        file_name = self.image.img_path.stem
        file_format = self.image.img_path.suffix

        subprocess.run(["ffmpeg", "-i", self.image.img_path, "-vf", f"crop={crop_width}:{crop_height}:{x}:{y}", "-y", f"{file_name} cropped.{file_format.replace('.', '')}"])

    @Slot()
    def crop_steam(self):
        max_counter = {1: 5, 2: 10, 3: 15} # количество кусков изображения зависит от количества rows

        for i in range(max_counter[self._rows]):
            # размеры кусков которые строят всю картинку
            part_width = self.image.original_width / 5
            part_height = self.image.original_height / self._rows

            row = i // 5
            col = i % 5

            x = col * part_width
            y = row * part_height

            img_path = cfg.base_dir / "sir" / f"{self.image.img_path.stem} steam {i + 1}{self.image.img_path.suffix}"

            subprocess.run(
                ["ffmpeg", "-i", self.image.img_path, "-vf", f"crop={part_width}:{part_height}:{x}:{y}", "-y", img_path],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL # очистить весь вывод ffmpeg
            )

            # редактирование байтов
            data = bytearray(Path(img_path).read_bytes())
            data[-1] = 0x67 # замена последнего байта. это нужно чтобы стим нормально скушал картинку
            Path(img_path).write_bytes(data)