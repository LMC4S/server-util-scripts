#!/usr/bin/expect -f
spawn ssh -L <local-port>:127.0.0.1:<remote-port> <host>
expect "password:"
send  "$pwd"
interact