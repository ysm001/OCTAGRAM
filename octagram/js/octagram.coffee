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
        program = @core.octagrams.createInstance()
        @core.octagrams.show(program.id)
        @onload()

  copyObjectToLocal : (local) ->
    for key, value of local.parent.octagram
      console.log(key)
      if (key != 'Octagram' && key != 'Cpu' && key != 'Resource' && key != 'OctagramCore' && 'OctagramContent' && 'OctagramContentSet') then local[key] = value
    
  onload : () ->

octagram.Octagram = Octagram
