class GameLog
  constructor: () ->
    selector = new ProgramSelector()

    moveToBattlePage = (playerId, enemyId) ->
      location.href = getRoot() + "combats/matching/" + playerId + "/" + enemyId

    callback = () ->
      userId = getUserId()
      if userId == parseInt($(@).attr('user-id'))
        bootbox.alert("自分のプログラムとは対戦できません")
        return
      name = $(".program-name", @).text()
      selector.modal
        title: "#{name}と対戦するプログラムを選んで下さい"
        buttons: [{
          type: "success",
          text: "選択",
          handler: (id) => moveToBattlePage(id, $(@).attr('program-id'))
        }]
    $('.battle-log-challenger').click(callback)
    $('.battle-log-defender').click(callback)

class Tutorial
  constructor: () ->

  start: () ->
    msg = 
      "<p>CodeCombatでは、プログラミング言語OCTAGRAMを使って作成したAIをユーザ同士で戦わせます。</p>" + 
      "<p>最強のAIを作って、ランキング上位を目指そう！</p>" +
      "<p>まずは、チュートリアルを見てみましょう。</p>"

    bootbox.dialog(
      message: msg,
      title: "CodeCombatへようこそ！",
      buttons: 
        success: 
          label: "チュートリアルを見る",
          className: "btn-success",
          callback:  () ->,
        danger: 
          label: "今後表示しない",
          className: "btn-danger",
          callback: () -> ,
    )

  disableTutorial: () ->

$ -> 
  new GameLog

  if ( tutorialEnabled ) 
    tutorial = new Tutorial()
    tutorial.start()
