class ProgramSelector
  modal : (options) ->
    ScreenLoader.show()
    setTimeout((() =>
      $table = $('<table></table>').attr('class', 'table table-striped table-hover')
      $body = $('<tbody></tbody>')
      $head = $('<thead></thead>').append(
        $('<tr></tr>')
          .append($('<th></th>').text(""))
          #.append($('<th></th>').text("Comment"))
          .append($('<th></th>').text(""))
      );

      $.get(getRequestURL('programs', 'owned_list'), {user_id: getUserId()}, (data) -> 
        ScreenLoader.cancel()
        programs = JSON.parse(data)
        for program in programs
          $tr = $('<tr></tr>')
    
          $title = $('<td></td>').attr({class: 'selector-title', 'program-id': program.id}).text(program.name)
          if ( parseInt(program.is_preset) )
            if ( !options.showPresets? ) then continue;
            $label = $('<span style="margin-left: 10px"></span>').attr(class: 'label label-info').text("preset")
            $title.append($label)
    
          $btns = $('<td></td>').attr(class: 'selector-btn')

          callback = (button.handler for button in options.buttons)
          for button, idx in options.buttons
            $btns.append(
              $('<button style="margin-left:10px"></button>').attr(class: "btn btn-" + button.type, 'program-id': program.id, 'btn-id': idx).text(button.text)
                .click(() ->
                  programId = $(@).attr('program-id')
                  programName = $('.selector-title[program-id = ' + programId + ']').text()
                  callback[$(@).attr('btn-id')](id: programId, name: programName)
                  $modal.modal('hide')
                )
            )
    
          $tr.append($title)
          $tr.append($btns)
          $body.append($tr)

        if ( $body.children().length == 0 ) 
          $modalBody.children().remove()
          $modalBody.append($('<b class="text-danger">選択できるプログラムがありません。</b>'))
      )
    
      $table.append($head)
      $table.append($body)
    
      $modalBody =
        $('<div></div>').attr('class', 'modal-body').append(
          $table
        )
    
      title = if options.title then options.title else "プログラムを選択して下さい。"
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

      $modal.on('hidden.bs.modal', () => 
        $modal.remove()
      )

      $modal.modal({
        keyboard: true,
        show: true
      })

    ), 500)

class ProgramStorage
  constructor: () ->
    @selector = new ProgramSelector()

  loadProgram : (callback) -> 
    @selector.modal(
      showPresets: true,
      buttons: [
        {
          type: 'success'
          text: '読み込み'
          handler: (data) => 
            @loadProgramById(data.id, () -> 
              data.status = 'complete'
              callback(data)
            )
            data.status = 'ready'
            callback(data)
        }
      ]
    )

  deleteProgram : () ->
    @selector.modal(
      buttons: [
        {
          type: 'danger'
          text: '削除'
          handler: (data) => 
            bootbox.confirm('<b class="text-danger">プログラムを削除すると、関連する対戦履歴やスコアなども消えてしまいます。</b><br><p>本当に削除しますか？</p>',
              (result) => 
                if result then @deleteProgramById(data.id)
            )
        }
      ]
    )

  saveProgram : (override = false, defaultTitle = "", callback) ->
    bootbox.prompt("プログラム名を入力して下さい。", (name)  => 
      if name then @saveProgramByName(name, override, callback)
    )
    $input = $('.bootbox-input-text')
    $input.val(defaultTitle)
    $input.focus()
  
  saveProgramByName : (name, override = false, callback) ->
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
          if callback then callback({name: name})
        else if response.preset
          bootbox.alert("サンプルプログラムを上書きすることはできません。<br>プログラム名を変更して下さい。")
        else if response.exists && !response.override
          bootbox.confirm(name + " は既に存在します。上書きしますか?<br><b class='text-danger'>上書きすると、レートや対戦履歴は初期化されます。</b>", (result) => 
            if result then @saveProgramByName(name, true, callback)
          ) 
        else
          bootbox.alert(data);
      )

  loadProgramById : (id, callback) ->
    $.get(getRequestURL('programs', 'load_data'), {id: id},  (data) ->
      getCurrentProgram().deserialize(JSON.parse(data))
      Flash.showSuccess("読み込みました。")
      if callback then callback(id)
    )

  deleteProgramById : (id, callback) ->
    $.post(getRequestURL('programs', 'delete'), {id: id},  (data) -> 
      Flash.showSuccess("削除しました。")
      if callback then callback()
    )
