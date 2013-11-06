    <!-- Marketing messaging and featurettes
    ================================================== -->
    <!-- Wrap the rest of the page in another container to center all the content. -->

    <?php echo $this->Html->css(array('home'), false, array('inline'=>false)); ?>

    <div class="container marketing">

      <!-- Three columns of text below the carousel -->
      <div class="row">
        <div class="col-lg-4">
	   <?php echo $this->Html->image('top_icon_programming.png', array('class' => 'img-circle top-icon', 'url' => array('controller' => 'programs', 'action' => 'create')));?>
          <h2>プログラミング</h2>
          <p>OCTAGRAMを用いてAIプログラミングを行います。</p>
        </div><!-- /.col-lg-4 -->
        <div class="col-lg-4">
	   <?php echo $this->Html->image('top_icon_vs.png', array('class' => 'img-circle top-icon', 'url' => array('controller' => 'combats', 'action' => 'index')));?>
          <h2>対戦</h2>
          <p>他のユーザのAIと対戦を行います。</p>
        </div><!-- /.col-lg-4 -->
        <div class="col-lg-4">
	   <?php echo $this->Html->image('top_icon_ranking.png', array('class' => 'img-circle top-icon', 'url' => array('controller' => 'pages', 'action' => 'home')));?>
          <h2>ランキング</h2>
          <p>ランキングを表示します。</p>
        </div><!-- /.col-lg-4 -->
      </div><!-- /.row -->


      <!-- START THE FEATURETTES -->

      <hr class="featurette-divider">

      <div class="row featurette">
        <div class="col-md-7">
          <h2 class="featurette-heading">First featurette heading. <span class="text-muted">It'll blow your mind.</span></h2>
          <p class="lead">Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.</p>
        </div>
        <div class="col-md-5">
	   <?php echo $this->Html->image('500x500.png', array('class' => 'featurette-image img-responsive'));?>
        </div>
      </div>

      <hr class="featurette-divider">

      <div class="row featurette">
        <div class="col-md-5">
	   <?php echo $this->Html->image('500x500.png', array('class' => 'featurette-image img-responsive'));?>
        </div>
        <div class="col-md-7">
          <h2 class="featurette-heading">Oh yeah, it's that good. <span class="text-muted">See for yourself.</span></h2>
          <p class="lead">Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.</p>
        </div>
      </div>

      <hr class="featurette-divider">

      <div class="row featurette">
        <div class="col-md-7">
          <h2 class="featurette-heading">And lastly, this one. <span class="text-muted">Checkmate.</span></h2>
          <p class="lead">Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.</p>
        </div>
        <div class="col-md-5">
	   <?php echo $this->Html->image('500x500.png', array('class' => 'featurette-image img-responsive'));?>
        </div>
      </div>

      <hr class="featurette-divider">

      <!-- /END THE FEATURETTES -->
