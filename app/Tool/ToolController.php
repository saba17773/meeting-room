<?php 

namespace App\Tool;

use App\Tool\ToolAPI;
use App\Security\SecurityAPI;

class ToolController extends \App\Base\BaseController

{
	public function index($request, $response, $args) 
	{
		if((new SecurityAPI)->PermissionSession()==true){
			return $this->renderView('pages/tool/index');
		}else{
			return $response->withRedirect('/security', 301);
		}
	    // return $this->renderView('pages/tool/index');
	}

	public function load($request, $response, $args) 
	{
	    return $response->withJson((new ToolAPI)->load());
	}

  	public function update($request, $response, $args)
	{
	    $parsedBody = $request->getParsedBody();
	    return $response->withJson(
	      (new ToolAPI)->update($parsedBody['tool_name'],$parsedBody['tool_id'])
	    );
  	}

  	public function create($request, $response, $args)
	{
	    $parsedBody = $request->getParsedBody();

	    return $response->withJson(
	      (new ToolAPI)->create($parsedBody['tool'])
	    );
  	}

  	public function remark($request, $response, $args) 
	{
		if((new SecurityAPI)->PermissionSession()==true){
			return $this->renderView('pages/tool/remark');
		}else{
			return $response->withRedirect('/security', 301);
		}
	    // return $this->renderView('pages/tool/remark');
	}

	public function loadremark($request, $response, $args) 
	{
	    return $response->withJson((new ToolAPI)->loadremark());
	}

	public function remark_create($request, $response, $args)
	{
	    $parsedBody = $request->getParsedBody();

	    if ($parsedBody['form_type']=='create') {
	    	return $response->withJson(
		      (new ToolAPI)->remark_create($parsedBody['remark'],$parsedBody['remark_type'])
		    );
	    }else{
	    	return $response->withJson(
		      (new ToolAPI)->remark_update($parsedBody['remark'],$parsedBody['remark_type'],$parsedBody['id'])
		    );
	    }
	    
  	}

  	public function loadremarktype($request, $response, $args) 
	{
	    return $response->withJson((new ToolAPI)->loadremarktype());
	}

}