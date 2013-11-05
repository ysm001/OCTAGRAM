<?php

class CombatsController extends AppController {
    
    public $uses = array("User", "Program");
    
    public $components = array('Paginator');

    public $paginate = array(
        'Program' => array(
            'limit' => 20,
            'order' => array('Program.modified' => 'desc'),
        ));

    public function index() {
        $this->set('programs',$this->paginate('Program'));
    }
    
    public function matching($playerId, $enemyId) {
	$this->set('playerId', $playerId);
	$this->set('enemyId', $enemyId);
    }
    
}
