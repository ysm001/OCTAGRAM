class Octagram
  constructor : (path) ->
    @core = null

    $octagramContent = $('<iframe seamless></iframe>').attr('id', 'octagram-content')
                                                      .attr('src', path + '/content.html')
                                                      .attr('width', '640')
                                                      .attr('height', '640')

    $('#octagram').append($octagramContent)
    contentWindow = $octagramContent[0].contentWindow

    contentWindow.isContent = true

    contentWindow.onload = () =>
      #@copyObjectToLocal(contentWindow)

      @core = new contentWindow.OctagramCore(16, 16, 640, 640, "./resource/")
      @core.start()
      @core.onload = () => 
        scene = new contentWindow.Scene(@core)
        @core.pushScene(scene)
        #program = @core.octagrams.createInstance()
        #@core.octagrams.show(program.id)
        @onload()

  createProgramInstance : () -> @core.octagrams.createInstance()
  showProgram : (program) -> @core.octagrams.show(program)
  getInstance : (id) -> @core.octagrams.getInstance(id)

  copyObjectToLocal : (local) ->
    ignores = ['Resources', 'TipUtil']

    for key, value of local.parent.octagram
      if !(key in ignores)
        console.log('import : ' + key)
        local[key] = value
      else console.log('ignore : ' + key)

  copyAssetsToHost : (local) ->
    console.log(local.Game.instance.assets)
    for key, value of local.Game.instance.assets
      console.log('load asset :' + key)
      local.parent.Game.instance.assets[key] = value
    
  onload : () ->

octagram.Octagram = Octagram
