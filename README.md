SMStackMenu
===========

Expanding stack menu that extends from ECSlidingViewController for iOS

This is an expanding and collapsing menu that works along side ECSlidingViewController. The intention of this was
to create an expandable menu that was easy to implement, understand, and extend/customize to fit your needs.

ECSlidingViewController - A popular setup to create a sliding menu from the side. It is included in this repo, but
to understand more about it, feel free to visit that github documentation (there are also many videos online, and 
I show it in my example project).

SMStackMenu - This is the Menu that controls the UITableViewController used for ECSlidingViewController. Using
this menu will allow you to create an expanding menu (up to 1 submenu deep). This menu is completely customizable 
to fit your needs, while still doing most of the work for you without needing to read and implement source code.

In the sample project, I have included the bare minimum example on how you could use this menu and how it works.
Read through the SMMenuViewController, SMInitViewController, and SMParentViewController code to see how each
should be set up, as well as glancing at the storyboard.
