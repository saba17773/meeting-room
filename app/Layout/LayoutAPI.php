<?php

namespace App\Layout;

use App\Database\Connection;

use Wattanar\Sqlsrv;

class LayoutAPI
{
    public function load()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM layout"
      );
    }

    public function loadpicture($idlayout)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM layout WHERE layout_id = ?",array($idlayout)
      );
    }

    public function create($layout_name,$file)
    {
      $conn = (new Connection)->dbConnect();
      
      $create = sqlsrv_query(
        $conn,
        "INSERT layout (layout_name,layout_picture)
        VALUES(?,?)",
        array(
          $layout_name,$file
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

    public function update($layout_name,$file,$layout_id)
    {
      $conn = (new Connection)->dbConnect();
      
      if ($file=='nofile') {
        $update = sqlsrv_query(
          $conn,
          "UPDATE layout SET layout_name=?
          WHERE layout_id=?",
          array(
            $layout_name,$layout_id
          )
        );
      }else{
        $update = sqlsrv_query(
          $conn,
          "UPDATE layout SET layout_name=?,layout_picture=?
          WHERE layout_id=?",
          array(
            $layout_name,$file,$layout_id
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

    public function delete($layout_id)
    {
      $conn = (new Connection)->dbConnect();
      
      $delete = sqlsrv_query(
        $conn,
        "DELETE FROM layout
        WHERE layout_id=?",[$layout_id]
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