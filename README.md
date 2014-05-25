# Python Isort for Atom editor

Uses [Isort](https://github.com/timothycrosley/isort) to organizing Python imports.

## Install

Make sure you have `Isort` installed and the correct path to binary was set in the package config.

### Keymap

Currently, there are two following commands:

* `python-isort:sortImports` - for sorting imports
* `python-isort:checkImports` - for checking imports

## Limitations/ToDo

* `checkImports` does not work when "sortOnSave" is enabled
* no error handling
