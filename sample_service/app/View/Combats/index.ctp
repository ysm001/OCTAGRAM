<?php $this->start('bottom-content'); ?>

<?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->css(array('combat'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('combat'), false, array('inline'=>false)); ?>

<?php
$pageInfo = $this->params['paging']['Program'];
extract($this->passedArgs);

$tmp = array();
foreach($this->passedArgs as $k => $v) {
if ($k != "page") {
array_push($tmp, $k.":".$v);
}
}
$query = (count($tmp) > 0) ? "/".implode("/", $tmp) : "";
?>

<div>
  <br>
  <blockquote>
    <p><b class="opponent-list-header">対戦相手一覧</b></p>
  </blockquote>

  <?php if ($pageInfo['count'] > 0) { ?>
  <!-- table -->

  <div class="opponent-list">
    <div class="row opponent-list-heading">
      <div class="col-sm-4">
        <?php if(isset($sort) && $sort == "name") { ?><i class="glyphicon <?php echo ($direction == "asc") ? "glyphicon-chevron-up" : "glyphicon-chevron-down"?>"></i><?php } ?>
        <?php echo $this->Paginator->sort('name','敵プログラム名');?>
      </div>
      <div class="col-sm-4">
        <?php if(isset($sort) && $sort == "user_id") { ?><i class="glyphicon <?php echo ($direction == "asc") ? "glyphicon-chevron-up" : "glyphicon-chevron-down"?>"></i><?php } ?>
        <?php echo $this->Paginator->sort('user_id','プログラム所有者');?>
      </div>
      <div class="col-sm-4">
        <?php if(isset($sort) && $sort == "modified") { ?><i class="glyphicon <?php echo ($direction == "asc") ? "glyphicon-chevron-up" : "glyphicon-chevron-down"?>"></i><?php } ?>
        <?php echo $this->Paginator->sort('modified','登録日時');?>
      </div>
    </div>

    <?php foreach($programs as $p) { ?>
    <div class="row program-row" program-id='<?php echo $p["Program"]["id"]?>'>
      <div class="col-sm-4">
        <div class="text-primary program-name">
          <!--
          <img class="img-rounded" src="<?php echo $p['User']['icon_url'] ?>" height="80" alt="" />&nbsp;&nbsp;
          -->
          <?php echo $p['Program']['name']; ?>
        </div>
      </div>
      <div class="col-sm-4">
        <div class="user-col">
          <img class="img-rounded" src="<?php echo $p['User']['icon_url'] ?>" height="80" alt="" />&nbsp;&nbsp;
          <?php echo $p['User']['nickname']; ?>
        </div>
      </div>
      <div class="col-sm-4"><p class="modified"><?php echo (new DateTime($p['Program']['modified']))->format('Y-m-d H:i'); ?></p></div>
    </div>
    <?php } ?>

  </div>
  <!-- table end -->  


      <!-- pagenation -->
      <ul class='pagination'>
        <?php if($pageInfo['prevPage']) { ?>
        <li><?php echo $this->Html->link('<<', '/combats/index/page:'.($pageInfo['page']-1)); ?></li>
        <?php } else { ?>
        <li class='disabled'><?php echo $this->Html->link('<<', '#'); ?></li>
        <?php } ?>

        <?php foreach(range(1, $pageInfo['pageCount']) as $num) { ?>
        <?php if ($num == $pageInfo['page']) { ?>
        <li class='active'><?php echo $this->Html->link($num, '/combats/index/page:'.$num.$query); ?><li>
            <?php } else { ?>
            <li><?php echo $this->Html->link($num, '/combats/index/page:'.$num.$query); ?><li>
                <?php } ?>
                <?php } ?>

                <?php if($pageInfo['nextPage']) { ?>
                <li><?php echo $this->Html->link('>>', '/combats/index/page:'.($pageInfo['page']+1)); ?></li>
                <?php } else { ?>
                <li class='disabled'><?php echo $this->Html->link('>>', '#'); ?></li>
                <?php } ?>    
              </ul>
              <!-- pagenation end -->


</div>
      </div>


              <?php } else { ?>
              <h3 class="text-danger">対戦できる敵プログラムは存在しません</h3>
              <?php } ?>

              <div>

                <?php $this->end(); ?>
