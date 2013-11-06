<?php
class BattleLog extends AppModel {
    public $id_list = array();

    function afterSave($created, $options = array())
    {
	if($created)
	{
	    $this->id_list[] = $this->getInsertID();
	}
	return true;
    }
}
?>
