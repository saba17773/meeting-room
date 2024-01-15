<?php $this->layout('layouts/main'); 
use App\User\UserAPI;
$username = $_SESSION['user_name'];
$dataUser = (new UserAPI)->getUserId($username);
?>

<style type="text/css">
	table, th, td {
	    border: 1px solid white;
	    border-collapse: collapse;
	    padding: 5px;
	    /*text-align: center;*/
	    color:#ffffff;
	    width:500px;
	}
</style>

<div class="row">
    <div class="col-lg-12">
        <h1>แก้ไขข้อมูลส่วนตัว</h1>
        <hr>
    </div>
</div>

<div class="container">

	<form id="form_profile" onsubmit="return submit_profile()">
	<table>
		<tr bgcolor="#6E7B8B">
			<td>Username</td>
			<td> <input type="hidden" name="username" value="<?php echo $_SESSION['user_name']; ?>"> <div><?php echo $_SESSION['user_name']; ?></div> </td>
		</tr>
		<tr bgcolor="#6E7B8B">
			<td>Password</td>
			<td><input type="password" name="password" value="<?php echo $dataUser[0]['password']; ?>" style="width: 250px; height: 30px; color:#6E7B8B;"></td>
		</tr>
		<tr bgcolor="#6E7B8B">
			<td>ชื่อ</td>
			<td><input type="text" name="fname" value="<?php echo $dataUser[0]['fname']; ?>" style="width: 250px; height: 30px; color:#6E7B8B;" disabled="true"></td>
		</tr>
		<tr bgcolor="#6E7B8B">
			<td>นามสกุล</td>
			<td><input type="text" name="lname" value="<?php echo $dataUser[0]['lname']; ?>" style="width: 250px; height: 30px; color:#6E7B8B;" disabled="true"></td>
		</tr>
		<tr bgcolor="#6E7B8B">
			<td>บริษัท</td>
			<td><select class="form-control" name="company" id="company" required style="width: 250px; height: 30px; color:#6E7B8B;" disabled="true"></select></td>
		</tr>
		<tr bgcolor="#6E7B8B">
			<td>แผนก</td>
			<td><select class="form-control" name="department" id="department" required style="width: 250px; height: 30px; color:#6E7B8B;" disabled="true"></select></td>
		</tr>
		<tr bgcolor="#6E7B8B">
			<td>E-mail</td>
			<td><input type="text" name="email" value="<?php echo $dataUser[0]['email']; ?>" style="width: 250px; height: 30px; color:#6E7B8B;" disabled="true"></td>
		</tr>
		<tr bgcolor="#6E7B8B">
			<td>เบอร์ติดต่อ</td>
			<td><input type="text" name="tel" value="<?php echo $dataUser[0]['tell']; ?>" style="width: 250px; height: 30px; color:#6E7B8B;"></td>
		</tr>
		<tr bgcolor="#6E7B8B">
			<td colspan="2" align="center">
				<button class="btn btn-lg btn-primary" id="btn_save_booking"><i class="glyphicon glyphicon-floppy-saved"></i> บันทึก</button>
			</td>
		</tr>
	</table>
	</form>

</div>

<script type="text/javascript">
	jQuery(document).ready(function($) {
		$('#username').val('<?php echo $_SESSION['user_name'] ?>');

        getPlant()
		    .done(function(data) {
		      $('select[name=company]').html("<option value=''>=Select=</option>");
		      $.each(data, function(index, val) {
		        $('select[name=company]').append('<option value="'+val.com_id+'">'+val.com_nname+
		          ' ('+val.com_fname+')'+'</option>');
		        $('#company').val('<?php echo $dataUser[0]['company']; ?>');
		    });
		});

		getDepartment()
  		    .done(function(data) {
  		      $('select[name=department]').html("<option value=''>=Select=</option>");
  		      $.each(data, function(index, val) {
  		        $('select[name=department]').append('<option value="'+val.dep_id+'">'+val.dep_name+'</option>');
  		        $('#department').val('<?php echo $dataUser[0]['department']; ?>');
  		    });
  		});

	});


	function getPlant() {
	  return $.ajax({
	    url : '/room/loadcompany',
	    type : 'get',
	    dataType : 'json',
	    cache : false
	  });
	}

	function getDepartment() {
	  return $.ajax({
	    url : '/room/loaddepartment',
	    type : 'get',
	    dataType : 'json',
	    cache : false
	  });
	}

	function submit_profile() {
		$.ajax({
		    url : '/user/profile/update',
		    type : 'post',
		    cache : false,
		    dataType : 'json',
		    data : $('form#form_profile').serialize()
		})
		.done(function(data) {
		    if (data.result == false) {
		      swal(data.message, "", "error")
		    }else{
		      // swal(data.message, " ", "success");
		      swal({
		          title: data.message,
		          type: "success",
		          closeOnConfirm: false,
		          showLoaderOnConfirm: true
		        }, function () {
		          setTimeout(function () {
		          window.location = '/mybooking';
		        }, 2000);
		      });
		      
		    }
		    console.log(data);
		});
	  	return false;
	}
</script>