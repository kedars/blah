# blah
Non-Recursive Makefile Build System

Always wondered how the hell does the non-recursive Makefile system works. Here is a quick version for future reference. Needs much more work for taking to production.

* Basically, all subdirectories are included from the top Makefile
* post-subdir.mk sanitizes the variables and collects into its own variables that start with 'b-' prefix
* blah.mk provides centralized support for building objects, archives and programs
