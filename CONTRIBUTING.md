# Contributions to GTW-RPG
Thanks for reading this, you have now taken the first step in the process of contributing to improve GTW-RPG :+1:

This document describe all the ways you can contribute without being an official developer of this project, 
you will also find a list of active contributors, guidelines in the coding, optimization, rules, tutorials etc..

## Issue report
As all large projects GTW-RPG will also suffer from potential bugs and issues, that's why it's important to be 
aware of them and then solve them, posting an issue report is a great way to let us know about an issue, another
way is to make a pull request (more info below) in where you solve the issue by yourself, the solution will be 
reviewed discussed and added if it fullyfy all requirements in coding guidelines, optimization and works as it 
should.

### Requirements
An issue report must fullify the following requirements:
* A semi technical (or technical) description of the bug with as many details as possible
* The exact process in how the bug can be triggered
* Analysis of potential consequenses and other potential triggers

You may also report bugs in our community forum:
https://discuss.404rq.com/t/issues


## Language support
Each resource should now have a language file, one for the server and one for the client _(s_lang.lua and c_lang.lua)_.
Within this files there's simply one big multidimensional table containing all text outputs translated into multiple 
languages, there's also a resource global definition at the top defining the resource language locally and if possible
globally by GTWcore. See GTWantispam for a live example of how languages should be implemented.


## Pull request
This is the method used by non official developers allowing anyone who want to contribute to GTW-RPG, the process
is described in below list and used to preview changes before they are added into the official game mode. Here's 
how you do it:
* Fork the project, click the "Fork" button in the upper right corner.
* Do the changes you want to your copy of GTW-RPG
* Make a pull request: https://github.com/404rq/GTW-RPG/pulls
* Watch (and join) the discussion :+1:

We recomend you to also describe your changes with a simple title followed by a more detailed description if needed
you may also use tags like update: new: misc: and similar. Please write them in lower case followed by a colon, followed 
by space and then the title, your description provides more freedom of writing though as long as it describes what 
changes you made and possibly why.

And that's it, contributing shouldn't be harder than so, right.

### Branch organization
GTW-RPG has two branches currently, master and development. Master is basically for finished and tested code ready to release while development can be used for beta features, testing, and features that isn't fully finished yet but still interesting enough to include.


## Guidelines & coding standards
More information comes soon, until then we suggest you follow below list of requirements for our definition of clean code:
* Indentation, we use tab for indentation with a width of 8 spaces, indentation applies to every keyword that requires an "end" if more than 1 line are used. For instance `function` or `if, else`, functions in other functions or multiline expressions.
* Comments, a multiline comment is standard above functions to describe their purpose shortly `--[[ This function does a, b, c etc.. ]]--`, within the code we use single line comments, even when multiple lines are used, `-- Like this one`. Use one new line above every comment and split it up into blocks with a few lines to make it easy to read, comments are not always required but as long they are helpful they should be there. Comments whitin functions can be "funny" and describe what's going on in the code in a more caual way.
* Header, all files should have a header at the top with information about authors, the GTW-RPG project, links to our websites as well as this page. It's under no circumstances allowed to modify these first 16 lines, except if you wish to add your own name to the list of contributors, that can only be done if you actually did contribute and should be done as a comma separated list with a ',' followed by a space ' '. Check the current files to get this block of information when creating a new file.
* Optimize! any code that uses to much system resources is bad code. To save memory, make sure that objects are cleaned up and data related to specific players are removed/saved and then removed when the player leaves. Don't add to much objects unless it's needed, for instance a real example would be GTWtrain with ~500 nodes, adding a marker on all these locations would require lot's of memory. _This is an actual issue which we resolved long ago_. 
* Don't waste CPU performance, for the same reasons as above. High CPU usage could cause lag as the FPS won't be able to stay at 60, even older PC's must be able to play at 60 FPS and this isn't hard to accomplish as the game itself is very optimized in the beginning. 


### Tips for optimization
* Use local variables as much as possible, local variables are defined by putting `local` in front of their names like: `local is_staff = nil`. Local variables are only accessible within the space they are defined in, if used at the top of a function they will be removed automatically as soon the function is done and reach `end`.
* Apply event handlers to individual objects or limited groups of objects instead of the root element where possible, a event-handler for root element will trigger on any element that causes the event and call it's function, let's take a bus stop for instance, if the function are supposed to pay the busdriver who stops by why should it care about cars or players running into the marker who's hitevent is assigned to the function? It's just a waste of system resources.
* Be careful with timers and the event "onClientRender", anything in that event will be executed up to 60 times/second, (depending on the servers FPS settings). Timers are executed often as well if they are assigned to do so, "onElementStreamIn" is also a dangerous event as it's triggered as soon an onject is loaded. Lest's assume you do some heavy calculations there, then suddently a player enter a nearby town where around 200 objects are loaded at the same time, then the code are executed 200 times which causes the FPS to drop seriously and the player will yell high about "lag".
* If something isn't needed, then don't implement it. This principle are also useful in security questions.
* Do not compile! sure compiling has it's advantages. Faster loading and harder to steal the source code from a specific server are a few good reasons. However, this is up to the users of GTW-RPG to decide wether they want to compile or not, in here we do not compile anything. _We don't pack anything as zip archives either unless it's a third party resource_.
* In loops, use `for v=1, #my_table do` where possible (indexed tables), as it's more efficient. For non indexed tables use `for k,v in pairs(my_table) do`, it's the second most efficient function. Try to avoid using `for k,v in ipairs(my_table) do` when `for v=1, #my_table do` can be used, as that method is faster. There are also sorting functions that can be executed during startup if you wish to handle a large amount of data.
