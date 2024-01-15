<?php 

namespace App\Dessert;

use App\Dessert\DessertAPI;
use App\Security\SecurityAPI;

class DessertController extends \App\Base\BaseController

{
	public function index($request, $response, $args) 
	{
		if((new SecurityAPI)->PermissionSession()==true){
			return $this->renderView('pages/dessert/index');
		}else{
			return $response->withRedirect('/security', 301);
		}
	    // return $this->renderView('pages/dessert/index');
	}

	public function load($request, $response, $args) 
	{
		return $response->withJson((new DessertAPI)->load());
	}

	public function create($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();

		if ($parsedBody['type']=='create') {

			if (isset($_FILES['file']['name'])) {
				if(move_uploaded_file($_FILES['file']['tmp_name'], 'picturemaster/dessert/' . $_FILES['file']['name'])){
					return $response->withJson(
				      (new DessertAPI)->create($parsedBody['dessert_name'],$parsedBody['dessert_price'],$_FILES['file']['name'])
				    );
				}else{
					return [
						"result" => false,
						"message" => "Failed !"
					];
				}
			}else{
				$file = 'nopic.png';
				return $response->withJson(
				    (new DessertAPI)->create($parsedBody['dessert_name'],$parsedBody['dessert_price'],$file)
				);
			}

		}else{

			if (isset($_FILES['file']['name'])) {
				if(move_uploaded_file($_FILES['file']['tmp_name'], 'picturemaster/dessert/' . $_FILES['file']['name'])){
					return $response->withJson(
				      (new DessertAPI)->update($parsedBody['dessert_name'],$parsedBody['dessert_price'],$_FILES['file']['name'],$parsedBody['dessert_id'])
				    );
				}else{
					return [
						"result" => false,
						"message" => "Failed !"
					];
				}
			}else{
				$file = 'nofile';
				return $response->withJson(
				    (new DessertAPI)->update($parsedBody['dessert_name'],$parsedBody['dessert_price'],$file,$parsedBody['dessert_id'])
				);
			}

		}
		
	}

	public function delete($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody); exit;
		$path = $parsedBody["dessert_picture"];
		unlink('picturemaster/dessert/'.$path);
		return $response->withJson(
			(new DessertAPI)->delete($parsedBody['dessert_id'])
		);
	}
}