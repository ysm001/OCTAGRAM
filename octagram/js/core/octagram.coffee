class Octagram
  constructor : (path) ->
    @core = null

    $octagramContent = $('<iframe seamless></iframe>').attr({id: 'octagram-content',src: path + '/content.html'})
                                                      .css({width: '640px', height: '640px'})

    $target = $('#octagram')
    $target.css({width: '640px', height: '640px'})
    $target.append($octagramContent)
    contentWindow = $octagramContent[0].contentWindow

    contentWindow.isContent = true

    contentWindow.onload = () =>
      @core = new contentWindow.OctagramCore(16, 16, 640, 640, "./resource/")
      @core.start()
      @core.onload = () => 
        scene = new contentWindow.Scene(@core)
        @core.pushScene(scene)
        @onload()

  createProgramInstance : () -> @core.octagrams.createInstance()
  showProgram : (program) -> @core.octagrams.show(program)
  getInstance : (id) -> @core.octagrams.getInstance(id)
  getCurrentInstance : () -> @core.octagrams.getCurrentInstance()
   
  onload : () ->

octagram.Octagram = Octagram
