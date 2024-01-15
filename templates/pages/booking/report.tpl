<?php $this->layout('layouts/main'); ?>

<h1 style="text-align: center; margin-bottom: 20px;">รายงานการใช้ห้องประชุม</h1>

<style>
  table {
    margin: 0 auto;
  }

  table td {
    padding: 10px;
  }
</style>

<table border="0">
  <tr>
    <td>วันที่</td>
    <td><input type="text" id="input_from_date" name="input_from_date" value="" class="form-control"></td>
    <td>ถึงวันที่</td>
    <td><input type="text" id="input_to_date" name="input_to_date" value="" class="form-control"></td>
  </tr>
</table>

<div id="grid" style="margin-top: 20px;"></div>

<script>
  jQuery(document).ready(function ($) {

    grid();

    $('#input_from_date').datepicker({
      dateFormat: 'dd-mm-yy',
      onSelect: function (d) {
        $('#input_to_date').val(d);
      },
      beforeShow: function () {
        setTimeout(function () {
          $('.ui-datepicker').css('z-index', 99999999999999);
        }, 0);
      }
    });

    $('#input_to_date').datepicker({
      dateFormat: 'dd-mm-yy',
      onSelect: function (d) {
       if (d < $('#input_from_date').val()) {
        alert('วันไม่ถูกต้อง');
       }
       return false;
      },
      beforeShow: function () {
        setTimeout(function () {
          $('.ui-datepicker').css('z-index', 99999999999999);
        }, 0);
      }
    });

    // END
  });

  function grid() {
    var dataAdapter = new $.jqx.dataAdapter({
      datatype: 'json',
      datafields: [
        { name: 'book_title', type: 'string' },
        { name: 'book_start', type: 'date' },
        { name: 'book_end', type: 'date' },
        { name: 'book_reserv_to', type: 'string'}
      ],
      url: '/api/v1/book'
    });

    return $("#grid").jqxGrid({
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
      columns: [
        { text: 'เรื่อง', datafield: 'book_title', width: 120 },
        { text: 'จองวันที่', datafield: 'book_start', width: 170, cellsformat: 'yyyy-MM-dd HH:mm:ss' },
        { text: 'ถึงวันที่', datafield: 'book_end', width: 170, cellsformat: 'yyyy-MM-dd HH:mm:ss' },
        { text: 'ผู้จอง', datafield: 'book_reserv_to', width: 100 }
      ]
    });
  }
</script>