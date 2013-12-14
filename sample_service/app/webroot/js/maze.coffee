class MazeResultViewer
  constructor: () ->
    @frontend = new Frontend()
    @$result = null

  end : (result) -> 
    $('#stop').attr('disabled', 'disabled')
    $('.question-number').attr('disabled', 'disabled')
    @disableInput()
    @showResult()

  createResultView : () ->
    $result = $('<div></div>').attr('id', 'battle-result')
    $playerResult = $('<div></div>').attr('id', 'player-result')
    $enemyResult = $('<div></div>').attr('id', 'enemy-result')

    _createResultView = ($parent) ->
      $text = $('<div></div>').attr('class', 'result-text clear text-success').text('クリア！')
      $parent.append($text)

    _createResultView($result)
    $label = $('<div></div>').attr('class', 'result-label')
    $result.append(@createResultButton())

    $result

  retry: () =>
    $('#battle-result').fadeOut('fast', () =>
      $('#battle-result').remove()
      $('#enchant-stage').fadeIn('fast', () =>
        $('#filter').remove()
        @hideResult()
        $('#stop').click()
        $('.question-number').removeAttr('disabled')
      )
    )

  createResultButton : () ->
    page = if window.location.hash.length > 0 then parseInt(window.location.hash.replace('#', '')) else 1

    $backButton = $('<a></a>').attr({id: 'back-btn', class: 'btn btn-lg btn-danger result-btn'}).text('Back')
    $retryButton = $('<div></div>').attr({id: 'retry-btn', class: 'btn btn-lg btn-primary result-btn'}).text('Retry').click(@retry)
    $nextButton = $('<a></a>').attr({id: 'next-btn', class: 'btn btn-lg btn-success result-btn'}).text('Next')

    $backButton.click(() => 
      window.location.href = window.location.pathname + '#' + (page - 1)
      @retry()
    )

    $nextButton.click(() => 
      window.location.href = window.location.pathname + '#' + (page + 1)
      @retry()
    )


    $buttons = $('<div></div>').attr('class', 'result-btns')

    console.log page
    $buttons.append($backButton) if page > 1
    $buttons.append($retryButton)
    $buttons.append($nextButton) if page < 5

    $buttons

  showResult : () ->
    @$result = @createResultView()
    $('#enchant-stage').fadeOut('fast', () => 
      $(@).remove()
      $('#program-container').append(@$result)
    )

  hideResult : () ->
    if @$result?
      @$result.remove()
      @$result = null

  disableInput : () ->
    $filter = $('<div></div>').attr('id', 'filter')
    $('#program-container').append($filter)

$ ->
  page = if window.location.hash.length > 0 then parseInt(window.location.hash.replace('#', '')) else 1
  $('.question-number').click(() -> window.location.href = window.location.pathname + '#' + $(@).text())
  $('.question-number').removeAttr('disabled')

  highlitePagerButton = (num) ->
    $pager = $('.question-number')

    for btn,i in $pager
      $btn = $(btn)
      $btn.removeClass('btn-default')
      $btn.removeClass('btn-primary')
      $btn.removeAttr('disabled')

      if i == (num - 1) 
        $btn.addClass('btn-primary')
        $btn.attr('disabled', 'disabled')
      else $btn.addClass('btn-default')

  highlitePagerButton(page)
  tm.HashObserver.enable()

  document.addEventListener("changehash", (e) -> 
    $('#filter').remove()
    highlitePagerButton(e.hash.replace('#', ''))
  )
