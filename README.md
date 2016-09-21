API ENDPOINTS AND REQUESTS

<b>http://sorryapp.canadacentral.cloudapp.azure.com/SorryAppBackend/users.php</b>  
GET (no params) -> gets all users  
GET (email) -> gets a particular user  
POST (email, first_name, last_name, gender, dob) -> Adds a new user  

<b>http://sorryapp.canadacentral.cloudapp.azure.com/SorryAppBackend/sorrynosorry.php</b>  
GET (email, sorrynotsorry, timestamp) -> gets the number of sorries or not sorries of a particular user that day, depending on whether sorrynotsorry is 'sorry' or 'notsorry'.  
GET (email, sorrynotsorry, type, timestamp) -> gets the number of sorries or not sorries of a particular user that week, month, or year depending on value of type.  
POST (email, sorrynotsorry, timestamp) -> adds a sorry or not sorry record to a user.  

<b>http://sorryapp.canadacentral.cloudapp.azure.com/SorryAppBackend/leaderboard.php</b>  
GET (sorrynotsorry) -> gets the top 10 users who have said soryy or not sorry spanning all of time.  

timestamp must be in the format of YYYY-MM-DD HH:MM:SS
