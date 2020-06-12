#include "types.h"
#include "user.h"
#include "fcntl.h"

#define FILE_SZ 1 << 19

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

int main()
{
    memset((void*)writeBuf, 'a', FILE_SZ);
    writeToFile(writeBuf, "ass4File.txt");
    readFromFile(readBuf, "ass4File.txt");
    printf(1, "read content: %s\n", readBuf);
    exit();
}