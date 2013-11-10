window.onload = () ->
  selector = new ProgramSelector()

  moveToBattlePage = (playerId, enemyId) ->
    location.href = getRoot() + "combats/matching/" + playerId + "/" + enemyId

  $('.program-row').click(() -> selector.modal(
    buttons: [{
      type: "success",
      text: "Select",
      handler: (data) => moveToBattlePage(data.id, $(@).attr('program-id'))
    }]
  ))
