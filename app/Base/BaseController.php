<?php

namespace App\Base;

use \Slim\Csrf\Guard;
use \Firebase\JWT\JWT;

class BaseController extends \App\Container\ContainerController
{
	public function renderView($path, $data = null)
	{
		$templates = new \League\Plates\Engine(__DIR__ . '/../../templates', 'tpl');
		if (isset($data)) {
			echo $templates->render($path, $data);
		} else {
			echo $templates->render($path);
		}
		return;
	}

	public function getCsrf()
	{
		$csrf = new Guard;
		$csrf->validateStorage();

		$keyName = $csrf->getTokenNameKey();
		$keyValue = $csrf->getTokenValueKey();
		$keyPair = $csrf->generateToken();

		return [
			'name' => $keyName,
			'value' => $keyValue,
			'key' => $keyPair
		];
	}

	public function createToken(array $payload = [])
	{
		$token = [
			'nbf' => time(),
			'exp' => time() + (24*60*60), // expire 1 day
			'user_data' => $payload
		];

		return JWT::encode($token, $this->_getSecretKey());
	}

	public function validateToken($token, $key)
	{
		return (array)JWT::decode($token, $key, array('HS256'));
	}

	public function convertforin($str)
	{
		$token = "";
        $a =explode(',', $str);
        foreach ($a as $value) {
            if($token===""){
                $token.=$value;
            }else{
                $token.=",".$value;
            }
        }
        return $token;
	}
}