<?php $this->start('bottom-content-after'); ?>
<?php echo $this->Html->css(array('create'), false, array('inline'=>false)); ?>
<?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('bootbox'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/ui.enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/widget.enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/model.enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('ace'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('mode-javascript'), false, array('inline'=>false)); ?>

<?php $this->Html->scriptStart(array('inline'=>false)); ?>
  var VPL_JS_BASE = "./";
  var base = "<?php echo '../'.APP_DIR.'/'.WEBROOT_DIR.'/'.JS_URL;  ?>";
  var octagramBase = base + "/octagram";
  var resourceBase = base + "/robot_battle/resources";
  var UserConfig = {OCTAGRAM_DIR: octagramBase, R: {RESOURCE_DIR: resourceBase}};
  enchant();
  enchant.ui.assets = [resourceBase + '/ui/pad.png', resourceBase + '/ui/apad.png', resourceBase + '/ui/icon0.png', resourceBase + '/ui/font0.png'];
  enchant.widget.assets = [resourceBase + '/widget/dialog.png'];
<?php $this->Html->scriptEnd(); ?>

<?php echo $this->Html->script(array('octagram/js/octagram-loader-client.js'), false, array('inline'=>false)); ?>
<?php if (isset($_GET['dev'])) { ?>
<?php echo $this->Html->script(array('robot_battle/js/ai-robot.js'), false, array('inline'=>false)); ?>
<?php } else { ?>
<?php echo $this->Html->script(array('robot_battle/code-combat.min.js'), false, array('inline'=>false)); ?>
<?php } ?>

<?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('create'), false, array('inline'=>false)); ?>

<style type="text/css">
  body {
    margin: 0;
    padding: 0;
  }
</style>

<?php $this->Html->scriptStart(array('inline'=>false)); ?>
  window.onload = function() {
    runGame();
  }
<?php $this->Html->scriptEnd(); ?>
<br>
<div class="program-editor-container">
<blockquote class="programming-header">
  <b>プログラム作成</b>
  <p>- 最強のAIを作ろう！-</p>
</blockquote>
<div id="program-container">
  <div id="octagram" style="float:left"></div>
  <div id="enchant-stage" style="float:left"></div>
</div>
<div id="target-label-player" class="label label-success">プレイヤープログラムを編集中</div>
<div id="target-label-enemy" class="label label-danger" style="display:none">敵プログラムを編集中 (保存はできません)</div>
<br>
<div id="dbg-btns" style="float:left; margin-top: 10px">
  <div class='button-container-left'>
    <button type="button" class="btn btn-lg btn-success" id="save">保存</button>
    <button type="button" class="btn btn-lg btn-success" id="load">読み込み</button>
    <button type="button" class="btn btn-lg btn-danger" id="delete">削除</button>
  </div>
  <div class='button-container'>
    <button type="button" class="btn btn-lg btn-primary" id="run">実行</button>
    <button type="button" class="btn btn-lg btn-warning" id="stop" disabled=disabled>初期状態に戻す</button>
    <button type="button" class="btn btn-lg btn-warning" id="restart" disabled=disabled>最初から実行</button>
  </div>
  <div class='button-container'>
    <button type="button" class="btn btn-lg btn-success" id='edit-player-program' style="display: none">プレイヤープログラムを編集</button>
    <button type="button" class="btn btn-lg btn-danger"  id='edit-enemy-program'>敵プログラムを編集</button>
  </div>

  <div class='button-container-row'>
    <button type="button" class="btn btn-lg btn-primary" id="show-js">Javascriptを表示</button>
    <button type="button" class="btn btn-lg btn-primary" id="compare-js">Javascriptと比較</button>
    <button type="button" class="btn btn-lg btn-danger" id="hide-js" disabled=disabled>Javascriptを隠す</button>
  </div>
</div>
</div>
<?php $this->end(); ?>
