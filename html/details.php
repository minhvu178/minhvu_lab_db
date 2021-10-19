<?php

    $request_name = "SHOW TABLES FROM " . $_POST['request_name'].";";

    $dbhost = 'localhost';
    $dbuser = 'Minhvu';
    $dbpass = 'minhvu178';
    $conn = new MySQLi($dbhost, $dbuser, $dbpass);
    if ($conn->connect_errno) {
        echo "Error: Failed to make a MySQL connection,
              here is why: ". "<br>";
        echo "Errno: " . $conn->connect_errno . "\n";
        echo "Error: " . $conn->connect_error . "\n";
        exit; // Quit this PHP script if the connection fails.
    } else {
        echo "Connected Successfully!" . "<br>";
        echo "YAY!" . "<br>";
    }


    $result = $conn->query($request_name);


    while ($dbname = $result->fetch_array()) {?>
        <li><?php echo $dbname[0] . "<br>";?></li>
        <?php
    }

    $conn->close();
?>