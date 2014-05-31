process = require 'child_process'
byline = require 'byline'
fs = require 'fs'

module.exports =
class PythonIsort

  checkForPythonContext: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?
    return unless editor.getGrammar().name == 'Python'
    return true

    editor = atom.workspace.getActiveEditor()
    filePath = editor.getPath()

    params = [filePath, "-c"]
    isortpath = atom.config.get "python-isort.isortpath"

    if not fs.existsSync(isortpath)
      # TODO: make this error visible in status line
      return

    proc = process.spawn isortpath, params

  sortImports: ->
    return unless @checkForPythonContext?
    editor = atom.workspace.getActiveEditor()
    filePath = editor.getPath()

    params = [filePath, "-vb"]
    isortpath = atom.config.get "python-isort.isortpath"

    if not fs.existsSync(isortpath)
      # TODO: make this error visible in status line
      return

    proc = process.spawn isortpath, params

    @reload
