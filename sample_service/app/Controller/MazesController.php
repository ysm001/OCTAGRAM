<?php

class MazesController extends AppController {

    public $uses = array("User");

    public function beforeFilter() {
        parent::beforeFilter();
        $this->layout = 'bootstrap-with-header';
    }

    public function index() {
    }

}
?>
