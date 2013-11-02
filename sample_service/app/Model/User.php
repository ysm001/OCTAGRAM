<?php 
class User extends AppModel {
    public $hasMany = array(
	'Account' => array(
	    'className' => 'Account',
	    'foreignKey' => 'user_id'
	),
	'Program' => array(
	    'className' => 'Program',
	    'foreignKey' => 'user_id'
	)
    );
}
?>
