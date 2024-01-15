<?php if (is_logged_in() === true): ?>
<?php $this->layout('layouts/main'); ?>
<?php endif; ?>
<?php if (is_logged_in() === false): ?>
<?php $this->layout('layouts/login'); ?>
<?php endif; ?>

<div class="row">
    <div class="col-lg-12">
        <h1>รายงานจองห้องประชุม</h1>
    </div>
</div>
<br>
<div id="grid_report"></div>

<script type="text/javascript">

	jQuery(document).ready(function($) {
		grid_report();
	});

	function grid_report() {
	    var dataAdapter = new $.jqx.dataAdapter({
	    datatype: "json",
	    filter : function () {
            // update the grid and send a request to the server.

            // loadgrid.jqxGrid('clearfilters');
            $('#grid_report').jqxGrid('updatebounddata','filter');
        },
	    datafields: [
	              { name: "book_startdate", type: "date"},
	              { name: "book_enddate", type: "date"},
	              { name: "book_starttime", type: "string"},
	              { name: "book_endtime", type: "string"},
	              { name: "com_nname", type: "string"},
	              { name: "com_fname", type: "string"},
	              { name: "room_name", type: "string"},
	              { name: "book_title", type: "string"},
	              { name: "fullname", type: "string"},
	              { name: "dep_name", type: "string"},
	              { name: "tell", type: "string"}
	    ],
	      url : '/report/load/day'
	    });

	    // var addfilter = function () {
     //        var filtergroup = new $.jqx.filter();
     //        var date_defult = '<?php echo date('Y-m-d', strtotime(date('Y-m-d'). ' -1 days'));?>';
     //        var date_defult1 = '<?php echo date('Y-m-d');?>';
     //        var filter_or_operator = 0;
     //        var filtervalue = date_defult;
     //        var filtercondition = 'GREATER_THAN_OR_EQUAL';
     //        var filter1 = filtergroup.createfilter('datefilter', filtervalue, filtercondition);

     //        filtervalue = date_defult1;
     //        filtercondition = 'LESS_THAN';
     //        var filter2 = filtergroup.createfilter('datefilter', filtervalue, filtercondition);

     //        filtergroup.addfilter(filter_or_operator, filter1);
     //        filtergroup.addfilter(filter_or_operator, filter2);
     //        // add the filters.
     //        $("#grid_report").jqxGrid('addfilter', 'book_startdate', filtergroup);
     //        // apply the filters.
     //        $("#grid_report").jqxGrid('applyfilters');
     //    }
        var addDefaultfilter = function(){
            var datefiltergroup = new $.jqx.filter();

            var today = new Date();

            var weekago = new Date();

            weekago.setDate((today.getDate() - 10));

            var  filtervalue = weekago;
            var  filtercondition = "GREATER_THAN_OR_EQUAL";
            var  filter4 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

            filtervalue = today;
            filtercondition = "LESS_THAN_OR_EQUAL";
            var filter5 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

            datefiltergroup.addfilter(0, filter4);
            datefiltergroup.addfilter(0, filter5);

            //$("#jqxProgress").jqxGrid('addfilter', 'Status', statusfiltergroup);
            $("#grid_report").jqxGrid('addfilter', 'range', datefiltergroup);
            $("#grid_report").jqxGrid('applyfilters');
        }

	    return $("#grid_report").jqxGrid({
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
	        ready: function () {
                addDefaultfilter();
            },
	      columns: [
	      	// {text: 'Date',datafield: 'Date',filtertype: 'range', cellsformat: 'yyyy-MM-dd' ,width:100},
	        { text:"วันที่ใช้งาน", datafield: "book_startdate",filtertype: 'range', cellsformat: 'yyyy-MM-dd' , width:'10%'},
	        { text:"เวลาเริ่มต้น", datafield: "book_starttime",width:'8%'},
	        { text:"เวลาสิ้นสุด", datafield: "book_endtime",width:'8%'},
	        { text:"บริษัท", datafield: "com_fname",width:'15%'},
	        { text:"ชื่อห้อง", datafield: "room_name"},
	        { text:"หัวข้อการประชุม", datafield: "book_title",width:'12%'},
	        { text:"ผู้จอง", datafield: "fullname",width:'12%'},
	        { text:"แผนก", datafield: "dep_name",width:'14%'},
	        { text:"เบอร์โทร", datafield: "tell",width:'8%'}
	      ]
	    });
	}
</script>