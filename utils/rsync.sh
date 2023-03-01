#!/usr/bin/expect -f
spawn rsync -trlvpz <host>:<remote-path> <local-path>
expect "password:"
send  "$pwd"
interact