fs = require 'fs'
jquery = require('atom').$
process = require 'child_process'

module.exports =
class PythonIsort

  checkForPythonContext: ->
    editor = atom.workspace.getActiveEditor()
    return editor.getGrammar().name == 'Python'


  updateStatusbarText: (message, isError) ->
    if jquery("#python-isort-status").length == 0
      statusBar = atom.workspaceView.statusBar
      return unless statusBar?
      statusBar.appendLeft('<div id="python-isort-status" class="inline-block">
                              <span style="font-weight: bold">Isort: </span>
                              <span id="python-isort-status-message"></span>
                            </div>')

    statusBarElement = jquery("#python-isort-status-message")

    if isError == true
      statusBarElement.addClass("text-error")
    else
      statusBarElement.removeClass("text-error")

    statusBarElement.text(message)

  getFilePath: ->
    editor = atom.workspace.getActiveEditor()
    return editor.getPath()

    isortpath = atom.config.get "python-isort.isortpath"
    params = [@getFilePath(), "-c", "-vb"]

    if not fs.existsSync(isortpath)
      @updateStatusbarText("unable to open " + isortpath, false)
      return

    proc = process.spawn isortpath, params

    updateStatusbarText = @updateStatusbarText
    proc.on 'exit', (exit_code, signal) ->
      if exit_code == 0
        updateStatusbarText("√ all python imports are fine", false)
      else
        updateStatusbarText("python imports are unsorted", true)

  sortImports: ->
    if not @checkForPythonContext
      return

    params = [@getFilePath(), "-vb"]
    isortpath = atom.config.get "python-isort.isortpath"

    if not fs.existsSync(isortpath)
      @updateStatusbarText("unable to open " + isortpath, false)
      return

    proc = process.spawn isortpath, params
    @updateStatusbarText("√ all python imports are fine", false)
    @reload
