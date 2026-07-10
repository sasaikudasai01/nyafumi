from PySide6.QtCore import QObject, QUrl, Property, Signal, Slot

from pathlib import Path
import sys



class Config(QObject):
    imagePathChanged  = Signal()

    def __init__(self):
        super().__init__()

        if getattr(sys, "frozen", False):
            # запускается из exe
            self.base_dir = Path(sys.executable).parent

        else:
            # запускается из скрипта
            self.base_dir = Path(__file__).parent

        self.editing_photo_path = self.base_dir / "mama nyaf.jpg"
    
    # сменить qml файл (новая страница)
    def set_view(self, engine, qml_path: QUrl):
        root = engine.rootObjects()[0]
        loader = root.findChild(QObject, "viewLoader")
        loader.setProperty("source", qml_path)

# централизация
cfg = Config()