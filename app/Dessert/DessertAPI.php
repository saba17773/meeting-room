<?php

namespace App\Dessert;

use App\Database\Connection;

use Wattanar\Sqlsrv;

class DessertAPI
{
    public function load()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM dessert"
      );
    }

    public function create($dessert_name,$dessert_price,$file)
    {
      $conn = (new Connection)->dbConnect();
      
      $create = sqlsrv_query(
        $conn,
        "INSERT dessert (dessert_name,dessert_price,dessert_picture)
        VALUES(?,?,?)",
        array(
          $dessert_name,$dessert_price,$file
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

    public function update($dessert_name,$dessert_price,$file,$dessert_id)
    {
      $conn = (new Connection)->dbConnect();
      
      if ($file=='nofile') {
        $update = sqlsrv_query(
          $conn,
          "UPDATE dessert SET dessert_name=?,dessert_price=?
          WHERE dessert_id=?",
          array(
            $dessert_name,$dessert_price,$dessert_id
          )
        );
      }else{
        $update = sqlsrv_query(
          $conn,
          "UPDATE dessert SET dessert_name=?,dessert_price=?,dessert_picture=?
          WHERE dessert_id=?",
          array(
            $dessert_name,$dessert_price,$file,$dessert_id
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

    public function delete($dessert_id)
    {
      $conn = (new Connection)->dbConnect();
      
      $delete = sqlsrv_query(
        $conn,
        "DELETE FROM dessert
        WHERE dessert_id=?",[$dessert_id]
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