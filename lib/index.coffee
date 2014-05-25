PythonIsort = require './python-isort'
pi = new PythonIsort()

module.exports =
  configDefaults:
    isortpath: "/usr/bin/isort"
    sortOnSave: false

  activate: (state) ->
    atom.workspaceView.command 'python-isort:sortImports', ->
      pi.sortImports()

    atom.workspaceView.command 'python-isort:checkImports', ->
      pi.checkImports()

    atom.config.observe 'python-isort.sortOnSave', {callNow: true}, (value) ->
      if value?
        atom.workspace.eachEditor (editor) ->
          editor.buffer.on "saved", ->
            pi.sortImports()
      else
        atom.workspace.eachEditor (editor) ->
          editor.buffer.off "saved", ->
            pi.sortImports()
