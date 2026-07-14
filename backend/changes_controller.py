from PySide6.QtCore import QObject, Slot, QUrl
import subprocess
from config import cfg

# -i -- input file
# -vf -- video filter
# "-y" -- overwrite output file without asking

# apply changes
class ChangesController(QObject):

    def __init__(self, engine, UIState):
        super().__init__()

        self.UIState_resize = UIState

        self.engine = engine

    @Slot(int, int)
    def apply_changes(self, width, height):

        # steam crop
        counter = 1
        x = 0
        y = 0

        while counter < 5:
            if x == 6 or x == 11:
                subprocess.run(["ffmpeg", "-i", "mama nyaf 4 steem.jpg", "-vf", f"crop={width}:{height}:{x}:{y}", "-y", f"sir/mama nyaf cropped {counter}.jpg"])
                counter += 1
                x += 150
                y += 450