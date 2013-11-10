<?php $this->extend('bootstrap-nonavbar'); ?>

<?php echo $this->Html->script(array('bootbox'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script('flash'); ?>
<?php echo $this->Html->css('flash'); ?>
<?php echo $this->Html->css('style'); ?>
<?php echo $this->Html->css('tutorial'); ?>
<?php echo $this->Html->script('tutorial'); ?>
<?php echo $this->Html->script('utility'); ?>
<?php echo $this->Html->script('lib/underscore'); ?>
<?php echo $this->Html->script('lib/backbone'); ?>
<?php if ( $authUser ) { ?>
<div id="uid" style="display:none"><?php echo $authUser['id'] ?></div>
<?php } ?>
<div id="webroot" style="display:none"><?= ROOT_URL?></div>
<script type="text/javascript">
  function getUserId() { return parseInt($('#uid').text()); }
  function getRoot() { return $('#webroot').text(); }
  function getRequestURL(controller, action) {return getRoot() + controller + '/' + action}
</script>
<?php echo $this->Html->css('docs'); ?>
<?php $this->start('header'); ?>
        <div class="navbar navbar-default">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
	    <a class="navbar-brand" href="#"><?php echo $serviceName; ?></a>
          </div>
          <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                <li><?php echo $this->Html->link('Home', '/fronts/home'); ?></li>
                <li class="dropdown">
                   <a href="#" class="dropdown-toggle" data-toggle="dropdown">Document<b class="caret"></b></a>
                   <ul class="dropdown-menu">
                   <li><?php echo $this->Html->link('ゲームルール', '/documents/game', array('id' => 'gamerule-link')); ?></li>
                   <li><?php echo $this->Html->link('プログラムの作り方', '/documents/tutorial', array('id' => 'tutorial-link')); ?></li>
                   </ul>
                 </li>
                 <li><?php echo $this->Html->link('Profile', '/users/profile'); ?></li>
                 <li><?php echo $this->Html->link('Tutorial', 'javascript:void(0)', array('onclick' => 'new Tutorial().show()')); ?></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <?php if ( $authUser ) :  ?>
                        <?php echo $authUser['nickname'] ?>
                        <?php else :  ?>           
                	  Guest
                        <?php endif  ?>           
                 <b class="caret"></b></a>
                 <ul class="dropdown-menu">
	           <li><?php echo $this->Html->link('Logout', '/users/signout'); ?></li>
                 </ul>
              </li>
            </ul>
          </div>
        </div>
<?php $this->end(); ?>

  <div id="overlay"></div>
	<div class="container">
    <?php echo $this->Session->flash(); ?>

		<?php echo $this->fetch('content'); ?>
	</div> <!-- /container -->
<?php $this->start('footer'); ?>
<?php $this->end(); ?>
