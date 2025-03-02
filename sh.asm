
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
      1b:	0f 8f 91 00 00 00    	jg     b2 <main+0xb2>
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 61 13 00 00       	push   $0x1361
      2b:	e8 43 0e 00 00       	call   e73 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	eb 2e                	jmp    67 <main+0x67>
      39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      40:	80 3d 02 1a 00 00 20 	cmpb   $0x20,0x1a02
      47:	0f 84 88 00 00 00    	je     d5 <main+0xd5>
      4d:	8d 76 00             	lea    0x0(%esi),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      50:	e8 d6 0d 00 00       	call   e2b <fork>
  if(pid == -1)
      55:	83 f8 ff             	cmp    $0xffffffff,%eax
      58:	0f 84 c1 00 00 00    	je     11f <main+0x11f>
    if(fork1() == 0)
      5e:	85 c0                	test   %eax,%eax
      60:	74 5e                	je     c0 <main+0xc0>
    wait();
      62:	e8 d4 0d 00 00       	call   e3b <wait>
  printf(2, "$ ");
      67:	83 ec 08             	sub    $0x8,%esp
      6a:	68 c8 12 00 00       	push   $0x12c8
      6f:	6a 02                	push   $0x2
      71:	e8 2a 0f 00 00       	call   fa0 <printf>
  memset(buf, 0, nbuf);
      76:	83 c4 0c             	add    $0xc,%esp
      79:	6a 64                	push   $0x64
      7b:	6a 00                	push   $0x0
      7d:	68 00 1a 00 00       	push   $0x1a00
      82:	e8 19 0c 00 00       	call   ca0 <memset>
  gets(buf, nbuf);
      87:	58                   	pop    %eax
      88:	5a                   	pop    %edx
      89:	6a 64                	push   $0x64
      8b:	68 00 1a 00 00       	push   $0x1a00
      90:	e8 6b 0c 00 00       	call   d00 <gets>
  if(buf[0] == 0) // EOF
      95:	0f b6 05 00 1a 00 00 	movzbl 0x1a00,%eax
      9c:	83 c4 10             	add    $0x10,%esp
      9f:	84 c0                	test   %al,%al
      a1:	74 77                	je     11a <main+0x11a>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      a3:	3c 63                	cmp    $0x63,%al
      a5:	75 a9                	jne    50 <main+0x50>
      a7:	80 3d 01 1a 00 00 64 	cmpb   $0x64,0x1a01
      ae:	75 a0                	jne    50 <main+0x50>
      b0:	eb 8e                	jmp    40 <main+0x40>
      close(fd);
      b2:	83 ec 0c             	sub    $0xc,%esp
      b5:	50                   	push   %eax
      b6:	e8 a0 0d 00 00       	call   e5b <close>
      break;
      bb:	83 c4 10             	add    $0x10,%esp
      be:	eb a7                	jmp    67 <main+0x67>
      runcmd(parsecmd(buf));
      c0:	83 ec 0c             	sub    $0xc,%esp
      c3:	68 00 1a 00 00       	push   $0x1a00
      c8:	e8 a3 0a 00 00       	call   b70 <parsecmd>
      cd:	89 04 24             	mov    %eax,(%esp)
      d0:	e8 db 00 00 00       	call   1b0 <runcmd>
      buf[strlen(buf)-1] = 0;  // chop \n
      d5:	83 ec 0c             	sub    $0xc,%esp
      d8:	68 00 1a 00 00       	push   $0x1a00
      dd:	e8 8e 0b 00 00       	call   c70 <strlen>
      if(chdir(buf+3) < 0)
      e2:	c7 04 24 03 1a 00 00 	movl   $0x1a03,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      e9:	c6 80 ff 19 00 00 00 	movb   $0x0,0x19ff(%eax)
      if(chdir(buf+3) < 0)
      f0:	e8 ae 0d 00 00       	call   ea3 <chdir>
      f5:	83 c4 10             	add    $0x10,%esp
      f8:	85 c0                	test   %eax,%eax
      fa:	0f 89 67 ff ff ff    	jns    67 <main+0x67>
        printf(2, "cannot cd %s\n", buf+3);
     100:	51                   	push   %ecx
     101:	68 03 1a 00 00       	push   $0x1a03
     106:	68 69 13 00 00       	push   $0x1369
     10b:	6a 02                	push   $0x2
     10d:	e8 8e 0e 00 00       	call   fa0 <printf>
     112:	83 c4 10             	add    $0x10,%esp
     115:	e9 4d ff ff ff       	jmp    67 <main+0x67>
  exit();
     11a:	e8 14 0d 00 00       	call   e33 <exit>
    panic("fork");
     11f:	83 ec 0c             	sub    $0xc,%esp
     122:	68 cb 12 00 00       	push   $0x12cb
     127:	e8 44 00 00 00       	call   170 <panic>
     12c:	66 90                	xchg   %ax,%ax
     12e:	66 90                	xchg   %ax,%ax

00000130 <getcmd>:
{
     130:	55                   	push   %ebp
     131:	89 e5                	mov    %esp,%ebp
     133:	56                   	push   %esi
     134:	53                   	push   %ebx
     135:	8b 75 0c             	mov    0xc(%ebp),%esi
     138:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     13b:	83 ec 08             	sub    $0x8,%esp
     13e:	68 c8 12 00 00       	push   $0x12c8
     143:	6a 02                	push   $0x2
     145:	e8 56 0e 00 00       	call   fa0 <printf>
  memset(buf, 0, nbuf);
     14a:	83 c4 0c             	add    $0xc,%esp
     14d:	56                   	push   %esi
     14e:	6a 00                	push   $0x0
     150:	53                   	push   %ebx
     151:	e8 4a 0b 00 00       	call   ca0 <memset>
  gets(buf, nbuf);
     156:	58                   	pop    %eax
     157:	5a                   	pop    %edx
     158:	56                   	push   %esi
     159:	53                   	push   %ebx
     15a:	e8 a1 0b 00 00       	call   d00 <gets>
  if(buf[0] == 0) // EOF
     15f:	83 c4 10             	add    $0x10,%esp
     162:	80 3b 01             	cmpb   $0x1,(%ebx)
     165:	19 c0                	sbb    %eax,%eax
}
     167:	8d 65 f8             	lea    -0x8(%ebp),%esp
     16a:	5b                   	pop    %ebx
     16b:	5e                   	pop    %esi
     16c:	5d                   	pop    %ebp
     16d:	c3                   	ret
     16e:	66 90                	xchg   %ax,%ax

00000170 <panic>:
{
     170:	55                   	push   %ebp
     171:	89 e5                	mov    %esp,%ebp
     173:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     176:	ff 75 08             	push   0x8(%ebp)
     179:	68 5d 13 00 00       	push   $0x135d
     17e:	6a 02                	push   $0x2
     180:	e8 1b 0e 00 00       	call   fa0 <printf>
  exit();
     185:	e8 a9 0c 00 00       	call   e33 <exit>
     18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000190 <fork1>:
{
     190:	55                   	push   %ebp
     191:	89 e5                	mov    %esp,%ebp
     193:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     196:	e8 90 0c 00 00       	call   e2b <fork>
  if(pid == -1)
     19b:	83 f8 ff             	cmp    $0xffffffff,%eax
     19e:	74 02                	je     1a2 <fork1+0x12>
  return pid;
}
     1a0:	c9                   	leave
     1a1:	c3                   	ret
    panic("fork");
     1a2:	83 ec 0c             	sub    $0xc,%esp
     1a5:	68 cb 12 00 00       	push   $0x12cb
     1aa:	e8 c1 ff ff ff       	call   170 <panic>
     1af:	90                   	nop

000001b0 <runcmd>:
{
     1b0:	55                   	push   %ebp
     1b1:	89 e5                	mov    %esp,%ebp
     1b3:	53                   	push   %ebx
     1b4:	83 ec 14             	sub    $0x14,%esp
     1b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     1ba:	85 db                	test   %ebx,%ebx
     1bc:	74 1f                	je     1dd <runcmd+0x2d>
  switch(cmd->type){
     1be:	83 3b 05             	cmpl   $0x5,(%ebx)
     1c1:	0f 87 ef 00 00 00    	ja     2b6 <runcmd+0x106>
     1c7:	8b 03                	mov    (%ebx),%eax
     1c9:	ff 24 85 80 13 00 00 	jmp    *0x1380(,%eax,4)
    if(fork1() == 0)
     1d0:	e8 bb ff ff ff       	call   190 <fork1>
     1d5:	85 c0                	test   %eax,%eax
     1d7:	0f 84 ce 00 00 00    	je     2ab <runcmd+0xfb>
    exit();
     1dd:	e8 51 0c 00 00       	call   e33 <exit>
    if (ecmd->argv[0] == 0)
     1e2:	8b 43 04             	mov    0x4(%ebx),%eax
     1e5:	85 c0                	test   %eax,%eax
     1e7:	74 f4                	je     1dd <runcmd+0x2d>
    if (strcmp(ecmd->argv[0], "unblock") == 0) {
     1e9:	52                   	push   %edx
     1ea:	52                   	push   %edx
     1eb:	68 d7 12 00 00       	push   $0x12d7
     1f0:	50                   	push   %eax
     1f1:	e8 1a 0a 00 00       	call   c10 <strcmp>
     1f6:	83 c4 10             	add    $0x10,%esp
     1f9:	85 c0                	test   %eax,%eax
     1fb:	0f 84 12 01 00 00    	je     313 <runcmd+0x163>
    exec(ecmd->argv[0], ecmd->argv);
     201:	8d 43 04             	lea    0x4(%ebx),%eax
     204:	51                   	push   %ecx
     205:	51                   	push   %ecx
     206:	50                   	push   %eax
     207:	ff 73 04             	push   0x4(%ebx)
     20a:	e8 5c 0c 00 00       	call   e6b <exec>
    exit();
     20f:	e8 1f 0c 00 00       	call   e33 <exit>
    if(pipe(p) < 0)
     214:	83 ec 0c             	sub    $0xc,%esp
     217:	8d 45 f0             	lea    -0x10(%ebp),%eax
     21a:	50                   	push   %eax
     21b:	e8 23 0c 00 00       	call   e43 <pipe>
     220:	83 c4 10             	add    $0x10,%esp
     223:	85 c0                	test   %eax,%eax
     225:	0f 88 ad 00 00 00    	js     2d8 <runcmd+0x128>
    if(fork1() == 0){
     22b:	e8 60 ff ff ff       	call   190 <fork1>
     230:	85 c0                	test   %eax,%eax
     232:	0f 84 ad 00 00 00    	je     2e5 <runcmd+0x135>
    if(fork1() == 0){
     238:	e8 53 ff ff ff       	call   190 <fork1>
     23d:	85 c0                	test   %eax,%eax
     23f:	0f 85 e0 00 00 00    	jne    325 <runcmd+0x175>
      close(0);
     245:	83 ec 0c             	sub    $0xc,%esp
     248:	6a 00                	push   $0x0
     24a:	e8 0c 0c 00 00       	call   e5b <close>
      dup(p[0]);
     24f:	5a                   	pop    %edx
     250:	ff 75 f0             	push   -0x10(%ebp)
     253:	e8 53 0c 00 00       	call   eab <dup>
      close(p[0]);
     258:	59                   	pop    %ecx
     259:	ff 75 f0             	push   -0x10(%ebp)
     25c:	e8 fa 0b 00 00       	call   e5b <close>
      close(p[1]);
     261:	58                   	pop    %eax
     262:	ff 75 f4             	push   -0xc(%ebp)
     265:	e8 f1 0b 00 00       	call   e5b <close>
      runcmd(pcmd->right);
     26a:	58                   	pop    %eax
     26b:	ff 73 08             	push   0x8(%ebx)
     26e:	e8 3d ff ff ff       	call   1b0 <runcmd>
    if(fork1() == 0)
     273:	e8 18 ff ff ff       	call   190 <fork1>
     278:	85 c0                	test   %eax,%eax
     27a:	74 2f                	je     2ab <runcmd+0xfb>
    wait();
     27c:	e8 ba 0b 00 00       	call   e3b <wait>
    runcmd(lcmd->right);
     281:	83 ec 0c             	sub    $0xc,%esp
     284:	ff 73 08             	push   0x8(%ebx)
     287:	e8 24 ff ff ff       	call   1b0 <runcmd>
    close(rcmd->fd);
     28c:	83 ec 0c             	sub    $0xc,%esp
     28f:	ff 73 14             	push   0x14(%ebx)
     292:	e8 c4 0b 00 00       	call   e5b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     297:	58                   	pop    %eax
     298:	5a                   	pop    %edx
     299:	ff 73 10             	push   0x10(%ebx)
     29c:	ff 73 08             	push   0x8(%ebx)
     29f:	e8 cf 0b 00 00       	call   e73 <open>
     2a4:	83 c4 10             	add    $0x10,%esp
     2a7:	85 c0                	test   %eax,%eax
     2a9:	78 18                	js     2c3 <runcmd+0x113>
      runcmd(bcmd->cmd);
     2ab:	83 ec 0c             	sub    $0xc,%esp
     2ae:	ff 73 04             	push   0x4(%ebx)
     2b1:	e8 fa fe ff ff       	call   1b0 <runcmd>
    panic("runcmd");
     2b6:	83 ec 0c             	sub    $0xc,%esp
     2b9:	68 d0 12 00 00       	push   $0x12d0
     2be:	e8 ad fe ff ff       	call   170 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     2c3:	51                   	push   %ecx
     2c4:	ff 73 08             	push   0x8(%ebx)
     2c7:	68 df 12 00 00       	push   $0x12df
     2cc:	6a 02                	push   $0x2
     2ce:	e8 cd 0c 00 00       	call   fa0 <printf>
      exit();
     2d3:	e8 5b 0b 00 00       	call   e33 <exit>
      panic("pipe");
     2d8:	83 ec 0c             	sub    $0xc,%esp
     2db:	68 ef 12 00 00       	push   $0x12ef
     2e0:	e8 8b fe ff ff       	call   170 <panic>
      close(1);
     2e5:	83 ec 0c             	sub    $0xc,%esp
     2e8:	6a 01                	push   $0x1
     2ea:	e8 6c 0b 00 00       	call   e5b <close>
      dup(p[1]);
     2ef:	58                   	pop    %eax
     2f0:	ff 75 f4             	push   -0xc(%ebp)
     2f3:	e8 b3 0b 00 00       	call   eab <dup>
      close(p[0]);
     2f8:	58                   	pop    %eax
     2f9:	ff 75 f0             	push   -0x10(%ebp)
     2fc:	e8 5a 0b 00 00       	call   e5b <close>
      close(p[1]);
     301:	58                   	pop    %eax
     302:	ff 75 f4             	push   -0xc(%ebp)
     305:	e8 51 0b 00 00       	call   e5b <close>
      runcmd(pcmd->left);
     30a:	5a                   	pop    %edx
     30b:	ff 73 04             	push   0x4(%ebx)
     30e:	e8 9d fe ff ff       	call   1b0 <runcmd>
        unblock(SYS_exec);
     313:	83 ec 0c             	sub    $0xc,%esp
     316:	6a 07                	push   $0x7
     318:	e8 c6 0b 00 00       	call   ee3 <unblock>
     31d:	83 c4 10             	add    $0x10,%esp
     320:	e9 dc fe ff ff       	jmp    201 <runcmd+0x51>
    close(p[0]);
     325:	83 ec 0c             	sub    $0xc,%esp
     328:	ff 75 f0             	push   -0x10(%ebp)
     32b:	e8 2b 0b 00 00       	call   e5b <close>
    close(p[1]);
     330:	58                   	pop    %eax
     331:	ff 75 f4             	push   -0xc(%ebp)
     334:	e8 22 0b 00 00       	call   e5b <close>
    wait();
     339:	e8 fd 0a 00 00       	call   e3b <wait>
    wait();
     33e:	e8 f8 0a 00 00       	call   e3b <wait>
    break;
     343:	83 c4 10             	add    $0x10,%esp
     346:	e9 92 fe ff ff       	jmp    1dd <runcmd+0x2d>
     34b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000350 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     350:	55                   	push   %ebp
     351:	89 e5                	mov    %esp,%ebp
     353:	53                   	push   %ebx
     354:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     357:	6a 54                	push   $0x54
     359:	e8 72 0e 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     35e:	83 c4 0c             	add    $0xc,%esp
     361:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     363:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     365:	6a 00                	push   $0x0
     367:	50                   	push   %eax
     368:	e8 33 09 00 00       	call   ca0 <memset>
  cmd->type = EXEC;
     36d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     373:	89 d8                	mov    %ebx,%eax
     375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     378:	c9                   	leave
     379:	c3                   	ret
     37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000380 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	53                   	push   %ebx
     384:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     387:	6a 18                	push   $0x18
     389:	e8 42 0e 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     38e:	83 c4 0c             	add    $0xc,%esp
     391:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     393:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     395:	6a 00                	push   $0x0
     397:	50                   	push   %eax
     398:	e8 03 09 00 00       	call   ca0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     39d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     3a0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     3a6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ac:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3af:	8b 45 10             	mov    0x10(%ebp),%eax
     3b2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3b5:	8b 45 14             	mov    0x14(%ebp),%eax
     3b8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3bb:	8b 45 18             	mov    0x18(%ebp),%eax
     3be:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3c1:	89 d8                	mov    %ebx,%eax
     3c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3c6:	c9                   	leave
     3c7:	c3                   	ret
     3c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3cf:	00 

000003d0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	53                   	push   %ebx
     3d4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3d7:	6a 0c                	push   $0xc
     3d9:	e8 f2 0d 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3de:	83 c4 0c             	add    $0xc,%esp
     3e1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     3e3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3e5:	6a 00                	push   $0x0
     3e7:	50                   	push   %eax
     3e8:	e8 b3 08 00 00       	call   ca0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     3ed:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     3f0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     3f6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3fc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     3ff:	89 d8                	mov    %ebx,%eax
     401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     404:	c9                   	leave
     405:	c3                   	ret
     406:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     40d:	00 
     40e:	66 90                	xchg   %ax,%ax

00000410 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	53                   	push   %ebx
     414:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     417:	6a 0c                	push   $0xc
     419:	e8 b2 0d 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     41e:	83 c4 0c             	add    $0xc,%esp
     421:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     423:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     425:	6a 00                	push   $0x0
     427:	50                   	push   %eax
     428:	e8 73 08 00 00       	call   ca0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     42d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     430:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     436:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     439:	8b 45 0c             	mov    0xc(%ebp),%eax
     43c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     43f:	89 d8                	mov    %ebx,%eax
     441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     444:	c9                   	leave
     445:	c3                   	ret
     446:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     44d:	00 
     44e:	66 90                	xchg   %ax,%ax

00000450 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     450:	55                   	push   %ebp
     451:	89 e5                	mov    %esp,%ebp
     453:	53                   	push   %ebx
     454:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     457:	6a 08                	push   $0x8
     459:	e8 72 0d 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     45e:	83 c4 0c             	add    $0xc,%esp
     461:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     463:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     465:	6a 00                	push   $0x0
     467:	50                   	push   %eax
     468:	e8 33 08 00 00       	call   ca0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     46d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     470:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     476:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     479:	89 d8                	mov    %ebx,%eax
     47b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     47e:	c9                   	leave
     47f:	c3                   	ret

00000480 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     480:	55                   	push   %ebp
     481:	89 e5                	mov    %esp,%ebp
     483:	57                   	push   %edi
     484:	56                   	push   %esi
     485:	53                   	push   %ebx
     486:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     489:	8b 45 08             	mov    0x8(%ebp),%eax
{
     48c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     48f:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     492:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     494:	39 df                	cmp    %ebx,%edi
     496:	72 0f                	jb     4a7 <gettoken+0x27>
     498:	eb 25                	jmp    4bf <gettoken+0x3f>
     49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     4a0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     4a3:	39 fb                	cmp    %edi,%ebx
     4a5:	74 18                	je     4bf <gettoken+0x3f>
     4a7:	0f be 07             	movsbl (%edi),%eax
     4aa:	83 ec 08             	sub    $0x8,%esp
     4ad:	50                   	push   %eax
     4ae:	68 e4 19 00 00       	push   $0x19e4
     4b3:	e8 08 08 00 00       	call   cc0 <strchr>
     4b8:	83 c4 10             	add    $0x10,%esp
     4bb:	85 c0                	test   %eax,%eax
     4bd:	75 e1                	jne    4a0 <gettoken+0x20>
  if(q)
     4bf:	85 f6                	test   %esi,%esi
     4c1:	74 02                	je     4c5 <gettoken+0x45>
    *q = s;
     4c3:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     4c5:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     4c8:	3c 3c                	cmp    $0x3c,%al
     4ca:	0f 8f d0 00 00 00    	jg     5a0 <gettoken+0x120>
     4d0:	3c 3a                	cmp    $0x3a,%al
     4d2:	0f 8f b4 00 00 00    	jg     58c <gettoken+0x10c>
     4d8:	84 c0                	test   %al,%al
     4da:	75 44                	jne    520 <gettoken+0xa0>
     4dc:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     4de:	8b 55 14             	mov    0x14(%ebp),%edx
     4e1:	85 d2                	test   %edx,%edx
     4e3:	74 05                	je     4ea <gettoken+0x6a>
    *eq = s;
     4e5:	8b 45 14             	mov    0x14(%ebp),%eax
     4e8:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     4ea:	39 df                	cmp    %ebx,%edi
     4ec:	72 09                	jb     4f7 <gettoken+0x77>
     4ee:	eb 1f                	jmp    50f <gettoken+0x8f>
    s++;
     4f0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     4f3:	39 fb                	cmp    %edi,%ebx
     4f5:	74 18                	je     50f <gettoken+0x8f>
     4f7:	0f be 07             	movsbl (%edi),%eax
     4fa:	83 ec 08             	sub    $0x8,%esp
     4fd:	50                   	push   %eax
     4fe:	68 e4 19 00 00       	push   $0x19e4
     503:	e8 b8 07 00 00       	call   cc0 <strchr>
     508:	83 c4 10             	add    $0x10,%esp
     50b:	85 c0                	test   %eax,%eax
     50d:	75 e1                	jne    4f0 <gettoken+0x70>
  *ps = s;
     50f:	8b 45 08             	mov    0x8(%ebp),%eax
     512:	89 38                	mov    %edi,(%eax)
  return ret;
}
     514:	8d 65 f4             	lea    -0xc(%ebp),%esp
     517:	89 f0                	mov    %esi,%eax
     519:	5b                   	pop    %ebx
     51a:	5e                   	pop    %esi
     51b:	5f                   	pop    %edi
     51c:	5d                   	pop    %ebp
     51d:	c3                   	ret
     51e:	66 90                	xchg   %ax,%ax
  switch(*s){
     520:	79 5e                	jns    580 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     522:	39 fb                	cmp    %edi,%ebx
     524:	77 34                	ja     55a <gettoken+0xda>
  if(eq)
     526:	8b 45 14             	mov    0x14(%ebp),%eax
     529:	be 61 00 00 00       	mov    $0x61,%esi
     52e:	85 c0                	test   %eax,%eax
     530:	75 b3                	jne    4e5 <gettoken+0x65>
     532:	eb db                	jmp    50f <gettoken+0x8f>
     534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     538:	0f be 07             	movsbl (%edi),%eax
     53b:	83 ec 08             	sub    $0x8,%esp
     53e:	50                   	push   %eax
     53f:	68 dc 19 00 00       	push   $0x19dc
     544:	e8 77 07 00 00       	call   cc0 <strchr>
     549:	83 c4 10             	add    $0x10,%esp
     54c:	85 c0                	test   %eax,%eax
     54e:	75 22                	jne    572 <gettoken+0xf2>
      s++;
     550:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     553:	39 fb                	cmp    %edi,%ebx
     555:	74 cf                	je     526 <gettoken+0xa6>
     557:	0f b6 07             	movzbl (%edi),%eax
     55a:	83 ec 08             	sub    $0x8,%esp
     55d:	0f be f0             	movsbl %al,%esi
     560:	56                   	push   %esi
     561:	68 e4 19 00 00       	push   $0x19e4
     566:	e8 55 07 00 00       	call   cc0 <strchr>
     56b:	83 c4 10             	add    $0x10,%esp
     56e:	85 c0                	test   %eax,%eax
     570:	74 c6                	je     538 <gettoken+0xb8>
    ret = 'a';
     572:	be 61 00 00 00       	mov    $0x61,%esi
     577:	e9 62 ff ff ff       	jmp    4de <gettoken+0x5e>
     57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     580:	3c 26                	cmp    $0x26,%al
     582:	74 08                	je     58c <gettoken+0x10c>
     584:	8d 48 d8             	lea    -0x28(%eax),%ecx
     587:	80 f9 01             	cmp    $0x1,%cl
     58a:	77 96                	ja     522 <gettoken+0xa2>
  ret = *s;
     58c:	0f be f0             	movsbl %al,%esi
    s++;
     58f:	83 c7 01             	add    $0x1,%edi
    break;
     592:	e9 47 ff ff ff       	jmp    4de <gettoken+0x5e>
     597:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     59e:	00 
     59f:	90                   	nop
  switch(*s){
     5a0:	3c 3e                	cmp    $0x3e,%al
     5a2:	75 1c                	jne    5c0 <gettoken+0x140>
    if(*s == '>'){
     5a4:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     5a8:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     5ab:	74 1c                	je     5c9 <gettoken+0x149>
    s++;
     5ad:	89 c7                	mov    %eax,%edi
     5af:	be 3e 00 00 00       	mov    $0x3e,%esi
     5b4:	e9 25 ff ff ff       	jmp    4de <gettoken+0x5e>
     5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     5c0:	3c 7c                	cmp    $0x7c,%al
     5c2:	74 c8                	je     58c <gettoken+0x10c>
     5c4:	e9 59 ff ff ff       	jmp    522 <gettoken+0xa2>
      s++;
     5c9:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     5cc:	be 2b 00 00 00       	mov    $0x2b,%esi
     5d1:	e9 08 ff ff ff       	jmp    4de <gettoken+0x5e>
     5d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     5dd:	00 
     5de:	66 90                	xchg   %ax,%ax

000005e0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     5e0:	55                   	push   %ebp
     5e1:	89 e5                	mov    %esp,%ebp
     5e3:	57                   	push   %edi
     5e4:	56                   	push   %esi
     5e5:	53                   	push   %ebx
     5e6:	83 ec 0c             	sub    $0xc,%esp
     5e9:	8b 7d 08             	mov    0x8(%ebp),%edi
     5ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     5ef:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     5f1:	39 f3                	cmp    %esi,%ebx
     5f3:	72 12                	jb     607 <peek+0x27>
     5f5:	eb 28                	jmp    61f <peek+0x3f>
     5f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     5fe:	00 
     5ff:	90                   	nop
    s++;
     600:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     603:	39 de                	cmp    %ebx,%esi
     605:	74 18                	je     61f <peek+0x3f>
     607:	0f be 03             	movsbl (%ebx),%eax
     60a:	83 ec 08             	sub    $0x8,%esp
     60d:	50                   	push   %eax
     60e:	68 e4 19 00 00       	push   $0x19e4
     613:	e8 a8 06 00 00       	call   cc0 <strchr>
     618:	83 c4 10             	add    $0x10,%esp
     61b:	85 c0                	test   %eax,%eax
     61d:	75 e1                	jne    600 <peek+0x20>
  *ps = s;
     61f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     621:	0f be 03             	movsbl (%ebx),%eax
     624:	31 d2                	xor    %edx,%edx
     626:	84 c0                	test   %al,%al
     628:	75 0e                	jne    638 <peek+0x58>
}
     62a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     62d:	89 d0                	mov    %edx,%eax
     62f:	5b                   	pop    %ebx
     630:	5e                   	pop    %esi
     631:	5f                   	pop    %edi
     632:	5d                   	pop    %ebp
     633:	c3                   	ret
     634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     638:	83 ec 08             	sub    $0x8,%esp
     63b:	50                   	push   %eax
     63c:	ff 75 10             	push   0x10(%ebp)
     63f:	e8 7c 06 00 00       	call   cc0 <strchr>
     644:	83 c4 10             	add    $0x10,%esp
     647:	31 d2                	xor    %edx,%edx
     649:	85 c0                	test   %eax,%eax
     64b:	0f 95 c2             	setne  %dl
}
     64e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     651:	5b                   	pop    %ebx
     652:	89 d0                	mov    %edx,%eax
     654:	5e                   	pop    %esi
     655:	5f                   	pop    %edi
     656:	5d                   	pop    %ebp
     657:	c3                   	ret
     658:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     65f:	00 

00000660 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     660:	55                   	push   %ebp
     661:	89 e5                	mov    %esp,%ebp
     663:	57                   	push   %edi
     664:	56                   	push   %esi
     665:	53                   	push   %ebx
     666:	83 ec 2c             	sub    $0x2c,%esp
     669:	8b 75 0c             	mov    0xc(%ebp),%esi
     66c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     66f:	90                   	nop
     670:	83 ec 04             	sub    $0x4,%esp
     673:	68 11 13 00 00       	push   $0x1311
     678:	53                   	push   %ebx
     679:	56                   	push   %esi
     67a:	e8 61 ff ff ff       	call   5e0 <peek>
     67f:	83 c4 10             	add    $0x10,%esp
     682:	85 c0                	test   %eax,%eax
     684:	0f 84 f6 00 00 00    	je     780 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     68a:	6a 00                	push   $0x0
     68c:	6a 00                	push   $0x0
     68e:	53                   	push   %ebx
     68f:	56                   	push   %esi
     690:	e8 eb fd ff ff       	call   480 <gettoken>
     695:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     697:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     69a:	50                   	push   %eax
     69b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     69e:	50                   	push   %eax
     69f:	53                   	push   %ebx
     6a0:	56                   	push   %esi
     6a1:	e8 da fd ff ff       	call   480 <gettoken>
     6a6:	83 c4 20             	add    $0x20,%esp
     6a9:	83 f8 61             	cmp    $0x61,%eax
     6ac:	0f 85 d9 00 00 00    	jne    78b <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     6b2:	83 ff 3c             	cmp    $0x3c,%edi
     6b5:	74 69                	je     720 <parseredirs+0xc0>
     6b7:	83 ff 3e             	cmp    $0x3e,%edi
     6ba:	74 05                	je     6c1 <parseredirs+0x61>
     6bc:	83 ff 2b             	cmp    $0x2b,%edi
     6bf:	75 af                	jne    670 <parseredirs+0x10>
  cmd = malloc(sizeof(*cmd));
     6c1:	83 ec 0c             	sub    $0xc,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     6c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     6ca:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6cc:	89 55 d0             	mov    %edx,-0x30(%ebp)
     6cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     6d2:	e8 f9 0a 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6d7:	83 c4 0c             	add    $0xc,%esp
     6da:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     6dc:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     6de:	6a 00                	push   $0x0
     6e0:	50                   	push   %eax
     6e1:	e8 ba 05 00 00       	call   ca0 <memset>
  cmd->type = REDIR;
     6e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     6ec:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     6ef:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     6f2:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     6f5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     6f8:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     6fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     6fe:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     705:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     708:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      break;
     70f:	89 7d 08             	mov    %edi,0x8(%ebp)
     712:	e9 59 ff ff ff       	jmp    670 <parseredirs+0x10>
     717:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     71e:	00 
     71f:	90                   	nop
  cmd = malloc(sizeof(*cmd));
     720:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     723:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     726:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     729:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     72b:	89 55 d0             	mov    %edx,-0x30(%ebp)
     72e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     731:	e8 9a 0a 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     736:	83 c4 0c             	add    $0xc,%esp
     739:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     73b:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     73d:	6a 00                	push   $0x0
     73f:	50                   	push   %eax
     740:	e8 5b 05 00 00       	call   ca0 <memset>
  cmd->cmd = subcmd;
     745:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     748:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     74b:	89 7d 08             	mov    %edi,0x8(%ebp)
  cmd->efile = efile;
     74e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     751:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
      break;
     757:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     75a:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     75d:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     760:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     763:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     76a:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      break;
     771:	e9 fa fe ff ff       	jmp    670 <parseredirs+0x10>
     776:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     77d:	00 
     77e:	66 90                	xchg   %ax,%ax
    }
  }
  return cmd;
}
     780:	8b 45 08             	mov    0x8(%ebp),%eax
     783:	8d 65 f4             	lea    -0xc(%ebp),%esp
     786:	5b                   	pop    %ebx
     787:	5e                   	pop    %esi
     788:	5f                   	pop    %edi
     789:	5d                   	pop    %ebp
     78a:	c3                   	ret
      panic("missing file for redirection");
     78b:	83 ec 0c             	sub    $0xc,%esp
     78e:	68 f4 12 00 00       	push   $0x12f4
     793:	e8 d8 f9 ff ff       	call   170 <panic>
     798:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     79f:	00 

000007a0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     7a0:	55                   	push   %ebp
     7a1:	89 e5                	mov    %esp,%ebp
     7a3:	57                   	push   %edi
     7a4:	56                   	push   %esi
     7a5:	53                   	push   %ebx
     7a6:	83 ec 30             	sub    $0x30,%esp
     7a9:	8b 75 08             	mov    0x8(%ebp),%esi
     7ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     7af:	68 14 13 00 00       	push   $0x1314
     7b4:	57                   	push   %edi
     7b5:	56                   	push   %esi
     7b6:	e8 25 fe ff ff       	call   5e0 <peek>
     7bb:	83 c4 10             	add    $0x10,%esp
     7be:	85 c0                	test   %eax,%eax
     7c0:	0f 85 aa 00 00 00    	jne    870 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     7c6:	83 ec 0c             	sub    $0xc,%esp
     7c9:	89 c3                	mov    %eax,%ebx
     7cb:	6a 54                	push   $0x54
     7cd:	e8 fe 09 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     7d2:	83 c4 0c             	add    $0xc,%esp
     7d5:	6a 54                	push   $0x54
     7d7:	6a 00                	push   $0x0
     7d9:	50                   	push   %eax
     7da:	89 45 d0             	mov    %eax,-0x30(%ebp)
     7dd:	e8 be 04 00 00       	call   ca0 <memset>
  cmd->type = EXEC;
     7e2:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7e5:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     7e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     7ee:	57                   	push   %edi
     7ef:	56                   	push   %esi
     7f0:	50                   	push   %eax
     7f1:	e8 6a fe ff ff       	call   660 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     7f6:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     7f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7fc:	eb 15                	jmp    813 <parseexec+0x73>
     7fe:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     800:	83 ec 04             	sub    $0x4,%esp
     803:	57                   	push   %edi
     804:	56                   	push   %esi
     805:	ff 75 d4             	push   -0x2c(%ebp)
     808:	e8 53 fe ff ff       	call   660 <parseredirs>
     80d:	83 c4 10             	add    $0x10,%esp
     810:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     813:	83 ec 04             	sub    $0x4,%esp
     816:	68 2b 13 00 00       	push   $0x132b
     81b:	57                   	push   %edi
     81c:	56                   	push   %esi
     81d:	e8 be fd ff ff       	call   5e0 <peek>
     822:	83 c4 10             	add    $0x10,%esp
     825:	85 c0                	test   %eax,%eax
     827:	75 5f                	jne    888 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     829:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     82c:	50                   	push   %eax
     82d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     830:	50                   	push   %eax
     831:	57                   	push   %edi
     832:	56                   	push   %esi
     833:	e8 48 fc ff ff       	call   480 <gettoken>
     838:	83 c4 10             	add    $0x10,%esp
     83b:	85 c0                	test   %eax,%eax
     83d:	74 49                	je     888 <parseexec+0xe8>
    if(tok != 'a')
     83f:	83 f8 61             	cmp    $0x61,%eax
     842:	75 62                	jne    8a6 <parseexec+0x106>
    cmd->argv[argc] = q;
     844:	8b 45 e0             	mov    -0x20(%ebp),%eax
     847:	8b 55 d0             	mov    -0x30(%ebp),%edx
     84a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     84e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     851:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     855:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     858:	83 fb 0a             	cmp    $0xa,%ebx
     85b:	75 a3                	jne    800 <parseexec+0x60>
      panic("too many args");
     85d:	83 ec 0c             	sub    $0xc,%esp
     860:	68 1d 13 00 00       	push   $0x131d
     865:	e8 06 f9 ff ff       	call   170 <panic>
     86a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     870:	89 7d 0c             	mov    %edi,0xc(%ebp)
     873:	89 75 08             	mov    %esi,0x8(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     876:	8d 65 f4             	lea    -0xc(%ebp),%esp
     879:	5b                   	pop    %ebx
     87a:	5e                   	pop    %esi
     87b:	5f                   	pop    %edi
     87c:	5d                   	pop    %ebp
    return parseblock(ps, es);
     87d:	e9 ae 01 00 00       	jmp    a30 <parseblock>
     882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc] = 0;
     888:	8b 45 d0             	mov    -0x30(%ebp),%eax
     88b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     892:	00 
  cmd->eargv[argc] = 0;
     893:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     89a:	00 
}
     89b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     89e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8a1:	5b                   	pop    %ebx
     8a2:	5e                   	pop    %esi
     8a3:	5f                   	pop    %edi
     8a4:	5d                   	pop    %ebp
     8a5:	c3                   	ret
      panic("syntax");
     8a6:	83 ec 0c             	sub    $0xc,%esp
     8a9:	68 16 13 00 00       	push   $0x1316
     8ae:	e8 bd f8 ff ff       	call   170 <panic>
     8b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8ba:	00 
     8bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

000008c0 <parsepipe>:
{
     8c0:	55                   	push   %ebp
     8c1:	89 e5                	mov    %esp,%ebp
     8c3:	57                   	push   %edi
     8c4:	56                   	push   %esi
     8c5:	53                   	push   %ebx
     8c6:	83 ec 14             	sub    $0x14,%esp
     8c9:	8b 75 08             	mov    0x8(%ebp),%esi
     8cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     8cf:	57                   	push   %edi
     8d0:	56                   	push   %esi
     8d1:	e8 ca fe ff ff       	call   7a0 <parseexec>
  if(peek(ps, es, "|")){
     8d6:	83 c4 0c             	add    $0xc,%esp
     8d9:	68 30 13 00 00       	push   $0x1330
  cmd = parseexec(ps, es);
     8de:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     8e0:	57                   	push   %edi
     8e1:	56                   	push   %esi
     8e2:	e8 f9 fc ff ff       	call   5e0 <peek>
     8e7:	83 c4 10             	add    $0x10,%esp
     8ea:	85 c0                	test   %eax,%eax
     8ec:	75 12                	jne    900 <parsepipe+0x40>
}
     8ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8f1:	89 d8                	mov    %ebx,%eax
     8f3:	5b                   	pop    %ebx
     8f4:	5e                   	pop    %esi
     8f5:	5f                   	pop    %edi
     8f6:	5d                   	pop    %ebp
     8f7:	c3                   	ret
     8f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8ff:	00 
    gettoken(ps, es, 0, 0);
     900:	6a 00                	push   $0x0
     902:	6a 00                	push   $0x0
     904:	57                   	push   %edi
     905:	56                   	push   %esi
     906:	e8 75 fb ff ff       	call   480 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     90b:	58                   	pop    %eax
     90c:	5a                   	pop    %edx
     90d:	57                   	push   %edi
     90e:	56                   	push   %esi
     90f:	e8 ac ff ff ff       	call   8c0 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     914:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     91b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     91d:	e8 ae 08 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     922:	83 c4 0c             	add    $0xc,%esp
     925:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     927:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     929:	6a 00                	push   $0x0
     92b:	50                   	push   %eax
     92c:	e8 6f 03 00 00       	call   ca0 <memset>
  cmd->left = left;
     931:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     934:	83 c4 10             	add    $0x10,%esp
     937:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     939:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     93f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     941:	89 7e 08             	mov    %edi,0x8(%esi)
}
     944:	8d 65 f4             	lea    -0xc(%ebp),%esp
     947:	5b                   	pop    %ebx
     948:	5e                   	pop    %esi
     949:	5f                   	pop    %edi
     94a:	5d                   	pop    %ebp
     94b:	c3                   	ret
     94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000950 <parseline>:
{
     950:	55                   	push   %ebp
     951:	89 e5                	mov    %esp,%ebp
     953:	57                   	push   %edi
     954:	56                   	push   %esi
     955:	53                   	push   %ebx
     956:	83 ec 24             	sub    $0x24,%esp
     959:	8b 75 08             	mov    0x8(%ebp),%esi
     95c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     95f:	57                   	push   %edi
     960:	56                   	push   %esi
     961:	e8 5a ff ff ff       	call   8c0 <parsepipe>
  while(peek(ps, es, "&")){
     966:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     969:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     96b:	eb 3b                	jmp    9a8 <parseline+0x58>
     96d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     970:	6a 00                	push   $0x0
     972:	6a 00                	push   $0x0
     974:	57                   	push   %edi
     975:	56                   	push   %esi
     976:	e8 05 fb ff ff       	call   480 <gettoken>
  cmd = malloc(sizeof(*cmd));
     97b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     982:	e8 49 08 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     987:	83 c4 0c             	add    $0xc,%esp
     98a:	6a 08                	push   $0x8
     98c:	6a 00                	push   $0x0
     98e:	50                   	push   %eax
     98f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     992:	e8 09 03 00 00       	call   ca0 <memset>
  cmd->type = BACK;
     997:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     99a:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     99d:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     9a3:	89 5a 04             	mov    %ebx,0x4(%edx)
     9a6:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     9a8:	83 ec 04             	sub    $0x4,%esp
     9ab:	68 32 13 00 00       	push   $0x1332
     9b0:	57                   	push   %edi
     9b1:	56                   	push   %esi
     9b2:	e8 29 fc ff ff       	call   5e0 <peek>
     9b7:	83 c4 10             	add    $0x10,%esp
     9ba:	85 c0                	test   %eax,%eax
     9bc:	75 b2                	jne    970 <parseline+0x20>
  if(peek(ps, es, ";")){
     9be:	83 ec 04             	sub    $0x4,%esp
     9c1:	68 2e 13 00 00       	push   $0x132e
     9c6:	57                   	push   %edi
     9c7:	56                   	push   %esi
     9c8:	e8 13 fc ff ff       	call   5e0 <peek>
     9cd:	83 c4 10             	add    $0x10,%esp
     9d0:	85 c0                	test   %eax,%eax
     9d2:	75 0c                	jne    9e0 <parseline+0x90>
}
     9d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9d7:	89 d8                	mov    %ebx,%eax
     9d9:	5b                   	pop    %ebx
     9da:	5e                   	pop    %esi
     9db:	5f                   	pop    %edi
     9dc:	5d                   	pop    %ebp
     9dd:	c3                   	ret
     9de:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     9e0:	6a 00                	push   $0x0
     9e2:	6a 00                	push   $0x0
     9e4:	57                   	push   %edi
     9e5:	56                   	push   %esi
     9e6:	e8 95 fa ff ff       	call   480 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     9eb:	58                   	pop    %eax
     9ec:	5a                   	pop    %edx
     9ed:	57                   	push   %edi
     9ee:	56                   	push   %esi
     9ef:	e8 5c ff ff ff       	call   950 <parseline>
  cmd = malloc(sizeof(*cmd));
     9f4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     9fb:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     9fd:	e8 ce 07 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     a02:	83 c4 0c             	add    $0xc,%esp
     a05:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     a07:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     a09:	6a 00                	push   $0x0
     a0b:	50                   	push   %eax
     a0c:	e8 8f 02 00 00       	call   ca0 <memset>
  cmd->left = left;
     a11:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     a14:	83 c4 10             	add    $0x10,%esp
     a17:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     a19:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     a1f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     a21:	89 7e 08             	mov    %edi,0x8(%esi)
}
     a24:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a27:	5b                   	pop    %ebx
     a28:	5e                   	pop    %esi
     a29:	5f                   	pop    %edi
     a2a:	5d                   	pop    %ebp
     a2b:	c3                   	ret
     a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a30 <parseblock>:
{
     a30:	55                   	push   %ebp
     a31:	89 e5                	mov    %esp,%ebp
     a33:	57                   	push   %edi
     a34:	56                   	push   %esi
     a35:	53                   	push   %ebx
     a36:	83 ec 10             	sub    $0x10,%esp
     a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     a3f:	68 14 13 00 00       	push   $0x1314
     a44:	56                   	push   %esi
     a45:	53                   	push   %ebx
     a46:	e8 95 fb ff ff       	call   5e0 <peek>
     a4b:	83 c4 10             	add    $0x10,%esp
     a4e:	85 c0                	test   %eax,%eax
     a50:	74 4a                	je     a9c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     a52:	6a 00                	push   $0x0
     a54:	6a 00                	push   $0x0
     a56:	56                   	push   %esi
     a57:	53                   	push   %ebx
     a58:	e8 23 fa ff ff       	call   480 <gettoken>
  cmd = parseline(ps, es);
     a5d:	58                   	pop    %eax
     a5e:	5a                   	pop    %edx
     a5f:	56                   	push   %esi
     a60:	53                   	push   %ebx
     a61:	e8 ea fe ff ff       	call   950 <parseline>
  if(!peek(ps, es, ")"))
     a66:	83 c4 0c             	add    $0xc,%esp
     a69:	68 50 13 00 00       	push   $0x1350
  cmd = parseline(ps, es);
     a6e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     a70:	56                   	push   %esi
     a71:	53                   	push   %ebx
     a72:	e8 69 fb ff ff       	call   5e0 <peek>
     a77:	83 c4 10             	add    $0x10,%esp
     a7a:	85 c0                	test   %eax,%eax
     a7c:	74 2b                	je     aa9 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     a7e:	6a 00                	push   $0x0
     a80:	6a 00                	push   $0x0
     a82:	56                   	push   %esi
     a83:	53                   	push   %ebx
     a84:	e8 f7 f9 ff ff       	call   480 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a89:	83 c4 0c             	add    $0xc,%esp
     a8c:	56                   	push   %esi
     a8d:	53                   	push   %ebx
     a8e:	57                   	push   %edi
     a8f:	e8 cc fb ff ff       	call   660 <parseredirs>
}
     a94:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a97:	5b                   	pop    %ebx
     a98:	5e                   	pop    %esi
     a99:	5f                   	pop    %edi
     a9a:	5d                   	pop    %ebp
     a9b:	c3                   	ret
    panic("parseblock");
     a9c:	83 ec 0c             	sub    $0xc,%esp
     a9f:	68 34 13 00 00       	push   $0x1334
     aa4:	e8 c7 f6 ff ff       	call   170 <panic>
    panic("syntax - missing )");
     aa9:	83 ec 0c             	sub    $0xc,%esp
     aac:	68 3f 13 00 00       	push   $0x133f
     ab1:	e8 ba f6 ff ff       	call   170 <panic>
     ab6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     abd:	00 
     abe:	66 90                	xchg   %ax,%ax

00000ac0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     ac0:	55                   	push   %ebp
     ac1:	89 e5                	mov    %esp,%ebp
     ac3:	53                   	push   %ebx
     ac4:	83 ec 04             	sub    $0x4,%esp
     ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     aca:	85 db                	test   %ebx,%ebx
     acc:	0f 84 8e 00 00 00    	je     b60 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
     ad2:	83 3b 05             	cmpl   $0x5,(%ebx)
     ad5:	77 61                	ja     b38 <nulterminate+0x78>
     ad7:	8b 03                	mov    (%ebx),%eax
     ad9:	ff 24 85 98 13 00 00 	jmp    *0x1398(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     ae0:	83 ec 0c             	sub    $0xc,%esp
     ae3:	ff 73 04             	push   0x4(%ebx)
     ae6:	e8 d5 ff ff ff       	call   ac0 <nulterminate>
    nulterminate(lcmd->right);
     aeb:	58                   	pop    %eax
     aec:	ff 73 08             	push   0x8(%ebx)
     aef:	e8 cc ff ff ff       	call   ac0 <nulterminate>
    break;
     af4:	83 c4 10             	add    $0x10,%esp
     af7:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     afc:	c9                   	leave
     afd:	c3                   	ret
     afe:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     b00:	83 ec 0c             	sub    $0xc,%esp
     b03:	ff 73 04             	push   0x4(%ebx)
     b06:	e8 b5 ff ff ff       	call   ac0 <nulterminate>
    break;
     b0b:	89 d8                	mov    %ebx,%eax
     b0d:	83 c4 10             	add    $0x10,%esp
}
     b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b13:	c9                   	leave
     b14:	c3                   	ret
     b15:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     b18:	8b 4b 04             	mov    0x4(%ebx),%ecx
     b1b:	8d 43 08             	lea    0x8(%ebx),%eax
     b1e:	85 c9                	test   %ecx,%ecx
     b20:	74 16                	je     b38 <nulterminate+0x78>
     b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     b28:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     b2b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     b2e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     b31:	8b 50 fc             	mov    -0x4(%eax),%edx
     b34:	85 d2                	test   %edx,%edx
     b36:	75 f0                	jne    b28 <nulterminate+0x68>
  switch(cmd->type){
     b38:	89 d8                	mov    %ebx,%eax
}
     b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b3d:	c9                   	leave
     b3e:	c3                   	ret
     b3f:	90                   	nop
    nulterminate(rcmd->cmd);
     b40:	83 ec 0c             	sub    $0xc,%esp
     b43:	ff 73 04             	push   0x4(%ebx)
     b46:	e8 75 ff ff ff       	call   ac0 <nulterminate>
    *rcmd->efile = 0;
     b4b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     b4e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     b51:	c6 00 00             	movb   $0x0,(%eax)
    break;
     b54:	89 d8                	mov    %ebx,%eax
}
     b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b59:	c9                   	leave
     b5a:	c3                   	ret
     b5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return 0;
     b60:	31 c0                	xor    %eax,%eax
     b62:	eb 95                	jmp    af9 <nulterminate+0x39>
     b64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b6b:	00 
     b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b70 <parsecmd>:
{
     b70:	55                   	push   %ebp
     b71:	89 e5                	mov    %esp,%ebp
     b73:	57                   	push   %edi
     b74:	56                   	push   %esi
  cmd = parseline(&s, es);
     b75:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     b78:	53                   	push   %ebx
     b79:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     b7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b7f:	53                   	push   %ebx
     b80:	e8 eb 00 00 00       	call   c70 <strlen>
  cmd = parseline(&s, es);
     b85:	59                   	pop    %ecx
     b86:	5e                   	pop    %esi
  es = s + strlen(s);
     b87:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     b89:	53                   	push   %ebx
     b8a:	57                   	push   %edi
     b8b:	e8 c0 fd ff ff       	call   950 <parseline>
  peek(&s, es, "");
     b90:	83 c4 0c             	add    $0xc,%esp
     b93:	68 ee 12 00 00       	push   $0x12ee
  cmd = parseline(&s, es);
     b98:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     b9a:	53                   	push   %ebx
     b9b:	57                   	push   %edi
     b9c:	e8 3f fa ff ff       	call   5e0 <peek>
  if(s != es){
     ba1:	8b 45 08             	mov    0x8(%ebp),%eax
     ba4:	83 c4 10             	add    $0x10,%esp
     ba7:	39 d8                	cmp    %ebx,%eax
     ba9:	75 13                	jne    bbe <parsecmd+0x4e>
  nulterminate(cmd);
     bab:	83 ec 0c             	sub    $0xc,%esp
     bae:	56                   	push   %esi
     baf:	e8 0c ff ff ff       	call   ac0 <nulterminate>
}
     bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bb7:	89 f0                	mov    %esi,%eax
     bb9:	5b                   	pop    %ebx
     bba:	5e                   	pop    %esi
     bbb:	5f                   	pop    %edi
     bbc:	5d                   	pop    %ebp
     bbd:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
     bbe:	52                   	push   %edx
     bbf:	50                   	push   %eax
     bc0:	68 52 13 00 00       	push   $0x1352
     bc5:	6a 02                	push   $0x2
     bc7:	e8 d4 03 00 00       	call   fa0 <printf>
    panic("syntax");
     bcc:	c7 04 24 16 13 00 00 	movl   $0x1316,(%esp)
     bd3:	e8 98 f5 ff ff       	call   170 <panic>
     bd8:	66 90                	xchg   %ax,%ax
     bda:	66 90                	xchg   %ax,%ax
     bdc:	66 90                	xchg   %ax,%ax
     bde:	66 90                	xchg   %ax,%ax

00000be0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     be0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     be1:	31 c0                	xor    %eax,%eax
{
     be3:	89 e5                	mov    %esp,%ebp
     be5:	53                   	push   %ebx
     be6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     be9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     bf0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     bf4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     bf7:	83 c0 01             	add    $0x1,%eax
     bfa:	84 d2                	test   %dl,%dl
     bfc:	75 f2                	jne    bf0 <strcpy+0x10>
    ;
  return os;
}
     bfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c01:	89 c8                	mov    %ecx,%eax
     c03:	c9                   	leave
     c04:	c3                   	ret
     c05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c0c:	00 
     c0d:	8d 76 00             	lea    0x0(%esi),%esi

00000c10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c10:	55                   	push   %ebp
     c11:	89 e5                	mov    %esp,%ebp
     c13:	53                   	push   %ebx
     c14:	8b 55 08             	mov    0x8(%ebp),%edx
     c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     c1a:	0f b6 02             	movzbl (%edx),%eax
     c1d:	84 c0                	test   %al,%al
     c1f:	75 17                	jne    c38 <strcmp+0x28>
     c21:	eb 3a                	jmp    c5d <strcmp+0x4d>
     c23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     c28:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     c2c:	83 c2 01             	add    $0x1,%edx
     c2f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     c32:	84 c0                	test   %al,%al
     c34:	74 1a                	je     c50 <strcmp+0x40>
    p++, q++;
     c36:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
     c38:	0f b6 19             	movzbl (%ecx),%ebx
     c3b:	38 c3                	cmp    %al,%bl
     c3d:	74 e9                	je     c28 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     c3f:	29 d8                	sub    %ebx,%eax
}
     c41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c44:	c9                   	leave
     c45:	c3                   	ret
     c46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c4d:	00 
     c4e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     c50:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     c54:	31 c0                	xor    %eax,%eax
     c56:	29 d8                	sub    %ebx,%eax
}
     c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c5b:	c9                   	leave
     c5c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     c5d:	0f b6 19             	movzbl (%ecx),%ebx
     c60:	31 c0                	xor    %eax,%eax
     c62:	eb db                	jmp    c3f <strcmp+0x2f>
     c64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c6b:	00 
     c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c70 <strlen>:

uint
strlen(const char *s)
{
     c70:	55                   	push   %ebp
     c71:	89 e5                	mov    %esp,%ebp
     c73:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     c76:	80 3a 00             	cmpb   $0x0,(%edx)
     c79:	74 15                	je     c90 <strlen+0x20>
     c7b:	31 c0                	xor    %eax,%eax
     c7d:	8d 76 00             	lea    0x0(%esi),%esi
     c80:	83 c0 01             	add    $0x1,%eax
     c83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     c87:	89 c1                	mov    %eax,%ecx
     c89:	75 f5                	jne    c80 <strlen+0x10>
    ;
  return n;
}
     c8b:	89 c8                	mov    %ecx,%eax
     c8d:	5d                   	pop    %ebp
     c8e:	c3                   	ret
     c8f:	90                   	nop
  for(n = 0; s[n]; n++)
     c90:	31 c9                	xor    %ecx,%ecx
}
     c92:	5d                   	pop    %ebp
     c93:	89 c8                	mov    %ecx,%eax
     c95:	c3                   	ret
     c96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c9d:	00 
     c9e:	66 90                	xchg   %ax,%ax

00000ca0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     ca0:	55                   	push   %ebp
     ca1:	89 e5                	mov    %esp,%ebp
     ca3:	57                   	push   %edi
     ca4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     ca7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     caa:	8b 45 0c             	mov    0xc(%ebp),%eax
     cad:	89 d7                	mov    %edx,%edi
     caf:	fc                   	cld
     cb0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     cb2:	8b 7d fc             	mov    -0x4(%ebp),%edi
     cb5:	89 d0                	mov    %edx,%eax
     cb7:	c9                   	leave
     cb8:	c3                   	ret
     cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000cc0 <strchr>:

char*
strchr(const char *s, char c)
{
     cc0:	55                   	push   %ebp
     cc1:	89 e5                	mov    %esp,%ebp
     cc3:	8b 45 08             	mov    0x8(%ebp),%eax
     cc6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     cca:	0f b6 10             	movzbl (%eax),%edx
     ccd:	84 d2                	test   %dl,%dl
     ccf:	75 12                	jne    ce3 <strchr+0x23>
     cd1:	eb 1d                	jmp    cf0 <strchr+0x30>
     cd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     cd8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     cdc:	83 c0 01             	add    $0x1,%eax
     cdf:	84 d2                	test   %dl,%dl
     ce1:	74 0d                	je     cf0 <strchr+0x30>
    if(*s == c)
     ce3:	38 d1                	cmp    %dl,%cl
     ce5:	75 f1                	jne    cd8 <strchr+0x18>
      return (char*)s;
  return 0;
}
     ce7:	5d                   	pop    %ebp
     ce8:	c3                   	ret
     ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     cf0:	31 c0                	xor    %eax,%eax
}
     cf2:	5d                   	pop    %ebp
     cf3:	c3                   	ret
     cf4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     cfb:	00 
     cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d00 <gets>:

char*
gets(char *buf, int max)
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	57                   	push   %edi
     d04:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     d05:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
     d08:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     d09:	31 db                	xor    %ebx,%ebx
{
     d0b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     d0e:	eb 27                	jmp    d37 <gets+0x37>
    cc = read(0, &c, 1);
     d10:	83 ec 04             	sub    $0x4,%esp
     d13:	6a 01                	push   $0x1
     d15:	57                   	push   %edi
     d16:	6a 00                	push   $0x0
     d18:	e8 2e 01 00 00       	call   e4b <read>
    if(cc < 1)
     d1d:	83 c4 10             	add    $0x10,%esp
     d20:	85 c0                	test   %eax,%eax
     d22:	7e 1d                	jle    d41 <gets+0x41>
      break;
    buf[i++] = c;
     d24:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     d28:	8b 55 08             	mov    0x8(%ebp),%edx
     d2b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     d2f:	3c 0a                	cmp    $0xa,%al
     d31:	74 1d                	je     d50 <gets+0x50>
     d33:	3c 0d                	cmp    $0xd,%al
     d35:	74 19                	je     d50 <gets+0x50>
  for(i=0; i+1 < max; ){
     d37:	89 de                	mov    %ebx,%esi
     d39:	83 c3 01             	add    $0x1,%ebx
     d3c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     d3f:	7c cf                	jl     d10 <gets+0x10>
      break;
  }
  buf[i] = '\0';
     d41:	8b 45 08             	mov    0x8(%ebp),%eax
     d44:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d4b:	5b                   	pop    %ebx
     d4c:	5e                   	pop    %esi
     d4d:	5f                   	pop    %edi
     d4e:	5d                   	pop    %ebp
     d4f:	c3                   	ret
  buf[i] = '\0';
     d50:	8b 45 08             	mov    0x8(%ebp),%eax
     d53:	89 de                	mov    %ebx,%esi
     d55:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
     d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d5c:	5b                   	pop    %ebx
     d5d:	5e                   	pop    %esi
     d5e:	5f                   	pop    %edi
     d5f:	5d                   	pop    %ebp
     d60:	c3                   	ret
     d61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     d68:	00 
     d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d70 <stat>:

int
stat(const char *n, struct stat *st)
{
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	56                   	push   %esi
     d74:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d75:	83 ec 08             	sub    $0x8,%esp
     d78:	6a 00                	push   $0x0
     d7a:	ff 75 08             	push   0x8(%ebp)
     d7d:	e8 f1 00 00 00       	call   e73 <open>
  if(fd < 0)
     d82:	83 c4 10             	add    $0x10,%esp
     d85:	85 c0                	test   %eax,%eax
     d87:	78 27                	js     db0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     d89:	83 ec 08             	sub    $0x8,%esp
     d8c:	ff 75 0c             	push   0xc(%ebp)
     d8f:	89 c3                	mov    %eax,%ebx
     d91:	50                   	push   %eax
     d92:	e8 f4 00 00 00       	call   e8b <fstat>
  close(fd);
     d97:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     d9a:	89 c6                	mov    %eax,%esi
  close(fd);
     d9c:	e8 ba 00 00 00       	call   e5b <close>
  return r;
     da1:	83 c4 10             	add    $0x10,%esp
}
     da4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     da7:	89 f0                	mov    %esi,%eax
     da9:	5b                   	pop    %ebx
     daa:	5e                   	pop    %esi
     dab:	5d                   	pop    %ebp
     dac:	c3                   	ret
     dad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     db0:	be ff ff ff ff       	mov    $0xffffffff,%esi
     db5:	eb ed                	jmp    da4 <stat+0x34>
     db7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     dbe:	00 
     dbf:	90                   	nop

00000dc0 <atoi>:

int
atoi(const char *s)
{
     dc0:	55                   	push   %ebp
     dc1:	89 e5                	mov    %esp,%ebp
     dc3:	53                   	push   %ebx
     dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     dc7:	0f be 02             	movsbl (%edx),%eax
     dca:	8d 48 d0             	lea    -0x30(%eax),%ecx
     dcd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     dd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     dd5:	77 1e                	ja     df5 <atoi+0x35>
     dd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     dde:	00 
     ddf:	90                   	nop
    n = n*10 + *s++ - '0';
     de0:	83 c2 01             	add    $0x1,%edx
     de3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     de6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     dea:	0f be 02             	movsbl (%edx),%eax
     ded:	8d 58 d0             	lea    -0x30(%eax),%ebx
     df0:	80 fb 09             	cmp    $0x9,%bl
     df3:	76 eb                	jbe    de0 <atoi+0x20>
  return n;
}
     df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     df8:	89 c8                	mov    %ecx,%eax
     dfa:	c9                   	leave
     dfb:	c3                   	ret
     dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e00 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e00:	55                   	push   %ebp
     e01:	89 e5                	mov    %esp,%ebp
     e03:	57                   	push   %edi
     e04:	8b 45 10             	mov    0x10(%ebp),%eax
     e07:	8b 55 08             	mov    0x8(%ebp),%edx
     e0a:	56                   	push   %esi
     e0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     e0e:	85 c0                	test   %eax,%eax
     e10:	7e 13                	jle    e25 <memmove+0x25>
     e12:	01 d0                	add    %edx,%eax
  dst = vdst;
     e14:	89 d7                	mov    %edx,%edi
     e16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     e1d:	00 
     e1e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
     e20:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     e21:	39 f8                	cmp    %edi,%eax
     e23:	75 fb                	jne    e20 <memmove+0x20>
  return vdst;
}
     e25:	5e                   	pop    %esi
     e26:	89 d0                	mov    %edx,%eax
     e28:	5f                   	pop    %edi
     e29:	5d                   	pop    %ebp
     e2a:	c3                   	ret

00000e2b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e2b:	b8 01 00 00 00       	mov    $0x1,%eax
     e30:	cd 40                	int    $0x40
     e32:	c3                   	ret

00000e33 <exit>:
SYSCALL(exit)
     e33:	b8 02 00 00 00       	mov    $0x2,%eax
     e38:	cd 40                	int    $0x40
     e3a:	c3                   	ret

00000e3b <wait>:
SYSCALL(wait)
     e3b:	b8 03 00 00 00       	mov    $0x3,%eax
     e40:	cd 40                	int    $0x40
     e42:	c3                   	ret

00000e43 <pipe>:
SYSCALL(pipe)
     e43:	b8 04 00 00 00       	mov    $0x4,%eax
     e48:	cd 40                	int    $0x40
     e4a:	c3                   	ret

00000e4b <read>:
SYSCALL(read)
     e4b:	b8 05 00 00 00       	mov    $0x5,%eax
     e50:	cd 40                	int    $0x40
     e52:	c3                   	ret

00000e53 <write>:
SYSCALL(write)
     e53:	b8 10 00 00 00       	mov    $0x10,%eax
     e58:	cd 40                	int    $0x40
     e5a:	c3                   	ret

00000e5b <close>:
SYSCALL(close)
     e5b:	b8 15 00 00 00       	mov    $0x15,%eax
     e60:	cd 40                	int    $0x40
     e62:	c3                   	ret

00000e63 <kill>:
SYSCALL(kill)
     e63:	b8 06 00 00 00       	mov    $0x6,%eax
     e68:	cd 40                	int    $0x40
     e6a:	c3                   	ret

00000e6b <exec>:
SYSCALL(exec)
     e6b:	b8 07 00 00 00       	mov    $0x7,%eax
     e70:	cd 40                	int    $0x40
     e72:	c3                   	ret

00000e73 <open>:
SYSCALL(open)
     e73:	b8 0f 00 00 00       	mov    $0xf,%eax
     e78:	cd 40                	int    $0x40
     e7a:	c3                   	ret

00000e7b <mknod>:
SYSCALL(mknod)
     e7b:	b8 11 00 00 00       	mov    $0x11,%eax
     e80:	cd 40                	int    $0x40
     e82:	c3                   	ret

00000e83 <unlink>:
SYSCALL(unlink)
     e83:	b8 12 00 00 00       	mov    $0x12,%eax
     e88:	cd 40                	int    $0x40
     e8a:	c3                   	ret

00000e8b <fstat>:
SYSCALL(fstat)
     e8b:	b8 08 00 00 00       	mov    $0x8,%eax
     e90:	cd 40                	int    $0x40
     e92:	c3                   	ret

00000e93 <link>:
SYSCALL(link)
     e93:	b8 13 00 00 00       	mov    $0x13,%eax
     e98:	cd 40                	int    $0x40
     e9a:	c3                   	ret

00000e9b <mkdir>:
SYSCALL(mkdir)
     e9b:	b8 14 00 00 00       	mov    $0x14,%eax
     ea0:	cd 40                	int    $0x40
     ea2:	c3                   	ret

00000ea3 <chdir>:
SYSCALL(chdir)
     ea3:	b8 09 00 00 00       	mov    $0x9,%eax
     ea8:	cd 40                	int    $0x40
     eaa:	c3                   	ret

00000eab <dup>:
SYSCALL(dup)
     eab:	b8 0a 00 00 00       	mov    $0xa,%eax
     eb0:	cd 40                	int    $0x40
     eb2:	c3                   	ret

00000eb3 <getpid>:
SYSCALL(getpid)
     eb3:	b8 0b 00 00 00       	mov    $0xb,%eax
     eb8:	cd 40                	int    $0x40
     eba:	c3                   	ret

00000ebb <sbrk>:
SYSCALL(sbrk)
     ebb:	b8 0c 00 00 00       	mov    $0xc,%eax
     ec0:	cd 40                	int    $0x40
     ec2:	c3                   	ret

00000ec3 <sleep>:
SYSCALL(sleep)
     ec3:	b8 0d 00 00 00       	mov    $0xd,%eax
     ec8:	cd 40                	int    $0x40
     eca:	c3                   	ret

00000ecb <uptime>:
SYSCALL(uptime)
     ecb:	b8 0e 00 00 00       	mov    $0xe,%eax
     ed0:	cd 40                	int    $0x40
     ed2:	c3                   	ret

00000ed3 <gethistory>:
SYSCALL(gethistory)
     ed3:	b8 16 00 00 00       	mov    $0x16,%eax
     ed8:	cd 40                	int    $0x40
     eda:	c3                   	ret

00000edb <block>:
SYSCALL(block)
     edb:	b8 17 00 00 00       	mov    $0x17,%eax
     ee0:	cd 40                	int    $0x40
     ee2:	c3                   	ret

00000ee3 <unblock>:
SYSCALL(unblock)
     ee3:	b8 18 00 00 00       	mov    $0x18,%eax
     ee8:	cd 40                	int    $0x40
     eea:	c3                   	ret
     eeb:	66 90                	xchg   %ax,%ax
     eed:	66 90                	xchg   %ax,%ax
     eef:	90                   	nop

00000ef0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     ef0:	55                   	push   %ebp
     ef1:	89 e5                	mov    %esp,%ebp
     ef3:	57                   	push   %edi
     ef4:	56                   	push   %esi
     ef5:	53                   	push   %ebx
     ef6:	83 ec 3c             	sub    $0x3c,%esp
     ef9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     efc:	89 d1                	mov    %edx,%ecx
{
     efe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     f01:	85 d2                	test   %edx,%edx
     f03:	0f 89 7f 00 00 00    	jns    f88 <printint+0x98>
     f09:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     f0d:	74 79                	je     f88 <printint+0x98>
    neg = 1;
     f0f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     f16:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     f18:	31 db                	xor    %ebx,%ebx
     f1a:	8d 75 d7             	lea    -0x29(%ebp),%esi
     f1d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     f20:	89 c8                	mov    %ecx,%eax
     f22:	31 d2                	xor    %edx,%edx
     f24:	89 cf                	mov    %ecx,%edi
     f26:	f7 75 c4             	divl   -0x3c(%ebp)
     f29:	0f b6 92 08 14 00 00 	movzbl 0x1408(%edx),%edx
     f30:	89 45 c0             	mov    %eax,-0x40(%ebp)
     f33:	89 d8                	mov    %ebx,%eax
     f35:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     f38:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     f3b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     f3e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     f41:	76 dd                	jbe    f20 <printint+0x30>
  if(neg)
     f43:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     f46:	85 c9                	test   %ecx,%ecx
     f48:	74 0c                	je     f56 <printint+0x66>
    buf[i++] = '-';
     f4a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     f4f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     f51:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     f56:	8b 7d b8             	mov    -0x48(%ebp),%edi
     f59:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     f5d:	eb 07                	jmp    f66 <printint+0x76>
     f5f:	90                   	nop
    putc(fd, buf[i]);
     f60:	0f b6 13             	movzbl (%ebx),%edx
     f63:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     f66:	83 ec 04             	sub    $0x4,%esp
     f69:	88 55 d7             	mov    %dl,-0x29(%ebp)
     f6c:	6a 01                	push   $0x1
     f6e:	56                   	push   %esi
     f6f:	57                   	push   %edi
     f70:	e8 de fe ff ff       	call   e53 <write>
  while(--i >= 0)
     f75:	83 c4 10             	add    $0x10,%esp
     f78:	39 de                	cmp    %ebx,%esi
     f7a:	75 e4                	jne    f60 <printint+0x70>
}
     f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f7f:	5b                   	pop    %ebx
     f80:	5e                   	pop    %esi
     f81:	5f                   	pop    %edi
     f82:	5d                   	pop    %ebp
     f83:	c3                   	ret
     f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     f88:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     f8f:	eb 87                	jmp    f18 <printint+0x28>
     f91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f98:	00 
     f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000fa0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     fa0:	55                   	push   %ebp
     fa1:	89 e5                	mov    %esp,%ebp
     fa3:	57                   	push   %edi
     fa4:	56                   	push   %esi
     fa5:	53                   	push   %ebx
     fa6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     fa9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
     fac:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
     faf:	0f b6 13             	movzbl (%ebx),%edx
     fb2:	84 d2                	test   %dl,%dl
     fb4:	74 6a                	je     1020 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
     fb6:	8d 45 10             	lea    0x10(%ebp),%eax
     fb9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
     fbc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     fbf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
     fc1:	89 45 d0             	mov    %eax,-0x30(%ebp)
     fc4:	eb 36                	jmp    ffc <printf+0x5c>
     fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fcd:	00 
     fce:	66 90                	xchg   %ax,%ax
     fd0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     fd3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
     fd8:	83 f8 25             	cmp    $0x25,%eax
     fdb:	74 15                	je     ff2 <printf+0x52>
  write(fd, &c, 1);
     fdd:	83 ec 04             	sub    $0x4,%esp
     fe0:	88 55 e7             	mov    %dl,-0x19(%ebp)
     fe3:	6a 01                	push   $0x1
     fe5:	57                   	push   %edi
     fe6:	56                   	push   %esi
     fe7:	e8 67 fe ff ff       	call   e53 <write>
     fec:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
     fef:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     ff2:	0f b6 13             	movzbl (%ebx),%edx
     ff5:	83 c3 01             	add    $0x1,%ebx
     ff8:	84 d2                	test   %dl,%dl
     ffa:	74 24                	je     1020 <printf+0x80>
    c = fmt[i] & 0xff;
     ffc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
     fff:	85 c9                	test   %ecx,%ecx
    1001:	74 cd                	je     fd0 <printf+0x30>
      }
    } else if(state == '%'){
    1003:	83 f9 25             	cmp    $0x25,%ecx
    1006:	75 ea                	jne    ff2 <printf+0x52>
      if(c == 'd'){
    1008:	83 f8 25             	cmp    $0x25,%eax
    100b:	0f 84 07 01 00 00    	je     1118 <printf+0x178>
    1011:	83 e8 63             	sub    $0x63,%eax
    1014:	83 f8 15             	cmp    $0x15,%eax
    1017:	77 17                	ja     1030 <printf+0x90>
    1019:	ff 24 85 b0 13 00 00 	jmp    *0x13b0(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1020:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1023:	5b                   	pop    %ebx
    1024:	5e                   	pop    %esi
    1025:	5f                   	pop    %edi
    1026:	5d                   	pop    %ebp
    1027:	c3                   	ret
    1028:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    102f:	00 
  write(fd, &c, 1);
    1030:	83 ec 04             	sub    $0x4,%esp
    1033:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1036:	6a 01                	push   $0x1
    1038:	57                   	push   %edi
    1039:	56                   	push   %esi
    103a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    103e:	e8 10 fe ff ff       	call   e53 <write>
        putc(fd, c);
    1043:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1047:	83 c4 0c             	add    $0xc,%esp
    104a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    104d:	6a 01                	push   $0x1
    104f:	57                   	push   %edi
    1050:	56                   	push   %esi
    1051:	e8 fd fd ff ff       	call   e53 <write>
        putc(fd, c);
    1056:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1059:	31 c9                	xor    %ecx,%ecx
    105b:	eb 95                	jmp    ff2 <printf+0x52>
    105d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1060:	83 ec 0c             	sub    $0xc,%esp
    1063:	b9 10 00 00 00       	mov    $0x10,%ecx
    1068:	6a 00                	push   $0x0
    106a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    106d:	8b 10                	mov    (%eax),%edx
    106f:	89 f0                	mov    %esi,%eax
    1071:	e8 7a fe ff ff       	call   ef0 <printint>
        ap++;
    1076:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    107a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    107d:	31 c9                	xor    %ecx,%ecx
    107f:	e9 6e ff ff ff       	jmp    ff2 <printf+0x52>
    1084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1088:	8b 45 d0             	mov    -0x30(%ebp),%eax
    108b:	8b 10                	mov    (%eax),%edx
        ap++;
    108d:	83 c0 04             	add    $0x4,%eax
    1090:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1093:	85 d2                	test   %edx,%edx
    1095:	0f 84 8d 00 00 00    	je     1128 <printf+0x188>
        while(*s != 0){
    109b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    109e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    10a0:	84 c0                	test   %al,%al
    10a2:	0f 84 4a ff ff ff    	je     ff2 <printf+0x52>
    10a8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    10ab:	89 d3                	mov    %edx,%ebx
    10ad:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    10b0:	83 ec 04             	sub    $0x4,%esp
          s++;
    10b3:	83 c3 01             	add    $0x1,%ebx
    10b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    10b9:	6a 01                	push   $0x1
    10bb:	57                   	push   %edi
    10bc:	56                   	push   %esi
    10bd:	e8 91 fd ff ff       	call   e53 <write>
        while(*s != 0){
    10c2:	0f b6 03             	movzbl (%ebx),%eax
    10c5:	83 c4 10             	add    $0x10,%esp
    10c8:	84 c0                	test   %al,%al
    10ca:	75 e4                	jne    10b0 <printf+0x110>
      state = 0;
    10cc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    10cf:	31 c9                	xor    %ecx,%ecx
    10d1:	e9 1c ff ff ff       	jmp    ff2 <printf+0x52>
    10d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10dd:	00 
    10de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    10e0:	83 ec 0c             	sub    $0xc,%esp
    10e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    10e8:	6a 01                	push   $0x1
    10ea:	e9 7b ff ff ff       	jmp    106a <printf+0xca>
    10ef:	90                   	nop
        putc(fd, *ap);
    10f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    10f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    10f6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    10f8:	6a 01                	push   $0x1
    10fa:	57                   	push   %edi
    10fb:	56                   	push   %esi
        putc(fd, *ap);
    10fc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    10ff:	e8 4f fd ff ff       	call   e53 <write>
        ap++;
    1104:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1108:	83 c4 10             	add    $0x10,%esp
      state = 0;
    110b:	31 c9                	xor    %ecx,%ecx
    110d:	e9 e0 fe ff ff       	jmp    ff2 <printf+0x52>
    1112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1118:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    111b:	83 ec 04             	sub    $0x4,%esp
    111e:	e9 2a ff ff ff       	jmp    104d <printf+0xad>
    1123:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          s = "(null)";
    1128:	ba 77 13 00 00       	mov    $0x1377,%edx
        while(*s != 0){
    112d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1130:	b8 28 00 00 00       	mov    $0x28,%eax
    1135:	89 d3                	mov    %edx,%ebx
    1137:	e9 74 ff ff ff       	jmp    10b0 <printf+0x110>
    113c:	66 90                	xchg   %ax,%ax
    113e:	66 90                	xchg   %ax,%ax

00001140 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1140:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1141:	a1 64 1a 00 00       	mov    0x1a64,%eax
{
    1146:	89 e5                	mov    %esp,%ebp
    1148:	57                   	push   %edi
    1149:	56                   	push   %esi
    114a:	53                   	push   %ebx
    114b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    114e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1158:	89 c2                	mov    %eax,%edx
    115a:	8b 00                	mov    (%eax),%eax
    115c:	39 ca                	cmp    %ecx,%edx
    115e:	73 30                	jae    1190 <free+0x50>
    1160:	39 c1                	cmp    %eax,%ecx
    1162:	72 04                	jb     1168 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1164:	39 c2                	cmp    %eax,%edx
    1166:	72 f0                	jb     1158 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1168:	8b 73 fc             	mov    -0x4(%ebx),%esi
    116b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    116e:	39 f8                	cmp    %edi,%eax
    1170:	74 30                	je     11a2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1172:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1175:	8b 42 04             	mov    0x4(%edx),%eax
    1178:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    117b:	39 f1                	cmp    %esi,%ecx
    117d:	74 3a                	je     11b9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    117f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1181:	5b                   	pop    %ebx
  freep = p;
    1182:	89 15 64 1a 00 00    	mov    %edx,0x1a64
}
    1188:	5e                   	pop    %esi
    1189:	5f                   	pop    %edi
    118a:	5d                   	pop    %ebp
    118b:	c3                   	ret
    118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1190:	39 c2                	cmp    %eax,%edx
    1192:	72 c4                	jb     1158 <free+0x18>
    1194:	39 c1                	cmp    %eax,%ecx
    1196:	73 c0                	jae    1158 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    1198:	8b 73 fc             	mov    -0x4(%ebx),%esi
    119b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    119e:	39 f8                	cmp    %edi,%eax
    11a0:	75 d0                	jne    1172 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    11a2:	03 70 04             	add    0x4(%eax),%esi
    11a5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    11a8:	8b 02                	mov    (%edx),%eax
    11aa:	8b 00                	mov    (%eax),%eax
    11ac:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    11af:	8b 42 04             	mov    0x4(%edx),%eax
    11b2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    11b5:	39 f1                	cmp    %esi,%ecx
    11b7:	75 c6                	jne    117f <free+0x3f>
    p->s.size += bp->s.size;
    11b9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    11bc:	89 15 64 1a 00 00    	mov    %edx,0x1a64
    p->s.size += bp->s.size;
    11c2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    11c5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    11c8:	89 0a                	mov    %ecx,(%edx)
}
    11ca:	5b                   	pop    %ebx
    11cb:	5e                   	pop    %esi
    11cc:	5f                   	pop    %edi
    11cd:	5d                   	pop    %ebp
    11ce:	c3                   	ret
    11cf:	90                   	nop

000011d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	57                   	push   %edi
    11d4:	56                   	push   %esi
    11d5:	53                   	push   %ebx
    11d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    11dc:	8b 3d 64 1a 00 00    	mov    0x1a64,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11e2:	8d 70 07             	lea    0x7(%eax),%esi
    11e5:	c1 ee 03             	shr    $0x3,%esi
    11e8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    11eb:	85 ff                	test   %edi,%edi
    11ed:	0f 84 9d 00 00 00    	je     1290 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11f3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    11f5:	8b 4a 04             	mov    0x4(%edx),%ecx
    11f8:	39 f1                	cmp    %esi,%ecx
    11fa:	73 6a                	jae    1266 <malloc+0x96>
    11fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1201:	39 de                	cmp    %ebx,%esi
    1203:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1206:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    120d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1210:	eb 17                	jmp    1229 <malloc+0x59>
    1212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1218:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    121a:	8b 48 04             	mov    0x4(%eax),%ecx
    121d:	39 f1                	cmp    %esi,%ecx
    121f:	73 4f                	jae    1270 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1221:	8b 3d 64 1a 00 00    	mov    0x1a64,%edi
    1227:	89 c2                	mov    %eax,%edx
    1229:	39 d7                	cmp    %edx,%edi
    122b:	75 eb                	jne    1218 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    122d:	83 ec 0c             	sub    $0xc,%esp
    1230:	ff 75 e4             	push   -0x1c(%ebp)
    1233:	e8 83 fc ff ff       	call   ebb <sbrk>
  if(p == (char*)-1)
    1238:	83 c4 10             	add    $0x10,%esp
    123b:	83 f8 ff             	cmp    $0xffffffff,%eax
    123e:	74 1c                	je     125c <malloc+0x8c>
  hp->s.size = nu;
    1240:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1243:	83 ec 0c             	sub    $0xc,%esp
    1246:	83 c0 08             	add    $0x8,%eax
    1249:	50                   	push   %eax
    124a:	e8 f1 fe ff ff       	call   1140 <free>
  return freep;
    124f:	8b 15 64 1a 00 00    	mov    0x1a64,%edx
      if((p = morecore(nunits)) == 0)
    1255:	83 c4 10             	add    $0x10,%esp
    1258:	85 d2                	test   %edx,%edx
    125a:	75 bc                	jne    1218 <malloc+0x48>
        return 0;
  }
}
    125c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    125f:	31 c0                	xor    %eax,%eax
}
    1261:	5b                   	pop    %ebx
    1262:	5e                   	pop    %esi
    1263:	5f                   	pop    %edi
    1264:	5d                   	pop    %ebp
    1265:	c3                   	ret
    if(p->s.size >= nunits){
    1266:	89 d0                	mov    %edx,%eax
    1268:	89 fa                	mov    %edi,%edx
    126a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1270:	39 ce                	cmp    %ecx,%esi
    1272:	74 4c                	je     12c0 <malloc+0xf0>
        p->s.size -= nunits;
    1274:	29 f1                	sub    %esi,%ecx
    1276:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1279:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    127c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    127f:	89 15 64 1a 00 00    	mov    %edx,0x1a64
}
    1285:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1288:	83 c0 08             	add    $0x8,%eax
}
    128b:	5b                   	pop    %ebx
    128c:	5e                   	pop    %esi
    128d:	5f                   	pop    %edi
    128e:	5d                   	pop    %ebp
    128f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
    1290:	c7 05 64 1a 00 00 68 	movl   $0x1a68,0x1a64
    1297:	1a 00 00 
    base.s.size = 0;
    129a:	bf 68 1a 00 00       	mov    $0x1a68,%edi
    base.s.ptr = freep = prevp = &base;
    129f:	c7 05 68 1a 00 00 68 	movl   $0x1a68,0x1a68
    12a6:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12a9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    12ab:	c7 05 6c 1a 00 00 00 	movl   $0x0,0x1a6c
    12b2:	00 00 00 
    if(p->s.size >= nunits){
    12b5:	e9 42 ff ff ff       	jmp    11fc <malloc+0x2c>
    12ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    12c0:	8b 08                	mov    (%eax),%ecx
    12c2:	89 0a                	mov    %ecx,(%edx)
    12c4:	eb b9                	jmp    127f <malloc+0xaf>
