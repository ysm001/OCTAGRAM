<?php
class Program extends AppModel {
    public $belongsTo = array(
        'User' => array(
            'className' => 'User',
        )
    );

    public $hasMany = array(
	'BattleLog' => array(
	    'className' => 'BattleLog',
	    'foreignKey' => 'program_id'
	)
    );

    public function getPresetPrograms($root, $user_id) {
        $relDir = $this->getPresetProgramDir($root);
	$absDir = $this->getAbsolutePresetProgramDir($root);
        $programs = array();

        if ( file_exists($absDir) ) {
            $handle = opendir($absDir);
            if ( $handle ) {
                while ( false !== ( $file = readdir($handle) ) ) {
                    $relPath = $relDir.'/'.$file;
                    $absPath = $absDir.'/'.$file;

                    if ( !is_dir($absPath) && $file != '.' && $file != '..') {
                        $program = array(
                            'name' => $file,
                            'data_url' => $relPath,
                            'user_id' => $user_id,
                            'is_preset' => true,
                            'modified' => date("Y-m-d H:i:s", filemtime($absPath))
                        );

                        $programs []= $program;
                    }
                }

                closedir($handle);
            }
        }
        return $programs;
    }

    public function getUserProgramDir($root, $userId) { 
        return $root.APP_DIR.'/'.WEBROOT_DIR.'/files/programs/'.$userId.'/'; 
    }

    public function getAbsoluteUserProgramDir($root, $userId) {
	return $_SERVER['DOCUMENT_ROOT'].$this->getUserProgramDir($root, $userId);
    }

    public function getPresetProgramDir($root) { 
        return $root.APP_DIR.'/'.WEBROOT_DIR.'/files/programs/presets'; 
    }

    public function getAbsolutePresetProgramDir($root) {
	return $_SERVER['DOCUMENT_ROOT'].$this->getPresetProgramDir($root);
    }
}
?>
