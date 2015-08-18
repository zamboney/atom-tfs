TfsView = require './tfs-view'
{CompositeDisposable} = require 'atom'
tfs =  require 'tfs-unlock'
module.exports = Tfs =
  tfsView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    console.log(state)
    @source.bit64.vs2013()
    @tfsView = new TfsView(state.tfsViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @tfsView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-text-editor', 'tfs:checkout': => @checkout()
    @subscriptions.add atom.commands.add 'atom-text-editor', 'tfs:undo': => @undo()


  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @tfsView.destroy()

  serialize: ->
    tfsViewState: @tfsView.serialize()

  checkout: ->
    @modalPanel.show()
    self = @
    tfs.checkout([atom.workspace.getActivePaneItem().buffer.file.path]).then ->
        console.log "checkout"
        self.modalPanel.hide()
      ,
        (data)->
          self.modalPanel.hide()
          console.log(data)
  undo: ->
    @modalPanel.show()
    self = @
    tfs.undo([atom.workspace.getActivePaneItem().buffer.file.path]).then ->
        self.modalPanel.hide()
      ,
        (data)->
          self.modalPanel.hide()
          console.log(data)
  source:
    bit32 :
      vs2008: ->
        tfs.init({
          "visualStudioPath": tfs.vs2008.bit32
          });
      vs2010: ->
        tfs.init({
          "visualStudioPath": tfs.vs2010.bit32
          });
      vs2012: ->
        tfs.init({
          "visualStudioPath": tfs.vs2012.bit32
          });
      vs2015: ->
        tfs.init({
          "visualStudioPath": tfs.vs2015.bit32
          });
      vs2013: ->
        tfs.init({
          "visualStudioPath": tfs.vs2013.bit32
          });
    bit64 :
      vs2008: ->
        tfs.init({
          "visualStudioPath": tfs.vs2008.bit64
          });
      vs2010: ->
        tfs.init({
          "visualStudioPath": tfs.vs2010.bit64
          });
      vs2012: ->
        tfs.init({
          "visualStudioPath": tfs.vs2012.bit64
          });
      vs2013: ->
        tfs.init({
          "visualStudioPath": tfs.vs2013.bit64
          });
      vs2015: ->
        tfs.init({
          "visualStudioPath": tfs.vs2015.bit64
          });
