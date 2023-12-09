AS_ARM = /usr/bin/arm-linux-gnu-as
LD_ARM = /usr/bin/arm-linux-gnu-ld
CFLAGS = -march=armv2a -mno-thumb-interwork -Wall -O1
LD_FLAGS = -Bstatic -fix-v4bx

all : test

test : test.o
  ${LD_ARM} ${LD_FLAGS} -T sections.lds -o test test.o

test.o : test.s
  ${AS_ARM} -c test.s -o test.o

clean :
  rm -f test *.o