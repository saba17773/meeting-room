<?php 

namespace App\Layout;

use App\Layout\LayoutAPI;
use App\Security\SecurityAPI;

class LayoutController extends \App\Base\BaseController

{
	public function index($request, $response, $args) 
	{
		if((new SecurityAPI)->PermissionSession()==true){
			return $this->renderView('pages/layout/index');
		}else{
			return $response->withRedirect('/security', 301);
		}
	    // return $this->renderView('pages/layout/index');
	}

	public function load($request, $response, $args) 
	{
	    return $response->withJson( (new LayoutAPI)->load() );
	}

	public function loadpicture($request, $response, $args)
	{
		$idlayout = $request->getQueryParams();
		$datapicture = (new LayoutAPI)->loadpicture($idlayout['idlayout']);
		
		return json_encode([
          "result" => true,
          "message" => $datapicture[0]['layout_picture']
        ]);
	}

	public function create($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody);exit;
		if ($parsedBody['type']=='create') {

			if (isset($_FILES['file']['name'])) {
				if(move_uploaded_file($_FILES['file']['tmp_name'], 'picturemaster/layout/' . $_FILES['file']['name'])){
					return $response->withJson(
				      (new LayoutAPI)->create($parsedBody['layout_name'],$_FILES['file']['name'])
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
				    (new LayoutAPI)->create($parsedBody['layout_name'],$file)
				);
			}

		}else{

			if (isset($_FILES['file']['name'])) {
				if(move_uploaded_file($_FILES['file']['tmp_name'], 'picturemaster/layout/' . $_FILES['file']['name'])){
					return $response->withJson(
				      (new LayoutAPI)->update($parsedBody['layout_name'],$_FILES['file']['name'],$parsedBody['layout_id'])
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
				    (new LayoutAPI)->update($parsedBody['layout_name'],$file,$parsedBody['layout_id'])
				);
			}

		}
		
	}

	public function delete($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody); exit;
		$path = $parsedBody["layout_picture"];
		unlink('picturemaster/layout/'.$path);
		return $response->withJson(
			(new LayoutAPI)->delete($parsedBody['layout_id'])
		);
	}
}