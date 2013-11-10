class ColorConverter 
  constructor : (@from = "#428bca", @to = "#b94a48") ->

  toColor : (val, min, max) ->
    graF = gra_hexcolor(@from, @to);
  
    if (val < min) then rate = min;
    if (val > max) then rate = max;
  
    normalized = (val - min) / (max - min );
  
    graF(normalized);

  rateToColor : (val) -> @toColor(val, 1200, 1800)
  battleNumToColor : (val) -> @toColor(val, 0, 180)
  scoreToColor : (val) -> @toColor(val, 0, 50000)

window.onload = () ->
  selector = new ProgramSelector()

  moveToBattlePage = (playerId, enemyId) ->
    location.href = getRoot() + "combats/matching/" + playerId + "/" + enemyId

  $('.program-row').click(() -> selector.modal(
    buttons: [{
      type: "success",
      text: "Select",
      handler: (data) => moveToBattlePage(data.id, $(@).attr('program-id'))
    }]
  ))

  converter = new ColorConverter("#428bca", "#b94a48")
  $.each($('.rate'), () ->
    $(@).css('color', converter.rateToColor($(@).text()))
  )

  $.each($('.battle_num'), () ->
    $(@).css('color', converter.battleNumToColor($(@).text()))
  )

  $.each($('.score_average'), () ->
    $(@).css('color', converter.scoreToColor($(@).text()))
  )
