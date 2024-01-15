<?php

namespace App\Booking;

use App\Booking\BookingAPI;
use App\SendMail\SendMailAPI;
use App\Approve\ApproveAPI;

class BookingController extends \App\Base\BaseController
{
  public function checkRoom($request, $response, $args) {
    return $this->renderView('pages/booking/check_room');
  }

  public function bookingReport($request, $response, $args) {
    return $this->renderView('pages/booking/report');
  }

  public function getBook($request, $response, $args) {
    return $response->withJson( (new BookingAPI)->getBookingReport() );
  }

  public function weekly($request, $response, $args) {
    return $response->withJson( (new BookingAPI)->getweekly() );
  }

  public function timein($request, $response, $args) {
    return $response->withJson( (new BookingAPI)->getTimein() );
  }

  public function timeout($request, $response, $args) {
    return $response->withJson( (new BookingAPI)->getTimeout() );
  }

  public function create($request, $response, $args)
  {
    $parsedBody = $request->getParsedBody();

    $booking_room       = $parsedBody['booking_roomid'];
    $booking_startdate  = date("Y-m-d",strtotime($parsedBody['booking_startdate']));
    $booking_enddate    = date("Y-m-d",strtotime($parsedBody['booking_enddate']));
    $booking_starttime  = $parsedBody['booking_starttime'];
    $booking_endtime    = $parsedBody['booking_endtime'];
    $booking_name       = $parsedBody['booking_name'];
    $booking_user       = $parsedBody['booking_user'];
    $booking_seat       = $parsedBody['booking_seat'];
    $booking_supportchk = $parsedBody['booking_supportchk'];
    $booking_layout     = $parsedBody['layoutpicid'];
    $booking_remark     = $parsedBody['booking_remark'];
    
    $_food              = null;
    $_dessert           = null;

    if (isset($parsedBody['booking_loopcheck'])) {
      $booking_loopdate   = $parsedBody['booking_loopdate'];
    }else{
      $booking_loopdate   = '0';
    }
    // echo $booking_loopdate;
    // exit();
    
    if ($booking_loopdate != '0') {
      
      $date = self::date_in_period("D-Y-m-d", $booking_startdate, $booking_enddate,array($booking_loopdate));
      $idTrans = 0;
      $x = '';
      foreach($date as $day){
        if (substr($day,0,3) != "Sun") { 
            $book_weekly = substr($day,0,3);
            $dateincorrect = substr($day,4);
            $checkBooking = (new BookingAPI)->checkBooking($dateincorrect,$dateincorrect,$booking_starttime,$booking_endtime,$booking_room,$idTrans);
            if ($checkBooking==true) {
              $x = 'room is booking';
            }

        }
      }
      if ($x == 'room is booking') {
        echo json_encode(["status" => 404, "message" => "มีการจองไปแล้ว !!"]);
        exit();
      }

    }else{
      
      $idTrans = 0;
      $checkBooking = (new BookingAPI)->checkBooking($booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime,$booking_room,$idTrans);
      if ($checkBooking==true) {
        echo json_encode(["status" => 404, "message" => "มีการจองไปแล้ว !"]);
        exit();
      }

    }

    // $idTrans = 0;
    // $checkBooking = (new BookingAPI)->checkBooking($booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime,$booking_room,$idTrans);
    // if ($checkBooking==true) {
    //   echo json_encode(["status" => 404, "message" => "มีการจองไปแล้ว !"]);
    //   exit();
    // }
    
    if (isset($parsedBody['booking_chkfood'])) {
      // check foood
      if (isset($parsedBody['food'])) {
        $food               = $parsedBody['food'];
        $food_unit          = $parsedBody['food_unit'];

        if (count($food>0)) {
          $_food = array_combine($food, $food_unit);
        }else{
          $_food = "";
        }

      }

      // check dessert
      if (isset($parsedBody['dessert'])) {
        $dessert               = $parsedBody['dessert'];
        $dessert_unit          = $parsedBody['dessert_unit'];

        if (count($dessert>0)) {
          $_dessert = array_combine($dessert, $dessert_unit);
        }else{
          $_dessert = "";
        }

      }

    }

    // check Support
    if ($booking_supportchk==1) {
      $booking_support    = $parsedBody['booking_support'];
    }else{
      $booking_support = null;
    }

    // Get NumberSequence
    $numbersequence     = (new BookingAPI)->getsequence('get');
    
    $booking = (new BookingAPI)->create($booking_loopdate,$booking_room,$numbersequence,$booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime,$booking_name,$booking_user,$booking_seat,$booking_remark,$_food,$_dessert,$booking_layout,$booking_support);

    echo $booking;
    exit();

  }

  public function update($request, $response, $args)
  {
    $parsedBody = $request->getParsedBody();

    $booking_room           = $parsedBody['booking_roomname']; 
    $booking_startdate_old  = date("Y-m-d",strtotime($parsedBody['booking_startdate_old']));
    $booking_enddate_old    = date("Y-m-d",strtotime($parsedBody['booking_enddate_old']));
    $booking_startdate      = date("Y-m-d",strtotime($parsedBody['booking_startdate']));
    $booking_enddate        = date("Y-m-d",strtotime($parsedBody['booking_enddate']));
    $booking_starttime      = $parsedBody['booking_starttime'];
    $booking_endtime        = $parsedBody['booking_endtime'];
    $booking_name           = $parsedBody['booking_name'];
    $booking_user           = $parsedBody['booking_user'];
    $booking_seat           = $parsedBody['booking_seat'];
    $booking_remark         = $parsedBody['booking_remark'];
    $booking_supportchk     = $parsedBody['booking_supportchk'];
    $booking_layout         = $parsedBody['booking_layout'];
    $booking_number         = $parsedBody['booking_number'];
    $click_type             = $parsedBody['click_type'];
    // $booking_loopdate       = $parsedBody['booking_loopdate'];

    // check foood
    $_food    = null;
    $_dessert = null;

    if (isset($parsedBody['booking_loopcheck'])) {
      $booking_loopcheck   = '1';
    }else{
      $booking_loopcheck   = '0';
    }

    if (isset($parsedBody['booking_loopcheck'])) {
      $booking_loopdate   = $parsedBody['booking_loopdate'];
    }else{
      $booking_loopdate   = '0';
    }

    // echo "<pre>".print_r($parsedBody,true)."</pre>";
    // exit();
    $idTrans = $booking_number;
    $checkBooking = (new BookingAPI)->checkBooking($booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime,$booking_room,$idTrans);
    if ($checkBooking==true) {
      echo json_encode(["status" => 404, "message" => "มีการจองไปแล้ว !"]);
      exit();
    }

    // check foood
    if (isset($parsedBody['food'])) {
      $food               = $parsedBody['food'];
      $food_unit          = $parsedBody['food_unit'];

      if (count($food>0)) {
        $_food = array_combine($food, $food_unit);
      }else{
        $_food = "";
      }

    }

    // check dessert
    if (isset($parsedBody['dessert'])) {
      $dessert               = $parsedBody['dessert'];
      $dessert_unit          = $parsedBody['dessert_unit'];

      if (count($dessert>0)) {
        $_dessert = array_combine($dessert, $dessert_unit);
      }else{
        $_dessert = "";
      }

    }

    // check Support
    if ($booking_supportchk==1) {
      $booking_support    = $parsedBody['booking_support'];
    }else{
      $booking_support = null;
    }

    if ($booking_startdate_old == $booking_startdate && $booking_enddate_old == $booking_enddate) {  
      $loopdate = 0;
    }else{
      $loopdate = 1;
    }

    $numbersequence     = $booking_number;
 
    $booking = (new BookingAPI)->update($booking_loopcheck,$booking_loopdate,$loopdate,$booking_room,$numbersequence,$booking_startdate,$booking_enddate,$booking_starttime,$booking_endtime,$booking_name,$booking_user,$booking_seat,$booking_remark,$_food,$_dessert,$booking_layout,$booking_support,$click_type);

    echo $booking;

  }

  public function daletefood($request, $response, $args)
  {
    $parsedBody = $request->getParsedBody();
    $food_id        = $parsedBody['food_id'];
    $booking_id     = $parsedBody['booking_id'];
    $type           = $parsedBody['type'];
    
    $delete = (new BookingAPI)->deletefood($food_id,$booking_id,$type);

  }

  public function getSubjectManagerUser($numbersequence)
  {
    $txt = '';
    $txt .= "แจ้งสถานะการขอใช้ห้องประชุม รายการที่ ".$numbersequence;
    return $txt;
  }

  public function getBodyManagerUser($numbersequence,$to)
  {
    $app  = self::getapplocation();
    $data = (new ApproveAPI)->load($numbersequence);
    $txt  = "";
    $txt .= "<table>";
    $txt .= "<tr><td><b>ชื่อห้องประชุม</b></td> <td> : ".$data[0]['room_name']."</td></tr>";
    $txt .= "<tr><td><b>หัวข้อการประชุม</b></td> <td> : ".$data[0]['book_title']."</td></tr>";
    $txt .= "<tr><td><b>วันที่เริ่มใช้งาน</b></td><td> : ".date("d/m/Y", strtotime($data[0]['book_startdate']))." เวลา : ".$data[0]['book_starttime']."</td></tr>";
    $txt .= "<tr><td><b>วันที่สิ้นสุด</b></td>  <td> : ".date("d/m/Y", strtotime($data[0]['book_enddate']))." เวลา : ".$data[0]['book_endtime']."</td></tr>";
    $txt .= "<tr><td colspan=2><b>รายละเอียด/ลิ้งค์อนุมัติ</b> : <a href='http://".$app."/mg_approve_user?numbersequence=".$numbersequence."&mg=".$to."'>เลือกที่นี่</a></td></tr>";
    $txt .= "</table>";
    return $txt;
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

  public function cancel($request, $response, $args)
  {
    $parsedBody = $request->getParsedBody();
    $booking_number = $parsedBody['book_number'];
    
    $cancel = (new BookingAPI)->cancel($booking_number);
    if ($cancel===true) {
      echo json_encode(["status" => 200, "message" => "ดำเนินการยกเลิกเรียบร้อย !"]);
    }else{
      echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด !"]);
    }

  }

  public function cancel_id($request, $response, $args)
  {
    $parsedBody = $request->getParsedBody();
    $txt_remark = $parsedBody['txt_remark'];
    $remark_id  = $parsedBody['remark_id'];
    $numbersequence  = $parsedBody['numbersequence'];

    $remark_id = implode(",", $remark_id);
      
    $cancel = (new BookingAPI)->cancel_id($remark_id,$txt_remark);
    if ($cancel===true) {
      if ($_SESSION['user_status']=="A") {

          $getallmailuser = (new SendMailAPI)->getmailuser($numbersequence);
          $mailTo     = [];
          $mailCC     = [];
          $mailBCC    = [];
          $sender     = $_SESSION['user_email'];
          array_push($mailTo, $getallmailuser[0]['email']);
          
          $subject  = self::getSubjectManagerUser($numbersequence);
          $body     = self::getBodyCancel($remark_id,$txt_remark);

          if((new SendMailAPI)->SendMail($mailTo, $mailCC, $mailBCC, $subject , $body , $sender )===true){
            echo json_encode(["status" => 200, "message" => "ดำเนินการยกเลิกเรียบร้อย"]);
          }else{
            echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาดในการส่งเมลล์"]);
          }
          
      }else{
        echo json_encode(["status" => 200, "message" => "ดำเนินการยกเลิกเรียบร้อย !"]);
      }
    }else{
      echo json_encode(["status" => 404, "message" => "เกิดข้อผิดพลาด !"]);
    }

  }

  public function getBodyCancel($remark_id,$txt_remark)
  {
    $data = (new ApproveAPI)->loadbyid($remark_id);
    $txt  = "";
    $txt .= "<table>";
    $txt .= "<tr><td><b>ชื่อห้องประชุม</b></td> <td colspan=4> : ".$data[0]['room_name']."</td></tr>";
    $txt .= "<tr><td><b>หัวข้อการประชุม</b></td> <td colspan=4> : ".$data[0]['book_title']."</td></tr>";

    foreach ($data as $value) {
      $txt .= "<tr><td><b>วันที่ใช้งาน</b></td> <td colspan=4> : ".date("d/m/Y", strtotime($value['book_startdate']))." เวลา : ".$value['book_starttime']." - ".$value['book_endtime']."</td></tr>";
    }
    
    $txt .= "<tr><td><b>ผลการอนุมัติ</b></td>  <td colspan=4> : <font color='red'>ยกเลิกการจอง</font></td></tr>";
    $txt .= "<tr><td><b>สาเหตุ</b></td>  <td colspan=4> : ".$txt_remark."</td></tr>";
    $txt .= "</table>";
    return $txt;
  }

  public function getapplocation()
  {
    return "192.168.90.35:8809";
  }

}