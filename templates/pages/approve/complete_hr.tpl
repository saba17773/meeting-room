<?php
// require '../vendor/autoload.php'; 
$mpdf = ob_get_clean();

$this->layout('layouts/approve'); 

use App\Approve\ApproveAPI;
use App\MyBooking\MyAPI;
$numbersequence = $_REQUEST['numbersequence'];
$mg         = $_REQUEST['mg'];

$data       = (new ApproveAPI)->load($numbersequence);
$data_layout  = (new MyAPI)->loadlayout($numbersequence);
$data_food    = (new MyAPI)->loadfood($numbersequence);
$data_dessert   = (new MyAPI)->loaddessert($numbersequence);
$data_support   = (new MyAPI)->loadsupport($numbersequence);
$data_mixs    = (new MyAPI)->mixs_approve($numbersequence);
// echo "<pre>".print_r($data_layout,true)."</pre>";
// exit();
?>

<style type="text/css">
  table, th, td {
    /*border: 1px solid white;*/
    border-collapse: collapse;
    padding: 5px;
  }
  input[type=checkbox] {
    width: 20px;
    height: 20px;
  }
</style>

<div class="row">
  <div class="col-lg-12">
    <form id="form_booking" onsubmit="return submit_booking_room()">
    <table width="100%">
      <tr>
        <td width="20%">
          <label>ห้องประชุม</label>
        </td>
        <td>
          <?php echo $data[0]['room_name']; ?>
        </td>
      </tr>
      <tr>
        <td>
          <label>หัวข้อการประชุม</label>
        </td>
        <td>
          <?php echo $data[0]['book_title']; ?>
        </td>
      </tr>
      <tr>
        <td>
          <label>วัน/เวลา ที่เริ่มใช้งาน</label>
        </td>
        <td>
          <?php echo date("d/m/Y", strtotime($data[0]['book_startdate'])); ?>
          &nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;
          <?php echo $data[0]['book_starttime']; ?> น.
        </td>
      </tr>
      <tr>
        <td>
          <label>วัน/เวลา ที่สิ้นสุด</label>
        </td>
        <td>
          <?php echo date("d/m/Y", strtotime($data[(count($data)-1)]['book_enddate'])); ?>
          &nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;
          <?php echo $data[0]['book_endtime']; ?> น.
        </td>
      </tr>
      <tr>
        <td>
          <label>ผู้จอง</label>
        </td>
        <td>
          <?php echo $data[0]['fullname']; ?>
        </td>
      </tr>
      <tr>
        <td>
          <label>ผู้ใช้งาน</label>
        </td>
        <td>
          <?php echo $data[0]['book_user']; ?>
        </td>
      </tr>
      <tr>
        <td>
         <label> จำนวนผู้เข้าประชุม</label>
        </td>
        <td>
          <?php echo $data[0]['book_seat']; ?> คน
        </td>
      </tr>
      <tr>
        <td>
          <label>รูปแบบการจัดห้อง</label>
        </td>
        <td>
        <?php 
        foreach ($data_layout as $l) {
          
          if ($l['layout_approve']==1) {
            echo "<table width=950px><tr>
            <td width=150px>".$l['layout_name']."</td>
            <td width=350px></td> 
            <td>
            <input type='checkbox' value='1' name=layout".$l['layout_id']." checked> อนุมัติ
            <input type='checkbox' value='0' name=layout".$l['layout_id']."> ไม่อนุมัติ
            </td>
            <td></td>
            </tr></table>";
          }else{
            echo "<table width=950px><tr>
            <td width=150px>".$l['layout_name']."</td>
            <td width=350px></td> 
            <td>
            <input type='checkbox' value='1' name=layout".$l['layout_id']."> อนุมัติ
            <input type='checkbox' value='0' name=layout".$l['layout_id']." checked> ไม่อนุมัติ
            </td>
            <td>หมายเหตุ : ".$l['remark_name']."</td>
            </tr></table>";
          }

        }
        ?>
        </td>
      </tr>
      <tr>
        <td>
          <label>อาหาร</label>
        </td>
        <td>
        <?php 
        foreach ($data_food as $f) {
          
          if ($f['food_approve']==1) {
            echo "<table width=950px><tr>
            <td width=150px>".$f['food_name']."</td>
            <td width=100px>".$f['food_unit']." หน่วย </td> 
            <td width=150px> ราคา".$f['food_price']."/หน่วย </td> 
            <td width=100px> = ".$f['food_unit']*$f['food_price']." บาท</td> 
            <td>
            <input type='checkbox' value='1' name=food".$f['food_id']." checked> อนุมัติ
            <input type='checkbox' value='0' name=food".$f['food_id']."> ไม่อนุมัติ
            </td>
            <td></td>
            </tr></table>";
          }else{
            echo "<table width=950px><tr>
            <td width=150px>".$f['food_name']."</td>
            <td width=100px>".$f['food_unit']." หน่วย </td> 
            <td width=150px> ราคา".$f['food_price']."/หน่วย </td> 
            <td width=100px> = ".$f['food_unit']*$f['food_price']." บาท</td> 
            <td>
            <input type='checkbox' value='1' name=food".$f['food_id']."> อนุมัติ
            <input type='checkbox' value='0' name=food".$f['food_id']." checked> ไม่อนุมัติ
            </td>
            <td>หมายเหตุ : ".$f['remark_name']."</td>
            </tr></table>";
          }

        }
        ?>
        </td>
      </tr>
      <tr>
        <td>
          <label>ของว่าง</label>
        </td>
        <td>
        <?php 
        foreach ($data_dessert as $d) {

          if ($f['food_approve']==1) {
            echo "<table width=950px><tr>
            <td width=150px>".$d['dessert_name']."</td>
            <td width=100px>".$d['food_unit']." หน่วย </td> 
            <td width=150px> ราคา".$d['dessert_price']."/หน่วย </td> 
            <td width=100px> = ".$d['food_unit']*$d['dessert_price']." บาท</td> 
            <td>
            <input type='checkbox' value='1' name=dessert".$d['food_id']." checked> อนุมัติ
            <input type='checkbox' value='0' name=dessert".$d['food_id']."> ไม่อนุมัติ
            </td>
            <td></td>
            </tr></table>";
          }else{
            echo "<table width=950px><tr>
            <td width=150px>".$d['dessert_name']."</td>
            <td width=100px>".$d['food_unit']." หน่วย </td> 
            <td width=150px> ราคา".$d['dessert_price']."/หน่วย </td> 
            <td width=100px> = ".$d['food_unit']*$d['dessert_price']." บาท</td> 
            <td>
            <input type='checkbox' value='1' name=dessert".$d['food_id']."> อนุมัติ
            <input type='checkbox' value='0' name=dessert".$d['food_id']." checked> ไม่อนุมัติ
            </td>
            <td>หมายเหตุ : ".$d['remark_name']."</td>
            </tr></table>";
          }

        }
        ?>
        </td>
      </tr>
      <tr>
        <td>
          <label>คนรับรอง</label>
        </td>
        <td>
        <?php 
        foreach ($data_support as $s) {

          if ($s['support_approve']==1) {
            echo "<table width=950px><tr>
            <td width=150px>".$s['support_id']." คน </td>
            <td width=350px></td> 
            <td>
            <input type='checkbox' value='1' name=support".$s['support_id']." checked> อนุมัติ
            <input type='checkbox' value='0' name=support".$s['support_id']."> ไม่อนุมัติ
            </td>
            <td></td>
            </tr></table>";
          }else{
            echo "<table width=950px><tr>
            <td width=150px>".$s['support_id']." คน </td>
            <td width=350px></td> 
            <td>
            <input type='checkbox' value='1' name=support".$s['support_id']."> อนุมัติ
            <input type='checkbox' value='0' name=support".$s['support_id']." checked> ไม่อนุมัติ
            </td>
            <td>หมายเหตุ : ".$s['remark_name']."</td>
            </tr></table>";
          }
        }
        ?>
        </td>
      </tr>
    
    <tr>
      <td>
        
      </td>
      <td>
        <table>
          <tr>
            <td colspan="2" width=500px>
              รวมราคา 
              <?php 
              // echo count($data_dessert); 
                $sum_dessert = 0;
                $sum_food = 0;
                foreach ($data_dessert as $value) {
                    $sum_dessert += $value['food_unit']*$value['dessert_price'];
                }

                foreach ($data_food as $value) {
                    $sum_food += $value['food_unit']*$value['food_price'];
                }
                echo $sum_dessert+$sum_food;
              ?>
              บาท
            </td>
            <td>
            </td>
          </tr>
        </table>
        </td>
      </tr>

    </table>
    </form>
  </div>
</div>

<?php 
// $html = ob_get_contents();
// ob_end_clean();
// $mpdf=new mPDF('th','A4', 0, '', 2, 2, 2, 2);
// $mpdf->WriteHTML($html);
// $mpdf->Output();
?>