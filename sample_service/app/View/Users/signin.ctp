<?php echo $this->Html->css(array('signin'), false, array('inline'=>false)); ?>

<?php $this->Html->scriptStart(array('inline'=>false)); ?>
window.onload = function() {
    var minHeight = 650;
    var height = document.documentElement.clientHeight > minHeight ? document.documentElement.clientHeight : minHeight;
    $('.bs-header').css('height', height);
    $(window).resize(function() {
      height = document.documentElement.clientHeight > height ? document.documentElement.clientHeight : height;
      width = document.documentElement.clientWidth;

      if (width > height) {
        $('.bs-header').css('height', height);
        $('.bs-header').css('width', "");
        $('.octagram-logo-img').css('width', 'auto');
        $('.octagram-logo-img').css('height', '100%');
        $('.octagram-logo-text').css('width', 'auto');
        $('.octagram-logo-text').css('height', '100%');
      }
      else {
        console.log("aaaaaaaaaaa");
        $('.bs-header').css('height', "");
        $('.bs-header').css('width', width);
        $('.octagram-logo-img').css('width', '60%');
        $('.octagram-logo-img').css('height', 'auto');
        $('.octagram-logo-text').css('width', '60%');
        $('.octagram-logo-text').css('height', 'auto');
      }
    });
}

$('a[href^="#"]').click(function(event) {
      var id = $(this).attr("href");
      var offset = 0;
      var target = $(id).offset().top - offset;
      $('html, body').animate({scrollTop:target}, 500);
      event.preventDefault();
      return false;
});

<?php $this->Html->scriptEnd(); ?>


<?php $this->start('header'); ?>
<div class="bs-header" id="content">
  <div class="container">
    <div class="octagram-logo-container">
      <div class="octagram-logo-img-container">
        <?php echo $this->Html->image('octagram_logo.png', array('class' => 'octagram-logo-img', 'url' => array('controller' => 'auth', 'action' => 'google')));?>
      </div>
      <div class="octagram-logo-text-container">
        <?php echo $this->Html->image('octagram_logo_text.png', array('class' => 'octagram-logo-text', 'url' => array('controller' => 'auth', 'action' => 'google')));?>
      </div>
    </div>
    <div class="form-signin"> 
        <?php echo $this->Html->link('Sign in with Google', '/auth/google', array('class' => 'btn-block signin-btn')); ?>
        <?php echo $this->Html->link('Features', '#feature1', array('class' => 'btn-block signin-btn')); ?>
    </div>
  </div>
</div>
<?php $this->end(); ?>

      <!-- START THE FEATURETTES -->

      <div id="feature1" class="row featurette">
        <div class="col-md-7">
          <h2 class="featurette-heading">Everyone is <br>Programmer.</h2>
          <p class="lead">誰もがプログラミングを行うことができるようになることを目指したサービスです。</p>
        </div>
        <div class="col-md-5">
           <!--
	   <?php echo $this->Html->image('500x500.png', array('class' => 'featurette-image img-responsive'));?>
           -->
        </div>
      </div>

      <div id="feature2" class="row featurette">
        <div class="col-md-5">
           <!--
	   <?php echo $this->Html->image('500x500.png', array('class' => 'featurette-image img-responsive'));?>
           -->
        </div>
        <div class="col-md-7">
          <h2 class="featurette-heading">Fun <br>Programming. </h2>
          <p class="lead">ゲームAIのプログラミングを通して、プログラミングの楽しさを知ることができます。</p>
        </div>
      </div>

      <div id="feature3" class="row featurette">
        <div class="col-md-7">
          <h2 class="featurette-heading">Easy <br>Programming. </h2>
          <p class="lead">視覚的かつ直感的なプログラミング言語OCTAGRAMを使う事によって、web上で簡単にプログラムを書くことができます。</p>
        </div>
        <div class="col-md-5">
           <!--
	   <?php echo $this->Html->image('500x500.png', array('class' => 'featurette-image img-responsive'));?>
           -->
        </div>
      </div>

      <!-- /END THE FEATURETTES -->
