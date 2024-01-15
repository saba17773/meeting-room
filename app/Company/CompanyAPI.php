<?php

namespace App\Company;

use App\Database\Connection;
use Wattanar\Sqlsrv;

class CompanyAPI
{
  public function getAll() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT * FROM Company"
    );
  }
}