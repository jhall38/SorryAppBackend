<?php
	include('dbconnect.php');
	include('common.php');
	if(!empty($_GET['email'])){	
		$query = "SELECT * FROM tblPerson WHERE Email='" . $_GET['email'] . "'";
		mysqli_query($db, $query) or die('Error querying database.');
		$result = mysqli_query($db, $query);
		 $rows = array();
   		while($r = mysqli_fetch_assoc($result)) {
    		 $rows['user'][] = $r;
   		}
		//echo json_encode($rows);
		if(empty($rows)){
			deliver_response(200, "user not found", NULL);
		}
		else{
			deliver_response(200, "user found", $rows);
		}
	}
	else{
		//invalid request
		deliver_response(400, "invalid request", NULL);

	}

	


?>