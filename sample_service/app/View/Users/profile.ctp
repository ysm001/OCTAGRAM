<?php //pr($user); ?>
<script type="text/template" id="program-tpl">
  <div class="panel panel-primary">
  <div class="panel-heading"><%- name %> ~レート: <%- rate %>~</div>
    <div class="panel-body">
      <div id="graph-container" style="min-width; 310px: height; 400px: margin; 0 auto"></div>
      <ul class="list-group">
      <% battle_log.forEach(function(i){ %>
        <li class="list-group-item">
          <p class="list-group-item-text">レート: <%- i.rate %></p>
          <p class="list-group-item-text">消費エネルギー: <%- i.consumed_energy %></p>
          <p class="list-group-item-text">残りHP: <%- i.remaining_hp %></p>
        </li>
      <% }) %>
      </ul>
    </div>
  </div> 
</script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>
<?php echo $this->Html->script('model/program'); ?>
<?php echo $this->Html->script('users/profile/view'); ?>
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
            <legend>プロフィール</legend>
            <div class="form-group">
              <label for="cc_name" class="col-sm-3 control-label">ユーザー名</label>
              <div class="col-sm-9">
                <?php echo $this->Form->input('cc_name', array('class' => 'form-control', 'placeHolder' => 'Googleのユーザー名を隠したい時に入力してください', 'value' => $user['User']['cc_name'])); ?>
              </div>
            </div>
            <?php echo $this->Form->hidden('id', array('value' => $user['User']['id'])); ?>
            <div class="form-group">
              <div class="col-lg-9 col-lg-offset-3">
                <button type="submit" class="btn btn-primary">変更</button> 
              </div>
            </div>
          </fieldset>
        <?php echo $this->Form->end(); ?>
      </div>
      <blockquote> プログラムリスト </blockquote>
      <div class="list-group">
        <?php foreach ($user['Program'] as $p) { ?>
        <?php if ($p['is_preset']) continue; ?>
        <a href="#program/<?php echo $p['id']; ?>" class="list-group-item"><?php echo $p['name']; ?></a>
        <?php } ?>
      </div>
    </div>
    <div class="col-sm-6">
      <div id="program"></div>
    </div>
  </div>
</div>
