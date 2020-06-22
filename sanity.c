#include "types.h"
#include "user.h"
#include "fcntl.h"

#define FILE_SZ 50

char writeBuf[FILE_SZ];
char readBuf[FILE_SZ];

int writeToFile(char* buf, char* filename)
{
    int fd, writeres;
    if((fd = open(filename, O_CREATE | O_RDWR)) < 0)
    {
        printf(1, "writeToFile: failed to create file\n");
        return fd;
    }
    if((writeres = write(fd, buf, FILE_SZ)) != FILE_SZ)
    {
        printf(1, "writeToFile: failed to write to file\n");
        close(fd);
        return writeres;
    }

    printf(1, "write ok\n");
    return 0;

}

int readFromFile (char* buf, char* filename)
{
    int fd, readres;
    if((fd = open(filename, O_RDWR)) < 0)
    {
        printf(1, "readFromFile: failed to open file\n");
        return fd;
    }
    if((readres = read(fd, buf, FILE_SZ)) != FILE_SZ)
    {
        printf(1, "readFromFile: failed to read to file\n");
        close(fd);
        return readres;
    }

    printf(1, "read ok\n");
    return 0;
}

void writeMoreThan70kBTest()
{
    printf(1, "creating 1MB file\n");
    memset((void*)writeBuf, 'a', FILE_SZ);
    writeToFile(writeBuf, "myfile");
    // readFromFile(readBuf, "myfile");
    // printf(1, "read content: %s\n", readBuf);
    printf(1,"\n");
}

void createTwoSymlinks()
{
    printf(1,"\n");
    printf(1, "creating symbolic link /myfile -> link\n");
    symlink("/myfile", "/link");
    printf(1, "creating symbolic link /link -> link2Link\n");
    symlink("/link", "/link2Link");
    printf(1, "creating symbolic link /link2Link -> link2Link2Link\n");
    symlink("/link2Link", "/link2Link2Link");
     printf(1,"\n");
}
void readLinkTest()
{
    char buf[50];
    printf(1,"--------- readlink test ---------\n");
    readlink("/link2Link2Link", buf, 50);
    printf(1, "expected: /myfile, actual: %s\n", buf);
}



int main()
{
    writeMoreThan70kBTest();
    createTwoSymlinks();
    readLinkTest();
    exit();
}