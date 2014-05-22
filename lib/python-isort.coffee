process = require 'child_process'
byline = require 'byline'
# fs = require 'fs'

sortImports = ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?
    return unless editor.getGrammar().name == 'Python'

    filePath = editor.getPath()
    isortFile filePath, () ->

isortFile = (filePath) ->

    params = [filePath, "-vb"]
    isortpath = atom.config.get "python-isort.isortpath"

    proc = process.spawn isortpath, params

    output = byline(proc.stdout)
    output.on 'data', (line) =>
        console.log line.toString()

    output = byline(proc.stderr)
    output.on 'data', (line) =>
        console.log line.toString()

    proc.on 'exit', (exit_code, signal) ->
        # TODO

module.exports =
    configDefaults:
        isortpath: "/usr/bin/isort"
        runOnSave: true

    activate: (state) ->
        atom.workspaceView.command "python-isort:run", => @run()

        atom.config.observe 'python-isort.runOnSave', {callNow: true}, (value) ->
            if value == true
                atom.workspace.eachEditor (editor) ->
                    editor.buffer.on 'saved', sortImports
            else
                atom.workspace.eachEditor (editor) ->
                    editor.buffer.off 'saved', sortImports

    run: ->
        sortImports()
        @reload
