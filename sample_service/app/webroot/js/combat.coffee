window.onload = () ->
  selector = new ProgramSelector()

  moveToBattlePage = (playerId, enemyId) ->
    location.href = getRoot() + "combats/matching/" + playerId + "/" + enemyId

  $('.btn-battle').click(() -> selector.modal(
    buttons: [{
      type: "success",
      text: "Select",
      handler: (id) => moveToBattlePage(id, $(@).attr('program-id'))
    }]
  ))
