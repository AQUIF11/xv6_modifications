
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
       d:	51                   	push   %ecx
       e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;
  // 1. printf(1, "SHELL: Starting shell process\n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      11:	eb 0e                	jmp    21 <main+0x21>
      13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f 51 02 00 00    	jg     272 <main+0x272>
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 d3 16 00 00       	push   $0x16d3
      2b:	e8 83 11 00 00       	call   11b3 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	eb 68                	jmp    a1 <main+0xa1>
      39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while (getcmd(buf, sizeof(buf)) >= 0) {
    if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y') {
        history_command();
        continue;
    }
    if (buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k' && buf[5] == ' ') {
      40:	3c 62                	cmp    $0x62,%al
      42:	0f 84 00 01 00 00    	je     148 <main+0x148>
        block_command(buf + 6);
        continue;
    }
    if (buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k' && buf[7] == ' ') {
      48:	3c 75                	cmp    $0x75,%al
      4a:	75 0d                	jne    59 <main+0x59>
      4c:	80 3d a1 1e 00 00 6e 	cmpb   $0x6e,0x1ea1
      53:	0f 84 47 01 00 00    	je     1a0 <main+0x1a0>
        unblock_command(buf + 8);
        continue;
    }
    buf[strlen(buf) - 1] = 0;  // Remove newline character
      59:	83 ec 0c             	sub    $0xc,%esp
      5c:	68 a0 1e 00 00       	push   $0x1ea0
      61:	e8 4a 0f 00 00       	call   fb0 <strlen>
    // if (strcmp(buf, "unblock ") == 0) {
    //     unblock_command(buf + 8);
    //     continue;
    // }

    if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd' && buf[5] == ' ') {
      66:	83 c4 10             	add    $0x10,%esp
    buf[strlen(buf) - 1] = 0;  // Remove newline character
      69:	c6 80 9f 1e 00 00 00 	movb   $0x0,0x1e9f(%eax)
    if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd' && buf[5] == ' ') {
      70:	80 3d a0 1e 00 00 63 	cmpb   $0x63,0x1ea0
      77:	75 0d                	jne    86 <main+0x86>
      79:	80 3d a1 1e 00 00 68 	cmpb   $0x68,0x1ea1
      80:	0f 84 82 01 00 00    	je     208 <main+0x208>
int
fork1(void)
{
  int pid;

  pid = fork();
      86:	e8 e0 10 00 00       	call   116b <fork>
  if(pid == -1)
      8b:	83 f8 ff             	cmp    $0xffffffff,%eax
      8e:	0f 84 51 02 00 00    	je     2e5 <main+0x2e5>
    if (fork1() == 0)
      94:	85 c0                	test   %eax,%eax
      96:	0f 84 e7 01 00 00    	je     283 <main+0x283>
    wait();
      9c:	e8 da 10 00 00       	call   117b <wait>
  printf(2, "$ ");
      a1:	83 ec 08             	sub    $0x8,%esp
      a4:	68 3a 16 00 00       	push   $0x163a
      a9:	6a 02                	push   $0x2
      ab:	e8 40 12 00 00       	call   12f0 <printf>
  memset(buf, 0, nbuf);
      b0:	83 c4 0c             	add    $0xc,%esp
      b3:	6a 64                	push   $0x64
      b5:	6a 00                	push   $0x0
      b7:	68 a0 1e 00 00       	push   $0x1ea0
      bc:	e8 1f 0f 00 00       	call   fe0 <memset>
  gets(buf, nbuf);
      c1:	58                   	pop    %eax
      c2:	5a                   	pop    %edx
      c3:	6a 64                	push   $0x64
      c5:	68 a0 1e 00 00       	push   $0x1ea0
      ca:	e8 71 0f 00 00       	call   1040 <gets>
  if(buf[0] == 0) // EOF
      cf:	0f b6 05 a0 1e 00 00 	movzbl 0x1ea0,%eax
      d6:	83 c4 10             	add    $0x10,%esp
      d9:	84 c0                	test   %al,%al
      db:	0f 84 b7 01 00 00    	je     298 <main+0x298>
    if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y') {
      e1:	3c 68                	cmp    $0x68,%al
      e3:	0f 85 57 ff ff ff    	jne    40 <main+0x40>
      e9:	80 3d a1 1e 00 00 69 	cmpb   $0x69,0x1ea1
      f0:	0f 85 63 ff ff ff    	jne    59 <main+0x59>
      f6:	80 3d a2 1e 00 00 73 	cmpb   $0x73,0x1ea2
      fd:	0f 85 56 ff ff ff    	jne    59 <main+0x59>
     103:	80 3d a3 1e 00 00 74 	cmpb   $0x74,0x1ea3
     10a:	0f 85 49 ff ff ff    	jne    59 <main+0x59>
     110:	80 3d a4 1e 00 00 6f 	cmpb   $0x6f,0x1ea4
     117:	0f 85 3c ff ff ff    	jne    59 <main+0x59>
     11d:	80 3d a5 1e 00 00 72 	cmpb   $0x72,0x1ea5
     124:	0f 85 2f ff ff ff    	jne    59 <main+0x59>
     12a:	80 3d a6 1e 00 00 79 	cmpb   $0x79,0x1ea6
     131:	0f 85 22 ff ff ff    	jne    59 <main+0x59>
        history_command();
     137:	e8 c4 01 00 00       	call   300 <history_command>
        continue;
     13c:	e9 60 ff ff ff       	jmp    a1 <main+0xa1>
     141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k' && buf[5] == ' ') {
     148:	80 3d a1 1e 00 00 6c 	cmpb   $0x6c,0x1ea1
     14f:	0f 85 04 ff ff ff    	jne    59 <main+0x59>
     155:	80 3d a2 1e 00 00 6f 	cmpb   $0x6f,0x1ea2
     15c:	0f 85 f7 fe ff ff    	jne    59 <main+0x59>
     162:	80 3d a3 1e 00 00 63 	cmpb   $0x63,0x1ea3
     169:	0f 85 ea fe ff ff    	jne    59 <main+0x59>
     16f:	80 3d a4 1e 00 00 6b 	cmpb   $0x6b,0x1ea4
     176:	0f 85 dd fe ff ff    	jne    59 <main+0x59>
     17c:	80 3d a5 1e 00 00 20 	cmpb   $0x20,0x1ea5
     183:	0f 85 d0 fe ff ff    	jne    59 <main+0x59>
        block_command(buf + 6);
     189:	83 ec 0c             	sub    $0xc,%esp
     18c:	68 a6 1e 00 00       	push   $0x1ea6
     191:	e8 ca 01 00 00       	call   360 <block_command>
        continue;
     196:	83 c4 10             	add    $0x10,%esp
     199:	e9 03 ff ff ff       	jmp    a1 <main+0xa1>
     19e:	66 90                	xchg   %ax,%ax
    if (buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k' && buf[7] == ' ') {
     1a0:	80 3d a2 1e 00 00 62 	cmpb   $0x62,0x1ea2
     1a7:	0f 85 ac fe ff ff    	jne    59 <main+0x59>
     1ad:	80 3d a3 1e 00 00 6c 	cmpb   $0x6c,0x1ea3
     1b4:	0f 85 9f fe ff ff    	jne    59 <main+0x59>
     1ba:	80 3d a4 1e 00 00 6f 	cmpb   $0x6f,0x1ea4
     1c1:	0f 85 92 fe ff ff    	jne    59 <main+0x59>
     1c7:	80 3d a5 1e 00 00 63 	cmpb   $0x63,0x1ea5
     1ce:	0f 85 85 fe ff ff    	jne    59 <main+0x59>
     1d4:	80 3d a6 1e 00 00 6b 	cmpb   $0x6b,0x1ea6
     1db:	0f 85 78 fe ff ff    	jne    59 <main+0x59>
     1e1:	80 3d a7 1e 00 00 20 	cmpb   $0x20,0x1ea7
     1e8:	0f 85 6b fe ff ff    	jne    59 <main+0x59>
        unblock_command(buf + 8);
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	68 a8 1e 00 00       	push   $0x1ea8
     1f6:	e8 b5 01 00 00       	call   3b0 <unblock_command>
        continue;
     1fb:	83 c4 10             	add    $0x10,%esp
     1fe:	e9 9e fe ff ff       	jmp    a1 <main+0xa1>
     203:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd' && buf[5] == ' ') {
     208:	80 3d a2 1e 00 00 6d 	cmpb   $0x6d,0x1ea2
     20f:	0f 85 71 fe ff ff    	jne    86 <main+0x86>
     215:	80 3d a3 1e 00 00 6f 	cmpb   $0x6f,0x1ea3
     21c:	0f 85 64 fe ff ff    	jne    86 <main+0x86>
     222:	80 3d a4 1e 00 00 64 	cmpb   $0x64,0x1ea4
     229:	0f 85 57 fe ff ff    	jne    86 <main+0x86>
     22f:	80 3d a5 1e 00 00 20 	cmpb   $0x20,0x1ea5
     236:	0f 85 4a fe ff ff    	jne    86 <main+0x86>
        int i = 6; // Start after "chmod "
     23c:	b8 06 00 00 00       	mov    $0x6,%eax
     241:	eb 03                	jmp    246 <main+0x246>
        while (buf[i] == ' ') i++;
     243:	83 c0 01             	add    $0x1,%eax
     246:	0f b6 90 a0 1e 00 00 	movzbl 0x1ea0(%eax),%edx
     24d:	80 fa 20             	cmp    $0x20,%dl
     250:	74 f1                	je     243 <main+0x243>
        if (buf[i] != 0) file = &buf[i]; // File name starts here
     252:	8d 88 a0 1e 00 00    	lea    0x1ea0(%eax),%ecx
     258:	84 d2                	test   %dl,%dl
     25a:	75 44                	jne    2a0 <main+0x2a0>
            printf(2, "Usage: chmod <file> <mode>\n");
     25c:	51                   	push   %ecx
     25d:	51                   	push   %ecx
     25e:	68 db 16 00 00       	push   $0x16db
     263:	6a 02                	push   $0x2
     265:	e8 86 10 00 00       	call   12f0 <printf>
     26a:	83 c4 10             	add    $0x10,%esp
     26d:	e9 2f fe ff ff       	jmp    a1 <main+0xa1>
      close(fd);
     272:	83 ec 0c             	sub    $0xc,%esp
     275:	50                   	push   %eax
     276:	e8 20 0f 00 00       	call   119b <close>
      break;
     27b:	83 c4 10             	add    $0x10,%esp
     27e:	e9 1e fe ff ff       	jmp    a1 <main+0xa1>
        runcmd(parsecmd(buf));
     283:	83 ec 0c             	sub    $0xc,%esp
     286:	68 a0 1e 00 00       	push   $0x1ea0
     28b:	e8 20 0c 00 00       	call   eb0 <parsecmd>
     290:	89 04 24             	mov    %eax,(%esp)
     293:	e8 58 02 00 00       	call   4f0 <runcmd>
  exit();
     298:	e8 d6 0e 00 00       	call   1173 <exit>
        while (buf[i] != 0 && buf[i] != ' ') i++;
     29d:	83 c0 01             	add    $0x1,%eax
     2a0:	0f b6 90 a0 1e 00 00 	movzbl 0x1ea0(%eax),%edx
     2a7:	f6 c2 df             	test   $0xdf,%dl
     2aa:	75 f1                	jne    29d <main+0x29d>
        if (buf[i] != 0) {
     2ac:	84 d2                	test   %dl,%dl
     2ae:	74 ac                	je     25c <main+0x25c>
            buf[i] = 0; // Null-terminate file name
     2b0:	c6 80 a0 1e 00 00 00 	movb   $0x0,0x1ea0(%eax)
            i++;
     2b7:	83 c0 01             	add    $0x1,%eax
     2ba:	eb 03                	jmp    2bf <main+0x2bf>
        while (buf[i] == ' ') i++;
     2bc:	83 c0 01             	add    $0x1,%eax
     2bf:	0f b6 90 a0 1e 00 00 	movzbl 0x1ea0(%eax),%edx
     2c6:	80 fa 20             	cmp    $0x20,%dl
     2c9:	74 f1                	je     2bc <main+0x2bc>
        if (buf[i] != 0) mode = &buf[i]; // Mode starts here
     2cb:	84 d2                	test   %dl,%dl
     2cd:	74 8d                	je     25c <main+0x25c>
     2cf:	05 a0 1e 00 00       	add    $0x1ea0,%eax
            chmod_command(file, mode);
     2d4:	52                   	push   %edx
     2d5:	52                   	push   %edx
     2d6:	50                   	push   %eax
     2d7:	51                   	push   %ecx
     2d8:	e8 23 01 00 00       	call   400 <chmod_command>
     2dd:	83 c4 10             	add    $0x10,%esp
     2e0:	e9 bc fd ff ff       	jmp    a1 <main+0xa1>
    panic("fork");
     2e5:	83 ec 0c             	sub    $0xc,%esp
     2e8:	68 3d 16 00 00       	push   $0x163d
     2ed:	e8 be 01 00 00       	call   4b0 <panic>
     2f2:	66 90                	xchg   %ax,%ax
     2f4:	66 90                	xchg   %ax,%ax
     2f6:	66 90                	xchg   %ax,%ax
     2f8:	66 90                	xchg   %ax,%ax
     2fa:	66 90                	xchg   %ax,%ax
     2fc:	66 90                	xchg   %ax,%ax
     2fe:	66 90                	xchg   %ax,%ax

00000300 <history_command>:
void history_command() {
     300:	55                   	push   %ebp
     301:	89 e5                	mov    %esp,%ebp
     303:	57                   	push   %edi
     304:	56                   	push   %esi
  int count = gethistory(hist, MAX_HISTORY);
     305:	8d 85 88 f6 ff ff    	lea    -0x978(%ebp),%eax
void history_command() {
     30b:	53                   	push   %ebx
     30c:	81 ec 74 09 00 00    	sub    $0x974,%esp
  int count = gethistory(hist, MAX_HISTORY);
     312:	6a 64                	push   $0x64
     314:	50                   	push   %eax
     315:	e8 f9 0e 00 00       	call   1213 <gethistory>
  if (count < 0) {
     31a:	83 c4 10             	add    $0x10,%esp
     31d:	85 c0                	test   %eax,%eax
     31f:	78 32                	js     353 <history_command+0x53>
     321:	89 c7                	mov    %eax,%edi
  for (int i = 0; i < count; i++) {
     323:	8d 9d 8c f6 ff ff    	lea    -0x974(%ebp),%ebx
     329:	be 00 00 00 00       	mov    $0x0,%esi
     32e:	74 23                	je     353 <history_command+0x53>
    printf(1, "%d %s %d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     330:	83 ec 0c             	sub    $0xc,%esp
     333:	ff 73 10             	push   0x10(%ebx)
  for (int i = 0; i < count; i++) {
     336:	83 c6 01             	add    $0x1,%esi
    printf(1, "%d %s %d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     339:	53                   	push   %ebx
  for (int i = 0; i < count; i++) {
     33a:	83 c3 18             	add    $0x18,%ebx
    printf(1, "%d %s %d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     33d:	ff 73 e4             	push   -0x1c(%ebx)
     340:	68 18 16 00 00       	push   $0x1618
     345:	6a 01                	push   $0x1
     347:	e8 a4 0f 00 00       	call   12f0 <printf>
  for (int i = 0; i < count; i++) {
     34c:	83 c4 20             	add    $0x20,%esp
     34f:	39 f7                	cmp    %esi,%edi
     351:	75 dd                	jne    330 <history_command+0x30>
}
     353:	8d 65 f4             	lea    -0xc(%ebp),%esp
     356:	5b                   	pop    %ebx
     357:	5e                   	pop    %esi
     358:	5f                   	pop    %edi
     359:	5d                   	pop    %ebp
     35a:	c3                   	ret
     35b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000360 <block_command>:
void block_command(char *arg) {
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	53                   	push   %ebx
     364:	83 ec 10             	sub    $0x10,%esp
  int syscall_id = atoi(arg);
     367:	ff 75 08             	push   0x8(%ebp)
     36a:	e8 91 0d 00 00       	call   1100 <atoi>
  if (syscall_id <= 0) {
     36f:	83 c4 10             	add    $0x10,%esp
     372:	85 c0                	test   %eax,%eax
     374:	7e 12                	jle    388 <block_command+0x28>
  if (block(syscall_id) < 0) {
     376:	83 ec 0c             	sub    $0xc,%esp
     379:	89 c3                	mov    %eax,%ebx
     37b:	50                   	push   %eax
     37c:	e8 9a 0e 00 00       	call   121b <block>
     381:	83 c4 10             	add    $0x10,%esp
     384:	85 c0                	test   %eax,%eax
     386:	78 08                	js     390 <block_command+0x30>
}
     388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     38b:	c9                   	leave
     38c:	c3                   	ret
     38d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(2, "Error: Failed to block syscall %d\n", syscall_id);
     390:	83 ec 04             	sub    $0x4,%esp
     393:	53                   	push   %ebx
     394:	68 00 17 00 00       	push   $0x1700
     399:	6a 02                	push   $0x2
     39b:	e8 50 0f 00 00       	call   12f0 <printf>
}
     3a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3a3:	83 c4 10             	add    $0x10,%esp
     3a6:	c9                   	leave
     3a7:	c3                   	ret
     3a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3af:	00 

000003b0 <unblock_command>:
void unblock_command(char *arg) {
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	53                   	push   %ebx
     3b4:	83 ec 10             	sub    $0x10,%esp
  int syscall_id = atoi(arg);
     3b7:	ff 75 08             	push   0x8(%ebp)
     3ba:	e8 41 0d 00 00       	call   1100 <atoi>
  if (syscall_id <= 0) {
     3bf:	83 c4 10             	add    $0x10,%esp
     3c2:	85 c0                	test   %eax,%eax
     3c4:	7e 12                	jle    3d8 <unblock_command+0x28>
  if (unblock(syscall_id) < 0) {
     3c6:	83 ec 0c             	sub    $0xc,%esp
     3c9:	89 c3                	mov    %eax,%ebx
     3cb:	50                   	push   %eax
     3cc:	e8 52 0e 00 00       	call   1223 <unblock>
     3d1:	83 c4 10             	add    $0x10,%esp
     3d4:	85 c0                	test   %eax,%eax
     3d6:	78 08                	js     3e0 <unblock_command+0x30>
}
     3d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3db:	c9                   	leave
     3dc:	c3                   	ret
     3dd:	8d 76 00             	lea    0x0(%esi),%esi
      printf(2, "Error: Failed to unblock syscall %d\n", syscall_id);
     3e0:	83 ec 04             	sub    $0x4,%esp
     3e3:	53                   	push   %ebx
     3e4:	68 24 17 00 00       	push   $0x1724
     3e9:	6a 02                	push   $0x2
     3eb:	e8 00 0f 00 00       	call   12f0 <printf>
}
     3f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3f3:	83 c4 10             	add    $0x10,%esp
     3f6:	c9                   	leave
     3f7:	c3                   	ret
     3f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3ff:	00 

00000400 <chmod_command>:
void chmod_command(char *file, char *mode_str) {
     400:	55                   	push   %ebp
     401:	89 e5                	mov    %esp,%ebp
     403:	53                   	push   %ebx
     404:	83 ec 10             	sub    $0x10,%esp
  int mode = atoi(mode_str);
     407:	ff 75 0c             	push   0xc(%ebp)
void chmod_command(char *file, char *mode_str) {
     40a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int mode = atoi(mode_str);
     40d:	e8 ee 0c 00 00       	call   1100 <atoi>
  if (mode < 0 || mode > 7) {
     412:	83 c4 10             	add    $0x10,%esp
     415:	83 f8 07             	cmp    $0x7,%eax
     418:	77 16                	ja     430 <chmod_command+0x30>
  if (chmod(file, mode) < 0) {
     41a:	83 ec 08             	sub    $0x8,%esp
     41d:	50                   	push   %eax
     41e:	53                   	push   %ebx
     41f:	e8 07 0e 00 00       	call   122b <chmod>
     424:	83 c4 10             	add    $0x10,%esp
     427:	85 c0                	test   %eax,%eax
     429:	78 25                	js     450 <chmod_command+0x50>
}
     42b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     42e:	c9                   	leave
     42f:	c3                   	ret
      printf(2, "Invalid mode. Use a 3-bit integer (0-7)\n");
     430:	c7 45 0c 4c 17 00 00 	movl   $0x174c,0xc(%ebp)
}
     437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      printf(2, "Invalid mode. Use a 3-bit integer (0-7)\n");
     43a:	c7 45 08 02 00 00 00 	movl   $0x2,0x8(%ebp)
}
     441:	c9                   	leave
      printf(2, "Invalid mode. Use a 3-bit integer (0-7)\n");
     442:	e9 a9 0e 00 00       	jmp    12f0 <printf>
     447:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     44e:	00 
     44f:	90                   	nop
      printf(2, "chmod operation failed\n");
     450:	c7 45 0c 22 16 00 00 	movl   $0x1622,0xc(%ebp)
}
     457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      printf(2, "chmod operation failed\n");
     45a:	c7 45 08 02 00 00 00 	movl   $0x2,0x8(%ebp)
}
     461:	c9                   	leave
      printf(2, "chmod operation failed\n");
     462:	e9 89 0e 00 00       	jmp    12f0 <printf>
     467:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     46e:	00 
     46f:	90                   	nop

00000470 <getcmd>:
{
     470:	55                   	push   %ebp
     471:	89 e5                	mov    %esp,%ebp
     473:	56                   	push   %esi
     474:	53                   	push   %ebx
     475:	8b 75 0c             	mov    0xc(%ebp),%esi
     478:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     47b:	83 ec 08             	sub    $0x8,%esp
     47e:	68 3a 16 00 00       	push   $0x163a
     483:	6a 02                	push   $0x2
     485:	e8 66 0e 00 00       	call   12f0 <printf>
  memset(buf, 0, nbuf);
     48a:	83 c4 0c             	add    $0xc,%esp
     48d:	56                   	push   %esi
     48e:	6a 00                	push   $0x0
     490:	53                   	push   %ebx
     491:	e8 4a 0b 00 00       	call   fe0 <memset>
  gets(buf, nbuf);
     496:	58                   	pop    %eax
     497:	5a                   	pop    %edx
     498:	56                   	push   %esi
     499:	53                   	push   %ebx
     49a:	e8 a1 0b 00 00       	call   1040 <gets>
  if(buf[0] == 0) // EOF
     49f:	83 c4 10             	add    $0x10,%esp
     4a2:	80 3b 01             	cmpb   $0x1,(%ebx)
     4a5:	19 c0                	sbb    %eax,%eax
}
     4a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
     4aa:	5b                   	pop    %ebx
     4ab:	5e                   	pop    %esi
     4ac:	5d                   	pop    %ebp
     4ad:	c3                   	ret
     4ae:	66 90                	xchg   %ax,%ax

000004b0 <panic>:
{
     4b0:	55                   	push   %ebp
     4b1:	89 e5                	mov    %esp,%ebp
     4b3:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     4b6:	ff 75 08             	push   0x8(%ebp)
     4b9:	68 cf 16 00 00       	push   $0x16cf
     4be:	6a 02                	push   $0x2
     4c0:	e8 2b 0e 00 00       	call   12f0 <printf>
  exit();
     4c5:	e8 a9 0c 00 00       	call   1173 <exit>
     4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004d0 <fork1>:
{
     4d0:	55                   	push   %ebp
     4d1:	89 e5                	mov    %esp,%ebp
     4d3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     4d6:	e8 90 0c 00 00       	call   116b <fork>
  if(pid == -1)
     4db:	83 f8 ff             	cmp    $0xffffffff,%eax
     4de:	74 02                	je     4e2 <fork1+0x12>
  return pid;
}
     4e0:	c9                   	leave
     4e1:	c3                   	ret
    panic("fork");
     4e2:	83 ec 0c             	sub    $0xc,%esp
     4e5:	68 3d 16 00 00       	push   $0x163d
     4ea:	e8 c1 ff ff ff       	call   4b0 <panic>
     4ef:	90                   	nop

000004f0 <runcmd>:
{
     4f0:	55                   	push   %ebp
     4f1:	89 e5                	mov    %esp,%ebp
     4f3:	53                   	push   %ebx
     4f4:	83 ec 14             	sub    $0x14,%esp
     4f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     4fa:	85 db                	test   %ebx,%ebx
     4fc:	74 1f                	je     51d <runcmd+0x2d>
  switch(cmd->type){
     4fe:	83 3b 05             	cmpl   $0x5,(%ebx)
     501:	0f 87 ef 00 00 00    	ja     5f6 <runcmd+0x106>
     507:	8b 03                	mov    (%ebx),%eax
     509:	ff 24 85 78 17 00 00 	jmp    *0x1778(,%eax,4)
    if(fork1() == 0)
     510:	e8 bb ff ff ff       	call   4d0 <fork1>
     515:	85 c0                	test   %eax,%eax
     517:	0f 84 ce 00 00 00    	je     5eb <runcmd+0xfb>
    exit();
     51d:	e8 51 0c 00 00       	call   1173 <exit>
    if (ecmd->argv[0] == 0)
     522:	8b 43 04             	mov    0x4(%ebx),%eax
     525:	85 c0                	test   %eax,%eax
     527:	74 f4                	je     51d <runcmd+0x2d>
    if (strcmp(ecmd->argv[0], "unblock") == 0) {
     529:	52                   	push   %edx
     52a:	52                   	push   %edx
     52b:	68 49 16 00 00       	push   $0x1649
     530:	50                   	push   %eax
     531:	e8 1a 0a 00 00       	call   f50 <strcmp>
     536:	83 c4 10             	add    $0x10,%esp
     539:	85 c0                	test   %eax,%eax
     53b:	0f 84 12 01 00 00    	je     653 <runcmd+0x163>
    exec(ecmd->argv[0], ecmd->argv);
     541:	8d 43 04             	lea    0x4(%ebx),%eax
     544:	51                   	push   %ecx
     545:	51                   	push   %ecx
     546:	50                   	push   %eax
     547:	ff 73 04             	push   0x4(%ebx)
     54a:	e8 5c 0c 00 00       	call   11ab <exec>
    exit();
     54f:	e8 1f 0c 00 00       	call   1173 <exit>
    if(pipe(p) < 0)
     554:	83 ec 0c             	sub    $0xc,%esp
     557:	8d 45 f0             	lea    -0x10(%ebp),%eax
     55a:	50                   	push   %eax
     55b:	e8 23 0c 00 00       	call   1183 <pipe>
     560:	83 c4 10             	add    $0x10,%esp
     563:	85 c0                	test   %eax,%eax
     565:	0f 88 ad 00 00 00    	js     618 <runcmd+0x128>
    if(fork1() == 0){
     56b:	e8 60 ff ff ff       	call   4d0 <fork1>
     570:	85 c0                	test   %eax,%eax
     572:	0f 84 ad 00 00 00    	je     625 <runcmd+0x135>
    if(fork1() == 0){
     578:	e8 53 ff ff ff       	call   4d0 <fork1>
     57d:	85 c0                	test   %eax,%eax
     57f:	0f 85 e0 00 00 00    	jne    665 <runcmd+0x175>
      close(0);
     585:	83 ec 0c             	sub    $0xc,%esp
     588:	6a 00                	push   $0x0
     58a:	e8 0c 0c 00 00       	call   119b <close>
      dup(p[0]);
     58f:	5a                   	pop    %edx
     590:	ff 75 f0             	push   -0x10(%ebp)
     593:	e8 53 0c 00 00       	call   11eb <dup>
      close(p[0]);
     598:	59                   	pop    %ecx
     599:	ff 75 f0             	push   -0x10(%ebp)
     59c:	e8 fa 0b 00 00       	call   119b <close>
      close(p[1]);
     5a1:	58                   	pop    %eax
     5a2:	ff 75 f4             	push   -0xc(%ebp)
     5a5:	e8 f1 0b 00 00       	call   119b <close>
      runcmd(pcmd->right);
     5aa:	58                   	pop    %eax
     5ab:	ff 73 08             	push   0x8(%ebx)
     5ae:	e8 3d ff ff ff       	call   4f0 <runcmd>
    if(fork1() == 0)
     5b3:	e8 18 ff ff ff       	call   4d0 <fork1>
     5b8:	85 c0                	test   %eax,%eax
     5ba:	74 2f                	je     5eb <runcmd+0xfb>
    wait();
     5bc:	e8 ba 0b 00 00       	call   117b <wait>
    runcmd(lcmd->right);
     5c1:	83 ec 0c             	sub    $0xc,%esp
     5c4:	ff 73 08             	push   0x8(%ebx)
     5c7:	e8 24 ff ff ff       	call   4f0 <runcmd>
    close(rcmd->fd);
     5cc:	83 ec 0c             	sub    $0xc,%esp
     5cf:	ff 73 14             	push   0x14(%ebx)
     5d2:	e8 c4 0b 00 00       	call   119b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     5d7:	58                   	pop    %eax
     5d8:	5a                   	pop    %edx
     5d9:	ff 73 10             	push   0x10(%ebx)
     5dc:	ff 73 08             	push   0x8(%ebx)
     5df:	e8 cf 0b 00 00       	call   11b3 <open>
     5e4:	83 c4 10             	add    $0x10,%esp
     5e7:	85 c0                	test   %eax,%eax
     5e9:	78 18                	js     603 <runcmd+0x113>
      runcmd(bcmd->cmd);
     5eb:	83 ec 0c             	sub    $0xc,%esp
     5ee:	ff 73 04             	push   0x4(%ebx)
     5f1:	e8 fa fe ff ff       	call   4f0 <runcmd>
    panic("runcmd");
     5f6:	83 ec 0c             	sub    $0xc,%esp
     5f9:	68 42 16 00 00       	push   $0x1642
     5fe:	e8 ad fe ff ff       	call   4b0 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     603:	51                   	push   %ecx
     604:	ff 73 08             	push   0x8(%ebx)
     607:	68 51 16 00 00       	push   $0x1651
     60c:	6a 02                	push   $0x2
     60e:	e8 dd 0c 00 00       	call   12f0 <printf>
      exit();
     613:	e8 5b 0b 00 00       	call   1173 <exit>
      panic("pipe");
     618:	83 ec 0c             	sub    $0xc,%esp
     61b:	68 61 16 00 00       	push   $0x1661
     620:	e8 8b fe ff ff       	call   4b0 <panic>
      close(1);
     625:	83 ec 0c             	sub    $0xc,%esp
     628:	6a 01                	push   $0x1
     62a:	e8 6c 0b 00 00       	call   119b <close>
      dup(p[1]);
     62f:	58                   	pop    %eax
     630:	ff 75 f4             	push   -0xc(%ebp)
     633:	e8 b3 0b 00 00       	call   11eb <dup>
      close(p[0]);
     638:	58                   	pop    %eax
     639:	ff 75 f0             	push   -0x10(%ebp)
     63c:	e8 5a 0b 00 00       	call   119b <close>
      close(p[1]);
     641:	58                   	pop    %eax
     642:	ff 75 f4             	push   -0xc(%ebp)
     645:	e8 51 0b 00 00       	call   119b <close>
      runcmd(pcmd->left);
     64a:	5a                   	pop    %edx
     64b:	ff 73 04             	push   0x4(%ebx)
     64e:	e8 9d fe ff ff       	call   4f0 <runcmd>
        unblock(SYS_exec);
     653:	83 ec 0c             	sub    $0xc,%esp
     656:	6a 07                	push   $0x7
     658:	e8 c6 0b 00 00       	call   1223 <unblock>
     65d:	83 c4 10             	add    $0x10,%esp
     660:	e9 dc fe ff ff       	jmp    541 <runcmd+0x51>
    close(p[0]);
     665:	83 ec 0c             	sub    $0xc,%esp
     668:	ff 75 f0             	push   -0x10(%ebp)
     66b:	e8 2b 0b 00 00       	call   119b <close>
    close(p[1]);
     670:	58                   	pop    %eax
     671:	ff 75 f4             	push   -0xc(%ebp)
     674:	e8 22 0b 00 00       	call   119b <close>
    wait();
     679:	e8 fd 0a 00 00       	call   117b <wait>
    wait();
     67e:	e8 f8 0a 00 00       	call   117b <wait>
    break;
     683:	83 c4 10             	add    $0x10,%esp
     686:	e9 92 fe ff ff       	jmp    51d <runcmd+0x2d>
     68b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000690 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     690:	55                   	push   %ebp
     691:	89 e5                	mov    %esp,%ebp
     693:	53                   	push   %ebx
     694:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     697:	6a 54                	push   $0x54
     699:	e8 82 0e 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     69e:	83 c4 0c             	add    $0xc,%esp
     6a1:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     6a3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     6a5:	6a 00                	push   $0x0
     6a7:	50                   	push   %eax
     6a8:	e8 33 09 00 00       	call   fe0 <memset>
  cmd->type = EXEC;
     6ad:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     6b3:	89 d8                	mov    %ebx,%eax
     6b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     6b8:	c9                   	leave
     6b9:	c3                   	ret
     6ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000006c0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     6c0:	55                   	push   %ebp
     6c1:	89 e5                	mov    %esp,%ebp
     6c3:	53                   	push   %ebx
     6c4:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6c7:	6a 18                	push   $0x18
     6c9:	e8 52 0e 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6ce:	83 c4 0c             	add    $0xc,%esp
     6d1:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     6d3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     6d5:	6a 00                	push   $0x0
     6d7:	50                   	push   %eax
     6d8:	e8 03 09 00 00       	call   fe0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     6dd:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     6e0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     6e6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     6e9:	8b 45 0c             	mov    0xc(%ebp),%eax
     6ec:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     6ef:	8b 45 10             	mov    0x10(%ebp),%eax
     6f2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     6f5:	8b 45 14             	mov    0x14(%ebp),%eax
     6f8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     6fb:	8b 45 18             	mov    0x18(%ebp),%eax
     6fe:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     701:	89 d8                	mov    %ebx,%eax
     703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     706:	c9                   	leave
     707:	c3                   	ret
     708:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     70f:	00 

00000710 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     710:	55                   	push   %ebp
     711:	89 e5                	mov    %esp,%ebp
     713:	53                   	push   %ebx
     714:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     717:	6a 0c                	push   $0xc
     719:	e8 02 0e 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     71e:	83 c4 0c             	add    $0xc,%esp
     721:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     723:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     725:	6a 00                	push   $0x0
     727:	50                   	push   %eax
     728:	e8 b3 08 00 00       	call   fe0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     72d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     730:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
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

00000750 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     750:	55                   	push   %ebp
     751:	89 e5                	mov    %esp,%ebp
     753:	53                   	push   %ebx
     754:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     757:	6a 0c                	push   $0xc
     759:	e8 c2 0d 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     75e:	83 c4 0c             	add    $0xc,%esp
     761:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     763:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     765:	6a 00                	push   $0x0
     767:	50                   	push   %eax
     768:	e8 73 08 00 00       	call   fe0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     76d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     770:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     776:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     779:	8b 45 0c             	mov    0xc(%ebp),%eax
     77c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     77f:	89 d8                	mov    %ebx,%eax
     781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     784:	c9                   	leave
     785:	c3                   	ret
     786:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     78d:	00 
     78e:	66 90                	xchg   %ax,%ax

00000790 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	53                   	push   %ebx
     794:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     797:	6a 08                	push   $0x8
     799:	e8 82 0d 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     79e:	83 c4 0c             	add    $0xc,%esp
     7a1:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     7a3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     7a5:	6a 00                	push   $0x0
     7a7:	50                   	push   %eax
     7a8:	e8 33 08 00 00       	call   fe0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     7ad:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     7b0:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     7b6:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     7b9:	89 d8                	mov    %ebx,%eax
     7bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7be:	c9                   	leave
     7bf:	c3                   	ret

000007c0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     7c0:	55                   	push   %ebp
     7c1:	89 e5                	mov    %esp,%ebp
     7c3:	57                   	push   %edi
     7c4:	56                   	push   %esi
     7c5:	53                   	push   %ebx
     7c6:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     7c9:	8b 45 08             	mov    0x8(%ebp),%eax
{
     7cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     7cf:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     7d2:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     7d4:	39 df                	cmp    %ebx,%edi
     7d6:	72 0f                	jb     7e7 <gettoken+0x27>
     7d8:	eb 25                	jmp    7ff <gettoken+0x3f>
     7da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     7e0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     7e3:	39 fb                	cmp    %edi,%ebx
     7e5:	74 18                	je     7ff <gettoken+0x3f>
     7e7:	0f be 07             	movsbl (%edi),%eax
     7ea:	83 ec 08             	sub    $0x8,%esp
     7ed:	50                   	push   %eax
     7ee:	68 94 1e 00 00       	push   $0x1e94
     7f3:	e8 08 08 00 00       	call   1000 <strchr>
     7f8:	83 c4 10             	add    $0x10,%esp
     7fb:	85 c0                	test   %eax,%eax
     7fd:	75 e1                	jne    7e0 <gettoken+0x20>
  if(q)
     7ff:	85 f6                	test   %esi,%esi
     801:	74 02                	je     805 <gettoken+0x45>
    *q = s;
     803:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     805:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     808:	3c 3c                	cmp    $0x3c,%al
     80a:	0f 8f d0 00 00 00    	jg     8e0 <gettoken+0x120>
     810:	3c 3a                	cmp    $0x3a,%al
     812:	0f 8f b4 00 00 00    	jg     8cc <gettoken+0x10c>
     818:	84 c0                	test   %al,%al
     81a:	75 44                	jne    860 <gettoken+0xa0>
     81c:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     81e:	8b 55 14             	mov    0x14(%ebp),%edx
     821:	85 d2                	test   %edx,%edx
     823:	74 05                	je     82a <gettoken+0x6a>
    *eq = s;
     825:	8b 45 14             	mov    0x14(%ebp),%eax
     828:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     82a:	39 df                	cmp    %ebx,%edi
     82c:	72 09                	jb     837 <gettoken+0x77>
     82e:	eb 1f                	jmp    84f <gettoken+0x8f>
    s++;
     830:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     833:	39 fb                	cmp    %edi,%ebx
     835:	74 18                	je     84f <gettoken+0x8f>
     837:	0f be 07             	movsbl (%edi),%eax
     83a:	83 ec 08             	sub    $0x8,%esp
     83d:	50                   	push   %eax
     83e:	68 94 1e 00 00       	push   $0x1e94
     843:	e8 b8 07 00 00       	call   1000 <strchr>
     848:	83 c4 10             	add    $0x10,%esp
     84b:	85 c0                	test   %eax,%eax
     84d:	75 e1                	jne    830 <gettoken+0x70>
  *ps = s;
     84f:	8b 45 08             	mov    0x8(%ebp),%eax
     852:	89 38                	mov    %edi,(%eax)
  return ret;
}
     854:	8d 65 f4             	lea    -0xc(%ebp),%esp
     857:	89 f0                	mov    %esi,%eax
     859:	5b                   	pop    %ebx
     85a:	5e                   	pop    %esi
     85b:	5f                   	pop    %edi
     85c:	5d                   	pop    %ebp
     85d:	c3                   	ret
     85e:	66 90                	xchg   %ax,%ax
  switch(*s){
     860:	79 5e                	jns    8c0 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     862:	39 fb                	cmp    %edi,%ebx
     864:	77 34                	ja     89a <gettoken+0xda>
  if(eq)
     866:	8b 45 14             	mov    0x14(%ebp),%eax
     869:	be 61 00 00 00       	mov    $0x61,%esi
     86e:	85 c0                	test   %eax,%eax
     870:	75 b3                	jne    825 <gettoken+0x65>
     872:	eb db                	jmp    84f <gettoken+0x8f>
     874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     878:	0f be 07             	movsbl (%edi),%eax
     87b:	83 ec 08             	sub    $0x8,%esp
     87e:	50                   	push   %eax
     87f:	68 8c 1e 00 00       	push   $0x1e8c
     884:	e8 77 07 00 00       	call   1000 <strchr>
     889:	83 c4 10             	add    $0x10,%esp
     88c:	85 c0                	test   %eax,%eax
     88e:	75 22                	jne    8b2 <gettoken+0xf2>
      s++;
     890:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     893:	39 fb                	cmp    %edi,%ebx
     895:	74 cf                	je     866 <gettoken+0xa6>
     897:	0f b6 07             	movzbl (%edi),%eax
     89a:	83 ec 08             	sub    $0x8,%esp
     89d:	0f be f0             	movsbl %al,%esi
     8a0:	56                   	push   %esi
     8a1:	68 94 1e 00 00       	push   $0x1e94
     8a6:	e8 55 07 00 00       	call   1000 <strchr>
     8ab:	83 c4 10             	add    $0x10,%esp
     8ae:	85 c0                	test   %eax,%eax
     8b0:	74 c6                	je     878 <gettoken+0xb8>
    ret = 'a';
     8b2:	be 61 00 00 00       	mov    $0x61,%esi
     8b7:	e9 62 ff ff ff       	jmp    81e <gettoken+0x5e>
     8bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     8c0:	3c 26                	cmp    $0x26,%al
     8c2:	74 08                	je     8cc <gettoken+0x10c>
     8c4:	8d 48 d8             	lea    -0x28(%eax),%ecx
     8c7:	80 f9 01             	cmp    $0x1,%cl
     8ca:	77 96                	ja     862 <gettoken+0xa2>
  ret = *s;
     8cc:	0f be f0             	movsbl %al,%esi
    s++;
     8cf:	83 c7 01             	add    $0x1,%edi
    break;
     8d2:	e9 47 ff ff ff       	jmp    81e <gettoken+0x5e>
     8d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8de:	00 
     8df:	90                   	nop
  switch(*s){
     8e0:	3c 3e                	cmp    $0x3e,%al
     8e2:	75 1c                	jne    900 <gettoken+0x140>
    if(*s == '>'){
     8e4:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     8e8:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     8eb:	74 1c                	je     909 <gettoken+0x149>
    s++;
     8ed:	89 c7                	mov    %eax,%edi
     8ef:	be 3e 00 00 00       	mov    $0x3e,%esi
     8f4:	e9 25 ff ff ff       	jmp    81e <gettoken+0x5e>
     8f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     900:	3c 7c                	cmp    $0x7c,%al
     902:	74 c8                	je     8cc <gettoken+0x10c>
     904:	e9 59 ff ff ff       	jmp    862 <gettoken+0xa2>
      s++;
     909:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     90c:	be 2b 00 00 00       	mov    $0x2b,%esi
     911:	e9 08 ff ff ff       	jmp    81e <gettoken+0x5e>
     916:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     91d:	00 
     91e:	66 90                	xchg   %ax,%ax

00000920 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     920:	55                   	push   %ebp
     921:	89 e5                	mov    %esp,%ebp
     923:	57                   	push   %edi
     924:	56                   	push   %esi
     925:	53                   	push   %ebx
     926:	83 ec 0c             	sub    $0xc,%esp
     929:	8b 7d 08             	mov    0x8(%ebp),%edi
     92c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     92f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     931:	39 f3                	cmp    %esi,%ebx
     933:	72 12                	jb     947 <peek+0x27>
     935:	eb 28                	jmp    95f <peek+0x3f>
     937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     93e:	00 
     93f:	90                   	nop
    s++;
     940:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     943:	39 de                	cmp    %ebx,%esi
     945:	74 18                	je     95f <peek+0x3f>
     947:	0f be 03             	movsbl (%ebx),%eax
     94a:	83 ec 08             	sub    $0x8,%esp
     94d:	50                   	push   %eax
     94e:	68 94 1e 00 00       	push   $0x1e94
     953:	e8 a8 06 00 00       	call   1000 <strchr>
     958:	83 c4 10             	add    $0x10,%esp
     95b:	85 c0                	test   %eax,%eax
     95d:	75 e1                	jne    940 <peek+0x20>
  *ps = s;
     95f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     961:	0f be 03             	movsbl (%ebx),%eax
     964:	31 d2                	xor    %edx,%edx
     966:	84 c0                	test   %al,%al
     968:	75 0e                	jne    978 <peek+0x58>
}
     96a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     96d:	89 d0                	mov    %edx,%eax
     96f:	5b                   	pop    %ebx
     970:	5e                   	pop    %esi
     971:	5f                   	pop    %edi
     972:	5d                   	pop    %ebp
     973:	c3                   	ret
     974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     978:	83 ec 08             	sub    $0x8,%esp
     97b:	50                   	push   %eax
     97c:	ff 75 10             	push   0x10(%ebp)
     97f:	e8 7c 06 00 00       	call   1000 <strchr>
     984:	83 c4 10             	add    $0x10,%esp
     987:	31 d2                	xor    %edx,%edx
     989:	85 c0                	test   %eax,%eax
     98b:	0f 95 c2             	setne  %dl
}
     98e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     991:	5b                   	pop    %ebx
     992:	89 d0                	mov    %edx,%eax
     994:	5e                   	pop    %esi
     995:	5f                   	pop    %edi
     996:	5d                   	pop    %ebp
     997:	c3                   	ret
     998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     99f:	00 

000009a0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     9a0:	55                   	push   %ebp
     9a1:	89 e5                	mov    %esp,%ebp
     9a3:	57                   	push   %edi
     9a4:	56                   	push   %esi
     9a5:	53                   	push   %ebx
     9a6:	83 ec 2c             	sub    $0x2c,%esp
     9a9:	8b 75 0c             	mov    0xc(%ebp),%esi
     9ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9af:	90                   	nop
     9b0:	83 ec 04             	sub    $0x4,%esp
     9b3:	68 83 16 00 00       	push   $0x1683
     9b8:	53                   	push   %ebx
     9b9:	56                   	push   %esi
     9ba:	e8 61 ff ff ff       	call   920 <peek>
     9bf:	83 c4 10             	add    $0x10,%esp
     9c2:	85 c0                	test   %eax,%eax
     9c4:	0f 84 f6 00 00 00    	je     ac0 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     9ca:	6a 00                	push   $0x0
     9cc:	6a 00                	push   $0x0
     9ce:	53                   	push   %ebx
     9cf:	56                   	push   %esi
     9d0:	e8 eb fd ff ff       	call   7c0 <gettoken>
     9d5:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     9d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     9da:	50                   	push   %eax
     9db:	8d 45 e0             	lea    -0x20(%ebp),%eax
     9de:	50                   	push   %eax
     9df:	53                   	push   %ebx
     9e0:	56                   	push   %esi
     9e1:	e8 da fd ff ff       	call   7c0 <gettoken>
     9e6:	83 c4 20             	add    $0x20,%esp
     9e9:	83 f8 61             	cmp    $0x61,%eax
     9ec:	0f 85 d9 00 00 00    	jne    acb <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     9f2:	83 ff 3c             	cmp    $0x3c,%edi
     9f5:	74 69                	je     a60 <parseredirs+0xc0>
     9f7:	83 ff 3e             	cmp    $0x3e,%edi
     9fa:	74 05                	je     a01 <parseredirs+0x61>
     9fc:	83 ff 2b             	cmp    $0x2b,%edi
     9ff:	75 af                	jne    9b0 <parseredirs+0x10>
  cmd = malloc(sizeof(*cmd));
     a01:	83 ec 0c             	sub    $0xc,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     a07:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     a0a:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a0c:	89 55 d0             	mov    %edx,-0x30(%ebp)
     a0f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     a12:	e8 09 0b 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     a17:	83 c4 0c             	add    $0xc,%esp
     a1a:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     a1c:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     a1e:	6a 00                	push   $0x0
     a20:	50                   	push   %eax
     a21:	e8 ba 05 00 00       	call   fe0 <memset>
  cmd->type = REDIR;
     a26:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     a2c:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     a2f:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     a32:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     a35:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     a38:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     a3b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     a3e:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     a45:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     a48:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      break;
     a4f:	89 7d 08             	mov    %edi,0x8(%ebp)
     a52:	e9 59 ff ff ff       	jmp    9b0 <parseredirs+0x10>
     a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a5e:	00 
     a5f:	90                   	nop
  cmd = malloc(sizeof(*cmd));
     a60:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     a63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     a66:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     a69:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     a6b:	89 55 d0             	mov    %edx,-0x30(%ebp)
     a6e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     a71:	e8 aa 0a 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     a76:	83 c4 0c             	add    $0xc,%esp
     a79:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     a7b:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     a7d:	6a 00                	push   $0x0
     a7f:	50                   	push   %eax
     a80:	e8 5b 05 00 00       	call   fe0 <memset>
  cmd->cmd = subcmd;
     a85:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     a88:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     a8b:	89 7d 08             	mov    %edi,0x8(%ebp)
  cmd->efile = efile;
     a8e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     a91:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
      break;
     a97:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     a9a:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     a9d:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     aa0:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     aa3:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     aaa:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      break;
     ab1:	e9 fa fe ff ff       	jmp    9b0 <parseredirs+0x10>
     ab6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     abd:	00 
     abe:	66 90                	xchg   %ax,%ax
    }
  }
  return cmd;
}
     ac0:	8b 45 08             	mov    0x8(%ebp),%eax
     ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ac6:	5b                   	pop    %ebx
     ac7:	5e                   	pop    %esi
     ac8:	5f                   	pop    %edi
     ac9:	5d                   	pop    %ebp
     aca:	c3                   	ret
      panic("missing file for redirection");
     acb:	83 ec 0c             	sub    $0xc,%esp
     ace:	68 66 16 00 00       	push   $0x1666
     ad3:	e8 d8 f9 ff ff       	call   4b0 <panic>
     ad8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     adf:	00 

00000ae0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     ae0:	55                   	push   %ebp
     ae1:	89 e5                	mov    %esp,%ebp
     ae3:	57                   	push   %edi
     ae4:	56                   	push   %esi
     ae5:	53                   	push   %ebx
     ae6:	83 ec 30             	sub    $0x30,%esp
     ae9:	8b 75 08             	mov    0x8(%ebp),%esi
     aec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     aef:	68 86 16 00 00       	push   $0x1686
     af4:	57                   	push   %edi
     af5:	56                   	push   %esi
     af6:	e8 25 fe ff ff       	call   920 <peek>
     afb:	83 c4 10             	add    $0x10,%esp
     afe:	85 c0                	test   %eax,%eax
     b00:	0f 85 aa 00 00 00    	jne    bb0 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     b06:	83 ec 0c             	sub    $0xc,%esp
     b09:	89 c3                	mov    %eax,%ebx
     b0b:	6a 54                	push   $0x54
     b0d:	e8 0e 0a 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     b12:	83 c4 0c             	add    $0xc,%esp
     b15:	6a 54                	push   $0x54
     b17:	6a 00                	push   $0x0
     b19:	50                   	push   %eax
     b1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
     b1d:	e8 be 04 00 00       	call   fe0 <memset>
  cmd->type = EXEC;
     b22:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     b25:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     b28:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     b2e:	57                   	push   %edi
     b2f:	56                   	push   %esi
     b30:	50                   	push   %eax
     b31:	e8 6a fe ff ff       	call   9a0 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     b36:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     b39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     b3c:	eb 15                	jmp    b53 <parseexec+0x73>
     b3e:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     b40:	83 ec 04             	sub    $0x4,%esp
     b43:	57                   	push   %edi
     b44:	56                   	push   %esi
     b45:	ff 75 d4             	push   -0x2c(%ebp)
     b48:	e8 53 fe ff ff       	call   9a0 <parseredirs>
     b4d:	83 c4 10             	add    $0x10,%esp
     b50:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     b53:	83 ec 04             	sub    $0x4,%esp
     b56:	68 9d 16 00 00       	push   $0x169d
     b5b:	57                   	push   %edi
     b5c:	56                   	push   %esi
     b5d:	e8 be fd ff ff       	call   920 <peek>
     b62:	83 c4 10             	add    $0x10,%esp
     b65:	85 c0                	test   %eax,%eax
     b67:	75 5f                	jne    bc8 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b69:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b6c:	50                   	push   %eax
     b6d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b70:	50                   	push   %eax
     b71:	57                   	push   %edi
     b72:	56                   	push   %esi
     b73:	e8 48 fc ff ff       	call   7c0 <gettoken>
     b78:	83 c4 10             	add    $0x10,%esp
     b7b:	85 c0                	test   %eax,%eax
     b7d:	74 49                	je     bc8 <parseexec+0xe8>
    if(tok != 'a')
     b7f:	83 f8 61             	cmp    $0x61,%eax
     b82:	75 62                	jne    be6 <parseexec+0x106>
    cmd->argv[argc] = q;
     b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b87:	8b 55 d0             	mov    -0x30(%ebp),%edx
     b8a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b91:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     b95:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     b98:	83 fb 0a             	cmp    $0xa,%ebx
     b9b:	75 a3                	jne    b40 <parseexec+0x60>
      panic("too many args");
     b9d:	83 ec 0c             	sub    $0xc,%esp
     ba0:	68 8f 16 00 00       	push   $0x168f
     ba5:	e8 06 f9 ff ff       	call   4b0 <panic>
     baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     bb0:	89 7d 0c             	mov    %edi,0xc(%ebp)
     bb3:	89 75 08             	mov    %esi,0x8(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bb9:	5b                   	pop    %ebx
     bba:	5e                   	pop    %esi
     bbb:	5f                   	pop    %edi
     bbc:	5d                   	pop    %ebp
    return parseblock(ps, es);
     bbd:	e9 ae 01 00 00       	jmp    d70 <parseblock>
     bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc] = 0;
     bc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
     bcb:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     bd2:	00 
  cmd->eargv[argc] = 0;
     bd3:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     bda:	00 
}
     bdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
     be1:	5b                   	pop    %ebx
     be2:	5e                   	pop    %esi
     be3:	5f                   	pop    %edi
     be4:	5d                   	pop    %ebp
     be5:	c3                   	ret
      panic("syntax");
     be6:	83 ec 0c             	sub    $0xc,%esp
     be9:	68 88 16 00 00       	push   $0x1688
     bee:	e8 bd f8 ff ff       	call   4b0 <panic>
     bf3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     bfa:	00 
     bfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000c00 <parsepipe>:
{
     c00:	55                   	push   %ebp
     c01:	89 e5                	mov    %esp,%ebp
     c03:	57                   	push   %edi
     c04:	56                   	push   %esi
     c05:	53                   	push   %ebx
     c06:	83 ec 14             	sub    $0x14,%esp
     c09:	8b 75 08             	mov    0x8(%ebp),%esi
     c0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     c0f:	57                   	push   %edi
     c10:	56                   	push   %esi
     c11:	e8 ca fe ff ff       	call   ae0 <parseexec>
  if(peek(ps, es, "|")){
     c16:	83 c4 0c             	add    $0xc,%esp
     c19:	68 a2 16 00 00       	push   $0x16a2
  cmd = parseexec(ps, es);
     c1e:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     c20:	57                   	push   %edi
     c21:	56                   	push   %esi
     c22:	e8 f9 fc ff ff       	call   920 <peek>
     c27:	83 c4 10             	add    $0x10,%esp
     c2a:	85 c0                	test   %eax,%eax
     c2c:	75 12                	jne    c40 <parsepipe+0x40>
}
     c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c31:	89 d8                	mov    %ebx,%eax
     c33:	5b                   	pop    %ebx
     c34:	5e                   	pop    %esi
     c35:	5f                   	pop    %edi
     c36:	5d                   	pop    %ebp
     c37:	c3                   	ret
     c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c3f:	00 
    gettoken(ps, es, 0, 0);
     c40:	6a 00                	push   $0x0
     c42:	6a 00                	push   $0x0
     c44:	57                   	push   %edi
     c45:	56                   	push   %esi
     c46:	e8 75 fb ff ff       	call   7c0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     c4b:	58                   	pop    %eax
     c4c:	5a                   	pop    %edx
     c4d:	57                   	push   %edi
     c4e:	56                   	push   %esi
     c4f:	e8 ac ff ff ff       	call   c00 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     c54:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     c5b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     c5d:	e8 be 08 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     c62:	83 c4 0c             	add    $0xc,%esp
     c65:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     c67:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     c69:	6a 00                	push   $0x0
     c6b:	50                   	push   %eax
     c6c:	e8 6f 03 00 00       	call   fe0 <memset>
  cmd->left = left;
     c71:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     c74:	83 c4 10             	add    $0x10,%esp
     c77:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     c79:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     c7f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     c81:	89 7e 08             	mov    %edi,0x8(%esi)
}
     c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c87:	5b                   	pop    %ebx
     c88:	5e                   	pop    %esi
     c89:	5f                   	pop    %edi
     c8a:	5d                   	pop    %ebp
     c8b:	c3                   	ret
     c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c90 <parseline>:
{
     c90:	55                   	push   %ebp
     c91:	89 e5                	mov    %esp,%ebp
     c93:	57                   	push   %edi
     c94:	56                   	push   %esi
     c95:	53                   	push   %ebx
     c96:	83 ec 24             	sub    $0x24,%esp
     c99:	8b 75 08             	mov    0x8(%ebp),%esi
     c9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     c9f:	57                   	push   %edi
     ca0:	56                   	push   %esi
     ca1:	e8 5a ff ff ff       	call   c00 <parsepipe>
  while(peek(ps, es, "&")){
     ca6:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     ca9:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     cab:	eb 3b                	jmp    ce8 <parseline+0x58>
     cad:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     cb0:	6a 00                	push   $0x0
     cb2:	6a 00                	push   $0x0
     cb4:	57                   	push   %edi
     cb5:	56                   	push   %esi
     cb6:	e8 05 fb ff ff       	call   7c0 <gettoken>
  cmd = malloc(sizeof(*cmd));
     cbb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     cc2:	e8 59 08 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     cc7:	83 c4 0c             	add    $0xc,%esp
     cca:	6a 08                	push   $0x8
     ccc:	6a 00                	push   $0x0
     cce:	50                   	push   %eax
     ccf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     cd2:	e8 09 03 00 00       	call   fe0 <memset>
  cmd->type = BACK;
     cd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     cda:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     cdd:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     ce3:	89 5a 04             	mov    %ebx,0x4(%edx)
     ce6:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     ce8:	83 ec 04             	sub    $0x4,%esp
     ceb:	68 a4 16 00 00       	push   $0x16a4
     cf0:	57                   	push   %edi
     cf1:	56                   	push   %esi
     cf2:	e8 29 fc ff ff       	call   920 <peek>
     cf7:	83 c4 10             	add    $0x10,%esp
     cfa:	85 c0                	test   %eax,%eax
     cfc:	75 b2                	jne    cb0 <parseline+0x20>
  if(peek(ps, es, ";")){
     cfe:	83 ec 04             	sub    $0x4,%esp
     d01:	68 a0 16 00 00       	push   $0x16a0
     d06:	57                   	push   %edi
     d07:	56                   	push   %esi
     d08:	e8 13 fc ff ff       	call   920 <peek>
     d0d:	83 c4 10             	add    $0x10,%esp
     d10:	85 c0                	test   %eax,%eax
     d12:	75 0c                	jne    d20 <parseline+0x90>
}
     d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d17:	89 d8                	mov    %ebx,%eax
     d19:	5b                   	pop    %ebx
     d1a:	5e                   	pop    %esi
     d1b:	5f                   	pop    %edi
     d1c:	5d                   	pop    %ebp
     d1d:	c3                   	ret
     d1e:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     d20:	6a 00                	push   $0x0
     d22:	6a 00                	push   $0x0
     d24:	57                   	push   %edi
     d25:	56                   	push   %esi
     d26:	e8 95 fa ff ff       	call   7c0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     d2b:	58                   	pop    %eax
     d2c:	5a                   	pop    %edx
     d2d:	57                   	push   %edi
     d2e:	56                   	push   %esi
     d2f:	e8 5c ff ff ff       	call   c90 <parseline>
  cmd = malloc(sizeof(*cmd));
     d34:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     d3b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     d3d:	e8 de 07 00 00       	call   1520 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     d42:	83 c4 0c             	add    $0xc,%esp
     d45:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     d47:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     d49:	6a 00                	push   $0x0
     d4b:	50                   	push   %eax
     d4c:	e8 8f 02 00 00       	call   fe0 <memset>
  cmd->left = left;
     d51:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     d54:	83 c4 10             	add    $0x10,%esp
     d57:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     d59:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     d5f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     d61:	89 7e 08             	mov    %edi,0x8(%esi)
}
     d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d67:	5b                   	pop    %ebx
     d68:	5e                   	pop    %esi
     d69:	5f                   	pop    %edi
     d6a:	5d                   	pop    %ebp
     d6b:	c3                   	ret
     d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d70 <parseblock>:
{
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	57                   	push   %edi
     d74:	56                   	push   %esi
     d75:	53                   	push   %ebx
     d76:	83 ec 10             	sub    $0x10,%esp
     d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
     d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     d7f:	68 86 16 00 00       	push   $0x1686
     d84:	56                   	push   %esi
     d85:	53                   	push   %ebx
     d86:	e8 95 fb ff ff       	call   920 <peek>
     d8b:	83 c4 10             	add    $0x10,%esp
     d8e:	85 c0                	test   %eax,%eax
     d90:	74 4a                	je     ddc <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     d92:	6a 00                	push   $0x0
     d94:	6a 00                	push   $0x0
     d96:	56                   	push   %esi
     d97:	53                   	push   %ebx
     d98:	e8 23 fa ff ff       	call   7c0 <gettoken>
  cmd = parseline(ps, es);
     d9d:	58                   	pop    %eax
     d9e:	5a                   	pop    %edx
     d9f:	56                   	push   %esi
     da0:	53                   	push   %ebx
     da1:	e8 ea fe ff ff       	call   c90 <parseline>
  if(!peek(ps, es, ")"))
     da6:	83 c4 0c             	add    $0xc,%esp
     da9:	68 c2 16 00 00       	push   $0x16c2
  cmd = parseline(ps, es);
     dae:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     db0:	56                   	push   %esi
     db1:	53                   	push   %ebx
     db2:	e8 69 fb ff ff       	call   920 <peek>
     db7:	83 c4 10             	add    $0x10,%esp
     dba:	85 c0                	test   %eax,%eax
     dbc:	74 2b                	je     de9 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     dbe:	6a 00                	push   $0x0
     dc0:	6a 00                	push   $0x0
     dc2:	56                   	push   %esi
     dc3:	53                   	push   %ebx
     dc4:	e8 f7 f9 ff ff       	call   7c0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     dc9:	83 c4 0c             	add    $0xc,%esp
     dcc:	56                   	push   %esi
     dcd:	53                   	push   %ebx
     dce:	57                   	push   %edi
     dcf:	e8 cc fb ff ff       	call   9a0 <parseredirs>
}
     dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     dd7:	5b                   	pop    %ebx
     dd8:	5e                   	pop    %esi
     dd9:	5f                   	pop    %edi
     dda:	5d                   	pop    %ebp
     ddb:	c3                   	ret
    panic("parseblock");
     ddc:	83 ec 0c             	sub    $0xc,%esp
     ddf:	68 a6 16 00 00       	push   $0x16a6
     de4:	e8 c7 f6 ff ff       	call   4b0 <panic>
    panic("syntax - missing )");
     de9:	83 ec 0c             	sub    $0xc,%esp
     dec:	68 b1 16 00 00       	push   $0x16b1
     df1:	e8 ba f6 ff ff       	call   4b0 <panic>
     df6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     dfd:	00 
     dfe:	66 90                	xchg   %ax,%ax

00000e00 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e00:	55                   	push   %ebp
     e01:	89 e5                	mov    %esp,%ebp
     e03:	53                   	push   %ebx
     e04:	83 ec 04             	sub    $0x4,%esp
     e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     e0a:	85 db                	test   %ebx,%ebx
     e0c:	0f 84 8e 00 00 00    	je     ea0 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
     e12:	83 3b 05             	cmpl   $0x5,(%ebx)
     e15:	77 61                	ja     e78 <nulterminate+0x78>
     e17:	8b 03                	mov    (%ebx),%eax
     e19:	ff 24 85 90 17 00 00 	jmp    *0x1790(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     e20:	83 ec 0c             	sub    $0xc,%esp
     e23:	ff 73 04             	push   0x4(%ebx)
     e26:	e8 d5 ff ff ff       	call   e00 <nulterminate>
    nulterminate(lcmd->right);
     e2b:	58                   	pop    %eax
     e2c:	ff 73 08             	push   0x8(%ebx)
     e2f:	e8 cc ff ff ff       	call   e00 <nulterminate>
    break;
     e34:	83 c4 10             	add    $0x10,%esp
     e37:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e3c:	c9                   	leave
     e3d:	c3                   	ret
     e3e:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     e40:	83 ec 0c             	sub    $0xc,%esp
     e43:	ff 73 04             	push   0x4(%ebx)
     e46:	e8 b5 ff ff ff       	call   e00 <nulterminate>
    break;
     e4b:	89 d8                	mov    %ebx,%eax
     e4d:	83 c4 10             	add    $0x10,%esp
}
     e50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e53:	c9                   	leave
     e54:	c3                   	ret
     e55:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     e58:	8b 4b 04             	mov    0x4(%ebx),%ecx
     e5b:	8d 43 08             	lea    0x8(%ebx),%eax
     e5e:	85 c9                	test   %ecx,%ecx
     e60:	74 16                	je     e78 <nulterminate+0x78>
     e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     e68:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     e6b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     e6e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     e71:	8b 50 fc             	mov    -0x4(%eax),%edx
     e74:	85 d2                	test   %edx,%edx
     e76:	75 f0                	jne    e68 <nulterminate+0x68>
  switch(cmd->type){
     e78:	89 d8                	mov    %ebx,%eax
}
     e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e7d:	c9                   	leave
     e7e:	c3                   	ret
     e7f:	90                   	nop
    nulterminate(rcmd->cmd);
     e80:	83 ec 0c             	sub    $0xc,%esp
     e83:	ff 73 04             	push   0x4(%ebx)
     e86:	e8 75 ff ff ff       	call   e00 <nulterminate>
    *rcmd->efile = 0;
     e8b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     e8e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     e91:	c6 00 00             	movb   $0x0,(%eax)
    break;
     e94:	89 d8                	mov    %ebx,%eax
}
     e96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e99:	c9                   	leave
     e9a:	c3                   	ret
     e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return 0;
     ea0:	31 c0                	xor    %eax,%eax
     ea2:	eb 95                	jmp    e39 <nulterminate+0x39>
     ea4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     eab:	00 
     eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000eb0 <parsecmd>:
{
     eb0:	55                   	push   %ebp
     eb1:	89 e5                	mov    %esp,%ebp
     eb3:	57                   	push   %edi
     eb4:	56                   	push   %esi
  cmd = parseline(&s, es);
     eb5:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     eb8:	53                   	push   %ebx
     eb9:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     ebc:	8b 5d 08             	mov    0x8(%ebp),%ebx
     ebf:	53                   	push   %ebx
     ec0:	e8 eb 00 00 00       	call   fb0 <strlen>
  cmd = parseline(&s, es);
     ec5:	59                   	pop    %ecx
     ec6:	5e                   	pop    %esi
  es = s + strlen(s);
     ec7:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     ec9:	53                   	push   %ebx
     eca:	57                   	push   %edi
     ecb:	e8 c0 fd ff ff       	call   c90 <parseline>
  peek(&s, es, "");
     ed0:	83 c4 0c             	add    $0xc,%esp
     ed3:	68 f6 16 00 00       	push   $0x16f6
  cmd = parseline(&s, es);
     ed8:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     eda:	53                   	push   %ebx
     edb:	57                   	push   %edi
     edc:	e8 3f fa ff ff       	call   920 <peek>
  if(s != es){
     ee1:	8b 45 08             	mov    0x8(%ebp),%eax
     ee4:	83 c4 10             	add    $0x10,%esp
     ee7:	39 d8                	cmp    %ebx,%eax
     ee9:	75 13                	jne    efe <parsecmd+0x4e>
  nulterminate(cmd);
     eeb:	83 ec 0c             	sub    $0xc,%esp
     eee:	56                   	push   %esi
     eef:	e8 0c ff ff ff       	call   e00 <nulterminate>
}
     ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ef7:	89 f0                	mov    %esi,%eax
     ef9:	5b                   	pop    %ebx
     efa:	5e                   	pop    %esi
     efb:	5f                   	pop    %edi
     efc:	5d                   	pop    %ebp
     efd:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
     efe:	52                   	push   %edx
     eff:	50                   	push   %eax
     f00:	68 c4 16 00 00       	push   $0x16c4
     f05:	6a 02                	push   $0x2
     f07:	e8 e4 03 00 00       	call   12f0 <printf>
    panic("syntax");
     f0c:	c7 04 24 88 16 00 00 	movl   $0x1688,(%esp)
     f13:	e8 98 f5 ff ff       	call   4b0 <panic>
     f18:	66 90                	xchg   %ax,%ax
     f1a:	66 90                	xchg   %ax,%ax
     f1c:	66 90                	xchg   %ax,%ax
     f1e:	66 90                	xchg   %ax,%ax

00000f20 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     f20:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     f21:	31 c0                	xor    %eax,%eax
{
     f23:	89 e5                	mov    %esp,%ebp
     f25:	53                   	push   %ebx
     f26:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     f30:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     f34:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     f37:	83 c0 01             	add    $0x1,%eax
     f3a:	84 d2                	test   %dl,%dl
     f3c:	75 f2                	jne    f30 <strcpy+0x10>
    ;
  return os;
}
     f3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f41:	89 c8                	mov    %ecx,%eax
     f43:	c9                   	leave
     f44:	c3                   	ret
     f45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f4c:	00 
     f4d:	8d 76 00             	lea    0x0(%esi),%esi

00000f50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f50:	55                   	push   %ebp
     f51:	89 e5                	mov    %esp,%ebp
     f53:	53                   	push   %ebx
     f54:	8b 55 08             	mov    0x8(%ebp),%edx
     f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     f5a:	0f b6 02             	movzbl (%edx),%eax
     f5d:	84 c0                	test   %al,%al
     f5f:	75 17                	jne    f78 <strcmp+0x28>
     f61:	eb 3a                	jmp    f9d <strcmp+0x4d>
     f63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     f68:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     f6c:	83 c2 01             	add    $0x1,%edx
     f6f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     f72:	84 c0                	test   %al,%al
     f74:	74 1a                	je     f90 <strcmp+0x40>
    p++, q++;
     f76:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
     f78:	0f b6 19             	movzbl (%ecx),%ebx
     f7b:	38 c3                	cmp    %al,%bl
     f7d:	74 e9                	je     f68 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     f7f:	29 d8                	sub    %ebx,%eax
}
     f81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f84:	c9                   	leave
     f85:	c3                   	ret
     f86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f8d:	00 
     f8e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     f90:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     f94:	31 c0                	xor    %eax,%eax
     f96:	29 d8                	sub    %ebx,%eax
}
     f98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f9b:	c9                   	leave
     f9c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     f9d:	0f b6 19             	movzbl (%ecx),%ebx
     fa0:	31 c0                	xor    %eax,%eax
     fa2:	eb db                	jmp    f7f <strcmp+0x2f>
     fa4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fab:	00 
     fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000fb0 <strlen>:

uint
strlen(const char *s)
{
     fb0:	55                   	push   %ebp
     fb1:	89 e5                	mov    %esp,%ebp
     fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     fb6:	80 3a 00             	cmpb   $0x0,(%edx)
     fb9:	74 15                	je     fd0 <strlen+0x20>
     fbb:	31 c0                	xor    %eax,%eax
     fbd:	8d 76 00             	lea    0x0(%esi),%esi
     fc0:	83 c0 01             	add    $0x1,%eax
     fc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     fc7:	89 c1                	mov    %eax,%ecx
     fc9:	75 f5                	jne    fc0 <strlen+0x10>
    ;
  return n;
}
     fcb:	89 c8                	mov    %ecx,%eax
     fcd:	5d                   	pop    %ebp
     fce:	c3                   	ret
     fcf:	90                   	nop
  for(n = 0; s[n]; n++)
     fd0:	31 c9                	xor    %ecx,%ecx
}
     fd2:	5d                   	pop    %ebp
     fd3:	89 c8                	mov    %ecx,%eax
     fd5:	c3                   	ret
     fd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fdd:	00 
     fde:	66 90                	xchg   %ax,%ax

00000fe0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     fe0:	55                   	push   %ebp
     fe1:	89 e5                	mov    %esp,%ebp
     fe3:	57                   	push   %edi
     fe4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     fe7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     fea:	8b 45 0c             	mov    0xc(%ebp),%eax
     fed:	89 d7                	mov    %edx,%edi
     fef:	fc                   	cld
     ff0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     ff2:	8b 7d fc             	mov    -0x4(%ebp),%edi
     ff5:	89 d0                	mov    %edx,%eax
     ff7:	c9                   	leave
     ff8:	c3                   	ret
     ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001000 <strchr>:

char*
strchr(const char *s, char c)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	8b 45 08             	mov    0x8(%ebp),%eax
    1006:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    100a:	0f b6 10             	movzbl (%eax),%edx
    100d:	84 d2                	test   %dl,%dl
    100f:	75 12                	jne    1023 <strchr+0x23>
    1011:	eb 1d                	jmp    1030 <strchr+0x30>
    1013:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    1018:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    101c:	83 c0 01             	add    $0x1,%eax
    101f:	84 d2                	test   %dl,%dl
    1021:	74 0d                	je     1030 <strchr+0x30>
    if(*s == c)
    1023:	38 d1                	cmp    %dl,%cl
    1025:	75 f1                	jne    1018 <strchr+0x18>
      return (char*)s;
  return 0;
}
    1027:	5d                   	pop    %ebp
    1028:	c3                   	ret
    1029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1030:	31 c0                	xor    %eax,%eax
}
    1032:	5d                   	pop    %ebp
    1033:	c3                   	ret
    1034:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    103b:	00 
    103c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001040 <gets>:

char*
gets(char *buf, int max)
{
    1040:	55                   	push   %ebp
    1041:	89 e5                	mov    %esp,%ebp
    1043:	57                   	push   %edi
    1044:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1045:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    1048:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    1049:	31 db                	xor    %ebx,%ebx
{
    104b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    104e:	eb 27                	jmp    1077 <gets+0x37>
    cc = read(0, &c, 1);
    1050:	83 ec 04             	sub    $0x4,%esp
    1053:	6a 01                	push   $0x1
    1055:	57                   	push   %edi
    1056:	6a 00                	push   $0x0
    1058:	e8 2e 01 00 00       	call   118b <read>
    if(cc < 1)
    105d:	83 c4 10             	add    $0x10,%esp
    1060:	85 c0                	test   %eax,%eax
    1062:	7e 1d                	jle    1081 <gets+0x41>
      break;
    buf[i++] = c;
    1064:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1068:	8b 55 08             	mov    0x8(%ebp),%edx
    106b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    106f:	3c 0a                	cmp    $0xa,%al
    1071:	74 1d                	je     1090 <gets+0x50>
    1073:	3c 0d                	cmp    $0xd,%al
    1075:	74 19                	je     1090 <gets+0x50>
  for(i=0; i+1 < max; ){
    1077:	89 de                	mov    %ebx,%esi
    1079:	83 c3 01             	add    $0x1,%ebx
    107c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    107f:	7c cf                	jl     1050 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    1081:	8b 45 08             	mov    0x8(%ebp),%eax
    1084:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1088:	8d 65 f4             	lea    -0xc(%ebp),%esp
    108b:	5b                   	pop    %ebx
    108c:	5e                   	pop    %esi
    108d:	5f                   	pop    %edi
    108e:	5d                   	pop    %ebp
    108f:	c3                   	ret
  buf[i] = '\0';
    1090:	8b 45 08             	mov    0x8(%ebp),%eax
    1093:	89 de                	mov    %ebx,%esi
    1095:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    1099:	8d 65 f4             	lea    -0xc(%ebp),%esp
    109c:	5b                   	pop    %ebx
    109d:	5e                   	pop    %esi
    109e:	5f                   	pop    %edi
    109f:	5d                   	pop    %ebp
    10a0:	c3                   	ret
    10a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10a8:	00 
    10a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000010b0 <stat>:

int
stat(const char *n, struct stat *st)
{
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	56                   	push   %esi
    10b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    10b5:	83 ec 08             	sub    $0x8,%esp
    10b8:	6a 00                	push   $0x0
    10ba:	ff 75 08             	push   0x8(%ebp)
    10bd:	e8 f1 00 00 00       	call   11b3 <open>
  if(fd < 0)
    10c2:	83 c4 10             	add    $0x10,%esp
    10c5:	85 c0                	test   %eax,%eax
    10c7:	78 27                	js     10f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    10c9:	83 ec 08             	sub    $0x8,%esp
    10cc:	ff 75 0c             	push   0xc(%ebp)
    10cf:	89 c3                	mov    %eax,%ebx
    10d1:	50                   	push   %eax
    10d2:	e8 f4 00 00 00       	call   11cb <fstat>
  close(fd);
    10d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    10da:	89 c6                	mov    %eax,%esi
  close(fd);
    10dc:	e8 ba 00 00 00       	call   119b <close>
  return r;
    10e1:	83 c4 10             	add    $0x10,%esp
}
    10e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    10e7:	89 f0                	mov    %esi,%eax
    10e9:	5b                   	pop    %ebx
    10ea:	5e                   	pop    %esi
    10eb:	5d                   	pop    %ebp
    10ec:	c3                   	ret
    10ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    10f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    10f5:	eb ed                	jmp    10e4 <stat+0x34>
    10f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10fe:	00 
    10ff:	90                   	nop

00001100 <atoi>:

int
atoi(const char *s)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	53                   	push   %ebx
    1104:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1107:	0f be 02             	movsbl (%edx),%eax
    110a:	8d 48 d0             	lea    -0x30(%eax),%ecx
    110d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1110:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1115:	77 1e                	ja     1135 <atoi+0x35>
    1117:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    111e:	00 
    111f:	90                   	nop
    n = n*10 + *s++ - '0';
    1120:	83 c2 01             	add    $0x1,%edx
    1123:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1126:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    112a:	0f be 02             	movsbl (%edx),%eax
    112d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1130:	80 fb 09             	cmp    $0x9,%bl
    1133:	76 eb                	jbe    1120 <atoi+0x20>
  return n;
}
    1135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1138:	89 c8                	mov    %ecx,%eax
    113a:	c9                   	leave
    113b:	c3                   	ret
    113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001140 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1140:	55                   	push   %ebp
    1141:	89 e5                	mov    %esp,%ebp
    1143:	57                   	push   %edi
    1144:	8b 45 10             	mov    0x10(%ebp),%eax
    1147:	8b 55 08             	mov    0x8(%ebp),%edx
    114a:	56                   	push   %esi
    114b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    114e:	85 c0                	test   %eax,%eax
    1150:	7e 13                	jle    1165 <memmove+0x25>
    1152:	01 d0                	add    %edx,%eax
  dst = vdst;
    1154:	89 d7                	mov    %edx,%edi
    1156:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    115d:	00 
    115e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
    1160:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1161:	39 f8                	cmp    %edi,%eax
    1163:	75 fb                	jne    1160 <memmove+0x20>
  return vdst;
}
    1165:	5e                   	pop    %esi
    1166:	89 d0                	mov    %edx,%eax
    1168:	5f                   	pop    %edi
    1169:	5d                   	pop    %ebp
    116a:	c3                   	ret

0000116b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    116b:	b8 01 00 00 00       	mov    $0x1,%eax
    1170:	cd 40                	int    $0x40
    1172:	c3                   	ret

00001173 <exit>:
SYSCALL(exit)
    1173:	b8 02 00 00 00       	mov    $0x2,%eax
    1178:	cd 40                	int    $0x40
    117a:	c3                   	ret

0000117b <wait>:
SYSCALL(wait)
    117b:	b8 03 00 00 00       	mov    $0x3,%eax
    1180:	cd 40                	int    $0x40
    1182:	c3                   	ret

00001183 <pipe>:
SYSCALL(pipe)
    1183:	b8 04 00 00 00       	mov    $0x4,%eax
    1188:	cd 40                	int    $0x40
    118a:	c3                   	ret

0000118b <read>:
SYSCALL(read)
    118b:	b8 05 00 00 00       	mov    $0x5,%eax
    1190:	cd 40                	int    $0x40
    1192:	c3                   	ret

00001193 <write>:
SYSCALL(write)
    1193:	b8 10 00 00 00       	mov    $0x10,%eax
    1198:	cd 40                	int    $0x40
    119a:	c3                   	ret

0000119b <close>:
SYSCALL(close)
    119b:	b8 15 00 00 00       	mov    $0x15,%eax
    11a0:	cd 40                	int    $0x40
    11a2:	c3                   	ret

000011a3 <kill>:
SYSCALL(kill)
    11a3:	b8 06 00 00 00       	mov    $0x6,%eax
    11a8:	cd 40                	int    $0x40
    11aa:	c3                   	ret

000011ab <exec>:
SYSCALL(exec)
    11ab:	b8 07 00 00 00       	mov    $0x7,%eax
    11b0:	cd 40                	int    $0x40
    11b2:	c3                   	ret

000011b3 <open>:
SYSCALL(open)
    11b3:	b8 0f 00 00 00       	mov    $0xf,%eax
    11b8:	cd 40                	int    $0x40
    11ba:	c3                   	ret

000011bb <mknod>:
SYSCALL(mknod)
    11bb:	b8 11 00 00 00       	mov    $0x11,%eax
    11c0:	cd 40                	int    $0x40
    11c2:	c3                   	ret

000011c3 <unlink>:
SYSCALL(unlink)
    11c3:	b8 12 00 00 00       	mov    $0x12,%eax
    11c8:	cd 40                	int    $0x40
    11ca:	c3                   	ret

000011cb <fstat>:
SYSCALL(fstat)
    11cb:	b8 08 00 00 00       	mov    $0x8,%eax
    11d0:	cd 40                	int    $0x40
    11d2:	c3                   	ret

000011d3 <link>:
SYSCALL(link)
    11d3:	b8 13 00 00 00       	mov    $0x13,%eax
    11d8:	cd 40                	int    $0x40
    11da:	c3                   	ret

000011db <mkdir>:
SYSCALL(mkdir)
    11db:	b8 14 00 00 00       	mov    $0x14,%eax
    11e0:	cd 40                	int    $0x40
    11e2:	c3                   	ret

000011e3 <chdir>:
SYSCALL(chdir)
    11e3:	b8 09 00 00 00       	mov    $0x9,%eax
    11e8:	cd 40                	int    $0x40
    11ea:	c3                   	ret

000011eb <dup>:
SYSCALL(dup)
    11eb:	b8 0a 00 00 00       	mov    $0xa,%eax
    11f0:	cd 40                	int    $0x40
    11f2:	c3                   	ret

000011f3 <getpid>:
SYSCALL(getpid)
    11f3:	b8 0b 00 00 00       	mov    $0xb,%eax
    11f8:	cd 40                	int    $0x40
    11fa:	c3                   	ret

000011fb <sbrk>:
SYSCALL(sbrk)
    11fb:	b8 0c 00 00 00       	mov    $0xc,%eax
    1200:	cd 40                	int    $0x40
    1202:	c3                   	ret

00001203 <sleep>:
SYSCALL(sleep)
    1203:	b8 0d 00 00 00       	mov    $0xd,%eax
    1208:	cd 40                	int    $0x40
    120a:	c3                   	ret

0000120b <uptime>:
SYSCALL(uptime)
    120b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1210:	cd 40                	int    $0x40
    1212:	c3                   	ret

00001213 <gethistory>:
SYSCALL(gethistory)
    1213:	b8 16 00 00 00       	mov    $0x16,%eax
    1218:	cd 40                	int    $0x40
    121a:	c3                   	ret

0000121b <block>:
SYSCALL(block)
    121b:	b8 17 00 00 00       	mov    $0x17,%eax
    1220:	cd 40                	int    $0x40
    1222:	c3                   	ret

00001223 <unblock>:
SYSCALL(unblock)
    1223:	b8 18 00 00 00       	mov    $0x18,%eax
    1228:	cd 40                	int    $0x40
    122a:	c3                   	ret

0000122b <chmod>:
SYSCALL(chmod)
    122b:	b8 19 00 00 00       	mov    $0x19,%eax
    1230:	cd 40                	int    $0x40
    1232:	c3                   	ret
    1233:	66 90                	xchg   %ax,%ax
    1235:	66 90                	xchg   %ax,%ax
    1237:	66 90                	xchg   %ax,%ax
    1239:	66 90                	xchg   %ax,%ax
    123b:	66 90                	xchg   %ax,%ax
    123d:	66 90                	xchg   %ax,%ax
    123f:	90                   	nop

00001240 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	57                   	push   %edi
    1244:	56                   	push   %esi
    1245:	53                   	push   %ebx
    1246:	83 ec 3c             	sub    $0x3c,%esp
    1249:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    124c:	89 d1                	mov    %edx,%ecx
{
    124e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1251:	85 d2                	test   %edx,%edx
    1253:	0f 89 7f 00 00 00    	jns    12d8 <printint+0x98>
    1259:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    125d:	74 79                	je     12d8 <printint+0x98>
    neg = 1;
    125f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1266:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1268:	31 db                	xor    %ebx,%ebx
    126a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    126d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1270:	89 c8                	mov    %ecx,%eax
    1272:	31 d2                	xor    %edx,%edx
    1274:	89 cf                	mov    %ecx,%edi
    1276:	f7 75 c4             	divl   -0x3c(%ebp)
    1279:	0f b6 92 00 18 00 00 	movzbl 0x1800(%edx),%edx
    1280:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1283:	89 d8                	mov    %ebx,%eax
    1285:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1288:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    128b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    128e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1291:	76 dd                	jbe    1270 <printint+0x30>
  if(neg)
    1293:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1296:	85 c9                	test   %ecx,%ecx
    1298:	74 0c                	je     12a6 <printint+0x66>
    buf[i++] = '-';
    129a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    129f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    12a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    12a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    12a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    12ad:	eb 07                	jmp    12b6 <printint+0x76>
    12af:	90                   	nop
    putc(fd, buf[i]);
    12b0:	0f b6 13             	movzbl (%ebx),%edx
    12b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    12b6:	83 ec 04             	sub    $0x4,%esp
    12b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    12bc:	6a 01                	push   $0x1
    12be:	56                   	push   %esi
    12bf:	57                   	push   %edi
    12c0:	e8 ce fe ff ff       	call   1193 <write>
  while(--i >= 0)
    12c5:	83 c4 10             	add    $0x10,%esp
    12c8:	39 de                	cmp    %ebx,%esi
    12ca:	75 e4                	jne    12b0 <printint+0x70>
}
    12cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12cf:	5b                   	pop    %ebx
    12d0:	5e                   	pop    %esi
    12d1:	5f                   	pop    %edi
    12d2:	5d                   	pop    %ebp
    12d3:	c3                   	ret
    12d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    12d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    12df:	eb 87                	jmp    1268 <printint+0x28>
    12e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    12e8:	00 
    12e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000012f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    12f0:	55                   	push   %ebp
    12f1:	89 e5                	mov    %esp,%ebp
    12f3:	57                   	push   %edi
    12f4:	56                   	push   %esi
    12f5:	53                   	push   %ebx
    12f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    12f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    12fc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    12ff:	0f b6 13             	movzbl (%ebx),%edx
    1302:	84 d2                	test   %dl,%dl
    1304:	74 6a                	je     1370 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    1306:	8d 45 10             	lea    0x10(%ebp),%eax
    1309:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    130c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    130f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    1311:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1314:	eb 36                	jmp    134c <printf+0x5c>
    1316:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    131d:	00 
    131e:	66 90                	xchg   %ax,%ax
    1320:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1323:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    1328:	83 f8 25             	cmp    $0x25,%eax
    132b:	74 15                	je     1342 <printf+0x52>
  write(fd, &c, 1);
    132d:	83 ec 04             	sub    $0x4,%esp
    1330:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1333:	6a 01                	push   $0x1
    1335:	57                   	push   %edi
    1336:	56                   	push   %esi
    1337:	e8 57 fe ff ff       	call   1193 <write>
    133c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    133f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1342:	0f b6 13             	movzbl (%ebx),%edx
    1345:	83 c3 01             	add    $0x1,%ebx
    1348:	84 d2                	test   %dl,%dl
    134a:	74 24                	je     1370 <printf+0x80>
    c = fmt[i] & 0xff;
    134c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    134f:	85 c9                	test   %ecx,%ecx
    1351:	74 cd                	je     1320 <printf+0x30>
      }
    } else if(state == '%'){
    1353:	83 f9 25             	cmp    $0x25,%ecx
    1356:	75 ea                	jne    1342 <printf+0x52>
      if(c == 'd'){
    1358:	83 f8 25             	cmp    $0x25,%eax
    135b:	0f 84 07 01 00 00    	je     1468 <printf+0x178>
    1361:	83 e8 63             	sub    $0x63,%eax
    1364:	83 f8 15             	cmp    $0x15,%eax
    1367:	77 17                	ja     1380 <printf+0x90>
    1369:	ff 24 85 a8 17 00 00 	jmp    *0x17a8(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1370:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1373:	5b                   	pop    %ebx
    1374:	5e                   	pop    %esi
    1375:	5f                   	pop    %edi
    1376:	5d                   	pop    %ebp
    1377:	c3                   	ret
    1378:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    137f:	00 
  write(fd, &c, 1);
    1380:	83 ec 04             	sub    $0x4,%esp
    1383:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1386:	6a 01                	push   $0x1
    1388:	57                   	push   %edi
    1389:	56                   	push   %esi
    138a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    138e:	e8 00 fe ff ff       	call   1193 <write>
        putc(fd, c);
    1393:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1397:	83 c4 0c             	add    $0xc,%esp
    139a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    139d:	6a 01                	push   $0x1
    139f:	57                   	push   %edi
    13a0:	56                   	push   %esi
    13a1:	e8 ed fd ff ff       	call   1193 <write>
        putc(fd, c);
    13a6:	83 c4 10             	add    $0x10,%esp
      state = 0;
    13a9:	31 c9                	xor    %ecx,%ecx
    13ab:	eb 95                	jmp    1342 <printf+0x52>
    13ad:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    13b0:	83 ec 0c             	sub    $0xc,%esp
    13b3:	b9 10 00 00 00       	mov    $0x10,%ecx
    13b8:	6a 00                	push   $0x0
    13ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
    13bd:	8b 10                	mov    (%eax),%edx
    13bf:	89 f0                	mov    %esi,%eax
    13c1:	e8 7a fe ff ff       	call   1240 <printint>
        ap++;
    13c6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    13ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
    13cd:	31 c9                	xor    %ecx,%ecx
    13cf:	e9 6e ff ff ff       	jmp    1342 <printf+0x52>
    13d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    13d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
    13db:	8b 10                	mov    (%eax),%edx
        ap++;
    13dd:	83 c0 04             	add    $0x4,%eax
    13e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    13e3:	85 d2                	test   %edx,%edx
    13e5:	0f 84 8d 00 00 00    	je     1478 <printf+0x188>
        while(*s != 0){
    13eb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    13ee:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    13f0:	84 c0                	test   %al,%al
    13f2:	0f 84 4a ff ff ff    	je     1342 <printf+0x52>
    13f8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    13fb:	89 d3                	mov    %edx,%ebx
    13fd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1400:	83 ec 04             	sub    $0x4,%esp
          s++;
    1403:	83 c3 01             	add    $0x1,%ebx
    1406:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1409:	6a 01                	push   $0x1
    140b:	57                   	push   %edi
    140c:	56                   	push   %esi
    140d:	e8 81 fd ff ff       	call   1193 <write>
        while(*s != 0){
    1412:	0f b6 03             	movzbl (%ebx),%eax
    1415:	83 c4 10             	add    $0x10,%esp
    1418:	84 c0                	test   %al,%al
    141a:	75 e4                	jne    1400 <printf+0x110>
      state = 0;
    141c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    141f:	31 c9                	xor    %ecx,%ecx
    1421:	e9 1c ff ff ff       	jmp    1342 <printf+0x52>
    1426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    142d:	00 
    142e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    1430:	83 ec 0c             	sub    $0xc,%esp
    1433:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1438:	6a 01                	push   $0x1
    143a:	e9 7b ff ff ff       	jmp    13ba <printf+0xca>
    143f:	90                   	nop
        putc(fd, *ap);
    1440:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    1443:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1446:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    1448:	6a 01                	push   $0x1
    144a:	57                   	push   %edi
    144b:	56                   	push   %esi
        putc(fd, *ap);
    144c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    144f:	e8 3f fd ff ff       	call   1193 <write>
        ap++;
    1454:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1458:	83 c4 10             	add    $0x10,%esp
      state = 0;
    145b:	31 c9                	xor    %ecx,%ecx
    145d:	e9 e0 fe ff ff       	jmp    1342 <printf+0x52>
    1462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1468:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    146b:	83 ec 04             	sub    $0x4,%esp
    146e:	e9 2a ff ff ff       	jmp    139d <printf+0xad>
    1473:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          s = "(null)";
    1478:	ba f7 16 00 00       	mov    $0x16f7,%edx
        while(*s != 0){
    147d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1480:	b8 28 00 00 00       	mov    $0x28,%eax
    1485:	89 d3                	mov    %edx,%ebx
    1487:	e9 74 ff ff ff       	jmp    1400 <printf+0x110>
    148c:	66 90                	xchg   %ax,%ax
    148e:	66 90                	xchg   %ax,%ax

00001490 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1490:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1491:	a1 04 1f 00 00       	mov    0x1f04,%eax
{
    1496:	89 e5                	mov    %esp,%ebp
    1498:	57                   	push   %edi
    1499:	56                   	push   %esi
    149a:	53                   	push   %ebx
    149b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    149e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    14a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14a8:	89 c2                	mov    %eax,%edx
    14aa:	8b 00                	mov    (%eax),%eax
    14ac:	39 ca                	cmp    %ecx,%edx
    14ae:	73 30                	jae    14e0 <free+0x50>
    14b0:	39 c1                	cmp    %eax,%ecx
    14b2:	72 04                	jb     14b8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    14b4:	39 c2                	cmp    %eax,%edx
    14b6:	72 f0                	jb     14a8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    14b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    14bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    14be:	39 f8                	cmp    %edi,%eax
    14c0:	74 30                	je     14f2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    14c2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    14c5:	8b 42 04             	mov    0x4(%edx),%eax
    14c8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    14cb:	39 f1                	cmp    %esi,%ecx
    14cd:	74 3a                	je     1509 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    14cf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    14d1:	5b                   	pop    %ebx
  freep = p;
    14d2:	89 15 04 1f 00 00    	mov    %edx,0x1f04
}
    14d8:	5e                   	pop    %esi
    14d9:	5f                   	pop    %edi
    14da:	5d                   	pop    %ebp
    14db:	c3                   	ret
    14dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    14e0:	39 c2                	cmp    %eax,%edx
    14e2:	72 c4                	jb     14a8 <free+0x18>
    14e4:	39 c1                	cmp    %eax,%ecx
    14e6:	73 c0                	jae    14a8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    14e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    14eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    14ee:	39 f8                	cmp    %edi,%eax
    14f0:	75 d0                	jne    14c2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    14f2:	03 70 04             	add    0x4(%eax),%esi
    14f5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    14f8:	8b 02                	mov    (%edx),%eax
    14fa:	8b 00                	mov    (%eax),%eax
    14fc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    14ff:	8b 42 04             	mov    0x4(%edx),%eax
    1502:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    1505:	39 f1                	cmp    %esi,%ecx
    1507:	75 c6                	jne    14cf <free+0x3f>
    p->s.size += bp->s.size;
    1509:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    150c:	89 15 04 1f 00 00    	mov    %edx,0x1f04
    p->s.size += bp->s.size;
    1512:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    1515:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    1518:	89 0a                	mov    %ecx,(%edx)
}
    151a:	5b                   	pop    %ebx
    151b:	5e                   	pop    %esi
    151c:	5f                   	pop    %edi
    151d:	5d                   	pop    %ebp
    151e:	c3                   	ret
    151f:	90                   	nop

00001520 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1520:	55                   	push   %ebp
    1521:	89 e5                	mov    %esp,%ebp
    1523:	57                   	push   %edi
    1524:	56                   	push   %esi
    1525:	53                   	push   %ebx
    1526:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1529:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    152c:	8b 3d 04 1f 00 00    	mov    0x1f04,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1532:	8d 70 07             	lea    0x7(%eax),%esi
    1535:	c1 ee 03             	shr    $0x3,%esi
    1538:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    153b:	85 ff                	test   %edi,%edi
    153d:	0f 84 9d 00 00 00    	je     15e0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1543:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    1545:	8b 4a 04             	mov    0x4(%edx),%ecx
    1548:	39 f1                	cmp    %esi,%ecx
    154a:	73 6a                	jae    15b6 <malloc+0x96>
    154c:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1551:	39 de                	cmp    %ebx,%esi
    1553:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1556:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    155d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1560:	eb 17                	jmp    1579 <malloc+0x59>
    1562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1568:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    156a:	8b 48 04             	mov    0x4(%eax),%ecx
    156d:	39 f1                	cmp    %esi,%ecx
    156f:	73 4f                	jae    15c0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1571:	8b 3d 04 1f 00 00    	mov    0x1f04,%edi
    1577:	89 c2                	mov    %eax,%edx
    1579:	39 d7                	cmp    %edx,%edi
    157b:	75 eb                	jne    1568 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    157d:	83 ec 0c             	sub    $0xc,%esp
    1580:	ff 75 e4             	push   -0x1c(%ebp)
    1583:	e8 73 fc ff ff       	call   11fb <sbrk>
  if(p == (char*)-1)
    1588:	83 c4 10             	add    $0x10,%esp
    158b:	83 f8 ff             	cmp    $0xffffffff,%eax
    158e:	74 1c                	je     15ac <malloc+0x8c>
  hp->s.size = nu;
    1590:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1593:	83 ec 0c             	sub    $0xc,%esp
    1596:	83 c0 08             	add    $0x8,%eax
    1599:	50                   	push   %eax
    159a:	e8 f1 fe ff ff       	call   1490 <free>
  return freep;
    159f:	8b 15 04 1f 00 00    	mov    0x1f04,%edx
      if((p = morecore(nunits)) == 0)
    15a5:	83 c4 10             	add    $0x10,%esp
    15a8:	85 d2                	test   %edx,%edx
    15aa:	75 bc                	jne    1568 <malloc+0x48>
        return 0;
  }
}
    15ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    15af:	31 c0                	xor    %eax,%eax
}
    15b1:	5b                   	pop    %ebx
    15b2:	5e                   	pop    %esi
    15b3:	5f                   	pop    %edi
    15b4:	5d                   	pop    %ebp
    15b5:	c3                   	ret
    if(p->s.size >= nunits){
    15b6:	89 d0                	mov    %edx,%eax
    15b8:	89 fa                	mov    %edi,%edx
    15ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    15c0:	39 ce                	cmp    %ecx,%esi
    15c2:	74 4c                	je     1610 <malloc+0xf0>
        p->s.size -= nunits;
    15c4:	29 f1                	sub    %esi,%ecx
    15c6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    15c9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    15cc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    15cf:	89 15 04 1f 00 00    	mov    %edx,0x1f04
}
    15d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    15d8:	83 c0 08             	add    $0x8,%eax
}
    15db:	5b                   	pop    %ebx
    15dc:	5e                   	pop    %esi
    15dd:	5f                   	pop    %edi
    15de:	5d                   	pop    %ebp
    15df:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
    15e0:	c7 05 04 1f 00 00 08 	movl   $0x1f08,0x1f04
    15e7:	1f 00 00 
    base.s.size = 0;
    15ea:	bf 08 1f 00 00       	mov    $0x1f08,%edi
    base.s.ptr = freep = prevp = &base;
    15ef:	c7 05 08 1f 00 00 08 	movl   $0x1f08,0x1f08
    15f6:	1f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15f9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    15fb:	c7 05 0c 1f 00 00 00 	movl   $0x0,0x1f0c
    1602:	00 00 00 
    if(p->s.size >= nunits){
    1605:	e9 42 ff ff ff       	jmp    154c <malloc+0x2c>
    160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1610:	8b 08                	mov    (%eax),%ecx
    1612:	89 0a                	mov    %ecx,(%edx)
    1614:	eb b9                	jmp    15cf <malloc+0xaf>
