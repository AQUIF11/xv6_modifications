#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscall.h"

int blocked_syscalls[MAX_SYSCALLS] = {0};  // Global kernel-side tracking


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

// int sys_sbrk(void) {
//     int addr;
//     int n;
//     struct proc *curproc = myproc();

//     if(argint(0, &n) < 0)
//         return -1;
//     addr = curproc->sz;

//     if(growproc(n) < 0)
//         return -1;

//     // Update only memory, do not overwrite name
//     acquire(&ptable.lock);
//     for (int i = 0; i < history_count; i++) {
//         if (process_history[i].pid == curproc->pid) {
//             process_history[i].mem_usage = curproc->sz;
//             break;
//         }
//     }
//     release(&ptable.lock);
    
//     return addr;
// }

int sys_sbrk(void) {
    int addr;
    int n;
    struct proc *curproc = myproc();

    if(argint(0, &n) < 0)
        return -1;

    addr = curproc->sz;

    if(growproc(n) < 0)
        return -1;

    // Wait for memory to be actually allocated
    int max_wait_cycles = 100000; // Avoid infinite loop
    while (curproc->sz == addr && max_wait_cycles > 0) {
        max_wait_cycles--;
    }

    if (curproc->sz == addr) {
        cprintf("sys_sbrk: Warning - Memory allocation did not reflect in time!\n");
    } else {
        cprintf("sys_sbrk: Memory size increased from %d to %d\n", addr, curproc->sz);
    }

    // Update only memory, do not overwrite name
    acquire(&ptable.lock);
    for (int i = 0; i < history_count; i++) {
        if (process_history[i].pid == curproc->pid) {
            // process_history[i].mem_usage = curproc->sz;
            if(curproc->sz > process_history[i].mem_usage) {
                process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
            }
            break;
        }
    }
    release(&ptable.lock);

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

// System call to block system calls
// int sys_block(void) {
//     int syscall_id;
//     struct proc *curproc = myproc();

//     if (argint(0, &syscall_id) < 0) 
//         return -1;

//     // Prevent blocking critical syscalls
//     if (syscall_id == SYS_fork || syscall_id == SYS_exit || syscall_id == SYS_unblock) {
//         return -1;
//     }

//     // Block the syscall for the current shell session
//     if (syscall_id >= 0 && syscall_id < MAX_SYSCALLS) {
//         curproc->blocked_syscalls[syscall_id] = 1;
//         return 0;
//     }

//     return -1;
// }
int sys_block(void) {
    int syscall_id;
    if (argint(0, &syscall_id) < 0) 
        return -1;
    
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
        return -1;

    // Prevent blocking critical system calls
    if (syscall_id == SYS_fork || syscall_id == SYS_exit || syscall_id == SYS_unblock) {
        return -1;
    }

    blocked_syscalls[syscall_id] = 1;  // Store in the kernel
    return 0;
}



// System call to unblock system calls
// int sys_unblock(void) {
//     int syscall_id;
//     struct proc *curproc = myproc();

//     if (argint(0, &syscall_id) < 0) 
//         return -1;

//     if (syscall_id >= 0 && syscall_id < MAX_SYSCALLS) {
//         curproc->blocked_syscalls[syscall_id] = 0;
//         return 0;
//     }

//     return -1;
// }

// int sys_unblock(void) {
//     int syscall_id;
//     struct proc *curproc = myproc();
//     struct proc *p;

//     if (argint(0, &syscall_id) < 0) 
//         return -1;

//     if (syscall_id == SYS_fork || syscall_id == SYS_exit || syscall_id == SYS_unblock) {
//         return -1;
//     }

//     if (syscall_id >= 0 && syscall_id < MAX_SYSCALLS) {

//         acquire(&ptable.lock);
//         // Unblock for current shell and all its child processes
//         for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
//             if (p->parent == curproc || p == curproc) {
//                 p->blocked_syscalls[syscall_id] = 0;
//             }
//         }
//         release(&ptable.lock);   

//         return 0;
//     }

//     return -1;
// }

// int sys_unblock(void) {
//     int syscall_id;
//     struct proc *curproc = myproc();
//     struct proc *p;

//     if (argint(0, &syscall_id) < 0) 
//         return -1;

//     if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
//         return -1;

//     acquire(&ptable.lock);
    
//     // Debugging output
//     cprintf("Unblocking syscall %d for PID %d and its children\n", syscall_id, curproc->pid);

//     for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
//         if (p->parent == curproc || p == curproc) {
//             p->blocked_syscalls[syscall_id] = 0;
//             cprintf("Syscall %d unblocked for PID %d\n", syscall_id, p->pid);
//         }
//     }

//     release(&ptable.lock);
//     return 0;
// }
int sys_unblock(void) {
    int syscall_id;

    // Get the syscall ID from arguments
    if (argint(0, &syscall_id) < 0) 
        return -1;

    // Validate syscall ID range
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
        return -1;

    // Unblock the specified syscall
    blocked_syscalls[syscall_id] = 0;

    return 0;
}








