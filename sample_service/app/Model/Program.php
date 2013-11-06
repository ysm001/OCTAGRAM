<?php
class Program extends AppModel {
    public $belongsTo = array(
        'User' => array(
            'className' => 'User',
        )
    );

    public $hasOne = array(
	'Statistic' => array(
	    'className' => 'Statistic',
	    'foreignKey' => 'program_id'
	)
    );
}
?>
