<?php

namespace App\Database;

use Wattanar\Sqlsrv;

class Connection
{
  public function dbConnect()
  {
   
    return Sqlsrv::connect(
      'xxxxx',
      'sa',
      'xxx',
      'MeetingRoom2018'
    );
  }
}