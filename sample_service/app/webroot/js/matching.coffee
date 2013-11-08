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

  createResultView : (playerData, enemyData) ->
    $result = $('<div></div>').attr('id', 'battle-result')
    $playerResult = $('<div></div>').attr('id', 'player-result')
    $enemyResult = $('<div></div>').attr('id', 'enemy-result')

    _createResultView = ($parent, data) ->
      textClass = if data.win then 'text-success' else 'text-danger'
      $programName = $('<div></div>').attr('class', 'program-name ' + textClass).text(data.programName)
      $hp = $('<div></div>').attr('class', 'result-text remaining-hp ' + textClass).text(data.remainingHp)
      $energy = $('<div></div>').attr('class', 'result-text comsumed-energy ' + textClass).text(data.consumedEnergy)
      $score = $('<div></div>').attr('class', 'result-text score ' + textClass).text(data.score)

      $parent.append($programName)
      $parent.append($hp)
      $parent.append($energy)
      $parent.append($score)

    $label = $('<div></div>').attr('class', 'result-label')
    $labelProgramName = $('<div></div>').attr('class', 'result-text result-label-pname').text('')
    $labelHp = $('<div></div>').attr('class', 'result-text result-label-hp').text('残りHP')
    $labelEnergy = $('<div></div>').attr('class', 'result-text result-label-energy').text('消費エネルギー')
    $labelScore = $('<div></div>').attr('class', 'result-text result-label-score').text('スコア')
    $label.append($labelProgramName)
    $label.append($labelHp)
    $label.append($labelEnergy)
    $label.append($labelScore)

    _createResultView($playerResult, playerData)
    _createResultView($enemyResult, enemyData)

    $result.append($playerResult);
    $result.append($label);
    $result.append($enemyResult);

    $result

  showResult : (result) ->
    playerData = {
      userName: "user name",
      programName: "program name",
      remainingHp: 10,
      consumedEnergy: 100,
      score: 1234,
      win: true
    }

    enemyData = {
      userName: "user name",
      programName: "program name",
      remainingHp: 10,
      consumedEnergy: 100,
      score: 1234,
      win:false 
    }

    $result = @createResultView(playerData, enemyData) # $('<div></div>').attr('id', 'battle-result')
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
