<?php $this->start('bottom-content'); ?>
<br>
<?php echo $this->Html->css(array('ranking'), false, array('inline'=>false)); ?>
<blockquote>
  <p><b class="rank-header">ランキング</b></p>
</blockquote>
    <div class="row rank-list-heading">
      <div class="col-sm-1 center">
        <p>順位</p>
      </div>
      <div class="col-sm-3">
        <p>プログラム名</p>
      </div>
      <div class="col-sm-2 center">
        <p>レーティング</p>
      </div>
      <div class="col-sm-1 center">
        <p>戦闘回数</p>
      </div>
      <div class="col-sm-2 center">
        <p>平均スコア</p>
      </div>
      <div class="col-sm-2 center">
        <p>プログラム所有者</p>
      </div>
    </div>
    <?php foreach($programs as $p) { ?>
    <div class="row program-row" program-id='<?php echo $p["Program"]["id"]?>'>
      <div class="col-sm-1 center"><div class="rank"><?php echo $p["Program"]["rank"]?></div></div>
      <div class="col-sm-3">
        <div class="text-primary program-name">
          <!--
          <img class="img-rounded" src="<?php echo $p['User']['icon_url'] ?>" height="80" alt="" />&nbsp;&nbsp;
          -->
          <?php echo $p['Program']['name']; ?>
        </div>
      </div>
      <div class="col-sm-2 center">
        <div class="text-primary rate">
          <?php echo $p['Program']['rate']; ?>
        </div>
      </div>
      <div class="col-sm-1 center">
        <div class="text-primary battle_num">
          <?php echo $p['Statistics']['battle_num']; ?>
        </div>
      </div>
      <div class="col-sm-2 center">
        <div class="text-primary score_average">
          <?php echo $p['Statistics']['score_average']; ?>
        </div>
      </div>
      <div class="col-sm-2 center">
        <div class="user-col">
          <img class="img-rounded" src="<?php echo $p['User']['icon_url'] ?>" height="80" alt="" /><br>
          <?php echo $p['User']['nickname']; ?>
        </div>
      </div>
    </div>
    <?php } ?>
<?php $this->end(); ?>
