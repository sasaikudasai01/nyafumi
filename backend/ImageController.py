from PySide6.QtCore import QObject, Property, Signal, QUrl
from config import cfg
import subprocess
import json

class CurrentImage(QObject):
    imageChanged = Signal()
    widthChanged = Signal()
    heightChanged = Signal()

    def __init__(self):
        super().__init__()

        self.img_path = None

        self.original_width = 0
        self.original_height = 0
    
    def getImageMetas(self, path):
        # получить метаданные картинки
        image_metas = subprocess.run([
            "ffprobe",
            "-v", "error",
            "-select_streams", "v:0",
            "-show_entries", "stream=width,height",
            "-of", "json",
            path
        ], capture_output=True, text=True)

        # данные в json
        data = json.loads(image_metas.stdout)

        # это нужно чтобы при изменении по проценту менять исходный размер а не уже измененный
        self.original_width = data["streams"][0]["width"]
        self.original_height = data["streams"][0]["height"]

    # image setter
    def setImage(self, path):
        self.img_path = path
        self.getImageMetas(path)
        self.imageChanged.emit()
    
    # image getter
    def getImage(self):
        return QUrl.fromLocalFile(str(self.img_path))
    

    # получить ширину
    def getWidth(self):
        return self.original_width

    # изменить ширину
    # value это int из width = Property(int, ...)
    def setWidth(self, value):
        self.original_width = value
        self.widthChanged.emit()



    # получить высоту
    def getHeight(self):
        return self.original_height

    # изменить высоту
    def setHeight(self, value):
        self.original_height = value
        self.heightChanged.emit()
    
    image = Property(QUrl, getImage, setImage, notify=imageChanged)
    width = Property(int, getWidth, setWidth, notify=widthChanged)
    height = Property(int, getHeight, setHeight, notify=heightChanged)

image = CurrentImage()