<?php $this->extend('bootstrap'); ?>

<?php echo $this->Html->css(array('bootstrap-with-header'), false, array('inline'=>false)); ?>
<?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>

<?php $this->start('content-without-container'); ?>
<!-- Three columns of text below the carousel -->
<div class="wrapper">
  <div class="menu-wrapper">
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
  </div>

  <div class="bottom-content-wrapper">
    <div class="bottom-content-container">
      <div class="container">
        <?php echo $this->fetch('bottom-content'); ?>
      </div> 
    </div>
  </div>
</div>
<?php $this->end(); ?>
