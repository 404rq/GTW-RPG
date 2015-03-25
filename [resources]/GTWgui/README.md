Applies custom font styles and create CE GUI windows with a custom style, NOTE that this has to be loaded before any resource calling it's functions, resources who use this GUI system must also be reloaded whenever this resource is reloaded (after this). NOTE2 other solutions to include nice looking GUI's are being worked on which will make this resource unused in the future.

## Functions available

`element window = createWindow(float x, float y, float width, float height, string text, bool relative)`  
_(client) Create a CE GUI window with custom background based on an image and returns it._

`setDefaultFont(element guiElement, float fontSize)`  
_(client) Apply a new font at given size to any element._

## Exported functions

`element window = createWindow(float x, float y, float width, float height, string text, bool relative)`  
_(client) Create a CE GUI window with custom background based on an image and returns it._

`setDefaultFont(element guiElement, float fontSize)`  
_(client) Apply a new font at given size to any element._

## Requirements

GTWtopbar
