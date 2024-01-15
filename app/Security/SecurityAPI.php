<?php

namespace App\Security;

class SecurityAPI
{
  
  public function PermissionSession() {
    if ($_SESSION["user_status"]=="A") {
      return true;
    }else{
      return false;
    }
  }

}