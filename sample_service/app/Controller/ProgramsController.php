<?php
class ProgramsController extends AppController {
    public function create() {}
    public function add() {
	if ($this->request->is('post')) {
            $program = $this->request->data;
	    $data_url = $this->saveProgram($program['name'], $program['serialized_data']);
	    if ( $data_url ) {
		$this->Program->create();

		$program['data_url'] = $data_url;

		if ($this->Program->save($program)) {
		    $this->response->body('program has been saved.');
		    return $this->response;
		} else {
		    $this->setSuccessFlash("fail: program save");
		}
	    }
	    else {
		$this->setSuccessFlash("fail: program save");
	    }
	}
    }

    private function saveProgram($name, $data) {
	$dir = $this->getProgramDir();

	if ( file_exists($dir) || mkdir($dir, 0777, true) ) {
	    $path = $dir.$name;
	    if ( file_put_contents($path, $data, LOCK_EX) ) {
		return $path;
	    }
	}

	return false;
    }

    private function getProgramDir() { 
	$authUser = $this->getAuthUser();
	return $authUser ? WWW_ROOT.'/files/programs/'.$authUser['id'].'/' : null; 
    }
}
?>
