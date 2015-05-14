#!/bin/bash
####################################################################################################

resetcolors() { echo -n $'\e[0;30m'; }

####################################################################################################

SERVER="http://cdp.fcs.org/"
PlistBuddy='/usr/libexec/PlistBuddy'
PLIST="/Library/Preferences/com.inventarislabs.fda.fileinstaller.plist"
TMPFILE="/tmp/temp-download"

####################################################################################################

#checks for connection to server
if [[ $(ping -t 6 -o -q $(echo $SERVER | sed 's/^http.\:\/\///' | sed 's/\/$//') > /dev/null 2>&1 && echo 1 || echo 0) -eq 1 ]]; then

    #checks if plist file is newer than 30 min
    if [ "$(find $PLIST -mtime -0h30m)" == "" ]; then
        echo -e $'\e[32m'"Downloading PLIST"
        ## get plist from server
        curl -s $SERVER'management/files.php?hostname='$(hostname) > $PLIST
    fi

    NUMBEROFFILES=$(defaults read $PLIST NumberOfFiles)
    X=0
    while [ $X -lt $NUMBEROFFILES ]; do

        InstallLocation=$($PlistBuddy -c "print :$X:Location" $PLIST)
        URL=$SERVER$($PlistBuddy -c "print :$X:URL" $PLIST)
        ServerHash=$($PlistBuddy -c "print :$X:Hash" $PLIST)

        if [ -f $InstallLocation ]; then
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
                    echo -e $'\e[32m'  "      |--Downloaded"  || (echo -e $'\e[31m' "      |--Download Failed"    && learnfromfailure > /dev/null 2>&1)
                ) && (
                    $($PlistBuddy -c "print :$X:PostScript" $PLIST) > /dev/null 2>&1 &&
                    echo -e $'\e[32m'  "      |--Post-Script" || (echo -e $'\e[31m' "      |--Post-Script Failed" && learnfromfailure > /dev/null 2>&1)
                ) && (
                    test -f $InstallLocation && test $ServerHash == $(md5 -q $InstallLocation) &&
                    echo -e $'\e[32m'  "      |--Updated"     ||  echo -e $'\e[31m' "      |--Update Failed"
                )
            else
                echo -e $'\e[32m'" [$X] Already Installed"
            fi
        else
            echo -e $'\e[34m'  "[$X] Installing"
            (
            $($PlistBuddy -c "print :$X:PreScript" $PLIST) > /dev/null 2>&1 &&
            echo -e $'\e[32m'  "      |--Pre-Script"  || (echo -e $'\e[31m' "      |--Pre-Script Failed"  && learnfromfailure > /dev/null 2>&1)
            ) && (
            curl -s -o $TMPFILE $URL > /dev/null 2>&1 &&
            test $ServerHash == $(md5 -q $TMPFILE) &&
            mv $TMPFILE $InstallLocation &&
            echo -e $'\e[32m'  "      |--Downloaded"  || (echo -e $'\e[31m' "      |--Download Failed"    && learnfromfailure > /dev/null 2>&1)
            ) && (
            $($PlistBuddy -c "print :$X:PostScript" $PLIST) > /dev/null 2>&1 &&
            echo -e $'\e[32m'  "      |--Post-Script" || (echo -e $'\e[31m' "      |--Post-Script Failed" && learnfromfailure > /dev/null 2>&1)
            ) && (
            test -f $InstallLocation && test $ServerHash == $(md5 -q $InstallLocation) &&
            echo -e $'\e[32m'  "      |--Installed"   ||  echo -e $'\e[31m' "      |--Install Failed"
            )
        fi
        let X+=1
    done
else
    echo -e $'\e[31m'"Server Not Detected"
fi

resetcolors

####################################################################################################
