#!/bin/bash
resetcolors() {
	echo -n $'\e[0;30m'
}
PlistBuddy='/usr/libexec/PlistBuddy'
PLIST="/Users/admin/test.plist"
TMPFILE="/tmp/temp-download"
curl -s http://cdp.fcs.org/management/files.php?hostname=$(hostname) > $PLIST
NUMBEROFFILES=$(defaults read $PLIST NumberOfFiles)
X=0
while [ $X -lt $NUMBEROFFILES ]; do
	InstallLocation=$($PlistBuddy -c "print :$X:Location" $PLIST)
	URL=$($PlistBuddy -c "print :$X:URL" $PLIST)
	if [ -f $InstallLocation ]; then
		ServerHash=$($PlistBuddy -c "print :$X:Hash" $PLIST)
		CurrentHash=$(md5 -q $InstallLocation)
		if [[ $ServerHash != $CurrentHash ]]; then
			echo -e $'\e[32m'  "[$X] Updating" 
			(
				$($PlistBuddy -c "print :$X:PreScript" $PLIST) > /dev/null 2>&1 &&
				echo -e $'\e[32m'  "      |--Pre-Script"  || (echo -e $'\e[31m' "      |--Pre-Script Failed"  && learnfromfailure > /dev/null 2>&1)
			) && (
				curl -s -o $TMPFILE $URL > /dev/null 2>&1 && 
				test $ServerHash == $(md5 -q $TMPFILE) &&
				mv $TMPFILE $InstallLocation &&
				echo -e $'\e[32m'  "      |--Download"    || (echo -e $'\e[31m' "      |--Download Failed"    && learnfromfailure > /dev/null 2>&1)
			) && (
				$($PlistBuddy -c "print :$X:PostScript" $PLIST) > /dev/null 2>&1 &&
				echo -e $'\e[32m'  "      |--Post-Script" || (echo -e $'\e[31m' "      |--Post-Script Failed" && learnfromfailure > /dev/null 2>&1)
			) && (
				test -f $InstallLocation && test $ServerHash == $(md5 -q $InstallLocation) &&
				echo -e $'\e[32m'  "      |--Updated"     || echo -e $'\e[31m' "      |--Update Failed"
			)
		else
			echo -e $'\e[32m'" [$X] Already Installed"
		fi
	else
		echo -e $'\e[31m'  "[$X] Installing" 
		$($PlistBuddy -c "print :$X:PreScript" $PLIST) > /dev/null 2>&1 &&
		echo -e $'\e[32m'  "      |--Pre-Script"  || echo -e $'\e[31m' "      |--Pre-Script Failed"
		curl -s -o $InstallLocation $URL > /dev/null 2>&1 &&
		echo -e $'\e[32m'  "      |--Download"    || echo -e $'\e[31m' "      |--Download Failed"
		$($PlistBuddy -c "print :$X:PostScript" $PLIST) > /dev/null 2>&1 &&
		echo -e $'\e[32m'  "      |--Post-Script" || echo -e $'\e[31m' "      |--Post-Script Failed"
		test -f $InstallLocation && test $ServerHash == $(md5 -q $InstallLocation) &&
		echo -e $'\e[32m'  "      |--Installed"   || echo -e $'\e[31m' "      |--Installation Failed"
	fi
	resetcolors
	let X+=1
done
