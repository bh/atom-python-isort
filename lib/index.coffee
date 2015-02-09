PythonIsort = require './python-isort'

module.exports =
  configDefaults:
    isortPath: "isort"
    sortOnSave: false
    checkOnSave: true

  activate: ->
    pi = new PythonIsort()

    atom.commands.add 'atom-workspace', 'pane:active-item-changed', ->
      pi.removeStatusbarItem()

    atom.commands.add 'atom-workspace', 'python-isort:sortImports', ->
      pi.sortImports()

    atom.commands.add 'atom-workspace', 'python-isort:checkImports', ->
      pi.checkImports()

    atom.config.observe 'python-isort.sortOnSave', {callNow: true}, (value) ->
      atom.workspace.eachEditor (editor) ->
        if value == true
          editor.buffer.on "saved", ->
            pi.sortImports()
        else
          editor.buffer.off "saved", ->
            pi.sortImports()

    atom.config.observe 'python-isort.checkOnSave', {callNow: true}, (value) ->
      atom.workspace.eachEditor (editor) ->
        if value == true
          editor.buffer.on "saved", ->
            pi.checkImports()
        else
          editor.buffer.off "saved", ->
            pi.checkImports()
