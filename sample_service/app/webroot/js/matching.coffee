class Mathing 
  constructor: (@playerId, @enemyId) ->

  start : () ->
    editPlayerProgram()
    loadProgramById(@playerId, () ->
      editEnemyProgram()
      loadProgramById(@enemyId, () ->
        executeProgram()
        editPlayerProgram()
      )
    )

  end : (result) ->
    target = getRequestURL('statistics', 'push_result')
    isPlayerWin = result.win instanceof PlayerRobot 

    playerResult = {
      damage : 0,
      damaged: 0,
      win: +isPlayerWin,
      program_id: @playerId
    }

    enemyResult = {
      damage : 0,
      damaged: 0,
      win: +(!isPlayerWin),
      program_id: @enemyId
    }

    $.post(target, playerResult, (response) -> console.log(response))
    $.post(target, enemyResult, (response) -> console.log(response))

$ ->
  mathing = new Mathing(playerId, enemyId)

  Config.Frame.setGameSpeed(4)
  options = { 
    onload:  ()->mathing.start()
    onend: (result) -> mathing.end(result)
  }

  runGame(options);
