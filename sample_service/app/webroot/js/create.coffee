getPlayerProgram = () -> Game.instance.octagram.getInstance(Game.instance.currentScene.world.playerProgramId)
getEnemyProgram = () -> Game.instance.octagram.getInstance(Game.instance.currentScene.world.enemyProgramId)
getCurrentProgram = () -> Game.instance.octagram.getCurrentInstance()

showPlayerProgram = () -> Game.instance.octagram.showProgram(Game.instance.currentScene.world.playerProgramId)
showEnemyProgram = () -> Game.instance.octagram.showProgram(Game.instance.currentScene.world.enemyProgramId)

editPlayerProgram = () ->
  $('#edit-player-program').hide()
  $('#edit-enemy-program').show()
  $('#program-container').css('border-color', '#5cb85c')

  showPlayerProgram()

editEnemyProgram = () ->
  $('#edit-player-program').show()
  $('#edit-enemy-program').hide()
  $('#program-container').css('border-color', '#d9534f')
  showEnemyProgram()


getContentWindow = () -> $('iframe')[0].contentWindow

executeProgram = () ->
  getPlayerProgram().execute()
  getEnemyProgram().execute()

stopProgram = () ->
  getPlayerProgram().stop()
  getEnemyProgram().stop()

saveProgram = (override = false) ->
  bootbox.prompt("Enter Program Name.", (name)  => 
    if name then saveProgramByName(name, override)
  )

saveProgramByName = (name, override = false) ->
  if (!name?) 
    console.log("error") 
  else 
    serializedVal = getCurrentProgram().serialize()

    program = {
      program:
        name: name,
        comment: "",
        serialized_data: serializedVal,
        user_id: getUserId(),
      override: override
    }

    $.post( "add", program, ( data) => 
      response = JSON.parse(data)

      if response.success
        bootbox.alert("program has been saved.")
      else if response.exists && !response.override
        bootbox.confirm(name + " is already exists. Do you want to override it?", (result) => 
          if result then saveProgramByName(name, true)
        ); 
      else
        bootbox.alert(data);
    );

loadProgram = () ->
  $table = $('<table></table>').attr('class', 'table table-striped table-hover')
  $body = $('<tbody></tbody>')
  $head = $('<thead></thead>').append(
    $('<tr></tr>')
      .append($('<th></th>').text(""))
      #.append($('<th></th>').text("Comment"))
      .append($('<th></th>').text(""))
  );

  onItemLoad = () -> 
    programId = $(@).attr('program-id')
    loadProgramById(programId)
    $modal.modal('hide')

  onItemDelete = () ->
    programId = $(@).attr('program-id')
    deleteProgramById(programId)
    $modal.modal('hide')

  $.get("owned_list", {user_id: getUserId()}, (data) -> 
    programs = JSON.parse(data)
    for program in programs
      $tr = $('<tr></tr>')

      $title = $('<td></td>').attr(class: 'loadtable-title').text(program.name)
      if ( program.is_preset ) 
        $label = $('<span style="margin-left: 10px"></span>').attr(class: 'label label-info').text("preset");
        $title.append($label)

      #$comment = $('<td></td>').attr(class: 'loadtable-title' ).text(program.comment)
      #$updated = $('<td></td>').attr(class: 'loadtable-btn' ).text(program.modified)

      $delete = $('<td></td>').attr(class: 'loadtable-btn')
        .append($('<button></button>').attr(class: "btn btn-success", 'program-id': program.id).text("Load").click(onItemLoad))
        .append($('<button style="margin-left:10px"></button>').attr(class: "btn btn-danger", 'program-id': program.id).text("Delete").click(onItemDelete))

      $tr.append($title)
      #$tr.append($comment)
      #$tr.append($updated)
      $tr.append($delete)
      $body.append($tr)
  )

  $table.append($head)
  $table.append($body)

  $modalBody = 
    $('<div></div>').attr('class', 'modal-body').append(
      $table
    )

  title = "Select Program"
  $modalHeader =
    $('<div></div>').attr('class', 'modal-header').append(
      $('<button></button>').attr({type: 'button', class: 'close', 'data-dismiss': 'modal'}).text('×')
    ).append(
      $('<h4></h4>').attr('class', 'modal-title').text(title)
    )

  $modal = 
    $('<div></div>').attr({class: 'modal fade', tabIndex: '-1', role: 'dialog'}).append(
      $('<div></div>').attr('class', 'modal-dialog').append(
        $('<div></div>').attr('class', 'modal-content').append(
          $modalHeader
        ).append(
          $modalBody
        )
      )
    )

  $modal.modal({
    keyboard: true,
    show: true
  })

loadProgramById = (id) ->
  $.get('load_data', {id: id},  (data) ->
    getCurrentProgram().deserialize(JSON.parse(data))
  )

deleteProgramById = (id) ->
  $.post('delete', {id: id},  (data) -> )
