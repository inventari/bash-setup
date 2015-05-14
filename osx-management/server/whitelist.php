<?php
	$sqlconnection = mysqli_connect("localhost", "sqlusername", "sqlpassword", "management");
    
    // Check connection
    if (mysqli_connect_errno()) {
        echo "FALSE";
    } else {    
		// Create connection
		$result = mysqli_query($sqlconnection, "SELECT * FROM `whitelist`"); // Create connection
	
		while ($row = mysqli_fetch_array($result)) {
			foreach (explode(',', $row['url']) as $url) {
				$rx = $row['subdomains'];
				for ($x = 0; $x <= $rx; $x++) {
					for ($z = 0; $z < $x; $z++){
						echo "*.";
					}
					echo  $url . ' ';
				}
			}
		}
    }
?>
