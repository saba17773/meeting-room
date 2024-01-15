<?php

namespace App\Tool;

use App\Database\Connection;
use Wattanar\Sqlsrv;

class ToolAPI
{
  public function load() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT * FROM tool"
    );
  }

  public function update($tool_name,$tool_id){
    
    $conn = (new Connection)->dbConnect();
    $update = sqlsrv_query(
      $conn,
      "UPDATE tool SET tool_name=?
      WHERE tool_id=?",[$tool_name,$tool_id]
    );

    if($update){
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

  public function create($tool_name){
    
    $conn = (new Connection)->dbConnect();
    $create = sqlsrv_query(
      $conn,
      "INSERT tool (tool_name)
      VALUES (?)",array($tool_name)
    );

    if($create){
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

  public function loadremark() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT R.*,T.type_name FROM remark R LEFT JOIN remark_type T ON R.remark_type_id=T.type_id"
    );
  }

  public function remark_create($remark,$remark_type){
    
    $conn = (new Connection)->dbConnect();
    $create = sqlsrv_query(
      $conn,
      "INSERT remark (remark_name,remark_type_id)
      VALUES (?,?)",array($remark,$remark_type)
    );

    if($create){
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

  public function remark_update($remark,$remark_type,$id){
    
    $conn = (new Connection)->dbConnect();
    $update = sqlsrv_query(
      $conn,
      "UPDATE remark SET remark_name=?, remark_type_id=?
      WHERE remark_id=?",[$remark,$remark_type,$id]
    );

    if($update){
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

  public function loadremarktype() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT * FROM remark_type"
    );
  }

}