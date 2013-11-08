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
        $user = $this->Auth->user();
        $this->Paginator->settings = array(
            'conditions' => array('Program.user_id' => "<> {$user['id']}"),
        );
    }

    public function index() {
        $this->set('programs',$this->paginate('Program'));
    }

    public function matching($playerId, $enemyId) {
        $this->set('playerId', $playerId);
        $this->set('enemyId', $enemyId);
    }

}
?>
