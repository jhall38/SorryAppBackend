http://localhost/SorryAppBackend/users.php  
GET (no params) -> gets all users  
GET (email) -> gets a particular user  
POST (email, first_name, last_name, gender, dob) -> Adds a new user  

http://localhost/SorryAppBackend/sorrynosorry.php  
GET (email, sorrynotsorry) -> gets the number of sorries or not sorries of a particular user that day.  
GET (email, sorrynotsorry, type) -> gets the number of sorries or not sorries of a particular user that week, month, or year depending on value of type. If type is 'leader', return the top 10 users who have said soryy or not sorry spanning all of time.  
POST (email, sorrynotsorry) -> adds a sorry or not sorry record to a user.  
