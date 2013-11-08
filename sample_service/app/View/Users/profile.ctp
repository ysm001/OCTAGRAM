<?php //pr($user); ?>
<div class="container">
  <div class="row">
    <div class="col-sm-6">
      <div class="well">
        <?php
          echo $this->Form->create('User', 
            array(
              'class' => 'form-horizontal', 
              'inputDefaults' => array(
                'format' => array('before', 'label', 'between', 'input', 'error', 'after'),
                'label' => false,
                'div' => false,
                'after' => false,
                'error' => array('attributes' => array('wrap' => 'span', 'class' => 'help-inline')),
                'between' => false,
              )
            )
          );
          ?>
          <fieldset>
            <legend>プロファイル</legend>
            <div class="form-group">
              <label for="cc_name" class="col-sm-3 control-label">ユーザー名</label>
              <div class="col-sm-9">
                <?php echo $this->Form->input('cc_name', array('class' => 'form-control', 'placeHolder' => 'Googleのユーザー名を隠したい時に入力してください', 'value' => $user['User']['cc_name'])); ?>
              </div>
            </div>
            <?php echo $this->Form->hidden('id', array('value' => $user['User']['id'])); ?>
            <div class="form-group">
              <div class="col-lg-9 col-lg-offset-3">
                <button type="submit" class="btn btn-primary">Submit</button> 
              </div>
            </div>
          </fieldset>
        <?php echo $this->Form->end(); ?>
      </div>
      <div class="panel panel-primary">
        <div class="panel-heading">プログラムリスト</div>
        <div class="panel-body">
          <ul class="list-group">
            <?php foreach ($user['Program'] as $p) { ?>
            <?php if ($p['is_preset']) continue; ?>
            <li class="list-group-item"><?php echo $p['name']; ?></li>
            <?php } ?>
          </ul>
        </div>
      </div> 
    </div>
  </div>
</div>
