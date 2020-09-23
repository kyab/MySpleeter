# MySpleeter
MySpleeter is Mac GUI version of [Spleeter](https://research.deezer.com/projects/spleeter.html).
MySpleeter allows you to separate any stereo music files into 5stems(vocals/drums/bass/piano/other).

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

### Install spleeter into self builded python
Execute following commands to install spleeter in self builded python.
```
cd ~/work/devbuild/bin
export PYTHONPATH="~/work/devbuild/lib/python3.7/site-packages"
./python3 -m pip install spleeter
```
Now your python build(~/work/devbuild) are spleeter installed version.


### Add self builded python into your XCode project
Drag and drop ~/work/devbuild into left side (project)view of Xcode.

Drag and drop ~/work/devbuild/lib/libpython3.7m.a into leftside (project)view of Xcode.

In XCode, open project's "Build Phases" tab and add "devbuild" to "Copy Bundle Resources" phase.

### Add ffmpeg/ffprobe to your Xcode project
Download standalone version of ffmpeg/ffprobe binary(executable) from [here](https://evermeet.cx/ffmpeg/).

Create folder named "ffmpeg" in Xcode project and drag and drop ffmpeg/ffprobe binary into left side (project)view of Xcode.

In XCode, open project's "Build Phases" tab and add "devbuild" to "Copy Bundle Resouces" phase.

### Coding(Initializing)
At first, path to ffmpeg/ffprobe should be in PATH environment value when your application launch.
See code around https://github.com/kyab/MySpleeter/blob/a33ecf73c9d2b8ed6ad041043a72978f6f764ae5/MySpleeter/SpleeterWrapper.m#L23

Next, PYTHONPATH should be set, for embedded python can find spleeter and dependent python libraries.
See code around https://github.com/kyab/MySpleeter/blob/a33ecf73c9d2b8ed6ad041043a72978f6f764ae5/MySpleeter/SpleeterWrapper.m#L32

After that, [Initializing python from C](https://github.com/kyab/MySpleeter/blob/a33ecf73c9d2b8ed6ad041043a72978f6f764ae5/MySpleeter/SpleeterWrapper.m#L42) should success.

### Coding(Separation)
Using Python's C API to call spleeter API that written in Python.
See code started from here(https://github.com/kyab/MySpleeter/blob/a33ecf73c9d2b8ed6ad041043a72978f6f764ae5/MySpleeter/SpleeterWrapper.m#L107), 
and here(https://github.com/kyab/MySpleeter/blob/a33ecf73c9d2b8ed6ad041043a72978f6f764ae5/MySpleeter/SpleeterWrapper.m#L132)

### Building and Test
If you successfully build, try run your application on fresh installed macOS. It would ensure that can run without any preinstalled modules, if you plan to distribute your app.

