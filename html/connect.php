<?php


    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    if (!function_exists('mysqli_init') && !extension_loaded('mysqli')) {
        echo 'We don\'t have mysqli!!!';
    } else {
        echo 'Phew we have it!';
    }

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

    $dblist = 'SHOW databases';
    $result = $conn->query($dblist);
    while ($dbname = $result->fetch_array()) {
        echo $dbname['Database'] . "<br>";
    }

    $conn->close();
?>

<form action="details.php" method="POST">
    <pre>Database name: <input type="text"
        name="request_name">
    </pre>
    <input type="submit" />
</form>
