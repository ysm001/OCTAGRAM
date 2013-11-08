class GameLog
  constructor: ()->
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



$ -> new GameLog
