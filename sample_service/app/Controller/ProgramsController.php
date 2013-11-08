<?php
class ProgramsController extends AppController {
    public $uses = array("User", "Program", "Statistic");

    public function create() {}
    public function add() {
        if ($this->request->is('post')) {
            $data = $this->request->data['program'];
            $override = $this->request->data['override'] == "true";

            $program = $this->Program->find('first', array('conditions' => array('Program.name' => $data['name'], 'Program.user_id' => $data['user_id'])));

            $alreadyExists = $program != null;
            $response = array('success' => false, 'exists' => $alreadyExists, 'override' => $override);

            if ( !$alreadyExists || $override ) {
                $data_url = $this->saveProgram($data['user_id'], $data['name'], $data['serialized_data'], $override);
                if ( $data_url ) {
                    $this->Program->create();

                    $data['data_url'] = $data_url;
		    $data['Statistic'] = $this->Statistic->create();
                    if ( $alreadyExists && $override ) $data['id'] = $program['Program']['id'];
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

            $user = $this->User->findById($id);
            if ( $user ) {
                $response = $user['Program'];
            }
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

    private function saveProgram($userId, $name, $data, $override = false) {
        $reldir = $this->getUserProgramDir($userId);
        $absdir = $_SERVER['DOCUMENT_ROOT'].$reldir;

        if ( file_exists($absdir) || mkdir($absdir, 0777, true) ) {
            $relpath = $reldir.$name;
            $abspath = $absdir.$name;
            if ( file_put_contents($abspath, $data, LOCK_EX) ) {
                return $relpath;
            }
        }

        return false;
    }

    private function registerPresetPrograms($user_id) {
    }

    private function getPresetPrograms($user_id) {
        $dir = $this->getPresetProgramDir();
        $programs = array();

	debug(file_exists($dir));
        if ( file_exists($dir) ) {
            $handle = opendir($dir);
            if ( $handle ) {
                while ( false !== ( $file = readdir($handle) ) ) {
                    $path = $dir.$file;

                    if ( !is_dir($path)  ) {
                        $program = array(
                            'name' => $file,
                            'data_url' => $path,
                            'user_id' => $user_id,
                            'is_preset' => true,
                            'modified' => date("Y-m-d H:i:s", filemtime($path))
                        );

                        $programs []= $program;
                    }
                }

                closedir($handle);
            }
        }

        return $programs;
    }

    private function getUserProgramDir($userId) { 
        return $this->webroot.APP_DIR.'/'.WEBROOT_DIR.'/files/programs/'.$userId.'/'; 
    }

    private function getPresetProgramDir() { 
        return $this->webroot.APP_DIR.'/'.WEBROOT_DIR.'/files/programs/presets'; 
    }
}
?>
