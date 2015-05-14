<?php

	$sqlconnection = mysqli_connect("localhost", "sqlusername", "sqlpassword", "management");
    // Check connection
    if (mysqli_connect_errno()) {
        echo "FALSE";
    } else {
    	$host = str_replace(".local", "", str_replace("fda-", "", $_GET['hostname']));
		$result = mysqli_query($sqlconnection, "SELECT * FROM `files` WHERE  `scope` LIKE  '%all%' AND `scope` NOT LIKE  '%-" . $host . "%'"); // Create connection
		while ($row = mysqli_fetch_array($result)) {
			$filelistmeta[$row['id']]['id']    = $row['id'];
			$filelistmeta[$row['id']]['il']    = $row['install-location'];
			$filelistmeta[$row['id']]['hash']  = $row['hash'];
			$filelistmeta[$row['id']]['pre']   = $row['pre-instructions'];
			$filelistmeta[$row['id']]['url']   = $row['file-url'];
			$filelistmeta[$row['id']]['post']  = $row['post-instructions'];
		}
		$result = mysqli_query($sqlconnection, "SELECT * FROM `files` WHERE  `scope` LIKE  '%" . $host . "%' AND `scope` NOT LIKE  '%all%'"); // Create connection
		while ($row = mysqli_fetch_array($result)) {
			$filelistmeta[$row['id']]['id']    = $row['id'];
			$filelistmeta[$row['id']]['il']    = $row['install-location'];
			$filelistmeta[$row['id']]['hash']  = $row['hash'];
			$filelistmeta[$row['id']]['pre']   = $row['pre-instructions'];
			$filelistmeta[$row['id']]['url']   = $row['file-url'];
			$filelistmeta[$row['id']]['post']  = $row['post-instructions'];
		}
		
		echo '<?xml version="1.0" encoding="UTF-8"?>' . PHP_EOL;
		echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' . PHP_EOL;
		echo '<plist version="1.0">'. PHP_EOL;
		echo '<dict>' . PHP_EOL;
		$x = 0;
		foreach ($filelistmeta as $filemeta) {
			echo '<key>'. ($x) .'</key>' . PHP_EOL;
			echo '<dict>' . PHP_EOL;
			echo '<key>SQLFileID</key>'     . PHP_EOL;
			echo '<string>' . $filemeta['id']   . '</string>' . PHP_EOL;
			echo '<key>Location</key>'   . PHP_EOL;
			echo '<string>' . $filemeta['il']   . '</string>' . PHP_EOL;
			echo '<key>Hash</key>'       . PHP_EOL;
			echo '<string>' . $filemeta['hash'] . '</string>' . PHP_EOL;
			echo '<key>PreScript</key>'  . PHP_EOL;
			echo '<string>' . $filemeta['pre']  . '</string>' . PHP_EOL;
			echo '<key>URL</key>' 		 . PHP_EOL;
			echo '<string>' . $filemeta['url']  . '</string>' . PHP_EOL;
			echo '<key>PostScript</key>' . PHP_EOL;
			echo '<string>' . $filemeta['post'] . '</string>' . PHP_EOL;
			echo '</dict>' . PHP_EOL;
			$x++;
		}
		echo '<key>NumberOfFiles</key>' . PHP_EOL;
		echo '<integer>' . $x . '</integer>' . PHP_EOL;
		echo '</dict>' . PHP_EOL;
		echo '</plist>' . PHP_EOL;
    }
?>
