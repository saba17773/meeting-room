<?php $this->layout('layouts/main'); 

  use App\Database\Connection;
  use App\Room\RoomAPI;
  use App\Booking\BookingAPI;
  $db = (new Connection)->dbConnect();
  
  if( $db === false ) {
    die( print_r( sqlsrv_errors(), true));
  }

  ini_set('display_errors', 1);
  error_reporting(0);

  $company = null;
  $startDate = null;
  $startTime = null;
  $endDate = null;
  $endTime = null;
  $grid_room = null;

  if(isset($_GET["company"]) && $_GET["grid_room"]=='' )
  {
    $company    = $_GET["company"];
    $startDate  = $_GET["startDate"];
    $startTime  = $_GET["startTime"];
    $endDate    = $_GET["endDate"];
    $endTime    = $_GET["endTime"];

    $dataRoom = (new BookingAPI)->getByComp($company,$startDate,$startTime,$endDate,$endTime);
    // echo "<pre>".print_r($dataRoom,true)."</pre>";
    // exit;
  }else if(isset($_GET["grid_room"])){
    $room       = $_GET["grid_room"];
    $company    = $_GET["company"];
    $startDate  = $_GET["startDate"];
    $startTime  = $_GET["startTime"];
    $endDate    = $_GET["endDate"];
    $endTime    = $_GET["endTime"];

    $dataRoom = (new BookingAPI)->getByRoom($room,$company,$startDate,$startTime,$endDate,$endTime);
    // echo "<pre>".print_r($dataRoom,true)."</pre>";
    // exit;
  }
        
?>

<style type="text/css">
  td { 
    padding: 10px;
    text-align: left;
  }
  hr{
    color: #FFFFFF;
    background-color: #FFFFFF;
    height: 4px;
  }
  .inner { 
    padding: 2px;
    text-align: left;
  }
  input[type=radio] {
    width: 20px;
    height: 20px;
  }
  input[type=checkbox] {
    width: 20px;
    height: 20px;
  }
  .ui-datepicker{z-index:9999 !important;}
  .ui-dialog { z-index: 9999 !important ;}
</style>

<div id="dialogpic">
  <div id="foodpic"></div>
</div>

<div class="modal" id="modal_booking" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">จองห้องประชุม</h4>
      </div>
      <div class="modal-body">
        <form id="form_booking" onsubmit="return submit_booking_room()">
          
          <table align="center">
            <tr>
              <td>
                <label>ชื่อห้องประชุม</label>
              </td>
              <td>
                <input type="text" name="booking_roomname" id="booking_roomname" class="form-control" autocomplete="off" readonly="true">
                <input type="hidden" name="booking_roomid" id="booking_roomid">
              </td>
              <td>
                <label>
                  กรณีจองซ้ำ
                  <input type="checkbox" name="booking_loopcheck" id="booking_loopcheck">
                </label>
              </td>
              <td>
                <div id="loopchk">
                  <!-- <select class="form-control" name="booking_loopdate" id="booking_loopdate">
                    <option value="0">=Select=</option>
                    <option value="Mon">วันจันทร์</option>
                    <option value="Tue">วันอังคาร</option>
                    <option value="Wed">วันพุธ</option>
                    <option value="Thu">วันพฤหัสบดี</option>
                    <option value="Fri">วันศุกร์</option>
                    <option value="Sat">วันเสาร์</option>
                  </select> -->
                  <select class="form-control" name="booking_loopdate" id="booking_loopdate"></select>
                </div>
              </td>
            </tr>
            <tr>
              <td>
                <label>วันที่เริ่มต้น</label>
              </td>
              <td>
                <div class="input-group">
                      <input type="text" class="form-control" name="booking_startdate" id="booking_startdate" placeholder="เลือกวันที่..." autocomplete="off" required readonly="true">
                      <span class="input-group-btn">
                        <button class="btn btn-info" id="date_booking_start_show" type="button">
                          <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                        </button>
                      </span>
                    </div>
                </div>
              </td>
              <td>
                <select class="form-control" name="booking_starttime" id="booking_starttime" required></select>
              </td>
            </tr>
            <tr>
              <td>
                <label>วันที่สิ้นสุด</label>
              </td>
              <td>
                <div class="input-group">
                      <input type="text" class="form-control" name="booking_enddate" id="booking_enddate" placeholder="เลือกวันที่..." autocomplete="off" required readonly="true">
                      <span class="input-group-btn">
                        <button class="btn btn-info" id="date_booking_end_show" type="button">
                          <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                        </button>
                      </span>
                    </div>
                </div>
              </td>
              <td>
                <select class="form-control" name="booking_endtime" id="booking_endtime" required></select>
              </td>
            </tr>
            <tr>
              <td>
                <label>หัวข้อการประชุม</label>
              </td>
              <td>
                <input type="text" name="booking_name" id="booking_name" class="form-control" autocomplete="off" required>
              </td>
              <td>
                <label>จำนวนผู้เข้าประชุม</label>
              </td>
              <td>
                <input type="text" name="booking_seat" id="booking_seat" class="form-control allownumberdecimal" autocomplete="off" required style="width: 70px;">
              </td>
              <td><label>คน</label></td>
            </tr>
            <tr>
              <td>
                <label>ผู้ใช้งาน</label>
              </td>
              <td>
                <input type="text" name="booking_user" id="booking_user" class="form-control" autocomplete="off" required>
              </td>
              <td>
                <label>คนรับรอง</label>
                <input type="radio" name="booking_supportchk" value="1"> <label>มี</label>
                <input type="radio" name="booking_supportchk" value="0" checked="true"> <label>ไม่มี
                </label>
              </td>
              <td>
                <div id="support">
                  <input type="text" name="booking_support" id="booking_support" style="width: 70px;" class="form-control allownumberdecimal">
                </div>
              </td>
              <td><label id="support_unit">คน</label></td>
            </tr>
            <tr>
              <td>
                <label>กรณีเลือกรายการอาหาร</label>
              </td>
              <td>
                <input type="checkbox" name="booking_chkfood" id="booking_chkfood">
              </td>
            </tr>
            <tr>
              <td>
                <div id="divfood_label">
                  <label>อาหาร</label>
                </div>
              </td>
              <td colspan="2">
                <div id="divfood_span">
                  <input name="food" id="food" type="button" class="btn btn-info" value="+" style="font-size: 1.2em;"><br>
                  <div class="well"><span id="mySpanfood"></span></div>
                </div>
              </td>
            </tr>
            <tr>
              <td>
                <div id="divdessert_label">
                  <label>ของว่างและเครื่องดื่ม</label>
                </div>
              </td>
              <td colspan="2">
                <div id="divdessert_span">
                  <input name="dessert" id="dessert" type="button" class="btn btn-info" value="+" style="font-size: 1.2em;"><br>
                  <div class="well"><span id="mySpandessert"></span></div>
                </div>
              </td>
            </tr>
          
            <tr>
              <td>
                <label>รูปแบบการจัดห้อง</label>
              </td>
              <td>
                <select class="form-control" name="booking_layout" id="booking_layout" required></select>
                <input type="hidden" name="layoutpicid" id="layoutpicid">
              </td>
              <td colspan="2">
                <div id="layoutpic"></div>
              </td>
            </tr>
            <tr>
              <td>
                <label>เพิ่มเติม</label>
              </td>
              <td colspan="2">
                <textarea rows="2" class="form-control" name="booking_remark" id="booking_remark"></textarea>
              </td>
            </tr>
            <tr>
              <td></td>
              <td colspan="3">
                <label>
                  <button class="btn btn-lg btn-primary" id="btn_save_booking"><i class="glyphicon glyphicon-floppy-saved"></i> บันทึก</button>
                </label>
                <!-- <label>
                  <button class="btn btn-lg btn-default" type="reset" id="btn_reset_booking"><i class="glyphicon glyphicon-refresh"></i> ล้างค่า</button>
                </label> -->
              </td>
            </tr>
          </table>

        </form>
      </div>
    </div>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
      <h1 style="text-align: center;">ตรวจสอบห้องว่าง</h1>
      <hr>
  </div>
</div>

<div class="row">
	<div class="col-md-12">
    <div style="text-align: center;">
      <form id="form_checkroom" method="get">

        <table align="center">
        <tr>
          <td>วันที่เริ่มต้น</td>
          <td>
            <div class="input-group" style="width: 200px;">
                  <input type="text" class="form-control" name="startDate" id="startDate" placeholder="เลือกวันที่..." autocomplete="off" required value="<?php echo $startDate;?>">
                  <span class="input-group-btn">
                    <button class="btn btn-info" id="date_startDate_show" type="button">
                      <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                    </button>
                  </span>
            </div>
          </td>
          <td style="width: 150px;">
              <select name="startTime" id="startTime" class="form-control" required></select>
          </td>
          <td>
            <span class="glyphicon glyphicon-option-vertical" style="font-size:20px;"></span>
          </td>
          <td>วันที่สิ้นสุด</td>
          <td>
            <div class="input-group" style="width: 200px;">
                  <input type="text" class="form-control" name="endDate" id="endDate" placeholder="เลือกวันที่..." autocomplete="off" required value="<?php echo $startDate;?>">
                  <span class="input-group-btn">
                    <button class="btn btn-info" id="date_endDate_show" type="button">
                      <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                    </button>
                  </span>
            </div>
          </td>
          <td style="width: 150px;">
              <select name="endTime" id="endTime" class="form-control" required></select>
          </td>
        </tr>
        <tr>
          <td>บริษัท</td>
          <td style="width: 200px;">
            <select name="company" id="company" class="form-control"  required></select>
          </td>
          <td style="width: 150px;">
            <div id='grid_room' name='grid_room'></div>
          </td>
        </tr>
        </table>

      <button class="btn btn-lg btn-primary" type="submit"><i class="glyphicon glyphicon-search"></i> ค้นหา</button>
      </form>
    </div>
	</div>
</div>
<hr>
  
  <table class="table table-bordered">
    <?php if (isset($_GET["company"])) { ?>
    <tr>
        <td colspan='2' style="text-align: center;" bgcolor="#BEBEBE">
            <h4><b>รายละเอียด<b></h4>
        </td>
    </tr>
    <tr>
        <td style="text-align: center; width:50%;" bgcolor="#BEBEBE">
            <b>รูปภาพห้องประชุม</b>
        </td>
        <td style="text-align: center; width:50%;" bgcolor="#BEBEBE">
            <b>ข้อมูลห้องประชุม</b>
        </td>
    </tr>
    <?php } ?>
    <?php
      foreach ($dataRoom as $value) {
    ?>
    <tr>
      <td style="text-align: center;">
        <img src="./picturemaster/room/<?php echo $value['room_picture'];?>" style="width:400px;height:250px;"> 
      </td>
      <td>
        <table>
          <tr>
            <td class="inner">
              ชื่อห้องประชุม
            </td>
            <td class="inner">
              : <?php echo $value['room_name']; ?>
            </td>
          </tr>
          <tr>
            <td class="inner">
              จำนวนที่นั่ง
            </td>
            <td class="inner">
              : <?php echo $value['room_max_seat']; ?>
            </td>
          </tr>
          <tr>
            <td class="inner">
              ชั้น
            </td>
            <td class="inner">
              : <?php echo $value['room_floor']; ?>
            </td>
          </tr>
          <tr>
            <td class="inner">
              บริษัท
            </td>
            <td class="inner">
              : <?php echo $value['com_fname']; ?>
            </td>
          </tr>
          <tr>
            <td class="inner" valign="top">
              อุปกรณ์
            </td>
            <td class="inner">
                :<?php 
                  $idTool = explode(",",$value['room_tool']);
                    foreach ($idTool as $tool) {
                    $dataTool = (new RoomAPI)->loadtool($tool);
                    if (isset($dataTool[0]['tool_name'])) {
                        echo "&nbsp;".$dataTool[0]['tool_name']."<br>";
                      }
                    }
                ?>
            </td>
          </tr>
          <tr>
            <td>
              
            </td>
            <td><br>
              <button class="btn btn-lg btn-primary" Onclick="return btn_booking('<?php echo $value['room_id']; ?>','<?php echo $value['room_name']; ?>','<?php echo $value['room_company']; ?>','<?php echo $value['room_floor']; ?>','<?php echo $value['room_max_seat']; ?>')">
              <i class="glyphicon glyphicon-th-list"></i>
              จอง</button>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <?php } ?>
  </table>



<script>

jQuery( document ).ready(function($) {
  $('#divfood_label').hide();
  $('#divfood_span').hide();
  $('#divdessert_label').hide();
  $('#divdessert_span').hide();
  $('#dialogpic').hide();
  // console.log(year+"-"+month+"-"+day);

  // date dialog
  $('#booking_startdate').datepicker({
    dateFormat: 'dd-mm-yy',
    onSelect: function(dateText){
          $('#booking_enddate').val($('#booking_startdate').val());
      }
  });
  $('#booking_enddate').datepicker({ dateFormat: 'dd-mm-yy' });

  $('#date_booking_start_show').click(function() {
    $('#booking_startdate').datepicker('show');
  });
  $('#date_booking_end_show').click(function() {
    $('#booking_enddate').datepicker('show');
  });

  // date form
  $('#startDate').datepicker({
    dateFormat: 'dd-mm-yy',
    onSelect: function(dateText){
          $('#endDate').val($('#startDate').val());
      }
  });
  $('#endDate').datepicker({ dateFormat: 'dd-mm-yy' });

  $('#date_startDate_show').click(function() {
    $('#startDate').datepicker('show');
  });
  $('#date_endDate_show').click(function() {
    $('#endDate').datepicker('show');
  });
  
  $('#loopchk').hide();
  $('#support').hide();
  $('#support_unit').hide();

  $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
     $(this).val($(this).val().replace(/[^\d].+/, ""));
      if ((event.which < 48 || event.which > 57)) {
          event.preventDefault();
      }
  });

  gojax('get', '/book/weekly')
    .done(function(data) {
      $('#booking_loopdate').html("<option value=''>=Select=</option>");
      $.each(data, function(index, val) {
       $('#booking_loopdate').append('<option value="'+val.weekly_id+'">'+val.weekly_name+'</option>');
      });
      // $('#booking_loopdate').val();
  });

  getPlant()
    .done(function(data) {
      $('select[name=company]').html("<option value=''>=Select=</option>");
      $.each(data, function(index, val) {
        $('select[name=company]').append('<option value="'+val.com_nname+'">'+val.com_nname+
          ' ('+val.com_fname+')'+'</option>');
        $('#company').val('<?php echo $company; ?>');
      });
  });

  getTimein()
    .done(function(data) {
      $('select[name=startTime]').html("<option value=''>=Select=</option>");
      $.each(data, function(index, val) {
        $('select[name=startTime]').append('<option value="'+val.timein+'">'+val.timein+'</option>');
        $('#startTime').val('<?php echo $startTime; ?>');
      });
  });

  getTimeout()
    .done(function(data) {
      $('select[name=endTime]').html("<option value=''>=Select=</option>");
      $.each(data, function(index, val) {
        $('select[name=endTime]').append('<option value="'+val.timeout+'">'+val.timeout_name+'</option>');
        $('#endTime').val('<?php echo $endTime; ?>');
      });
  });
  
  $('#company').on('click', function() {
    grid_room($('#company').val());
  });

  $('#modal_booking').on('hidden.bs.modal', function () {
    location.reload();
  });

  // $('#btn_reset_booking').bind('click',function(){
    // $("#booking_loopcheck").attr('checked', false);
    // $('#booking_loopdate').html("<option value=''>=Select=</option>");
    // $('#booking_startdate').val("");
    // $('#booking_enddate').val("");
    // $('#booking_starttime').val("");
    // $('#booking_endtime').val("");
    // $('#booking_name').val("");
    // $('#booking_seat').val("");
    // $('#booking_support').val("");
    // $('#booking_layout').html("<option value=''>=Select=</option>");
    // $("#booking_name").val("TEST");
  // });

});

function grid_room(comp) {
      
  var dataAdapter = new $.jqx.dataAdapter({
  datatype: "json",
  datafields: [
            { name: "room_id", type: "int" },
            { name: "room_name", type: "string"}
  ],
    url : '/room/load?comp='+comp
  });

  $("#grid_room").jqxDropDownList({ checkboxes: true, source: dataAdapter, displayMember: "room_name", valueMember: "room_id", width: 150, height: 30, theme: 'deestone'});
}

function getPlant() {
  return $.ajax({
    url : '/room/loadcompany',
    type : 'get',
    dataType : 'json',
    cache : false
  });
}

function getTimein() {
  return $.ajax({
    url : '/book/timein',
    type : 'get',
    dataType : 'json',
    cache : false
  });
}

function getTimeout() {
  return $.ajax({
    url : '/book/timeout',
    type : 'get',
    dataType : 'json',
    cache : false
  });
}

function getLayout() {
  return $.ajax({
    url : '/layout/load',
    type : 'get',
    dataType : 'json',
    cache : false
  });
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


function show_imageLayout(src, width, height, alt) {
  var img = document.createElement("img");
  img.src = src;
  img.width = 280;
  img.height = 200;
  img.alt = alt;

  $('#layoutpic').html( document.body.appendChild(img));
}

$('#form_checkroom').submit(function(e){    
  var currentDate = new Date(),
  day = currentDate.getDate(),
  month = currentDate.getMonth() + 1,
  year = currentDate.getFullYear();
  if (month.toString().length==1){
    month = ("0"+month);
  }

  if ($('#startDate').val().substr(6, 4) < year) {
    swal("กรุณาเลือกปีใหม่", "", "error");
    e.preventDefault();
  }

  if ($('#startDate').val().substr(6, 4) === year && $('#startDate').val().substr(3, 2) < month) {
    swal("กรุณาเลือกเดือนใหม่", "", "error");
    e.preventDefault();
  }

  if ($('#startDate').val().substr(3, 2) == month && $('#startDate').val().substr(0, 2) < day) {
    swal("กรุณาเลือกวันใหม่", "", "error");
    e.preventDefault();
  }

  if ($('#startDate').val().substr(6, 4) > $('#endDate').val().substr(6, 4)) {
    swal("กรุณาเลือกปีเดียวกัน", "", "error");
    e.preventDefault();
  }

  if ($('#startDate').val().substr(6, 4) === $('#endDate').val().substr(6, 4) && $('#startDate').val().substr(3, 2) > $('#endDate').val().substr(3, 2)) {
    swal("กรุณาเลือกเดือนสิ้นสุดใหม่", "", "error");
    e.preventDefault();
  }

  if ($('#startDate').val().substr(3, 2) == $('#endDate').val().substr(3, 2) && $('#startDate').val().substr(0, 2) > $('#endDate').val().substr(0, 2)) {
    swal("กรุณาเลือกวันสิ้นสุดใหม่", "", "error");
    e.preventDefault();
  }
  if ($('#startTime').val() > $('#endTime').val()) {
    swal("กรุณาเลือกเวลาสิ้นสุดใหม่", "", "error");
    $('#endTime').focus();
    e.preventDefault();
  }  
});

$("#booking_layout").change(function(){
  var viewlayout = $("#booking_layout option:selected").val();
  
  namepic = viewlayout.split('_').pop();
  idpic   = viewlayout.substr(0, viewlayout.indexOf('_'));

  var src = "/picturemaster/layout/"+namepic;

  if (namepic!="") {
    $('#layoutpic').show();
    $('#layoutpicid').val(idpic);
    show_imageLayout(src);
  }else{
    $('#layoutpic').hide();
  }

});

function showpicfood(data){
  var id = data.id;
  var idfood = $("#"+id+"").val();
  if (!!idfood) {
    $("#dialogpic").dialog({width: "340px"});
    $(".ui-dialog-title").text("รูปภาพอาหาร");
      $.ajax({
        url : '/food/load/picture',
        type : 'get',
        cache : false,
        dataType : 'json',
        data : {
          idfood  : idfood
        }
      })
      .done(function(data) {
        // console.log(data.message);
        var src = "/picturemaster/food/"+data.message;
        var img = document.createElement("img");
        img.src = src;
        img.width = 300;
        img.height = 200;
        $('#foodpic').html( document.body.appendChild(img));
    });
  }
  return false;
}

function showpicdessert(data){
  var id = data.id;
  var idfood = $("#"+id+"").val();
  if (!!idfood) {
    $("#dialogpic").dialog({width: "340px"});
    $(".ui-dialog-title").text("รูปภาพของว่างและเครื่องดื่ม");
      $.ajax({
        url : '/food/load/picture/dessert',
        type : 'get',
        cache : false,
        dataType : 'json',
        data : {
          idfood  : idfood
        }
      })
      .done(function(data) {
        // console.log(data.message);
        var src = "/picturemaster/dessert/"+data.message;
        var img = document.createElement("img");
        img.src = src;
        img.width = 300;
        img.height = 200;
        $('#foodpic').html( document.body.appendChild(img));
    });
  }
  return false;
}

function btn_booking(room_id,room_name,room_company,room_floor,room_max_seat){

  $('#modal_booking').modal({backdrop: 'static'});

  $("#booking_loopcheck").on('change', function() {

    if ($(this).is(':checked')) {
      $(this).attr('value', 'true');
      // $('#booking_loopdate').attr('disabled', false);
      $('#loopchk').show();
    } else {
      $(this).attr('value', 'false'); 
      // $('#booking_loopdate').attr('disabled', true);
      $('#loopchk').hide();
    }

  });

  $("#booking_chkfood").on('change', function() {

    if ($(this).is(':checked')) {
      $(this).attr('value', 'true');
      $('#divfood_label').show();
      $('#divfood_span').show();
      $('#divdessert_label').show();
      $('#divdessert_span').show();
    } else {
      $(this).attr('value', 'false'); 
      $('#divfood_label').hide();
      $('#divfood_span').hide();
      $('#divdessert_label').hide();
      $('#divdessert_span').hide();
    }

  });

  $("input[name=booking_supportchk]").bind('click', function() {
    if ($("input[name=booking_supportchk]:checked").val() == 1) {
        $('#support').show();
        $('#support_unit').show();
    } else {
        $('#support').hide();
        $('#support_unit').hide();
    }
  });

  // $('#booking_startdate').datepicker({ dateFormat: 'dd-mm-yy' });
  // $('#booking_enddate').datepicker({ dateFormat: 'dd-mm-yy' });

  $('#booking_roomid').val(room_id);
  $('#booking_roomname').val(room_name);
  $('#booking_startdate').val('<?php echo $startDate; ?>');
  $('#booking_enddate').val('<?php echo $endDate; ?>');
  

  getTimein()
    .done(function(data) {
      $('select[name=booking_starttime]').html("<option value=''>=Select=</option>");
      $.each(data, function(index, val) {
        $('select[name=booking_starttime]').append('<option value="'+val.timein+'">'+val.timein+'</option>');
        $('#booking_starttime').val('<?php echo $startTime; ?>');
      });
  });  

  getTimeout()
    .done(function(data) {
      $('select[name=booking_endtime]').html("<option value=''>=Select=</option>");
      $.each(data, function(index, val) {
        $('select[name=booking_endtime]').append('<option value="'+val.timeout+'">'+val.timeout_name+'</option>');
        $('#booking_endtime').val('<?php echo $endTime; ?>');
      });
  });

  getLayout()
    .done(function(data) {
      $('select[name=booking_layout]').html("<option value=''>=Select=</option>");
      $.each(data, function(index, val) {
        $('select[name=booking_layout]').append('<option value="'+val.layout_id+'_'+val.layout_picture+'">'+val.layout_name+'</option>');
        $('#booking_layout').val();
      });
  });

  // food
  var num =1;
  
  $('#food').bind('click',function(){
   var add ="add"+num;
   var select_ ="select_"+num;
   var input_  ="input_"+num;
   var br1 = "br1"+num;
   var strunit = "strunit_"+num; 
    
    $('#mySpanfood').append("<button class='btn btn-info' id='"+add+"' onclick='removeEle("+add+','+select_+','+br1+','+input_+','+strunit+','+add+ ")' type='button'>-</button><select name='food[]' id='"+select_+"' required></select><input type='text' name='food_unit[]' id='"+input_+"' style='width: 50px' required class='allownumberdecimal'> <label id='"+strunit+"'>หน่วย</label> <button id='"+add+"' type='button' class='btn btn-info' onclick='showpicfood("+select_+");'><span class='glyphicon glyphicon-search' style='font-size:15px;'></span></button><br id='"+br1+"'>");

    getFood()
    .done(function(data) {
        $("#"+select_+"").html("<option value=''>=Select=</option>");
        $.each(data, function(indax, val) {
          $("#"+select_+"").append('<option value="'+val.food_id+'">'+val.food_name+'</option>');
        });
    });

    $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
       $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });
    num++;
  });
  // dessert
  var numd =1;
  
  $('#dessert').bind('click',function(){
   var addd ="addd"+numd;
   var dessert_ ="dessert_"+numd;
   var inputd_  ="inputd_"+numd;
   var brd = "brd"+numd;
   var strunitd = "dessertunit_"+numd; 

   $('#mySpandessert').append("<button id='"+addd+"' onclick='removeEle("+addd+','+dessert_+','+brd+','+inputd_+','+strunitd+ ")' type='button' class='btn btn-info'>-</button><select name='dessert[]' id='"+dessert_+"' required></select> <input type='text' name='dessert_unit[]' id='"+inputd_+"' style='width: 50px' required class='allownumberdecimal'> <label id='"+strunitd+"'>หน่วย</label><button id='"+addd+"' type='button' class='btn btn-info' onclick='showpicdessert("+dessert_+");'><span class='glyphicon glyphicon-search' style='font-size:15px;'></span></button><br id='"+brd+"'>");

    getDessert()
    .done(function(data) {
        $("#"+dessert_+"").html("<option value=''>=Select=</option>");
        $.each(data, function(indax, val) {
          $("#"+dessert_+"").append('<option value="'+val.dessert_id+'">'+val.dessert_name+'</option>');
        });
    });

    $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
       $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });

    numd++;
  });

}

function removeEle(divid,_divid,divbr,divinput,divstrunit,divpic){
  $(divid).remove(); 
  $(_divid).remove();
  $(divbr).remove(); 
  $(divinput).remove(); 
  $(divstrunit).remove();
  $(divpic).remove();
}  

function getdatetime(){
  var currentTime = new Date(),
  hours = currentTime.getHours(),
  minutes = currentTime.getMinutes();

  var currentDate = new Date(),
  day = currentDate.getDate() - 1,
  month = currentDate.getMonth() + 1,
  year = currentDate.getFullYear();

  if (minutes < 10) {
   minutes = "0" + minutes;
  }

  return (day + "-" + month + "-" + year);
}

function submit_booking_room(){

  if($("#booking_loopcheck").is(':checked')){
    if ($("#booking_loopdate").val()=="") {
      $("#booking_loopdate").focus();
      return false;
    }
  }

  if ($("#booking_startdate").val()=="") {
    $("#booking_startdate").focus();
    return false;
  }

  if ($("#booking_enddate").val()=="") {
    $("#booking_enddate").focus();
    return false;
  }

  var currentDate = new Date(),
  day = currentDate.getDate(),
  month = currentDate.getMonth() + 1,
  year = currentDate.getFullYear();
  if (month.toString().length==1){
    month = ("0"+month);
  }

  if ($('#layoutpicid').val()=="") {
    $('#layoutpicid').val(1);
  }

  if ($('#booking_startdate').val().substr(6, 4) < year) {
    swal("กรุณาเลือกปีใหม่", "", "error");
    return false;
  }

  if ($('#booking_startdate').val().substr(6, 4) === year && $('#booking_startdate').val().substr(3, 2) < month) {
    swal("กรุณาเลือกเดือนใหม่", "", "error");
    return false;
  }

  if ($('#booking_startdate').val().substr(3, 2) == month && $('#booking_startdate').val().substr(0, 2) < day) {
    swal("กรุณาเลือกวันใหม่", "", "error");
    return false;
  }

  if ($('#booking_startdate').val().substr(6, 4) > $('#booking_enddate').val().substr(6, 4)) {
    swal("กรุณาเลือกปีเดียวกัน", "", "error");
    return false;
  }

  if ($('#booking_startdate').val().substr(6, 4) === $('#booking_enddate').val().substr(6, 4) && $('#booking_startdate').val().substr(3, 2) > $('#booking_enddate').val().substr(3, 2)) {
    swal("กรุณาเลือกเดือนสิ้นสุดใหม่", "", "error");
    return false;
  }

  if ($('#booking_startdate').val().substr(3, 2) == $('#booking_enddate').val().substr(3, 2) && $('#booking_startdate').val().substr(0, 2) > $('#booking_enddate').val().substr(0, 2)) {
    swal("กรุณาเลือกวันสิ้นสุดใหม่", "", "error");
    return false;
  }

  if ($("input[name=booking_supportchk]:checked").val() == 1 && $('#booking_support').val()== ''){
    swal("กรุณากรอกจำนวนคนรับรอง", "", "error");
    $('#booking_support').focus();
    return false;
  }

  $('#btn_save_booking').text('กำลังบันทึก...');
  $('#btn_save_booking').attr('disabled', true);
  $('#btn_reset_booking').attr('disabled', true);

  $.ajax({
    url : '/booking/create',
    type : 'post',
    cache : false,
    dataType : 'json',
    data : $('form#form_booking').serialize()
  })
  .done(function(data) {
    if (data.status == 404) {

      swal(data.message, "", "error");
      $('#btn_save_booking').text('บันทึก');
      $('#btn_save_booking').attr('disabled', false);
      $('#btn_reset_booking').attr('disabled', false);

    }else if(data.status == 400){

      $('#modal_create').modal('hide');
      swal({
          title: data.message,
          type: "error",
          closeOnConfirm: false,
          showLoaderOnConfirm: true
        }, function () {
          setTimeout(function () {
          window.location = '/mybooking';
        }, 2000);
      });
      $('#btn_save_booking').text('บันทึก');
      $('#btn_save_booking').attr('disabled', false);
      $('#btn_reset_booking').attr('disabled', false);

    }else{

      $('#modal_create').modal('hide');
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
      $('#btn_save_booking').text('บันทึก');
      $('#btn_save_booking').attr('disabled', false);
      $('#btn_reset_booking').attr('disabled', false);

    }
    // console.log(data);
  });
  return false;
}
</script>