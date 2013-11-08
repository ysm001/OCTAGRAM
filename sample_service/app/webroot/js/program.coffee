class ProgramSelector
  modal : (options) ->
    $table = $('<table></table>').attr('class', 'table table-striped table-hover')
    $body = $('<tbody></tbody>')
    $head = $('<thead></thead>').append(
      $('<tr></tr>')
        .append($('<th></th>').text(""))
        #.append($('<th></th>').text("Comment"))
        .append($('<th></th>').text(""))
    );
 
    $.get(getRequestURL('programs', 'owned_list'), {user_id: getUserId()}, (data) -> 
      programs = JSON.parse(data)
      for program in programs
        $tr = $('<tr></tr>')
  
        $title = $('<td></td>').attr(class: 'selector-title').text(program.name)
        if ( parseInt(program.is_preset) ) 
          $label = $('<span style="margin-left: 10px"></span>').attr(class: 'label label-info').text("preset");
          $title.append($label)
  
        $btns = $('<td></td>').attr(class: 'selector-btn')

        callback = (button.handler for button in options.buttons)
        for button, idx in options.buttons
          $btns.append(
            $('<button style="margin-left:10px"></button>').attr(class: "btn btn-" + button.type, 'program-id': program.id, 'btn-id': idx).text(button.text)
              .click(() ->
                callback[$(@).attr('btn-id')]($(@).attr('program-id'))
                $modal.modal('hide')
              )
          )
  
        $tr.append($title)
        $tr.append($btns)
        $body.append($tr)
    )
  
    $table.append($head)
    $table.append($body)
  
    $modalBody =
      $('<div></div>').attr('class', 'modal-body').append(
        $table
      )
  
    title = if options.title then options.title else "Select Program"
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

class ProgramStorage
  constructor: () ->
    @selector = new ProgramSelector()

  loadProgram : () -> 
    @selector.modal(
      buttons: [
        {
          type: 'success'
          text: 'Load'
          handler: @loadProgramById
        },
        {
          type: 'danger'
          text: 'Delete'
          handler: @deleteProgramById
        }
      ]
    )

  saveProgram : (override = false) ->
    bootbox.prompt("Enter Program Name.", (name)  => 
      if name then @saveProgramByName(name, override)
    )
  
  saveProgramByName : (name, override = false) ->
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
  
      $.post(getRequestURL('programs', 'add'), program, ( data) => 
        response = JSON.parse(data)
  
        if response.success
          Flash.showSuccess("保存しました。")
        else if response.preset
          bootbox.alert("サンプルプログラムを上書きすることはできません。<br>プログラム名を変更して下さい。")
        else if response.exists && !response.override
          bootbox.confirm(name + " は既に存在します。上書きしますか?", (result) => 
            if result then @saveProgramByName(name, true)
          ) 
        else
          bootbox.alert(data);
      )

  loadProgramById : (id, callback) ->
    $.get(getRequestURL('programs', 'load_data'), {id: id},  (data) ->
      getCurrentProgram().deserialize(JSON.parse(data))
      Flash.showSuccess("読み込みました。")
      if callback then callback()
    )

  deleteProgramById : (id, callback) ->
    $.post(getRequestURL('programs', 'delete'), {id: id},  (data) -> 
      Flash.showSuccess("削除しました。")
      if callback then callback()
    )
