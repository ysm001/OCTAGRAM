<?php
class StatisticsController extends AppController {
    public $uses = array('Statistic', 'Program');
    public function push_result() {
	$response = false;

	if ($this->request->is('post')) {
	    $data = $this->request->data;

	    $program = $this->Program->findById($data['program_id']);

	    if ( $program ) {
		$statistic = $program['Statistic'];
		$statistic['combat_num']++;
		$statistic['total_damage'] += $data['damage'];
		$statistic['total_damaged'] += $data['damaged'];
		$statistic['kill_num'] += (boolean)$data['win'] ? 1 : 0;
		$statistic['score'] = $statistic['kill_num'];

		if ( $this->Statistic->save($statistic) ) {
		    $response = true;
		}
	    }
	}

        $this->response->body($response);
        return $this->response;
    }
}
?>
