<?php

namespace App\Booking;

use Wattanar\Sqlsrv;
use App\Database\Connection;
use App\Approve\ApproveAPI;
use App\SendMail\SendMailAPI;

class BookingAPI
{
	public function getBookingReport($dafaultstart,$dafaultend) {
	    $conn = (new Connection)->dbConnect();
	    
	    $dafaultstart  = date("Y-m-d",strtotime($dafaultstart));
    	$dafaultend    = date("Y-m-d",strtotime($dafaultend));

	    return Sqlsrv::rows(
	    	$conn,
	    	"SELECT R.*,B.*
			FROM room R
			LEFT JOIN booking B ON B.book_room=R.room_id
			WHERE B.book_startdate BETWEEN ? AND ?
			ORDER BY B.book_startdate ASC",[$dafaultstart,$dafaultend]
	    );
	}

	public function getBookingRoom($startdate) {
	    $conn = (new Connection)->dbConnect();

	    return Sqlsrv::rows(
	    	$conn,
	    	"SELECT R.*,B.*
			FROM room R
			LEFT JOIN booking B ON B.book_room=R.room_id
			WHERE B.book_startdate = ?
			ORDER BY B.book_startdate,R.room_id ASC",[$startdate]
	    );
	}

	public function getByRoom($room,$company,$startDate,$startTime,$endDate,$endTime){
		$conn = (new Connection)->dbConnect();

		$startDate = date("Y-m-d",strtotime($startDate));
		$endDate   = date("Y-m-d",strtotime($endDate));

		$data_book = Sqlsrv::rows(
			$conn,
			"SELECT b.book_room FROM booking b
			WHERE b.book_room IN ($room)
		    AND (('$startDate' BETWEEN b.book_startdate AND b.book_enddate)
		    OR ('$endDate' BETWEEN b.book_startdate AND b.book_enddate)
		    OR (b.book_startdate BETWEEN '$startDate'  AND '$endDate')
		    OR (b.book_enddate   BETWEEN '$startDate' AND '$endDate'))
		    AND(('$startTime' BETWEEN b.book_starttime AND b.book_endtime)
		    OR ('$endTime' BETWEEN b.book_starttime AND b.book_endtime)
		    OR (b.book_starttime BETWEEN '$startTime' AND '$endTime')
		    OR (b.book_endtime BETWEEN '$startTime' AND '$endTime'))
		    AND b.book_status NOT IN (5,6,7,8)"
		);

		// return $data_book;
		// exit;
	    $a = [];
	    for ($i=0; $i < count($data_book); $i++) { 
	        if (!in_array($data_book[$i][0], $a)) {
	        	array_push($a, $data_book[$i][0]);
	        }
	    }
	    // $not_inroom = implode(",",$b);
	    $b = (explode(",",$room));
	    $list_room = [];
	    foreach ($b as $value) {
	    	if (!in_array($value, $a)) {
	    		array_push($list_room, $value);
	    	}
	    }
	    $inroom = implode(",",$list_room);
	    // $list_room = (explode(",",$list_room));
	    // return $inroom;
	    return Sqlsrv::rows(
			$conn,
			"SELECT  R.room_id
                    ,R.room_name
                    ,R.room_company
                    ,R.room_floor
                    ,R.room_max_seat
                    ,R.room_tool
                    ,R.room_picture
                    ,C.com_fname
                    ,C.com_nname
            FROM  ROOM R
            LEFT JOIN COMPANY C ON R.room_company=C.com_id 
            WHERE room_id IN ($inroom)
            ORDER BY R.room_id ASC"
		);

	}

	public function getByComp($company,$startDate,$startTime,$endDate,$endTime){
		$conn = (new Connection)->dbConnect();

		$startDate = date("Y-m-d",strtotime($startDate));
		$endDate   = date("Y-m-d",strtotime($endDate));

		$data_book = Sqlsrv::rows(
			$conn,
			"SELECT b.book_room FROM booking b
			LEFT JOIN room r on b.book_room = r.room_id
			LEFT JOIN company c on r.room_company = c.com_id
			WHERE c.com_nname = '$company'
		    AND (('$startDate' BETWEEN b.book_startdate AND b.book_enddate)
		    OR ('$endDate' BETWEEN b.book_startdate AND b.book_enddate)
		    OR (b.book_startdate BETWEEN '$startDate'  AND '$endDate')
		    OR (b.book_enddate   BETWEEN '$startDate' AND '$endDate'))
		    AND(('$startTime' BETWEEN b.book_starttime AND b.book_endtime)
		    OR ('$endTime' BETWEEN b.book_starttime AND b.book_endtime)
		    OR (b.book_starttime BETWEEN '$startTime' AND '$endTime')
		    OR (b.book_endtime BETWEEN '$startTime' AND '$endTime'))
		    AND b.book_status NOT IN (5,6,7,8) 
		    GROUP BY b.book_room"
		);

		$data_room = Sqlsrv::rows(
			$conn,
			"SELECT * FROM room WHERE room_active=1"
		);
		
		$room = [];
		foreach ($data_room as $r) {
			array_push($room, $r['room_id']);
		}

		$room = implode(",",$room);
		
	    $a = [];
	    for ($i=0; $i < count($data_book); $i++) { 
	        if (!in_array($data_book[$i][0], $a)) {
	        	array_push($a, $data_book[$i][0]);
	        }
	    }
	    // $not_inroom = implode(",",$b);
	    $b = (explode(",",$room));
	    $list_room = [];
	    foreach ($b as $value) {
	    	if (!in_array($value, $a)) {
	    		array_push($list_room, $value);
	    	}
	    }
	    $inroom = implode(",",$list_room);
	    // $list_room = (explode(",",$list_room));
	    // return $inroom;
	    return Sqlsrv::rows(
			$conn,
			"SELECT  R.room_id
                    ,R.room_name
                    ,R.room_company
                    ,R.room_floor
                    ,R.room_max_seat
                    ,R.room_tool
                    ,R.room_picture
                    ,C.com_fname
                    ,C.com_nname
            FROM  room R
            LEFT JOIN company C ON R.room_company=C.com_id 
            WHERE room_id IN ($inroom)
            AND C.com_nname='$company'
            ORDER BY R.room_id ASC"
		);
	}

	public function getweekly() {
	    $conn = (new Connection)->dbConnect();
	    return Sqlsrv::rows(
	      $conn,
	      "SELECT * FROM weekly"
	    );
	}

	public function getTimein() {
	    $conn = (new Connection)->dbConnect();
	    return Sqlsrv::rows(
	      $conn,
	      "SELECT * FROM timein"
	    );
	}

	public function getTimeout() {
	    $conn = (new Connection)->dbConnect();
	    return Sqlsrv::rows(
	      $conn,
	      "SELECT * FROM timeout"
	    );
	}

	public function checkBooking($booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime,$booking_room,$idTrans) {
		$conn = (new Connection)->dbConnect();
		$startDate = $booking_startdate;
		$endDate   = $booking_enddate;
		$startTime = $booking_starttime;
		$endTime   = $booking_endtime;
		$room 	   = $booking_room;

		if ($idTrans!=0) {
			$data_book = Sqlsrv::rows(
				$conn,
				"SELECT b.book_room FROM booking b
				WHERE b.book_room IN ($room)
				AND b.book_status NOT IN (5,6,7,8)
				AND b.book_number != '$idTrans'
			    AND (('$startDate' BETWEEN b.book_startdate AND b.book_enddate)
			    OR ('$endDate' BETWEEN b.book_startdate AND b.book_enddate)
			    OR (b.book_startdate BETWEEN '$startDate'  AND '$endDate')
			    OR (b.book_enddate   BETWEEN '$startDate' AND '$endDate'))
			    AND(('$startTime' BETWEEN b.book_starttime AND b.book_endtime)
			    OR ('$endTime' BETWEEN b.book_starttime AND b.book_endtime)
			    OR (b.book_starttime BETWEEN '$startTime' AND '$endTime')
			    OR (b.book_endtime BETWEEN '$startTime' AND '$endTime'))"
			);
		}else{
			$data_book = Sqlsrv::rows(
				$conn,
				"SELECT b.book_room FROM booking b
				WHERE b.book_room IN ($room)
				AND b.book_status NOT IN (5,6,7,8)
			    AND (('$startDate' BETWEEN b.book_startdate AND b.book_enddate)
			    OR ('$endDate' BETWEEN b.book_startdate AND b.book_enddate)
			    OR (b.book_startdate BETWEEN '$startDate'  AND '$endDate')
			    OR (b.book_enddate   BETWEEN '$startDate' AND '$endDate'))
			    AND(('$startTime' BETWEEN b.book_starttime AND b.book_endtime)
			    OR ('$endTime' BETWEEN b.book_starttime AND b.book_endtime)
			    OR (b.book_starttime BETWEEN '$startTime' AND '$endTime')
			    OR (b.book_endtime BETWEEN '$startTime' AND '$endTime'))"
			);
		}
		
		if ($data_book) {
			return true;
		}else{
			return false;
		}

	}

	public function create($booking_loopdate,$booking_room,$numbersequence,$booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime,$booking_name,$booking_user,$booking_seat,$booking_remark,$_food=[],$_dessert=[],$booking_layout,$booking_support){
		
		$conn = (new Connection)->dbConnect();
		$year =  date("Y");
		$session_user	= $_SESSION['user_id'];	

		if (Sqlsrv::begin($conn) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{

		if ($booking_loopdate!='0') {
			// Issue fix weekly
			if ($booking_startdate != $booking_enddate) {

				$date = self::date_in_period("D-Y-m-d", $booking_startdate, $booking_enddate,array($booking_loopdate));
		        if ((count($date)==0)) { 
		            echo json_encode(["status" => 404, "message" => "ไม่พบวันที่เลือก !"]);
		            exit();
		        }
		        // Insert By Weekly
		        foreach($date as $day){
		            if (substr($day,0,3) != "Sun") { 
		            	$book_weekly = substr($day,0,3);
		              	$dateincorrect = substr($day,4);

		              	$insert = sqlsrv_query(
							$conn,
							"INSERT  booking (		book_room
													,book_number
													,book_startdate
													,book_enddate
													,book_starttime
													,book_endtime
													,book_title
													,book_user
													,book_seat
													,book_create
													,book_createdate
													,book_remark
													,book_status
													,book_weekly
							)
							VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,?)",
							array(
								$booking_room
								,$numbersequence
								,$dateincorrect
								,$dateincorrect
								,$booking_starttime
								,$booking_endtime
								,$booking_name
								,$booking_user
								,$booking_seat
								,$session_user
								,$booking_remark
								,1
								,$book_weekly
							)
						);

		            }
		        }

		    }else{
		    	// Insert 1 Day
		    	$insert = sqlsrv_query(
					$conn,
					"INSERT  booking (		book_room
											,book_number
											,book_startdate
											,book_enddate
											,book_starttime
											,book_endtime
											,book_title
											,book_user
											,book_seat
											,book_create
											,book_createdate
											,book_remark
											,book_status
											,book_weekly
					)
					VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,?)",
					array(
						$booking_room
						,$numbersequence
						,$booking_enddate
						,$booking_enddate
						,$booking_starttime
						,$booking_endtime
						,$booking_name
						,$booking_user
						,$booking_seat
						,$session_user
						,$booking_remark
						,1
						,0
					)
				);
		    }

		}else{
			$book_weekly = 0;
			// Issue Several Days
		    if ($booking_startdate != $booking_enddate) {

				$date = self::date_in_period("D-Y-m-d", $booking_startdate, $booking_enddate);
		        if ((count($date)==0)) { 
		            echo json_encode(["status" => 404, "message" => "ไม่พบวันที่เลือก !"]);
		            exit();
		        }
		        // Insert By Weekly
		        foreach($date as $day){
		            if (substr($day,0,3) != "Sun") { 
		              	$dateincorrect = substr($day,4);

		              	$insert = sqlsrv_query(
							$conn,
							"INSERT  booking (		book_room
													,book_number
													,book_startdate
													,book_enddate
													,book_starttime
													,book_endtime
													,book_title
													,book_user
													,book_seat
													,book_create
													,book_createdate
													,book_remark
													,book_status
													,book_weekly
							)
							VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,?)",
							array(
								$booking_room
								,$numbersequence
								,$dateincorrect
								,$dateincorrect
								,$booking_starttime
								,$booking_endtime
								,$booking_name
								,$booking_user
								,$booking_seat
								,$session_user
								,$booking_remark
								,1
								,$book_weekly
							)
						);

		            }
		        }

		    }else{
		    	// Insert 1 Day
		    	$insert = sqlsrv_query(
					$conn,
					"INSERT  booking (		book_room
											,book_number
											,book_startdate
											,book_enddate
											,book_starttime
											,book_endtime
											,book_title
											,book_user
											,book_seat
											,book_create
											,book_createdate
											,book_remark
											,book_status
											,book_weekly
					)
					VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,?)",
					array(
						$booking_room
						,$numbersequence
						,$booking_enddate
						,$booking_enddate
						,$booking_starttime
						,$booking_endtime
						,$booking_name
						,$booking_user
						,$booking_seat
						,$session_user
						,$booking_remark
						,1
						,$book_weekly
					)
				);
		    }

		}

	        if ($insert) {

				if (isset($_food)) {

			    	foreach ($_food as $key => $unit) {
				      	$insert = sqlsrv_query(
						$conn,
							"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
							VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,0,0,1]
						);
				    }

			    }

				if (isset($_dessert)) {
					
					foreach ($_dessert as $key => $unit) {
				      	$insert = sqlsrv_query(
						$conn,
							"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
							VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,0,0,2]
						);
				    }	

				}
				if (isset($booking_layout)) {
					
					$insert = sqlsrv_query(
					$conn,
						"INSERT INTO booking_layout 
						(booking_id,layout_id,layout_approve,layout_remark)
						VALUES(?,?,?,?)",[$numbersequence,$booking_layout,0,0]
					);

				}
				if (isset($booking_support)) {
					
					$insert = sqlsrv_query(
					$conn,
						"INSERT INTO booking_support
						(booking_id,support_id,support_approve,support_remark)
						VALUES(?,?,?,?)",[$numbersequence,$booking_support,0,0]
					);	

				}

				$nextnumbersequence = self::getsequence('next');

				if ($nextnumbersequence) {
					
					$update = sqlsrv_query(
						$conn,
						"UPDATE numbersequence SET nextrec=? WHERE numofyear=?",[$nextnumbersequence,$year]
					);	

				}


            	$getmail  = (new SendMailAPI)->getmailhead();
	            $to       = $getmail[0]['email_head'];
	            $sender   = $getmail[0]['email'];

	            $mailTo = [
	              $to
	            ];

	            $mailCC = [
	                
	            ];

	            $BCC = [

	            ];

	            $subject  = self::getSubjectManagerUser($numbersequence);
            	$body     = self::getBodyManagerUser($numbersequence,$to,$booking_room,$booking_name,$booking_startdate,$booking_starttime,$booking_enddate,$booking_endtime);
            	
	            if ((new SendMailAPI)->SendMail($mailTo, $mailCC, $BCC, $subject , $body , $sender )===true) {
	            	Sqlsrv::commit($conn);
	            	echo json_encode(["status" => 200, "message" => "ดำเนินการจองเรียบร้อย !"]);
	            }else{
	            	Sqlsrv::commit($conn);
					echo json_encode(["status" => 400, "message" => "เกิดข้อผิดพลาด ส่งเมลล์ไม่ผ่าน !"]);
	            }
	        	// echo json_encode(["status" => 200, "message" => "ดำเนินการจองเรียบร้อย !"]);
			}else{
				Sqlsrv::rollback($conn);
				echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด !"]);
			}

		}catch (Exception $e) {
			Sqlsrv::rollback($conn);
			return false;
		}

	}

	public function update($booking_loopcheck,$booking_loopdate,$loopdate,$booking_room,$numbersequence,$booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime,$booking_name,$booking_user,$booking_seat,$booking_remark,$_food,$_dessert,$booking_layout,$booking_support,$click_type){
		
		$conn = (new Connection)->dbConnect();
		$year =  date("Y");
		$session_user	= $_SESSION['user_id'];	
		
		if ($_SESSION['user_status']=="A") {
			$session_admin = $_SESSION['user_email'];
			$status 	   = 3;
		}else{
			$session_admin = null;
			$status 	   = 1;
		}
		// change date 
		if ($loopdate!=0) {

			$deletestatus =  sqlsrv_query(
				$conn,
				"DELETE FROM booking
				WHERE book_number = ?",[$numbersequence]
			);

			if ($deletestatus) {
				// weekly 
				if ($booking_loopcheck==1) {

					if ($booking_loopdate!='0') {
						
						if ($booking_startdate != $booking_enddate) {

							$date = self::date_in_period("D-Y-m-d", $booking_startdate, $booking_enddate,array($booking_loopdate));
					        if ((count($date)==0)) { 
					            echo json_encode(["status" => 404, "message" => "ไม่พบวันที่เลือก !"]);
					            exit();
					        }
					        // Insert By Weekly
					        foreach($date as $day){
					            if (substr($day,0,3) != "Sun") { 
					            	$book_weekly = substr($day,0,3);
					              	$dateincorrect = substr($day,4);

					              	$insert = sqlsrv_query(
										$conn,
										"INSERT  booking (		book_room
																,book_number
																,book_startdate
																,book_enddate
																,book_starttime
																,book_endtime
																,book_title
																,book_user
																,book_seat
																,book_create
																,book_createdate
																,book_remark
																,book_status
																,book_weekly
										)
										VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,?)",
										array(
											$booking_room
											,$numbersequence
											,$dateincorrect
											,$dateincorrect
											,$booking_starttime
											,$booking_endtime
											,$booking_name
											,$booking_user
											,$booking_seat
											,$session_user
											,$booking_remark
											,$status
											,$book_weekly
										)
									);

					            }
					        }

					    }else{
					    	// Insert 1 Day
					    	$insert = sqlsrv_query(
								$conn,
								"INSERT  booking (		book_room
														,book_number
														,book_startdate
														,book_enddate
														,book_starttime
														,book_endtime
														,book_title
														,book_user
														,book_seat
														,book_create
														,book_createdate
														,book_remark
														,book_status
														,book_weekly
								)
								VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,?)",
								array(
									$booking_room
									,$numbersequence
									,$booking_enddate
									,$booking_enddate
									,$booking_starttime
									,$booking_endtime
									,$booking_name
									,$booking_user
									,$booking_seat
									,$session_user
									,$booking_remark
									,$status
									,0
								)
							);
					    }
					// days 
					}

				}else{

					$getnumbersequence 	= self::getsequence('get');
					$nextnumbersequence = self::getsequence('next');

					$date = self::date_in_period("D-Y-m-d", $booking_startdate, $booking_enddate);
			        if ((count($date)==0)) { 
			            echo json_encode(["status" => 404, "message" => "ไม่พบวันที่เลือก !"]);
			            exit();
			        }
			        // Insert Days
			        foreach($date as $day){
			            if (substr($day,0,3) != "Sun") { 
			              	$dateincorrect = substr($day,4);

			              	$insert = sqlsrv_query(
								$conn,
								"INSERT  booking (		book_room
														,book_number
														,book_startdate
														,book_enddate
														,book_starttime
														,book_endtime
														,book_title
														,book_user
														,book_seat
														,book_create
														,book_createdate
														,book_remark
														,book_status
														,book_updatedate
														,book_updateby
														,book_admindate
														,book_adminby
														,book_weekly
								)
								VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,getdate(),?,getdate(),?,?)",
								array(
									$booking_room
									,$numbersequence
									,$dateincorrect
									,$dateincorrect
									,$booking_starttime
									,$booking_endtime
									,$booking_name
									,$booking_user
									,$booking_seat
									,$session_user
									,$booking_remark
									,$status
									,$session_user
									,$session_admin
									,0
								)
							);

			            }
			        }

			        if ($insert) {
			        	$delete = sqlsrv_query(
						$conn,
						"DELETE FROM booking_food
						WHERE booking_id=?",[$numbersequence]
						);
			        }

				}	

					if (isset($_food)) {

				    	foreach ($_food as $key => $unit) {
					      	$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
								VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,1,null,1]
							);
					    }

				    }
					if (isset($_dessert)) {
						
						foreach ($_dessert as $key => $unit) {
					      	$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
								VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,1,null,2]
							);
					    }	

					}
					if (isset($booking_layout)) {

						$update = sqlsrv_query(
						$conn,
							"UPDATE booking_layout SET layout_id = ?
							WHERE booking_id=?",[$booking_layout,$numbersequence]
						);

					}
					if (isset($booking_support)) {
						
						$delete = sqlsrv_query(
							$conn,
							"DELETE FROM booking_support
							WHERE booking_id=?",[$numbersequence]
						);	

						$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_support (booking_id,support_id,support_approve,support_remark)
								VALUES(?,?,?,?)",[$numbersequence,$booking_support,1,null]
							);	

					}else{
						
						$delete = sqlsrv_query(
							$conn,
							"DELETE FROM booking_support
							WHERE booking_id=?",[$numbersequence]
						);

					}
	

			}else{
				echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด !"]);
			}

		// date defult 
		}else{
			// Days
			if ($booking_startdate != $booking_enddate) {

				$deletestatus =  sqlsrv_query(
					$conn,
					"DELETE FROM booking
					WHERE book_number = ?",[$numbersequence]
				);

				if ($booking_loopcheck==1) {
					
					if ($booking_loopdate!='0') {
				
						$date = self::date_in_period("D-Y-m-d", $booking_startdate, $booking_enddate,array($booking_loopdate));
				        if ((count($date)==0)) { 
				            echo json_encode(["status" => 404, "message" => "ไม่พบวันที่เลือก !"]);
				            exit();
				        }
				        // Insert By Weekly
				        foreach($date as $day){
				            if (substr($day,0,3) != "Sun") { 
				            	$book_weekly = substr($day,0,3);
				              	$dateincorrect = substr($day,4);

				              	$insert = sqlsrv_query(
									$conn,
									"INSERT  booking (		book_room
															,book_number
															,book_startdate
															,book_enddate
															,book_starttime
															,book_endtime
															,book_title
															,book_user
															,book_seat
															,book_create
															,book_createdate
															,book_remark
															,book_status
															,book_weekly
									)
									VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,?)",
									array(
										$booking_room
										,$numbersequence
										,$dateincorrect
										,$dateincorrect
										,$booking_starttime
										,$booking_endtime
										,$booking_name
										,$booking_user
										,$booking_seat
										,$session_user
										,$booking_remark
										,$status
										,$book_weekly
									)
								);

				            }
				        }

					}

				}else{
					$getnumbersequence 	= self::getsequence('get');
					$nextnumbersequence = self::getsequence('next');

					$date = self::date_in_period("D-Y-m-d", $booking_startdate, $booking_enddate);
			        if ((count($date)==0)) { 
			            echo json_encode(["status" => 404, "message" => "ไม่พบวันที่เลือก !"]);
			            exit();
			        }
			        // Insert Days
			        foreach($date as $day){
			            if (substr($day,0,3) != "Sun") { 
			              	$dateincorrect = substr($day,4);

			              	$insert = sqlsrv_query(
								$conn,
								"INSERT  booking (		book_room
														,book_number
														,book_startdate
														,book_enddate
														,book_starttime
														,book_endtime
														,book_title
														,book_user
														,book_seat
														,book_create
														,book_createdate
														,book_remark
														,book_status
														,book_updatedate
														,book_updateby
														,book_admindate
														,book_adminby
														,book_weekly
								)
								VALUES(?,?,?,?,?,?,?,?,?,?,getdate(),?,?,getdate(),?,getdate(),?,?)",
								array(
									$booking_room
									,$numbersequence
									,$dateincorrect
									,$dateincorrect
									,$booking_starttime
									,$booking_endtime
									,$booking_name
									,$booking_user
									,$booking_seat
									,$session_user
									,$booking_remark
									,$status
									,$session_user
									,$session_admin
									,0
								)
							);

			            }
			        }
				}

				if ($insert) {
				
					$delete = sqlsrv_query(
						$conn,
						"DELETE FROM booking_food
						WHERE booking_id=?",[$numbersequence]
					);	

					if (isset($_food)) {

				    	foreach ($_food as $key => $unit) {
					      	$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
								VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,1,null,1]
							);
					    }

				    }
					if (isset($_dessert)) {
						
						foreach ($_dessert as $key => $unit) {
					      	$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
								VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,1,null,2]
							);
					    }	

					}
					if (isset($booking_layout)) {

						$update = sqlsrv_query(
						$conn,
							"UPDATE booking_layout SET layout_id = ?
							WHERE booking_id=?",[$booking_layout,$numbersequence]
						);

					}
					if (isset($booking_support)) {
						
						$delete = sqlsrv_query(
							$conn,
							"DELETE FROM booking_support
							WHERE booking_id=?",[$numbersequence]
						);	

						$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_support (booking_id,support_id,support_approve,support_remark)
								VALUES(?,?,?,?)",[$numbersequence,$booking_support,1,null]
							);	

					}else{
						
						$delete = sqlsrv_query(
							$conn,
							"DELETE FROM booking_support
							WHERE booking_id=?",[$numbersequence]
						);

					}
		            
				}else{
					echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด !"]);
					exit();
				}
			// Day
			}else{
			
				$update = sqlsrv_query(
					$conn,
					"UPDATE booking SET book_room=?, 
										book_startdate=?, 
										book_enddate=?, 
										book_starttime=?, 
										book_endtime=?, 
										book_title=?, 
										book_user=?, 
										book_seat=?, 
										book_remark=?,
										book_status=?,
										book_updatedate=getdate(),
										book_updateby=?,
										book_admindate=getdate(),
										book_adminby=?
					WHERE book_number = ?",
					[	
						$booking_room,
						$booking_startdate,
						$booking_enddate,
						$booking_starttime,
						$booking_endtime,
						$booking_name,
						$booking_user,
						$booking_seat,
						$booking_remark,
						$status,
						$session_user,
						$session_admin,
						$numbersequence
					]
				);

				if ($update) {
				
					$delete = sqlsrv_query(
						$conn,
						"DELETE FROM booking_food
						WHERE booking_id=?",[$numbersequence]
					);	

					if (isset($_food)) {

				    	foreach ($_food as $key => $unit) {
					      	$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
								VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,1,null,1]
							);
					    }

				    }
					if (isset($_dessert)) {
						
						foreach ($_dessert as $key => $unit) {
					      	$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
								VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,1,null,2]
							);
					    }	

					}
					if (isset($booking_layout)) {

						$update = sqlsrv_query(
						$conn,
							"UPDATE booking_layout SET layout_id = ?
							WHERE booking_id=?",[$booking_layout,$numbersequence]
						);

					}
					if (isset($booking_support)) {
						
						$delete = sqlsrv_query(
							$conn,
							"DELETE FROM booking_support
							WHERE booking_id=?",[$numbersequence]
						);	

						$insert = sqlsrv_query(
							$conn,
								"INSERT INTO booking_support (booking_id,support_id,support_approve,support_remark)
								VALUES(?,?,?,?)",[$numbersequence,$booking_support,1,null]
							);	

					}else{
						
						$delete = sqlsrv_query(
							$conn,
							"DELETE FROM booking_support
							WHERE booking_id=?",[$numbersequence]
						);

					}
		            
				}else{
					// Sqlsrv::rollback($conn);
					echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด !"]);
					exit();
				}

			}

		}

		// send mail
		$mailTo = [];
        $mailCC = [];
        $BCC 	= [];
        $sender = $_SESSION['user_email'];

        if ($click_type=='send') {
			if ($_SESSION['user_status']=='A') {
			 	$getmail  = (new SendMailAPI)->getmailhead();

				foreach ($getmail as $value) {
	    			array_push($mailTo, $value['email_head']);
	    		}
	    		$subject  = self::getSubjectManagerHr($numbersequence);
        		$body     = self::getBodyManagerHr($numbersequence,$mailTo[0],$booking_room,$booking_name,$booking_startdate,$booking_starttime,$booking_enddate,$booking_endtime);

			}else{
				$getmail  = (new SendMailAPI)->getmailhead();

				foreach ($getmail as $value) {
	    			array_push($mailTo, $value['email_head']);
	    		}
	    		$subject  = self::getSubjectManagerUser($numbersequence);
        		$body     = self::getBodyManagerUser($numbersequence,$mailTo[0],$booking_room,$booking_name,$booking_startdate,$booking_starttime,$booking_enddate,$booking_endtime);
			}
		} 

        if ($click_type=='send') {
        	if ((new SendMailAPI)->SendMail($mailTo, $mailCC, $BCC, $subject , $body , $sender )===true) {
            	// Sqlsrv::commit($conn);
            	echo json_encode(["status" => 200, "message" => "ดำเนินการจองเรียบร้อย !"]);
            }else{
            	// Sqlsrv::rollback($conn);
				echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด !"]);
            }
        }else{
        	// Sqlsrv::commit($conn);
        	echo json_encode(["status" => 200, "message" => "ดำเนินการจองเรียบร้อย !"]);
        }


	}

	public function deletefood($food_id,$booking_id,$type){
		$conn = (new Connection)->dbConnect();
		
		$delete = sqlsrv_query(
			$conn,
			"DELETE booking_food
			WHERE food_id=? AND booking_id=? AND food_type=?",[$food_id,$booking_id,$type]
		);	
		if ($delete) {
			echo json_encode(["status" => 200, "message" => "ดำเนินการลบเรียบร้อย !"]);
		}else{
			echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด !"]);
		}
	}

	public function chkroom_update($booking_id,$booking_room,$booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime){
		$conn = (new Connection)->dbConnect();

		return Sqlsrv::hasRows(
			$conn,
			"SELECT b.book_room FROM booking b
			WHERE b.book_room IN ($booking_room) AND b.book_id != '$booking_id'
		    AND (('$booking_startdate' BETWEEN b.book_startdate AND b.book_enddate)
		    OR ('$booking_enddate' BETWEEN b.book_startdate AND b.book_enddate)
		    OR (b.book_startdate BETWEEN '$booking_startdate'  AND '$booking_enddate')
		    OR (b.book_enddate BETWEEN '$booking_startdate' AND '$booking_enddate'))
		    AND(('$booking_starttime' BETWEEN b.book_starttime AND b.book_endtime)
		    OR ('$booking_endtime' BETWEEN b.book_starttime AND b.book_endtime)
		    OR (b.book_starttime BETWEEN '$booking_starttime' AND '$booking_endtime')
		    OR (b.book_endtime BETWEEN '$booking_starttime' AND '$booking_endtime'))"
		);

	}

	public function getsequence($params){

		$arr = self::gensequence();
		$before = 0;
	    $strlen = strlen($arr[0]['nextrec']);
	      
	    if ($strlen>=$arr[0]['highest']){ 
	      $arr[0]['highest']++; $before = '';
	    }

	    for($i=1;$i<=$arr[0]['highest']-$strlen;$i++){
	        @$pre.=$before;
	    }

	    $NumberSequence = $pre.$arr[0]['nextrec'].'/'.$arr[0]['numofyear'];
	    $nextnumber = $arr[0]['nextrec']+1;

	    if ($params=='get') {
	    	return $NumberSequence;
	    }else{
	    	return $nextnumber;
	    }

	}

	public function gensequence(){
		$year =  date("Y");
		$conn = (new Connection)->dbConnect();

		$hasRows = Sqlsrv::hasRows(
			$conn,
			"SELECT * FROM numbersequence WHERE numofyear = ?",[$year]
		);

		if ($hasRows) {
			return Sqlsrv::rows($conn, 
				"SELECT * FROM numbersequence WHERE numofyear = ?",[$year]
			);	
		}else{
			$insertnumber = sqlsrv_query(
			$conn,
				"INSERT INTO numbersequence (highest,nextrec,numofyear)
				VALUES(?,?,?)",[4,1,$year]
			);
			if ($insertnumber) {
				return Sqlsrv::rows($conn, 
					"SELECT * FROM numbersequence WHERE numofyear = ?",[$year]
				);	
			}else{
				return false;
			}
		}
		
	}

	public function number_update($nextnumbersequence,$conn){
		$year =  date("Y");
		// $conn = (new Connection)->dbConnect();
		
		$update = sqlsrv_query(
			$conn,
			"UPDATE numbersequence SET nextrec=? WHERE numofyear=?",[$nextnumbersequence,$year]
		);	
		if ($update) {
			return true;
		}else{
			return false;
		}
	}

	public function insertfood($numbersequence,$_food,$conn){
		$year =  date("Y");
		// $conn = (new Connection)->dbConnect();

	    foreach ($_food as $key => $unit) {
	      	$insert = sqlsrv_query(
			$conn,
				"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
				VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,0,0,1]
			);
	    }

	    if ($insert) {
	    	return true;
	    }else{
	    	return false;
	    }

	}

	public function insertdessert($numbersequence,$_dessert,$conn){
		$year =  date("Y");
		// $conn = (new Connection)->dbConnect();

	    foreach ($_dessert as $key => $unit) {
	      	$insert = sqlsrv_query(
			$conn,
				"INSERT INTO booking_food (booking_id,food_id,food_unit,food_approve,food_remark,food_type)
				VALUES(?,?,?,?,?,?)",[$numbersequence,$key,$unit,0,0,2]
			);
	    }

	    if ($insert) {
	    	return true;
	    }else{
	    	return false;
	    }

	}

	public function insertlayout($numbersequence,$booking_layout,$conn){
		$year =  date("Y");
		// $conn = (new Connection)->dbConnect();

	    $insert = sqlsrv_query(
			$conn,
				"INSERT INTO booking_layout 
				(booking_id,layout_id,layout_approve,layout_remark)
				VALUES(?,?,?,?)",[$numbersequence,$booking_layout,0,0]
			);

	    if ($insert) {
	    	return true;
	    }else{
	    	return false;
	    }

	}

	public function insertsupport($numbersequence,$booking_support,$conn){
		$year =  date("Y");
		// $conn = (new Connection)->dbConnect();

	    $insert = sqlsrv_query(
			$conn,
				"INSERT INTO booking_support
				(booking_id,support_id,support_approve,support_remark)
				VALUES(?,?,?,?)",[$numbersequence,$booking_support,0,0]
			);

	    if ($insert) {
	    	return true;
	    }else{
	    	return false;
	    }

	}

	public function updateStatus($status,$numbersequence){
		$conn = (new Connection)->dbConnect();

		$update = sqlsrv_query(
			$conn,
			"UPDATE booking SET book_status=?,book_updatedate=GETDATE() 
			WHERE book_number=?",[$status,$numbersequence]
		);	
		if ($update) {
			return true;
		}else{
			return false;
		}
	}

	public function cancel($booking_number){
		$conn = (new Connection)->dbConnect();
		$session_user   = $_SESSION['user_id'];

		$update = sqlsrv_query(
			$conn,
			"UPDATE booking SET book_status=?, book_updateby=?, book_updatedate=GETDATE() 
			WHERE book_number=?",[8,$session_user,$booking_number]
		);	
		if ($update) {
			return true;
		}else{
			return false;
		}
	}

	public function cancel_id($remark_id,$txt_remark){
		$conn = (new Connection)->dbConnect();
		$session_user   = $_SESSION['user_id'];

		$update = sqlsrv_query(
			$conn,
			"UPDATE booking SET book_status=?, book_updateby=?, book_updatedate=GETDATE(), book_remark_cancel=? 
			WHERE book_id IN ($remark_id)",[8,$session_user,$txt_remark]
		);	
		if ($update) {
			return true;
		}else{
			return false;
		}
	}

	public function getSubjectManagerUser($numbersequence) {
        $txt = '';
        $txt .= "แจ้งสถานะการขอใช้ห้องประชุม รายการที่ ".$numbersequence;
        return $txt;
    }

    public function getBodyManagerUser($numbersequence,$to,$booking_room,$booking_name,$booking_startdate,$booking_starttime,$booking_enddate,$booking_endtime) {
        $app  = self::getapplocation();
        $room = self::getroomName($booking_room);
        $user = self::userBooking();
        $txt  = "";
        $txt .= "<table>";
        $txt .= "<tr><td><b>ชื่อห้องประชุม</b></td> <td> : ".$room[0]['room_name']."</td></tr>";
        $txt .= "<tr><td><b>ผู้จอง</b></td> <td> : ".$user[0]['fname']." ".$user[0]['lname']."&nbsp;&nbsp;&nbsp;แผนก : ".$user[0]['dep_name']."</td></tr>";
        $txt .= "<tr><td><b>หัวข้อการประชุม</b></td> <td> : ".$booking_name."</td></tr>";
        $txt .= "<tr><td><b>วันที่เริ่มใช้งาน</b></td><td> : ".date("d/m/Y", strtotime($booking_startdate))." เวลา : ".$booking_starttime." น.</td></tr>";
        $txt .= "<tr><td><b>วันที่สิ้นสุด</b></td>  <td> : ".date("d/m/Y", strtotime($booking_enddate))." เวลา : ".$booking_endtime." น.</td></tr>";
        $txt .= "<tr><td colspan=2><b>รายละเอียด/ลิ้งค์อนุมัติ</b> : <a href='http://".$app."/mg_approve_user?numbersequence=".$numbersequence."&mg=".$to."'>เลือกที่นี่</a></td></tr>";
        $txt .= "</table>";
        return $txt;
    }

    public function getSubjectManagerHr($numbersequence) {
        $txt = '';
        $txt .= "แจ้งสถานะการขอใช้ห้องประชุม รายการที่ ".$numbersequence;
        return $txt;
    }

    public function getBodyManagerHr($numbersequence,$to,$booking_room,$booking_name,$booking_startdate,$booking_starttime,$booking_enddate,$booking_endtime) {
        $app  = self::getapplocation();
        $room = self::getroomName($booking_room);
        $user = (new ApproveAPI)->load($numbersequence);
        $txt  = "";
        $txt .= "<table>";
        $txt .= "<tr><td><b>ชื่อห้องประชุม</b></td> <td> : ".$room[0]['room_name']."</td></tr>";
        $txt .= "<tr><td><b>ผู้จอง</b></td> <td> : ".$user[0]['fullname']."&nbsp;&nbsp;&nbsp;แผนก : ".$user[0]['dep_name']."</td></tr>";
        $txt .= "<tr><td><b>หัวข้อการประชุม</b></td> <td> : ".$booking_name."</td></tr>";
        $txt .= "<tr><td><b>วันที่เริ่มใช้งาน</b></td><td> : ".date("d/m/Y", strtotime($booking_startdate))." เวลา : ".$booking_starttime." น.</td></tr>";
        $txt .= "<tr><td><b>วันที่สิ้นสุด</b></td>  <td> : ".date("d/m/Y", strtotime($booking_enddate))." เวลา : ".$booking_endtime." น.</td></tr>";
        $txt .= "<tr><td colspan=2><b>รายละเอียด/ลิ้งค์อนุมัติ</b> : <a href='http://".$app."/mg_approve_hr?numbersequence=".$numbersequence."&mg=".$to."'>เลือกที่นี่</a></td></tr>";
        $txt .= "</table>";
        return $txt;
    }

    public function getroomName($booking_room){
		
		$conn = (new Connection)->dbConnect();

		return Sqlsrv::rows($conn, 
			"SELECT * FROM room WHERE room_id = ?",[$booking_room]
		);	
		
	}

	public function userBooking(){
		
		$conn = (new Connection)->dbConnect();

		return Sqlsrv::rows($conn, 
			"SELECT U.*,D.dep_name FROM [user] U
  			LEFT JOIN department D ON U.department=D.dep_id
   			WHERE U.username = ?",[$_SESSION['user_name']]
		);	
		
	}

	public function date_in_period($format, $start, $end, $skip = NULL)
	{
	    $output = array();
	    $days   = floor((strtotime($end) - strtotime($start))/86400);
	    
	    for($i=0;$i<=$days;$i++){
	      $in_period = strtotime("+" . $i . " day", strtotime($start));
	      if(is_array($skip) and !in_array(date("D",$in_period), $skip)){
	        continue;
	      }
	      array_push($output, date($format, $in_period));
	    }

	    return $output;
	}

    public function getapplocation() {
        return "lungryn.deestonegrp.com:8809";
    }

}