### Description
GTWgui, also known as Walrus GUI is an alternative to dx GUI's based on standard CE GUI elements, by 
using images any design could be applied to these GUI's without risk of loosing useful event's and 
functionality as well as saving valuable CPU resources for the clients, 

<br>
**Functions available**

None _not available yet._

<br>
**Exported functions**

`element window = createWindow(float x, float y, float width, float height, string text, bool relative)`  
_(client) Create a CE GUI window with custom background based on an image and returns it._

setDefaultFont(element guiElement, float fontSize)
_(client) Apply a new font at given size to any element._

<br>
**Requirements**

s_refresh.lua (server file), this is an included script that automatically refresh any resource using 
this resources GUI, run this if you restart GTWgui after calling it from another resource to prevent 
random controls from spawning at top left.
GTWtopbar<br>
