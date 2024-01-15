<?php

namespace App\User;

use App\User\UserAPI;
use App\Security\SecurityAPI;

class UserController extends \App\Base\BaseController
{
  	public function login($request, $response, $args) {
		$csrf = $this->getCsrf();
		
		return $this->renderView('pages/login', [
			'name' => $csrf['name'],
			'value' => $csrf['value'],
			'key' => $csrf['key']
		]);
	}

	public function auth($request, $response, $args) {

		$parsedBody = $request->getParsedBody();

		$res = (new UserAPI)->isUser($parsedBody['username'], $parsedBody['password']);

		if ( $res === false ) {
			// return $this->renderView('pages/error/unauthorized', ['message' => 'Username หรือ Password ไม่ถูกต้อง']);
			echo json_encode(["status" => 404, "message" => "Username หรือ Password ไม่ถูกต้อง"]);
			exit();
		}

		$user = (new UserAPI)->getUserId($parsedBody['username']);
		$_SESSION['user_id'] 			= $user[0]['id'];
		$_SESSION['user_name'] 			= $user[0]['username'];
		$_SESSION['user_password'] 		= $user[0]['password'];
		$_SESSION['user_fname'] 		= $user[0]['fname'];
		$_SESSION['user_lname'] 		= $user[0]['lname'];
		$_SESSION['user_status'] 		= $user[0]['status'];
		$_SESSION['user_email'] 		= $user[0]['email'];
		$_SESSION['user_emailhead'] 	= $user[0]['email_head'];
		$_SESSION['user_tel'] 			= $user[0]['tell'];
		$_SESSION['user_company'] 		= $user[0]['company'];
		$_SESSION['user_department'] 	= $user[0]['department'];
		$_SESSION['user_permissionid'] 	= $user[0]['permission_company'];
		$_SESSION['user_employee']		= $user[0]['EMPID'];
		
		$insertLog = (new UserAPI)->InsertLog($user[0]['username'],$user[0]['EMPID'],'LOGIN_DATE');

		if($_SESSION['user_status']=='A'){
			echo json_encode(["status" => 301, "message" => "Username & Password Incorrect(Admin)"]);
		}else{
			echo json_encode(["status" => 300, "message" => "Username & Password Incorrect(User)"]);
		}
		
		// return $response->withRedirect('/', 301);
	}

	public function index($request, $response, $args) {
		if((new SecurityAPI)->PermissionSession()==true){
			return $this->renderView('pages/user/index');
		}else{
			return $response->withRedirect('/security', 301);
		}
	}

	public function profile($request, $response, $args) {
		return $this->renderView('pages/user/profile');
	}

	public function resetpassword($request, $response, $args) {
		return $this->renderView('pages/user/changpassword');
	}

	public function logout($request, $response, $args) {
		$insertLog = (new UserAPI)->InsertLog($_SESSION['user_name'],$_SESSION['user_employee'],'LOGOUT_DATE');
		session_destroy();
		return $response->withRedirect('/', 301);
	}

	public function load($request, $response, $args) 
	{
	    return $response->withJson((new UserAPI)->load());
	}

	public function load_emailhead($request, $response, $args)
	{
		return $response->withJson((new UserAPI)->load_emailhead());
	}
	
	public function loadpermission($request, $response, $args) 
	{
	    return $response->withJson((new UserAPI)->loadpermission());
	}

	public function loadstatus($request, $response, $args) 
	{
	    return $response->withJson((new UserAPI)->loadstatus());
	}
	
	public function companyload($request, $response, $args) 
	{
	    return $response->withJson((new UserAPI)->companyload());
	}

	public function update($request, $response, $args) {

		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody);exit;
		if ($parsedBody['active']==true) {
			$active = 1;
		}else{
			$active = 0;
		}

		return $response->withJson(
			(new UserAPI)->update(
				trim($parsedBody['password']), 
				$parsedBody['fname'], 
				$parsedBody['lname'], 
				$parsedBody['tell'], 
				$parsedBody['email'], 
				$active,
				$parsedBody['company'], 
				$parsedBody['department'], 
				$parsedBody['permission'], 
				$parsedBody['id']
			)
		);
		// print_r($parsedBody);
	}

	public function create($request, $response, $args) {
		
		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody);
		return $response->withJson(
			(new UserAPI)->create(
				trim($parsedBody['user_employee']),
				trim($parsedBody['username']),
				trim($parsedBody['password']), 
				$parsedBody['fname'], 
				$parsedBody['lname'], 
				$parsedBody['tel'], 
				$parsedBody['email'], 
				$parsedBody['company'], 
				$parsedBody['department'], 
				$parsedBody['permission'], 
				$parsedBody['status'],
				$parsedBody['emailhead'],
				$parsedBody['active'],
				$parsedBody['form_type'],
				$parsedBody['id']
			)
		);
	}

	public function update_email_head($request, $response, $args) {

		$parsedBody = $request->getParsedBody();

		return $response->withJson(
			(new UserAPI)->update_email_head(
				$parsedBody['email_head'],  
				$parsedBody['id']
			)
		);
	}

	public function profile_update($request, $response, $args) {

		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody);exit;

		return $response->withJson(
			(new UserAPI)->profile_update(
				$parsedBody['username'],
				$parsedBody['password'],  
				$parsedBody['tel']
			)
		);
	}

	public function changpassword($request, $response, $args) {

		$parsedBody = $request->getParsedBody();

		$res = (new UserAPI)->changpassword($parsedBody['email']);

		return $res;

	}

	public function employee($request, $response, $args) 
	{
	    return $response->withJson((new UserAPI)->employee());
	}
}