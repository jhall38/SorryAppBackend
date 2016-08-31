<?php
	header("Content-Type:application/json");

	function deliver_response($status, $status_message, $data){
		header("HTTP/1.1 $status $status_message");

		$response['status'] = $status;
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

	function get_num_sorry_or_not_sorry($email, $sorrynotsorry){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "SELECT countTodayRecordSorry('$email', now())";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "SELECT countTodayRecordNotSorry('$email', now())";
		}
		else{
			deliver_response(400, "invalid request", NULL);
			return NULL;
		}
		$result = mysqli_query($db, $query);
		$rows = array();
		if($sorrynotsorry == 'sorry'){
	   		while($r = mysqli_fetch_assoc($result)) {
		  		$rows['num_' . $sorrynotsorry][] = $r["countTodayRecordSorry('$email', now())"];
		   	}
	   	}
	   	else{
	   		while($r = mysqli_fetch_assoc($result)) {
		  		$rows['num_' . $sorrynotsorry][] = $r["countTodayRecordNotSorry('$email', now())"];
		   	}	   		
	   	}
	   	return $rows;
	}

	function get_num_sorry_or_not_sorry_over_week($email, $sorrynotsorry){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "CALL countWeekSorry('$email')";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "CALL countWeekNotSorry('$email')";
		}
		else{
			deliver_response(400, "invalid request", NULL);
			return NULL;
		}
		$result = mysqli_query($db, $query);
		$rows = array();
   		while($r = mysqli_fetch_assoc($result)) {
	  		$rows['records'][] = $r;
	   	}
	   	return $rows;
	}

	function get_num_sorry_or_not_sorry_over_month($email, $sorrynotsorry){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "CALL countMonthSorry('$email')";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "CALL countMonthNotSorry('$email')";
		}
		else{
			deliver_response(400, "invalid request", NULL);
			return NULL;
		}
		$result = mysqli_query($db, $query);
		$rows = array();
   		while($r = mysqli_fetch_assoc($result)) {
	  		$rows['records'][] = $r;
	   	}
	   	return $rows;
	}

	function get_num_sorry_or_not_sorry_over_year($email, $sorrynotsorry){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "CALL countYearSorry('$email')";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "CALL countYearNotSorry('$email')";
		}
		else{
			deliver_response(400, "invalid request", NULL);
			return NULL;
		}
		$result = mysqli_query($db, $query);
		$rows = array();
   		while($r = mysqli_fetch_assoc($result)) {
	  		$rows['records'][] = $r;
	   	}
	   	return $rows;
	}

	function said_sorry_or_not_sorry($email, $sorrynotsorry){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "SELECT addNewRecordSorry('$email', now())";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "SELECT addNewRecordNotSorry('$email', now())";
		}
		else{
			deliver_response(400, "invalid request", NULL);
			return NULL;
		}
		$result = mysqli_query($db, $query);
		$rows = array();
		if($sorrynotsorry == 'sorry'){
	   		while($r = mysqli_fetch_assoc($result)) {
		  		$rows['num_' . $sorrynotsorry][] = $r["addNewRecordSorry('$email', now())"];
		   	}
		}
		else{
			while($r = mysqli_fetch_assoc($result)) {
		  		$rows['num_' . $sorrynotsorry][] = $r["addNewRecordNotSorry('$email', now())"];
		   	}
		}
   		if($rows['num_' . $sorrynotsorry][0] == 1){
   			return true;
   		}
   		else{
   			return false;
   		}
	}