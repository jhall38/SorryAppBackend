<?php
	include('dbconnect.php');
	include('functions.php');
	if($_SERVER['REQUEST_METHOD'] == 'GET'){
		if(!empty($_GET['email'])){
			$user = get_user($_GET['email']);
			if(empty($user)){
				deliver_response(404, "user not found", NULL);
			}
			else{
				deliver_response(200, "user found", $user);
			}
		}
		else{
	   		$users = get_users();
	   		if(empty($users)){
				deliver_response(404, "no users are in the database", NULL);
			}
			else{
				deliver_response(200, "list of all users", $users);
			}
		}
	}
	else if($_SERVER['REQUEST_METHOD'] == 'POST'){
		if(!empty($_POST['email']) && !empty($_POST['first_name']) && !empty($_POST['last_name']) && !empty($_POST['gender'])){
			$email = $_POST['email'];
			$first_name = $_POST['first_name'];
			$last_name = $_POST['last_name'];
			$gender = $_POST['gender'];
			$query = "SELECT addNewPerson('$email','$first_name','$last_name','$gender')";
			$result = mysqli_query($db, $query);
			if($result){
				while($r = mysqli_fetch_assoc($result)) {
		   			$rows['result'][] = $r;
		   		}
				print_r($rows['result'][0]);
		   		if($rows['result'][0]["addNewPerson('$email','$first_name','$last_name','$gender')"] == 1){
		   			deliver_response(200, "user successfully added", NULL);
				}
				else{
					deliver_response(400, "user already exists", NULL);
				}
			}
			else{
				deliver_response(400, "invalid request!!", NULL);
			}
		}
		else{
			deliver_response(400, "invalid request", NULL);
		}
	}
?>
