class Mathing 
  start : (playerId, enemyId) ->
    editPlayerProgram()
    loadProgramById(playerId, () ->
      editEnemyProgram()
      loadProgramById(enemyId, () ->
        executeProgram()
        editPlayerProgram()
      )
    )


$ ->
  mathing = new Mathing()

  Config.Frame.setGameSpeed(4)
  options = { 
    onload:  ()->mathing.start(playerId, enemyId);
    onend: (result) -> console.log(result)
  }

  runGame(options);
