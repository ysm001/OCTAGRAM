<?php
App::import('Vendor', 'oauth', array('file' => 'OAuth'.DS.'oauth_consumer.php'));
class UsersController extends AppController {
    //public $components = array('Auth');
    public function beforeFilter() {
	parent::beforeFilter();
	//debug($this->Auth);
    }

    public function opauth_complete() {
	debug($this->data);
	//debug($this->Session->read('Auth'));
    }

    public function login() {
    }
}
?>
