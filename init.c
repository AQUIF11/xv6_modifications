// init: The initial user-level program with login authentication

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define MAX_ATTEMPTS 3

char *argv[] = { "sh", 0 };

// Function to get user input safely
void get_input(char *buffer, int size) {
    int len = read(0, buffer, size - 1);
    if (len == size - 1) {
        char flush;
        while (read(0, &flush, 1) == 1 && flush != '\n');
    }
    if (len > 0 && buffer[len - 1] == '\n')
        buffer[len - 1] = '\0';
    else
        buffer[len] = '\0';
}

// Function to validate username and password
int is_valid_input(const char *input) {
    int len = strlen(input);
    for (int i = 0; i < len; i++) {
        if (!((input[i] >= 'A' && input[i] <= 'Z') || (input[i] >= 'a' && input[i] <= 'z') || (input[i] >= '0' && input[i] <= '9')))
            return 0;
    }
    return 1;
}

int main(void) {
    // Ensure console is set up
    if (open("console", O_RDWR) < 0) {
        mknod("console", 1, 1);
        open("console", O_RDWR);
    }
    dup(0);  // stdout
    dup(0);  // stderr

    char username[33], password[33];
    int attempts = 0;

    while (attempts < MAX_ATTEMPTS) {
        printf(1, "$Enter username: ");
        get_input(username, sizeof(username));

        if (!is_valid_input(username)) {
            // printf(1, "Invalid username. Only letters and numbers are allowed.\n");
            attempts++;
            continue;
        }
        if (strcmp(username, USERNAME) != 0) {
            // printf(1, "Invalid username. Try again.\n");
            attempts++;
            continue;
        }

        printf(1, "$Enter password: ");
        get_input(password, sizeof(password));

        if (!is_valid_input(password)) {
            // printf(1, "Invalid password. Only letters and numbers are allowed.\n");
            attempts++;
            continue;
        }
        if (strcmp(password, PASSWORD) != 0) {
            // printf(1, "Invalid password. Try again.\n");
            attempts++;
            continue;
        }

        printf(1, "Login successful\n");
        break;
    }

    if (attempts == MAX_ATTEMPTS) {
        printf(1, "Too many failed attempts. Login process disabled.\n");

        // Prevent further interaction, effectively disabling login
        for (;;) {
            sleep(10000);  
        }
    }

    // Start the shell after successful login
    for (;;) {
        // printf(1, "init: starting sh\n");
        int pid = fork();
        if (pid < 0) {
            printf(1, "init: fork failed\n");
            exit();
        }
        if (pid == 0) {
            exec("sh", argv);
            printf(1, "init: exec sh failed\n");
            exit();
        }
        int wpid;
        while ((wpid = wait()) >= 0 && wpid != pid)
            printf(1, "zombie!\n");
    }
}
