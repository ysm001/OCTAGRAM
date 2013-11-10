<?php

class CombatsController extends AppController {

    public $uses = array("User", "Program");

    public $components = array('Paginator', 'Auth' => array('loginAction' => '/users/signin'), 'Session');
    public $paginate = array(
        'Program' => array(
            'limit' => 20,
            'order' => array('Program.modified' => 'desc'),
        )
    );

    public function beforeFilter() {
	parent::beforeFilter();
	$this->layout = 'bootstrap-with-header';
    }

    public function index() {
        $user = $this->Auth->user();
        $this->Paginator->settings = array(
            'limit' => 20,
            'order' => array('Program.modified' => 'desc'),
            'conditions' => array('Program.is_preset' => '0', 'Program.user_id !=' => $user['id'])
        );

        $this->set('programs',$this->Paginator->paginate('Program'));
    }

    public function matching($playerId, $enemyId) {
        $playerProgram = $this->Program->findById($playerId);
        $enemyProgram = $this->Program->findById($enemyId);

	$error = false;

	if ( $playerProgram && $enemyProgram ) {
	    if ( $playerProgram['Program']['user_id'] != $enemyProgram['Program']['user_id'] ) {
		$player = $this->User->findById($playerProgram['Program']['user_id']);
		$enemy = $this->User->findById($enemyProgram['Program']['user_id']);

		$this->set('player', $playerProgram);
		$this->set('enemy', $enemyProgram);
		$this->set('playerIconURL', $player['User']['icon_url']);
		$this->set('enemyIconURL', $enemy['User']['icon_url']);
	    } else {
		$this->setErrorFlash('自分のプログラムとは対戦できません。');
		$error = true;
	    }
	} else {
	    $this->setErrorFlash('IDが不正です。');
	    $error = true;
	}

	if ( $error ) $this->redirect(array('controller' => 'fronts', 'action' => 'home'));
    }
}
?>
