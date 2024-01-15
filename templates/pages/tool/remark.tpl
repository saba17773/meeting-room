<?php $this->layout('layouts/main'); ?>

<style type="text/css">
  td { 
    padding: 10px;
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
</style>

<div class="modal" id="modal_create" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <form id="form_create" onsubmit="return submit_create()">
        <table align="center">
          <tr>
            <td>
              <label>หมายเหตุ</label>
            </td>
            <td>
              <input class="form-control" type="text" name="remark" id="remark" required style="width: 400px">
            </td>
          </tr>
          <tr>
            <td>
              <label>ประเภท</label>
            </td>
            <td>
              <select class="form-control" name="remark_type" id="remark_type" required></select>
            </td>
          </tr>
          <tr>
            <td align="right" colspan="4">
            <input type="hidden" name="form_type" id="form_type">
            <input type="hidden" name="id" id="id">
            <button class="btn btn-primary">Save</button>
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
        <h1>หมายเหตุการไม่อนุมัติ</h1>
        <hr>
        <button class="btn btn-lg btn-primary" id="btn_create"><i class="glyphicon glyphicon-plus"></i> เพิ่ม</button>
        <button class="btn btn-lg btn-primary" id="btn_edit"><i class="glyphicon glyphicon-edit"></i> แก้ไข</button>
    </div>
</div>
<br>
<div id="grid_remark"></div>

<script type="text/javascript">
  jQuery(document).ready(function($) {
    grid_remark();

    $('#btn_create').on('click', function() {      
     
      $('#modal_create').modal({backdrop: 'static'});
      $('#form_remark_create').trigger('reset');
      $('#form_type').val('create');
      $('.modal-title').text('เพิ่มหมายเหตุ');
      getType()
      .done(function(data) {
        $('select[name=remark_type]').html("<option value=''>=Select=</option>");
        $.each(data, function(index, val) {
          $('select[name=remark_type]').append('<option value="'+val.type_id+'">'+val.type_name+'</option>');
          $('#remark_type').val();
        });
      });

    });

    $('#btn_edit').on('click', function() {      
      
      var selectedrowindex = $("#grid_remark").jqxGrid('getselectedrowindex');
      var rowdata = $("#grid_remark").jqxGrid('getrowdata', selectedrowindex);

      if (rowdata) {
        $('#modal_create').modal({backdrop: 'static'});
        $('#form_remark_create').trigger('reset');
        $('#form_type').val('update');
        $('.modal-title').text('แก้ไขหมายเหตุ');
        $('#remark').val(rowdata.remark_name);
        $('#id').val(rowdata.remark_id);
        getType()
        .done(function(data) {
          $('select[name=remark_type]').html("<option value=''>=Select=</option>");
          $.each(data, function(index, val) {
            $('select[name=remark_type]').append('<option value="'+val.type_id+'">'+val.type_name+'</option>');
            $('#remark_type').val(rowdata.remark_type_id);
          });
        });
      }else{
        alert("กรุณาเลือกรายการ");
      }

    });

  });

  function submit_create(){
    $.ajax({
        url : '/remark/create',
        type : 'post',
        cache : false,
        dataType : 'json',
        data : $('form#form_create').serialize()
    })
    .done(function(data) {
        if (data.result == false) {
          swal(data.message, "", "error")
        }else{
          $('#modal_create').modal('hide');
          $('#grid_remark').jqxGrid('updatebounddata','cells');
          swal(data.message, " ", "success");
        }
        // console.log(data);
    });
      return false;
  }

  function getType() {
    return $.ajax({
      url : '/load/remarktype',
      type : 'get',
      dataType : 'json',
      cache : false
    });
  }

  function grid_remark() {

      var dataAdapter = new $.jqx.dataAdapter({
      datatype: "json",
      datafields: [
                { name: "remark_id", type: "int" },
                { name: "remark_name", type: "string"},
                { name: "remark_type_id", type: "int"},
                { name: "type_name", type:"string"}
      ],
        url : '/loadremark'
      });

      return $("#grid_remark").jqxGrid({
          width: '40%',
          pageSize :'15',
          source: dataAdapter,
          autoheight: true,
          columnsresize: true,
          pageable: true,
          filterable: true,
          showfilterrow: true,
          theme: 'deestone',
        columns: [
          { text:"หมายเหตุ", datafield: "remark_name"},
          { text:"ประเภท", datafield: "type_name"}
        ]
      });
  }
</script>