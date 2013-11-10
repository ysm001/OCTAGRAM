<?php
class UsersController extends AppController {
    public $uses = array('User', 'Program');

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

    public function profile() {
        if (!empty($this->data)) {
            if ($this->User->save($this->data)) {
                $this->Session->setFlash("菫晏ｭ倥＠縺ｾ縺励◆", 'dissmiss', array('class' => 'alert alert-success alert-dismissable'));
            } else {
                $this->Session->setFlash("菫晏ｭ倥↓螟ｱ謨励＠縺ｾ縺励◆", 'default', array('class' => 'alert alert-danger'));
            }
            $this->redirect('/users/profile');
        } else {
            $user = $this->Auth->user();
            $user = $this->User->find('first', array('conditions' => array('User.id' => $user['id'])));
            $this->set('user', $user);
        }
    }

    public function disable_tutorial() {
	if ($this->request->is('post')) {
	    if (!empty($this->request->data)) {
		$this->User->id = $this->request->data['id'];
		if ( $this->User->saveField('tutorial_enabled', 0) ) {
		}
	    }
	}
    }

    private function update($data) {
        $user = $this->User->find('first', array('conditions' => array('username' => $data['username'])));

        $new = false;
        if ( !$user ) {
            $this->User->create();
            $new = true;
        }
        else {
            $data['id'] = $user['User']['id'];
            $data['Account']['id'] = $user['Account']['id'];
	    $data['tutorial_enabled'] = $user['User']['tutorial_enabled'];
        }
        $response =  $this->User->saveAll($data);

        if ( $new ) {
            $presets = $this->Program->getPresetPrograms($this->webroot, $this->User->getLastInsertID());
            if ( !empty($presets) ) {
                $this->Program->saveAll($presets);
            }
        }

        return $response;
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
	    'tutorial_enabled' => 1,
            'Account' => $account
        );

        $this->login($user);
    }

    private function loginWithFacebook($data) {
    }

    private function getUserIcon($email) {
        $default = "http://www.gravatar.com/avatar/00000000000000000000000000000000";
        $size = 200;
        $grav_url = "http://www.gravatar.com/avatar/" . md5( strtolower( trim( $email ) ) ) . "?d=" . urlencode( $default ). "&s=" . $size; 

        return $grav_url;
    }
}
