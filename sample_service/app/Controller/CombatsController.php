<?php

class CombatsController extends AppController {
    
    public $uses = array("User", "Program");
    
    public $components = array('Paginator');

    public function index() {
	$this->Paginator->settings = array(
	    'limit' => 20,
            'order' => array('Program.modified' => 'desc'),
	    'conditions' => array('Program.is_preset' => '0')
	);

        $this->set('programs',$this->Paginator->paginate('Program'));
    }
    
    public function matching($playerId, $enemyId) {
        $playerProgram = $this->Program->findById($playerId);
	$enemyProgram = $this->Program->findById($enemyId);

	$player = $this->User->findById($playerProgram['Program']['user_id']);
	$enemy = $this->User->findById($enemyProgram['Program']['user_id']);

	$this->set('player', $playerProgram);
	$this->set('enemy', $enemyProgram);
	$this->set('playerIconURL', $player['User']['icon_url']);
	$this->set('enemyIconURL', $enemy['User']['icon_url']);
    }
    
}
?>
