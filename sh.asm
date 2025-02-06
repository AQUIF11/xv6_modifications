
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
      26:	68 39 13 00 00       	push   $0x1339
      2b:	e8 23 0e 00 00       	call   e53 <open>
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
      40:	80 3d e2 19 00 00 20 	cmpb   $0x20,0x19e2
      47:	0f 84 88 00 00 00    	je     d5 <main+0xd5>
      4d:	8d 76 00             	lea    0x0(%esi),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      50:	e8 b6 0d 00 00       	call   e0b <fork>
  if(pid == -1)
      55:	83 f8 ff             	cmp    $0xffffffff,%eax
      58:	0f 84 c1 00 00 00    	je     11f <main+0x11f>
    if(fork1() == 0)
      5e:	85 c0                	test   %eax,%eax
      60:	74 5e                	je     c0 <main+0xc0>
    wait();
      62:	e8 b4 0d 00 00       	call   e1b <wait>
  printf(2, "$ ");
      67:	83 ec 08             	sub    $0x8,%esp
      6a:	68 98 12 00 00       	push   $0x1298
      6f:	6a 02                	push   $0x2
      71:	e8 fa 0e 00 00       	call   f70 <printf>
  memset(buf, 0, nbuf);
      76:	83 c4 0c             	add    $0xc,%esp
      79:	6a 64                	push   $0x64
      7b:	6a 00                	push   $0x0
      7d:	68 e0 19 00 00       	push   $0x19e0
      82:	e8 f9 0b 00 00       	call   c80 <memset>
  gets(buf, nbuf);
      87:	58                   	pop    %eax
      88:	5a                   	pop    %edx
      89:	6a 64                	push   $0x64
      8b:	68 e0 19 00 00       	push   $0x19e0
      90:	e8 4b 0c 00 00       	call   ce0 <gets>
  if(buf[0] == 0) // EOF
      95:	0f b6 05 e0 19 00 00 	movzbl 0x19e0,%eax
      9c:	83 c4 10             	add    $0x10,%esp
      9f:	84 c0                	test   %al,%al
      a1:	74 77                	je     11a <main+0x11a>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      a3:	3c 63                	cmp    $0x63,%al
      a5:	75 a9                	jne    50 <main+0x50>
      a7:	80 3d e1 19 00 00 64 	cmpb   $0x64,0x19e1
      ae:	75 a0                	jne    50 <main+0x50>
      b0:	eb 8e                	jmp    40 <main+0x40>
      close(fd);
      b2:	83 ec 0c             	sub    $0xc,%esp
      b5:	50                   	push   %eax
      b6:	e8 80 0d 00 00       	call   e3b <close>
      break;
      bb:	83 c4 10             	add    $0x10,%esp
      be:	eb a7                	jmp    67 <main+0x67>
      runcmd(parsecmd(buf));
      c0:	83 ec 0c             	sub    $0xc,%esp
      c3:	68 e0 19 00 00       	push   $0x19e0
      c8:	e8 83 0a 00 00       	call   b50 <parsecmd>
      cd:	89 04 24             	mov    %eax,(%esp)
      d0:	e8 db 00 00 00       	call   1b0 <runcmd>
      buf[strlen(buf)-1] = 0;  // chop \n
      d5:	83 ec 0c             	sub    $0xc,%esp
      d8:	68 e0 19 00 00       	push   $0x19e0
      dd:	e8 6e 0b 00 00       	call   c50 <strlen>
      if(chdir(buf+3) < 0)
      e2:	c7 04 24 e3 19 00 00 	movl   $0x19e3,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      e9:	c6 80 df 19 00 00 00 	movb   $0x0,0x19df(%eax)
      if(chdir(buf+3) < 0)
      f0:	e8 8e 0d 00 00       	call   e83 <chdir>
      f5:	83 c4 10             	add    $0x10,%esp
      f8:	85 c0                	test   %eax,%eax
      fa:	0f 89 67 ff ff ff    	jns    67 <main+0x67>
        printf(2, "cannot cd %s\n", buf+3);
     100:	51                   	push   %ecx
     101:	68 e3 19 00 00       	push   $0x19e3
     106:	68 41 13 00 00       	push   $0x1341
     10b:	6a 02                	push   $0x2
     10d:	e8 5e 0e 00 00       	call   f70 <printf>
     112:	83 c4 10             	add    $0x10,%esp
     115:	e9 4d ff ff ff       	jmp    67 <main+0x67>
  exit();
     11a:	e8 f4 0c 00 00       	call   e13 <exit>
    panic("fork");
     11f:	83 ec 0c             	sub    $0xc,%esp
     122:	68 9b 12 00 00       	push   $0x129b
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
     13e:	68 98 12 00 00       	push   $0x1298
     143:	6a 02                	push   $0x2
     145:	e8 26 0e 00 00       	call   f70 <printf>
  memset(buf, 0, nbuf);
     14a:	83 c4 0c             	add    $0xc,%esp
     14d:	56                   	push   %esi
     14e:	6a 00                	push   $0x0
     150:	53                   	push   %ebx
     151:	e8 2a 0b 00 00       	call   c80 <memset>
  gets(buf, nbuf);
     156:	58                   	pop    %eax
     157:	5a                   	pop    %edx
     158:	56                   	push   %esi
     159:	53                   	push   %ebx
     15a:	e8 81 0b 00 00       	call   ce0 <gets>
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
     179:	68 35 13 00 00       	push   $0x1335
     17e:	6a 02                	push   $0x2
     180:	e8 eb 0d 00 00       	call   f70 <printf>
  exit();
     185:	e8 89 0c 00 00       	call   e13 <exit>
     18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000190 <fork1>:
{
     190:	55                   	push   %ebp
     191:	89 e5                	mov    %esp,%ebp
     193:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     196:	e8 70 0c 00 00       	call   e0b <fork>
  if(pid == -1)
     19b:	83 f8 ff             	cmp    $0xffffffff,%eax
     19e:	74 02                	je     1a2 <fork1+0x12>
  return pid;
}
     1a0:	c9                   	leave
     1a1:	c3                   	ret
    panic("fork");
     1a2:	83 ec 0c             	sub    $0xc,%esp
     1a5:	68 9b 12 00 00       	push   $0x129b
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
     1bc:	74 3a                	je     1f8 <runcmd+0x48>
  switch(cmd->type){
     1be:	83 3b 05             	cmpl   $0x5,(%ebx)
     1c1:	0f 87 e6 00 00 00    	ja     2ad <runcmd+0xfd>
     1c7:	8b 03                	mov    (%ebx),%eax
     1c9:	ff 24 85 58 13 00 00 	jmp    *0x1358(,%eax,4)
    if(ecmd->argv[0] == 0)
     1d0:	8b 43 04             	mov    0x4(%ebx),%eax
     1d3:	85 c0                	test   %eax,%eax
     1d5:	74 21                	je     1f8 <runcmd+0x48>
    exec(ecmd->argv[0], ecmd->argv);
     1d7:	8d 53 04             	lea    0x4(%ebx),%edx
     1da:	51                   	push   %ecx
     1db:	51                   	push   %ecx
     1dc:	52                   	push   %edx
     1dd:	50                   	push   %eax
     1de:	e8 68 0c 00 00       	call   e4b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     1e3:	83 c4 0c             	add    $0xc,%esp
     1e6:	ff 73 04             	push   0x4(%ebx)
     1e9:	68 a7 12 00 00       	push   $0x12a7
     1ee:	6a 02                	push   $0x2
     1f0:	e8 7b 0d 00 00       	call   f70 <printf>
    break;
     1f5:	83 c4 10             	add    $0x10,%esp
    exit();
     1f8:	e8 16 0c 00 00       	call   e13 <exit>
    if(fork1() == 0)
     1fd:	e8 8e ff ff ff       	call   190 <fork1>
     202:	85 c0                	test   %eax,%eax
     204:	75 f2                	jne    1f8 <runcmd+0x48>
     206:	e9 97 00 00 00       	jmp    2a2 <runcmd+0xf2>
    if(pipe(p) < 0)
     20b:	83 ec 0c             	sub    $0xc,%esp
     20e:	8d 45 f0             	lea    -0x10(%ebp),%eax
     211:	50                   	push   %eax
     212:	e8 0c 0c 00 00       	call   e23 <pipe>
     217:	83 c4 10             	add    $0x10,%esp
     21a:	85 c0                	test   %eax,%eax
     21c:	0f 88 ad 00 00 00    	js     2cf <runcmd+0x11f>
    if(fork1() == 0){
     222:	e8 69 ff ff ff       	call   190 <fork1>
     227:	85 c0                	test   %eax,%eax
     229:	0f 84 ad 00 00 00    	je     2dc <runcmd+0x12c>
    if(fork1() == 0){
     22f:	e8 5c ff ff ff       	call   190 <fork1>
     234:	85 c0                	test   %eax,%eax
     236:	0f 85 ce 00 00 00    	jne    30a <runcmd+0x15a>
      close(0);
     23c:	83 ec 0c             	sub    $0xc,%esp
     23f:	6a 00                	push   $0x0
     241:	e8 f5 0b 00 00       	call   e3b <close>
      dup(p[0]);
     246:	5a                   	pop    %edx
     247:	ff 75 f0             	push   -0x10(%ebp)
     24a:	e8 3c 0c 00 00       	call   e8b <dup>
      close(p[0]);
     24f:	59                   	pop    %ecx
     250:	ff 75 f0             	push   -0x10(%ebp)
     253:	e8 e3 0b 00 00       	call   e3b <close>
      close(p[1]);
     258:	58                   	pop    %eax
     259:	ff 75 f4             	push   -0xc(%ebp)
     25c:	e8 da 0b 00 00       	call   e3b <close>
      runcmd(pcmd->right);
     261:	58                   	pop    %eax
     262:	ff 73 08             	push   0x8(%ebx)
     265:	e8 46 ff ff ff       	call   1b0 <runcmd>
    if(fork1() == 0)
     26a:	e8 21 ff ff ff       	call   190 <fork1>
     26f:	85 c0                	test   %eax,%eax
     271:	74 2f                	je     2a2 <runcmd+0xf2>
    wait();
     273:	e8 a3 0b 00 00       	call   e1b <wait>
    runcmd(lcmd->right);
     278:	83 ec 0c             	sub    $0xc,%esp
     27b:	ff 73 08             	push   0x8(%ebx)
     27e:	e8 2d ff ff ff       	call   1b0 <runcmd>
    close(rcmd->fd);
     283:	83 ec 0c             	sub    $0xc,%esp
     286:	ff 73 14             	push   0x14(%ebx)
     289:	e8 ad 0b 00 00       	call   e3b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     28e:	58                   	pop    %eax
     28f:	5a                   	pop    %edx
     290:	ff 73 10             	push   0x10(%ebx)
     293:	ff 73 08             	push   0x8(%ebx)
     296:	e8 b8 0b 00 00       	call   e53 <open>
     29b:	83 c4 10             	add    $0x10,%esp
     29e:	85 c0                	test   %eax,%eax
     2a0:	78 18                	js     2ba <runcmd+0x10a>
      runcmd(bcmd->cmd);
     2a2:	83 ec 0c             	sub    $0xc,%esp
     2a5:	ff 73 04             	push   0x4(%ebx)
     2a8:	e8 03 ff ff ff       	call   1b0 <runcmd>
    panic("runcmd");
     2ad:	83 ec 0c             	sub    $0xc,%esp
     2b0:	68 a0 12 00 00       	push   $0x12a0
     2b5:	e8 b6 fe ff ff       	call   170 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     2ba:	51                   	push   %ecx
     2bb:	ff 73 08             	push   0x8(%ebx)
     2be:	68 b7 12 00 00       	push   $0x12b7
     2c3:	6a 02                	push   $0x2
     2c5:	e8 a6 0c 00 00       	call   f70 <printf>
      exit();
     2ca:	e8 44 0b 00 00       	call   e13 <exit>
      panic("pipe");
     2cf:	83 ec 0c             	sub    $0xc,%esp
     2d2:	68 c7 12 00 00       	push   $0x12c7
     2d7:	e8 94 fe ff ff       	call   170 <panic>
      close(1);
     2dc:	83 ec 0c             	sub    $0xc,%esp
     2df:	6a 01                	push   $0x1
     2e1:	e8 55 0b 00 00       	call   e3b <close>
      dup(p[1]);
     2e6:	58                   	pop    %eax
     2e7:	ff 75 f4             	push   -0xc(%ebp)
     2ea:	e8 9c 0b 00 00       	call   e8b <dup>
      close(p[0]);
     2ef:	58                   	pop    %eax
     2f0:	ff 75 f0             	push   -0x10(%ebp)
     2f3:	e8 43 0b 00 00       	call   e3b <close>
      close(p[1]);
     2f8:	58                   	pop    %eax
     2f9:	ff 75 f4             	push   -0xc(%ebp)
     2fc:	e8 3a 0b 00 00       	call   e3b <close>
      runcmd(pcmd->left);
     301:	5a                   	pop    %edx
     302:	ff 73 04             	push   0x4(%ebx)
     305:	e8 a6 fe ff ff       	call   1b0 <runcmd>
    close(p[0]);
     30a:	83 ec 0c             	sub    $0xc,%esp
     30d:	ff 75 f0             	push   -0x10(%ebp)
     310:	e8 26 0b 00 00       	call   e3b <close>
    close(p[1]);
     315:	58                   	pop    %eax
     316:	ff 75 f4             	push   -0xc(%ebp)
     319:	e8 1d 0b 00 00       	call   e3b <close>
    wait();
     31e:	e8 f8 0a 00 00       	call   e1b <wait>
    wait();
     323:	e8 f3 0a 00 00       	call   e1b <wait>
    break;
     328:	83 c4 10             	add    $0x10,%esp
     32b:	e9 c8 fe ff ff       	jmp    1f8 <runcmd+0x48>

00000330 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     330:	55                   	push   %ebp
     331:	89 e5                	mov    %esp,%ebp
     333:	53                   	push   %ebx
     334:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     337:	6a 54                	push   $0x54
     339:	e8 62 0e 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     33e:	83 c4 0c             	add    $0xc,%esp
     341:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     343:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     345:	6a 00                	push   $0x0
     347:	50                   	push   %eax
     348:	e8 33 09 00 00       	call   c80 <memset>
  cmd->type = EXEC;
     34d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     353:	89 d8                	mov    %ebx,%eax
     355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     358:	c9                   	leave
     359:	c3                   	ret
     35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000360 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	53                   	push   %ebx
     364:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     367:	6a 18                	push   $0x18
     369:	e8 32 0e 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     36e:	83 c4 0c             	add    $0xc,%esp
     371:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     373:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     375:	6a 00                	push   $0x0
     377:	50                   	push   %eax
     378:	e8 03 09 00 00       	call   c80 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     37d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     380:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     386:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     389:	8b 45 0c             	mov    0xc(%ebp),%eax
     38c:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     38f:	8b 45 10             	mov    0x10(%ebp),%eax
     392:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     395:	8b 45 14             	mov    0x14(%ebp),%eax
     398:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     39b:	8b 45 18             	mov    0x18(%ebp),%eax
     39e:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3a1:	89 d8                	mov    %ebx,%eax
     3a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3a6:	c9                   	leave
     3a7:	c3                   	ret
     3a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3af:	00 

000003b0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	53                   	push   %ebx
     3b4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b7:	6a 0c                	push   $0xc
     3b9:	e8 e2 0d 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3be:	83 c4 0c             	add    $0xc,%esp
     3c1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     3c3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3c5:	6a 00                	push   $0x0
     3c7:	50                   	push   %eax
     3c8:	e8 b3 08 00 00       	call   c80 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     3cd:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     3d0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     3d6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3dc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     3df:	89 d8                	mov    %ebx,%eax
     3e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3e4:	c9                   	leave
     3e5:	c3                   	ret
     3e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3ed:	00 
     3ee:	66 90                	xchg   %ax,%ax

000003f0 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     3f0:	55                   	push   %ebp
     3f1:	89 e5                	mov    %esp,%ebp
     3f3:	53                   	push   %ebx
     3f4:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3f7:	6a 0c                	push   $0xc
     3f9:	e8 a2 0d 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3fe:	83 c4 0c             	add    $0xc,%esp
     401:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     403:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     405:	6a 00                	push   $0x0
     407:	50                   	push   %eax
     408:	e8 73 08 00 00       	call   c80 <memset>
  cmd->type = LIST;
  cmd->left = left;
     40d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     410:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     416:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     419:	8b 45 0c             	mov    0xc(%ebp),%eax
     41c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     41f:	89 d8                	mov    %ebx,%eax
     421:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     424:	c9                   	leave
     425:	c3                   	ret
     426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     42d:	00 
     42e:	66 90                	xchg   %ax,%ax

00000430 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     430:	55                   	push   %ebp
     431:	89 e5                	mov    %esp,%ebp
     433:	53                   	push   %ebx
     434:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     437:	6a 08                	push   $0x8
     439:	e8 62 0d 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     43e:	83 c4 0c             	add    $0xc,%esp
     441:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     443:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     445:	6a 00                	push   $0x0
     447:	50                   	push   %eax
     448:	e8 33 08 00 00       	call   c80 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     44d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     450:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     456:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     459:	89 d8                	mov    %ebx,%eax
     45b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     45e:	c9                   	leave
     45f:	c3                   	ret

00000460 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     460:	55                   	push   %ebp
     461:	89 e5                	mov    %esp,%ebp
     463:	57                   	push   %edi
     464:	56                   	push   %esi
     465:	53                   	push   %ebx
     466:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     469:	8b 45 08             	mov    0x8(%ebp),%eax
{
     46c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     46f:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     472:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     474:	39 df                	cmp    %ebx,%edi
     476:	72 0f                	jb     487 <gettoken+0x27>
     478:	eb 25                	jmp    49f <gettoken+0x3f>
     47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     480:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     483:	39 fb                	cmp    %edi,%ebx
     485:	74 18                	je     49f <gettoken+0x3f>
     487:	0f be 07             	movsbl (%edi),%eax
     48a:	83 ec 08             	sub    $0x8,%esp
     48d:	50                   	push   %eax
     48e:	68 bc 19 00 00       	push   $0x19bc
     493:	e8 08 08 00 00       	call   ca0 <strchr>
     498:	83 c4 10             	add    $0x10,%esp
     49b:	85 c0                	test   %eax,%eax
     49d:	75 e1                	jne    480 <gettoken+0x20>
  if(q)
     49f:	85 f6                	test   %esi,%esi
     4a1:	74 02                	je     4a5 <gettoken+0x45>
    *q = s;
     4a3:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     4a5:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     4a8:	3c 3c                	cmp    $0x3c,%al
     4aa:	0f 8f d0 00 00 00    	jg     580 <gettoken+0x120>
     4b0:	3c 3a                	cmp    $0x3a,%al
     4b2:	0f 8f b4 00 00 00    	jg     56c <gettoken+0x10c>
     4b8:	84 c0                	test   %al,%al
     4ba:	75 44                	jne    500 <gettoken+0xa0>
     4bc:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     4be:	8b 55 14             	mov    0x14(%ebp),%edx
     4c1:	85 d2                	test   %edx,%edx
     4c3:	74 05                	je     4ca <gettoken+0x6a>
    *eq = s;
     4c5:	8b 45 14             	mov    0x14(%ebp),%eax
     4c8:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     4ca:	39 df                	cmp    %ebx,%edi
     4cc:	72 09                	jb     4d7 <gettoken+0x77>
     4ce:	eb 1f                	jmp    4ef <gettoken+0x8f>
    s++;
     4d0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     4d3:	39 fb                	cmp    %edi,%ebx
     4d5:	74 18                	je     4ef <gettoken+0x8f>
     4d7:	0f be 07             	movsbl (%edi),%eax
     4da:	83 ec 08             	sub    $0x8,%esp
     4dd:	50                   	push   %eax
     4de:	68 bc 19 00 00       	push   $0x19bc
     4e3:	e8 b8 07 00 00       	call   ca0 <strchr>
     4e8:	83 c4 10             	add    $0x10,%esp
     4eb:	85 c0                	test   %eax,%eax
     4ed:	75 e1                	jne    4d0 <gettoken+0x70>
  *ps = s;
     4ef:	8b 45 08             	mov    0x8(%ebp),%eax
     4f2:	89 38                	mov    %edi,(%eax)
  return ret;
}
     4f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4f7:	89 f0                	mov    %esi,%eax
     4f9:	5b                   	pop    %ebx
     4fa:	5e                   	pop    %esi
     4fb:	5f                   	pop    %edi
     4fc:	5d                   	pop    %ebp
     4fd:	c3                   	ret
     4fe:	66 90                	xchg   %ax,%ax
  switch(*s){
     500:	79 5e                	jns    560 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     502:	39 fb                	cmp    %edi,%ebx
     504:	77 34                	ja     53a <gettoken+0xda>
  if(eq)
     506:	8b 45 14             	mov    0x14(%ebp),%eax
     509:	be 61 00 00 00       	mov    $0x61,%esi
     50e:	85 c0                	test   %eax,%eax
     510:	75 b3                	jne    4c5 <gettoken+0x65>
     512:	eb db                	jmp    4ef <gettoken+0x8f>
     514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     518:	0f be 07             	movsbl (%edi),%eax
     51b:	83 ec 08             	sub    $0x8,%esp
     51e:	50                   	push   %eax
     51f:	68 b4 19 00 00       	push   $0x19b4
     524:	e8 77 07 00 00       	call   ca0 <strchr>
     529:	83 c4 10             	add    $0x10,%esp
     52c:	85 c0                	test   %eax,%eax
     52e:	75 22                	jne    552 <gettoken+0xf2>
      s++;
     530:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     533:	39 fb                	cmp    %edi,%ebx
     535:	74 cf                	je     506 <gettoken+0xa6>
     537:	0f b6 07             	movzbl (%edi),%eax
     53a:	83 ec 08             	sub    $0x8,%esp
     53d:	0f be f0             	movsbl %al,%esi
     540:	56                   	push   %esi
     541:	68 bc 19 00 00       	push   $0x19bc
     546:	e8 55 07 00 00       	call   ca0 <strchr>
     54b:	83 c4 10             	add    $0x10,%esp
     54e:	85 c0                	test   %eax,%eax
     550:	74 c6                	je     518 <gettoken+0xb8>
    ret = 'a';
     552:	be 61 00 00 00       	mov    $0x61,%esi
     557:	e9 62 ff ff ff       	jmp    4be <gettoken+0x5e>
     55c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     560:	3c 26                	cmp    $0x26,%al
     562:	74 08                	je     56c <gettoken+0x10c>
     564:	8d 48 d8             	lea    -0x28(%eax),%ecx
     567:	80 f9 01             	cmp    $0x1,%cl
     56a:	77 96                	ja     502 <gettoken+0xa2>
  ret = *s;
     56c:	0f be f0             	movsbl %al,%esi
    s++;
     56f:	83 c7 01             	add    $0x1,%edi
    break;
     572:	e9 47 ff ff ff       	jmp    4be <gettoken+0x5e>
     577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     57e:	00 
     57f:	90                   	nop
  switch(*s){
     580:	3c 3e                	cmp    $0x3e,%al
     582:	75 1c                	jne    5a0 <gettoken+0x140>
    if(*s == '>'){
     584:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     588:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     58b:	74 1c                	je     5a9 <gettoken+0x149>
    s++;
     58d:	89 c7                	mov    %eax,%edi
     58f:	be 3e 00 00 00       	mov    $0x3e,%esi
     594:	e9 25 ff ff ff       	jmp    4be <gettoken+0x5e>
     599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     5a0:	3c 7c                	cmp    $0x7c,%al
     5a2:	74 c8                	je     56c <gettoken+0x10c>
     5a4:	e9 59 ff ff ff       	jmp    502 <gettoken+0xa2>
      s++;
     5a9:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     5ac:	be 2b 00 00 00       	mov    $0x2b,%esi
     5b1:	e9 08 ff ff ff       	jmp    4be <gettoken+0x5e>
     5b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     5bd:	00 
     5be:	66 90                	xchg   %ax,%ax

000005c0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     5c0:	55                   	push   %ebp
     5c1:	89 e5                	mov    %esp,%ebp
     5c3:	57                   	push   %edi
     5c4:	56                   	push   %esi
     5c5:	53                   	push   %ebx
     5c6:	83 ec 0c             	sub    $0xc,%esp
     5c9:	8b 7d 08             	mov    0x8(%ebp),%edi
     5cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     5cf:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     5d1:	39 f3                	cmp    %esi,%ebx
     5d3:	72 12                	jb     5e7 <peek+0x27>
     5d5:	eb 28                	jmp    5ff <peek+0x3f>
     5d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     5de:	00 
     5df:	90                   	nop
    s++;
     5e0:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     5e3:	39 de                	cmp    %ebx,%esi
     5e5:	74 18                	je     5ff <peek+0x3f>
     5e7:	0f be 03             	movsbl (%ebx),%eax
     5ea:	83 ec 08             	sub    $0x8,%esp
     5ed:	50                   	push   %eax
     5ee:	68 bc 19 00 00       	push   $0x19bc
     5f3:	e8 a8 06 00 00       	call   ca0 <strchr>
     5f8:	83 c4 10             	add    $0x10,%esp
     5fb:	85 c0                	test   %eax,%eax
     5fd:	75 e1                	jne    5e0 <peek+0x20>
  *ps = s;
     5ff:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     601:	0f be 03             	movsbl (%ebx),%eax
     604:	31 d2                	xor    %edx,%edx
     606:	84 c0                	test   %al,%al
     608:	75 0e                	jne    618 <peek+0x58>
}
     60a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     60d:	89 d0                	mov    %edx,%eax
     60f:	5b                   	pop    %ebx
     610:	5e                   	pop    %esi
     611:	5f                   	pop    %edi
     612:	5d                   	pop    %ebp
     613:	c3                   	ret
     614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     618:	83 ec 08             	sub    $0x8,%esp
     61b:	50                   	push   %eax
     61c:	ff 75 10             	push   0x10(%ebp)
     61f:	e8 7c 06 00 00       	call   ca0 <strchr>
     624:	83 c4 10             	add    $0x10,%esp
     627:	31 d2                	xor    %edx,%edx
     629:	85 c0                	test   %eax,%eax
     62b:	0f 95 c2             	setne  %dl
}
     62e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     631:	5b                   	pop    %ebx
     632:	89 d0                	mov    %edx,%eax
     634:	5e                   	pop    %esi
     635:	5f                   	pop    %edi
     636:	5d                   	pop    %ebp
     637:	c3                   	ret
     638:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     63f:	00 

00000640 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     640:	55                   	push   %ebp
     641:	89 e5                	mov    %esp,%ebp
     643:	57                   	push   %edi
     644:	56                   	push   %esi
     645:	53                   	push   %ebx
     646:	83 ec 2c             	sub    $0x2c,%esp
     649:	8b 75 0c             	mov    0xc(%ebp),%esi
     64c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     64f:	90                   	nop
     650:	83 ec 04             	sub    $0x4,%esp
     653:	68 e9 12 00 00       	push   $0x12e9
     658:	53                   	push   %ebx
     659:	56                   	push   %esi
     65a:	e8 61 ff ff ff       	call   5c0 <peek>
     65f:	83 c4 10             	add    $0x10,%esp
     662:	85 c0                	test   %eax,%eax
     664:	0f 84 f6 00 00 00    	je     760 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     66a:	6a 00                	push   $0x0
     66c:	6a 00                	push   $0x0
     66e:	53                   	push   %ebx
     66f:	56                   	push   %esi
     670:	e8 eb fd ff ff       	call   460 <gettoken>
     675:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     677:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     67a:	50                   	push   %eax
     67b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     67e:	50                   	push   %eax
     67f:	53                   	push   %ebx
     680:	56                   	push   %esi
     681:	e8 da fd ff ff       	call   460 <gettoken>
     686:	83 c4 20             	add    $0x20,%esp
     689:	83 f8 61             	cmp    $0x61,%eax
     68c:	0f 85 d9 00 00 00    	jne    76b <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     692:	83 ff 3c             	cmp    $0x3c,%edi
     695:	74 69                	je     700 <parseredirs+0xc0>
     697:	83 ff 3e             	cmp    $0x3e,%edi
     69a:	74 05                	je     6a1 <parseredirs+0x61>
     69c:	83 ff 2b             	cmp    $0x2b,%edi
     69f:	75 af                	jne    650 <parseredirs+0x10>
  cmd = malloc(sizeof(*cmd));
     6a1:	83 ec 0c             	sub    $0xc,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     6a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     6aa:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6ac:	89 55 d0             	mov    %edx,-0x30(%ebp)
     6af:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     6b2:	e8 e9 0a 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6b7:	83 c4 0c             	add    $0xc,%esp
     6ba:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     6bc:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     6be:	6a 00                	push   $0x0
     6c0:	50                   	push   %eax
     6c1:	e8 ba 05 00 00       	call   c80 <memset>
  cmd->type = REDIR;
     6c6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     6cc:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     6cf:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     6d2:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     6d5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     6d8:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     6db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     6de:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     6e5:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     6e8:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      break;
     6ef:	89 7d 08             	mov    %edi,0x8(%ebp)
     6f2:	e9 59 ff ff ff       	jmp    650 <parseredirs+0x10>
     6f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     6fe:	00 
     6ff:	90                   	nop
  cmd = malloc(sizeof(*cmd));
     700:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     703:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     706:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     709:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     70b:	89 55 d0             	mov    %edx,-0x30(%ebp)
     70e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     711:	e8 8a 0a 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     716:	83 c4 0c             	add    $0xc,%esp
     719:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     71b:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     71d:	6a 00                	push   $0x0
     71f:	50                   	push   %eax
     720:	e8 5b 05 00 00       	call   c80 <memset>
  cmd->cmd = subcmd;
     725:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     728:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     72b:	89 7d 08             	mov    %edi,0x8(%ebp)
  cmd->efile = efile;
     72e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     731:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
      break;
     737:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     73a:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     73d:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     740:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     743:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     74a:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      break;
     751:	e9 fa fe ff ff       	jmp    650 <parseredirs+0x10>
     756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     75d:	00 
     75e:	66 90                	xchg   %ax,%ax
    }
  }
  return cmd;
}
     760:	8b 45 08             	mov    0x8(%ebp),%eax
     763:	8d 65 f4             	lea    -0xc(%ebp),%esp
     766:	5b                   	pop    %ebx
     767:	5e                   	pop    %esi
     768:	5f                   	pop    %edi
     769:	5d                   	pop    %ebp
     76a:	c3                   	ret
      panic("missing file for redirection");
     76b:	83 ec 0c             	sub    $0xc,%esp
     76e:	68 cc 12 00 00       	push   $0x12cc
     773:	e8 f8 f9 ff ff       	call   170 <panic>
     778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     77f:	00 

00000780 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     780:	55                   	push   %ebp
     781:	89 e5                	mov    %esp,%ebp
     783:	57                   	push   %edi
     784:	56                   	push   %esi
     785:	53                   	push   %ebx
     786:	83 ec 30             	sub    $0x30,%esp
     789:	8b 75 08             	mov    0x8(%ebp),%esi
     78c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     78f:	68 ec 12 00 00       	push   $0x12ec
     794:	57                   	push   %edi
     795:	56                   	push   %esi
     796:	e8 25 fe ff ff       	call   5c0 <peek>
     79b:	83 c4 10             	add    $0x10,%esp
     79e:	85 c0                	test   %eax,%eax
     7a0:	0f 85 aa 00 00 00    	jne    850 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     7a6:	83 ec 0c             	sub    $0xc,%esp
     7a9:	89 c3                	mov    %eax,%ebx
     7ab:	6a 54                	push   $0x54
     7ad:	e8 ee 09 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     7b2:	83 c4 0c             	add    $0xc,%esp
     7b5:	6a 54                	push   $0x54
     7b7:	6a 00                	push   $0x0
     7b9:	50                   	push   %eax
     7ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
     7bd:	e8 be 04 00 00       	call   c80 <memset>
  cmd->type = EXEC;
     7c2:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7c5:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     7c8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     7ce:	57                   	push   %edi
     7cf:	56                   	push   %esi
     7d0:	50                   	push   %eax
     7d1:	e8 6a fe ff ff       	call   640 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     7d6:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     7d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7dc:	eb 15                	jmp    7f3 <parseexec+0x73>
     7de:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     7e0:	83 ec 04             	sub    $0x4,%esp
     7e3:	57                   	push   %edi
     7e4:	56                   	push   %esi
     7e5:	ff 75 d4             	push   -0x2c(%ebp)
     7e8:	e8 53 fe ff ff       	call   640 <parseredirs>
     7ed:	83 c4 10             	add    $0x10,%esp
     7f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7f3:	83 ec 04             	sub    $0x4,%esp
     7f6:	68 03 13 00 00       	push   $0x1303
     7fb:	57                   	push   %edi
     7fc:	56                   	push   %esi
     7fd:	e8 be fd ff ff       	call   5c0 <peek>
     802:	83 c4 10             	add    $0x10,%esp
     805:	85 c0                	test   %eax,%eax
     807:	75 5f                	jne    868 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     809:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     80c:	50                   	push   %eax
     80d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     810:	50                   	push   %eax
     811:	57                   	push   %edi
     812:	56                   	push   %esi
     813:	e8 48 fc ff ff       	call   460 <gettoken>
     818:	83 c4 10             	add    $0x10,%esp
     81b:	85 c0                	test   %eax,%eax
     81d:	74 49                	je     868 <parseexec+0xe8>
    if(tok != 'a')
     81f:	83 f8 61             	cmp    $0x61,%eax
     822:	75 62                	jne    886 <parseexec+0x106>
    cmd->argv[argc] = q;
     824:	8b 45 e0             	mov    -0x20(%ebp),%eax
     827:	8b 55 d0             	mov    -0x30(%ebp),%edx
     82a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     82e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     831:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     835:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     838:	83 fb 0a             	cmp    $0xa,%ebx
     83b:	75 a3                	jne    7e0 <parseexec+0x60>
      panic("too many args");
     83d:	83 ec 0c             	sub    $0xc,%esp
     840:	68 f5 12 00 00       	push   $0x12f5
     845:	e8 26 f9 ff ff       	call   170 <panic>
     84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     850:	89 7d 0c             	mov    %edi,0xc(%ebp)
     853:	89 75 08             	mov    %esi,0x8(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     856:	8d 65 f4             	lea    -0xc(%ebp),%esp
     859:	5b                   	pop    %ebx
     85a:	5e                   	pop    %esi
     85b:	5f                   	pop    %edi
     85c:	5d                   	pop    %ebp
    return parseblock(ps, es);
     85d:	e9 ae 01 00 00       	jmp    a10 <parseblock>
     862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc] = 0;
     868:	8b 45 d0             	mov    -0x30(%ebp),%eax
     86b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     872:	00 
  cmd->eargv[argc] = 0;
     873:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     87a:	00 
}
     87b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     87e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     881:	5b                   	pop    %ebx
     882:	5e                   	pop    %esi
     883:	5f                   	pop    %edi
     884:	5d                   	pop    %ebp
     885:	c3                   	ret
      panic("syntax");
     886:	83 ec 0c             	sub    $0xc,%esp
     889:	68 ee 12 00 00       	push   $0x12ee
     88e:	e8 dd f8 ff ff       	call   170 <panic>
     893:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     89a:	00 
     89b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

000008a0 <parsepipe>:
{
     8a0:	55                   	push   %ebp
     8a1:	89 e5                	mov    %esp,%ebp
     8a3:	57                   	push   %edi
     8a4:	56                   	push   %esi
     8a5:	53                   	push   %ebx
     8a6:	83 ec 14             	sub    $0x14,%esp
     8a9:	8b 75 08             	mov    0x8(%ebp),%esi
     8ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     8af:	57                   	push   %edi
     8b0:	56                   	push   %esi
     8b1:	e8 ca fe ff ff       	call   780 <parseexec>
  if(peek(ps, es, "|")){
     8b6:	83 c4 0c             	add    $0xc,%esp
     8b9:	68 08 13 00 00       	push   $0x1308
  cmd = parseexec(ps, es);
     8be:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     8c0:	57                   	push   %edi
     8c1:	56                   	push   %esi
     8c2:	e8 f9 fc ff ff       	call   5c0 <peek>
     8c7:	83 c4 10             	add    $0x10,%esp
     8ca:	85 c0                	test   %eax,%eax
     8cc:	75 12                	jne    8e0 <parsepipe+0x40>
}
     8ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8d1:	89 d8                	mov    %ebx,%eax
     8d3:	5b                   	pop    %ebx
     8d4:	5e                   	pop    %esi
     8d5:	5f                   	pop    %edi
     8d6:	5d                   	pop    %ebp
     8d7:	c3                   	ret
     8d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8df:	00 
    gettoken(ps, es, 0, 0);
     8e0:	6a 00                	push   $0x0
     8e2:	6a 00                	push   $0x0
     8e4:	57                   	push   %edi
     8e5:	56                   	push   %esi
     8e6:	e8 75 fb ff ff       	call   460 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8eb:	58                   	pop    %eax
     8ec:	5a                   	pop    %edx
     8ed:	57                   	push   %edi
     8ee:	56                   	push   %esi
     8ef:	e8 ac ff ff ff       	call   8a0 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     8f4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8fb:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     8fd:	e8 9e 08 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     902:	83 c4 0c             	add    $0xc,%esp
     905:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     907:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     909:	6a 00                	push   $0x0
     90b:	50                   	push   %eax
     90c:	e8 6f 03 00 00       	call   c80 <memset>
  cmd->left = left;
     911:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     914:	83 c4 10             	add    $0x10,%esp
     917:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     919:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     91f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     921:	89 7e 08             	mov    %edi,0x8(%esi)
}
     924:	8d 65 f4             	lea    -0xc(%ebp),%esp
     927:	5b                   	pop    %ebx
     928:	5e                   	pop    %esi
     929:	5f                   	pop    %edi
     92a:	5d                   	pop    %ebp
     92b:	c3                   	ret
     92c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000930 <parseline>:
{
     930:	55                   	push   %ebp
     931:	89 e5                	mov    %esp,%ebp
     933:	57                   	push   %edi
     934:	56                   	push   %esi
     935:	53                   	push   %ebx
     936:	83 ec 24             	sub    $0x24,%esp
     939:	8b 75 08             	mov    0x8(%ebp),%esi
     93c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     93f:	57                   	push   %edi
     940:	56                   	push   %esi
     941:	e8 5a ff ff ff       	call   8a0 <parsepipe>
  while(peek(ps, es, "&")){
     946:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     949:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     94b:	eb 3b                	jmp    988 <parseline+0x58>
     94d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     950:	6a 00                	push   $0x0
     952:	6a 00                	push   $0x0
     954:	57                   	push   %edi
     955:	56                   	push   %esi
     956:	e8 05 fb ff ff       	call   460 <gettoken>
  cmd = malloc(sizeof(*cmd));
     95b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     962:	e8 39 08 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     967:	83 c4 0c             	add    $0xc,%esp
     96a:	6a 08                	push   $0x8
     96c:	6a 00                	push   $0x0
     96e:	50                   	push   %eax
     96f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     972:	e8 09 03 00 00       	call   c80 <memset>
  cmd->type = BACK;
     977:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     97a:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     97d:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     983:	89 5a 04             	mov    %ebx,0x4(%edx)
     986:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     988:	83 ec 04             	sub    $0x4,%esp
     98b:	68 0a 13 00 00       	push   $0x130a
     990:	57                   	push   %edi
     991:	56                   	push   %esi
     992:	e8 29 fc ff ff       	call   5c0 <peek>
     997:	83 c4 10             	add    $0x10,%esp
     99a:	85 c0                	test   %eax,%eax
     99c:	75 b2                	jne    950 <parseline+0x20>
  if(peek(ps, es, ";")){
     99e:	83 ec 04             	sub    $0x4,%esp
     9a1:	68 06 13 00 00       	push   $0x1306
     9a6:	57                   	push   %edi
     9a7:	56                   	push   %esi
     9a8:	e8 13 fc ff ff       	call   5c0 <peek>
     9ad:	83 c4 10             	add    $0x10,%esp
     9b0:	85 c0                	test   %eax,%eax
     9b2:	75 0c                	jne    9c0 <parseline+0x90>
}
     9b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9b7:	89 d8                	mov    %ebx,%eax
     9b9:	5b                   	pop    %ebx
     9ba:	5e                   	pop    %esi
     9bb:	5f                   	pop    %edi
     9bc:	5d                   	pop    %ebp
     9bd:	c3                   	ret
     9be:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     9c0:	6a 00                	push   $0x0
     9c2:	6a 00                	push   $0x0
     9c4:	57                   	push   %edi
     9c5:	56                   	push   %esi
     9c6:	e8 95 fa ff ff       	call   460 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     9cb:	58                   	pop    %eax
     9cc:	5a                   	pop    %edx
     9cd:	57                   	push   %edi
     9ce:	56                   	push   %esi
     9cf:	e8 5c ff ff ff       	call   930 <parseline>
  cmd = malloc(sizeof(*cmd));
     9d4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     9db:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     9dd:	e8 be 07 00 00       	call   11a0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     9e2:	83 c4 0c             	add    $0xc,%esp
     9e5:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     9e7:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     9e9:	6a 00                	push   $0x0
     9eb:	50                   	push   %eax
     9ec:	e8 8f 02 00 00       	call   c80 <memset>
  cmd->left = left;
     9f1:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     9f4:	83 c4 10             	add    $0x10,%esp
     9f7:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     9f9:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     9ff:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     a01:	89 7e 08             	mov    %edi,0x8(%esi)
}
     a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a07:	5b                   	pop    %ebx
     a08:	5e                   	pop    %esi
     a09:	5f                   	pop    %edi
     a0a:	5d                   	pop    %ebp
     a0b:	c3                   	ret
     a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a10 <parseblock>:
{
     a10:	55                   	push   %ebp
     a11:	89 e5                	mov    %esp,%ebp
     a13:	57                   	push   %edi
     a14:	56                   	push   %esi
     a15:	53                   	push   %ebx
     a16:	83 ec 10             	sub    $0x10,%esp
     a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     a1f:	68 ec 12 00 00       	push   $0x12ec
     a24:	56                   	push   %esi
     a25:	53                   	push   %ebx
     a26:	e8 95 fb ff ff       	call   5c0 <peek>
     a2b:	83 c4 10             	add    $0x10,%esp
     a2e:	85 c0                	test   %eax,%eax
     a30:	74 4a                	je     a7c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     a32:	6a 00                	push   $0x0
     a34:	6a 00                	push   $0x0
     a36:	56                   	push   %esi
     a37:	53                   	push   %ebx
     a38:	e8 23 fa ff ff       	call   460 <gettoken>
  cmd = parseline(ps, es);
     a3d:	58                   	pop    %eax
     a3e:	5a                   	pop    %edx
     a3f:	56                   	push   %esi
     a40:	53                   	push   %ebx
     a41:	e8 ea fe ff ff       	call   930 <parseline>
  if(!peek(ps, es, ")"))
     a46:	83 c4 0c             	add    $0xc,%esp
     a49:	68 28 13 00 00       	push   $0x1328
  cmd = parseline(ps, es);
     a4e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     a50:	56                   	push   %esi
     a51:	53                   	push   %ebx
     a52:	e8 69 fb ff ff       	call   5c0 <peek>
     a57:	83 c4 10             	add    $0x10,%esp
     a5a:	85 c0                	test   %eax,%eax
     a5c:	74 2b                	je     a89 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     a5e:	6a 00                	push   $0x0
     a60:	6a 00                	push   $0x0
     a62:	56                   	push   %esi
     a63:	53                   	push   %ebx
     a64:	e8 f7 f9 ff ff       	call   460 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a69:	83 c4 0c             	add    $0xc,%esp
     a6c:	56                   	push   %esi
     a6d:	53                   	push   %ebx
     a6e:	57                   	push   %edi
     a6f:	e8 cc fb ff ff       	call   640 <parseredirs>
}
     a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a77:	5b                   	pop    %ebx
     a78:	5e                   	pop    %esi
     a79:	5f                   	pop    %edi
     a7a:	5d                   	pop    %ebp
     a7b:	c3                   	ret
    panic("parseblock");
     a7c:	83 ec 0c             	sub    $0xc,%esp
     a7f:	68 0c 13 00 00       	push   $0x130c
     a84:	e8 e7 f6 ff ff       	call   170 <panic>
    panic("syntax - missing )");
     a89:	83 ec 0c             	sub    $0xc,%esp
     a8c:	68 17 13 00 00       	push   $0x1317
     a91:	e8 da f6 ff ff       	call   170 <panic>
     a96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a9d:	00 
     a9e:	66 90                	xchg   %ax,%ax

00000aa0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     aa0:	55                   	push   %ebp
     aa1:	89 e5                	mov    %esp,%ebp
     aa3:	53                   	push   %ebx
     aa4:	83 ec 04             	sub    $0x4,%esp
     aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     aaa:	85 db                	test   %ebx,%ebx
     aac:	0f 84 8e 00 00 00    	je     b40 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
     ab2:	83 3b 05             	cmpl   $0x5,(%ebx)
     ab5:	77 61                	ja     b18 <nulterminate+0x78>
     ab7:	8b 03                	mov    (%ebx),%eax
     ab9:	ff 24 85 70 13 00 00 	jmp    *0x1370(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     ac0:	83 ec 0c             	sub    $0xc,%esp
     ac3:	ff 73 04             	push   0x4(%ebx)
     ac6:	e8 d5 ff ff ff       	call   aa0 <nulterminate>
    nulterminate(lcmd->right);
     acb:	58                   	pop    %eax
     acc:	ff 73 08             	push   0x8(%ebx)
     acf:	e8 cc ff ff ff       	call   aa0 <nulterminate>
    break;
     ad4:	83 c4 10             	add    $0x10,%esp
     ad7:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     adc:	c9                   	leave
     add:	c3                   	ret
     ade:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     ae0:	83 ec 0c             	sub    $0xc,%esp
     ae3:	ff 73 04             	push   0x4(%ebx)
     ae6:	e8 b5 ff ff ff       	call   aa0 <nulterminate>
    break;
     aeb:	89 d8                	mov    %ebx,%eax
     aed:	83 c4 10             	add    $0x10,%esp
}
     af0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     af3:	c9                   	leave
     af4:	c3                   	ret
     af5:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     af8:	8b 4b 04             	mov    0x4(%ebx),%ecx
     afb:	8d 43 08             	lea    0x8(%ebx),%eax
     afe:	85 c9                	test   %ecx,%ecx
     b00:	74 16                	je     b18 <nulterminate+0x78>
     b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     b08:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     b0b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     b0e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     b11:	8b 50 fc             	mov    -0x4(%eax),%edx
     b14:	85 d2                	test   %edx,%edx
     b16:	75 f0                	jne    b08 <nulterminate+0x68>
  switch(cmd->type){
     b18:	89 d8                	mov    %ebx,%eax
}
     b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b1d:	c9                   	leave
     b1e:	c3                   	ret
     b1f:	90                   	nop
    nulterminate(rcmd->cmd);
     b20:	83 ec 0c             	sub    $0xc,%esp
     b23:	ff 73 04             	push   0x4(%ebx)
     b26:	e8 75 ff ff ff       	call   aa0 <nulterminate>
    *rcmd->efile = 0;
     b2b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     b2e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     b31:	c6 00 00             	movb   $0x0,(%eax)
    break;
     b34:	89 d8                	mov    %ebx,%eax
}
     b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b39:	c9                   	leave
     b3a:	c3                   	ret
     b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return 0;
     b40:	31 c0                	xor    %eax,%eax
     b42:	eb 95                	jmp    ad9 <nulterminate+0x39>
     b44:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b4b:	00 
     b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b50 <parsecmd>:
{
     b50:	55                   	push   %ebp
     b51:	89 e5                	mov    %esp,%ebp
     b53:	57                   	push   %edi
     b54:	56                   	push   %esi
  cmd = parseline(&s, es);
     b55:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     b58:	53                   	push   %ebx
     b59:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     b5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b5f:	53                   	push   %ebx
     b60:	e8 eb 00 00 00       	call   c50 <strlen>
  cmd = parseline(&s, es);
     b65:	59                   	pop    %ecx
     b66:	5e                   	pop    %esi
  es = s + strlen(s);
     b67:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     b69:	53                   	push   %ebx
     b6a:	57                   	push   %edi
     b6b:	e8 c0 fd ff ff       	call   930 <parseline>
  peek(&s, es, "");
     b70:	83 c4 0c             	add    $0xc,%esp
     b73:	68 b6 12 00 00       	push   $0x12b6
  cmd = parseline(&s, es);
     b78:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     b7a:	53                   	push   %ebx
     b7b:	57                   	push   %edi
     b7c:	e8 3f fa ff ff       	call   5c0 <peek>
  if(s != es){
     b81:	8b 45 08             	mov    0x8(%ebp),%eax
     b84:	83 c4 10             	add    $0x10,%esp
     b87:	39 d8                	cmp    %ebx,%eax
     b89:	75 13                	jne    b9e <parsecmd+0x4e>
  nulterminate(cmd);
     b8b:	83 ec 0c             	sub    $0xc,%esp
     b8e:	56                   	push   %esi
     b8f:	e8 0c ff ff ff       	call   aa0 <nulterminate>
}
     b94:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b97:	89 f0                	mov    %esi,%eax
     b99:	5b                   	pop    %ebx
     b9a:	5e                   	pop    %esi
     b9b:	5f                   	pop    %edi
     b9c:	5d                   	pop    %ebp
     b9d:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
     b9e:	52                   	push   %edx
     b9f:	50                   	push   %eax
     ba0:	68 2a 13 00 00       	push   $0x132a
     ba5:	6a 02                	push   $0x2
     ba7:	e8 c4 03 00 00       	call   f70 <printf>
    panic("syntax");
     bac:	c7 04 24 ee 12 00 00 	movl   $0x12ee,(%esp)
     bb3:	e8 b8 f5 ff ff       	call   170 <panic>
     bb8:	66 90                	xchg   %ax,%ax
     bba:	66 90                	xchg   %ax,%ax
     bbc:	66 90                	xchg   %ax,%ax
     bbe:	66 90                	xchg   %ax,%ax

00000bc0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     bc0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bc1:	31 c0                	xor    %eax,%eax
{
     bc3:	89 e5                	mov    %esp,%ebp
     bc5:	53                   	push   %ebx
     bc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bc9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     bd0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     bd4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     bd7:	83 c0 01             	add    $0x1,%eax
     bda:	84 d2                	test   %dl,%dl
     bdc:	75 f2                	jne    bd0 <strcpy+0x10>
    ;
  return os;
}
     bde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     be1:	89 c8                	mov    %ecx,%eax
     be3:	c9                   	leave
     be4:	c3                   	ret
     be5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     bec:	00 
     bed:	8d 76 00             	lea    0x0(%esi),%esi

00000bf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bf0:	55                   	push   %ebp
     bf1:	89 e5                	mov    %esp,%ebp
     bf3:	53                   	push   %ebx
     bf4:	8b 55 08             	mov    0x8(%ebp),%edx
     bf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     bfa:	0f b6 02             	movzbl (%edx),%eax
     bfd:	84 c0                	test   %al,%al
     bff:	75 17                	jne    c18 <strcmp+0x28>
     c01:	eb 3a                	jmp    c3d <strcmp+0x4d>
     c03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     c08:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     c0c:	83 c2 01             	add    $0x1,%edx
     c0f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     c12:	84 c0                	test   %al,%al
     c14:	74 1a                	je     c30 <strcmp+0x40>
    p++, q++;
     c16:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
     c18:	0f b6 19             	movzbl (%ecx),%ebx
     c1b:	38 c3                	cmp    %al,%bl
     c1d:	74 e9                	je     c08 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     c1f:	29 d8                	sub    %ebx,%eax
}
     c21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c24:	c9                   	leave
     c25:	c3                   	ret
     c26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c2d:	00 
     c2e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     c30:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     c34:	31 c0                	xor    %eax,%eax
     c36:	29 d8                	sub    %ebx,%eax
}
     c38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c3b:	c9                   	leave
     c3c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     c3d:	0f b6 19             	movzbl (%ecx),%ebx
     c40:	31 c0                	xor    %eax,%eax
     c42:	eb db                	jmp    c1f <strcmp+0x2f>
     c44:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c4b:	00 
     c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c50 <strlen>:

uint
strlen(const char *s)
{
     c50:	55                   	push   %ebp
     c51:	89 e5                	mov    %esp,%ebp
     c53:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     c56:	80 3a 00             	cmpb   $0x0,(%edx)
     c59:	74 15                	je     c70 <strlen+0x20>
     c5b:	31 c0                	xor    %eax,%eax
     c5d:	8d 76 00             	lea    0x0(%esi),%esi
     c60:	83 c0 01             	add    $0x1,%eax
     c63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     c67:	89 c1                	mov    %eax,%ecx
     c69:	75 f5                	jne    c60 <strlen+0x10>
    ;
  return n;
}
     c6b:	89 c8                	mov    %ecx,%eax
     c6d:	5d                   	pop    %ebp
     c6e:	c3                   	ret
     c6f:	90                   	nop
  for(n = 0; s[n]; n++)
     c70:	31 c9                	xor    %ecx,%ecx
}
     c72:	5d                   	pop    %ebp
     c73:	89 c8                	mov    %ecx,%eax
     c75:	c3                   	ret
     c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c7d:	00 
     c7e:	66 90                	xchg   %ax,%ax

00000c80 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c80:	55                   	push   %ebp
     c81:	89 e5                	mov    %esp,%ebp
     c83:	57                   	push   %edi
     c84:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     c87:	8b 4d 10             	mov    0x10(%ebp),%ecx
     c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c8d:	89 d7                	mov    %edx,%edi
     c8f:	fc                   	cld
     c90:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     c92:	8b 7d fc             	mov    -0x4(%ebp),%edi
     c95:	89 d0                	mov    %edx,%eax
     c97:	c9                   	leave
     c98:	c3                   	ret
     c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000ca0 <strchr>:

char*
strchr(const char *s, char c)
{
     ca0:	55                   	push   %ebp
     ca1:	89 e5                	mov    %esp,%ebp
     ca3:	8b 45 08             	mov    0x8(%ebp),%eax
     ca6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     caa:	0f b6 10             	movzbl (%eax),%edx
     cad:	84 d2                	test   %dl,%dl
     caf:	75 12                	jne    cc3 <strchr+0x23>
     cb1:	eb 1d                	jmp    cd0 <strchr+0x30>
     cb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     cb8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     cbc:	83 c0 01             	add    $0x1,%eax
     cbf:	84 d2                	test   %dl,%dl
     cc1:	74 0d                	je     cd0 <strchr+0x30>
    if(*s == c)
     cc3:	38 d1                	cmp    %dl,%cl
     cc5:	75 f1                	jne    cb8 <strchr+0x18>
      return (char*)s;
  return 0;
}
     cc7:	5d                   	pop    %ebp
     cc8:	c3                   	ret
     cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     cd0:	31 c0                	xor    %eax,%eax
}
     cd2:	5d                   	pop    %ebp
     cd3:	c3                   	ret
     cd4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     cdb:	00 
     cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ce0 <gets>:

char*
gets(char *buf, int max)
{
     ce0:	55                   	push   %ebp
     ce1:	89 e5                	mov    %esp,%ebp
     ce3:	57                   	push   %edi
     ce4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     ce5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
     ce8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     ce9:	31 db                	xor    %ebx,%ebx
{
     ceb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     cee:	eb 27                	jmp    d17 <gets+0x37>
    cc = read(0, &c, 1);
     cf0:	83 ec 04             	sub    $0x4,%esp
     cf3:	6a 01                	push   $0x1
     cf5:	57                   	push   %edi
     cf6:	6a 00                	push   $0x0
     cf8:	e8 2e 01 00 00       	call   e2b <read>
    if(cc < 1)
     cfd:	83 c4 10             	add    $0x10,%esp
     d00:	85 c0                	test   %eax,%eax
     d02:	7e 1d                	jle    d21 <gets+0x41>
      break;
    buf[i++] = c;
     d04:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     d08:	8b 55 08             	mov    0x8(%ebp),%edx
     d0b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     d0f:	3c 0a                	cmp    $0xa,%al
     d11:	74 1d                	je     d30 <gets+0x50>
     d13:	3c 0d                	cmp    $0xd,%al
     d15:	74 19                	je     d30 <gets+0x50>
  for(i=0; i+1 < max; ){
     d17:	89 de                	mov    %ebx,%esi
     d19:	83 c3 01             	add    $0x1,%ebx
     d1c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     d1f:	7c cf                	jl     cf0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
     d21:	8b 45 08             	mov    0x8(%ebp),%eax
     d24:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d2b:	5b                   	pop    %ebx
     d2c:	5e                   	pop    %esi
     d2d:	5f                   	pop    %edi
     d2e:	5d                   	pop    %ebp
     d2f:	c3                   	ret
  buf[i] = '\0';
     d30:	8b 45 08             	mov    0x8(%ebp),%eax
     d33:	89 de                	mov    %ebx,%esi
     d35:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
     d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d3c:	5b                   	pop    %ebx
     d3d:	5e                   	pop    %esi
     d3e:	5f                   	pop    %edi
     d3f:	5d                   	pop    %ebp
     d40:	c3                   	ret
     d41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     d48:	00 
     d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d50 <stat>:

int
stat(const char *n, struct stat *st)
{
     d50:	55                   	push   %ebp
     d51:	89 e5                	mov    %esp,%ebp
     d53:	56                   	push   %esi
     d54:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d55:	83 ec 08             	sub    $0x8,%esp
     d58:	6a 00                	push   $0x0
     d5a:	ff 75 08             	push   0x8(%ebp)
     d5d:	e8 f1 00 00 00       	call   e53 <open>
  if(fd < 0)
     d62:	83 c4 10             	add    $0x10,%esp
     d65:	85 c0                	test   %eax,%eax
     d67:	78 27                	js     d90 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     d69:	83 ec 08             	sub    $0x8,%esp
     d6c:	ff 75 0c             	push   0xc(%ebp)
     d6f:	89 c3                	mov    %eax,%ebx
     d71:	50                   	push   %eax
     d72:	e8 f4 00 00 00       	call   e6b <fstat>
  close(fd);
     d77:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     d7a:	89 c6                	mov    %eax,%esi
  close(fd);
     d7c:	e8 ba 00 00 00       	call   e3b <close>
  return r;
     d81:	83 c4 10             	add    $0x10,%esp
}
     d84:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d87:	89 f0                	mov    %esi,%eax
     d89:	5b                   	pop    %ebx
     d8a:	5e                   	pop    %esi
     d8b:	5d                   	pop    %ebp
     d8c:	c3                   	ret
     d8d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     d90:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d95:	eb ed                	jmp    d84 <stat+0x34>
     d97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     d9e:	00 
     d9f:	90                   	nop

00000da0 <atoi>:

int
atoi(const char *s)
{
     da0:	55                   	push   %ebp
     da1:	89 e5                	mov    %esp,%ebp
     da3:	53                   	push   %ebx
     da4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     da7:	0f be 02             	movsbl (%edx),%eax
     daa:	8d 48 d0             	lea    -0x30(%eax),%ecx
     dad:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     db0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     db5:	77 1e                	ja     dd5 <atoi+0x35>
     db7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     dbe:	00 
     dbf:	90                   	nop
    n = n*10 + *s++ - '0';
     dc0:	83 c2 01             	add    $0x1,%edx
     dc3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     dc6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     dca:	0f be 02             	movsbl (%edx),%eax
     dcd:	8d 58 d0             	lea    -0x30(%eax),%ebx
     dd0:	80 fb 09             	cmp    $0x9,%bl
     dd3:	76 eb                	jbe    dc0 <atoi+0x20>
  return n;
}
     dd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     dd8:	89 c8                	mov    %ecx,%eax
     dda:	c9                   	leave
     ddb:	c3                   	ret
     ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000de0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     de0:	55                   	push   %ebp
     de1:	89 e5                	mov    %esp,%ebp
     de3:	57                   	push   %edi
     de4:	8b 45 10             	mov    0x10(%ebp),%eax
     de7:	8b 55 08             	mov    0x8(%ebp),%edx
     dea:	56                   	push   %esi
     deb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     dee:	85 c0                	test   %eax,%eax
     df0:	7e 13                	jle    e05 <memmove+0x25>
     df2:	01 d0                	add    %edx,%eax
  dst = vdst;
     df4:	89 d7                	mov    %edx,%edi
     df6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     dfd:	00 
     dfe:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
     e00:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     e01:	39 f8                	cmp    %edi,%eax
     e03:	75 fb                	jne    e00 <memmove+0x20>
  return vdst;
}
     e05:	5e                   	pop    %esi
     e06:	89 d0                	mov    %edx,%eax
     e08:	5f                   	pop    %edi
     e09:	5d                   	pop    %ebp
     e0a:	c3                   	ret

00000e0b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e0b:	b8 01 00 00 00       	mov    $0x1,%eax
     e10:	cd 40                	int    $0x40
     e12:	c3                   	ret

00000e13 <exit>:
SYSCALL(exit)
     e13:	b8 02 00 00 00       	mov    $0x2,%eax
     e18:	cd 40                	int    $0x40
     e1a:	c3                   	ret

00000e1b <wait>:
SYSCALL(wait)
     e1b:	b8 03 00 00 00       	mov    $0x3,%eax
     e20:	cd 40                	int    $0x40
     e22:	c3                   	ret

00000e23 <pipe>:
SYSCALL(pipe)
     e23:	b8 04 00 00 00       	mov    $0x4,%eax
     e28:	cd 40                	int    $0x40
     e2a:	c3                   	ret

00000e2b <read>:
SYSCALL(read)
     e2b:	b8 05 00 00 00       	mov    $0x5,%eax
     e30:	cd 40                	int    $0x40
     e32:	c3                   	ret

00000e33 <write>:
SYSCALL(write)
     e33:	b8 10 00 00 00       	mov    $0x10,%eax
     e38:	cd 40                	int    $0x40
     e3a:	c3                   	ret

00000e3b <close>:
SYSCALL(close)
     e3b:	b8 15 00 00 00       	mov    $0x15,%eax
     e40:	cd 40                	int    $0x40
     e42:	c3                   	ret

00000e43 <kill>:
SYSCALL(kill)
     e43:	b8 06 00 00 00       	mov    $0x6,%eax
     e48:	cd 40                	int    $0x40
     e4a:	c3                   	ret

00000e4b <exec>:
SYSCALL(exec)
     e4b:	b8 07 00 00 00       	mov    $0x7,%eax
     e50:	cd 40                	int    $0x40
     e52:	c3                   	ret

00000e53 <open>:
SYSCALL(open)
     e53:	b8 0f 00 00 00       	mov    $0xf,%eax
     e58:	cd 40                	int    $0x40
     e5a:	c3                   	ret

00000e5b <mknod>:
SYSCALL(mknod)
     e5b:	b8 11 00 00 00       	mov    $0x11,%eax
     e60:	cd 40                	int    $0x40
     e62:	c3                   	ret

00000e63 <unlink>:
SYSCALL(unlink)
     e63:	b8 12 00 00 00       	mov    $0x12,%eax
     e68:	cd 40                	int    $0x40
     e6a:	c3                   	ret

00000e6b <fstat>:
SYSCALL(fstat)
     e6b:	b8 08 00 00 00       	mov    $0x8,%eax
     e70:	cd 40                	int    $0x40
     e72:	c3                   	ret

00000e73 <link>:
SYSCALL(link)
     e73:	b8 13 00 00 00       	mov    $0x13,%eax
     e78:	cd 40                	int    $0x40
     e7a:	c3                   	ret

00000e7b <mkdir>:
SYSCALL(mkdir)
     e7b:	b8 14 00 00 00       	mov    $0x14,%eax
     e80:	cd 40                	int    $0x40
     e82:	c3                   	ret

00000e83 <chdir>:
SYSCALL(chdir)
     e83:	b8 09 00 00 00       	mov    $0x9,%eax
     e88:	cd 40                	int    $0x40
     e8a:	c3                   	ret

00000e8b <dup>:
SYSCALL(dup)
     e8b:	b8 0a 00 00 00       	mov    $0xa,%eax
     e90:	cd 40                	int    $0x40
     e92:	c3                   	ret

00000e93 <getpid>:
SYSCALL(getpid)
     e93:	b8 0b 00 00 00       	mov    $0xb,%eax
     e98:	cd 40                	int    $0x40
     e9a:	c3                   	ret

00000e9b <sbrk>:
SYSCALL(sbrk)
     e9b:	b8 0c 00 00 00       	mov    $0xc,%eax
     ea0:	cd 40                	int    $0x40
     ea2:	c3                   	ret

00000ea3 <sleep>:
SYSCALL(sleep)
     ea3:	b8 0d 00 00 00       	mov    $0xd,%eax
     ea8:	cd 40                	int    $0x40
     eaa:	c3                   	ret

00000eab <uptime>:
SYSCALL(uptime)
     eab:	b8 0e 00 00 00       	mov    $0xe,%eax
     eb0:	cd 40                	int    $0x40
     eb2:	c3                   	ret
     eb3:	66 90                	xchg   %ax,%ax
     eb5:	66 90                	xchg   %ax,%ax
     eb7:	66 90                	xchg   %ax,%ax
     eb9:	66 90                	xchg   %ax,%ax
     ebb:	66 90                	xchg   %ax,%ax
     ebd:	66 90                	xchg   %ax,%ax
     ebf:	90                   	nop

00000ec0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp
     ec3:	57                   	push   %edi
     ec4:	56                   	push   %esi
     ec5:	53                   	push   %ebx
     ec6:	83 ec 3c             	sub    $0x3c,%esp
     ec9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     ecc:	89 d1                	mov    %edx,%ecx
{
     ece:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     ed1:	85 d2                	test   %edx,%edx
     ed3:	0f 89 7f 00 00 00    	jns    f58 <printint+0x98>
     ed9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     edd:	74 79                	je     f58 <printint+0x98>
    neg = 1;
     edf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     ee6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     ee8:	31 db                	xor    %ebx,%ebx
     eea:	8d 75 d7             	lea    -0x29(%ebp),%esi
     eed:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     ef0:	89 c8                	mov    %ecx,%eax
     ef2:	31 d2                	xor    %edx,%edx
     ef4:	89 cf                	mov    %ecx,%edi
     ef6:	f7 75 c4             	divl   -0x3c(%ebp)
     ef9:	0f b6 92 e0 13 00 00 	movzbl 0x13e0(%edx),%edx
     f00:	89 45 c0             	mov    %eax,-0x40(%ebp)
     f03:	89 d8                	mov    %ebx,%eax
     f05:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     f08:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     f0b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     f0e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     f11:	76 dd                	jbe    ef0 <printint+0x30>
  if(neg)
     f13:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     f16:	85 c9                	test   %ecx,%ecx
     f18:	74 0c                	je     f26 <printint+0x66>
    buf[i++] = '-';
     f1a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     f1f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     f21:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     f26:	8b 7d b8             	mov    -0x48(%ebp),%edi
     f29:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     f2d:	eb 07                	jmp    f36 <printint+0x76>
     f2f:	90                   	nop
    putc(fd, buf[i]);
     f30:	0f b6 13             	movzbl (%ebx),%edx
     f33:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     f36:	83 ec 04             	sub    $0x4,%esp
     f39:	88 55 d7             	mov    %dl,-0x29(%ebp)
     f3c:	6a 01                	push   $0x1
     f3e:	56                   	push   %esi
     f3f:	57                   	push   %edi
     f40:	e8 ee fe ff ff       	call   e33 <write>
  while(--i >= 0)
     f45:	83 c4 10             	add    $0x10,%esp
     f48:	39 de                	cmp    %ebx,%esi
     f4a:	75 e4                	jne    f30 <printint+0x70>
}
     f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f4f:	5b                   	pop    %ebx
     f50:	5e                   	pop    %esi
     f51:	5f                   	pop    %edi
     f52:	5d                   	pop    %ebp
     f53:	c3                   	ret
     f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     f58:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     f5f:	eb 87                	jmp    ee8 <printint+0x28>
     f61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f68:	00 
     f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000f70 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     f70:	55                   	push   %ebp
     f71:	89 e5                	mov    %esp,%ebp
     f73:	57                   	push   %edi
     f74:	56                   	push   %esi
     f75:	53                   	push   %ebx
     f76:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
     f7c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
     f7f:	0f b6 13             	movzbl (%ebx),%edx
     f82:	84 d2                	test   %dl,%dl
     f84:	74 6a                	je     ff0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
     f86:	8d 45 10             	lea    0x10(%ebp),%eax
     f89:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
     f8c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     f8f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
     f91:	89 45 d0             	mov    %eax,-0x30(%ebp)
     f94:	eb 36                	jmp    fcc <printf+0x5c>
     f96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f9d:	00 
     f9e:	66 90                	xchg   %ax,%ax
     fa0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     fa3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
     fa8:	83 f8 25             	cmp    $0x25,%eax
     fab:	74 15                	je     fc2 <printf+0x52>
  write(fd, &c, 1);
     fad:	83 ec 04             	sub    $0x4,%esp
     fb0:	88 55 e7             	mov    %dl,-0x19(%ebp)
     fb3:	6a 01                	push   $0x1
     fb5:	57                   	push   %edi
     fb6:	56                   	push   %esi
     fb7:	e8 77 fe ff ff       	call   e33 <write>
     fbc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
     fbf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     fc2:	0f b6 13             	movzbl (%ebx),%edx
     fc5:	83 c3 01             	add    $0x1,%ebx
     fc8:	84 d2                	test   %dl,%dl
     fca:	74 24                	je     ff0 <printf+0x80>
    c = fmt[i] & 0xff;
     fcc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
     fcf:	85 c9                	test   %ecx,%ecx
     fd1:	74 cd                	je     fa0 <printf+0x30>
      }
    } else if(state == '%'){
     fd3:	83 f9 25             	cmp    $0x25,%ecx
     fd6:	75 ea                	jne    fc2 <printf+0x52>
      if(c == 'd'){
     fd8:	83 f8 25             	cmp    $0x25,%eax
     fdb:	0f 84 07 01 00 00    	je     10e8 <printf+0x178>
     fe1:	83 e8 63             	sub    $0x63,%eax
     fe4:	83 f8 15             	cmp    $0x15,%eax
     fe7:	77 17                	ja     1000 <printf+0x90>
     fe9:	ff 24 85 88 13 00 00 	jmp    *0x1388(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ff3:	5b                   	pop    %ebx
     ff4:	5e                   	pop    %esi
     ff5:	5f                   	pop    %edi
     ff6:	5d                   	pop    %ebp
     ff7:	c3                   	ret
     ff8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fff:	00 
  write(fd, &c, 1);
    1000:	83 ec 04             	sub    $0x4,%esp
    1003:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1006:	6a 01                	push   $0x1
    1008:	57                   	push   %edi
    1009:	56                   	push   %esi
    100a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    100e:	e8 20 fe ff ff       	call   e33 <write>
        putc(fd, c);
    1013:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1017:	83 c4 0c             	add    $0xc,%esp
    101a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    101d:	6a 01                	push   $0x1
    101f:	57                   	push   %edi
    1020:	56                   	push   %esi
    1021:	e8 0d fe ff ff       	call   e33 <write>
        putc(fd, c);
    1026:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1029:	31 c9                	xor    %ecx,%ecx
    102b:	eb 95                	jmp    fc2 <printf+0x52>
    102d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1030:	83 ec 0c             	sub    $0xc,%esp
    1033:	b9 10 00 00 00       	mov    $0x10,%ecx
    1038:	6a 00                	push   $0x0
    103a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    103d:	8b 10                	mov    (%eax),%edx
    103f:	89 f0                	mov    %esi,%eax
    1041:	e8 7a fe ff ff       	call   ec0 <printint>
        ap++;
    1046:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    104a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    104d:	31 c9                	xor    %ecx,%ecx
    104f:	e9 6e ff ff ff       	jmp    fc2 <printf+0x52>
    1054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1058:	8b 45 d0             	mov    -0x30(%ebp),%eax
    105b:	8b 10                	mov    (%eax),%edx
        ap++;
    105d:	83 c0 04             	add    $0x4,%eax
    1060:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1063:	85 d2                	test   %edx,%edx
    1065:	0f 84 8d 00 00 00    	je     10f8 <printf+0x188>
        while(*s != 0){
    106b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    106e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    1070:	84 c0                	test   %al,%al
    1072:	0f 84 4a ff ff ff    	je     fc2 <printf+0x52>
    1078:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    107b:	89 d3                	mov    %edx,%ebx
    107d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1080:	83 ec 04             	sub    $0x4,%esp
          s++;
    1083:	83 c3 01             	add    $0x1,%ebx
    1086:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1089:	6a 01                	push   $0x1
    108b:	57                   	push   %edi
    108c:	56                   	push   %esi
    108d:	e8 a1 fd ff ff       	call   e33 <write>
        while(*s != 0){
    1092:	0f b6 03             	movzbl (%ebx),%eax
    1095:	83 c4 10             	add    $0x10,%esp
    1098:	84 c0                	test   %al,%al
    109a:	75 e4                	jne    1080 <printf+0x110>
      state = 0;
    109c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    109f:	31 c9                	xor    %ecx,%ecx
    10a1:	e9 1c ff ff ff       	jmp    fc2 <printf+0x52>
    10a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10ad:	00 
    10ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    10b0:	83 ec 0c             	sub    $0xc,%esp
    10b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    10b8:	6a 01                	push   $0x1
    10ba:	e9 7b ff ff ff       	jmp    103a <printf+0xca>
    10bf:	90                   	nop
        putc(fd, *ap);
    10c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    10c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    10c6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    10c8:	6a 01                	push   $0x1
    10ca:	57                   	push   %edi
    10cb:	56                   	push   %esi
        putc(fd, *ap);
    10cc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    10cf:	e8 5f fd ff ff       	call   e33 <write>
        ap++;
    10d4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    10d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
    10db:	31 c9                	xor    %ecx,%ecx
    10dd:	e9 e0 fe ff ff       	jmp    fc2 <printf+0x52>
    10e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    10e8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    10eb:	83 ec 04             	sub    $0x4,%esp
    10ee:	e9 2a ff ff ff       	jmp    101d <printf+0xad>
    10f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          s = "(null)";
    10f8:	ba 4f 13 00 00       	mov    $0x134f,%edx
        while(*s != 0){
    10fd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1100:	b8 28 00 00 00       	mov    $0x28,%eax
    1105:	89 d3                	mov    %edx,%ebx
    1107:	e9 74 ff ff ff       	jmp    1080 <printf+0x110>
    110c:	66 90                	xchg   %ax,%ax
    110e:	66 90                	xchg   %ax,%ax

00001110 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1110:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1111:	a1 44 1a 00 00       	mov    0x1a44,%eax
{
    1116:	89 e5                	mov    %esp,%ebp
    1118:	57                   	push   %edi
    1119:	56                   	push   %esi
    111a:	53                   	push   %ebx
    111b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    111e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1128:	89 c2                	mov    %eax,%edx
    112a:	8b 00                	mov    (%eax),%eax
    112c:	39 ca                	cmp    %ecx,%edx
    112e:	73 30                	jae    1160 <free+0x50>
    1130:	39 c1                	cmp    %eax,%ecx
    1132:	72 04                	jb     1138 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1134:	39 c2                	cmp    %eax,%edx
    1136:	72 f0                	jb     1128 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1138:	8b 73 fc             	mov    -0x4(%ebx),%esi
    113b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    113e:	39 f8                	cmp    %edi,%eax
    1140:	74 30                	je     1172 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1142:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1145:	8b 42 04             	mov    0x4(%edx),%eax
    1148:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    114b:	39 f1                	cmp    %esi,%ecx
    114d:	74 3a                	je     1189 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    114f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1151:	5b                   	pop    %ebx
  freep = p;
    1152:	89 15 44 1a 00 00    	mov    %edx,0x1a44
}
    1158:	5e                   	pop    %esi
    1159:	5f                   	pop    %edi
    115a:	5d                   	pop    %ebp
    115b:	c3                   	ret
    115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1160:	39 c2                	cmp    %eax,%edx
    1162:	72 c4                	jb     1128 <free+0x18>
    1164:	39 c1                	cmp    %eax,%ecx
    1166:	73 c0                	jae    1128 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    1168:	8b 73 fc             	mov    -0x4(%ebx),%esi
    116b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    116e:	39 f8                	cmp    %edi,%eax
    1170:	75 d0                	jne    1142 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    1172:	03 70 04             	add    0x4(%eax),%esi
    1175:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1178:	8b 02                	mov    (%edx),%eax
    117a:	8b 00                	mov    (%eax),%eax
    117c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    117f:	8b 42 04             	mov    0x4(%edx),%eax
    1182:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    1185:	39 f1                	cmp    %esi,%ecx
    1187:	75 c6                	jne    114f <free+0x3f>
    p->s.size += bp->s.size;
    1189:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    118c:	89 15 44 1a 00 00    	mov    %edx,0x1a44
    p->s.size += bp->s.size;
    1192:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    1195:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    1198:	89 0a                	mov    %ecx,(%edx)
}
    119a:	5b                   	pop    %ebx
    119b:	5e                   	pop    %esi
    119c:	5f                   	pop    %edi
    119d:	5d                   	pop    %ebp
    119e:	c3                   	ret
    119f:	90                   	nop

000011a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	57                   	push   %edi
    11a4:	56                   	push   %esi
    11a5:	53                   	push   %ebx
    11a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    11ac:	8b 3d 44 1a 00 00    	mov    0x1a44,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11b2:	8d 70 07             	lea    0x7(%eax),%esi
    11b5:	c1 ee 03             	shr    $0x3,%esi
    11b8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    11bb:	85 ff                	test   %edi,%edi
    11bd:	0f 84 9d 00 00 00    	je     1260 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11c3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    11c5:	8b 4a 04             	mov    0x4(%edx),%ecx
    11c8:	39 f1                	cmp    %esi,%ecx
    11ca:	73 6a                	jae    1236 <malloc+0x96>
    11cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
    11d1:	39 de                	cmp    %ebx,%esi
    11d3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    11d6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    11dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    11e0:	eb 17                	jmp    11f9 <malloc+0x59>
    11e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    11ea:	8b 48 04             	mov    0x4(%eax),%ecx
    11ed:	39 f1                	cmp    %esi,%ecx
    11ef:	73 4f                	jae    1240 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11f1:	8b 3d 44 1a 00 00    	mov    0x1a44,%edi
    11f7:	89 c2                	mov    %eax,%edx
    11f9:	39 d7                	cmp    %edx,%edi
    11fb:	75 eb                	jne    11e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    11fd:	83 ec 0c             	sub    $0xc,%esp
    1200:	ff 75 e4             	push   -0x1c(%ebp)
    1203:	e8 93 fc ff ff       	call   e9b <sbrk>
  if(p == (char*)-1)
    1208:	83 c4 10             	add    $0x10,%esp
    120b:	83 f8 ff             	cmp    $0xffffffff,%eax
    120e:	74 1c                	je     122c <malloc+0x8c>
  hp->s.size = nu;
    1210:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1213:	83 ec 0c             	sub    $0xc,%esp
    1216:	83 c0 08             	add    $0x8,%eax
    1219:	50                   	push   %eax
    121a:	e8 f1 fe ff ff       	call   1110 <free>
  return freep;
    121f:	8b 15 44 1a 00 00    	mov    0x1a44,%edx
      if((p = morecore(nunits)) == 0)
    1225:	83 c4 10             	add    $0x10,%esp
    1228:	85 d2                	test   %edx,%edx
    122a:	75 bc                	jne    11e8 <malloc+0x48>
        return 0;
  }
}
    122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    122f:	31 c0                	xor    %eax,%eax
}
    1231:	5b                   	pop    %ebx
    1232:	5e                   	pop    %esi
    1233:	5f                   	pop    %edi
    1234:	5d                   	pop    %ebp
    1235:	c3                   	ret
    if(p->s.size >= nunits){
    1236:	89 d0                	mov    %edx,%eax
    1238:	89 fa                	mov    %edi,%edx
    123a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1240:	39 ce                	cmp    %ecx,%esi
    1242:	74 4c                	je     1290 <malloc+0xf0>
        p->s.size -= nunits;
    1244:	29 f1                	sub    %esi,%ecx
    1246:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1249:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    124c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    124f:	89 15 44 1a 00 00    	mov    %edx,0x1a44
}
    1255:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1258:	83 c0 08             	add    $0x8,%eax
}
    125b:	5b                   	pop    %ebx
    125c:	5e                   	pop    %esi
    125d:	5f                   	pop    %edi
    125e:	5d                   	pop    %ebp
    125f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
    1260:	c7 05 44 1a 00 00 48 	movl   $0x1a48,0x1a44
    1267:	1a 00 00 
    base.s.size = 0;
    126a:	bf 48 1a 00 00       	mov    $0x1a48,%edi
    base.s.ptr = freep = prevp = &base;
    126f:	c7 05 48 1a 00 00 48 	movl   $0x1a48,0x1a48
    1276:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1279:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    127b:	c7 05 4c 1a 00 00 00 	movl   $0x0,0x1a4c
    1282:	00 00 00 
    if(p->s.size >= nunits){
    1285:	e9 42 ff ff ff       	jmp    11cc <malloc+0x2c>
    128a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1290:	8b 08                	mov    (%eax),%ecx
    1292:	89 0a                	mov    %ecx,(%edx)
    1294:	eb b9                	jmp    124f <malloc+0xaf>
