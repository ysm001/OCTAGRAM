OCTAGRAM Sample Web Service
======
## Setup Development Environment
### Place the directory OCTAGRAM DocumentRoot/OCTAGRAM
    1. If, after changing the location OCTAGRAM, it must also change Google/Facebool/Github project settings(redirect url etc...).

### Fix Opauth Plugin
    1. fix /app/Plugin/Opauth/Controller/OpauthAppController.php
    
public function __construct($request = null, $response = null) {
    parent::__construct($request, $response);
    App::import('Vendor/OPauth', 'OPauth'); // insert this line
    $this->autoRender = false;
}

### Import Schema
