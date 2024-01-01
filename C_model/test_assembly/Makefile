AS_ARM = arm-linux-gnueabi-as
LD_ARM = arm-linux-gnueabi-ld
DP_ARM = arm-linux-gnueabi-objdump
CFLAGS = -march=armv2a -mno-thumb-interwork -Wall -O1
LD_FLAGS = -Bstatic -fix-v4bx

FILE_NAME = mult_add

all : ${FILE_NAME}

${FILE_NAME} : ${FILE_NAME}.o
	${LD_ARM} ${LD_FLAGS} -T sections.lds -o ${FILE_NAME} ${FILE_NAME}.o

${FILE_NAME}.o : ${FILE_NAME}.s 
	${AS_ARM} -c ${FILE_NAME}.s -o ${FILE_NAME}.o

dump : 
	${DP_ARM} -d ${FILE_NAME}

clean :
	rm -f ${FILE_NAME} *.o