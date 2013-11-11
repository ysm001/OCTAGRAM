<?php
class RankingsController extends AppController {
    public $uses = array("User", "Program", "BattleLog");

    public $components = array('Paginator');

    public $paginate = array(
        'Program' => array(
            'limit' => 20,
            'order' => array('Program.modified' => 'desc'),
        ));

    public function index() {
        $this->layout = 'bootstrap-with-header';

        $this->Program->unbindModel(array('hasMany' => array('BattleLog')));        
        $programs = $this->Program->find('all', array(
            'limit' => 100,
            /* 'fields' => array('Program.id', 'Program.rate'), */
            'order' => array('Program.rate' => 'desc'), 
        ));
        $rank = 1;
        foreach ($programs as $k => $v) {
            $programs[$k]['Program']['rank'] = $rank;
            if (isset($programs[$k + 1]) && $v['Program']['rate'] != $programs[$k + 1]['Program']['rate']) {
                $rank += 1;
            }
        }
        $this->set('programs',$programs);
    }

}
?>
