# plasma-applet-popup-launcher

Plasma 5 custom application launcher that opens a popup when placed in a panel

![Screen shot of plasma-applet-popup-launcher](popup-launcher.png)

Dependencies:

* plasma-addons

## Installation

### From openDesktop.org

1. Go to [https://www.opendesktop.org/p/1084934/](https://www.opendesktop.org/p/1084934/)
2. Click on the `Files` tab
3. Click the `Install` button

### From within the Plasma workspace

1. If your widgets are locked, right-click the desktop and select `Unlock Widgets`
2. Right-click the desktop and select `Add Widgets...`
3. Click the `Get new widgets` button in the Widget Explorer that just opened
4. Type `Popup Launcher` into the search field
5. Click the `Install` button next to "Popup Launcher"

### From source

```sh
git clone https://github.com/dfaust/plasma-applet-popup-launcher
cd plasma-applet-popup-launcher
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install
```

Dependencies:

* plasma-framework-devel
