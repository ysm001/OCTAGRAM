getPlayerProgram = () -> Game.instance.octagrams.getInstance(Game.instance.currentScene.world.playerProgramId)
getEnemyProgram = () -> Game.instance.octagrams.getInstance(Game.instance.currentScene.world.enemyProgramId)

executePlayerProgram = () -> getPlayerProgram().execute()
executeEnemyProgram = () -> getEnemyProgram().execute()

savePlayerProgram = () -> getPlayerProgram().save("player")
saveEnemyProgram = () -> getEnemyProgram().save("enemy")

loadPlayerProgram = () -> getPlayerProgram().load("player")
loadEnemyProgram = () -> getEnemyProgram().load("enemy")

showPlayerProgram = () -> Game.instance.octagrams.show(Game.instance.currentScene.world.playerProgramId)
showEnemyProgram = () -> Game.instance.octagrams.show(Game.instance.currentScene.world.enemyProgramId)

test = () ->
  playerProgram = Game.instance.currentScene.world.playerProgram
  enemyProgram = Game.instance.currentScene.world.enemyProgram
  playerProgram.load("test")
  enemyProgram.load("test")

  playerProgram.execute();
  enemyProgram.execute();
