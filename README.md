# MySpleeter
MySpleeter is Mac GUI version of [Spleeter](https://research.deezer.com/projects/spleeter.html).
MySpleeter allows to separate any stereo music files into 5stems(vocals/drums/bass/piano/other).

## download
https://github.com/kyab/MySpleeter/releases/download/20200904_2/MySpleeter20200904.dmg


## Development Documentation
In this section, I wrote down the way to embed whole spleeter into mac application.
(I've basically refered [stackoverflow post](https://stackoverflow.com/questions/26660287/how-to-embed-python-in-an-objective-c-os-x-application-for-plugins) as a start point. It describes way to embed python into application.)

### Install openssl with homebrew
```
brew install openssl
```
this openssl will be used to static link openssl to self builded python.

### Self build python3.7 with openssl statically linked.

Download source code of Python3.7.x from [here](https://www.python.org/downloads/source/), then extract it to any place(example : ~/work/python3.7)
Python3.8.x does not work with spleeter.

Open file named ~/work/python3.7/Modules/Setup with editor, and edit
```
# Socket module helper for SSL support; you must comment out the other
# socket line above, and possibly edit the SSL variable:
#SSL=/usr/local/ssl
#_ssl _ssl.c \
#	-DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
#	-L$(SSL)/lib -lssl -lcrypto
```
to below
```
# Socket module helper for SSL support; you must comment out the other
# socket line above, and possibly edit the SSL variable:
SSL=/usr/local/opt/openssl
_ssl _ssl.c \
	-DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
	$(SSL)/lib/libssl.a $(SSL)/lib/libcrypto.a
```
Then cd to ~/work/python3.7 and build python3.7.x
```
./configure --prefix="~/work/devbuild" --with-openssl=/usr/local/opt/openssl
make
make install
```

### Add self builded python into your XCode project
Drag and drop ~/work/devbuild into left side (project)view of Xcode.

Drag and drop ~/work/devbuild/lib/libpython3.7m.a into leftside (project)view of Xcode.

In XCode, open project's "Build Phases" tab and add "devbuild" to "Copy Bundle Resources" phase.


