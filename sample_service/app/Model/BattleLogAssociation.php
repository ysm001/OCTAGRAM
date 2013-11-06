<?php
class BattleLogAssociation extends AppModel{
    public $belongsTo = array(
	'ChallengerBattleLog' => array(
	    'className'    => 'BattleLog',
	    'foreignKey'   => 'challenger_id'
	),
	'DefenderBattleLog' => array(
	    'className'    => 'BattleLog',
	    'foreignKey'   => 'defender_id'
	)
    );
}
?>
