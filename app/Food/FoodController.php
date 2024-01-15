<?php 

namespace App\Food;

use App\Food\FoodAPI;
use App\Security\SecurityAPI;

class FoodController extends \App\Base\BaseController

{
	public function index($request, $response, $args) 
	{
		if((new SecurityAPI)->PermissionSession()==true){
			return $this->renderView('pages/food/index');
		}else{
			return $response->withRedirect('/security', 301);
		}
	    // return $this->renderView('pages/food/index');
	}

	public function load($request, $response, $args) 
	{
	    return $response->withJson((new FoodAPI)->load());
	}

	public function loadpicture($request, $response, $args)
	{
		$idfood = $request->getQueryParams();
		$datapicture = (new FoodAPI)->loadpicture($idfood['idfood']);
		
		return json_encode([
          "result" => true,
          "message" => $datapicture[0]['food_picture']
        ]);
	}

	public function loadpicturedessert($request, $response, $args)
	{
		$idfood = $request->getQueryParams();
		$datapicture = (new FoodAPI)->loadpicturedessert($idfood['idfood']);
		
		return json_encode([
          "result" => true,
          "message" => $datapicture[0]['dessert_picture']
        ]);
	}

	public function create($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		
		if ($parsedBody['type']=='create') {

			if (isset($_FILES['file']['name'])) {
				if(move_uploaded_file($_FILES['file']['tmp_name'], 'picturemaster/food/' . $_FILES['file']['name'])){
					return $response->withJson(
				      (new FoodAPI)->create($parsedBody['food_name'],$parsedBody['food_price'],$_FILES['file']['name'])
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
				    (new FoodAPI)->create($parsedBody['food_name'],$parsedBody['food_price'],$file)
				);
			}

		}else{

			if (isset($_FILES['file']['name'])) {
				if(move_uploaded_file($_FILES['file']['tmp_name'], 'picturemaster/food/' . $_FILES['file']['name'])){
					return $response->withJson(
				      (new FoodAPI)->update($parsedBody['food_name'],$parsedBody['food_price'],$_FILES['file']['name'],$parsedBody['food_id'])
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
				    (new FoodAPI)->update($parsedBody['food_name'],$parsedBody['food_price'],$file,$parsedBody['food_id'])
				);
			}

		}
		
	}

	public function delete($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody); exit;
		$path = $parsedBody["food_picture"];
		unlink('picturemaster/food/'.$path);
		return $response->withJson(
			(new FoodAPI)->delete($parsedBody['food_id'])
		);
		
	}
}