<?php 
$this->layout('layouts/main'); 

use App\Room\RoomAPI;

// echo "<pre>".print_r($dataRoom,true)."</pre>";
  if(isset($_GET["txtComp"]) && $_GET["txtRoom"]=='' ){
    $comp     = $_GET["txtComp"];
    $dataRoom = (new RoomAPI)->load_bycomp($comp);
  }else if(isset($_GET["txtRoom"])){
    $room     = $_GET["txtRoom"];
    $dataRoom = (new RoomAPI)->load_byroom($room);
  }else{
    $dataRoom = (new RoomAPI)->load();
  }

?>

<style type="text/css">
  hr{
    color: #FFFFFF;
    background-color: #FFFFFF;
    height: 4px;
  }
  td { 
    padding: 5px;
    text-align: left;
  }
  input[type=checkbox] {
    width: 20px;
    height: 20px;
  }
</style>

<div class="row">
  <div class="col-lg-12">
      <h1>Room</h1>
      <hr>

      <form name="frmSearch" method="get" class="form-search">
        <table>
          <tr>
            <td>ชื่อบริษัท :
              <select name="txtComp" id="txtComp" style="width: 200px; height: 30px;"></select>
            </td>
            <td>
              <div id="room_hide">
              ชื่อห้องประชุม :
              <select name="txtRoom" id="txtRoom" style="width: 200px; height: 30px;">
              </select>
              </div>
            </td>
            <td>
              <button type="submit" class="btn btn-primary"><i class="glyphicon glyphicon-search"></i>ค้นหา</button>
            </td>
          </tr>
        </table> 
      </form>
      <hr>

      <button class="btn btn-primary" data-backdrop="static" data-toggle="modal" data-target="#modal_new" id="btn_new" style="width:190px;" ><i class="glyphicon glyphicon-plus"></i>เพิ่มรายการห้องประชุม</button>
  </div>
</div>

<div class="modal" id="modal_new" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">เพิ่มรายการห้องประชุม</h4>
      </div>
      <div class="modal-body">
        <form id="form_new" onsubmit="return submit_new_room()">
          
            <label>ชื่อห้องประชุม</label>
            <input type="text" name="room_name" id="room_name" class="form-control" autocomplete="off" placeholder="ชื่อห้องประชุม" required>
            <label>บริษัท</label>
            <select name="room_company" id="room_company" class="form-control" required></select>
            <label>ชั้น</label>
            <input type="number" name="room_floor" id="room_floor" class="form-control" autocomplete="off" placeholder="ชั้น" required>
            <label>ที่นั่ง</label>
            <input type="number" name="room_seat" id="room_seat" class="form-control" autocomplete="off" placeholder="ที่นั่ง" required>
            <label>อุปกรณ์</label>
            <br>
            <select name="room_tool[]" id="room_tool" multiple="multiple" style="width:500px"  required>
            <br>
            <input type="file" name="file_pic" id="file_pic" class="well">
            <label>สถานะ</label>
            <input type="checkbox" value='1' name="room_active" id="room_active" checked> เปิดใช้งาน&nbsp;&nbsp;&nbsp;
            <input type="checkbox" value='0' name="room_active" id="room_active"> ปิดใช้งาน
            <br>
            <input type="hidden" name="type" id="type">
            <input type="hidden" name="room_id" id="room_id">
          <label>
            <button class="btn btn-primary">Save</button>
          </label>

        </form>
      </div>
    </div>
  </div>
</div>

<br>

  <table class="table table-bordered">
    <tr>
        <td style="text-align: center; width:50%;" bgcolor="#BEBEBE">
            <b>รูปภาพห้องประชุม</b>
        </td>
        <td style="text-align: center; width:50%;" bgcolor="#BEBEBE">
            <b>ข้อมูลห้องประชุม</b>
        </td>
      </tr>

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
              <td>
                ชื่อห้องประชุม
              </td>
              <td>
                : <?php echo $value['room_name']; ?>
              </td>
            </tr>
            <tr>
              <td>
                บริษัท
              </td>
              <td>
              : <?php echo $value['com_fname']; ?>
              </td>
            </tr>
            <tr>
              <td>
                ชั้น
              </td>
              <td>
              : <?php echo $value['room_floor']; ?>
              </td>
            </tr>
            <tr>
              <td>
                ที่นั่ง
              </td>
              <td>
              : <?php echo $value['room_max_seat']; ?>
              </td>
            </tr>
            <tr>
              <td valign="top">
                อุปกรณ์
              </td>
              <td>
              <?php 
                  $idTool = explode(",",$value['room_tool']);
                    foreach ($idTool as $tool) {
                    $dataTool = (new RoomAPI)->loadtool($tool);
                    if (isset($dataTool[0]['tool_name'])) {
                        echo $dataTool[0]['tool_name']."<br>";
                      }
                    }
                ?>
              </td>
            </tr>
            <tr>
              <td>สถานะ</td>
              <td>
                <?php 
                  if($value['room_active']==1){ 
                    echo "<b><font color='green'>เปิดใช้งาน</font></b>";
                  }else{ 
                    echo "<b><font color='red'>ปิดใช้งาน</font></b>";
                  } 
                ?>
              </td>
            </tr>
          </table>
      <br>              
          <button class="btn btn-primary" style="width:190px;" Onclick="return update('<?php echo $value['room_name']; ?>','<?php echo $value['room_company']; ?>','<?php echo $value['room_floor']; ?>','<?php echo $value['room_max_seat']; ?>','<?php echo $value['room_tool']; ?>','<?php echo $value['room_picture']; ?>','<?php echo $value['room_active']; ?>','<?php echo $value['room_id']; ?>')">
            <i class="glyphicon glyphicon-edit"></i>
            แก้ไขรายการห้องประชุม </button>
      <br><br>                
          <button class="btn btn-primary" style="width:190px;" Onclick="return deleted('<?php echo $value['room_picture']; ?>','<?php echo $value['room_id']; ?>')">
            <i class="glyphicon glyphicon-trash"></i>
            ลบรายการห้องประชุม </button>
      </td>
    </tr>
    <?php
      }
    ?>
  </table>


<script type="text/javascript">
  
  jQuery(document).ready(function($) {
    $('#room_hide').hide();

    $('#room_tool').html("");
		$('#room_tool').multipleSelect();
    
    $('#btn_new').on('click',function(){
      $('#type').val('create');
      $('#form_new').trigger('reset');
    });

    $("input:checkbox").on('click', function() {
      
      var $box = $(this);
      if ($box.is(":checked")) {
        var group = "input:checkbox[name='" + $box.attr("name") + "']";
        $(group).prop("checked", false);
        $box.prop("checked", true);
      }else{
        $box.prop("checked", false);
      }
        // remarkbox($box.attr("name"));
        // console.log($box.attr("name"));

    });

    getPlant()
      .done(function(data) {
        $('select[name=room_company]').html("<option value=''>=Select=</option>");
        $.each(data, function(index, val) {
          $('select[name=room_company]').append('<option value="'+val.com_id+'">'+val.com_nname+
            ' ('+val.com_fname+')'+'</option>');
        });
    });

    getTool()
	    .done(function(data) {
	        $.each(data, function(k, v) {
	            $('#room_tool').append('<option value="'+ v.tool_id+'">'+v.tool_name+'</option>');
	      });
	      $('#room_tool').multipleSelect();
	  });

    getPlant()
      .done(function(data) {
        $('select[name=txtComp]').html("<option value=''>=Select=</option>");
        $.each(data, function(index, val) {
          $('select[name=txtComp]').append('<option value="'+val.com_nname+'">'+val.com_nname+
            ' ('+val.com_fname+')'+'</option>');
        });
    });

    $('#txtComp').on('click', function() {
      $('#room_hide').show();

      getRoom($('#txtComp').val())
        .done(function(data) {
          $('select[name=txtRoom]').html("<option value=''>=Select=</option>");
          $.each(data, function(index, val) {
            $('select[name=txtRoom]').append('<option value="'+val.room_id+'">'+val.room_name+'</option>');
          });
      });

    });

  });

  function submit_new_room(){

    var file_data = $('#file_pic').prop('files')[0];
    var form_data = new FormData();                  
    
    if(!file_data)
    {
      $.ajax({
        url : '/room/create',
        type : 'post',
        cache : false,
        dataType : 'json',
        data : $('form#form_new').serialize()
      })
      .done(function(data) {
        if (data.result == false) {
          swal(data.message, "", "error")
        }else{
          $('#modal_create').modal('hide');
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
        // alert(data);
      });
    }else{
      //console.log($('#room_tool').val());
      form_data.append('room_active', $('#room_active').val());
      form_data.append('room_name', $('#room_name').val());
      form_data.append('room_company', $('#room_company').val());
      form_data.append('room_floor', $('#room_floor').val());
      form_data.append('room_seat', $('#room_seat').val());
      form_data.append('room_tool', $('#room_tool').val());
      form_data.append('type', $('#type').val());
      form_data.append('room_id', $('#room_id').val());
      form_data.append('file', file_data);

      ex = getExtension(file_data["name"]);
      // if(ex != "jpg")
      // {
      //   swal("The picture extension must be .jpg !", "", "warning")
      //   return false;
      // }

      $.ajax({
        url : '/room/create',
        type : 'post',
        cache : false,
        dataType : 'json',
        contentType: false,
        processData: false,
        data : form_data
      })
      .done(function(data) {
        if (data.result == false) {
          swal(data.message, "", "error")
        }else{
          $('#modal_create').modal('hide');

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
        // alert(data);
      });
    }
    return false;
  }

  function getExtension(filename) 
  {
    var parts = filename.split('.');
    return parts[parts.length - 1];
  }

  function update(room_name,room_company,room_floor,room_seat,room_tool,room_picture,room_active,room_id){
    $('#modal_new').modal({backdrop: 'static'});
    $('#form_new').trigger('reset');
    $('.modal-title').text('แก้ไขรายการห้องประชุม');
    $('#room_name').val(room_name);
    $('#room_floor').val(room_floor);
    $('#room_seat').val(room_seat);
    // $('#room_active').val(room_active);
    $('#room_id').val(room_id);
    $('#type').val('update');

    if (room_active==1) {
      // console.log("checked=1");
      $("input[name=room_active][value=1]").prop('checked' , true);
      $("input[name=room_active][value=0]").prop('checked' , false);
    }else{
      // console.log("checked=0");
      $("input[name=room_active][value=0]").prop('checked' , true);
      $("input[name=room_active][value=1]").prop('checked' , false);
    }

    gojax('get', '/room/loadcompany')
      .done(function(data) {
        $('#room_company').html('');
        $.each(data, function(index, val) {
           $('#room_company').append('<option value="'+val.com_id+'">'+val.com_nname+'</option>');
        });
        $('#room_company').val(room_company);
    });

      var setting_actions = room_tool;
      if (!!setting_actions) {
        var tmp_actions = setting_actions.split(',');
      }
      gojax('get', '/room/loadtoolAll')
        .done(function(data) {
          $('#room_tool').html('');
          $.each(data, function(k, v) {
              if ($.inArray(v.tool_id.toString(), tmp_actions) !== -1) {
                $('#room_tool').append('<option value="'+ v.tool_id +'" selected>'+v.tool_name+'</option>');
              } else {
                $('#room_tool').append('<option value="'+ v.tool_id +'">'+v.tool_name+'</option>');
              }              
          });
        $('#room_tool').multipleSelect({placeholder: 'เลือกข้อมูล', filter: true});
      });

  }

  function deleted(room_picture,room_id){
    if (confirm('Are you Delete ?')) {
      
      $.ajax({
        url : '/room/delete',
        type : 'post',
        cache : false,
        dataType : 'json',
        data : {
          room_picture  : room_picture,
          room_id       : room_id
        }
      })
      .done(function(data) {
        if (data.result == false) {
          swal(data.message, "", "error")
        }else{
          $('#modal_create').modal('hide');
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
      });

    }
  }

  function getPlant() {
    return $.ajax({
      url : '/room/loadcompany_byper',
      type : 'get',
      dataType : 'json',
      cache : false
    });
  }

  function getTool() {
    return $.ajax({
      url : '/room/loadtoolAll',
      type : 'get',
      dataType : 'json',
      cache : false
    });
  }

  function getRoom(comp) {
    return $.ajax({
      url : '/room/load?comp='+comp,
      type : 'get',
      dataType : 'json',
      cache : false
    });
  }

</script>