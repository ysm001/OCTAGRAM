    <!-- Marketing messaging and featurettes
    ================================================== -->
    <!-- Wrap the rest of the page in another container to center all the content. -->

    <?php echo $this->Html->css(array('home'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('combat'), false, array('inline'=>false)); ?>


    <div class="container marketing">

      <!-- Three columns of text below the carousel -->
      <div class="row">
        <div class="col-lg-4">
	   <?php echo $this->Html->image('top_icon_programming.png', array('class' => 'top-icon', 'url' => array('controller' => 'programs', 'action' => 'create')));?>
          <h2>プログラミング</h2>
          <p>OCTAGRAMを用いてAIプログラミングを行います。</p>
        </div><!-- /.col-lg-4 -->
        <div class="col-lg-4">
	   <?php echo $this->Html->image('top_icon_vs.png', array('class' => 'img-circle top-icon', 'url' => array('controller' => 'combats', 'action' => 'index')));?>
          <h2>対戦</h2>
          <p>他のユーザのAIと対戦を行います。</p>
        </div><!-- /.col-lg-4 -->
        <div class="col-lg-4">
	   <?php echo $this->Html->image('top_icon_ranking.png', array('class' => 'img-circle top-icon', 'url' => array('controller' => 'fronts', 'action' => 'home')));?>
          <h2>ランキング</h2>
          <p>ランキングを表示します。</p>
        </div><!-- /.col-lg-4 -->
      </div><!-- /.row -->

     <?php
        $pageInfo = $this->params['paging']['BattleLogAssociation'];
     ?>
     <div>
    
       <hr></hr>
       <blockquote>
         <p>Battle Log</p>
       </blockquote>
       <?php if ($pageInfo['count'] > 0) { ?>
       
         <!-- table -->  
         <table class='table table table-striped table-hover'>
           <tr><th>プレイヤー名</th><th>プログラム名</th><th></th><th style="text-align:right">プログラム名</th><th style="text-align:right">プレイヤー名</th></tr>
           <?php foreach($associations as $p) { ?> 
           <tr>
             <td><p class="text"><?php echo $p['ChallengerBattleLog']['Program']['User']['nickname']; ?></p></td>
             <td><p class="text-primary"><?php echo $p['ChallengerBattleLog']['Program']['name']; ?></p></td>
             <td><p class="text-danger">V.S.</p></td>
             <td><p class="text-primary" style="text-align:right"><?php echo $p['DefenderBattleLog']['Program']['name']; ?></p></td>
             <td><p class="text" style="text-align:right"><?php echo $p['DefenderBattleLog']['Program']['User']['nickname']; ?></p></td>
           </tr>
           <?php } ?>
         </table>
         <!-- table end -->  
        
         <!-- pagenation -->
         <ul class='pagination'>
           <?php if($pageInfo['prevPage']) { ?>
             <li><?php echo $this->Html->link('<<', '/fronts/index/page:'.($pageInfo['page']-1)); ?></li>
           <?php } else { ?>
             <li class='disabled'><?php echo $this->Html->link('<<', '#'); ?></li>
           <?php } ?>
             
           <?php foreach(range(1, $pageInfo['pageCount']) as $num) { ?>
             <?php if ($num == $pageInfo['page']) { ?>
               <li class='active'><?php echo $this->Html->link($num, '/fronts/index/page:'.$num); ?><li>
             <?php } else { ?>
               <li><?php echo $this->Html->link($num, '/fronts/index/page:'.$num); ?><li>
             <?php } ?>
           <?php } ?>
        
           <?php if($pageInfo['nextPage']) { ?>
             <li><?php echo $this->Html->link('>>', '/fronts/index/page:'.($pageInfo['page']+1)); ?></li>
           <?php } else { ?>
             <li class='disabled'><?php echo $this->Html->link('>>', '#'); ?></li>
           <?php } ?>    
         </ul>
         <!-- pagenation end -->
       
       <?php } else { ?>
         <h3 class="text-danger">対戦できる敵プログラムは存在しません</h3>
       <?php } ?>
       
     <div>
