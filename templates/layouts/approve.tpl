<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="x-ua-compatible" content="ie=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta charset="UTF-8">
	<title><?php echo APP_NAME;?></title>
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
  <link rel="icon" href="/favicon.ico" type="image/x-icon">
  <link rel="manifest" href="/manifest.json">
	<!-- CSS -->
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
  <script src="/assets/vitalets-datepicker/js/moment.min.js"></script>
  <script type="text/javascript" src="/assets/jonthornton/jquery.timepicker.js"></script>
  <script src="/assets/js/gotify.min.js"></script>
  
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
  <!-- <nav class="navbar navbar-default navbar-static-top"> -->
    <div class="container">
      <div class="navbar-header">
        
        <a class="navbar-brand"><img  src="/DN2.png" style="padding-left:10px;height:15px; width:auto;" /></a> 
        <a class="navbar-brand" href="#">แจ้งสถานะการขอใช้ห้องประชุม</a>

      </div>
  
      
    </div>
  </nav>
  
  <!-- GOTIFY -->
  <div class="gotify-overlay"></div>

  <div class="gotify">
    <div class="gotify-wrap">
        <div class="close-gotify" onclick="return close_gotify()"></div>
        <div class="gotify-content"></div>
    </div>
  </div>

  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <?=$this->section('content')?>
      </div>
    </div>
  </div>
  
</body>
</html>

    