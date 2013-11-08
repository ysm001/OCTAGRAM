<?php
class UsersController extends AppController {
    public function beforeFilter() {
	parent::beforeFilter();

	$this->Auth->allow('index', 'signin', 'opauth_complete');

	if ( $this->action == 'signin' ) {
	    $this->layout = 'bootstrap-nonavbar';
	}
    }

    public function index() {
    }

    public function opauth_complete() {
	if ( isset($this->data['opauth']) ) {
	    $data = unserialize(base64_decode($this->data['opauth']));

	    $this->loginWithGoogle($data);
	}
    }

    public function signin() {
    }

    public function signout() {
	$this->redirect($this->Auth->logout());
    }

    private function update($data) {
	$user = $this->User->find('first', array('conditions' => array('username' => $data['username'])));

	if ( !$user ) {
	    $this->User->create();

	    $statistic = array(
		'score' => 0,
		'winning_percentage' => 0.0,
		'combat_num' => 0
	    );

	    $data['Statistic'] = $statistic;
	}
	else {
	    $data['id'] = $user['User']['id'];
	    $data['Account']['id'] = $user['Account']['id'];
	}
	return $this->User->saveAll($data);
    }

    private function login($data) {
	$method = null;

	if ($this->update($data)) {
	    $data['id'] = $this->User->id;
	    if ($this->Auth->login($data)) {
		$this->redirect(array('controller' => 'fronts', 'action' => 'home'));
	    }
	    else {
		$this->setErrorFlash('failed: login');
	    }
	} else {
	    $this->setErrorflash('failed: create account');
	}
    }

    private function loginWithGoogle($data) {
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
	    'email' => $info['email'],
	    'icon_url' => $this->getUserIcon($info['email']),
	    'Account' => $account
	);

	$this->login($user);
    }

    private function loginWithFacebook($data) {
    }

    private function getUserIcon($email) {
	$default = "http://www.somewhere.com/homestar.jpg";
	$size = 200;
	$grav_url = "http://www.gravatar.com/avatar/" . md5( strtolower( trim( $email ) ) ) . "?d=" . urlencode( $default ). "&s=" . $size; 

	return $grav_url;
    }
}
