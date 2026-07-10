from PySide6.QtCore import QObject, Property, Signal, Slot, QUrl
from config import cfg
import subprocess


class UIState_resize(QObject):
    widthChanged = Signal()
    heightChanged = Signal()
    percentChanged = Signal()
    maintain_aspect_ratio_Changed = Signal()
    imageChanged = Signal()

    def __init__(self, image, set_view):
        super().__init__()

        self.image = image

        # отслеживание изменения картинки
        image.imageChanged.connect(self.update_info)

        self.set_view = set_view

        self._width = 0
        self._height = 0

        self._percent = 0

        # сохранять ли пропорцию
        self._maintain_aspect_ratio = False
        # цвет круглой кнопки 
        self._maintain_aspect_ratio_button_color = "black"
    
    @Slot()
    def update_info(self):
        self._width = self.image.original_width
        self._height = self.image.original_height
        self._percent = 0

        self.widthChanged.emit()
        self.heightChanged.emit()
        self.percentChanged.emit()



    # получить ширину
    def getWidth(self):
        return self._width
    
    # изменить ширину
    # value это int из width = Property(int, ...)
    def setWidth(self, value):
        # сохранить пропорции
        if self._maintain_aspect_ratio:
            self._height = self.image.original_height / (self.image.original_width / value)
            self.heightChanged.emit()
        
        self._percent = 0
        self.percentChanged.emit()

        self._width = value
        self.widthChanged.emit()



    # получить высоту
    def getHeight(self):
        return self._height

    # изменить высоту
    def setHeight(self, value):
        # сохранить пропорции
        if self._maintain_aspect_ratio:
            self._width = self.image.original_width / (self.image.original_height / value)
            self.widthChanged.emit()

        self._percent = 0
        self.percentChanged.emit()

        self._height = value
        self.heightChanged.emit()
    


    # получить проценты
    def getPercent(self):
        return self._percent

    # изменить проценты
    def setPercent(self, percent):
        self._width = self.image.original_width - (self.image.original_width * percent / 100)
        self.widthChanged.emit()
        
        self._height = self.image.original_height - (self.image.original_height * percent / 100)
        self.heightChanged.emit()

        self._percent = percent
        self.percentChanged.emit()



    # получить maintain_aspect_ratio
    def getMaintain_aspect_ratio(self):
        return self._maintain_aspect_ratio_button_color
    
    # изменить maintain_aspect_ratio
    def setMaintain_aspect_ratio(self, _):
        self._maintain_aspect_ratio = not self._maintain_aspect_ratio
        if self._maintain_aspect_ratio:
            self._maintain_aspect_ratio_button_color = "#808080"
        else:
            self._maintain_aspect_ratio_button_color = "black"
        
        self.maintain_aspect_ratio_Changed.emit()
    


    # базовая констркция для Property(type, getter, setter, notify)
    width = Property(int, getWidth, setWidth, notify=widthChanged)
    height = Property(int, getHeight, setHeight, notify=heightChanged)
    percent = Property(int, getPercent, setPercent, notify=percentChanged)
    maintain_aspect_ratio = Property(str, getMaintain_aspect_ratio, setMaintain_aspect_ratio, notify=maintain_aspect_ratio_Changed)

    @Slot(int, int)
    def resize(self, width, height):
        file_name = self.image.img_path.stem
        file_format = self.image.img_path.suffix

        print(f'file_name: {file_name}')
        print(f'file_format: {file_format}')

        subprocess.run(["ffmpeg", "-i", self.image.img_path, "-vf", f"scale={width}:{height}", "-y", f"{file_name} resized.{file_format}"])
        print(f"scale={width}:{height}")
