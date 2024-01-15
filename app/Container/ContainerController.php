<?php

namespace App\Container;

use \Slim\Container;

class ContainerController
{
  protected $container;
	
	public function __construct(Container $container)
	{
			$this->container = $container;
  }
  
  public function _getSecretKey()
  {
    return $this->container->get('settings')['secret_key'];
  }
}