#!/usr/bin/env zsh
anyconnect="/opt/cisco/anyconnect/bin/vpn"
if $anyconnect status | grep -q "state: Connected"; then 
	if read -q "choice? VPN [+], do you want to switch it OFF? [y/n] "; then 
		/opt/cisco/anyconnect/bin/vpn disconnect
		echo
		echo "VPN is disconnected [-], press any key to exit..."; read -k1 -s
	else 
		echo
		echo "No action, press any key to exit..."; read -k1 -s
	fi
else 
	if read -q "choice?VPN [-], do you want to switch it ON? [y/n] "; then 
		printf '$username\n$pwd\npush\ny' | /opt/cisco/anyconnect/bin/vpn -s connect vpn.rutgers.edu;
		echo
		echo "VPN is connected [+], press any key to exit..."; read -k1 -s
	else 
		echo
		echo "No action, press any key to exit..."; read -k1 -s	
	fi
fi
	
