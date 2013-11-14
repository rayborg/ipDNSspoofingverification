#!/bin/bash
#Script to do reverse DNS and then forward DNS to Help
#verify that IP addresses are not spoofing their domain legitimate crawlers
cat $1 | while read line; 
do 
	temprDNS=$(host $line | grep -o "pointer.*" | grep -o " .*" | sed 's/^ *//g')
	
	#If the reverseDNS finds a domain then do a forward DNS
	if [ ! -z "$temprDNS" -a "$temprDNS" != " " ] && [[ "$temprDNS" != *$line* ]]
	then
	tempfDNS=$(host $temprDNS | grep -o "address.*" | grep -o " .*" | sed 's/^ *//g')
		
		#IF forward DNS finds the IP address for the domain then grep it out and print 
		if [ ! -z "$tempfDNS" -a "$tempfDNS" != " " ]; then
        
			#If reverse and forward DNS succeds compare result to original IP
			if [ "$line" == "$tempfDNS" ]; then
			echo $line $temprDNS
			else
			echo $line "IS Spoofing its Domain Name" $temprDNS
			fi

		fi
	#This else optional to list IPs that don't map with rDNS to any Domain	
	else
	echo $line "does not map to a domain"
	fi
done
