

`
sudo pip install M2Crypto
`

pip安装M2Crypto时出现以下错误

```
cc -fno-strict-aliasing -fno-common -dynamic -arch x86_64 -arch i386 -g -Os -pipe -fno-common -fno-strict-aliasing -fwrapv -DENABLE_DTRACE -DMACOSX -DNDEBUG -Wall -Wstrict-prototypes -Wshorten-64-to-32 -DNDEBUG -g -fwrapv -Os -Wall -Wstrict-prototypes -DENABLE_DTRACE -arch x86_64 -arch i386 -pipe -I/System/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7 -I/usr/include -I/private/tmp/pip-build-3oHnRT/M2Crypto/SWIG -c SWIG/_m2crypto_wrap.c -o build/temp.macosx-10.12-intel-2.7/SWIG/_m2crypto_wrap.o -DTHREADING
    SWIG/_m2crypto_wrap.c:2887:9: warning: variable 'res' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (PyType_Ready(tp) < 0)
            ^~~~~~~~~~~~~~~~~~~~
    SWIG/_m2crypto_wrap.c:2911:10: note: uninitialized use occurs here
      return res;
             ^~~
    SWIG/_m2crypto_wrap.c:2887:5: note: remove the 'if' if its condition is always false
        if (PyType_Ready(tp) < 0)
        ^~~~~~~~~~~~~~~~~~~~~~~~~
    SWIG/_m2crypto_wrap.c:2868:10: note: initialize the variable 'res' to silence this warning
      int res;
             ^
              = 0
    SWIG/_m2crypto_wrap.c:3541:10: fatal error: 'openssl/err.h' file not found
    #include <openssl/err.h>
             ^
    1 warning and 1 error generated.
    error: command 'cc' failed with exit status 1

    ----------------------------------------
Command "/usr/bin/python -u -c "import setuptools, tokenize;__file__='/private/tmp/pip-build-3oHnRT/M2Crypto/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" install --record /tmp/pip-zmyaiX-record/install-record.txt --single-version-externally-managed --compile" failed with error code 1 in /private/tmp/pip-build-3oHnRT/M2Crypto/
```

```
brew install openssl
```

发现,openssl已经安装了

ll发现/usr/local/include/下面没有openssl

```
ll /usr/local/include/
total 96
drwxrwxr-x  14   476B  1 16 14:19 .
drwxr-xr-x  14   476B  2 26 04:00 ..
lrwxr-xr-x   1    41B  1  4 10:17 libssh2.h -> ../Cellar/libssh2/1.8.0/include/libssh2.h
lrwxr-xr-x   1    51B  1  4 10:17 libssh2_publickey.h -> ../Cellar/libssh2/1.8.0/include/libssh2_publickey.h
lrwxr-xr-x   1    46B  1  4 10:17 libssh2_sftp.h -> ../Cellar/libssh2/1.8.0/include/libssh2_sftp.h
lrwxr-xr-x   1    36B 12 31 07:39 mysql -> ../Cellar/mysql/5.7.16/include/mysql
lrwxr-xr-x   1    33B  1 16 13:44 node -> ../Cellar/node/7.4.0/include/node
lrwxr-xr-x   1    34B  1 16 14:19 pcre.h -> ../Cellar/pcre/8.39/include/pcre.h
lrwxr-xr-x   1    42B  1 16 14:19 pcre_scanner.h -> ../Cellar/pcre/8.39/include/pcre_scanner.h
lrwxr-xr-x   1    46B  1 16 14:19 pcre_stringpiece.h -> ../Cellar/pcre/8.39/include/pcre_stringpiece.h
lrwxr-xr-x   1    37B  1 16 14:19 pcrecpp.h -> ../Cellar/pcre/8.39/include/pcrecpp.h
lrwxr-xr-x   1    40B  1 16 14:19 pcrecpparg.h -> ../Cellar/pcre/8.39/include/pcrecpparg.h
lrwxr-xr-x   1    39B  1 16 14:19 pcreposix.h -> ../Cellar/pcre/8.39/include/pcreposix.h
lrwxr-xr-x   1    49B  1  1 07:34 subversion-1 -> ../Cellar/subversion/1.9.5_1/include/subversion-1
```


果断软链接过来

```
ln -s ../Cellar/openssl/1.0.2j/include/openssl openssl
```
重新执行sudo pip install M2Crypto,问题解决
