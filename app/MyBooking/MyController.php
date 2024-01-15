<?php 

namespace App\MyBooking;

use App\MyBooking\MyAPI;

class MyController extends \App\Base\BaseController

{
	public function index($request, $response, $args) 
	{
	    return $this->renderView('pages/mybooking/index');
	}

	public function load($request, $response, $args) 
	{
	    return $response->withJson((new MyAPI)->load());
	}

	public function loadcancel($request, $response, $args) 
	{
		$book_number = $request->getQueryParams();
	    return $response->withJson((new MyAPI)->loadcancel($book_number["book_number"]));
	}

	public function loadfood($request, $response, $args) 
	{
		$numbersequence = $request->getQueryParams();
	    return $response->withJson((new MyAPI)->loadfood($numbersequence["numbersequence"]));
	}

	public function loaddessert($request, $response, $args) 
	{
		$numbersequence = $request->getQueryParams();
	    return $response->withJson((new MyAPI)->loaddessert($numbersequence["numbersequence"]));
	}

	public function loadlayout($request, $response, $args) 
	{
		$numbersequence = $request->getQueryParams();
	    return $response->withJson((new MyAPI)->loadlayout($numbersequence["numbersequence"]));
	}

	public function loadsupport($request, $response, $args) 
	{
		$numbersequence = $request->getQueryParams();
	    return $response->withJson((new MyAPI)->loadsupport($numbersequence["numbersequence"]));
	}

	public function mixs_approve($request, $response, $args) 
	{
		$numbersequence = $request->getQueryParams();
	    return $response->withJson((new MyAPI)->mixs_approve($numbersequence["numbersequence"]));
	}

}