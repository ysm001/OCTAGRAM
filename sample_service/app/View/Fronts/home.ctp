    <!-- Marketing messaging and featurettes
    ================================================== -->
    <!-- Wrap the rest of the page in another container to center all the content. -->

    <?php echo $this->Html->css(array('home'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->css(array('program'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('program'), false, array('inline'=>false)); ?>
    <?php echo $this->Html->script(array('home'), false, array('inline'=>false)); ?>


    <div class="container marketing">

      <!-- Three columns of text below the carousel -->
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
	   <?php echo $this->Html->image('top_icon_ranking.png', array('class' => 'img-circle top-icon', 'url' => array('controller' => 'fronts', 'action' => 'home')));?>
          <h2>ランキング</h2>
          <p>ランキングを表示します。</p>
        </div><!-- /.col-lg-4 -->
      </div><!-- /.row -->

     <?php
        $pageInfo = $this->params['paging']['BattleLogAssociation'];
     ?>
    
       <hr></hr>
       <blockquote>
         <p>対戦履歴</p>
       </blockquote>
       <?php if ($pageInfo['count'] > 0) { ?>
       
        
        <?php
        $email = "tamanyan.sss@gmail.com";
        $size = 40;
        $grav_url = "http://www.gravatar.com/avatar/" . md5( strtolower( trim( $email ) ) ) . "&s=" . $size;
        ?>
         <?php foreach($associations as $p) { ?> 
         <div class="row battle-log">
             <div class="battle-log-challenger col-sm-4" program-id="<?php echo $p['ChallengerBattleLog']['Program']['id']; ?>" user-id="<?php echo $p['ChallengerBattleLog']['Program']['User']['id']; ?>">
                 <div class="row">
                     <div class="col-sm-6">
                         <div class="img">
                             <img class="img-rounded" src="<?php echo $grav_url; ?>" height="80" alt="" />
                         </div>
                     </div>
                     <div class="col-sm-6">
                         <div class="name"><?php echo $p['ChallengerBattleLog']['Program']['User']['nickname']; ?></div>
                         <div class="program-name"><?php echo $p['ChallengerBattleLog']['Program']['name']; ?></div>
                     </div>
                </div>
             </div>
             <div class="battle-log-vs col-sm-4">
                 <p class="text-danger">V.S.</p>
             </div>
             <div class="battle-log-defender col-sm-4" program-id="<?php echo $p['DefenderBattleLog']['Program']['id']; ?>" user-id="<?php echo $p['DefenderBattleLog']['Program']['User']['id']; ?>">
                 <div class="row">
                     <div class="col-sm-6">
                         <div class="name"><?php echo $p['DefenderBattleLog']['Program']['User']['nickname']; ?></div>
                         <div class="program-name"><?php echo $p['DefenderBattleLog']['Program']['name']; ?></div>
                     </div>
                     <div class="col-sm-6">
                         <div class="img">
                             <img class="img-rounded" src="<?php echo $grav_url; ?>" alt="" />
                         </div>
                     </div>
                </div>
             </div>
         </div>
         <?php } ?>
        
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
       
