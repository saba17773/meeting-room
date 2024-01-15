<?php 
$this->layout('layouts/approve'); 

use App\Approve\ApproveAPI;
use App\MyBooking\MyAPI;
$numbersequence = $_REQUEST['numbersequence'];
$mg 		    = $_REQUEST['mg'];
// exit();
$data 			= (new ApproveAPI)->load($numbersequence);
$data_layout 	= (new MyAPI)->loadlayout($numbersequence);
$data_food 		= (new MyAPI)->loadfood($numbersequence);
$data_dessert 	= (new MyAPI)->loaddessert($numbersequence);
$data_support 	= (new MyAPI)->loadsupport($numbersequence);
$data_mixs  	= (new MyAPI)->mixs_approve($numbersequence);
// echo "<pre>".print_r($data,true)."</pre>";
// echo count($data);
// exit;

?>

<style type="text/css">
  table, th, td {
    border: 1px solid white;
    border-collapse: collapse;
    padding: 5px;
  }
  input[type=checkbox] {
    width: 20px;
    height: 20px;
  }
</style>

<?php if ($data[0]['book_status']==1){?>
	
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

					echo "<table width=950px><tr>
					<td width=150px>".$l['layout_name']."</td>
					<td width=350px></td> 
					<td>
					<input type='checkbox' value='1' name=layout".$l['layout_id']."> อนุมัติ
					<input type='checkbox' value='0' name=layout".$l['layout_id']."> ไม่อนุมัติ
					</td>
					<td><select name=remarklayout".$l['layout_id']." id=remarklayout".$l['layout_id']." ></select></td>
					</tr></table>";
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

					echo "<table width=950px><tr>
					<td width=150px>".$f['food_name']."</td>
					<td width=100px>".$f['food_unit']." หน่วย </td> 
					<td width=150px> ราคา".$f['food_price']."/หน่วย </td> 
					<td width=100px> = ".number_format($f['food_unit']*$f['food_price'])." บาท</td> 
					<td>
					<input type='checkbox' value='1' name=food".$f['food_id']."> อนุมัติ
					<input type='checkbox' value='0' name=food".$f['food_id']."> ไม่อนุมัติ
					</td>
					<td><select name=remarkfood".$f['food_id']." id=remarkfood".$f['food_id']." ></select></td>
					</tr></table>";
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

					echo "<table width=950px><tr>
					<td width=150px>".$d['dessert_name']."</td>
					<td width=100px>".$d['food_unit']." หน่วย </td> 
					<td width=150px> ราคา".$d['dessert_price']."/หน่วย </td> 
					<td width=100px> = ".number_format($d['food_unit']*$d['dessert_price'])." บาท</td> 
					<td>
					<input type='checkbox' value='1' name=dessert".$d['food_id']."> อนุมัติ
					<input type='checkbox' value='0' name=dessert".$d['food_id']."> ไม่อนุมัติ
					</td>
					<td><select name=remarkdessert".$d['food_id']." id=remarkdessert".$d['food_id']." ></select></td>
					</tr></table>";
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

					echo "<table width=950px><tr>
					<td width=150px>".$s['support_id']." คน </td>
					<td width=350px></td> 
					<td>
					<input type='checkbox' value='1' name=support".$s['support_id']."> อนุมัติ
					<input type='checkbox' value='0' name=support".$s['support_id']."> ไม่อนุมัติ
					</td>
					<td><select name=remarksupport".$s['support_id']." id=remarksupport".$s['support_id']." ></select></td>
					</tr></table>";
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
		                echo number_format($sum_dessert+$sum_food);
		              ?>
		              บาท
		            </td>
	  				<td>
						<input type="checkbox" name="selectall" value="1" onClick="selectAll(this)" />เลือกทั้งหมด
						<input type="checkbox" name="selectall" value="0" onClick="unselectAll(this)" />ไม่เลือกทั้งหมด
	  				</td>
	  			</tr>
	  		</table>
        </td>
      </tr>

      <tr>
        <td colspan="3" align="right">
          <label>
          	<input type="hidden" name="numbersequence" value="<?php echo $numbersequence; ?>">
          	<input type="hidden" name="mg" value="<?php echo $mg; ?>">
            <input type="hidden" name="level" value="mg_user">
            <input type="hidden" name="status" value="2">
            <button class="btn btn-lg btn-primary" id="btn_save_booking"><i class="glyphicon glyphicon-floppy-saved"></i> ยืนยันการอนุมัติ</button>
          </label>
        </td>
      </tr>

    </table>
    </form>
  </div>
</div>

<?php }else{ ?>
	<div id="myModalExit" class="modal">
	    <br><br><br>
	    <center class="container">
	    <div class="panel panel-danger">
	      <div class="panel-heading">
	        <h3 class="panel-title">แจ้งสถานะการอนุมัติ</h3>
	      </div>
	      <div class="panel-body">
	        รายการนี้ได้ดำเนินการไปแล้ว! 
	      </div>
	    </div>
	    </center>
	</div>
<?php } ?>

<div id="myModalApprove" class="modal">
    <br><br><br>
    <center class="container">
    <div class="panel panel-success">
      <div class="panel-heading">
        <h3 class="panel-title">แจ้งสถานะการอนุมัติ</h3>
      </div>
      <div class="panel-body">
        การอนุมัติคำร้องประสบความสำเร็จ! 
      </div>
    </div>
    </center>
</div>


<script type="text/javascript">

	jQuery(document).ready(function($) {
		var book_number = '<?php echo $data[0]['book_number'] ?>';
		var book_status = '<?php echo $data[0]['book_status'] ?>';

		if (book_status!=1) {
			$('#myModalExit').modal({backdrop: 'static', keyboard: false});
		}

	 	unselect();

		$("input:checkbox").on('click', function() {
		  
		  var $box = $(this);
		  if ($box.is(":checked")) {
		    var group = "input:checkbox[name='" + $box.attr("name") + "']";
		    $(group).prop("checked", false);
		    $box.prop("checked", true);
		  }else{
		    $box.prop("checked", false);
		  }
		  	remarkbox($box.attr("name"));
		  	// console.log($box.attr("name"));

		});

		$("input[name=selectall]").on('click', function() {
		  	if ($('input[name=selectall]:checked').val()==undefined) {
		  		unselect();
		  	}
		});

		gojax('get', '/load/layout?numbersequence='+book_number)
          .done(function(data){
          $.each(data, function( k, v ) {
          	var remark_l ="remarklayout"+v.layout_id;
            
            gojax('get', '/mg_approve_user/remark/layout')
              .done(function(data) {
              $('select[name='+remark_l+']').html("<option value=''>=Select=</option>");
              $.each(data, function(index, val) {
                 $('select[name='+remark_l+']').append('<option value="'+val.remark_id+'">'+val.remark_name+'</option>');
              });
              $('select[name='+remark_l+']').val();
            });

          });
        });

        gojax('get', '/load/food?numbersequence='+book_number)
          .done(function(data){
          $.each(data, function( k, v ) {
          	var remark_f ="remarkfood"+v.food_id;
            
            gojax('get', '/mg_approve_user/remark/food')
              .done(function(data) {
              $('select[name='+remark_f+']').html("<option value=''>=Select=</option>");
              $.each(data, function(index, val) {
                 $('select[name='+remark_f+']').append('<option value="'+val.remark_id+'">'+val.remark_name+'</option>');
              });
              $('select[name='+remark_f+']').val();
            });

          });
        });

        gojax('get', '/load/dessert?numbersequence='+book_number)
          .done(function(data){
          $.each(data, function( k, v ) {
          	var remark_d ="remarkdessert"+v.food_id;
            
            gojax('get', '/mg_approve_user/remark/food')
              .done(function(data) {
              $('select[name='+remark_d+']').html("<option value=''>=Select=</option>");
              $.each(data, function(index, val) {
                 $('select[name='+remark_d+']').append('<option value="'+val.remark_id+'">'+val.remark_name+'</option>');
              });
              $('select[name='+remark_d+']').val();
            });

          });
        });

        gojax('get', '/load/support?numbersequence='+book_number)
          .done(function(data){
          $.each(data, function( k, v ) {
          	var remark_s ="remarksupport"+v.support_id;
            
            gojax('get', '/mg_approve_user/remark/support')
              .done(function(data) {
              $('select[name='+remark_s+']').html("<option value=''>=Select=</option>");
              $.each(data, function(index, val) {
                 $('select[name='+remark_s+']').append('<option value="'+val.remark_id+'">'+val.remark_name+'</option>');
              });
              $('select[name='+remark_s+']').val();
            });

          });
        });

	});

	function remarkbox(name) {
	
		if ($("input[name="+name+"]:checked").val()==1) {
	    	$("select[name=remark"+name+"]").hide();
	    }else if($("input[name="+name+"]:checked").val()==0) {
	    	$("select[name=remark"+name+"]").show();
	    }else{
	    	$("select[name=remark"+name+"]").hide();

	    }
	    
	}

	function submit_booking_room() {

  		var datamixs = <?php echo json_encode( $data_mixs ) ?>;
  		// console.log(datamixs);
  		for (i=0; i <= datamixs.length-1; i++) {
  			if ($("input[name="+datamixs[i]+"]:checked").val() == undefined) {
  				gotify("กรุณากรอกข้อมูลให้ครบถ้วน","danger");
  				return false;
  			}
  		}
	    
	    $('#btn_save_booking').text('กำลังอนุมัติ...');
    	$('#btn_save_booking').attr('disabled', true);
    	
	    $.ajax({
	        url : '/booking/approve',
	        type : 'post',
	        cache : false,
	        dataType : 'json',
	        data : $('form#form_booking').serialize()
	    })
	    .done(function(data) {
		    if (data.status == 404) {
		      	gotify(data.message, "warning")
		    }else{
		      	$('#myModalApprove').show();
				$('#myModalApprove').modal({backdrop: 'static', keyboard: false});
              	CloseWindowsInTime(5); 
              	$('#btn_save_booking').text('ยืนยันการอนุมัติ');
    			$('#btn_save_booking').attr('disabled', false);
		    }
		    // console.log(data);
		    
		});
	     
      	return false;

	}

	function CloseWindowsInTime(t){
        t = t*1000;
        setTimeout("window.close()",t);
    }

    function selectAll(source) {
    	
    	var book_number = '<?php echo $data[0]['book_number'] ?>';
	 	// Layout
	 	gojax('get','/load/layout?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var layout_id = v.layout_id;
			    $("input[name=layout"+layout_id+"][value=1]").prop('checked', true);
			    $("input[name=layout"+layout_id+"][value=0]").prop('checked', false);
			    $("select[name=remarklayout"+layout_id+"]").hide();
	          i++;
	      });
	    });
	 	// Food
	 	gojax('get','/load/food?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var food_id = v.food_id;
			    $("input[name=food"+food_id+"][value=1]").prop('checked', true);
			    $("input[name=food"+food_id+"][value=0]").prop('checked', false);
			    $("select[name=remarkfood"+food_id+"]").hide();
	          i++;
	      });
	    });
	    // Dessert
	    gojax('get','/load/dessert?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var dessert_id = v.food_id;
			    $("input[name=dessert"+dessert_id+"][value=1]").prop('checked', true);
			    $("input[name=dessert"+dessert_id+"][value=0]").prop('checked', false);
			    $("select[name=remarkdessert"+dessert_id+"]").hide();
	          i++;
	      });
	    });
	    // Support
	    gojax('get','/load/support?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var book_support = v.support_id;
			    $("input[name=support"+book_support+"][value=1]").prop('checked', true);
			    $("input[name=support"+book_support+"][value=0]").prop('checked', false);
			    $("select[name=remarksupport"+book_support+"]").hide();
	          i++;
	      });
	    });

	    // if ($('input[name=2]:checked').val() == undefined) {
	    // 	console.log('no check');
	    // }else{
	    // 	console.log($('input[name=2]:checked').val());
	    // }
	    
	}

	function unselectAll(source) {
    	
    	var book_number = '<?php echo $data[0]['book_number'] ?>';
	 	// Layout
	 	gojax('get','/load/layout?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var layout_id = v.layout_id;
			    $("input[name=layout"+layout_id+"][value=0]").prop('checked', true);
			    $("input[name=layout"+layout_id+"][value=1]").prop('checked', false);
			    $("select[name=remarklayout"+layout_id+"]").show();
	          i++;
	      });
	    });
	    // Food
	 	gojax('get','/load/food?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var food_id = v.food_id;
			    $("input[name=food"+food_id+"][value=0]").prop('checked', true);
			    $("input[name=food"+food_id+"][value=1]").prop('checked', false);
			    $("select[name=remarkfood"+food_id+"]").show();
	          i++;
	      });
	    });
	    // Dessert
	    gojax('get','/load/dessert?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var dessert_id = v.food_id;
			    $("input[name=dessert"+dessert_id+"][value=0]").prop('checked', true);
			    $("input[name=dessert"+dessert_id+"][value=1]").prop('checked', false);
			    $("select[name=remarkdessert"+dessert_id+"]").show();
	          i++;
	      });
	    });
	    // Support
	    gojax('get','/load/support?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var book_support = v.support_id;
			    $("input[name=support"+book_support+"][value=0]").prop('checked', true);
			    $("input[name=support"+book_support+"][value=1]").prop('checked', false);
			    $("select[name=remarksupport"+book_support+"]").show();
	          i++;
	      });
	    });
	    
	}

	function unselect(source) {
    	
    	var book_number = '<?php echo $data[0]['book_number'] ?>';
	 	// Layout
	 	gojax('get','/load/layout?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var layout_id = v.layout_id;
			    $("input[name=layout"+layout_id+"][value=0]").prop('checked', false);
			    $("input[name=layout"+layout_id+"][value=1]").prop('checked', false);
			    $("select[name=remarklayout"+layout_id+"]").hide();
	          i++;
	      });
	    });
	    // Food
	 	gojax('get','/load/food?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var food_id = v.food_id;
			    $("input[name=food"+food_id+"][value=0]").prop('checked', false);
			    $("input[name=food"+food_id+"][value=1]").prop('checked', false);
			    $("select[name=remarkfood"+food_id+"]").hide();
	          i++;
	      });
	    });
	    // Dessert
	    gojax('get','/load/dessert?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var dessert_id = v.food_id;
			    $("input[name=dessert"+dessert_id+"][value=0]").prop('checked', false);
			    $("input[name=dessert"+dessert_id+"][value=1]").prop('checked', false);
			    $("select[name=remarkdessert"+dessert_id+"]").hide();
	          i++;
	      });
	    });
	    // Support
	    gojax('get','/load/support?numbersequence='+book_number)
	      .done(function(data){
	          var i=1;
	          $.each(data, function( k, v ) {
	            var book_support = v.support_id;
			    $("input[name=support"+book_support+"][value=0]").prop('checked', false);
			    $("input[name=support"+book_support+"][value=1]").prop('checked', false);
			    $("select[name=remarksupport"+book_support+"]").hide();
	          i++;
	      });
	    });
	    
	}
</script>