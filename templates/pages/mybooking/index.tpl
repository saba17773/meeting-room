<?php 
$this->layout('layouts/main'); 
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
  img {
      display: left;
  }
</style>

<div id="dialogpic">
  <!-- <div id="foodpic"></div> -->
  <div id="images"></div>
</div>

<div class="modal" id="modal_detail" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">
        <div>
          <img src='../DN2.png' style='padding-top:-5;height:25px; width:auto;'>
          <a id="detail_number"></a>
        </div>
        </h4>
      </div>
      <div class="modal-body">
        <table>
          <tr>
            <td><b>ห้องประชุม</b></td>
            <td>:</td>
            <td><div id="detail_roomname"></div></td>
          </tr>
          <tr>
            <td><b>หัวข้อการประชุม</b></td>
            <td>:</td>
            <td><div id="detail_title"></div></td>
          </tr>
          <tr>
            <td><b>วัน เวลา ที่เริ่ม</b></td>
            <td>:</td>
            <td><div id="detail_start"></div></td>
          </tr>
          <tr>
            <td><b>วัน เวลา ที่สิ้นสุด</b></td>
            <td>:</td>
            <td><div id="detail_end"></div></td>
          </tr>
          <tr>
            <td><b>จำนวนผู้เข้าประชุม</b></td>
            <td>:</td>
            <td><div id="detail_seat"></div></td>
          </tr>
          <tr>
            <td><b>ผู้ใช้งาน</b></td>
            <td>:</td>
            <td><div id="detail_user"></div></td>
          </tr>
          <!-- <tr>
            <td>ผู้จอง</td>
            <td>:</td>
            <td><div id="detail_fullname"></div></td>
          </tr> -->
        </table>
      </div>
    </div>
  </div>
</div>

<div class="modal" id="modal_update" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <form id="form_booking" onsubmit="return submit_booking_room()">
        <table align="center">
          <tr>
            <td>
              <label>ชื่อห้องประชุม</label>
            </td>
            <td>
              <input type="hidden" name="booking_number" id="booking_number">
              <input type="hidden" name="booking_startdate_old" id="booking_startdate_old">
              <input type="hidden" name="booking_enddate_old" id="booking_enddate_old">
              <select class="form-control" name="booking_roomname" id="booking_roomname" required></select>
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
              <label>จากวันที่</label>
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
              <label>ถึงวันที่</label>
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
              <input type="text" name="booking_seat" id="booking_seat" autocomplete="off" required style="width: 70px;" class="form-control allownumberdecimal">
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
              <input type="radio" name="booking_supportchk" id="booking_supportchk1" value="1"> <label>มี</label>
              <input type="radio" name="booking_supportchk" id="booking_supportchk0" value="0"> <label>ไม่มี</label>
            </td>
            <td>
              <div id="support">
                <input type="text" name="booking_support" id="booking_support" class="form-control allownumberdecimal" style="width: 70px;">
              </div>
            </td>
            <td><label id="support_unit">คน</label></td>
          </tr>
          <tr>
            <td>
              <label>อาหาร</label>
            </td>
            <td colspan="2" align="right">
              <input name="food" id="food" type="button" class="btn btn-info" value="+" style="font-size: 1.2em;"><br>
              <div class="well">
                <span id="mySpanfood"></span>
                <span id="mySpanfoodAdd"></span>
              </div>
              <!-- <p id ="link"></p> -->
            </td>
          </tr>
          <tr>
            <td>
              <label>ของว่างและเครื่องดื่ม</label>
            </td>
            <td colspan="2">
              <input name="dessert" id="dessert" type="button" class="btn btn-info" value="+" style="font-size: 1.2em;"><br>
              <div class="well">
                <span id="mySpandessert"></span>
                <span id="mySpandessertAdd"></span>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <label>รูปแบบการจัดห้อง</label>
            </td>
            <td>
              <select class="form-control" name="booking_layout" id="booking_layout" required></select>
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
            <!-- <td colspan="2">
              <div id="layoutpic"></div>
            </td> -->
          </tr>
          <tr>
            <td></td>
            <td colspan="3">
              <label>
                <input type="hidden" name="book_status" id="book_status">
                <input type="hidden" name="click_type" id="click_type">
                <button class="btn btn-lg btn-primary" id="btn_save_booking"><i class="glyphicon glyphicon-floppy-saved"></i> บันทึก</button>
                <button class="btn btn-lg btn-primary" id="btn_send_booking"><i class="glyphicon glyphicon-send"></i> บันทึกและส่งอีเมลล์</button>
              </label>
            </td>
          </tr>
        </table>
        </form>
      </div>
    </div>
  </div>
</div>

<div class="modal" id="modal_cancel" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <div id="grid_mybook_cancel"></div>
        <br>
        <button class="btn btn-primary" id="btn_cancel_check">
          <span class="glyphicon glyphicon-remove"></span> ตกลง
        </button>
      </div>
    </div>
  </div>
</div>

<div class="modal" id="modal_cancel_remark" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">สาเหตุการยกเลิก</h4>
      </div>
      <div class="modal-body">
        <form id="form_booking_cancel_remark" onsubmit="return submit_booking_remark()">
          <textarea rows="2" class="form-control" name="txt_remark" id="txt_remark" required="true"></textarea>
          <input type="hidden" name="remark_id[]" id="remark_id">
          <input type="hidden" name="numbersequence" id="numbersequence">
          <br>
          <button class="btn btn-primary" id="btn_remark" type="submit">
            <span class="glyphicon glyphicon-remove"></span> ตกลง
          </button>
        </form>
      </div>
    </div>
  </div>
</div>

<div class="modal" id="modal_print" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <div id="grid_mybook_print"></div>
        <br>
        <button class="btn btn-primary" id="btn_print_check">
          <span class="glyphicon glyphicon-print"></span> print
        </button>
      </div>
    </div>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
      <h1>รายการจองห้องประชุม</h1>
      <hr>
      <button class="btn btn-lg btn-primary" id="btn_update"><i class="glyphicon glyphicon-edit"></i> แก้ไข</button>
      <button class="btn btn-lg btn-primary" id="btn_cancel"><i class="glyphicon glyphicon-remove"></i> ยกเลิก</button>
      <button class="btn btn-lg btn-primary" id="btn_report"><i class="glyphicon glyphicon-print"></i> ใบสั่งงาน</button>
      <button class="btn btn-lg btn-primary" id="btn_report_room"><i class="glyphicon glyphicon-print"></i> ใบจองห้อง</button>
  </div>
</div>
<br>
<div id="grid_mybook"></div>

<script>
  jQuery(document).ready(function($) {
    $('#dialogpic').hide();
    $('#btn_report').hide();
    $('#btn_report_room').hide();
    $('#loopchk').hide();
    $('#btn_save_booking').hide();
    var user_status = '<?php echo $_SESSION['user_status']; ?>';

    $('#btn_update').hide();

    if (user_status=='A') {
      $('#btn_update').show();
    }else{
      $('#btn_update').show();
    }

    grid_mybook();
    $('#support').hide();
    $('#support_unit').hide();

    $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
        $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });

    $('#grid_mybook').on('rowclick', function (event) {
        var args = event.args;
        var boundIndex = args.rowindex;        
        var datarow = $("#grid_mybook").jqxGrid('getrowdata', boundIndex);      
        var session = '<?php echo $_SESSION['user_status']; ?>'; 
        if (datarow.book_status==4 && session =="A") {
          $('#btn_report').show();
          // $('#btn_report_room').show();
        }else{
          $('#btn_report').hide();
          // $('#btn_report_room').hide();
        }

        if (session =="A") {
          $('#btn_report_room').show();
        }else{
          $('#btn_report_room').hide();
        }
        // console.log(datarow.book_status);
    });    
    
    $('#btn_cancel').on('click', function() {      
      var selectedrowindex = $("#grid_mybook").jqxGrid('getselectedrowindex');
      var rowdata = $("#grid_mybook").jqxGrid('getrowdata', selectedrowindex);

      if (rowdata && rowdata.book_status<5) {

        var currentDate = new Date(),
        day   = currentDate.getDate(),
        month = currentDate.getMonth() + 1,
        year  = currentDate.getFullYear();
        if (month.toString().length==1){
          month = ("0"+month);
        }

        var startd = formatDate(rowdata.book_enddate);

        if (startd.substr(6, 4) < year) {
          alert("ไม่สามารถยกเลิกวันย้อนหลังได้");
          return false;
        }

        if (startd.substr(6, 4) === year && startd.substr(3, 2) < month) {
          alert("ไม่สามารถยกเลิกวันย้อนหลังได้");
          return false;
        }

        if (startd.substr(3, 2) == month && startd.substr(0, 2) < day) {
          alert("ไม่สามารถยกเลิกวันย้อนหลังได้");
          return false;
        }
      
        grid_mybook_cancel(rowdata.book_number);
        $('#numbersequence').val(rowdata.book_number)
        $('#modal_cancel').modal({backdrop: 'static'});
        $('.modal-title').text('เลือกรายการสำหรับ ยกเลิก');
      }

    });

    $("#btn_cancel_check").on('click', function() {
      var rowdata = row_selected("#grid_mybook_cancel");
      var rows_selected = [];
      var row_book = '';
      if (typeof rowdata !== "undefined") {
        var rows = $('#grid_mybook_cancel').jqxGrid('getselectedrowindexes');
        
        for (var i = 0; i < rows.length; i++) {
          row_book = $('#grid_mybook_cancel').jqxGrid('getrowdata', rows[i]);
          if (row_book.book_status!=8) {
            rows_selected.push(row_book.book_id);
          }
        }
        $('#modal_cancel_remark').modal({backdrop: 'static'});
        $('#remark_id').val(rows_selected);

      } else {
        alert("กรุณาเลือกข้อมูล");
      }
    });

    $('#btn_report').on('click', function(){
      var selectedrowindex = $("#grid_mybook").jqxGrid('getselectedrowindex');
      var rowdata = $("#grid_mybook").jqxGrid('getrowdata', selectedrowindex);
        if (!!rowdata && rowdata.book_status==4) {
          window.open('/report?id='+rowdata.book_number,'_blank');
        }
    });

    $('#btn_report_room').on('click', function(){
      var selectedrowindex = $("#grid_mybook").jqxGrid('getselectedrowindex');
      var rowdata = $("#grid_mybook").jqxGrid('getrowdata', selectedrowindex);
        // if (!!rowdata && rowdata.book_status==4) {
        if (!!rowdata) {
          if (formatDate(rowdata.book_startdate)!=formatDate(rowdata.book_enddate)) {
            if (rowdata.book_weekly!=0) {
              grid_mybook_print(rowdata.book_number);
              $('#modal_print').modal({backdrop: 'static'});
              $('.modal-title').text('เลือกรายการสำหรับ print');
            }else{
              window.open('/report_room?id='+rowdata.book_number,'_blank');
            }
          }else{
            window.open('/report_room?id='+rowdata.book_number,'_blank');
          }
        }
    });

    $("#btn_print_check").on('click', function() {
      var rowdata = row_selected("#grid_mybook_print");
      var rows_selected = [];
      var row_book = '';
      if (typeof rowdata !== "undefined") {
        var rows = $('#grid_mybook_print').jqxGrid('getselectedrowindexes');
        
        for (var i = 0; i < rows.length; i++) {
          row_book = $('#grid_mybook_print').jqxGrid('getrowdata', rows[i]);
          if (row_book.book_status!=8) {
            rows_selected.push(row_book.book_id);
          }
        }
        // console.log(rows_selected);
        // window.open('/report_room?id='+rowdata.book_number,'_blank');
        window.open('/report_room?id='+rowdata.book_number+'&recid='+rows_selected, '_blank');

      } else {
        alert("กรุณาเลือกข้อมูล");
      }
    });

    $('#btn_update').on('click', function() {      
      var selectedrowindex = $("#grid_mybook").jqxGrid('getselectedrowindex');
      var rowdata = $("#grid_mybook").jqxGrid('getrowdata', selectedrowindex);

      // if (rowdata && rowdata.book_status<5) {
      //   }else{
      //   alert("รายการนี้ไม่สามารถแก้ไขได้");
      // }
      if (rowdata && rowdata.book_status!=8) {
        if (rowdata.book_status === 1 || rowdata.book_status === 5 || rowdata.book_status === 6 || rowdata.book_status === 7 || user_status==='A') {

          $('#modal_update').modal({backdrop: 'static'});
          $('#form_booking').trigger('reset');
          $('#book_status').val(rowdata.book_status);

          if (rowdata.book_weekly != 0) {
            $("#booking_loopcheck").attr('checked', 'true');
            $('#loopchk').show();
          }

          $("#booking_loopcheck").on('change', function() {
            if ($(this).is(':checked')) {
              $(this).attr('value', 'true');
              $('#loopchk').show();
            } else {
              $(this).attr('value', 'false'); 
              $('#loopchk').hide();
            }
          });

          $('.modal-title').text('แก้ไขการจองห้องประชุม รายการที่ '+rowdata.book_number);

          $('#booking_startdate').datepicker({
            dateFormat: 'dd-mm-yy',
            onSelect: function(dateText){
                  $('#booking_enddate').val($('#booking_startdate').val());
              }
          });
          $('#date_booking_start_show').click(function() {
            $('#booking_startdate').datepicker('show');
          });

          $('#booking_enddate').datepicker({ dateFormat: 'dd-mm-yy' });
          $('#date_booking_end_show').click(function() {
            $('#booking_enddate').datepicker('show');
          });

          var startd = formatDate(rowdata.book_startdate);
          var edate = formatDate(rowdata.book_enddate);
         
          $('#booking_startdate').val(startd);
          $('#booking_enddate').val(edate);
          $('#booking_startdate_old').val(startd);
          $('#booking_enddate_old').val(edate);
          $('#booking_name').val(rowdata.book_title);
          $('#booking_user').val(rowdata.book_user);
          $('#booking_seat').val(rowdata.book_seat);
          $('#booking_remark').val(rowdata.book_remark);
          $('#booking_number').val(rowdata.book_number);

          gojax('get', '/room/loadAll')
            .done(function(data) {
            $('#booking_roomname').html('');
            $.each(data, function(index, val) {
               $('#booking_roomname').append('<option value="'+val.room_id+'">'+val.room_name+'</option>');
            });
            $('#booking_roomname').val(rowdata.book_room);
          });

          gojax('get', '/book/weekly')
            .done(function(data) {
            $('#booking_loopdate').html('');
            $.each(data, function(index, val) {
               $('#booking_loopdate').append('<option value="'+val.weekly_id+'">'+val.weekly_name+'</option>');
            });
            $('#booking_loopdate').val(rowdata.book_weekly);
          });

          gojax('get', '/book/timein')
            .done(function(data) {
            $('#booking_starttime').html('');
            $.each(data, function(index, val) {
               $('#booking_starttime').append('<option value="'+val.timein+'">'+val.timein+'</option>');
            });
            $('#booking_starttime').val(rowdata.book_starttime);
          });

          gojax('get', '/book/timeout')
            .done(function(data) {
            $('#booking_endtime').html('');
            $.each(data, function(index, val) {
               $('#booking_endtime').append('<option value="'+val.timeout+'">'+val.timeout+'</option>');
            });
            $('#booking_endtime').val(rowdata.book_endtime);
          });

          gojax('get', '/load/support?numbersequence='+rowdata.book_number)
            .done(function(data){
              $('#booking_support').html('');
              if (data!='') {
                $.each(data, function( k, v ) {
                  // console.log(v.support_id);
                  $("#support").show();
                  $('#support_unit').show();
                  $("#booking_supportchk1").prop('checked' , true);
                  $("#booking_support").val(v.support_id);
                });
              }else{
                  $("#booking_supportchk0").prop('checked' , true);
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

          gojax('get', '/load/layout?numbersequence='+rowdata.book_number)
            .done(function(data){
            $('#booking_layout').html('');
            
            $.each(data, function( k, v ) {
              gojax('get', '/layout/load')
                .done(function(data) {
                $("#booking_layout").html('');
                $.each(data, function(index, val) {
                   $("#booking_layout").append('<option value="'+val.layout_id+'">'+val.layout_name+'</option>');
                });
                $("#booking_layout").val(v.layout_id);
              });
            });

          });

          // Food
          gojax('get', '/load/food?numbersequence='+rowdata.book_number)
            .done(function(data){
                $('#mySpanfood').html('');
                var num =1;
                $.each(data, function( k, v ) {

                var add ="add"+num;
                var select_ ="select_"+num;
                var input_  ="input_"+num;
                var br1 = "br1"+num;
                var strunit = "strunit_"+num; 

                $('#mySpanfood').append("<button id='"+add+"' onclick=deleteFood\('"+v.food_id+"','"+v.booking_id+"','1',"+add+','+select_+','+input_+','+br1+','+strunit+ ") type='button' class='btn btn-info'>-</button><select name='food[]' id='"+select_+"' required></select> <input type='text' name='food_unit[]' id='"+input_+"' value="+v.food_unit+" style='width: 50px' required class='allownumberdecimal'> <label id='"+strunit+"'>หน่วย</label><button id='"+add+"' type='button' class='btn btn-info' onclick='showpicfood("+select_+");'><span class='glyphicon glyphicon-search' style='font-size:15px;'></span></button><br id='"+br1+"'>");

                  gojax('get', '/food/load')
                    .done(function(data) {
                    $("#"+select_+"").html('');
                    $.each(data, function(index, val) {
                       $("#"+select_+"").append('<option value="'+val.food_id+'">'+val.food_name+'</option>');
                    });
                    $("#"+select_+"").val(v.food_id);
                  });

                  $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
                     $(this).val($(this).val().replace(/[^\d].+/, ""));
                      if ((event.which < 48 || event.which > 57)) {
                          event.preventDefault();
                      }
                  });

                num++;
            });

          });

          // Dessert
          gojax('get', '/load/dessert?numbersequence='+rowdata.book_number)
            .done(function(data){
                $('#mySpandessert').html('');
                var numd =1;
                $.each(data, function( k, v ) {

                var addd ="addd"+numd;
                var selectd_ ="selectd_"+numd;
                var inputd_  ="inputd_"+numd;
                var brd1 = "brd1"+numd;
                var strunitd = "strunitd_"+numd; 

                $('#mySpandessert').append("<button id='"+addd+"' onclick=deleteFood\('"+v.food_id+"','"+v.booking_id+"','2',"+addd+','+selectd_+','+inputd_+','+brd1+','+strunitd+ ") type='button' class='btn btn-info'>-</button><select name='dessert[]' id='"+selectd_+"' required></select> <input type='text' name='dessert_unit[]' id='"+inputd_+"' value="+v.food_unit+" style='width: 50px' required class='allownumberdecimal'> <label id='"+strunitd+"'>หน่วย</label><button id='"+addd+"' type='button' class='btn btn-info' onclick='showpicdessert("+selectd_+");'><span class='glyphicon glyphicon-search' style='font-size:15px;'></span></button><br id='"+brd1+"'>");

                  gojax('get', '/dessert/load')
                    .done(function(data) {
                    $("#"+selectd_+"").html('');
                    $.each(data, function(index, val) {
                       $("#"+selectd_+"").append('<option value="'+val.dessert_id+'">'+val.dessert_name+'</option>');
                    });
                    $("#"+selectd_+"").val(v.food_id);
                  });

                  $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
                     $(this).val($(this).val().replace(/[^\d].+/, ""));
                      if ((event.which < 48 || event.which > 57)) {
                          event.preventDefault();
                      }
                  });

                numd++;
            });

          });
          // FoodAdd
          var i =1;
          $('#food').bind('click',function(){

            var plus ="plus"+i;
            var selected ="selected"+i;
            var inputed  ="inputed"+i;
            var br = "br"+i;
            var united = "united"+i; 

            $('#mySpanfoodAdd').append("<button id='"+plus+"' onclick='removeEle("+plus+','+selected+','+br+','+inputed+','+united+ ")' type='button' class='btn btn-info'>-</button><select name='food[]' id='"+selected+"' required></select> <input type='text' name='food_unit[]' id='"+inputed+"' style='width: 50px' required class='allownumberdecimal'> <label id='"+united+"'>หน่วย</label><button id='"+plus+"' type='button' class='btn btn-info' onclick='showpicfood("+selected+");'><span class='glyphicon glyphicon-search' style='font-size:15px;'></span></button><br id='"+br+"'>");
            getFood()
            .done(function(data) {
                $("#"+selected+"").html("<option value=''>=Select=</option>");
                $.each(data, function(indax, val) {
                  $("#"+selected+"").append('<option value="'+val.food_id+'">'+val.food_name+'</option>');
                });
            });

            $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
               $(this).val($(this).val().replace(/[^\d].+/, ""));
                if ((event.which < 48 || event.which > 57)) {
                    event.preventDefault();
                }
            });

            i++;
          });
          // DessertAdd
          var d =1;
          $('#dessert').bind('click',function(){
          
            var plus_d ="plus_d"+d;
            var selected_d ="selected_d"+d;
            var inputed_d  ="inputed_d"+d;
            var br_d = "br_d"+d;
            var united_d = "united_d"+d; 

            $('#mySpandessertAdd').append("<button id='"+plus_d+"' onclick='removeEle("+plus_d+','+selected_d+','+br_d+','+inputed_d+','+united_d+ ")' type='button' class='btn btn-info'>-</button><select name='dessert[]' id='"+selected_d+"' required></select> <input type='text' name='dessert_unit[]' id='"+inputed_d+"' style='width: 50px' required class='allownumberdecimal'> <label id='"+united_d+"'>หน่วย</label><button id='"+plus_d+"' type='button' class='btn btn-info' onclick='showpicdessert("+selected_d+");'><span class='glyphicon glyphicon-search' style='font-size:15px;'></span></button><br id='"+br_d+"'>");
            getDessert()
            .done(function(data) {
                $("#"+selected_d+"").html("<option value=''>=Select=</option>");
                $.each(data, function(indax, val) {
                  $("#"+selected_d+"").append('<option value="'+val.dessert_id+'">'+val.dessert_name+'</option>');
                });
            });

            $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
               $(this).val($(this).val().replace(/[^\d].+/, ""));
                if ((event.which < 48 || event.which > 57)) {
                    event.preventDefault();
                }
            });

            d++;
          });

        }
      }


    });
    
    $('#btn_save_booking').on('click', function() {
      $('#click_type').val("saved");

    });

    $('#btn_send_booking').on('click', function() {
      $('#click_type').val("send");
    });

    $("#booking_layout").change(function(){
      var viewlayout = $("#booking_layout option:selected").val();
      
      if (!!viewlayout) {
        $.ajax({
          url : '/layout/load/picture',
          type : 'get',
          cache : false,
          dataType : 'json',
          data : {
            idlayout  : viewlayout
          }
        }).done(function(data) {
            // console.log(data.message);
            var src = "/picturemaster/layout/"+data.message;
            show_imageLayout(src);
        });
      }

    });

    $('#modal_update').on('hidden.bs.modal', function () {
      location.reload();
    });

  });
  
  function submit_booking_remark(){
    // alert($('form#form_booking_cancel_remark').serialize());
      if ($('#remark_id').val()=="") {
        alert("ไม่มีรายการที่ยกเลิกได้");
        return false;
      }

      if (confirm('Are you sure?')) {
        $.ajax({
          url : '/booking/cancel_id',
          type : 'post',
          cache : false,
          dataType : 'json',
          data : $('form#form_booking_cancel_remark').serialize()
        })
        .done(function(data) {
          if (data.status == 404) {
            swal(data.message, "", "error");
          }else{
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
          // console.log(data.message);
        });
        return false;
      }

    return false;
  }

  function showpicfood(data){
    var id = data.id;
    var idfood = $("#"+id+"").val();
    // console.log(idfood);
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
      $("#dialogpic").dialog({width: "600px"});
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
          // var src = "/picturemaster/dessert/"+data.message;
          // var img = document.createElement("img");
          // img.src = src;
          // img.width = 300;
          // img.height = 200;
          // $('#foodpic').html( document.body.appendChild(img));
          
          $("#dialogpic").dialog({width: "600px"});

          p=[
            'hhhh11.png',
            '0813higashi2.jpg'
          ];

          for (var i = 0; i <= p.length-1; i++) {
              var parent    = document.getElementById('images'),
              imagePath = "/picturemaster/dessert/"+p[i],
              img;
              img = new Image();
              img.src = imagePath;
              img.width = 200;
              img.height = 150;
              parent.appendChild(img);
          }

      });
    }
    return false;
  }

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

  function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [day, month, year].join('-');
  }

  function formatDate_(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [day, month, year].join('/');
  }

  function grid_mybook() {
    
    var dataAdapter = new $.jqx.dataAdapter({
    datatype: "json",
    filter : function (data) {
      $('#grid_mybook').jqxGrid('updatebounddata', 'filter');
    },
    datafields: [
              { name: "book_number", type: "string" },
              { name: "book_room", type: "int" },
              { name: "room_name", type: "string"},
              { name: "book_name", type: "string"},
              { name: "book_title", type: "string"},
              { name: "book_startdate", type: "date"},
              { name: "book_enddate", type: "date"},
              { name: "book_starttime", type: "string"},
              { name: "book_endtime", type: "string"},
              { name: "timeout_name", type: "string"},
              { name: "book_user", type: "string"},
              { name: "book_seat", type: "string"},
              { name: "book_support", type: "int"},
              { name: "book_food", type: "string"},
              { name: "book_status", type: "int"},
              { name: "book_statusname", type: "string"},
              { name: "book_remark", type: "string"},
              { name: "book_weekly", type: "string"},
              { name: "fullname", type: "string"},
              { name: "com_fname", type: "string"}
    ],
      url : '/mybooking/load'
    });

    var setDetail = function (row, column, value) {
      if (value !== "") {
        return "<div style='padding:4px;'>" + value + "</div>";
      } else {
        return "<div style='font-size: 0.9em; padding:1px 1px 3px 5px;'><button class='btn btn-sm btn-primary' onclick='return setDetailModal("+row+")'><i class='glyphicon glyphicon-comment'></i></button></div>";
      }
      
    }

    return $("#grid_mybook").jqxGrid({
        width: '100%',
        pageSize :'15',
        source: dataAdapter,
        autoheight: true,
        columnsresize: true,
        pageable: true,
        filterable: true,
        showfilterrow: true,
        editable : false,
        theme: 'deestone',
      columns: [
          { text:"รายการ", datafield: "book_number",width:'8%'},
          { text:"ห้องประชุม", datafield: "room_name",width:'12%', filtertype: 'checkedlist'},
          { text:"หัวข้อการประชุม", datafield: "book_title"},
          { text:"จากวันที่", datafield: "book_startdate",filtertype: 'range', cellsformat: 'yyyy-MM-dd' ,width:'10%'},
          { text:"จากเวลา", datafield: "book_starttime", width:'6%'},
          { text:"ถึงวันที่", datafield: "book_enddate",filtertype: 'range', cellsformat: 'yyyy-MM-dd' ,width:'10%'},
          { text:"ถึงเวลา", datafield: "timeout_name", width:'6%'},
          { text:"ผู้จอง", datafield: "fullname",width:'12%'},
          { text:"สถานะ", datafield: "book_statusname",width:'18%',filtertype: 'checkedlist', filteritems: ['รอผู้จัดการอนุมัติ','รอผู้ดูแลอนุมัติ','รอผู้จัดการแผนกบุคคลอนุมัติ','จองเรียบร้อย','ผู้จัดการไม่อนุมัติ','ผู้ดูแลไม่อนุมัติ','ผู้จัดการแผนกบุคคลไม่อนุมัติ','ยกเลิก'], 
                  cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
                      var status;
                         if (value =="รอผู้จัดการอนุมัติ") {
                             status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้จัดการอนุมัติ</b> </div>";
                         }else if(value =="รอผู้ดูแลอนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้ดูแลอนุมัติ</b> </div>";
                         }else if(value =="รอผู้จัดการแผนกบุคคลอนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้จัดการแผนกบุคคลอนุมัติ</b> </div>";
                         }else if(value =="จองเรียบร้อย"){
                              status =  "<div style='padding: 5px; background:#32CD32 ; color:#000000; font-size:15px;'> <b>จองเรียบร้อย</b> </div>";
                         }else if(value =="ผู้จัดการไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้จัดการไม่อนุมัติ</b> </div>";
                         }else if(value =="ผู้ดูแลไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้ดูแลไม่อนุมัติ</b> </div>";
                         }else if(value =="ผู้จัดการแผนกบุคคลไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้จัดการแผนกบุคคลไม่อนุมัติ</b> </div>";
                         }else if(value =="ยกเลิก"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ยกเลิก</b> </div>";
                         }

                         return status;
                  }
          },
          { text:"ใบจอง",  cellsrenderer : setDetail, editable:false,width:'4%'}
      ]
    });
  }

  function setDetailModal(row) {
      var selectedrowindex = $("#grid_mybook").jqxGrid('getselectedrowindex');
      var datarow = $("#grid_mybook").jqxGrid('getrowdata', row);
      console.log(datarow.book_number);
      $('#modal_detail').modal({backdrop: 'static'});
      $('#detail_number').text('รายการจองที่ : '+datarow.book_number);
      $('#detail_roomname').text(datarow.room_name+' ('+datarow.com_fname+')');
      $('#detail_title').text(datarow.book_title);
      $('#detail_start').text(formatDate_(datarow.book_startdate) +' '+ datarow.book_starttime);
      $('#detail_end').text(formatDate_(datarow.book_enddate) +' '+ datarow.timeout_name);
      $('#detail_fullname').text(datarow.fullname);
      $('#detail_seat').text(datarow.book_seat+ ' คน');
      $('#detail_user').text(datarow.book_user);
  }

  function grid_mybook_cancel(book_number) {
    
    var dataAdapter = new $.jqx.dataAdapter({
    datatype: "json",
    datafields: [
              { name: "book_id", type: "int" },
              { name: "book_number", type: "string" },
              { name: "book_room", type: "int" },
              { name: "room_name", type: "string"},
              { name: "book_name", type: "string"},
              { name: "book_title", type: "string"},
              { name: "book_startdate", type: "date"},
              { name: "book_enddate", type: "date"},
              { name: "book_starttime", type: "string"},
              { name: "book_endtime", type: "string"},
              { name: "book_user", type: "string"},
              { name: "book_seat", type: "string"},
              { name: "book_support", type: "int"},
              { name: "book_food", type: "string"},
              { name: "book_status", type: "int"},
              { name: "book_remark", type: "string"},
              { name: "status_description", type: "string"}
    ],
      url : '/mybooking/loadcancel?book_number='+book_number
    });

    return $("#grid_mybook_cancel").jqxGrid({
        width: '100%',
        source: dataAdapter,
        autoheight: true,
        pageSize : 10,
        altrows : true,
        pageable : true,
        sortable: true,
        filterable : true,
        showfilterrow : true,
        columnsresize: true,
        selectionmode: 'checkbox',
        theme: 'deestone',
      columns: [
          { text:"รายการ", datafield: "book_number",width:'10%'},
          { text:"ห้องประชุม", datafield: "room_name",width:'15%', filtertype: 'checkedlist'},
          { text:"หัวข้อการประชุม", datafield: "book_title"},
          { text:"จากวันที่", datafield: "book_startdate",filtertype: 'range', cellsformat: 'dd-MM-yyyy' ,width:'10%'},
          { text:"จากเวลา", datafield: "book_starttime", width:'10%'},
          { text:"ถึงวันที่", datafield: "book_enddate",filtertype: 'range', cellsformat: 'dd-MM-yyyy' ,width:'10%'},
          { text:"ถึงเวลา", datafield: "book_endtime", width:'10%'},
          { text:"สถานะ", datafield: "status_description",width:'20%',
                  cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
                      var status;
                         if (value =="รอผู้จัดการอนุมัติ") {
                             status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้จัดการอนุมัติ</b> </div>";
                         }else if(value =="รอผู้ดูแลอนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้ดูแลอนุมัติ</b> </div>";
                         }else if(value =="รอผู้จัดการแผนกบุคคลอนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้จัดการแผนกบุคคลอนุมัติ</b> </div>";
                         }else if(value =="จองเรียบร้อย"){
                              status =  "<div style='padding: 5px; background:#32CD32 ; color:#000000; font-size:15px;'> <b>จองเรียบร้อย</b> </div>";
                         }else if(value =="ผู้จัดการไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้จัดการไม่อนุมัติ</b> </div>";
                         }else if(value =="ผู้ดูแลไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้ดูแลไม่อนุมัติ</b> </div>";
                         }else if(value =="ผู้จัดการแผนกบุคคลไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้จัดการแผนกบุคคลไม่อนุมัติ</b> </div>";
                         }else if(value =="ยกเลิก"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ยกเลิก</b> </div>";
                         }

                         return status;
                  }
          }
      ]
    });
  }

  function grid_mybook_print(book_number) {
    
    var dataAdapter = new $.jqx.dataAdapter({
    datatype: "json",
    datafields: [
              { name: "book_id", type: "int" },
              { name: "book_number", type: "string" },
              { name: "book_room", type: "int" },
              { name: "room_name", type: "string"},
              { name: "book_name", type: "string"},
              { name: "book_title", type: "string"},
              { name: "book_startdate", type: "date"},
              { name: "book_enddate", type: "date"},
              { name: "book_starttime", type: "string"},
              { name: "book_endtime", type: "string"},
              { name: "book_user", type: "string"},
              { name: "book_seat", type: "string"},
              { name: "book_support", type: "int"},
              { name: "book_food", type: "string"},
              { name: "book_status", type: "int"},
              { name: "book_remark", type: "string"},
              { name: "status_description", type: "string"}
    ],
      url : '/mybooking/loadcancel?book_number='+book_number
    });

    return $("#grid_mybook_print").jqxGrid({
        width: '100%',
        source: dataAdapter,
        autoheight: true,
        pageSize : 10,
        altrows : true,
        pageable : true,
        sortable: true,
        filterable : true,
        showfilterrow : true,
        columnsresize: true,
        selectionmode: 'checkbox',
        theme: 'deestone',
      columns: [
          { text:"รายการ", datafield: "book_number",width:'10%'},
          { text:"ห้องประชุม", datafield: "room_name",width:'15%', filtertype: 'checkedlist'},
          { text:"หัวข้อการประชุม", datafield: "book_title"},
          { text:"จากวันที่", datafield: "book_startdate",filtertype: 'range', cellsformat: 'dd-MM-yyyy' ,width:'10%'},
          { text:"จากเวลา", datafield: "book_starttime", width:'10%'},
          { text:"ถึงวันที่", datafield: "book_enddate",filtertype: 'range', cellsformat: 'dd-MM-yyyy' ,width:'10%'},
          { text:"ถึงเวลา", datafield: "book_endtime", width:'10%'},
          { text:"สถานะ", datafield: "status_description",width:'20%',
                  cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
                      var status;
                         if (value =="รอผู้จัดการอนุมัติ") {
                             status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้จัดการอนุมัติ</b> </div>";
                         }else if(value =="รอผู้ดูแลอนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้ดูแลอนุมัติ</b> </div>";
                         }else if(value =="รอผู้จัดการแผนกบุคคลอนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FFFF33 ; color:#000000; font-size:15px;'> <b>รอผู้จัดการแผนกบุคคลอนุมัติ</b> </div>";
                         }else if(value =="จองเรียบร้อย"){
                              status =  "<div style='padding: 5px; background:#32CD32 ; color:#000000; font-size:15px;'> <b>จองเรียบร้อย</b> </div>";
                         }else if(value =="ผู้จัดการไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้จัดการไม่อนุมัติ</b> </div>";
                         }else if(value =="ผู้ดูแลไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้ดูแลไม่อนุมัติ</b> </div>";
                         }else if(value =="ผู้จัดการแผนกบุคคลไม่อนุมัติ"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ผู้จัดการแผนกบุคคลไม่อนุมัติ</b> </div>";
                         }else if(value =="ยกเลิก"){
                              status =  "<div style='padding: 5px; background:#FF0000 ; color:#000000; font-size:15px;'> <b>ยกเลิก</b> </div>";
                         }

                         return status;
                  }
          }
      ]
    });
  }

  function getRoom() {
    return $.ajax({
      url : '/room/loadAll',
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

  function submit_booking_room(){
    if ($('#book_status').val()>=5) {  
      alert("รายการนี้ไม่สามารถแก้ไขได้");
      return false;
    }

    if($("#booking_loopcheck").is(':checked')){
      if ($("#booking_loopdate").val()=="") {
        $("#booking_loopdate").focus();
        return false;
      }
    }
    // if ($('#booking_startdate').val() > $('#booking_enddate').val()) {
    //   swal("กรุณาเลือกวันสิ้นสุดใหม่", "", "error");
    //   $('#booking_enddate').focus();
    //   return false;
    // }
    var currentDate = new Date(),
    day = currentDate.getDate(),
    month = currentDate.getMonth() + 1,
    year = currentDate.getFullYear();
    if (month.toString().length==1){
      month = ("0"+month);
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
    
    if ($('#booking_starttime').val() > $('#booking_endtime').val()) {
      swal("กรุณาเลือกเวลาสิ้นสุดใหม่", "", "error");
      $('#booking_endtime').focus();
      return false;
    }  

    if ($('#click_type').val()=='saved') {
      $('#btn_save_booking').text('กำลังดำเนินการ...');
      $('#btn_save_booking').attr('disabled', true);
    }
    if ($('#click_type').val()=='send') {
      $('#btn_send_booking').text('กำลังดำเนินการ...');
      $('#btn_send_booking').attr('disabled', true);
    }

    $.ajax({
      url : '/booking/update',
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
        $('#btn_send_booking').text('บันทึกและส่งอีเมลล์');
        $('#btn_send_booking').attr('disabled', false);

      }else{
        
        // swal(data.message, " ", "success");
        $('#btn_save_booking').text('บันทึก');
        $('#btn_save_booking').attr('disabled', false);
        $('#btn_send_booking').text('บันทึกและส่งอีเมลล์');
        $('#btn_send_booking').attr('disabled', false);
        $('#grid_mybook').jqxGrid('updatebounddata');
        // $('#modal_update').modal('hide');
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

  function show_imageLayout(src, width, height, alt) {
    var img = document.createElement("img");
    img.src = src;
    img.width = 280;
    img.height = 200;
    img.alt = alt;
    $('#layoutpic').html( document.body.appendChild(img));
  }
</script>