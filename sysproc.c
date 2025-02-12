#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
    return fork();
}

int sys_exit(void) {
    exit();
    return 0;  // not reached
}

int sys_wait(void) {
    return wait();
}

int sys_kill(void) {
    int pid;
    if(argint(0, &pid) < 0)
        return -1;
    return kill(pid);
}

int sys_getpid(void) {
    return myproc()->pid;
}

int sys_sbrk(void) {
    int addr;
    int n;
    if(argint(0, &n) < 0)
        return -1;
    addr = myproc()->sz;
    if(growproc(n) < 0)
        return -1;
    return addr;
}

int sys_sleep(void) {
    int n;
    uint ticks0;
    if(argint(0, &n) < 0)
        return -1;
    acquire(&tickslock);
    ticks0 = ticks;
    while(ticks - ticks0 < n) {
        if(myproc()->killed) {
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
int sys_uptime(void) {
    uint xticks;
    acquire(&tickslock);
    xticks = ticks;
    release(&tickslock);
    return xticks;
}

// System call to get process history
int sys_gethistory(void) {
    struct history_entry *hist_buf;
    int max_entries;

    // Get arguments from user space
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
        argint(1, &max_entries) < 0) {
        return -1;  // Invalid arguments
    }

    acquire(&ptable.lock);

    // Return only the most recent `max_entries` from history
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
    int start = (history_count < MAX_HISTORY) ? 0 : history_index;  // Start index

    for (int i = 0; i < copy_count; i++) {
        int index = (start + i) % MAX_HISTORY;
        hist_buf[i].pid = process_history[index].pid;
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
        hist_buf[i].mem_usage = process_history[index].mem_usage;
    }

    release(&ptable.lock);
    return copy_count;  // Return number of processes copied
}
