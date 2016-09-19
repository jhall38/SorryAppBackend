<?php 
	include('dbconnect.php');
	include('functions.php');

	if($_SERVER['REQUEST_METHOD'] == 'GET'){
		if(!empty($_GET['email']) && !empty($_GET['sorrynotsorry'])){
			if(empty($_GET['type'])){
				if ($_GET['sorrynotsorry'] != "sorry" and $_GET['sorrynotsorry'] != "notsorry") {
				   deliver_response(400, "invalid request", NULL);
				   return;
				}
				$num = get_num_sorry_or_not_sorry($_GET['email'], $_GET['sorrynotsorry'], $_GET['timestamp']);
			}
			else{
			        if ($_GET['sorrynotsorry'] != "sorry" and $_GET['sorrynotsorry'] != "notsorry") {
                                   deliver_response(400, "invalid request", NULL);
                                   return;
                                }
				switch($_GET['type']){
					case 'week':
						$num = get_num_sorry_or_not_sorry_over_week($_GET['email'], $_GET['sorrynotsorry'], $_GET['timestamp']);
						break;
					case 'month':
						$num = get_num_sorry_or_not_sorry_over_month($_GET['email'], $_GET['sorrynotsorry'], $_GET['timestamp']);
						break;
					case 'year':
						$num = get_num_sorry_or_not_sorry_over_year($_GET['email'], $_GET['sorrynotsorry'], $_GET['timestamp']);
						break;
					default: 
						deliver_response(400, "invalid request", NULL);
						die();
						break;
				}
			}
			if(empty($num)){
				deliver_response(404, "user not found", NULL);
			}
			else{
				deliver_response(200, "success", $num);
			}
		}
		else{
			deliver_response(400, "invalid request", NULL);
		}
	}
	else if($_SERVER['REQUEST_METHOD'] == 'POST'){
		if(!empty($_POST['email']) && !empty($_POST['sorrynotsorry']) && 
			($_POST['sorrynotsorry'] == "sorry" || $_POST['sorrynotsorry'] == "notsorry")){
			if(!empty(get_user($_POST['email']))){
				$success = said_sorry_or_not_sorry($_POST['email'], $_POST['sorrynotsorry'], $_POST['timestamp']);
				if($success){
					deliver_response(200, "record succesfully updated", NULL);
				}
				else{
					deliver_response(400, "invalid request", NULL);
				}
			}
			else{
				deliver_response(200, "user does not exist", NULL);
			}
		}
		else{
			deliver_response(400, "invalid request", NULL);
		}
	}
?>