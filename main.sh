#!/bin/bash

authFileName="authen.txt"
outputFileName=""

while getopts "c:o:" opt; do
  case $opt in
    o)
      outputFileName=$OPTARG
      touch "$outputFileName"
      ;;
    c)
      authFileName=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


show() {
	read -p "Do you want to see the contents of the directory (y/n) " usrInput
	case $usrInput in
		y)
			find demo/*
			;;
		n)
			;;
esac
}

auth() {
if [ ! -e "$authFileName" ]
then
	for i in $(find demo/*)
	do
		name="$i"
		ownerid="`stat -c %u $name`"
		ownername="`stat -c %U $name`"
		groupid="`stat -c %g $name`"
		accessmd="`stat -c %A $name`"
		datemod="`stat -c %Y $name`"
		if [ -d "$name" ]
		then
			sha1="hello dir"
			md5="dir hello"
		else
			sha1="`sha1sum $name | awk '{ print $1 }'`"
			md5="`md5sum $name | awk '{ print $1}'`"
		fi
		echo "$name $ownername $ownerid $groupid $accessmd $datemod $sha1 $md5" >> $authFileName
	done
fi
}

detect() {
echo "make changes to demo/. press Enter when finished:"
read _

if [ -e "current.txt" ]
then
	rm current.txt
else
	touch current.txt
fi
for i in $(find demo/*)
do
	name="$i"
	ownerid="`stat -c %u $name`"
	ownername="`stat -c %U $name`"
	groupid="`stat -c %g $name`"
	accessmd="`stat -c %A $name`"
	datemod="`stat -c %Y $name`"
	if [ -d "$name" ]
	then
		sha1="hello dir"
		md5="dir hello"
	else
		sha1="`sha1sum $name | awk {'print $1'}`"
		md5="`md5sum $name | awk {'print $1'}`"
	fi
	echo "$name $ownername $ownerid $groupid $accessmd $datemod $sha1 $md5" >> current.txt
done

cat current.txt | while read line
	do
		name=`echo $line | awk '{print $1}'`
		if ! grep -q "$name" authen.txt
		then
			echo "$name has been created"
			if [ -e "$outputFileName" ]
			then
				echo "$name has been created" >> $outputFileName
			fi
		fi
	done

cat $authFileName | while read line
	do
		name=`echo $line | awk '{print $1}'`
		ownername=`echo $line | awk '{print $2}'`
		ownerid=`echo $line | awk '{print $3}'`
		groupid=`echo $line | awk '{print $4}'`
		accessmd=`echo $line | awk '{print $5}'`
		datemod=`echo $line | awk '{print $6}'`
		sha1=`echo $line | awk '{print $7}'`
		md5=`echo $line | awk '{print $8}'`
		if [ -f "$name" ] || [ -d "$name" ]
		then
			if ! grep -q "$name.*$ownername.*$ownerid.*$groupid.*$accessmd.*$datemod*.*$sha1.*$md5" current.txt
			then
				echo "$name has been modified"
				if [ -e "$outputFileName" ]
				then
					echo "$name has been modified" >> $outputFileName
				fi
			fi
		else
			echo "$name has been deleted"
			if [ -e "$outputFileName" ]
			then
				echo "$name has been deleted" >> $outputFileName
			fi
		fi
	done

read -p "do these changes look correct (y/n) " response

case $response in
	y)
		cat current.txt > $authFileName
		rm current.txt
		;;
	n)
		echo "system has been compromised"
		;;
	*)
		echo "please respond yes or no"
		;;
esac
}



while :
do
	echo "1: Run IDS"
	echo "2: Exit"
	if [ ! -d 'demo' ]
	then
		mkdir demo demo/dir1 demo/dir2 demo/dir3 &&
		echo "demo file1" > demo/file1.txt &&
		echo "demo file2" > demo/file2.txt &&
		echo "demo file3" > demo/file3.txt
	fi
	read usr_input
	case $usr_input in
	1)
		show
		auth
		detect
    if [ -e "$outputFileName" ]
    then
      echo "saving output to $outputFileName"
      cat $outputFileName
    fi
		break
		;;

	2)
		break
		;;
	esac
done
