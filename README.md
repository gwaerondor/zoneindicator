# Zone Indicator
Shows a small text box with the zone name.

# Usage
* Position it by dragging it with the left mouse button.
* Resize it by using the scroll wheel.
* Hide it with the command `//zi hide` (or just unload the addon)
* Unhide it with the command `//zi show`
* Toggle debug printouts with `//zi debug`

# Additional config
The font color can be changed in the `data/settings.xml` file.

# Loading the addon
Place the addon in your Windower's addon directory, `//Windower/addons/`.
To load it automatically upon starting the game, put the following line in your
Windower's init script (which can be found in `//Windower/scripts/init.txt`):
```
lua load zoneindicator
```
Otherwise, you can type the same command manually.

# Credits
Inspired by ZoneName by sylandro, https://github.com/azamorapl/windower-lua/tree/personal/addons/zonename