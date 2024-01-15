<?php 
$this->layout('layouts/main'); 

use App\Layout\LayoutAPI;


$dataLayout = (new LayoutAPI)->load();
// echo "<pre>".print_r($dataLayout,true)."</pre>";
?>

<div class="row">
  <div class="col-lg-12">
      <h1>รูปแบบห้อง</h1>
      <hr>
      <button class="btn btn-primary" data-backdrop="static" data-toggle="modal" data-target="#modal_new" id="btn_new" style="width:190px;" ><i class="glyphicon glyphicon-plus"></i>เพิ่มรูปแบบห้อง</button>
  </div>
</div>

<div class="modal" id="modal_new" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">เพิ่มรูปแบบห้อง</h4>
      </div>
      <div class="modal-body">
        <form id="form_new" onsubmit="return submit_new_layout()">
          
            <label>ชื่อรูปแบบห้อง</label>
            <input type="text" name="layout_name" id="layout_name" class="form-control" autocomplete="off" placeholder="ชื่อรูปแบบห้อง" required>
            <br>
            <input type="file" name="file_pic" id="file_pic" class="well">
            <br>
            <input type="hidden" name="type" id="type">
            <input type="hidden" name="layout_id" id="layout_id">
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
        <td style="text-align: center; width:50%;">
            <b>Picture</b>
        </td>
        <td style="text-align: center; width:50%;">
            <b>Description</b>
        </td>
      </tr>

      <?php 
        foreach ($dataLayout as $value) {
      ?>
    <tr>
      <td style="text-align: center;">
          <img src="./picturemaster/layout/<?php echo $value['layout_picture'];?>" style="width:400px;height:250px;"> 
      </td>
      <td>
          <h3>
          ชื่อรูปแบบห้อง : <?php echo $value['layout_name']; ?><br>
          </h3>
      <br><br>                
          <button class="btn btn-primary" style="width:190px;" Onclick="return update('<?php echo $value['layout_name']; ?>','<?php echo $value['layout_picture']; ?>','<?php echo $value['layout_id']; ?>')"><i class="glyphicon glyphicon-edit"></i>
            แก้ไขรูปแบบห้อง </button>
      <br><br>                
          <button class="btn btn-primary" style="width:190px;" Onclick="return deleted('<?php echo $value['layout_picture']; ?>','<?php echo $value['layout_id']; ?>')"><i class="glyphicon glyphicon-trash"></i>
            ลบรูปแบบห้อง </button>
      </td>
    </tr>
    <?php
      }
    ?>
  </table>


<script type="text/javascript">
  
  $('#btn_new').on('click',function(){
    $('#type').val('create');
  });

  function submit_new_layout(){

    var file_data = $('#file_pic').prop('files')[0];
    var form_data = new FormData();                  
    form_data.append('file', file_data);

    if(!file_data)
    {
      $.ajax({
        url : '/layout/create',
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
      });
    }else{
      form_data.append('layout_name', $('#layout_name').val());
      form_data.append('type', $('#type').val());
      form_data.append('layout_id', $('#layout_id').val());

      ex = getExtension(file_data["name"]);
      if(ex != "jpg")
      {
        swal("The picture extension must be .jpg !", "", "warning")
        return false;
      }

      $.ajax({
        url : '/layout/create',
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
      });
    }
    return false;
  }

  function getExtension(filename) 
  {
    var parts = filename.split('.');
    return parts[parts.length - 1];
  }

  function update(layout_name,layout_picture,layout_id){
    $('#modal_new').modal({backdrop: 'static'});
    $('#form_new').trigger('reset');
    $('.modal-title').text('แก้ไขรูปแบบห้อง');
    $('#layout_name').val(layout_name);
    $('#layout_id').val(layout_id);
    $('#type').val('update');
  }

  function deleted(layout_picture,layout_id){
    // console.log(food_picture+food_id);
    if (confirm('Are you Delete ?')) {
      
      $.ajax({
        url : '/layout/delete',
        type : 'post',
        cache : false,
        dataType : 'json',
        data : {
          layout_picture  : layout_picture,
          layout_id       : layout_id
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
</script>