window.onload = () ->
  core = new @OctagramCore(16, 16, 640, 640, "./resource/")
  core.start()
  core.onload = () => 
    scene = new Scene(core)
    core.pushScene(scene)
    program = core.octagrams.createInstance()
    core.octagrams.show(program.id)

  @octagram.core = core
  @octagram.onload()
