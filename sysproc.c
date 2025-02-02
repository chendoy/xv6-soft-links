#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_symlink(void)
{
  const char *oldpath;
  const char *newpath;
  
  if(argptr(0, (char**)&oldpath, 4) < 0)
    return -1;
  if(argptr(1, (char**)&newpath, 4) < 0)
    return -1;


  return create_symlink(oldpath, newpath);
}

int
sys_readlink(void)
{
  const char *pathname;
  char *buf;
  size_t bufsize;
  
  if(argptr(0, (char**)&pathname, 4) < 0)
    return -1;
  if(argptr(1, (char**)&buf, 4) < 0)
    return -1;
  if(argint(2, (int*)&bufsize) < 0)
    return -1;

  return read_symlink(pathname, buf, bufsize);
}
