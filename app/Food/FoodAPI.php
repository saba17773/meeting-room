<?php

namespace App\Food;

use App\Database\Connection;

use Wattanar\Sqlsrv;

class FoodAPI
{
    public function load()
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM food"
      );
    }

    public function loadpicture($idfood)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM food WHERE food_id = ?",array($idfood)
      );
    }

    public function loadpicturedessert($idfood)
    {
      $conn = (new Connection)->dbConnect();
      return Sqlsrv::rows(
        $conn,
        "SELECT *
        FROM dessert WHERE dessert_id = ?",array($idfood)
      );
    }

    public function create($food_name,$food_price,$file)
    {
      $conn = (new Connection)->dbConnect();
      
      $create = sqlsrv_query(
        $conn,
        "INSERT food (food_name,food_price,food_picture)
        VALUES(?,?,?)",
        array(
          $food_name,$food_price,$file
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

    public function update($food_name,$food_price,$file,$food_id)
    {
      $conn = (new Connection)->dbConnect();
      
      if ($file=='nofile') {
        $update = sqlsrv_query(
          $conn,
          "UPDATE food SET food_name=?,food_price=?
          WHERE food_id=?",
          array(
            $food_name,$food_price,$food_id
          )
        );
      }else{
        $update = sqlsrv_query(
          $conn,
          "UPDATE food SET food_name=?,food_price=?,food_picture=?
          WHERE food_id=?",
          array(
            $food_name,$food_price,$file,$food_id
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

    public function delete($food_id)
    {
      $conn = (new Connection)->dbConnect();
      
      $delete = sqlsrv_query(
        $conn,
        "DELETE FROM food
        WHERE food_id=?",[$food_id]
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