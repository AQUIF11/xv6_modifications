
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
      26:	68 48 17 00 00       	push   $0x1748
      2b:	e8 e3 11 00 00       	call   1213 <open>
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
      4c:	80 3d 21 1f 00 00 6e 	cmpb   $0x6e,0x1f21
      53:	0f 84 47 01 00 00    	je     1a0 <main+0x1a0>
        unblock_command(buf + 8);
        continue;
    }
    buf[strlen(buf) - 1] = 0;  // Remove newline character
      59:	83 ec 0c             	sub    $0xc,%esp
      5c:	68 20 1f 00 00       	push   $0x1f20
      61:	e8 aa 0f 00 00       	call   1010 <strlen>
    // if (strcmp(buf, "unblock ") == 0) {
    //     unblock_command(buf + 8);
    //     continue;
    // }

    if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd' && buf[5] == ' ') {
      66:	83 c4 10             	add    $0x10,%esp
    buf[strlen(buf) - 1] = 0;  // Remove newline character
      69:	c6 80 1f 1f 00 00 00 	movb   $0x0,0x1f1f(%eax)
    if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd' && buf[5] == ' ') {
      70:	80 3d 20 1f 00 00 63 	cmpb   $0x63,0x1f20
      77:	75 0d                	jne    86 <main+0x86>
      79:	80 3d 21 1f 00 00 68 	cmpb   $0x68,0x1f21
      80:	0f 84 82 01 00 00    	je     208 <main+0x208>
int
fork1(void)
{
  int pid;

  pid = fork();
      86:	e8 40 11 00 00       	call   11cb <fork>
  if(pid == -1)
      8b:	83 f8 ff             	cmp    $0xffffffff,%eax
      8e:	0f 84 51 02 00 00    	je     2e5 <main+0x2e5>
    if (fork1() == 0)
      94:	85 c0                	test   %eax,%eax
      96:	0f 84 e7 01 00 00    	je     283 <main+0x283>
    wait();
      9c:	e8 3a 11 00 00       	call   11db <wait>
  printf(2, "$ ");
      a1:	83 ec 08             	sub    $0x8,%esp
      a4:	68 af 16 00 00       	push   $0x16af
      a9:	6a 02                	push   $0x2
      ab:	e8 a0 12 00 00       	call   1350 <printf>
  memset(buf, 0, nbuf);
      b0:	83 c4 0c             	add    $0xc,%esp
      b3:	6a 64                	push   $0x64
      b5:	6a 00                	push   $0x0
      b7:	68 20 1f 00 00       	push   $0x1f20
      bc:	e8 7f 0f 00 00       	call   1040 <memset>
  gets(buf, nbuf);
      c1:	58                   	pop    %eax
      c2:	5a                   	pop    %edx
      c3:	6a 64                	push   $0x64
      c5:	68 20 1f 00 00       	push   $0x1f20
      ca:	e8 d1 0f 00 00       	call   10a0 <gets>
  if(buf[0] == 0) // EOF
      cf:	0f b6 05 20 1f 00 00 	movzbl 0x1f20,%eax
      d6:	83 c4 10             	add    $0x10,%esp
      d9:	84 c0                	test   %al,%al
      db:	0f 84 b7 01 00 00    	je     298 <main+0x298>
    if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y') {
      e1:	3c 68                	cmp    $0x68,%al
      e3:	0f 85 57 ff ff ff    	jne    40 <main+0x40>
      e9:	80 3d 21 1f 00 00 69 	cmpb   $0x69,0x1f21
      f0:	0f 85 63 ff ff ff    	jne    59 <main+0x59>
      f6:	80 3d 22 1f 00 00 73 	cmpb   $0x73,0x1f22
      fd:	0f 85 56 ff ff ff    	jne    59 <main+0x59>
     103:	80 3d 23 1f 00 00 74 	cmpb   $0x74,0x1f23
     10a:	0f 85 49 ff ff ff    	jne    59 <main+0x59>
     110:	80 3d 24 1f 00 00 6f 	cmpb   $0x6f,0x1f24
     117:	0f 85 3c ff ff ff    	jne    59 <main+0x59>
     11d:	80 3d 25 1f 00 00 72 	cmpb   $0x72,0x1f25
     124:	0f 85 2f ff ff ff    	jne    59 <main+0x59>
     12a:	80 3d 26 1f 00 00 79 	cmpb   $0x79,0x1f26
     131:	0f 85 22 ff ff ff    	jne    59 <main+0x59>
        history_command();
     137:	e8 c4 01 00 00       	call   300 <history_command>
        continue;
     13c:	e9 60 ff ff ff       	jmp    a1 <main+0xa1>
     141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k' && buf[5] == ' ') {
     148:	80 3d 21 1f 00 00 6c 	cmpb   $0x6c,0x1f21
     14f:	0f 85 04 ff ff ff    	jne    59 <main+0x59>
     155:	80 3d 22 1f 00 00 6f 	cmpb   $0x6f,0x1f22
     15c:	0f 85 f7 fe ff ff    	jne    59 <main+0x59>
     162:	80 3d 23 1f 00 00 63 	cmpb   $0x63,0x1f23
     169:	0f 85 ea fe ff ff    	jne    59 <main+0x59>
     16f:	80 3d 24 1f 00 00 6b 	cmpb   $0x6b,0x1f24
     176:	0f 85 dd fe ff ff    	jne    59 <main+0x59>
     17c:	80 3d 25 1f 00 00 20 	cmpb   $0x20,0x1f25
     183:	0f 85 d0 fe ff ff    	jne    59 <main+0x59>
        block_command(buf + 6);
     189:	83 ec 0c             	sub    $0xc,%esp
     18c:	68 26 1f 00 00       	push   $0x1f26
     191:	e8 2a 02 00 00       	call   3c0 <block_command>
        continue;
     196:	83 c4 10             	add    $0x10,%esp
     199:	e9 03 ff ff ff       	jmp    a1 <main+0xa1>
     19e:	66 90                	xchg   %ax,%ax
    if (buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k' && buf[7] == ' ') {
     1a0:	80 3d 22 1f 00 00 62 	cmpb   $0x62,0x1f22
     1a7:	0f 85 ac fe ff ff    	jne    59 <main+0x59>
     1ad:	80 3d 23 1f 00 00 6c 	cmpb   $0x6c,0x1f23
     1b4:	0f 85 9f fe ff ff    	jne    59 <main+0x59>
     1ba:	80 3d 24 1f 00 00 6f 	cmpb   $0x6f,0x1f24
     1c1:	0f 85 92 fe ff ff    	jne    59 <main+0x59>
     1c7:	80 3d 25 1f 00 00 63 	cmpb   $0x63,0x1f25
     1ce:	0f 85 85 fe ff ff    	jne    59 <main+0x59>
     1d4:	80 3d 26 1f 00 00 6b 	cmpb   $0x6b,0x1f26
     1db:	0f 85 78 fe ff ff    	jne    59 <main+0x59>
     1e1:	80 3d 27 1f 00 00 20 	cmpb   $0x20,0x1f27
     1e8:	0f 85 6b fe ff ff    	jne    59 <main+0x59>
        unblock_command(buf + 8);
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	68 28 1f 00 00       	push   $0x1f28
     1f6:	e8 15 02 00 00       	call   410 <unblock_command>
        continue;
     1fb:	83 c4 10             	add    $0x10,%esp
     1fe:	e9 9e fe ff ff       	jmp    a1 <main+0xa1>
     203:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd' && buf[5] == ' ') {
     208:	80 3d 22 1f 00 00 6d 	cmpb   $0x6d,0x1f22
     20f:	0f 85 71 fe ff ff    	jne    86 <main+0x86>
     215:	80 3d 23 1f 00 00 6f 	cmpb   $0x6f,0x1f23
     21c:	0f 85 64 fe ff ff    	jne    86 <main+0x86>
     222:	80 3d 24 1f 00 00 64 	cmpb   $0x64,0x1f24
     229:	0f 85 57 fe ff ff    	jne    86 <main+0x86>
     22f:	80 3d 25 1f 00 00 20 	cmpb   $0x20,0x1f25
     236:	0f 85 4a fe ff ff    	jne    86 <main+0x86>
        int i = 6; // Start after "chmod "
     23c:	b8 06 00 00 00       	mov    $0x6,%eax
     241:	eb 03                	jmp    246 <main+0x246>
        while (buf[i] == ' ') i++;
     243:	83 c0 01             	add    $0x1,%eax
     246:	0f b6 90 20 1f 00 00 	movzbl 0x1f20(%eax),%edx
     24d:	80 fa 20             	cmp    $0x20,%dl
     250:	74 f1                	je     243 <main+0x243>
        if (buf[i] != 0) file = &buf[i]; // File name starts here
     252:	8d 88 20 1f 00 00    	lea    0x1f20(%eax),%ecx
     258:	84 d2                	test   %dl,%dl
     25a:	75 44                	jne    2a0 <main+0x2a0>
            printf(2, "Usage: chmod <file> <mode>\n");
     25c:	51                   	push   %ecx
     25d:	51                   	push   %ecx
     25e:	68 50 17 00 00       	push   $0x1750
     263:	6a 02                	push   $0x2
     265:	e8 e6 10 00 00       	call   1350 <printf>
     26a:	83 c4 10             	add    $0x10,%esp
     26d:	e9 2f fe ff ff       	jmp    a1 <main+0xa1>
      close(fd);
     272:	83 ec 0c             	sub    $0xc,%esp
     275:	50                   	push   %eax
     276:	e8 80 0f 00 00       	call   11fb <close>
      break;
     27b:	83 c4 10             	add    $0x10,%esp
     27e:	e9 1e fe ff ff       	jmp    a1 <main+0xa1>
        runcmd(parsecmd(buf));
     283:	83 ec 0c             	sub    $0xc,%esp
     286:	68 20 1f 00 00       	push   $0x1f20
     28b:	e8 80 0c 00 00       	call   f10 <parsecmd>
     290:	89 04 24             	mov    %eax,(%esp)
     293:	e8 b8 02 00 00       	call   550 <runcmd>
  exit();
     298:	e8 36 0f 00 00       	call   11d3 <exit>
        while (buf[i] != 0 && buf[i] != ' ') i++;
     29d:	83 c0 01             	add    $0x1,%eax
     2a0:	0f b6 90 20 1f 00 00 	movzbl 0x1f20(%eax),%edx
     2a7:	f6 c2 df             	test   $0xdf,%dl
     2aa:	75 f1                	jne    29d <main+0x29d>
        if (buf[i] != 0) {
     2ac:	84 d2                	test   %dl,%dl
     2ae:	74 ac                	je     25c <main+0x25c>
            buf[i] = 0; // Null-terminate file name
     2b0:	c6 80 20 1f 00 00 00 	movb   $0x0,0x1f20(%eax)
            i++;
     2b7:	83 c0 01             	add    $0x1,%eax
     2ba:	eb 03                	jmp    2bf <main+0x2bf>
        while (buf[i] == ' ') i++;
     2bc:	83 c0 01             	add    $0x1,%eax
     2bf:	0f b6 90 20 1f 00 00 	movzbl 0x1f20(%eax),%edx
     2c6:	80 fa 20             	cmp    $0x20,%dl
     2c9:	74 f1                	je     2bc <main+0x2bc>
        if (buf[i] != 0) mode = &buf[i]; // Mode starts here
     2cb:	84 d2                	test   %dl,%dl
     2cd:	74 8d                	je     25c <main+0x25c>
     2cf:	05 20 1f 00 00       	add    $0x1f20,%eax
            chmod_command(file, mode);
     2d4:	52                   	push   %edx
     2d5:	52                   	push   %edx
     2d6:	50                   	push   %eax
     2d7:	51                   	push   %ecx
     2d8:	e8 83 01 00 00       	call   460 <chmod_command>
     2dd:	83 c4 10             	add    $0x10,%esp
     2e0:	e9 bc fd ff ff       	jmp    a1 <main+0xa1>
    panic("fork");
     2e5:	83 ec 0c             	sub    $0xc,%esp
     2e8:	68 b2 16 00 00       	push   $0x16b2
     2ed:	e8 1e 02 00 00       	call   510 <panic>
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
     315:	e8 59 0f 00 00       	call   1273 <gethistory>
  if (count < 0) {
     31a:	83 c4 10             	add    $0x10,%esp
     31d:	85 c0                	test   %eax,%eax
     31f:	0f 88 87 00 00 00    	js     3ac <history_command+0xac>
     325:	89 c7                	mov    %eax,%edi
  for (int i = 0; i < count; i++) {
     327:	8d 9d 8c f6 ff ff    	lea    -0x974(%ebp),%ebx
     32d:	be 00 00 00 00       	mov    $0x0,%esi
     332:	75 2f                	jne    363 <history_command+0x63>
     334:	eb 76                	jmp    3ac <history_command+0xac>
     336:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     33d:	00 
     33e:	66 90                	xchg   %ax,%ax
    printf(1, "%d\t%s\t%d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     340:	83 ec 0c             	sub    $0xc,%esp
     343:	ff 73 10             	push   0x10(%ebx)
     346:	53                   	push   %ebx
     347:	ff 73 fc             	push   -0x4(%ebx)
     34a:	68 8d 16 00 00       	push   $0x168d
     34f:	6a 01                	push   $0x1
     351:	e8 fa 0f 00 00       	call   1350 <printf>
     356:	83 c4 20             	add    $0x20,%esp
  for (int i = 0; i < count; i++) {
     359:	83 c6 01             	add    $0x1,%esi
     35c:	83 c3 18             	add    $0x18,%ebx
     35f:	39 f7                	cmp    %esi,%edi
     361:	74 49                	je     3ac <history_command+0xac>
    if(strcmp(hist[i].name, "sh") == 0) {
     363:	83 ec 08             	sub    $0x8,%esp
     366:	68 78 16 00 00       	push   $0x1678
     36b:	53                   	push   %ebx
     36c:	e8 3f 0c 00 00       	call   fb0 <strcmp>
     371:	83 c4 10             	add    $0x10,%esp
     374:	85 c0                	test   %eax,%eax
     376:	74 e1                	je     359 <history_command+0x59>
    if(strcmp(hist[i].name, "unknown") == 0) {
     378:	83 ec 08             	sub    $0x8,%esp
     37b:	68 7b 16 00 00       	push   $0x167b
     380:	53                   	push   %ebx
     381:	e8 2a 0c 00 00       	call   fb0 <strcmp>
     386:	83 c4 10             	add    $0x10,%esp
     389:	85 c0                	test   %eax,%eax
     38b:	75 b3                	jne    340 <history_command+0x40>
        printf(1, "%d\tsh\t%d\n", hist[i].pid, hist[i].mem_usage);
     38d:	ff 73 10             	push   0x10(%ebx)
  for (int i = 0; i < count; i++) {
     390:	83 c6 01             	add    $0x1,%esi
     393:	83 c3 18             	add    $0x18,%ebx
        printf(1, "%d\tsh\t%d\n", hist[i].pid, hist[i].mem_usage);
     396:	ff 73 e4             	push   -0x1c(%ebx)
     399:	68 83 16 00 00       	push   $0x1683
     39e:	6a 01                	push   $0x1
     3a0:	e8 ab 0f 00 00       	call   1350 <printf>
        continue; 
     3a5:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < count; i++) {
     3a8:	39 f7                	cmp    %esi,%edi
     3aa:	75 b7                	jne    363 <history_command+0x63>
}
     3ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
     3af:	5b                   	pop    %ebx
     3b0:	5e                   	pop    %esi
     3b1:	5f                   	pop    %edi
     3b2:	5d                   	pop    %ebp
     3b3:	c3                   	ret
     3b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3bb:	00 
     3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <block_command>:
void block_command(char *arg) {
     3c0:	55                   	push   %ebp
     3c1:	89 e5                	mov    %esp,%ebp
     3c3:	53                   	push   %ebx
     3c4:	83 ec 10             	sub    $0x10,%esp
  int syscall_id = atoi(arg);
     3c7:	ff 75 08             	push   0x8(%ebp)
     3ca:	e8 91 0d 00 00       	call   1160 <atoi>
  if (syscall_id <= 0) {
     3cf:	83 c4 10             	add    $0x10,%esp
     3d2:	85 c0                	test   %eax,%eax
     3d4:	7e 12                	jle    3e8 <block_command+0x28>
  if (block(syscall_id) < 0) {
     3d6:	83 ec 0c             	sub    $0xc,%esp
     3d9:	89 c3                	mov    %eax,%ebx
     3db:	50                   	push   %eax
     3dc:	e8 9a 0e 00 00       	call   127b <block>
     3e1:	83 c4 10             	add    $0x10,%esp
     3e4:	85 c0                	test   %eax,%eax
     3e6:	78 08                	js     3f0 <block_command+0x30>
}
     3e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3eb:	c9                   	leave
     3ec:	c3                   	ret
     3ed:	8d 76 00             	lea    0x0(%esi),%esi
      printf(2, "Error: Failed to block syscall %d\n", syscall_id);
     3f0:	83 ec 04             	sub    $0x4,%esp
     3f3:	53                   	push   %ebx
     3f4:	68 74 17 00 00       	push   $0x1774
     3f9:	6a 02                	push   $0x2
     3fb:	e8 50 0f 00 00       	call   1350 <printf>
}
     400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     403:	83 c4 10             	add    $0x10,%esp
     406:	c9                   	leave
     407:	c3                   	ret
     408:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     40f:	00 

00000410 <unblock_command>:
void unblock_command(char *arg) {
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	53                   	push   %ebx
     414:	83 ec 10             	sub    $0x10,%esp
  int syscall_id = atoi(arg);
     417:	ff 75 08             	push   0x8(%ebp)
     41a:	e8 41 0d 00 00       	call   1160 <atoi>
  if (syscall_id <= 0) {
     41f:	83 c4 10             	add    $0x10,%esp
     422:	85 c0                	test   %eax,%eax
     424:	7e 12                	jle    438 <unblock_command+0x28>
  if (unblock(syscall_id) < 0) {
     426:	83 ec 0c             	sub    $0xc,%esp
     429:	89 c3                	mov    %eax,%ebx
     42b:	50                   	push   %eax
     42c:	e8 52 0e 00 00       	call   1283 <unblock>
     431:	83 c4 10             	add    $0x10,%esp
     434:	85 c0                	test   %eax,%eax
     436:	78 08                	js     440 <unblock_command+0x30>
}
     438:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     43b:	c9                   	leave
     43c:	c3                   	ret
     43d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(2, "Error: Failed to unblock syscall %d\n", syscall_id);
     440:	83 ec 04             	sub    $0x4,%esp
     443:	53                   	push   %ebx
     444:	68 98 17 00 00       	push   $0x1798
     449:	6a 02                	push   $0x2
     44b:	e8 00 0f 00 00       	call   1350 <printf>
}
     450:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     453:	83 c4 10             	add    $0x10,%esp
     456:	c9                   	leave
     457:	c3                   	ret
     458:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     45f:	00 

00000460 <chmod_command>:
void chmod_command(char *file, char *mode_str) {
     460:	55                   	push   %ebp
     461:	89 e5                	mov    %esp,%ebp
     463:	53                   	push   %ebx
     464:	83 ec 10             	sub    $0x10,%esp
  int mode = atoi(mode_str);
     467:	ff 75 0c             	push   0xc(%ebp)
void chmod_command(char *file, char *mode_str) {
     46a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int mode = atoi(mode_str);
     46d:	e8 ee 0c 00 00       	call   1160 <atoi>
  if (mode < 0 || mode > 7) {
     472:	83 c4 10             	add    $0x10,%esp
     475:	83 f8 07             	cmp    $0x7,%eax
     478:	77 16                	ja     490 <chmod_command+0x30>
  if (chmod(file, mode) < 0) {
     47a:	83 ec 08             	sub    $0x8,%esp
     47d:	50                   	push   %eax
     47e:	53                   	push   %ebx
     47f:	e8 07 0e 00 00       	call   128b <chmod>
     484:	83 c4 10             	add    $0x10,%esp
     487:	85 c0                	test   %eax,%eax
     489:	78 25                	js     4b0 <chmod_command+0x50>
}
     48b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     48e:	c9                   	leave
     48f:	c3                   	ret
      printf(2, "Invalid mode. Use a 3-bit integer (0-7)\n");
     490:	c7 45 0c c0 17 00 00 	movl   $0x17c0,0xc(%ebp)
}
     497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      printf(2, "Invalid mode. Use a 3-bit integer (0-7)\n");
     49a:	c7 45 08 02 00 00 00 	movl   $0x2,0x8(%ebp)
}
     4a1:	c9                   	leave
      printf(2, "Invalid mode. Use a 3-bit integer (0-7)\n");
     4a2:	e9 a9 0e 00 00       	jmp    1350 <printf>
     4a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     4ae:	00 
     4af:	90                   	nop
      printf(2, "chmod operation failed\n");
     4b0:	c7 45 0c 97 16 00 00 	movl   $0x1697,0xc(%ebp)
}
     4b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      printf(2, "chmod operation failed\n");
     4ba:	c7 45 08 02 00 00 00 	movl   $0x2,0x8(%ebp)
}
     4c1:	c9                   	leave
      printf(2, "chmod operation failed\n");
     4c2:	e9 89 0e 00 00       	jmp    1350 <printf>
     4c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     4ce:	00 
     4cf:	90                   	nop

000004d0 <getcmd>:
{
     4d0:	55                   	push   %ebp
     4d1:	89 e5                	mov    %esp,%ebp
     4d3:	56                   	push   %esi
     4d4:	53                   	push   %ebx
     4d5:	8b 75 0c             	mov    0xc(%ebp),%esi
     4d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     4db:	83 ec 08             	sub    $0x8,%esp
     4de:	68 af 16 00 00       	push   $0x16af
     4e3:	6a 02                	push   $0x2
     4e5:	e8 66 0e 00 00       	call   1350 <printf>
  memset(buf, 0, nbuf);
     4ea:	83 c4 0c             	add    $0xc,%esp
     4ed:	56                   	push   %esi
     4ee:	6a 00                	push   $0x0
     4f0:	53                   	push   %ebx
     4f1:	e8 4a 0b 00 00       	call   1040 <memset>
  gets(buf, nbuf);
     4f6:	58                   	pop    %eax
     4f7:	5a                   	pop    %edx
     4f8:	56                   	push   %esi
     4f9:	53                   	push   %ebx
     4fa:	e8 a1 0b 00 00       	call   10a0 <gets>
  if(buf[0] == 0) // EOF
     4ff:	83 c4 10             	add    $0x10,%esp
     502:	80 3b 01             	cmpb   $0x1,(%ebx)
     505:	19 c0                	sbb    %eax,%eax
}
     507:	8d 65 f8             	lea    -0x8(%ebp),%esp
     50a:	5b                   	pop    %ebx
     50b:	5e                   	pop    %esi
     50c:	5d                   	pop    %ebp
     50d:	c3                   	ret
     50e:	66 90                	xchg   %ax,%ax

00000510 <panic>:
{
     510:	55                   	push   %ebp
     511:	89 e5                	mov    %esp,%ebp
     513:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     516:	ff 75 08             	push   0x8(%ebp)
     519:	68 44 17 00 00       	push   $0x1744
     51e:	6a 02                	push   $0x2
     520:	e8 2b 0e 00 00       	call   1350 <printf>
  exit();
     525:	e8 a9 0c 00 00       	call   11d3 <exit>
     52a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000530 <fork1>:
{
     530:	55                   	push   %ebp
     531:	89 e5                	mov    %esp,%ebp
     533:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     536:	e8 90 0c 00 00       	call   11cb <fork>
  if(pid == -1)
     53b:	83 f8 ff             	cmp    $0xffffffff,%eax
     53e:	74 02                	je     542 <fork1+0x12>
  return pid;
}
     540:	c9                   	leave
     541:	c3                   	ret
    panic("fork");
     542:	83 ec 0c             	sub    $0xc,%esp
     545:	68 b2 16 00 00       	push   $0x16b2
     54a:	e8 c1 ff ff ff       	call   510 <panic>
     54f:	90                   	nop

00000550 <runcmd>:
{
     550:	55                   	push   %ebp
     551:	89 e5                	mov    %esp,%ebp
     553:	53                   	push   %ebx
     554:	83 ec 14             	sub    $0x14,%esp
     557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     55a:	85 db                	test   %ebx,%ebx
     55c:	74 1f                	je     57d <runcmd+0x2d>
  switch(cmd->type){
     55e:	83 3b 05             	cmpl   $0x5,(%ebx)
     561:	0f 87 ef 00 00 00    	ja     656 <runcmd+0x106>
     567:	8b 03                	mov    (%ebx),%eax
     569:	ff 24 85 ec 17 00 00 	jmp    *0x17ec(,%eax,4)
    if(fork1() == 0)
     570:	e8 bb ff ff ff       	call   530 <fork1>
     575:	85 c0                	test   %eax,%eax
     577:	0f 84 ce 00 00 00    	je     64b <runcmd+0xfb>
    exit();
     57d:	e8 51 0c 00 00       	call   11d3 <exit>
    if (ecmd->argv[0] == 0)
     582:	8b 43 04             	mov    0x4(%ebx),%eax
     585:	85 c0                	test   %eax,%eax
     587:	74 f4                	je     57d <runcmd+0x2d>
    if (strcmp(ecmd->argv[0], "unblock") == 0) {
     589:	52                   	push   %edx
     58a:	52                   	push   %edx
     58b:	68 be 16 00 00       	push   $0x16be
     590:	50                   	push   %eax
     591:	e8 1a 0a 00 00       	call   fb0 <strcmp>
     596:	83 c4 10             	add    $0x10,%esp
     599:	85 c0                	test   %eax,%eax
     59b:	0f 84 12 01 00 00    	je     6b3 <runcmd+0x163>
    exec(ecmd->argv[0], ecmd->argv);
     5a1:	8d 43 04             	lea    0x4(%ebx),%eax
     5a4:	51                   	push   %ecx
     5a5:	51                   	push   %ecx
     5a6:	50                   	push   %eax
     5a7:	ff 73 04             	push   0x4(%ebx)
     5aa:	e8 5c 0c 00 00       	call   120b <exec>
    exit();
     5af:	e8 1f 0c 00 00       	call   11d3 <exit>
    if(pipe(p) < 0)
     5b4:	83 ec 0c             	sub    $0xc,%esp
     5b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
     5ba:	50                   	push   %eax
     5bb:	e8 23 0c 00 00       	call   11e3 <pipe>
     5c0:	83 c4 10             	add    $0x10,%esp
     5c3:	85 c0                	test   %eax,%eax
     5c5:	0f 88 ad 00 00 00    	js     678 <runcmd+0x128>
    if(fork1() == 0){
     5cb:	e8 60 ff ff ff       	call   530 <fork1>
     5d0:	85 c0                	test   %eax,%eax
     5d2:	0f 84 ad 00 00 00    	je     685 <runcmd+0x135>
    if(fork1() == 0){
     5d8:	e8 53 ff ff ff       	call   530 <fork1>
     5dd:	85 c0                	test   %eax,%eax
     5df:	0f 85 e0 00 00 00    	jne    6c5 <runcmd+0x175>
      close(0);
     5e5:	83 ec 0c             	sub    $0xc,%esp
     5e8:	6a 00                	push   $0x0
     5ea:	e8 0c 0c 00 00       	call   11fb <close>
      dup(p[0]);
     5ef:	5a                   	pop    %edx
     5f0:	ff 75 f0             	push   -0x10(%ebp)
     5f3:	e8 53 0c 00 00       	call   124b <dup>
      close(p[0]);
     5f8:	59                   	pop    %ecx
     5f9:	ff 75 f0             	push   -0x10(%ebp)
     5fc:	e8 fa 0b 00 00       	call   11fb <close>
      close(p[1]);
     601:	58                   	pop    %eax
     602:	ff 75 f4             	push   -0xc(%ebp)
     605:	e8 f1 0b 00 00       	call   11fb <close>
      runcmd(pcmd->right);
     60a:	58                   	pop    %eax
     60b:	ff 73 08             	push   0x8(%ebx)
     60e:	e8 3d ff ff ff       	call   550 <runcmd>
    if(fork1() == 0)
     613:	e8 18 ff ff ff       	call   530 <fork1>
     618:	85 c0                	test   %eax,%eax
     61a:	74 2f                	je     64b <runcmd+0xfb>
    wait();
     61c:	e8 ba 0b 00 00       	call   11db <wait>
    runcmd(lcmd->right);
     621:	83 ec 0c             	sub    $0xc,%esp
     624:	ff 73 08             	push   0x8(%ebx)
     627:	e8 24 ff ff ff       	call   550 <runcmd>
    close(rcmd->fd);
     62c:	83 ec 0c             	sub    $0xc,%esp
     62f:	ff 73 14             	push   0x14(%ebx)
     632:	e8 c4 0b 00 00       	call   11fb <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     637:	58                   	pop    %eax
     638:	5a                   	pop    %edx
     639:	ff 73 10             	push   0x10(%ebx)
     63c:	ff 73 08             	push   0x8(%ebx)
     63f:	e8 cf 0b 00 00       	call   1213 <open>
     644:	83 c4 10             	add    $0x10,%esp
     647:	85 c0                	test   %eax,%eax
     649:	78 18                	js     663 <runcmd+0x113>
      runcmd(bcmd->cmd);
     64b:	83 ec 0c             	sub    $0xc,%esp
     64e:	ff 73 04             	push   0x4(%ebx)
     651:	e8 fa fe ff ff       	call   550 <runcmd>
    panic("runcmd");
     656:	83 ec 0c             	sub    $0xc,%esp
     659:	68 b7 16 00 00       	push   $0x16b7
     65e:	e8 ad fe ff ff       	call   510 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     663:	51                   	push   %ecx
     664:	ff 73 08             	push   0x8(%ebx)
     667:	68 c6 16 00 00       	push   $0x16c6
     66c:	6a 02                	push   $0x2
     66e:	e8 dd 0c 00 00       	call   1350 <printf>
      exit();
     673:	e8 5b 0b 00 00       	call   11d3 <exit>
      panic("pipe");
     678:	83 ec 0c             	sub    $0xc,%esp
     67b:	68 d6 16 00 00       	push   $0x16d6
     680:	e8 8b fe ff ff       	call   510 <panic>
      close(1);
     685:	83 ec 0c             	sub    $0xc,%esp
     688:	6a 01                	push   $0x1
     68a:	e8 6c 0b 00 00       	call   11fb <close>
      dup(p[1]);
     68f:	58                   	pop    %eax
     690:	ff 75 f4             	push   -0xc(%ebp)
     693:	e8 b3 0b 00 00       	call   124b <dup>
      close(p[0]);
     698:	58                   	pop    %eax
     699:	ff 75 f0             	push   -0x10(%ebp)
     69c:	e8 5a 0b 00 00       	call   11fb <close>
      close(p[1]);
     6a1:	58                   	pop    %eax
     6a2:	ff 75 f4             	push   -0xc(%ebp)
     6a5:	e8 51 0b 00 00       	call   11fb <close>
      runcmd(pcmd->left);
     6aa:	5a                   	pop    %edx
     6ab:	ff 73 04             	push   0x4(%ebx)
     6ae:	e8 9d fe ff ff       	call   550 <runcmd>
        unblock(SYS_exec);
     6b3:	83 ec 0c             	sub    $0xc,%esp
     6b6:	6a 07                	push   $0x7
     6b8:	e8 c6 0b 00 00       	call   1283 <unblock>
     6bd:	83 c4 10             	add    $0x10,%esp
     6c0:	e9 dc fe ff ff       	jmp    5a1 <runcmd+0x51>
    close(p[0]);
     6c5:	83 ec 0c             	sub    $0xc,%esp
     6c8:	ff 75 f0             	push   -0x10(%ebp)
     6cb:	e8 2b 0b 00 00       	call   11fb <close>
    close(p[1]);
     6d0:	58                   	pop    %eax
     6d1:	ff 75 f4             	push   -0xc(%ebp)
     6d4:	e8 22 0b 00 00       	call   11fb <close>
    wait();
     6d9:	e8 fd 0a 00 00       	call   11db <wait>
    wait();
     6de:	e8 f8 0a 00 00       	call   11db <wait>
    break;
     6e3:	83 c4 10             	add    $0x10,%esp
     6e6:	e9 92 fe ff ff       	jmp    57d <runcmd+0x2d>
     6eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

000006f0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     6f0:	55                   	push   %ebp
     6f1:	89 e5                	mov    %esp,%ebp
     6f3:	53                   	push   %ebx
     6f4:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6f7:	6a 54                	push   $0x54
     6f9:	e8 82 0e 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6fe:	83 c4 0c             	add    $0xc,%esp
     701:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     703:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     705:	6a 00                	push   $0x0
     707:	50                   	push   %eax
     708:	e8 33 09 00 00       	call   1040 <memset>
  cmd->type = EXEC;
     70d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     713:	89 d8                	mov    %ebx,%eax
     715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     718:	c9                   	leave
     719:	c3                   	ret
     71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000720 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     720:	55                   	push   %ebp
     721:	89 e5                	mov    %esp,%ebp
     723:	53                   	push   %ebx
     724:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     727:	6a 18                	push   $0x18
     729:	e8 52 0e 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     72e:	83 c4 0c             	add    $0xc,%esp
     731:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     733:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     735:	6a 00                	push   $0x0
     737:	50                   	push   %eax
     738:	e8 03 09 00 00       	call   1040 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     73d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     740:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     746:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     749:	8b 45 0c             	mov    0xc(%ebp),%eax
     74c:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     74f:	8b 45 10             	mov    0x10(%ebp),%eax
     752:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     755:	8b 45 14             	mov    0x14(%ebp),%eax
     758:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     75b:	8b 45 18             	mov    0x18(%ebp),%eax
     75e:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     761:	89 d8                	mov    %ebx,%eax
     763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     766:	c9                   	leave
     767:	c3                   	ret
     768:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     76f:	00 

00000770 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     770:	55                   	push   %ebp
     771:	89 e5                	mov    %esp,%ebp
     773:	53                   	push   %ebx
     774:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     777:	6a 0c                	push   $0xc
     779:	e8 02 0e 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     77e:	83 c4 0c             	add    $0xc,%esp
     781:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     783:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     785:	6a 00                	push   $0x0
     787:	50                   	push   %eax
     788:	e8 b3 08 00 00       	call   1040 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     78d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     790:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     796:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     799:	8b 45 0c             	mov    0xc(%ebp),%eax
     79c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     79f:	89 d8                	mov    %ebx,%eax
     7a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7a4:	c9                   	leave
     7a5:	c3                   	ret
     7a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7ad:	00 
     7ae:	66 90                	xchg   %ax,%ax

000007b0 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     7b0:	55                   	push   %ebp
     7b1:	89 e5                	mov    %esp,%ebp
     7b3:	53                   	push   %ebx
     7b4:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7b7:	6a 0c                	push   $0xc
     7b9:	e8 c2 0d 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     7be:	83 c4 0c             	add    $0xc,%esp
     7c1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     7c3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     7c5:	6a 00                	push   $0x0
     7c7:	50                   	push   %eax
     7c8:	e8 73 08 00 00       	call   1040 <memset>
  cmd->type = LIST;
  cmd->left = left;
     7cd:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     7d0:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     7d6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     7d9:	8b 45 0c             	mov    0xc(%ebp),%eax
     7dc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     7df:	89 d8                	mov    %ebx,%eax
     7e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7e4:	c9                   	leave
     7e5:	c3                   	ret
     7e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7ed:	00 
     7ee:	66 90                	xchg   %ax,%ax

000007f0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     7f0:	55                   	push   %ebp
     7f1:	89 e5                	mov    %esp,%ebp
     7f3:	53                   	push   %ebx
     7f4:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7f7:	6a 08                	push   $0x8
     7f9:	e8 82 0d 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     7fe:	83 c4 0c             	add    $0xc,%esp
     801:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     803:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     805:	6a 00                	push   $0x0
     807:	50                   	push   %eax
     808:	e8 33 08 00 00       	call   1040 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     80d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     810:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     816:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     819:	89 d8                	mov    %ebx,%eax
     81b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     81e:	c9                   	leave
     81f:	c3                   	ret

00000820 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     820:	55                   	push   %ebp
     821:	89 e5                	mov    %esp,%ebp
     823:	57                   	push   %edi
     824:	56                   	push   %esi
     825:	53                   	push   %ebx
     826:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     829:	8b 45 08             	mov    0x8(%ebp),%eax
{
     82c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     82f:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     832:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     834:	39 df                	cmp    %ebx,%edi
     836:	72 0f                	jb     847 <gettoken+0x27>
     838:	eb 25                	jmp    85f <gettoken+0x3f>
     83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     840:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     843:	39 fb                	cmp    %edi,%ebx
     845:	74 18                	je     85f <gettoken+0x3f>
     847:	0f be 07             	movsbl (%edi),%eax
     84a:	83 ec 08             	sub    $0x8,%esp
     84d:	50                   	push   %eax
     84e:	68 08 1f 00 00       	push   $0x1f08
     853:	e8 08 08 00 00       	call   1060 <strchr>
     858:	83 c4 10             	add    $0x10,%esp
     85b:	85 c0                	test   %eax,%eax
     85d:	75 e1                	jne    840 <gettoken+0x20>
  if(q)
     85f:	85 f6                	test   %esi,%esi
     861:	74 02                	je     865 <gettoken+0x45>
    *q = s;
     863:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     865:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     868:	3c 3c                	cmp    $0x3c,%al
     86a:	0f 8f d0 00 00 00    	jg     940 <gettoken+0x120>
     870:	3c 3a                	cmp    $0x3a,%al
     872:	0f 8f b4 00 00 00    	jg     92c <gettoken+0x10c>
     878:	84 c0                	test   %al,%al
     87a:	75 44                	jne    8c0 <gettoken+0xa0>
     87c:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     87e:	8b 55 14             	mov    0x14(%ebp),%edx
     881:	85 d2                	test   %edx,%edx
     883:	74 05                	je     88a <gettoken+0x6a>
    *eq = s;
     885:	8b 45 14             	mov    0x14(%ebp),%eax
     888:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     88a:	39 df                	cmp    %ebx,%edi
     88c:	72 09                	jb     897 <gettoken+0x77>
     88e:	eb 1f                	jmp    8af <gettoken+0x8f>
    s++;
     890:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     893:	39 fb                	cmp    %edi,%ebx
     895:	74 18                	je     8af <gettoken+0x8f>
     897:	0f be 07             	movsbl (%edi),%eax
     89a:	83 ec 08             	sub    $0x8,%esp
     89d:	50                   	push   %eax
     89e:	68 08 1f 00 00       	push   $0x1f08
     8a3:	e8 b8 07 00 00       	call   1060 <strchr>
     8a8:	83 c4 10             	add    $0x10,%esp
     8ab:	85 c0                	test   %eax,%eax
     8ad:	75 e1                	jne    890 <gettoken+0x70>
  *ps = s;
     8af:	8b 45 08             	mov    0x8(%ebp),%eax
     8b2:	89 38                	mov    %edi,(%eax)
  return ret;
}
     8b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8b7:	89 f0                	mov    %esi,%eax
     8b9:	5b                   	pop    %ebx
     8ba:	5e                   	pop    %esi
     8bb:	5f                   	pop    %edi
     8bc:	5d                   	pop    %ebp
     8bd:	c3                   	ret
     8be:	66 90                	xchg   %ax,%ax
  switch(*s){
     8c0:	79 5e                	jns    920 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8c2:	39 fb                	cmp    %edi,%ebx
     8c4:	77 34                	ja     8fa <gettoken+0xda>
  if(eq)
     8c6:	8b 45 14             	mov    0x14(%ebp),%eax
     8c9:	be 61 00 00 00       	mov    $0x61,%esi
     8ce:	85 c0                	test   %eax,%eax
     8d0:	75 b3                	jne    885 <gettoken+0x65>
     8d2:	eb db                	jmp    8af <gettoken+0x8f>
     8d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8d8:	0f be 07             	movsbl (%edi),%eax
     8db:	83 ec 08             	sub    $0x8,%esp
     8de:	50                   	push   %eax
     8df:	68 00 1f 00 00       	push   $0x1f00
     8e4:	e8 77 07 00 00       	call   1060 <strchr>
     8e9:	83 c4 10             	add    $0x10,%esp
     8ec:	85 c0                	test   %eax,%eax
     8ee:	75 22                	jne    912 <gettoken+0xf2>
      s++;
     8f0:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8f3:	39 fb                	cmp    %edi,%ebx
     8f5:	74 cf                	je     8c6 <gettoken+0xa6>
     8f7:	0f b6 07             	movzbl (%edi),%eax
     8fa:	83 ec 08             	sub    $0x8,%esp
     8fd:	0f be f0             	movsbl %al,%esi
     900:	56                   	push   %esi
     901:	68 08 1f 00 00       	push   $0x1f08
     906:	e8 55 07 00 00       	call   1060 <strchr>
     90b:	83 c4 10             	add    $0x10,%esp
     90e:	85 c0                	test   %eax,%eax
     910:	74 c6                	je     8d8 <gettoken+0xb8>
    ret = 'a';
     912:	be 61 00 00 00       	mov    $0x61,%esi
     917:	e9 62 ff ff ff       	jmp    87e <gettoken+0x5e>
     91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     920:	3c 26                	cmp    $0x26,%al
     922:	74 08                	je     92c <gettoken+0x10c>
     924:	8d 48 d8             	lea    -0x28(%eax),%ecx
     927:	80 f9 01             	cmp    $0x1,%cl
     92a:	77 96                	ja     8c2 <gettoken+0xa2>
  ret = *s;
     92c:	0f be f0             	movsbl %al,%esi
    s++;
     92f:	83 c7 01             	add    $0x1,%edi
    break;
     932:	e9 47 ff ff ff       	jmp    87e <gettoken+0x5e>
     937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     93e:	00 
     93f:	90                   	nop
  switch(*s){
     940:	3c 3e                	cmp    $0x3e,%al
     942:	75 1c                	jne    960 <gettoken+0x140>
    if(*s == '>'){
     944:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     948:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     94b:	74 1c                	je     969 <gettoken+0x149>
    s++;
     94d:	89 c7                	mov    %eax,%edi
     94f:	be 3e 00 00 00       	mov    $0x3e,%esi
     954:	e9 25 ff ff ff       	jmp    87e <gettoken+0x5e>
     959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     960:	3c 7c                	cmp    $0x7c,%al
     962:	74 c8                	je     92c <gettoken+0x10c>
     964:	e9 59 ff ff ff       	jmp    8c2 <gettoken+0xa2>
      s++;
     969:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     96c:	be 2b 00 00 00       	mov    $0x2b,%esi
     971:	e9 08 ff ff ff       	jmp    87e <gettoken+0x5e>
     976:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     97d:	00 
     97e:	66 90                	xchg   %ax,%ax

00000980 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     980:	55                   	push   %ebp
     981:	89 e5                	mov    %esp,%ebp
     983:	57                   	push   %edi
     984:	56                   	push   %esi
     985:	53                   	push   %ebx
     986:	83 ec 0c             	sub    $0xc,%esp
     989:	8b 7d 08             	mov    0x8(%ebp),%edi
     98c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     98f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     991:	39 f3                	cmp    %esi,%ebx
     993:	72 12                	jb     9a7 <peek+0x27>
     995:	eb 28                	jmp    9bf <peek+0x3f>
     997:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     99e:	00 
     99f:	90                   	nop
    s++;
     9a0:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     9a3:	39 de                	cmp    %ebx,%esi
     9a5:	74 18                	je     9bf <peek+0x3f>
     9a7:	0f be 03             	movsbl (%ebx),%eax
     9aa:	83 ec 08             	sub    $0x8,%esp
     9ad:	50                   	push   %eax
     9ae:	68 08 1f 00 00       	push   $0x1f08
     9b3:	e8 a8 06 00 00       	call   1060 <strchr>
     9b8:	83 c4 10             	add    $0x10,%esp
     9bb:	85 c0                	test   %eax,%eax
     9bd:	75 e1                	jne    9a0 <peek+0x20>
  *ps = s;
     9bf:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     9c1:	0f be 03             	movsbl (%ebx),%eax
     9c4:	31 d2                	xor    %edx,%edx
     9c6:	84 c0                	test   %al,%al
     9c8:	75 0e                	jne    9d8 <peek+0x58>
}
     9ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9cd:	89 d0                	mov    %edx,%eax
     9cf:	5b                   	pop    %ebx
     9d0:	5e                   	pop    %esi
     9d1:	5f                   	pop    %edi
     9d2:	5d                   	pop    %ebp
     9d3:	c3                   	ret
     9d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     9d8:	83 ec 08             	sub    $0x8,%esp
     9db:	50                   	push   %eax
     9dc:	ff 75 10             	push   0x10(%ebp)
     9df:	e8 7c 06 00 00       	call   1060 <strchr>
     9e4:	83 c4 10             	add    $0x10,%esp
     9e7:	31 d2                	xor    %edx,%edx
     9e9:	85 c0                	test   %eax,%eax
     9eb:	0f 95 c2             	setne  %dl
}
     9ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9f1:	5b                   	pop    %ebx
     9f2:	89 d0                	mov    %edx,%eax
     9f4:	5e                   	pop    %esi
     9f5:	5f                   	pop    %edi
     9f6:	5d                   	pop    %ebp
     9f7:	c3                   	ret
     9f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     9ff:	00 

00000a00 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     a00:	55                   	push   %ebp
     a01:	89 e5                	mov    %esp,%ebp
     a03:	57                   	push   %edi
     a04:	56                   	push   %esi
     a05:	53                   	push   %ebx
     a06:	83 ec 2c             	sub    $0x2c,%esp
     a09:	8b 75 0c             	mov    0xc(%ebp),%esi
     a0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     a0f:	90                   	nop
     a10:	83 ec 04             	sub    $0x4,%esp
     a13:	68 f8 16 00 00       	push   $0x16f8
     a18:	53                   	push   %ebx
     a19:	56                   	push   %esi
     a1a:	e8 61 ff ff ff       	call   980 <peek>
     a1f:	83 c4 10             	add    $0x10,%esp
     a22:	85 c0                	test   %eax,%eax
     a24:	0f 84 f6 00 00 00    	je     b20 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     a2a:	6a 00                	push   $0x0
     a2c:	6a 00                	push   $0x0
     a2e:	53                   	push   %ebx
     a2f:	56                   	push   %esi
     a30:	e8 eb fd ff ff       	call   820 <gettoken>
     a35:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     a37:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     a3a:	50                   	push   %eax
     a3b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a3e:	50                   	push   %eax
     a3f:	53                   	push   %ebx
     a40:	56                   	push   %esi
     a41:	e8 da fd ff ff       	call   820 <gettoken>
     a46:	83 c4 20             	add    $0x20,%esp
     a49:	83 f8 61             	cmp    $0x61,%eax
     a4c:	0f 85 d9 00 00 00    	jne    b2b <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     a52:	83 ff 3c             	cmp    $0x3c,%edi
     a55:	74 69                	je     ac0 <parseredirs+0xc0>
     a57:	83 ff 3e             	cmp    $0x3e,%edi
     a5a:	74 05                	je     a61 <parseredirs+0x61>
     a5c:	83 ff 2b             	cmp    $0x2b,%edi
     a5f:	75 af                	jne    a10 <parseredirs+0x10>
  cmd = malloc(sizeof(*cmd));
     a61:	83 ec 0c             	sub    $0xc,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     a67:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     a6a:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a6c:	89 55 d0             	mov    %edx,-0x30(%ebp)
     a6f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     a72:	e8 09 0b 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     a77:	83 c4 0c             	add    $0xc,%esp
     a7a:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     a7c:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     a7e:	6a 00                	push   $0x0
     a80:	50                   	push   %eax
     a81:	e8 ba 05 00 00       	call   1040 <memset>
  cmd->type = REDIR;
     a86:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     a8c:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     a8f:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     a92:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     a95:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     a98:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     a9b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     a9e:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     aa5:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     aa8:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      break;
     aaf:	89 7d 08             	mov    %edi,0x8(%ebp)
     ab2:	e9 59 ff ff ff       	jmp    a10 <parseredirs+0x10>
     ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     abe:	00 
     abf:	90                   	nop
  cmd = malloc(sizeof(*cmd));
     ac0:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     ac3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     ac6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     ac9:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     acb:	89 55 d0             	mov    %edx,-0x30(%ebp)
     ace:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     ad1:	e8 aa 0a 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     ad6:	83 c4 0c             	add    $0xc,%esp
     ad9:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     adb:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     add:	6a 00                	push   $0x0
     adf:	50                   	push   %eax
     ae0:	e8 5b 05 00 00       	call   1040 <memset>
  cmd->cmd = subcmd;
     ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     ae8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     aeb:	89 7d 08             	mov    %edi,0x8(%ebp)
  cmd->efile = efile;
     aee:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     af1:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
      break;
     af7:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     afa:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     afd:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     b00:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     b03:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     b0a:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      break;
     b11:	e9 fa fe ff ff       	jmp    a10 <parseredirs+0x10>
     b16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b1d:	00 
     b1e:	66 90                	xchg   %ax,%ax
    }
  }
  return cmd;
}
     b20:	8b 45 08             	mov    0x8(%ebp),%eax
     b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b26:	5b                   	pop    %ebx
     b27:	5e                   	pop    %esi
     b28:	5f                   	pop    %edi
     b29:	5d                   	pop    %ebp
     b2a:	c3                   	ret
      panic("missing file for redirection");
     b2b:	83 ec 0c             	sub    $0xc,%esp
     b2e:	68 db 16 00 00       	push   $0x16db
     b33:	e8 d8 f9 ff ff       	call   510 <panic>
     b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b3f:	00 

00000b40 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     b40:	55                   	push   %ebp
     b41:	89 e5                	mov    %esp,%ebp
     b43:	57                   	push   %edi
     b44:	56                   	push   %esi
     b45:	53                   	push   %ebx
     b46:	83 ec 30             	sub    $0x30,%esp
     b49:	8b 75 08             	mov    0x8(%ebp),%esi
     b4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     b4f:	68 fb 16 00 00       	push   $0x16fb
     b54:	57                   	push   %edi
     b55:	56                   	push   %esi
     b56:	e8 25 fe ff ff       	call   980 <peek>
     b5b:	83 c4 10             	add    $0x10,%esp
     b5e:	85 c0                	test   %eax,%eax
     b60:	0f 85 aa 00 00 00    	jne    c10 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     b66:	83 ec 0c             	sub    $0xc,%esp
     b69:	89 c3                	mov    %eax,%ebx
     b6b:	6a 54                	push   $0x54
     b6d:	e8 0e 0a 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     b72:	83 c4 0c             	add    $0xc,%esp
     b75:	6a 54                	push   $0x54
     b77:	6a 00                	push   $0x0
     b79:	50                   	push   %eax
     b7a:	89 45 d0             	mov    %eax,-0x30(%ebp)
     b7d:	e8 be 04 00 00       	call   1040 <memset>
  cmd->type = EXEC;
     b82:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     b85:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     b88:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     b8e:	57                   	push   %edi
     b8f:	56                   	push   %esi
     b90:	50                   	push   %eax
     b91:	e8 6a fe ff ff       	call   a00 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     b96:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     b99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     b9c:	eb 15                	jmp    bb3 <parseexec+0x73>
     b9e:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     ba0:	83 ec 04             	sub    $0x4,%esp
     ba3:	57                   	push   %edi
     ba4:	56                   	push   %esi
     ba5:	ff 75 d4             	push   -0x2c(%ebp)
     ba8:	e8 53 fe ff ff       	call   a00 <parseredirs>
     bad:	83 c4 10             	add    $0x10,%esp
     bb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     bb3:	83 ec 04             	sub    $0x4,%esp
     bb6:	68 12 17 00 00       	push   $0x1712
     bbb:	57                   	push   %edi
     bbc:	56                   	push   %esi
     bbd:	e8 be fd ff ff       	call   980 <peek>
     bc2:	83 c4 10             	add    $0x10,%esp
     bc5:	85 c0                	test   %eax,%eax
     bc7:	75 5f                	jne    c28 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     bc9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     bcc:	50                   	push   %eax
     bcd:	8d 45 e0             	lea    -0x20(%ebp),%eax
     bd0:	50                   	push   %eax
     bd1:	57                   	push   %edi
     bd2:	56                   	push   %esi
     bd3:	e8 48 fc ff ff       	call   820 <gettoken>
     bd8:	83 c4 10             	add    $0x10,%esp
     bdb:	85 c0                	test   %eax,%eax
     bdd:	74 49                	je     c28 <parseexec+0xe8>
    if(tok != 'a')
     bdf:	83 f8 61             	cmp    $0x61,%eax
     be2:	75 62                	jne    c46 <parseexec+0x106>
    cmd->argv[argc] = q;
     be4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     be7:	8b 55 d0             	mov    -0x30(%ebp),%edx
     bea:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bf1:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     bf5:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     bf8:	83 fb 0a             	cmp    $0xa,%ebx
     bfb:	75 a3                	jne    ba0 <parseexec+0x60>
      panic("too many args");
     bfd:	83 ec 0c             	sub    $0xc,%esp
     c00:	68 04 17 00 00       	push   $0x1704
     c05:	e8 06 f9 ff ff       	call   510 <panic>
     c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     c10:	89 7d 0c             	mov    %edi,0xc(%ebp)
     c13:	89 75 08             	mov    %esi,0x8(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c19:	5b                   	pop    %ebx
     c1a:	5e                   	pop    %esi
     c1b:	5f                   	pop    %edi
     c1c:	5d                   	pop    %ebp
    return parseblock(ps, es);
     c1d:	e9 ae 01 00 00       	jmp    dd0 <parseblock>
     c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc] = 0;
     c28:	8b 45 d0             	mov    -0x30(%ebp),%eax
     c2b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     c32:	00 
  cmd->eargv[argc] = 0;
     c33:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     c3a:	00 
}
     c3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c41:	5b                   	pop    %ebx
     c42:	5e                   	pop    %esi
     c43:	5f                   	pop    %edi
     c44:	5d                   	pop    %ebp
     c45:	c3                   	ret
      panic("syntax");
     c46:	83 ec 0c             	sub    $0xc,%esp
     c49:	68 fd 16 00 00       	push   $0x16fd
     c4e:	e8 bd f8 ff ff       	call   510 <panic>
     c53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c5a:	00 
     c5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000c60 <parsepipe>:
{
     c60:	55                   	push   %ebp
     c61:	89 e5                	mov    %esp,%ebp
     c63:	57                   	push   %edi
     c64:	56                   	push   %esi
     c65:	53                   	push   %ebx
     c66:	83 ec 14             	sub    $0x14,%esp
     c69:	8b 75 08             	mov    0x8(%ebp),%esi
     c6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     c6f:	57                   	push   %edi
     c70:	56                   	push   %esi
     c71:	e8 ca fe ff ff       	call   b40 <parseexec>
  if(peek(ps, es, "|")){
     c76:	83 c4 0c             	add    $0xc,%esp
     c79:	68 17 17 00 00       	push   $0x1717
  cmd = parseexec(ps, es);
     c7e:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     c80:	57                   	push   %edi
     c81:	56                   	push   %esi
     c82:	e8 f9 fc ff ff       	call   980 <peek>
     c87:	83 c4 10             	add    $0x10,%esp
     c8a:	85 c0                	test   %eax,%eax
     c8c:	75 12                	jne    ca0 <parsepipe+0x40>
}
     c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c91:	89 d8                	mov    %ebx,%eax
     c93:	5b                   	pop    %ebx
     c94:	5e                   	pop    %esi
     c95:	5f                   	pop    %edi
     c96:	5d                   	pop    %ebp
     c97:	c3                   	ret
     c98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c9f:	00 
    gettoken(ps, es, 0, 0);
     ca0:	6a 00                	push   $0x0
     ca2:	6a 00                	push   $0x0
     ca4:	57                   	push   %edi
     ca5:	56                   	push   %esi
     ca6:	e8 75 fb ff ff       	call   820 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     cab:	58                   	pop    %eax
     cac:	5a                   	pop    %edx
     cad:	57                   	push   %edi
     cae:	56                   	push   %esi
     caf:	e8 ac ff ff ff       	call   c60 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     cb4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     cbb:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     cbd:	e8 be 08 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     cc2:	83 c4 0c             	add    $0xc,%esp
     cc5:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     cc7:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     cc9:	6a 00                	push   $0x0
     ccb:	50                   	push   %eax
     ccc:	e8 6f 03 00 00       	call   1040 <memset>
  cmd->left = left;
     cd1:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     cd4:	83 c4 10             	add    $0x10,%esp
     cd7:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     cd9:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     cdf:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     ce1:	89 7e 08             	mov    %edi,0x8(%esi)
}
     ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ce7:	5b                   	pop    %ebx
     ce8:	5e                   	pop    %esi
     ce9:	5f                   	pop    %edi
     cea:	5d                   	pop    %ebp
     ceb:	c3                   	ret
     cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000cf0 <parseline>:
{
     cf0:	55                   	push   %ebp
     cf1:	89 e5                	mov    %esp,%ebp
     cf3:	57                   	push   %edi
     cf4:	56                   	push   %esi
     cf5:	53                   	push   %ebx
     cf6:	83 ec 24             	sub    $0x24,%esp
     cf9:	8b 75 08             	mov    0x8(%ebp),%esi
     cfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     cff:	57                   	push   %edi
     d00:	56                   	push   %esi
     d01:	e8 5a ff ff ff       	call   c60 <parsepipe>
  while(peek(ps, es, "&")){
     d06:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     d09:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     d0b:	eb 3b                	jmp    d48 <parseline+0x58>
     d0d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     d10:	6a 00                	push   $0x0
     d12:	6a 00                	push   $0x0
     d14:	57                   	push   %edi
     d15:	56                   	push   %esi
     d16:	e8 05 fb ff ff       	call   820 <gettoken>
  cmd = malloc(sizeof(*cmd));
     d1b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     d22:	e8 59 08 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     d27:	83 c4 0c             	add    $0xc,%esp
     d2a:	6a 08                	push   $0x8
     d2c:	6a 00                	push   $0x0
     d2e:	50                   	push   %eax
     d2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     d32:	e8 09 03 00 00       	call   1040 <memset>
  cmd->type = BACK;
     d37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     d3a:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     d3d:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     d43:	89 5a 04             	mov    %ebx,0x4(%edx)
     d46:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     d48:	83 ec 04             	sub    $0x4,%esp
     d4b:	68 19 17 00 00       	push   $0x1719
     d50:	57                   	push   %edi
     d51:	56                   	push   %esi
     d52:	e8 29 fc ff ff       	call   980 <peek>
     d57:	83 c4 10             	add    $0x10,%esp
     d5a:	85 c0                	test   %eax,%eax
     d5c:	75 b2                	jne    d10 <parseline+0x20>
  if(peek(ps, es, ";")){
     d5e:	83 ec 04             	sub    $0x4,%esp
     d61:	68 15 17 00 00       	push   $0x1715
     d66:	57                   	push   %edi
     d67:	56                   	push   %esi
     d68:	e8 13 fc ff ff       	call   980 <peek>
     d6d:	83 c4 10             	add    $0x10,%esp
     d70:	85 c0                	test   %eax,%eax
     d72:	75 0c                	jne    d80 <parseline+0x90>
}
     d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d77:	89 d8                	mov    %ebx,%eax
     d79:	5b                   	pop    %ebx
     d7a:	5e                   	pop    %esi
     d7b:	5f                   	pop    %edi
     d7c:	5d                   	pop    %ebp
     d7d:	c3                   	ret
     d7e:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     d80:	6a 00                	push   $0x0
     d82:	6a 00                	push   $0x0
     d84:	57                   	push   %edi
     d85:	56                   	push   %esi
     d86:	e8 95 fa ff ff       	call   820 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     d8b:	58                   	pop    %eax
     d8c:	5a                   	pop    %edx
     d8d:	57                   	push   %edi
     d8e:	56                   	push   %esi
     d8f:	e8 5c ff ff ff       	call   cf0 <parseline>
  cmd = malloc(sizeof(*cmd));
     d94:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     d9b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     d9d:	e8 de 07 00 00       	call   1580 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     da2:	83 c4 0c             	add    $0xc,%esp
     da5:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     da7:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     da9:	6a 00                	push   $0x0
     dab:	50                   	push   %eax
     dac:	e8 8f 02 00 00       	call   1040 <memset>
  cmd->left = left;
     db1:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     db4:	83 c4 10             	add    $0x10,%esp
     db7:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     db9:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     dbf:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     dc1:	89 7e 08             	mov    %edi,0x8(%esi)
}
     dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     dc7:	5b                   	pop    %ebx
     dc8:	5e                   	pop    %esi
     dc9:	5f                   	pop    %edi
     dca:	5d                   	pop    %ebp
     dcb:	c3                   	ret
     dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000dd0 <parseblock>:
{
     dd0:	55                   	push   %ebp
     dd1:	89 e5                	mov    %esp,%ebp
     dd3:	57                   	push   %edi
     dd4:	56                   	push   %esi
     dd5:	53                   	push   %ebx
     dd6:	83 ec 10             	sub    $0x10,%esp
     dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     ddc:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     ddf:	68 fb 16 00 00       	push   $0x16fb
     de4:	56                   	push   %esi
     de5:	53                   	push   %ebx
     de6:	e8 95 fb ff ff       	call   980 <peek>
     deb:	83 c4 10             	add    $0x10,%esp
     dee:	85 c0                	test   %eax,%eax
     df0:	74 4a                	je     e3c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     df2:	6a 00                	push   $0x0
     df4:	6a 00                	push   $0x0
     df6:	56                   	push   %esi
     df7:	53                   	push   %ebx
     df8:	e8 23 fa ff ff       	call   820 <gettoken>
  cmd = parseline(ps, es);
     dfd:	58                   	pop    %eax
     dfe:	5a                   	pop    %edx
     dff:	56                   	push   %esi
     e00:	53                   	push   %ebx
     e01:	e8 ea fe ff ff       	call   cf0 <parseline>
  if(!peek(ps, es, ")"))
     e06:	83 c4 0c             	add    $0xc,%esp
     e09:	68 37 17 00 00       	push   $0x1737
  cmd = parseline(ps, es);
     e0e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     e10:	56                   	push   %esi
     e11:	53                   	push   %ebx
     e12:	e8 69 fb ff ff       	call   980 <peek>
     e17:	83 c4 10             	add    $0x10,%esp
     e1a:	85 c0                	test   %eax,%eax
     e1c:	74 2b                	je     e49 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     e1e:	6a 00                	push   $0x0
     e20:	6a 00                	push   $0x0
     e22:	56                   	push   %esi
     e23:	53                   	push   %ebx
     e24:	e8 f7 f9 ff ff       	call   820 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     e29:	83 c4 0c             	add    $0xc,%esp
     e2c:	56                   	push   %esi
     e2d:	53                   	push   %ebx
     e2e:	57                   	push   %edi
     e2f:	e8 cc fb ff ff       	call   a00 <parseredirs>
}
     e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e37:	5b                   	pop    %ebx
     e38:	5e                   	pop    %esi
     e39:	5f                   	pop    %edi
     e3a:	5d                   	pop    %ebp
     e3b:	c3                   	ret
    panic("parseblock");
     e3c:	83 ec 0c             	sub    $0xc,%esp
     e3f:	68 1b 17 00 00       	push   $0x171b
     e44:	e8 c7 f6 ff ff       	call   510 <panic>
    panic("syntax - missing )");
     e49:	83 ec 0c             	sub    $0xc,%esp
     e4c:	68 26 17 00 00       	push   $0x1726
     e51:	e8 ba f6 ff ff       	call   510 <panic>
     e56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     e5d:	00 
     e5e:	66 90                	xchg   %ax,%ax

00000e60 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e60:	55                   	push   %ebp
     e61:	89 e5                	mov    %esp,%ebp
     e63:	53                   	push   %ebx
     e64:	83 ec 04             	sub    $0x4,%esp
     e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     e6a:	85 db                	test   %ebx,%ebx
     e6c:	0f 84 8e 00 00 00    	je     f00 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
     e72:	83 3b 05             	cmpl   $0x5,(%ebx)
     e75:	77 61                	ja     ed8 <nulterminate+0x78>
     e77:	8b 03                	mov    (%ebx),%eax
     e79:	ff 24 85 04 18 00 00 	jmp    *0x1804(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     e80:	83 ec 0c             	sub    $0xc,%esp
     e83:	ff 73 04             	push   0x4(%ebx)
     e86:	e8 d5 ff ff ff       	call   e60 <nulterminate>
    nulterminate(lcmd->right);
     e8b:	58                   	pop    %eax
     e8c:	ff 73 08             	push   0x8(%ebx)
     e8f:	e8 cc ff ff ff       	call   e60 <nulterminate>
    break;
     e94:	83 c4 10             	add    $0x10,%esp
     e97:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e9c:	c9                   	leave
     e9d:	c3                   	ret
     e9e:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     ea0:	83 ec 0c             	sub    $0xc,%esp
     ea3:	ff 73 04             	push   0x4(%ebx)
     ea6:	e8 b5 ff ff ff       	call   e60 <nulterminate>
    break;
     eab:	89 d8                	mov    %ebx,%eax
     ead:	83 c4 10             	add    $0x10,%esp
}
     eb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     eb3:	c9                   	leave
     eb4:	c3                   	ret
     eb5:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     eb8:	8b 4b 04             	mov    0x4(%ebx),%ecx
     ebb:	8d 43 08             	lea    0x8(%ebx),%eax
     ebe:	85 c9                	test   %ecx,%ecx
     ec0:	74 16                	je     ed8 <nulterminate+0x78>
     ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     ec8:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     ecb:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     ece:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     ed1:	8b 50 fc             	mov    -0x4(%eax),%edx
     ed4:	85 d2                	test   %edx,%edx
     ed6:	75 f0                	jne    ec8 <nulterminate+0x68>
  switch(cmd->type){
     ed8:	89 d8                	mov    %ebx,%eax
}
     eda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     edd:	c9                   	leave
     ede:	c3                   	ret
     edf:	90                   	nop
    nulterminate(rcmd->cmd);
     ee0:	83 ec 0c             	sub    $0xc,%esp
     ee3:	ff 73 04             	push   0x4(%ebx)
     ee6:	e8 75 ff ff ff       	call   e60 <nulterminate>
    *rcmd->efile = 0;
     eeb:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     eee:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     ef1:	c6 00 00             	movb   $0x0,(%eax)
    break;
     ef4:	89 d8                	mov    %ebx,%eax
}
     ef6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ef9:	c9                   	leave
     efa:	c3                   	ret
     efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return 0;
     f00:	31 c0                	xor    %eax,%eax
     f02:	eb 95                	jmp    e99 <nulterminate+0x39>
     f04:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f0b:	00 
     f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f10 <parsecmd>:
{
     f10:	55                   	push   %ebp
     f11:	89 e5                	mov    %esp,%ebp
     f13:	57                   	push   %edi
     f14:	56                   	push   %esi
  cmd = parseline(&s, es);
     f15:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     f18:	53                   	push   %ebx
     f19:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     f1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
     f1f:	53                   	push   %ebx
     f20:	e8 eb 00 00 00       	call   1010 <strlen>
  cmd = parseline(&s, es);
     f25:	59                   	pop    %ecx
     f26:	5e                   	pop    %esi
  es = s + strlen(s);
     f27:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     f29:	53                   	push   %ebx
     f2a:	57                   	push   %edi
     f2b:	e8 c0 fd ff ff       	call   cf0 <parseline>
  peek(&s, es, "");
     f30:	83 c4 0c             	add    $0xc,%esp
     f33:	68 6b 17 00 00       	push   $0x176b
  cmd = parseline(&s, es);
     f38:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     f3a:	53                   	push   %ebx
     f3b:	57                   	push   %edi
     f3c:	e8 3f fa ff ff       	call   980 <peek>
  if(s != es){
     f41:	8b 45 08             	mov    0x8(%ebp),%eax
     f44:	83 c4 10             	add    $0x10,%esp
     f47:	39 d8                	cmp    %ebx,%eax
     f49:	75 13                	jne    f5e <parsecmd+0x4e>
  nulterminate(cmd);
     f4b:	83 ec 0c             	sub    $0xc,%esp
     f4e:	56                   	push   %esi
     f4f:	e8 0c ff ff ff       	call   e60 <nulterminate>
}
     f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f57:	89 f0                	mov    %esi,%eax
     f59:	5b                   	pop    %ebx
     f5a:	5e                   	pop    %esi
     f5b:	5f                   	pop    %edi
     f5c:	5d                   	pop    %ebp
     f5d:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
     f5e:	52                   	push   %edx
     f5f:	50                   	push   %eax
     f60:	68 39 17 00 00       	push   $0x1739
     f65:	6a 02                	push   $0x2
     f67:	e8 e4 03 00 00       	call   1350 <printf>
    panic("syntax");
     f6c:	c7 04 24 fd 16 00 00 	movl   $0x16fd,(%esp)
     f73:	e8 98 f5 ff ff       	call   510 <panic>
     f78:	66 90                	xchg   %ax,%ax
     f7a:	66 90                	xchg   %ax,%ax
     f7c:	66 90                	xchg   %ax,%ax
     f7e:	66 90                	xchg   %ax,%ax

00000f80 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     f80:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     f81:	31 c0                	xor    %eax,%eax
{
     f83:	89 e5                	mov    %esp,%ebp
     f85:	53                   	push   %ebx
     f86:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     f90:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     f94:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     f97:	83 c0 01             	add    $0x1,%eax
     f9a:	84 d2                	test   %dl,%dl
     f9c:	75 f2                	jne    f90 <strcpy+0x10>
    ;
  return os;
}
     f9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     fa1:	89 c8                	mov    %ecx,%eax
     fa3:	c9                   	leave
     fa4:	c3                   	ret
     fa5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fac:	00 
     fad:	8d 76 00             	lea    0x0(%esi),%esi

00000fb0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     fb0:	55                   	push   %ebp
     fb1:	89 e5                	mov    %esp,%ebp
     fb3:	53                   	push   %ebx
     fb4:	8b 55 08             	mov    0x8(%ebp),%edx
     fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     fba:	0f b6 02             	movzbl (%edx),%eax
     fbd:	84 c0                	test   %al,%al
     fbf:	75 17                	jne    fd8 <strcmp+0x28>
     fc1:	eb 3a                	jmp    ffd <strcmp+0x4d>
     fc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     fc8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     fcc:	83 c2 01             	add    $0x1,%edx
     fcf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     fd2:	84 c0                	test   %al,%al
     fd4:	74 1a                	je     ff0 <strcmp+0x40>
    p++, q++;
     fd6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
     fd8:	0f b6 19             	movzbl (%ecx),%ebx
     fdb:	38 c3                	cmp    %al,%bl
     fdd:	74 e9                	je     fc8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     fdf:	29 d8                	sub    %ebx,%eax
}
     fe1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     fe4:	c9                   	leave
     fe5:	c3                   	ret
     fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fed:	00 
     fee:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     ff0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     ff4:	31 c0                	xor    %eax,%eax
     ff6:	29 d8                	sub    %ebx,%eax
}
     ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ffb:	c9                   	leave
     ffc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     ffd:	0f b6 19             	movzbl (%ecx),%ebx
    1000:	31 c0                	xor    %eax,%eax
    1002:	eb db                	jmp    fdf <strcmp+0x2f>
    1004:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    100b:	00 
    100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001010 <strlen>:

uint
strlen(const char *s)
{
    1010:	55                   	push   %ebp
    1011:	89 e5                	mov    %esp,%ebp
    1013:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    1016:	80 3a 00             	cmpb   $0x0,(%edx)
    1019:	74 15                	je     1030 <strlen+0x20>
    101b:	31 c0                	xor    %eax,%eax
    101d:	8d 76 00             	lea    0x0(%esi),%esi
    1020:	83 c0 01             	add    $0x1,%eax
    1023:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    1027:	89 c1                	mov    %eax,%ecx
    1029:	75 f5                	jne    1020 <strlen+0x10>
    ;
  return n;
}
    102b:	89 c8                	mov    %ecx,%eax
    102d:	5d                   	pop    %ebp
    102e:	c3                   	ret
    102f:	90                   	nop
  for(n = 0; s[n]; n++)
    1030:	31 c9                	xor    %ecx,%ecx
}
    1032:	5d                   	pop    %ebp
    1033:	89 c8                	mov    %ecx,%eax
    1035:	c3                   	ret
    1036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    103d:	00 
    103e:	66 90                	xchg   %ax,%ax

00001040 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1040:	55                   	push   %ebp
    1041:	89 e5                	mov    %esp,%ebp
    1043:	57                   	push   %edi
    1044:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1047:	8b 4d 10             	mov    0x10(%ebp),%ecx
    104a:	8b 45 0c             	mov    0xc(%ebp),%eax
    104d:	89 d7                	mov    %edx,%edi
    104f:	fc                   	cld
    1050:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1052:	8b 7d fc             	mov    -0x4(%ebp),%edi
    1055:	89 d0                	mov    %edx,%eax
    1057:	c9                   	leave
    1058:	c3                   	ret
    1059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001060 <strchr>:

char*
strchr(const char *s, char c)
{
    1060:	55                   	push   %ebp
    1061:	89 e5                	mov    %esp,%ebp
    1063:	8b 45 08             	mov    0x8(%ebp),%eax
    1066:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    106a:	0f b6 10             	movzbl (%eax),%edx
    106d:	84 d2                	test   %dl,%dl
    106f:	75 12                	jne    1083 <strchr+0x23>
    1071:	eb 1d                	jmp    1090 <strchr+0x30>
    1073:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    1078:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    107c:	83 c0 01             	add    $0x1,%eax
    107f:	84 d2                	test   %dl,%dl
    1081:	74 0d                	je     1090 <strchr+0x30>
    if(*s == c)
    1083:	38 d1                	cmp    %dl,%cl
    1085:	75 f1                	jne    1078 <strchr+0x18>
      return (char*)s;
  return 0;
}
    1087:	5d                   	pop    %ebp
    1088:	c3                   	ret
    1089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1090:	31 c0                	xor    %eax,%eax
}
    1092:	5d                   	pop    %ebp
    1093:	c3                   	ret
    1094:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    109b:	00 
    109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000010a0 <gets>:

char*
gets(char *buf, int max)
{
    10a0:	55                   	push   %ebp
    10a1:	89 e5                	mov    %esp,%ebp
    10a3:	57                   	push   %edi
    10a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    10a5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    10a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    10a9:	31 db                	xor    %ebx,%ebx
{
    10ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    10ae:	eb 27                	jmp    10d7 <gets+0x37>
    cc = read(0, &c, 1);
    10b0:	83 ec 04             	sub    $0x4,%esp
    10b3:	6a 01                	push   $0x1
    10b5:	57                   	push   %edi
    10b6:	6a 00                	push   $0x0
    10b8:	e8 2e 01 00 00       	call   11eb <read>
    if(cc < 1)
    10bd:	83 c4 10             	add    $0x10,%esp
    10c0:	85 c0                	test   %eax,%eax
    10c2:	7e 1d                	jle    10e1 <gets+0x41>
      break;
    buf[i++] = c;
    10c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    10c8:	8b 55 08             	mov    0x8(%ebp),%edx
    10cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    10cf:	3c 0a                	cmp    $0xa,%al
    10d1:	74 1d                	je     10f0 <gets+0x50>
    10d3:	3c 0d                	cmp    $0xd,%al
    10d5:	74 19                	je     10f0 <gets+0x50>
  for(i=0; i+1 < max; ){
    10d7:	89 de                	mov    %ebx,%esi
    10d9:	83 c3 01             	add    $0x1,%ebx
    10dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    10df:	7c cf                	jl     10b0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    10e1:	8b 45 08             	mov    0x8(%ebp),%eax
    10e4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    10e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10eb:	5b                   	pop    %ebx
    10ec:	5e                   	pop    %esi
    10ed:	5f                   	pop    %edi
    10ee:	5d                   	pop    %ebp
    10ef:	c3                   	ret
  buf[i] = '\0';
    10f0:	8b 45 08             	mov    0x8(%ebp),%eax
    10f3:	89 de                	mov    %ebx,%esi
    10f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    10f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10fc:	5b                   	pop    %ebx
    10fd:	5e                   	pop    %esi
    10fe:	5f                   	pop    %edi
    10ff:	5d                   	pop    %ebp
    1100:	c3                   	ret
    1101:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    1108:	00 
    1109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001110 <stat>:

int
stat(const char *n, struct stat *st)
{
    1110:	55                   	push   %ebp
    1111:	89 e5                	mov    %esp,%ebp
    1113:	56                   	push   %esi
    1114:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1115:	83 ec 08             	sub    $0x8,%esp
    1118:	6a 00                	push   $0x0
    111a:	ff 75 08             	push   0x8(%ebp)
    111d:	e8 f1 00 00 00       	call   1213 <open>
  if(fd < 0)
    1122:	83 c4 10             	add    $0x10,%esp
    1125:	85 c0                	test   %eax,%eax
    1127:	78 27                	js     1150 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    1129:	83 ec 08             	sub    $0x8,%esp
    112c:	ff 75 0c             	push   0xc(%ebp)
    112f:	89 c3                	mov    %eax,%ebx
    1131:	50                   	push   %eax
    1132:	e8 f4 00 00 00       	call   122b <fstat>
  close(fd);
    1137:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    113a:	89 c6                	mov    %eax,%esi
  close(fd);
    113c:	e8 ba 00 00 00       	call   11fb <close>
  return r;
    1141:	83 c4 10             	add    $0x10,%esp
}
    1144:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1147:	89 f0                	mov    %esi,%eax
    1149:	5b                   	pop    %ebx
    114a:	5e                   	pop    %esi
    114b:	5d                   	pop    %ebp
    114c:	c3                   	ret
    114d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1150:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1155:	eb ed                	jmp    1144 <stat+0x34>
    1157:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    115e:	00 
    115f:	90                   	nop

00001160 <atoi>:

int
atoi(const char *s)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	53                   	push   %ebx
    1164:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1167:	0f be 02             	movsbl (%edx),%eax
    116a:	8d 48 d0             	lea    -0x30(%eax),%ecx
    116d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1170:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1175:	77 1e                	ja     1195 <atoi+0x35>
    1177:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    117e:	00 
    117f:	90                   	nop
    n = n*10 + *s++ - '0';
    1180:	83 c2 01             	add    $0x1,%edx
    1183:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1186:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    118a:	0f be 02             	movsbl (%edx),%eax
    118d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1190:	80 fb 09             	cmp    $0x9,%bl
    1193:	76 eb                	jbe    1180 <atoi+0x20>
  return n;
}
    1195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1198:	89 c8                	mov    %ecx,%eax
    119a:	c9                   	leave
    119b:	c3                   	ret
    119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000011a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	57                   	push   %edi
    11a4:	8b 45 10             	mov    0x10(%ebp),%eax
    11a7:	8b 55 08             	mov    0x8(%ebp),%edx
    11aa:	56                   	push   %esi
    11ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11ae:	85 c0                	test   %eax,%eax
    11b0:	7e 13                	jle    11c5 <memmove+0x25>
    11b2:	01 d0                	add    %edx,%eax
  dst = vdst;
    11b4:	89 d7                	mov    %edx,%edi
    11b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    11bd:	00 
    11be:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
    11c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    11c1:	39 f8                	cmp    %edi,%eax
    11c3:	75 fb                	jne    11c0 <memmove+0x20>
  return vdst;
}
    11c5:	5e                   	pop    %esi
    11c6:	89 d0                	mov    %edx,%eax
    11c8:	5f                   	pop    %edi
    11c9:	5d                   	pop    %ebp
    11ca:	c3                   	ret

000011cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    11cb:	b8 01 00 00 00       	mov    $0x1,%eax
    11d0:	cd 40                	int    $0x40
    11d2:	c3                   	ret

000011d3 <exit>:
SYSCALL(exit)
    11d3:	b8 02 00 00 00       	mov    $0x2,%eax
    11d8:	cd 40                	int    $0x40
    11da:	c3                   	ret

000011db <wait>:
SYSCALL(wait)
    11db:	b8 03 00 00 00       	mov    $0x3,%eax
    11e0:	cd 40                	int    $0x40
    11e2:	c3                   	ret

000011e3 <pipe>:
SYSCALL(pipe)
    11e3:	b8 04 00 00 00       	mov    $0x4,%eax
    11e8:	cd 40                	int    $0x40
    11ea:	c3                   	ret

000011eb <read>:
SYSCALL(read)
    11eb:	b8 05 00 00 00       	mov    $0x5,%eax
    11f0:	cd 40                	int    $0x40
    11f2:	c3                   	ret

000011f3 <write>:
SYSCALL(write)
    11f3:	b8 10 00 00 00       	mov    $0x10,%eax
    11f8:	cd 40                	int    $0x40
    11fa:	c3                   	ret

000011fb <close>:
SYSCALL(close)
    11fb:	b8 15 00 00 00       	mov    $0x15,%eax
    1200:	cd 40                	int    $0x40
    1202:	c3                   	ret

00001203 <kill>:
SYSCALL(kill)
    1203:	b8 06 00 00 00       	mov    $0x6,%eax
    1208:	cd 40                	int    $0x40
    120a:	c3                   	ret

0000120b <exec>:
SYSCALL(exec)
    120b:	b8 07 00 00 00       	mov    $0x7,%eax
    1210:	cd 40                	int    $0x40
    1212:	c3                   	ret

00001213 <open>:
SYSCALL(open)
    1213:	b8 0f 00 00 00       	mov    $0xf,%eax
    1218:	cd 40                	int    $0x40
    121a:	c3                   	ret

0000121b <mknod>:
SYSCALL(mknod)
    121b:	b8 11 00 00 00       	mov    $0x11,%eax
    1220:	cd 40                	int    $0x40
    1222:	c3                   	ret

00001223 <unlink>:
SYSCALL(unlink)
    1223:	b8 12 00 00 00       	mov    $0x12,%eax
    1228:	cd 40                	int    $0x40
    122a:	c3                   	ret

0000122b <fstat>:
SYSCALL(fstat)
    122b:	b8 08 00 00 00       	mov    $0x8,%eax
    1230:	cd 40                	int    $0x40
    1232:	c3                   	ret

00001233 <link>:
SYSCALL(link)
    1233:	b8 13 00 00 00       	mov    $0x13,%eax
    1238:	cd 40                	int    $0x40
    123a:	c3                   	ret

0000123b <mkdir>:
SYSCALL(mkdir)
    123b:	b8 14 00 00 00       	mov    $0x14,%eax
    1240:	cd 40                	int    $0x40
    1242:	c3                   	ret

00001243 <chdir>:
SYSCALL(chdir)
    1243:	b8 09 00 00 00       	mov    $0x9,%eax
    1248:	cd 40                	int    $0x40
    124a:	c3                   	ret

0000124b <dup>:
SYSCALL(dup)
    124b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1250:	cd 40                	int    $0x40
    1252:	c3                   	ret

00001253 <getpid>:
SYSCALL(getpid)
    1253:	b8 0b 00 00 00       	mov    $0xb,%eax
    1258:	cd 40                	int    $0x40
    125a:	c3                   	ret

0000125b <sbrk>:
SYSCALL(sbrk)
    125b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1260:	cd 40                	int    $0x40
    1262:	c3                   	ret

00001263 <sleep>:
SYSCALL(sleep)
    1263:	b8 0d 00 00 00       	mov    $0xd,%eax
    1268:	cd 40                	int    $0x40
    126a:	c3                   	ret

0000126b <uptime>:
SYSCALL(uptime)
    126b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1270:	cd 40                	int    $0x40
    1272:	c3                   	ret

00001273 <gethistory>:
SYSCALL(gethistory)
    1273:	b8 16 00 00 00       	mov    $0x16,%eax
    1278:	cd 40                	int    $0x40
    127a:	c3                   	ret

0000127b <block>:
SYSCALL(block)
    127b:	b8 17 00 00 00       	mov    $0x17,%eax
    1280:	cd 40                	int    $0x40
    1282:	c3                   	ret

00001283 <unblock>:
SYSCALL(unblock)
    1283:	b8 18 00 00 00       	mov    $0x18,%eax
    1288:	cd 40                	int    $0x40
    128a:	c3                   	ret

0000128b <chmod>:
SYSCALL(chmod)
    128b:	b8 19 00 00 00       	mov    $0x19,%eax
    1290:	cd 40                	int    $0x40
    1292:	c3                   	ret
    1293:	66 90                	xchg   %ax,%ax
    1295:	66 90                	xchg   %ax,%ax
    1297:	66 90                	xchg   %ax,%ax
    1299:	66 90                	xchg   %ax,%ax
    129b:	66 90                	xchg   %ax,%ax
    129d:	66 90                	xchg   %ax,%ax
    129f:	90                   	nop

000012a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    12a0:	55                   	push   %ebp
    12a1:	89 e5                	mov    %esp,%ebp
    12a3:	57                   	push   %edi
    12a4:	56                   	push   %esi
    12a5:	53                   	push   %ebx
    12a6:	83 ec 3c             	sub    $0x3c,%esp
    12a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    12ac:	89 d1                	mov    %edx,%ecx
{
    12ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    12b1:	85 d2                	test   %edx,%edx
    12b3:	0f 89 7f 00 00 00    	jns    1338 <printint+0x98>
    12b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    12bd:	74 79                	je     1338 <printint+0x98>
    neg = 1;
    12bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    12c6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    12c8:	31 db                	xor    %ebx,%ebx
    12ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
    12cd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    12d0:	89 c8                	mov    %ecx,%eax
    12d2:	31 d2                	xor    %edx,%edx
    12d4:	89 cf                	mov    %ecx,%edi
    12d6:	f7 75 c4             	divl   -0x3c(%ebp)
    12d9:	0f b6 92 74 18 00 00 	movzbl 0x1874(%edx),%edx
    12e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    12e3:	89 d8                	mov    %ebx,%eax
    12e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    12e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    12eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    12ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    12f1:	76 dd                	jbe    12d0 <printint+0x30>
  if(neg)
    12f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    12f6:	85 c9                	test   %ecx,%ecx
    12f8:	74 0c                	je     1306 <printint+0x66>
    buf[i++] = '-';
    12fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    12ff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1301:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1306:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1309:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    130d:	eb 07                	jmp    1316 <printint+0x76>
    130f:	90                   	nop
    putc(fd, buf[i]);
    1310:	0f b6 13             	movzbl (%ebx),%edx
    1313:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1316:	83 ec 04             	sub    $0x4,%esp
    1319:	88 55 d7             	mov    %dl,-0x29(%ebp)
    131c:	6a 01                	push   $0x1
    131e:	56                   	push   %esi
    131f:	57                   	push   %edi
    1320:	e8 ce fe ff ff       	call   11f3 <write>
  while(--i >= 0)
    1325:	83 c4 10             	add    $0x10,%esp
    1328:	39 de                	cmp    %ebx,%esi
    132a:	75 e4                	jne    1310 <printint+0x70>
}
    132c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    132f:	5b                   	pop    %ebx
    1330:	5e                   	pop    %esi
    1331:	5f                   	pop    %edi
    1332:	5d                   	pop    %ebp
    1333:	c3                   	ret
    1334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1338:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    133f:	eb 87                	jmp    12c8 <printint+0x28>
    1341:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    1348:	00 
    1349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001350 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1350:	55                   	push   %ebp
    1351:	89 e5                	mov    %esp,%ebp
    1353:	57                   	push   %edi
    1354:	56                   	push   %esi
    1355:	53                   	push   %ebx
    1356:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    135c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    135f:	0f b6 13             	movzbl (%ebx),%edx
    1362:	84 d2                	test   %dl,%dl
    1364:	74 6a                	je     13d0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    1366:	8d 45 10             	lea    0x10(%ebp),%eax
    1369:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    136c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    136f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    1371:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1374:	eb 36                	jmp    13ac <printf+0x5c>
    1376:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    137d:	00 
    137e:	66 90                	xchg   %ax,%ax
    1380:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1383:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    1388:	83 f8 25             	cmp    $0x25,%eax
    138b:	74 15                	je     13a2 <printf+0x52>
  write(fd, &c, 1);
    138d:	83 ec 04             	sub    $0x4,%esp
    1390:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1393:	6a 01                	push   $0x1
    1395:	57                   	push   %edi
    1396:	56                   	push   %esi
    1397:	e8 57 fe ff ff       	call   11f3 <write>
    139c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    139f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    13a2:	0f b6 13             	movzbl (%ebx),%edx
    13a5:	83 c3 01             	add    $0x1,%ebx
    13a8:	84 d2                	test   %dl,%dl
    13aa:	74 24                	je     13d0 <printf+0x80>
    c = fmt[i] & 0xff;
    13ac:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    13af:	85 c9                	test   %ecx,%ecx
    13b1:	74 cd                	je     1380 <printf+0x30>
      }
    } else if(state == '%'){
    13b3:	83 f9 25             	cmp    $0x25,%ecx
    13b6:	75 ea                	jne    13a2 <printf+0x52>
      if(c == 'd'){
    13b8:	83 f8 25             	cmp    $0x25,%eax
    13bb:	0f 84 07 01 00 00    	je     14c8 <printf+0x178>
    13c1:	83 e8 63             	sub    $0x63,%eax
    13c4:	83 f8 15             	cmp    $0x15,%eax
    13c7:	77 17                	ja     13e0 <printf+0x90>
    13c9:	ff 24 85 1c 18 00 00 	jmp    *0x181c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    13d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13d3:	5b                   	pop    %ebx
    13d4:	5e                   	pop    %esi
    13d5:	5f                   	pop    %edi
    13d6:	5d                   	pop    %ebp
    13d7:	c3                   	ret
    13d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    13df:	00 
  write(fd, &c, 1);
    13e0:	83 ec 04             	sub    $0x4,%esp
    13e3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    13e6:	6a 01                	push   $0x1
    13e8:	57                   	push   %edi
    13e9:	56                   	push   %esi
    13ea:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    13ee:	e8 00 fe ff ff       	call   11f3 <write>
        putc(fd, c);
    13f3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    13f7:	83 c4 0c             	add    $0xc,%esp
    13fa:	88 55 e7             	mov    %dl,-0x19(%ebp)
    13fd:	6a 01                	push   $0x1
    13ff:	57                   	push   %edi
    1400:	56                   	push   %esi
    1401:	e8 ed fd ff ff       	call   11f3 <write>
        putc(fd, c);
    1406:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1409:	31 c9                	xor    %ecx,%ecx
    140b:	eb 95                	jmp    13a2 <printf+0x52>
    140d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1410:	83 ec 0c             	sub    $0xc,%esp
    1413:	b9 10 00 00 00       	mov    $0x10,%ecx
    1418:	6a 00                	push   $0x0
    141a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    141d:	8b 10                	mov    (%eax),%edx
    141f:	89 f0                	mov    %esi,%eax
    1421:	e8 7a fe ff ff       	call   12a0 <printint>
        ap++;
    1426:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    142a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    142d:	31 c9                	xor    %ecx,%ecx
    142f:	e9 6e ff ff ff       	jmp    13a2 <printf+0x52>
    1434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1438:	8b 45 d0             	mov    -0x30(%ebp),%eax
    143b:	8b 10                	mov    (%eax),%edx
        ap++;
    143d:	83 c0 04             	add    $0x4,%eax
    1440:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1443:	85 d2                	test   %edx,%edx
    1445:	0f 84 8d 00 00 00    	je     14d8 <printf+0x188>
        while(*s != 0){
    144b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    144e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    1450:	84 c0                	test   %al,%al
    1452:	0f 84 4a ff ff ff    	je     13a2 <printf+0x52>
    1458:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    145b:	89 d3                	mov    %edx,%ebx
    145d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1460:	83 ec 04             	sub    $0x4,%esp
          s++;
    1463:	83 c3 01             	add    $0x1,%ebx
    1466:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1469:	6a 01                	push   $0x1
    146b:	57                   	push   %edi
    146c:	56                   	push   %esi
    146d:	e8 81 fd ff ff       	call   11f3 <write>
        while(*s != 0){
    1472:	0f b6 03             	movzbl (%ebx),%eax
    1475:	83 c4 10             	add    $0x10,%esp
    1478:	84 c0                	test   %al,%al
    147a:	75 e4                	jne    1460 <printf+0x110>
      state = 0;
    147c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    147f:	31 c9                	xor    %ecx,%ecx
    1481:	e9 1c ff ff ff       	jmp    13a2 <printf+0x52>
    1486:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    148d:	00 
    148e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    1490:	83 ec 0c             	sub    $0xc,%esp
    1493:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1498:	6a 01                	push   $0x1
    149a:	e9 7b ff ff ff       	jmp    141a <printf+0xca>
    149f:	90                   	nop
        putc(fd, *ap);
    14a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    14a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    14a6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    14a8:	6a 01                	push   $0x1
    14aa:	57                   	push   %edi
    14ab:	56                   	push   %esi
        putc(fd, *ap);
    14ac:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    14af:	e8 3f fd ff ff       	call   11f3 <write>
        ap++;
    14b4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    14b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14bb:	31 c9                	xor    %ecx,%ecx
    14bd:	e9 e0 fe ff ff       	jmp    13a2 <printf+0x52>
    14c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    14c8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    14cb:	83 ec 04             	sub    $0x4,%esp
    14ce:	e9 2a ff ff ff       	jmp    13fd <printf+0xad>
    14d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          s = "(null)";
    14d8:	ba 6c 17 00 00       	mov    $0x176c,%edx
        while(*s != 0){
    14dd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    14e0:	b8 28 00 00 00       	mov    $0x28,%eax
    14e5:	89 d3                	mov    %edx,%ebx
    14e7:	e9 74 ff ff ff       	jmp    1460 <printf+0x110>
    14ec:	66 90                	xchg   %ax,%ax
    14ee:	66 90                	xchg   %ax,%ax

000014f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    14f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    14f1:	a1 84 1f 00 00       	mov    0x1f84,%eax
{
    14f6:	89 e5                	mov    %esp,%ebp
    14f8:	57                   	push   %edi
    14f9:	56                   	push   %esi
    14fa:	53                   	push   %ebx
    14fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    14fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1508:	89 c2                	mov    %eax,%edx
    150a:	8b 00                	mov    (%eax),%eax
    150c:	39 ca                	cmp    %ecx,%edx
    150e:	73 30                	jae    1540 <free+0x50>
    1510:	39 c1                	cmp    %eax,%ecx
    1512:	72 04                	jb     1518 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1514:	39 c2                	cmp    %eax,%edx
    1516:	72 f0                	jb     1508 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1518:	8b 73 fc             	mov    -0x4(%ebx),%esi
    151b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    151e:	39 f8                	cmp    %edi,%eax
    1520:	74 30                	je     1552 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1522:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1525:	8b 42 04             	mov    0x4(%edx),%eax
    1528:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    152b:	39 f1                	cmp    %esi,%ecx
    152d:	74 3a                	je     1569 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    152f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1531:	5b                   	pop    %ebx
  freep = p;
    1532:	89 15 84 1f 00 00    	mov    %edx,0x1f84
}
    1538:	5e                   	pop    %esi
    1539:	5f                   	pop    %edi
    153a:	5d                   	pop    %ebp
    153b:	c3                   	ret
    153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1540:	39 c2                	cmp    %eax,%edx
    1542:	72 c4                	jb     1508 <free+0x18>
    1544:	39 c1                	cmp    %eax,%ecx
    1546:	73 c0                	jae    1508 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    1548:	8b 73 fc             	mov    -0x4(%ebx),%esi
    154b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    154e:	39 f8                	cmp    %edi,%eax
    1550:	75 d0                	jne    1522 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    1552:	03 70 04             	add    0x4(%eax),%esi
    1555:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1558:	8b 02                	mov    (%edx),%eax
    155a:	8b 00                	mov    (%eax),%eax
    155c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    155f:	8b 42 04             	mov    0x4(%edx),%eax
    1562:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    1565:	39 f1                	cmp    %esi,%ecx
    1567:	75 c6                	jne    152f <free+0x3f>
    p->s.size += bp->s.size;
    1569:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    156c:	89 15 84 1f 00 00    	mov    %edx,0x1f84
    p->s.size += bp->s.size;
    1572:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    1575:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    1578:	89 0a                	mov    %ecx,(%edx)
}
    157a:	5b                   	pop    %ebx
    157b:	5e                   	pop    %esi
    157c:	5f                   	pop    %edi
    157d:	5d                   	pop    %ebp
    157e:	c3                   	ret
    157f:	90                   	nop

00001580 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1580:	55                   	push   %ebp
    1581:	89 e5                	mov    %esp,%ebp
    1583:	57                   	push   %edi
    1584:	56                   	push   %esi
    1585:	53                   	push   %ebx
    1586:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1589:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    158c:	8b 3d 84 1f 00 00    	mov    0x1f84,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1592:	8d 70 07             	lea    0x7(%eax),%esi
    1595:	c1 ee 03             	shr    $0x3,%esi
    1598:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    159b:	85 ff                	test   %edi,%edi
    159d:	0f 84 9d 00 00 00    	je     1640 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15a3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    15a5:	8b 4a 04             	mov    0x4(%edx),%ecx
    15a8:	39 f1                	cmp    %esi,%ecx
    15aa:	73 6a                	jae    1616 <malloc+0x96>
    15ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
    15b1:	39 de                	cmp    %ebx,%esi
    15b3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    15b6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    15bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    15c0:	eb 17                	jmp    15d9 <malloc+0x59>
    15c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15c8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    15ca:	8b 48 04             	mov    0x4(%eax),%ecx
    15cd:	39 f1                	cmp    %esi,%ecx
    15cf:	73 4f                	jae    1620 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    15d1:	8b 3d 84 1f 00 00    	mov    0x1f84,%edi
    15d7:	89 c2                	mov    %eax,%edx
    15d9:	39 d7                	cmp    %edx,%edi
    15db:	75 eb                	jne    15c8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    15dd:	83 ec 0c             	sub    $0xc,%esp
    15e0:	ff 75 e4             	push   -0x1c(%ebp)
    15e3:	e8 73 fc ff ff       	call   125b <sbrk>
  if(p == (char*)-1)
    15e8:	83 c4 10             	add    $0x10,%esp
    15eb:	83 f8 ff             	cmp    $0xffffffff,%eax
    15ee:	74 1c                	je     160c <malloc+0x8c>
  hp->s.size = nu;
    15f0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    15f3:	83 ec 0c             	sub    $0xc,%esp
    15f6:	83 c0 08             	add    $0x8,%eax
    15f9:	50                   	push   %eax
    15fa:	e8 f1 fe ff ff       	call   14f0 <free>
  return freep;
    15ff:	8b 15 84 1f 00 00    	mov    0x1f84,%edx
      if((p = morecore(nunits)) == 0)
    1605:	83 c4 10             	add    $0x10,%esp
    1608:	85 d2                	test   %edx,%edx
    160a:	75 bc                	jne    15c8 <malloc+0x48>
        return 0;
  }
}
    160c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    160f:	31 c0                	xor    %eax,%eax
}
    1611:	5b                   	pop    %ebx
    1612:	5e                   	pop    %esi
    1613:	5f                   	pop    %edi
    1614:	5d                   	pop    %ebp
    1615:	c3                   	ret
    if(p->s.size >= nunits){
    1616:	89 d0                	mov    %edx,%eax
    1618:	89 fa                	mov    %edi,%edx
    161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1620:	39 ce                	cmp    %ecx,%esi
    1622:	74 4c                	je     1670 <malloc+0xf0>
        p->s.size -= nunits;
    1624:	29 f1                	sub    %esi,%ecx
    1626:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1629:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    162c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    162f:	89 15 84 1f 00 00    	mov    %edx,0x1f84
}
    1635:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1638:	83 c0 08             	add    $0x8,%eax
}
    163b:	5b                   	pop    %ebx
    163c:	5e                   	pop    %esi
    163d:	5f                   	pop    %edi
    163e:	5d                   	pop    %ebp
    163f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
    1640:	c7 05 84 1f 00 00 88 	movl   $0x1f88,0x1f84
    1647:	1f 00 00 
    base.s.size = 0;
    164a:	bf 88 1f 00 00       	mov    $0x1f88,%edi
    base.s.ptr = freep = prevp = &base;
    164f:	c7 05 88 1f 00 00 88 	movl   $0x1f88,0x1f88
    1656:	1f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1659:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    165b:	c7 05 8c 1f 00 00 00 	movl   $0x0,0x1f8c
    1662:	00 00 00 
    if(p->s.size >= nunits){
    1665:	e9 42 ff ff ff       	jmp    15ac <malloc+0x2c>
    166a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1670:	8b 08                	mov    (%eax),%ecx
    1672:	89 0a                	mov    %ecx,(%edx)
    1674:	eb b9                	jmp    162f <malloc+0xaf>
