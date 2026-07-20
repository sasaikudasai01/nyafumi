from PySide6.QtCore import QObject, Slot, QUrl
from pathlib import Path
from config import cfg
import subprocess

class FormatChange(QObject):
    def __init__(self, image):
        super().__init__()

        self.image = image

    @Slot(str, QUrl)
    def set_new_format(self, format, save_path):
        local_path = Path(str(QUrl(save_path).toLocalFile()).replace(f".{format}", ""))

        subprocess.run(["ffmpeg", "-i", self.image.img_path, f'{local_path}.{format}'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)