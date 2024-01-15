<?php 
$this->layout('layouts/main'); 

?>
<style type="text/css">
  td { 
    padding: 10px;
    /*text-align: left;*/
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
        <h4 class="modal-title">เพิ่มรายการอุปกรณ์</h4>
      </div>
      <div class="modal-body">
        <form id="form_tool_create" onsubmit="return submit_tool_create()">
        <table>
          <tr>
            <td>
              <label>รายการอุปกรณ์</label>
            </td>
            <td>
              <input class="form-control" type="text" name="tool" id="tool" 
              style="width: 200px" required>
            </td>
          </tr>
          <tr>
            <td align="right" colspan="2">
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
      <h1> อุปกรณ์</h1>
      <hr>
      <button class="btn btn-lg btn-primary" id="btn_create"><i class="glyphicon glyphicon-plus"></i> เพิ่มอุปกรณ์</button>
  </div>
</div>
<br>
<div id="grid_tool"></div>

<script>
  jQuery(document).ready(function($) {
    grid_tool();
        $('#btn_create').on('click', function() {
            $('#modal_create').modal({backdrop: 'static'});
            $('#form_create').trigger('reset');
        });
  });

    function grid_tool() {
      
      var dataAdapter = new $.jqx.dataAdapter({
      datatype: "json",
      updaterow: function (rowid, rowdata, commit) {
        gojax('post', '/tool/update', {
          tool_name     : rowdata.tool_name,
          tool_id       : rowdata.tool_id
        }).done(function(data) {
          if (data.result === true) {
            $('#grid_tool').jqxGrid('updatebounddata');
            commit(true);
          }
        }).fail(function() {
          commit(false);
        });
      },
      datafields: [
                { name: "tool_id", type: "int" },
                { name: "tool_name", type: "string"}
      ],
        url : '/load'
      });

      return $("#grid_tool").jqxGrid({
          width: '60%',
          pageSize :'15',
          source: dataAdapter,
          autoheight: true,
          columnsresize: true,
          pageable: true,
          filterable: true,
          showfilterrow: true,
          editable : true,
          theme : 'deestone',
        columns: [
            // { text:"tool_id", datafield: "tool_id", editable : false, width : "20%"},
            { text:"รายการอุปกรณ์", datafield: "tool_name"}
        ]
      });
    }

    function submit_tool_create() {
      $.ajax({
          url : '/tool/create',
          type : 'post',
          cache : false,
          dataType : 'json',
          data : $('form#form_tool_create').serialize()
      })
      .done(function(data) {
          if (data.result == false) {
            swal(data.message, "", "error")
          }else{
            $('#modal_create').modal('hide');
            $('#grid_tool').jqxGrid('updatebounddata');
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
          // console.log(data);
      });
      return false;
    }

</script>