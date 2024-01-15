<?php

function is_logged_in() {
  if ( isset($_SESSION['user_id']) && $_SESSION['user_id'] !== null) {
    return true;
  } 
  return false;
}

function get_user_fullname() {
	if ( is_logged_in() === true ) {
		$user = new \App\User\UserAPI;
		echo $user->getFullname();
	} else {
		echo "กรุณาเข้าสู่ระบบ";
	}
}