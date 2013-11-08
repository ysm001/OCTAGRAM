<?php
// pr($associations)
$pageInfo = $this->params['paging']['BattleLogAssociation'];
?>
<?php echo $this->Html->css(array('home'), false, array('inline'=>false)); ?>
<?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('home'), false, array('inline'=>false)); ?>

<?php $this->start('content-without-container'); ?>
  <!-- Three columns of text below the carousel -->
<div class="container">
  <div class="row menu">
    <div class="menu-item col-sm-4">
   <?php echo $this->Html->image('top_icon_programming.png', array('class' => 'top-icon', 'url' => array('controller' => 'programs', 'action' => 'create')));?>
      <h2>プログラミング</h2>
      <p>OCTAGRAMを用いてAIプログラミングを行います。</p>
    </div><!-- /.col-lg-4 -->
    <div class="menu-item col-sm-4">
   <?php echo $this->Html->image('top_icon_vs.png', array('class' => 'img-circle top-icon', 'url' => array('controller' => 'combats', 'action' => 'index')));?>
      <h2>対戦</h2>
      <p>他のユーザのAIと対戦を行います。</p>
    </div><!-- /.col-lg-4 -->
    <div class="menu-item col-sm-4">
   <?php echo $this->Html->image('top_icon_ranking.png', array('class' => 'img-circle top-icon', 'url' => array('controller' => 'rankings', 'action' => 'index')));?>
      <h2>ランキング</h2>
      <p>ランキングを表示します。</p>
    </div><!-- /.col-lg-4 -->
  </div><!-- /.row -->
</div>

<div class="battle-log-wrapper">
<div class="battle-log-container">
<div class="container">
    <br>
   <blockquote>
     <p><b class="battle-log-header">対戦履歴</b></p>
   </blockquote>

   <?php if ($pageInfo['count'] > 0) { ?>

     <?php foreach($associations as $p) { ?>

     <div class="row battle-log">
	 <div class="battle-log-challenger col-sm-4" program-id="<?php echo $p['ChallengerBattleLog']['Program']['id']; ?>" user-id="<?php echo $p['ChallengerBattleLog']['Program']['User']['id']; ?>">
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
	 <div class="battle-log-vs col-sm-4" style="margin-top: 10px;">
	     <div class="text-danger" style="font-size:large;">V.S.</div>
	     <div class="text-muted"><?php echo (new DateTime($p['BattleLogAssociation']['created']))->format('Y-m-d H:i'); ?></div>
	 </div>
	 <div class="battle-log-defender col-sm-4" program-id="<?php echo $p['DefenderBattleLog']['Program']['id']; ?>" user-id="<?php echo $p['DefenderBattleLog']['Program']['User']['id']; ?>">
	     <div class="row">
	     <?php if ($p['DefenderBattleLog']['is_winner']) { ?><div class="col-sm-6 text-primary"><?php } else { ?><div class="col-sm-6 text-danger"><?php } ?>
		     <div class="name" style="font-size:small;"><?php echo $p['DefenderBattleLog']['Program']['User']['nickname']; ?></div>
		     <div class="program-name" style="font-size:x-large;"><?php echo $p['DefenderBattleLog']['Program']['name']; ?></div>
		 <div class="score">score : <?php echo $p['DefenderBattleLog']['score']; ?></div>
		 </div>
		 <div class="col-sm-6">
		     <div class="img">
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
     <h3 class="text-danger">対戦ログは存在しません</h3>
   <?php } ?>
   </div>
</div> 
</div> 
<?php $this->end(); ?>
