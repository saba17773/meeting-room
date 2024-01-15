<?php 
$this->layout('layouts/calendar'); 
use App\Room\RoomAPI;
use App\Booking\BookingAPI;
?>

<style>

	#script-warning {
		display: none;
		background: #eee;
		border-bottom: 1px solid #ddd;
		padding: 0 10px;
		line-height: 40px;
		text-align: center;
		font-weight: bold;
		font-size: 12px;
		color: red;
	}

	#loading {
		display: none;
		position: absolute;
		top: 10px;
		right: 10px;
	}

	#calendar {
		max-width: 1100px;
		max-height: 1100px;
		margin: 50px auto;
		font-size: 14px;
		padding-left: 80px;
	}
	.car_list{
	  position: absolute;
	  float: left;
	  background: #ffffff;
	  margin: 15px;
	  padding: 20px;
	  border: 1px solid #cccccc;
	  font-size: 12px;
	}
	
	/*.modal {
	    display: none;
	    position: fixed;
	    z-index: 4000;
	    padding-top: 100px;
	    left: 0;
	    top: 0;
	    width: 100%;
	    height: 100%;
	    overflow: auto;
	    background-color: rgb(0,0,0);
	    background-color: rgba(0,0,0,0.4);
	}

	.modal-content {
	    background-color: #fefefe;
	    margin: auto;
	    padding: 10px;
	    border: 1px solid #888;
	    width: 50%;
	}*/

	.close {
	    color: #aaaaaa;
	    float: right;
	    font-size: 28px;
	    font-weight: bold;
	}

	.close:hover,
	.close:focus {
	    color: #000;
	    text-decoration: none;
	    cursor: pointer;
	}

</style>

<div class="container">
	<div class="row">
	  	<div class="col-lg-12">
	    	<h3>ตารางการใช้ห้องประชุม</h3>
	    </div>
	</div>
</div>

<body>

	<div id='script-warning'>
		This page should be running from a webserver, to allow fetching from the <code>json/</code> directory.
	</div>

	<div id='loading'>loading...</div>
	
	<div class="car_list">
		<p style="margin-bottom:10px;"><b>รายชื่อห้องประชุม</b></p>
		<table class="table table-condensed">

		<?php 
	        $dataroom  = (new RoomAPI)->load();
	        foreach ($dataroom as $room) {
      	?>
      	<tr>
      		<td>
      			<p align="center" style="background:#708090; padding:10px; display:block;  margin:0 auto;">
				</p>
      		</td>
      		<td>
      			<?php 
      				echo $room['room_name'];
      			?>
      		</td>
      	</tr>

      	<?php } ?>
		
		</table>
	</div>

	<div id='calendar'></div>
	
	<!-- The Modal -->

	<div class="modal" id="myModal" tabindex="-1" role="dialog">
	  	<div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="btn btn-danger pull-right" data-dismiss="modal" aria-label="Close" id="close_dialog">
	          <span class="glyphicon glyphicon-remove"></span>
	          Close
	        </button>
	        <h4><p id="book_number"></p></h4>
	      </div>
	      <div class="modal-body">
	        <form id="form_booking" onsubmit="return submit_booking_room()">
		        <table align="center">
		        	<tr>
			    		<td>
			    			<label>ห้องประชุม</label>
			    		</td>
			    		<td colspan="2">
			    			<p id="room_name"></p>
			    		</td>
			    	</tr>
			    	<tr>
			    		<td>
			    			<label>วันที่/เวลา (เริ่ม)&nbsp;&nbsp;</label>
			    		</td>
			    		<td colspan="2">
			    			<p id="start_name"></p>
			    		</td>
			    	</tr>
			    	<tr>
			    		<td>
			    			<label>วันที่/เวลา (สิ้นสุด)&nbsp;&nbsp;</label>
			    		</td>
			    		<td colspan="2">
			    			<p id="end_name"></p>
			    		</td>
			    	</tr>
			    	<tr>
			    		<td>
			    			<label>หัวข้อการประชุม</label>
			    		</td>
			    		<td colspan="2">
			    			<p id="title_name"></p>
			    		</td>
			    	</tr>
			    	<tr>
			    		<td>
			    			<label>ผู้ใช้งาน</label>
			    		</td>
			    		<td colspan="2">
			    			<p id="user_name"></p>
			    		</td>
			    	</tr>
			    	<tr>
			    		<td>
			    			<label>จำนวนผู้เข้าประชุม</label>
			    		</td>
			    		<td colspan="2">
			    			<p id="user_seat"></p>
			    		</td>
			    	</tr>
			    	<tr>
			            <td>
			              <label>คนรับรอง</label>
			            </td>
			            <td>
			              <input type="radio" name="booking_supportchk" id="booking_supportchk1" value="1">มี
			              <input type="radio" name="booking_supportchk" id="booking_supportchk0" value="0">ไม่มี
			            </td>
			            <td>
			            	<div id="support">
				                <p id="booking_support"></p>
				            </div>
			            </td>
			        </tr>
			        <tr>
			            <td>
			              <label>รูปแบบการจัดห้อง</label>
			            </td>
			            <td colspan="2">
			              <span id="mySpanlayout"></span>
			            </td>
			        </tr>
			        <tr>
			            <td valign="top">
			              <label>อาหาร</label>
			            </td>
			            <td colspan="2">
			                <span id="mySpanfood"></span>
			            </td>
			        </tr>
			        <tr>
			            <td valign="top">
			              <label>ของว่าง</label>
			            </td>
			            <td colspan="2">
			                <span id="mySpandessert"></span>
			            </td>
			        </tr>
			        <tr>
						<td>
			              <label>สถานะ</label>
			            </td>
			            <td colspan="2">
			              <p id="myStatus"></p>
			            </td>
			        </tr>
	        		<tr>
	        			<td colspan="2">
	        				<br>
	        				<input type="hidden" name="book_room" id="book_room">
							<input type="hidden" name="title" id="title">
							<input type="hidden" name="startdate" id="startdate">
							<input type="hidden" name="enddate" id="enddate">
							<input type="hidden" name="starttime" id="starttime">
							<input type="hidden" name="endtime" id="endtime">
			              	<input type="hidden" name="bookid" id="bookid">
			              	<input type="hidden" name="click_type" id="click_type">

	        				<button class="btn btn-primary" id="btn_approve_booking"><i class="glyphicon glyphicon-send"></i> อนุมัติ</button>
	                		<button class="btn btn-danger" id="btn_notapprove_booking"><i class="glyphicon glyphicon-remove-sign"></i> ไม่อนุมัติ</button>
	        			</td>
	        		</tr>
		        </table>
		    </form>
		  </div>
		</div>
		</div>
	</div>

</body>

<script type="text/javascript">
	
	$(function() { 
		
		$('#calendar').fullCalendar({

			now: new Date(),
			editable: false, 
			aspectRatio: 1.8,
			scrollTime: '08:00',
			header: {
				left: 'today prev,next',
				center: 'title',
				right: 'timelineDay,agendaWeek,month'
			},
			defaultView: 'timelineDay',
			views: {
				timelineThreeDays: {
					type: 'timeline',
					duration: { days: 3 }
				}
			},
			resourceLabelText: 'รายชื่อห้องประชุม',

			resources: { 
				url: '/api/v1/book1',
				error: function() {
					$('#script-warning').show();
				}
			},

			events: { 
				url: '/api/v1/book2',
				textColor: 'black',
				error: function() {
					$('#script-warning').show();
				}
			},
			eventRender: function (event, element, view) {
               	if (event.eventColor) {
                    element.css('background-color', event.eventColor)
               	}

             },
			eventClick: function(calEvent, jsEvent, view) {

					$('#form_booking').trigger('reset');
					$('#support').hide();
			        $('#myModal').show();
			        $('#bookid').val(calEvent.id);
			        $('#book_room').val(calEvent.resourceId);
			        $('#title').val(calEvent.title);
			        $('#startdate').val(calEvent.startdate);
			        $('#starttime').val(calEvent.starttime);
			        $('#enddate').val(calEvent.enddate);
			        $('#endtime').val(calEvent.endtime);
			        var start = moment(calEvent.start).format("dddd DD-MM-YYYY HH:mm");
			        var end = moment(calEvent.end).format("dddd DD-MM-YYYY HH:mm");
			        document.getElementById("book_number").innerHTML = "รายละเอียดการจองห้องประชุม  รายการที่ "+calEvent.id;
					document.getElementById("title_name").innerHTML = calEvent.title;
			        document.getElementById("start_name").innerHTML = start;
			        document.getElementById("end_name").innerHTML = end;
			        document.getElementById("room_name").innerHTML = calEvent.roomname;
			        document.getElementById("user_name").innerHTML = calEvent.user;
			        document.getElementById("user_seat").innerHTML = calEvent.seat+" คน";
			        document.getElementById("myStatus").innerHTML = calEvent.statusname;

			        gojax('get', '/load/support?numbersequence='+calEvent.id)
			            .done(function(data){
				            if (data!='') {
				                $.each(data, function( k, v ) {
				                $("#support").show();
				                $("#booking_supportchk1").prop('checked' , true);
				                document.getElementById("booking_support").innerHTML = v.support_id+" คน";
				                });
				            }else{
				                $("#booking_supportchk0").prop('checked' , true);
				            }
			        });

			        gojax('get', '/load/layout?numbersequence='+calEvent.id)
			            .done(function(data){
			            $('#mySpanlayout').html("");
			            $.each(data, function( k, v ) {
			              gojax('get', '/layout/load')
			                .done(function(data) {
			                   $('#mySpanlayout').append(""+v.layout_name+"");
			                $("#booking_layout").val(v.layout_id);
			              });
			            });
			        });
  
			        gojax('get', '/load/food?numbersequence='+calEvent.id)
			            .done(function(data){
			            $('#mySpanfood').html("");
			            $.each(data, function( k, v ) {
			                $('#mySpanfood').append("<table><tr><td width=150px>"+v.food_name+"</td><td width=80px>"+v.food_unit+" หน่วย</td><td width=130px>ราคา"+v.food_price+"บาท/หน่วย </td><td> ="+v.food_unit*v.food_price+" บาท</td></tr></table>");
			            });

			        });
			 
			        gojax('get', '/load/dessert?numbersequence='+calEvent.id)
			            .done(function(data){
			            $('#mySpandessert').html("");
			            $.each(data, function( k, v ) {
			                $('#mySpandessert').append("<table><tr><td width=150px>"+v.dessert_name+"</td><td width=80px>"+v.food_unit+" หน่วย</td><td width=130px>ราคา"+v.dessert_price+"บาท/หน่วย </td><td> ="+v.food_unit*v.dessert_price+" บาท</td></tr></table>");
			            });

			        });

			        $("input[name=booking_supportchk]").bind('click', function() {
			            if ($("input[name=booking_supportchk]:checked").val() == 1) {
			                $('#support').show();
			            } else {
			                $('#support').hide();
			            }
			        });

			        $('#btn_approve_booking').on('click', function() {
				      $('#click_type').val("approve");
				    });

				    $('#btn_notapprove_booking').on('click', function() {
				      $('#click_type').val("notapprove");
				    });

				    $('#close_dialog').on('click', function() {
				    	$('#myModal').hide();
				    });
				    console.log(calEvent.bookstatus);
			        if (calEvent.bookstatus!=4) {
			        	$('#btn_approve_booking').show();
			        	$('#btn_notapprove_booking').show();
			        }else{
			        	$('#btn_approve_booking').hide();
			        	$('#btn_notapprove_booking').hide();
			        }
			}
		});

	});

	function removeEle(divid,_divid,divbr,divinput,divstrunit){
	    $(divid).remove(); 
	    $(_divid).remove();
	    $(divbr).remove(); 
	    $(divinput).remove(); 
	    $(divstrunit).remove();
	}  

	function deleteFood(food_id,booking_id,type,divid,_divid,divbr,divinput,divstrunit){

	    if (confirm('Are you sure?')) {

	      $.ajax({
	        url : '/booking/daletefood',
	        type : 'post',
	        cache : false,
	        dataType : 'json',
	        data : {
	          food_id     : food_id,
	          booking_id  : booking_id,
	          type        : type
	        }
	      })
	      .done(function(data) {
	        if (data.status == 404) {
	          swal(data.message, "", "error");
	        }else{
	          $(divid).remove(); 
	          $(_divid).remove();
	          $(divbr).remove(); 
	          $(divinput).remove(); 
	          $(divstrunit).remove();
	          // swal(data.message, "", "success");
	        }
	        
	      });
	      return false;
	        

	    }
	}

	function getFood() {
	    return $.ajax({
	      url : '/food/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}

  	function getDessert() {
	    return $.ajax({
	      url : '/dessert/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
  	}

  	function submit_booking_room(){
	     
	    if ($('#click_type').val()=="approve") {
			$('#btn_approve_booking').text('กำลังบันทึก...');
	    	$('#btn_approve_booking').attr('disabled', true);
	    }else{
	    	$('#btn_notapprove_booking').text('กำลังบันทึก...');
	    	$('#btn_notapprove_booking').attr('disabled', true);
	    }

	    $.ajax({
	      url : '/booking/admin/approve',
	      type : 'post',
	      cache : false,
	      dataType : 'json',
	      data : $('form#form_booking').serialize()
	    })
	    .done(function(data) {
	      if (data.status == 404) {

	        swal(data.message, "", "error");
	        $('#btn_notapprove_booking').text('อนุมัติ');
	    	$('#btn_notapprove_booking').attr('disabled', false);
	    	$('#btn_notapprove_booking').text('ไม่อนุมัติ');
	    	$('#btn_notapprove_booking').attr('disabled', false);
	        
	      }else{
	        
	        swal({
	            title: data.message,
	            type: "success",
	            closeOnConfirm: false,
	            showLoaderOnConfirm: true
	          }, function () {
	            setTimeout(function () {
	            location.reload();
	          }, 2000);
	        });
	       
	      }
	      console.log(data);
	    });
	    return false;

	}

</script>

