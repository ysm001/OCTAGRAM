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

    public $belongsTo = array(
        'Program' => array(
            'className'    => 'Program',
            'foreignKey'   => 'program_id'
        )
    );

    public function calcScore($data) {
        $energyScore = (10000 - $data['consumed_energy']);
        if ( $energyScore < 0 ) $energyScore = 0;
        $bonus = $data['is_winner'] ? 1 : 0;

        $score = ($data['remaining_hp'] + 1 + $bonus) * $energyScore;

        return $score;
    }

}
?>
