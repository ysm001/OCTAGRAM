<?php echo $this->Html->css(array('signin'), false, array('inline'=>false)); ?>

<div class="form-signin"> 
    <p><?php echo $this->Html->link('Sign in with Google', '/auth/google', array('class' => 'btn btn-lg btn-primary btn-block')); ?></p>
</div>
