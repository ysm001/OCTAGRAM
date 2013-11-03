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

savePlayerProgramOnServer = (override = false) ->
  bootbox.prompt("Enter Program Name.", (name)  => savePlayerProgramOnServerWithName(name, override))

savePlayerProgramOnServerWithName = (name, override = false) ->
  if (!name?) 
    console.log("error") 
  else 
    playerProgram = getPlayerProgram()
    serializedVal = playerProgram.serialize()

    program = {
      program:
        name: name,
        comment: "",
        serialized_data: serializedVal,
        user_id: getUserId(),
      override: override
    }

    console.log(program);
    $.post( "add", program, ( data) => 
      response = JSON.parse(data)

      if response.success
        bootbox.alert("program has been saved.")
      else if response.exists && !response.override
        bootbox.confirm(name + " is already exists. Do you want to override it?", (result) => 
          if result then savePlayerProgramOnServerWithName(name, true)
        ); 
      else
        bootbox.alert(data);
    );

