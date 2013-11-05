<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>
		<?php echo __('CakePHP: the rapid development php framework:'); ?>
		<?php echo $title_for_layout; ?>
	</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">

	<!-- Le styles -->
	<?php echo $this->Html->css('bootstrap.min'); ?>
	<?php echo $this->Html->css('bootstrap-responsive.min'); ?>
	<?php echo $this->Html->css('flash'); ?>
	<?php echo $this->Html->script('flash'); ?>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
	<?php echo $this->Html->script('bootstrap'); ?>

	<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

	<!-- Le fav and touch icons -->
	<!--
	<link rel="shortcut icon" href="/ico/favicon.ico">
	<link rel="apple-touch-icon-precomposed" sizes="144x144" href="/ico/apple-touch-icon-144-precomposed.png">
	<link rel="apple-touch-icon-precomposed" sizes="114x114" href="/ico/apple-touch-icon-114-precomposed.png">
	<link rel="apple-touch-icon-precomposed" sizes="72x72" href="/ico/apple-touch-icon-72-precomposed.png">
	<link rel="apple-touch-icon-precomposed" href="/ico/apple-touch-icon-57-precomposed.png">
	-->
	<?php
	echo $this->fetch('meta');
	echo $this->fetch('css');
	?>
</head>

<body>
        <div class="navbar navbar-default">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">Fight OCTAGRAM</a>
          </div>
          <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
	      <li><?php echo $this->Html->link('Home', '/pages/home'); ?></li>
	      <li><?php echo $this->Html->link('Document', '/documents/index'); ?></li>
              <li><a href="#">Share</a></li>
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

	<div class="container">
		<?php echo $this->Session->flash(); ?>

		<?php echo $this->fetch('content'); ?>
	</div> <!-- /container -->

	<?php if ( $authUser ) : ?>
	<div id="uid" style="display:none"><?= $authUser['id'] ?></div>
        <?php endif ?>
	<div id="webroot" style="display:none"><?= ROOT_URL ?></div>
	<script type="text/javascript">
	    function getUserId() { return parseInt($('#uid').text()); }
	    function getRoot() { return $('#webroot').text(); }
	    function getRequestURL(controller, action) {return getRoot() + controller + '/' + action}
	</script>

	<!-- Le javascript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<?php echo $this->fetch('script'); ?>
</body>
</html>
