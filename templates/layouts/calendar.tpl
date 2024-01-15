<!DOCTYPE html>
<html lang="en">
<head>
  <title><?php echo APP_NAME;?></title>
	<meta charset="UTF-8">
	<!-- CSS -->
  <link href='/assets/fullcalendar-scheduler/lib/fullcalendar.min.css' rel='stylesheet' />
  <link href='/assets/fullcalendar-scheduler/lib/fullcalendar.print.css' rel='stylesheet' media='print' />
  <link href='/assets/fullcalendar-scheduler/scheduler.min.css' rel='stylesheet' />
  

  <link rel="stylesheet" href="/assets/jqwidgets/styles/jqx.base.css"/>
	<link rel="stylesheet" href="/assets/bootstrap-3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="/assets/treed-menu/treed.css">
	<link rel="stylesheet" href="/assets/css/app.css">
  <link rel="stylesheet" href="/assets/sweetalert-master/dist/sweetalert.css">
  <link rel="stylesheet" href="/assets/css/multiple-select.css" />
  <link rel="stylesheet" href="/assets/jquery-ui-1.12.1/jquery-ui.min.css">
  <link rel="stylesheet" href="/assets/css/boon-all.css">
  <link rel="stylesheet" href="/assets/css/style.css">
  <link rel="stylesheet" href="/assets/jqwidgets/styles/deestone2.css"/>

  <!-- CSS datepicker -->
  <link rel="stylesheet" type="text/css" href="/assets/jonthornton/jquery.timepicker.css" />
  
	<!-- JS -->
  <script src="/assets/sweetalert-master/dist/sweetalert.min.js"></script> 
	<script src="/assets/js/jquery.min.js"></script>
  <script src="/assets/js/multiple-select.js"></script>
  <script src="/assets/bootstrap-3.3.7/js/bootstrap.min.js"></script>
  <script src="/assets/jqwidgets/jqxcore.js"></script>
  <script src="/assets/jqwidgets/jqxinput.js"></script>
  <script src="/assets/jqwidgets/jqxdata.js"></script>
  <script src="/assets/jqwidgets/jqxbuttons.js"></script>
  <script src="/assets/jqwidgets/jqxbuttongroup.js"></script>
  <script src="/assets/jqwidgets/jqxscrollbar.js"></script>
  <script src="/assets/jqwidgets/jqxmenu.js"></script>
  <script src="/assets/jqwidgets/jqxlistbox.js"></script>
  <script src="/assets/jqwidgets/jqxdropdownlist.js"></script>
  <script src="/assets/jqwidgets/jqxgrid.js"></script>
  <script src="/assets/jqwidgets/jqxgrid.selection.js"></script> 
  <script src="/assets/jqwidgets/jqxgrid.columnsresize.js"></script> 
  <script src="/assets/jqwidgets/jqxgrid.filter.js"></script> 
  <script src="/assets/jqwidgets/jqxgrid.sort.js"></script> 
  <script src="/assets/jqwidgets/jqxgrid.pager.js"></script> 
  <script src="/assets/jqwidgets/jqxgrid.edit.js"></script> 
  <script src="/assets/jqwidgets/jqxdatetimeinput.js"></script> 
  <script src="/assets/jqwidgets/jqxcalendar.js"></script> 
  <script src="/assets/jqwidgets/jqxgrid.grouping.js"></script> 
  <script src="/assets/jqwidgets/jqxwindow.js"></script>
  <script src="/assets/jqwidgets/jqxinput.js"></script>
  <script src="/assets/jqwidgets/jqxcheckbox.js"></script>
  <script src="/assets/jqwidgets/jqxpanel.js"></script>
  <script src="/assets/jqwidgets/jqxcombobox.js"></script>
  <script src="/assets/jqwidgets/jqxdropdownbutton.js"></script>
  <script src="/assets/jqwidgets/globalization/globalize.js"></script>
  <script src="/assets/jquery-ui-1.12.1/jquery-ui.min.js"></script>
  <script src="/assets/js/app.js"></script>
  <script src="/assets/js/gojax.min.js"></script>

  
  <script src='/assets/fullcalendar-scheduler/lib/moment.min.js'></script>
  <script src='/assets/fullcalendar-scheduler/lib/jquery.min.js'></script>
  <script src='/assets/fullcalendar-scheduler/lib/fullcalendar.min.js'></script>
  <script src='/assets/fullcalendar-scheduler/scheduler.min.js'></script>
	  <!--datepicker-->
  <script src="/assets/vitalets-datepicker/js/moment.min.js"></script>
  <script type="text/javascript" src="/assets/jonthornton/jquery.timepicker.js"></script>

</head>

<style type="text/css">
  .navbar-custom {
      background-color:#708090;
      color:#ffffff;
      border-radius:0;
  }

  .navbar-custom .navbar-nav > li > a {
      color:#fff;
  }

  .navbar-custom .navbar-nav > .active > a {
      color: #ffffff;
      background-color:transparent;
  }

  .navbar-custom .navbar-nav > li > a:hover,
  .navbar-custom .navbar-nav > li > a:focus,
  .navbar-custom .navbar-nav > .active > a:hover,
  .navbar-custom .navbar-nav > .active > a:focus,
  .navbar-custom .navbar-nav > .open >a {
      text-decoration: none;
      background-color:#6E7B8B;
  }

  .navbar-custom .navbar-brand {
      color:#eeeeee;
  }
  .navbar-custom .navbar-toggle {
      background-color:#eeeeee;
  }
  .navbar-custom .icon-bar {
      background-color:#33aa33;
  }
</style>

<body>
  <nav class="navbar navbar-custom navbar-static-top">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#mobile_menu" aria-expanded="false">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="/calendar">Meeting Room </a>
        <ul class="nav navbar-nav navbar-left">
          <li class="dropdown"><a href="/check_room">จองห้องประชุม</a></li>
          <li class="dropdown"><a href="/mybooking">รายการจองห้องประชุม</a></li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">ตั้งค่า <span class="caret"></span></a>
            <ul class="dropdown-menu" role="menu">
              <li><a href="/user">ผู้ใช้งาน</a></li>
              <li><a href="/room">ห้องประชุม</a></li>
              <li><a href="/food">อาหาร</a></li>
              <li><a href="/dessert">ของว่างและเครื่องดื่ม</a></li>
              <li><a href="/layout">รูปแบบห้อง</a></li>
              <li><a href="/tool">อุปกรณ์</a></li>
              <li><a href="/remark">หมายเหตุ</a></li>
            </ul>
          </li>
        </ul>

      </div>
  
      <div class="collapse navbar-collapse" id="mobile_menu">
        <ul class="nav navbar-nav navbar-right">
          <?php if (is_logged_in() === false): ?>
          <li><a href="/login">Login</a></li>
          <?php endif; ?>

          <?php if (is_logged_in() === true): ?>
          <li class="dropdown"> 
            <a href="#" 
              class="dropdown-toggle" 
              data-toggle="dropdown" 
              role="button" 
              aria-haspopup="true" 
              aria-expanded="false">
              <span class="glyphicon glyphicon-user"></span> <?php get_user_fullname();?> <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
              <li><a href="/user/profile"><span class="glyphicon glyphicon-pencil"></span> แก้ไขโปรไฟล์</a></li>
              <li><a href="/user/logout"><span class="glyphicon glyphicon-log-out"></span> ออกจากระบบ</a></li>
            </ul>
          </li>
          <?php endif; ?>
        </ul>
      </div>
    <!-- </div> -->
  </nav>
  
    <div class="row">
      <div class="col-md-12">
        <?=$this->section('content')?>
      </div>
    </div>

</body>
</html>

    