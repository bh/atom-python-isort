PythonIsort = require './python-isort'

module.exports =
  configDefaults:
    isortpath: "/usr/bin/isort"
    sortOnSave: false
    checkOnSave: true

  activate: (state) ->
    pi = new PythonIsort()
    atom.workspaceView.command 'python-isort:sortImports', ->
      pi.sortImports()

    atom.workspaceView.command 'python-isort:checkImports', ->
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
            pi.checkForUnsortedImports()
        else
          editor.buffer.off "saved", ->
            pi.checkForUnsortedImports()
