class ColorConverter 
  constructor : (@colors) ->

  toGradation : (val, min, max) ->
    result = @_getIndex(val, min, max)

    index = result.index
    step = result.step

    @_toColor(val, min + step * index, min + step * (index+1), @colors[index], @colors[index + 1])

  toColor : (val, min, max) ->
    result = @_getIndex(val, min, max)

    @colors[result.index]

  _getIndex : (val, min, max, grad=false) ->
    dist = max - min
    step = dist / (@colors.length + (if grad then 1 else 0))

    if (val < min) then val = min;
    if (val > max) then val = max;
    val -= min

    index = (s for s in [0...@colors.length] when step * s <= val && val <= step * (s+1))[0]
    {index: index, step: step}

  _toColor : (val, min, max, from, to) ->
    graF = gra_hexcolor(from, to);
  
    if (val < min) then val = min;
    if (val > max) then val = max;
  
    normalized = (val - min) / (max - min );
  
    graF(normalized);

  rateToColor : (val) -> @toColor(val, 1300, 1800)
  battleNumToColor : (val) -> @toColor(val, 0, 100)
  scoreToColor : (val) -> @toColor(val, 0, 50000)

window.onload = () ->
  selector = new ProgramSelector()

  moveToBattlePage = (playerId, enemyId) ->
    location.href = getRoot() + "combats/matching/" + playerId + "/" + enemyId

  $('.program-row').click(() -> 
    name = $(@).find('.program-name').text().replace(/^\s+|\s+$/g, "")

    selector.modal(
      title: name + "と対戦するプログラムを選んで下さい。", 
      buttons: [{
        type: "success",
        text: "Select",
        handler: (data) => moveToBattlePage(data.id, $(@).attr('program-id'))
      }]
    )
  )

