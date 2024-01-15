<?php 

namespace App\Approve;

use App\Approve\ApproveAPI;
use App\MyBooking\MyAPI;
use App\SendMail\SendMailAPI;
use App\Booking\BookingAPI;

class ApproveController extends \App\Base\BaseController

{
	public function mg_approve($request, $response, $args) 
	{
	    return $this->renderView('pages/approve/mg_approve');
	}

	public function mg_approve_user($request, $response, $args) 
	{
	    return $this->renderView('pages/approve/mg_approve_user');
	}

	public function mg_approve_hr($request, $response, $args) 
	{
	    return $this->renderView('pages/approve/mg_approve_hr');
	}

	public function complete_hr($request, $response, $args) 
	{
	    return $this->renderView('pages/approve/complete_hr');
	}

	public function approve($request, $response, $args) 
	{
	    $parsedBody = $request->getParsedBody();

	    $numbersequence = $parsedBody['numbersequence'];
	    $mg 			= $parsedBody['mg'];
	    $level			= $parsedBody['level'];
	    $status 		= $parsedBody['status'];
	    $data_layout 	= (new MyAPI)->loadlayout($numbersequence);
	    $data_food 		= (new MyAPI)->loadfood($numbersequence);
		$data_dessert 	= (new MyAPI)->loaddessert($numbersequence);
		$data_support 	= (new MyAPI)->loadsupport($numbersequence);

		// Layout
		if(count($data_layout)>0){
			foreach ($data_layout as $key => $value) {
				$l  = "layout".$value['layout_id'];
				$lr = "remarklayout".$value['layout_id'];
				
				if ($parsedBody[$l]!=0) {
					// echo "=1\\\\".$l."\\\\".$parsedBody[$l]."\\\\".$parsedBody[$lr];
					$updateLayout = (new ApproveAPI)->updateLayout($numbersequence,$l,$parsedBody[$l],NULL);
				}else{
					// echo "=0\\\\".$l."\\\\".$parsedBody[$l]."\\\\".$parsedBody[$lr];
					$updateLayout = (new ApproveAPI)->updateLayout($numbersequence,$l,$parsedBody[$l],$parsedBody[$lr]);
				}
			}
		}
		// Food
		if(count($data_food)>0){
			foreach ($data_food as $key => $value) {
				$f  = "food".$value['food_id'];
				$fr = "remarkfood".$value['food_id'];
				
				if ($parsedBody[$f]!=0) {
					$updateFood = (new ApproveAPI)->updateFood($numbersequence,$f,$parsedBody[$f],NULL);
				}else{
					$updateFood = (new ApproveAPI)->updateFood($numbersequence,$f,$parsedBody[$f],$parsedBody[$fr]);
				}
			}
		}
		// Dessert
		if(count($data_dessert)>0){
			foreach ($data_dessert as $key => $value) {
				$d  = "dessert".$value['food_id'];
				$dr = "remarkdessert".$value['food_id'];
				
				if ($parsedBody[$d]!=0) {
					$updateDessert = (new ApproveAPI)->updateDessert($numbersequence,$d,$parsedBody[$d],NULL);
				}else{
					$updateDessert = (new ApproveAPI)->updateDessert($numbersequence,$d,$parsedBody[$d],$parsedBody[$dr]);
				}
			}
		}
		// Support
		if(count($data_support)>0){
			foreach ($data_support as $key => $value) {
				$s  = "support".$value['support_id'];
				$sr = "remarksupport".$value['support_id'];
				
				if ($parsedBody[$s]!=0) {
					$updateSupport = (new ApproveAPI)->updateSupport($numbersequence,$s,$parsedBody[$s],NULL);
				}else{
					$updateSupport = (new ApproveAPI)->updateSupport($numbersequence,$s,$parsedBody[$s],$parsedBody[$sr]);
				}
			}
		}

		// Check Approve
	    if((new ApproveAPI)->checkLayoutApprove($numbersequence)===false && (new ApproveAPI)->checkFoodApprove($numbersequence)===false && (new ApproveAPI)->checkSupportApprove($numbersequence)===false){
	    	
	    	if((new ApproveAPI)->nextApprove($numbersequence,$mg,$status)===true){
	    		
	    		if ($level=='mg_user') {
	    			
	    			$getmail = (new SendMailAPI)->getmailadmin($numbersequence);
		    		$mailTo  = [];
		    		$mailCC  = [];
		    		$mailBCC = [];
		    		$sender  = $mg;		    		

		    		foreach ($getmail as $value) {
		    			array_push($mailTo, $value['email']);
		    		}

		    		$subject  = "แจ้งสถานะ มีการจองห้องประชุม รายการที่ ".$numbersequence;
		            $body     = self::getBodyadmin($numbersequence);

	    		}else{

	    			$getallmailuser 	= (new SendMailAPI)->getmailuser($numbersequence);
	    			$getallmailmg 		= (new SendMailAPI)->getallmailmg($numbersequence);
	    			$getallmailadmin 	= (new SendMailAPI)->getallmailadmin($numbersequence);
		    		$mailTo  = [];
		    		$mailCC  = [];
		    		$mailBCC = [];
		    		$sender  = $mg;
		    		
		    		// foreach ($getallmailuser as $value) {
		    		// 	array_push($mailTo, $value['email']);
		    		// }
		    		array_push($mailTo, $getallmailuser[0]['email']);
		    		array_push($mailCC, $getallmailmg[0]['book_mgby']);
		    		array_push($mailCC, $getallmailadmin[0]['book_adminby']);

		    		$app 	  = (new BookingAPI)->getapplocation($numbersequence);
		    		$subject  = (new SendMailAPI)->getSubjectComplete($numbersequence);
		    		$body 	  = self::getBodyComplete($numbersequence,$sender);
		    		$updateStatus = (new BookingAPI)->updateStatus(4,$numbersequence);
		            
	    		}
	    		
	            
	            $sendmail = (new SendMailAPI)->SendMail($mailTo, $mailCC, $mailBCC, $subject , $body , $sender );

	            if ($sendmail==true) {
	            	echo json_encode([
	            		"status"=>200,
	            		"message"=>"Send E-mail Successful"
	            	]);
	            }else{
	            	echo json_encode([
	            		"status"=>404,
	            		"message"=>"Send E-mail Failed"
	            	]);
	            }
	            // echo $sendmail;

	    	}else{
	    		echo json_encode(["status" => 404, "message" => "อนุมัติไม่สำเร็จ"]);
				exit();
	    	}
	    	
	    }else{

	    	if ($level=='mg_user') {

		    	$getmail = (new SendMailAPI)->getmailuser($numbersequence);
		    	$mailTo  = [];
	    		$mailCC  = [];
	    		$mailBCC = [];
	    		$sender  = $mg;

	    		foreach ($getmail as $value) {
	    			array_push($mailTo, $value['email']);
	    		}
	    		$updateStatus = (new BookingAPI)->updateStatus(5,$numbersequence);
	    		$app 	 	= (new BookingAPI)->getapplocation($numbersequence);
		    	$subject  	= (new SendMailAPI)->getSubjectComplete($numbersequence);
		        $body     	= self::getBodyUser($numbersequence);

    		}else{

    			$getmail = (new SendMailAPI)->getmailuser($numbersequence);
		    	$mailTo  = [];
	    		$mailCC  = [];
	    		$mailBCC = [];
	    		$sender  = $mg;

	    		foreach ($getmail as $value) {
	    			array_push($mailTo, $value['email']);
	    		}
	    		$updateStatus = (new BookingAPI)->updateStatus(7,$numbersequence);
	    		$app 	 	= (new BookingAPI)->getapplocation($numbersequence);
		    	$subject  	= (new SendMailAPI)->getSubjectComplete($numbersequence);
		        $body     	= self::getBodyUser($numbersequence);

    		}

    		

	    	$sendmail = (new SendMailAPI)->SendMail($mailTo, $mailCC, $mailBCC, $subject , $body , $sender );
	    	echo $sendmail;
	    }
	}

	public function remark($request, $response, $args) {
	    return $response->withJson( (new ApproveAPI)->remark() );
	}

	public function remark_food($request, $response, $args) {
	    return $response->withJson( (new ApproveAPI)->remark_food() );
	}

	public function remark_layout($request, $response, $args) {
	    return $response->withJson( (new ApproveAPI)->remark_layout() );
	}

	public function remark_support($request, $response, $args) {
	    return $response->withJson( (new ApproveAPI)->remark_support() );
	}

	public function getBodyadmin($numbersequence) {
	    $app  = (new BookingAPI)->getapplocation();
	    $data = (new ApproveAPI)->load($numbersequence);
	    $txt  = "";
	    $txt .= "<table>";
	    $txt .= "<tr><td><b>ชื่อห้องประชุม</b></td> <td> : ".$data[0]['room_name']."</td></tr>";
	    $txt .= "<tr><td><b>ผู้จอง</b></td> <td> : ".$data[0]['fullname']."&nbsp;&nbsp;&nbsp;แผนก : ".$data[0]['dep_name']."</td></tr>";
	    $txt .= "<tr><td><b>หัวข้อการประชุม</b></td> <td> : ".$data[0]['book_title']."</td></tr>";
	    $txt .= "<tr><td><b>วันที่เริ่มใช้งาน</b></td><td> : ".date("d/m/Y", strtotime($data[0]['book_startdate']))." เวลา : ".$data[0]['book_starttime']." น.</td></tr>";
	    $txt .= "<tr><td><b>วันที่สิ้นสุด</b></td>  <td> : ".date("d/m/Y", strtotime($data[0]['book_enddate']))." เวลา : ".$data[0]['book_endtime']." น.</td></tr>";
	    $txt .= "<tr><td colspan=2><b>รายละเอียด</b> : <a href='http://".$app."/mybooking'>เลือกที่นี่</a>";
	    $txt .= "</table>";
	    return $txt;
	}

	public function getBodyUser($numbersequence) {
	    $app  = (new BookingAPI)->getapplocation();
	    $data = (new ApproveAPI)->load($numbersequence);
	    $food = (new ApproveAPI)->getRemarkfood($numbersequence);
	    $dessert = (new ApproveAPI)->getRemarkdessert($numbersequence);
	    $layout  = (new ApproveAPI)->getRemarklayout($numbersequence);
	    $support = (new ApproveAPI)->getRemarksupport($numbersequence);

	    $txt  = "";
	   //  $txt .= "<style>
	   //  		table {
				//     border-collapse: collapse;
				// }

				// table, tr, td {
				//     border: 1px solid black;
				// }</style>";
	    $txt .= "<table>";
	    $txt .= "<tr><td><b>ชื่อห้องประชุม</b></td> <td colspan=4> : ".$data[0]['room_name']."</td></tr>";
	    $txt .= "<tr><td><b>หัวข้อการประชุม</b></td> <td colspan=4> : ".$data[0]['book_title']."</td></tr>";
	    $txt .= "<tr><td><b>วันที่เริ่มใช้งาน</b></td> <td colspan=4> : ".date("d/m/Y", strtotime($data[0]['book_startdate']))." เวลา : ".$data[0]['book_starttime']."</td></tr>";
	    $txt .= "<tr><td><b>วันที่สิ้นสุด</b></td>  <td colspan=4> : ".date("d/m/Y", strtotime($data[0]['book_enddate']))." เวลา : ".$data[0]['book_endtime']."</td></tr>";
	    $txt .= "<tr><td><b>ผลการอนุมัติ</b></td>  <td colspan=4> : <font color='red'>ไม่อนุมัติ</font></td></tr>";
	    // $txt .= "<tr><td colspan=2><b>รายละเอียด</b> : <a href='http://".$app."/mybooking'>เลือกที่นี่</a>";

	    if (count($layout)>0) {
	    	$txt .= "<tr><td><b>รูปแบบการจัดห้อง</b></td>";

	    	foreach ($layout as $l) {
	    		$txt .= "<td> : ".$l['layout_name']."</td>";
	    		
	    		if ($l['layout_approve']==1) {
	    			$txt .= "<td><input type='checkbox' checked='true'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox'>ไม่อนุมัติ</td>";
	    			$txt .= "<td></td>";
	    		}else{
	    			$txt .= "<td><input type='checkbox'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox' checked='true'>ไม่อนุมัติ</td>";
	    			$txt .= "<td><font color='red'>".$l['remark_name']."</font></td>";
	    		}
	    		
	    	}

	    	$txt .= "</tr>";
	    }

	    if (count($food)>0) {
	    	$txt .= "<tr><td><b>อาหาร</b></td>";
	    	$i = 1;
	    	foreach ($food as $f) {
	    		if ($i>1) {
	    			$txt .= "<tr><td></td>";
	    		}
	    		$txt .= "<td> : ".$f['food_name']."</td>";
	    		
	    		if ($f['food_approve']==1) {
	    			$txt .= "<td><input type='checkbox' checked='true'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox'>ไม่อนุมัติ</td>";
	    			$txt .= "<td></td>";
	    		}else{
	    			$txt .= "<td><input type='checkbox'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox' checked='true'>ไม่อนุมัติ</td>";
	    			$txt .= "<td><font color='red'>".$f['remark_name']."</font></td>";
	    		}

	    		if ($i>1) {
	    			$txt .= "</tr>";
	    		}
	    		$i++;
	    	}

	    	$txt .= "</tr>";

	    }

	    if (count($dessert)>0) {
	    	$txt .= "<tr><td><b>ของว่าง</b></td>";
	    	$i = 1;
	    	foreach ($dessert as $d) {
	    		if ($i>1) {
	    			$txt .= "<tr><td></td>";
	    		}
	    		$txt .= "<td> : ".$d['dessert_name']."</td>";
	    		
	    		if ($d['food_approve']==1) {
	    			$txt .= "<td><input type='checkbox' checked='true'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox'>ไม่อนุมัติ</td>";
	    			$txt .= "<td></td>";
	    		}else{
	    			$txt .= "<td><input type='checkbox'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox' checked='true'>ไม่อนุมัติ</td>";
	    			$txt .= "<td><font color='red'>".$d['remark_name']."</font></td>";
	    		}

	    		if ($i>1) {
	    			$txt .= "</tr>";
	    		}
	    		$i++;
	    	}

	    	$txt .= "</tr>";

	    }
	    
	    if (count($support)>0) {
	    	$txt .= "<tr><td><b>คนรับรอง</b></td>";

	    	foreach ($support as $s) {
	    		$txt .= "<td> : ".$s['support_id']." คน</td>";
	    		
	    		if ($s['support_approve']==1) {
	    			$txt .= "<td><input type='checkbox' checked='true'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox'>ไม่อนุมัติ</td>";
	    			$txt .= "<td></td>";
	    		}else{
	    			$txt .= "<td><input type='checkbox'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox' checked='true'>ไม่อนุมัติ</td>";
	    			$txt .= "<td><font color='red'>".$s['remark_name']."</font></td>";
	    		}
	    		
	    	}

	    	$txt .= "</tr>";
	    }

	    $txt .= "</table>";
	    return $txt;
	}

	public function getBodyUserNotApprove($numbersequence) {
	    $app  = (new BookingAPI)->getapplocation();
	    $data = (new ApproveAPI)->load($numbersequence);
	    $food = (new ApproveAPI)->getRemarkfood($numbersequence);
	    $dessert = (new ApproveAPI)->getRemarkdessert($numbersequence);
	    $layout  = (new ApproveAPI)->getRemarklayout($numbersequence);
	    $support = (new ApproveAPI)->getRemarksupport($numbersequence);

	    $txt  = "";
	  
	    $txt .= "<table>";
	    $txt .= "<tr><td><b>ชื่อห้องประชุม</b></td> <td colspan=4> : ".$data[0]['room_name']."</td></tr>";
	    $txt .= "<tr><td><b>หัวข้อการประชุม</b></td> <td colspan=4> : ".$data[0]['book_title']."</td></tr>";
	    $txt .= "<tr><td><b>วันที่เริ่มใช้งาน</b></td> <td colspan=4> : ".date("d/m/Y", strtotime($data[0]['book_startdate']))." เวลา : ".$data[0]['book_starttime']."</td></tr>";
	    $txt .= "<tr><td><b>วันที่สิ้นสุด</b></td>  <td colspan=4> : ".date("d/m/Y", strtotime($data[0]['book_enddate']))." เวลา : ".$data[0]['book_endtime']."</td></tr>";
	    $txt .= "<tr><td><b>ผลการอนุมัติ</b></td>  <td colspan=4> : <font color='red'>ไม่อนุมัติ</font></td></tr>";
	    // $txt .= "<tr><td colspan=2><b>รายละเอียด</b> : <a href='http://".$app."/mybooking'>เลือกที่นี่</a>";

	    $txt .= "</table>";
	    return $txt;
	}

	public function getBodyComplete($numbersequence,$sender) {
	    $app  = (new BookingAPI)->getapplocation();
	    $data = (new ApproveAPI)->load($numbersequence);
	    $food = (new ApproveAPI)->getRemarkfood($numbersequence);
	    $dessert = (new ApproveAPI)->getRemarkdessert($numbersequence);
	    $layout  = (new ApproveAPI)->getRemarklayout($numbersequence);
	    $support = (new ApproveAPI)->getRemarksupport($numbersequence);
	    $user = (new ApproveAPI)->load($numbersequence);
	    $txt  = "";
	    $txt .= "<table>";
	    $txt .= "<tr><td><b>ชื่อห้องประชุม</b></td> <td colspan=3> : ".$data[0]['room_name']."</td></tr>";
	    $txt .= "<tr><td><b>ผู้จอง</b></td> <td> : ".$user[0]['fullname']."&nbsp;&nbsp;&nbsp;แผนก : ".$user[0]['dep_name']."</td></tr>";
	    $txt .= "<tr><td><b>หัวข้อการประชุม</b></td> <td colspan=3> : ".$data[0]['book_title']."</td></tr>";
	    $txt .= "<tr><td><b>วันที่เริ่มใช้งาน</b></td> <td colspan=3> : ".date("d/m/Y", strtotime($data[0]['book_startdate']))." เวลา : ".$data[0]['book_starttime']."</td></tr>";
	    $txt .= "<tr><td><b>วันที่สิ้นสุด</b></td>  <td colspan=3> : ".date("d/m/Y", strtotime($data[0]['book_enddate']))." เวลา : ".$data[0]['book_endtime']."</td></tr>";
	    $txt .= "<tr><td><b>สถานะ</b></td>  <td colspan=3> : <font color='green'>จองสำเร็จ</font></td></tr>";

	    // $txt .= "<tr><td colspan=2><b>รายละเอียด</b> : <a href='http://".$app."/complete_hr?numbersequence=".$numbersequence."&mg=".$sender."'>เลือกที่นี่</a>";
	    if (count($layout)>0) {
	    	$txt .= "<tr><td><b>รูปแบบการจัดห้อง</b></td>";

	    	foreach ($layout as $l) {
	    		$txt .= "<td> : ".$l['layout_name']."</td>";
	    		
	    		if ($l['remark_name']=='') {
	    			$txt .= "<td><input type='checkbox' checked='true'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox'>ไม่อนุมัติ</td>";
	    			$txt .= "<td></td>";
	    		}else{
	    			$txt .= "<td><input type='checkbox'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox' checked='true'>ไม่อนุมัติ</td>";
	    			$txt .= "<td><font color='red'>".$l['remark_name']."</font></td>";
	    		}
	    		
	    	}

	    	$txt .= "</tr>";
	    }

	    if (count($food)>0) {
	    	$txt .= "<tr><td><b>อาหาร</b></td>";
	    	$i = 1;
	    	foreach ($food as $f) {
	    		if ($i>1) {
	    			$txt .= "<tr><td></td>";
	    		}
	    		$txt .= "<td> : ".$f['food_name']."</td>";
	    		
	    		if ($f['remark_name']=='') {
	    			$txt .= "<td><input type='checkbox' checked='true'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox'>ไม่อนุมัติ</td>";
	    			$txt .= "<td></td>";
	    		}else{
	    			$txt .= "<td><input type='checkbox'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox' checked='true'>ไม่อนุมัติ</td>";
	    			$txt .= "<td><font color='red'>".$f['remark_name']."</font></td>";
	    		}

	    		if ($i>1) {
	    			$txt .= "</tr>";
	    		}
	    		$i++;
	    	}

	    	$txt .= "</tr>";

	    }

	    if (count($dessert)>0) {
	    	$txt .= "<tr><td><b>ของว่าง</b></td>";
	    	$i = 1;
	    	foreach ($dessert as $d) {
	    		if ($i>1) {
	    			$txt .= "<tr><td></td>";
	    		}
	    		$txt .= "<td> : ".$d['dessert_name']."</td>";
	    		
	    		if ($d['remark_name']=='') {
	    			$txt .= "<td><input type='checkbox' checked='true'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox'>ไม่อนุมัติ</td>";
	    			$txt .= "<td></td>";
	    		}else{
	    			$txt .= "<td><input type='checkbox'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox' checked='true'>ไม่อนุมัติ</td>";
	    			$txt .= "<td><font color='red'>".$d['remark_name']."</font></td>";
	    		}

	    		if ($i>1) {
	    			$txt .= "</tr>";
	    		}
	    		$i++;
	    	}

	    	$txt .= "</tr>";

	    }
	    
	    if (count($support)>0) {
	    	$txt .= "<tr><td><b>คนรับรอง</b></td>";

	    	foreach ($support as $s) {
	    		$txt .= "<td> : ".$s['support_id']." คน</td>";
	    		
	    		if ($s['remark_name']=='') {
	    			$txt .= "<td><input type='checkbox' checked='true'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox'>ไม่อนุมัติ</td>";
	    			$txt .= "<td></td>";
	    		}else{
	    			$txt .= "<td><input type='checkbox'>อนุมัติ</td>";
	    			$txt .= "<td><input type='checkbox' checked='true'>ไม่อนุมัติ</td>";
	    			$txt .= "<td><font color='red'>".$s['remark_name']."</font></td>";
	    		}
	    		
	    	}

	    	$txt .= "</tr>";
	    }

	    $txt .= "<tr><td colspan=2><b>รายละเอียด/ใบสั่งงาน</b> : <a href='http://".$app."/report?id=".$numbersequence."'>เลือกที่นี่</a></td></tr>";

	    $txt .= "</table>";
	    return $txt;
	}

	public function admin_approve($request, $response, $args) 
	{
	    $parsedBody = $request->getParsedBody();

		$numbersequence = 	$parsedBody['bookid'];
		$type			=	$parsedBody['click_type'];
		$booking_room	=	$parsedBody['book_room'];
		$booking_name	=	$parsedBody['title'];
		$booking_starttime	=	$parsedBody['starttime'];
		$booking_endtime	=	$parsedBody['endtime'];
		
		if((new ApproveAPI)->CalendarApprove($numbersequence,$type)===true){

			if ($type=="approve") {

				$mailTo			=	[];
				$mailCC			=	[];
				$mailBCC		=	[];
				$sender			=	$_SESSION['user_email'];
				array_push($mailTo, $_SESSION['user_emailhead']);
				$booking_startdate	=	date("Y-m-d",strtotime($parsedBody['startdate']));
				$booking_enddate	=	date("Y-m-d",strtotime($parsedBody['enddate']));
				
				$subject  = (new BookingAPI)->getSubjectManagerHr($numbersequence);
			    $body     = (new BookingAPI)->getBodyManagerHr($numbersequence,$mailTo[0],$booking_room,$booking_name,$booking_startdate,$booking_starttime,$booking_enddate,$booking_endtime);

				if((new SendMailAPI)->SendMail($mailTo, $mailCC, $mailBCC, $subject , $body , $sender )===true){
					$updateStatus = (new BookingAPI)->updateStatus(3,$numbersequence);
					echo json_encode(["status" => 200, "message" => "ดำเนินการเรียบร้อย"]);
				}else{
					echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาดในการส่งเมลล์"]);
				}

			}else{

				$getallmailuser = (new SendMailAPI)->getmailuser($numbersequence);
				$mailTo			=	[];
				$mailCC			=	[];
				$mailBCC		=	[];
				$sender			=	$_SESSION['user_email'];
				array_push($mailTo, $getallmailuser[0]['email']);
				$booking_startdate	=	date("Y-m-d",strtotime($parsedBody['startdate']));
				$booking_enddate	=	date("Y-m-d",strtotime($parsedBody['enddate']));
				
				$subject  = (new BookingAPI)->getSubjectManagerHr($numbersequence);
			    $body     = self::getBodyUserNotApprove($numbersequence);

				if((new SendMailAPI)->SendMail($mailTo, $mailCC, $mailBCC, $subject , $body , $sender )===true){
					$updateStatus = (new BookingAPI)->updateStatus(6,$numbersequence);
					echo json_encode(["status" => 200, "message" => "ดำเนินการเรียบร้อย"]);
				}else{
					echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาดในการส่งเมลล์"]);
				}

			}
	        
		}else{
			echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด"]);
		}
	}
}