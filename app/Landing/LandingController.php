<?php

namespace App\Landing;
use App\Landing\LandingAPI;
use App\Database\Connection;
use Wattanar\Sqlsrv;
use App\Security\SecurityAPI;

class LandingController extends \App\Base\BaseController
{
  	public function home($request, $response, $args)
	{
		return $this->renderView('pages/index');
	}
	public function calendar($request, $response, $args)
	{
		if((new SecurityAPI)->PermissionSession()==true){
			return $this->renderView('pages/calendar');
		}else{
			return $response->withRedirect('/security', 301);
		}
		// return $this->renderView('pages/calendar');
	}

	public function getBook1($request, $response, $args)
	{
		$conn = (new Connection)->dbConnect();

		$book_create = $_SESSION['user_id'];

	    $data_session =  Sqlsrv::rows(
	        $conn,
	        "SELECT *,U.email FROM [user] U 
	          LEFT JOIN permissioncompany P  ON U.permission_company=P.permission_id
	          WHERE P.permission_id = ?",[$_SESSION['user_permissionid']]
	    );

	    $session_per = $data_session[0]['permission_company'];
	    
	    $sql = "SELECT R.room_id
              ,R.room_name
              ,R.room_company
              ,R.room_floor
              ,R.room_max_seat
              ,R.room_tool
              ,R.room_picture
              ,R.room_sort
              ,R.room_active
              -- ,R.room_codecolor
              ,C.com_fname
              ,C.com_nname
	        FROM room R
	        JOIN company C ON R.room_company=C.com_id
	        WHERE R.room_active != 0 AND R.room_company IN ($session_per)
	        ORDER BY R.room_company,R.room_name ASC";
	            $result=sqlsrv_query($conn,$sql);
	            $rows = array();
	            while($res = sqlsrv_fetch_object($result)) {
	                $rows[] = array(
                        "id" => $res->room_id,
                        "title" => $res->room_name
                        // "eventColor" => $res->room_codecolor
                    );
	            }

            echo json_encode($rows);
	}
	public function getBook2($request, $response, $args)
	{
		$conn = (new Connection)->dbConnect();

		$book_create = $_SESSION['user_id'];

	    $data_session =  Sqlsrv::rows(
	        $conn,
	        "SELECT *,U.email FROM [user] U 
	          LEFT JOIN permissioncompany P  ON U.permission_company=P.permission_id
	          WHERE P.permission_id = ?",[$_SESSION['user_permissionid']]
	    );

	    $session_per = $data_session[0]['permission_company'];

	    $sql = "SELECT R.*,B.*,T.timeout_name,ST.status_description
	    		,CASE
					WHEN B.book_status <= 3 THEN '#FFFF00' 
					WHEN B.book_status = 4 THEN '#33CC33' 
				ELSE '#FF0000' END [room_color]
				FROM booking B
				LEFT JOIN room R ON B.book_room=R.room_id
				LEFT JOIN timeout T ON B.book_endtime=T.timeout
				LEFT JOIN status ST ON B.book_status=ST.status_id
				WHERE B.book_status NOT IN (5,6,7,8) AND R.room_company IN ($session_per)
				ORDER BY B.book_startdate ASC";
	            $result=sqlsrv_query($conn,$sql);
	            $rows = array();
	            while($res = sqlsrv_fetch_object($result)) {
	                $rows[] = array(
	                        "id" => $res->book_number,
	                        "resourceId" => $res->book_room,
	                        "roomname" => $res->room_name,
	                        "start" => $res->book_startdate." ".$res->book_starttime,
	                        "end" => $res->book_enddate." ".$res->timeout_name,
	                        "title" => $res->book_title,
	                        "user" => $res->book_user,
	                        "seat" => $res->book_seat,
	                        "startdate" => $res->book_startdate,
	                        "starttime" => $res->book_starttime,
	                        "enddate" => $res->book_enddate,
	                        "endtime" => $res->timeout_name,
	                        "bookstatus" => $res->book_status,
	                        "statusname" => $res->status_description,
	                        "eventColor" => $res->room_color
	                    );
	            }
            echo json_encode($rows);
	}

	public function load($request, $response, $args) 
	{
	    $numbersequence = $request->getQueryParams();
	    return $response->withJson((new LandingAPI)->load($numbersequence["numbersequence"]));
	}

}