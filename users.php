<?php
	include('dbconnect.php');
	include('functions.php');

	if($_SERVER['REQUEST_METHOD'] == 'GET'){
		if(!empty($_GET['email'])){	
			$user = get_user($_GET['email']);
			if(empty($rows)){
				deliver_response(200, "user not found", NULL);
			}
			else{
				deliver_response(200, "user found", $user);
			}
		}
		else{
	   		$users = getUsers();
	   		if(empty($users)){
				deliver_response(200, "no users are in the database", NULL);
			}
			else{
				deliver_response(200, "list of all users", $users);
			}
		}
	}
	else if($_SERVER['REQUEST_METHOD'] == 'POST'){
		$email = $_POST['email'];
		$first_name = $_POST['first_name'];
		$last_name = $_POST['last_name'];
		$gender = $_POST['gender'];
		$dob = $_POST['dob'];
		$query = "SELECT addNewPerson('$email','$first_name','$last_name', '$gender', '$dob')";
		$result = mysqli_query($db, $query);
		if($result){
			while($r = mysqli_fetch_assoc($result)) {
	   			$rows['result'][] = $r;
	   		}
	   		if($rows['result'][0]["addNewPerson('$email','$first_name','$last_name', '$gender', '$dob')"] == 1){
	   			deliver_response(200, "user successfully added", NULL);
			}
			else{
				deliver_response(200, "user already exists", NULL);
			}
		}
		else{
			deliver_response(400, "invalid request", NULL);
		}
	}
?>