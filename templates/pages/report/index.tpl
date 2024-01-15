<!DOCTYPE html>
<html>
<head>
  <title>MeetingRoom</title>
  <style type="text/css">
    table, tr, td {
      font-family: "THSarabun";
      font-size: 18pt;
      text-align: left;
      padding: 1.5px;
      border-collapse: collapse;
      border: 0px solid black;
    }
  </style>
</head>
<body>
    <?php  
      use App\Report\ReportAPI;
      use App\MyBooking\MyAPI;
      $data = (new ReportAPI)->getAll($_GET['id']);
      $data_layout = (new MyAPI)->loadlayout($_GET['id']);
      $data_food = (new MyAPI)->loadfood($_GET['id']);
      $data_dessert = (new MyAPI)->loaddessert($_GET['id']);
      $data_support = (new MyAPI)->loadsupport($_GET['id']);
    ?>

<table width="100%">
  <tr>
    <td colspan="3">
      <a class="navbar-brand">
        <?php
          $room_company=$data[0]['com_nname'];

          if ($room_company=="STR") {
            echo "<img src='./logoplant/STR.jpg' style='padding-top:-45;height:150px; width:auto;'>";
          }else if ($room_company=="DRB") {
            echo "<img src='./logoplant/DRB.jpg' style='padding-top:-25;padding-left:-30;height:150px; width:auto;'>";
          }else if ($room_company=="DSL") {
            echo "<img src='./logoplant/DSL.jpg' style='padding-top:-10;height:150px; width:auto;'>";
          }else if ($room_company=="DSI") {
            echo "<img src='./logoplant/DSI.jpg' style='padding-top:-15;padding-left:-20;height:150px; width:auto;'>";
          }else if ($room_company=="SVO") {
            echo "<img src='./logoplant/SVO.jpg' style='padding-top:-25;padding-left:-10;height:130px; width:auto;'>";
          }
          
        ?>
      </a> 
    </td>
  </tr>
  <tr>
    <td valign="top" align="center" colspan="2"><u><h3>ใบสั่งงาน</h3></u></td>
  </tr>

  <tr>

    <td valign="top" width="45%">

      <table style="float:right;">
        <tr>
          <td width="10%"></td>
          <td width="40%"><b>ห้องประชุม : </b></td>
          <td><?php echo $data[0]['room_name']; ?></td>
        </tr>
        <tr>
          <td></td>
          <td><b>หัวข้อการประชุม : </b></td>
          <td><?php echo $data[0]['book_title']; ?></td>
        </tr>
        <tr>
          <td></td>
          <td><b>วันที่เริ่มใช้งาน : </b></td>
          <td><?php echo date("d/m/Y",strtotime($data[0]['book_startdate'])); ?></td>
        </tr>
        <tr>
          <td></td>
          <td><b>วันที่สิ้นสุด : </b></td>
          <td><?php echo date("d/m/Y",strtotime($data[0]['book_enddate'])); ?></td>
        </tr>
        <tr>
        <td></td>
        <td><b>เวลาเริ่ม : </b></td>
        <td><?php echo $data[0]['book_starttime']; ?> น.</td>
        </tr>
        <tr>
          <td></td>
          <td><b>เวลาสิ้นสุด : </b></td>
          <td><?php echo $data[0]['book_endtime']; ?> น.</td>
        </tr>
        <tr>
          <td></td>
          <td valign="top"><b>ผู้จอง : </b></td>
          <td><?php echo $data[0]['fullname']; ?><br>แผนก : <?php echo $data[0]['dep_name']; ?></td>
        </tr>
        <tr>
          <td></td>
          <td><b>ผู้ใช้งาน : </b></td>
          <td><?php echo $data[0]['book_user']; ?></td>
        </tr>
        <tr>
          <td></td>
          <td><b>จำนวนผู้เข้าประชุม : </b></td>
          <td><?php echo $data[0]['book_seat']; ?> คน</td>
        </tr>
        <tr>
          <td></td>
          <td><b>รูปแบบการจัดห้อง : </b></td>
          <td>
            <?php echo $data_layout[0]['layout_name']; ?>
          </td>
        </tr>
        <tr>
          <td></td>
          <td colspan="2">
            <a class="navbar-brand"><img src="./picturemaster/layout/<?php echo $data_layout[0]['layout_picture']; ?>"
              style="height:250px; width:auto;" /></a>
          </td>
        </tr>
      </table>

    </td>
   
    <td width="45%" valign="top">

      <table style="float:right;">
        <tr>
          <td width="80px" valign="top"><b>อาหาร : </b></td>
          <td>
            <?php 
              if ($data_food) {
                foreach ($data_food as $key => $food) {
                  echo "<table>";
                  echo "<tr>";
                  echo "<td width=250px>".$food['food_name']."</td>";
                  echo "<td width=100px>".$food['food_unit']." หน่วย</td>";
                  echo "<td width=200px> ราคา ".$food['food_price']."บาท/หน่วย</td>";
                  echo "</tr>";
                  echo "</table>";
                }
              }else{
                echo "-";
              }
            ?>
          </td>
        </tr>
        <tr>
          <td valign="top"><b>ของว่าง : </b></td>
          <td>
            <?php 
              if ($data_dessert) {
                foreach ($data_dessert as $key => $dessert) {
                  echo "<table>";
                  echo "<tr>";
                  echo "<td width=250px>".$dessert['dessert_name']."</td>";
                  echo "<td width=100px>".$dessert['food_unit']." หน่วย</td>";
                  echo "<td width=200px> ราคา ".$dessert['dessert_price']."บาท/หน่วย</td>";
                  echo "</tr>";
                  echo "</table>";
                }
              }else{
                echo "-";
              }
            ?>
          </td>
        </tr>
        <tr>
          <td><b>รวมราคา : </b></td>
          <td>
            <?php 
                $sumfood=0;
                foreach ($data_food as $f) {
                $rowsfood = array($f['food_price']*$f['food_unit']);
                $food = array_sum($rowsfood);
                $sumfood += $food;
                }
                
                $sumdessert=0;
                foreach ($data_dessert as $d) {
                $rowsdessert = array($d['dessert_price']*$d['food_unit']);
                $dessert = array_sum($rowsdessert);
                $sumdessert += $dessert;
                }

                if ($sumfood==0 && $sumdessert==0) {
                    echo "-";
                }else{
                    echo number_format($sumfood+$sumdessert) ." บาท";
                } 
            ?>
          </td>
        </tr>
        <tr>
          <td><b>คนรับรอง : </b></td>
          <td> 
            <?php 
              if ($data_support) {
                echo $data_support[0]['support_id']." คน"; 
              }else{
                echo "ไม่มี";
              }
            ?>
          </td>
        </tr>
        <tr>
          <td valign="top"><b>เพิ่มเติม : </b></td>
          <td>
            <?php echo $data[0]['book_remark']; ?>
          </td>
        </tr>
      </table>

    </td>

  </tr>
</table>

</body>
</html>
<?php

$html = ob_get_contents();
ob_end_clean();
$pdf = new mPDF('th','A4-L', 0, '', 0, 0, 0, 0);  
$pdf->SetDisplayMode('fullpage');
$pdf->WriteHTML($html);
$pdf->Output(); 
?>

