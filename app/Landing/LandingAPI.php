<?php

namespace App\Landing;

use App\Database\Connection;
use Wattanar\Sqlsrv;

class LandingAPI
{
	public function load() {
	    $conn = (new Connection)->dbConnect($numbersequence);
	    return Sqlsrv::rows(
	      $conn,
	      "SELECT B.book_number
	              ,B.book_room
	              ,BS.book_startdate
	              ,BE.book_enddate
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
	              ,B.book_remark
	              ,B.book_status
	              ,R.room_name
	              ,S.status_description
	      FROM  booking B
	      LEFT JOIN room R ON B.book_room = R.room_id
	      LEFT JOIN status S ON B.book_status = S.status_id
	      JOIN 
	     (
	      SELECT MIN(book_startdate)book_startdate,book_number
	      FROM booking BS
	      GROUP BY BS.book_number
	     )BS
	     ON BS.book_number = B.book_number
	      JOIN 
	     (
	      SELECT MAX(book_enddate)book_enddate,book_number
	      FROM booking BE
	      GROUP BY BE.book_number
	     )BE
	     ON BE.book_number = B.book_number
	     WHERE B.book_number=?
	      GROUP BY B.book_number
	              ,B.book_room
	              ,BS.book_startdate
	              ,BE.book_enddate
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
	              ,B.book_remark
	              ,B.book_status
	              ,R.room_name
	              ,S.status_description",[$numbersequence]
	    );
	}
}