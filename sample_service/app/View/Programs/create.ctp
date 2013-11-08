<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">

    <?php echo $this->Html->css(array('create'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('bootbox'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('octagram/js/enchant.js/enchant.js'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/ui.enchant.js'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/widget.enchant.js'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('octagram/js/enchant.js/plugins/model.enchant.js'), false, array('inline'=>false)); ?>

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
    <?php echo $this->Html->script(array('robot_battle/js/ai-robot.js'), false, array('inline'=>false)); ?>

    <?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('create'), false, array('inline'=>false)); ?>

    <style type="text/css">
      body {
        margin: 0;
        padding: 0;
      }
    </style>

    <script type="text/javascript">
        window.onload = function() {
	    runGame();
        }
    </script>
  </head>
  <body>
    <div id="program-container">
      <div id="octagram" style="float:left"></div>
      <div id="enchant-stage" style="float:left"></div>
    </div>
    <div id="dbg-btns" style="float:left; margin-top: 10px">
      <form>
	<button type="button" class="btn btn-lg btn-success" id='edit-player-program' style="display: none">edit player program</button>
	<button type="button" class="btn btn-lg btn-danger"  id='edit-enemy-program'>edit enemy program</button>
	<button type="button" class="btn btn-lg btn-success" id="save">save</button>
	<button type="button" class="btn btn-lg btn-success" id="load">load</button>
	<button type="button" class="btn btn-lg btn-primary" id="run">run</button>
	<button type="button" class="btn btn-lg btn-warning" id="stop" disabled=disabled>stop</button>
	<button type="button" class="btn btn-lg btn-warning" id="restart" disabled=disabled>restart</button>

<!--
	<button type="button" class="btn btn-lg btn-success" id='edit-player-program' style="display: none"  onClick="editPlayerProgram()">edit player program</button>
	<button type="button" class="btn btn-lg btn-danger" id='edit-enemy-program' onClick="editEnemyProgram()">edit enemy program</button>
	<button type="button" class="btn btn-lg btn-success" onClick="saveProgram()">save</button>
	<button type="button" class="btn btn-lg btn-success" onClick="loadProgram()">load</button>
	<button type="button" class="btn btn-lg btn-primary" onClick="executeProgram()">run</button>
	<button type="button" class="btn btn-lg btn-warning" onClick="resetProgram()">stop</button>
	<button type="button" class="btn btn-lg btn-warning" onClick="restartProgram()">restart</button>
-->
      </form>
    </div>
  </body>
</html>
