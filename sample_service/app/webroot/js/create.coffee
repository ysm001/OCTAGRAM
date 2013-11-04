programStorage = new ProgramStorage()

getPlayerProgram = () -> Game.instance.octagram.getInstance(Game.instance.currentScene.world.playerProgramId)
getEnemyProgram = () -> Game.instance.octagram.getInstance(Game.instance.currentScene.world.enemyProgramId)
getCurrentProgram = () -> Game.instance.octagram.getCurrentInstance()

showPlayerProgram = () -> Game.instance.octagram.showProgram(Game.instance.currentScene.world.playerProgramId)
showEnemyProgram = () -> Game.instance.octagram.showProgram(Game.instance.currentScene.world.enemyProgramId)

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

getContentWindow = () -> $('iframe')[0].contentWindow

executeProgram = () ->
  getPlayerProgram().execute()
  getEnemyProgram().execute()

stopProgram = () ->
  getPlayerProgram().stop()
  getEnemyProgram().stop()

