class ScreenLoader
  @show: () ->
    $("#overlay").append('<div id="loader-screen"><img class="loader" src="' + getRoot() + 'img/screen-loader.gif"</div>')
    $('#overlay').show().fadeTo('slow', 0.8)
  @cancel: () ->
    $("#overlay").empty()
    $('#overlay').fadeTo 'fast', 0, () ->
      $(@).hide()


