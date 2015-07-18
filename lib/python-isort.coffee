$ = require 'jquery'
process = require 'child_process'

module.exports =
class PythonIsort

  checkForPythonContext: ->
    editor = atom.workspace.getActiveTextEditor()
    if not editor?
      return false
    return editor.getGrammar().name == 'Python'

  removeStatusbarItem: =>
    @statusBarTile?.destroy()
    @statusBarTile = null

  updateStatusbarText: (message, isError) =>
    if not @statusBarTile
      statusBar = document.querySelector("status-bar")
      return unless statusBar?
      @statusBarTile = statusBar
        .addLeftTile(
          item: $('<div id="status-bar-python-isort" class="inline-block">
                    <span style="font-weight: bold">Isort: </span>
                    <span id="python-isort-status-message"></span>
                  </div>'), priority: 100)

    statusBarElement = @statusBarTile.getItem()
      .find('#python-isort-status-message')

    if isError == true
      statusBarElement.addClass("text-error")
    else
      statusBarElement.removeClass("text-error")

    statusBarElement.text(message)

  getFilePath: ->
    editor = atom.workspace.getActiveTextEditor()
    return editor.getPath()

  sortImports: (options)->
    options ?= {}
    options.write_file ?= true

    if not @checkForPythonContext()
      return

    cmd = atom.config.get "python-isort.isortPath"
    params = [@getFilePath(), "-vb"]
    if not options.write_file
      params.push('-c')

    returnCode = process.spawnSync(cmd, params).status
    if returnCode != 0
      @updateStatusbarText("x", true)
      return
    else
      @updateStatusbarText("√", false)

    if options.write_file
      @reload
