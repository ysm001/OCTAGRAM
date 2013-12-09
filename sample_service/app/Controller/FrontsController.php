<?php
class FrontsController extends AppController {
    public $uses = array("User", "Program", "BattleLogAssociation", "BattleLog");
    public $components = array('Paginator');

    public function home() {
        $this->layout = "bootstrap-with-header";
        $this->Paginator->settings = array(
            'limit' => 20,
            'order' => array('BattleLogAssociation.modified' => 'desc')
        );

        $this->Program->unbindModel(array('hasMany' => array('BattleLog')));
        $this->set('associations', $this->Paginator->paginate('BattleLogAssociation'));
        $data = $this->getAuthUser();
        $this->set('tutorialEnabled', intval($this->User->findById($data['tutorial_enabled'])));
    }
}
?>
