<?php 

namespace App\Report;

use App\Report\ReportAPI;

class ReportController extends \App\Base\BaseController

{
	public function index($request, $response, $args) 
	{
	    return $this->renderView('pages/report/index');
	}
	public function report_room($request, $response, $args) 
	{
	    return $this->renderView('pages/report/report_room');
	}
	public function report_day($request, $response, $args) 
	{
	    return $this->renderView('pages/report/report_day');
	}
	public function load_day($request, $response, $args) 
	{
	    return $response->withJson((new ReportAPI)->load_day());
	}
}