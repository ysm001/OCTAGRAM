<?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script(array('combat'), false, array('inline'=>false)); ?>

<?php
   $pageInfo = $this->params['paging']['Program'];
?>
<div>

  <blockquote>
    <p>OCTAGRAM AI list</p>
    <small>fight the AI of other users!</small>
  </blockquote>

  <?php if ($pageInfo['count'] > 0) { ?>
  
    <!-- pagenation -->
    <ul class='pagination'>
      <?php if($pageInfo['prevPage']) { ?>
        <li><?php echo $this->Html->link('<<', '/combats/index/page:'.($pageInfo['page']-1)); ?></li>
      <?php } else { ?>
        <li class='disabled'><?php echo $this->Html->link('<<', '#'); ?></li>
      <?php } ?>
   
      <?php foreach(range(1, $pageInfo['pageCount']) as $num) { ?>
        <?php if ($num == $pageInfo['page']) { ?>
          <li class='active'><?php echo $this->Html->link($num, '/combats/index/page:'.$num); ?><li>
        <?php } else { ?>
          <li><?php echo $this->Html->link($num, '/combats/index/page:'.$num); ?><li>
        <?php } ?>
      <?php } ?>
   
      <?php if($pageInfo['nextPage']) { ?>
        <li><?php echo $this->Html->link('>>', '/combats/index/page:'.($pageInfo['page']+1)); ?></li>
      <?php } else { ?>
        <li class='disabled'><?php echo $this->Html->link('>>', '#'); ?></li>
      <?php } ?>    
    </ul>
    <!-- pagenation end -->
   
    <!-- table -->  
    <table class='table table table-striped table-hover'>
      <tr><th style='width:100px;'></th><th>敵プログラム名</th><th>対戦相手</th><th>更新日時</th></tr>
      <?php foreach($programs as $p) { ?> 
      <tr>
        <td>
	<div class='btn btn-default btn-battle' program-id='<?php echo $p["Program"]["id"]?>'>Battle »</div>
        </td>
        <td><p class="text-primary"><?php echo $p['Program']['name']; ?></p></td>
        <td><?php echo $p['User']['nickname']; ?></td>
        <td><?php echo $p['Program']['modified']; ?></td>
      </tr>
      <?php } ?>
    </table>
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
          <li class='active'><?php echo $this->Html->link($num, '/combats/index/page:'.$num); ?><li>
        <?php } else { ?>
          <li><?php echo $this->Html->link($num, '/combats/index/page:'.$num); ?><li>
        <?php } ?>
      <?php } ?>
   
      <?php if($pageInfo['nextPage']) { ?>
        <li><?php echo $this->Html->link('>>', '/combats/index/page:'.($pageInfo['page']+1)); ?></li>
      <?php } else { ?>
        <li class='disabled'><?php echo $this->Html->link('>>', '#'); ?></li>
      <?php } ?>    
    </ul>
    <!-- pagenation end -->
  
  <?php } else { ?>
    <h3 class="text-danger">対戦できる敵プログラムは存在しません</h3>
  <?php } ?>
  
<div>
