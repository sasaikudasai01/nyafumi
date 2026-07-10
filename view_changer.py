from PySide6.QtCore import QObject, QUrl, Slot
from pathlib import Path
from config import cfg

class SetView(QObject):

    def __init__(self, engine, image):
        super().__init__()

        self.image = image
        self.engine = engine
    
    @Slot(str, QUrl)
    def set_new_view(self, qml_path, img_path):
        _qml = qml_path
        if qml_path != "dragndrop.qml":
            # drop.urls[0] выдает url поэтмоу нужно перевести в локальный файл, чтобы qml смог отобразить картинку
            self.image.setImage(Path(QUrl(img_path).toLocalFile()))
            _qml = str(cfg.base_dir / "ui" / qml_path)

        root = self.engine.rootObjects()[0]
        loader = root.findChild(QObject, "viewLoader")
        loader.setProperty("source", QUrl.fromLocalFile(_qml))