<?php $this->layout('layouts/login'); ?>


	<table align="center">
		<form id="form_login" onsubmit="return submit_login()">
			<tr>
				<td>
					<h1>เข้าสู่ระบบ(TEST)</h1><hr>
				</td>
			</tr>
			<tr>
				<td>
					<div class="form-group">
						<label for="username">ชื่อผู้ใช้</label>
						<input type="text" name="username" id="username" class="form-control" autocomplete="off" autofocus required style="width: 300px;">
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="form-group">
						<label for="password">รหัสผ่าน</label>
						<input type="password" name="password" id="password" class="form-control" autocomplete="off" autofocus required style="width: 300px;">
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<input type="hidden" name="<?= $name ?>" value="<?= $key['csrf_name'] ?>">
					<input type="hidden" name="<?= $value ?>" value="<?= $key['csrf_value'] ?>">
					<button class="btn btn-lg btn-primary"><i class="glyphicon glyphicon-log-in"></i> เข้าสู่ระบบ</button>
					<a href="#" onclick="changpassword()">ลืมรหัสผ่าน</a> <i class="glyphicon glyphicon-lock"></i>
				</td>
			</tr>
			<tr>
				<td>
					เว็บไซต์นี้เหมาะสำหรับ : Browser Internet Explorer 11 ขึ้นไป<br>
					<font color="red">เว็บไซต์นี้สร้างขึ้นมาเพื่อทดสอบระบบ</font>
				</td>
			</tr>
		</form>
	</table>

<div class="modal" id="modal_chang" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">ลืมรหัสผ่าน</h4>
      </div>
      <div class="modal-body">
        <form id="form_user_chang" onsubmit="return submit_user_chang()">
        <table width="70%">
          <tr>
            <td>
              	<label>อีเมลล์</label>
            </td>
            <td>
	            <input class="form-control" type="email" name="email" id="email" required autocomplete="off" style='width: 240px;'>
            </td>
            <td>
		    	<button class="btn btn-primary" id="btn_send"><i class="glyphicon glyphicon-send"></i> ตกลง</button>
          	</td>
          </tr>
        </table>
        </form>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    function submit_login() {
		    $.ajax({
		        url : '/auth',
		        type : 'post',
		        cache : false,
		        dataType : 'json',
		        data : $('form#form_login').serialize()
	        })
	        .done(function(data) {
		        if (data.status == 404) {
              		//gotify(data.message,"danger");
              		alert(data.message);
		        }else if(data.status == 301){
              		// gotify(data.message,"success");
              		// alert(data.message);
              		window.location = '/calendar';
		        }else{
		        	window.location = '/check_room';
		        }
		        // console.log(data);
	        });
    	return false;
	}

	function changpassword(){
		$('#modal_chang').modal({backdrop: 'static'});
      	$('#form_user_chang').trigger('reset');
		return false;
	}

	function submit_user_chang(){
		$('#btn_send').text('กำลังส่ง...');
      	$('#btn_send').attr('disabled', true);
		$.ajax({
		    url : '/user/changpassword',
		    type : 'post',
		    cache : false,
		    dataType : 'json',
		    data : $('form#form_user_chang').serialize()
		})
		.done(function(data) {
		    if (data.status == 404) {
		      swal(data.message, "", "error");
		    }else{
		      $('#modal_chang').modal('hide');
		      swal(data.message, " ", "success");
		    }
		    $('#btn_send').text('ตกลง');
      		$('#btn_send').attr('disabled', false);
		    // console.log(data);
		});
	  	return false;
	}

</script>