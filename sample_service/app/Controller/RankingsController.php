<?php
class RankingsController extends AppController {
    public $uses = array("User", "Program", "Statistic", "BattleLog");
    
    public $components = array('Paginator');

    public $paginate = array(
        'Program' => array(
            'limit' => 20,
            'order' => array('Program.modified' => 'desc'),
        ));

    public function index() {
        $this->Program->unbindModel(array('hasMany' => array('BattleLog')));        
        $programs = $this->Program->find('all', array(
                'limit' => 100,
                /* 'fields' => array('Program.id', 'Program.rate'), */
                'order' => array('Program.rate' => 'asc'), 
            ));
        $this->set('programs',$programs);
    }
    
    public function matching($playerId, $enemyId) {
	$this->set('playerId', $playerId);
	$this->set('enemyId', $enemyId);
    }
    
}
?>
