<!DOCTYPE html>
<html>
<head>
    
    <link rel="stylesheet" href="basic.css">
</head>
<body>
    <h1>Delete Instruments</h1>
<?php 
    $reload = false;
    if (!isset($_COOKIE["dark"])){
        setcookie("dark", "false", 0, '/', '', false, true);
    }
    if ($_POST["light_dark"]){
        if ($_COOKIE["dark"] == "true"){
            setcookie("dark", "false", 0, '/', '', false, true);
        }
        else {
            setcookie("dark", "true", 0, '/', '', false, true);
        }
        $reload = true;
    }

    if ($_COOKIE["dark"]=="true") {
        ?>  <link rel="stylesheet" href="darkmode.css"> <?php 
    }
    session_start();
    if (isset($_POST["log_out"])){
        session_unset();
        $reload =true;
    }
    if (isset($_POST["username"])){
        $_SESSION['user_id'] = $_POST["username"];
        $_SESSION['count'] = 0;
        $reload = true;
    }
    // $_POST["light_dark"] = TRUE;
    // if (isset($_POST["light_dark"])){
    //     unset()
    // }


    if (isset($_SESSION['user_id'])) {
       ?><h2><?php echo "Welcome " . $_SESSION['user_id'];?>  </h2> 
        <form action="manageInstruments.php" method = POST>
            <input type="submit" value="Log out" method = POST name = "log_out"/>
        </form><?php
      } else {?>
        <form action="manageInstruments.php" method = POST>
            <h3><label for="username">Username: </label></h3>
            <input type="text" name="username"><br>
            <input type="submit" value="Login">
        </form><?php
      }

    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    
    $dbhost = "localhost";
    $dbuser = "Minhvu";
    $dbpass = "minhvu178";
    $dbname = "instrument_rentals";
    
    if (!$conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname)){
        echo "Error: Failed to make a MySQL connection: " . "<br>";
        echo "Errno: $conn->connect_errno; i.e. $conn->connect_error \n";
        exit;
   }


    if (isset($_POST["add"])){
        $conn->query("INSERT INTO instruments (instrument_type)
                        VALUES ('Guitar'),
                                ('Trumpet'),
                                ('Flute'),
                                ('Theremin'),
                                ('Violin'),
                                ('Tuba'),
                                ('Melodica'),
                                ('Trombone'),
                                ('Keyboard');");
    }

    $query = "SELECT instrument_id, instrument_type FROM instruments;";
    $res = $conn->query($query);

    $nrows = $res->num_rows;
    $ncols = $res->field_count;
    $resar = $res->fetch_all();

    $del_stmt = $conn->prepare("DELETE FROM instruments WHERE instrument_id = ?");
    $del_stmt->bind_param('i', $id);
    for ($i = 0; $i < $nrows; $i++){
        $id = $resar[$i][0];
        if (isset($_POST['delete_selected']) && isset($_POST["checkbox$id"]) && $del_stmt->execute()) {
            $_SESSION['count']++;
        } else {
            echo $conn->error;
        }
    }

    if ($reload){
        header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
        exit();
    }

    $res = $conn->query($query);
    result_to_table($res);
    if (isset($_SESSION['user_id'])) {
        ?><h3> <?php echo "You have deleted " . $_SESSION['count'] . " records this session." ?> </h3><?php
    }
    else {
        ?><h3> <?php echo "You have deleted no records this session." ?> </h3><?php
    }
    ?> 

    
    
    <form action="manageInstruments.php" method = POST>
        <input type="submit" value="Toggle light/dark mode" method = POST name = "light_dark"/>
    </form>
    <?php

?>
</body>
</html>
<?php

function result_to_table($res) {


    $nrows = $res->num_rows;
    $ncols = $res->field_count;
    $resar = $res->fetch_all();



    ?> 
    <p>
    <?php echo $ncols; ?> columns, <?php echo $nrows; ?> rows.
    </p>
    <form action="manageInstruments.php" method=POST>

        <table>
        <thead>
            <tr>
                <th>Delete?</th>
                <?php
                while ($fld = $res->fetch_field()) {
                ?>
                    <th><?php echo $fld->name; ?></th>
                <?php
                }
                ?>
            </tr>
        </thead>
    <tbody>
        <?php
        for ($i=0;$i<$nrows; $i++) {
        ?>
        <tr>
            <?php
                $id = $resar[$i][0];
                ?>
                <td><input type="checkbox"
                            name="checkbox<?php echo $id?>"
                            value=<?php echo $id ?>
                /></td><?php
                for ( $j = 0; $j < $ncols; $j++ ) {
            ?>
                <td>
                <?php echo $resar[$i][$j]; ?></td>
            <?php
                }
        ?>        
        </tr>
    <?php
    }
    ?>
    </tbody>
    <?php 


    // for ($i = 0; $i < $nrows; $i++){
    //     $id = $resar[$i][0];
    //     if (isset($_POST['delete_selected']) && isset($_POST["checkbox$id"]) && !$del_stmt->execute()) {
    //         echo $conn->error;
    //     }
    // }
    
        if (isset($_POST['delete_all'])) {
            $query = "DELETE * FROM instruments";
            $result = $conn->query($query);
        }

    ?>
    </table>
    <input name="delete_selected" type="submit" value="Delete Selected Records" method=POST/>

    </form>
<?php
}
?>

<form action="manageInstruments.php" method = POST>
    <input type="submit" value="Add records" method = POST name = "add"/>
</form>


