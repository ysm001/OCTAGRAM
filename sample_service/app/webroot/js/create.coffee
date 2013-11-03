getPlayerProgram = () -> Game.instance.octagram.getInstance(Game.instance.currentScene.world.playerProgramId)
getEnemyProgram = () -> Game.instance.octagram.getInstance(Game.instance.currentScene.world.enemyProgramId)

executePlayerProgram = () -> getPlayerProgram().execute()
executeEnemyProgram = () -> getEnemyProgram().execute()

savePlayerProgram = () -> getPlayerProgram().save("player")
saveEnemyProgram = () -> getEnemyProgram().save("enemy")

loadPlayerProgram = () -> getPlayerProgram().load("player")
loadEnemyProgram = () -> getEnemyProgram().load("enemy")

showPlayerProgram = () -> Game.instance.octagram.showProgram(Game.instance.currentScene.world.playerProgramId)

showEnemyProgram = () -> Game.instance.octagram.showProgram(Game.instance.currentScene.world.enemyProgramId)

getContentWindow = () -> $('iframe')[0].contentWindow

savePlayerProgramOnServer = () ->
  bootbox.prompt("Enter Program Name.", (result)  =>
    if (!result?) console.log("error") 
    else 
      serializedVal = playerProgram.serialize()
      console.log(result)
  )