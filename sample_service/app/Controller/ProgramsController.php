<?php
class ProgramsController extends AppController {
    public $uses = array("User", "Program", "Statistic", "BattleLog");

    public function create() {}
    public function add() {
        if ($this->request->is('post')) {
            $data = $this->request->data['program'];
            $override = $this->request->data['override'] == "true";

            $program = $this->Program->find('first', array('conditions' => array('Program.name' => $data['name'], 'Program.user_id' => $data['user_id'])));

            $alreadyExists = $program != null;
            $response = array('success' => false, 'exists' => $alreadyExists, 'override' => $override, 'preset' => $alreadyExists && $program['Program']['is_preset']);

            if ( !$alreadyExists || $override ) {
                $data_url = $this->saveProgram($data['user_id'], $data['name'], $data['serialized_data'], $override);
                if ( $data_url ) {
                    $this->Program->create();

                    $data['data_url'] = $data_url;
                    $data['Statistic'] = $this->Statistic->create();
                    if ( $alreadyExists && $override ){
                        $data['id'] = $program['Program']['id'];
                    } else {
                        $data['rate'] = $this->BattleLog->getDefaultRate();
                    }
                    $response['success'] = $this->Program->saveAll($data);
                }
            }
        }

        $this->response->body(json_encode($response));
        return $this->response;
    }

    public function owned_list() {
	$response = "";

        if ($this->request->is('get')) {
            $id = $this->request->query['user_id'];

	    $programs = $this->Program->find('all',
		array(
		    'conditions' => array('Program.user_id' => $id), 
		    'order' => array('Program.modified DESC')
		)
	    );
	    $fn = function($p) {return $p['Program']; };
	    $response = array_map($fn, $programs);
        }

        $this->response->body(json_encode($response));
        return $this->response;
    }

    public function load_data() {
        $response = "";

        if ($this->request->is('get')) {
            $id = $this->request->query['id'];

            $program = $this->Program->findById($id);
            if ( $program ) {
                $response = file_get_contents($_SERVER['DOCUMENT_ROOT'].$program['Program']['data_url']);
            }
        }

        $this->response->body(json_encode($response));
        return $this->response;
    }

    public function delete() {
        $response = "false";

        if ($this->request->is('post')) {
            $id = $this->request->data['id'];

            $program = $this->Program->findById($id);
            if ( $program ) {
                unlink($program['Program']['data_url']);
                $this->Program->delete($id);

                $response = "true";
            }
        }

        $this->response->body($response);
        return $this->response;
    }

    public function api($id = 0) {
        header("Content-Type; application/json: charset=utf-8");
        if ($this->request->is('get')) {
            $this->User->unbindModel(array('hasOne' => array('Accout')));
            $this->User->unbindModel(array('hasMany' => array('Program')));
            $this->Program->recursive = 2;
            echo json_encode($this->Program->findById($id));
        }
        exit();
    } 

    private function saveProgram($userId, $name, $data, $override = false) {
        $reldir = $this->Program->getUserProgramDir($this->webroot, $userId);
        $absdir = $this->Program->getAbsoluteUserProgramDir($this->webroot, $userId);

        if ( file_exists($absdir) || mkdir($absdir, 0777, true) ) {
            $relpath = $reldir.$name;
            $abspath = $absdir.$name;
            if ( file_put_contents($abspath, $data, LOCK_EX) ) {
                return $relpath;
            }
        }

        return false;
    }
}
?>
