<?php

namespace App\Report;

use App\Database\Connection;
use Wattanar\Sqlsrv;

class ReportAPI
{
  	public function getAll($id) {
	    $conn = (new Connection)->dbConnect();
	    return Sqlsrv::rows(
	      $conn,
	      "SELECT B.book_number
	                ,B.book_room
	                ,BS.book_startdate
	                ,BE.book_enddate
	                ,B.book_starttime
	                ,TI.timeout_name[book_endtime]
	                ,B.book_title
	                ,B.book_user
	                ,B.book_seat
	                ,B.book_support
	                ,B.book_food
	                ,B.book_dessert
	                ,B.book_layout
	                ,B.book_create
	                ,B.book_remark
	                ,B.book_status
	                ,R.room_name
	                ,R.room_company
	                ,S.status_description
	                ,U.fname+' '+U.lname [fullname]
	                ,D.dep_name
	                ,C.com_nname
	        FROM  booking B
	        LEFT JOIN room R ON B.book_room = R.room_id
	        LEFT JOIN status S ON B.book_status = S.status_id
	        LEFT JOIN [user] U ON B.book_create = U.id
	        LEFT JOIN department D ON U.department=D.dep_id
	        LEFT JOIN company C ON R.room_company=C.com_id
	        LEFT JOIN timeout TI ON B.book_endtime=TI.timeout
	        JOIN 
	         (
	          SELECT MIN(book_startdate)book_startdate,book_number
	          FROM booking BS
	          WHERE book_status != 8
	          GROUP BY BS.book_number
	         )BS
	        ON BS.book_number = B.book_number
	        JOIN 
	         (
	          SELECT MAX(book_enddate)book_enddate,book_number
	          FROM booking BE
	          WHERE book_status != 8
	          GROUP BY BE.book_number
	         )BE
	        ON BE.book_number = B.book_number
	        WHERE B.book_number = ?
	        AND B.book_status != 8
	        GROUP BY B.book_number
	                ,B.book_room
	                ,BS.book_startdate
	                ,BE.book_enddate
	                ,B.book_starttime
	                ,TI.timeout_name
	                ,B.book_title
	                ,B.book_user
	                ,B.book_seat
	                ,B.book_support
	                ,B.book_food
	                ,B.book_dessert
	                ,B.book_layout
	                ,B.book_create
	                ,B.book_remark
	                ,B.book_status
	                ,R.room_name
	                ,R.room_company
	                ,S.status_description
	                ,U.fname
	                ,U.lname
	                ,D.dep_name
	                ,C.com_nname
	        ORDER BY B.book_number DESC",[$id]
	    );
  	}

  	public function getAllbyId($id) {
	    $conn = (new Connection)->dbConnect();
	    return Sqlsrv::rows(
	      $conn,
	      "SELECT B.book_number
	                ,B.book_room
	                ,B.book_startdate
	                ,B.book_enddate
	                ,B.book_starttime
	                ,TI.timeout_name[book_endtime]
	                ,B.book_title
	                ,B.book_user
	                ,B.book_seat
	                ,B.book_support
	                ,B.book_food
	                ,B.book_dessert
	                ,B.book_layout
	                ,B.book_create
	                ,B.book_remark
	                ,B.book_status
	                ,R.room_name
	                ,R.room_company
	                ,S.status_description
	                ,U.fname+' '+U.lname [fullname]
	                ,D.dep_name
	                ,C.com_nname
	        FROM  booking B
	        LEFT JOIN room R ON B.book_room = R.room_id
	        LEFT JOIN status S ON B.book_status = S.status_id
	        LEFT JOIN [user] U ON B.book_create = U.id
	        LEFT JOIN department D ON U.department=D.dep_id
	        LEFT JOIN company C ON R.room_company=C.com_id
	        LEFT JOIN timeout TI ON B.book_endtime=TI.timeout
	        WHERE B.book_id IN ($id)
	        AND B.book_status != 8
	        GROUP BY B.book_number
	                ,B.book_room
	                ,B.book_startdate
	                ,B.book_enddate
	                ,B.book_starttime
	                ,TI.timeout_name
	                ,B.book_title
	                ,B.book_user
	                ,B.book_seat
	                ,B.book_support
	                ,B.book_food
	                ,B.book_dessert
	                ,B.book_layout
	                ,B.book_create
	                ,B.book_remark
	                ,B.book_status
	                ,R.room_name
	                ,R.room_company
	                ,S.status_description
	                ,U.fname
	                ,U.lname
	                ,D.dep_name
	                ,C.com_nname
	        ORDER BY B.book_number DESC"
	    );
  	}

  	public function load_day() {
	    $conn = (new Connection)->dbConnect();
	    $getdate = date('Y-m-d');
	    $sql = "SELECT TOP 100 B.book_number
		                ,B.book_room
		                ,B.book_startdate
		                ,B.book_enddate
		                ,B.book_starttime
		                ,CASE
							WHEN LEN(SUBSTRING(B.book_endtime, 1, 2)+1) = 1 THEN 
								CASE 
									WHEN SUBSTRING(B.book_endtime, 4, 5)='59' THEN '0'+CONVERT(varchar(10), SUBSTRING(B.book_endtime, 1, 2)+1)+':00'
									WHEN SUBSTRING(B.book_endtime, 4, 5)='29' THEN '0'+ SUBSTRING(B.book_endtime, 1, 2)+':30'
								END
							WHEN LEN(SUBSTRING(B.book_endtime, 1, 2)+1) = 2 THEN 
								CASE 
									WHEN SUBSTRING(B.book_endtime, 4, 5)='59' THEN CONVERT(varchar(10), (CONVERT(INT, SUBSTRING(B.book_endtime, 1, 2))+1))+':00'
									WHEN SUBSTRING(B.book_endtime, 4, 5)='29' THEN SUBSTRING(B.book_endtime, 1, 2)+':30'
								END
						END [book_endtime]
		                ,B.book_title
		                ,B.book_user
		                ,B.book_seat
		                ,B.book_support
		                ,B.book_food
		                ,B.book_dessert
		                ,B.book_layout
		                ,B.book_create
		                ,B.book_remark
		                ,B.book_status
		                ,R.room_name
		                ,R.room_company
		                ,S.status_description
		                ,U.fname+' '+U.lname [fullname]
		                ,D.dep_name
		                ,U.tell
		                ,C.com_nname
		                ,C.com_fname
		        FROM  booking B
		        LEFT JOIN room R ON B.book_room = R.room_id
		        LEFT JOIN status S ON B.book_status = S.status_id
		        LEFT JOIN [user] U ON B.book_create = U.id
		        LEFT JOIN department D ON U.department=D.dep_id
		        LEFT JOIN company C ON R.room_company=C.com_id
		        LEFT JOIN timeout TI ON B.book_endtime=TI.timeout
		        WHERE B.book_startdate = '$getdate'
		        AND B.book_status <= 4
		        ORDER BY B.book_startdate DESC";

		    if (isset($_GET['filterscount']))
	        {
	            $filterscount = $_GET['filterscount'];
	            
	            if ($filterscount > 0)
	            {
	                $sql = "";
	                $where = "WHERE (";
	                $tmpdatafield = "";
	                $tmpfilteroperator = "";
	                for ($i=0; $i < $filterscount; $i++)
	                {
	                    // get the filter's value.
	                    $filtervalue = $_GET["filtervalue" . $i];
	                    // get the filter's condition.
	                    $filtercondition = $_GET["filtercondition" . $i];
	                    // get the filter's column.
	                    $filterdatafield = $_GET["filterdatafield" . $i];
	                    // get the filter's operator.
	                    $filteroperator = $_GET["filteroperator" . $i];

	                    if ($filterdatafield === 'CheckBuild') {
	                        if ((string)$filtervalue === 'true') {
	                            $tmp_value = 1;
	                        } else {
	                            $tmp_value = 0;
	                        }
	                        $filtervalue = $tmp_value;
	                    }
	                    
	                    if ($tmpdatafield == "")
	                    {
	                        $tmpdatafield = $filterdatafield;           
	                    }
	                    else if ($tmpdatafield <> $filterdatafield)
	                    {
	                        $where .= ")AND(";
	                    }
	                    else if ($tmpdatafield == $filterdatafield)
	                    {
	                        if ($tmpfilteroperator == 0)
	                        {
	                            $where .= " AND ";
	                        }
	                        else $where .= " OR ";  
	                    }
	                    
	                    // build the "WHERE" clause depending on the filter's condition, value and datafield.
	                    switch($filtercondition)
	                    {
	                        case "CONTAINS":
	                            $where .= " " . $filterdatafield . " LIKE '%" . $filtervalue ."%'";
	                            break;
	                        case "DOES_NOT_CONTAIN":
	                            $where .= " " . $filterdatafield . " NOT LIKE '%" . $filtervalue ."%'";
	                            break;
	                        case "EQUAL":
	                            $where .= " " . $filterdatafield . " = '" . $filtervalue ."'";
	                            break;
	                        case "NOT_EQUAL":
	                            $where .= " " . $filterdatafield . " <> '" . $filtervalue ."'";
	                            break;
	                        case "GREATER_THAN":
	                            $where .= " " . $filterdatafield . " > '" . $filtervalue ."'";
	                            break;
	                        case "LESS_THAN":
	                            $where .= " " . $filterdatafield . " < '" . $filtervalue ."'";
	                            break;
	                        case "GREATER_THAN_OR_EQUAL":
	                            $where .= " " . $filterdatafield . " >= '" . $filtervalue ."'";
	                            break;
	                        case "LESS_THAN_OR_EQUAL":
	                            $where .= " " . $filterdatafield . " <= '" . $filtervalue ."'";
	                            break;
	                        case "STARTS_WITH":
	                            $where .= " " . $filterdatafield . " LIKE '" . $filtervalue ."%'";
	                            break;
	                        case "ENDS_WITH":
	                            $where .= " " . $filterdatafield . " LIKE '%" . $filtervalue ."'";
	                            break;
	                    }
	                                    
	                    if ($i == $filterscount - 1)
	                    {
	                        $where .= ")";
	                    }
	                    
	                    $tmpfilteroperator = $filteroperator;
	                    $tmpdatafield = $filterdatafield;           
	                }
	                // build the query.
	                $sql = "SELECT TOP 100 * FROM ( 
	                    SELECT B.book_number
		                ,B.book_room
		                ,B.book_startdate
		                ,B.book_enddate
		                ,B.book_starttime
		                ,CASE
							WHEN LEN(SUBSTRING(B.book_endtime, 1, 2)+1) = 1 THEN 
								CASE 
									WHEN SUBSTRING(B.book_endtime, 4, 5)='59' THEN '0'+CONVERT(varchar(10), SUBSTRING(B.book_endtime, 1, 2)+1)+':00'
									WHEN SUBSTRING(B.book_endtime, 4, 5)='29' THEN '0'+ SUBSTRING(B.book_endtime, 1, 2)+':30'
								END
							WHEN LEN(SUBSTRING(B.book_endtime, 1, 2)+1) = 2 THEN 
								CASE 
									WHEN SUBSTRING(B.book_endtime, 4, 5)='59' THEN CONVERT(varchar(10), (CONVERT(INT, SUBSTRING(B.book_endtime, 1, 2))+1))+':00'
									WHEN SUBSTRING(B.book_endtime, 4, 5)='29' THEN SUBSTRING(B.book_endtime, 1, 2)+':30'
								END
						END [book_endtime]
		                ,B.book_title
		                ,B.book_user
		                ,B.book_seat
		                ,B.book_support
		                ,B.book_food
		                ,B.book_dessert
		                ,B.book_layout
		                ,B.book_create
		                ,B.book_remark
		                ,B.book_status
		                ,R.room_name
		                ,R.room_company
		                ,S.status_description
		                ,U.fname+' '+U.lname [fullname]
		                ,D.dep_name
		                ,U.tell
		                ,C.com_nname
		                ,C.com_fname
		        FROM  booking B
		        LEFT JOIN room R ON B.book_room = R.room_id
		        LEFT JOIN status S ON B.book_status = S.status_id
		        LEFT JOIN [user] U ON B.book_create = U.id
		        LEFT JOIN department D ON U.department=D.dep_id
		        LEFT JOIN company C ON R.room_company=C.com_id
		        LEFT JOIN timeout TI ON B.book_endtime=TI.timeout
		        WHERE B.book_status <= 4
	                    ) X " . $where . "ORDER BY X.book_startdate DESC"; 
	            }
	        }

	    	$query = Sqlsrv::rows(
	    		$conn,
	    		$sql
	    	);

	    	return $query;
    // return Sqlsrv::rows(
    //   $conn,
    //   "SELECT B.book_number
	   //              ,B.book_room
	   //              ,B.book_startdate
	   //              ,B.book_enddate
	   //              ,B.book_starttime
	   //              ,TI.timeout_name[book_endtime]
	   //              ,B.book_title
	   //              ,B.book_user
	   //              ,B.book_seat
	   //              ,B.book_support
	   //              ,B.book_food
	   //              ,B.book_dessert
	   //              ,B.book_layout
	   //              ,B.book_create
	   //              ,B.book_remark
	   //              ,B.book_status
	   //              ,R.room_name
	   //              ,R.room_company
	   //              ,S.status_description
	   //              ,U.fname+' '+U.lname [fullname]
	   //              ,D.dep_name
	   //              ,U.tell
	   //              ,C.com_nname
	   //              ,C.com_fname
	   //      FROM  booking B
	   //      LEFT JOIN room R ON B.book_room = R.room_id
	   //      LEFT JOIN status S ON B.book_status = S.status_id
	   //      LEFT JOIN [user] U ON B.book_create = U.id
	   //      LEFT JOIN department D ON U.department=D.dep_id
	   //      LEFT JOIN company C ON R.room_company=C.com_id
	   //      LEFT JOIN timeout TI ON B.book_endtime=TI.timeout
	   //      AND B.book_status != 8
	   //      -- WHERE B.book_startdate=?
	   //      ORDER BY B.book_startdate DESC",[]
    // );
  	}
}