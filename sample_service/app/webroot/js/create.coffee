programStorage = new ProgramStorage()

getPlayerProgram = () -> Game.instance.octagram.getInstance(Game.instance.currentScene.world.playerProgramId)
getEnemyProgram = () -> Game.instance.octagram.getInstance(Game.instance.currentScene.world.enemyProgramId)
getCurrentProgram = () -> Game.instance.octagram.getCurrentInstance()

showPlayerProgram = () -> Game.instance.octagram.showProgram(Game.instance.currentScene.world.playerProgramId)
showEnemyProgram = () -> Game.instance.octagram.showProgram(Game.instance.currentScene.world.enemyProgramId)

playerRunning = false
enemyRunning = false

resetProgram = (onReset) ->
  stopProgram()

  restart = () -> 
    if (!playerRunning && !enemyRunning) 
      Game.instance.currentScene.restart()
      if onReset then onReset()
    else setTimeout(restart, 100)

  setTimeout(restart, 100)

restartProgram = () ->
  resetProgram(() -> 
    console.log("aaaaaa")
    executeProgram())

editPlayerProgram = () ->
  $('#edit-player-program').hide()
  $('#edit-enemy-program').show()
  $('#program-container').css('border-color', '#5cb85c')

  showPlayerProgram()

editEnemyProgram = () ->
  $('#edit-player-program').show()
  $('#edit-enemy-program').hide()
  $('#program-container').css('border-color', '#d9534f')

  showEnemyProgram()

saveProgram = (override = false) -> programStorage.saveProgram(override)
loadProgram = () -> programStorage.loadProgram()
loadProgramById = (id, callback) -> programStorage.loadProgramById(id, callback)

getContentWindow = () -> $('iframe')[0].contentWindow

executeProgram = () ->
  playerRunning = true
  enemyRunning = true

  getPlayerProgram().execute({onStop: () -> playerRunning = false})
  getEnemyProgram().execute({onStop: () -> enemyRunning = false})

stopProgram = () ->
  getPlayerProgram().stop()
  getEnemyProgram().stop()


