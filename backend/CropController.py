from PySide6.QtCore import QObject, Property, Signal, Slot, QUrl
from config import cfg
import subprocess


class UIState_crop(QObject):
    widthChanged = Signal()
    heightChanged = Signal()
    imageChanged = Signal()
    xChanged = Signal()
    yChanged = Signal()

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
    
    @Slot()
    def update_info(self):
        #self._width = self.image.original_width
        #self._height = self.image.original_height
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

    width = Property(int, getWidth, setWidth, notify=widthChanged)
    height = Property(int, getHeight, setHeight, notify=heightChanged)
    x_coord = Property(int, getXCoord, setXCoord, notify=xChanged)
    y_coord = Property(int, getYCoord, setYCoord, notify=yChanged)

    @Slot(int, int, int, int)
    def crop(self, crop_width, crop_height, x, y):
        file_name = self.image.img_path.stem
        file_format = self.image.img_path.suffix

        subprocess.run(["ffmpeg", "-i", self.image.img_path, "-vf", f"crop={crop_width}:{crop_height}:{x}:{y}", "-y", f"{file_name} cropped.{file_format}"])