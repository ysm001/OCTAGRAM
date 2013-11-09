<?php
class BattleLogsController extends AppController {
    public $uses = array('BattleLog', 'BattleLogAssociations', 'Program');
    public function save() {
	$response = false;

	if ($this->request->is('post')) {
	    $challengerData = $this->request->data['challenger'];
	    $defenderData = $this->request->data['defender'];

	    $challengerData['score'] = $this->BattleLog->calcScore($challengerData);
	    $defenderData['score'] = $this->BattleLog->calcScore($defenderData);

        $challengerProgram = $this->Program->findById($challengerData['program_id']);
        $defenderProgram = $this->Program->findById($defenderData['program_id']);        
        $challengerData['rate'] = $challengerProgram['Program']['rate'];
		$defenderData['rate'] = $defenderProgram['Program']['rate'];

        // update program rate
        $winProgramId = (!empty($challengerData['is_winner'])) ? $challengerData['program_id'] : $defenderData['program_id'];
        $loseProgramId = (!empty($challengerData['is_winner'])) ? $defenderData['program_id'] : $challengerData['program_id'];
        $this->BattleLog->updateProgramRate($winProgramId, $loseProgramId);

	    $data = array($challengerData, $defenderData);
        
	    if ( $this->BattleLog->saveAll($data) ) {
		$ids  = $this->BattleLog->id_list;
		$association = array(
		    'challenger_log_id' => $ids[0],
		    'defender_log_id' => $ids[1]
		);
        $rateArray = array(
            'before' => array('challengerRate' => $challengerData['rate'], 'defenderRate' => $defenderData['rate']),
            'after' => array('challengerRate' => $this->Program->getRateByProgramId($challengerData['program_id']), 'defenderRate' => $this->Program->getRateByProgramId($defenderData['program_id'])),
        );
		if ( $this->BattleLogAssociations->save($association) ) {
		    $response = array('playerScore' => $challengerData['score'], 'enemyScore' => $defenderData['score'], 'rate' => $rateArray);
		}
	    }
	}

        $this->response->body(json_encode($response));
        return $this->response;
    }
}
?>