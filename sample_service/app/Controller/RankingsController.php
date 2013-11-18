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
        $user = $this->Auth->user();
        $this->layout = 'bootstrap-with-header';

        $this->Program->unbindModel(array('hasMany' => array('BattleLog')));        
        $programs = $this->Program->find('all', array(
            'limit' => 100,
            'order' => array('Program.rate' => 'desc'), 
            'conditions' => array('Program.is_preset' => '0')
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

    /*
    public function index() {
        $user = $this->Auth->user();
        $this->Paginator->settings = array(
            'limit' => 20,
            'order' => array('Program.modified' => 'desc'),
            'conditions' => array('Program.is_preset' => '0', 'Program.user_id !=' => $user['id'])
        );

        $data = $this->Paginator->paginate('Program');

	if ( isset($this->request->named['sort']) ) {
	    $sort = $this->request->named['sort'];
	    if ( $sort === 'Statistics.score_average' || $sort === 'Statistics.battle_num' ) {
		$data = Set::sort($data, '{n}.'.$sort, $this->request->named['direction']);
	    }
	}

        $this->set('programs', $data);
    }
     */
}
?>
