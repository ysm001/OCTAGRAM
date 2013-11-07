class Mathing 
  constructor: (@playerId, @enemyId) ->

  start : () ->
    @disableInput()

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

    @showResult()
    $.post(
      target, data, (response) -> 
        if ( response == "true" ) 
          Flash.showSuccess("result has been saved.") 
        else 
          Flash.showError("error")
    )

  createResultView : () ->

  showResult : () ->
    $result = $('<div></div>').attr('id', 'battle-result')
    $('#enchant-stage').fadeOut('fast', () => 
      $(@).remove()
      $('#program-container').append($result)
    )

  disableInput : () ->
    $filter = $('<div></div>').attr('id', 'filter')
    $('#program-container').append($filter)

$ ->
  mathing = new Mathing(playerId, enemyId)

  Config.Frame.setGameSpeed(4)
  options = { 
    onload:  ()->mathing.start()
    onend: (result) -> mathing.end(result)
  }

  runGame(options);
