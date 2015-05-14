<?php

	$sqlconnection = mysqli_connect("localhost", "management", "manage", "management");
    // Check connection
    if (mysqli_connect_errno()) {
        echo "FALSE";
    } else {
		$host = str_replace(".local", "", str_replace("fda-", "", $_GET['hostname']));
		echo "##" . PHP_EOL;
		echo "# Host Database" . PHP_EOL;
		echo "#" . PHP_EOL;
		echo "# localhost is used to configure the loopback interface" . PHP_EOL;
		echo "# when the system is booting.  Do not change this entry." . PHP_EOL;
		echo "##" . PHP_EOL;
		echo "127.0.0.1	localhost" . PHP_EOL;
		echo "255.255.255.255	broadcasthost" . PHP_EOL;
		echo "::1             localhost " . PHP_EOL;
		
		// Create connection
		$result = mysqli_query($sqlconnection, "SELECT * FROM `blacklist` WHERE  `scope` LIKE  '%all%' AND `scope` NOT LIKE  '%-" . $host . "%'"); // Create connection
	
		while ($row = mysqli_fetch_array($result)) {
			echo PHP_EOL;
			echo "# " . $row['human-readable-name'] . PHP_EOL;
			foreach (explode(',', $row['dns-name']) as $dns) {
				echo $row['ip-address'] . '	' . $dns . PHP_EOL;
			}
		}
	
		$result = mysqli_query($sqlconnection, "SELECT * FROM `blacklist` WHERE  `scope` LIKE  '%" . $host . "%' AND `scope` NOT LIKE  '%all%'"); // Create connection
	
		while ($row = mysqli_fetch_array($result)) {
			echo PHP_EOL;
			echo "# " . $row['human-readable-name'] . PHP_EOL;
			foreach (explode(',', $row['dns-name']) as $dns) {
				echo $row['ip-address'] . '	' . $dns . PHP_EOL;
			}
		}
    }
?>
