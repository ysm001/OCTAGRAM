<?php 
class User extends AppModel {
    public $hasOne = array(
        'Account' => array(
            'className' => 'Account',
            'foreignKey' => 'user_id'
        )
    );
    public $hasMany = array(
        'Program' => array(
            'className' => 'Program',
            'foreignKey' => 'user_id'
        )
    );

    public function afterFind($results, $primary = false) {
        foreach ($results as $key => $val) {
            if (!empty($val['User']['cc_name'])) {
                $results[$key]['User']['nickname'] = $val['User']['cc_name'];
            }
        }
        return $results;
    }
}
?>
