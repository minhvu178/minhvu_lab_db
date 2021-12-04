<html>
     <head>
     <title>PHP Test Page</title>
     </head>
     <body>
     <?php echo "Hello world!"; ?>     
     <?php phpinfo(); ?>

     <?php
          echo $_SERVER['HTTP_USER_AGENT'];
     ?>
     <?php
          if (strpos($_SERVER['HTTP_USER_AGENT'], 'Safari') !== FALSE) {
          echo 'You are using Safari.<br />';
          }
     ?>
     <?php
          if (strpos($_SERVER['HTTP_USER_AGENT'], 'Safari') !== FALSE) {
     ?>
          <h3>strpos() must have returned non-false</h3>
          <p>You are using Safari</p>
     <?php
          } else {
     ?>
          <h3>strpos() must have returned false</h3>
          <p>You are not using Safari</p>
     <?php
          }
     ?>
     <form action="action.php" method="post">
          <p>Your name: <input type="text" name="name" /></p>
          <p>Your age: <input type="text" name="age" /></p>
          <p><input type="submit" /></p>
     </form>
     </body>
</html>