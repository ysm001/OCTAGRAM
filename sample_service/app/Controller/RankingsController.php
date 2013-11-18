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

        $user = $this->Auth->user();
        $this->Paginator->settings = array(
            'limit' => 20,
            'order' => array('Program.rate' => 'desc'),
            'conditions' => array('Program.is_preset' => '0')
        );

        $data = $this->Paginator->paginate('Program');

	if ( isset($this->request->named['sort']) ) {
	    $sort = $this->request->named['sort'];
	    if ( $sort === 'Statistics.score_average' || $sort === 'Statistics.battle_num' ) {
		$data = Set::sort($data, '{n}.'.$sort, $this->request->named['direction']);
	    }
	}

        $this->set('programs', array_filter($data, function($d) { return $d['Statistics']['battle_num'] != 0; }));
    }
}
?>
