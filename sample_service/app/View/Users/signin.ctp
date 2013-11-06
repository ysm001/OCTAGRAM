<?php echo $this->Html->css(array('signin'), false, array('inline'=>false)); ?>

<?php $this->start('header'); ?>
<div class="bs-header" id="content">
  <div class="container">
    <div class="octagram-logo-container">
      <div class="octagram-logo-img-container">
        <?php echo $this->Html->image('octagram_logo.png', array('class' => 'octagram-logo-img'));?>
      </div>
      <div class="octagram-logo-text-container">
        <?php echo $this->Html->image('octagram_logo_text.png', array('class' => 'octagram-logo-text'));?>
      </div>
    </div>
    <div class="form-signin"> 
        <p><?php echo $this->Html->link('Sign in with Google', '/auth/google', array('class' => 'btn btn-lg btn-primary btn-block')); ?></p>
    </div>
  </div>
</div>
<?php $this->end(); ?>

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
