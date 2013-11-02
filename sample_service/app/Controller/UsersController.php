<?php
class UsersController extends AppController {
    public function beforeFilter() {
	parent::beforeFilter();

	$this->Auth->allow('index', 'opauth_complete');
    }

    public function index() {
    }

    public function opauth_complete() {
	if ( isset($this->data['opauth']) ) {
	    $data = unserialize(base64_decode($this->data['opauth']));
	    debug($data);

	    $this->createWithGoogle($data);
	}
    }

    public function login() {
    }

    private function create($data) {
	$this->User->create();
	if ($this->User->saveAll($data)) {
	    $this->setSuccessFlash('success');
	    $this->redirect(array('action' => 'index'));
	} else {
	    $this->setErrorflash('failed');
	}
    }

    private function createWithGoogle($data) {
	$auth = $data['auth'];
	$info = $auth['info'];
	$uid  = $auth['uid'];
	$token= $auth['credentials']['token'];

	$account = array(
	    'provider' => $auth['provider'], 
	    'token' => $token,
	    'uid' => $uid,
	);

	$user = array(
	    'username' =>  $uid,
	    'password' => $token,
	    'nickname' => $info['name'],
	    'Account' => array($account)
	);

	$this->create($user);
    }

    private function createWithFacebook($data) {
    }
}
?>
