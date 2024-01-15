<?php

namespace App\Room;

use App\Database\Connection;

use Wattanar\Sqlsrv;

class RoomAPI
{
    public function load()
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
      return Sqlsrv::rows(
        $conn,
        "SELECT R.room_id
              ,R.room_name
              ,R.room_company
              ,R.room_floor
              ,R.room_max_seat
              ,R.room_tool
              ,R.room_picture
              ,R.room_sort
              ,R.room_active
              ,R.room_codecolor
              ,C.com_fname
              ,C.com_nname
        FROM room R
        JOIN company C ON R.room_company=C.com_id AND R.room_company IN ($session_per)
        -- WHERE R.room_active=1
        ORDER BY R.room_company,R.room_name ASC"
      );

    }

    public function load_bycomp($comp)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT R.room_id
              ,R.room_name
              ,R.room_company
              ,R.room_floor
              ,R.room_max_seat
              ,R.room_tool
              ,R.room_picture
              ,R.room_sort
              ,R.room_active
              ,C.com_fname
              ,C.com_nname
        FROM room R
        JOIN company C ON R.room_company=C.com_id
        WHERE com_nname=?
        ORDER BY R.room_company,R.room_name ASC",[$comp]
      );
    }

    public function load_byroom($room)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT R.room_id
              ,R.room_name
              ,R.room_company
              ,R.room_floor
              ,R.room_max_seat
              ,R.room_tool
              ,R.room_picture
              ,R.room_sort
              ,R.room_active
              ,C.com_fname
              ,C.com_nname
        FROM room R
        JOIN company C ON R.room_company=C.com_id
        WHERE room_id=?",[$room]
      );
    }

    public function loadtool($tool)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM tool WHERE tool_id=?",[$tool]
      );
    }

    public function loadtoolAll()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM tool"
      );
    }

    public function loadcompany()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM company"
      );
    }
    
    public function loadcompany_byper()
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

      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM company WHERE com_id IN ($session_per)"
      );
    }

    public function loaddepartment()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM department"
      );
    }

    public function create($room_name,$room_company,$room_floor,$room_seat,$room_tool,$file,$active)
    {
      $conn = (new Connection)->dbConnect();
      
      $create = sqlsrv_query(
        $conn,
        "INSERT room (room_name,room_company,room_floor,room_max_seat,room_tool,room_picture,room_active)
        VALUES(?,?,?,?,?,?,?)",
        array(
          $room_name,$room_company,$room_floor,$room_seat,$room_tool,$file,$active
        )
      );
      if ($create) {
        return [
          "result" => true,
          "message" => "Successful !"
        ];
      }else{
        return [
          "result" => false,
          "message" => "Failed !"
        ];
      }
    }

    public function update($room_name,$room_company,$room_floor,$room_seat,$room_tool,$file,$active,$room_id)
    {
      $conn = (new Connection)->dbConnect();
      
      if ($file=='nofile') {
        $update = sqlsrv_query(
          $conn,
          "UPDATE room SET room_name=?,room_company=?,room_floor=?,room_max_seat=?,room_tool=?,room_active=?
          WHERE room_id=?",
          array(
            $room_name,$room_company,$room_floor,$room_seat,$room_tool,$active,$room_id
          )
        );
      }else{
        $update = sqlsrv_query(
          $conn,
          "UPDATE room SET room_name=?,room_company=?,room_floor=?,room_max_seat=?,room_tool=?,room_picture=?,room_active=?
          WHERE room_id=?",
          array(
            $room_name,$room_company,$room_floor,$room_seat,$room_tool,$file,$active,$room_id
          )
        );
      }
      
      if ($update) {
        return [
          "result" => true,
          "message" => "Successful !"
        ];
      }else{
        return [
          "result" => false,
          "message" => "Failed !"
        ];
      }
    }

    public function delete($room_id)
    {
      $conn = (new Connection)->dbConnect();
      
      $delete = sqlsrv_query(
        $conn,
        "DELETE FROM room
        WHERE room_id=?",[$room_id]
      );

      if ($delete) {
        return [
          "result" => true,
          "message" => "Successful !"
        ];
      }else{
        return [
          "result" => false,
          "message" => "Failed !"
        ];
      }

    }
}