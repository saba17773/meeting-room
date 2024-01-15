<?php 
$this->layout('layouts/calendar'); 

// use App\Room\RoomAPI;
// $data = (new ReportAPI)->getAllbyDay();
?>

<style type="text/css">
	table, th, td {
	    border: 1px solid white;
	    border-collapse: collapse;
	    padding: 5px;
	    text-align: center;
	}
</style>


<div class="container">
	<h3>รายงานจองการใช้ห้องประชุม</h3>

	<?php 
		// $format= 'Y-m-d'; 
		// $start= '2018-08-09';
		// $end= '2018-08-30'; 
		// $skip = NULL;

		// $output = array();
	 //    $days   = floor((strtotime($end) - strtotime($start))/86400);
	    
	 //    for($i=0;$i<=$days;$i++){
	 //      $in_period = strtotime("+" . $i . " day", strtotime($start));
	 //      if(is_array($skip) and !in_array(date("D",$in_period), $skip)){
	 //        continue;
	 //      }
	 //      array_push($output, date($format, $in_period));
	 //    }

	 //    echo "<pre>".print_r($output,true)."</pre>";
	    // return $output;
	$get_id=["1","2","3"];
	$get_product=["apple","oppo","vivo"];
	$get_comment=["good","very good","bad"];

	foreach($get_id as $i => $id){
	    $product = $get_product[$i];
	    $comment = $get_comment[$i];
	    echo $id ."-". $product ."-". $comment."<br/>";
	}

	?>	
</div>

<!-- TESTING -->

<table>
	<tr>
		<td>
			<label>เพิ่มรายการอาหาร</label>

		</td>
		<td>
			<select class="form-control" name="selected_food" id="selected_food">
				<option value="0">=เลือก=</option>
				<option value="1">=อาหารคาว=</option>
				<option value="2">=อาหารเส้น=</option>
			</select><br><br><br><br>
		</td>
	</tr>
	<tr>
	    <td>
	      <label>รายาละเอียดอาหารอาหาร</label>
	    </td>
	    <td colspan="2" align="right">
	      <div id="listfood">
		      <input name="food" id="food" type="button" class="btn btn-info" value="+" style="font-size: 1.2em;"><br>
		      <div class="well">
		        <span id="mySpanfoodAdd"></span>
		      </div>
	      </div>
	    </td>
	</tr>
</table>

<script type="text/javascript">
	jQuery(document).ready(function($) {
		// $('#listfood').hide();

		$('#selected_food').on('change',function(event) {
			alert("change");
		});

	  	var i =1;
	  	$('#food').bind('click',function(){

	    var plus ="plus"+i;
	    var selected ="selected"+i;
	    var inputed  ="inputed"+i;
	    var br = "br"+i;
	    var united = "united"+i; 

	    $('#mySpanfoodAdd').append("<button id='"+plus+"' onclick='removeEle("+plus+','+selected+','+br+','+inputed+','+united+ ")' type='button' class='btn btn-info'>-</button><select name='food[]' id='"+selected+"' required></select> <input type='text' name='food_unit[]' id='"+inputed+"' style='width: 50px' required class='allownumberdecimal'> <label id='"+united+"'>หน่วย</label><button id='"+plus+"' type='button' class='btn btn-info' onclick='showpicfood("+selected+");'><span class='glyphicon glyphicon-search' style='font-size:15px;'></span></button><br id='"+br+"'>");

	    getFood()
		    .done(function(data) {
		        $("#"+selected+"").html("<option value=''>=Select=</option>");
		        $.each(data, function(indax, val) {
		          $("#"+selected+"").append('<option value="'+val.food_id+'">'+val.food_name+'</option>');
		        });
		    });

		    $(".allownumberdecimal").on("keypress keyup blur",function (event) {    
		       $(this).val($(this).val().replace(/[^\d].+/, ""));
		        if ((event.which < 48 || event.which > 57)) {
		            event.preventDefault();
		        }
		    });

		    i++;
		});

  	});

	function getFood() {
	    return $.ajax({
	      url : '/food/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}

	function removeEle(divid,_divid,divbr,divinput,divstrunit){
	    $(divid).remove(); 
	    $(_divid).remove();
	    $(divbr).remove(); 
	    $(divinput).remove(); 
	    $(divstrunit).remove();
	} 
</script>
