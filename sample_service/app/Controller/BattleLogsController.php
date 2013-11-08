<?php
class BattleLogsController extends AppController {
    public $uses = array('BattleLog', 'BattleLogAssociations');
    public function save() {
	$response = false;

	if ($this->request->is('post')) {
	    $challengerData = $this->request->data['challenger'];
	    $defenderData = $this->request->data['defender'];

	    $challengerData['score'] = $this->BattleLog->calcScore($challengerData);
	    $defenderData['score'] = $this->BattleLog->calcScore($defenderData);
	    
	    $data = array($challengerData,$defenderData);

	    if ( $this->BattleLog->saveAll($data) ) {
		$ids  = $this->BattleLog->id_list;
		$association = array(
		    'challenger_log_id' => $ids[0],
		    'defender_log_id' => $ids[1]
		);

		if ( $this->BattleLogAssociations->save($association) ) {
		    $response = array('playerScore' => $challengerData['score'], 'enemyScore' => $defenderData['score']);
		}
	    }
	}

        $this->response->body(json_encode($response));
        return $this->response;
    }
}
?>
