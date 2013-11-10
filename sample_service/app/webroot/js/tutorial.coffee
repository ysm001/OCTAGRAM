class TutorialPager
  constructor: (@pages) ->
    $modal = null
    @currentPage = 0
    @prevBtn = null
    @nextBtn = null
    @body = null
    @title = null

  show: () ->
    page = @pages[@currentPage]
    $modal = bootbox.dialog(
      message: page.content,
      title: page.title,
      buttons: 
        danger: 
          label: "前へ",
          className: "btn-danger",
          callback: () => 
            @showPrev()
            false
        success: 
          label: "次へ",
          className: "btn-success",
          id: 'btn-prev',
          callback: () =>
            @showNext()
            false
    )

    $buttons = $modal.find('.modal-footer').find('button')

    @prevBtn = $($buttons[0])
    @nextBtn = $($buttons[1])

    @body = $modal.find('.bootbox-body')
    @title = $modal.find('.modal-title')

    $modal.find('.modal-body').height('300px')

    @checkButtonVisibility()

  checkButtonVisibility: () ->
    @prevBtn.removeAttr('disabled')
    @nextBtn.removeAttr('disabled')

    if @currentPage == 0 then @prevBtn.attr('disabled', 'disabled')
    else if @currentPage == @pages.length - 1 then @nextBtn.attr('disabled', 'disabled')

  showPage: (page) ->
    @title.text(page.title)
    @body.html(page.content)

  showNext: () ->
    @showPage(@pages[++@currentPage])
    @checkButtonVisibility()

  showPrev: () ->
    @showPage(@pages[--@currentPage])
    @checkButtonVisibility()

class Tutorial
  constructor: () ->
    @pager = new TutorialPager(@makePages())

  show: () ->
    msg = 
      "<p>CodeCombatは、プログラミング言語OCTAGRAMで作ったゲームAIの強さを競わせるサービスです。</p>" + 
      "<p>最強のAIを作って、ランキング上位を目指そう！</p>" +
      "<p>まずは、チュートリアルを見てみましょう。</p>"

    bootbox.dialog(
      message: msg,
      title: "CodeCombatへようこそ！",
      buttons: 
        success: 
          label: "チュートリアルを見る",
          className: "btn-success",
          callback:  () => 
            @pager.show()
            @disableTutorial()
        danger: 
          label: "今後表示しない",
          className: "btn-danger",
          callback: () => @disableTutorial()
    )

  disableTutorial: () ->
    $.post(getRequestURL('users', 'disable_tutorial'), {id: getUserId()})

  makePages: () ->
    page1 = {
      title: 'チュートリアルへようこそ！',
      content: 
        '<p>ここでは、Code Combatの使い方の基本学びます。</p>'
    }

    page2 = {
      title: 'プログラムの作り方',
      content: 
        '<p>Code Combatでは、作成したゲームAI同士を競わせることによって、ランキング上位を目指します。</p>' +
        '<img src="' + getRoot() + 'app/webroot/img/top_icon_programming.png" width=80 height=80 class="tutorial-icon"/>' +
        '<p>プログラムは、画面上部のプログラミングアイコンをクリックすることにより作成できます。</p>'
    }

    page3 = {
      title: '対戦の仕方',
      content: 
        '<img src="' + getRoot() + 'app/webroot/img/top_icon_vs.png" width=80 height=80 class="tutorial-icon"/>' +
        '<p>作成したプログラムを、他ユーザと対戦させるには、画面上部の対戦アイコンをクリックします。</p>' +
        '<p>新着順で他ユーザの作成したプログラムが表示されるので、好きなプログラムを選んで対戦しましょう。</p>'
    }

    page4 = {
      title: 'ランキング',
      content: 
        '<p>ユーザ同士の対戦を行うと、結果に応じてレートが変動します。</p>' +
        '<p>レートはプログラムの強さを表しており、レートが高い程強いプログラムとなります。</p>' +
        '<p>ランキングでは、レートの高いプログラムが表示され、ランキング上のプログラムと自由に戦うことができます。</p>' +
        '<img src="' + getRoot() + 'app/webroot/img/top_icon_ranking.png" width=80 height=80 class="tutorial-icon"/>' +
        '<p>ランキングは、画面上部のランキングアイコンをクリックすることにより見ることができます。</p>'
    }

    page5 = {
      title: '対戦履歴',
      content: 
        '<p>ユーザ同士の対戦履歴が画面下部に表示されます。</p>' +
        '<p>ここからも、プログラムをクリックすることによって対戦を行うことができます。</p>'
    }

    page6 = {
      title: 'マイページ',
      content: 
        '<p>ナビゲーションバーの「Profile」をクリックすることにより、自分のマイページへ飛ぶことができます。</p>' +
        '<p>ここでは、自分の名前を変更したり、プログラムのレートやスコアの変動などの統計情報を見ることができます。</p>'
    }

    tutorialLink = $('#tutorial-link').attr('href')
    gameRuleLink = $('#gamerule-link').attr('href')
    page6 = {
      title: 'ドキュメント',
      content: 
        '<p>ナビゲーションバーの「Document」から、プログラムの組み方のチュートリアルやゲームルールをなどを確認することができます。</p>' +
        '<p>Code Combatのチュートリアルは以上です。頑張って最強のAIを作りましょう！</p>' +
        '<p>このチュートリアルは、ナビゲーションバーの「Tutorial」をクリックすることで、いつでも確認できます。</p>' +
        '<div class="tutorial-btns">' + 
        '<div class="tutorial-btns-container">' + 
        '<div class="learn-program-btn"> <a href="' + tutorialLink + '" class="btn btn-success btn-lg">' + 'プログラムの組み方を学ぶ' + '</a></div>'  +
        '<div class="learn-game-btn"> <a href="' + gameRuleLink + '" class="btn btn-primary btn-lg">' + 'ゲームのルールを学ぶ' + '</a></div>' +
        '</div>' +
        '</div>'
    }



    [page1, page2, page3, page4, page5, page6]



