<?php 
$this->layout('layouts/main'); 

use App\Dessert\DessertAPI;


$dataDessert = (new DessertAPI)->load();

?>

<div class="row">
  <div class="col-lg-12">
      <h1>รายการของว่างและเครื่องดื่ม</h1>
      <hr>
      <button class="btn btn-primary" data-backdrop="static" data-toggle="modal" data-target="#modal_new" id="btn_new" style="width:230;" ><i class="glyphicon glyphicon-plus"></i>เพิ่มรายการของว่างและเครื่องดื่ม</button>
  </div>
</div>

<div class="modal" id="modal_new" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">เพิ่มรายการของว่างและเครื่องดื่ม</h4>
      </div>
      <div class="modal-body">
        <form id="form_new" onsubmit="return submit_new_dessert()">
          
            <label>ชื่อรายการของว่างและเครื่องดื่ม</label>
            <input type="text" name="dessert_name" id="dessert_name" class="form-control" autocomplete="off" placeholder="ชื่อรายการของว่าง" required>
            <label>ราคาของว่างและเครื่องดื่ม</label>
            <input type="number" name="dessert_price" id="dessert_price" class="form-control" autocomplete="off" placeholder="ราคาของว่าง" required>
            <br>
            <input type="file" name="file_pic" id="file_pic" class="well">
            <br>
            <input type="hidden" name="type" id="type">
            <input type="hidden" name="dessert_id" id="dessert_id">
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
        foreach ($dataDessert as $value) {
      ?>
    <tr>
      <td style="text-align: center;">
          <img src="./picturemaster/dessert/<?php echo $value['dessert_picture'];?>" style="width:400px;height:250px;"> 
      </td>
      <td>
          <h3>
          ชื่อรายการ : <?php echo $value['dessert_name']; ?><br>
          ราคา : <?php echo $value['dessert_price']; ?> บาท<br>
          </h3>
      <br><br>                
          <button class="btn btn-primary" style="width:230px;" Onclick="return update('<?php echo $value['dessert_name']; ?>','<?php echo $value['dessert_price']; ?>','<?php echo $value['dessert_picture']; ?>','<?php echo $value['dessert_id']; ?>')"><i class="glyphicon glyphicon-edit"></i>
            แก้ไขรายการของว่างและเครื่องดื่ม </button>
      <br><br>                
          <button class="btn btn-primary" style="width:230px;" Onclick="return deleted('<?php echo $value['dessert_picture']; ?>','<?php echo $value['dessert_id']; ?>')"><i class="glyphicon glyphicon-trash"></i>
            ลบรายการของว่างและเครื่องดื่ม </button>
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

  function submit_new_dessert(){

    var file_data = $('#file_pic').prop('files')[0];
    var form_data = new FormData();                  
    form_data.append('file', file_data);

    if(!file_data)
    {
      $.ajax({
        url : '/dessert/create',
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
      form_data.append('dessert_name', $('#dessert_name').val());
      form_data.append('dessert_price', $('#dessert_price').val());
      form_data.append('type', $('#type').val());
      form_data.append('dessert_id', $('#dessert_id').val());

      ex = getExtension(file_data["name"]);
      // if(ex != "jpg")
      // {
      //   swal("The picture extension must be .jpg !", "", "warning")
      //   return false;
      // }

      $.ajax({
        url : '/dessert/create',
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

  function update(dessert_name,dessert_price,dessert_picture,dessert_id){
    $('#modal_new').modal({backdrop: 'static'});
    $('#form_new').trigger('reset');
    $('.modal-title').text('แก้ไขรายการของว่างและเครื่องดื่ม');
    $('#dessert_name').val(dessert_name);
    $('#dessert_price').val(dessert_price);
    $('#dessert_id').val(dessert_id);
    $('#type').val('update');
  }

  function deleted(dessert_picture,dessert_id){

    if (confirm('Are you Delete ?')) {
      
      $.ajax({
        url : '/dessert/delete',
        type : 'post',
        cache : false,
        dataType : 'json',
        data : {
          dessert_picture  : dessert_picture,
          dessert_id       : dessert_id
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