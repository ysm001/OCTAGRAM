<?php 
class User extends AppModel {
    public $hasOne = array(
	'Account' => array(
	    'className' => 'Account',
	    'foreignKey' => 'user_id'
	),
	'Statistic' => array(
	    'className' => 'Statistic',
	    'foreignKey' => 'user_id'
	)
    );
    public $hasMany = array(
	'Program' => array(
	    'className' => 'Program',
	    'foreignKey' => 'user_id'
	)
    );
}
?>
