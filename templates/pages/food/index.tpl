<?php 
$this->layout('layouts/main'); 

use App\Food\FoodAPI;


$dataFood = (new FoodAPI)->load();
// echo "<pre>".print_r($dataFood,true)."</pre>";
?>

<div class="row">
  <div class="col-lg-12">
      <h1>รายการอาหาร</h1>
      <hr>
      <button class="btn btn-primary" data-backdrop="static" data-toggle="modal" data-target="#modal_new" id="btn_new" style="width:190px;" ><i class="glyphicon glyphicon-plus"></i>เพิ่มรายการอาหาร</button>
  </div>
</div>

<div class="modal" id="modal_new" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">เพิ่มรายการอาหาร</h4>
      </div>
      <div class="modal-body">
        <form id="form_new" onsubmit="return submit_new_food()">
          
            <label>ชื่อรายการอาหาร</label>
            <input type="text" name="food_name" id="food_name" class="form-control" autocomplete="off" placeholder="ชื่อรายการอาหาร" required>
            <label>ราคาอาหาร</label>
            <input type="number" name="food_price" id="food_price" class="form-control" autocomplete="off" placeholder="ราคาอาหาร" required>
            <br>
            <input type="file" name="file_pic" id="file_pic" class="well">
            <br>
            <input type="hidden" name="type" id="type">
            <input type="hidden" name="food_id" id="food_id">
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
        foreach ($dataFood as $value) {
      ?>
    <tr>
      <td style="text-align: center;">
          <img src="./picturemaster/food/<?php echo $value['food_picture'];?>" style="width:400px;height:250px;"> 
      </td>
      <td>
          <h3>
          ชื่อรายการ : <?php echo $value['food_name']; ?><br>
          ราคา : <?php echo $value['food_price']; ?> บาท<br>
          </h3>
      <br><br>                
          <button class="btn btn-primary" style="width:190px;" Onclick="return update('<?php echo $value['food_name']; ?>','<?php echo $value['food_price']; ?>','<?php echo $value['food_picture']; ?>','<?php echo $value['food_id']; ?>')"><i class="glyphicon glyphicon-edit"></i>
            แก้ไขรายการอาหาร </button>
      <br><br>                
          <button class="btn btn-primary" style="width:190px;" Onclick="return deleted('<?php echo $value['food_picture']; ?>','<?php echo $value['food_id']; ?>')"><i class="glyphicon glyphicon-trash"></i>
            ลบรายการอาหาร </button>
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

  function submit_new_food(){

    var file_data = $('#file_pic').prop('files')[0];
    var form_data = new FormData();                  
    form_data.append('file', file_data);

    if(!file_data)
    {
      $.ajax({
        url : '/food/create',
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
      form_data.append('food_name', $('#food_name').val());
      form_data.append('food_price', $('#food_price').val());
      form_data.append('type', $('#type').val());
      form_data.append('food_id', $('#food_id').val());

      ex = getExtension(file_data["name"]);

      $.ajax({
        url : '/food/create',
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

  function update(food_name,food_price,food_picture,food_id){
    $('#modal_new').modal({backdrop: 'static'});
    $('#form_new').trigger('reset');
    $('.modal-title').text('แก้ไขรายการอาหาร');
    $('#food_name').val(food_name);
    $('#food_price').val(food_price);
    $('#food_id').val(food_id);
    $('#type').val('update');
  }

  function deleted(food_picture,food_id){
    // console.log(food_picture+food_id);
    if (confirm('Are you Delete ?')) {
      
      $.ajax({
        url : '/food/delete',
        type : 'post',
        cache : false,
        dataType : 'json',
        data : {
          food_picture  : food_picture,
          food_id       : food_id
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