<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">

    <?php echo $this->Html->css(array('create'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'), false, array('inline'=>false)); ?>
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

    <style type="text/css">
      body {
        margin: 0;
        padding: 0;
      }
    </style>
  </head>
  <body>
    <div class="program-container">
      <div id="octagram" style="float:left"></div>
      <div id="enchant-stage" style="float:left"></div>
    </div>
    <div id="dbg-btns" style="float:left">
      <form>
        <!--<input type="button" class="btn btn-default" value="generate"       name="Generate Test Code" onClick="generateTestCode()" />-->
        <input type="button" class="btn btn-success" value="show player" name="Save" onClick="showPlayerProgram()" />
        <input type="button" class="btn btn-success" value="save player" name="Save" onClick="savePlayerProgram()" />
        <input type="button" class="btn btn-success" value="load player" name="Save" onClick="loadPlayerProgram()" />
        <input type="button" class="btn btn-success" value="execute player" name="Execute Test Code" onClick="executePlayerProgram()" />
        <input type="button" class="btn btn-danger" value="show enemy" name="Save" onClick="showEnemyProgram()" />
        <input type="button" class="btn btn-danger" value="save enemy"  name="Save" onClick="saveEnemyProgram()" />
        <input type="button" class="btn btn-danger" value="load enemy"  name="Save" onClick="loadEnemyProgram()" />
        <input type="button" class="btn btn-danger" value="execute enemy"  name="Execute Test Code" onClick="executeEnemyProgram()" />
      </form>
    </div>
  </body>
</html>
