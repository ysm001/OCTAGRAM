<?php $this->start('bottom-content'); ?>
<?php
$pageInfo = $this->params['paging']['BattleLogAssociation'];
?>

<?php echo $this->Html->css(array('home'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('home'), false, array('inline'=>false)); ?>
<!-- Three columns of text below the carousel -->
<br>
<blockquote>
  <p><b class="battle-log-header">対戦ログ</b></p>
</blockquote>

<?php if ($pageInfo['count'] > 0) { ?>

<?php foreach($associations as $p) { ?>
<div class="row battle-log">
  <div class="battle-log-challenger col-sm-4 program-cell" program-id="<?php echo $p['ChallengerBattleLog']['Program']['id']; ?>" user-id="<?php echo $p['ChallengerBattleLog']['Program']['User']['id']; ?>">
    <div class="row">
      <div class="col-sm-6">
        <div class="img">
          <img class="img-rounded" src="<?php echo $p['ChallengerBattleLog']['Program']['User']['icon_url'] ?>" height="80" alt="" />
        </div>
      </div>
      <?php if ($p['ChallengerBattleLog']['is_winner']) { ?><div class="col-sm-6 text-primary"><?php } else { ?><div class="col-sm-6 text-danger"><?php } ?>
          <div class="name" style="font-size:small;"><?php echo $p['ChallengerBattleLog']['Program']['User']['nickname']; ?></div>
          <div class="program-name" style="font-size:x-large;"><?php echo $p['ChallengerBattleLog']['Program']['name']; ?></div>
          <div class="score">score : <?php echo $p['ChallengerBattleLog']['score']; ?></div>
        </div>
      </div>
    </div>
    <div class="battle-log-vs col-sm-4">
      <div class="text-danger">V.S.</div>
      <div class="text-muted"><?php echo (new DateTime($p['BattleLogAssociation']['created']))->format('Y-m-d H:i'); ?></div>
    </div>
    <div class="battle-log-defender col-sm-4 program-cell" program-id="<?php echo $p['DefenderBattleLog']['Program']['id']; ?>" user-id="<?php echo $p['DefenderBattleLog']['Program']['User']['id']; ?>">
      <div class="row">
        <?php if ($p['DefenderBattleLog']['is_winner']) { ?><div class="col-sm-6 text-primary"><?php } else { ?><div class="col-sm-6 text-danger"><?php } ?>
            <div class="name" style="font-size:small;"><?php echo $p['DefenderBattleLog']['Program']['User']['nickname']; ?></div>
            <div class="program-name" style="font-size:x-large;"><?php echo $p['DefenderBattleLog']['Program']['name']; ?></div>
            <div class="score">score : <?php echo $p['DefenderBattleLog']['score']; ?></div>
          </div>
          <div class="col-sm-6">
            <div class="img" height=80>
              <img class="img-rounded" src="<?php echo $p['DefenderBattleLog']['Program']['User']['icon_url'] ?>" height="80" alt="" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <?php } ?>

    <!-- pagenation -->
    <ul class='pagination'>
      <?php if($pageInfo['prevPage']) { ?>
      <li><?php echo $this->Html->link('<<', '/fronts/home/page:'.($pageInfo['page']-1)); ?></li>
      <?php } else { ?>
      <li class='disabled'><?php echo $this->Html->link('<<', '#'); ?></li>
      <?php } ?>

      <?php foreach(range(1, $pageInfo['pageCount']) as $num) { ?>
      <?php if ($num == $pageInfo['page']) { ?>
      <li class='active'><?php echo $this->Html->link($num, '/fronts/home/page:'.$num); ?><li>
          <?php } else { ?>
          <li><?php echo $this->Html->link($num, '/fronts/home/page:'.$num); ?><li>
              <?php } ?>
              <?php } ?>

              <?php if($pageInfo['nextPage']) { ?>
              <li><?php echo $this->Html->link('>>', '/fronts/home/page:'.($pageInfo['page']+1)); ?></li>
              <?php } else { ?>
              <li class='disabled'><?php echo $this->Html->link('>>', '#'); ?></li>
              <?php } ?>    
            </ul>
            <!-- pagenation end -->

            <?php } else { ?>
            <h3 class="text-danger">対戦ログはありません。</h3>
            <?php } ?>
          </div>
        </div> 


    <?php if ( $authUser ) : ?>
      <?php $this->Html->scriptStart(array('inline'=>false)); ?>
        var tutorialEnabled = <?php echo $authUser['tutorial_enabled'] ?>
      <?php $this->Html->scriptEnd(); ?>
    <?php endif ?>
<?php $this->end(); ?>
