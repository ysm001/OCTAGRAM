<?php $this->start('bottom-content-after'); ?>
<?php echo $this->Html->css(array('create'), false, array('inline'=>false)); ?>
<?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->css(array('maze'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('bootbox'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/ui.enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/widget.enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/model.enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('ace'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('mode-javascript'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('tm.hash-observer'), false, array('inline'=>false)); ?>

<?php $this->Html->scriptStart(array('inline'=>false)); ?>
  var VPL_JS_BASE = "./";
  var base = "<?php echo './'.APP_DIR.'/'.WEBROOT_DIR.'/'.JS_URL;  ?>";
  var octagramBase = base + "/octagram";
  var resourceBase = base + "/maze/resources";
  var UserConfig = {OCTAGRAM_DIR: octagramBase, R: {RESOURCE_DIR: resourceBase}};
  enchant();
  enchant.ui.assets = [resourceBase + '/ui/pad.png', resourceBase + '/ui/apad.png', resourceBase + '/ui/icon0.png', resourceBase + '/ui/font0.png'];
  enchant.widget.assets = [resourceBase + '/widget/dialog.png'];
<?php $this->Html->scriptEnd(); ?>

<?php echo $this->Html->script(array('octagram/js/octagram-loader-client.js'), false, array('inline'=>false)); ?>
<?php if (isset($_GET['dev'])) { ?>
<?php echo $this->Html->script(array('maze/js/maze-loader.js'), false, array('inline'=>false)); ?>
<?php } else { ?>
<?php echo $this->Html->script(array('maze/js/maze-loader.js'), false, array('inline'=>false)); ?>
<?php } ?>

<?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('create'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('maze'), false, array('inline'=>false)); ?>

<style type="text/css">
  body {
    margin: 0;
    padding: 0;
  }
</style>

<?php $this->Html->scriptStart(array('inline'=>false)); ?>
  window.onload = function() {
    maze = new MazeResultViewer();

    options = { 
      onend: function(result) {maze.end(result);}
    };

    runGame(options);
  }
<?php $this->Html->scriptEnd(); ?>
<br>
<div class="program-editor-container">
<blockquote class="programming-header">
  <b>チュートリアル</b>
  <p>- プログラムで迷路を解こう！-</p>
</blockquote>
<div id="program-container">
  <div id="octagram" style="float:left"></div>
  <div id="enchant-stage" style="float:left"></div>
  <div id="js-viewer"></div>
</div>
<br>
<div id="dbg-btns" style="float:left; margin-top: 10px">
  <div class='button-container'>
    <button type="button" class="btn btn-lg btn-primary" id="run">実行</button>
    <button type="button" class="btn btn-lg btn-warning" id="stop" disabled=disabled>初期状態に戻す</button>
  </div>
  <div class='button-container'>
    <button type="button" class="btn btn-lg btn-primary" id="show-js">Javascriptを表示</button>
    <button type="button" class="btn btn-lg btn-danger" id="hide-js" disabled=disabled>Javascriptを隠す</button>
  </div>
  <div class='button-container' style='float:right'>
    <div class="btn-toolbar" role="toolbar">
      <div class="btn-group">
        <button class="btn btn-lg btn-default question-number" type="button">1</button>
        <button class="btn btn-lg btn-default question-number" type="button">2</button>
        <button class="btn btn-lg btn-default question-number" type="button">3</button>
        <button class="btn btn-lg btn-default question-number" type="button">4</button>
        <button class="btn btn-lg btn-default question-number" type="button">5</button>
      </div>
    </div>
  </div>
</div>
</div>
<?php $this->end(); ?>
