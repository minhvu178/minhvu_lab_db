<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="basic.css">
</head>
<body>
    <h1>Delete Instruments</h1>
<?php 

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

    // echo $_POST['crag_name'];
    // if ($_GET['crag_name']) {
    //     $query = "SELECT * FROM climbs WHERE crag_name = ?";
    //     $stmt = $conn->prepare($query);
    //     $stmt->bind_param('s', $_GET['crag_name']);
    // } else {
    //     $query = "SELECT * FROM climbs";
    //     $stmt = $conn->prepare($query);
    //     $stmt->bind_param();
    // }


    // $stmt->execute();
    // $result = $stmt->get_result();
    // $conn->close();
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
        if (isset($_POST['delete_selected']) && isset($_POST["checkbox$id"]) && !$del_stmt->execute()) {
            echo $conn->error;
        }
    }

    $res = $conn->query($query);
    result_to_table($res);
     
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
    <input name="delete_all" type="submit" value="Delete All Records" method=POST/>

    </form>
<?php
}
?>

<form action="manageInstruments.php" method = POST>
    <input type="submit" value="Add records" method = POST name = "add"/>
</form>


