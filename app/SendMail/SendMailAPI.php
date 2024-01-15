<?php

namespace App\SendMail;

use Wattanar\Sqlsrv;
use App\Database\Connection;

class SendMailAPI
{
	public function getmailhead() {
        $conn = (new Connection)->dbConnect();
        $session_user   = $_SESSION['user_id'];
        return Sqlsrv::rows(
          $conn,
          "SELECT * FROM [user] WHERE id = ?",[$session_user]
        );
    }

    public function getmailadmin($numbersequence) {
        $conn = (new Connection)->dbConnect();
        
        $getcreate = Sqlsrv::rows(
            $conn,
            "SELECT TOP 1 b.book_create,r.room_company FROM booking b 
              LEFT JOIN [user] u ON b.book_create=u.id
              LEFT JOIN [room] r ON b.book_room=R.room_id
              WHERE b.book_number = ? ",[$numbersequence]
        );

        $companyroom = $getcreate[0]['room_company'];

        return Sqlsrv::rows(
          $conn,
          "SELECT U.email FROM [user] U 
            LEFT JOIN permissioncompany P  ON U.permission_company=P.permission_id
            WHERE U.status = ?
            AND U.department = ?
            AND P.permission_company LIKE '%$companyroom%'",["A","2"]
        );
    }

    public function getmailuser($numbersequence) {
        $conn = (new Connection)->dbConnect();
        return Sqlsrv::rows(
          $conn,
          "SELECT TOP 1 B.book_create,U.email
            FROM booking B
            LEFT JOIN [user] U ON B.book_create = U.id
            WHERE B.book_number=?",[$numbersequence]
        );
    }

    public function getallmailmg($numbersequence) {
        $conn = (new Connection)->dbConnect();
        return Sqlsrv::rows(
          $conn,
          "SELECT TOP 1 B.book_mgby
            FROM booking B
            WHERE B.book_number=?",[$numbersequence]
        );
    }

    public function getallmailadmin($numbersequence) {
        $conn = (new Connection)->dbConnect();
        return Sqlsrv::rows(
          $conn,
          "SELECT TOP 1 B.book_adminby
            FROM booking B
            WHERE B.book_number=?",[$numbersequence]
        );
    }

    public function SendMail($mailTo = [], $mailCC = [], $BCC = [], $subject = '', $body = '', $sender = '') {
	   
	   	if ($sender === '') {
			$sender_mail = 'meetingroom_system@deestone.com';
		} else {
			$sender_mail = $sender;
		}

        $mail = new \PHPMailer;
        $mail->isSMTP();
        $mail->Host = 'idc.deestone.com';  
        $mail->SMTPAuth = true;  
        $mail->SMTPSecure = "ssl";                             
        // $mail->Username = 'ea_devteam@deestone.com';
        // $mail->Password = '$devT$78420';
        $mail->Username = 'webadministrator@deestone.com';
        $mail->Password = 'W@dmIn$02587';
        $mail->CharSet = "utf-8";
        $mail->Port = 587; 
        $mail->SMTPOptions = array( 
            'ssl' => array( 
                'verify_peer' => false, 
                'verify_peer_name' => false, 
                'allow_self_signed' => true 
            ) 
        );
        $mail->From = $sender_mail;
        $mail->FromName = 'MEETING ROOM';
        $mail->Sender = 'webadministrator@deestone.com';
        // $mail->setFrom($sender_mail, $sender_mail);
        // $mail->setFrom('ea_devteam@deestone.com', $sender_mail);
        // $mail->addReplyTo($sender_mail);
        
        if (count($mailTo) > 0) {
			foreach ($mailTo as $customerMailTo) {
				$mail->addAddress($customerMailTo);
			}
		} else {
			return ['result' => false, 'message' => 'No recipients mail.'];
		}

        if (count($mailCC) > 0) {
			foreach ($mailCC as $customerMailCC) {
				$mail->addCC($customerMailCC);
			}
		}

		if (count($BCC) > 0) {
			foreach ($BCC as $MAIL_BCC) {
				$mail->addBCC($MAIL_BCC);
			}
		}
		
        $mail->isHTML(true);  
        $mail->SMTPOptions = array( 
            'ssl' => array( 
                'verify_peer' => false, 
                'verify_peer_name' => false, 
                'allow_self_signed' => true 
            ) 
        );
            
        $mail->Subject =  $subject;
            
        $mail->Body    = $body;
                    
        if(!$mail->send()){
           // echo json_encode(["status" => 404, "message" => $mail->ErrorInfo]);
            return false;
        }else{
           // echo json_encode(["status" => 200, "message" => "Send Success"]);
            return true;
        }

	}

    public function getSubjectComplete($numbersequence) {
        $txt = '';
        $txt .= "แจ้งสถานะการขอใช้ห้องประชุม รายการที่ ".$numbersequence;
        return $txt;
    }

}