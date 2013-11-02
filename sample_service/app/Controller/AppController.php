<?php
/**
 * Application level Controller
 *
 * This file is application-wide controller file. You can put all
 * application-wide controller-related methods here.
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Controller
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

App::uses('Controller', 'Controller');
App::import('Vendor', 'oauth', array('file' => 'OAuth'.DS.'oauth_consumer.php'));

/**
 * Application Controller
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @package       app.Controller
 * @link http://book.cakephp.org/2.0/en/controllers.html#the-app-controller
 */
class AppController extends Controller {
    public $components = array('Auth', 'Session');
    public $helpers = array(
	'Session',
	'Html' => array('className' => 'TwitterBootstrap.BootstrapHtml'),
	'Form' => array('className' => 'TwitterBootstrap.BootstrapForm'),
	'Paginator' => array('className' => 'TwitterBootstrap.BootstrapPaginator'),
    );
    public function beforeFilter() {
	parent::beforeFilter();
	$this->layout = 'bootstrap';

	$this->set('authUser', $this->getAuthUser());
    }

    public function getAuthUser() {
	if ( isset($this->Session->read('Auth')['User']) ) {
	    return $this->Session->read('Auth')['User'];
	}
	else return null;
    }

    protected function setSuccessFlash($message) {
	$this->Session->setFlash(
	    $message,
	    'alert',
	    array(
		'plugin' => 'TwitterBootstrap',
		'class' => 'alert-success'
	    )
	);
    }

    protected function setErrorFlash($message) {
	$this->Session->setFlash(
	    $message,
	    'alert',
	    array(
		'plugin' => 'TwitterBootstrap',
		'class' => 'alert-error'
	    )
	);
    }
}
