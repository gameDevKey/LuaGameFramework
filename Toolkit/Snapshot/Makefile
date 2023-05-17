MINGW_PATH=D:/MinGW
C_INCLUDE_PATH=D:/MinGW/include;D:/MinGW/lib/gcc/mingw32/9.2.0/include;D:/Lua/luaforwindows-5.1.5-52/files/include

.PHONY : all linux mingw

all : linux

linux :
	gcc -g -Wall -fPIC --shared -o snapshot.so snapshot.c

mingw :
	gcc -g -Wall --shared -o snapshot.dll snapshot.c -I/usr/local/include -L/usr/local/bin -llua53

mingw51 :
	gcc -g -Wall --shared -o snapshot.dll snapshot.c -I/usr/local/include -L/usr/local/bin -llua51

macosx :
	gcc -g -Wall --shared -undefined dynamic_lookup -o snapshot.so snapshot.c