<?php
	include('dbconnect.php');
	include('functions.php');

	if(!empty($_GET['sorrynotsorry'])){
		if($_GET['sorrynotsorry'] == 'sorry'){
			$query = "CALL countLeaderSorry()";
		}
		else if($_GET['sorrynotsorry'] == 'notsorry'){
			$query = "CALL countLeaderNotSorry()";
		}
		else{
			deliver_response(400, "invalid request", NULL);
			die();
		}
		$result = mysqli_query($db, $query);
		$rows = array();
		while($r = mysqli_fetch_assoc($result)) {
			$rows['user'][] = $r;
		}
		if(!empty($rows)){
			deliver_response(200, "success!", $rows);
		}
		else{
			deliver_response(404, "users not found", $rows);
		}
	}
	else{
		deliver_response(400, "invalid request", NULL);
	}








?>