<?php 

namespace App\Room;

use App\Room\RoomAPI;
use App\Security\SecurityAPI;

class RoomController extends \App\Base\BaseController

{
	public function index($request, $response, $args) 
	{
		if((new SecurityAPI)->PermissionSession()==true){
			return $this->renderView('pages/room/index');
		}else{
			return $response->withRedirect('/security', 301);
		}
	    // return $this->renderView('pages/room/index');
	}

	public function load($request, $response, $args) 
	{
		$no = $request->getQueryParams();
		return $response->withJson((new RoomAPI)->load_bycomp($no["comp"]));
	}

	public function loadAll($request, $response, $args) 
	{
		return $response->withJson((new RoomAPI)->load());
	}

	public function loadcompany($request, $response, $args) 
	{
	    return $response->withJson((new RoomAPI)->loadcompany());
	}

	public function loadcompany_byper($request, $response, $args) 
	{
	    return $response->withJson((new RoomAPI)->loadcompany_byper());
	}

	public function loaddepartment($request, $response, $args) 
	{
	    return $response->withJson((new RoomAPI)->loaddepartment());
	}

	public function loadtoolAll($request, $response, $args) 
	{
	    return $response->withJson((new RoomAPI)->loadtoolAll());
	}

	public function create($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody); exit;
		if ($parsedBody['type']=='create') {
			
			if (isset($_FILES['file']['name'])) {
				if(move_uploaded_file($_FILES['file']['tmp_name'], 'picturemaster/room/' . $_FILES['file']['name'])){
					return $response->withJson(
				      (new RoomAPI)->create($parsedBody['room_name'],$parsedBody['room_company'],$parsedBody['room_floor'],$parsedBody['room_seat'],$parsedBody['room_tool'],$_FILES['file']['name'],$parsedBody['room_active'])
				    );
				}else{
					return [
						"result" => false,
						"message" => "Failed !"
					];
				}
			}else{
				$file = 'nopic.png';
				$room_tool = $this->convertforin(implode(',',$parsedBody["room_tool"]));
				return $response->withJson(
				    (new RoomAPI)->create($parsedBody['room_name'],$parsedBody['room_company'],$parsedBody['room_floor'],$parsedBody['room_seat'],$room_tool,$file,$parsedBody['room_active'])
				);
			}

		}else{

			if (isset($_FILES['file']['name'])) {
				if(move_uploaded_file($_FILES['file']['tmp_name'], 'picturemaster/room/' . $_FILES['file']['name'])){
					return $response->withJson(
				      (new RoomAPI)->update($parsedBody['room_name'],$parsedBody['room_company'],$parsedBody['room_floor'],$parsedBody['room_seat'],$parsedBody['room_tool'],$_FILES['file']['name'],$parsedBody['room_active'],$parsedBody['room_id'])
				    );
				}else{
					return [
						"result" => false,
						"message" => "Failed !"
					];
				}
			}else{
				$file = 'nofile';
				$room_tool = $this->convertforin(implode(',',$parsedBody["room_tool"]));
				return $response->withJson(
				    (new RoomAPI)->update($parsedBody['room_name'],$parsedBody['room_company'],$parsedBody['room_floor'],$parsedBody['room_seat'],$room_tool,$file,$parsedBody['room_active'],$parsedBody['room_id'])
				);
			}

		}
		
	}

	public function delete($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		// print_r($parsedBody); exit;
		$path = $parsedBody["room_picture"];
		unlink('picturemaster/room/'.$path);
		return $response->withJson(
			(new RoomAPI)->delete($parsedBody['room_id'])
		);
		
	}
}