<?php

namespace App\Approve;

use App\Database\Connection;
use Wattanar\Sqlsrv;

class ApproveAPI
{
    public function load($numbersequence)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT B.book_id
            ,B.book_number
            ,B.book_room
            ,R.room_name
            ,B.book_startdate
            ,B.book_enddate
            ,B.book_starttime
            -- ,B.book_endtime
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
            ,U.fname +' '+ U.lname [fullname]
            ,B.book_createdate
            ,B.book_remark
            ,B.book_status
            ,B.book_updatedate
            ,B.book_updateby
            ,B.book_mgdate
            ,B.book_mgby
            ,B.book_admindate
            ,B.book_adminby
            ,B.book_mghrdate
            ,B.book_mghrby
            ,D.dep_name
        FROM booking B
        LEFT JOIN room R ON B.book_room = R.room_id
        LEFT JOIN [user] U ON B.book_create = U.id
        LEFT JOIN department D ON U.department = D.dep_id
        WHERE B.book_number=?",[$numbersequence]
      );
    }

    public function remark()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM remark"
      );
    }

    public function remark_food()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM remark WHERE remark_type_id=1"
      );
    }

    public function remark_layout()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM remark WHERE remark_type_id=2"
      );
    }

    public function remark_support()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM remark WHERE remark_type_id=3"
      );
    }

    public function preg_split_string($params)
    {
        $parts = preg_split("/(,?\s+)|((?<=[a-z])(?=\d))|((?<=\d)(?=[a-z]))/i", $params);
        return $parts[0];
    }

    public function preg_split_int($params)
    {
        $parts = preg_split("/(,?\s+)|((?<=[a-z])(?=\d))|((?<=\d)(?=[a-z]))/i", $params);
        return $parts[1];
    }

    public function updateLayout($numbersequence,$id,$approve,$remark){
        $conn   = (new Connection)->dbConnect();
        $id     = self::preg_split_int($id);
        
        $update =  sqlsrv_query(
            $conn,
            "UPDATE booking_layout SET layout_approve = ?,layout_remark = ?
            WHERE booking_id = ? AND layout_id = ?",[$approve,$remark,$numbersequence,$id]
        );
        if ($update) {
            return true;
        }else{
            return false;
        }

    }

    public function updateFood($numbersequence,$id,$approve,$remark){
        $conn   = (new Connection)->dbConnect();
        $id     = self::preg_split_int($id);
        
        $update =  sqlsrv_query(
            $conn,
            "UPDATE booking_food SET food_approve = ?,food_remark = ?
            WHERE booking_id = ? AND food_id = ? AND food_type = ?",[$approve,$remark,$numbersequence,$id,1]
        );
        if ($update) {
            return true;
        }else{
            return false;
        }

    }

    public function updateDessert($numbersequence,$id,$approve,$remark){
        $conn   = (new Connection)->dbConnect();
        $id     = self::preg_split_int($id);
        
        $update =  sqlsrv_query(
            $conn,
            "UPDATE booking_food SET food_approve = ?,food_remark = ?
            WHERE booking_id = ? AND food_id = ? AND food_type = ?",[$approve,$remark,$numbersequence,$id,2]
        );
        if ($update) {
            return true;
        }else{
            return false;
        }

    }

    public function updateSupport($numbersequence,$id,$approve,$remark){
        $conn   = (new Connection)->dbConnect();
        $id     = self::preg_split_int($id);
        
        $update =  sqlsrv_query(
            $conn,
            "UPDATE booking_support SET support_approve = ?,support_remark = ?
            WHERE booking_id = ? AND support_id = ?",[$approve,$remark,$numbersequence,$id]
        );
        if ($update) {
            return true;
        }else{
            return false;
        }

    }

    public function checkLayoutApprove($numbersequence){
        $conn = (new Connection)->dbConnect();
        $query = Sqlsrv::hasRows(
          $conn,
          "SELECT * FROM booking_layout WHERE booking_id=? AND layout_approve=?",[$numbersequence,0]
        );
        if($query){
            return true;
        }else{
            return false;
        }
    }

    public function checkFoodApprove($numbersequence){
        $conn = (new Connection)->dbConnect();
        $query = Sqlsrv::hasRows(
          $conn,
          "SELECT * FROM booking_food WHERE booking_id=? AND food_approve=?",[$numbersequence,0]
        );
        if($query){
            return true;
        }else{
            return false;
        }
    }

    public function checkSupportApprove($numbersequence){
        $conn = (new Connection)->dbConnect();
        $query = Sqlsrv::hasRows(
          $conn,
          "SELECT * FROM booking_support WHERE booking_id=? AND support_approve=?",[$numbersequence,0]
        );
        if($query){
            return true;
        }else{
            return false;
        }
    }

    public function nextApprove($numbersequence,$mg,$status){
        $conn   = (new Connection)->dbConnect();
        
        if ($status==2) {

            $update =  sqlsrv_query(
            $conn,
            "UPDATE booking SET book_status = ?,book_mgdate = GETDATE(), book_mgby = ?
            WHERE book_number = ?",[$status,$mg,$numbersequence]
            );
            if ($update) {
                return true;
            }else{
                return false;
            }

        }else if($status==4){

            $update =  sqlsrv_query(
            $conn,
            "UPDATE booking SET book_status = ?,book_mghrdate = GETDATE(), book_mghrby = ?
            WHERE book_number = ?",[$status,$mg,$numbersequence]
            );
            if ($update) {
                return true;
            }else{
                return false;
            }

        }
        
    }

    public function CalendarApprove($numbersequence,$type){
        $conn   = (new Connection)->dbConnect();
        
        if ($type=="approve") {

            $update =  sqlsrv_query(
            $conn,
            "UPDATE booking SET book_status = ?,book_admindate = GETDATE(), book_adminby = ?
            WHERE book_number = ? AND book_status != ?",[3,$_SESSION['user_email'],$numbersequence,8]
            );
            if ($update) {
                return true;
            }else{
                return false;
            }

        }else{

            $update =  sqlsrv_query(
            $conn,
            "UPDATE booking SET book_status = ?,book_admindate = GETDATE(), book_adminby = ?
            WHERE book_number = ? AND book_status != ?",[6,$_SESSION['user_email'],$numbersequence,8]
            );
            if ($update) {
                return true;
            }else{
                return false;
            }

        }
        
    }

    public function getRemarkfood($numbersequence)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT F.booking_id,F.food_approve,F.food_id,F.food_remark,D.food_name,R.remark_name
        FROM booking_food F
        LEFT JOIN food D ON F.food_id=D.food_id
        LEFT JOIN remark R ON F.food_remark=R.remark_id
        WHERE F.booking_id = ? AND F.food_type=1",
        [$numbersequence]
      );
    }

    public function getRemarkdessert($numbersequence)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT F.booking_id,F.food_approve,F.food_id,F.food_remark,D.dessert_name,R.remark_name
        FROM booking_food F
        LEFT JOIN dessert D ON F.food_id=D.dessert_id
        LEFT JOIN remark R ON F.food_remark=R.remark_id
        WHERE F.booking_id = ? AND F.food_type=2",
        [$numbersequence]
      );
    }

    public function getRemarklayout($numbersequence)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT F.booking_id,F.layout_approve,F.layout_id,F.layout_remark,L.layout_name,R.remark_name
        FROM booking_layout F
        LEFT JOIN layout L ON F.layout_id=L.layout_id
        LEFT JOIN remark R ON F.layout_remark=R.remark_id
        WHERE F.booking_id = ?",
        [$numbersequence]
      );
    }

    public function getRemarksupport($numbersequence)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT F.booking_id,F.support_approve,F.support_id,F.support_remark,R.remark_name
        FROM booking_support F
        LEFT JOIN remark R ON F.support_remark=R.remark_id
        WHERE F.booking_id = ?",
        [$numbersequence]
      );
    }

    public function loadbyid($remark_id)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT B.book_id
            ,B.book_number
            ,B.book_room
            ,R.room_name
            ,B.book_startdate
            ,B.book_enddate
            ,B.book_starttime
            ,B.book_endtime
            ,B.book_title
            ,B.book_user
            ,B.book_seat
            ,B.book_support
            ,B.book_food
            ,B.book_dessert
            ,B.book_layout
            ,B.book_create
            ,U.fname +' '+ U.lname [fullname]
            ,B.book_createdate
            ,B.book_remark
            ,B.book_status
            ,B.book_updatedate
            ,B.book_updateby
            ,B.book_mgdate
            ,B.book_mgby
            ,B.book_admindate
            ,B.book_adminby
            ,B.book_mghrdate
            ,B.book_mghrby
            ,D.dep_name
        FROM booking B
        LEFT JOIN room R ON B.book_room = R.room_id
        LEFT JOIN [user] U ON B.book_create = U.id
        LEFT JOIN department D ON U.department = D.dep_id
        WHERE B.book_id IN ($remark_id)"
      );
    }

}