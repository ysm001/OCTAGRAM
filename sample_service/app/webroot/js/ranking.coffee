window.onload = () ->
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
