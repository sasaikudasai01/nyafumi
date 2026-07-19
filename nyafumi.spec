from pathlib import Path
from shutil import move
import glob

# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('*.qml', '.'),
        ('ui/*.qml', 'ui'),
        ('components/*.qml', 'components'),
    ],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='nyafumi',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='nyafumi',
)


dist_dir = Path(DISTPATH) / "nyafumi"
internal_dir = dist_dir / "_internal"

move(internal_dir / "ui", dist_dir)
move(internal_dir / "components", dist_dir)

for qml in internal_dir.glob("*.qml"):
    move(qml, dist_dir / qml.name)