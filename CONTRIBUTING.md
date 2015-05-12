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
http://forum.gtw-games.org/bug-reports/


## Pull request
This is the method used by non official developers allowing anyone who want to contribute to GTW-RPG, the process
is described in below list and used to preview changes before they are added into the official game mode. Here's 
how you do it:
* Fork the project, click the "Fork" button in the upper right corner.
* Do the changes you want to your copy of GTW-RPG
* Make a pull request: https://github.com/GTWCode/GTW-RPG/pulls
* Watch (and join) the discussion :+1:

And that's it, contributing shouldn't be harder than that, right.

### Branch organization
GTW-RPG has two branches currently, master and development. Master is basically for finished and tested code ready to release while development can be used for beta features, testing, and features that isn't fully finished yet but still interesting enough to include.


## Guidelines & coding standards
More information comes soon, until then we suggest you follow below list of requirements for our definition of clean code:
* Indentation, indentation applies to every keyword that requires an "end" if more than 1 line are used. For example `function` or `if, else`, functions in functions etc.
* Comments, a multiline comment is standard above functions to describe shorty their purpose `--[[ This function does a, b, c etc.. ]]--`, within the code it will be sufficient with single line comments `-- Like this one`. Use one new line above every comment and split it up into blocks with a few lines to make it easy to read, comments are not always required but as long they are helpful they should be there.
* Header, all files should have a header at the top with information about authors, the GTW-RPG project, links to our websites as well as this page. Check the current files to get this block of information.
* Optimize! any code that uses to much system resources is bad code. To save memory, make sure objects are cleaned up and data related to specific players are removed/saved and then removed when the player leaves. Don't add to much objects unless it's needed, for instance a real example would be GTWtrain with ~500 nodes, adding a marker on all these locations would require lot's of memory. 
* Don't waste CPU performance, same reasons as above. High CPU usage could cause lag as the FPS won't be able to stay at 60, even older PC's must be able to play at 60 FPS and this isn't hard to accomplish as the game itself is very optimized in the beginning.
