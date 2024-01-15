<?php

namespace App\User;

use App\Database\Connection;
use Wattanar\Sqlsrv;
use App\SendMail\SendMailAPI;
use App\Booking\BookingAPI;

class UserAPI
{
  public function isUser($username, $password) {
    $conn = (new Connection)->dbConnect();
    return sqlsrv_has_rows(sqlsrv_query(
      $conn,
      "SELECT * FROM [user] where username = ? and [password] = ? and USERACTIVE = ? ",
      [
        $username,
        $password,
        1
      ]
    ));
  }

  public function getUserId($username) {
    $conn = (new Connection)->dbConnect();
    $rows = Sqlsrv::rows(
      $conn,
      "SELECT * FROM [user] where username = ?",
      [
        $username
      ]
    );
    return $rows;
  }

  public function getFullname() {
    $conn = (new Connection)->dbConnect();
    $rows = Sqlsrv::rows(
      $conn,
      "SELECT * FROM [user] where id = ?",
      [
        $_SESSION['user_id']
      ]
    );
    return $rows[0]['fname'].' '.$rows[0]['lname'];
  }

  public function load() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT U.id
            ,U.username
            ,U.password
            ,U.password_hashed
            ,U.fname
            ,U.lname
            ,U.tell
            ,U.email
            ,U.email_head
            ,U.company
            ,U.department
            ,U.status
            ,U.see_com
            ,U.user_active
            ,C.com_nname
            ,D.dep_name
            ,U.permission_company
            ,P.permission_name
            ,U.EMPID
            ,U.USERACTIVE
            ,CASE 
              WHEN U.status = 'U' THEN 'User'
              WHEN U.status = 'A' THEN 'Admin'
            END [status_name]
      from [user] U
      left join company C on U.company = C.com_id
      left join department D on U.department = D.dep_id
      left join permissioncompany P on U.permission_company = P.permission_id"
    );
  }

  public function load_emailhead() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT * from emailhead"
    );
  }

  public function loadpermission() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT * FROM [permissioncompany]"
    );
  }

  public function loadstatus() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT status[status_id],
      CASE  
       WHEN status='A' THEN 'Admin'
       WHEN status='U' THEN 'User' END [status_name]
      FROM [user]
      GROUP BY status"
    );
  }

  public function companyload() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT * FROM [company]"
    );
  }

  public function update($password, $fname, $lname, $tell, $email, $active, $company, $department, $permission, $id){

    $conn = (new Connection)->dbConnect();

    $getcompany = Sqlsrv::rows(
      $conn,
      "SELECT com_id FROM company WHERE com_nname=?",[$company]
    );

    $getdepartment = Sqlsrv::rows(
      $conn,
      "SELECT dep_id FROM department WHERE dep_name=?",[$department]
    );

    $getpermission = Sqlsrv::rows(
      $conn,
      "SELECT permission_id FROM permissioncompany WHERE permission_name=?",[$permission]
    );
    
    $companyid    = $getcompany[0][0];
    $departmentid = $getdepartment[0][0];
    $permissionid = $getpermission[0][0];

    $update = sqlsrv_query(
      $conn,
      "UPDATE [user] SET password=?, fname=?, lname=?, tell=?, email=?, user_active=?, company=?, department=?, permission_company=?
      WHERE id=?",
      array(
        $password, $fname, $lname, $tell, $email, $active, $companyid, $departmentid, $permissionid, $id
      )
    );

    if ($update) {
      return [
        "result" => true,
        "message" => "Update Successful !"
      ];
    }else{
      return [
        "result" => false,
        "message" => "Update Failed !"
      ];
    }

  }

  public function create($user_employee,$username, $password, $fname, $lname, $tel, $email, $company, $department, $permission, $status, $emailhead, $active, $form_type, $id){

    $conn = (new Connection)->dbConnect();

    if ($form_type=="create") {
      
      $create = sqlsrv_query(
        $conn,
        "INSERT [user] 
        (EMPID,USERACTIVE,username,password,fname,lname,tell,email,company,department,permission_company,status,user_active,email_head)
        VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        array(
          $user_employee, 1, $username, $password, $fname, $lname, $tel, $email, $company, $department, $permission, $status,1,$emailhead
        )
      );

      if ($create) {

        $InsertLogUser = sqlsrv_query(
            $conn,
            "INSERT INTO [EA_APP].[dbo].[TB_USER_APP] (EMP_CODE,USER_NAME,HOST_NAME,PROJECT_NAME,CREATE_DATE)
            VALUES (?,?,?,?,getdate())",
            [
              $user_employee,
              $username,
              gethostbyaddr($_SERVER['REMOTE_ADDR']),
              'Meeting Room'
            ]
        );
        
        return [
          "result" => true,
          "message" => "Create Successful !"
        ];
      }else{
        return [
          "result" => false,
          "message" => "Create Failed !"
        ];
      }

    }else{

      $update = sqlsrv_query(
        $conn,
        "UPDATE [user] SET 
        EMPID=?, USERACTIVE=?, username=? , password=? , fname=? , lname=? , tell=? , email=? , company=? , department=? , permission_company=? , status=? , email_head=?
        WHERE id=?",[$user_employee,$active,$username, $password, $fname, $lname, $tel, $email, $company, $department, $permission, $status, $emailhead ,$id]       
      );

      if ($update) {

        if ($active==1) {
          $InsertLogUser = sqlsrv_query(
                $conn,
                "INSERT INTO [EA_APP].[dbo].[TB_USER_APP] (EMP_CODE,USER_NAME,HOST_NAME,PROJECT_NAME,CREATE_DATE)
                VALUES (?,?,?,?,getdate())",
                [
                  $user_employee,
                  $username,
                  gethostbyaddr($_SERVER['REMOTE_ADDR']),
                  'Meeting Room'
                ]
            );
        }else{
          $DeleteLogUser = sqlsrv_query(
            $conn,
            "UPDATE [EA_APP].[dbo].[TB_USER_APP]
            SET UPDATE_DATE = getdate(), STATUS = ?
            WHERE EMP_CODE = ? AND  USER_NAME= ? AND PROJECT_NAME = ?",
            [
              0,
              $user_employee,
              $username,
              'Meeting Room'
            ]
          );
        }

        return [
          "result" => true,
          "message" => "Update Successful !"
        ];
      }else{
        return [
          "result" => false,
          "message" => "Update Failed !"
        ];
      }

    }   

  }

  public function update_email_head($email_head,$id){
    $conn = (new Connection)->dbConnect();
    $update = sqlsrv_query(
      $conn,
      "UPDATE [user] SET email_head=?
      WHERE id=?",
      array(
        $email_head, $id
      )
    );

    if ($update) {
      return [
        "result" => true,
        "message" => "Set E-mail Successful !"
      ];
    }else{
      return [
        "result" => false,
        "message" => "Set E-mail Failed !"
      ];
    }

  }

  public function profile_update($username,$password,$tel){
    $conn = (new Connection)->dbConnect();
    $update = sqlsrv_query(
      $conn,
      "UPDATE [user] SET password=?,tell=?
      WHERE username=?",
      array(
        $password,$tel,$username
      )
    );

    if ($update) {
      return [
        "result" => true,
        "message" => "แก้ไขสำเร็จ"
      ];
    }else{
      return [
        "result" => false,
        "message" => "แก้ไขไม่สำเร็จ !"
      ];
    }

  }

  public function changpassword($email){
    $conn = (new Connection)->dbConnect();
    $app  = (new BookingAPI)->getapplocation();

    $hasrows = sqlsrv_has_rows(sqlsrv_query(
      $conn,
      "SELECT * FROM [user] where email = ?",
      [
        $email
      ]
    ));

    if ($hasrows) {

      $getuser = Sqlsrv::rows(
        $conn,
        "SELECT * FROM [user] WHERE email=?",[$email]
      );

      $mailTo  = [$email];
      $mailCC  = [];
      $mailBCC = [];
      $subject = "แจ้งรหัสผ่านสำหรับเข้าใช้ระบบจองห้องประชุมออนไลน์ (Meeting Room online)";
      $body    = "<table><tr><td colspan='2'>เรียน  คุณ".$getuser[0]['fname']." ".$getuser[0]['lname']."</td></tr><tr><td width='20px;'></td><td colspan='2'>แจ้งรหัสผ่านสำหรับเข้าใช้ระบบจองห้องประชุมออนไลน์  ดังนี้</td></tr><tr><td colspan='3'>Username : ".$getuser[0]['username']."</td></tr><tr><td colspan='3'>Password  : ".$getuser[0]['password']."</td></tr></table>";
      // <tr><td colspan='3'>ต้องการ Reset Password: <a href='http://".$app."/resert/password?email=".$email."'>เลือกที่นี่</a></td></tr>
      // $body    = "<b>รหัสผ่าน : </b> <font color='red'>".$getuser[0]['password']."</font>";
      $sender  = "ea_devteam@deestone.com";
     
      $sendmail = (new SendMailAPI)->SendMail($mailTo, $mailCC, $mailBCC, $subject , $body , $sender );
      if ($sendmail==true) {
        echo json_encode(["status" => 200, "message" => "รหัสผ่านถูกส่งไปยังอีเมลล์แล้ว"]);
      }else{
        echo json_encode(["status" => 200, "message" => "เกิดข้อผิดพลาดในการส่งเมลล์"]);
      }

    }else{

      echo json_encode(["status" => 404, "message" =>"อีเมลล์นี้ไม่พบในระบบ \n รบกวนติดต่อแผนกฝ่ายบุคคลเพื่อขอสิทธิ์ใช้งาน"]);

    }
    
    
  }

  public function InsertLog($username,$employee,$type){
    $conn = (new Connection)->dbConnect();
    $detect = new \Mobile_Detect; 

    $getdate = date("Y-m-d H:i:s");
    $computername = gethostbyaddr($_SERVER['REMOTE_ADDR']);
    $remark = $_SERVER['HTTP_USER_AGENT'];
    
    if ($detect->isMobile()) {
      $device = 2;
    }else{
      $device = 1;
    }

    $InsertLog = sqlsrv_query(
      $conn,
      "INSERT INTO [WEB_CENTER].[dbo].[LoginLogs] (EmployeeID,ComputerName,Username,LoginDevice,LoginDate,ProjectID,Remark)
      VALUES(?,?,?,?,?,?,?)",[$employee,$computername,$username,$device,$getdate,7,$remark]
    );

    $InsertlogApp = sqlsrv_query($conn,
        "INSERT INTO [EA_APP].[dbo].[TB_LOG_APP] (EMP_CODE,USER_NAME,HOST_NAME,".$type.",PROJECT_NAME)
        VALUES (?,?,?,?,?)",
        array(
            $employee,
            $username,
            $computername,
            date('Y-m-d H:i:s'),
            'Meeting Room'
        )
    );

    $update = sqlsrv_query(
      $conn,
      "UPDATE [user] SET last_login=?
      WHERE username=?",
      array(
        $getdate,$username
      )
    );

    if ($update) {
      return true;
    }else{
      return false;
    }
  }

  public function employee() {
    $conn = (new Connection)->dbConnect();
    return Sqlsrv::rows(
      $conn,
      "SELECT 
        E.CODEMPID, E.EMPNAME, E.EMPLASTNAME, S.DIVISIONID, E.DEPARTMENTCODE ,D.DEPARTMENTNAME,S.DIVISIONNAME,E.COMPANYNAME,T.EMAIL
        from [HRTRAINING].[dbo].[Employee] E
        LEFT JOIN [HRTRAINING].[dbo].[DEPARTMENT] D ON E.DEPARTMENTCODE=D.DEPARTMENTCODE
        LEFT JOIN [HRTRAINING].[dbo].[DIVISION] S ON E.DIVISIONCODE=S.DIVISIONCODE
        LEFT JOIN [HRTRAINING].[dbo].[TEMPLOY1] T ON E.CODEMPID=T.CODEMPID
        where E.STATUS != 9 
        -- and T.EMAIL IS NOT NULL 
        -- and T.EMAIL != 'dummy@tjs.co.th'
        group by E.CODEMPID, E.EMPNAME, E.EMPLASTNAME, S.DIVISIONID, E.DEPARTMENTCODE,D.DEPARTMENTNAME,S.DIVISIONNAME,E.COMPANYNAME,T.EMAIL"
    );
  }

}