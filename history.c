#include "types.h"
#include "user.h"

#define MAX_HISTORY 100  // Should match NPROC

int main(void) {
    struct history_entry hist[MAX_HISTORY];
    int count = gethistory(hist, MAX_HISTORY);

    if (count < 0) {
        // printf(1, "Error fetching process history\n");
        exit();
    }

    // printf(1, "PID\tCOMMAND\tMEMORY\n"); // Table Header
    for (int i = 0; i < count; i++) {
        if(strcmp(hist[i].name, "sh") == 0) {
            continue;
        }
        printf(1, "%d\t%s\t%d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
    }

    exit();
}
