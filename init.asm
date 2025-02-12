
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
            return 0;
    }
    return 1;
}

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 60             	sub    $0x60,%esp
    // Ensure console is set up
    if (open("console", O_RDWR) < 0) {
  14:	6a 02                	push   $0x2
  16:	68 e8 09 00 00       	push   $0x9e8
  1b:	e8 83 05 00 00       	call   5a3 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	0f 88 c6 01 00 00    	js     1f1 <main+0x1f1>
        mknod("console", 1, 1);
        open("console", O_RDWR);
    }
    dup(0);  // stdout
  2b:	83 ec 0c             	sub    $0xc,%esp
  2e:	8d 5d a6             	lea    -0x5a(%ebp),%ebx
  31:	8d 7d c7             	lea    -0x39(%ebp),%edi
    dup(0);  // stderr
  34:	be 01 00 00 00       	mov    $0x1,%esi
    dup(0);  // stdout
  39:	6a 00                	push   $0x0
  3b:	e8 9b 05 00 00       	call   5db <dup>
    dup(0);  // stderr
  40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  47:	e8 8f 05 00 00       	call   5db <dup>
  4c:	83 c4 10             	add    $0x10,%esp

    char username[33], password[33];
    int attempts = 0;

    while (attempts < MAX_ATTEMPTS) {
        printf(1, "Enter Username: ");
  4f:	83 ec 08             	sub    $0x8,%esp
  52:	68 f0 09 00 00       	push   $0x9f0
  57:	6a 01                	push   $0x1
  59:	e8 62 06 00 00       	call   6c0 <printf>
        get_input(username, sizeof(username));
  5e:	58                   	pop    %eax
  5f:	5a                   	pop    %edx
  60:	6a 21                	push   $0x21
  62:	53                   	push   %ebx
  63:	e8 c8 01 00 00       	call   230 <get_input>

        if (!is_valid_input(username)) {
  68:	89 1c 24             	mov    %ebx,(%esp)
  6b:	e8 40 02 00 00       	call   2b0 <is_valid_input>
  70:	83 c4 10             	add    $0x10,%esp
  73:	85 c0                	test   %eax,%eax
  75:	0f 84 c6 00 00 00    	je     141 <main+0x141>
            printf(1, "Invalid username. Only letters and numbers are allowed.\n");
            attempts++;
            continue;
        }
        if (strcmp(username, USERNAME) != 0) {
  7b:	83 ec 08             	sub    $0x8,%esp
  7e:	68 01 0a 00 00       	push   $0xa01
  83:	53                   	push   %ebx
  84:	e8 b7 02 00 00       	call   340 <strcmp>
  89:	83 c4 10             	add    $0x10,%esp
  8c:	85 c0                	test   %eax,%eax
  8e:	0f 85 fd 00 00 00    	jne    191 <main+0x191>
            printf(1, "Invalid username. Try again.\n");
            attempts++;
            continue;
        }

        printf(1, "Enter Password: ");
  94:	83 ec 08             	sub    $0x8,%esp
  97:	68 28 0a 00 00       	push   $0xa28
  9c:	6a 01                	push   $0x1
  9e:	e8 1d 06 00 00       	call   6c0 <printf>
        get_input(password, sizeof(password));
  a3:	58                   	pop    %eax
  a4:	5a                   	pop    %edx
  a5:	6a 21                	push   $0x21
  a7:	57                   	push   %edi
  a8:	e8 83 01 00 00       	call   230 <get_input>

        if (!is_valid_input(password)) {
  ad:	89 3c 24             	mov    %edi,(%esp)
  b0:	e8 fb 01 00 00       	call   2b0 <is_valid_input>
  b5:	83 c4 10             	add    $0x10,%esp
  b8:	85 c0                	test   %eax,%eax
  ba:	0f 84 1b 01 00 00    	je     1db <main+0x1db>
            printf(1, "Invalid password. Only letters and numbers are allowed.\n");
            attempts++;
            continue;
        }
        if (strcmp(password, PASSWORD) != 0) {
  c0:	50                   	push   %eax
  c1:	50                   	push   %eax
  c2:	68 39 0a 00 00       	push   $0xa39
  c7:	57                   	push   %edi
  c8:	e8 73 02 00 00       	call   340 <strcmp>
  cd:	83 c4 10             	add    $0x10,%esp
  d0:	85 c0                	test   %eax,%eax
  d2:	0f 85 3e 01 00 00    	jne    216 <main+0x216>
            printf(1, "Invalid password. Try again.\n");
            attempts++;
            continue;
        }

        printf(1, "Login successful\n");
  d8:	83 ec 08             	sub    $0x8,%esp
  db:	68 60 0a 00 00       	push   $0xa60
  e0:	6a 01                	push   $0x1
  e2:	e8 d9 05 00 00       	call   6c0 <printf>
  e7:	83 c4 10             	add    $0x10,%esp
  ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        }
    }

    // Start the shell after successful login
    for (;;) {
        printf(1, "init: starting sh\n");
  f0:	83 ec 08             	sub    $0x8,%esp
  f3:	68 72 0a 00 00       	push   $0xa72
  f8:	6a 01                	push   $0x1
  fa:	e8 c1 05 00 00       	call   6c0 <printf>
        int pid = fork();
  ff:	e8 57 04 00 00       	call   55b <fork>
        if (pid < 0) {
 104:	83 c4 10             	add    $0x10,%esp
        int pid = fork();
 107:	89 c3                	mov    %eax,%ebx
        if (pid < 0) {
 109:	85 c0                	test   %eax,%eax
 10b:	0f 88 93 00 00 00    	js     1a4 <main+0x1a4>
            printf(1, "init: fork failed\n");
            exit();
        }
        if (pid == 0) {
 111:	0f 84 a0 00 00 00    	je     1b7 <main+0x1b7>
 117:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 11e:	00 
 11f:	90                   	nop
            exec("sh", argv);
            printf(1, "init: exec sh failed\n");
            exit();
        }
        int wpid;
        while ((wpid = wait()) >= 0 && wpid != pid)
 120:	e8 46 04 00 00       	call   56b <wait>
 125:	85 c0                	test   %eax,%eax
 127:	78 c7                	js     f0 <main+0xf0>
 129:	39 c3                	cmp    %eax,%ebx
 12b:	74 c3                	je     f0 <main+0xf0>
            printf(1, "zombie!\n");
 12d:	83 ec 08             	sub    $0x8,%esp
 130:	68 b1 0a 00 00       	push   $0xab1
 135:	6a 01                	push   $0x1
 137:	e8 84 05 00 00       	call   6c0 <printf>
 13c:	83 c4 10             	add    $0x10,%esp
 13f:	eb df                	jmp    120 <main+0x120>
            printf(1, "Invalid username. Only letters and numbers are allowed.\n");
 141:	50                   	push   %eax
 142:	50                   	push   %eax
 143:	68 c4 0a 00 00       	push   $0xac4
 148:	6a 01                	push   $0x1
 14a:	e8 71 05 00 00       	call   6c0 <printf>
            continue;
 14f:	83 c4 10             	add    $0x10,%esp
    while (attempts < MAX_ATTEMPTS) {
 152:	83 c6 01             	add    $0x1,%esi
 155:	83 fe 04             	cmp    $0x4,%esi
 158:	0f 85 f1 fe ff ff    	jne    4f <main+0x4f>
        printf(1, "Too many failed attempts. Login process disabled.\n");
 15e:	50                   	push   %eax
 15f:	50                   	push   %eax
 160:	68 3c 0b 00 00       	push   $0xb3c
 165:	6a 01                	push   $0x1
 167:	e8 54 05 00 00       	call   6c0 <printf>
 16c:	83 c4 10             	add    $0x10,%esp
            sleep(10000);  
 16f:	83 ec 0c             	sub    $0xc,%esp
 172:	68 10 27 00 00       	push   $0x2710
 177:	e8 77 04 00 00       	call   5f3 <sleep>
 17c:	83 c4 10             	add    $0x10,%esp
 17f:	83 ec 0c             	sub    $0xc,%esp
 182:	68 10 27 00 00       	push   $0x2710
 187:	e8 67 04 00 00       	call   5f3 <sleep>
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	eb de                	jmp    16f <main+0x16f>
            printf(1, "Invalid username. Try again.\n");
 191:	51                   	push   %ecx
 192:	51                   	push   %ecx
 193:	68 0a 0a 00 00       	push   $0xa0a
 198:	6a 01                	push   $0x1
 19a:	e8 21 05 00 00       	call   6c0 <printf>
            continue;
 19f:	83 c4 10             	add    $0x10,%esp
 1a2:	eb ae                	jmp    152 <main+0x152>
            printf(1, "init: fork failed\n");
 1a4:	56                   	push   %esi
 1a5:	56                   	push   %esi
 1a6:	68 85 0a 00 00       	push   $0xa85
 1ab:	6a 01                	push   $0x1
 1ad:	e8 0e 05 00 00       	call   6c0 <printf>
            exit();
 1b2:	e8 ac 03 00 00       	call   563 <exit>
            exec("sh", argv);
 1b7:	52                   	push   %edx
 1b8:	52                   	push   %edx
 1b9:	68 e4 0e 00 00       	push   $0xee4
 1be:	68 98 0a 00 00       	push   $0xa98
 1c3:	e8 d3 03 00 00       	call   59b <exec>
            printf(1, "init: exec sh failed\n");
 1c8:	59                   	pop    %ecx
 1c9:	5b                   	pop    %ebx
 1ca:	68 9b 0a 00 00       	push   $0xa9b
 1cf:	6a 01                	push   $0x1
 1d1:	e8 ea 04 00 00       	call   6c0 <printf>
            exit();
 1d6:	e8 88 03 00 00       	call   563 <exit>
            printf(1, "Invalid password. Only letters and numbers are allowed.\n");
 1db:	50                   	push   %eax
 1dc:	50                   	push   %eax
 1dd:	68 00 0b 00 00       	push   $0xb00
 1e2:	6a 01                	push   $0x1
 1e4:	e8 d7 04 00 00       	call   6c0 <printf>
            continue;
 1e9:	83 c4 10             	add    $0x10,%esp
 1ec:	e9 61 ff ff ff       	jmp    152 <main+0x152>
        mknod("console", 1, 1);
 1f1:	51                   	push   %ecx
 1f2:	6a 01                	push   $0x1
 1f4:	6a 01                	push   $0x1
 1f6:	68 e8 09 00 00       	push   $0x9e8
 1fb:	e8 ab 03 00 00       	call   5ab <mknod>
        open("console", O_RDWR);
 200:	5b                   	pop    %ebx
 201:	5e                   	pop    %esi
 202:	6a 02                	push   $0x2
 204:	68 e8 09 00 00       	push   $0x9e8
 209:	e8 95 03 00 00       	call   5a3 <open>
 20e:	83 c4 10             	add    $0x10,%esp
 211:	e9 15 fe ff ff       	jmp    2b <main+0x2b>
            printf(1, "Invalid password. Try again.\n");
 216:	50                   	push   %eax
 217:	50                   	push   %eax
 218:	68 42 0a 00 00       	push   $0xa42
 21d:	6a 01                	push   $0x1
 21f:	e8 9c 04 00 00       	call   6c0 <printf>
            continue;
 224:	83 c4 10             	add    $0x10,%esp
 227:	e9 26 ff ff ff       	jmp    152 <main+0x152>
 22c:	66 90                	xchg   %ax,%ax
 22e:	66 90                	xchg   %ax,%ax

00000230 <get_input>:
void get_input(char *buffer, int size) {
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	53                   	push   %ebx
 236:	83 ec 20             	sub    $0x20,%esp
    int len = read(0, buffer, size - 1);
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
void get_input(char *buffer, int size) {
 23c:	8b 7d 08             	mov    0x8(%ebp),%edi
    int len = read(0, buffer, size - 1);
 23f:	8d 70 ff             	lea    -0x1(%eax),%esi
 242:	56                   	push   %esi
 243:	57                   	push   %edi
 244:	6a 00                	push   $0x0
 246:	e8 30 03 00 00       	call   57b <read>
    if (len == size - 1) {
 24b:	83 c4 10             	add    $0x10,%esp
    int len = read(0, buffer, size - 1);
 24e:	89 c3                	mov    %eax,%ebx
    if (len == size - 1) {
 250:	39 c6                	cmp    %eax,%esi
 252:	74 2c                	je     280 <get_input+0x50>
    if (len > 0 && buffer[len - 1] == '\n')
 254:	85 db                	test   %ebx,%ebx
 256:	7e 09                	jle    261 <get_input+0x31>
 258:	8d 44 1f ff          	lea    -0x1(%edi,%ebx,1),%eax
 25c:	80 38 0a             	cmpb   $0xa,(%eax)
 25f:	74 0f                	je     270 <get_input+0x40>
        buffer[len] = '\0';
 261:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
}
 265:	8d 65 f4             	lea    -0xc(%ebp),%esp
 268:	5b                   	pop    %ebx
 269:	5e                   	pop    %esi
 26a:	5f                   	pop    %edi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret
 26d:	8d 76 00             	lea    0x0(%esi),%esi
        buffer[len - 1] = '\0';
 270:	c6 00 00             	movb   $0x0,(%eax)
}
 273:	8d 65 f4             	lea    -0xc(%ebp),%esp
 276:	5b                   	pop    %ebx
 277:	5e                   	pop    %esi
 278:	5f                   	pop    %edi
 279:	5d                   	pop    %ebp
 27a:	c3                   	ret
 27b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 280:	8d 75 e7             	lea    -0x19(%ebp),%esi
 283:	eb 09                	jmp    28e <get_input+0x5e>
 285:	8d 76 00             	lea    0x0(%esi),%esi
        while (read(0, &flush, 1) == 1 && flush != '\n');
 288:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
 28c:	74 c6                	je     254 <get_input+0x24>
 28e:	83 ec 04             	sub    $0x4,%esp
 291:	6a 01                	push   $0x1
 293:	56                   	push   %esi
 294:	6a 00                	push   $0x0
 296:	e8 e0 02 00 00       	call   57b <read>
 29b:	83 c4 10             	add    $0x10,%esp
 29e:	83 f8 01             	cmp    $0x1,%eax
 2a1:	74 e5                	je     288 <get_input+0x58>
 2a3:	eb af                	jmp    254 <get_input+0x24>
 2a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ac:	00 
 2ad:	8d 76 00             	lea    0x0(%esi),%esi

000002b0 <is_valid_input>:
int is_valid_input(const char *input) {
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	83 ec 10             	sub    $0x10,%esp
 2b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int len = strlen(input);
 2ba:	53                   	push   %ebx
 2bb:	e8 e0 00 00 00       	call   3a0 <strlen>
    for (int i = 0; i < len; i++) {
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	85 c0                	test   %eax,%eax
 2c5:	7e 27                	jle    2ee <is_valid_input+0x3e>
 2c7:	89 da                	mov    %ebx,%edx
 2c9:	8d 1c 03             	lea    (%ebx,%eax,1),%ebx
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (!((input[i] >= 'A' && input[i] <= 'Z') || (input[i] >= 'a' && input[i] <= 'z') || (input[i] >= '0' && input[i] <= '9')))
 2d0:	0f b6 02             	movzbl (%edx),%eax
 2d3:	89 c1                	mov    %eax,%ecx
 2d5:	83 e1 df             	and    $0xffffffdf,%ecx
 2d8:	83 e9 41             	sub    $0x41,%ecx
 2db:	80 f9 19             	cmp    $0x19,%cl
 2de:	76 07                	jbe    2e7 <is_valid_input+0x37>
 2e0:	83 e8 30             	sub    $0x30,%eax
 2e3:	3c 09                	cmp    $0x9,%al
 2e5:	77 19                	ja     300 <is_valid_input+0x50>
    for (int i = 0; i < len; i++) {
 2e7:	83 c2 01             	add    $0x1,%edx
 2ea:	39 d3                	cmp    %edx,%ebx
 2ec:	75 e2                	jne    2d0 <is_valid_input+0x20>
}
 2ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 1;
 2f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
 2f6:	c9                   	leave
 2f7:	c3                   	ret
 2f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ff:	00 
 300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return 0;
 303:	31 c0                	xor    %eax,%eax
}
 305:	c9                   	leave
 306:	c3                   	ret
 307:	66 90                	xchg   %ax,%ax
 309:	66 90                	xchg   %ax,%ax
 30b:	66 90                	xchg   %ax,%ax
 30d:	66 90                	xchg   %ax,%ax
 30f:	90                   	nop

00000310 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 310:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 311:	31 c0                	xor    %eax,%eax
{
 313:	89 e5                	mov    %esp,%ebp
 315:	53                   	push   %ebx
 316:	8b 4d 08             	mov    0x8(%ebp),%ecx
 319:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 320:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 324:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 327:	83 c0 01             	add    $0x1,%eax
 32a:	84 d2                	test   %dl,%dl
 32c:	75 f2                	jne    320 <strcpy+0x10>
    ;
  return os;
}
 32e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 331:	89 c8                	mov    %ecx,%eax
 333:	c9                   	leave
 334:	c3                   	ret
 335:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 33c:	00 
 33d:	8d 76 00             	lea    0x0(%esi),%esi

00000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 55 08             	mov    0x8(%ebp),%edx
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 34a:	0f b6 02             	movzbl (%edx),%eax
 34d:	84 c0                	test   %al,%al
 34f:	75 17                	jne    368 <strcmp+0x28>
 351:	eb 3a                	jmp    38d <strcmp+0x4d>
 353:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 358:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 35c:	83 c2 01             	add    $0x1,%edx
 35f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 362:	84 c0                	test   %al,%al
 364:	74 1a                	je     380 <strcmp+0x40>
    p++, q++;
 366:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 368:	0f b6 19             	movzbl (%ecx),%ebx
 36b:	38 c3                	cmp    %al,%bl
 36d:	74 e9                	je     358 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 36f:	29 d8                	sub    %ebx,%eax
}
 371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 374:	c9                   	leave
 375:	c3                   	ret
 376:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37d:	00 
 37e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 380:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 384:	31 c0                	xor    %eax,%eax
 386:	29 d8                	sub    %ebx,%eax
}
 388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 38b:	c9                   	leave
 38c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 38d:	0f b6 19             	movzbl (%ecx),%ebx
 390:	31 c0                	xor    %eax,%eax
 392:	eb db                	jmp    36f <strcmp+0x2f>
 394:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 39b:	00 
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003a0 <strlen>:

uint
strlen(const char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3a6:	80 3a 00             	cmpb   $0x0,(%edx)
 3a9:	74 15                	je     3c0 <strlen+0x20>
 3ab:	31 c0                	xor    %eax,%eax
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
 3b0:	83 c0 01             	add    $0x1,%eax
 3b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3b7:	89 c1                	mov    %eax,%ecx
 3b9:	75 f5                	jne    3b0 <strlen+0x10>
    ;
  return n;
}
 3bb:	89 c8                	mov    %ecx,%eax
 3bd:	5d                   	pop    %ebp
 3be:	c3                   	ret
 3bf:	90                   	nop
  for(n = 0; s[n]; n++)
 3c0:	31 c9                	xor    %ecx,%ecx
}
 3c2:	5d                   	pop    %ebp
 3c3:	89 c8                	mov    %ecx,%eax
 3c5:	c3                   	ret
 3c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3cd:	00 
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	89 d7                	mov    %edx,%edi
 3df:	fc                   	cld
 3e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 3e5:	89 d0                	mov    %edx,%eax
 3e7:	c9                   	leave
 3e8:	c3                   	ret
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003f0 <strchr>:

char*
strchr(const char *s, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3fa:	0f b6 10             	movzbl (%eax),%edx
 3fd:	84 d2                	test   %dl,%dl
 3ff:	75 12                	jne    413 <strchr+0x23>
 401:	eb 1d                	jmp    420 <strchr+0x30>
 403:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 408:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 40c:	83 c0 01             	add    $0x1,%eax
 40f:	84 d2                	test   %dl,%dl
 411:	74 0d                	je     420 <strchr+0x30>
    if(*s == c)
 413:	38 d1                	cmp    %dl,%cl
 415:	75 f1                	jne    408 <strchr+0x18>
      return (char*)s;
  return 0;
}
 417:	5d                   	pop    %ebp
 418:	c3                   	ret
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 420:	31 c0                	xor    %eax,%eax
}
 422:	5d                   	pop    %ebp
 423:	c3                   	ret
 424:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42b:	00 
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <gets>:

char*
gets(char *buf, int max)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 435:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 438:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 439:	31 db                	xor    %ebx,%ebx
{
 43b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 43e:	eb 27                	jmp    467 <gets+0x37>
    cc = read(0, &c, 1);
 440:	83 ec 04             	sub    $0x4,%esp
 443:	6a 01                	push   $0x1
 445:	57                   	push   %edi
 446:	6a 00                	push   $0x0
 448:	e8 2e 01 00 00       	call   57b <read>
    if(cc < 1)
 44d:	83 c4 10             	add    $0x10,%esp
 450:	85 c0                	test   %eax,%eax
 452:	7e 1d                	jle    471 <gets+0x41>
      break;
    buf[i++] = c;
 454:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 458:	8b 55 08             	mov    0x8(%ebp),%edx
 45b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 45f:	3c 0a                	cmp    $0xa,%al
 461:	74 1d                	je     480 <gets+0x50>
 463:	3c 0d                	cmp    $0xd,%al
 465:	74 19                	je     480 <gets+0x50>
  for(i=0; i+1 < max; ){
 467:	89 de                	mov    %ebx,%esi
 469:	83 c3 01             	add    $0x1,%ebx
 46c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 46f:	7c cf                	jl     440 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 471:	8b 45 08             	mov    0x8(%ebp),%eax
 474:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 478:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47b:	5b                   	pop    %ebx
 47c:	5e                   	pop    %esi
 47d:	5f                   	pop    %edi
 47e:	5d                   	pop    %ebp
 47f:	c3                   	ret
  buf[i] = '\0';
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	89 de                	mov    %ebx,%esi
 485:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 489:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48c:	5b                   	pop    %ebx
 48d:	5e                   	pop    %esi
 48e:	5f                   	pop    %edi
 48f:	5d                   	pop    %ebp
 490:	c3                   	ret
 491:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 498:	00 
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a5:	83 ec 08             	sub    $0x8,%esp
 4a8:	6a 00                	push   $0x0
 4aa:	ff 75 08             	push   0x8(%ebp)
 4ad:	e8 f1 00 00 00       	call   5a3 <open>
  if(fd < 0)
 4b2:	83 c4 10             	add    $0x10,%esp
 4b5:	85 c0                	test   %eax,%eax
 4b7:	78 27                	js     4e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4b9:	83 ec 08             	sub    $0x8,%esp
 4bc:	ff 75 0c             	push   0xc(%ebp)
 4bf:	89 c3                	mov    %eax,%ebx
 4c1:	50                   	push   %eax
 4c2:	e8 f4 00 00 00       	call   5bb <fstat>
  close(fd);
 4c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ca:	89 c6                	mov    %eax,%esi
  close(fd);
 4cc:	e8 ba 00 00 00       	call   58b <close>
  return r;
 4d1:	83 c4 10             	add    $0x10,%esp
}
 4d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4d7:	89 f0                	mov    %esi,%eax
 4d9:	5b                   	pop    %ebx
 4da:	5e                   	pop    %esi
 4db:	5d                   	pop    %ebp
 4dc:	c3                   	ret
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4e5:	eb ed                	jmp    4d4 <stat+0x34>
 4e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4ee:	00 
 4ef:	90                   	nop

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	53                   	push   %ebx
 4f4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4f7:	0f be 02             	movsbl (%edx),%eax
 4fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4fd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 500:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 505:	77 1e                	ja     525 <atoi+0x35>
 507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 50e:	00 
 50f:	90                   	nop
    n = n*10 + *s++ - '0';
 510:	83 c2 01             	add    $0x1,%edx
 513:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 516:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 51a:	0f be 02             	movsbl (%edx),%eax
 51d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 520:	80 fb 09             	cmp    $0x9,%bl
 523:	76 eb                	jbe    510 <atoi+0x20>
  return n;
}
 525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 528:	89 c8                	mov    %ecx,%eax
 52a:	c9                   	leave
 52b:	c3                   	ret
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000530 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	8b 45 10             	mov    0x10(%ebp),%eax
 537:	8b 55 08             	mov    0x8(%ebp),%edx
 53a:	56                   	push   %esi
 53b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 53e:	85 c0                	test   %eax,%eax
 540:	7e 13                	jle    555 <memmove+0x25>
 542:	01 d0                	add    %edx,%eax
  dst = vdst;
 544:	89 d7                	mov    %edx,%edi
 546:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 54d:	00 
 54e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 550:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 551:	39 f8                	cmp    %edi,%eax
 553:	75 fb                	jne    550 <memmove+0x20>
  return vdst;
}
 555:	5e                   	pop    %esi
 556:	89 d0                	mov    %edx,%eax
 558:	5f                   	pop    %edi
 559:	5d                   	pop    %ebp
 55a:	c3                   	ret

0000055b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 55b:	b8 01 00 00 00       	mov    $0x1,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <exit>:
SYSCALL(exit)
 563:	b8 02 00 00 00       	mov    $0x2,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <wait>:
SYSCALL(wait)
 56b:	b8 03 00 00 00       	mov    $0x3,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <pipe>:
SYSCALL(pipe)
 573:	b8 04 00 00 00       	mov    $0x4,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <read>:
SYSCALL(read)
 57b:	b8 05 00 00 00       	mov    $0x5,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <write>:
SYSCALL(write)
 583:	b8 10 00 00 00       	mov    $0x10,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <close>:
SYSCALL(close)
 58b:	b8 15 00 00 00       	mov    $0x15,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <kill>:
SYSCALL(kill)
 593:	b8 06 00 00 00       	mov    $0x6,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <exec>:
SYSCALL(exec)
 59b:	b8 07 00 00 00       	mov    $0x7,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <open>:
SYSCALL(open)
 5a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <mknod>:
SYSCALL(mknod)
 5ab:	b8 11 00 00 00       	mov    $0x11,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <unlink>:
SYSCALL(unlink)
 5b3:	b8 12 00 00 00       	mov    $0x12,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <fstat>:
SYSCALL(fstat)
 5bb:	b8 08 00 00 00       	mov    $0x8,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <link>:
SYSCALL(link)
 5c3:	b8 13 00 00 00       	mov    $0x13,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret

000005cb <mkdir>:
SYSCALL(mkdir)
 5cb:	b8 14 00 00 00       	mov    $0x14,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret

000005d3 <chdir>:
SYSCALL(chdir)
 5d3:	b8 09 00 00 00       	mov    $0x9,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret

000005db <dup>:
SYSCALL(dup)
 5db:	b8 0a 00 00 00       	mov    $0xa,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret

000005e3 <getpid>:
SYSCALL(getpid)
 5e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret

000005eb <sbrk>:
SYSCALL(sbrk)
 5eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret

000005f3 <sleep>:
SYSCALL(sleep)
 5f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret

000005fb <uptime>:
SYSCALL(uptime)
 5fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret

00000603 <gethistory>:
SYSCALL(gethistory)
 603:	b8 16 00 00 00       	mov    $0x16,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret
 60b:	66 90                	xchg   %ax,%ax
 60d:	66 90                	xchg   %ax,%ax
 60f:	90                   	nop

00000610 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 3c             	sub    $0x3c,%esp
 619:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 61c:	89 d1                	mov    %edx,%ecx
{
 61e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 621:	85 d2                	test   %edx,%edx
 623:	0f 89 7f 00 00 00    	jns    6a8 <printint+0x98>
 629:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 62d:	74 79                	je     6a8 <printint+0x98>
    neg = 1;
 62f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 636:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 638:	31 db                	xor    %ebx,%ebx
 63a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 640:	89 c8                	mov    %ecx,%eax
 642:	31 d2                	xor    %edx,%edx
 644:	89 cf                	mov    %ecx,%edi
 646:	f7 75 c4             	divl   -0x3c(%ebp)
 649:	0f b6 92 c8 0b 00 00 	movzbl 0xbc8(%edx),%edx
 650:	89 45 c0             	mov    %eax,-0x40(%ebp)
 653:	89 d8                	mov    %ebx,%eax
 655:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 658:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 65b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 65e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 661:	76 dd                	jbe    640 <printint+0x30>
  if(neg)
 663:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 666:	85 c9                	test   %ecx,%ecx
 668:	74 0c                	je     676 <printint+0x66>
    buf[i++] = '-';
 66a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 66f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 671:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 676:	8b 7d b8             	mov    -0x48(%ebp),%edi
 679:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 67d:	eb 07                	jmp    686 <printint+0x76>
 67f:	90                   	nop
    putc(fd, buf[i]);
 680:	0f b6 13             	movzbl (%ebx),%edx
 683:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 686:	83 ec 04             	sub    $0x4,%esp
 689:	88 55 d7             	mov    %dl,-0x29(%ebp)
 68c:	6a 01                	push   $0x1
 68e:	56                   	push   %esi
 68f:	57                   	push   %edi
 690:	e8 ee fe ff ff       	call   583 <write>
  while(--i >= 0)
 695:	83 c4 10             	add    $0x10,%esp
 698:	39 de                	cmp    %ebx,%esi
 69a:	75 e4                	jne    680 <printint+0x70>
}
 69c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69f:	5b                   	pop    %ebx
 6a0:	5e                   	pop    %esi
 6a1:	5f                   	pop    %edi
 6a2:	5d                   	pop    %ebp
 6a3:	c3                   	ret
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6af:	eb 87                	jmp    638 <printint+0x28>
 6b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6b8:	00 
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000006c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 6cc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 6cf:	0f b6 13             	movzbl (%ebx),%edx
 6d2:	84 d2                	test   %dl,%dl
 6d4:	74 6a                	je     740 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 6d6:	8d 45 10             	lea    0x10(%ebp),%eax
 6d9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 6dc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6df:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 6e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6e4:	eb 36                	jmp    71c <printf+0x5c>
 6e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ed:	00 
 6ee:	66 90                	xchg   %ax,%ax
 6f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6f3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 6f8:	83 f8 25             	cmp    $0x25,%eax
 6fb:	74 15                	je     712 <printf+0x52>
  write(fd, &c, 1);
 6fd:	83 ec 04             	sub    $0x4,%esp
 700:	88 55 e7             	mov    %dl,-0x19(%ebp)
 703:	6a 01                	push   $0x1
 705:	57                   	push   %edi
 706:	56                   	push   %esi
 707:	e8 77 fe ff ff       	call   583 <write>
 70c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 70f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 712:	0f b6 13             	movzbl (%ebx),%edx
 715:	83 c3 01             	add    $0x1,%ebx
 718:	84 d2                	test   %dl,%dl
 71a:	74 24                	je     740 <printf+0x80>
    c = fmt[i] & 0xff;
 71c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 71f:	85 c9                	test   %ecx,%ecx
 721:	74 cd                	je     6f0 <printf+0x30>
      }
    } else if(state == '%'){
 723:	83 f9 25             	cmp    $0x25,%ecx
 726:	75 ea                	jne    712 <printf+0x52>
      if(c == 'd'){
 728:	83 f8 25             	cmp    $0x25,%eax
 72b:	0f 84 07 01 00 00    	je     838 <printf+0x178>
 731:	83 e8 63             	sub    $0x63,%eax
 734:	83 f8 15             	cmp    $0x15,%eax
 737:	77 17                	ja     750 <printf+0x90>
 739:	ff 24 85 70 0b 00 00 	jmp    *0xb70(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 740:	8d 65 f4             	lea    -0xc(%ebp),%esp
 743:	5b                   	pop    %ebx
 744:	5e                   	pop    %esi
 745:	5f                   	pop    %edi
 746:	5d                   	pop    %ebp
 747:	c3                   	ret
 748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 74f:	00 
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 756:	6a 01                	push   $0x1
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 75e:	e8 20 fe ff ff       	call   583 <write>
        putc(fd, c);
 763:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 767:	83 c4 0c             	add    $0xc,%esp
 76a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 76d:	6a 01                	push   $0x1
 76f:	57                   	push   %edi
 770:	56                   	push   %esi
 771:	e8 0d fe ff ff       	call   583 <write>
        putc(fd, c);
 776:	83 c4 10             	add    $0x10,%esp
      state = 0;
 779:	31 c9                	xor    %ecx,%ecx
 77b:	eb 95                	jmp    712 <printf+0x52>
 77d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 10 00 00 00       	mov    $0x10,%ecx
 788:	6a 00                	push   $0x0
 78a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 78d:	8b 10                	mov    (%eax),%edx
 78f:	89 f0                	mov    %esi,%eax
 791:	e8 7a fe ff ff       	call   610 <printint>
        ap++;
 796:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 79a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 79d:	31 c9                	xor    %ecx,%ecx
 79f:	e9 6e ff ff ff       	jmp    712 <printf+0x52>
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7ab:	8b 10                	mov    (%eax),%edx
        ap++;
 7ad:	83 c0 04             	add    $0x4,%eax
 7b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7b3:	85 d2                	test   %edx,%edx
 7b5:	0f 84 8d 00 00 00    	je     848 <printf+0x188>
        while(*s != 0){
 7bb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 7be:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 7c0:	84 c0                	test   %al,%al
 7c2:	0f 84 4a ff ff ff    	je     712 <printf+0x52>
 7c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 7cb:	89 d3                	mov    %edx,%ebx
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 7d0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7d3:	83 c3 01             	add    $0x1,%ebx
 7d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7d9:	6a 01                	push   $0x1
 7db:	57                   	push   %edi
 7dc:	56                   	push   %esi
 7dd:	e8 a1 fd ff ff       	call   583 <write>
        while(*s != 0){
 7e2:	0f b6 03             	movzbl (%ebx),%eax
 7e5:	83 c4 10             	add    $0x10,%esp
 7e8:	84 c0                	test   %al,%al
 7ea:	75 e4                	jne    7d0 <printf+0x110>
      state = 0;
 7ec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 7ef:	31 c9                	xor    %ecx,%ecx
 7f1:	e9 1c ff ff ff       	jmp    712 <printf+0x52>
 7f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7fd:	00 
 7fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 800:	83 ec 0c             	sub    $0xc,%esp
 803:	b9 0a 00 00 00       	mov    $0xa,%ecx
 808:	6a 01                	push   $0x1
 80a:	e9 7b ff ff ff       	jmp    78a <printf+0xca>
 80f:	90                   	nop
        putc(fd, *ap);
 810:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 813:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 816:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 818:	6a 01                	push   $0x1
 81a:	57                   	push   %edi
 81b:	56                   	push   %esi
        putc(fd, *ap);
 81c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 81f:	e8 5f fd ff ff       	call   583 <write>
        ap++;
 824:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 828:	83 c4 10             	add    $0x10,%esp
      state = 0;
 82b:	31 c9                	xor    %ecx,%ecx
 82d:	e9 e0 fe ff ff       	jmp    712 <printf+0x52>
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 838:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 83b:	83 ec 04             	sub    $0x4,%esp
 83e:	e9 2a ff ff ff       	jmp    76d <printf+0xad>
 843:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          s = "(null)";
 848:	ba ba 0a 00 00       	mov    $0xaba,%edx
        while(*s != 0){
 84d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 850:	b8 28 00 00 00       	mov    $0x28,%eax
 855:	89 d3                	mov    %edx,%ebx
 857:	e9 74 ff ff ff       	jmp    7d0 <printf+0x110>
 85c:	66 90                	xchg   %ax,%ax
 85e:	66 90                	xchg   %ax,%ax

00000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 861:	a1 ec 0e 00 00       	mov    0xeec,%eax
{
 866:	89 e5                	mov    %esp,%ebp
 868:	57                   	push   %edi
 869:	56                   	push   %esi
 86a:	53                   	push   %ebx
 86b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 86e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 878:	89 c2                	mov    %eax,%edx
 87a:	8b 00                	mov    (%eax),%eax
 87c:	39 ca                	cmp    %ecx,%edx
 87e:	73 30                	jae    8b0 <free+0x50>
 880:	39 c1                	cmp    %eax,%ecx
 882:	72 04                	jb     888 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	39 c2                	cmp    %eax,%edx
 886:	72 f0                	jb     878 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 888:	8b 73 fc             	mov    -0x4(%ebx),%esi
 88b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 88e:	39 f8                	cmp    %edi,%eax
 890:	74 30                	je     8c2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 895:	8b 42 04             	mov    0x4(%edx),%eax
 898:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 89b:	39 f1                	cmp    %esi,%ecx
 89d:	74 3a                	je     8d9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 89f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8a1:	5b                   	pop    %ebx
  freep = p;
 8a2:	89 15 ec 0e 00 00    	mov    %edx,0xeec
}
 8a8:	5e                   	pop    %esi
 8a9:	5f                   	pop    %edi
 8aa:	5d                   	pop    %ebp
 8ab:	c3                   	ret
 8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	39 c2                	cmp    %eax,%edx
 8b2:	72 c4                	jb     878 <free+0x18>
 8b4:	39 c1                	cmp    %eax,%ecx
 8b6:	73 c0                	jae    878 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 8b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8be:	39 f8                	cmp    %edi,%eax
 8c0:	75 d0                	jne    892 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 8c2:	03 70 04             	add    0x4(%eax),%esi
 8c5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c8:	8b 02                	mov    (%edx),%eax
 8ca:	8b 00                	mov    (%eax),%eax
 8cc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 8cf:	8b 42 04             	mov    0x4(%edx),%eax
 8d2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8d5:	39 f1                	cmp    %esi,%ecx
 8d7:	75 c6                	jne    89f <free+0x3f>
    p->s.size += bp->s.size;
 8d9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 8dc:	89 15 ec 0e 00 00    	mov    %edx,0xeec
    p->s.size += bp->s.size;
 8e2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 8e5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 8e8:	89 0a                	mov    %ecx,(%edx)
}
 8ea:	5b                   	pop    %ebx
 8eb:	5e                   	pop    %esi
 8ec:	5f                   	pop    %edi
 8ed:	5d                   	pop    %ebp
 8ee:	c3                   	ret
 8ef:	90                   	nop

000008f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	57                   	push   %edi
 8f4:	56                   	push   %esi
 8f5:	53                   	push   %ebx
 8f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8fc:	8b 3d ec 0e 00 00    	mov    0xeec,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 902:	8d 70 07             	lea    0x7(%eax),%esi
 905:	c1 ee 03             	shr    $0x3,%esi
 908:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 90b:	85 ff                	test   %edi,%edi
 90d:	0f 84 9d 00 00 00    	je     9b0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 913:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 915:	8b 4a 04             	mov    0x4(%edx),%ecx
 918:	39 f1                	cmp    %esi,%ecx
 91a:	73 6a                	jae    986 <malloc+0x96>
 91c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 921:	39 de                	cmp    %ebx,%esi
 923:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 926:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 92d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 930:	eb 17                	jmp    949 <malloc+0x59>
 932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 93a:	8b 48 04             	mov    0x4(%eax),%ecx
 93d:	39 f1                	cmp    %esi,%ecx
 93f:	73 4f                	jae    990 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 941:	8b 3d ec 0e 00 00    	mov    0xeec,%edi
 947:	89 c2                	mov    %eax,%edx
 949:	39 d7                	cmp    %edx,%edi
 94b:	75 eb                	jne    938 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 94d:	83 ec 0c             	sub    $0xc,%esp
 950:	ff 75 e4             	push   -0x1c(%ebp)
 953:	e8 93 fc ff ff       	call   5eb <sbrk>
  if(p == (char*)-1)
 958:	83 c4 10             	add    $0x10,%esp
 95b:	83 f8 ff             	cmp    $0xffffffff,%eax
 95e:	74 1c                	je     97c <malloc+0x8c>
  hp->s.size = nu;
 960:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 963:	83 ec 0c             	sub    $0xc,%esp
 966:	83 c0 08             	add    $0x8,%eax
 969:	50                   	push   %eax
 96a:	e8 f1 fe ff ff       	call   860 <free>
  return freep;
 96f:	8b 15 ec 0e 00 00    	mov    0xeec,%edx
      if((p = morecore(nunits)) == 0)
 975:	83 c4 10             	add    $0x10,%esp
 978:	85 d2                	test   %edx,%edx
 97a:	75 bc                	jne    938 <malloc+0x48>
        return 0;
  }
}
 97c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 97f:	31 c0                	xor    %eax,%eax
}
 981:	5b                   	pop    %ebx
 982:	5e                   	pop    %esi
 983:	5f                   	pop    %edi
 984:	5d                   	pop    %ebp
 985:	c3                   	ret
    if(p->s.size >= nunits){
 986:	89 d0                	mov    %edx,%eax
 988:	89 fa                	mov    %edi,%edx
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 990:	39 ce                	cmp    %ecx,%esi
 992:	74 4c                	je     9e0 <malloc+0xf0>
        p->s.size -= nunits;
 994:	29 f1                	sub    %esi,%ecx
 996:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 999:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 99c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 99f:	89 15 ec 0e 00 00    	mov    %edx,0xeec
}
 9a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9a8:	83 c0 08             	add    $0x8,%eax
}
 9ab:	5b                   	pop    %ebx
 9ac:	5e                   	pop    %esi
 9ad:	5f                   	pop    %edi
 9ae:	5d                   	pop    %ebp
 9af:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 9b0:	c7 05 ec 0e 00 00 f0 	movl   $0xef0,0xeec
 9b7:	0e 00 00 
    base.s.size = 0;
 9ba:	bf f0 0e 00 00       	mov    $0xef0,%edi
    base.s.ptr = freep = prevp = &base;
 9bf:	c7 05 f0 0e 00 00 f0 	movl   $0xef0,0xef0
 9c6:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 9cb:	c7 05 f4 0e 00 00 00 	movl   $0x0,0xef4
 9d2:	00 00 00 
    if(p->s.size >= nunits){
 9d5:	e9 42 ff ff ff       	jmp    91c <malloc+0x2c>
 9da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9e0:	8b 08                	mov    (%eax),%ecx
 9e2:	89 0a                	mov    %ecx,(%edx)
 9e4:	eb b9                	jmp    99f <malloc+0xaf>
