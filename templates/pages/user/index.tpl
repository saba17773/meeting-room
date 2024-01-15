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

<!-- Create -->
<div class="modal" id="modal_create" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">เพิ่มผู้ใช้งาน</h4>
      </div>
      <div class="modal-body">
        <form id="form_user_create" onsubmit="return submit_user_create()">
        <table align="center">
          <tr>
            <td>
              <label for="user_employee">Employee</label>
            </td>
            <td>
              <div class="input-group">
                <input type="text" name="user_employee" id="user_employee" class="form-control" required style="width: 200px;" readonly="ture">
                <button class="btn btn-primary" id="btn_employee" type="button">
                  <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                </button>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <label>ชื่อผู้ใช้งาน</label>
            </td>
            <td>
              <input class="form-control" type="text" name="username" id="username" required>
            </td>
            <td>
              <label>รหัสผ่าน</label>
            </td>
            <td>
              <input class="form-control" type="password" name="password" id="password" required>
            </td>
          </tr>
          <tr>
            <td>
              <label>ชื่อ</label>
            </td>
            <td>
              <input class="form-control" type="text" name="fname" id="fname" required>
            </td>
            <td>
              <label>นามสกุล</label>
            </td>
            <td>
              <input class="form-control" type="text" name="lname" id="lname" required>
            </td>
          </tr>
          <tr>
            <td>
              <label>เบอร์ติดต่อ</label>
            </td>
            <td>
              <input class="form-control" type="text" name="tel" id="tel" required>
            </td>
            <td>
              <label>อีเมลล์</label>
            </td>
            <td>
              <input class="form-control" type="email" name="email" id="email" required>
            </td>
          </tr>
          <tr>
            <td>
              <label>บริษัท</label>
            </td>
            <td>
              <select class="form-control" name="company" id="company" required></select>
            </td>
            <td>
              <label>แผนก</label>
            </td>
            <td>
              <select class="form-control" name="department" id="department" required></select>
            </td>
          </tr>
          <tr>
            <td>
              <label>Permission</label>
            </td>
            <td>
              <select class="form-control" name="permission" id="permission" required></select>
            </td>
            <td>
              <label>สถานะ</label>
            </td>
            <td>
              <select class="form-control" name="status" id="status" required></select>
            </td>
          </tr>
          <tr>
            <td>
              <label>อีเมลล์(ผจก.)</label>
            </td>
            <td>
              <input class="form-control" type="email" name="emailhead" id="emailhead" required>
            </td>
            <td>
              <label>IsActive</label>
            </td>
            <td>
              <select class="form-control" name="active" id="active" required>
                <option value="1">Enable</option>
                <option value="0">Disable</option>
              </select>
            </td>
          </tr>
          <tr>
          	<td align="right" colspan="4">
            <input type="hidden" name="form_type" id="form_type">
            <input type="hidden" name="id" id="id">
		        <button class="btn btn-primary">บันทึก</button>
          	</td>
          </tr>
        </table>
        
        </form>
      </div>
    </div>
  </div>
</div>
<!-- Eamil -->
<div class="modal" id="modal_email" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">e-mail ผู้อนุมัติ</h4>
      </div>
      <div class="modal-body">
        <div id="grid_emailhead"></div>
      </div>
      <div class="modal-footer">
        <input type="hidden" id="email_id_user" name="email_id_user">
      </div>
    </div>
  </div>
</div>
<!-- btn -->
<div class="row">
    <div class="col-lg-12">
        <h1>ผู้ใช้งาน</h1>
        <hr>
        <button class="btn btn-lg btn-primary" id="btn_create"><i class="glyphicon glyphicon-plus"></i> เพิ่ม</button>
        <!-- <button class="btn btn-lg btn-primary" id="btn_setmail"><i class="glyphicon glyphicon-send"></i> Set E-mail</button> -->
        <button class="btn btn-lg btn-primary" id="btn_edit"><i class="glyphicon glyphicon-edit"></i> แก้ไข</button>
    </div>
</div>
<!-- dialog employee -->
<div class="modal" id="modal_employee" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <b>รายชื่อพนักงาน</b>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
          </button>
        </div>
        
        <div class="modal-body">
          <div id="grid_empployee"></div>
        <hr>
        </div>

    </div>
  </div>
</div>

<br>
<div id="grid_user"></div>

<script type="text/javascript">
    
  $(document).ready(function () {
    
    grid_user();

    $('#btn_employee').on('click', function () {
      $('#modal_employee').modal({backdrop: 'static'});
      load_gridemployee();
      return false;
    });

    $("#grid_empployee").on('rowdoubleclick', function(event) {
        var args = event.args;
        var row = $("#grid_empployee").jqxGrid('getrowdata', args.rowindex);
        $('#user_employee').val(row.CODEMPID);
        $('#fname').val(row.EMPNAME);
        $('#lname').val(row.EMPLASTNAME);
        $('#user_company').val(row.COMPANYNAME);
        $('#email').val(row.EMAIL);
        $('#modal_employee').modal('hide');
    });

    $('#btn_create').on('click', function() {      
     
      $('#modal_create').modal({backdrop: 'static'});
      $('#form_user_create').trigger('reset');
      $('#form_type').val('create');

      getPlant()
	    .done(function(data) {
	      $('select[name=company]').html("<option value=''>=Select=</option>");
	      $.each(data, function(index, val) {
	        $('select[name=company]').append('<option value="'+val.com_id+'">'+val.com_nname+
	          ' ('+val.com_fname+')'+'</option>');
	        $('#company').val();
	      });
		  });

			getDepartment()
		    .done(function(data) {
		      $('select[name=department]').html("<option value=''>=Select=</option>");
		      $.each(data, function(index, val) {
		        $('select[name=department]').append('<option value="'+val.dep_id+'">'+val.dep_name+'</option>');
		        $('#department').val();
		      });
			});

			getPermission()
		    .done(function(data) {
		      $('select[name=permission]').html("<option value=''>=Select=</option>");
		      $.each(data, function(index, val) {
		        $('select[name=permission]').append('<option value="'+val.permission_id+'">'+val.permission_name+'</option>');
		        $('#permission').val();
		      });
			});

      getStatus()
        .done(function(data) {
          $('select[name=status]').html("<option value=''>=Select=</option>");
          $.each(data, function(index, val) {
            $('select[name=status]').append('<option value="'+val.status_id+'">'+val.status_name+
              '</option>');
            $('#status').val();
          });
      });

    });

    $('#btn_setmail').on('click', function() {
      var selectedrowindex = $("#grid_user").jqxGrid('getselectedrowindex');
      var datarow = $("#grid_user").jqxGrid('getrowdata', selectedrowindex);
      
      if(datarow) {
        $('#modal_email').modal({backdrop: 'static'});
        $('#email_id_user').val(datarow.id);
        grid_emailhead();
      }
      
    });

    $('#grid_emailhead').on('rowdoubleclick', function (event){
      var args = event.args;
      var boundIndex = args.rowindex;        
      var datarow = $("#grid_emailhead").jqxGrid('getrowdata', boundIndex);
      update_emailhead(datarow.email_head,$('#email_id_user').val());
    });   

    $('#btn_edit').on('click', function() {      
      var selectedrowindex = $("#grid_user").jqxGrid('getselectedrowindex');
      var rowdata = $("#grid_user").jqxGrid('getrowdata', selectedrowindex);

      if (rowdata) {

        $('#modal_create').modal({backdrop: 'static'});
        $('#form_user_create').trigger('reset');
        $('#form_type').val('update');
        $('#user_employee').val(rowdata.EMPID);
        $('#username').val(rowdata.username);
        $('#password').val(rowdata.password);
        $('#fname').val(rowdata.fname);
        $('#lname').val(rowdata.lname);
        $('#tel').val(rowdata.tell);
        $('#email').val(rowdata.email);
        $('#emailhead').val(rowdata.email_head);
        $('#active').val(rowdata.USERACTIVE);
        $('#id').val(rowdata.id);

        getPlant()
        .done(function(data) {
          $('select[name=company]').html("<option value=''>=Select=</option>");
          $.each(data, function(index, val) {
            $('select[name=company]').append('<option value="'+val.com_id+'">'+val.com_nname+
              ' ('+val.com_fname+')'+'</option>');
            $('#company').val(rowdata.company);
          });
        });

        getDepartment()
        .done(function(data) {
          $('select[name=department]').html("<option value=''>=Select=</option>");
          $.each(data, function(index, val) {
            $('select[name=department]').append('<option value="'+val.dep_id+'">'+val.dep_name+'</option>');
            $('#department').val(rowdata.department);
          });
        });

        getPermission()
          .done(function(data) {
            $('select[name=permission]').html("<option value=''>=Select=</option>");
            $.each(data, function(index, val) {
              $('select[name=permission]').append('<option value="'+val.permission_id+'">'+val.permission_name+'</option>');
              $('#permission').val(rowdata.permission_company);
            });
        });

        getStatus()
        .done(function(data) {
          $('select[name=status]').html("<option value=''>=Select=</option>");
          $.each(data, function(index, val) {
            $('select[name=status]').append('<option value="'+val.status_id+'">'+val.status_name+
              '</option>');
            $('#status').val(rowdata.status);
          });
        });

      }

    });

  });

  function grid_user() {

	    var dataAdapter = new $.jqx.dataAdapter({
	    datatype: "json",
	    updaterow: function (rowid, rowdata, commit) {
	        gojax('post', '/user/update', {
	          password	: rowdata.password,
	          fname 	: rowdata.fname,
	          lname 	: rowdata.lname,
	          tell 		: rowdata.tell,
	          email 	: rowdata.email,
	          active 	: rowdata.user_active,
	          company 	: rowdata.com_nname,
	          department: rowdata.dep_name,
	          permission: rowdata.permission_name,
	          id      	: rowdata.id
	        }).done(function(data) {
	          if (data.result === true) {
	            $('#grid_user').jqxGrid('updatebounddata');
	            commit(true);
	          }
	        }).fail(function() {
	          commit(false);
	        // console.log(data);
	        });
	        // console.log(rowdata.permission_name);
	    },
	    datafields: [
	              { name: "id", type: "int" },
	              { name: "username", type: "string"},
	              { name: "password", type: "string"},
	              { name: "fname", type: "string"},
	              { name: "lname", type: "string"},
	              { name: "tell", type: "string"},
	              { name: "email", type: "string"},
                { name: "email_head", type: "string"},
	              { name: "user_active", type: "string"},
	              { name: "company", type: "string"},
	              { name: "com_nname", type: "string"},
	              { name: "department", type: "string"},
	              { name: "dep_name", type: "string"},
	              { name: "permission_company", type: "int"},
	              { name: "permission_name", type: "string"},
                { name: "status", type: "string"},
	              { name: "status_name", type: "string"},
                { name: "EMPID", type: "string"},
                { name: "USERACTIVE", type: "int"}
	    ],
	      url : '/user/load'
	    });

	    return $("#grid_user").jqxGrid({
	        width: '100%',
	        pageSize :'15',
	        source: dataAdapter,
	        autoheight: true,
	        columnsresize: true,
	        pageable: true,
	        filterable: true,
	        showfilterrow: true,
	        // editable : true,
	        theme: 'deestone',
	      columns: [
	        { text:"ชื่อผู้ใช้งาน", datafield: "username", editable:false, width:'10%'},
	        // { text:"รหัสผ่าน", datafield: "password",width:'10%'},
	        { text:"ชื่อ", datafield: "fname",width:'10%'},
	        { text:"นามสกุล", datafield: "lname",width:'10%'},
	        { text:"เบอร์ติดต่อ", datafield: "tell",width:'4%'},
	        { text:"e-mail", datafield: "email",width:'18%'},
          { text:"e-mail ผู้อนุมัติ", datafield: "email_head",width:'18%'},
	        // { text:"สถานะ", datafield: "user_active", filtertype: 'bool', columntype: 'checkbox', editable: true, width:'5%'},
            // {	
            //     text: 'บริษัท', datafield: 'com_nname', width: "5%", columntype: 'dropdownlist',
            //     createeditor: function (row, column, editor) {
            //         editor.jqxDropDownList({ autoDropDownHeight: true,displayMember: "com_nname"});
            //     },
            //     cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
            //         if (newvalue == "") return oldvalue;
            //     },
            //     geteditorvalue: function (row, cellvalue, editor) {
            //         var selectedIndex = editor.jqxDropDownList('getSelectedIndex');
            //         return editor.find('input').val();
            //     }
            // },
            {	
                text: 'แผนก', datafield: 'dep_name', width: "10%", columntype: 'dropdownlist',
                createeditor: function (row, column, editor) {
                    editor.jqxDropDownList({ autoDropDownHeight: true,displayMember: "dep_name"});
                },
                cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                    if (newvalue == "") return oldvalue;
                },
                geteditorvalue: function (row, cellvalue, editor) {
                    var selectedIndex = editor.jqxDropDownList('getSelectedIndex');
                    return editor.find('input').val();
                }
            },
            {	
                text: 'Permission', datafield: 'permission_name', width: "10%", columntype: 'dropdownlist',
                createeditor: function (row, column, editor) {
                    editor.jqxDropDownList({ autoDropDownHeight: true,displayMember: "permission_name"});
                },
                cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                    if (newvalue == "") return oldvalue;
                },
                geteditorvalue: function (row, cellvalue, editor) {
                    var selectedIndex = editor.jqxDropDownList('getSelectedIndex');
                    return editor.find('input').val();
                }

            },
            { text:"ระดับ", datafield: "status_name",width:'8%',filtertype: 'checkedlist', editable: false, filteritems: ['Admin','User'], 
                  cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
                      var status;
                         if (value =="Admin") {
                             status =  "<div style='padding: 5px; background:#1E90FF ; color:#000000; font-size:15px;'> Admin </div>";
                         }else if(value =="User"){
                              status =  "<div style='padding: 5px; background:#778899 ; color:#000000; font-size:15px;'> User </div>";
                         }
                         return status;
                  }
            },
            { text:"Active", datafield: "USERACTIVE",width:50,
                cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
                    var status;
                       if (value ==1) {
                           status =  "<div style='padding: 5px; background:#00CC00; color:#F8F8FF; font-size:12px;'> Enable </div>";
                       }else{
                            status =  "<div style='padding: 5px; background:#FF0033; color:#F8F8FF; font-size:12px;'> Disable </div>";
                       }
                       return status;
                }
            }

	      ]
	    });
	}

  function grid_emailhead() {

      var dataAdapter = new $.jqx.dataAdapter({
      datatype: "json",
      datafields: [
                { name: "rec_id", type: "int" },
                { name: "email_head", type: "string"},
                { name: "email_name", type: "string"}
      ],
        url : '/user/load/emailhead'
      });

      return $("#grid_emailhead").jqxGrid({
          width: '100%',
          pageSize :'15',
          source: dataAdapter,
          autoheight: true,
          columnsresize: true,
          pageable: true,
          filterable: true,
          showfilterrow: true,
          theme: 'deestone',
        columns: [
          { text:"E-mail", datafield: "email_head"},
          { text:"Name", datafield: "email_name"}
        ]
      });
  }

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

	function getPermission() {
	  return $.ajax({
		    url : '/user/loadpermission',
		    type : 'get',
		    dataType : 'json',
		    cache : false
		  });
	}

  function getStatus() {
    return $.ajax({
      url : '/user/loadstatus',
      type : 'get',
      dataType : 'json',
      cache : false
    });
  }

	function submit_user_create(){
		$.ajax({
		    url : '/user/create',
		    type : 'post',
		    cache : false,
		    dataType : 'json',
		    data : $('form#form_user_create').serialize()
		})
		.done(function(data) {
		    if (data.result == false) {
		      swal(data.message, "", "error")
		    }else{
		      $('#modal_create').modal('hide');
		      $('#grid_user').jqxGrid('updatebounddata','cells');
		      swal(data.message, " ", "success");
		    }
		    // console.log(data);
		});
	  	return false;
	}

  function update_emailhead(email_head,id){
    $.ajax({
        url : '/user/update_email_head',
        type : 'post',
        cache : false,
        dataType : 'json',
        data : {
        email_head : email_head,
        id         : id
        }
    })
    .done(function(data) {
        if (data.result == false) {
          swal(data.message, "", "error")
        }else{
          $('#modal_email').modal('hide');
          $('#grid_user').jqxGrid('updatebounddata');
          swal(data.message, " ", "success");
        }
        // console.log(data);
    });

    return false;

  }

  function load_gridemployee(){

    var dataAdapter = new $.jqx.dataAdapter({
    datatype: "json",
    datafields: [
    { name: 'CODEMPID', type: 'string' },
    { name: 'EMPNAME', type: 'string' },
    { name: 'EMPLASTNAME', type: 'string' },
    { name: 'DEPARTMENTNAME', type: 'string' },
    { name: 'DIVISIONNAME', type: 'string' },
    { name: 'COMPANYNAME', type: 'string' },
    { name: 'EMAIL', type: 'string' },
    { name: 'DIVISIONID', type: 'string' },
    { name: 'DEPARTMENTCODE', type: 'string' }
    ],
      url: '/user/employee',
    });

    return $("#grid_empployee").jqxGrid({
        width: '100%',
        source: dataAdapter,
        autoheight: true,
        pageSize: 10,
        altrows: true,
        pageable: true,
        sortable: true,
        filterable: true,
        showfilterrow: true,
        columnsresize: true,
        theme: 'default',
        columns: [
          {text: 'EmployeeCode',datafield: 'CODEMPID',width:110},
          {text: 'Firstname',datafield: 'EMPNAME',width:110},
          {text: 'Lastname',datafield: 'EMPLASTNAME',width:110},
          {text: 'Section',datafield: 'DIVISIONNAME',width:100},
          {text: 'Department',datafield: 'DEPARTMENTNAME',width:100},
          {text: 'Company',datafield: 'COMPANYNAME',width:100},
          {text: 'E-mail',datafield: 'EMAIL'}

        ]
    });
  }
</script>