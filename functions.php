<?php
	include('dbconnect.php');
	header("Content-Type:application/json");

	function deliver_response($status, $status_message, $data){
		header("HTTP/1.1 $status $status_message");

		$response['stauts'] = $status;
		$response['status_message'] = $status_message;
		$response['data'] = $data;

		$json_response = json_encode($response);
		echo $json_response;
	}

	function get_users(){
		global $db;
		$query = "SELECT * FROM tblPerson";
		$result = mysqli_query($db, $query);
		while($r = mysqli_fetch_assoc($result)) {
	   		 $rows['user'][] = $r;
	   	}
	   	return $rows;
	}

	function get_user($email){
		global $db;
		$query = "SELECT * FROM tblPerson WHERE Email='$email'";
		$result = mysqli_query($db, $query);
		$rows = array();
   		while($r = mysqli_fetch_assoc($result)) {
	  		$rows['user'][] = $r;
	   	}
	   	return $rows;
	}