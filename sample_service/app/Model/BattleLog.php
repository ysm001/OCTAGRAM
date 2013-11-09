<?php

class BattleLog extends AppModel {
    public $id_list = array();

    private $defaultRate = 1500;
    private $ratio = 0.04;
    private $baseDelta = 16;

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

    function getDefaultRate()
    {
        return $this->defaultRate;
    }

    function getDelta($winProgramRate, $loseProgramRate)
    {
        return (int) ($this->baseDelta + ($loseProgramRate - $winProgramRate) * $this->ratio);
    }

    public function updateProgramRate($winProgramId, $loseProgramId)
    {
        $winProgram = $this->Program->findById($winProgramId);
        $loseProgram = $this->Program->findById($loseProgramId);
        $delta = $this->getDelta($winProgram['Program']['rate'], $loseProgram['Program']['rate']);
        $winProgram['Program']['rate'] = $winProgram['Program']['rate'] + $delta;
        $loseProgram['Program']['rate'] = $loseProgram['Program']['rate'] - $delta;
        $this->Program->saveAll(array($winProgram, $loseProgram));
    }
    
    function getUserRate($userId)
    {
        $this->Program->unbindModel(array('hasMany' => array('BattleLog')));
        $programs = $this->Program->find('all', array(
                'fields' => array('Program.id', 'Program.rate'),
                'order' => array('Program.created' => 'asc'), 
                'conditions' => array('Program.user_id' => $userId), 
            ));
        $programs = Set::combine($programs, '{n}.Program.id','{n}.Program.rate');
        
        $totalProgramNum = count($programs);
        $totalProgramRate = ($totalProgramNum > 0) ? array_sum($programs) : $this->getDefaultRate();
        return (int) ($totalProgramRate / $totalProgramNum);
    }

}

