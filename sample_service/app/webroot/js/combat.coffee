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

  colors = [
    '#aaaaaa',
    '#5cb85c',
    '#428bca',
    '#f0ad4e',
    '#d9534f'
  ]

  converter = new ColorConverter(colors)

  $.each($('.rate'), () ->
    $(@).css('color', converter.rateToColor($(@).text()))
  )

  $.each($('.battle_num'), () ->
    $(@).css('color', converter.battleNumToColor($(@).text()))
  )

  $.each($('.score_average'), () ->
    $(@).css('color', converter.scoreToColor($(@).text()))
  )
