import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle

from backend.changes_controller import ChangesController
from backend.UIStateController import UIState_resize
from backend.ImageController import image
from backend.CropController import UIState_crop

from view_changer import SetView

from config import cfg



def main():
    QQuickStyle.setStyle("Fusion") # dark theme

    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()

    controller = ChangesController(engine, UIState_resize)
    engine.rootContext().setContextProperty("changesController", controller)

    engine.rootContext().setContextProperty("cfg", cfg)

    engine.rootContext().setContextProperty("image", image)

    set_view = SetView(engine, image)
    engine.rootContext().setContextProperty("setView", set_view)

    state = UIState_resize(image, set_view)
    engine.rootContext().setContextProperty("uiStateResize", state)

    crop_state = UIState_crop(image, set_view)
    engine.rootContext().setContextProperty("uiStateCrop", crop_state)

    # main qml file
    engine.load(cfg.base_dir / "main.qml")

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()