<?php $this->extend('bootstrap-nonavbar'); ?>

<?php echo $this->Html->script(array('bootbox'), false, array('inline'=>false)); ?>
<?php echo $this->Html->script('flash'); ?>
<?php echo $this->Html->css('flash'); ?>
<?php echo $this->Html->css('style'); ?>
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
                   <li><?php echo $this->Html->link('OCTAGRAM', '/documents/index'); ?></li>
                   <li><?php echo $this->Html->link('Game', '/documents/game'); ?></li>
                   <li><?php echo $this->Html->link('Tutorial', '/documents/tutorial'); ?></li>
                   </ul>
                 </li>
                 <li><?php echo $this->Html->link('Profile', '/users/profile'); ?></li>
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
  <?php if ( $authUser ) { ?>
  <div id="uid" style="display:none"><?php echo $authUser['id'] ?></div>
  <?php } ?>
	<div id="webroot" style="display:none"><?= ROOT_URL?></div>
	<script type="text/javascript">
	    function getUserId() { return parseInt($('#uid').text()); }
	    function getRoot() { return $('#webroot').text(); }
	    function getRequestURL(controller, action) {return getRoot() + controller + '/' + action}
	</script>
<?php $this->end(); ?>
<?php echo $this->Html->script('utility'); ?>
