<?php
class BattleLogAssociation extends AppModel{
    public $recursive = 3;
    public $belongsTo = array(
	'ChallengerBattleLog' => array(
	    'className'    => 'BattleLog',
	    'foreignKey'   => 'challenger_log_id'
	),
	'DefenderBattleLog' => array(
	    'className'    => 'BattleLog',
	    'foreignKey'   => 'defender_log_id'
	)
    );
}
?>
