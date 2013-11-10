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
            'foreignKey' => 'program_id',
            'limit' => '10',
            'order' => 'BattleLog.id desc'
        )
    );

    public function copyPresetProgramToUser($root, $absPresetPath, $userId) {
        $absDir = $this->getAbsoluteUserProgramDir($root, $userId);
        $relDir = $this->getUserProgramDir($root, $userId);

        $file = basename($absPresetPath);

        $absPath = $absDir.$file;
        $relPath = $relDir.$file;

        if ( !file_exists($absDir) ) {
            mkdir($absDir);
        } 
        copy($absPresetPath, $absPath);

        return array('abs' => $absPath, 'rel' => $relPath);
    }

    public function getPresetPrograms($root, $userId) {
        $relDir = $this->getPresetProgramDir($root);
        $absDir = $this->getAbsolutePresetProgramDir($root);
        $programs = array();

        if ( file_exists($absDir) ) {
            $handle = opendir($absDir);
            if ( $handle ) {
                while ( false !== ( $file = readdir($handle) ) ) {
                    $absPath = $absDir.'/'.$file;

                    if ( !is_dir($absPath) && $file != '.' && $file != '..') {
                        $path = $this->copyPresetProgramToUser($root, $absPath, $userId);
                        $program = array(
                            'name' => $file,
                            'data_url' => $path['rel'],
                            'user_id' => $userId,
                            'is_preset' => true,
                            'modified' => date("Y-m-d H:i:s", filemtime($path['abs']))
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

    public function afterFind($results, $primary = false) {
        foreach ($results as $key => $val) {
            if (isset($val['User']) && !empty($val['User']['cc_name'])) {
                $results[$key]['User']['nickname'] = $val['User']['cc_name'];
            }
            if (isset($val['cc_name']) && !empty($val['cc_name'])) {
                $results[$key]['nickname'] = $val['cc_name'];
            }

	    if ( isset($val['Program']) ) {
		$results[$key]['Statistics'] = $this->getStatistics( $val );
	    }
	    else if ( isset($val['id']) ) {
		$results[$key]['Statistics'] = $this->getStatistics( array('Program' => $val) );
	    }
        }

        return $results;
    }

    public function getRateByProgramId($programId) {
        $d = $this->findById($programId);
        return (!empty($d)) ? $d['Program']['rate'] : null;
    }

    public function getDefaultColor() {
	$rgb2hex = function ($rgb) {
	    $hex = "#";
	    $hex .= str_pad(dechex($rgb[0]), 2, "0", STR_PAD_LEFT);
	    $hex .= str_pad(dechex($rgb[1]), 2, "0", STR_PAD_LEFT);
	    $hex .= str_pad(dechex($rgb[2]), 2, "0", STR_PAD_LEFT);

	    return $hex;
	};

	return $rgb2hex(array(
	    mt_rand(0, 255),
	    mt_rand(0, 255),
	    mt_rand(0, 255)
	));
    }

    public function getRelatedLogAssociations($program) {
	App::import('Model','BattleLogAssociation');
	$association = new BattleLogAssociation();

	$this->unbindModel(array('hasMany' => array('BattleLog')));
	$this->BattleLog->unbindModel(array('belongsTo' => array('Program')));
	$challenger = $association->find('all', array('conditions' =>
	    array(
		'ChallengerBattleLog.program_id' => $program['Program']['id']
	    ),
	    'recursive' => 0
	));

	$defender = $association->find('all', array('conditions' =>
	    array(
		'DefenderBattleLog.program_id' => $program['Program']['id']
	    ),
	    'recursive' => 0
	));

	return array_merge($challenger, $defender);
    }

    public function getStatistics($program) {
	$result = array(
	    'battle_num' => 0,
	    'score_average' => 0,
	    'challenge_num' => 0,
	    'defence_num' => 0
	);

	if ( $program ) {
            $logs = $this->getRelatedLogAssociations($program);
	    $result['battle_num'] = count($logs);

	    if ( $result['battle_num'] != 0 ) {
		$scoreSum = 0;

		foreach ($logs as $log) {
	            $challengerLog = $log['ChallengerBattleLog'];
	            $defenderLog = $log['DefenderBattleLog'];

		    $myLog = null;
		    if ( $challengerLog['program_id'] == $program['Program']['id']) {
			$myLog = $challengerLog;
			$result['challenge_num']++;
		    }
		    else {
			$myLog = $defenderLog;
			$result['defence_num']++;
		    }

		    $scoreSum += $myLog['score'];
		}

		$result['score_average'] = (int)($scoreSum / $result['battle_num']);
	    }
	}

	return $result;
    }
}
?>
