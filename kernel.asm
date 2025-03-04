
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 56 11 80       	mov    $0x80115650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 74 10 80       	push   $0x801074e0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 a5 44 00 00       	call   80104500 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 74 10 80       	push   $0x801074e7
80100097:	50                   	push   %eax
80100098:	e8 33 43 00 00       	call   801043d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 e7 45 00 00       	call   801046d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 09 45 00 00       	call   80104670 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 42 00 00       	call   80104410 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 74 10 80       	push   $0x801074ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 42 00 00       	call   801044b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 74 10 80       	push   $0x801074ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 42 00 00       	call   801044b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 42 00 00       	call   80104470 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 b0 44 00 00       	call   801046d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ff 43 00 00       	jmp    80104670 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 75 10 80       	push   $0x80107506
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 2b 44 00 00       	call   801046d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 9e 3e 00 00       	call   80104170 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 37 00 00       	call   80103a30 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 75 43 00 00       	call   80104670 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 1f 43 00 00       	call   80104670 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 75 10 80       	push   $0x8010750d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 ae 79 10 80 	movl   $0x801079ae,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 41 00 00       	call   80104520 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 75 10 80       	push   $0x80107521
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 e1 5b 00 00       	call   80106000 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 f6 5a 00 00       	call   80106000 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ea 5a 00 00       	call   80106000 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 de 5a 00 00       	call   80106000 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 da 42 00 00       	call   80104830 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 25 42 00 00       	call   80104790 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 75 10 80       	push   $0x80107525
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058a:	00 
8010058b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 20 41 00 00       	call   801046d0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 87 40 00 00       	call   80104670 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 00 7a 10 80 	movzbl -0x7fef8600(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret
80100692:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100699:	00 
8010069a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 e3 3e 00 00       	call   801046d0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        s = "(null)";
80100838:	bf 38 75 10 80       	mov    $0x80107538,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 10 3e 00 00       	call   80104670 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 75 10 80       	push   $0x8010753f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 38 3e 00 00       	call   801046d0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010097f:	00 
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 9b 3c 00 00       	call   80104670 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 fd 38 00 00       	jmp    80104310 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 e7 37 00 00       	call   80104230 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a58:	00 
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 48 75 10 80       	push   $0x80107548
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 8b 3a 00 00       	call   80104500 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 6f 2f 00 00       	call   80103a30 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 57 66 00 00       	call   80107190 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100b6f:	00 
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 08 64 00 00       	call   80106fb0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 e2 62 00 00       	call   80106ec0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 f0 64 00 00       	call   80107110 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100c2f:	00 
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 49 63 00 00       	call   80106fb0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 a8 65 00 00       	call   80107230 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 b8 3c 00 00       	call   80104990 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 a4 3c 00 00       	call   80104990 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 03 67 00 00       	call   80107400 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 fa 63 00 00       	call   80107110 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 98 66 00 00       	call   80107400 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 aa 3b 00 00       	call   80104950 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 5e 5f 00 00       	call   80106d30 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 36 63 00 00       	call   80107110 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 50 75 10 80       	push   $0x80107550
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 5c 75 10 80       	push   $0x8010755c
80100e1b:	68 60 ef 10 80       	push   $0x8010ef60
80100e20:	e8 db 36 00 00       	call   80104500 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave
80100e29:	c3                   	ret
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ef 10 80       	push   $0x8010ef60
80100e41:	e8 8a 38 00 00       	call   801046d0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ef 10 80       	push   $0x8010ef60
80100e71:	e8 fa 37 00 00       	call   80104670 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave
80100e7f:	c3                   	ret
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ef 10 80       	push   $0x8010ef60
80100e8a:	e8 e1 37 00 00       	call   80104670 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave
80100e98:	c3                   	ret
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ef 10 80       	push   $0x8010ef60
80100eaf:	e8 1c 38 00 00       	call   801046d0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ef 10 80       	push   $0x8010ef60
80100ecc:	e8 9f 37 00 00       	call   80104670 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave
80100ed7:	c3                   	ret
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 63 75 10 80       	push   $0x80107563
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100eec:	00 
80100eed:	8d 76 00             	lea    0x0(%esi),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 ca 37 00 00       	call   801046d0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 2f 37 00 00       	call   80104670 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret
80100f56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f5d:	00 
80100f5e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f60:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 fd 36 00 00       	jmp    80104670 <release>
80100f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f9e:	00 
80100f9f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 6b 75 10 80       	push   $0x8010756b
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fcd:	00 
80100fce:	66 90                	xchg   %ax,%ax

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave
80101009:	c3                   	ret
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave
80101019:	c3                   	ret
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 75 75 10 80       	push   $0x80107575
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 7e 75 10 80       	push   $0x8010757e
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 84 75 10 80       	push   $0x80107584
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 8e 75 10 80       	push   $0x8010758e
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101238:	00 
80101239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 a1 75 10 80       	push   $0x801075a1
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 66 34 00 00       	call   80104790 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret
80101344:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010134b:	00 
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 f9 10 80       	push   $0x8010f960
8010136a:	e8 61 33 00 00       	call   801046d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010137e:	00 
8010137f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 f9 10 80       	push   $0x8010f960
801013d7:	e8 94 32 00 00       	call   80104670 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 66 32 00 00       	call   80104670 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 b7 75 10 80       	push   $0x801075b7
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101449:	00 
8010144a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014ee:	00 
801014ef:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 c7 75 10 80       	push   $0x801075c7
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 ea 32 00 00       	call   80104830 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010155e:	00 
8010155f:	90                   	nop

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 da 75 10 80       	push   $0x801075da
80101571:	68 60 f9 10 80       	push   $0x8010f960
80101576:	e8 85 2f 00 00       	call   80104500 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 e1 75 10 80       	push   $0x801075e1
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 3c 2e 00 00       	call   801043d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 15 11 80       	push   $0x801115b4
801015bc:	e8 6f 32 00 00       	call   80104830 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 15 11 80    	push   0x801115cc
801015cf:	ff 35 c8 15 11 80    	push   0x801115c8
801015d5:	ff 35 c4 15 11 80    	push   0x801115c4
801015db:	ff 35 c0 15 11 80    	push   0x801115c0
801015e1:	ff 35 bc 15 11 80    	push   0x801115bc
801015e7:	ff 35 b8 15 11 80    	push   0x801115b8
801015ed:	ff 35 b4 15 11 80    	push   0x801115b4
801015f3:	68 14 7a 10 80       	push   $0x80107a14
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave
80101604:	c3                   	ret
80101605:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010160c:	00 
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010163d:	00 
8010163e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 fd 30 00 00       	call   80104790 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 e7 75 10 80       	push   $0x801075e7
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 fa 30 00 00       	call   80104830 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 f9 10 80       	push   $0x8010f960
8010175f:	e8 6c 2f 00 00       	call   801046d0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010176f:	e8 fc 2e 00 00       	call   80104670 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave
8010177a:	c3                   	ret
8010177b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 69 2c 00 00       	call   80104410 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret
801017b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017bf:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 13 30 00 00       	call   80104830 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 ff 75 10 80       	push   $0x801075ff
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 f9 75 10 80       	push   $0x801075f9
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010185b:	00 
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 38 2c 00 00       	call   801044b0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 dc 2b 00 00       	jmp    80104470 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 0e 76 10 80       	push   $0x8010760e
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018a8:	00 
801018a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 4b 2b 00 00       	call   80104410 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 91 2b 00 00       	call   80104470 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018e6:	e8 e5 2d 00 00       	call   801046d0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 6b 2d 00 00       	jmp    80104670 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 f9 10 80       	push   $0x8010f960
80101910:	e8 bb 2d 00 00       	call   801046d0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010191f:	e8 4c 2d 00 00       	call   80104670 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a0a:	00 
80101a0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 88 2a 00 00       	call   801044b0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 31 2a 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 0e 76 10 80       	push   $0x8010760e
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret
80101a8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 f4 2c 00 00       	call   80104830 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b8f:	00 

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 f8 2b 00 00       	call   80104830 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cba:	00 
80101cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 cd 2b 00 00       	call   801048a0 <strncmp>
}
80101cd3:	c9                   	leave
80101cd4:	c3                   	ret
80101cd5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cdc:	00 
80101cdd:	8d 76 00             	lea    0x0(%esi),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 6e 2b 00 00       	call   801048a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret
80101d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 28 76 10 80       	push   $0x80107628
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 16 76 10 80       	push   $0x80107616
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 81 1c 00 00       	call   80103a30 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 f9 10 80       	push   $0x8010f960
80101dba:	e8 11 29 00 00       	call   801046d0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dca:	e8 a1 28 00 00       	call   80104670 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 04 2a 00 00       	call   80104830 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 1f 26 00 00       	call   801044b0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 bd 25 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 50 29 00 00       	call   80104830 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 80 25 00 00       	call   801044b0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 21 25 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 3e 25 00 00       	call   801044b0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 1b 25 00 00       	call   801044b0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 c4 24 00 00       	call   80104470 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 0e 76 10 80       	push   $0x8010760e
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 ae 28 00 00       	call   801048f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 37 76 10 80       	push   $0x80107637
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 b2 78 10 80       	push   $0x801078b2
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102099:	00 
8010209a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave
801020b4:	c3                   	ret
801020b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020bc:	00 
801020bd:	8d 76 00             	lea    0x0(%esi),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010210e:	00 
8010210f:	90                   	nop
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 4d 76 10 80       	push   $0x8010764d
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 44 76 10 80       	push   $0x80107644
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021b9:	00 
801021ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 5f 76 10 80       	push   $0x8010765f
801021cb:	68 00 16 11 80       	push   $0x80111600
801021d0:	e8 2b 23 00 00       	call   80104500 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave
80102230:	c3                   	ret
80102231:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102238:	00 
80102239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 16 11 80       	push   $0x80111600
8010224e:	e8 7d 24 00 00       	call   801046d0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010227e:	00 
8010227f:	90                   	nop
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 7e 1f 00 00       	call   80104230 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 16 11 80       	push   $0x80111600
801022cb:	e8 a0 23 00 00       	call   80104670 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret
801022d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022df:	00 

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 bd 21 00 00       	call   801044b0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 16 11 80       	push   $0x80111600
80102328:	e8 a3 23 00 00       	call   801046d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 16 11 80       	push   $0x80111600
80102368:	53                   	push   %ebx
80102369:	e8 02 1e 00 00       	call   80104170 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave
  release(&idelock);
80102386:	e9 e5 22 00 00       	jmp    80104670 <release>
8010238b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 8e 76 10 80       	push   $0x8010768e
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 79 76 10 80       	push   $0x80107679
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 63 76 10 80       	push   $0x80107663
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 68 7a 10 80       	push   $0x80107a68
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret
80102476:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010247d:	00 
8010247e:	66 90                	xchg   %ax,%ax

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 50 56 11 80    	cmp    $0x80115650,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 99 22 00 00       	call   80104790 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 16 11 80       	mov    0x80111678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave
8010251e:	c3                   	ret
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 16 11 80       	push   $0x80111640
80102528:	e8 a3 21 00 00       	call   801046d0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave
    release(&kmem.lock);
80102543:	e9 28 21 00 00       	jmp    80104670 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 ac 76 10 80       	push   $0x801076ac
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010255c:	00 
8010255d:	8d 76 00             	lea    0x0(%esi),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret
801025ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret
80102605:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010260c:	00 
8010260d:	8d 76 00             	lea    0x0(%esi),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 b2 76 10 80       	push   $0x801076b2
80102620:	68 40 16 11 80       	push   $0x80111640
80102625:	e8 d6 1e 00 00       	call   80104500 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret
80102673:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010267a:	00 
8010267b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 16 11 80       	mov    0x80111674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
8010269a:	c3                   	ret
8010269b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 16 11 80       	push   $0x80111640
801026b3:	e8 18 20 00 00       	call   801046d0 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 16 11 80       	push   $0x80111640
801026e1:	e8 8a 1f 00 00       	call   80104670 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave
801026ed:	c3                   	ret
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 e0 7c 10 80 	movzbl -0x7fef8320(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 e0 7b 10 80 	movzbl -0x7fef8420(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 c0 7b 10 80 	mov    -0x7fef8440(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave
80102767:	c3                   	ret
80102768:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010276f:	00 
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave
8010277f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 e0 7c 10 80 	movzbl -0x7fef8320(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave
801027a4:	c3                   	ret
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret
801027c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027cd:	00 
801027ce:	66 90                	xchg   %ax,%ax

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave
801027e4:	c3                   	ret
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028ae:	00 
801028af:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028e9:	00 
801028ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret
80102903:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010290a:	00 
8010290b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 16 11 80       	mov    0x80111680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret
80102927:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010292e:	00 
8010292f:	90                   	nop

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret
80102931:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102938:	00 
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave
801029ce:	c3                   	ret
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 e4 1c 00 00       	call   801047e0 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 16 11 80    	push   0x801116e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c04:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 07 1c 00 00       	call   80104830 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 16 11 80    	push   0x801116d4
80102c6d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave
80102cba:	c3                   	ret
80102cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 b7 76 10 80       	push   $0x801076b7
80102ccf:	68 a0 16 11 80       	push   $0x801116a0
80102cd4:	e8 27 18 00 00       	call   80104500 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d1e:	00 
80102d1f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave
80102d56:	c3                   	ret
80102d57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d5e:	00 
80102d5f:	90                   	nop

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 16 11 80       	push   $0x801116a0
80102d6b:	e8 60 19 00 00       	call   801046d0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 16 11 80       	push   $0x801116a0
80102d80:	68 a0 16 11 80       	push   $0x801116a0
80102d85:	e8 e6 13 00 00       	call   80104170 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102d9b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102db7:	68 a0 16 11 80       	push   $0x801116a0
80102dbc:	e8 af 18 00 00       	call   80104670 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave
80102dc5:	c3                   	ret
80102dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dcd:	00 
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 16 11 80       	push   $0x801116a0
80102dde:	e8 ed 18 00 00       	call   801046d0 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 16 11 80       	push   $0x801116a0
80102e1c:	e8 4f 18 00 00       	call   80104670 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 16 11 80       	push   $0x801116a0
80102e36:	e8 95 18 00 00       	call   801046d0 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 df 13 00 00       	call   80104230 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e58:	e8 13 18 00 00       	call   80104670 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret
80102e68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e6f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102e94:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 77 19 00 00       	call   80104830 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 16 11 80       	push   $0x801116a0
80102f08:	e8 23 13 00 00       	call   80104230 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f14:	e8 57 17 00 00       	call   80104670 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 bb 76 10 80       	push   $0x801076bb
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f38:	00 
80102f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 16 11 80       	push   $0x801116a0
80102f76:	e8 55 17 00 00       	call   801046d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fb4:	c9                   	leave
  release(&log.lock);
80102fb5:	e9 b6 16 00 00       	jmp    80104670 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 ca 76 10 80       	push   $0x801076ca
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 e0 76 10 80       	push   $0x801076e0
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 04 0a 00 00       	call   80103a10 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 fd 09 00 00       	call   80103a10 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 fb 76 10 80       	push   $0x801076fb
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 09 2c 00 00       	call   80105c30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 84 09 00 00       	call   801039b0 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 b1 0c 00 00       	call   80103cf0 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 d5 3c 00 00       	call   80106d20 <switchkvm>
  seginit();
8010304b:	e8 40 3c 00 00       	call   80106c90 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 50 56 11 80       	push   $0x80115650
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 8a 41 00 00       	call   80107210 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 fb 3b 00 00       	call   80106c90 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 77 2e 00 00       	call   80105f20 <uartinit>
  pinit();         // process table
801030a9:	e8 e2 08 00 00       	call   80103990 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 fd 2a 00 00       	call   80105bb0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c a4 10 80       	push   $0x8010a48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 57 17 00 00       	call   80104830 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030eb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 92 08 00 00       	call   801039b0 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010313b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 d9 08 00 00       	call   80103a60 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031af:	00 
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 0f 77 10 80       	push   $0x8010770f
801031c3:	56                   	push   %esi
801031c4:	e8 17 16 00 00       	call   801047e0 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret
80103204:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010320b:	00 
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 14 77 10 80       	push   $0x80107714
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 5c 15 00 00       	call   801047e0 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 19 77 10 80       	push   $0x80107719
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033ae:	00 
801033af:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 0f 77 10 80       	push   $0x8010770f
801033c7:	53                   	push   %ebx
801033c8:	e8 13 14 00 00       	call   801047e0 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033dd:	00 
801033de:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 9c 7a 10 80       	push   $0x80107a9c
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 31 77 10 80       	push   $0x80107731
801034a8:	50                   	push   %eax
801034a9:	e8 52 10 00 00       	call   80104500 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 8c 11 00 00       	call   801046d0 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 cc 0c 00 00       	call   80104230 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 e7 10 00 00       	jmp    80104670 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 d7 10 00 00       	call   80104670 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 67 0c 00 00       	call   80104230 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 ee 10 00 00       	call   801046d0 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 03 04 00 00       	call   80103a30 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 f3 0b 00 00       	call   80104230 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 2a 0b 00 00       	call   80104170 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 ff 0f 00 00       	call   80104670 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 71 0b 00 00       	call   80104230 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 a9 0f 00 00       	call   80104670 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 e5 0f 00 00       	call   801046d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 2b 03 00 00       	call   80103a30 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 56 0a 00 00       	call   80104170 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 b5 0a 00 00       	call   80104230 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 ed 0e 00 00       	call   80104670 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 d2 0e 00 00       	call   80104670 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b5:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
  acquire(&ptable.lock);
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	68 20 1d 11 80       	push   $0x80111d20
801037c2:	e8 09 0f 00 00       	call   801046d0 <acquire>
801037c7:	83 c4 10             	add    $0x10,%esp
801037ca:	eb 13                	jmp    801037df <allocproc+0x2f>
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	83 c3 7c             	add    $0x7c,%ebx
801037d3:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801037d9:	0f 84 31 01 00 00    	je     80103910 <allocproc+0x160>
    if(p->state == UNUSED)
801037df:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e2:	85 c0                	test   %eax,%eax
801037e4:	75 ea                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e6:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037eb:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037ee:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f5:	89 43 10             	mov    %eax,0x10(%ebx)
801037f8:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037fb:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
80103800:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103806:	e8 65 0e 00 00       	call   80104670 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010380b:	e8 70 ee ff ff       	call   80102680 <kalloc>
80103810:	83 c4 10             	add    $0x10,%esp
80103813:	89 43 08             	mov    %eax,0x8(%ebx)
80103816:	85 c0                	test   %eax,%eax
80103818:	0f 84 0d 01 00 00    	je     8010392b <allocproc+0x17b>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010381e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103824:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103827:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010382c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010382f:	c7 40 14 9f 5b 10 80 	movl   $0x80105b9f,0x14(%eax)
  p->context = (struct context*)sp;
80103836:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103839:	6a 14                	push   $0x14
8010383b:	6a 00                	push   $0x0
8010383d:	50                   	push   %eax
8010383e:	e8 4d 0f 00 00       	call   80104790 <memset>
  p->context->eip = (uint)forkret;
80103843:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid == 1 || p->pid == 2) {
80103846:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103849:	c7 40 10 40 39 10 80 	movl   $0x80103940,0x10(%eax)
  if(p->pid == 1 || p->pid == 2) {
80103850:	8b 43 10             	mov    0x10(%ebx),%eax
80103853:	83 e8 01             	sub    $0x1,%eax
80103856:	83 f8 01             	cmp    $0x1,%eax
80103859:	0f 86 9e 00 00 00    	jbe    801038fd <allocproc+0x14d>
    return p;
  }

  // Make sure process name is set before adding to history
  safestrcpy(p->name, "unknown", sizeof(p->name));  // Default name
8010385f:	83 ec 04             	sub    $0x4,%esp
80103862:	8d 73 6c             	lea    0x6c(%ebx),%esi
80103865:	6a 10                	push   $0x10
80103867:	68 36 77 10 80       	push   $0x80107736
8010386c:	56                   	push   %esi
8010386d:	e8 de 10 00 00       	call   80104950 <safestrcpy>

  // Add process to history (Circular Buffer)
  acquire(&ptable.lock);
80103872:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103879:	e8 52 0e 00 00       	call   801046d0 <acquire>
  process_history[history_index].pid = p->pid;
8010387e:	a1 54 3c 11 80       	mov    0x80113c54,%eax
80103883:	8b 53 10             	mov    0x10(%ebx),%edx
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
80103886:	83 c4 0c             	add    $0xc,%esp
80103889:	6a 10                	push   $0x10
  process_history[history_index].pid = p->pid;
8010388b:	8d 04 40             	lea    (%eax,%eax,2),%eax
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
8010388e:	56                   	push   %esi
  process_history[history_index].pid = p->pid;
8010388f:	c1 e0 03             	shl    $0x3,%eax
80103892:	89 90 60 3c 11 80    	mov    %edx,-0x7feec3a0(%eax)
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
80103898:	05 64 3c 11 80       	add    $0x80113c64,%eax
8010389d:	50                   	push   %eax
8010389e:	e8 ad 10 00 00       	call   80104950 <safestrcpy>
  process_history[history_index].mem_usage = p->sz;
801038a3:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
801038a9:	8b 13                	mov    (%ebx),%edx

  // Update history index (Circular Buffer)
  history_index = (history_index + 1) % MAX_HISTORY;
  if (history_count < MAX_HISTORY) {
801038ab:	83 c4 10             	add    $0x10,%esp
  process_history[history_index].mem_usage = p->sz;
801038ae:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  history_index = (history_index + 1) % MAX_HISTORY;
801038b1:	83 c1 01             	add    $0x1,%ecx
  process_history[history_index].mem_usage = p->sz;
801038b4:	89 14 c5 74 3c 11 80 	mov    %edx,-0x7feec38c(,%eax,8)
  history_index = (history_index + 1) % MAX_HISTORY;
801038bb:	89 c8                	mov    %ecx,%eax
801038bd:	ba 67 66 66 66       	mov    $0x66666667,%edx
801038c2:	f7 ea                	imul   %edx
801038c4:	89 c8                	mov    %ecx,%eax
801038c6:	c1 f8 1f             	sar    $0x1f,%eax
801038c9:	c1 fa 02             	sar    $0x2,%edx
801038cc:	29 c2                	sub    %eax,%edx
801038ce:	8d 04 92             	lea    (%edx,%edx,4),%eax
801038d1:	01 c0                	add    %eax,%eax
801038d3:	29 c1                	sub    %eax,%ecx
  if (history_count < MAX_HISTORY) {
801038d5:	a1 58 3c 11 80       	mov    0x80113c58,%eax
  history_index = (history_index + 1) % MAX_HISTORY;
801038da:	89 0d 54 3c 11 80    	mov    %ecx,0x80113c54
  if (history_count < MAX_HISTORY) {
801038e0:	83 f8 09             	cmp    $0x9,%eax
801038e3:	7f 08                	jg     801038ed <allocproc+0x13d>
      history_count++;  // Keep track of number of stored records
801038e5:	83 c0 01             	add    $0x1,%eax
801038e8:	a3 58 3c 11 80       	mov    %eax,0x80113c58
  }
  release(&ptable.lock);
801038ed:	83 ec 0c             	sub    $0xc,%esp
801038f0:	68 20 1d 11 80       	push   $0x80111d20
801038f5:	e8 76 0d 00 00       	call   80104670 <release>

  return p;
801038fa:	83 c4 10             	add    $0x10,%esp
}
801038fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103900:	89 d8                	mov    %ebx,%eax
80103902:	5b                   	pop    %ebx
80103903:	5e                   	pop    %esi
80103904:	5d                   	pop    %ebp
80103905:	c3                   	ret
80103906:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010390d:	00 
8010390e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103910:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103913:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103915:	68 20 1d 11 80       	push   $0x80111d20
8010391a:	e8 51 0d 00 00       	call   80104670 <release>
  return 0;
8010391f:	83 c4 10             	add    $0x10,%esp
}
80103922:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103925:	89 d8                	mov    %ebx,%eax
80103927:	5b                   	pop    %ebx
80103928:	5e                   	pop    %esi
80103929:	5d                   	pop    %ebp
8010392a:	c3                   	ret
    p->state = UNUSED;
8010392b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103932:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80103935:	31 db                	xor    %ebx,%ebx
}
80103937:	89 d8                	mov    %ebx,%eax
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret
8010393d:	8d 76 00             	lea    0x0(%esi),%esi

80103940 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103946:	68 20 1d 11 80       	push   $0x80111d20
8010394b:	e8 20 0d 00 00       	call   80104670 <release>

  if (first) {
80103950:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	85 c0                	test   %eax,%eax
8010395a:	75 04                	jne    80103960 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010395c:	c9                   	leave
8010395d:	c3                   	ret
8010395e:	66 90                	xchg   %ax,%ax
    first = 0;
80103960:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103967:	00 00 00 
    iinit(ROOTDEV);
8010396a:	83 ec 0c             	sub    $0xc,%esp
8010396d:	6a 01                	push   $0x1
8010396f:	e8 ec db ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103974:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010397b:	e8 40 f3 ff ff       	call   80102cc0 <initlog>
}
80103980:	83 c4 10             	add    $0x10,%esp
80103983:	c9                   	leave
80103984:	c3                   	ret
80103985:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010398c:	00 
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

80103990 <pinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103996:	68 3e 77 10 80       	push   $0x8010773e
8010399b:	68 20 1d 11 80       	push   $0x80111d20
801039a0:	e8 5b 0b 00 00       	call   80104500 <initlock>
}
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	c9                   	leave
801039a9:	c3                   	ret
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <mycpu>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039b5:	9c                   	pushf
801039b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039b7:	f6 c4 02             	test   $0x2,%ah
801039ba:	75 46                	jne    80103a02 <mycpu+0x52>
  apicid = lapicid();
801039bc:	e8 2f ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039c1:	8b 35 84 17 11 80    	mov    0x80111784,%esi
801039c7:	85 f6                	test   %esi,%esi
801039c9:	7e 2a                	jle    801039f5 <mycpu+0x45>
801039cb:	31 d2                	xor    %edx,%edx
801039cd:	eb 08                	jmp    801039d7 <mycpu+0x27>
801039cf:	90                   	nop
801039d0:	83 c2 01             	add    $0x1,%edx
801039d3:	39 f2                	cmp    %esi,%edx
801039d5:	74 1e                	je     801039f5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039d7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039dd:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
801039e4:	39 c3                	cmp    %eax,%ebx
801039e6:	75 e8                	jne    801039d0 <mycpu+0x20>
}
801039e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039eb:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
801039f1:	5b                   	pop    %ebx
801039f2:	5e                   	pop    %esi
801039f3:	5d                   	pop    %ebp
801039f4:	c3                   	ret
  panic("unknown apicid\n");
801039f5:	83 ec 0c             	sub    $0xc,%esp
801039f8:	68 45 77 10 80       	push   $0x80107745
801039fd:	e8 7e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a02:	83 ec 0c             	sub    $0xc,%esp
80103a05:	68 bc 7a 10 80       	push   $0x80107abc
80103a0a:	e8 71 c9 ff ff       	call   80100380 <panic>
80103a0f:	90                   	nop

80103a10 <cpuid>:
cpuid() {
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a16:	e8 95 ff ff ff       	call   801039b0 <mycpu>
}
80103a1b:	c9                   	leave
  return mycpu()-cpus;
80103a1c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103a21:	c1 f8 04             	sar    $0x4,%eax
80103a24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a2a:	c3                   	ret
80103a2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a30 <myproc>:
myproc(void) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a37:	e8 44 0b 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103a3c:	e8 6f ff ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103a41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a47:	e8 84 0b 00 00       	call   801045d0 <popcli>
}
80103a4c:	89 d8                	mov    %ebx,%eax
80103a4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a51:	c9                   	leave
80103a52:	c3                   	ret
80103a53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a5a:	00 
80103a5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a60 <userinit>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a67:	e8 44 fd ff ff       	call   801037b0 <allocproc>
80103a6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a6e:	a3 50 3d 11 80       	mov    %eax,0x80113d50
  if((p->pgdir = setupkvm()) == 0)
80103a73:	e8 18 37 00 00       	call   80107190 <setupkvm>
80103a78:	89 43 04             	mov    %eax,0x4(%ebx)
80103a7b:	85 c0                	test   %eax,%eax
80103a7d:	0f 84 bd 00 00 00    	je     80103b40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a83:	83 ec 04             	sub    $0x4,%esp
80103a86:	68 2c 00 00 00       	push   $0x2c
80103a8b:	68 60 a4 10 80       	push   $0x8010a460
80103a90:	50                   	push   %eax
80103a91:	e8 aa 33 00 00       	call   80106e40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a9f:	6a 4c                	push   $0x4c
80103aa1:	6a 00                	push   $0x0
80103aa3:	ff 73 18             	push   0x18(%ebx)
80103aa6:	e8 e5 0c 00 00       	call   80104790 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aab:	8b 43 18             	mov    0x18(%ebx),%eax
80103aae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ab3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ab6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103abf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ac6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103acd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ad1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ad8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103adc:	8b 43 18             	mov    0x18(%ebx),%eax
80103adf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ae6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103af0:	8b 43 18             	mov    0x18(%ebx),%eax
80103af3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103afa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103afd:	6a 10                	push   $0x10
80103aff:	68 6e 77 10 80       	push   $0x8010776e
80103b04:	50                   	push   %eax
80103b05:	e8 46 0e 00 00       	call   80104950 <safestrcpy>
  p->cwd = namei("/");
80103b0a:	c7 04 24 77 77 10 80 	movl   $0x80107777,(%esp)
80103b11:	e8 8a e5 ff ff       	call   801020a0 <namei>
80103b16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b19:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b20:	e8 ab 0b 00 00       	call   801046d0 <acquire>
  p->state = RUNNABLE;
80103b25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b2c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b33:	e8 38 0b 00 00       	call   80104670 <release>
}
80103b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3b:	83 c4 10             	add    $0x10,%esp
80103b3e:	c9                   	leave
80103b3f:	c3                   	ret
    panic("userinit: out of memory?");
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 55 77 10 80       	push   $0x80107755
80103b48:	e8 33 c8 ff ff       	call   80100380 <panic>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi

80103b50 <growproc>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx
80103b55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b58:	e8 23 0a 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103b5d:	e8 4e fe ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103b62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b68:	e8 63 0a 00 00       	call   801045d0 <popcli>
  sz = curproc->sz;
80103b6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b6f:	85 f6                	test   %esi,%esi
80103b71:	7f 1d                	jg     80103b90 <growproc+0x40>
  } else if(n < 0){
80103b73:	75 3b                	jne    80103bb0 <growproc+0x60>
  switchuvm(curproc);
80103b75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b7a:	53                   	push   %ebx
80103b7b:	e8 b0 31 00 00       	call   80106d30 <switchuvm>
  return 0;
80103b80:	83 c4 10             	add    $0x10,%esp
80103b83:	31 c0                	xor    %eax,%eax
}
80103b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b88:	5b                   	pop    %ebx
80103b89:	5e                   	pop    %esi
80103b8a:	5d                   	pop    %ebp
80103b8b:	c3                   	ret
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b90:	83 ec 04             	sub    $0x4,%esp
80103b93:	01 c6                	add    %eax,%esi
80103b95:	56                   	push   %esi
80103b96:	50                   	push   %eax
80103b97:	ff 73 04             	push   0x4(%ebx)
80103b9a:	e8 11 34 00 00       	call   80106fb0 <allocuvm>
80103b9f:	83 c4 10             	add    $0x10,%esp
80103ba2:	85 c0                	test   %eax,%eax
80103ba4:	75 cf                	jne    80103b75 <growproc+0x25>
      return -1;
80103ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bab:	eb d8                	jmp    80103b85 <growproc+0x35>
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bb0:	83 ec 04             	sub    $0x4,%esp
80103bb3:	01 c6                	add    %eax,%esi
80103bb5:	56                   	push   %esi
80103bb6:	50                   	push   %eax
80103bb7:	ff 73 04             	push   0x4(%ebx)
80103bba:	e8 21 35 00 00       	call   801070e0 <deallocuvm>
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 af                	jne    80103b75 <growproc+0x25>
80103bc6:	eb de                	jmp    80103ba6 <growproc+0x56>
80103bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bcf:	00 

80103bd0 <fork>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bd9:	e8 a2 09 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103bde:	e8 cd fd ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103be3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103be9:	e8 e2 09 00 00       	call   801045d0 <popcli>
  if((np = allocproc()) == 0){
80103bee:	e8 bd fb ff ff       	call   801037b0 <allocproc>
80103bf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bf6:	85 c0                	test   %eax,%eax
80103bf8:	0f 84 b7 00 00 00    	je     80103cb5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bfe:	83 ec 08             	sub    $0x8,%esp
80103c01:	ff 33                	push   (%ebx)
80103c03:	89 c7                	mov    %eax,%edi
80103c05:	ff 73 04             	push   0x4(%ebx)
80103c08:	e8 73 36 00 00       	call   80107280 <copyuvm>
80103c0d:	83 c4 10             	add    $0x10,%esp
80103c10:	89 47 04             	mov    %eax,0x4(%edi)
80103c13:	85 c0                	test   %eax,%eax
80103c15:	0f 84 a1 00 00 00    	je     80103cbc <fork+0xec>
  np->sz = curproc->sz;
80103c1b:	8b 03                	mov    (%ebx),%eax
80103c1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c25:	89 c8                	mov    %ecx,%eax
80103c27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c2f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c36:	8b 40 18             	mov    0x18(%eax),%eax
80103c39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c44:	85 c0                	test   %eax,%eax
80103c46:	74 13                	je     80103c5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c48:	83 ec 0c             	sub    $0xc,%esp
80103c4b:	50                   	push   %eax
80103c4c:	e8 4f d2 ff ff       	call   80100ea0 <filedup>
80103c51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c54:	83 c4 10             	add    $0x10,%esp
80103c57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c5b:	83 c6 01             	add    $0x1,%esi
80103c5e:	83 fe 10             	cmp    $0x10,%esi
80103c61:	75 dd                	jne    80103c40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c63:	83 ec 0c             	sub    $0xc,%esp
80103c66:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c6c:	e8 df da ff ff       	call   80101750 <idup>
80103c71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c7d:	6a 10                	push   $0x10
80103c7f:	53                   	push   %ebx
80103c80:	50                   	push   %eax
80103c81:	e8 ca 0c 00 00       	call   80104950 <safestrcpy>
  pid = np->pid;
80103c86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c89:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c90:	e8 3b 0a 00 00       	call   801046d0 <acquire>
  np->state = RUNNABLE;
80103c95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c9c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ca3:	e8 c8 09 00 00       	call   80104670 <release>
  return pid;
80103ca8:	83 c4 10             	add    $0x10,%esp
}
80103cab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cae:	89 d8                	mov    %ebx,%eax
80103cb0:	5b                   	pop    %ebx
80103cb1:	5e                   	pop    %esi
80103cb2:	5f                   	pop    %edi
80103cb3:	5d                   	pop    %ebp
80103cb4:	c3                   	ret
    return -1;
80103cb5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cba:	eb ef                	jmp    80103cab <fork+0xdb>
    kfree(np->kstack);
80103cbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cbf:	83 ec 0c             	sub    $0xc,%esp
80103cc2:	ff 73 08             	push   0x8(%ebx)
80103cc5:	e8 f6 e7 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103cca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cd1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cd4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cdb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ce0:	eb c9                	jmp    80103cab <fork+0xdb>
80103ce2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ce9:	00 
80103cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cf0 <scheduler>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103cf9:	e8 b2 fc ff ff       	call   801039b0 <mycpu>
  c->proc = 0;
80103cfe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d05:	00 00 00 
  struct cpu *c = mycpu();
80103d08:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d0a:	8d 78 04             	lea    0x4(%eax),%edi
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d10:	fb                   	sti
    acquire(&ptable.lock);
80103d11:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d14:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103d19:	68 20 1d 11 80       	push   $0x80111d20
80103d1e:	e8 ad 09 00 00       	call   801046d0 <acquire>
80103d23:	83 c4 10             	add    $0x10,%esp
80103d26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d2d:	00 
80103d2e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d34:	75 33                	jne    80103d69 <scheduler+0x79>
      switchuvm(p);
80103d36:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d3f:	53                   	push   %ebx
80103d40:	e8 eb 2f 00 00       	call   80106d30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d45:	58                   	pop    %eax
80103d46:	5a                   	pop    %edx
80103d47:	ff 73 1c             	push   0x1c(%ebx)
80103d4a:	57                   	push   %edi
      p->state = RUNNING;
80103d4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d52:	e8 54 0c 00 00       	call   801049ab <swtch>
      switchkvm();
80103d57:	e8 c4 2f 00 00       	call   80106d20 <switchkvm>
      c->proc = 0;
80103d5c:	83 c4 10             	add    $0x10,%esp
80103d5f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d66:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d69:	83 c3 7c             	add    $0x7c,%ebx
80103d6c:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103d72:	75 bc                	jne    80103d30 <scheduler+0x40>
    release(&ptable.lock);
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	68 20 1d 11 80       	push   $0x80111d20
80103d7c:	e8 ef 08 00 00       	call   80104670 <release>
    sti();
80103d81:	83 c4 10             	add    $0x10,%esp
80103d84:	eb 8a                	jmp    80103d10 <scheduler+0x20>
80103d86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d8d:	00 
80103d8e:	66 90                	xchg   %ax,%ax

80103d90 <sched>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
  pushcli();
80103d95:	e8 e6 07 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103d9a:	e8 11 fc ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103d9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da5:	e8 26 08 00 00       	call   801045d0 <popcli>
  if(!holding(&ptable.lock))
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 20 1d 11 80       	push   $0x80111d20
80103db2:	e8 79 08 00 00       	call   80104630 <holding>
80103db7:	83 c4 10             	add    $0x10,%esp
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 4f                	je     80103e0d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dbe:	e8 ed fb ff ff       	call   801039b0 <mycpu>
80103dc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dca:	75 68                	jne    80103e34 <sched+0xa4>
  if(p->state == RUNNING)
80103dcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103dd0:	74 55                	je     80103e27 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dd2:	9c                   	pushf
80103dd3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dd4:	f6 c4 02             	test   $0x2,%ah
80103dd7:	75 41                	jne    80103e1a <sched+0x8a>
  intena = mycpu()->intena;
80103dd9:	e8 d2 fb ff ff       	call   801039b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dde:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103de1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103de7:	e8 c4 fb ff ff       	call   801039b0 <mycpu>
80103dec:	83 ec 08             	sub    $0x8,%esp
80103def:	ff 70 04             	push   0x4(%eax)
80103df2:	53                   	push   %ebx
80103df3:	e8 b3 0b 00 00       	call   801049ab <swtch>
  mycpu()->intena = intena;
80103df8:	e8 b3 fb ff ff       	call   801039b0 <mycpu>
}
80103dfd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e09:	5b                   	pop    %ebx
80103e0a:	5e                   	pop    %esi
80103e0b:	5d                   	pop    %ebp
80103e0c:	c3                   	ret
    panic("sched ptable.lock");
80103e0d:	83 ec 0c             	sub    $0xc,%esp
80103e10:	68 79 77 10 80       	push   $0x80107779
80103e15:	e8 66 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 a5 77 10 80       	push   $0x801077a5
80103e22:	e8 59 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	68 97 77 10 80       	push   $0x80107797
80103e2f:	e8 4c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	68 8b 77 10 80       	push   $0x8010778b
80103e3c:	e8 3f c5 ff ff       	call   80100380 <panic>
80103e41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e48:	00 
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e50 <exit>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e59:	e8 d2 fb ff ff       	call   80103a30 <myproc>
  if(curproc == initproc)
80103e5e:	39 05 50 3d 11 80    	cmp    %eax,0x80113d50
80103e64:	0f 84 6d 01 00 00    	je     80103fd7 <exit+0x187>
  acquire(&ptable.lock);
80103e6a:	83 ec 0c             	sub    $0xc,%esp
80103e6d:	89 c3                	mov    %eax,%ebx
80103e6f:	68 20 1d 11 80       	push   $0x80111d20
80103e74:	e8 57 08 00 00       	call   801046d0 <acquire>
  for (int i = 0; i < history_count; i++) {
80103e79:	8b 0d 58 3c 11 80    	mov    0x80113c58,%ecx
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	85 c9                	test   %ecx,%ecx
80103e84:	7e 4a                	jle    80103ed0 <exit+0x80>
      if (process_history[i].pid == curproc->pid) {
80103e86:	8b 7b 10             	mov    0x10(%ebx),%edi
  for (int i = 0; i < history_count; i++) {
80103e89:	31 c0                	xor    %eax,%eax
80103e8b:	eb 0a                	jmp    80103e97 <exit+0x47>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
80103e90:	83 c0 01             	add    $0x1,%eax
80103e93:	39 c8                	cmp    %ecx,%eax
80103e95:	74 39                	je     80103ed0 <exit+0x80>
      if (process_history[i].pid == curproc->pid) {
80103e97:	8d 14 40             	lea    (%eax,%eax,2),%edx
80103e9a:	8d 34 d5 00 00 00 00 	lea    0x0(,%edx,8),%esi
80103ea1:	39 3c d5 60 3c 11 80 	cmp    %edi,-0x7feec3a0(,%edx,8)
80103ea8:	75 e6                	jne    80103e90 <exit+0x40>
        if(curproc->sz > process_history[i].mem_usage) {
80103eaa:	8b 03                	mov    (%ebx),%eax
80103eac:	3b 86 74 3c 11 80    	cmp    -0x7feec38c(%esi),%eax
80103eb2:	76 06                	jbe    80103eba <exit+0x6a>
          process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
80103eb4:	89 86 74 3c 11 80    	mov    %eax,-0x7feec38c(%esi)
          safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80103eba:	81 c6 64 3c 11 80    	add    $0x80113c64,%esi
80103ec0:	50                   	push   %eax
80103ec1:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ec4:	6a 10                	push   $0x10
80103ec6:	50                   	push   %eax
80103ec7:	56                   	push   %esi
80103ec8:	e8 83 0a 00 00       	call   80104950 <safestrcpy>
          break;
80103ecd:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80103ed0:	83 ec 0c             	sub    $0xc,%esp
80103ed3:	8d 73 28             	lea    0x28(%ebx),%esi
80103ed6:	8d 7b 68             	lea    0x68(%ebx),%edi
80103ed9:	68 20 1d 11 80       	push   $0x80111d20
80103ede:	e8 8d 07 00 00       	call   80104670 <release>
  for(fd = 0; fd < NOFILE; fd++){
80103ee3:	83 c4 10             	add    $0x10,%esp
80103ee6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103eed:	00 
80103eee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
80103ef0:	8b 06                	mov    (%esi),%eax
80103ef2:	85 c0                	test   %eax,%eax
80103ef4:	74 12                	je     80103f08 <exit+0xb8>
      fileclose(curproc->ofile[fd]);
80103ef6:	83 ec 0c             	sub    $0xc,%esp
80103ef9:	50                   	push   %eax
80103efa:	e8 f1 cf ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103eff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f05:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f08:	83 c6 04             	add    $0x4,%esi
80103f0b:	39 f7                	cmp    %esi,%edi
80103f0d:	75 e1                	jne    80103ef0 <exit+0xa0>
  begin_op();
80103f0f:	e8 4c ee ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103f14:	83 ec 0c             	sub    $0xc,%esp
80103f17:	ff 73 68             	push   0x68(%ebx)
80103f1a:	e8 91 d9 ff ff       	call   801018b0 <iput>
  end_op();
80103f1f:	e8 ac ee ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103f24:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f2b:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103f32:	e8 99 07 00 00       	call   801046d0 <acquire>
  wakeup1(curproc->parent);
80103f37:	8b 53 14             	mov    0x14(%ebx),%edx
80103f3a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f3d:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f42:	eb 0e                	jmp    80103f52 <exit+0x102>
80103f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f48:	83 c0 7c             	add    $0x7c,%eax
80103f4b:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f50:	74 1c                	je     80103f6e <exit+0x11e>
    if(p->state == SLEEPING && p->chan == chan)
80103f52:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f56:	75 f0                	jne    80103f48 <exit+0xf8>
80103f58:	3b 50 20             	cmp    0x20(%eax),%edx
80103f5b:	75 eb                	jne    80103f48 <exit+0xf8>
      p->state = RUNNABLE;
80103f5d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f64:	83 c0 7c             	add    $0x7c,%eax
80103f67:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f6c:	75 e4                	jne    80103f52 <exit+0x102>
      p->parent = initproc;
80103f6e:	8b 0d 50 3d 11 80    	mov    0x80113d50,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f74:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103f79:	eb 10                	jmp    80103f8b <exit+0x13b>
80103f7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f80:	83 c2 7c             	add    $0x7c,%edx
80103f83:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103f89:	74 33                	je     80103fbe <exit+0x16e>
    if(p->parent == curproc){
80103f8b:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f8e:	75 f0                	jne    80103f80 <exit+0x130>
      if(p->state == ZOMBIE)
80103f90:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f94:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f97:	75 e7                	jne    80103f80 <exit+0x130>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f99:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f9e:	eb 0a                	jmp    80103faa <exit+0x15a>
80103fa0:	83 c0 7c             	add    $0x7c,%eax
80103fa3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103fa8:	74 d6                	je     80103f80 <exit+0x130>
    if(p->state == SLEEPING && p->chan == chan)
80103faa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fae:	75 f0                	jne    80103fa0 <exit+0x150>
80103fb0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fb3:	75 eb                	jne    80103fa0 <exit+0x150>
      p->state = RUNNABLE;
80103fb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fbc:	eb e2                	jmp    80103fa0 <exit+0x150>
  curproc->state = ZOMBIE;
80103fbe:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fc5:	e8 c6 fd ff ff       	call   80103d90 <sched>
  panic("zombie exit");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 c6 77 10 80       	push   $0x801077c6
80103fd2:	e8 a9 c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 b9 77 10 80       	push   $0x801077b9
80103fdf:	e8 9c c3 ff ff       	call   80100380 <panic>
80103fe4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103feb:	00 
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <wait>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
  pushcli();
80103ff5:	e8 86 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103ffa:	e8 b1 f9 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103fff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104005:	e8 c6 05 00 00       	call   801045d0 <popcli>
  acquire(&ptable.lock);
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	68 20 1d 11 80       	push   $0x80111d20
80104012:	e8 b9 06 00 00       	call   801046d0 <acquire>
80104017:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010401a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104021:	eb 10                	jmp    80104033 <wait+0x43>
80104023:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104028:	83 c3 7c             	add    $0x7c,%ebx
8010402b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80104031:	74 1b                	je     8010404e <wait+0x5e>
      if(p->parent != curproc)
80104033:	39 73 14             	cmp    %esi,0x14(%ebx)
80104036:	75 f0                	jne    80104028 <wait+0x38>
      if(p->state == ZOMBIE){
80104038:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010403c:	74 62                	je     801040a0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104041:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104046:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010404c:	75 e5                	jne    80104033 <wait+0x43>
    if(!havekids || curproc->killed){
8010404e:	85 c0                	test   %eax,%eax
80104050:	0f 84 a0 00 00 00    	je     801040f6 <wait+0x106>
80104056:	8b 46 24             	mov    0x24(%esi),%eax
80104059:	85 c0                	test   %eax,%eax
8010405b:	0f 85 95 00 00 00    	jne    801040f6 <wait+0x106>
  pushcli();
80104061:	e8 1a 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104066:	e8 45 f9 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
8010406b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104071:	e8 5a 05 00 00       	call   801045d0 <popcli>
  if(p == 0)
80104076:	85 db                	test   %ebx,%ebx
80104078:	0f 84 8f 00 00 00    	je     8010410d <wait+0x11d>
  p->chan = chan;
8010407e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104081:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104088:	e8 03 fd ff ff       	call   80103d90 <sched>
  p->chan = 0;
8010408d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104094:	eb 84                	jmp    8010401a <wait+0x2a>
80104096:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010409d:	00 
8010409e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801040a0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040a3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040a6:	ff 73 08             	push   0x8(%ebx)
801040a9:	e8 12 e4 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801040ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040b5:	5a                   	pop    %edx
801040b6:	ff 73 04             	push   0x4(%ebx)
801040b9:	e8 52 30 00 00       	call   80107110 <freevm>
        p->pid = 0;
801040be:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040c5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040cc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040d0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040de:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040e5:	e8 86 05 00 00       	call   80104670 <release>
        return pid;
801040ea:	83 c4 10             	add    $0x10,%esp
}
801040ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f0:	89 f0                	mov    %esi,%eax
801040f2:	5b                   	pop    %ebx
801040f3:	5e                   	pop    %esi
801040f4:	5d                   	pop    %ebp
801040f5:	c3                   	ret
      release(&ptable.lock);
801040f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040fe:	68 20 1d 11 80       	push   $0x80111d20
80104103:	e8 68 05 00 00       	call   80104670 <release>
      return -1;
80104108:	83 c4 10             	add    $0x10,%esp
8010410b:	eb e0                	jmp    801040ed <wait+0xfd>
    panic("sleep");
8010410d:	83 ec 0c             	sub    $0xc,%esp
80104110:	68 d2 77 10 80       	push   $0x801077d2
80104115:	e8 66 c2 ff ff       	call   80100380 <panic>
8010411a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104120 <yield>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104127:	68 20 1d 11 80       	push   $0x80111d20
8010412c:	e8 9f 05 00 00       	call   801046d0 <acquire>
  pushcli();
80104131:	e8 4a 04 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104136:	e8 75 f8 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
8010413b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104141:	e8 8a 04 00 00       	call   801045d0 <popcli>
  myproc()->state = RUNNABLE;
80104146:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010414d:	e8 3e fc ff ff       	call   80103d90 <sched>
  release(&ptable.lock);
80104152:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104159:	e8 12 05 00 00       	call   80104670 <release>
}
8010415e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104161:	83 c4 10             	add    $0x10,%esp
80104164:	c9                   	leave
80104165:	c3                   	ret
80104166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010416d:	00 
8010416e:	66 90                	xchg   %ax,%ax

80104170 <sleep>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	57                   	push   %edi
80104174:	56                   	push   %esi
80104175:	53                   	push   %ebx
80104176:	83 ec 0c             	sub    $0xc,%esp
80104179:	8b 7d 08             	mov    0x8(%ebp),%edi
8010417c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010417f:	e8 fc 03 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104184:	e8 27 f8 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104189:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010418f:	e8 3c 04 00 00       	call   801045d0 <popcli>
  if(p == 0)
80104194:	85 db                	test   %ebx,%ebx
80104196:	0f 84 87 00 00 00    	je     80104223 <sleep+0xb3>
  if(lk == 0)
8010419c:	85 f6                	test   %esi,%esi
8010419e:	74 76                	je     80104216 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041a0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801041a6:	74 50                	je     801041f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	68 20 1d 11 80       	push   $0x80111d20
801041b0:	e8 1b 05 00 00       	call   801046d0 <acquire>
    release(lk);
801041b5:	89 34 24             	mov    %esi,(%esp)
801041b8:	e8 b3 04 00 00       	call   80104670 <release>
  p->chan = chan;
801041bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041c7:	e8 c4 fb ff ff       	call   80103d90 <sched>
  p->chan = 0;
801041cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041d3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041da:	e8 91 04 00 00       	call   80104670 <release>
    acquire(lk);
801041df:	89 75 08             	mov    %esi,0x8(%ebp)
801041e2:	83 c4 10             	add    $0x10,%esp
}
801041e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041e8:	5b                   	pop    %ebx
801041e9:	5e                   	pop    %esi
801041ea:	5f                   	pop    %edi
801041eb:	5d                   	pop    %ebp
    acquire(lk);
801041ec:	e9 df 04 00 00       	jmp    801046d0 <acquire>
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104202:	e8 89 fb ff ff       	call   80103d90 <sched>
  p->chan = 0;
80104207:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010420e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104211:	5b                   	pop    %ebx
80104212:	5e                   	pop    %esi
80104213:	5f                   	pop    %edi
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret
    panic("sleep without lk");
80104216:	83 ec 0c             	sub    $0xc,%esp
80104219:	68 d8 77 10 80       	push   $0x801077d8
8010421e:	e8 5d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104223:	83 ec 0c             	sub    $0xc,%esp
80104226:	68 d2 77 10 80       	push   $0x801077d2
8010422b:	e8 50 c1 ff ff       	call   80100380 <panic>

80104230 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 10             	sub    $0x10,%esp
80104237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010423a:	68 20 1d 11 80       	push   $0x80111d20
8010423f:	e8 8c 04 00 00       	call   801046d0 <acquire>
80104244:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104247:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010424c:	eb 0c                	jmp    8010425a <wakeup+0x2a>
8010424e:	66 90                	xchg   %ax,%ax
80104250:	83 c0 7c             	add    $0x7c,%eax
80104253:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104258:	74 1c                	je     80104276 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010425a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010425e:	75 f0                	jne    80104250 <wakeup+0x20>
80104260:	3b 58 20             	cmp    0x20(%eax),%ebx
80104263:	75 eb                	jne    80104250 <wakeup+0x20>
      p->state = RUNNABLE;
80104265:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010426c:	83 c0 7c             	add    $0x7c,%eax
8010426f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104274:	75 e4                	jne    8010425a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104276:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010427d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104280:	c9                   	leave
  release(&ptable.lock);
80104281:	e9 ea 03 00 00       	jmp    80104670 <release>
80104286:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010428d:	00 
8010428e:	66 90                	xchg   %ax,%ax

80104290 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 10             	sub    $0x10,%esp
80104297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010429a:	68 20 1d 11 80       	push   $0x80111d20
8010429f:	e8 2c 04 00 00       	call   801046d0 <acquire>
801042a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801042ac:	eb 0c                	jmp    801042ba <kill+0x2a>
801042ae:	66 90                	xchg   %ax,%ax
801042b0:	83 c0 7c             	add    $0x7c,%eax
801042b3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801042b8:	74 36                	je     801042f0 <kill+0x60>
    if(p->pid == pid){
801042ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801042bd:	75 f1                	jne    801042b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042ca:	75 07                	jne    801042d3 <kill+0x43>
        p->state = RUNNABLE;
801042cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042d3:	83 ec 0c             	sub    $0xc,%esp
801042d6:	68 20 1d 11 80       	push   $0x80111d20
801042db:	e8 90 03 00 00       	call   80104670 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042e3:	83 c4 10             	add    $0x10,%esp
801042e6:	31 c0                	xor    %eax,%eax
}
801042e8:	c9                   	leave
801042e9:	c3                   	ret
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801042f0:	83 ec 0c             	sub    $0xc,%esp
801042f3:	68 20 1d 11 80       	push   $0x80111d20
801042f8:	e8 73 03 00 00       	call   80104670 <release>
}
801042fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104300:	83 c4 10             	add    $0x10,%esp
80104303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104308:	c9                   	leave
80104309:	c3                   	ret
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104310 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104318:	53                   	push   %ebx
80104319:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010431e:	83 ec 3c             	sub    $0x3c,%esp
80104321:	eb 24                	jmp    80104347 <procdump+0x37>
80104323:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 ae 79 10 80       	push   $0x801079ae
80104330:	e8 6b c3 ff ff       	call   801006a0 <cprintf>
80104335:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104338:	83 c3 7c             	add    $0x7c,%ebx
8010433b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104341:	0f 84 81 00 00 00    	je     801043c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104347:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010434a:	85 c0                	test   %eax,%eax
8010434c:	74 ea                	je     80104338 <procdump+0x28>
      state = "???";
8010434e:	ba e9 77 10 80       	mov    $0x801077e9,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104353:	83 f8 05             	cmp    $0x5,%eax
80104356:	77 11                	ja     80104369 <procdump+0x59>
80104358:	8b 14 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%edx
      state = "???";
8010435f:	b8 e9 77 10 80       	mov    $0x801077e9,%eax
80104364:	85 d2                	test   %edx,%edx
80104366:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104369:	53                   	push   %ebx
8010436a:	52                   	push   %edx
8010436b:	ff 73 a4             	push   -0x5c(%ebx)
8010436e:	68 ed 77 10 80       	push   $0x801077ed
80104373:	e8 28 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104378:	83 c4 10             	add    $0x10,%esp
8010437b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010437f:	75 a7                	jne    80104328 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104381:	83 ec 08             	sub    $0x8,%esp
80104384:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104387:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010438a:	50                   	push   %eax
8010438b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010438e:	8b 40 0c             	mov    0xc(%eax),%eax
80104391:	83 c0 08             	add    $0x8,%eax
80104394:	50                   	push   %eax
80104395:	e8 86 01 00 00       	call   80104520 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010439a:	83 c4 10             	add    $0x10,%esp
8010439d:	8d 76 00             	lea    0x0(%esi),%esi
801043a0:	8b 17                	mov    (%edi),%edx
801043a2:	85 d2                	test   %edx,%edx
801043a4:	74 82                	je     80104328 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043ac:	52                   	push   %edx
801043ad:	68 21 75 10 80       	push   $0x80107521
801043b2:	e8 e9 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043b7:	83 c4 10             	add    $0x10,%esp
801043ba:	39 fe                	cmp    %edi,%esi
801043bc:	75 e2                	jne    801043a0 <procdump+0x90>
801043be:	e9 65 ff ff ff       	jmp    80104328 <procdump+0x18>
801043c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801043c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043cb:	5b                   	pop    %ebx
801043cc:	5e                   	pop    %esi
801043cd:	5f                   	pop    %edi
801043ce:	5d                   	pop    %ebp
801043cf:	c3                   	ret

801043d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
801043d4:	83 ec 0c             	sub    $0xc,%esp
801043d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043da:	68 20 78 10 80       	push   $0x80107820
801043df:	8d 43 04             	lea    0x4(%ebx),%eax
801043e2:	50                   	push   %eax
801043e3:	e8 18 01 00 00       	call   80104500 <initlock>
  lk->name = name;
801043e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104401:	c9                   	leave
80104402:	c3                   	ret
80104403:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010440a:	00 
8010440b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104410 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104418:	8d 73 04             	lea    0x4(%ebx),%esi
8010441b:	83 ec 0c             	sub    $0xc,%esp
8010441e:	56                   	push   %esi
8010441f:	e8 ac 02 00 00       	call   801046d0 <acquire>
  while (lk->locked) {
80104424:	8b 13                	mov    (%ebx),%edx
80104426:	83 c4 10             	add    $0x10,%esp
80104429:	85 d2                	test   %edx,%edx
8010442b:	74 16                	je     80104443 <acquiresleep+0x33>
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104430:	83 ec 08             	sub    $0x8,%esp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	e8 36 fd ff ff       	call   80104170 <sleep>
  while (lk->locked) {
8010443a:	8b 03                	mov    (%ebx),%eax
8010443c:	83 c4 10             	add    $0x10,%esp
8010443f:	85 c0                	test   %eax,%eax
80104441:	75 ed                	jne    80104430 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104443:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104449:	e8 e2 f5 ff ff       	call   80103a30 <myproc>
8010444e:	8b 40 10             	mov    0x10(%eax),%eax
80104451:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104454:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104457:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445a:	5b                   	pop    %ebx
8010445b:	5e                   	pop    %esi
8010445c:	5d                   	pop    %ebp
  release(&lk->lk);
8010445d:	e9 0e 02 00 00       	jmp    80104670 <release>
80104462:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104469:	00 
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104470 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104478:	8d 73 04             	lea    0x4(%ebx),%esi
8010447b:	83 ec 0c             	sub    $0xc,%esp
8010447e:	56                   	push   %esi
8010447f:	e8 4c 02 00 00       	call   801046d0 <acquire>
  lk->locked = 0;
80104484:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010448a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104491:	89 1c 24             	mov    %ebx,(%esp)
80104494:	e8 97 fd ff ff       	call   80104230 <wakeup>
  release(&lk->lk);
80104499:	89 75 08             	mov    %esi,0x8(%ebp)
8010449c:	83 c4 10             	add    $0x10,%esp
}
8010449f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a2:	5b                   	pop    %ebx
801044a3:	5e                   	pop    %esi
801044a4:	5d                   	pop    %ebp
  release(&lk->lk);
801044a5:	e9 c6 01 00 00       	jmp    80104670 <release>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	31 ff                	xor    %edi,%edi
801044b6:	56                   	push   %esi
801044b7:	53                   	push   %ebx
801044b8:	83 ec 18             	sub    $0x18,%esp
801044bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044be:	8d 73 04             	lea    0x4(%ebx),%esi
801044c1:	56                   	push   %esi
801044c2:	e8 09 02 00 00       	call   801046d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044c7:	8b 03                	mov    (%ebx),%eax
801044c9:	83 c4 10             	add    $0x10,%esp
801044cc:	85 c0                	test   %eax,%eax
801044ce:	75 18                	jne    801044e8 <holdingsleep+0x38>
  release(&lk->lk);
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	56                   	push   %esi
801044d4:	e8 97 01 00 00       	call   80104670 <release>
  return r;
}
801044d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044dc:	89 f8                	mov    %edi,%eax
801044de:	5b                   	pop    %ebx
801044df:	5e                   	pop    %esi
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret
801044e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801044e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044eb:	e8 40 f5 ff ff       	call   80103a30 <myproc>
801044f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801044f3:	0f 94 c0             	sete   %al
801044f6:	0f b6 c0             	movzbl %al,%eax
801044f9:	89 c7                	mov    %eax,%edi
801044fb:	eb d3                	jmp    801044d0 <holdingsleep+0x20>
801044fd:	66 90                	xchg   %ax,%ax
801044ff:	90                   	nop

80104500 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104506:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010450f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104512:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret
8010451b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104520 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104520:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104521:	31 d2                	xor    %edx,%edx
{
80104523:	89 e5                	mov    %esp,%ebp
80104525:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104526:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104529:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010452c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010452f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104530:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104536:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010453c:	77 1a                	ja     80104558 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010453e:	8b 58 04             	mov    0x4(%eax),%ebx
80104541:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104544:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104547:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104549:	83 fa 0a             	cmp    $0xa,%edx
8010454c:	75 e2                	jne    80104530 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010454e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104551:	c9                   	leave
80104552:	c3                   	ret
80104553:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104558:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010455b:	8d 51 28             	lea    0x28(%ecx),%edx
8010455e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104560:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104566:	83 c0 04             	add    $0x4,%eax
80104569:	39 d0                	cmp    %edx,%eax
8010456b:	75 f3                	jne    80104560 <getcallerpcs+0x40>
}
8010456d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104570:	c9                   	leave
80104571:	c3                   	ret
80104572:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104579:	00 
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 04             	sub    $0x4,%esp
80104587:	9c                   	pushf
80104588:	5b                   	pop    %ebx
  asm volatile("cli");
80104589:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010458a:	e8 21 f4 ff ff       	call   801039b0 <mycpu>
8010458f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104595:	85 c0                	test   %eax,%eax
80104597:	74 17                	je     801045b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104599:	e8 12 f4 ff ff       	call   801039b0 <mycpu>
8010459e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a8:	c9                   	leave
801045a9:	c3                   	ret
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045b0:	e8 fb f3 ff ff       	call   801039b0 <mycpu>
801045b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045c1:	eb d6                	jmp    80104599 <pushcli+0x19>
801045c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045ca:	00 
801045cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801045d0 <popcli>:

void
popcli(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045d6:	9c                   	pushf
801045d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045d8:	f6 c4 02             	test   $0x2,%ah
801045db:	75 35                	jne    80104612 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045dd:	e8 ce f3 ff ff       	call   801039b0 <mycpu>
801045e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045e9:	78 34                	js     8010461f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045eb:	e8 c0 f3 ff ff       	call   801039b0 <mycpu>
801045f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045f6:	85 d2                	test   %edx,%edx
801045f8:	74 06                	je     80104600 <popcli+0x30>
    sti();
}
801045fa:	c9                   	leave
801045fb:	c3                   	ret
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104600:	e8 ab f3 ff ff       	call   801039b0 <mycpu>
80104605:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010460b:	85 c0                	test   %eax,%eax
8010460d:	74 eb                	je     801045fa <popcli+0x2a>
  asm volatile("sti");
8010460f:	fb                   	sti
}
80104610:	c9                   	leave
80104611:	c3                   	ret
    panic("popcli - interruptible");
80104612:	83 ec 0c             	sub    $0xc,%esp
80104615:	68 2b 78 10 80       	push   $0x8010782b
8010461a:	e8 61 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010461f:	83 ec 0c             	sub    $0xc,%esp
80104622:	68 42 78 10 80       	push   $0x80107842
80104627:	e8 54 bd ff ff       	call   80100380 <panic>
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <holding>:
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 75 08             	mov    0x8(%ebp),%esi
80104638:	31 db                	xor    %ebx,%ebx
  pushcli();
8010463a:	e8 41 ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010463f:	8b 06                	mov    (%esi),%eax
80104641:	85 c0                	test   %eax,%eax
80104643:	75 0b                	jne    80104650 <holding+0x20>
  popcli();
80104645:	e8 86 ff ff ff       	call   801045d0 <popcli>
}
8010464a:	89 d8                	mov    %ebx,%eax
8010464c:	5b                   	pop    %ebx
8010464d:	5e                   	pop    %esi
8010464e:	5d                   	pop    %ebp
8010464f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104650:	8b 5e 08             	mov    0x8(%esi),%ebx
80104653:	e8 58 f3 ff ff       	call   801039b0 <mycpu>
80104658:	39 c3                	cmp    %eax,%ebx
8010465a:	0f 94 c3             	sete   %bl
  popcli();
8010465d:	e8 6e ff ff ff       	call   801045d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104662:	0f b6 db             	movzbl %bl,%ebx
}
80104665:	89 d8                	mov    %ebx,%eax
80104667:	5b                   	pop    %ebx
80104668:	5e                   	pop    %esi
80104669:	5d                   	pop    %ebp
8010466a:	c3                   	ret
8010466b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104670 <release>:
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104678:	e8 03 ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010467d:	8b 03                	mov    (%ebx),%eax
8010467f:	85 c0                	test   %eax,%eax
80104681:	75 15                	jne    80104698 <release+0x28>
  popcli();
80104683:	e8 48 ff ff ff       	call   801045d0 <popcli>
    panic("release");
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 49 78 10 80       	push   $0x80107849
80104690:	e8 eb bc ff ff       	call   80100380 <panic>
80104695:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104698:	8b 73 08             	mov    0x8(%ebx),%esi
8010469b:	e8 10 f3 ff ff       	call   801039b0 <mycpu>
801046a0:	39 c6                	cmp    %eax,%esi
801046a2:	75 df                	jne    80104683 <release+0x13>
  popcli();
801046a4:	e8 27 ff ff ff       	call   801045d0 <popcli>
  lk->pcs[0] = 0;
801046a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c5:	5b                   	pop    %ebx
801046c6:	5e                   	pop    %esi
801046c7:	5d                   	pop    %ebp
  popcli();
801046c8:	e9 03 ff ff ff       	jmp    801045d0 <popcli>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi

801046d0 <acquire>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046d7:	e8 a4 fe ff ff       	call   80104580 <pushcli>
  if(holding(lk))
801046dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046df:	e8 9c fe ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046e4:	8b 03                	mov    (%ebx),%eax
801046e6:	85 c0                	test   %eax,%eax
801046e8:	75 7e                	jne    80104768 <acquire+0x98>
  popcli();
801046ea:	e8 e1 fe ff ff       	call   801045d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801046ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801046f8:	8b 55 08             	mov    0x8(%ebp),%edx
801046fb:	89 c8                	mov    %ecx,%eax
801046fd:	f0 87 02             	lock xchg %eax,(%edx)
80104700:	85 c0                	test   %eax,%eax
80104702:	75 f4                	jne    801046f8 <acquire+0x28>
  __sync_synchronize();
80104704:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104709:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010470c:	e8 9f f2 ff ff       	call   801039b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104711:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104714:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104716:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104719:	31 c0                	xor    %eax,%eax
8010471b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104720:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104726:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010472c:	77 1a                	ja     80104748 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010472e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104731:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104735:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104738:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010473a:	83 f8 0a             	cmp    $0xa,%eax
8010473d:	75 e1                	jne    80104720 <acquire+0x50>
}
8010473f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104742:	c9                   	leave
80104743:	c3                   	ret
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104748:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010474c:	8d 51 34             	lea    0x34(%ecx),%edx
8010474f:	90                   	nop
    pcs[i] = 0;
80104750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104756:	83 c0 04             	add    $0x4,%eax
80104759:	39 c2                	cmp    %eax,%edx
8010475b:	75 f3                	jne    80104750 <acquire+0x80>
}
8010475d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104760:	c9                   	leave
80104761:	c3                   	ret
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104768:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010476b:	e8 40 f2 ff ff       	call   801039b0 <mycpu>
80104770:	39 c3                	cmp    %eax,%ebx
80104772:	0f 85 72 ff ff ff    	jne    801046ea <acquire+0x1a>
  popcli();
80104778:	e8 53 fe ff ff       	call   801045d0 <popcli>
    panic("acquire");
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	68 51 78 10 80       	push   $0x80107851
80104785:	e8 f6 bb ff ff       	call   80100380 <panic>
8010478a:	66 90                	xchg   %ax,%ax
8010478c:	66 90                	xchg   %ax,%ax
8010478e:	66 90                	xchg   %ax,%ax

80104790 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	8b 55 08             	mov    0x8(%ebp),%edx
80104797:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010479a:	53                   	push   %ebx
8010479b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010479e:	89 d7                	mov    %edx,%edi
801047a0:	09 cf                	or     %ecx,%edi
801047a2:	83 e7 03             	and    $0x3,%edi
801047a5:	75 29                	jne    801047d0 <memset+0x40>
    c &= 0xFF;
801047a7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047aa:	c1 e0 18             	shl    $0x18,%eax
801047ad:	89 fb                	mov    %edi,%ebx
801047af:	c1 e9 02             	shr    $0x2,%ecx
801047b2:	c1 e3 10             	shl    $0x10,%ebx
801047b5:	09 d8                	or     %ebx,%eax
801047b7:	09 f8                	or     %edi,%eax
801047b9:	c1 e7 08             	shl    $0x8,%edi
801047bc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047be:	89 d7                	mov    %edx,%edi
801047c0:	fc                   	cld
801047c1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047c3:	5b                   	pop    %ebx
801047c4:	89 d0                	mov    %edx,%eax
801047c6:	5f                   	pop    %edi
801047c7:	5d                   	pop    %ebp
801047c8:	c3                   	ret
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801047d0:	89 d7                	mov    %edx,%edi
801047d2:	fc                   	cld
801047d3:	f3 aa                	rep stos %al,%es:(%edi)
801047d5:	5b                   	pop    %ebx
801047d6:	89 d0                	mov    %edx,%eax
801047d8:	5f                   	pop    %edi
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret
801047db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801047e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	8b 75 10             	mov    0x10(%ebp),%esi
801047e7:	8b 55 08             	mov    0x8(%ebp),%edx
801047ea:	53                   	push   %ebx
801047eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047ee:	85 f6                	test   %esi,%esi
801047f0:	74 2e                	je     80104820 <memcmp+0x40>
801047f2:	01 c6                	add    %eax,%esi
801047f4:	eb 14                	jmp    8010480a <memcmp+0x2a>
801047f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047fd:	00 
801047fe:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104800:	83 c0 01             	add    $0x1,%eax
80104803:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104806:	39 f0                	cmp    %esi,%eax
80104808:	74 16                	je     80104820 <memcmp+0x40>
    if(*s1 != *s2)
8010480a:	0f b6 0a             	movzbl (%edx),%ecx
8010480d:	0f b6 18             	movzbl (%eax),%ebx
80104810:	38 d9                	cmp    %bl,%cl
80104812:	74 ec                	je     80104800 <memcmp+0x20>
      return *s1 - *s2;
80104814:	0f b6 c1             	movzbl %cl,%eax
80104817:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104819:	5b                   	pop    %ebx
8010481a:	5e                   	pop    %esi
8010481b:	5d                   	pop    %ebp
8010481c:	c3                   	ret
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
80104820:	5b                   	pop    %ebx
  return 0;
80104821:	31 c0                	xor    %eax,%eax
}
80104823:	5e                   	pop    %esi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret
80104826:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010482d:	00 
8010482e:	66 90                	xchg   %ax,%ax

80104830 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	8b 55 08             	mov    0x8(%ebp),%edx
80104837:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010483a:	56                   	push   %esi
8010483b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010483e:	39 d6                	cmp    %edx,%esi
80104840:	73 26                	jae    80104868 <memmove+0x38>
80104842:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104845:	39 fa                	cmp    %edi,%edx
80104847:	73 1f                	jae    80104868 <memmove+0x38>
80104849:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010484c:	85 c9                	test   %ecx,%ecx
8010484e:	74 0c                	je     8010485c <memmove+0x2c>
      *--d = *--s;
80104850:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104854:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104857:	83 e8 01             	sub    $0x1,%eax
8010485a:	73 f4                	jae    80104850 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010485c:	5e                   	pop    %esi
8010485d:	89 d0                	mov    %edx,%eax
8010485f:	5f                   	pop    %edi
80104860:	5d                   	pop    %ebp
80104861:	c3                   	ret
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104868:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010486b:	89 d7                	mov    %edx,%edi
8010486d:	85 c9                	test   %ecx,%ecx
8010486f:	74 eb                	je     8010485c <memmove+0x2c>
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104878:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104879:	39 c6                	cmp    %eax,%esi
8010487b:	75 fb                	jne    80104878 <memmove+0x48>
}
8010487d:	5e                   	pop    %esi
8010487e:	89 d0                	mov    %edx,%eax
80104880:	5f                   	pop    %edi
80104881:	5d                   	pop    %ebp
80104882:	c3                   	ret
80104883:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010488a:	00 
8010488b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104890 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104890:	eb 9e                	jmp    80104830 <memmove>
80104892:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104899:	00 
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	8b 75 10             	mov    0x10(%ebp),%esi
801048a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048aa:	53                   	push   %ebx
801048ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801048ae:	85 f6                	test   %esi,%esi
801048b0:	74 2e                	je     801048e0 <strncmp+0x40>
801048b2:	01 d6                	add    %edx,%esi
801048b4:	eb 18                	jmp    801048ce <strncmp+0x2e>
801048b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048bd:	00 
801048be:	66 90                	xchg   %ax,%ax
801048c0:	38 d8                	cmp    %bl,%al
801048c2:	75 14                	jne    801048d8 <strncmp+0x38>
    n--, p++, q++;
801048c4:	83 c2 01             	add    $0x1,%edx
801048c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048ca:	39 f2                	cmp    %esi,%edx
801048cc:	74 12                	je     801048e0 <strncmp+0x40>
801048ce:	0f b6 01             	movzbl (%ecx),%eax
801048d1:	0f b6 1a             	movzbl (%edx),%ebx
801048d4:	84 c0                	test   %al,%al
801048d6:	75 e8                	jne    801048c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048d8:	29 d8                	sub    %ebx,%eax
}
801048da:	5b                   	pop    %ebx
801048db:	5e                   	pop    %esi
801048dc:	5d                   	pop    %ebp
801048dd:	c3                   	ret
801048de:	66 90                	xchg   %ax,%ax
801048e0:	5b                   	pop    %ebx
    return 0;
801048e1:	31 c0                	xor    %eax,%eax
}
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret
801048e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ed:	00 
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	8b 75 08             	mov    0x8(%ebp),%esi
801048f8:	53                   	push   %ebx
801048f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048fc:	89 f0                	mov    %esi,%eax
801048fe:	eb 15                	jmp    80104915 <strncpy+0x25>
80104900:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104904:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104907:	83 c0 01             	add    $0x1,%eax
8010490a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010490e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104911:	84 d2                	test   %dl,%dl
80104913:	74 09                	je     8010491e <strncpy+0x2e>
80104915:	89 cb                	mov    %ecx,%ebx
80104917:	83 e9 01             	sub    $0x1,%ecx
8010491a:	85 db                	test   %ebx,%ebx
8010491c:	7f e2                	jg     80104900 <strncpy+0x10>
    ;
  while(n-- > 0)
8010491e:	89 c2                	mov    %eax,%edx
80104920:	85 c9                	test   %ecx,%ecx
80104922:	7e 17                	jle    8010493b <strncpy+0x4b>
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104928:	83 c2 01             	add    $0x1,%edx
8010492b:	89 c1                	mov    %eax,%ecx
8010492d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104931:	29 d1                	sub    %edx,%ecx
80104933:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104937:	85 c9                	test   %ecx,%ecx
80104939:	7f ed                	jg     80104928 <strncpy+0x38>
  return os;
}
8010493b:	5b                   	pop    %ebx
8010493c:	89 f0                	mov    %esi,%eax
8010493e:	5e                   	pop    %esi
8010493f:	5f                   	pop    %edi
80104940:	5d                   	pop    %ebp
80104941:	c3                   	ret
80104942:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104949:	00 
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	8b 55 10             	mov    0x10(%ebp),%edx
80104957:	8b 75 08             	mov    0x8(%ebp),%esi
8010495a:	53                   	push   %ebx
8010495b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010495e:	85 d2                	test   %edx,%edx
80104960:	7e 25                	jle    80104987 <safestrcpy+0x37>
80104962:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104966:	89 f2                	mov    %esi,%edx
80104968:	eb 16                	jmp    80104980 <safestrcpy+0x30>
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104970:	0f b6 08             	movzbl (%eax),%ecx
80104973:	83 c0 01             	add    $0x1,%eax
80104976:	83 c2 01             	add    $0x1,%edx
80104979:	88 4a ff             	mov    %cl,-0x1(%edx)
8010497c:	84 c9                	test   %cl,%cl
8010497e:	74 04                	je     80104984 <safestrcpy+0x34>
80104980:	39 d8                	cmp    %ebx,%eax
80104982:	75 ec                	jne    80104970 <safestrcpy+0x20>
    ;
  *s = 0;
80104984:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104987:	89 f0                	mov    %esi,%eax
80104989:	5b                   	pop    %ebx
8010498a:	5e                   	pop    %esi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret
8010498d:	8d 76 00             	lea    0x0(%esi),%esi

80104990 <strlen>:

int
strlen(const char *s)
{
80104990:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104991:	31 c0                	xor    %eax,%eax
{
80104993:	89 e5                	mov    %esp,%ebp
80104995:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104998:	80 3a 00             	cmpb   $0x0,(%edx)
8010499b:	74 0c                	je     801049a9 <strlen+0x19>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
801049a0:	83 c0 01             	add    $0x1,%eax
801049a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049a7:	75 f7                	jne    801049a0 <strlen+0x10>
    ;
  return n;
}
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret

801049ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049b3:	55                   	push   %ebp
  pushl %ebx
801049b4:	53                   	push   %ebx
  pushl %esi
801049b5:	56                   	push   %esi
  pushl %edi
801049b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049bb:	5f                   	pop    %edi
  popl %esi
801049bc:	5e                   	pop    %esi
  popl %ebx
801049bd:	5b                   	pop    %ebx
  popl %ebp
801049be:	5d                   	pop    %ebp
  ret
801049bf:	c3                   	ret

801049c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 04             	sub    $0x4,%esp
801049c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049ca:	e8 61 f0 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049cf:	8b 00                	mov    (%eax),%eax
801049d1:	39 d8                	cmp    %ebx,%eax
801049d3:	76 1b                	jbe    801049f0 <fetchint+0x30>
801049d5:	8d 53 04             	lea    0x4(%ebx),%edx
801049d8:	39 d0                	cmp    %edx,%eax
801049da:	72 14                	jb     801049f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049df:	8b 13                	mov    (%ebx),%edx
801049e1:	89 10                	mov    %edx,(%eax)
  return 0;
801049e3:	31 c0                	xor    %eax,%eax
}
801049e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e8:	c9                   	leave
801049e9:	c3                   	ret
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f5:	eb ee                	jmp    801049e5 <fetchint+0x25>
801049f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049fe:	00 
801049ff:	90                   	nop

80104a00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	83 ec 04             	sub    $0x4,%esp
80104a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a0a:	e8 21 f0 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz)
80104a0f:	39 18                	cmp    %ebx,(%eax)
80104a11:	76 2d                	jbe    80104a40 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a16:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a18:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a1a:	39 d3                	cmp    %edx,%ebx
80104a1c:	73 22                	jae    80104a40 <fetchstr+0x40>
80104a1e:	89 d8                	mov    %ebx,%eax
80104a20:	eb 0d                	jmp    80104a2f <fetchstr+0x2f>
80104a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a28:	83 c0 01             	add    $0x1,%eax
80104a2b:	39 c2                	cmp    %eax,%edx
80104a2d:	76 11                	jbe    80104a40 <fetchstr+0x40>
    if(*s == 0)
80104a2f:	80 38 00             	cmpb   $0x0,(%eax)
80104a32:	75 f4                	jne    80104a28 <fetchstr+0x28>
      return s - *pp;
80104a34:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a39:	c9                   	leave
80104a3a:	c3                   	ret
80104a3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a48:	c9                   	leave
80104a49:	c3                   	ret
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a55:	e8 d6 ef ff ff       	call   80103a30 <myproc>
80104a5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a5d:	8b 40 18             	mov    0x18(%eax),%eax
80104a60:	8b 40 44             	mov    0x44(%eax),%eax
80104a63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a66:	e8 c5 ef ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a6e:	8b 00                	mov    (%eax),%eax
80104a70:	39 c6                	cmp    %eax,%esi
80104a72:	73 1c                	jae    80104a90 <argint+0x40>
80104a74:	8d 53 08             	lea    0x8(%ebx),%edx
80104a77:	39 d0                	cmp    %edx,%eax
80104a79:	72 15                	jb     80104a90 <argint+0x40>
  *ip = *(int*)(addr);
80104a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a81:	89 10                	mov    %edx,(%eax)
  return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	5b                   	pop    %ebx
80104a86:	5e                   	pop    %esi
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a95:	eb ee                	jmp    80104a85 <argint+0x35>
80104a97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a9e:	00 
80104a9f:	90                   	nop

80104aa0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	53                   	push   %ebx
80104aa6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104aa9:	e8 82 ef ff ff       	call   80103a30 <myproc>
80104aae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab0:	e8 7b ef ff ff       	call   80103a30 <myproc>
80104ab5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab8:	8b 40 18             	mov    0x18(%eax),%eax
80104abb:	8b 40 44             	mov    0x44(%eax),%eax
80104abe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ac1:	e8 6a ef ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ac9:	8b 00                	mov    (%eax),%eax
80104acb:	39 c7                	cmp    %eax,%edi
80104acd:	73 31                	jae    80104b00 <argptr+0x60>
80104acf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ad2:	39 c8                	cmp    %ecx,%eax
80104ad4:	72 2a                	jb     80104b00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ad6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ad9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104adc:	85 d2                	test   %edx,%edx
80104ade:	78 20                	js     80104b00 <argptr+0x60>
80104ae0:	8b 16                	mov    (%esi),%edx
80104ae2:	39 c2                	cmp    %eax,%edx
80104ae4:	76 1a                	jbe    80104b00 <argptr+0x60>
80104ae6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ae9:	01 c3                	add    %eax,%ebx
80104aeb:	39 da                	cmp    %ebx,%edx
80104aed:	72 11                	jb     80104b00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104aef:	8b 55 0c             	mov    0xc(%ebp),%edx
80104af2:	89 02                	mov    %eax,(%edx)
  return 0;
80104af4:	31 c0                	xor    %eax,%eax
}
80104af6:	83 c4 0c             	add    $0xc,%esp
80104af9:	5b                   	pop    %ebx
80104afa:	5e                   	pop    %esi
80104afb:	5f                   	pop    %edi
80104afc:	5d                   	pop    %ebp
80104afd:	c3                   	ret
80104afe:	66 90                	xchg   %ax,%ax
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b05:	eb ef                	jmp    80104af6 <argptr+0x56>
80104b07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b0e:	00 
80104b0f:	90                   	nop

80104b10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b15:	e8 16 ef ff ff       	call   80103a30 <myproc>
80104b1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b1d:	8b 40 18             	mov    0x18(%eax),%eax
80104b20:	8b 40 44             	mov    0x44(%eax),%eax
80104b23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b26:	e8 05 ef ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b2e:	8b 00                	mov    (%eax),%eax
80104b30:	39 c6                	cmp    %eax,%esi
80104b32:	73 44                	jae    80104b78 <argstr+0x68>
80104b34:	8d 53 08             	lea    0x8(%ebx),%edx
80104b37:	39 d0                	cmp    %edx,%eax
80104b39:	72 3d                	jb     80104b78 <argstr+0x68>
  *ip = *(int*)(addr);
80104b3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b3e:	e8 ed ee ff ff       	call   80103a30 <myproc>
  if(addr >= curproc->sz)
80104b43:	3b 18                	cmp    (%eax),%ebx
80104b45:	73 31                	jae    80104b78 <argstr+0x68>
  *pp = (char*)addr;
80104b47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b4e:	39 d3                	cmp    %edx,%ebx
80104b50:	73 26                	jae    80104b78 <argstr+0x68>
80104b52:	89 d8                	mov    %ebx,%eax
80104b54:	eb 11                	jmp    80104b67 <argstr+0x57>
80104b56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b5d:	00 
80104b5e:	66 90                	xchg   %ax,%ax
80104b60:	83 c0 01             	add    $0x1,%eax
80104b63:	39 c2                	cmp    %eax,%edx
80104b65:	76 11                	jbe    80104b78 <argstr+0x68>
    if(*s == 0)
80104b67:	80 38 00             	cmpb   $0x0,(%eax)
80104b6a:	75 f4                	jne    80104b60 <argstr+0x50>
      return s - *pp;
80104b6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b6e:	5b                   	pop    %ebx
80104b6f:	5e                   	pop    %esi
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b78:	5b                   	pop    %ebx
    return -1;
80104b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b7e:	5e                   	pop    %esi
80104b7f:	5d                   	pop    %ebp
80104b80:	c3                   	ret
80104b81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b88:	00 
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b90 <strcmp>:

// Helper function for comparing two strings.
int
strcmp(const char *p, const char *q)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	8b 55 08             	mov    0x8(%ebp),%edx
80104b97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
80104b9a:	0f b6 02             	movzbl (%edx),%eax
80104b9d:	84 c0                	test   %al,%al
80104b9f:	75 17                	jne    80104bb8 <strcmp+0x28>
80104ba1:	eb 3a                	jmp    80104bdd <strcmp+0x4d>
80104ba3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ba8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
80104bac:	83 c2 01             	add    $0x1,%edx
80104baf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
80104bb2:	84 c0                	test   %al,%al
80104bb4:	74 1a                	je     80104bd0 <strcmp+0x40>
    p++, q++;
80104bb6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
80104bb8:	0f b6 19             	movzbl (%ecx),%ebx
80104bbb:	38 c3                	cmp    %al,%bl
80104bbd:	74 e9                	je     80104ba8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
80104bbf:	29 d8                	sub    %ebx,%eax
}
80104bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc4:	c9                   	leave
80104bc5:	c3                   	ret
80104bc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bcd:	00 
80104bce:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
80104bd0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
80104bd4:	31 c0                	xor    %eax,%eax
80104bd6:	29 d8                	sub    %ebx,%eax
}
80104bd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bdb:	c9                   	leave
80104bdc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
80104bdd:	0f b6 19             	movzbl (%ecx),%ebx
80104be0:	31 c0                	xor    %eax,%eax
80104be2:	eb db                	jmp    80104bbf <strcmp+0x2f>
80104be4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104beb:	00 
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <syscall>:
[SYS_gethistory]  sys_gethistory,
[SYS_block]   sys_block,
[SYS_unblock]   sys_unblock,     
};

void syscall(void) {
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104bf7:	e8 34 ee ff ff       	call   80103a30 <myproc>
80104bfc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bfe:	8b 40 18             	mov    0x18(%eax),%eax
80104c01:	8b 40 1c             	mov    0x1c(%eax),%eax

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c07:	83 fa 17             	cmp    $0x17,%edx
80104c0a:	77 2c                	ja     80104c38 <syscall+0x48>
80104c0c:	8b 14 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%edx
80104c13:	85 d2                	test   %edx,%edx
80104c15:	74 21                	je     80104c38 <syscall+0x48>
    // Check if the syscall is blocked
    if (blocked_syscalls[num]) {
80104c17:	8b 0c 85 60 3d 11 80 	mov    -0x7feec2a0(,%eax,4),%ecx
80104c1e:	85 c9                	test   %ecx,%ecx
80104c20:	75 3e                	jne    80104c60 <syscall+0x70>
      cprintf("syscall %d is blocked\n", num);
      curproc->tf->eax = -1;  // Return error
      return;
    }

    curproc->tf->eax = syscalls[num]();
80104c22:	ff d2                	call   *%edx
80104c24:	89 c2                	mov    %eax,%edx
80104c26:	8b 43 18             	mov    0x18(%ebx),%eax
80104c29:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c2f:	c9                   	leave
80104c30:	c3                   	ret
80104c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c38:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c39:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c3c:	50                   	push   %eax
80104c3d:	ff 73 10             	push   0x10(%ebx)
80104c40:	68 70 78 10 80       	push   $0x80107870
80104c45:	e8 56 ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c4a:	8b 43 18             	mov    0x18(%ebx),%eax
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c5a:	c9                   	leave
80104c5b:	c3                   	ret
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("syscall %d is blocked\n", num);
80104c60:	83 ec 08             	sub    $0x8,%esp
80104c63:	50                   	push   %eax
80104c64:	68 59 78 10 80       	push   $0x80107859
80104c69:	e8 32 ba ff ff       	call   801006a0 <cprintf>
      curproc->tf->eax = -1;  // Return error
80104c6e:	8b 43 18             	mov    0x18(%ebx),%eax
      return;
80104c71:	83 c4 10             	add    $0x10,%esp
      curproc->tf->eax = -1;  // Return error
80104c74:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
      return;
80104c7b:	eb da                	jmp    80104c57 <syscall+0x67>
80104c7d:	66 90                	xchg   %ax,%ax
80104c7f:	90                   	nop

80104c80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c88:	53                   	push   %ebx
80104c89:	83 ec 34             	sub    $0x34,%esp
80104c8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c92:	57                   	push   %edi
80104c93:	50                   	push   %eax
{
80104c94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c9a:	e8 21 d4 ff ff       	call   801020c0 <nameiparent>
80104c9f:	83 c4 10             	add    $0x10,%esp
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	0f 84 46 01 00 00    	je     80104df0 <create+0x170>
    return 0;
  ilock(dp);
80104caa:	83 ec 0c             	sub    $0xc,%esp
80104cad:	89 c3                	mov    %eax,%ebx
80104caf:	50                   	push   %eax
80104cb0:	e8 cb ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cb5:	83 c4 0c             	add    $0xc,%esp
80104cb8:	6a 00                	push   $0x0
80104cba:	57                   	push   %edi
80104cbb:	53                   	push   %ebx
80104cbc:	e8 1f d0 ff ff       	call   80101ce0 <dirlookup>
80104cc1:	83 c4 10             	add    $0x10,%esp
80104cc4:	89 c6                	mov    %eax,%esi
80104cc6:	85 c0                	test   %eax,%eax
80104cc8:	74 56                	je     80104d20 <create+0xa0>
    iunlockput(dp);
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	53                   	push   %ebx
80104cce:	e8 3d cd ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104cd3:	89 34 24             	mov    %esi,(%esp)
80104cd6:	e8 a5 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cdb:	83 c4 10             	add    $0x10,%esp
80104cde:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ce3:	75 1b                	jne    80104d00 <create+0x80>
80104ce5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104cea:	75 14                	jne    80104d00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cef:	89 f0                	mov    %esi,%eax
80104cf1:	5b                   	pop    %ebx
80104cf2:	5e                   	pop    %esi
80104cf3:	5f                   	pop    %edi
80104cf4:	5d                   	pop    %ebp
80104cf5:	c3                   	ret
80104cf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cfd:	00 
80104cfe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104d00:	83 ec 0c             	sub    $0xc,%esp
80104d03:	56                   	push   %esi
    return 0;
80104d04:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d06:	e8 05 cd ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d0b:	83 c4 10             	add    $0x10,%esp
}
80104d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d11:	89 f0                	mov    %esi,%eax
80104d13:	5b                   	pop    %ebx
80104d14:	5e                   	pop    %esi
80104d15:	5f                   	pop    %edi
80104d16:	5d                   	pop    %ebp
80104d17:	c3                   	ret
80104d18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d1f:	00 
  if((ip = ialloc(dp->dev, type)) == 0)
80104d20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d24:	83 ec 08             	sub    $0x8,%esp
80104d27:	50                   	push   %eax
80104d28:	ff 33                	push   (%ebx)
80104d2a:	e8 e1 c8 ff ff       	call   80101610 <ialloc>
80104d2f:	83 c4 10             	add    $0x10,%esp
80104d32:	89 c6                	mov    %eax,%esi
80104d34:	85 c0                	test   %eax,%eax
80104d36:	0f 84 cd 00 00 00    	je     80104e09 <create+0x189>
  ilock(ip);
80104d3c:	83 ec 0c             	sub    $0xc,%esp
80104d3f:	50                   	push   %eax
80104d40:	e8 3b ca ff ff       	call   80101780 <ilock>
  ip->major = major;
80104d45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d49:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d51:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d55:	b8 01 00 00 00       	mov    $0x1,%eax
80104d5a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d5e:	89 34 24             	mov    %esi,(%esp)
80104d61:	e8 6a c9 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d66:	83 c4 10             	add    $0x10,%esp
80104d69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d6e:	74 30                	je     80104da0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d70:	83 ec 04             	sub    $0x4,%esp
80104d73:	ff 76 04             	push   0x4(%esi)
80104d76:	57                   	push   %edi
80104d77:	53                   	push   %ebx
80104d78:	e8 63 d2 ff ff       	call   80101fe0 <dirlink>
80104d7d:	83 c4 10             	add    $0x10,%esp
80104d80:	85 c0                	test   %eax,%eax
80104d82:	78 78                	js     80104dfc <create+0x17c>
  iunlockput(dp);
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	53                   	push   %ebx
80104d88:	e8 83 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104d8d:	83 c4 10             	add    $0x10,%esp
}
80104d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d93:	89 f0                	mov    %esi,%eax
80104d95:	5b                   	pop    %ebx
80104d96:	5e                   	pop    %esi
80104d97:	5f                   	pop    %edi
80104d98:	5d                   	pop    %ebp
80104d99:	c3                   	ret
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104da0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104da3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104da8:	53                   	push   %ebx
80104da9:	e8 22 c9 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dae:	83 c4 0c             	add    $0xc,%esp
80104db1:	ff 76 04             	push   0x4(%esi)
80104db4:	68 a8 78 10 80       	push   $0x801078a8
80104db9:	56                   	push   %esi
80104dba:	e8 21 d2 ff ff       	call   80101fe0 <dirlink>
80104dbf:	83 c4 10             	add    $0x10,%esp
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	78 18                	js     80104dde <create+0x15e>
80104dc6:	83 ec 04             	sub    $0x4,%esp
80104dc9:	ff 73 04             	push   0x4(%ebx)
80104dcc:	68 a7 78 10 80       	push   $0x801078a7
80104dd1:	56                   	push   %esi
80104dd2:	e8 09 d2 ff ff       	call   80101fe0 <dirlink>
80104dd7:	83 c4 10             	add    $0x10,%esp
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	79 92                	jns    80104d70 <create+0xf0>
      panic("create dots");
80104dde:	83 ec 0c             	sub    $0xc,%esp
80104de1:	68 9b 78 10 80       	push   $0x8010789b
80104de6:	e8 95 b5 ff ff       	call   80100380 <panic>
80104deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80104df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104df3:	31 f6                	xor    %esi,%esi
}
80104df5:	5b                   	pop    %ebx
80104df6:	89 f0                	mov    %esi,%eax
80104df8:	5e                   	pop    %esi
80104df9:	5f                   	pop    %edi
80104dfa:	5d                   	pop    %ebp
80104dfb:	c3                   	ret
    panic("create: dirlink");
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	68 aa 78 10 80       	push   $0x801078aa
80104e04:	e8 77 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e09:	83 ec 0c             	sub    $0xc,%esp
80104e0c:	68 8c 78 10 80       	push   $0x8010788c
80104e11:	e8 6a b5 ff ff       	call   80100380 <panic>
80104e16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e1d:	00 
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <sys_dup>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e2b:	50                   	push   %eax
80104e2c:	6a 00                	push   $0x0
80104e2e:	e8 1d fc ff ff       	call   80104a50 <argint>
80104e33:	83 c4 10             	add    $0x10,%esp
80104e36:	85 c0                	test   %eax,%eax
80104e38:	78 36                	js     80104e70 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e3e:	77 30                	ja     80104e70 <sys_dup+0x50>
80104e40:	e8 eb eb ff ff       	call   80103a30 <myproc>
80104e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e4c:	85 f6                	test   %esi,%esi
80104e4e:	74 20                	je     80104e70 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e50:	e8 db eb ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e55:	31 db                	xor    %ebx,%ebx
80104e57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e5e:	00 
80104e5f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104e60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e64:	85 d2                	test   %edx,%edx
80104e66:	74 18                	je     80104e80 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e68:	83 c3 01             	add    $0x1,%ebx
80104e6b:	83 fb 10             	cmp    $0x10,%ebx
80104e6e:	75 f0                	jne    80104e60 <sys_dup+0x40>
}
80104e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e78:	89 d8                	mov    %ebx,%eax
80104e7a:	5b                   	pop    %ebx
80104e7b:	5e                   	pop    %esi
80104e7c:	5d                   	pop    %ebp
80104e7d:	c3                   	ret
80104e7e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e80:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e83:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e87:	56                   	push   %esi
80104e88:	e8 13 c0 ff ff       	call   80100ea0 <filedup>
  return fd;
80104e8d:	83 c4 10             	add    $0x10,%esp
}
80104e90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e93:	89 d8                	mov    %ebx,%eax
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5d                   	pop    %ebp
80104e98:	c3                   	ret
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <sys_read>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ea5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ea8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eab:	53                   	push   %ebx
80104eac:	6a 00                	push   $0x0
80104eae:	e8 9d fb ff ff       	call   80104a50 <argint>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 5e                	js     80104f18 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ebe:	77 58                	ja     80104f18 <sys_read+0x78>
80104ec0:	e8 6b eb ff ff       	call   80103a30 <myproc>
80104ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ec8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ecc:	85 f6                	test   %esi,%esi
80104ece:	74 48                	je     80104f18 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ed0:	83 ec 08             	sub    $0x8,%esp
80104ed3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ed6:	50                   	push   %eax
80104ed7:	6a 02                	push   $0x2
80104ed9:	e8 72 fb ff ff       	call   80104a50 <argint>
80104ede:	83 c4 10             	add    $0x10,%esp
80104ee1:	85 c0                	test   %eax,%eax
80104ee3:	78 33                	js     80104f18 <sys_read+0x78>
80104ee5:	83 ec 04             	sub    $0x4,%esp
80104ee8:	ff 75 f0             	push   -0x10(%ebp)
80104eeb:	53                   	push   %ebx
80104eec:	6a 01                	push   $0x1
80104eee:	e8 ad fb ff ff       	call   80104aa0 <argptr>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 1e                	js     80104f18 <sys_read+0x78>
  return fileread(f, p, n);
80104efa:	83 ec 04             	sub    $0x4,%esp
80104efd:	ff 75 f0             	push   -0x10(%ebp)
80104f00:	ff 75 f4             	push   -0xc(%ebp)
80104f03:	56                   	push   %esi
80104f04:	e8 17 c1 ff ff       	call   80101020 <fileread>
80104f09:	83 c4 10             	add    $0x10,%esp
}
80104f0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f0f:	5b                   	pop    %ebx
80104f10:	5e                   	pop    %esi
80104f11:	5d                   	pop    %ebp
80104f12:	c3                   	ret
80104f13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f1d:	eb ed                	jmp    80104f0c <sys_read+0x6c>
80104f1f:	90                   	nop

80104f20 <sys_write>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	53                   	push   %ebx
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 1d fb ff ff       	call   80104a50 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 5e                	js     80104f98 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 58                	ja     80104f98 <sys_write+0x78>
80104f40:	e8 eb ea ff ff       	call   80103a30 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 48                	je     80104f98 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f50:	83 ec 08             	sub    $0x8,%esp
80104f53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f56:	50                   	push   %eax
80104f57:	6a 02                	push   $0x2
80104f59:	e8 f2 fa ff ff       	call   80104a50 <argint>
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	85 c0                	test   %eax,%eax
80104f63:	78 33                	js     80104f98 <sys_write+0x78>
80104f65:	83 ec 04             	sub    $0x4,%esp
80104f68:	ff 75 f0             	push   -0x10(%ebp)
80104f6b:	53                   	push   %ebx
80104f6c:	6a 01                	push   $0x1
80104f6e:	e8 2d fb ff ff       	call   80104aa0 <argptr>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 1e                	js     80104f98 <sys_write+0x78>
  return filewrite(f, p, n);
80104f7a:	83 ec 04             	sub    $0x4,%esp
80104f7d:	ff 75 f0             	push   -0x10(%ebp)
80104f80:	ff 75 f4             	push   -0xc(%ebp)
80104f83:	56                   	push   %esi
80104f84:	e8 27 c1 ff ff       	call   801010b0 <filewrite>
80104f89:	83 c4 10             	add    $0x10,%esp
}
80104f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f8f:	5b                   	pop    %ebx
80104f90:	5e                   	pop    %esi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret
80104f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9d:	eb ed                	jmp    80104f8c <sys_write+0x6c>
80104f9f:	90                   	nop

80104fa0 <sys_close>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	50                   	push   %eax
80104fac:	6a 00                	push   $0x0
80104fae:	e8 9d fa ff ff       	call   80104a50 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 3e                	js     80104ff8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 38                	ja     80104ff8 <sys_close+0x58>
80104fc0:	e8 6b ea ff ff       	call   80103a30 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104fcb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104fcf:	85 f6                	test   %esi,%esi
80104fd1:	74 25                	je     80104ff8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104fd3:	e8 58 ea ff ff       	call   80103a30 <myproc>
  fileclose(f);
80104fd8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104fdb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104fe2:	00 
  fileclose(f);
80104fe3:	56                   	push   %esi
80104fe4:	e8 07 bf ff ff       	call   80100ef0 <fileclose>
  return 0;
80104fe9:	83 c4 10             	add    $0x10,%esp
80104fec:	31 c0                	xor    %eax,%eax
}
80104fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff1:	5b                   	pop    %ebx
80104ff2:	5e                   	pop    %esi
80104ff3:	5d                   	pop    %ebp
80104ff4:	c3                   	ret
80104ff5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffd:	eb ef                	jmp    80104fee <sys_close+0x4e>
80104fff:	90                   	nop

80105000 <sys_fstat>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105005:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105008:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010500b:	53                   	push   %ebx
8010500c:	6a 00                	push   $0x0
8010500e:	e8 3d fa ff ff       	call   80104a50 <argint>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	78 46                	js     80105060 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010501a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010501e:	77 40                	ja     80105060 <sys_fstat+0x60>
80105020:	e8 0b ea ff ff       	call   80103a30 <myproc>
80105025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105028:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010502c:	85 f6                	test   %esi,%esi
8010502e:	74 30                	je     80105060 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105030:	83 ec 04             	sub    $0x4,%esp
80105033:	6a 14                	push   $0x14
80105035:	53                   	push   %ebx
80105036:	6a 01                	push   $0x1
80105038:	e8 63 fa ff ff       	call   80104aa0 <argptr>
8010503d:	83 c4 10             	add    $0x10,%esp
80105040:	85 c0                	test   %eax,%eax
80105042:	78 1c                	js     80105060 <sys_fstat+0x60>
  return filestat(f, st);
80105044:	83 ec 08             	sub    $0x8,%esp
80105047:	ff 75 f4             	push   -0xc(%ebp)
8010504a:	56                   	push   %esi
8010504b:	e8 80 bf ff ff       	call   80100fd0 <filestat>
80105050:	83 c4 10             	add    $0x10,%esp
}
80105053:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105056:	5b                   	pop    %ebx
80105057:	5e                   	pop    %esi
80105058:	5d                   	pop    %ebp
80105059:	c3                   	ret
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	eb ec                	jmp    80105053 <sys_fstat+0x53>
80105067:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010506e:	00 
8010506f:	90                   	nop

80105070 <sys_link>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105075:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105078:	53                   	push   %ebx
80105079:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010507c:	50                   	push   %eax
8010507d:	6a 00                	push   $0x0
8010507f:	e8 8c fa ff ff       	call   80104b10 <argstr>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	85 c0                	test   %eax,%eax
80105089:	0f 88 fb 00 00 00    	js     8010518a <sys_link+0x11a>
8010508f:	83 ec 08             	sub    $0x8,%esp
80105092:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105095:	50                   	push   %eax
80105096:	6a 01                	push   $0x1
80105098:	e8 73 fa ff ff       	call   80104b10 <argstr>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	0f 88 e2 00 00 00    	js     8010518a <sys_link+0x11a>
  begin_op();
801050a8:	e8 b3 dc ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
801050ad:	83 ec 0c             	sub    $0xc,%esp
801050b0:	ff 75 d4             	push   -0x2c(%ebp)
801050b3:	e8 e8 cf ff ff       	call   801020a0 <namei>
801050b8:	83 c4 10             	add    $0x10,%esp
801050bb:	89 c3                	mov    %eax,%ebx
801050bd:	85 c0                	test   %eax,%eax
801050bf:	0f 84 e4 00 00 00    	je     801051a9 <sys_link+0x139>
  ilock(ip);
801050c5:	83 ec 0c             	sub    $0xc,%esp
801050c8:	50                   	push   %eax
801050c9:	e8 b2 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
801050ce:	83 c4 10             	add    $0x10,%esp
801050d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050d6:	0f 84 b5 00 00 00    	je     80105191 <sys_link+0x121>
  iupdate(ip);
801050dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801050df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801050e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050e7:	53                   	push   %ebx
801050e8:	e8 e3 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801050ed:	89 1c 24             	mov    %ebx,(%esp)
801050f0:	e8 6b c7 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050f5:	58                   	pop    %eax
801050f6:	5a                   	pop    %edx
801050f7:	57                   	push   %edi
801050f8:	ff 75 d0             	push   -0x30(%ebp)
801050fb:	e8 c0 cf ff ff       	call   801020c0 <nameiparent>
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	89 c6                	mov    %eax,%esi
80105105:	85 c0                	test   %eax,%eax
80105107:	74 5b                	je     80105164 <sys_link+0xf4>
  ilock(dp);
80105109:	83 ec 0c             	sub    $0xc,%esp
8010510c:	50                   	push   %eax
8010510d:	e8 6e c6 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105112:	8b 03                	mov    (%ebx),%eax
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	39 06                	cmp    %eax,(%esi)
80105119:	75 3d                	jne    80105158 <sys_link+0xe8>
8010511b:	83 ec 04             	sub    $0x4,%esp
8010511e:	ff 73 04             	push   0x4(%ebx)
80105121:	57                   	push   %edi
80105122:	56                   	push   %esi
80105123:	e8 b8 ce ff ff       	call   80101fe0 <dirlink>
80105128:	83 c4 10             	add    $0x10,%esp
8010512b:	85 c0                	test   %eax,%eax
8010512d:	78 29                	js     80105158 <sys_link+0xe8>
  iunlockput(dp);
8010512f:	83 ec 0c             	sub    $0xc,%esp
80105132:	56                   	push   %esi
80105133:	e8 d8 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105138:	89 1c 24             	mov    %ebx,(%esp)
8010513b:	e8 70 c7 ff ff       	call   801018b0 <iput>
  end_op();
80105140:	e8 8b dc ff ff       	call   80102dd0 <end_op>
  return 0;
80105145:	83 c4 10             	add    $0x10,%esp
80105148:	31 c0                	xor    %eax,%eax
}
8010514a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010514d:	5b                   	pop    %ebx
8010514e:	5e                   	pop    %esi
8010514f:	5f                   	pop    %edi
80105150:	5d                   	pop    %ebp
80105151:	c3                   	ret
80105152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	56                   	push   %esi
8010515c:	e8 af c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105161:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105164:	83 ec 0c             	sub    $0xc,%esp
80105167:	53                   	push   %ebx
80105168:	e8 13 c6 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010516d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105172:	89 1c 24             	mov    %ebx,(%esp)
80105175:	e8 56 c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010517a:	89 1c 24             	mov    %ebx,(%esp)
8010517d:	e8 8e c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105182:	e8 49 dc ff ff       	call   80102dd0 <end_op>
  return -1;
80105187:	83 c4 10             	add    $0x10,%esp
8010518a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518f:	eb b9                	jmp    8010514a <sys_link+0xda>
    iunlockput(ip);
80105191:	83 ec 0c             	sub    $0xc,%esp
80105194:	53                   	push   %ebx
80105195:	e8 76 c8 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010519a:	e8 31 dc ff ff       	call   80102dd0 <end_op>
    return -1;
8010519f:	83 c4 10             	add    $0x10,%esp
801051a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a7:	eb a1                	jmp    8010514a <sys_link+0xda>
    end_op();
801051a9:	e8 22 dc ff ff       	call   80102dd0 <end_op>
    return -1;
801051ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b3:	eb 95                	jmp    8010514a <sys_link+0xda>
801051b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051bc:	00 
801051bd:	8d 76 00             	lea    0x0(%esi),%esi

801051c0 <sys_unlink>:
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	57                   	push   %edi
801051c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051c8:	53                   	push   %ebx
801051c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051cc:	50                   	push   %eax
801051cd:	6a 00                	push   $0x0
801051cf:	e8 3c f9 ff ff       	call   80104b10 <argstr>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	0f 88 7a 01 00 00    	js     80105359 <sys_unlink+0x199>
  begin_op();
801051df:	e8 7c db ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	53                   	push   %ebx
801051eb:	ff 75 c0             	push   -0x40(%ebp)
801051ee:	e8 cd ce ff ff       	call   801020c0 <nameiparent>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801051f9:	85 c0                	test   %eax,%eax
801051fb:	0f 84 62 01 00 00    	je     80105363 <sys_unlink+0x1a3>
  ilock(dp);
80105201:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	57                   	push   %edi
80105208:	e8 73 c5 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010520d:	58                   	pop    %eax
8010520e:	5a                   	pop    %edx
8010520f:	68 a8 78 10 80       	push   $0x801078a8
80105214:	53                   	push   %ebx
80105215:	e8 a6 ca ff ff       	call   80101cc0 <namecmp>
8010521a:	83 c4 10             	add    $0x10,%esp
8010521d:	85 c0                	test   %eax,%eax
8010521f:	0f 84 fb 00 00 00    	je     80105320 <sys_unlink+0x160>
80105225:	83 ec 08             	sub    $0x8,%esp
80105228:	68 a7 78 10 80       	push   $0x801078a7
8010522d:	53                   	push   %ebx
8010522e:	e8 8d ca ff ff       	call   80101cc0 <namecmp>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	0f 84 e2 00 00 00    	je     80105320 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010523e:	83 ec 04             	sub    $0x4,%esp
80105241:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105244:	50                   	push   %eax
80105245:	53                   	push   %ebx
80105246:	57                   	push   %edi
80105247:	e8 94 ca ff ff       	call   80101ce0 <dirlookup>
8010524c:	83 c4 10             	add    $0x10,%esp
8010524f:	89 c3                	mov    %eax,%ebx
80105251:	85 c0                	test   %eax,%eax
80105253:	0f 84 c7 00 00 00    	je     80105320 <sys_unlink+0x160>
  ilock(ip);
80105259:	83 ec 0c             	sub    $0xc,%esp
8010525c:	50                   	push   %eax
8010525d:	e8 1e c5 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105262:	83 c4 10             	add    $0x10,%esp
80105265:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010526a:	0f 8e 1c 01 00 00    	jle    8010538c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105270:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105275:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105278:	74 66                	je     801052e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010527a:	83 ec 04             	sub    $0x4,%esp
8010527d:	6a 10                	push   $0x10
8010527f:	6a 00                	push   $0x0
80105281:	57                   	push   %edi
80105282:	e8 09 f5 ff ff       	call   80104790 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105287:	6a 10                	push   $0x10
80105289:	ff 75 c4             	push   -0x3c(%ebp)
8010528c:	57                   	push   %edi
8010528d:	ff 75 b4             	push   -0x4c(%ebp)
80105290:	e8 fb c8 ff ff       	call   80101b90 <writei>
80105295:	83 c4 20             	add    $0x20,%esp
80105298:	83 f8 10             	cmp    $0x10,%eax
8010529b:	0f 85 de 00 00 00    	jne    8010537f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801052a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052a6:	0f 84 94 00 00 00    	je     80105340 <sys_unlink+0x180>
  iunlockput(dp);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	ff 75 b4             	push   -0x4c(%ebp)
801052b2:	e8 59 c7 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801052b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052bc:	89 1c 24             	mov    %ebx,(%esp)
801052bf:	e8 0c c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801052c4:	89 1c 24             	mov    %ebx,(%esp)
801052c7:	e8 44 c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052cc:	e8 ff da ff ff       	call   80102dd0 <end_op>
  return 0;
801052d1:	83 c4 10             	add    $0x10,%esp
801052d4:	31 c0                	xor    %eax,%eax
}
801052d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052d9:	5b                   	pop    %ebx
801052da:	5e                   	pop    %esi
801052db:	5f                   	pop    %edi
801052dc:	5d                   	pop    %ebp
801052dd:	c3                   	ret
801052de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052e4:	76 94                	jbe    8010527a <sys_unlink+0xba>
801052e6:	be 20 00 00 00       	mov    $0x20,%esi
801052eb:	eb 0b                	jmp    801052f8 <sys_unlink+0x138>
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
801052f0:	83 c6 10             	add    $0x10,%esi
801052f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801052f6:	73 82                	jae    8010527a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052f8:	6a 10                	push   $0x10
801052fa:	56                   	push   %esi
801052fb:	57                   	push   %edi
801052fc:	53                   	push   %ebx
801052fd:	e8 8e c7 ff ff       	call   80101a90 <readi>
80105302:	83 c4 10             	add    $0x10,%esp
80105305:	83 f8 10             	cmp    $0x10,%eax
80105308:	75 68                	jne    80105372 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010530a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010530f:	74 df                	je     801052f0 <sys_unlink+0x130>
    iunlockput(ip);
80105311:	83 ec 0c             	sub    $0xc,%esp
80105314:	53                   	push   %ebx
80105315:	e8 f6 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	ff 75 b4             	push   -0x4c(%ebp)
80105326:	e8 e5 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010532b:	e8 a0 da ff ff       	call   80102dd0 <end_op>
  return -1;
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105338:	eb 9c                	jmp    801052d6 <sys_unlink+0x116>
8010533a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105340:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105343:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105346:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010534b:	50                   	push   %eax
8010534c:	e8 7f c3 ff ff       	call   801016d0 <iupdate>
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	e9 53 ff ff ff       	jmp    801052ac <sys_unlink+0xec>
    return -1;
80105359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535e:	e9 73 ff ff ff       	jmp    801052d6 <sys_unlink+0x116>
    end_op();
80105363:	e8 68 da ff ff       	call   80102dd0 <end_op>
    return -1;
80105368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536d:	e9 64 ff ff ff       	jmp    801052d6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105372:	83 ec 0c             	sub    $0xc,%esp
80105375:	68 cc 78 10 80       	push   $0x801078cc
8010537a:	e8 01 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010537f:	83 ec 0c             	sub    $0xc,%esp
80105382:	68 de 78 10 80       	push   $0x801078de
80105387:	e8 f4 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010538c:	83 ec 0c             	sub    $0xc,%esp
8010538f:	68 ba 78 10 80       	push   $0x801078ba
80105394:	e8 e7 af ff ff       	call   80100380 <panic>
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_open>:

int
sys_open(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053a8:	53                   	push   %ebx
801053a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053ac:	50                   	push   %eax
801053ad:	6a 00                	push   $0x0
801053af:	e8 5c f7 ff ff       	call   80104b10 <argstr>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 88 8e 00 00 00    	js     8010544d <sys_open+0xad>
801053bf:	83 ec 08             	sub    $0x8,%esp
801053c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053c5:	50                   	push   %eax
801053c6:	6a 01                	push   $0x1
801053c8:	e8 83 f6 ff ff       	call   80104a50 <argint>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	78 79                	js     8010544d <sys_open+0xad>
    return -1;

  begin_op();
801053d4:	e8 87 d9 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
801053d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053dd:	75 79                	jne    80105458 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053df:	83 ec 0c             	sub    $0xc,%esp
801053e2:	ff 75 e0             	push   -0x20(%ebp)
801053e5:	e8 b6 cc ff ff       	call   801020a0 <namei>
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	89 c6                	mov    %eax,%esi
801053ef:	85 c0                	test   %eax,%eax
801053f1:	0f 84 7e 00 00 00    	je     80105475 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801053f7:	83 ec 0c             	sub    $0xc,%esp
801053fa:	50                   	push   %eax
801053fb:	e8 80 c3 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105400:	83 c4 10             	add    $0x10,%esp
80105403:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105408:	0f 84 c2 00 00 00    	je     801054d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010540e:	e8 1d ba ff ff       	call   80100e30 <filealloc>
80105413:	89 c7                	mov    %eax,%edi
80105415:	85 c0                	test   %eax,%eax
80105417:	74 23                	je     8010543c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105419:	e8 12 e6 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010541e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105420:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105424:	85 d2                	test   %edx,%edx
80105426:	74 60                	je     80105488 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105428:	83 c3 01             	add    $0x1,%ebx
8010542b:	83 fb 10             	cmp    $0x10,%ebx
8010542e:	75 f0                	jne    80105420 <sys_open+0x80>
    if(f)
      fileclose(f);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	57                   	push   %edi
80105434:	e8 b7 ba ff ff       	call   80100ef0 <fileclose>
80105439:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	56                   	push   %esi
80105440:	e8 cb c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105445:	e8 86 d9 ff ff       	call   80102dd0 <end_op>
    return -1;
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105452:	eb 6d                	jmp    801054c1 <sys_open+0x121>
80105454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105458:	83 ec 0c             	sub    $0xc,%esp
8010545b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010545e:	31 c9                	xor    %ecx,%ecx
80105460:	ba 02 00 00 00       	mov    $0x2,%edx
80105465:	6a 00                	push   $0x0
80105467:	e8 14 f8 ff ff       	call   80104c80 <create>
    if(ip == 0){
8010546c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010546f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105471:	85 c0                	test   %eax,%eax
80105473:	75 99                	jne    8010540e <sys_open+0x6e>
      end_op();
80105475:	e8 56 d9 ff ff       	call   80102dd0 <end_op>
      return -1;
8010547a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010547f:	eb 40                	jmp    801054c1 <sys_open+0x121>
80105481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105488:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010548b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010548f:	56                   	push   %esi
80105490:	e8 cb c3 ff ff       	call   80101860 <iunlock>
  end_op();
80105495:	e8 36 d9 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010549a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054b2:	f7 d0                	not    %eax
801054b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054c4:	89 d8                	mov    %ebx,%eax
801054c6:	5b                   	pop    %ebx
801054c7:	5e                   	pop    %esi
801054c8:	5f                   	pop    %edi
801054c9:	5d                   	pop    %ebp
801054ca:	c3                   	ret
801054cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801054d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054d3:	85 c9                	test   %ecx,%ecx
801054d5:	0f 84 33 ff ff ff    	je     8010540e <sys_open+0x6e>
801054db:	e9 5c ff ff ff       	jmp    8010543c <sys_open+0x9c>

801054e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054e6:	e8 75 d8 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054eb:	83 ec 08             	sub    $0x8,%esp
801054ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f1:	50                   	push   %eax
801054f2:	6a 00                	push   $0x0
801054f4:	e8 17 f6 ff ff       	call   80104b10 <argstr>
801054f9:	83 c4 10             	add    $0x10,%esp
801054fc:	85 c0                	test   %eax,%eax
801054fe:	78 30                	js     80105530 <sys_mkdir+0x50>
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105506:	31 c9                	xor    %ecx,%ecx
80105508:	ba 01 00 00 00       	mov    $0x1,%edx
8010550d:	6a 00                	push   $0x0
8010550f:	e8 6c f7 ff ff       	call   80104c80 <create>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	74 15                	je     80105530 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010551b:	83 ec 0c             	sub    $0xc,%esp
8010551e:	50                   	push   %eax
8010551f:	e8 ec c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105524:	e8 a7 d8 ff ff       	call   80102dd0 <end_op>
  return 0;
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	31 c0                	xor    %eax,%eax
}
8010552e:	c9                   	leave
8010552f:	c3                   	ret
    end_op();
80105530:	e8 9b d8 ff ff       	call   80102dd0 <end_op>
    return -1;
80105535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010553a:	c9                   	leave
8010553b:	c3                   	ret
8010553c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_mknod>:

int
sys_mknod(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105546:	e8 15 d8 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010554b:	83 ec 08             	sub    $0x8,%esp
8010554e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105551:	50                   	push   %eax
80105552:	6a 00                	push   $0x0
80105554:	e8 b7 f5 ff ff       	call   80104b10 <argstr>
80105559:	83 c4 10             	add    $0x10,%esp
8010555c:	85 c0                	test   %eax,%eax
8010555e:	78 60                	js     801055c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105560:	83 ec 08             	sub    $0x8,%esp
80105563:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105566:	50                   	push   %eax
80105567:	6a 01                	push   $0x1
80105569:	e8 e2 f4 ff ff       	call   80104a50 <argint>
  if((argstr(0, &path)) < 0 ||
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	85 c0                	test   %eax,%eax
80105573:	78 4b                	js     801055c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105575:	83 ec 08             	sub    $0x8,%esp
80105578:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557b:	50                   	push   %eax
8010557c:	6a 02                	push   $0x2
8010557e:	e8 cd f4 ff ff       	call   80104a50 <argint>
     argint(1, &major) < 0 ||
80105583:	83 c4 10             	add    $0x10,%esp
80105586:	85 c0                	test   %eax,%eax
80105588:	78 36                	js     801055c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010558a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010558e:	83 ec 0c             	sub    $0xc,%esp
80105591:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105595:	ba 03 00 00 00       	mov    $0x3,%edx
8010559a:	50                   	push   %eax
8010559b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010559e:	e8 dd f6 ff ff       	call   80104c80 <create>
     argint(2, &minor) < 0 ||
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	74 16                	je     801055c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055aa:	83 ec 0c             	sub    $0xc,%esp
801055ad:	50                   	push   %eax
801055ae:	e8 5d c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055b3:	e8 18 d8 ff ff       	call   80102dd0 <end_op>
  return 0;
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	31 c0                	xor    %eax,%eax
}
801055bd:	c9                   	leave
801055be:	c3                   	ret
801055bf:	90                   	nop
    end_op();
801055c0:	e8 0b d8 ff ff       	call   80102dd0 <end_op>
    return -1;
801055c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ca:	c9                   	leave
801055cb:	c3                   	ret
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_chdir>:

int
sys_chdir(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	56                   	push   %esi
801055d4:	53                   	push   %ebx
801055d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055d8:	e8 53 e4 ff ff       	call   80103a30 <myproc>
801055dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055df:	e8 7c d7 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055e4:	83 ec 08             	sub    $0x8,%esp
801055e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ea:	50                   	push   %eax
801055eb:	6a 00                	push   $0x0
801055ed:	e8 1e f5 ff ff       	call   80104b10 <argstr>
801055f2:	83 c4 10             	add    $0x10,%esp
801055f5:	85 c0                	test   %eax,%eax
801055f7:	78 77                	js     80105670 <sys_chdir+0xa0>
801055f9:	83 ec 0c             	sub    $0xc,%esp
801055fc:	ff 75 f4             	push   -0xc(%ebp)
801055ff:	e8 9c ca ff ff       	call   801020a0 <namei>
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	89 c3                	mov    %eax,%ebx
80105609:	85 c0                	test   %eax,%eax
8010560b:	74 63                	je     80105670 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010560d:	83 ec 0c             	sub    $0xc,%esp
80105610:	50                   	push   %eax
80105611:	e8 6a c1 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105616:	83 c4 10             	add    $0x10,%esp
80105619:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010561e:	75 30                	jne    80105650 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	53                   	push   %ebx
80105624:	e8 37 c2 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105629:	58                   	pop    %eax
8010562a:	ff 76 68             	push   0x68(%esi)
8010562d:	e8 7e c2 ff ff       	call   801018b0 <iput>
  end_op();
80105632:	e8 99 d7 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105637:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	31 c0                	xor    %eax,%eax
}
8010563f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105642:	5b                   	pop    %ebx
80105643:	5e                   	pop    %esi
80105644:	5d                   	pop    %ebp
80105645:	c3                   	ret
80105646:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010564d:	00 
8010564e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	53                   	push   %ebx
80105654:	e8 b7 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105659:	e8 72 d7 ff ff       	call   80102dd0 <end_op>
    return -1;
8010565e:	83 c4 10             	add    $0x10,%esp
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105666:	eb d7                	jmp    8010563f <sys_chdir+0x6f>
80105668:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010566f:	00 
    end_op();
80105670:	e8 5b d7 ff ff       	call   80102dd0 <end_op>
    return -1;
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567a:	eb c3                	jmp    8010563f <sys_chdir+0x6f>
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_exec>:

int
sys_exec(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	57                   	push   %edi
80105684:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105685:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010568b:	53                   	push   %ebx
8010568c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105692:	50                   	push   %eax
80105693:	6a 00                	push   $0x0
80105695:	e8 76 f4 ff ff       	call   80104b10 <argstr>
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	85 c0                	test   %eax,%eax
8010569f:	0f 88 87 00 00 00    	js     8010572c <sys_exec+0xac>
801056a5:	83 ec 08             	sub    $0x8,%esp
801056a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056ae:	50                   	push   %eax
801056af:	6a 01                	push   $0x1
801056b1:	e8 9a f3 ff ff       	call   80104a50 <argint>
801056b6:	83 c4 10             	add    $0x10,%esp
801056b9:	85 c0                	test   %eax,%eax
801056bb:	78 6f                	js     8010572c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056bd:	83 ec 04             	sub    $0x4,%esp
801056c0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801056c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056c8:	68 80 00 00 00       	push   $0x80
801056cd:	6a 00                	push   $0x0
801056cf:	56                   	push   %esi
801056d0:	e8 bb f0 ff ff       	call   80104790 <memset>
801056d5:	83 c4 10             	add    $0x10,%esp
801056d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056df:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056e0:	83 ec 08             	sub    $0x8,%esp
801056e3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801056e9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801056f0:	50                   	push   %eax
801056f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056f7:	01 f8                	add    %edi,%eax
801056f9:	50                   	push   %eax
801056fa:	e8 c1 f2 ff ff       	call   801049c0 <fetchint>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	78 26                	js     8010572c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105706:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010570c:	85 c0                	test   %eax,%eax
8010570e:	74 30                	je     80105740 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105716:	52                   	push   %edx
80105717:	50                   	push   %eax
80105718:	e8 e3 f2 ff ff       	call   80104a00 <fetchstr>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	78 08                	js     8010572c <sys_exec+0xac>
  for(i=0;; i++){
80105724:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105727:	83 fb 20             	cmp    $0x20,%ebx
8010572a:	75 b4                	jne    801056e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010572c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010572f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105734:	5b                   	pop    %ebx
80105735:	5e                   	pop    %esi
80105736:	5f                   	pop    %edi
80105737:	5d                   	pop    %ebp
80105738:	c3                   	ret
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105740:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105747:	00 00 00 00 
  return exec(path, argv);
8010574b:	83 ec 08             	sub    $0x8,%esp
8010574e:	56                   	push   %esi
8010574f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105755:	e8 56 b3 ff ff       	call   80100ab0 <exec>
8010575a:	83 c4 10             	add    $0x10,%esp
}
8010575d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105760:	5b                   	pop    %ebx
80105761:	5e                   	pop    %esi
80105762:	5f                   	pop    %edi
80105763:	5d                   	pop    %ebp
80105764:	c3                   	ret
80105765:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010576c:	00 
8010576d:	8d 76 00             	lea    0x0(%esi),%esi

80105770 <sys_pipe>:

int
sys_pipe(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105775:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105778:	53                   	push   %ebx
80105779:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010577c:	6a 08                	push   $0x8
8010577e:	50                   	push   %eax
8010577f:	6a 00                	push   $0x0
80105781:	e8 1a f3 ff ff       	call   80104aa0 <argptr>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	78 4a                	js     801057d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010578d:	83 ec 08             	sub    $0x8,%esp
80105790:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105793:	50                   	push   %eax
80105794:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105797:	50                   	push   %eax
80105798:	e8 93 dc ff ff       	call   80103430 <pipealloc>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 33                	js     801057d7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057a7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057a9:	e8 82 e2 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801057b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057b4:	85 f6                	test   %esi,%esi
801057b6:	74 28                	je     801057e0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801057b8:	83 c3 01             	add    $0x1,%ebx
801057bb:	83 fb 10             	cmp    $0x10,%ebx
801057be:	75 f0                	jne    801057b0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	ff 75 e0             	push   -0x20(%ebp)
801057c6:	e8 25 b7 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801057cb:	58                   	pop    %eax
801057cc:	ff 75 e4             	push   -0x1c(%ebp)
801057cf:	e8 1c b7 ff ff       	call   80100ef0 <fileclose>
    return -1;
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057dc:	eb 53                	jmp    80105831 <sys_pipe+0xc1>
801057de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057e0:	8d 73 08             	lea    0x8(%ebx),%esi
801057e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801057ea:	e8 41 e2 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057ef:	31 d2                	xor    %edx,%edx
801057f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801057f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057fc:	85 c9                	test   %ecx,%ecx
801057fe:	74 20                	je     80105820 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105800:	83 c2 01             	add    $0x1,%edx
80105803:	83 fa 10             	cmp    $0x10,%edx
80105806:	75 f0                	jne    801057f8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105808:	e8 23 e2 ff ff       	call   80103a30 <myproc>
8010580d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105814:	00 
80105815:	eb a9                	jmp    801057c0 <sys_pipe+0x50>
80105817:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010581e:	00 
8010581f:	90                   	nop
      curproc->ofile[fd] = f;
80105820:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105824:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105827:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105829:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010582c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010582f:	31 c0                	xor    %eax,%eax
}
80105831:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
80105838:	c3                   	ret
80105839:	66 90                	xchg   %ax,%ax
8010583b:	66 90                	xchg   %ax,%ax
8010583d:	66 90                	xchg   %ax,%ax
8010583f:	90                   	nop

80105840 <sys_fork>:

int blocked_syscalls[MAX_SYSCALLS] = {0};  // Global kernel-side tracking


int sys_fork(void) {
    return fork();
80105840:	e9 8b e3 ff ff       	jmp    80103bd0 <fork>
80105845:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010584c:	00 
8010584d:	8d 76 00             	lea    0x0(%esi),%esi

80105850 <sys_exit>:
}

int sys_exit(void) {
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 08             	sub    $0x8,%esp
    exit();
80105856:	e8 f5 e5 ff ff       	call   80103e50 <exit>
    return 0;  // not reached
}
8010585b:	31 c0                	xor    %eax,%eax
8010585d:	c9                   	leave
8010585e:	c3                   	ret
8010585f:	90                   	nop

80105860 <sys_wait>:

int sys_wait(void) {
    return wait();
80105860:	e9 8b e7 ff ff       	jmp    80103ff0 <wait>
80105865:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010586c:	00 
8010586d:	8d 76 00             	lea    0x0(%esi),%esi

80105870 <sys_kill>:
}

int sys_kill(void) {
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 20             	sub    $0x20,%esp
    int pid;
    if(argint(0, &pid) < 0)
80105876:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105879:	50                   	push   %eax
8010587a:	6a 00                	push   $0x0
8010587c:	e8 cf f1 ff ff       	call   80104a50 <argint>
80105881:	83 c4 10             	add    $0x10,%esp
80105884:	85 c0                	test   %eax,%eax
80105886:	78 18                	js     801058a0 <sys_kill+0x30>
        return -1;
    return kill(pid);
80105888:	83 ec 0c             	sub    $0xc,%esp
8010588b:	ff 75 f4             	push   -0xc(%ebp)
8010588e:	e8 fd e9 ff ff       	call   80104290 <kill>
80105893:	83 c4 10             	add    $0x10,%esp
}
80105896:	c9                   	leave
80105897:	c3                   	ret
80105898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589f:	00 
801058a0:	c9                   	leave
        return -1;
801058a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058a6:	c3                   	ret
801058a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058ae:	00 
801058af:	90                   	nop

801058b0 <sys_getpid>:

int sys_getpid(void) {
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
801058b6:	e8 75 e1 ff ff       	call   80103a30 <myproc>
801058bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801058be:	c9                   	leave
801058bf:	c3                   	ret

801058c0 <sys_sbrk>:
//     release(&ptable.lock);
    
//     return addr;
// }

int sys_sbrk(void) {
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	53                   	push   %ebx
801058c4:	83 ec 14             	sub    $0x14,%esp
    int addr;
    int n;
    struct proc *curproc = myproc();
801058c7:	e8 64 e1 ff ff       	call   80103a30 <myproc>

    if(argint(0, &n) < 0)
801058cc:	83 ec 08             	sub    $0x8,%esp
    struct proc *curproc = myproc();
801058cf:	89 c3                	mov    %eax,%ebx
    if(argint(0, &n) < 0)
801058d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d4:	50                   	push   %eax
801058d5:	6a 00                	push   $0x0
801058d7:	e8 74 f1 ff ff       	call   80104a50 <argint>
801058dc:	83 c4 10             	add    $0x10,%esp
801058df:	85 c0                	test   %eax,%eax
801058e1:	78 1d                	js     80105900 <sys_sbrk+0x40>
        return -1;
    addr = curproc->sz;

    if(growproc(n) < 0)
801058e3:	83 ec 0c             	sub    $0xc,%esp
    addr = curproc->sz;
801058e6:	8b 1b                	mov    (%ebx),%ebx
    if(growproc(n) < 0)
801058e8:	ff 75 f4             	push   -0xc(%ebp)
801058eb:	e8 60 e2 ff ff       	call   80103b50 <growproc>
801058f0:	83 c4 10             	add    $0x10,%esp
801058f3:	85 c0                	test   %eax,%eax
801058f5:	78 09                	js     80105900 <sys_sbrk+0x40>
        return -1;
    
    return addr;
}
801058f7:	89 d8                	mov    %ebx,%eax
801058f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058fc:	c9                   	leave
801058fd:	c3                   	ret
801058fe:	66 90                	xchg   %ax,%ax
        return -1;
80105900:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105905:	eb f0                	jmp    801058f7 <sys_sbrk+0x37>
80105907:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010590e:	00 
8010590f:	90                   	nop

80105910 <sys_sleep>:

//     return addr;
// }


int sys_sleep(void) {
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
    int n;
    uint ticks0;
    if(argint(0, &n) < 0)
80105914:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80105917:	83 ec 1c             	sub    $0x1c,%esp
    if(argint(0, &n) < 0)
8010591a:	50                   	push   %eax
8010591b:	6a 00                	push   $0x0
8010591d:	e8 2e f1 ff ff       	call   80104a50 <argint>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	0f 88 8a 00 00 00    	js     801059b7 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
8010592d:	83 ec 0c             	sub    $0xc,%esp
80105930:	68 00 3e 11 80       	push   $0x80113e00
80105935:	e8 96 ed ff ff       	call   801046d0 <acquire>
    ticks0 = ticks;
    while(ticks - ticks0 < n) {
8010593a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    ticks0 = ticks;
8010593d:	8b 1d e0 3d 11 80    	mov    0x80113de0,%ebx
    while(ticks - ticks0 < n) {
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 d2                	test   %edx,%edx
80105948:	75 27                	jne    80105971 <sys_sleep+0x61>
8010594a:	eb 54                	jmp    801059a0 <sys_sleep+0x90>
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105950:	83 ec 08             	sub    $0x8,%esp
80105953:	68 00 3e 11 80       	push   $0x80113e00
80105958:	68 e0 3d 11 80       	push   $0x80113de0
8010595d:	e8 0e e8 ff ff       	call   80104170 <sleep>
    while(ticks - ticks0 < n) {
80105962:	a1 e0 3d 11 80       	mov    0x80113de0,%eax
80105967:	83 c4 10             	add    $0x10,%esp
8010596a:	29 d8                	sub    %ebx,%eax
8010596c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010596f:	73 2f                	jae    801059a0 <sys_sleep+0x90>
        if(myproc()->killed) {
80105971:	e8 ba e0 ff ff       	call   80103a30 <myproc>
80105976:	8b 40 24             	mov    0x24(%eax),%eax
80105979:	85 c0                	test   %eax,%eax
8010597b:	74 d3                	je     80105950 <sys_sleep+0x40>
            release(&tickslock);
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	68 00 3e 11 80       	push   $0x80113e00
80105985:	e8 e6 ec ff ff       	call   80104670 <release>
    }
    release(&tickslock);
    return 0;
}
8010598a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return -1;
8010598d:	83 c4 10             	add    $0x10,%esp
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105995:	c9                   	leave
80105996:	c3                   	ret
80105997:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599e:	00 
8010599f:	90                   	nop
    release(&tickslock);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	68 00 3e 11 80       	push   $0x80113e00
801059a8:	e8 c3 ec ff ff       	call   80104670 <release>
    return 0;
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	31 c0                	xor    %eax,%eax
}
801059b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059b5:	c9                   	leave
801059b6:	c3                   	ret
        return -1;
801059b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059bc:	eb f4                	jmp    801059b2 <sys_sleep+0xa2>
801059be:	66 90                	xchg   %ax,%ax

801059c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	53                   	push   %ebx
801059c4:	83 ec 10             	sub    $0x10,%esp
    uint xticks;
    acquire(&tickslock);
801059c7:	68 00 3e 11 80       	push   $0x80113e00
801059cc:	e8 ff ec ff ff       	call   801046d0 <acquire>
    xticks = ticks;
801059d1:	8b 1d e0 3d 11 80    	mov    0x80113de0,%ebx
    release(&tickslock);
801059d7:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
801059de:	e8 8d ec ff ff       	call   80104670 <release>
    return xticks;
}
801059e3:	89 d8                	mov    %ebx,%eax
801059e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059e8:	c9                   	leave
801059e9:	c3                   	ret
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059f0 <sys_gethistory>:

// System call to get process history
int sys_gethistory(void) {
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
    struct history_entry *hist_buf;
    int max_entries;

    // Get arguments from user space
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
801059f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_gethistory(void) {
801059f8:	53                   	push   %ebx
801059f9:	83 ec 30             	sub    $0x30,%esp
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
801059fc:	6a 18                	push   $0x18
801059fe:	50                   	push   %eax
801059ff:	6a 00                	push   $0x0
80105a01:	e8 9a f0 ff ff       	call   80104aa0 <argptr>
80105a06:	83 c4 10             	add    $0x10,%esp
80105a09:	85 c0                	test   %eax,%eax
80105a0b:	0f 88 df 00 00 00    	js     80105af0 <sys_gethistory+0x100>
        argint(1, &max_entries) < 0) {
80105a11:	83 ec 08             	sub    $0x8,%esp
80105a14:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a17:	50                   	push   %eax
80105a18:	6a 01                	push   $0x1
80105a1a:	e8 31 f0 ff ff       	call   80104a50 <argint>
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105a1f:	83 c4 10             	add    $0x10,%esp
80105a22:	85 c0                	test   %eax,%eax
80105a24:	0f 88 c6 00 00 00    	js     80105af0 <sys_gethistory+0x100>
        return -1;  // Invalid arguments
    }

    acquire(&ptable.lock);
80105a2a:	83 ec 0c             	sub    $0xc,%esp
80105a2d:	68 20 1d 11 80       	push   $0x80111d20
80105a32:	e8 99 ec ff ff       	call   801046d0 <acquire>

    // Return only the most recent `max_entries` from history
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105a37:	a1 58 3c 11 80       	mov    0x80113c58,%eax
80105a3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105a3f:	39 d0                	cmp    %edx,%eax
80105a41:	89 d7                	mov    %edx,%edi
80105a43:	0f 4e f8             	cmovle %eax,%edi
    int start = (history_count < MAX_HISTORY) ? 0 : history_index;  // Start index
80105a46:	31 db                	xor    %ebx,%ebx
80105a48:	83 c4 10             	add    $0x10,%esp
80105a4b:	83 f8 09             	cmp    $0x9,%eax
80105a4e:	0f 4f 1d 54 3c 11 80 	cmovg  0x80113c54,%ebx
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105a55:	89 7d d0             	mov    %edi,-0x30(%ebp)

    for (int i = 0; i < copy_count; i++) {
80105a58:	85 ff                	test   %edi,%edi
80105a5a:	7e 79                	jle    80105ad5 <sys_gethistory+0xe5>
80105a5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
        int index = (start + i) % MAX_HISTORY;
        hist_buf[i].pid = process_history[index].pid;
80105a5f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105a62:	31 f6                	xor    %esi,%esi
80105a64:	01 d8                	add    %ebx,%eax
80105a66:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        int index = (start + i) % MAX_HISTORY;
80105a70:	b8 67 66 66 66       	mov    $0x66666667,%eax
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105a75:	83 ec 04             	sub    $0x4,%esp
        int index = (start + i) % MAX_HISTORY;
80105a78:	f7 eb                	imul   %ebx
80105a7a:	89 d8                	mov    %ebx,%eax
80105a7c:	c1 f8 1f             	sar    $0x1f,%eax
80105a7f:	c1 fa 02             	sar    $0x2,%edx
80105a82:	29 c2                	sub    %eax,%edx
80105a84:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105a87:	89 da                	mov    %ebx,%edx
    for (int i = 0; i < copy_count; i++) {
80105a89:	83 c3 01             	add    $0x1,%ebx
        int index = (start + i) % MAX_HISTORY;
80105a8c:	01 c0                	add    %eax,%eax
80105a8e:	29 c2                	sub    %eax,%edx
        hist_buf[i].pid = process_history[index].pid;
80105a90:	8d 14 52             	lea    (%edx,%edx,2),%edx
80105a93:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80105a9a:	8b 14 d5 60 3c 11 80 	mov    -0x7feec3a0(,%edx,8),%edx
80105aa1:	8d b8 60 3c 11 80    	lea    -0x7feec3a0(%eax),%edi
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105aa7:	05 64 3c 11 80       	add    $0x80113c64,%eax
        hist_buf[i].pid = process_history[index].pid;
80105aac:	89 14 31             	mov    %edx,(%ecx,%esi,1)
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105aaf:	6a 10                	push   $0x10
80105ab1:	50                   	push   %eax
80105ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ab5:	01 f0                	add    %esi,%eax
80105ab7:	83 c0 04             	add    $0x4,%eax
80105aba:	50                   	push   %eax
80105abb:	e8 90 ee ff ff       	call   80104950 <safestrcpy>
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105ac0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105ac3:	8b 47 14             	mov    0x14(%edi),%eax
    for (int i = 0; i < copy_count; i++) {
80105ac6:	83 c4 10             	add    $0x10,%esp
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105ac9:	89 44 31 14          	mov    %eax,0x14(%ecx,%esi,1)
    for (int i = 0; i < copy_count; i++) {
80105acd:	83 c6 18             	add    $0x18,%esi
80105ad0:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
80105ad3:	75 9b                	jne    80105a70 <sys_gethistory+0x80>
    }

    release(&ptable.lock);
80105ad5:	83 ec 0c             	sub    $0xc,%esp
80105ad8:	68 20 1d 11 80       	push   $0x80111d20
80105add:	e8 8e eb ff ff       	call   80104670 <release>
    return copy_count;  // Return number of processes copied
80105ae2:	83 c4 10             	add    $0x10,%esp
}
80105ae5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aeb:	5b                   	pop    %ebx
80105aec:	5e                   	pop    %esi
80105aed:	5f                   	pop    %edi
80105aee:	5d                   	pop    %ebp
80105aef:	c3                   	ret
        return -1;  // Invalid arguments
80105af0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
80105af7:	eb ec                	jmp    80105ae5 <sys_gethistory+0xf5>
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_block>:
//         return 0;
//     }

//     return -1;
// }
int sys_block(void) {
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 20             	sub    $0x20,%esp
    int syscall_id;
    if (argint(0, &syscall_id) < 0) 
80105b06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b09:	50                   	push   %eax
80105b0a:	6a 00                	push   $0x0
80105b0c:	e8 3f ef ff ff       	call   80104a50 <argint>
80105b11:	83 c4 10             	add    $0x10,%esp
80105b14:	85 c0                	test   %eax,%eax
80105b16:	78 28                	js     80105b40 <sys_block+0x40>
        return -1;
    
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1b:	83 f8 18             	cmp    $0x18,%eax
80105b1e:	77 20                	ja     80105b40 <sys_block+0x40>
        return -1;

    // Prevent blocking critical system calls
    if (syscall_id == SYS_fork || syscall_id == SYS_exit || syscall_id == SYS_unblock) {
80105b20:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b23:	83 fa 01             	cmp    $0x1,%edx
80105b26:	76 18                	jbe    80105b40 <sys_block+0x40>
80105b28:	83 f8 18             	cmp    $0x18,%eax
80105b2b:	74 13                	je     80105b40 <sys_block+0x40>
        return -1;
    }

    blocked_syscalls[syscall_id] = 1;  // Store in the kernel
80105b2d:	c7 04 85 60 3d 11 80 	movl   $0x1,-0x7feec2a0(,%eax,4)
80105b34:	01 00 00 00 
    return 0;
80105b38:	31 c0                	xor    %eax,%eax
}
80105b3a:	c9                   	leave
80105b3b:	c3                   	ret
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b40:	c9                   	leave
        return -1;
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b46:	c3                   	ret
80105b47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b4e:	00 
80105b4f:	90                   	nop

80105b50 <sys_unblock>:
//     }

//     release(&ptable.lock);
//     return 0;
// }
int sys_unblock(void) {
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 20             	sub    $0x20,%esp
    int syscall_id;

    // Get the syscall ID from arguments
    if (argint(0, &syscall_id) < 0) 
80105b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b59:	50                   	push   %eax
80105b5a:	6a 00                	push   $0x0
80105b5c:	e8 ef ee ff ff       	call   80104a50 <argint>
80105b61:	83 c4 10             	add    $0x10,%esp
80105b64:	85 c0                	test   %eax,%eax
80105b66:	78 18                	js     80105b80 <sys_unblock+0x30>
        return -1;

    // Validate syscall ID range
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6b:	83 f8 18             	cmp    $0x18,%eax
80105b6e:	77 10                	ja     80105b80 <sys_unblock+0x30>
        return -1;

    // Unblock the specified syscall
    blocked_syscalls[syscall_id] = 0;
80105b70:	c7 04 85 60 3d 11 80 	movl   $0x0,-0x7feec2a0(,%eax,4)
80105b77:	00 00 00 00 

    return 0;
80105b7b:	31 c0                	xor    %eax,%eax
}
80105b7d:	c9                   	leave
80105b7e:	c3                   	ret
80105b7f:	90                   	nop
80105b80:	c9                   	leave
        return -1;
80105b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b86:	c3                   	ret

80105b87 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b87:	1e                   	push   %ds
  pushl %es
80105b88:	06                   	push   %es
  pushl %fs
80105b89:	0f a0                	push   %fs
  pushl %gs
80105b8b:	0f a8                	push   %gs
  pushal
80105b8d:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b8e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b92:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b94:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b96:	54                   	push   %esp
  call trap
80105b97:	e8 c4 00 00 00       	call   80105c60 <trap>
  addl $4, %esp
80105b9c:	83 c4 04             	add    $0x4,%esp

80105b9f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b9f:	61                   	popa
  popl %gs
80105ba0:	0f a9                	pop    %gs
  popl %fs
80105ba2:	0f a1                	pop    %fs
  popl %es
80105ba4:	07                   	pop    %es
  popl %ds
80105ba5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ba6:	83 c4 08             	add    $0x8,%esp
  iret
80105ba9:	cf                   	iret
80105baa:	66 90                	xchg   %ax,%ax
80105bac:	66 90                	xchg   %ax,%ax
80105bae:	66 90                	xchg   %ax,%ax

80105bb0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bb0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bb1:	31 c0                	xor    %eax,%eax
{
80105bb3:	89 e5                	mov    %esp,%ebp
80105bb5:	83 ec 08             	sub    $0x8,%esp
80105bb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bbf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bc0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105bc7:	c7 04 c5 42 3e 11 80 	movl   $0x8e000008,-0x7feec1be(,%eax,8)
80105bce:	08 00 00 8e 
80105bd2:	66 89 14 c5 40 3e 11 	mov    %dx,-0x7feec1c0(,%eax,8)
80105bd9:	80 
80105bda:	c1 ea 10             	shr    $0x10,%edx
80105bdd:	66 89 14 c5 46 3e 11 	mov    %dx,-0x7feec1ba(,%eax,8)
80105be4:	80 
  for(i = 0; i < 256; i++)
80105be5:	83 c0 01             	add    $0x1,%eax
80105be8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bed:	75 d1                	jne    80105bc0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105bef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bf2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105bf7:	c7 05 42 40 11 80 08 	movl   $0xef000008,0x80114042
80105bfe:	00 00 ef 
  initlock(&tickslock, "time");
80105c01:	68 ed 78 10 80       	push   $0x801078ed
80105c06:	68 00 3e 11 80       	push   $0x80113e00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c0b:	66 a3 40 40 11 80    	mov    %ax,0x80114040
80105c11:	c1 e8 10             	shr    $0x10,%eax
80105c14:	66 a3 46 40 11 80    	mov    %ax,0x80114046
  initlock(&tickslock, "time");
80105c1a:	e8 e1 e8 ff ff       	call   80104500 <initlock>
}
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	c9                   	leave
80105c23:	c3                   	ret
80105c24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c2b:	00 
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c30 <idtinit>:

void
idtinit(void)
{
80105c30:	55                   	push   %ebp
  pd[0] = size-1;
80105c31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c36:	89 e5                	mov    %esp,%ebp
80105c38:	83 ec 10             	sub    $0x10,%esp
80105c3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c3f:	b8 40 3e 11 80       	mov    $0x80113e40,%eax
80105c44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c48:	c1 e8 10             	shr    $0x10,%eax
80105c4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c55:	c9                   	leave
80105c56:	c3                   	ret
80105c57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c5e:	00 
80105c5f:	90                   	nop

80105c60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
80105c66:	83 ec 1c             	sub    $0x1c,%esp
80105c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c6f:	83 f8 40             	cmp    $0x40,%eax
80105c72:	0f 84 68 01 00 00    	je     80105de0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c78:	83 e8 20             	sub    $0x20,%eax
80105c7b:	83 f8 1f             	cmp    $0x1f,%eax
80105c7e:	0f 87 8c 00 00 00    	ja     80105d10 <trap+0xb0>
80105c84:	ff 24 85 64 7e 10 80 	jmp    *-0x7fef819c(,%eax,4)
80105c8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c90:	e8 ab c5 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105c95:	e8 76 cc ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c9a:	e8 91 dd ff ff       	call   80103a30 <myproc>
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	74 1d                	je     80105cc0 <trap+0x60>
80105ca3:	e8 88 dd ff ff       	call   80103a30 <myproc>
80105ca8:	8b 50 24             	mov    0x24(%eax),%edx
80105cab:	85 d2                	test   %edx,%edx
80105cad:	74 11                	je     80105cc0 <trap+0x60>
80105caf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cb3:	83 e0 03             	and    $0x3,%eax
80105cb6:	66 83 f8 03          	cmp    $0x3,%ax
80105cba:	0f 84 e8 01 00 00    	je     80105ea8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105cc0:	e8 6b dd ff ff       	call   80103a30 <myproc>
80105cc5:	85 c0                	test   %eax,%eax
80105cc7:	74 0f                	je     80105cd8 <trap+0x78>
80105cc9:	e8 62 dd ff ff       	call   80103a30 <myproc>
80105cce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cd2:	0f 84 b8 00 00 00    	je     80105d90 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cd8:	e8 53 dd ff ff       	call   80103a30 <myproc>
80105cdd:	85 c0                	test   %eax,%eax
80105cdf:	74 1d                	je     80105cfe <trap+0x9e>
80105ce1:	e8 4a dd ff ff       	call   80103a30 <myproc>
80105ce6:	8b 40 24             	mov    0x24(%eax),%eax
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	74 11                	je     80105cfe <trap+0x9e>
80105ced:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cf1:	83 e0 03             	and    $0x3,%eax
80105cf4:	66 83 f8 03          	cmp    $0x3,%ax
80105cf8:	0f 84 0f 01 00 00    	je     80105e0d <trap+0x1ad>
    exit();
}
80105cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d01:	5b                   	pop    %ebx
80105d02:	5e                   	pop    %esi
80105d03:	5f                   	pop    %edi
80105d04:	5d                   	pop    %ebp
80105d05:	c3                   	ret
80105d06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d0d:	00 
80105d0e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d10:	e8 1b dd ff ff       	call   80103a30 <myproc>
80105d15:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d18:	85 c0                	test   %eax,%eax
80105d1a:	0f 84 a2 01 00 00    	je     80105ec2 <trap+0x262>
80105d20:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d24:	0f 84 98 01 00 00    	je     80105ec2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d2a:	0f 20 d1             	mov    %cr2,%ecx
80105d2d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d30:	e8 db dc ff ff       	call   80103a10 <cpuid>
80105d35:	8b 73 30             	mov    0x30(%ebx),%esi
80105d38:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d3b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d41:	e8 ea dc ff ff       	call   80103a30 <myproc>
80105d46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d49:	e8 e2 dc ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d4e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d51:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d54:	51                   	push   %ecx
80105d55:	57                   	push   %edi
80105d56:	52                   	push   %edx
80105d57:	ff 75 e4             	push   -0x1c(%ebp)
80105d5a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d5b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d5e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d61:	56                   	push   %esi
80105d62:	ff 70 10             	push   0x10(%eax)
80105d65:	68 3c 7b 10 80       	push   $0x80107b3c
80105d6a:	e8 31 a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105d6f:	83 c4 20             	add    $0x20,%esp
80105d72:	e8 b9 dc ff ff       	call   80103a30 <myproc>
80105d77:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d7e:	e8 ad dc ff ff       	call   80103a30 <myproc>
80105d83:	85 c0                	test   %eax,%eax
80105d85:	0f 85 18 ff ff ff    	jne    80105ca3 <trap+0x43>
80105d8b:	e9 30 ff ff ff       	jmp    80105cc0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105d90:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d94:	0f 85 3e ff ff ff    	jne    80105cd8 <trap+0x78>
    yield();
80105d9a:	e8 81 e3 ff ff       	call   80104120 <yield>
80105d9f:	e9 34 ff ff ff       	jmp    80105cd8 <trap+0x78>
80105da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105da8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105daf:	e8 5c dc ff ff       	call   80103a10 <cpuid>
80105db4:	57                   	push   %edi
80105db5:	56                   	push   %esi
80105db6:	50                   	push   %eax
80105db7:	68 e4 7a 10 80       	push   $0x80107ae4
80105dbc:	e8 df a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105dc1:	e8 4a cb ff ff       	call   80102910 <lapiceoi>
    break;
80105dc6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dc9:	e8 62 dc ff ff       	call   80103a30 <myproc>
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	0f 85 cd fe ff ff    	jne    80105ca3 <trap+0x43>
80105dd6:	e9 e5 fe ff ff       	jmp    80105cc0 <trap+0x60>
80105ddb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105de0:	e8 4b dc ff ff       	call   80103a30 <myproc>
80105de5:	8b 70 24             	mov    0x24(%eax),%esi
80105de8:	85 f6                	test   %esi,%esi
80105dea:	0f 85 c8 00 00 00    	jne    80105eb8 <trap+0x258>
    myproc()->tf = tf;
80105df0:	e8 3b dc ff ff       	call   80103a30 <myproc>
80105df5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105df8:	e8 f3 ed ff ff       	call   80104bf0 <syscall>
    if(myproc()->killed)
80105dfd:	e8 2e dc ff ff       	call   80103a30 <myproc>
80105e02:	8b 48 24             	mov    0x24(%eax),%ecx
80105e05:	85 c9                	test   %ecx,%ecx
80105e07:	0f 84 f1 fe ff ff    	je     80105cfe <trap+0x9e>
}
80105e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e10:	5b                   	pop    %ebx
80105e11:	5e                   	pop    %esi
80105e12:	5f                   	pop    %edi
80105e13:	5d                   	pop    %ebp
      exit();
80105e14:	e9 37 e0 ff ff       	jmp    80103e50 <exit>
80105e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e20:	e8 3b 02 00 00       	call   80106060 <uartintr>
    lapiceoi();
80105e25:	e8 e6 ca ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e2a:	e8 01 dc ff ff       	call   80103a30 <myproc>
80105e2f:	85 c0                	test   %eax,%eax
80105e31:	0f 85 6c fe ff ff    	jne    80105ca3 <trap+0x43>
80105e37:	e9 84 fe ff ff       	jmp    80105cc0 <trap+0x60>
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e40:	e8 8b c9 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80105e45:	e8 c6 ca ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e4a:	e8 e1 db ff ff       	call   80103a30 <myproc>
80105e4f:	85 c0                	test   %eax,%eax
80105e51:	0f 85 4c fe ff ff    	jne    80105ca3 <trap+0x43>
80105e57:	e9 64 fe ff ff       	jmp    80105cc0 <trap+0x60>
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105e60:	e8 ab db ff ff       	call   80103a10 <cpuid>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	0f 85 28 fe ff ff    	jne    80105c95 <trap+0x35>
      acquire(&tickslock);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	68 00 3e 11 80       	push   $0x80113e00
80105e75:	e8 56 e8 ff ff       	call   801046d0 <acquire>
      wakeup(&ticks);
80105e7a:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
      ticks++;
80105e81:	83 05 e0 3d 11 80 01 	addl   $0x1,0x80113de0
      wakeup(&ticks);
80105e88:	e8 a3 e3 ff ff       	call   80104230 <wakeup>
      release(&tickslock);
80105e8d:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80105e94:	e8 d7 e7 ff ff       	call   80104670 <release>
80105e99:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e9c:	e9 f4 fd ff ff       	jmp    80105c95 <trap+0x35>
80105ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105ea8:	e8 a3 df ff ff       	call   80103e50 <exit>
80105ead:	e9 0e fe ff ff       	jmp    80105cc0 <trap+0x60>
80105eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105eb8:	e8 93 df ff ff       	call   80103e50 <exit>
80105ebd:	e9 2e ff ff ff       	jmp    80105df0 <trap+0x190>
80105ec2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ec5:	e8 46 db ff ff       	call   80103a10 <cpuid>
80105eca:	83 ec 0c             	sub    $0xc,%esp
80105ecd:	56                   	push   %esi
80105ece:	57                   	push   %edi
80105ecf:	50                   	push   %eax
80105ed0:	ff 73 30             	push   0x30(%ebx)
80105ed3:	68 08 7b 10 80       	push   $0x80107b08
80105ed8:	e8 c3 a7 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105edd:	83 c4 14             	add    $0x14,%esp
80105ee0:	68 f2 78 10 80       	push   $0x801078f2
80105ee5:	e8 96 a4 ff ff       	call   80100380 <panic>
80105eea:	66 90                	xchg   %ax,%ax
80105eec:	66 90                	xchg   %ax,%ax
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ef0:	a1 40 46 11 80       	mov    0x80114640,%eax
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	74 17                	je     80105f10 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ef9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105efe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105eff:	a8 01                	test   $0x1,%al
80105f01:	74 0d                	je     80105f10 <uartgetc+0x20>
80105f03:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f08:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f09:	0f b6 c0             	movzbl %al,%eax
80105f0c:	c3                   	ret
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f15:	c3                   	ret
80105f16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f1d:	00 
80105f1e:	66 90                	xchg   %ax,%ax

80105f20 <uartinit>:
{
80105f20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f21:	31 c9                	xor    %ecx,%ecx
80105f23:	89 c8                	mov    %ecx,%eax
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	57                   	push   %edi
80105f28:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f2d:	56                   	push   %esi
80105f2e:	89 fa                	mov    %edi,%edx
80105f30:	53                   	push   %ebx
80105f31:	83 ec 1c             	sub    $0x1c,%esp
80105f34:	ee                   	out    %al,(%dx)
80105f35:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f3f:	89 f2                	mov    %esi,%edx
80105f41:	ee                   	out    %al,(%dx)
80105f42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f4c:	ee                   	out    %al,(%dx)
80105f4d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f52:	89 c8                	mov    %ecx,%eax
80105f54:	89 da                	mov    %ebx,%edx
80105f56:	ee                   	out    %al,(%dx)
80105f57:	b8 03 00 00 00       	mov    $0x3,%eax
80105f5c:	89 f2                	mov    %esi,%edx
80105f5e:	ee                   	out    %al,(%dx)
80105f5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f64:	89 c8                	mov    %ecx,%eax
80105f66:	ee                   	out    %al,(%dx)
80105f67:	b8 01 00 00 00       	mov    $0x1,%eax
80105f6c:	89 da                	mov    %ebx,%edx
80105f6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f74:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f75:	3c ff                	cmp    $0xff,%al
80105f77:	74 78                	je     80105ff1 <uartinit+0xd1>
  uart = 1;
80105f79:	c7 05 40 46 11 80 01 	movl   $0x1,0x80114640
80105f80:	00 00 00 
80105f83:	89 fa                	mov    %edi,%edx
80105f85:	ec                   	in     (%dx),%al
80105f86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f8b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f8c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f8f:	bf f7 78 10 80       	mov    $0x801078f7,%edi
80105f94:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f99:	6a 00                	push   $0x0
80105f9b:	6a 04                	push   $0x4
80105f9d:	e8 de c4 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105fa2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105fa6:	83 c4 10             	add    $0x10,%esp
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105fb0:	a1 40 46 11 80       	mov    0x80114640,%eax
80105fb5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fba:	85 c0                	test   %eax,%eax
80105fbc:	75 14                	jne    80105fd2 <uartinit+0xb2>
80105fbe:	eb 23                	jmp    80105fe3 <uartinit+0xc3>
    microdelay(10);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	6a 0a                	push   $0xa
80105fc5:	e8 66 c9 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	83 eb 01             	sub    $0x1,%ebx
80105fd0:	74 07                	je     80105fd9 <uartinit+0xb9>
80105fd2:	89 f2                	mov    %esi,%edx
80105fd4:	ec                   	in     (%dx),%al
80105fd5:	a8 20                	test   $0x20,%al
80105fd7:	74 e7                	je     80105fc0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fd9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105fdd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fe2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105fe3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105fe7:	83 c7 01             	add    $0x1,%edi
80105fea:	88 45 e7             	mov    %al,-0x19(%ebp)
80105fed:	84 c0                	test   %al,%al
80105fef:	75 bf                	jne    80105fb0 <uartinit+0x90>
}
80105ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff4:	5b                   	pop    %ebx
80105ff5:	5e                   	pop    %esi
80105ff6:	5f                   	pop    %edi
80105ff7:	5d                   	pop    %ebp
80105ff8:	c3                   	ret
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106000 <uartputc>:
  if(!uart)
80106000:	a1 40 46 11 80       	mov    0x80114640,%eax
80106005:	85 c0                	test   %eax,%eax
80106007:	74 47                	je     80106050 <uartputc+0x50>
{
80106009:	55                   	push   %ebp
8010600a:	89 e5                	mov    %esp,%ebp
8010600c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010600d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106012:	53                   	push   %ebx
80106013:	bb 80 00 00 00       	mov    $0x80,%ebx
80106018:	eb 18                	jmp    80106032 <uartputc+0x32>
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	6a 0a                	push   $0xa
80106025:	e8 06 c9 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	83 eb 01             	sub    $0x1,%ebx
80106030:	74 07                	je     80106039 <uartputc+0x39>
80106032:	89 f2                	mov    %esi,%edx
80106034:	ec                   	in     (%dx),%al
80106035:	a8 20                	test   $0x20,%al
80106037:	74 e7                	je     80106020 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106039:	8b 45 08             	mov    0x8(%ebp),%eax
8010603c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106041:	ee                   	out    %al,(%dx)
}
80106042:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106045:	5b                   	pop    %ebx
80106046:	5e                   	pop    %esi
80106047:	5d                   	pop    %ebp
80106048:	c3                   	ret
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106050:	c3                   	ret
80106051:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106058:	00 
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106060 <uartintr>:

void
uartintr(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106066:	68 f0 5e 10 80       	push   $0x80105ef0
8010606b:	e8 10 a8 ff ff       	call   80100880 <consoleintr>
}
80106070:	83 c4 10             	add    $0x10,%esp
80106073:	c9                   	leave
80106074:	c3                   	ret

80106075 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $0
80106077:	6a 00                	push   $0x0
  jmp alltraps
80106079:	e9 09 fb ff ff       	jmp    80105b87 <alltraps>

8010607e <vector1>:
.globl vector1
vector1:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $1
80106080:	6a 01                	push   $0x1
  jmp alltraps
80106082:	e9 00 fb ff ff       	jmp    80105b87 <alltraps>

80106087 <vector2>:
.globl vector2
vector2:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $2
80106089:	6a 02                	push   $0x2
  jmp alltraps
8010608b:	e9 f7 fa ff ff       	jmp    80105b87 <alltraps>

80106090 <vector3>:
.globl vector3
vector3:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $3
80106092:	6a 03                	push   $0x3
  jmp alltraps
80106094:	e9 ee fa ff ff       	jmp    80105b87 <alltraps>

80106099 <vector4>:
.globl vector4
vector4:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $4
8010609b:	6a 04                	push   $0x4
  jmp alltraps
8010609d:	e9 e5 fa ff ff       	jmp    80105b87 <alltraps>

801060a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $5
801060a4:	6a 05                	push   $0x5
  jmp alltraps
801060a6:	e9 dc fa ff ff       	jmp    80105b87 <alltraps>

801060ab <vector6>:
.globl vector6
vector6:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $6
801060ad:	6a 06                	push   $0x6
  jmp alltraps
801060af:	e9 d3 fa ff ff       	jmp    80105b87 <alltraps>

801060b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $7
801060b6:	6a 07                	push   $0x7
  jmp alltraps
801060b8:	e9 ca fa ff ff       	jmp    80105b87 <alltraps>

801060bd <vector8>:
.globl vector8
vector8:
  pushl $8
801060bd:	6a 08                	push   $0x8
  jmp alltraps
801060bf:	e9 c3 fa ff ff       	jmp    80105b87 <alltraps>

801060c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $9
801060c6:	6a 09                	push   $0x9
  jmp alltraps
801060c8:	e9 ba fa ff ff       	jmp    80105b87 <alltraps>

801060cd <vector10>:
.globl vector10
vector10:
  pushl $10
801060cd:	6a 0a                	push   $0xa
  jmp alltraps
801060cf:	e9 b3 fa ff ff       	jmp    80105b87 <alltraps>

801060d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060d4:	6a 0b                	push   $0xb
  jmp alltraps
801060d6:	e9 ac fa ff ff       	jmp    80105b87 <alltraps>

801060db <vector12>:
.globl vector12
vector12:
  pushl $12
801060db:	6a 0c                	push   $0xc
  jmp alltraps
801060dd:	e9 a5 fa ff ff       	jmp    80105b87 <alltraps>

801060e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060e2:	6a 0d                	push   $0xd
  jmp alltraps
801060e4:	e9 9e fa ff ff       	jmp    80105b87 <alltraps>

801060e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060e9:	6a 0e                	push   $0xe
  jmp alltraps
801060eb:	e9 97 fa ff ff       	jmp    80105b87 <alltraps>

801060f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $15
801060f2:	6a 0f                	push   $0xf
  jmp alltraps
801060f4:	e9 8e fa ff ff       	jmp    80105b87 <alltraps>

801060f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $16
801060fb:	6a 10                	push   $0x10
  jmp alltraps
801060fd:	e9 85 fa ff ff       	jmp    80105b87 <alltraps>

80106102 <vector17>:
.globl vector17
vector17:
  pushl $17
80106102:	6a 11                	push   $0x11
  jmp alltraps
80106104:	e9 7e fa ff ff       	jmp    80105b87 <alltraps>

80106109 <vector18>:
.globl vector18
vector18:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $18
8010610b:	6a 12                	push   $0x12
  jmp alltraps
8010610d:	e9 75 fa ff ff       	jmp    80105b87 <alltraps>

80106112 <vector19>:
.globl vector19
vector19:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $19
80106114:	6a 13                	push   $0x13
  jmp alltraps
80106116:	e9 6c fa ff ff       	jmp    80105b87 <alltraps>

8010611b <vector20>:
.globl vector20
vector20:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $20
8010611d:	6a 14                	push   $0x14
  jmp alltraps
8010611f:	e9 63 fa ff ff       	jmp    80105b87 <alltraps>

80106124 <vector21>:
.globl vector21
vector21:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $21
80106126:	6a 15                	push   $0x15
  jmp alltraps
80106128:	e9 5a fa ff ff       	jmp    80105b87 <alltraps>

8010612d <vector22>:
.globl vector22
vector22:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $22
8010612f:	6a 16                	push   $0x16
  jmp alltraps
80106131:	e9 51 fa ff ff       	jmp    80105b87 <alltraps>

80106136 <vector23>:
.globl vector23
vector23:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $23
80106138:	6a 17                	push   $0x17
  jmp alltraps
8010613a:	e9 48 fa ff ff       	jmp    80105b87 <alltraps>

8010613f <vector24>:
.globl vector24
vector24:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $24
80106141:	6a 18                	push   $0x18
  jmp alltraps
80106143:	e9 3f fa ff ff       	jmp    80105b87 <alltraps>

80106148 <vector25>:
.globl vector25
vector25:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $25
8010614a:	6a 19                	push   $0x19
  jmp alltraps
8010614c:	e9 36 fa ff ff       	jmp    80105b87 <alltraps>

80106151 <vector26>:
.globl vector26
vector26:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $26
80106153:	6a 1a                	push   $0x1a
  jmp alltraps
80106155:	e9 2d fa ff ff       	jmp    80105b87 <alltraps>

8010615a <vector27>:
.globl vector27
vector27:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $27
8010615c:	6a 1b                	push   $0x1b
  jmp alltraps
8010615e:	e9 24 fa ff ff       	jmp    80105b87 <alltraps>

80106163 <vector28>:
.globl vector28
vector28:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $28
80106165:	6a 1c                	push   $0x1c
  jmp alltraps
80106167:	e9 1b fa ff ff       	jmp    80105b87 <alltraps>

8010616c <vector29>:
.globl vector29
vector29:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $29
8010616e:	6a 1d                	push   $0x1d
  jmp alltraps
80106170:	e9 12 fa ff ff       	jmp    80105b87 <alltraps>

80106175 <vector30>:
.globl vector30
vector30:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $30
80106177:	6a 1e                	push   $0x1e
  jmp alltraps
80106179:	e9 09 fa ff ff       	jmp    80105b87 <alltraps>

8010617e <vector31>:
.globl vector31
vector31:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $31
80106180:	6a 1f                	push   $0x1f
  jmp alltraps
80106182:	e9 00 fa ff ff       	jmp    80105b87 <alltraps>

80106187 <vector32>:
.globl vector32
vector32:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $32
80106189:	6a 20                	push   $0x20
  jmp alltraps
8010618b:	e9 f7 f9 ff ff       	jmp    80105b87 <alltraps>

80106190 <vector33>:
.globl vector33
vector33:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $33
80106192:	6a 21                	push   $0x21
  jmp alltraps
80106194:	e9 ee f9 ff ff       	jmp    80105b87 <alltraps>

80106199 <vector34>:
.globl vector34
vector34:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $34
8010619b:	6a 22                	push   $0x22
  jmp alltraps
8010619d:	e9 e5 f9 ff ff       	jmp    80105b87 <alltraps>

801061a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $35
801061a4:	6a 23                	push   $0x23
  jmp alltraps
801061a6:	e9 dc f9 ff ff       	jmp    80105b87 <alltraps>

801061ab <vector36>:
.globl vector36
vector36:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $36
801061ad:	6a 24                	push   $0x24
  jmp alltraps
801061af:	e9 d3 f9 ff ff       	jmp    80105b87 <alltraps>

801061b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $37
801061b6:	6a 25                	push   $0x25
  jmp alltraps
801061b8:	e9 ca f9 ff ff       	jmp    80105b87 <alltraps>

801061bd <vector38>:
.globl vector38
vector38:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $38
801061bf:	6a 26                	push   $0x26
  jmp alltraps
801061c1:	e9 c1 f9 ff ff       	jmp    80105b87 <alltraps>

801061c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $39
801061c8:	6a 27                	push   $0x27
  jmp alltraps
801061ca:	e9 b8 f9 ff ff       	jmp    80105b87 <alltraps>

801061cf <vector40>:
.globl vector40
vector40:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $40
801061d1:	6a 28                	push   $0x28
  jmp alltraps
801061d3:	e9 af f9 ff ff       	jmp    80105b87 <alltraps>

801061d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $41
801061da:	6a 29                	push   $0x29
  jmp alltraps
801061dc:	e9 a6 f9 ff ff       	jmp    80105b87 <alltraps>

801061e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $42
801061e3:	6a 2a                	push   $0x2a
  jmp alltraps
801061e5:	e9 9d f9 ff ff       	jmp    80105b87 <alltraps>

801061ea <vector43>:
.globl vector43
vector43:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $43
801061ec:	6a 2b                	push   $0x2b
  jmp alltraps
801061ee:	e9 94 f9 ff ff       	jmp    80105b87 <alltraps>

801061f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $44
801061f5:	6a 2c                	push   $0x2c
  jmp alltraps
801061f7:	e9 8b f9 ff ff       	jmp    80105b87 <alltraps>

801061fc <vector45>:
.globl vector45
vector45:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $45
801061fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106200:	e9 82 f9 ff ff       	jmp    80105b87 <alltraps>

80106205 <vector46>:
.globl vector46
vector46:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $46
80106207:	6a 2e                	push   $0x2e
  jmp alltraps
80106209:	e9 79 f9 ff ff       	jmp    80105b87 <alltraps>

8010620e <vector47>:
.globl vector47
vector47:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $47
80106210:	6a 2f                	push   $0x2f
  jmp alltraps
80106212:	e9 70 f9 ff ff       	jmp    80105b87 <alltraps>

80106217 <vector48>:
.globl vector48
vector48:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $48
80106219:	6a 30                	push   $0x30
  jmp alltraps
8010621b:	e9 67 f9 ff ff       	jmp    80105b87 <alltraps>

80106220 <vector49>:
.globl vector49
vector49:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $49
80106222:	6a 31                	push   $0x31
  jmp alltraps
80106224:	e9 5e f9 ff ff       	jmp    80105b87 <alltraps>

80106229 <vector50>:
.globl vector50
vector50:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $50
8010622b:	6a 32                	push   $0x32
  jmp alltraps
8010622d:	e9 55 f9 ff ff       	jmp    80105b87 <alltraps>

80106232 <vector51>:
.globl vector51
vector51:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $51
80106234:	6a 33                	push   $0x33
  jmp alltraps
80106236:	e9 4c f9 ff ff       	jmp    80105b87 <alltraps>

8010623b <vector52>:
.globl vector52
vector52:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $52
8010623d:	6a 34                	push   $0x34
  jmp alltraps
8010623f:	e9 43 f9 ff ff       	jmp    80105b87 <alltraps>

80106244 <vector53>:
.globl vector53
vector53:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $53
80106246:	6a 35                	push   $0x35
  jmp alltraps
80106248:	e9 3a f9 ff ff       	jmp    80105b87 <alltraps>

8010624d <vector54>:
.globl vector54
vector54:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $54
8010624f:	6a 36                	push   $0x36
  jmp alltraps
80106251:	e9 31 f9 ff ff       	jmp    80105b87 <alltraps>

80106256 <vector55>:
.globl vector55
vector55:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $55
80106258:	6a 37                	push   $0x37
  jmp alltraps
8010625a:	e9 28 f9 ff ff       	jmp    80105b87 <alltraps>

8010625f <vector56>:
.globl vector56
vector56:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $56
80106261:	6a 38                	push   $0x38
  jmp alltraps
80106263:	e9 1f f9 ff ff       	jmp    80105b87 <alltraps>

80106268 <vector57>:
.globl vector57
vector57:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $57
8010626a:	6a 39                	push   $0x39
  jmp alltraps
8010626c:	e9 16 f9 ff ff       	jmp    80105b87 <alltraps>

80106271 <vector58>:
.globl vector58
vector58:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $58
80106273:	6a 3a                	push   $0x3a
  jmp alltraps
80106275:	e9 0d f9 ff ff       	jmp    80105b87 <alltraps>

8010627a <vector59>:
.globl vector59
vector59:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $59
8010627c:	6a 3b                	push   $0x3b
  jmp alltraps
8010627e:	e9 04 f9 ff ff       	jmp    80105b87 <alltraps>

80106283 <vector60>:
.globl vector60
vector60:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $60
80106285:	6a 3c                	push   $0x3c
  jmp alltraps
80106287:	e9 fb f8 ff ff       	jmp    80105b87 <alltraps>

8010628c <vector61>:
.globl vector61
vector61:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $61
8010628e:	6a 3d                	push   $0x3d
  jmp alltraps
80106290:	e9 f2 f8 ff ff       	jmp    80105b87 <alltraps>

80106295 <vector62>:
.globl vector62
vector62:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $62
80106297:	6a 3e                	push   $0x3e
  jmp alltraps
80106299:	e9 e9 f8 ff ff       	jmp    80105b87 <alltraps>

8010629e <vector63>:
.globl vector63
vector63:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $63
801062a0:	6a 3f                	push   $0x3f
  jmp alltraps
801062a2:	e9 e0 f8 ff ff       	jmp    80105b87 <alltraps>

801062a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $64
801062a9:	6a 40                	push   $0x40
  jmp alltraps
801062ab:	e9 d7 f8 ff ff       	jmp    80105b87 <alltraps>

801062b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $65
801062b2:	6a 41                	push   $0x41
  jmp alltraps
801062b4:	e9 ce f8 ff ff       	jmp    80105b87 <alltraps>

801062b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $66
801062bb:	6a 42                	push   $0x42
  jmp alltraps
801062bd:	e9 c5 f8 ff ff       	jmp    80105b87 <alltraps>

801062c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $67
801062c4:	6a 43                	push   $0x43
  jmp alltraps
801062c6:	e9 bc f8 ff ff       	jmp    80105b87 <alltraps>

801062cb <vector68>:
.globl vector68
vector68:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $68
801062cd:	6a 44                	push   $0x44
  jmp alltraps
801062cf:	e9 b3 f8 ff ff       	jmp    80105b87 <alltraps>

801062d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $69
801062d6:	6a 45                	push   $0x45
  jmp alltraps
801062d8:	e9 aa f8 ff ff       	jmp    80105b87 <alltraps>

801062dd <vector70>:
.globl vector70
vector70:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $70
801062df:	6a 46                	push   $0x46
  jmp alltraps
801062e1:	e9 a1 f8 ff ff       	jmp    80105b87 <alltraps>

801062e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $71
801062e8:	6a 47                	push   $0x47
  jmp alltraps
801062ea:	e9 98 f8 ff ff       	jmp    80105b87 <alltraps>

801062ef <vector72>:
.globl vector72
vector72:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $72
801062f1:	6a 48                	push   $0x48
  jmp alltraps
801062f3:	e9 8f f8 ff ff       	jmp    80105b87 <alltraps>

801062f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $73
801062fa:	6a 49                	push   $0x49
  jmp alltraps
801062fc:	e9 86 f8 ff ff       	jmp    80105b87 <alltraps>

80106301 <vector74>:
.globl vector74
vector74:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $74
80106303:	6a 4a                	push   $0x4a
  jmp alltraps
80106305:	e9 7d f8 ff ff       	jmp    80105b87 <alltraps>

8010630a <vector75>:
.globl vector75
vector75:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $75
8010630c:	6a 4b                	push   $0x4b
  jmp alltraps
8010630e:	e9 74 f8 ff ff       	jmp    80105b87 <alltraps>

80106313 <vector76>:
.globl vector76
vector76:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $76
80106315:	6a 4c                	push   $0x4c
  jmp alltraps
80106317:	e9 6b f8 ff ff       	jmp    80105b87 <alltraps>

8010631c <vector77>:
.globl vector77
vector77:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $77
8010631e:	6a 4d                	push   $0x4d
  jmp alltraps
80106320:	e9 62 f8 ff ff       	jmp    80105b87 <alltraps>

80106325 <vector78>:
.globl vector78
vector78:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $78
80106327:	6a 4e                	push   $0x4e
  jmp alltraps
80106329:	e9 59 f8 ff ff       	jmp    80105b87 <alltraps>

8010632e <vector79>:
.globl vector79
vector79:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $79
80106330:	6a 4f                	push   $0x4f
  jmp alltraps
80106332:	e9 50 f8 ff ff       	jmp    80105b87 <alltraps>

80106337 <vector80>:
.globl vector80
vector80:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $80
80106339:	6a 50                	push   $0x50
  jmp alltraps
8010633b:	e9 47 f8 ff ff       	jmp    80105b87 <alltraps>

80106340 <vector81>:
.globl vector81
vector81:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $81
80106342:	6a 51                	push   $0x51
  jmp alltraps
80106344:	e9 3e f8 ff ff       	jmp    80105b87 <alltraps>

80106349 <vector82>:
.globl vector82
vector82:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $82
8010634b:	6a 52                	push   $0x52
  jmp alltraps
8010634d:	e9 35 f8 ff ff       	jmp    80105b87 <alltraps>

80106352 <vector83>:
.globl vector83
vector83:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $83
80106354:	6a 53                	push   $0x53
  jmp alltraps
80106356:	e9 2c f8 ff ff       	jmp    80105b87 <alltraps>

8010635b <vector84>:
.globl vector84
vector84:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $84
8010635d:	6a 54                	push   $0x54
  jmp alltraps
8010635f:	e9 23 f8 ff ff       	jmp    80105b87 <alltraps>

80106364 <vector85>:
.globl vector85
vector85:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $85
80106366:	6a 55                	push   $0x55
  jmp alltraps
80106368:	e9 1a f8 ff ff       	jmp    80105b87 <alltraps>

8010636d <vector86>:
.globl vector86
vector86:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $86
8010636f:	6a 56                	push   $0x56
  jmp alltraps
80106371:	e9 11 f8 ff ff       	jmp    80105b87 <alltraps>

80106376 <vector87>:
.globl vector87
vector87:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $87
80106378:	6a 57                	push   $0x57
  jmp alltraps
8010637a:	e9 08 f8 ff ff       	jmp    80105b87 <alltraps>

8010637f <vector88>:
.globl vector88
vector88:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $88
80106381:	6a 58                	push   $0x58
  jmp alltraps
80106383:	e9 ff f7 ff ff       	jmp    80105b87 <alltraps>

80106388 <vector89>:
.globl vector89
vector89:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $89
8010638a:	6a 59                	push   $0x59
  jmp alltraps
8010638c:	e9 f6 f7 ff ff       	jmp    80105b87 <alltraps>

80106391 <vector90>:
.globl vector90
vector90:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $90
80106393:	6a 5a                	push   $0x5a
  jmp alltraps
80106395:	e9 ed f7 ff ff       	jmp    80105b87 <alltraps>

8010639a <vector91>:
.globl vector91
vector91:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $91
8010639c:	6a 5b                	push   $0x5b
  jmp alltraps
8010639e:	e9 e4 f7 ff ff       	jmp    80105b87 <alltraps>

801063a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $92
801063a5:	6a 5c                	push   $0x5c
  jmp alltraps
801063a7:	e9 db f7 ff ff       	jmp    80105b87 <alltraps>

801063ac <vector93>:
.globl vector93
vector93:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $93
801063ae:	6a 5d                	push   $0x5d
  jmp alltraps
801063b0:	e9 d2 f7 ff ff       	jmp    80105b87 <alltraps>

801063b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $94
801063b7:	6a 5e                	push   $0x5e
  jmp alltraps
801063b9:	e9 c9 f7 ff ff       	jmp    80105b87 <alltraps>

801063be <vector95>:
.globl vector95
vector95:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $95
801063c0:	6a 5f                	push   $0x5f
  jmp alltraps
801063c2:	e9 c0 f7 ff ff       	jmp    80105b87 <alltraps>

801063c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $96
801063c9:	6a 60                	push   $0x60
  jmp alltraps
801063cb:	e9 b7 f7 ff ff       	jmp    80105b87 <alltraps>

801063d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $97
801063d2:	6a 61                	push   $0x61
  jmp alltraps
801063d4:	e9 ae f7 ff ff       	jmp    80105b87 <alltraps>

801063d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $98
801063db:	6a 62                	push   $0x62
  jmp alltraps
801063dd:	e9 a5 f7 ff ff       	jmp    80105b87 <alltraps>

801063e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $99
801063e4:	6a 63                	push   $0x63
  jmp alltraps
801063e6:	e9 9c f7 ff ff       	jmp    80105b87 <alltraps>

801063eb <vector100>:
.globl vector100
vector100:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $100
801063ed:	6a 64                	push   $0x64
  jmp alltraps
801063ef:	e9 93 f7 ff ff       	jmp    80105b87 <alltraps>

801063f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $101
801063f6:	6a 65                	push   $0x65
  jmp alltraps
801063f8:	e9 8a f7 ff ff       	jmp    80105b87 <alltraps>

801063fd <vector102>:
.globl vector102
vector102:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $102
801063ff:	6a 66                	push   $0x66
  jmp alltraps
80106401:	e9 81 f7 ff ff       	jmp    80105b87 <alltraps>

80106406 <vector103>:
.globl vector103
vector103:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $103
80106408:	6a 67                	push   $0x67
  jmp alltraps
8010640a:	e9 78 f7 ff ff       	jmp    80105b87 <alltraps>

8010640f <vector104>:
.globl vector104
vector104:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $104
80106411:	6a 68                	push   $0x68
  jmp alltraps
80106413:	e9 6f f7 ff ff       	jmp    80105b87 <alltraps>

80106418 <vector105>:
.globl vector105
vector105:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $105
8010641a:	6a 69                	push   $0x69
  jmp alltraps
8010641c:	e9 66 f7 ff ff       	jmp    80105b87 <alltraps>

80106421 <vector106>:
.globl vector106
vector106:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $106
80106423:	6a 6a                	push   $0x6a
  jmp alltraps
80106425:	e9 5d f7 ff ff       	jmp    80105b87 <alltraps>

8010642a <vector107>:
.globl vector107
vector107:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $107
8010642c:	6a 6b                	push   $0x6b
  jmp alltraps
8010642e:	e9 54 f7 ff ff       	jmp    80105b87 <alltraps>

80106433 <vector108>:
.globl vector108
vector108:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $108
80106435:	6a 6c                	push   $0x6c
  jmp alltraps
80106437:	e9 4b f7 ff ff       	jmp    80105b87 <alltraps>

8010643c <vector109>:
.globl vector109
vector109:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $109
8010643e:	6a 6d                	push   $0x6d
  jmp alltraps
80106440:	e9 42 f7 ff ff       	jmp    80105b87 <alltraps>

80106445 <vector110>:
.globl vector110
vector110:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $110
80106447:	6a 6e                	push   $0x6e
  jmp alltraps
80106449:	e9 39 f7 ff ff       	jmp    80105b87 <alltraps>

8010644e <vector111>:
.globl vector111
vector111:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $111
80106450:	6a 6f                	push   $0x6f
  jmp alltraps
80106452:	e9 30 f7 ff ff       	jmp    80105b87 <alltraps>

80106457 <vector112>:
.globl vector112
vector112:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $112
80106459:	6a 70                	push   $0x70
  jmp alltraps
8010645b:	e9 27 f7 ff ff       	jmp    80105b87 <alltraps>

80106460 <vector113>:
.globl vector113
vector113:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $113
80106462:	6a 71                	push   $0x71
  jmp alltraps
80106464:	e9 1e f7 ff ff       	jmp    80105b87 <alltraps>

80106469 <vector114>:
.globl vector114
vector114:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $114
8010646b:	6a 72                	push   $0x72
  jmp alltraps
8010646d:	e9 15 f7 ff ff       	jmp    80105b87 <alltraps>

80106472 <vector115>:
.globl vector115
vector115:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $115
80106474:	6a 73                	push   $0x73
  jmp alltraps
80106476:	e9 0c f7 ff ff       	jmp    80105b87 <alltraps>

8010647b <vector116>:
.globl vector116
vector116:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $116
8010647d:	6a 74                	push   $0x74
  jmp alltraps
8010647f:	e9 03 f7 ff ff       	jmp    80105b87 <alltraps>

80106484 <vector117>:
.globl vector117
vector117:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $117
80106486:	6a 75                	push   $0x75
  jmp alltraps
80106488:	e9 fa f6 ff ff       	jmp    80105b87 <alltraps>

8010648d <vector118>:
.globl vector118
vector118:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $118
8010648f:	6a 76                	push   $0x76
  jmp alltraps
80106491:	e9 f1 f6 ff ff       	jmp    80105b87 <alltraps>

80106496 <vector119>:
.globl vector119
vector119:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $119
80106498:	6a 77                	push   $0x77
  jmp alltraps
8010649a:	e9 e8 f6 ff ff       	jmp    80105b87 <alltraps>

8010649f <vector120>:
.globl vector120
vector120:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $120
801064a1:	6a 78                	push   $0x78
  jmp alltraps
801064a3:	e9 df f6 ff ff       	jmp    80105b87 <alltraps>

801064a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $121
801064aa:	6a 79                	push   $0x79
  jmp alltraps
801064ac:	e9 d6 f6 ff ff       	jmp    80105b87 <alltraps>

801064b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $122
801064b3:	6a 7a                	push   $0x7a
  jmp alltraps
801064b5:	e9 cd f6 ff ff       	jmp    80105b87 <alltraps>

801064ba <vector123>:
.globl vector123
vector123:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $123
801064bc:	6a 7b                	push   $0x7b
  jmp alltraps
801064be:	e9 c4 f6 ff ff       	jmp    80105b87 <alltraps>

801064c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $124
801064c5:	6a 7c                	push   $0x7c
  jmp alltraps
801064c7:	e9 bb f6 ff ff       	jmp    80105b87 <alltraps>

801064cc <vector125>:
.globl vector125
vector125:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $125
801064ce:	6a 7d                	push   $0x7d
  jmp alltraps
801064d0:	e9 b2 f6 ff ff       	jmp    80105b87 <alltraps>

801064d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $126
801064d7:	6a 7e                	push   $0x7e
  jmp alltraps
801064d9:	e9 a9 f6 ff ff       	jmp    80105b87 <alltraps>

801064de <vector127>:
.globl vector127
vector127:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $127
801064e0:	6a 7f                	push   $0x7f
  jmp alltraps
801064e2:	e9 a0 f6 ff ff       	jmp    80105b87 <alltraps>

801064e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $128
801064e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ee:	e9 94 f6 ff ff       	jmp    80105b87 <alltraps>

801064f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $129
801064f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064fa:	e9 88 f6 ff ff       	jmp    80105b87 <alltraps>

801064ff <vector130>:
.globl vector130
vector130:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $130
80106501:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106506:	e9 7c f6 ff ff       	jmp    80105b87 <alltraps>

8010650b <vector131>:
.globl vector131
vector131:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $131
8010650d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106512:	e9 70 f6 ff ff       	jmp    80105b87 <alltraps>

80106517 <vector132>:
.globl vector132
vector132:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $132
80106519:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010651e:	e9 64 f6 ff ff       	jmp    80105b87 <alltraps>

80106523 <vector133>:
.globl vector133
vector133:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $133
80106525:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010652a:	e9 58 f6 ff ff       	jmp    80105b87 <alltraps>

8010652f <vector134>:
.globl vector134
vector134:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $134
80106531:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106536:	e9 4c f6 ff ff       	jmp    80105b87 <alltraps>

8010653b <vector135>:
.globl vector135
vector135:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $135
8010653d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106542:	e9 40 f6 ff ff       	jmp    80105b87 <alltraps>

80106547 <vector136>:
.globl vector136
vector136:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $136
80106549:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010654e:	e9 34 f6 ff ff       	jmp    80105b87 <alltraps>

80106553 <vector137>:
.globl vector137
vector137:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $137
80106555:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010655a:	e9 28 f6 ff ff       	jmp    80105b87 <alltraps>

8010655f <vector138>:
.globl vector138
vector138:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $138
80106561:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106566:	e9 1c f6 ff ff       	jmp    80105b87 <alltraps>

8010656b <vector139>:
.globl vector139
vector139:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $139
8010656d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106572:	e9 10 f6 ff ff       	jmp    80105b87 <alltraps>

80106577 <vector140>:
.globl vector140
vector140:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $140
80106579:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010657e:	e9 04 f6 ff ff       	jmp    80105b87 <alltraps>

80106583 <vector141>:
.globl vector141
vector141:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $141
80106585:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010658a:	e9 f8 f5 ff ff       	jmp    80105b87 <alltraps>

8010658f <vector142>:
.globl vector142
vector142:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $142
80106591:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106596:	e9 ec f5 ff ff       	jmp    80105b87 <alltraps>

8010659b <vector143>:
.globl vector143
vector143:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $143
8010659d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065a2:	e9 e0 f5 ff ff       	jmp    80105b87 <alltraps>

801065a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $144
801065a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065ae:	e9 d4 f5 ff ff       	jmp    80105b87 <alltraps>

801065b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $145
801065b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065ba:	e9 c8 f5 ff ff       	jmp    80105b87 <alltraps>

801065bf <vector146>:
.globl vector146
vector146:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $146
801065c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065c6:	e9 bc f5 ff ff       	jmp    80105b87 <alltraps>

801065cb <vector147>:
.globl vector147
vector147:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $147
801065cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065d2:	e9 b0 f5 ff ff       	jmp    80105b87 <alltraps>

801065d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $148
801065d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065de:	e9 a4 f5 ff ff       	jmp    80105b87 <alltraps>

801065e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $149
801065e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ea:	e9 98 f5 ff ff       	jmp    80105b87 <alltraps>

801065ef <vector150>:
.globl vector150
vector150:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $150
801065f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065f6:	e9 8c f5 ff ff       	jmp    80105b87 <alltraps>

801065fb <vector151>:
.globl vector151
vector151:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $151
801065fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106602:	e9 80 f5 ff ff       	jmp    80105b87 <alltraps>

80106607 <vector152>:
.globl vector152
vector152:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $152
80106609:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010660e:	e9 74 f5 ff ff       	jmp    80105b87 <alltraps>

80106613 <vector153>:
.globl vector153
vector153:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $153
80106615:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010661a:	e9 68 f5 ff ff       	jmp    80105b87 <alltraps>

8010661f <vector154>:
.globl vector154
vector154:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $154
80106621:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106626:	e9 5c f5 ff ff       	jmp    80105b87 <alltraps>

8010662b <vector155>:
.globl vector155
vector155:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $155
8010662d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106632:	e9 50 f5 ff ff       	jmp    80105b87 <alltraps>

80106637 <vector156>:
.globl vector156
vector156:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $156
80106639:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010663e:	e9 44 f5 ff ff       	jmp    80105b87 <alltraps>

80106643 <vector157>:
.globl vector157
vector157:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $157
80106645:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010664a:	e9 38 f5 ff ff       	jmp    80105b87 <alltraps>

8010664f <vector158>:
.globl vector158
vector158:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $158
80106651:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106656:	e9 2c f5 ff ff       	jmp    80105b87 <alltraps>

8010665b <vector159>:
.globl vector159
vector159:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $159
8010665d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106662:	e9 20 f5 ff ff       	jmp    80105b87 <alltraps>

80106667 <vector160>:
.globl vector160
vector160:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $160
80106669:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010666e:	e9 14 f5 ff ff       	jmp    80105b87 <alltraps>

80106673 <vector161>:
.globl vector161
vector161:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $161
80106675:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010667a:	e9 08 f5 ff ff       	jmp    80105b87 <alltraps>

8010667f <vector162>:
.globl vector162
vector162:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $162
80106681:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106686:	e9 fc f4 ff ff       	jmp    80105b87 <alltraps>

8010668b <vector163>:
.globl vector163
vector163:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $163
8010668d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106692:	e9 f0 f4 ff ff       	jmp    80105b87 <alltraps>

80106697 <vector164>:
.globl vector164
vector164:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $164
80106699:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010669e:	e9 e4 f4 ff ff       	jmp    80105b87 <alltraps>

801066a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $165
801066a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066aa:	e9 d8 f4 ff ff       	jmp    80105b87 <alltraps>

801066af <vector166>:
.globl vector166
vector166:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $166
801066b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066b6:	e9 cc f4 ff ff       	jmp    80105b87 <alltraps>

801066bb <vector167>:
.globl vector167
vector167:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $167
801066bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066c2:	e9 c0 f4 ff ff       	jmp    80105b87 <alltraps>

801066c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $168
801066c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066ce:	e9 b4 f4 ff ff       	jmp    80105b87 <alltraps>

801066d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $169
801066d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066da:	e9 a8 f4 ff ff       	jmp    80105b87 <alltraps>

801066df <vector170>:
.globl vector170
vector170:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $170
801066e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066e6:	e9 9c f4 ff ff       	jmp    80105b87 <alltraps>

801066eb <vector171>:
.globl vector171
vector171:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $171
801066ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066f2:	e9 90 f4 ff ff       	jmp    80105b87 <alltraps>

801066f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $172
801066f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066fe:	e9 84 f4 ff ff       	jmp    80105b87 <alltraps>

80106703 <vector173>:
.globl vector173
vector173:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $173
80106705:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010670a:	e9 78 f4 ff ff       	jmp    80105b87 <alltraps>

8010670f <vector174>:
.globl vector174
vector174:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $174
80106711:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106716:	e9 6c f4 ff ff       	jmp    80105b87 <alltraps>

8010671b <vector175>:
.globl vector175
vector175:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $175
8010671d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106722:	e9 60 f4 ff ff       	jmp    80105b87 <alltraps>

80106727 <vector176>:
.globl vector176
vector176:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $176
80106729:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010672e:	e9 54 f4 ff ff       	jmp    80105b87 <alltraps>

80106733 <vector177>:
.globl vector177
vector177:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $177
80106735:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010673a:	e9 48 f4 ff ff       	jmp    80105b87 <alltraps>

8010673f <vector178>:
.globl vector178
vector178:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $178
80106741:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106746:	e9 3c f4 ff ff       	jmp    80105b87 <alltraps>

8010674b <vector179>:
.globl vector179
vector179:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $179
8010674d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106752:	e9 30 f4 ff ff       	jmp    80105b87 <alltraps>

80106757 <vector180>:
.globl vector180
vector180:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $180
80106759:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010675e:	e9 24 f4 ff ff       	jmp    80105b87 <alltraps>

80106763 <vector181>:
.globl vector181
vector181:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $181
80106765:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010676a:	e9 18 f4 ff ff       	jmp    80105b87 <alltraps>

8010676f <vector182>:
.globl vector182
vector182:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $182
80106771:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106776:	e9 0c f4 ff ff       	jmp    80105b87 <alltraps>

8010677b <vector183>:
.globl vector183
vector183:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $183
8010677d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106782:	e9 00 f4 ff ff       	jmp    80105b87 <alltraps>

80106787 <vector184>:
.globl vector184
vector184:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $184
80106789:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010678e:	e9 f4 f3 ff ff       	jmp    80105b87 <alltraps>

80106793 <vector185>:
.globl vector185
vector185:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $185
80106795:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010679a:	e9 e8 f3 ff ff       	jmp    80105b87 <alltraps>

8010679f <vector186>:
.globl vector186
vector186:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $186
801067a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067a6:	e9 dc f3 ff ff       	jmp    80105b87 <alltraps>

801067ab <vector187>:
.globl vector187
vector187:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $187
801067ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067b2:	e9 d0 f3 ff ff       	jmp    80105b87 <alltraps>

801067b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $188
801067b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067be:	e9 c4 f3 ff ff       	jmp    80105b87 <alltraps>

801067c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $189
801067c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ca:	e9 b8 f3 ff ff       	jmp    80105b87 <alltraps>

801067cf <vector190>:
.globl vector190
vector190:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $190
801067d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067d6:	e9 ac f3 ff ff       	jmp    80105b87 <alltraps>

801067db <vector191>:
.globl vector191
vector191:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $191
801067dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067e2:	e9 a0 f3 ff ff       	jmp    80105b87 <alltraps>

801067e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $192
801067e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ee:	e9 94 f3 ff ff       	jmp    80105b87 <alltraps>

801067f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $193
801067f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067fa:	e9 88 f3 ff ff       	jmp    80105b87 <alltraps>

801067ff <vector194>:
.globl vector194
vector194:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $194
80106801:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106806:	e9 7c f3 ff ff       	jmp    80105b87 <alltraps>

8010680b <vector195>:
.globl vector195
vector195:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $195
8010680d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106812:	e9 70 f3 ff ff       	jmp    80105b87 <alltraps>

80106817 <vector196>:
.globl vector196
vector196:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $196
80106819:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010681e:	e9 64 f3 ff ff       	jmp    80105b87 <alltraps>

80106823 <vector197>:
.globl vector197
vector197:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $197
80106825:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010682a:	e9 58 f3 ff ff       	jmp    80105b87 <alltraps>

8010682f <vector198>:
.globl vector198
vector198:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $198
80106831:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106836:	e9 4c f3 ff ff       	jmp    80105b87 <alltraps>

8010683b <vector199>:
.globl vector199
vector199:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $199
8010683d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106842:	e9 40 f3 ff ff       	jmp    80105b87 <alltraps>

80106847 <vector200>:
.globl vector200
vector200:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $200
80106849:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010684e:	e9 34 f3 ff ff       	jmp    80105b87 <alltraps>

80106853 <vector201>:
.globl vector201
vector201:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $201
80106855:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010685a:	e9 28 f3 ff ff       	jmp    80105b87 <alltraps>

8010685f <vector202>:
.globl vector202
vector202:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $202
80106861:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106866:	e9 1c f3 ff ff       	jmp    80105b87 <alltraps>

8010686b <vector203>:
.globl vector203
vector203:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $203
8010686d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106872:	e9 10 f3 ff ff       	jmp    80105b87 <alltraps>

80106877 <vector204>:
.globl vector204
vector204:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $204
80106879:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010687e:	e9 04 f3 ff ff       	jmp    80105b87 <alltraps>

80106883 <vector205>:
.globl vector205
vector205:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $205
80106885:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010688a:	e9 f8 f2 ff ff       	jmp    80105b87 <alltraps>

8010688f <vector206>:
.globl vector206
vector206:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $206
80106891:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106896:	e9 ec f2 ff ff       	jmp    80105b87 <alltraps>

8010689b <vector207>:
.globl vector207
vector207:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $207
8010689d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068a2:	e9 e0 f2 ff ff       	jmp    80105b87 <alltraps>

801068a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $208
801068a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068ae:	e9 d4 f2 ff ff       	jmp    80105b87 <alltraps>

801068b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $209
801068b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068ba:	e9 c8 f2 ff ff       	jmp    80105b87 <alltraps>

801068bf <vector210>:
.globl vector210
vector210:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $210
801068c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068c6:	e9 bc f2 ff ff       	jmp    80105b87 <alltraps>

801068cb <vector211>:
.globl vector211
vector211:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $211
801068cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068d2:	e9 b0 f2 ff ff       	jmp    80105b87 <alltraps>

801068d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $212
801068d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068de:	e9 a4 f2 ff ff       	jmp    80105b87 <alltraps>

801068e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $213
801068e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ea:	e9 98 f2 ff ff       	jmp    80105b87 <alltraps>

801068ef <vector214>:
.globl vector214
vector214:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $214
801068f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068f6:	e9 8c f2 ff ff       	jmp    80105b87 <alltraps>

801068fb <vector215>:
.globl vector215
vector215:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $215
801068fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106902:	e9 80 f2 ff ff       	jmp    80105b87 <alltraps>

80106907 <vector216>:
.globl vector216
vector216:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $216
80106909:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010690e:	e9 74 f2 ff ff       	jmp    80105b87 <alltraps>

80106913 <vector217>:
.globl vector217
vector217:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $217
80106915:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010691a:	e9 68 f2 ff ff       	jmp    80105b87 <alltraps>

8010691f <vector218>:
.globl vector218
vector218:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $218
80106921:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106926:	e9 5c f2 ff ff       	jmp    80105b87 <alltraps>

8010692b <vector219>:
.globl vector219
vector219:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $219
8010692d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106932:	e9 50 f2 ff ff       	jmp    80105b87 <alltraps>

80106937 <vector220>:
.globl vector220
vector220:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $220
80106939:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010693e:	e9 44 f2 ff ff       	jmp    80105b87 <alltraps>

80106943 <vector221>:
.globl vector221
vector221:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $221
80106945:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010694a:	e9 38 f2 ff ff       	jmp    80105b87 <alltraps>

8010694f <vector222>:
.globl vector222
vector222:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $222
80106951:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106956:	e9 2c f2 ff ff       	jmp    80105b87 <alltraps>

8010695b <vector223>:
.globl vector223
vector223:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $223
8010695d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106962:	e9 20 f2 ff ff       	jmp    80105b87 <alltraps>

80106967 <vector224>:
.globl vector224
vector224:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $224
80106969:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010696e:	e9 14 f2 ff ff       	jmp    80105b87 <alltraps>

80106973 <vector225>:
.globl vector225
vector225:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $225
80106975:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010697a:	e9 08 f2 ff ff       	jmp    80105b87 <alltraps>

8010697f <vector226>:
.globl vector226
vector226:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $226
80106981:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106986:	e9 fc f1 ff ff       	jmp    80105b87 <alltraps>

8010698b <vector227>:
.globl vector227
vector227:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $227
8010698d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106992:	e9 f0 f1 ff ff       	jmp    80105b87 <alltraps>

80106997 <vector228>:
.globl vector228
vector228:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $228
80106999:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010699e:	e9 e4 f1 ff ff       	jmp    80105b87 <alltraps>

801069a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $229
801069a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069aa:	e9 d8 f1 ff ff       	jmp    80105b87 <alltraps>

801069af <vector230>:
.globl vector230
vector230:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $230
801069b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069b6:	e9 cc f1 ff ff       	jmp    80105b87 <alltraps>

801069bb <vector231>:
.globl vector231
vector231:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $231
801069bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069c2:	e9 c0 f1 ff ff       	jmp    80105b87 <alltraps>

801069c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $232
801069c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069ce:	e9 b4 f1 ff ff       	jmp    80105b87 <alltraps>

801069d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $233
801069d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069da:	e9 a8 f1 ff ff       	jmp    80105b87 <alltraps>

801069df <vector234>:
.globl vector234
vector234:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $234
801069e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069e6:	e9 9c f1 ff ff       	jmp    80105b87 <alltraps>

801069eb <vector235>:
.globl vector235
vector235:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $235
801069ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069f2:	e9 90 f1 ff ff       	jmp    80105b87 <alltraps>

801069f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $236
801069f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069fe:	e9 84 f1 ff ff       	jmp    80105b87 <alltraps>

80106a03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $237
80106a05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a0a:	e9 78 f1 ff ff       	jmp    80105b87 <alltraps>

80106a0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $238
80106a11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a16:	e9 6c f1 ff ff       	jmp    80105b87 <alltraps>

80106a1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $239
80106a1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a22:	e9 60 f1 ff ff       	jmp    80105b87 <alltraps>

80106a27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $240
80106a29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a2e:	e9 54 f1 ff ff       	jmp    80105b87 <alltraps>

80106a33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $241
80106a35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a3a:	e9 48 f1 ff ff       	jmp    80105b87 <alltraps>

80106a3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $242
80106a41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a46:	e9 3c f1 ff ff       	jmp    80105b87 <alltraps>

80106a4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $243
80106a4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a52:	e9 30 f1 ff ff       	jmp    80105b87 <alltraps>

80106a57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $244
80106a59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a5e:	e9 24 f1 ff ff       	jmp    80105b87 <alltraps>

80106a63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $245
80106a65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a6a:	e9 18 f1 ff ff       	jmp    80105b87 <alltraps>

80106a6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $246
80106a71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a76:	e9 0c f1 ff ff       	jmp    80105b87 <alltraps>

80106a7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $247
80106a7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a82:	e9 00 f1 ff ff       	jmp    80105b87 <alltraps>

80106a87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $248
80106a89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a8e:	e9 f4 f0 ff ff       	jmp    80105b87 <alltraps>

80106a93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $249
80106a95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a9a:	e9 e8 f0 ff ff       	jmp    80105b87 <alltraps>

80106a9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $250
80106aa1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106aa6:	e9 dc f0 ff ff       	jmp    80105b87 <alltraps>

80106aab <vector251>:
.globl vector251
vector251:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $251
80106aad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ab2:	e9 d0 f0 ff ff       	jmp    80105b87 <alltraps>

80106ab7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $252
80106ab9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106abe:	e9 c4 f0 ff ff       	jmp    80105b87 <alltraps>

80106ac3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $253
80106ac5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aca:	e9 b8 f0 ff ff       	jmp    80105b87 <alltraps>

80106acf <vector254>:
.globl vector254
vector254:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $254
80106ad1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ad6:	e9 ac f0 ff ff       	jmp    80105b87 <alltraps>

80106adb <vector255>:
.globl vector255
vector255:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $255
80106add:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ae2:	e9 a0 f0 ff ff       	jmp    80105b87 <alltraps>
80106ae7:	66 90                	xchg   %ax,%ax
80106ae9:	66 90                	xchg   %ax,%ax
80106aeb:	66 90                	xchg   %ax,%ax
80106aed:	66 90                	xchg   %ax,%ax
80106aef:	90                   	nop

80106af0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106af6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106afc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b02:	83 ec 1c             	sub    $0x1c,%esp
80106b05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b08:	39 d3                	cmp    %edx,%ebx
80106b0a:	73 49                	jae    80106b55 <deallocuvm.part.0+0x65>
80106b0c:	89 c7                	mov    %eax,%edi
80106b0e:	eb 0c                	jmp    80106b1c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b10:	83 c0 01             	add    $0x1,%eax
80106b13:	c1 e0 16             	shl    $0x16,%eax
80106b16:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b18:	39 da                	cmp    %ebx,%edx
80106b1a:	76 39                	jbe    80106b55 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106b1c:	89 d8                	mov    %ebx,%eax
80106b1e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b21:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106b24:	f6 c1 01             	test   $0x1,%cl
80106b27:	74 e7                	je     80106b10 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b29:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b2b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106b31:	c1 ee 0a             	shr    $0xa,%esi
80106b34:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b3a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106b41:	85 f6                	test   %esi,%esi
80106b43:	74 cb                	je     80106b10 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106b45:	8b 06                	mov    (%esi),%eax
80106b47:	a8 01                	test   $0x1,%al
80106b49:	75 15                	jne    80106b60 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106b4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b51:	39 da                	cmp    %ebx,%edx
80106b53:	77 c7                	ja     80106b1c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b5b:	5b                   	pop    %ebx
80106b5c:	5e                   	pop    %esi
80106b5d:	5f                   	pop    %edi
80106b5e:	5d                   	pop    %ebp
80106b5f:	c3                   	ret
      if(pa == 0)
80106b60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b65:	74 25                	je     80106b8c <deallocuvm.part.0+0x9c>
      kfree(v);
80106b67:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b6a:	05 00 00 00 80       	add    $0x80000000,%eax
80106b6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106b78:	50                   	push   %eax
80106b79:	e8 42 b9 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106b7e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106b84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b87:	83 c4 10             	add    $0x10,%esp
80106b8a:	eb 8c                	jmp    80106b18 <deallocuvm.part.0+0x28>
        panic("kfree");
80106b8c:	83 ec 0c             	sub    $0xc,%esp
80106b8f:	68 ac 76 10 80       	push   $0x801076ac
80106b94:	e8 e7 97 ff ff       	call   80100380 <panic>
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ba0 <mappages>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ba6:	89 d3                	mov    %edx,%ebx
80106ba8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106bae:	83 ec 1c             	sub    $0x1c,%esp
80106bb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106bb4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106bb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bc3:	29 d8                	sub    %ebx,%eax
80106bc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bc8:	eb 3d                	jmp    80106c07 <mappages+0x67>
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106bd0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106bd7:	c1 ea 0a             	shr    $0xa,%edx
80106bda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106be0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106be7:	85 c0                	test   %eax,%eax
80106be9:	74 75                	je     80106c60 <mappages+0xc0>
    if(*pte & PTE_P)
80106beb:	f6 00 01             	testb  $0x1,(%eax)
80106bee:	0f 85 86 00 00 00    	jne    80106c7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106bf4:	0b 75 0c             	or     0xc(%ebp),%esi
80106bf7:	83 ce 01             	or     $0x1,%esi
80106bfa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bfc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106bff:	74 6f                	je     80106c70 <mappages+0xd0>
    a += PGSIZE;
80106c01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c10:	89 d8                	mov    %ebx,%eax
80106c12:	c1 e8 16             	shr    $0x16,%eax
80106c15:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c18:	8b 07                	mov    (%edi),%eax
80106c1a:	a8 01                	test   $0x1,%al
80106c1c:	75 b2                	jne    80106bd0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c1e:	e8 5d ba ff ff       	call   80102680 <kalloc>
80106c23:	85 c0                	test   %eax,%eax
80106c25:	74 39                	je     80106c60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c27:	83 ec 04             	sub    $0x4,%esp
80106c2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c2d:	68 00 10 00 00       	push   $0x1000
80106c32:	6a 00                	push   $0x0
80106c34:	50                   	push   %eax
80106c35:	e8 56 db ff ff       	call   80104790 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c3d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c40:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c46:	83 c8 07             	or     $0x7,%eax
80106c49:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c4b:	89 d8                	mov    %ebx,%eax
80106c4d:	c1 e8 0a             	shr    $0xa,%eax
80106c50:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c55:	01 d0                	add    %edx,%eax
80106c57:	eb 92                	jmp    80106beb <mappages+0x4b>
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c68:	5b                   	pop    %ebx
80106c69:	5e                   	pop    %esi
80106c6a:	5f                   	pop    %edi
80106c6b:	5d                   	pop    %ebp
80106c6c:	c3                   	ret
80106c6d:	8d 76 00             	lea    0x0(%esi),%esi
80106c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c73:	31 c0                	xor    %eax,%eax
}
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5f                   	pop    %edi
80106c78:	5d                   	pop    %ebp
80106c79:	c3                   	ret
      panic("remap");
80106c7a:	83 ec 0c             	sub    $0xc,%esp
80106c7d:	68 ff 78 10 80       	push   $0x801078ff
80106c82:	e8 f9 96 ff ff       	call   80100380 <panic>
80106c87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c8e:	00 
80106c8f:	90                   	nop

80106c90 <seginit>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c96:	e8 75 cd ff ff       	call   80103a10 <cpuid>
  pd[0] = size-1;
80106c9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ca0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ca6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106caa:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106cb1:	ff 00 00 
80106cb4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106cbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cbe:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106cc5:	ff 00 00 
80106cc8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106ccf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cd2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106cd9:	ff 00 00 
80106cdc:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106ce3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ce6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106ced:	ff 00 00 
80106cf0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106cf7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cfa:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106cff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d03:	c1 e8 10             	shr    $0x10,%eax
80106d06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d0d:	0f 01 10             	lgdtl  (%eax)
}
80106d10:	c9                   	leave
80106d11:	c3                   	ret
80106d12:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d19:	00 
80106d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d20:	a1 44 46 11 80       	mov    0x80114644,%eax
80106d25:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d2a:	0f 22 d8             	mov    %eax,%cr3
}
80106d2d:	c3                   	ret
80106d2e:	66 90                	xchg   %ax,%ax

80106d30 <switchuvm>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d3c:	85 f6                	test   %esi,%esi
80106d3e:	0f 84 cb 00 00 00    	je     80106e0f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d44:	8b 46 08             	mov    0x8(%esi),%eax
80106d47:	85 c0                	test   %eax,%eax
80106d49:	0f 84 da 00 00 00    	je     80106e29 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d4f:	8b 46 04             	mov    0x4(%esi),%eax
80106d52:	85 c0                	test   %eax,%eax
80106d54:	0f 84 c2 00 00 00    	je     80106e1c <switchuvm+0xec>
  pushcli();
80106d5a:	e8 21 d8 ff ff       	call   80104580 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d5f:	e8 4c cc ff ff       	call   801039b0 <mycpu>
80106d64:	89 c3                	mov    %eax,%ebx
80106d66:	e8 45 cc ff ff       	call   801039b0 <mycpu>
80106d6b:	89 c7                	mov    %eax,%edi
80106d6d:	e8 3e cc ff ff       	call   801039b0 <mycpu>
80106d72:	83 c7 08             	add    $0x8,%edi
80106d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d78:	e8 33 cc ff ff       	call   801039b0 <mycpu>
80106d7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d80:	ba 67 00 00 00       	mov    $0x67,%edx
80106d85:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d8c:	83 c0 08             	add    $0x8,%eax
80106d8f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d96:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d9b:	83 c1 08             	add    $0x8,%ecx
80106d9e:	c1 e8 18             	shr    $0x18,%eax
80106da1:	c1 e9 10             	shr    $0x10,%ecx
80106da4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106daa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106db0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106db5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106dc1:	e8 ea cb ff ff       	call   801039b0 <mycpu>
80106dc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dcd:	e8 de cb ff ff       	call   801039b0 <mycpu>
80106dd2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dd6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106dd9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ddf:	e8 cc cb ff ff       	call   801039b0 <mycpu>
80106de4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106de7:	e8 c4 cb ff ff       	call   801039b0 <mycpu>
80106dec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106df0:	b8 28 00 00 00       	mov    $0x28,%eax
80106df5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106df8:	8b 46 04             	mov    0x4(%esi),%eax
80106dfb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e00:	0f 22 d8             	mov    %eax,%cr3
}
80106e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e06:	5b                   	pop    %ebx
80106e07:	5e                   	pop    %esi
80106e08:	5f                   	pop    %edi
80106e09:	5d                   	pop    %ebp
  popcli();
80106e0a:	e9 c1 d7 ff ff       	jmp    801045d0 <popcli>
    panic("switchuvm: no process");
80106e0f:	83 ec 0c             	sub    $0xc,%esp
80106e12:	68 05 79 10 80       	push   $0x80107905
80106e17:	e8 64 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e1c:	83 ec 0c             	sub    $0xc,%esp
80106e1f:	68 30 79 10 80       	push   $0x80107930
80106e24:	e8 57 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e29:	83 ec 0c             	sub    $0xc,%esp
80106e2c:	68 1b 79 10 80       	push   $0x8010791b
80106e31:	e8 4a 95 ff ff       	call   80100380 <panic>
80106e36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e3d:	00 
80106e3e:	66 90                	xchg   %ax,%ax

80106e40 <inituvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e4c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e4f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e55:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e5b:	77 4b                	ja     80106ea8 <inituvm+0x68>
  mem = kalloc();
80106e5d:	e8 1e b8 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80106e62:	83 ec 04             	sub    $0x4,%esp
80106e65:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e6a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e6c:	6a 00                	push   $0x0
80106e6e:	50                   	push   %eax
80106e6f:	e8 1c d9 ff ff       	call   80104790 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e74:	58                   	pop    %eax
80106e75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e7b:	5a                   	pop    %edx
80106e7c:	6a 06                	push   $0x6
80106e7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e83:	31 d2                	xor    %edx,%edx
80106e85:	50                   	push   %eax
80106e86:	89 f8                	mov    %edi,%eax
80106e88:	e8 13 fd ff ff       	call   80106ba0 <mappages>
  memmove(mem, init, sz);
80106e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e90:	89 75 10             	mov    %esi,0x10(%ebp)
80106e93:	83 c4 10             	add    $0x10,%esp
80106e96:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e99:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9f:	5b                   	pop    %ebx
80106ea0:	5e                   	pop    %esi
80106ea1:	5f                   	pop    %edi
80106ea2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ea3:	e9 88 d9 ff ff       	jmp    80104830 <memmove>
    panic("inituvm: more than a page");
80106ea8:	83 ec 0c             	sub    $0xc,%esp
80106eab:	68 44 79 10 80       	push   $0x80107944
80106eb0:	e8 cb 94 ff ff       	call   80100380 <panic>
80106eb5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ebc:	00 
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi

80106ec0 <loaduvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
80106ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ecc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ecf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ed4:	0f 85 bb 00 00 00    	jne    80106f95 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106eda:	01 f0                	add    %esi,%eax
80106edc:	89 f3                	mov    %esi,%ebx
80106ede:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ee1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ee4:	01 f0                	add    %esi,%eax
80106ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ee9:	85 f6                	test   %esi,%esi
80106eeb:	0f 84 87 00 00 00    	je     80106f78 <loaduvm+0xb8>
80106ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106efb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106efe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f00:	89 c2                	mov    %eax,%edx
80106f02:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f05:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f08:	f6 c2 01             	test   $0x1,%dl
80106f0b:	75 13                	jne    80106f20 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f0d:	83 ec 0c             	sub    $0xc,%esp
80106f10:	68 5e 79 10 80       	push   $0x8010795e
80106f15:	e8 66 94 ff ff       	call   80100380 <panic>
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f20:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f29:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f2e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f35:	85 c0                	test   %eax,%eax
80106f37:	74 d4                	je     80106f0d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f39:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f3e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f48:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f4e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f51:	29 d9                	sub    %ebx,%ecx
80106f53:	05 00 00 00 80       	add    $0x80000000,%eax
80106f58:	57                   	push   %edi
80106f59:	51                   	push   %ecx
80106f5a:	50                   	push   %eax
80106f5b:	ff 75 10             	push   0x10(%ebp)
80106f5e:	e8 2d ab ff ff       	call   80101a90 <readi>
80106f63:	83 c4 10             	add    $0x10,%esp
80106f66:	39 f8                	cmp    %edi,%eax
80106f68:	75 1e                	jne    80106f88 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f6a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f70:	89 f0                	mov    %esi,%eax
80106f72:	29 d8                	sub    %ebx,%eax
80106f74:	39 c6                	cmp    %eax,%esi
80106f76:	77 80                	ja     80106ef8 <loaduvm+0x38>
}
80106f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f7b:	31 c0                	xor    %eax,%eax
}
80106f7d:	5b                   	pop    %ebx
80106f7e:	5e                   	pop    %esi
80106f7f:	5f                   	pop    %edi
80106f80:	5d                   	pop    %ebp
80106f81:	c3                   	ret
80106f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f90:	5b                   	pop    %ebx
80106f91:	5e                   	pop    %esi
80106f92:	5f                   	pop    %edi
80106f93:	5d                   	pop    %ebp
80106f94:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106f95:	83 ec 0c             	sub    $0xc,%esp
80106f98:	68 80 7b 10 80       	push   $0x80107b80
80106f9d:	e8 de 93 ff ff       	call   80100380 <panic>
80106fa2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fa9:	00 
80106faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fb0 <allocuvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fb9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106fbc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fc2:	85 c0                	test   %eax,%eax
80106fc4:	0f 88 b6 00 00 00    	js     80107080 <allocuvm+0xd0>
  if(newsz < oldsz)
80106fca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106fd0:	0f 82 9a 00 00 00    	jb     80107070 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fd6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fdc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fe2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fe5:	77 44                	ja     8010702b <allocuvm+0x7b>
80106fe7:	e9 87 00 00 00       	jmp    80107073 <allocuvm+0xc3>
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106ff0:	83 ec 04             	sub    $0x4,%esp
80106ff3:	68 00 10 00 00       	push   $0x1000
80106ff8:	6a 00                	push   $0x0
80106ffa:	50                   	push   %eax
80106ffb:	e8 90 d7 ff ff       	call   80104790 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107000:	58                   	pop    %eax
80107001:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107007:	5a                   	pop    %edx
80107008:	6a 06                	push   $0x6
8010700a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010700f:	89 f2                	mov    %esi,%edx
80107011:	50                   	push   %eax
80107012:	89 f8                	mov    %edi,%eax
80107014:	e8 87 fb ff ff       	call   80106ba0 <mappages>
80107019:	83 c4 10             	add    $0x10,%esp
8010701c:	85 c0                	test   %eax,%eax
8010701e:	78 78                	js     80107098 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107020:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107026:	39 75 10             	cmp    %esi,0x10(%ebp)
80107029:	76 48                	jbe    80107073 <allocuvm+0xc3>
    mem = kalloc();
8010702b:	e8 50 b6 ff ff       	call   80102680 <kalloc>
80107030:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107032:	85 c0                	test   %eax,%eax
80107034:	75 ba                	jne    80106ff0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	68 7c 79 10 80       	push   $0x8010797c
8010703e:	e8 5d 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107043:	8b 45 0c             	mov    0xc(%ebp),%eax
80107046:	83 c4 10             	add    $0x10,%esp
80107049:	39 45 10             	cmp    %eax,0x10(%ebp)
8010704c:	74 32                	je     80107080 <allocuvm+0xd0>
8010704e:	8b 55 10             	mov    0x10(%ebp),%edx
80107051:	89 c1                	mov    %eax,%ecx
80107053:	89 f8                	mov    %edi,%eax
80107055:	e8 96 fa ff ff       	call   80106af0 <deallocuvm.part.0>
      return 0;
8010705a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107064:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107067:	5b                   	pop    %ebx
80107068:	5e                   	pop    %esi
80107069:	5f                   	pop    %edi
8010706a:	5d                   	pop    %ebp
8010706b:	c3                   	ret
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107070:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107079:	5b                   	pop    %ebx
8010707a:	5e                   	pop    %esi
8010707b:	5f                   	pop    %edi
8010707c:	5d                   	pop    %ebp
8010707d:	c3                   	ret
8010707e:	66 90                	xchg   %ax,%ax
    return 0;
80107080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010708a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010708d:	5b                   	pop    %ebx
8010708e:	5e                   	pop    %esi
8010708f:	5f                   	pop    %edi
80107090:	5d                   	pop    %ebp
80107091:	c3                   	ret
80107092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107098:	83 ec 0c             	sub    $0xc,%esp
8010709b:	68 94 79 10 80       	push   $0x80107994
801070a0:	e8 fb 95 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801070a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a8:	83 c4 10             	add    $0x10,%esp
801070ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801070ae:	74 0c                	je     801070bc <allocuvm+0x10c>
801070b0:	8b 55 10             	mov    0x10(%ebp),%edx
801070b3:	89 c1                	mov    %eax,%ecx
801070b5:	89 f8                	mov    %edi,%eax
801070b7:	e8 34 fa ff ff       	call   80106af0 <deallocuvm.part.0>
      kfree(mem);
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	53                   	push   %ebx
801070c0:	e8 fb b3 ff ff       	call   801024c0 <kfree>
      return 0;
801070c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801070cc:	83 c4 10             	add    $0x10,%esp
}
801070cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <deallocuvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070ec:	39 d1                	cmp    %edx,%ecx
801070ee:	73 10                	jae    80107100 <deallocuvm+0x20>
}
801070f0:	5d                   	pop    %ebp
801070f1:	e9 fa f9 ff ff       	jmp    80106af0 <deallocuvm.part.0>
801070f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070fd:	00 
801070fe:	66 90                	xchg   %ax,%ax
80107100:	89 d0                	mov    %edx,%eax
80107102:	5d                   	pop    %ebp
80107103:	c3                   	ret
80107104:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010710b:	00 
8010710c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107110 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 0c             	sub    $0xc,%esp
80107119:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010711c:	85 f6                	test   %esi,%esi
8010711e:	74 59                	je     80107179 <freevm+0x69>
  if(newsz >= oldsz)
80107120:	31 c9                	xor    %ecx,%ecx
80107122:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107127:	89 f0                	mov    %esi,%eax
80107129:	89 f3                	mov    %esi,%ebx
8010712b:	e8 c0 f9 ff ff       	call   80106af0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107130:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107136:	eb 0f                	jmp    80107147 <freevm+0x37>
80107138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010713f:	00 
80107140:	83 c3 04             	add    $0x4,%ebx
80107143:	39 df                	cmp    %ebx,%edi
80107145:	74 23                	je     8010716a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107147:	8b 03                	mov    (%ebx),%eax
80107149:	a8 01                	test   $0x1,%al
8010714b:	74 f3                	je     80107140 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010714d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107152:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107155:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107158:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010715d:	50                   	push   %eax
8010715e:	e8 5d b3 ff ff       	call   801024c0 <kfree>
80107163:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107166:	39 df                	cmp    %ebx,%edi
80107168:	75 dd                	jne    80107147 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010716a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010716d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107170:	5b                   	pop    %ebx
80107171:	5e                   	pop    %esi
80107172:	5f                   	pop    %edi
80107173:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107174:	e9 47 b3 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107179:	83 ec 0c             	sub    $0xc,%esp
8010717c:	68 b0 79 10 80       	push   $0x801079b0
80107181:	e8 fa 91 ff ff       	call   80100380 <panic>
80107186:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010718d:	00 
8010718e:	66 90                	xchg   %ax,%ax

80107190 <setupkvm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	56                   	push   %esi
80107194:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107195:	e8 e6 b4 ff ff       	call   80102680 <kalloc>
8010719a:	89 c6                	mov    %eax,%esi
8010719c:	85 c0                	test   %eax,%eax
8010719e:	74 42                	je     801071e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801071a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071a3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801071a8:	68 00 10 00 00       	push   $0x1000
801071ad:	6a 00                	push   $0x0
801071af:	50                   	push   %eax
801071b0:	e8 db d5 ff ff       	call   80104790 <memset>
801071b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071bb:	83 ec 08             	sub    $0x8,%esp
801071be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071c1:	ff 73 0c             	push   0xc(%ebx)
801071c4:	8b 13                	mov    (%ebx),%edx
801071c6:	50                   	push   %eax
801071c7:	29 c1                	sub    %eax,%ecx
801071c9:	89 f0                	mov    %esi,%eax
801071cb:	e8 d0 f9 ff ff       	call   80106ba0 <mappages>
801071d0:	83 c4 10             	add    $0x10,%esp
801071d3:	85 c0                	test   %eax,%eax
801071d5:	78 19                	js     801071f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071d7:	83 c3 10             	add    $0x10,%ebx
801071da:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071e0:	75 d6                	jne    801071b8 <setupkvm+0x28>
}
801071e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071e5:	89 f0                	mov    %esi,%eax
801071e7:	5b                   	pop    %ebx
801071e8:	5e                   	pop    %esi
801071e9:	5d                   	pop    %ebp
801071ea:	c3                   	ret
801071eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801071f0:	83 ec 0c             	sub    $0xc,%esp
801071f3:	56                   	push   %esi
      return 0;
801071f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071f6:	e8 15 ff ff ff       	call   80107110 <freevm>
      return 0;
801071fb:	83 c4 10             	add    $0x10,%esp
}
801071fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107201:	89 f0                	mov    %esi,%eax
80107203:	5b                   	pop    %ebx
80107204:	5e                   	pop    %esi
80107205:	5d                   	pop    %ebp
80107206:	c3                   	ret
80107207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010720e:	00 
8010720f:	90                   	nop

80107210 <kvmalloc>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107216:	e8 75 ff ff ff       	call   80107190 <setupkvm>
8010721b:	a3 44 46 11 80       	mov    %eax,0x80114644
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107220:	05 00 00 00 80       	add    $0x80000000,%eax
80107225:	0f 22 d8             	mov    %eax,%cr3
}
80107228:	c9                   	leave
80107229:	c3                   	ret
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107230 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	83 ec 08             	sub    $0x8,%esp
80107236:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107239:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010723c:	89 c1                	mov    %eax,%ecx
8010723e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107241:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107244:	f6 c2 01             	test   $0x1,%dl
80107247:	75 17                	jne    80107260 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107249:	83 ec 0c             	sub    $0xc,%esp
8010724c:	68 c1 79 10 80       	push   $0x801079c1
80107251:	e8 2a 91 ff ff       	call   80100380 <panic>
80107256:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010725d:	00 
8010725e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107260:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107263:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107269:	25 fc 0f 00 00       	and    $0xffc,%eax
8010726e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107275:	85 c0                	test   %eax,%eax
80107277:	74 d0                	je     80107249 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107279:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010727c:	c9                   	leave
8010727d:	c3                   	ret
8010727e:	66 90                	xchg   %ax,%ax

80107280 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	56                   	push   %esi
80107285:	53                   	push   %ebx
80107286:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107289:	e8 02 ff ff ff       	call   80107190 <setupkvm>
8010728e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107291:	85 c0                	test   %eax,%eax
80107293:	0f 84 bd 00 00 00    	je     80107356 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107299:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010729c:	85 c9                	test   %ecx,%ecx
8010729e:	0f 84 b2 00 00 00    	je     80107356 <copyuvm+0xd6>
801072a4:	31 f6                	xor    %esi,%esi
801072a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072ad:	00 
801072ae:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801072b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801072b3:	89 f0                	mov    %esi,%eax
801072b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801072bb:	a8 01                	test   $0x1,%al
801072bd:	75 11                	jne    801072d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801072bf:	83 ec 0c             	sub    $0xc,%esp
801072c2:	68 cb 79 10 80       	push   $0x801079cb
801072c7:	e8 b4 90 ff ff       	call   80100380 <panic>
801072cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801072d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072d7:	c1 ea 0a             	shr    $0xa,%edx
801072da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801072e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072e7:	85 c0                	test   %eax,%eax
801072e9:	74 d4                	je     801072bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801072eb:	8b 00                	mov    (%eax),%eax
801072ed:	a8 01                	test   $0x1,%al
801072ef:	0f 84 9f 00 00 00    	je     80107394 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801072f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801072f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801072fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801072ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107305:	e8 76 b3 ff ff       	call   80102680 <kalloc>
8010730a:	89 c3                	mov    %eax,%ebx
8010730c:	85 c0                	test   %eax,%eax
8010730e:	74 64                	je     80107374 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107310:	83 ec 04             	sub    $0x4,%esp
80107313:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107319:	68 00 10 00 00       	push   $0x1000
8010731e:	57                   	push   %edi
8010731f:	50                   	push   %eax
80107320:	e8 0b d5 ff ff       	call   80104830 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107325:	58                   	pop    %eax
80107326:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010732c:	5a                   	pop    %edx
8010732d:	ff 75 e4             	push   -0x1c(%ebp)
80107330:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107335:	89 f2                	mov    %esi,%edx
80107337:	50                   	push   %eax
80107338:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010733b:	e8 60 f8 ff ff       	call   80106ba0 <mappages>
80107340:	83 c4 10             	add    $0x10,%esp
80107343:	85 c0                	test   %eax,%eax
80107345:	78 21                	js     80107368 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107347:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010734d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107350:	0f 87 5a ff ff ff    	ja     801072b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107356:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010735c:	5b                   	pop    %ebx
8010735d:	5e                   	pop    %esi
8010735e:	5f                   	pop    %edi
8010735f:	5d                   	pop    %ebp
80107360:	c3                   	ret
80107361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107368:	83 ec 0c             	sub    $0xc,%esp
8010736b:	53                   	push   %ebx
8010736c:	e8 4f b1 ff ff       	call   801024c0 <kfree>
      goto bad;
80107371:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107374:	83 ec 0c             	sub    $0xc,%esp
80107377:	ff 75 e0             	push   -0x20(%ebp)
8010737a:	e8 91 fd ff ff       	call   80107110 <freevm>
  return 0;
8010737f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107386:	83 c4 10             	add    $0x10,%esp
}
80107389:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010738c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010738f:	5b                   	pop    %ebx
80107390:	5e                   	pop    %esi
80107391:	5f                   	pop    %edi
80107392:	5d                   	pop    %ebp
80107393:	c3                   	ret
      panic("copyuvm: page not present");
80107394:	83 ec 0c             	sub    $0xc,%esp
80107397:	68 e5 79 10 80       	push   $0x801079e5
8010739c:	e8 df 8f ff ff       	call   80100380 <panic>
801073a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073a8:	00 
801073a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073b9:	89 c1                	mov    %eax,%ecx
801073bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073c1:	f6 c2 01             	test   $0x1,%dl
801073c4:	0f 84 00 01 00 00    	je     801074ca <uva2ka.cold>
  return &pgtab[PTX(va)];
801073ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801073d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801073d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801073e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073ea:	05 00 00 00 80       	add    $0x80000000,%eax
801073ef:	83 fa 05             	cmp    $0x5,%edx
801073f2:	ba 00 00 00 00       	mov    $0x0,%edx
801073f7:	0f 45 c2             	cmovne %edx,%eax
}
801073fa:	c3                   	ret
801073fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107400 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 0c             	sub    $0xc,%esp
80107409:	8b 75 14             	mov    0x14(%ebp),%esi
8010740c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010740f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107412:	85 f6                	test   %esi,%esi
80107414:	75 51                	jne    80107467 <copyout+0x67>
80107416:	e9 a5 00 00 00       	jmp    801074c0 <copyout+0xc0>
8010741b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107426:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010742c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107432:	74 75                	je     801074a9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107434:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107436:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107439:	29 c3                	sub    %eax,%ebx
8010743b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107441:	39 f3                	cmp    %esi,%ebx
80107443:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107446:	29 f8                	sub    %edi,%eax
80107448:	83 ec 04             	sub    $0x4,%esp
8010744b:	01 c1                	add    %eax,%ecx
8010744d:	53                   	push   %ebx
8010744e:	52                   	push   %edx
8010744f:	51                   	push   %ecx
80107450:	e8 db d3 ff ff       	call   80104830 <memmove>
    len -= n;
    buf += n;
80107455:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107458:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010745e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107461:	01 da                	add    %ebx,%edx
  while(len > 0){
80107463:	29 de                	sub    %ebx,%esi
80107465:	74 59                	je     801074c0 <copyout+0xc0>
  if(*pde & PTE_P){
80107467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010746a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010746c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010746e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107471:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107477:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010747a:	f6 c1 01             	test   $0x1,%cl
8010747d:	0f 84 4e 00 00 00    	je     801074d1 <copyout.cold>
  return &pgtab[PTX(va)];
80107483:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107485:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010748b:	c1 eb 0c             	shr    $0xc,%ebx
8010748e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107494:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010749b:	89 d9                	mov    %ebx,%ecx
8010749d:	83 e1 05             	and    $0x5,%ecx
801074a0:	83 f9 05             	cmp    $0x5,%ecx
801074a3:	0f 84 77 ff ff ff    	je     80107420 <copyout+0x20>
  }
  return 0;
}
801074a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074b1:	5b                   	pop    %ebx
801074b2:	5e                   	pop    %esi
801074b3:	5f                   	pop    %edi
801074b4:	5d                   	pop    %ebp
801074b5:	c3                   	ret
801074b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074bd:	00 
801074be:	66 90                	xchg   %ax,%ax
801074c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074c3:	31 c0                	xor    %eax,%eax
}
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret

801074ca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801074ca:	a1 00 00 00 00       	mov    0x0,%eax
801074cf:	0f 0b                	ud2

801074d1 <copyout.cold>:
801074d1:	a1 00 00 00 00       	mov    0x0,%eax
801074d6:	0f 0b                	ud2
