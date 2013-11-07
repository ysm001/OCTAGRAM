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
    target = getRequestURL('battle_logs', 'save')
    isPlayerWin = result.win instanceof PlayerRobot 
    player = if isPlayerWin then result.win else result.lose
    enemy  = if !isPlayerWin then result.win else result.lose

    playerResult = {
      opponent_id: enemyId,
      is_winner: +isPlayerWin,
      program_id: @playerId,
      remaining_hp: player.hp,
      consumed_energy: player.consumptionEnergy
    }

    enemyResult = {
      opponent_id: playerId,
      is_winner: +!isPlayerWin,
      program_id: @enemyId,
      remaining_hp: enemy.hp,
      consumed_energy: enemy.consumptionEnergy
    }

    data = {
      challenger: playerResult,
      defender: enemyResult
    }

    $.post(target, data, (response) -> console.log(response))

$ ->
  mathing = new Mathing(playerId, enemyId)

  Config.Frame.setGameSpeed(4)
  options = { 
    onload:  ()->mathing.start()
    onend: (result) -> mathing.end(result)
  }

  runGame(options);
