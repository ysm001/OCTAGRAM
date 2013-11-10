<?php $this->start('bottom-content-after') ?>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<?php echo $this->Html->css(array('create'), false, array('inline'=>false)); ?>
<?php echo $this->Html->css(array('matching'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('bootbox'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/ui.enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/widget.enchant.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/model.enchant.js'), false, array('inline'=>false)); ?>

<?php $this->Html->scriptStart(array('inline'=>false)); ?>
  playerProgram = <?php echo json_encode($player['Program']) ?>;
  enemyProgram = <?php echo json_encode($enemy['Program']) ?>;
  playerIconURL = "<?php echo $playerIconURL ?>";
  enemyIconURL = "<?php echo $enemyIconURL ?>";
  playerId = playerProgram.id;
  enemyId = enemyProgram.id;
 
  var VPL_JS_BASE = "./";
  var base = getRoot() + "<?php echo APP_DIR.'/'.WEBROOT_DIR.'/'.JS_URL;  ?>";
  var octagramBase = base + "/octagram";
  var resourceBase = base + "/robot_battle/resources";
  var UserConfig = {OCTAGRAM_DIR: octagramBase, R: {RESOURCE_DIR: resourceBase}};
  enchant();
  enchant.ui.assets = [resourceBase + '/ui/pad.png', resourceBase + '/ui/apad.png', resourceBase + '/ui/icon0.png', resourceBase + '/ui/font0.png'];
  enchant.widget.assets = [resourceBase + '/widget/dialog.png'];
<?php $this->Html->scriptEnd(); ?>

<?php echo $this->Html->script(array('octagram/js/octagram-loader-client.js'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('robot_battle/js/ai-robot.js'), false, array('inline'=>false)); ?>

<?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('create'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('matching'), false, array('inline'=>false)); ?>

<style type="text/css">
  body {
    margin: 0;
    padding: 0;
  }
</style>

<body>
  <div class="container-margin">
    <div class="program-editor-container">
      <div id="program-container">
        <div id="octagram" style="float:left"></div>
        <div id="enchant-stage" style="float:left"></div>
      </div>
    </div>
  </div>
</body>
<?php $this->end(); ?>
