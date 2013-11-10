class ColorConverter 
  constructor : (@colors) ->

  toColor : (val, min, max) ->
    dist = max - min
    step = dist / (@colors.length - 1)

    if (val < min) then val = min;
    if (val > max) then val = max;
    val -= min

    index = (s for s in [0...@colors.length] when step * s <= val && val <= step * (s+1))[0]

    @_toColor(val, step * index, step * (index+1), @colors[index], @colors[index + 1])

  _toColor : (val, min, max, from, to) ->
    graF = gra_hexcolor(from, to);
  
    if (val < min) then val = min;
    if (val > max) then val = max;
  
    normalized = (val - min) / (max - min );
  
    graF(normalized);

  rateToColor : (val) -> @toColor(val, 1400, 1700)
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

  colors = [
    '#5bc0de',
    '#428bca',
    '#5cb85c',
    '#f0ad4e',
    '#d9534f'
  ]
  converter = new ColorConverter(colors)

  ###
  # for debug
  for i in [0..1800]
    $d = $('<div></div>').css('background', converter.toColor(i, 1200, 1800)).css('width', '10px').css('height', '10px')
    $('body').append($d)
  ###

  $.each($('.rate'), () ->
    $(@).css('color', converter.rateToColor($(@).text()))
  )

  $.each($('.battle_num'), () ->
    $(@).css('color', converter.battleNumToColor($(@).text()))
  )

  $.each($('.score_average'), () ->
    $(@).css('color', converter.scoreToColor($(@).text()))
  )
