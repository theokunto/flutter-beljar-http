<?php
$db = "upj";
$host = "localhost";
$db_user = 'root'; $db_password = '';
//MySql server and database info
$link = mysqli_connect($host, $db_user, $db_password, $db);
//connecting to database
$json["error"] = false; $json["errmsg"] = ""; $json["data"] = array();
$sql = "SELECT * FROM mahasiswa ORDER BY nim";
$res = mysqli_query($link, $sql); $numrows = mysqli_num_rows($res);
if($numrows > 0){
//check if there is any data 
    $namelist = array();
while($array = mysqli_fetch_assoc($res)){ array_push($json["data"], $array);
//push fetched array to $json["data"] 
}
}else{
$json["error"] = true;
$json["errmsg"] = "No any data to show."; }
mysqli_close($link);
header('Content-Type: application/json'); // tell browser that its a json data
echo json_encode($json);
?>
