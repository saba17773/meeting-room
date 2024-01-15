<!DOCTYPE html>
<html>
<head>
  <title>MeetingRoom</title>
  <style type="text/css">
    table, tr, td {
      font-family: "THSarabun";
      font-size: 42pt;
      text-align: left;
      padding: 2px;
      border-collapse: collapse;
      border: 0px solid black;
      vertical-align: baseline;
    }
    h1 {
      font-family: "THSarabun";
      font-size: 80pt;
    }
  </style>
</head>
<body>
	<?php 
	  use App\Report\ReportAPI;
      use App\MyBooking\MyAPI;
      if (isset($_GET['recid'])) {
 		$data = (new ReportAPI)->getAllbyId($_GET['recid']);
      }else{
      	$data = (new ReportAPI)->getAll($_GET['id']);
      }
	?>

	<?php if (isset($_GET['recid'])) { ?>

		<?php foreach ($data as $key => $value) {?>
		<table>
			<tr>
				<td><h1>&nbsp;&nbsp;<?php echo $data[0]['room_name']; ?></h1></td>
			</tr>
			
		</table>

		<table width="70%" align="center">
			<tr>
				<td><b>หัวข้อการประชุม </b></td>
	      		<td><b>: </b><?php echo $value['book_title']; ?></td>
			</tr>
			<tr>
				<td><b>วันที่เริ่มใช้งาน </b></td>
				<td><b>: </b><?php echo date("d/m/Y",strtotime($value['book_startdate']))."&nbsp;&nbsp;".$value['book_starttime']."-".$value['book_endtime']." น."; ?></td>
			</tr>
			<tr>
				<td><b>ผู้ใช้งาน </b></td>
	      		<td><b>: </b><?php echo $value['book_user']; ?></td>
			</tr>
		</table><br><br><br><br><br><br><br><br><br><br><br><br>
		<?php } ?>

	<?php }else{ ?>
		
		<table>
			<tr>
				<td><h1>&nbsp;&nbsp;<?php echo $data[0]['room_name']; ?></h1></td>
			</tr>
			
		</table>

		<table width="80%" align="center">
			<tr>
				<td><b>หัวข้อการประชุม </b></td>
	      		<td><b>: </b><?php echo $data[0]['book_title']; ?></td>
			</tr>

			<?php if ($data[0]['book_startdate']!=$data[0]['book_enddate']) { ?>
			<tr>
				<td><b>วันที่เริ่มใช้งาน </b></td>
				<td><b>: </b><?php echo date("d/m/Y",strtotime($data[0]['book_startdate']))."&nbsp;&nbsp;".$data[0]['book_starttime']."-".$data[0]['book_endtime']." น."; ?></td>
			</tr>
			<tr>
				<td><b>วันที่สิ้นสุด </b></td>
				<td><b>: </b><?php echo date("d/m/Y",strtotime($data[0]['book_enddate']))."&nbsp;&nbsp;".$data[0]['book_starttime']."-".$data[0]['book_endtime']." น."; ?></td>
			</tr>
			<?php }else{ ?>
			<tr>
				<td><b>วันที่ใช้งาน </b></td>
				<td><b>: </b><?php echo date("d/m/Y",strtotime($data[0]['book_startdate']))."&nbsp;&nbsp;".$data[0]['book_starttime']."-".$data[0]['book_endtime']." น."; ?></td>
			</tr>
			<?php } ?>

			<tr>
				<td><b>ผู้ใช้งาน </b></td>
	      		<td><b>: </b><?php echo $data[0]['book_user']; ?></td>
			</tr>
		</table>

	<?php } ?>

</body>
</html>
<?php

$html = ob_get_contents();
ob_end_clean();
$pdf = new mPDF('th','A4-L', 0, '', 0, 0, 5, 0);  
$pdf->SetDisplayMode('fullpage');
$pdf->SetHTMLFooter('<img src="./logo/footer_deestone.png"/>');
$pdf->WriteHTML($html);
$pdf->Output(); 
?>

