<?php
	header("Content-Type:application/json");
	verify_access_token();

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

	function get_num_sorry_or_not_sorry($email, $sorrynotsorry, $timestamp){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "SELECT countTodayRecordSorry('$email', '$timestamp')";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "SELECT countTodayRecordNotSorry('$email', '$timestamp')";
		}
		else{
			deliver_response(400, "invalid request", NULL);
			return NULL;
		}
		$result = mysqli_query($db, $query);
		$rows = array();
		if($sorrynotsorry == 'sorry'){
	   		while($r = mysqli_fetch_assoc($result)) {
		  		$rows['num_' . $sorrynotsorry][] = $r["countTodayRecordSorry('$email', '$timestamp')"];
		   	}
	   	}
	   	else{
	   		while($r = mysqli_fetch_assoc($result)) {
		  		$rows['num_' . $sorrynotsorry][] = $r["countTodayRecordNotSorry('$email', '$timestamp')"];
		   	}	   		
	   	}
	   	return $rows;
	}

	function get_num_sorry_or_not_sorry_over_week($email, $sorrynotsorry, $timestamp){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "CALL countWeekSorry('$email','$timestamp')";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "CALL countWeekNotSorry('$email', '$timestamp')";
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

	function get_num_sorry_or_not_sorry_over_month($email, $sorrynotsorry, $timestamp){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "CALL countMonthSorry('$email', '$timestamp')";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "CALL countMonthNotSorry('$email', '$timestamp')";
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

	function get_num_sorry_or_not_sorry_over_year($email, $sorrynotsorry, $timestamp){
		global $db;		
		if($sorrynotsorry == 'sorry'){				  
			$query = "CALL countYearSorry('$email', '$timestamp')";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "CALL countYearNotSorry('$email', '$timestamp')";
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

	function said_sorry_or_not_sorry($email, $sorrynotsorry, $timestamp){
		global $db;
		if($sorrynotsorry == 'sorry'){
			$query = "SELECT addNewRecordSorry('$email', '$timestamp')";
		}
		else if($sorrynotsorry == 'notsorry'){
			$query = "SELECT addNewRecordNotSorry('$email', '$timestamp')";
		}
		else{
			deliver_response(400, "invalid request", NULL);
			return NULL;
		}
		$result = mysqli_query($db, $query);
		$rows = array();
		if($sorrynotsorry == 'sorry'){
	   		while($r = mysqli_fetch_assoc($result)) {
		  		$rows['num_' . $sorrynotsorry][] = $r["addNewRecordSorry('$email', '$timestamp')"];
		   	}
		}
		else{
			while($r = mysqli_fetch_assoc($result)) {
		  		$rows['num_' . $sorrynotsorry][] = $r["addNewRecordNotSorry('$email', '$timestamp')"];
		   	}
		}
   		if($rows['num_' . $sorrynotsorry][0] == 1){
   			return true;
   		}
   		else{
   			return false;
   		}
	}
	
	function verify_access_token(){
		if(empty($_GET['access_token'])){
			deliver_response(401, "invalid request - no access token provided", NULL);
			die();
		}
		$json = curl_get_file_contents('https://graph.facebook.com/me?access_token=' . $_GET['access_token']);
		if($json == 'false'){
			deliver_response(401, "cannot connect to open graph", NULL);
                	die();
		}
		$data = json_decode($json, true);
		if(empty($data)){
			deliver_response(401, "cannot connect to open graph", NULL);
			die();
		}
		if(empty($data['error'])){
			if(!empty($data['id'])){
				return;
			}
			else{
				deliver_response(401, "invalid query to open graph", NULL);
			}
		}
		else{
			deliver_response(403, "invalid token", NULL);
			die();
		}
	}

	function curl_get_file_contents($URL) {
		$c = curl_init();
		curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($c, CURLOPT_URL, $URL);
		$contents = curl_exec($c);
		$err  = curl_getinfo($c,CURLINFO_HTTP_CODE);
		curl_close($c);
		if ($contents) return $contents;
		else return FALSE;
	}
