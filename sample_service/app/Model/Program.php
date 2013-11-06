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
}
?>
