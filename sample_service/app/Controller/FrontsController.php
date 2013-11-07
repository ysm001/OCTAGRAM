<?php
class FrontsController extends AppController {
    public $uses = array("User", "Program", "BattleLogAssociation", "BattleLog");
    public $components = array('Paginator');
    public $paginate = array(
        'BattleLogAssociation' => array(
            'limit' => 20,
            'order' => array('BattleLogAssociation.modified' => 'desc'),
	)
    );

    public function home() {
	$this->Program->unbindModel(array('hasMany' => array('BattleLog')));
        $this->set('associations',$this->paginate('BattleLogAssociation'));
    }
}
?>
