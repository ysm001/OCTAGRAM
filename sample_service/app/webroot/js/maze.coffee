getHash = () -> if window.location.hash.length > 0 then parseInt(window.location.hash.replace('#', '')) else 1

class MazeResultViewer
  constructor: () ->
    @frontend = new Frontend()
    @$result = null
    @desiredTipCount = [3, 1, 4, 3, 5]

  end : (result) -> 
    $('#stop').attr('disabled', 'disabled')
    $('.question-number').attr('disabled', 'disabled')
    @disableInput()
    @showResult(result)

  createResultView : (playerCount, desiredCount) ->
    $result = $('<div></div>').attr('id', 'battle-result')
    $playerResult = $('<div></div>').attr('id', 'player-result')
    $enemyResult = $('<div></div>').attr('id', 'enemy-result')

    _createResultView = ($parent) =>
      cls = if playerCount > desiredCount then 'text-danger' else 'text-success'
      $clearText = $('<div></div>').attr('class', 'result-text clear text-success').text('クリア！')
      $playerCountText = $('<div></div>').attr('class', 'result-text player-count ' + cls).text('利用したチップ数: ' + playerCount)
      $desiredCountText = $('<div></div>').attr('class', 'result-text desired-count text-primary').text('目標のチップ数: ' + desiredCount)
      $warnCountText = $('<div></div>').attr('class', 'result-text warn-text text-warning').text('チップ数には動作命令と分岐命令のみ含まれます。')
      $parent.append($clearText)
      $parent.append($desiredCountText)
      $parent.append($playerCountText)
      $parent.append($warnCountText)

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

  showResult : (count) ->
    @$result = @createResultView(count.action + count.branch, @desiredTipCount[getHash()])
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
