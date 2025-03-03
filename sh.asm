
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	push   -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	53                   	push   %ebx
       e:	51                   	push   %ecx
  static char buf[100];
  int fd;
  // 1. printf(1, "SHELL: Starting shell process\n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
       f:	eb 10                	jmp    21 <main+0x21>
      11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f cb 02 00 00    	jg     2ec <main+0x2ec>
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 98 16 00 00       	push   $0x1698
      2b:	e8 43 11 00 00       	call   1173 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
      3e:	00 
      3f:	90                   	nop
  printf(2, "$ ");
      40:	83 ec 08             	sub    $0x8,%esp
      43:	68 ff 15 00 00       	push   $0x15ff
      48:	6a 02                	push   $0x2
      4a:	e8 51 12 00 00       	call   12a0 <printf>
  memset(buf, 0, nbuf);
      4f:	83 c4 0c             	add    $0xc,%esp
      52:	6a 64                	push   $0x64
      54:	6a 00                	push   $0x0
      56:	68 c0 1d 00 00       	push   $0x1dc0
      5b:	e8 40 0f 00 00       	call   fa0 <memset>
  gets(buf, nbuf);
      60:	58                   	pop    %eax
      61:	5a                   	pop    %edx
      62:	6a 64                	push   $0x64
      64:	68 c0 1d 00 00       	push   $0x1dc0
      69:	e8 92 0f 00 00       	call   1000 <gets>
  if(buf[0] == 0) // EOF
      6e:	0f b6 05 c0 1d 00 00 	movzbl 0x1dc0,%eax
      75:	83 c4 10             	add    $0x10,%esp
      78:	84 c0                	test   %al,%al
      7a:	0f 84 92 02 00 00    	je     312 <main+0x312>
    }
  }

  // Read and run input commands.
  while (getcmd(buf, sizeof(buf)) >= 0) {
    if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y') {
      80:	3c 68                	cmp    $0x68,%al
      82:	0f 84 a8 00 00 00    	je     130 <main+0x130>
        history_command();
        continue;
    }
    if (buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k' && buf[5] == ' ') {
      88:	3c 62                	cmp    $0x62,%al
      8a:	0f 84 00 01 00 00    	je     190 <main+0x190>
        block_command(buf + 6);
        continue;
    }
    if (buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k' && buf[7] == ' ') {
      90:	3c 75                	cmp    $0x75,%al
      92:	75 0d                	jne    a1 <main+0xa1>
      94:	80 3d c1 1d 00 00 6e 	cmpb   $0x6e,0x1dc1
      9b:	0f 84 9f 01 00 00    	je     240 <main+0x240>
        unblock_command(buf + 8);
        continue;
    }
    buf[strlen(buf) - 1] = 0;  // Remove newline character
      a1:	83 ec 0c             	sub    $0xc,%esp
      a4:	68 c0 1d 00 00       	push   $0x1dc0
      a9:	e8 c2 0e 00 00       	call   f70 <strlen>
    
    if (strcmp(buf, "history") == 0) {
      ae:	5b                   	pop    %ebx
    buf[strlen(buf) - 1] = 0;  // Remove newline character
      af:	c6 80 bf 1d 00 00 00 	movb   $0x0,0x1dbf(%eax)
    if (strcmp(buf, "history") == 0) {
      b6:	58                   	pop    %eax
      b7:	68 a0 16 00 00       	push   $0x16a0
      bc:	68 c0 1d 00 00       	push   $0x1dc0
      c1:	e8 4a 0e 00 00       	call   f10 <strcmp>
      c6:	83 c4 10             	add    $0x10,%esp
      c9:	85 c0                	test   %eax,%eax
      cb:	0f 84 af 00 00 00    	je     180 <main+0x180>
        history_command();
        continue;
    }
    if (strcmp(buf, "block ") == 0) {
      d1:	83 ec 08             	sub    $0x8,%esp
      d4:	68 aa 16 00 00       	push   $0x16aa
      d9:	68 c0 1d 00 00       	push   $0x1dc0
      de:	e8 2d 0e 00 00       	call   f10 <strcmp>
      e3:	83 c4 10             	add    $0x10,%esp
      e6:	85 c0                	test   %eax,%eax
      e8:	0f 84 02 01 00 00    	je     1f0 <main+0x1f0>
        block_command(buf + 6);
        continue;
    }
    if (strcmp(buf, "unblock ") == 0) {
      ee:	83 ec 08             	sub    $0x8,%esp
      f1:	68 a8 16 00 00       	push   $0x16a8
      f6:	68 c0 1d 00 00       	push   $0x1dc0
      fb:	e8 10 0e 00 00       	call   f10 <strcmp>
     100:	83 c4 10             	add    $0x10,%esp
     103:	85 c0                	test   %eax,%eax
     105:	0f 84 9d 01 00 00    	je     2a8 <main+0x2a8>
int
fork1(void)
{
  int pid;

  pid = fork();
     10b:	e8 1b 10 00 00       	call   112b <fork>
  if(pid == -1)
     110:	83 f8 ff             	cmp    $0xffffffff,%eax
     113:	0f 84 fe 01 00 00    	je     317 <main+0x317>
    if (fork1() == 0)
     119:	85 c0                	test   %eax,%eax
     11b:	0f 84 dc 01 00 00    	je     2fd <main+0x2fd>
    wait();
     121:	e8 15 10 00 00       	call   113b <wait>
     126:	e9 15 ff ff ff       	jmp    40 <main+0x40>
     12b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y') {
     130:	80 3d c1 1d 00 00 69 	cmpb   $0x69,0x1dc1
     137:	0f 85 64 ff ff ff    	jne    a1 <main+0xa1>
     13d:	80 3d c2 1d 00 00 73 	cmpb   $0x73,0x1dc2
     144:	0f 85 57 ff ff ff    	jne    a1 <main+0xa1>
     14a:	80 3d c3 1d 00 00 74 	cmpb   $0x74,0x1dc3
     151:	0f 85 4a ff ff ff    	jne    a1 <main+0xa1>
     157:	80 3d c4 1d 00 00 6f 	cmpb   $0x6f,0x1dc4
     15e:	0f 85 3d ff ff ff    	jne    a1 <main+0xa1>
     164:	80 3d c5 1d 00 00 72 	cmpb   $0x72,0x1dc5
     16b:	0f 85 30 ff ff ff    	jne    a1 <main+0xa1>
     171:	80 3d c6 1d 00 00 79 	cmpb   $0x79,0x1dc6
     178:	0f 85 23 ff ff ff    	jne    a1 <main+0xa1>
     17e:	66 90                	xchg   %ax,%ax
        history_command();
     180:	e8 ab 01 00 00       	call   330 <history_command>
        continue;
     185:	e9 b6 fe ff ff       	jmp    40 <main+0x40>
     18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k' && buf[5] == ' ') {
     190:	80 3d c1 1d 00 00 6c 	cmpb   $0x6c,0x1dc1
     197:	0f 85 04 ff ff ff    	jne    a1 <main+0xa1>
     19d:	80 3d c2 1d 00 00 6f 	cmpb   $0x6f,0x1dc2
     1a4:	0f 85 f7 fe ff ff    	jne    a1 <main+0xa1>
     1aa:	80 3d c3 1d 00 00 63 	cmpb   $0x63,0x1dc3
     1b1:	0f 85 ea fe ff ff    	jne    a1 <main+0xa1>
     1b7:	80 3d c4 1d 00 00 6b 	cmpb   $0x6b,0x1dc4
     1be:	0f 85 dd fe ff ff    	jne    a1 <main+0xa1>
     1c4:	80 3d c5 1d 00 00 20 	cmpb   $0x20,0x1dc5
     1cb:	0f 85 d0 fe ff ff    	jne    a1 <main+0xa1>
        block_command(buf + 6);
     1d1:	83 ec 0c             	sub    $0xc,%esp
     1d4:	68 c6 1d 00 00       	push   $0x1dc6
     1d9:	e8 b2 01 00 00       	call   390 <block_command>
        continue;
     1de:	83 c4 10             	add    $0x10,%esp
     1e1:	e9 5a fe ff ff       	jmp    40 <main+0x40>
     1e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     1ed:	00 
     1ee:	66 90                	xchg   %ax,%ax
  int syscall_id = atoi(arg);
     1f0:	83 ec 0c             	sub    $0xc,%esp
     1f3:	68 c6 1d 00 00       	push   $0x1dc6
     1f8:	e8 c3 0e 00 00       	call   10c0 <atoi>
  if (syscall_id <= 0) {
     1fd:	83 c4 10             	add    $0x10,%esp
  int syscall_id = atoi(arg);
     200:	89 c3                	mov    %eax,%ebx
  if (syscall_id <= 0) {
     202:	85 c0                	test   %eax,%eax
     204:	0f 8e 36 fe ff ff    	jle    40 <main+0x40>
  if (block(syscall_id) < 0) {
     20a:	83 ec 0c             	sub    $0xc,%esp
     20d:	50                   	push   %eax
     20e:	e8 c8 0f 00 00       	call   11db <block>
     213:	83 c4 10             	add    $0x10,%esp
     216:	85 c0                	test   %eax,%eax
     218:	0f 88 22 fe ff ff    	js     40 <main+0x40>
      printf(1, "syscall %d is blocked\n", syscall_id);
     21e:	83 ec 04             	sub    $0x4,%esp
     221:	53                   	push   %ebx
     222:	68 d2 15 00 00       	push   $0x15d2
     227:	6a 01                	push   $0x1
     229:	e8 72 10 00 00       	call   12a0 <printf>
     22e:	83 c4 10             	add    $0x10,%esp
     231:	e9 0a fe ff ff       	jmp    40 <main+0x40>
     236:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     23d:	00 
     23e:	66 90                	xchg   %ax,%ax
    if (buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k' && buf[7] == ' ') {
     240:	80 3d c2 1d 00 00 62 	cmpb   $0x62,0x1dc2
     247:	0f 85 54 fe ff ff    	jne    a1 <main+0xa1>
     24d:	80 3d c3 1d 00 00 6c 	cmpb   $0x6c,0x1dc3
     254:	0f 85 47 fe ff ff    	jne    a1 <main+0xa1>
     25a:	80 3d c4 1d 00 00 6f 	cmpb   $0x6f,0x1dc4
     261:	0f 85 3a fe ff ff    	jne    a1 <main+0xa1>
     267:	80 3d c5 1d 00 00 63 	cmpb   $0x63,0x1dc5
     26e:	0f 85 2d fe ff ff    	jne    a1 <main+0xa1>
     274:	80 3d c6 1d 00 00 6b 	cmpb   $0x6b,0x1dc6
     27b:	0f 85 20 fe ff ff    	jne    a1 <main+0xa1>
     281:	80 3d c7 1d 00 00 20 	cmpb   $0x20,0x1dc7
     288:	0f 85 13 fe ff ff    	jne    a1 <main+0xa1>
        unblock_command(buf + 8);
     28e:	83 ec 0c             	sub    $0xc,%esp
     291:	68 c8 1d 00 00       	push   $0x1dc8
     296:	e8 45 01 00 00       	call   3e0 <unblock_command>
        continue;
     29b:	83 c4 10             	add    $0x10,%esp
     29e:	e9 9d fd ff ff       	jmp    40 <main+0x40>
     2a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  int syscall_id = atoi(arg);
     2a8:	83 ec 0c             	sub    $0xc,%esp
     2ab:	68 c8 1d 00 00       	push   $0x1dc8
     2b0:	e8 0b 0e 00 00       	call   10c0 <atoi>
  if (syscall_id <= 0) {
     2b5:	83 c4 10             	add    $0x10,%esp
  int syscall_id = atoi(arg);
     2b8:	89 c3                	mov    %eax,%ebx
  if (syscall_id <= 0) {
     2ba:	85 c0                	test   %eax,%eax
     2bc:	0f 8e 7e fd ff ff    	jle    40 <main+0x40>
  if (unblock(syscall_id) < 0) {
     2c2:	83 ec 0c             	sub    $0xc,%esp
     2c5:	50                   	push   %eax
     2c6:	e8 18 0f 00 00       	call   11e3 <unblock>
     2cb:	83 c4 10             	add    $0x10,%esp
     2ce:	85 c0                	test   %eax,%eax
     2d0:	0f 88 6a fd ff ff    	js     40 <main+0x40>
      printf(1, "syscall %d unblocked\n", syscall_id);
     2d6:	51                   	push   %ecx
     2d7:	53                   	push   %ebx
     2d8:	68 e9 15 00 00       	push   $0x15e9
     2dd:	6a 01                	push   $0x1
     2df:	e8 bc 0f 00 00       	call   12a0 <printf>
     2e4:	83 c4 10             	add    $0x10,%esp
     2e7:	e9 54 fd ff ff       	jmp    40 <main+0x40>
      close(fd);
     2ec:	83 ec 0c             	sub    $0xc,%esp
     2ef:	50                   	push   %eax
     2f0:	e8 66 0e 00 00       	call   115b <close>
      break;
     2f5:	83 c4 10             	add    $0x10,%esp
     2f8:	e9 43 fd ff ff       	jmp    40 <main+0x40>
        runcmd(parsecmd(buf));
     2fd:	83 ec 0c             	sub    $0xc,%esp
     300:	68 c0 1d 00 00       	push   $0x1dc0
     305:	e8 66 0b 00 00       	call   e70 <parsecmd>
     30a:	89 04 24             	mov    %eax,(%esp)
     30d:	e8 9e 01 00 00       	call   4b0 <runcmd>
  exit();
     312:	e8 1c 0e 00 00       	call   1133 <exit>
    panic("fork");
     317:	83 ec 0c             	sub    $0xc,%esp
     31a:	68 02 16 00 00       	push   $0x1602
     31f:	e8 4c 01 00 00       	call   470 <panic>
     324:	66 90                	xchg   %ax,%ax
     326:	66 90                	xchg   %ax,%ax
     328:	66 90                	xchg   %ax,%ax
     32a:	66 90                	xchg   %ax,%ax
     32c:	66 90                	xchg   %ax,%ax
     32e:	66 90                	xchg   %ax,%ax

00000330 <history_command>:
void history_command() {
     330:	55                   	push   %ebp
     331:	89 e5                	mov    %esp,%ebp
     333:	57                   	push   %edi
     334:	56                   	push   %esi
  int count = gethistory(hist, MAX_HISTORY);
     335:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
void history_command() {
     33b:	53                   	push   %ebx
     33c:	81 ec 04 01 00 00    	sub    $0x104,%esp
  int count = gethistory(hist, MAX_HISTORY);
     342:	6a 0a                	push   $0xa
     344:	50                   	push   %eax
     345:	e8 89 0e 00 00       	call   11d3 <gethistory>
  if (count < 0) {
     34a:	83 c4 10             	add    $0x10,%esp
     34d:	85 c0                	test   %eax,%eax
     34f:	78 32                	js     383 <history_command+0x53>
     351:	89 c7                	mov    %eax,%edi
  for (int i = 0; i < count; i++) {
     353:	8d 9d fc fe ff ff    	lea    -0x104(%ebp),%ebx
     359:	be 00 00 00 00       	mov    $0x0,%esi
     35e:	74 23                	je     383 <history_command+0x53>
      printf(1, "%d\t%s\t%d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     360:	83 ec 0c             	sub    $0xc,%esp
     363:	ff 73 10             	push   0x10(%ebx)
  for (int i = 0; i < count; i++) {
     366:	83 c6 01             	add    $0x1,%esi
      printf(1, "%d\t%s\t%d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     369:	53                   	push   %ebx
  for (int i = 0; i < count; i++) {
     36a:	83 c3 18             	add    $0x18,%ebx
      printf(1, "%d\t%s\t%d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     36d:	ff 73 e4             	push   -0x1c(%ebx)
     370:	68 c8 15 00 00       	push   $0x15c8
     375:	6a 01                	push   $0x1
     377:	e8 24 0f 00 00       	call   12a0 <printf>
  for (int i = 0; i < count; i++) {
     37c:	83 c4 20             	add    $0x20,%esp
     37f:	39 f7                	cmp    %esi,%edi
     381:	75 dd                	jne    360 <history_command+0x30>
}
     383:	8d 65 f4             	lea    -0xc(%ebp),%esp
     386:	5b                   	pop    %ebx
     387:	5e                   	pop    %esi
     388:	5f                   	pop    %edi
     389:	5d                   	pop    %ebp
     38a:	c3                   	ret
     38b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000390 <block_command>:
void block_command(char *arg) {
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	53                   	push   %ebx
     394:	83 ec 10             	sub    $0x10,%esp
  int syscall_id = atoi(arg);
     397:	ff 75 08             	push   0x8(%ebp)
     39a:	e8 21 0d 00 00       	call   10c0 <atoi>
  if (syscall_id <= 0) {
     39f:	83 c4 10             	add    $0x10,%esp
     3a2:	85 c0                	test   %eax,%eax
     3a4:	7e 12                	jle    3b8 <block_command+0x28>
  if (block(syscall_id) < 0) {
     3a6:	83 ec 0c             	sub    $0xc,%esp
     3a9:	89 c3                	mov    %eax,%ebx
     3ab:	50                   	push   %eax
     3ac:	e8 2a 0e 00 00       	call   11db <block>
     3b1:	83 c4 10             	add    $0x10,%esp
     3b4:	85 c0                	test   %eax,%eax
     3b6:	79 08                	jns    3c0 <block_command+0x30>
}
     3b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3bb:	c9                   	leave
     3bc:	c3                   	ret
     3bd:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "syscall %d is blocked\n", syscall_id);
     3c0:	83 ec 04             	sub    $0x4,%esp
     3c3:	53                   	push   %ebx
     3c4:	68 d2 15 00 00       	push   $0x15d2
     3c9:	6a 01                	push   $0x1
     3cb:	e8 d0 0e 00 00       	call   12a0 <printf>
}
     3d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      printf(1, "syscall %d is blocked\n", syscall_id);
     3d3:	83 c4 10             	add    $0x10,%esp
}
     3d6:	c9                   	leave
     3d7:	c3                   	ret
     3d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3df:	00 

000003e0 <unblock_command>:
void unblock_command(char *arg) {
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	53                   	push   %ebx
     3e4:	83 ec 10             	sub    $0x10,%esp
  int syscall_id = atoi(arg);
     3e7:	ff 75 08             	push   0x8(%ebp)
     3ea:	e8 d1 0c 00 00       	call   10c0 <atoi>
  if (syscall_id <= 0) {
     3ef:	83 c4 10             	add    $0x10,%esp
     3f2:	85 c0                	test   %eax,%eax
     3f4:	7e 12                	jle    408 <unblock_command+0x28>
  if (unblock(syscall_id) < 0) {
     3f6:	83 ec 0c             	sub    $0xc,%esp
     3f9:	89 c3                	mov    %eax,%ebx
     3fb:	50                   	push   %eax
     3fc:	e8 e2 0d 00 00       	call   11e3 <unblock>
     401:	83 c4 10             	add    $0x10,%esp
     404:	85 c0                	test   %eax,%eax
     406:	79 08                	jns    410 <unblock_command+0x30>
}
     408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     40b:	c9                   	leave
     40c:	c3                   	ret
     40d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "syscall %d unblocked\n", syscall_id);
     410:	83 ec 04             	sub    $0x4,%esp
     413:	53                   	push   %ebx
     414:	68 e9 15 00 00       	push   $0x15e9
     419:	6a 01                	push   $0x1
     41b:	e8 80 0e 00 00       	call   12a0 <printf>
}
     420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      printf(1, "syscall %d unblocked\n", syscall_id);
     423:	83 c4 10             	add    $0x10,%esp
}
     426:	c9                   	leave
     427:	c3                   	ret
     428:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     42f:	00 

00000430 <getcmd>:
{
     430:	55                   	push   %ebp
     431:	89 e5                	mov    %esp,%ebp
     433:	56                   	push   %esi
     434:	53                   	push   %ebx
     435:	8b 75 0c             	mov    0xc(%ebp),%esi
     438:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     43b:	83 ec 08             	sub    $0x8,%esp
     43e:	68 ff 15 00 00       	push   $0x15ff
     443:	6a 02                	push   $0x2
     445:	e8 56 0e 00 00       	call   12a0 <printf>
  memset(buf, 0, nbuf);
     44a:	83 c4 0c             	add    $0xc,%esp
     44d:	56                   	push   %esi
     44e:	6a 00                	push   $0x0
     450:	53                   	push   %ebx
     451:	e8 4a 0b 00 00       	call   fa0 <memset>
  gets(buf, nbuf);
     456:	58                   	pop    %eax
     457:	5a                   	pop    %edx
     458:	56                   	push   %esi
     459:	53                   	push   %ebx
     45a:	e8 a1 0b 00 00       	call   1000 <gets>
  if(buf[0] == 0) // EOF
     45f:	83 c4 10             	add    $0x10,%esp
     462:	80 3b 01             	cmpb   $0x1,(%ebx)
     465:	19 c0                	sbb    %eax,%eax
}
     467:	8d 65 f8             	lea    -0x8(%ebp),%esp
     46a:	5b                   	pop    %ebx
     46b:	5e                   	pop    %esi
     46c:	5d                   	pop    %ebp
     46d:	c3                   	ret
     46e:	66 90                	xchg   %ax,%ax

00000470 <panic>:
{
     470:	55                   	push   %ebp
     471:	89 e5                	mov    %esp,%ebp
     473:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     476:	ff 75 08             	push   0x8(%ebp)
     479:	68 94 16 00 00       	push   $0x1694
     47e:	6a 02                	push   $0x2
     480:	e8 1b 0e 00 00       	call   12a0 <printf>
  exit();
     485:	e8 a9 0c 00 00       	call   1133 <exit>
     48a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000490 <fork1>:
{
     490:	55                   	push   %ebp
     491:	89 e5                	mov    %esp,%ebp
     493:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     496:	e8 90 0c 00 00       	call   112b <fork>
  if(pid == -1)
     49b:	83 f8 ff             	cmp    $0xffffffff,%eax
     49e:	74 02                	je     4a2 <fork1+0x12>
  return pid;
}
     4a0:	c9                   	leave
     4a1:	c3                   	ret
    panic("fork");
     4a2:	83 ec 0c             	sub    $0xc,%esp
     4a5:	68 02 16 00 00       	push   $0x1602
     4aa:	e8 c1 ff ff ff       	call   470 <panic>
     4af:	90                   	nop

000004b0 <runcmd>:
{
     4b0:	55                   	push   %ebp
     4b1:	89 e5                	mov    %esp,%ebp
     4b3:	53                   	push   %ebx
     4b4:	83 ec 14             	sub    $0x14,%esp
     4b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     4ba:	85 db                	test   %ebx,%ebx
     4bc:	74 1f                	je     4dd <runcmd+0x2d>
  switch(cmd->type){
     4be:	83 3b 05             	cmpl   $0x5,(%ebx)
     4c1:	0f 87 ef 00 00 00    	ja     5b6 <runcmd+0x106>
     4c7:	8b 03                	mov    (%ebx),%eax
     4c9:	ff 24 85 b8 16 00 00 	jmp    *0x16b8(,%eax,4)
    if(fork1() == 0)
     4d0:	e8 bb ff ff ff       	call   490 <fork1>
     4d5:	85 c0                	test   %eax,%eax
     4d7:	0f 84 ce 00 00 00    	je     5ab <runcmd+0xfb>
    exit();
     4dd:	e8 51 0c 00 00       	call   1133 <exit>
    if (ecmd->argv[0] == 0)
     4e2:	8b 43 04             	mov    0x4(%ebx),%eax
     4e5:	85 c0                	test   %eax,%eax
     4e7:	74 f4                	je     4dd <runcmd+0x2d>
    if (strcmp(ecmd->argv[0], "unblock") == 0) {
     4e9:	52                   	push   %edx
     4ea:	52                   	push   %edx
     4eb:	68 0e 16 00 00       	push   $0x160e
     4f0:	50                   	push   %eax
     4f1:	e8 1a 0a 00 00       	call   f10 <strcmp>
     4f6:	83 c4 10             	add    $0x10,%esp
     4f9:	85 c0                	test   %eax,%eax
     4fb:	0f 84 12 01 00 00    	je     613 <runcmd+0x163>
    exec(ecmd->argv[0], ecmd->argv);
     501:	8d 43 04             	lea    0x4(%ebx),%eax
     504:	51                   	push   %ecx
     505:	51                   	push   %ecx
     506:	50                   	push   %eax
     507:	ff 73 04             	push   0x4(%ebx)
     50a:	e8 5c 0c 00 00       	call   116b <exec>
    exit();
     50f:	e8 1f 0c 00 00       	call   1133 <exit>
    if(pipe(p) < 0)
     514:	83 ec 0c             	sub    $0xc,%esp
     517:	8d 45 f0             	lea    -0x10(%ebp),%eax
     51a:	50                   	push   %eax
     51b:	e8 23 0c 00 00       	call   1143 <pipe>
     520:	83 c4 10             	add    $0x10,%esp
     523:	85 c0                	test   %eax,%eax
     525:	0f 88 ad 00 00 00    	js     5d8 <runcmd+0x128>
    if(fork1() == 0){
     52b:	e8 60 ff ff ff       	call   490 <fork1>
     530:	85 c0                	test   %eax,%eax
     532:	0f 84 ad 00 00 00    	je     5e5 <runcmd+0x135>
    if(fork1() == 0){
     538:	e8 53 ff ff ff       	call   490 <fork1>
     53d:	85 c0                	test   %eax,%eax
     53f:	0f 85 e0 00 00 00    	jne    625 <runcmd+0x175>
      close(0);
     545:	83 ec 0c             	sub    $0xc,%esp
     548:	6a 00                	push   $0x0
     54a:	e8 0c 0c 00 00       	call   115b <close>
      dup(p[0]);
     54f:	5a                   	pop    %edx
     550:	ff 75 f0             	push   -0x10(%ebp)
     553:	e8 53 0c 00 00       	call   11ab <dup>
      close(p[0]);
     558:	59                   	pop    %ecx
     559:	ff 75 f0             	push   -0x10(%ebp)
     55c:	e8 fa 0b 00 00       	call   115b <close>
      close(p[1]);
     561:	58                   	pop    %eax
     562:	ff 75 f4             	push   -0xc(%ebp)
     565:	e8 f1 0b 00 00       	call   115b <close>
      runcmd(pcmd->right);
     56a:	58                   	pop    %eax
     56b:	ff 73 08             	push   0x8(%ebx)
     56e:	e8 3d ff ff ff       	call   4b0 <runcmd>
    if(fork1() == 0)
     573:	e8 18 ff ff ff       	call   490 <fork1>
     578:	85 c0                	test   %eax,%eax
     57a:	74 2f                	je     5ab <runcmd+0xfb>
    wait();
     57c:	e8 ba 0b 00 00       	call   113b <wait>
    runcmd(lcmd->right);
     581:	83 ec 0c             	sub    $0xc,%esp
     584:	ff 73 08             	push   0x8(%ebx)
     587:	e8 24 ff ff ff       	call   4b0 <runcmd>
    close(rcmd->fd);
     58c:	83 ec 0c             	sub    $0xc,%esp
     58f:	ff 73 14             	push   0x14(%ebx)
     592:	e8 c4 0b 00 00       	call   115b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     597:	58                   	pop    %eax
     598:	5a                   	pop    %edx
     599:	ff 73 10             	push   0x10(%ebx)
     59c:	ff 73 08             	push   0x8(%ebx)
     59f:	e8 cf 0b 00 00       	call   1173 <open>
     5a4:	83 c4 10             	add    $0x10,%esp
     5a7:	85 c0                	test   %eax,%eax
     5a9:	78 18                	js     5c3 <runcmd+0x113>
      runcmd(bcmd->cmd);
     5ab:	83 ec 0c             	sub    $0xc,%esp
     5ae:	ff 73 04             	push   0x4(%ebx)
     5b1:	e8 fa fe ff ff       	call   4b0 <runcmd>
    panic("runcmd");
     5b6:	83 ec 0c             	sub    $0xc,%esp
     5b9:	68 07 16 00 00       	push   $0x1607
     5be:	e8 ad fe ff ff       	call   470 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     5c3:	51                   	push   %ecx
     5c4:	ff 73 08             	push   0x8(%ebx)
     5c7:	68 16 16 00 00       	push   $0x1616
     5cc:	6a 02                	push   $0x2
     5ce:	e8 cd 0c 00 00       	call   12a0 <printf>
      exit();
     5d3:	e8 5b 0b 00 00       	call   1133 <exit>
      panic("pipe");
     5d8:	83 ec 0c             	sub    $0xc,%esp
     5db:	68 26 16 00 00       	push   $0x1626
     5e0:	e8 8b fe ff ff       	call   470 <panic>
      close(1);
     5e5:	83 ec 0c             	sub    $0xc,%esp
     5e8:	6a 01                	push   $0x1
     5ea:	e8 6c 0b 00 00       	call   115b <close>
      dup(p[1]);
     5ef:	58                   	pop    %eax
     5f0:	ff 75 f4             	push   -0xc(%ebp)
     5f3:	e8 b3 0b 00 00       	call   11ab <dup>
      close(p[0]);
     5f8:	58                   	pop    %eax
     5f9:	ff 75 f0             	push   -0x10(%ebp)
     5fc:	e8 5a 0b 00 00       	call   115b <close>
      close(p[1]);
     601:	58                   	pop    %eax
     602:	ff 75 f4             	push   -0xc(%ebp)
     605:	e8 51 0b 00 00       	call   115b <close>
      runcmd(pcmd->left);
     60a:	5a                   	pop    %edx
     60b:	ff 73 04             	push   0x4(%ebx)
     60e:	e8 9d fe ff ff       	call   4b0 <runcmd>
        unblock(SYS_exec);
     613:	83 ec 0c             	sub    $0xc,%esp
     616:	6a 07                	push   $0x7
     618:	e8 c6 0b 00 00       	call   11e3 <unblock>
     61d:	83 c4 10             	add    $0x10,%esp
     620:	e9 dc fe ff ff       	jmp    501 <runcmd+0x51>
    close(p[0]);
     625:	83 ec 0c             	sub    $0xc,%esp
     628:	ff 75 f0             	push   -0x10(%ebp)
     62b:	e8 2b 0b 00 00       	call   115b <close>
    close(p[1]);
     630:	58                   	pop    %eax
     631:	ff 75 f4             	push   -0xc(%ebp)
     634:	e8 22 0b 00 00       	call   115b <close>
    wait();
     639:	e8 fd 0a 00 00       	call   113b <wait>
    wait();
     63e:	e8 f8 0a 00 00       	call   113b <wait>
    break;
     643:	83 c4 10             	add    $0x10,%esp
     646:	e9 92 fe ff ff       	jmp    4dd <runcmd+0x2d>
     64b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000650 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     650:	55                   	push   %ebp
     651:	89 e5                	mov    %esp,%ebp
     653:	53                   	push   %ebx
     654:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     657:	6a 54                	push   $0x54
     659:	e8 72 0e 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     65e:	83 c4 0c             	add    $0xc,%esp
     661:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     663:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     665:	6a 00                	push   $0x0
     667:	50                   	push   %eax
     668:	e8 33 09 00 00       	call   fa0 <memset>
  cmd->type = EXEC;
     66d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     673:	89 d8                	mov    %ebx,%eax
     675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     678:	c9                   	leave
     679:	c3                   	ret
     67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000680 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     680:	55                   	push   %ebp
     681:	89 e5                	mov    %esp,%ebp
     683:	53                   	push   %ebx
     684:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     687:	6a 18                	push   $0x18
     689:	e8 42 0e 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     68e:	83 c4 0c             	add    $0xc,%esp
     691:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     693:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     695:	6a 00                	push   $0x0
     697:	50                   	push   %eax
     698:	e8 03 09 00 00       	call   fa0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     69d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     6a0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     6a6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     6a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     6ac:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     6af:	8b 45 10             	mov    0x10(%ebp),%eax
     6b2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     6b5:	8b 45 14             	mov    0x14(%ebp),%eax
     6b8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     6bb:	8b 45 18             	mov    0x18(%ebp),%eax
     6be:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     6c1:	89 d8                	mov    %ebx,%eax
     6c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     6c6:	c9                   	leave
     6c7:	c3                   	ret
     6c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     6cf:	00 

000006d0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     6d0:	55                   	push   %ebp
     6d1:	89 e5                	mov    %esp,%ebp
     6d3:	53                   	push   %ebx
     6d4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6d7:	6a 0c                	push   $0xc
     6d9:	e8 f2 0d 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6de:	83 c4 0c             	add    $0xc,%esp
     6e1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     6e3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     6e5:	6a 00                	push   $0x0
     6e7:	50                   	push   %eax
     6e8:	e8 b3 08 00 00       	call   fa0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     6ed:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     6f0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     6f6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     6f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     6fc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     6ff:	89 d8                	mov    %ebx,%eax
     701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     704:	c9                   	leave
     705:	c3                   	ret
     706:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     70d:	00 
     70e:	66 90                	xchg   %ax,%ax

00000710 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     710:	55                   	push   %ebp
     711:	89 e5                	mov    %esp,%ebp
     713:	53                   	push   %ebx
     714:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     717:	6a 0c                	push   $0xc
     719:	e8 b2 0d 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     71e:	83 c4 0c             	add    $0xc,%esp
     721:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     723:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     725:	6a 00                	push   $0x0
     727:	50                   	push   %eax
     728:	e8 73 08 00 00       	call   fa0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     72d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     730:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     736:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     739:	8b 45 0c             	mov    0xc(%ebp),%eax
     73c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     73f:	89 d8                	mov    %ebx,%eax
     741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     744:	c9                   	leave
     745:	c3                   	ret
     746:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     74d:	00 
     74e:	66 90                	xchg   %ax,%ax

00000750 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     750:	55                   	push   %ebp
     751:	89 e5                	mov    %esp,%ebp
     753:	53                   	push   %ebx
     754:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     757:	6a 08                	push   $0x8
     759:	e8 72 0d 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     75e:	83 c4 0c             	add    $0xc,%esp
     761:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     763:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     765:	6a 00                	push   $0x0
     767:	50                   	push   %eax
     768:	e8 33 08 00 00       	call   fa0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     76d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     770:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     776:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     779:	89 d8                	mov    %ebx,%eax
     77b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     77e:	c9                   	leave
     77f:	c3                   	ret

00000780 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     780:	55                   	push   %ebp
     781:	89 e5                	mov    %esp,%ebp
     783:	57                   	push   %edi
     784:	56                   	push   %esi
     785:	53                   	push   %ebx
     786:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     789:	8b 45 08             	mov    0x8(%ebp),%eax
{
     78c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     78f:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     792:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     794:	39 df                	cmp    %ebx,%edi
     796:	72 0f                	jb     7a7 <gettoken+0x27>
     798:	eb 25                	jmp    7bf <gettoken+0x3f>
     79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     7a0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     7a3:	39 fb                	cmp    %edi,%ebx
     7a5:	74 18                	je     7bf <gettoken+0x3f>
     7a7:	0f be 07             	movsbl (%edi),%eax
     7aa:	83 ec 08             	sub    $0x8,%esp
     7ad:	50                   	push   %eax
     7ae:	68 a4 1d 00 00       	push   $0x1da4
     7b3:	e8 08 08 00 00       	call   fc0 <strchr>
     7b8:	83 c4 10             	add    $0x10,%esp
     7bb:	85 c0                	test   %eax,%eax
     7bd:	75 e1                	jne    7a0 <gettoken+0x20>
  if(q)
     7bf:	85 f6                	test   %esi,%esi
     7c1:	74 02                	je     7c5 <gettoken+0x45>
    *q = s;
     7c3:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     7c5:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     7c8:	3c 3c                	cmp    $0x3c,%al
     7ca:	0f 8f d0 00 00 00    	jg     8a0 <gettoken+0x120>
     7d0:	3c 3a                	cmp    $0x3a,%al
     7d2:	0f 8f b4 00 00 00    	jg     88c <gettoken+0x10c>
     7d8:	84 c0                	test   %al,%al
     7da:	75 44                	jne    820 <gettoken+0xa0>
     7dc:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     7de:	8b 55 14             	mov    0x14(%ebp),%edx
     7e1:	85 d2                	test   %edx,%edx
     7e3:	74 05                	je     7ea <gettoken+0x6a>
    *eq = s;
     7e5:	8b 45 14             	mov    0x14(%ebp),%eax
     7e8:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     7ea:	39 df                	cmp    %ebx,%edi
     7ec:	72 09                	jb     7f7 <gettoken+0x77>
     7ee:	eb 1f                	jmp    80f <gettoken+0x8f>
    s++;
     7f0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     7f3:	39 fb                	cmp    %edi,%ebx
     7f5:	74 18                	je     80f <gettoken+0x8f>
     7f7:	0f be 07             	movsbl (%edi),%eax
     7fa:	83 ec 08             	sub    $0x8,%esp
     7fd:	50                   	push   %eax
     7fe:	68 a4 1d 00 00       	push   $0x1da4
     803:	e8 b8 07 00 00       	call   fc0 <strchr>
     808:	83 c4 10             	add    $0x10,%esp
     80b:	85 c0                	test   %eax,%eax
     80d:	75 e1                	jne    7f0 <gettoken+0x70>
  *ps = s;
     80f:	8b 45 08             	mov    0x8(%ebp),%eax
     812:	89 38                	mov    %edi,(%eax)
  return ret;
}
     814:	8d 65 f4             	lea    -0xc(%ebp),%esp
     817:	89 f0                	mov    %esi,%eax
     819:	5b                   	pop    %ebx
     81a:	5e                   	pop    %esi
     81b:	5f                   	pop    %edi
     81c:	5d                   	pop    %ebp
     81d:	c3                   	ret
     81e:	66 90                	xchg   %ax,%ax
  switch(*s){
     820:	79 5e                	jns    880 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     822:	39 fb                	cmp    %edi,%ebx
     824:	77 34                	ja     85a <gettoken+0xda>
  if(eq)
     826:	8b 45 14             	mov    0x14(%ebp),%eax
     829:	be 61 00 00 00       	mov    $0x61,%esi
     82e:	85 c0                	test   %eax,%eax
     830:	75 b3                	jne    7e5 <gettoken+0x65>
     832:	eb db                	jmp    80f <gettoken+0x8f>
     834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     838:	0f be 07             	movsbl (%edi),%eax
     83b:	83 ec 08             	sub    $0x8,%esp
     83e:	50                   	push   %eax
     83f:	68 9c 1d 00 00       	push   $0x1d9c
     844:	e8 77 07 00 00       	call   fc0 <strchr>
     849:	83 c4 10             	add    $0x10,%esp
     84c:	85 c0                	test   %eax,%eax
     84e:	75 22                	jne    872 <gettoken+0xf2>
      s++;
     850:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     853:	39 fb                	cmp    %edi,%ebx
     855:	74 cf                	je     826 <gettoken+0xa6>
     857:	0f b6 07             	movzbl (%edi),%eax
     85a:	83 ec 08             	sub    $0x8,%esp
     85d:	0f be f0             	movsbl %al,%esi
     860:	56                   	push   %esi
     861:	68 a4 1d 00 00       	push   $0x1da4
     866:	e8 55 07 00 00       	call   fc0 <strchr>
     86b:	83 c4 10             	add    $0x10,%esp
     86e:	85 c0                	test   %eax,%eax
     870:	74 c6                	je     838 <gettoken+0xb8>
    ret = 'a';
     872:	be 61 00 00 00       	mov    $0x61,%esi
     877:	e9 62 ff ff ff       	jmp    7de <gettoken+0x5e>
     87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     880:	3c 26                	cmp    $0x26,%al
     882:	74 08                	je     88c <gettoken+0x10c>
     884:	8d 48 d8             	lea    -0x28(%eax),%ecx
     887:	80 f9 01             	cmp    $0x1,%cl
     88a:	77 96                	ja     822 <gettoken+0xa2>
  ret = *s;
     88c:	0f be f0             	movsbl %al,%esi
    s++;
     88f:	83 c7 01             	add    $0x1,%edi
    break;
     892:	e9 47 ff ff ff       	jmp    7de <gettoken+0x5e>
     897:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     89e:	00 
     89f:	90                   	nop
  switch(*s){
     8a0:	3c 3e                	cmp    $0x3e,%al
     8a2:	75 1c                	jne    8c0 <gettoken+0x140>
    if(*s == '>'){
     8a4:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     8a8:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     8ab:	74 1c                	je     8c9 <gettoken+0x149>
    s++;
     8ad:	89 c7                	mov    %eax,%edi
     8af:	be 3e 00 00 00       	mov    $0x3e,%esi
     8b4:	e9 25 ff ff ff       	jmp    7de <gettoken+0x5e>
     8b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     8c0:	3c 7c                	cmp    $0x7c,%al
     8c2:	74 c8                	je     88c <gettoken+0x10c>
     8c4:	e9 59 ff ff ff       	jmp    822 <gettoken+0xa2>
      s++;
     8c9:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     8cc:	be 2b 00 00 00       	mov    $0x2b,%esi
     8d1:	e9 08 ff ff ff       	jmp    7de <gettoken+0x5e>
     8d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8dd:	00 
     8de:	66 90                	xchg   %ax,%ax

000008e0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     8e0:	55                   	push   %ebp
     8e1:	89 e5                	mov    %esp,%ebp
     8e3:	57                   	push   %edi
     8e4:	56                   	push   %esi
     8e5:	53                   	push   %ebx
     8e6:	83 ec 0c             	sub    $0xc,%esp
     8e9:	8b 7d 08             	mov    0x8(%ebp),%edi
     8ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     8ef:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     8f1:	39 f3                	cmp    %esi,%ebx
     8f3:	72 12                	jb     907 <peek+0x27>
     8f5:	eb 28                	jmp    91f <peek+0x3f>
     8f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8fe:	00 
     8ff:	90                   	nop
    s++;
     900:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     903:	39 de                	cmp    %ebx,%esi
     905:	74 18                	je     91f <peek+0x3f>
     907:	0f be 03             	movsbl (%ebx),%eax
     90a:	83 ec 08             	sub    $0x8,%esp
     90d:	50                   	push   %eax
     90e:	68 a4 1d 00 00       	push   $0x1da4
     913:	e8 a8 06 00 00       	call   fc0 <strchr>
     918:	83 c4 10             	add    $0x10,%esp
     91b:	85 c0                	test   %eax,%eax
     91d:	75 e1                	jne    900 <peek+0x20>
  *ps = s;
     91f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     921:	0f be 03             	movsbl (%ebx),%eax
     924:	31 d2                	xor    %edx,%edx
     926:	84 c0                	test   %al,%al
     928:	75 0e                	jne    938 <peek+0x58>
}
     92a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     92d:	89 d0                	mov    %edx,%eax
     92f:	5b                   	pop    %ebx
     930:	5e                   	pop    %esi
     931:	5f                   	pop    %edi
     932:	5d                   	pop    %ebp
     933:	c3                   	ret
     934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     938:	83 ec 08             	sub    $0x8,%esp
     93b:	50                   	push   %eax
     93c:	ff 75 10             	push   0x10(%ebp)
     93f:	e8 7c 06 00 00       	call   fc0 <strchr>
     944:	83 c4 10             	add    $0x10,%esp
     947:	31 d2                	xor    %edx,%edx
     949:	85 c0                	test   %eax,%eax
     94b:	0f 95 c2             	setne  %dl
}
     94e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     951:	5b                   	pop    %ebx
     952:	89 d0                	mov    %edx,%eax
     954:	5e                   	pop    %esi
     955:	5f                   	pop    %edi
     956:	5d                   	pop    %ebp
     957:	c3                   	ret
     958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     95f:	00 

00000960 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     960:	55                   	push   %ebp
     961:	89 e5                	mov    %esp,%ebp
     963:	57                   	push   %edi
     964:	56                   	push   %esi
     965:	53                   	push   %ebx
     966:	83 ec 2c             	sub    $0x2c,%esp
     969:	8b 75 0c             	mov    0xc(%ebp),%esi
     96c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     96f:	90                   	nop
     970:	83 ec 04             	sub    $0x4,%esp
     973:	68 48 16 00 00       	push   $0x1648
     978:	53                   	push   %ebx
     979:	56                   	push   %esi
     97a:	e8 61 ff ff ff       	call   8e0 <peek>
     97f:	83 c4 10             	add    $0x10,%esp
     982:	85 c0                	test   %eax,%eax
     984:	0f 84 f6 00 00 00    	je     a80 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     98a:	6a 00                	push   $0x0
     98c:	6a 00                	push   $0x0
     98e:	53                   	push   %ebx
     98f:	56                   	push   %esi
     990:	e8 eb fd ff ff       	call   780 <gettoken>
     995:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     997:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     99a:	50                   	push   %eax
     99b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     99e:	50                   	push   %eax
     99f:	53                   	push   %ebx
     9a0:	56                   	push   %esi
     9a1:	e8 da fd ff ff       	call   780 <gettoken>
     9a6:	83 c4 20             	add    $0x20,%esp
     9a9:	83 f8 61             	cmp    $0x61,%eax
     9ac:	0f 85 d9 00 00 00    	jne    a8b <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     9b2:	83 ff 3c             	cmp    $0x3c,%edi
     9b5:	74 69                	je     a20 <parseredirs+0xc0>
     9b7:	83 ff 3e             	cmp    $0x3e,%edi
     9ba:	74 05                	je     9c1 <parseredirs+0x61>
     9bc:	83 ff 2b             	cmp    $0x2b,%edi
     9bf:	75 af                	jne    970 <parseredirs+0x10>
  cmd = malloc(sizeof(*cmd));
     9c1:	83 ec 0c             	sub    $0xc,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     9c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     9ca:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9cc:	89 55 d0             	mov    %edx,-0x30(%ebp)
     9cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     9d2:	e8 f9 0a 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     9d7:	83 c4 0c             	add    $0xc,%esp
     9da:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     9dc:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     9de:	6a 00                	push   $0x0
     9e0:	50                   	push   %eax
     9e1:	e8 ba 05 00 00       	call   fa0 <memset>
  cmd->type = REDIR;
     9e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     9ec:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     9ef:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     9f2:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     9f5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     9f8:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     9fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     9fe:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     a05:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     a08:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      break;
     a0f:	89 7d 08             	mov    %edi,0x8(%ebp)
     a12:	e9 59 ff ff ff       	jmp    970 <parseredirs+0x10>
     a17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a1e:	00 
     a1f:	90                   	nop
  cmd = malloc(sizeof(*cmd));
     a20:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     a23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     a26:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     a29:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     a2b:	89 55 d0             	mov    %edx,-0x30(%ebp)
     a2e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     a31:	e8 9a 0a 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     a36:	83 c4 0c             	add    $0xc,%esp
     a39:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     a3b:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     a3d:	6a 00                	push   $0x0
     a3f:	50                   	push   %eax
     a40:	e8 5b 05 00 00       	call   fa0 <memset>
  cmd->cmd = subcmd;
     a45:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     a48:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     a4b:	89 7d 08             	mov    %edi,0x8(%ebp)
  cmd->efile = efile;
     a4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     a51:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
      break;
     a57:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     a5a:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     a5d:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     a60:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     a63:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     a6a:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      break;
     a71:	e9 fa fe ff ff       	jmp    970 <parseredirs+0x10>
     a76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a7d:	00 
     a7e:	66 90                	xchg   %ax,%ax
    }
  }
  return cmd;
}
     a80:	8b 45 08             	mov    0x8(%ebp),%eax
     a83:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a86:	5b                   	pop    %ebx
     a87:	5e                   	pop    %esi
     a88:	5f                   	pop    %edi
     a89:	5d                   	pop    %ebp
     a8a:	c3                   	ret
      panic("missing file for redirection");
     a8b:	83 ec 0c             	sub    $0xc,%esp
     a8e:	68 2b 16 00 00       	push   $0x162b
     a93:	e8 d8 f9 ff ff       	call   470 <panic>
     a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a9f:	00 

00000aa0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     aa0:	55                   	push   %ebp
     aa1:	89 e5                	mov    %esp,%ebp
     aa3:	57                   	push   %edi
     aa4:	56                   	push   %esi
     aa5:	53                   	push   %ebx
     aa6:	83 ec 30             	sub    $0x30,%esp
     aa9:	8b 75 08             	mov    0x8(%ebp),%esi
     aac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     aaf:	68 4b 16 00 00       	push   $0x164b
     ab4:	57                   	push   %edi
     ab5:	56                   	push   %esi
     ab6:	e8 25 fe ff ff       	call   8e0 <peek>
     abb:	83 c4 10             	add    $0x10,%esp
     abe:	85 c0                	test   %eax,%eax
     ac0:	0f 85 aa 00 00 00    	jne    b70 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     ac6:	83 ec 0c             	sub    $0xc,%esp
     ac9:	89 c3                	mov    %eax,%ebx
     acb:	6a 54                	push   $0x54
     acd:	e8 fe 09 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     ad2:	83 c4 0c             	add    $0xc,%esp
     ad5:	6a 54                	push   $0x54
     ad7:	6a 00                	push   $0x0
     ad9:	50                   	push   %eax
     ada:	89 45 d0             	mov    %eax,-0x30(%ebp)
     add:	e8 be 04 00 00       	call   fa0 <memset>
  cmd->type = EXEC;
     ae2:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     ae5:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     ae8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     aee:	57                   	push   %edi
     aef:	56                   	push   %esi
     af0:	50                   	push   %eax
     af1:	e8 6a fe ff ff       	call   960 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     af6:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     af9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     afc:	eb 15                	jmp    b13 <parseexec+0x73>
     afe:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     b00:	83 ec 04             	sub    $0x4,%esp
     b03:	57                   	push   %edi
     b04:	56                   	push   %esi
     b05:	ff 75 d4             	push   -0x2c(%ebp)
     b08:	e8 53 fe ff ff       	call   960 <parseredirs>
     b0d:	83 c4 10             	add    $0x10,%esp
     b10:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     b13:	83 ec 04             	sub    $0x4,%esp
     b16:	68 62 16 00 00       	push   $0x1662
     b1b:	57                   	push   %edi
     b1c:	56                   	push   %esi
     b1d:	e8 be fd ff ff       	call   8e0 <peek>
     b22:	83 c4 10             	add    $0x10,%esp
     b25:	85 c0                	test   %eax,%eax
     b27:	75 5f                	jne    b88 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b29:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b2c:	50                   	push   %eax
     b2d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b30:	50                   	push   %eax
     b31:	57                   	push   %edi
     b32:	56                   	push   %esi
     b33:	e8 48 fc ff ff       	call   780 <gettoken>
     b38:	83 c4 10             	add    $0x10,%esp
     b3b:	85 c0                	test   %eax,%eax
     b3d:	74 49                	je     b88 <parseexec+0xe8>
    if(tok != 'a')
     b3f:	83 f8 61             	cmp    $0x61,%eax
     b42:	75 62                	jne    ba6 <parseexec+0x106>
    cmd->argv[argc] = q;
     b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b47:	8b 55 d0             	mov    -0x30(%ebp),%edx
     b4a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     b4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b51:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     b55:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     b58:	83 fb 0a             	cmp    $0xa,%ebx
     b5b:	75 a3                	jne    b00 <parseexec+0x60>
      panic("too many args");
     b5d:	83 ec 0c             	sub    $0xc,%esp
     b60:	68 54 16 00 00       	push   $0x1654
     b65:	e8 06 f9 ff ff       	call   470 <panic>
     b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     b70:	89 7d 0c             	mov    %edi,0xc(%ebp)
     b73:	89 75 08             	mov    %esi,0x8(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b79:	5b                   	pop    %ebx
     b7a:	5e                   	pop    %esi
     b7b:	5f                   	pop    %edi
     b7c:	5d                   	pop    %ebp
    return parseblock(ps, es);
     b7d:	e9 ae 01 00 00       	jmp    d30 <parseblock>
     b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc] = 0;
     b88:	8b 45 d0             	mov    -0x30(%ebp),%eax
     b8b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     b92:	00 
  cmd->eargv[argc] = 0;
     b93:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     b9a:	00 
}
     b9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ba1:	5b                   	pop    %ebx
     ba2:	5e                   	pop    %esi
     ba3:	5f                   	pop    %edi
     ba4:	5d                   	pop    %ebp
     ba5:	c3                   	ret
      panic("syntax");
     ba6:	83 ec 0c             	sub    $0xc,%esp
     ba9:	68 4d 16 00 00       	push   $0x164d
     bae:	e8 bd f8 ff ff       	call   470 <panic>
     bb3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     bba:	00 
     bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000bc0 <parsepipe>:
{
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	57                   	push   %edi
     bc4:	56                   	push   %esi
     bc5:	53                   	push   %ebx
     bc6:	83 ec 14             	sub    $0x14,%esp
     bc9:	8b 75 08             	mov    0x8(%ebp),%esi
     bcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     bcf:	57                   	push   %edi
     bd0:	56                   	push   %esi
     bd1:	e8 ca fe ff ff       	call   aa0 <parseexec>
  if(peek(ps, es, "|")){
     bd6:	83 c4 0c             	add    $0xc,%esp
     bd9:	68 67 16 00 00       	push   $0x1667
  cmd = parseexec(ps, es);
     bde:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     be0:	57                   	push   %edi
     be1:	56                   	push   %esi
     be2:	e8 f9 fc ff ff       	call   8e0 <peek>
     be7:	83 c4 10             	add    $0x10,%esp
     bea:	85 c0                	test   %eax,%eax
     bec:	75 12                	jne    c00 <parsepipe+0x40>
}
     bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bf1:	89 d8                	mov    %ebx,%eax
     bf3:	5b                   	pop    %ebx
     bf4:	5e                   	pop    %esi
     bf5:	5f                   	pop    %edi
     bf6:	5d                   	pop    %ebp
     bf7:	c3                   	ret
     bf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     bff:	00 
    gettoken(ps, es, 0, 0);
     c00:	6a 00                	push   $0x0
     c02:	6a 00                	push   $0x0
     c04:	57                   	push   %edi
     c05:	56                   	push   %esi
     c06:	e8 75 fb ff ff       	call   780 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     c0b:	58                   	pop    %eax
     c0c:	5a                   	pop    %edx
     c0d:	57                   	push   %edi
     c0e:	56                   	push   %esi
     c0f:	e8 ac ff ff ff       	call   bc0 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     c14:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     c1b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     c1d:	e8 ae 08 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     c22:	83 c4 0c             	add    $0xc,%esp
     c25:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     c27:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     c29:	6a 00                	push   $0x0
     c2b:	50                   	push   %eax
     c2c:	e8 6f 03 00 00       	call   fa0 <memset>
  cmd->left = left;
     c31:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     c34:	83 c4 10             	add    $0x10,%esp
     c37:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     c39:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     c3f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     c41:	89 7e 08             	mov    %edi,0x8(%esi)
}
     c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c47:	5b                   	pop    %ebx
     c48:	5e                   	pop    %esi
     c49:	5f                   	pop    %edi
     c4a:	5d                   	pop    %ebp
     c4b:	c3                   	ret
     c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c50 <parseline>:
{
     c50:	55                   	push   %ebp
     c51:	89 e5                	mov    %esp,%ebp
     c53:	57                   	push   %edi
     c54:	56                   	push   %esi
     c55:	53                   	push   %ebx
     c56:	83 ec 24             	sub    $0x24,%esp
     c59:	8b 75 08             	mov    0x8(%ebp),%esi
     c5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     c5f:	57                   	push   %edi
     c60:	56                   	push   %esi
     c61:	e8 5a ff ff ff       	call   bc0 <parsepipe>
  while(peek(ps, es, "&")){
     c66:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     c69:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     c6b:	eb 3b                	jmp    ca8 <parseline+0x58>
     c6d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     c70:	6a 00                	push   $0x0
     c72:	6a 00                	push   $0x0
     c74:	57                   	push   %edi
     c75:	56                   	push   %esi
     c76:	e8 05 fb ff ff       	call   780 <gettoken>
  cmd = malloc(sizeof(*cmd));
     c7b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     c82:	e8 49 08 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     c87:	83 c4 0c             	add    $0xc,%esp
     c8a:	6a 08                	push   $0x8
     c8c:	6a 00                	push   $0x0
     c8e:	50                   	push   %eax
     c8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     c92:	e8 09 03 00 00       	call   fa0 <memset>
  cmd->type = BACK;
     c97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     c9a:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     c9d:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     ca3:	89 5a 04             	mov    %ebx,0x4(%edx)
     ca6:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     ca8:	83 ec 04             	sub    $0x4,%esp
     cab:	68 69 16 00 00       	push   $0x1669
     cb0:	57                   	push   %edi
     cb1:	56                   	push   %esi
     cb2:	e8 29 fc ff ff       	call   8e0 <peek>
     cb7:	83 c4 10             	add    $0x10,%esp
     cba:	85 c0                	test   %eax,%eax
     cbc:	75 b2                	jne    c70 <parseline+0x20>
  if(peek(ps, es, ";")){
     cbe:	83 ec 04             	sub    $0x4,%esp
     cc1:	68 65 16 00 00       	push   $0x1665
     cc6:	57                   	push   %edi
     cc7:	56                   	push   %esi
     cc8:	e8 13 fc ff ff       	call   8e0 <peek>
     ccd:	83 c4 10             	add    $0x10,%esp
     cd0:	85 c0                	test   %eax,%eax
     cd2:	75 0c                	jne    ce0 <parseline+0x90>
}
     cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cd7:	89 d8                	mov    %ebx,%eax
     cd9:	5b                   	pop    %ebx
     cda:	5e                   	pop    %esi
     cdb:	5f                   	pop    %edi
     cdc:	5d                   	pop    %ebp
     cdd:	c3                   	ret
     cde:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     ce0:	6a 00                	push   $0x0
     ce2:	6a 00                	push   $0x0
     ce4:	57                   	push   %edi
     ce5:	56                   	push   %esi
     ce6:	e8 95 fa ff ff       	call   780 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     ceb:	58                   	pop    %eax
     cec:	5a                   	pop    %edx
     ced:	57                   	push   %edi
     cee:	56                   	push   %esi
     cef:	e8 5c ff ff ff       	call   c50 <parseline>
  cmd = malloc(sizeof(*cmd));
     cf4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     cfb:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     cfd:	e8 ce 07 00 00       	call   14d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     d02:	83 c4 0c             	add    $0xc,%esp
     d05:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     d07:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     d09:	6a 00                	push   $0x0
     d0b:	50                   	push   %eax
     d0c:	e8 8f 02 00 00       	call   fa0 <memset>
  cmd->left = left;
     d11:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     d14:	83 c4 10             	add    $0x10,%esp
     d17:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     d19:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     d1f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     d21:	89 7e 08             	mov    %edi,0x8(%esi)
}
     d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d27:	5b                   	pop    %ebx
     d28:	5e                   	pop    %esi
     d29:	5f                   	pop    %edi
     d2a:	5d                   	pop    %ebp
     d2b:	c3                   	ret
     d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d30 <parseblock>:
{
     d30:	55                   	push   %ebp
     d31:	89 e5                	mov    %esp,%ebp
     d33:	57                   	push   %edi
     d34:	56                   	push   %esi
     d35:	53                   	push   %ebx
     d36:	83 ec 10             	sub    $0x10,%esp
     d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
     d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     d3f:	68 4b 16 00 00       	push   $0x164b
     d44:	56                   	push   %esi
     d45:	53                   	push   %ebx
     d46:	e8 95 fb ff ff       	call   8e0 <peek>
     d4b:	83 c4 10             	add    $0x10,%esp
     d4e:	85 c0                	test   %eax,%eax
     d50:	74 4a                	je     d9c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     d52:	6a 00                	push   $0x0
     d54:	6a 00                	push   $0x0
     d56:	56                   	push   %esi
     d57:	53                   	push   %ebx
     d58:	e8 23 fa ff ff       	call   780 <gettoken>
  cmd = parseline(ps, es);
     d5d:	58                   	pop    %eax
     d5e:	5a                   	pop    %edx
     d5f:	56                   	push   %esi
     d60:	53                   	push   %ebx
     d61:	e8 ea fe ff ff       	call   c50 <parseline>
  if(!peek(ps, es, ")"))
     d66:	83 c4 0c             	add    $0xc,%esp
     d69:	68 87 16 00 00       	push   $0x1687
  cmd = parseline(ps, es);
     d6e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     d70:	56                   	push   %esi
     d71:	53                   	push   %ebx
     d72:	e8 69 fb ff ff       	call   8e0 <peek>
     d77:	83 c4 10             	add    $0x10,%esp
     d7a:	85 c0                	test   %eax,%eax
     d7c:	74 2b                	je     da9 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     d7e:	6a 00                	push   $0x0
     d80:	6a 00                	push   $0x0
     d82:	56                   	push   %esi
     d83:	53                   	push   %ebx
     d84:	e8 f7 f9 ff ff       	call   780 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     d89:	83 c4 0c             	add    $0xc,%esp
     d8c:	56                   	push   %esi
     d8d:	53                   	push   %ebx
     d8e:	57                   	push   %edi
     d8f:	e8 cc fb ff ff       	call   960 <parseredirs>
}
     d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d97:	5b                   	pop    %ebx
     d98:	5e                   	pop    %esi
     d99:	5f                   	pop    %edi
     d9a:	5d                   	pop    %ebp
     d9b:	c3                   	ret
    panic("parseblock");
     d9c:	83 ec 0c             	sub    $0xc,%esp
     d9f:	68 6b 16 00 00       	push   $0x166b
     da4:	e8 c7 f6 ff ff       	call   470 <panic>
    panic("syntax - missing )");
     da9:	83 ec 0c             	sub    $0xc,%esp
     dac:	68 76 16 00 00       	push   $0x1676
     db1:	e8 ba f6 ff ff       	call   470 <panic>
     db6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     dbd:	00 
     dbe:	66 90                	xchg   %ax,%ax

00000dc0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     dc0:	55                   	push   %ebp
     dc1:	89 e5                	mov    %esp,%ebp
     dc3:	53                   	push   %ebx
     dc4:	83 ec 04             	sub    $0x4,%esp
     dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     dca:	85 db                	test   %ebx,%ebx
     dcc:	0f 84 8e 00 00 00    	je     e60 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
     dd2:	83 3b 05             	cmpl   $0x5,(%ebx)
     dd5:	77 61                	ja     e38 <nulterminate+0x78>
     dd7:	8b 03                	mov    (%ebx),%eax
     dd9:	ff 24 85 d0 16 00 00 	jmp    *0x16d0(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     de0:	83 ec 0c             	sub    $0xc,%esp
     de3:	ff 73 04             	push   0x4(%ebx)
     de6:	e8 d5 ff ff ff       	call   dc0 <nulterminate>
    nulterminate(lcmd->right);
     deb:	58                   	pop    %eax
     dec:	ff 73 08             	push   0x8(%ebx)
     def:	e8 cc ff ff ff       	call   dc0 <nulterminate>
    break;
     df4:	83 c4 10             	add    $0x10,%esp
     df7:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     dfc:	c9                   	leave
     dfd:	c3                   	ret
     dfe:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     e00:	83 ec 0c             	sub    $0xc,%esp
     e03:	ff 73 04             	push   0x4(%ebx)
     e06:	e8 b5 ff ff ff       	call   dc0 <nulterminate>
    break;
     e0b:	89 d8                	mov    %ebx,%eax
     e0d:	83 c4 10             	add    $0x10,%esp
}
     e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e13:	c9                   	leave
     e14:	c3                   	ret
     e15:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     e18:	8b 4b 04             	mov    0x4(%ebx),%ecx
     e1b:	8d 43 08             	lea    0x8(%ebx),%eax
     e1e:	85 c9                	test   %ecx,%ecx
     e20:	74 16                	je     e38 <nulterminate+0x78>
     e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     e28:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     e2b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     e2e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     e31:	8b 50 fc             	mov    -0x4(%eax),%edx
     e34:	85 d2                	test   %edx,%edx
     e36:	75 f0                	jne    e28 <nulterminate+0x68>
  switch(cmd->type){
     e38:	89 d8                	mov    %ebx,%eax
}
     e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e3d:	c9                   	leave
     e3e:	c3                   	ret
     e3f:	90                   	nop
    nulterminate(rcmd->cmd);
     e40:	83 ec 0c             	sub    $0xc,%esp
     e43:	ff 73 04             	push   0x4(%ebx)
     e46:	e8 75 ff ff ff       	call   dc0 <nulterminate>
    *rcmd->efile = 0;
     e4b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     e4e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     e51:	c6 00 00             	movb   $0x0,(%eax)
    break;
     e54:	89 d8                	mov    %ebx,%eax
}
     e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e59:	c9                   	leave
     e5a:	c3                   	ret
     e5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return 0;
     e60:	31 c0                	xor    %eax,%eax
     e62:	eb 95                	jmp    df9 <nulterminate+0x39>
     e64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     e6b:	00 
     e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e70 <parsecmd>:
{
     e70:	55                   	push   %ebp
     e71:	89 e5                	mov    %esp,%ebp
     e73:	57                   	push   %edi
     e74:	56                   	push   %esi
  cmd = parseline(&s, es);
     e75:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     e78:	53                   	push   %ebx
     e79:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     e7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
     e7f:	53                   	push   %ebx
     e80:	e8 eb 00 00 00       	call   f70 <strlen>
  cmd = parseline(&s, es);
     e85:	59                   	pop    %ecx
     e86:	5e                   	pop    %esi
  es = s + strlen(s);
     e87:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     e89:	53                   	push   %ebx
     e8a:	57                   	push   %edi
     e8b:	e8 c0 fd ff ff       	call   c50 <parseline>
  peek(&s, es, "");
     e90:	83 c4 0c             	add    $0xc,%esp
     e93:	68 d1 15 00 00       	push   $0x15d1
  cmd = parseline(&s, es);
     e98:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     e9a:	53                   	push   %ebx
     e9b:	57                   	push   %edi
     e9c:	e8 3f fa ff ff       	call   8e0 <peek>
  if(s != es){
     ea1:	8b 45 08             	mov    0x8(%ebp),%eax
     ea4:	83 c4 10             	add    $0x10,%esp
     ea7:	39 d8                	cmp    %ebx,%eax
     ea9:	75 13                	jne    ebe <parsecmd+0x4e>
  nulterminate(cmd);
     eab:	83 ec 0c             	sub    $0xc,%esp
     eae:	56                   	push   %esi
     eaf:	e8 0c ff ff ff       	call   dc0 <nulterminate>
}
     eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     eb7:	89 f0                	mov    %esi,%eax
     eb9:	5b                   	pop    %ebx
     eba:	5e                   	pop    %esi
     ebb:	5f                   	pop    %edi
     ebc:	5d                   	pop    %ebp
     ebd:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
     ebe:	52                   	push   %edx
     ebf:	50                   	push   %eax
     ec0:	68 89 16 00 00       	push   $0x1689
     ec5:	6a 02                	push   $0x2
     ec7:	e8 d4 03 00 00       	call   12a0 <printf>
    panic("syntax");
     ecc:	c7 04 24 4d 16 00 00 	movl   $0x164d,(%esp)
     ed3:	e8 98 f5 ff ff       	call   470 <panic>
     ed8:	66 90                	xchg   %ax,%ax
     eda:	66 90                	xchg   %ax,%ax
     edc:	66 90                	xchg   %ax,%ax
     ede:	66 90                	xchg   %ax,%ax

00000ee0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     ee0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ee1:	31 c0                	xor    %eax,%eax
{
     ee3:	89 e5                	mov    %esp,%ebp
     ee5:	53                   	push   %ebx
     ee6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ee9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     ef0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     ef4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     ef7:	83 c0 01             	add    $0x1,%eax
     efa:	84 d2                	test   %dl,%dl
     efc:	75 f2                	jne    ef0 <strcpy+0x10>
    ;
  return os;
}
     efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f01:	89 c8                	mov    %ecx,%eax
     f03:	c9                   	leave
     f04:	c3                   	ret
     f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f0c:	00 
     f0d:	8d 76 00             	lea    0x0(%esi),%esi

00000f10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f10:	55                   	push   %ebp
     f11:	89 e5                	mov    %esp,%ebp
     f13:	53                   	push   %ebx
     f14:	8b 55 08             	mov    0x8(%ebp),%edx
     f17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     f1a:	0f b6 02             	movzbl (%edx),%eax
     f1d:	84 c0                	test   %al,%al
     f1f:	75 17                	jne    f38 <strcmp+0x28>
     f21:	eb 3a                	jmp    f5d <strcmp+0x4d>
     f23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     f28:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     f2c:	83 c2 01             	add    $0x1,%edx
     f2f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     f32:	84 c0                	test   %al,%al
     f34:	74 1a                	je     f50 <strcmp+0x40>
    p++, q++;
     f36:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
     f38:	0f b6 19             	movzbl (%ecx),%ebx
     f3b:	38 c3                	cmp    %al,%bl
     f3d:	74 e9                	je     f28 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     f3f:	29 d8                	sub    %ebx,%eax
}
     f41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f44:	c9                   	leave
     f45:	c3                   	ret
     f46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f4d:	00 
     f4e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     f50:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     f54:	31 c0                	xor    %eax,%eax
     f56:	29 d8                	sub    %ebx,%eax
}
     f58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f5b:	c9                   	leave
     f5c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     f5d:	0f b6 19             	movzbl (%ecx),%ebx
     f60:	31 c0                	xor    %eax,%eax
     f62:	eb db                	jmp    f3f <strcmp+0x2f>
     f64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f6b:	00 
     f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f70 <strlen>:

uint
strlen(const char *s)
{
     f70:	55                   	push   %ebp
     f71:	89 e5                	mov    %esp,%ebp
     f73:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     f76:	80 3a 00             	cmpb   $0x0,(%edx)
     f79:	74 15                	je     f90 <strlen+0x20>
     f7b:	31 c0                	xor    %eax,%eax
     f7d:	8d 76 00             	lea    0x0(%esi),%esi
     f80:	83 c0 01             	add    $0x1,%eax
     f83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     f87:	89 c1                	mov    %eax,%ecx
     f89:	75 f5                	jne    f80 <strlen+0x10>
    ;
  return n;
}
     f8b:	89 c8                	mov    %ecx,%eax
     f8d:	5d                   	pop    %ebp
     f8e:	c3                   	ret
     f8f:	90                   	nop
  for(n = 0; s[n]; n++)
     f90:	31 c9                	xor    %ecx,%ecx
}
     f92:	5d                   	pop    %ebp
     f93:	89 c8                	mov    %ecx,%eax
     f95:	c3                   	ret
     f96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f9d:	00 
     f9e:	66 90                	xchg   %ax,%ax

00000fa0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     fa0:	55                   	push   %ebp
     fa1:	89 e5                	mov    %esp,%ebp
     fa3:	57                   	push   %edi
     fa4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     faa:	8b 45 0c             	mov    0xc(%ebp),%eax
     fad:	89 d7                	mov    %edx,%edi
     faf:	fc                   	cld
     fb0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     fb2:	8b 7d fc             	mov    -0x4(%ebp),%edi
     fb5:	89 d0                	mov    %edx,%eax
     fb7:	c9                   	leave
     fb8:	c3                   	ret
     fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000fc0 <strchr>:

char*
strchr(const char *s, char c)
{
     fc0:	55                   	push   %ebp
     fc1:	89 e5                	mov    %esp,%ebp
     fc3:	8b 45 08             	mov    0x8(%ebp),%eax
     fc6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     fca:	0f b6 10             	movzbl (%eax),%edx
     fcd:	84 d2                	test   %dl,%dl
     fcf:	75 12                	jne    fe3 <strchr+0x23>
     fd1:	eb 1d                	jmp    ff0 <strchr+0x30>
     fd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     fd8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     fdc:	83 c0 01             	add    $0x1,%eax
     fdf:	84 d2                	test   %dl,%dl
     fe1:	74 0d                	je     ff0 <strchr+0x30>
    if(*s == c)
     fe3:	38 d1                	cmp    %dl,%cl
     fe5:	75 f1                	jne    fd8 <strchr+0x18>
      return (char*)s;
  return 0;
}
     fe7:	5d                   	pop    %ebp
     fe8:	c3                   	ret
     fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     ff0:	31 c0                	xor    %eax,%eax
}
     ff2:	5d                   	pop    %ebp
     ff3:	c3                   	ret
     ff4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     ffb:	00 
     ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001000 <gets>:

char*
gets(char *buf, int max)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1005:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    1008:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    1009:	31 db                	xor    %ebx,%ebx
{
    100b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    100e:	eb 27                	jmp    1037 <gets+0x37>
    cc = read(0, &c, 1);
    1010:	83 ec 04             	sub    $0x4,%esp
    1013:	6a 01                	push   $0x1
    1015:	57                   	push   %edi
    1016:	6a 00                	push   $0x0
    1018:	e8 2e 01 00 00       	call   114b <read>
    if(cc < 1)
    101d:	83 c4 10             	add    $0x10,%esp
    1020:	85 c0                	test   %eax,%eax
    1022:	7e 1d                	jle    1041 <gets+0x41>
      break;
    buf[i++] = c;
    1024:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1028:	8b 55 08             	mov    0x8(%ebp),%edx
    102b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    102f:	3c 0a                	cmp    $0xa,%al
    1031:	74 1d                	je     1050 <gets+0x50>
    1033:	3c 0d                	cmp    $0xd,%al
    1035:	74 19                	je     1050 <gets+0x50>
  for(i=0; i+1 < max; ){
    1037:	89 de                	mov    %ebx,%esi
    1039:	83 c3 01             	add    $0x1,%ebx
    103c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    103f:	7c cf                	jl     1010 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    1041:	8b 45 08             	mov    0x8(%ebp),%eax
    1044:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1048:	8d 65 f4             	lea    -0xc(%ebp),%esp
    104b:	5b                   	pop    %ebx
    104c:	5e                   	pop    %esi
    104d:	5f                   	pop    %edi
    104e:	5d                   	pop    %ebp
    104f:	c3                   	ret
  buf[i] = '\0';
    1050:	8b 45 08             	mov    0x8(%ebp),%eax
    1053:	89 de                	mov    %ebx,%esi
    1055:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    1059:	8d 65 f4             	lea    -0xc(%ebp),%esp
    105c:	5b                   	pop    %ebx
    105d:	5e                   	pop    %esi
    105e:	5f                   	pop    %edi
    105f:	5d                   	pop    %ebp
    1060:	c3                   	ret
    1061:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    1068:	00 
    1069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001070 <stat>:

int
stat(const char *n, struct stat *st)
{
    1070:	55                   	push   %ebp
    1071:	89 e5                	mov    %esp,%ebp
    1073:	56                   	push   %esi
    1074:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1075:	83 ec 08             	sub    $0x8,%esp
    1078:	6a 00                	push   $0x0
    107a:	ff 75 08             	push   0x8(%ebp)
    107d:	e8 f1 00 00 00       	call   1173 <open>
  if(fd < 0)
    1082:	83 c4 10             	add    $0x10,%esp
    1085:	85 c0                	test   %eax,%eax
    1087:	78 27                	js     10b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    1089:	83 ec 08             	sub    $0x8,%esp
    108c:	ff 75 0c             	push   0xc(%ebp)
    108f:	89 c3                	mov    %eax,%ebx
    1091:	50                   	push   %eax
    1092:	e8 f4 00 00 00       	call   118b <fstat>
  close(fd);
    1097:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    109a:	89 c6                	mov    %eax,%esi
  close(fd);
    109c:	e8 ba 00 00 00       	call   115b <close>
  return r;
    10a1:	83 c4 10             	add    $0x10,%esp
}
    10a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    10a7:	89 f0                	mov    %esi,%eax
    10a9:	5b                   	pop    %ebx
    10aa:	5e                   	pop    %esi
    10ab:	5d                   	pop    %ebp
    10ac:	c3                   	ret
    10ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    10b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    10b5:	eb ed                	jmp    10a4 <stat+0x34>
    10b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10be:	00 
    10bf:	90                   	nop

000010c0 <atoi>:

int
atoi(const char *s)
{
    10c0:	55                   	push   %ebp
    10c1:	89 e5                	mov    %esp,%ebp
    10c3:	53                   	push   %ebx
    10c4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    10c7:	0f be 02             	movsbl (%edx),%eax
    10ca:	8d 48 d0             	lea    -0x30(%eax),%ecx
    10cd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    10d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    10d5:	77 1e                	ja     10f5 <atoi+0x35>
    10d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10de:	00 
    10df:	90                   	nop
    n = n*10 + *s++ - '0';
    10e0:	83 c2 01             	add    $0x1,%edx
    10e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    10e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    10ea:	0f be 02             	movsbl (%edx),%eax
    10ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
    10f0:	80 fb 09             	cmp    $0x9,%bl
    10f3:	76 eb                	jbe    10e0 <atoi+0x20>
  return n;
}
    10f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    10f8:	89 c8                	mov    %ecx,%eax
    10fa:	c9                   	leave
    10fb:	c3                   	ret
    10fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001100 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	57                   	push   %edi
    1104:	8b 45 10             	mov    0x10(%ebp),%eax
    1107:	8b 55 08             	mov    0x8(%ebp),%edx
    110a:	56                   	push   %esi
    110b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    110e:	85 c0                	test   %eax,%eax
    1110:	7e 13                	jle    1125 <memmove+0x25>
    1112:	01 d0                	add    %edx,%eax
  dst = vdst;
    1114:	89 d7                	mov    %edx,%edi
    1116:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    111d:	00 
    111e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
    1120:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1121:	39 f8                	cmp    %edi,%eax
    1123:	75 fb                	jne    1120 <memmove+0x20>
  return vdst;
}
    1125:	5e                   	pop    %esi
    1126:	89 d0                	mov    %edx,%eax
    1128:	5f                   	pop    %edi
    1129:	5d                   	pop    %ebp
    112a:	c3                   	ret

0000112b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    112b:	b8 01 00 00 00       	mov    $0x1,%eax
    1130:	cd 40                	int    $0x40
    1132:	c3                   	ret

00001133 <exit>:
SYSCALL(exit)
    1133:	b8 02 00 00 00       	mov    $0x2,%eax
    1138:	cd 40                	int    $0x40
    113a:	c3                   	ret

0000113b <wait>:
SYSCALL(wait)
    113b:	b8 03 00 00 00       	mov    $0x3,%eax
    1140:	cd 40                	int    $0x40
    1142:	c3                   	ret

00001143 <pipe>:
SYSCALL(pipe)
    1143:	b8 04 00 00 00       	mov    $0x4,%eax
    1148:	cd 40                	int    $0x40
    114a:	c3                   	ret

0000114b <read>:
SYSCALL(read)
    114b:	b8 05 00 00 00       	mov    $0x5,%eax
    1150:	cd 40                	int    $0x40
    1152:	c3                   	ret

00001153 <write>:
SYSCALL(write)
    1153:	b8 10 00 00 00       	mov    $0x10,%eax
    1158:	cd 40                	int    $0x40
    115a:	c3                   	ret

0000115b <close>:
SYSCALL(close)
    115b:	b8 15 00 00 00       	mov    $0x15,%eax
    1160:	cd 40                	int    $0x40
    1162:	c3                   	ret

00001163 <kill>:
SYSCALL(kill)
    1163:	b8 06 00 00 00       	mov    $0x6,%eax
    1168:	cd 40                	int    $0x40
    116a:	c3                   	ret

0000116b <exec>:
SYSCALL(exec)
    116b:	b8 07 00 00 00       	mov    $0x7,%eax
    1170:	cd 40                	int    $0x40
    1172:	c3                   	ret

00001173 <open>:
SYSCALL(open)
    1173:	b8 0f 00 00 00       	mov    $0xf,%eax
    1178:	cd 40                	int    $0x40
    117a:	c3                   	ret

0000117b <mknod>:
SYSCALL(mknod)
    117b:	b8 11 00 00 00       	mov    $0x11,%eax
    1180:	cd 40                	int    $0x40
    1182:	c3                   	ret

00001183 <unlink>:
SYSCALL(unlink)
    1183:	b8 12 00 00 00       	mov    $0x12,%eax
    1188:	cd 40                	int    $0x40
    118a:	c3                   	ret

0000118b <fstat>:
SYSCALL(fstat)
    118b:	b8 08 00 00 00       	mov    $0x8,%eax
    1190:	cd 40                	int    $0x40
    1192:	c3                   	ret

00001193 <link>:
SYSCALL(link)
    1193:	b8 13 00 00 00       	mov    $0x13,%eax
    1198:	cd 40                	int    $0x40
    119a:	c3                   	ret

0000119b <mkdir>:
SYSCALL(mkdir)
    119b:	b8 14 00 00 00       	mov    $0x14,%eax
    11a0:	cd 40                	int    $0x40
    11a2:	c3                   	ret

000011a3 <chdir>:
SYSCALL(chdir)
    11a3:	b8 09 00 00 00       	mov    $0x9,%eax
    11a8:	cd 40                	int    $0x40
    11aa:	c3                   	ret

000011ab <dup>:
SYSCALL(dup)
    11ab:	b8 0a 00 00 00       	mov    $0xa,%eax
    11b0:	cd 40                	int    $0x40
    11b2:	c3                   	ret

000011b3 <getpid>:
SYSCALL(getpid)
    11b3:	b8 0b 00 00 00       	mov    $0xb,%eax
    11b8:	cd 40                	int    $0x40
    11ba:	c3                   	ret

000011bb <sbrk>:
SYSCALL(sbrk)
    11bb:	b8 0c 00 00 00       	mov    $0xc,%eax
    11c0:	cd 40                	int    $0x40
    11c2:	c3                   	ret

000011c3 <sleep>:
SYSCALL(sleep)
    11c3:	b8 0d 00 00 00       	mov    $0xd,%eax
    11c8:	cd 40                	int    $0x40
    11ca:	c3                   	ret

000011cb <uptime>:
SYSCALL(uptime)
    11cb:	b8 0e 00 00 00       	mov    $0xe,%eax
    11d0:	cd 40                	int    $0x40
    11d2:	c3                   	ret

000011d3 <gethistory>:
SYSCALL(gethistory)
    11d3:	b8 16 00 00 00       	mov    $0x16,%eax
    11d8:	cd 40                	int    $0x40
    11da:	c3                   	ret

000011db <block>:
SYSCALL(block)
    11db:	b8 17 00 00 00       	mov    $0x17,%eax
    11e0:	cd 40                	int    $0x40
    11e2:	c3                   	ret

000011e3 <unblock>:
SYSCALL(unblock)
    11e3:	b8 18 00 00 00       	mov    $0x18,%eax
    11e8:	cd 40                	int    $0x40
    11ea:	c3                   	ret
    11eb:	66 90                	xchg   %ax,%ax
    11ed:	66 90                	xchg   %ax,%ax
    11ef:	90                   	nop

000011f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    11f0:	55                   	push   %ebp
    11f1:	89 e5                	mov    %esp,%ebp
    11f3:	57                   	push   %edi
    11f4:	56                   	push   %esi
    11f5:	53                   	push   %ebx
    11f6:	83 ec 3c             	sub    $0x3c,%esp
    11f9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    11fc:	89 d1                	mov    %edx,%ecx
{
    11fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1201:	85 d2                	test   %edx,%edx
    1203:	0f 89 7f 00 00 00    	jns    1288 <printint+0x98>
    1209:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    120d:	74 79                	je     1288 <printint+0x98>
    neg = 1;
    120f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1216:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1218:	31 db                	xor    %ebx,%ebx
    121a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    121d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1220:	89 c8                	mov    %ecx,%eax
    1222:	31 d2                	xor    %edx,%edx
    1224:	89 cf                	mov    %ecx,%edi
    1226:	f7 75 c4             	divl   -0x3c(%ebp)
    1229:	0f b6 92 40 17 00 00 	movzbl 0x1740(%edx),%edx
    1230:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1233:	89 d8                	mov    %ebx,%eax
    1235:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1238:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    123b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    123e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1241:	76 dd                	jbe    1220 <printint+0x30>
  if(neg)
    1243:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1246:	85 c9                	test   %ecx,%ecx
    1248:	74 0c                	je     1256 <printint+0x66>
    buf[i++] = '-';
    124a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    124f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1251:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1256:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1259:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    125d:	eb 07                	jmp    1266 <printint+0x76>
    125f:	90                   	nop
    putc(fd, buf[i]);
    1260:	0f b6 13             	movzbl (%ebx),%edx
    1263:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1266:	83 ec 04             	sub    $0x4,%esp
    1269:	88 55 d7             	mov    %dl,-0x29(%ebp)
    126c:	6a 01                	push   $0x1
    126e:	56                   	push   %esi
    126f:	57                   	push   %edi
    1270:	e8 de fe ff ff       	call   1153 <write>
  while(--i >= 0)
    1275:	83 c4 10             	add    $0x10,%esp
    1278:	39 de                	cmp    %ebx,%esi
    127a:	75 e4                	jne    1260 <printint+0x70>
}
    127c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    127f:	5b                   	pop    %ebx
    1280:	5e                   	pop    %esi
    1281:	5f                   	pop    %edi
    1282:	5d                   	pop    %ebp
    1283:	c3                   	ret
    1284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1288:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    128f:	eb 87                	jmp    1218 <printint+0x28>
    1291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    1298:	00 
    1299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000012a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    12a0:	55                   	push   %ebp
    12a1:	89 e5                	mov    %esp,%ebp
    12a3:	57                   	push   %edi
    12a4:	56                   	push   %esi
    12a5:	53                   	push   %ebx
    12a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    12a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    12ac:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    12af:	0f b6 13             	movzbl (%ebx),%edx
    12b2:	84 d2                	test   %dl,%dl
    12b4:	74 6a                	je     1320 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    12b6:	8d 45 10             	lea    0x10(%ebp),%eax
    12b9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    12bc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    12bf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    12c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    12c4:	eb 36                	jmp    12fc <printf+0x5c>
    12c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    12cd:	00 
    12ce:	66 90                	xchg   %ax,%ax
    12d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    12d3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    12d8:	83 f8 25             	cmp    $0x25,%eax
    12db:	74 15                	je     12f2 <printf+0x52>
  write(fd, &c, 1);
    12dd:	83 ec 04             	sub    $0x4,%esp
    12e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
    12e3:	6a 01                	push   $0x1
    12e5:	57                   	push   %edi
    12e6:	56                   	push   %esi
    12e7:	e8 67 fe ff ff       	call   1153 <write>
    12ec:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    12ef:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    12f2:	0f b6 13             	movzbl (%ebx),%edx
    12f5:	83 c3 01             	add    $0x1,%ebx
    12f8:	84 d2                	test   %dl,%dl
    12fa:	74 24                	je     1320 <printf+0x80>
    c = fmt[i] & 0xff;
    12fc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    12ff:	85 c9                	test   %ecx,%ecx
    1301:	74 cd                	je     12d0 <printf+0x30>
      }
    } else if(state == '%'){
    1303:	83 f9 25             	cmp    $0x25,%ecx
    1306:	75 ea                	jne    12f2 <printf+0x52>
      if(c == 'd'){
    1308:	83 f8 25             	cmp    $0x25,%eax
    130b:	0f 84 07 01 00 00    	je     1418 <printf+0x178>
    1311:	83 e8 63             	sub    $0x63,%eax
    1314:	83 f8 15             	cmp    $0x15,%eax
    1317:	77 17                	ja     1330 <printf+0x90>
    1319:	ff 24 85 e8 16 00 00 	jmp    *0x16e8(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1320:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1323:	5b                   	pop    %ebx
    1324:	5e                   	pop    %esi
    1325:	5f                   	pop    %edi
    1326:	5d                   	pop    %ebp
    1327:	c3                   	ret
    1328:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    132f:	00 
  write(fd, &c, 1);
    1330:	83 ec 04             	sub    $0x4,%esp
    1333:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1336:	6a 01                	push   $0x1
    1338:	57                   	push   %edi
    1339:	56                   	push   %esi
    133a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    133e:	e8 10 fe ff ff       	call   1153 <write>
        putc(fd, c);
    1343:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1347:	83 c4 0c             	add    $0xc,%esp
    134a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    134d:	6a 01                	push   $0x1
    134f:	57                   	push   %edi
    1350:	56                   	push   %esi
    1351:	e8 fd fd ff ff       	call   1153 <write>
        putc(fd, c);
    1356:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1359:	31 c9                	xor    %ecx,%ecx
    135b:	eb 95                	jmp    12f2 <printf+0x52>
    135d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1360:	83 ec 0c             	sub    $0xc,%esp
    1363:	b9 10 00 00 00       	mov    $0x10,%ecx
    1368:	6a 00                	push   $0x0
    136a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    136d:	8b 10                	mov    (%eax),%edx
    136f:	89 f0                	mov    %esi,%eax
    1371:	e8 7a fe ff ff       	call   11f0 <printint>
        ap++;
    1376:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    137a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    137d:	31 c9                	xor    %ecx,%ecx
    137f:	e9 6e ff ff ff       	jmp    12f2 <printf+0x52>
    1384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1388:	8b 45 d0             	mov    -0x30(%ebp),%eax
    138b:	8b 10                	mov    (%eax),%edx
        ap++;
    138d:	83 c0 04             	add    $0x4,%eax
    1390:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1393:	85 d2                	test   %edx,%edx
    1395:	0f 84 8d 00 00 00    	je     1428 <printf+0x188>
        while(*s != 0){
    139b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    139e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    13a0:	84 c0                	test   %al,%al
    13a2:	0f 84 4a ff ff ff    	je     12f2 <printf+0x52>
    13a8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    13ab:	89 d3                	mov    %edx,%ebx
    13ad:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    13b0:	83 ec 04             	sub    $0x4,%esp
          s++;
    13b3:	83 c3 01             	add    $0x1,%ebx
    13b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    13b9:	6a 01                	push   $0x1
    13bb:	57                   	push   %edi
    13bc:	56                   	push   %esi
    13bd:	e8 91 fd ff ff       	call   1153 <write>
        while(*s != 0){
    13c2:	0f b6 03             	movzbl (%ebx),%eax
    13c5:	83 c4 10             	add    $0x10,%esp
    13c8:	84 c0                	test   %al,%al
    13ca:	75 e4                	jne    13b0 <printf+0x110>
      state = 0;
    13cc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    13cf:	31 c9                	xor    %ecx,%ecx
    13d1:	e9 1c ff ff ff       	jmp    12f2 <printf+0x52>
    13d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    13dd:	00 
    13de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    13e0:	83 ec 0c             	sub    $0xc,%esp
    13e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    13e8:	6a 01                	push   $0x1
    13ea:	e9 7b ff ff ff       	jmp    136a <printf+0xca>
    13ef:	90                   	nop
        putc(fd, *ap);
    13f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    13f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    13f6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    13f8:	6a 01                	push   $0x1
    13fa:	57                   	push   %edi
    13fb:	56                   	push   %esi
        putc(fd, *ap);
    13fc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    13ff:	e8 4f fd ff ff       	call   1153 <write>
        ap++;
    1404:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1408:	83 c4 10             	add    $0x10,%esp
      state = 0;
    140b:	31 c9                	xor    %ecx,%ecx
    140d:	e9 e0 fe ff ff       	jmp    12f2 <printf+0x52>
    1412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1418:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    141b:	83 ec 04             	sub    $0x4,%esp
    141e:	e9 2a ff ff ff       	jmp    134d <printf+0xad>
    1423:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          s = "(null)";
    1428:	ba b1 16 00 00       	mov    $0x16b1,%edx
        while(*s != 0){
    142d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1430:	b8 28 00 00 00       	mov    $0x28,%eax
    1435:	89 d3                	mov    %edx,%ebx
    1437:	e9 74 ff ff ff       	jmp    13b0 <printf+0x110>
    143c:	66 90                	xchg   %ax,%ax
    143e:	66 90                	xchg   %ax,%ax

00001440 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1440:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1441:	a1 24 1e 00 00       	mov    0x1e24,%eax
{
    1446:	89 e5                	mov    %esp,%ebp
    1448:	57                   	push   %edi
    1449:	56                   	push   %esi
    144a:	53                   	push   %ebx
    144b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    144e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1458:	89 c2                	mov    %eax,%edx
    145a:	8b 00                	mov    (%eax),%eax
    145c:	39 ca                	cmp    %ecx,%edx
    145e:	73 30                	jae    1490 <free+0x50>
    1460:	39 c1                	cmp    %eax,%ecx
    1462:	72 04                	jb     1468 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1464:	39 c2                	cmp    %eax,%edx
    1466:	72 f0                	jb     1458 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1468:	8b 73 fc             	mov    -0x4(%ebx),%esi
    146b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    146e:	39 f8                	cmp    %edi,%eax
    1470:	74 30                	je     14a2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1472:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1475:	8b 42 04             	mov    0x4(%edx),%eax
    1478:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    147b:	39 f1                	cmp    %esi,%ecx
    147d:	74 3a                	je     14b9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    147f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1481:	5b                   	pop    %ebx
  freep = p;
    1482:	89 15 24 1e 00 00    	mov    %edx,0x1e24
}
    1488:	5e                   	pop    %esi
    1489:	5f                   	pop    %edi
    148a:	5d                   	pop    %ebp
    148b:	c3                   	ret
    148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1490:	39 c2                	cmp    %eax,%edx
    1492:	72 c4                	jb     1458 <free+0x18>
    1494:	39 c1                	cmp    %eax,%ecx
    1496:	73 c0                	jae    1458 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    1498:	8b 73 fc             	mov    -0x4(%ebx),%esi
    149b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    149e:	39 f8                	cmp    %edi,%eax
    14a0:	75 d0                	jne    1472 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    14a2:	03 70 04             	add    0x4(%eax),%esi
    14a5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    14a8:	8b 02                	mov    (%edx),%eax
    14aa:	8b 00                	mov    (%eax),%eax
    14ac:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    14af:	8b 42 04             	mov    0x4(%edx),%eax
    14b2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    14b5:	39 f1                	cmp    %esi,%ecx
    14b7:	75 c6                	jne    147f <free+0x3f>
    p->s.size += bp->s.size;
    14b9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    14bc:	89 15 24 1e 00 00    	mov    %edx,0x1e24
    p->s.size += bp->s.size;
    14c2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    14c5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    14c8:	89 0a                	mov    %ecx,(%edx)
}
    14ca:	5b                   	pop    %ebx
    14cb:	5e                   	pop    %esi
    14cc:	5f                   	pop    %edi
    14cd:	5d                   	pop    %ebp
    14ce:	c3                   	ret
    14cf:	90                   	nop

000014d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    14d0:	55                   	push   %ebp
    14d1:	89 e5                	mov    %esp,%ebp
    14d3:	57                   	push   %edi
    14d4:	56                   	push   %esi
    14d5:	53                   	push   %ebx
    14d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    14d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    14dc:	8b 3d 24 1e 00 00    	mov    0x1e24,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    14e2:	8d 70 07             	lea    0x7(%eax),%esi
    14e5:	c1 ee 03             	shr    $0x3,%esi
    14e8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    14eb:	85 ff                	test   %edi,%edi
    14ed:	0f 84 9d 00 00 00    	je     1590 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14f3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    14f5:	8b 4a 04             	mov    0x4(%edx),%ecx
    14f8:	39 f1                	cmp    %esi,%ecx
    14fa:	73 6a                	jae    1566 <malloc+0x96>
    14fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1501:	39 de                	cmp    %ebx,%esi
    1503:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1506:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    150d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1510:	eb 17                	jmp    1529 <malloc+0x59>
    1512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1518:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    151a:	8b 48 04             	mov    0x4(%eax),%ecx
    151d:	39 f1                	cmp    %esi,%ecx
    151f:	73 4f                	jae    1570 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1521:	8b 3d 24 1e 00 00    	mov    0x1e24,%edi
    1527:	89 c2                	mov    %eax,%edx
    1529:	39 d7                	cmp    %edx,%edi
    152b:	75 eb                	jne    1518 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    152d:	83 ec 0c             	sub    $0xc,%esp
    1530:	ff 75 e4             	push   -0x1c(%ebp)
    1533:	e8 83 fc ff ff       	call   11bb <sbrk>
  if(p == (char*)-1)
    1538:	83 c4 10             	add    $0x10,%esp
    153b:	83 f8 ff             	cmp    $0xffffffff,%eax
    153e:	74 1c                	je     155c <malloc+0x8c>
  hp->s.size = nu;
    1540:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1543:	83 ec 0c             	sub    $0xc,%esp
    1546:	83 c0 08             	add    $0x8,%eax
    1549:	50                   	push   %eax
    154a:	e8 f1 fe ff ff       	call   1440 <free>
  return freep;
    154f:	8b 15 24 1e 00 00    	mov    0x1e24,%edx
      if((p = morecore(nunits)) == 0)
    1555:	83 c4 10             	add    $0x10,%esp
    1558:	85 d2                	test   %edx,%edx
    155a:	75 bc                	jne    1518 <malloc+0x48>
        return 0;
  }
}
    155c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    155f:	31 c0                	xor    %eax,%eax
}
    1561:	5b                   	pop    %ebx
    1562:	5e                   	pop    %esi
    1563:	5f                   	pop    %edi
    1564:	5d                   	pop    %ebp
    1565:	c3                   	ret
    if(p->s.size >= nunits){
    1566:	89 d0                	mov    %edx,%eax
    1568:	89 fa                	mov    %edi,%edx
    156a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1570:	39 ce                	cmp    %ecx,%esi
    1572:	74 4c                	je     15c0 <malloc+0xf0>
        p->s.size -= nunits;
    1574:	29 f1                	sub    %esi,%ecx
    1576:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1579:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    157c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    157f:	89 15 24 1e 00 00    	mov    %edx,0x1e24
}
    1585:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1588:	83 c0 08             	add    $0x8,%eax
}
    158b:	5b                   	pop    %ebx
    158c:	5e                   	pop    %esi
    158d:	5f                   	pop    %edi
    158e:	5d                   	pop    %ebp
    158f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
    1590:	c7 05 24 1e 00 00 28 	movl   $0x1e28,0x1e24
    1597:	1e 00 00 
    base.s.size = 0;
    159a:	bf 28 1e 00 00       	mov    $0x1e28,%edi
    base.s.ptr = freep = prevp = &base;
    159f:	c7 05 28 1e 00 00 28 	movl   $0x1e28,0x1e28
    15a6:	1e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15a9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    15ab:	c7 05 2c 1e 00 00 00 	movl   $0x0,0x1e2c
    15b2:	00 00 00 
    if(p->s.size >= nunits){
    15b5:	e9 42 ff ff ff       	jmp    14fc <malloc+0x2c>
    15ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    15c0:	8b 08                	mov    (%eax),%ecx
    15c2:	89 0a                	mov    %ecx,(%edx)
    15c4:	eb b9                	jmp    157f <malloc+0xaf>
