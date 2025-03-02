
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc d0 7e 11 80       	mov    $0x80117ed0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 31 10 80       	mov    $0x80103190,%eax
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
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 76 10 80       	push   $0x801076e0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 c5 45 00 00       	call   80104620 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
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
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 76 10 80       	push   $0x801076e7
80100097:	50                   	push   %eax
80100098:	e8 53 44 00 00       	call   801044f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
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
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 07 47 00 00       	call   801047f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 29 46 00 00       	call   80104790 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 43 00 00       	call   80104530 <acquiresleep>
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
8010018c:	e8 7f 22 00 00       	call   80102410 <iderw>
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
801001a1:	68 ee 76 10 80       	push   $0x801076ee
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
801001be:	e8 0d 44 00 00       	call   801045d0 <holdingsleep>
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
801001d4:	e9 37 22 00 00       	jmp    80102410 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 76 10 80       	push   $0x801076ff
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
801001ff:	e8 cc 43 00 00       	call   801045d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 43 00 00       	call   80104590 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 d0 45 00 00       	call   801047f0 <acquire>
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
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 1f 45 00 00       	jmp    80104790 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 77 10 80       	push   $0x80107706
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
80100294:	e8 f7 16 00 00       	call   80101990 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 4b 45 00 00       	call   801047f0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
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
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 be 3f 00 00       	call   80104290 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 69 38 00 00       	call   80103b50 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 95 44 00 00       	call   80104790 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 ac 15 00 00       	call   801018b0 <ilock>
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
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
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
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 3f 44 00 00       	call   80104790 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 56 15 00 00       	call   801018b0 <ilock>
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
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
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
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 82 26 00 00       	call   80102a20 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 77 10 80       	push   $0x8010770d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 ae 7b 10 80 	movl   $0x80107bae,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 73 42 00 00       	call   80104640 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 77 10 80       	push   $0x80107721
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
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
8010041a:	e8 e1 5d 00 00       	call   80106200 <uartputc>
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
80100505:	e8 f6 5c 00 00       	call   80106200 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ea 5c 00 00       	call   80106200 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 de 5c 00 00       	call   80106200 <uartputc>
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
80100551:	e8 fa 43 00 00       	call   80104950 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 45 43 00 00       	call   801048b0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 77 10 80       	push   $0x80107725
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
8010059f:	e8 ec 13 00 00       	call   80101990 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 40 42 00 00       	call   801047f0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 a7 41 00 00       	call   80104790 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 be 12 00 00       	call   801018b0 <ilock>

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
80100636:	0f b6 92 00 7c 10 80 	movzbl -0x7fef8400(%edx),%edx
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
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
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
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
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
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 03 40 00 00       	call   801047f0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
80100838:	bf 38 77 10 80       	mov    $0x80107738,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 30 3f 00 00       	call   80104790 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 77 10 80       	push   $0x8010773f
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
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 58 3f 00 00       	call   801047f0 <acquire>
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
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
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
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010097f:	00 
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 bb 3d 00 00       	call   80104790 <release>
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
80100a0e:	e9 1d 3a 00 00       	jmp    80104430 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
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
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 07 39 00 00       	call   80104350 <wakeup>
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
80100a66:	68 48 77 10 80       	push   $0x80107748
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 ab 3b 00 00       	call   80104620 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 12 1b 00 00       	call   801025b0 <ioapicenable>
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
80100abc:	e8 8f 30 00 00       	call   80103b50 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 c4 23 00 00       	call   80102e90 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 f9 16 00 00       	call   801021d0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 27 04 00 00    	je     80100f09 <exec+0x459>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 c3 0d 00 00       	call   801018b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 c2 10 00 00       	call   80101bc0 <readi>
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
80100b0a:	e8 31 10 00 00       	call   80101b40 <iunlockput>
    end_op();
80100b0f:	e8 ec 23 00 00       	call   80102f00 <end_op>
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
80100b34:	e8 57 68 00 00       	call   80107390 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 d1 03 00 00    	je     80100f28 <exec+0x478>
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
80100ba3:	e8 08 66 00 00       	call   801071b0 <allocuvm>
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
80100bd9:	e8 e2 64 00 00       	call   801070c0 <loaduvm>
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
80100c01:	e8 ba 0f 00 00       	call   80101bc0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 f0 66 00 00       	call   80107310 <freevm>
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
80100c4c:	e8 ef 0e 00 00       	call   80101b40 <iunlockput>
  end_op();
80100c51:	e8 aa 22 00 00       	call   80102f00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c60:	57                   	push   %edi
80100c61:	56                   	push   %esi
80100c62:	e8 49 65 00 00       	call   801071b0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 a8 67 00 00       	call   80107430 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8d 00 00 00    	je     80100d2b <exec+0x27b>
80100c9e:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100ca4:	89 f7                	mov    %esi,%edi
80100ca6:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cac:	eb 21                	jmp    80100ccf <exec+0x21f>
80100cae:	66 90                	xchg   %ax,%ax
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
80100cd3:	e8 d8 3d 00 00       	call   80104ab0 <strlen>
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
80100ce7:	e8 c4 3d 00 00       	call   80104ab0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 03 69 00 00       	call   80107600 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 fa 65 00 00       	call   80107310 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	89 fe                	mov    %edi,%esi
80100d25:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2b:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100d32:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d34:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100d3b:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3f:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d41:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d44:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d4a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4c:	50                   	push   %eax
80100d4d:	52                   	push   %edx
80100d4e:	53                   	push   %ebx
80100d4f:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d55:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5c:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5f:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100d65:	89 9d f0 fe ff ff    	mov    %ebx,-0x110(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d6b:	e8 90 68 00 00       	call   80107600 <copyout>
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	85 c0                	test   %eax,%eax
80100d75:	78 91                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d77:	8b 45 08             	mov    0x8(%ebp),%eax
80100d7a:	8b 55 08             	mov    0x8(%ebp),%edx
80100d7d:	0f b6 00             	movzbl (%eax),%eax
80100d80:	84 c0                	test   %al,%al
80100d82:	74 1b                	je     80100d9f <exec+0x2ef>
80100d84:	89 d1                	mov    %edx,%ecx
80100d86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d8d:	00 
80100d8e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d90:	83 c1 01             	add    $0x1,%ecx
80100d93:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d95:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d98:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d9b:	84 c0                	test   %al,%al
80100d9d:	75 f1                	jne    80100d90 <exec+0x2e0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d9f:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100da5:	83 ec 04             	sub    $0x4,%esp
80100da8:	6a 10                	push   $0x10
80100daa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80100dad:	52                   	push   %edx
80100dae:	50                   	push   %eax
80100daf:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100db5:	e8 b6 3c 00 00       	call   80104a70 <safestrcpy>
  acquire(&ptable.lock);
80100dba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80100dc1:	e8 2a 3a 00 00       	call   801047f0 <acquire>
  release(&ptable.lock);
80100dc6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80100dcd:	e8 be 39 00 00       	call   80104790 <release>
  acquire(&ptable.lock);
80100dd2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80100dd9:	e8 12 3a 00 00       	call   801047f0 <acquire>
  for (int i = 0; i < history_count; i++) {
80100dde:	8b 35 58 65 11 80    	mov    0x80116558,%esi
80100de4:	83 c4 10             	add    $0x10,%esp
80100de7:	85 f6                	test   %esi,%esi
80100de9:	7e 4f                	jle    80100e3a <exec+0x38a>
    if (process_history[i].pid == curproc->pid) {
80100deb:	8b 5b 10             	mov    0x10(%ebx),%ebx
  for (int i = 0; i < history_count; i++) {
80100dee:	31 c0                	xor    %eax,%eax
80100df0:	eb 0d                	jmp    80100dff <exec+0x34f>
80100df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100df8:	83 c0 01             	add    $0x1,%eax
80100dfb:	39 f0                	cmp    %esi,%eax
80100dfd:	74 3b                	je     80100e3a <exec+0x38a>
    if (process_history[i].pid == curproc->pid) {
80100dff:	8d 14 40             	lea    (%eax,%eax,2),%edx
80100e02:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80100e09:	39 1c d5 60 65 11 80 	cmp    %ebx,-0x7fee9aa0(,%edx,8)
80100e10:	75 e6                	jne    80100df8 <exec+0x348>
      process_history[i].mem_usage = curproc->sz; // Capture memory before switching
80100e12:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
      safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80100e18:	83 ec 04             	sub    $0x4,%esp
      process_history[i].mem_usage = curproc->sz; // Capture memory before switching
80100e1b:	8b 00                	mov    (%eax),%eax
      safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80100e1d:	6a 10                	push   $0x10
80100e1f:	ff b5 e8 fe ff ff    	push   -0x118(%ebp)
      process_history[i].mem_usage = curproc->sz; // Capture memory before switching
80100e25:	89 81 74 65 11 80    	mov    %eax,-0x7fee9a8c(%ecx)
      safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80100e2b:	81 c1 64 65 11 80    	add    $0x80116564,%ecx
80100e31:	51                   	push   %ecx
80100e32:	e8 39 3c 00 00       	call   80104a70 <safestrcpy>
      break;
80100e37:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80100e3a:	83 ec 0c             	sub    $0xc,%esp
80100e3d:	68 20 2d 11 80       	push   $0x80112d20
80100e42:	e8 49 39 00 00       	call   80104790 <release>
  oldpgdir = curproc->pgdir;
80100e47:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  curproc->pgdir = pgdir;
80100e4d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100e53:	8b 5e 04             	mov    0x4(%esi),%ebx
  curproc->sz = sz;
80100e56:	89 3e                	mov    %edi,(%esi)
  curproc->pgdir = pgdir;
80100e58:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->tf->eip = elf.entry;  // main
80100e5b:	8b 46 18             	mov    0x18(%esi),%eax
80100e5e:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e64:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e67:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e6d:	8b 46 18             	mov    0x18(%esi),%eax
80100e70:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100e73:	89 34 24             	mov    %esi,(%esp)
80100e76:	e8 b5 60 00 00       	call   80106f30 <switchuvm>
  freevm(oldpgdir);
80100e7b:	89 1c 24             	mov    %ebx,(%esp)
80100e7e:	e8 8d 64 00 00       	call   80107310 <freevm>
  acquire(&ptable.lock);
80100e83:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80100e8a:	e8 61 39 00 00       	call   801047f0 <acquire>
  for (int i = 0; i < history_count; i++) {
80100e8f:	8b 1d 58 65 11 80    	mov    0x80116558,%ebx
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	85 db                	test   %ebx,%ebx
80100e9a:	7e 56                	jle    80100ef2 <exec+0x442>
      if (process_history[i].pid == curproc->pid) {
80100e9c:	8b 76 10             	mov    0x10(%esi),%esi
  for (int i = 0; i < history_count; i++) {
80100e9f:	31 c0                	xor    %eax,%eax
80100ea1:	eb 0c                	jmp    80100eaf <exec+0x3ff>
80100ea3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ea8:	83 c0 01             	add    $0x1,%eax
80100eab:	39 d8                	cmp    %ebx,%eax
80100ead:	74 43                	je     80100ef2 <exec+0x442>
      if (process_history[i].pid == curproc->pid) {
80100eaf:	8d 14 40             	lea    (%eax,%eax,2),%edx
80100eb2:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80100eb9:	39 34 d5 60 65 11 80 	cmp    %esi,-0x7fee9aa0(,%edx,8)
80100ec0:	75 e6                	jne    80100ea8 <exec+0x3f8>
          if(curproc->sz > process_history[i].mem_usage) {
80100ec2:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ec8:	8b 00                	mov    (%eax),%eax
80100eca:	3b 81 74 65 11 80    	cmp    -0x7fee9a8c(%ecx),%eax
80100ed0:	76 06                	jbe    80100ed8 <exec+0x428>
            process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
80100ed2:	89 81 74 65 11 80    	mov    %eax,-0x7fee9a8c(%ecx)
          safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80100ed8:	83 ec 04             	sub    $0x4,%esp
80100edb:	81 c1 64 65 11 80    	add    $0x80116564,%ecx
80100ee1:	6a 10                	push   $0x10
80100ee3:	ff b5 e8 fe ff ff    	push   -0x118(%ebp)
80100ee9:	51                   	push   %ecx
80100eea:	e8 81 3b 00 00       	call   80104a70 <safestrcpy>
          break;
80100eef:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	68 20 2d 11 80       	push   $0x80112d20
80100efa:	e8 91 38 00 00       	call   80104790 <release>
  return 0;
80100eff:	83 c4 10             	add    $0x10,%esp
80100f02:	31 c0                	xor    %eax,%eax
80100f04:	e9 13 fc ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100f09:	e8 f2 1f 00 00       	call   80102f00 <end_op>
    cprintf("exec: fail\n");
80100f0e:	83 ec 0c             	sub    $0xc,%esp
80100f11:	68 50 77 10 80       	push   $0x80107750
80100f16:	e8 85 f7 ff ff       	call   801006a0 <cprintf>
    return -1;
80100f1b:	83 c4 10             	add    $0x10,%esp
80100f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f23:	e9 f4 fb ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f28:	be 00 20 00 00       	mov    $0x2000,%esi
80100f2d:	31 ff                	xor    %edi,%edi
80100f2f:	e9 14 fd ff ff       	jmp    80100c48 <exec+0x198>
80100f34:	66 90                	xchg   %ax,%ax
80100f36:	66 90                	xchg   %ax,%ax
80100f38:	66 90                	xchg   %ax,%ax
80100f3a:	66 90                	xchg   %ax,%ax
80100f3c:	66 90                	xchg   %ax,%ax
80100f3e:	66 90                	xchg   %ax,%ax

80100f40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f46:	68 5c 77 10 80       	push   $0x8010775c
80100f4b:	68 60 ff 10 80       	push   $0x8010ff60
80100f50:	e8 cb 36 00 00       	call   80104620 <initlock>
}
80100f55:	83 c4 10             	add    $0x10,%esp
80100f58:	c9                   	leave
80100f59:	c3                   	ret
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f64:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100f69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f6c:	68 60 ff 10 80       	push   $0x8010ff60
80100f71:	e8 7a 38 00 00       	call   801047f0 <acquire>
80100f76:	83 c4 10             	add    $0x10,%esp
80100f79:	eb 10                	jmp    80100f8b <filealloc+0x2b>
80100f7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f80:	83 c3 18             	add    $0x18,%ebx
80100f83:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100f89:	74 25                	je     80100fb0 <filealloc+0x50>
    if(f->ref == 0){
80100f8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f8e:	85 c0                	test   %eax,%eax
80100f90:	75 ee                	jne    80100f80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f9c:	68 60 ff 10 80       	push   $0x8010ff60
80100fa1:	e8 ea 37 00 00       	call   80104790 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100fa6:	89 d8                	mov    %ebx,%eax
      return f;
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fae:	c9                   	leave
80100faf:	c3                   	ret
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fb3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fb5:	68 60 ff 10 80       	push   $0x8010ff60
80100fba:	e8 d1 37 00 00       	call   80104790 <release>
}
80100fbf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fc1:	83 c4 10             	add    $0x10,%esp
}
80100fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc7:	c9                   	leave
80100fc8:	c3                   	ret
80100fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 10             	sub    $0x10,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fda:	68 60 ff 10 80       	push   $0x8010ff60
80100fdf:	e8 0c 38 00 00       	call   801047f0 <acquire>
  if(f->ref < 1)
80100fe4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	85 c0                	test   %eax,%eax
80100fec:	7e 1a                	jle    80101008 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ff1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ff4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ff7:	68 60 ff 10 80       	push   $0x8010ff60
80100ffc:	e8 8f 37 00 00       	call   80104790 <release>
  return f;
}
80101001:	89 d8                	mov    %ebx,%eax
80101003:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101006:	c9                   	leave
80101007:	c3                   	ret
    panic("filedup");
80101008:	83 ec 0c             	sub    $0xc,%esp
8010100b:	68 63 77 10 80       	push   $0x80107763
80101010:	e8 6b f3 ff ff       	call   80100380 <panic>
80101015:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010101c:	00 
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 28             	sub    $0x28,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010102c:	68 60 ff 10 80       	push   $0x8010ff60
80101031:	e8 ba 37 00 00       	call   801047f0 <acquire>
  if(f->ref < 1)
80101036:	8b 53 04             	mov    0x4(%ebx),%edx
80101039:	83 c4 10             	add    $0x10,%esp
8010103c:	85 d2                	test   %edx,%edx
8010103e:	0f 8e a5 00 00 00    	jle    801010e9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101044:	83 ea 01             	sub    $0x1,%edx
80101047:	89 53 04             	mov    %edx,0x4(%ebx)
8010104a:	75 44                	jne    80101090 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010104c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101050:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101053:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101055:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010105b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010105e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101061:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101064:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80101069:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010106c:	e8 1f 37 00 00       	call   80104790 <release>

  if(ff.type == FD_PIPE)
80101071:	83 c4 10             	add    $0x10,%esp
80101074:	83 ff 01             	cmp    $0x1,%edi
80101077:	74 57                	je     801010d0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101079:	83 ff 02             	cmp    $0x2,%edi
8010107c:	74 2a                	je     801010a8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101081:	5b                   	pop    %ebx
80101082:	5e                   	pop    %esi
80101083:	5f                   	pop    %edi
80101084:	5d                   	pop    %ebp
80101085:	c3                   	ret
80101086:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010108d:	00 
8010108e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101090:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010109a:	5b                   	pop    %ebx
8010109b:	5e                   	pop    %esi
8010109c:	5f                   	pop    %edi
8010109d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010109e:	e9 ed 36 00 00       	jmp    80104790 <release>
801010a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
801010a8:	e8 e3 1d 00 00       	call   80102e90 <begin_op>
    iput(ff.ip);
801010ad:	83 ec 0c             	sub    $0xc,%esp
801010b0:	ff 75 e0             	push   -0x20(%ebp)
801010b3:	e8 28 09 00 00       	call   801019e0 <iput>
    end_op();
801010b8:	83 c4 10             	add    $0x10,%esp
}
801010bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010be:	5b                   	pop    %ebx
801010bf:	5e                   	pop    %esi
801010c0:	5f                   	pop    %edi
801010c1:	5d                   	pop    %ebp
    end_op();
801010c2:	e9 39 1e 00 00       	jmp    80102f00 <end_op>
801010c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801010ce:	00 
801010cf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
801010d0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010d4:	83 ec 08             	sub    $0x8,%esp
801010d7:	53                   	push   %ebx
801010d8:	56                   	push   %esi
801010d9:	e8 82 25 00 00       	call   80103660 <pipeclose>
801010de:	83 c4 10             	add    $0x10,%esp
}
801010e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e4:	5b                   	pop    %ebx
801010e5:	5e                   	pop    %esi
801010e6:	5f                   	pop    %edi
801010e7:	5d                   	pop    %ebp
801010e8:	c3                   	ret
    panic("fileclose");
801010e9:	83 ec 0c             	sub    $0xc,%esp
801010ec:	68 6b 77 10 80       	push   $0x8010776b
801010f1:	e8 8a f2 ff ff       	call   80100380 <panic>
801010f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801010fd:	00 
801010fe:	66 90                	xchg   %ax,%ax

80101100 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	53                   	push   %ebx
80101104:	83 ec 04             	sub    $0x4,%esp
80101107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010110a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010110d:	75 31                	jne    80101140 <filestat+0x40>
    ilock(f->ip);
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	ff 73 10             	push   0x10(%ebx)
80101115:	e8 96 07 00 00       	call   801018b0 <ilock>
    stati(f->ip, st);
8010111a:	58                   	pop    %eax
8010111b:	5a                   	pop    %edx
8010111c:	ff 75 0c             	push   0xc(%ebp)
8010111f:	ff 73 10             	push   0x10(%ebx)
80101122:	e8 69 0a 00 00       	call   80101b90 <stati>
    iunlock(f->ip);
80101127:	59                   	pop    %ecx
80101128:	ff 73 10             	push   0x10(%ebx)
8010112b:	e8 60 08 00 00       	call   80101990 <iunlock>
    return 0;
  }
  return -1;
}
80101130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101133:	83 c4 10             	add    $0x10,%esp
80101136:	31 c0                	xor    %eax,%eax
}
80101138:	c9                   	leave
80101139:	c3                   	ret
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101143:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101148:	c9                   	leave
80101149:	c3                   	ret
8010114a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101150 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	57                   	push   %edi
80101154:	56                   	push   %esi
80101155:	53                   	push   %ebx
80101156:	83 ec 0c             	sub    $0xc,%esp
80101159:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010115c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010115f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101162:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101166:	74 60                	je     801011c8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101168:	8b 03                	mov    (%ebx),%eax
8010116a:	83 f8 01             	cmp    $0x1,%eax
8010116d:	74 41                	je     801011b0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010116f:	83 f8 02             	cmp    $0x2,%eax
80101172:	75 5b                	jne    801011cf <fileread+0x7f>
    ilock(f->ip);
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	ff 73 10             	push   0x10(%ebx)
8010117a:	e8 31 07 00 00       	call   801018b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010117f:	57                   	push   %edi
80101180:	ff 73 14             	push   0x14(%ebx)
80101183:	56                   	push   %esi
80101184:	ff 73 10             	push   0x10(%ebx)
80101187:	e8 34 0a 00 00       	call   80101bc0 <readi>
8010118c:	83 c4 20             	add    $0x20,%esp
8010118f:	89 c6                	mov    %eax,%esi
80101191:	85 c0                	test   %eax,%eax
80101193:	7e 03                	jle    80101198 <fileread+0x48>
      f->off += r;
80101195:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101198:	83 ec 0c             	sub    $0xc,%esp
8010119b:	ff 73 10             	push   0x10(%ebx)
8010119e:	e8 ed 07 00 00       	call   80101990 <iunlock>
    return r;
801011a3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a9:	89 f0                	mov    %esi,%eax
801011ab:	5b                   	pop    %ebx
801011ac:	5e                   	pop    %esi
801011ad:	5f                   	pop    %edi
801011ae:	5d                   	pop    %ebp
801011af:	c3                   	ret
    return piperead(f->pipe, addr, n);
801011b0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b9:	5b                   	pop    %ebx
801011ba:	5e                   	pop    %esi
801011bb:	5f                   	pop    %edi
801011bc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011bd:	e9 3e 26 00 00       	jmp    80103800 <piperead>
801011c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011cd:	eb d7                	jmp    801011a6 <fileread+0x56>
  panic("fileread");
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	68 75 77 10 80       	push   $0x80107775
801011d7:	e8 a4 f1 ff ff       	call   80100380 <panic>
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
801011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011f5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801011f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011fc:	0f 84 bd 00 00 00    	je     801012bf <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101202:	8b 03                	mov    (%ebx),%eax
80101204:	83 f8 01             	cmp    $0x1,%eax
80101207:	0f 84 bf 00 00 00    	je     801012cc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010120d:	83 f8 02             	cmp    $0x2,%eax
80101210:	0f 85 c8 00 00 00    	jne    801012de <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101219:	31 f6                	xor    %esi,%esi
    while(i < n){
8010121b:	85 c0                	test   %eax,%eax
8010121d:	7f 30                	jg     8010124f <filewrite+0x6f>
8010121f:	e9 94 00 00 00       	jmp    801012b8 <filewrite+0xd8>
80101224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101228:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010122b:	83 ec 0c             	sub    $0xc,%esp
8010122e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101231:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101234:	e8 57 07 00 00       	call   80101990 <iunlock>
      end_op();
80101239:	e8 c2 1c 00 00       	call   80102f00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010123e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101241:	83 c4 10             	add    $0x10,%esp
80101244:	39 c7                	cmp    %eax,%edi
80101246:	75 5c                	jne    801012a4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101248:	01 fe                	add    %edi,%esi
    while(i < n){
8010124a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010124d:	7e 69                	jle    801012b8 <filewrite+0xd8>
      int n1 = n - i;
8010124f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101252:	b8 00 06 00 00       	mov    $0x600,%eax
80101257:	29 f7                	sub    %esi,%edi
80101259:	39 c7                	cmp    %eax,%edi
8010125b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010125e:	e8 2d 1c 00 00       	call   80102e90 <begin_op>
      ilock(f->ip);
80101263:	83 ec 0c             	sub    $0xc,%esp
80101266:	ff 73 10             	push   0x10(%ebx)
80101269:	e8 42 06 00 00       	call   801018b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010126e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101271:	57                   	push   %edi
80101272:	ff 73 14             	push   0x14(%ebx)
80101275:	01 f0                	add    %esi,%eax
80101277:	50                   	push   %eax
80101278:	ff 73 10             	push   0x10(%ebx)
8010127b:	e8 40 0a 00 00       	call   80101cc0 <writei>
80101280:	83 c4 20             	add    $0x20,%esp
80101283:	85 c0                	test   %eax,%eax
80101285:	7f a1                	jg     80101228 <filewrite+0x48>
      iunlock(f->ip);
80101287:	83 ec 0c             	sub    $0xc,%esp
8010128a:	ff 73 10             	push   0x10(%ebx)
8010128d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101290:	e8 fb 06 00 00       	call   80101990 <iunlock>
      end_op();
80101295:	e8 66 1c 00 00       	call   80102f00 <end_op>
      if(r < 0)
8010129a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010129d:	83 c4 10             	add    $0x10,%esp
801012a0:	85 c0                	test   %eax,%eax
801012a2:	75 1b                	jne    801012bf <filewrite+0xdf>
        panic("short filewrite");
801012a4:	83 ec 0c             	sub    $0xc,%esp
801012a7:	68 7e 77 10 80       	push   $0x8010777e
801012ac:	e8 cf f0 ff ff       	call   80100380 <panic>
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801012b8:	89 f0                	mov    %esi,%eax
801012ba:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801012bd:	74 05                	je     801012c4 <filewrite+0xe4>
801012bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c7:	5b                   	pop    %ebx
801012c8:	5e                   	pop    %esi
801012c9:	5f                   	pop    %edi
801012ca:	5d                   	pop    %ebp
801012cb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801012cc:	8b 43 0c             	mov    0xc(%ebx),%eax
801012cf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d5:	5b                   	pop    %ebx
801012d6:	5e                   	pop    %esi
801012d7:	5f                   	pop    %edi
801012d8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012d9:	e9 22 24 00 00       	jmp    80103700 <pipewrite>
  panic("filewrite");
801012de:	83 ec 0c             	sub    $0xc,%esp
801012e1:	68 84 77 10 80       	push   $0x80107784
801012e6:	e8 95 f0 ff ff       	call   80100380 <panic>
801012eb:	66 90                	xchg   %ax,%ax
801012ed:	66 90                	xchg   %ax,%ax
801012ef:	90                   	nop

801012f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801012f0:	55                   	push   %ebp
801012f1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801012f3:	89 d0                	mov    %edx,%eax
801012f5:	c1 e8 0c             	shr    $0xc,%eax
801012f8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801012fe:	89 e5                	mov    %esp,%ebp
80101300:	56                   	push   %esi
80101301:	53                   	push   %ebx
80101302:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101304:	83 ec 08             	sub    $0x8,%esp
80101307:	50                   	push   %eax
80101308:	51                   	push   %ecx
80101309:	e8 c2 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010130e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101310:	c1 fb 03             	sar    $0x3,%ebx
80101313:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101316:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101318:	83 e1 07             	and    $0x7,%ecx
8010131b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101320:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101326:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101328:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010132d:	85 c1                	test   %eax,%ecx
8010132f:	74 23                	je     80101354 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101331:	f7 d0                	not    %eax
  log_write(bp);
80101333:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101336:	21 c8                	and    %ecx,%eax
80101338:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010133c:	56                   	push   %esi
8010133d:	e8 2e 1d 00 00       	call   80103070 <log_write>
  brelse(bp);
80101342:	89 34 24             	mov    %esi,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	83 c4 10             	add    $0x10,%esp
8010134d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101350:	5b                   	pop    %ebx
80101351:	5e                   	pop    %esi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret
    panic("freeing free block");
80101354:	83 ec 0c             	sub    $0xc,%esp
80101357:	68 8e 77 10 80       	push   $0x8010778e
8010135c:	e8 1f f0 ff ff       	call   80100380 <panic>
80101361:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101368:	00 
80101369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101370 <balloc>:
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101379:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010137f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101382:	85 c9                	test   %ecx,%ecx
80101384:	0f 84 87 00 00 00    	je     80101411 <balloc+0xa1>
8010138a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101391:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101394:	83 ec 08             	sub    $0x8,%esp
80101397:	89 f0                	mov    %esi,%eax
80101399:	c1 f8 0c             	sar    $0xc,%eax
8010139c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801013a2:	50                   	push   %eax
801013a3:	ff 75 d8             	push   -0x28(%ebp)
801013a6:	e8 25 ed ff ff       	call   801000d0 <bread>
801013ab:	83 c4 10             	add    $0x10,%esp
801013ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013b1:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801013b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013b9:	31 c0                	xor    %eax,%eax
801013bb:	eb 2f                	jmp    801013ec <balloc+0x7c>
801013bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013c0:	89 c1                	mov    %eax,%ecx
801013c2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013ca:	83 e1 07             	and    $0x7,%ecx
801013cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013cf:	89 c1                	mov    %eax,%ecx
801013d1:	c1 f9 03             	sar    $0x3,%ecx
801013d4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013d9:	89 fa                	mov    %edi,%edx
801013db:	85 df                	test   %ebx,%edi
801013dd:	74 41                	je     80101420 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013df:	83 c0 01             	add    $0x1,%eax
801013e2:	83 c6 01             	add    $0x1,%esi
801013e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013ea:	74 05                	je     801013f1 <balloc+0x81>
801013ec:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013ef:	77 cf                	ja     801013c0 <balloc+0x50>
    brelse(bp);
801013f1:	83 ec 0c             	sub    $0xc,%esp
801013f4:	ff 75 e4             	push   -0x1c(%ebp)
801013f7:	e8 f4 ed ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013fc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101403:	83 c4 10             	add    $0x10,%esp
80101406:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101409:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
8010140f:	77 80                	ja     80101391 <balloc+0x21>
  panic("balloc: out of blocks");
80101411:	83 ec 0c             	sub    $0xc,%esp
80101414:	68 a1 77 10 80       	push   $0x801077a1
80101419:	e8 62 ef ff ff       	call   80100380 <panic>
8010141e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101423:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101426:	09 da                	or     %ebx,%edx
80101428:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010142c:	57                   	push   %edi
8010142d:	e8 3e 1c 00 00       	call   80103070 <log_write>
        brelse(bp);
80101432:	89 3c 24             	mov    %edi,(%esp)
80101435:	e8 b6 ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010143a:	58                   	pop    %eax
8010143b:	5a                   	pop    %edx
8010143c:	56                   	push   %esi
8010143d:	ff 75 d8             	push   -0x28(%ebp)
80101440:	e8 8b ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101445:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101448:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010144a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144d:	68 00 02 00 00       	push   $0x200
80101452:	6a 00                	push   $0x0
80101454:	50                   	push   %eax
80101455:	e8 56 34 00 00       	call   801048b0 <memset>
  log_write(bp);
8010145a:	89 1c 24             	mov    %ebx,(%esp)
8010145d:	e8 0e 1c 00 00       	call   80103070 <log_write>
  brelse(bp);
80101462:	89 1c 24             	mov    %ebx,(%esp)
80101465:	e8 86 ed ff ff       	call   801001f0 <brelse>
}
8010146a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010146d:	89 f0                	mov    %esi,%eax
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5f                   	pop    %edi
80101472:	5d                   	pop    %ebp
80101473:	c3                   	ret
80101474:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010147b:	00 
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101480 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	57                   	push   %edi
80101484:	89 c7                	mov    %eax,%edi
80101486:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101487:	31 f6                	xor    %esi,%esi
{
80101489:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010148a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010148f:	83 ec 28             	sub    $0x28,%esp
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101495:	68 60 09 11 80       	push   $0x80110960
8010149a:	e8 51 33 00 00       	call   801047f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010149f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801014a2:	83 c4 10             	add    $0x10,%esp
801014a5:	eb 1b                	jmp    801014c2 <iget+0x42>
801014a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014ae:	00 
801014af:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014b0:	39 3b                	cmp    %edi,(%ebx)
801014b2:	74 6c                	je     80101520 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ba:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014c0:	73 26                	jae    801014e8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014c2:	8b 43 08             	mov    0x8(%ebx),%eax
801014c5:	85 c0                	test   %eax,%eax
801014c7:	7f e7                	jg     801014b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014c9:	85 f6                	test   %esi,%esi
801014cb:	75 e7                	jne    801014b4 <iget+0x34>
801014cd:	85 c0                	test   %eax,%eax
801014cf:	75 76                	jne    80101547 <iget+0xc7>
801014d1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014d3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014d9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014df:	72 e1                	jb     801014c2 <iget+0x42>
801014e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014e8:	85 f6                	test   %esi,%esi
801014ea:	74 79                	je     80101565 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014ec:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014ef:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014f1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014f4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014fb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101502:	68 60 09 11 80       	push   $0x80110960
80101507:	e8 84 32 00 00       	call   80104790 <release>

  return ip;
8010150c:	83 c4 10             	add    $0x10,%esp
}
8010150f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101512:	89 f0                	mov    %esi,%eax
80101514:	5b                   	pop    %ebx
80101515:	5e                   	pop    %esi
80101516:	5f                   	pop    %edi
80101517:	5d                   	pop    %ebp
80101518:	c3                   	ret
80101519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101520:	39 53 04             	cmp    %edx,0x4(%ebx)
80101523:	75 8f                	jne    801014b4 <iget+0x34>
      release(&icache.lock);
80101525:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101528:	83 c0 01             	add    $0x1,%eax
      return ip;
8010152b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010152d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101532:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101535:	e8 56 32 00 00       	call   80104790 <release>
      return ip;
8010153a:	83 c4 10             	add    $0x10,%esp
}
8010153d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101540:	89 f0                	mov    %esi,%eax
80101542:	5b                   	pop    %ebx
80101543:	5e                   	pop    %esi
80101544:	5f                   	pop    %edi
80101545:	5d                   	pop    %ebp
80101546:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101547:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010154d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101553:	73 10                	jae    80101565 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101555:	8b 43 08             	mov    0x8(%ebx),%eax
80101558:	85 c0                	test   %eax,%eax
8010155a:	0f 8f 50 ff ff ff    	jg     801014b0 <iget+0x30>
80101560:	e9 68 ff ff ff       	jmp    801014cd <iget+0x4d>
    panic("iget: no inodes");
80101565:	83 ec 0c             	sub    $0xc,%esp
80101568:	68 b7 77 10 80       	push   $0x801077b7
8010156d:	e8 0e ee ff ff       	call   80100380 <panic>
80101572:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101579:	00 
8010157a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101580 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	89 c6                	mov    %eax,%esi
80101587:	53                   	push   %ebx
80101588:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010158b:	83 fa 0b             	cmp    $0xb,%edx
8010158e:	0f 86 8c 00 00 00    	jbe    80101620 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101594:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101597:	83 fb 7f             	cmp    $0x7f,%ebx
8010159a:	0f 87 a2 00 00 00    	ja     80101642 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801015a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801015a6:	85 c0                	test   %eax,%eax
801015a8:	74 5e                	je     80101608 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801015aa:	83 ec 08             	sub    $0x8,%esp
801015ad:	50                   	push   %eax
801015ae:	ff 36                	push   (%esi)
801015b0:	e8 1b eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801015b5:	83 c4 10             	add    $0x10,%esp
801015b8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801015bc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801015be:	8b 3b                	mov    (%ebx),%edi
801015c0:	85 ff                	test   %edi,%edi
801015c2:	74 1c                	je     801015e0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801015c4:	83 ec 0c             	sub    $0xc,%esp
801015c7:	52                   	push   %edx
801015c8:	e8 23 ec ff ff       	call   801001f0 <brelse>
801015cd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015d3:	89 f8                	mov    %edi,%eax
801015d5:	5b                   	pop    %ebx
801015d6:	5e                   	pop    %esi
801015d7:	5f                   	pop    %edi
801015d8:	5d                   	pop    %ebp
801015d9:	c3                   	ret
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015e3:	8b 06                	mov    (%esi),%eax
801015e5:	e8 86 fd ff ff       	call   80101370 <balloc>
      log_write(bp);
801015ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015ed:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015f0:	89 03                	mov    %eax,(%ebx)
801015f2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801015f4:	52                   	push   %edx
801015f5:	e8 76 1a 00 00       	call   80103070 <log_write>
801015fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015fd:	83 c4 10             	add    $0x10,%esp
80101600:	eb c2                	jmp    801015c4 <bmap+0x44>
80101602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101608:	8b 06                	mov    (%esi),%eax
8010160a:	e8 61 fd ff ff       	call   80101370 <balloc>
8010160f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101615:	eb 93                	jmp    801015aa <bmap+0x2a>
80101617:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010161e:	00 
8010161f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101620:	8d 5a 14             	lea    0x14(%edx),%ebx
80101623:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101627:	85 ff                	test   %edi,%edi
80101629:	75 a5                	jne    801015d0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010162b:	8b 00                	mov    (%eax),%eax
8010162d:	e8 3e fd ff ff       	call   80101370 <balloc>
80101632:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101636:	89 c7                	mov    %eax,%edi
}
80101638:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010163b:	5b                   	pop    %ebx
8010163c:	89 f8                	mov    %edi,%eax
8010163e:	5e                   	pop    %esi
8010163f:	5f                   	pop    %edi
80101640:	5d                   	pop    %ebp
80101641:	c3                   	ret
  panic("bmap: out of range");
80101642:	83 ec 0c             	sub    $0xc,%esp
80101645:	68 c7 77 10 80       	push   $0x801077c7
8010164a:	e8 31 ed ff ff       	call   80100380 <panic>
8010164f:	90                   	nop

80101650 <readsb>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	56                   	push   %esi
80101654:	53                   	push   %ebx
80101655:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101658:	83 ec 08             	sub    $0x8,%esp
8010165b:	6a 01                	push   $0x1
8010165d:	ff 75 08             	push   0x8(%ebp)
80101660:	e8 6b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101665:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101668:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010166a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010166d:	6a 1c                	push   $0x1c
8010166f:	50                   	push   %eax
80101670:	56                   	push   %esi
80101671:	e8 da 32 00 00       	call   80104950 <memmove>
  brelse(bp);
80101676:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101679:	83 c4 10             	add    $0x10,%esp
}
8010167c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010167f:	5b                   	pop    %ebx
80101680:	5e                   	pop    %esi
80101681:	5d                   	pop    %ebp
  brelse(bp);
80101682:	e9 69 eb ff ff       	jmp    801001f0 <brelse>
80101687:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010168e:	00 
8010168f:	90                   	nop

80101690 <iinit>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101699:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010169c:	68 da 77 10 80       	push   $0x801077da
801016a1:	68 60 09 11 80       	push   $0x80110960
801016a6:	e8 75 2f 00 00       	call   80104620 <initlock>
  for(i = 0; i < NINODE; i++) {
801016ab:	83 c4 10             	add    $0x10,%esp
801016ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801016b0:	83 ec 08             	sub    $0x8,%esp
801016b3:	68 e1 77 10 80       	push   $0x801077e1
801016b8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801016b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801016bf:	e8 2c 2e 00 00       	call   801044f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016c4:	83 c4 10             	add    $0x10,%esp
801016c7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801016cd:	75 e1                	jne    801016b0 <iinit+0x20>
  bp = bread(dev, 1);
801016cf:	83 ec 08             	sub    $0x8,%esp
801016d2:	6a 01                	push   $0x1
801016d4:	ff 75 08             	push   0x8(%ebp)
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016dc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016df:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016e1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016e4:	6a 1c                	push   $0x1c
801016e6:	50                   	push   %eax
801016e7:	68 b4 25 11 80       	push   $0x801125b4
801016ec:	e8 5f 32 00 00       	call   80104950 <memmove>
  brelse(bp);
801016f1:	89 1c 24             	mov    %ebx,(%esp)
801016f4:	e8 f7 ea ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016f9:	ff 35 cc 25 11 80    	push   0x801125cc
801016ff:	ff 35 c8 25 11 80    	push   0x801125c8
80101705:	ff 35 c4 25 11 80    	push   0x801125c4
8010170b:	ff 35 c0 25 11 80    	push   0x801125c0
80101711:	ff 35 bc 25 11 80    	push   0x801125bc
80101717:	ff 35 b8 25 11 80    	push   0x801125b8
8010171d:	ff 35 b4 25 11 80    	push   0x801125b4
80101723:	68 14 7c 10 80       	push   $0x80107c14
80101728:	e8 73 ef ff ff       	call   801006a0 <cprintf>
}
8010172d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101730:	83 c4 30             	add    $0x30,%esp
80101733:	c9                   	leave
80101734:	c3                   	ret
80101735:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010173c:	00 
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <ialloc>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	57                   	push   %edi
80101744:	56                   	push   %esi
80101745:	53                   	push   %ebx
80101746:	83 ec 1c             	sub    $0x1c,%esp
80101749:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010174c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101753:	8b 75 08             	mov    0x8(%ebp),%esi
80101756:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101759:	0f 86 91 00 00 00    	jbe    801017f0 <ialloc+0xb0>
8010175f:	bf 01 00 00 00       	mov    $0x1,%edi
80101764:	eb 21                	jmp    80101787 <ialloc+0x47>
80101766:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010176d:	00 
8010176e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101770:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101773:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101776:	53                   	push   %ebx
80101777:	e8 74 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010177c:	83 c4 10             	add    $0x10,%esp
8010177f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101785:	73 69                	jae    801017f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101787:	89 f8                	mov    %edi,%eax
80101789:	83 ec 08             	sub    $0x8,%esp
8010178c:	c1 e8 03             	shr    $0x3,%eax
8010178f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101795:	50                   	push   %eax
80101796:	56                   	push   %esi
80101797:	e8 34 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010179c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010179f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801017a1:	89 f8                	mov    %edi,%eax
801017a3:	83 e0 07             	and    $0x7,%eax
801017a6:	c1 e0 06             	shl    $0x6,%eax
801017a9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017b1:	75 bd                	jne    80101770 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017b3:	83 ec 04             	sub    $0x4,%esp
801017b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017b9:	6a 40                	push   $0x40
801017bb:	6a 00                	push   $0x0
801017bd:	51                   	push   %ecx
801017be:	e8 ed 30 00 00       	call   801048b0 <memset>
      dip->type = type;
801017c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017cd:	89 1c 24             	mov    %ebx,(%esp)
801017d0:	e8 9b 18 00 00       	call   80103070 <log_write>
      brelse(bp);
801017d5:	89 1c 24             	mov    %ebx,(%esp)
801017d8:	e8 13 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017dd:	83 c4 10             	add    $0x10,%esp
}
801017e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017e3:	89 fa                	mov    %edi,%edx
}
801017e5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017e6:	89 f0                	mov    %esi,%eax
}
801017e8:	5e                   	pop    %esi
801017e9:	5f                   	pop    %edi
801017ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801017eb:	e9 90 fc ff ff       	jmp    80101480 <iget>
  panic("ialloc: no inodes");
801017f0:	83 ec 0c             	sub    $0xc,%esp
801017f3:	68 e7 77 10 80       	push   $0x801077e7
801017f8:	e8 83 eb ff ff       	call   80100380 <panic>
801017fd:	8d 76 00             	lea    0x0(%esi),%esi

80101800 <iupdate>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101808:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010180b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180e:	83 ec 08             	sub    $0x8,%esp
80101811:	c1 e8 03             	shr    $0x3,%eax
80101814:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010181a:	50                   	push   %eax
8010181b:	ff 73 a4             	push   -0x5c(%ebx)
8010181e:	e8 ad e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101823:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101827:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010182f:	83 e0 07             	and    $0x7,%eax
80101832:	c1 e0 06             	shl    $0x6,%eax
80101835:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101839:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010183c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101840:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101843:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101847:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010184b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010184f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101853:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101857:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010185a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010185d:	6a 34                	push   $0x34
8010185f:	53                   	push   %ebx
80101860:	50                   	push   %eax
80101861:	e8 ea 30 00 00       	call   80104950 <memmove>
  log_write(bp);
80101866:	89 34 24             	mov    %esi,(%esp)
80101869:	e8 02 18 00 00       	call   80103070 <log_write>
  brelse(bp);
8010186e:	89 75 08             	mov    %esi,0x8(%ebp)
80101871:	83 c4 10             	add    $0x10,%esp
}
80101874:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101877:	5b                   	pop    %ebx
80101878:	5e                   	pop    %esi
80101879:	5d                   	pop    %ebp
  brelse(bp);
8010187a:	e9 71 e9 ff ff       	jmp    801001f0 <brelse>
8010187f:	90                   	nop

80101880 <idup>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	53                   	push   %ebx
80101884:	83 ec 10             	sub    $0x10,%esp
80101887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010188a:	68 60 09 11 80       	push   $0x80110960
8010188f:	e8 5c 2f 00 00       	call   801047f0 <acquire>
  ip->ref++;
80101894:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101898:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010189f:	e8 ec 2e 00 00       	call   80104790 <release>
}
801018a4:	89 d8                	mov    %ebx,%eax
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave
801018aa:	c3                   	ret
801018ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801018b0 <ilock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	0f 84 b7 00 00 00    	je     80101977 <ilock+0xc7>
801018c0:	8b 53 08             	mov    0x8(%ebx),%edx
801018c3:	85 d2                	test   %edx,%edx
801018c5:	0f 8e ac 00 00 00    	jle    80101977 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018cb:	83 ec 0c             	sub    $0xc,%esp
801018ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801018d1:	50                   	push   %eax
801018d2:	e8 59 2c 00 00       	call   80104530 <acquiresleep>
  if(ip->valid == 0){
801018d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018da:	83 c4 10             	add    $0x10,%esp
801018dd:	85 c0                	test   %eax,%eax
801018df:	74 0f                	je     801018f0 <ilock+0x40>
}
801018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018e4:	5b                   	pop    %ebx
801018e5:	5e                   	pop    %esi
801018e6:	5d                   	pop    %ebp
801018e7:	c3                   	ret
801018e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018ef:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018f0:	8b 43 04             	mov    0x4(%ebx),%eax
801018f3:	83 ec 08             	sub    $0x8,%esp
801018f6:	c1 e8 03             	shr    $0x3,%eax
801018f9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801018ff:	50                   	push   %eax
80101900:	ff 33                	push   (%ebx)
80101902:	e8 c9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101907:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010190a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010190c:	8b 43 04             	mov    0x4(%ebx),%eax
8010190f:	83 e0 07             	and    $0x7,%eax
80101912:	c1 e0 06             	shl    $0x6,%eax
80101915:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101919:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010191c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010191f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101923:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101927:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010192b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010192f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101933:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101937:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010193b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010193e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101941:	6a 34                	push   $0x34
80101943:	50                   	push   %eax
80101944:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101947:	50                   	push   %eax
80101948:	e8 03 30 00 00       	call   80104950 <memmove>
    brelse(bp);
8010194d:	89 34 24             	mov    %esi,(%esp)
80101950:	e8 9b e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101955:	83 c4 10             	add    $0x10,%esp
80101958:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010195d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101964:	0f 85 77 ff ff ff    	jne    801018e1 <ilock+0x31>
      panic("ilock: no type");
8010196a:	83 ec 0c             	sub    $0xc,%esp
8010196d:	68 ff 77 10 80       	push   $0x801077ff
80101972:	e8 09 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101977:	83 ec 0c             	sub    $0xc,%esp
8010197a:	68 f9 77 10 80       	push   $0x801077f9
8010197f:	e8 fc e9 ff ff       	call   80100380 <panic>
80101984:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010198b:	00 
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <iunlock>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	56                   	push   %esi
80101994:	53                   	push   %ebx
80101995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101998:	85 db                	test   %ebx,%ebx
8010199a:	74 28                	je     801019c4 <iunlock+0x34>
8010199c:	83 ec 0c             	sub    $0xc,%esp
8010199f:	8d 73 0c             	lea    0xc(%ebx),%esi
801019a2:	56                   	push   %esi
801019a3:	e8 28 2c 00 00       	call   801045d0 <holdingsleep>
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	85 c0                	test   %eax,%eax
801019ad:	74 15                	je     801019c4 <iunlock+0x34>
801019af:	8b 43 08             	mov    0x8(%ebx),%eax
801019b2:	85 c0                	test   %eax,%eax
801019b4:	7e 0e                	jle    801019c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019bc:	5b                   	pop    %ebx
801019bd:	5e                   	pop    %esi
801019be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019bf:	e9 cc 2b 00 00       	jmp    80104590 <releasesleep>
    panic("iunlock");
801019c4:	83 ec 0c             	sub    $0xc,%esp
801019c7:	68 0e 78 10 80       	push   $0x8010780e
801019cc:	e8 af e9 ff ff       	call   80100380 <panic>
801019d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019d8:	00 
801019d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801019e0 <iput>:
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 28             	sub    $0x28,%esp
801019e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019ef:	57                   	push   %edi
801019f0:	e8 3b 2b 00 00       	call   80104530 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	85 d2                	test   %edx,%edx
801019fd:	74 07                	je     80101a06 <iput+0x26>
801019ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a04:	74 32                	je     80101a38 <iput+0x58>
  releasesleep(&ip->lock);
80101a06:	83 ec 0c             	sub    $0xc,%esp
80101a09:	57                   	push   %edi
80101a0a:	e8 81 2b 00 00       	call   80104590 <releasesleep>
  acquire(&icache.lock);
80101a0f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a16:	e8 d5 2d 00 00       	call   801047f0 <acquire>
  ip->ref--;
80101a1b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a1f:	83 c4 10             	add    $0x10,%esp
80101a22:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2c:	5b                   	pop    %ebx
80101a2d:	5e                   	pop    %esi
80101a2e:	5f                   	pop    %edi
80101a2f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a30:	e9 5b 2d 00 00       	jmp    80104790 <release>
80101a35:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a38:	83 ec 0c             	sub    $0xc,%esp
80101a3b:	68 60 09 11 80       	push   $0x80110960
80101a40:	e8 ab 2d 00 00       	call   801047f0 <acquire>
    int r = ip->ref;
80101a45:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a48:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a4f:	e8 3c 2d 00 00       	call   80104790 <release>
    if(r == 1){
80101a54:	83 c4 10             	add    $0x10,%esp
80101a57:	83 fe 01             	cmp    $0x1,%esi
80101a5a:	75 aa                	jne    80101a06 <iput+0x26>
80101a5c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a62:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a65:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a68:	89 cf                	mov    %ecx,%edi
80101a6a:	eb 0b                	jmp    80101a77 <iput+0x97>
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a70:	83 c6 04             	add    $0x4,%esi
80101a73:	39 fe                	cmp    %edi,%esi
80101a75:	74 19                	je     80101a90 <iput+0xb0>
    if(ip->addrs[i]){
80101a77:	8b 16                	mov    (%esi),%edx
80101a79:	85 d2                	test   %edx,%edx
80101a7b:	74 f3                	je     80101a70 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a7d:	8b 03                	mov    (%ebx),%eax
80101a7f:	e8 6c f8 ff ff       	call   801012f0 <bfree>
      ip->addrs[i] = 0;
80101a84:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a8a:	eb e4                	jmp    80101a70 <iput+0x90>
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a90:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a99:	85 c0                	test   %eax,%eax
80101a9b:	75 2d                	jne    80101aca <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a9d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101aa0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101aa7:	53                   	push   %ebx
80101aa8:	e8 53 fd ff ff       	call   80101800 <iupdate>
      ip->type = 0;
80101aad:	31 c0                	xor    %eax,%eax
80101aaf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101ab3:	89 1c 24             	mov    %ebx,(%esp)
80101ab6:	e8 45 fd ff ff       	call   80101800 <iupdate>
      ip->valid = 0;
80101abb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ac2:	83 c4 10             	add    $0x10,%esp
80101ac5:	e9 3c ff ff ff       	jmp    80101a06 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aca:	83 ec 08             	sub    $0x8,%esp
80101acd:	50                   	push   %eax
80101ace:	ff 33                	push   (%ebx)
80101ad0:	e8 fb e5 ff ff       	call   801000d0 <bread>
80101ad5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ad8:	83 c4 10             	add    $0x10,%esp
80101adb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ae4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ae7:	89 cf                	mov    %ecx,%edi
80101ae9:	eb 0c                	jmp    80101af7 <iput+0x117>
80101aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101af0:	83 c6 04             	add    $0x4,%esi
80101af3:	39 f7                	cmp    %esi,%edi
80101af5:	74 0f                	je     80101b06 <iput+0x126>
      if(a[j])
80101af7:	8b 16                	mov    (%esi),%edx
80101af9:	85 d2                	test   %edx,%edx
80101afb:	74 f3                	je     80101af0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101afd:	8b 03                	mov    (%ebx),%eax
80101aff:	e8 ec f7 ff ff       	call   801012f0 <bfree>
80101b04:	eb ea                	jmp    80101af0 <iput+0x110>
    brelse(bp);
80101b06:	83 ec 0c             	sub    $0xc,%esp
80101b09:	ff 75 e4             	push   -0x1c(%ebp)
80101b0c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b0f:	e8 dc e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b14:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b1a:	8b 03                	mov    (%ebx),%eax
80101b1c:	e8 cf f7 ff ff       	call   801012f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b21:	83 c4 10             	add    $0x10,%esp
80101b24:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b2b:	00 00 00 
80101b2e:	e9 6a ff ff ff       	jmp    80101a9d <iput+0xbd>
80101b33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b3a:	00 
80101b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b40 <iunlockput>:
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	56                   	push   %esi
80101b44:	53                   	push   %ebx
80101b45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b48:	85 db                	test   %ebx,%ebx
80101b4a:	74 34                	je     80101b80 <iunlockput+0x40>
80101b4c:	83 ec 0c             	sub    $0xc,%esp
80101b4f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b52:	56                   	push   %esi
80101b53:	e8 78 2a 00 00       	call   801045d0 <holdingsleep>
80101b58:	83 c4 10             	add    $0x10,%esp
80101b5b:	85 c0                	test   %eax,%eax
80101b5d:	74 21                	je     80101b80 <iunlockput+0x40>
80101b5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b62:	85 c0                	test   %eax,%eax
80101b64:	7e 1a                	jle    80101b80 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b66:	83 ec 0c             	sub    $0xc,%esp
80101b69:	56                   	push   %esi
80101b6a:	e8 21 2a 00 00       	call   80104590 <releasesleep>
  iput(ip);
80101b6f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b72:	83 c4 10             	add    $0x10,%esp
}
80101b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5d                   	pop    %ebp
  iput(ip);
80101b7b:	e9 60 fe ff ff       	jmp    801019e0 <iput>
    panic("iunlock");
80101b80:	83 ec 0c             	sub    $0xc,%esp
80101b83:	68 0e 78 10 80       	push   $0x8010780e
80101b88:	e8 f3 e7 ff ff       	call   80100380 <panic>
80101b8d:	8d 76 00             	lea    0x0(%esi),%esi

80101b90 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	8b 55 08             	mov    0x8(%ebp),%edx
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b99:	8b 0a                	mov    (%edx),%ecx
80101b9b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b9e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ba1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ba4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ba8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bab:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101baf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bb3:	8b 52 58             	mov    0x58(%edx),%edx
80101bb6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bb9:	5d                   	pop    %ebp
80101bba:	c3                   	ret
80101bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101bc0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcf:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bd5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bd8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101be0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101be3:	0f 84 a7 00 00 00    	je     80101c90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101be9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bec:	8b 40 58             	mov    0x58(%eax),%eax
80101bef:	39 c6                	cmp    %eax,%esi
80101bf1:	0f 87 ba 00 00 00    	ja     80101cb1 <readi+0xf1>
80101bf7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bfa:	31 c9                	xor    %ecx,%ecx
80101bfc:	89 da                	mov    %ebx,%edx
80101bfe:	01 f2                	add    %esi,%edx
80101c00:	0f 92 c1             	setb   %cl
80101c03:	89 cf                	mov    %ecx,%edi
80101c05:	0f 82 a6 00 00 00    	jb     80101cb1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c0b:	89 c1                	mov    %eax,%ecx
80101c0d:	29 f1                	sub    %esi,%ecx
80101c0f:	39 d0                	cmp    %edx,%eax
80101c11:	0f 43 cb             	cmovae %ebx,%ecx
80101c14:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c17:	85 c9                	test   %ecx,%ecx
80101c19:	74 67                	je     80101c82 <readi+0xc2>
80101c1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c20:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c23:	89 f2                	mov    %esi,%edx
80101c25:	c1 ea 09             	shr    $0x9,%edx
80101c28:	89 d8                	mov    %ebx,%eax
80101c2a:	e8 51 f9 ff ff       	call   80101580 <bmap>
80101c2f:	83 ec 08             	sub    $0x8,%esp
80101c32:	50                   	push   %eax
80101c33:	ff 33                	push   (%ebx)
80101c35:	e8 96 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c3d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c42:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c44:	89 f0                	mov    %esi,%eax
80101c46:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c4b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c4d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c50:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c52:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c56:	39 d9                	cmp    %ebx,%ecx
80101c58:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c5b:	83 c4 0c             	add    $0xc,%esp
80101c5e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c5f:	01 df                	add    %ebx,%edi
80101c61:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c63:	50                   	push   %eax
80101c64:	ff 75 e0             	push   -0x20(%ebp)
80101c67:	e8 e4 2c 00 00       	call   80104950 <memmove>
    brelse(bp);
80101c6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c6f:	89 14 24             	mov    %edx,(%esp)
80101c72:	e8 79 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c77:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c7a:	83 c4 10             	add    $0x10,%esp
80101c7d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c80:	77 9e                	ja     80101c20 <readi+0x60>
  }
  return n;
80101c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c88:	5b                   	pop    %ebx
80101c89:	5e                   	pop    %esi
80101c8a:	5f                   	pop    %edi
80101c8b:	5d                   	pop    %ebp
80101c8c:	c3                   	ret
80101c8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 17                	ja     80101cb1 <readi+0xf1>
80101c9a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 0c                	je     80101cb1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ca5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101caf:	ff e0                	jmp    *%eax
      return -1;
80101cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb6:	eb cd                	jmp    80101c85 <readi+0xc5>
80101cb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cbf:	00 

80101cc0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	83 ec 1c             	sub    $0x1c,%esp
80101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ccf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cd2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cd7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cdd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ce3:	0f 84 b7 00 00 00    	je     80101da0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ce9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cec:	3b 70 58             	cmp    0x58(%eax),%esi
80101cef:	0f 87 e7 00 00 00    	ja     80101ddc <writei+0x11c>
80101cf5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cf8:	31 d2                	xor    %edx,%edx
80101cfa:	89 f8                	mov    %edi,%eax
80101cfc:	01 f0                	add    %esi,%eax
80101cfe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d01:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d06:	0f 87 d0 00 00 00    	ja     80101ddc <writei+0x11c>
80101d0c:	85 d2                	test   %edx,%edx
80101d0e:	0f 85 c8 00 00 00    	jne    80101ddc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d1b:	85 ff                	test   %edi,%edi
80101d1d:	74 72                	je     80101d91 <writei+0xd1>
80101d1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d20:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d23:	89 f2                	mov    %esi,%edx
80101d25:	c1 ea 09             	shr    $0x9,%edx
80101d28:	89 f8                	mov    %edi,%eax
80101d2a:	e8 51 f8 ff ff       	call   80101580 <bmap>
80101d2f:	83 ec 08             	sub    $0x8,%esp
80101d32:	50                   	push   %eax
80101d33:	ff 37                	push   (%edi)
80101d35:	e8 96 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d3a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d3f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d42:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d45:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d47:	89 f0                	mov    %esi,%eax
80101d49:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d4e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d50:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d54:	39 d9                	cmp    %ebx,%ecx
80101d56:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d59:	83 c4 0c             	add    $0xc,%esp
80101d5c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d5d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d5f:	ff 75 dc             	push   -0x24(%ebp)
80101d62:	50                   	push   %eax
80101d63:	e8 e8 2b 00 00       	call   80104950 <memmove>
    log_write(bp);
80101d68:	89 3c 24             	mov    %edi,(%esp)
80101d6b:	e8 00 13 00 00       	call   80103070 <log_write>
    brelse(bp);
80101d70:	89 3c 24             	mov    %edi,(%esp)
80101d73:	e8 78 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d78:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d7b:	83 c4 10             	add    $0x10,%esp
80101d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d81:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d84:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d87:	77 97                	ja     80101d20 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d8c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d8f:	77 37                	ja     80101dc8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d97:	5b                   	pop    %ebx
80101d98:	5e                   	pop    %esi
80101d99:	5f                   	pop    %edi
80101d9a:	5d                   	pop    %ebp
80101d9b:	c3                   	ret
80101d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101da0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101da4:	66 83 f8 09          	cmp    $0x9,%ax
80101da8:	77 32                	ja     80101ddc <writei+0x11c>
80101daa:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101db1:	85 c0                	test   %eax,%eax
80101db3:	74 27                	je     80101ddc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101db5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101dbf:	ff e0                	jmp    *%eax
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101dc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dcb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101dd1:	50                   	push   %eax
80101dd2:	e8 29 fa ff ff       	call   80101800 <iupdate>
80101dd7:	83 c4 10             	add    $0x10,%esp
80101dda:	eb b5                	jmp    80101d91 <writei+0xd1>
      return -1;
80101ddc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de1:	eb b1                	jmp    80101d94 <writei+0xd4>
80101de3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dea:	00 
80101deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101df0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101df6:	6a 0e                	push   $0xe
80101df8:	ff 75 0c             	push   0xc(%ebp)
80101dfb:	ff 75 08             	push   0x8(%ebp)
80101dfe:	e8 bd 2b 00 00       	call   801049c0 <strncmp>
}
80101e03:	c9                   	leave
80101e04:	c3                   	ret
80101e05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e0c:	00 
80101e0d:	8d 76 00             	lea    0x0(%esi),%esi

80101e10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 1c             	sub    $0x1c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e21:	0f 85 85 00 00 00    	jne    80101eac <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e27:	8b 53 58             	mov    0x58(%ebx),%edx
80101e2a:	31 ff                	xor    %edi,%edi
80101e2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2f:	85 d2                	test   %edx,%edx
80101e31:	74 3e                	je     80101e71 <dirlookup+0x61>
80101e33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 7e fd ff ff       	call   80101bc0 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 55                	jne    80101e9f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	74 18                	je     80101e69 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e51:	83 ec 04             	sub    $0x4,%esp
80101e54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e57:	6a 0e                	push   $0xe
80101e59:	50                   	push   %eax
80101e5a:	ff 75 0c             	push   0xc(%ebp)
80101e5d:	e8 5e 2b 00 00       	call   801049c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	85 c0                	test   %eax,%eax
80101e67:	74 17                	je     80101e80 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e69:	83 c7 10             	add    $0x10,%edi
80101e6c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e6f:	72 c7                	jb     80101e38 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e74:	31 c0                	xor    %eax,%eax
}
80101e76:	5b                   	pop    %ebx
80101e77:	5e                   	pop    %esi
80101e78:	5f                   	pop    %edi
80101e79:	5d                   	pop    %ebp
80101e7a:	c3                   	ret
80101e7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101e80:	8b 45 10             	mov    0x10(%ebp),%eax
80101e83:	85 c0                	test   %eax,%eax
80101e85:	74 05                	je     80101e8c <dirlookup+0x7c>
        *poff = off;
80101e87:	8b 45 10             	mov    0x10(%ebp),%eax
80101e8a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e8c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e90:	8b 03                	mov    (%ebx),%eax
80101e92:	e8 e9 f5 ff ff       	call   80101480 <iget>
}
80101e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e9a:	5b                   	pop    %ebx
80101e9b:	5e                   	pop    %esi
80101e9c:	5f                   	pop    %edi
80101e9d:	5d                   	pop    %ebp
80101e9e:	c3                   	ret
      panic("dirlookup read");
80101e9f:	83 ec 0c             	sub    $0xc,%esp
80101ea2:	68 28 78 10 80       	push   $0x80107828
80101ea7:	e8 d4 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101eac:	83 ec 0c             	sub    $0xc,%esp
80101eaf:	68 16 78 10 80       	push   $0x80107816
80101eb4:	e8 c7 e4 ff ff       	call   80100380 <panic>
80101eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ec0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	89 c3                	mov    %eax,%ebx
80101ec8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ecb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ece:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ed1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101ed4:	0f 84 64 01 00 00    	je     8010203e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eda:	e8 71 1c 00 00       	call   80103b50 <myproc>
  acquire(&icache.lock);
80101edf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ee2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ee5:	68 60 09 11 80       	push   $0x80110960
80101eea:	e8 01 29 00 00       	call   801047f0 <acquire>
  ip->ref++;
80101eef:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ef3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101efa:	e8 91 28 00 00       	call   80104790 <release>
80101eff:	83 c4 10             	add    $0x10,%esp
80101f02:	eb 07                	jmp    80101f0b <namex+0x4b>
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f08:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f0b:	0f b6 03             	movzbl (%ebx),%eax
80101f0e:	3c 2f                	cmp    $0x2f,%al
80101f10:	74 f6                	je     80101f08 <namex+0x48>
  if(*path == 0)
80101f12:	84 c0                	test   %al,%al
80101f14:	0f 84 06 01 00 00    	je     80102020 <namex+0x160>
  while(*path != '/' && *path != 0)
80101f1a:	0f b6 03             	movzbl (%ebx),%eax
80101f1d:	84 c0                	test   %al,%al
80101f1f:	0f 84 10 01 00 00    	je     80102035 <namex+0x175>
80101f25:	89 df                	mov    %ebx,%edi
80101f27:	3c 2f                	cmp    $0x2f,%al
80101f29:	0f 84 06 01 00 00    	je     80102035 <namex+0x175>
80101f2f:	90                   	nop
80101f30:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f34:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f37:	3c 2f                	cmp    $0x2f,%al
80101f39:	74 04                	je     80101f3f <namex+0x7f>
80101f3b:	84 c0                	test   %al,%al
80101f3d:	75 f1                	jne    80101f30 <namex+0x70>
  len = path - s;
80101f3f:	89 f8                	mov    %edi,%eax
80101f41:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f43:	83 f8 0d             	cmp    $0xd,%eax
80101f46:	0f 8e ac 00 00 00    	jle    80101ff8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f4c:	83 ec 04             	sub    $0x4,%esp
80101f4f:	6a 0e                	push   $0xe
80101f51:	53                   	push   %ebx
    path++;
80101f52:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f54:	ff 75 e4             	push   -0x1c(%ebp)
80101f57:	e8 f4 29 00 00       	call   80104950 <memmove>
80101f5c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f5f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f62:	75 0c                	jne    80101f70 <namex+0xb0>
80101f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f6b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f6e:	74 f8                	je     80101f68 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
80101f74:	e8 37 f9 ff ff       	call   801018b0 <ilock>
    if(ip->type != T_DIR){
80101f79:	83 c4 10             	add    $0x10,%esp
80101f7c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f81:	0f 85 cd 00 00 00    	jne    80102054 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f8a:	85 c0                	test   %eax,%eax
80101f8c:	74 09                	je     80101f97 <namex+0xd7>
80101f8e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f91:	0f 84 22 01 00 00    	je     801020b9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f97:	83 ec 04             	sub    $0x4,%esp
80101f9a:	6a 00                	push   $0x0
80101f9c:	ff 75 e4             	push   -0x1c(%ebp)
80101f9f:	56                   	push   %esi
80101fa0:	e8 6b fe ff ff       	call   80101e10 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	89 c7                	mov    %eax,%edi
80101fad:	85 c0                	test   %eax,%eax
80101faf:	0f 84 e1 00 00 00    	je     80102096 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fb5:	83 ec 0c             	sub    $0xc,%esp
80101fb8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fbb:	52                   	push   %edx
80101fbc:	e8 0f 26 00 00       	call   801045d0 <holdingsleep>
80101fc1:	83 c4 10             	add    $0x10,%esp
80101fc4:	85 c0                	test   %eax,%eax
80101fc6:	0f 84 30 01 00 00    	je     801020fc <namex+0x23c>
80101fcc:	8b 56 08             	mov    0x8(%esi),%edx
80101fcf:	85 d2                	test   %edx,%edx
80101fd1:	0f 8e 25 01 00 00    	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
80101fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fda:	83 ec 0c             	sub    $0xc,%esp
80101fdd:	52                   	push   %edx
80101fde:	e8 ad 25 00 00       	call   80104590 <releasesleep>
  iput(ip);
80101fe3:	89 34 24             	mov    %esi,(%esp)
80101fe6:	89 fe                	mov    %edi,%esi
80101fe8:	e8 f3 f9 ff ff       	call   801019e0 <iput>
80101fed:	83 c4 10             	add    $0x10,%esp
80101ff0:	e9 16 ff ff ff       	jmp    80101f0b <namex+0x4b>
80101ff5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ff8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ffb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ffe:	83 ec 04             	sub    $0x4,%esp
80102001:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102004:	50                   	push   %eax
80102005:	53                   	push   %ebx
    name[len] = 0;
80102006:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102008:	ff 75 e4             	push   -0x1c(%ebp)
8010200b:	e8 40 29 00 00       	call   80104950 <memmove>
    name[len] = 0;
80102010:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102013:	83 c4 10             	add    $0x10,%esp
80102016:	c6 02 00             	movb   $0x0,(%edx)
80102019:	e9 41 ff ff ff       	jmp    80101f5f <namex+0x9f>
8010201e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102020:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102023:	85 c0                	test   %eax,%eax
80102025:	0f 85 be 00 00 00    	jne    801020e9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010202b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010202e:	89 f0                	mov    %esi,%eax
80102030:	5b                   	pop    %ebx
80102031:	5e                   	pop    %esi
80102032:	5f                   	pop    %edi
80102033:	5d                   	pop    %ebp
80102034:	c3                   	ret
  while(*path != '/' && *path != 0)
80102035:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102038:	89 df                	mov    %ebx,%edi
8010203a:	31 c0                	xor    %eax,%eax
8010203c:	eb c0                	jmp    80101ffe <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010203e:	ba 01 00 00 00       	mov    $0x1,%edx
80102043:	b8 01 00 00 00       	mov    $0x1,%eax
80102048:	e8 33 f4 ff ff       	call   80101480 <iget>
8010204d:	89 c6                	mov    %eax,%esi
8010204f:	e9 b7 fe ff ff       	jmp    80101f0b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010205a:	53                   	push   %ebx
8010205b:	e8 70 25 00 00       	call   801045d0 <holdingsleep>
80102060:	83 c4 10             	add    $0x10,%esp
80102063:	85 c0                	test   %eax,%eax
80102065:	0f 84 91 00 00 00    	je     801020fc <namex+0x23c>
8010206b:	8b 46 08             	mov    0x8(%esi),%eax
8010206e:	85 c0                	test   %eax,%eax
80102070:	0f 8e 86 00 00 00    	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
80102076:	83 ec 0c             	sub    $0xc,%esp
80102079:	53                   	push   %ebx
8010207a:	e8 11 25 00 00       	call   80104590 <releasesleep>
  iput(ip);
8010207f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102082:	31 f6                	xor    %esi,%esi
  iput(ip);
80102084:	e8 57 f9 ff ff       	call   801019e0 <iput>
      return 0;
80102089:	83 c4 10             	add    $0x10,%esp
}
8010208c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208f:	89 f0                	mov    %esi,%eax
80102091:	5b                   	pop    %ebx
80102092:	5e                   	pop    %esi
80102093:	5f                   	pop    %edi
80102094:	5d                   	pop    %ebp
80102095:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010209c:	52                   	push   %edx
8010209d:	e8 2e 25 00 00       	call   801045d0 <holdingsleep>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	85 c0                	test   %eax,%eax
801020a7:	74 53                	je     801020fc <namex+0x23c>
801020a9:	8b 4e 08             	mov    0x8(%esi),%ecx
801020ac:	85 c9                	test   %ecx,%ecx
801020ae:	7e 4c                	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
801020b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801020b3:	83 ec 0c             	sub    $0xc,%esp
801020b6:	52                   	push   %edx
801020b7:	eb c1                	jmp    8010207a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020b9:	83 ec 0c             	sub    $0xc,%esp
801020bc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801020bf:	53                   	push   %ebx
801020c0:	e8 0b 25 00 00       	call   801045d0 <holdingsleep>
801020c5:	83 c4 10             	add    $0x10,%esp
801020c8:	85 c0                	test   %eax,%eax
801020ca:	74 30                	je     801020fc <namex+0x23c>
801020cc:	8b 7e 08             	mov    0x8(%esi),%edi
801020cf:	85 ff                	test   %edi,%edi
801020d1:	7e 29                	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
801020d3:	83 ec 0c             	sub    $0xc,%esp
801020d6:	53                   	push   %ebx
801020d7:	e8 b4 24 00 00       	call   80104590 <releasesleep>
}
801020dc:	83 c4 10             	add    $0x10,%esp
}
801020df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e2:	89 f0                	mov    %esi,%eax
801020e4:	5b                   	pop    %ebx
801020e5:	5e                   	pop    %esi
801020e6:	5f                   	pop    %edi
801020e7:	5d                   	pop    %ebp
801020e8:	c3                   	ret
    iput(ip);
801020e9:	83 ec 0c             	sub    $0xc,%esp
801020ec:	56                   	push   %esi
    return 0;
801020ed:	31 f6                	xor    %esi,%esi
    iput(ip);
801020ef:	e8 ec f8 ff ff       	call   801019e0 <iput>
    return 0;
801020f4:	83 c4 10             	add    $0x10,%esp
801020f7:	e9 2f ff ff ff       	jmp    8010202b <namex+0x16b>
    panic("iunlock");
801020fc:	83 ec 0c             	sub    $0xc,%esp
801020ff:	68 0e 78 10 80       	push   $0x8010780e
80102104:	e8 77 e2 ff ff       	call   80100380 <panic>
80102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102110 <dirlink>:
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	83 ec 20             	sub    $0x20,%esp
80102119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010211c:	6a 00                	push   $0x0
8010211e:	ff 75 0c             	push   0xc(%ebp)
80102121:	53                   	push   %ebx
80102122:	e8 e9 fc ff ff       	call   80101e10 <dirlookup>
80102127:	83 c4 10             	add    $0x10,%esp
8010212a:	85 c0                	test   %eax,%eax
8010212c:	75 67                	jne    80102195 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010212e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102131:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102134:	85 ff                	test   %edi,%edi
80102136:	74 29                	je     80102161 <dirlink+0x51>
80102138:	31 ff                	xor    %edi,%edi
8010213a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010213d:	eb 09                	jmp    80102148 <dirlink+0x38>
8010213f:	90                   	nop
80102140:	83 c7 10             	add    $0x10,%edi
80102143:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102146:	73 19                	jae    80102161 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102148:	6a 10                	push   $0x10
8010214a:	57                   	push   %edi
8010214b:	56                   	push   %esi
8010214c:	53                   	push   %ebx
8010214d:	e8 6e fa ff ff       	call   80101bc0 <readi>
80102152:	83 c4 10             	add    $0x10,%esp
80102155:	83 f8 10             	cmp    $0x10,%eax
80102158:	75 4e                	jne    801021a8 <dirlink+0x98>
    if(de.inum == 0)
8010215a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010215f:	75 df                	jne    80102140 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102161:	83 ec 04             	sub    $0x4,%esp
80102164:	8d 45 da             	lea    -0x26(%ebp),%eax
80102167:	6a 0e                	push   $0xe
80102169:	ff 75 0c             	push   0xc(%ebp)
8010216c:	50                   	push   %eax
8010216d:	e8 9e 28 00 00       	call   80104a10 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102172:	6a 10                	push   $0x10
  de.inum = inum;
80102174:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102177:	57                   	push   %edi
80102178:	56                   	push   %esi
80102179:	53                   	push   %ebx
  de.inum = inum;
8010217a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010217e:	e8 3d fb ff ff       	call   80101cc0 <writei>
80102183:	83 c4 20             	add    $0x20,%esp
80102186:	83 f8 10             	cmp    $0x10,%eax
80102189:	75 2a                	jne    801021b5 <dirlink+0xa5>
  return 0;
8010218b:	31 c0                	xor    %eax,%eax
}
8010218d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102190:	5b                   	pop    %ebx
80102191:	5e                   	pop    %esi
80102192:	5f                   	pop    %edi
80102193:	5d                   	pop    %ebp
80102194:	c3                   	ret
    iput(ip);
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	50                   	push   %eax
80102199:	e8 42 f8 ff ff       	call   801019e0 <iput>
    return -1;
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a6:	eb e5                	jmp    8010218d <dirlink+0x7d>
      panic("dirlink read");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 37 78 10 80       	push   $0x80107837
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 b2 7a 10 80       	push   $0x80107ab2
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021c9:	00 
801021ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021d0 <namei>:

struct inode*
namei(char *path)
{
801021d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021d1:	31 d2                	xor    %edx,%edx
{
801021d3:	89 e5                	mov    %esp,%ebp
801021d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021de:	e8 dd fc ff ff       	call   80101ec0 <namex>
}
801021e3:	c9                   	leave
801021e4:	c3                   	ret
801021e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021ec:	00 
801021ed:	8d 76 00             	lea    0x0(%esi),%esi

801021f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021f0:	55                   	push   %ebp
  return namex(path, 1, name);
801021f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021ff:	e9 bc fc ff ff       	jmp    80101ec0 <namex>
80102204:	66 90                	xchg   %ax,%ax
80102206:	66 90                	xchg   %ax,%ax
80102208:	66 90                	xchg   %ax,%ax
8010220a:	66 90                	xchg   %ax,%ax
8010220c:	66 90                	xchg   %ax,%ax
8010220e:	66 90                	xchg   %ax,%ax

80102210 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	57                   	push   %edi
80102214:	56                   	push   %esi
80102215:	53                   	push   %ebx
80102216:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102219:	85 c0                	test   %eax,%eax
8010221b:	0f 84 b4 00 00 00    	je     801022d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102221:	8b 70 08             	mov    0x8(%eax),%esi
80102224:	89 c3                	mov    %eax,%ebx
80102226:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010222c:	0f 87 96 00 00 00    	ja     801022c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102232:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102237:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010223e:	00 
8010223f:	90                   	nop
80102240:	89 ca                	mov    %ecx,%edx
80102242:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102243:	83 e0 c0             	and    $0xffffffc0,%eax
80102246:	3c 40                	cmp    $0x40,%al
80102248:	75 f6                	jne    80102240 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010224a:	31 ff                	xor    %edi,%edi
8010224c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102251:	89 f8                	mov    %edi,%eax
80102253:	ee                   	out    %al,(%dx)
80102254:	b8 01 00 00 00       	mov    $0x1,%eax
80102259:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010225e:	ee                   	out    %al,(%dx)
8010225f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102264:	89 f0                	mov    %esi,%eax
80102266:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102267:	89 f0                	mov    %esi,%eax
80102269:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010226e:	c1 f8 08             	sar    $0x8,%eax
80102271:	ee                   	out    %al,(%dx)
80102272:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102277:	89 f8                	mov    %edi,%eax
80102279:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010227a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010227e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102283:	c1 e0 04             	shl    $0x4,%eax
80102286:	83 e0 10             	and    $0x10,%eax
80102289:	83 c8 e0             	or     $0xffffffe0,%eax
8010228c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010228d:	f6 03 04             	testb  $0x4,(%ebx)
80102290:	75 16                	jne    801022a8 <idestart+0x98>
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 ca                	mov    %ecx,%edx
80102299:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010229a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5f                   	pop    %edi
801022a0:	5d                   	pop    %ebp
801022a1:	c3                   	ret
801022a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022a8:	b8 30 00 00 00       	mov    $0x30,%eax
801022ad:	89 ca                	mov    %ecx,%edx
801022af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801022b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bd:	fc                   	cld
801022be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
    panic("incorrect blockno");
801022c8:	83 ec 0c             	sub    $0xc,%esp
801022cb:	68 4d 78 10 80       	push   $0x8010784d
801022d0:	e8 ab e0 ff ff       	call   80100380 <panic>
    panic("idestart");
801022d5:	83 ec 0c             	sub    $0xc,%esp
801022d8:	68 44 78 10 80       	push   $0x80107844
801022dd:	e8 9e e0 ff ff       	call   80100380 <panic>
801022e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022e9:	00 
801022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022f0 <ideinit>:
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022f6:	68 5f 78 10 80       	push   $0x8010785f
801022fb:	68 00 26 11 80       	push   $0x80112600
80102300:	e8 1b 23 00 00       	call   80104620 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102305:	58                   	pop    %eax
80102306:	a1 84 27 11 80       	mov    0x80112784,%eax
8010230b:	5a                   	pop    %edx
8010230c:	83 e8 01             	sub    $0x1,%eax
8010230f:	50                   	push   %eax
80102310:	6a 0e                	push   $0xe
80102312:	e8 99 02 00 00       	call   801025b0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102317:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010231a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010231f:	90                   	nop
80102320:	ec                   	in     (%dx),%al
80102321:	83 e0 c0             	and    $0xffffffc0,%eax
80102324:	3c 40                	cmp    $0x40,%al
80102326:	75 f8                	jne    80102320 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102328:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010232d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102332:	ee                   	out    %al,(%dx)
80102333:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102338:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010233d:	eb 06                	jmp    80102345 <ideinit+0x55>
8010233f:	90                   	nop
  for(i=0; i<1000; i++){
80102340:	83 e9 01             	sub    $0x1,%ecx
80102343:	74 0f                	je     80102354 <ideinit+0x64>
80102345:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102346:	84 c0                	test   %al,%al
80102348:	74 f6                	je     80102340 <ideinit+0x50>
      havedisk1 = 1;
8010234a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102351:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102354:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102359:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010235e:	ee                   	out    %al,(%dx)
}
8010235f:	c9                   	leave
80102360:	c3                   	ret
80102361:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102368:	00 
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102370 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	57                   	push   %edi
80102374:	56                   	push   %esi
80102375:	53                   	push   %ebx
80102376:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102379:	68 00 26 11 80       	push   $0x80112600
8010237e:	e8 6d 24 00 00       	call   801047f0 <acquire>

  if((b = idequeue) == 0){
80102383:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102389:	83 c4 10             	add    $0x10,%esp
8010238c:	85 db                	test   %ebx,%ebx
8010238e:	74 63                	je     801023f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102390:	8b 43 58             	mov    0x58(%ebx),%eax
80102393:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102398:	8b 33                	mov    (%ebx),%esi
8010239a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801023a0:	75 2f                	jne    801023d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801023ae:	00 
801023af:	90                   	nop
801023b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023b1:	89 c1                	mov    %eax,%ecx
801023b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801023b6:	80 f9 40             	cmp    $0x40,%cl
801023b9:	75 f5                	jne    801023b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023bb:	a8 21                	test   $0x21,%al
801023bd:	75 12                	jne    801023d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801023bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801023c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023cc:	fc                   	cld
801023cd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801023cf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801023d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801023d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023d7:	83 ce 02             	or     $0x2,%esi
801023da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801023dc:	53                   	push   %ebx
801023dd:	e8 6e 1f 00 00       	call   80104350 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023e2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801023e7:	83 c4 10             	add    $0x10,%esp
801023ea:	85 c0                	test   %eax,%eax
801023ec:	74 05                	je     801023f3 <ideintr+0x83>
    idestart(idequeue);
801023ee:	e8 1d fe ff ff       	call   80102210 <idestart>
    release(&idelock);
801023f3:	83 ec 0c             	sub    $0xc,%esp
801023f6:	68 00 26 11 80       	push   $0x80112600
801023fb:	e8 90 23 00 00       	call   80104790 <release>

  release(&idelock);
}
80102400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102403:	5b                   	pop    %ebx
80102404:	5e                   	pop    %esi
80102405:	5f                   	pop    %edi
80102406:	5d                   	pop    %ebp
80102407:	c3                   	ret
80102408:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010240f:	00 

80102410 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	53                   	push   %ebx
80102414:	83 ec 10             	sub    $0x10,%esp
80102417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010241a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010241d:	50                   	push   %eax
8010241e:	e8 ad 21 00 00       	call   801045d0 <holdingsleep>
80102423:	83 c4 10             	add    $0x10,%esp
80102426:	85 c0                	test   %eax,%eax
80102428:	0f 84 c3 00 00 00    	je     801024f1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 e0 06             	and    $0x6,%eax
80102433:	83 f8 02             	cmp    $0x2,%eax
80102436:	0f 84 a8 00 00 00    	je     801024e4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010243c:	8b 53 04             	mov    0x4(%ebx),%edx
8010243f:	85 d2                	test   %edx,%edx
80102441:	74 0d                	je     80102450 <iderw+0x40>
80102443:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102448:	85 c0                	test   %eax,%eax
8010244a:	0f 84 87 00 00 00    	je     801024d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102450:	83 ec 0c             	sub    $0xc,%esp
80102453:	68 00 26 11 80       	push   $0x80112600
80102458:	e8 93 23 00 00       	call   801047f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010245d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102462:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102469:	83 c4 10             	add    $0x10,%esp
8010246c:	85 c0                	test   %eax,%eax
8010246e:	74 60                	je     801024d0 <iderw+0xc0>
80102470:	89 c2                	mov    %eax,%edx
80102472:	8b 40 58             	mov    0x58(%eax),%eax
80102475:	85 c0                	test   %eax,%eax
80102477:	75 f7                	jne    80102470 <iderw+0x60>
80102479:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010247c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010247e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102484:	74 3a                	je     801024c0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102486:	8b 03                	mov    (%ebx),%eax
80102488:	83 e0 06             	and    $0x6,%eax
8010248b:	83 f8 02             	cmp    $0x2,%eax
8010248e:	74 1b                	je     801024ab <iderw+0x9b>
    sleep(b, &idelock);
80102490:	83 ec 08             	sub    $0x8,%esp
80102493:	68 00 26 11 80       	push   $0x80112600
80102498:	53                   	push   %ebx
80102499:	e8 f2 1d 00 00       	call   80104290 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010249e:	8b 03                	mov    (%ebx),%eax
801024a0:	83 c4 10             	add    $0x10,%esp
801024a3:	83 e0 06             	and    $0x6,%eax
801024a6:	83 f8 02             	cmp    $0x2,%eax
801024a9:	75 e5                	jne    80102490 <iderw+0x80>
  }


  release(&idelock);
801024ab:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801024b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024b5:	c9                   	leave
  release(&idelock);
801024b6:	e9 d5 22 00 00       	jmp    80104790 <release>
801024bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801024c0:	89 d8                	mov    %ebx,%eax
801024c2:	e8 49 fd ff ff       	call   80102210 <idestart>
801024c7:	eb bd                	jmp    80102486 <iderw+0x76>
801024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024d0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801024d5:	eb a5                	jmp    8010247c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	68 8e 78 10 80       	push   $0x8010788e
801024df:	e8 9c de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801024e4:	83 ec 0c             	sub    $0xc,%esp
801024e7:	68 79 78 10 80       	push   $0x80107879
801024ec:	e8 8f de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801024f1:	83 ec 0c             	sub    $0xc,%esp
801024f4:	68 63 78 10 80       	push   $0x80107863
801024f9:	e8 82 de ff ff       	call   80100380 <panic>
801024fe:	66 90                	xchg   %ax,%ax

80102500 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102500:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102501:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102508:	00 c0 fe 
{
8010250b:	89 e5                	mov    %esp,%ebp
8010250d:	56                   	push   %esi
8010250e:	53                   	push   %ebx
  ioapic->reg = reg;
8010250f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102516:	00 00 00 
  return ioapic->data;
80102519:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010251f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102522:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102528:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010252e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102535:	c1 ee 10             	shr    $0x10,%esi
80102538:	89 f0                	mov    %esi,%eax
8010253a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010253d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102540:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102543:	39 c2                	cmp    %eax,%edx
80102545:	74 16                	je     8010255d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102547:	83 ec 0c             	sub    $0xc,%esp
8010254a:	68 68 7c 10 80       	push   $0x80107c68
8010254f:	e8 4c e1 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102554:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010255a:	83 c4 10             	add    $0x10,%esp
8010255d:	83 c6 21             	add    $0x21,%esi
{
80102560:	ba 10 00 00 00       	mov    $0x10,%edx
80102565:	b8 20 00 00 00       	mov    $0x20,%eax
8010256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102570:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102572:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102574:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010257a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010257d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102583:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102586:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102589:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010258c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010258e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102594:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010259b:	39 f0                	cmp    %esi,%eax
8010259d:	75 d1                	jne    80102570 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010259f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a2:	5b                   	pop    %ebx
801025a3:	5e                   	pop    %esi
801025a4:	5d                   	pop    %ebp
801025a5:	c3                   	ret
801025a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ad:	00 
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801025b0:	55                   	push   %ebp
  ioapic->reg = reg;
801025b1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801025b7:	89 e5                	mov    %esp,%ebp
801025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801025bc:	8d 50 20             	lea    0x20(%eax),%edx
801025bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025c5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025d6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025de:	89 50 10             	mov    %edx,0x10(%eax)
}
801025e1:	5d                   	pop    %ebp
801025e2:	c3                   	ret
801025e3:	66 90                	xchg   %ax,%ax
801025e5:	66 90                	xchg   %ax,%ax
801025e7:	66 90                	xchg   %ax,%ax
801025e9:	66 90                	xchg   %ax,%ax
801025eb:	66 90                	xchg   %ax,%ax
801025ed:	66 90                	xchg   %ax,%ax
801025ef:	90                   	nop

801025f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	53                   	push   %ebx
801025f4:	83 ec 04             	sub    $0x4,%esp
801025f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102600:	75 76                	jne    80102678 <kfree+0x88>
80102602:	81 fb d0 7e 11 80    	cmp    $0x80117ed0,%ebx
80102608:	72 6e                	jb     80102678 <kfree+0x88>
8010260a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102610:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102615:	77 61                	ja     80102678 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102617:	83 ec 04             	sub    $0x4,%esp
8010261a:	68 00 10 00 00       	push   $0x1000
8010261f:	6a 01                	push   $0x1
80102621:	53                   	push   %ebx
80102622:	e8 89 22 00 00       	call   801048b0 <memset>

  if(kmem.use_lock)
80102627:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	85 d2                	test   %edx,%edx
80102632:	75 1c                	jne    80102650 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102634:	a1 78 26 11 80       	mov    0x80112678,%eax
80102639:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010263b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102640:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102646:	85 c0                	test   %eax,%eax
80102648:	75 1e                	jne    80102668 <kfree+0x78>
    release(&kmem.lock);
}
8010264a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010264d:	c9                   	leave
8010264e:	c3                   	ret
8010264f:	90                   	nop
    acquire(&kmem.lock);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	68 40 26 11 80       	push   $0x80112640
80102658:	e8 93 21 00 00       	call   801047f0 <acquire>
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	eb d2                	jmp    80102634 <kfree+0x44>
80102662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102668:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010266f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102672:	c9                   	leave
    release(&kmem.lock);
80102673:	e9 18 21 00 00       	jmp    80104790 <release>
    panic("kfree");
80102678:	83 ec 0c             	sub    $0xc,%esp
8010267b:	68 ac 78 10 80       	push   $0x801078ac
80102680:	e8 fb dc ff ff       	call   80100380 <panic>
80102685:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268c:	00 
8010268d:	8d 76 00             	lea    0x0(%esi),%esi

80102690 <freerange>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102694:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102697:	8b 75 0c             	mov    0xc(%ebp),%esi
8010269a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010269b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ad:	39 de                	cmp    %ebx,%esi
801026af:	72 23                	jb     801026d4 <freerange+0x44>
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026b8:	83 ec 0c             	sub    $0xc,%esp
801026bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026c7:	50                   	push   %eax
801026c8:	e8 23 ff ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026cd:	83 c4 10             	add    $0x10,%esp
801026d0:	39 f3                	cmp    %esi,%ebx
801026d2:	76 e4                	jbe    801026b8 <freerange+0x28>
}
801026d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d7:	5b                   	pop    %ebx
801026d8:	5e                   	pop    %esi
801026d9:	5d                   	pop    %ebp
801026da:	c3                   	ret
801026db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026e0 <kinit2>:
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026e4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026e7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ea:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026fd:	39 de                	cmp    %ebx,%esi
801026ff:	72 23                	jb     80102724 <kinit2+0x44>
80102701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102711:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102717:	50                   	push   %eax
80102718:	e8 d3 fe ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	39 de                	cmp    %ebx,%esi
80102722:	73 e4                	jae    80102708 <kinit2+0x28>
  kmem.use_lock = 1;
80102724:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010272b:	00 00 00 
}
8010272e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102731:	5b                   	pop    %ebx
80102732:	5e                   	pop    %esi
80102733:	5d                   	pop    %ebp
80102734:	c3                   	ret
80102735:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010273c:	00 
8010273d:	8d 76 00             	lea    0x0(%esi),%esi

80102740 <kinit1>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
80102745:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102748:	83 ec 08             	sub    $0x8,%esp
8010274b:	68 b2 78 10 80       	push   $0x801078b2
80102750:	68 40 26 11 80       	push   $0x80112640
80102755:	e8 c6 1e 00 00       	call   80104620 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010275a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010275d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102760:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102767:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010276a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102770:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102776:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010277c:	39 de                	cmp    %ebx,%esi
8010277e:	72 1c                	jb     8010279c <kinit1+0x5c>
    kfree(p);
80102780:	83 ec 0c             	sub    $0xc,%esp
80102783:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102789:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010278f:	50                   	push   %eax
80102790:	e8 5b fe ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102795:	83 c4 10             	add    $0x10,%esp
80102798:	39 de                	cmp    %ebx,%esi
8010279a:	73 e4                	jae    80102780 <kinit1+0x40>
}
8010279c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010279f:	5b                   	pop    %ebx
801027a0:	5e                   	pop    %esi
801027a1:	5d                   	pop    %ebp
801027a2:	c3                   	ret
801027a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027aa:	00 
801027ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801027b0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801027b0:	a1 74 26 11 80       	mov    0x80112674,%eax
801027b5:	85 c0                	test   %eax,%eax
801027b7:	75 1f                	jne    801027d8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027b9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801027be:	85 c0                	test   %eax,%eax
801027c0:	74 0e                	je     801027d0 <kalloc+0x20>
    kmem.freelist = r->next;
801027c2:	8b 10                	mov    (%eax),%edx
801027c4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801027ca:	c3                   	ret
801027cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
  return (char*)r;
}
801027d0:	c3                   	ret
801027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027d8:	55                   	push   %ebp
801027d9:	89 e5                	mov    %esp,%ebp
801027db:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027de:	68 40 26 11 80       	push   $0x80112640
801027e3:	e8 08 20 00 00       	call   801047f0 <acquire>
  r = kmem.freelist;
801027e8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801027ed:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	85 c0                	test   %eax,%eax
801027f8:	74 08                	je     80102802 <kalloc+0x52>
    kmem.freelist = r->next;
801027fa:	8b 08                	mov    (%eax),%ecx
801027fc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102802:	85 d2                	test   %edx,%edx
80102804:	74 16                	je     8010281c <kalloc+0x6c>
    release(&kmem.lock);
80102806:	83 ec 0c             	sub    $0xc,%esp
80102809:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010280c:	68 40 26 11 80       	push   $0x80112640
80102811:	e8 7a 1f 00 00       	call   80104790 <release>
  return (char*)r;
80102816:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102819:	83 c4 10             	add    $0x10,%esp
}
8010281c:	c9                   	leave
8010281d:	c3                   	ret
8010281e:	66 90                	xchg   %ax,%ax

80102820 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102820:	ba 64 00 00 00       	mov    $0x64,%edx
80102825:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102826:	a8 01                	test   $0x1,%al
80102828:	0f 84 c2 00 00 00    	je     801028f0 <kbdgetc+0xd0>
{
8010282e:	55                   	push   %ebp
8010282f:	ba 60 00 00 00       	mov    $0x60,%edx
80102834:	89 e5                	mov    %esp,%ebp
80102836:	53                   	push   %ebx
80102837:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102838:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010283e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102841:	3c e0                	cmp    $0xe0,%al
80102843:	74 5b                	je     801028a0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102845:	89 da                	mov    %ebx,%edx
80102847:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010284a:	84 c0                	test   %al,%al
8010284c:	78 62                	js     801028b0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010284e:	85 d2                	test   %edx,%edx
80102850:	74 09                	je     8010285b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102852:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102855:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102858:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010285b:	0f b6 91 a0 7f 10 80 	movzbl -0x7fef8060(%ecx),%edx
  shift ^= togglecode[data];
80102862:	0f b6 81 a0 7e 10 80 	movzbl -0x7fef8160(%ecx),%eax
  shift |= shiftcode[data];
80102869:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010286b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010286d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010286f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102875:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102878:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010287b:	8b 04 85 80 7e 10 80 	mov    -0x7fef8180(,%eax,4),%eax
80102882:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102886:	74 0b                	je     80102893 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102888:	8d 50 9f             	lea    -0x61(%eax),%edx
8010288b:	83 fa 19             	cmp    $0x19,%edx
8010288e:	77 48                	ja     801028d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102890:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102896:	c9                   	leave
80102897:	c3                   	ret
80102898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010289f:	00 
    shift |= E0ESC;
801028a0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801028a3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028a5:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
801028ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ae:	c9                   	leave
801028af:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801028b0:	83 e0 7f             	and    $0x7f,%eax
801028b3:	85 d2                	test   %edx,%edx
801028b5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801028b8:	0f b6 81 a0 7f 10 80 	movzbl -0x7fef8060(%ecx),%eax
801028bf:	83 c8 40             	or     $0x40,%eax
801028c2:	0f b6 c0             	movzbl %al,%eax
801028c5:	f7 d0                	not    %eax
801028c7:	21 d8                	and    %ebx,%eax
}
801028c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028cc:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801028d1:	31 c0                	xor    %eax,%eax
}
801028d3:	c9                   	leave
801028d4:	c3                   	ret
801028d5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801028d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028db:	8d 50 20             	lea    0x20(%eax),%edx
}
801028de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028e1:	c9                   	leave
      c += 'a' - 'A';
801028e2:	83 f9 1a             	cmp    $0x1a,%ecx
801028e5:	0f 42 c2             	cmovb  %edx,%eax
}
801028e8:	c3                   	ret
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028f5:	c3                   	ret
801028f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028fd:	00 
801028fe:	66 90                	xchg   %ax,%ax

80102900 <kbdintr>:

void
kbdintr(void)
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102906:	68 20 28 10 80       	push   $0x80102820
8010290b:	e8 70 df ff ff       	call   80100880 <consoleintr>
}
80102910:	83 c4 10             	add    $0x10,%esp
80102913:	c9                   	leave
80102914:	c3                   	ret
80102915:	66 90                	xchg   %ax,%ax
80102917:	66 90                	xchg   %ax,%ax
80102919:	66 90                	xchg   %ax,%ax
8010291b:	66 90                	xchg   %ax,%ax
8010291d:	66 90                	xchg   %ax,%ax
8010291f:	90                   	nop

80102920 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102920:	a1 80 26 11 80       	mov    0x80112680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	0f 84 cb 00 00 00    	je     801029f8 <lapicinit+0xd8>
  lapic[index] = value;
8010292d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102934:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102941:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102944:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102947:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010294e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102951:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102954:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010295b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010295e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102961:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102968:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010296b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010296e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102975:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102978:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010297b:	8b 50 30             	mov    0x30(%eax),%edx
8010297e:	c1 ea 10             	shr    $0x10,%edx
80102981:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102987:	75 77                	jne    80102a00 <lapicinit+0xe0>
  lapic[index] = value;
80102989:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102990:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102996:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010299d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029d4:	8b 50 20             	mov    0x20(%eax),%edx
801029d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029de:	00 
801029df:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029e6:	80 e6 10             	and    $0x10,%dh
801029e9:	75 f5                	jne    801029e0 <lapicinit+0xc0>
  lapic[index] = value;
801029eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029f8:	c3                   	ret
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a00:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a07:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a0d:	e9 77 ff ff ff       	jmp    80102989 <lapicinit+0x69>
80102a12:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a19:	00 
80102a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a20 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a20:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 07                	je     80102a30 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a29:	8b 40 20             	mov    0x20(%eax),%eax
80102a2c:	c1 e8 18             	shr    $0x18,%eax
80102a2f:	c3                   	ret
    return 0;
80102a30:	31 c0                	xor    %eax,%eax
}
80102a32:	c3                   	ret
80102a33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a3a:	00 
80102a3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102a40 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a40:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a45:	85 c0                	test   %eax,%eax
80102a47:	74 0d                	je     80102a56 <lapiceoi+0x16>
  lapic[index] = value;
80102a49:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a53:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a56:	c3                   	ret
80102a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a5e:	00 
80102a5f:	90                   	nop

80102a60 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a60:	c3                   	ret
80102a61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a68:	00 
80102a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a70 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a71:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a76:	ba 70 00 00 00       	mov    $0x70,%edx
80102a7b:	89 e5                	mov    %esp,%ebp
80102a7d:	53                   	push   %ebx
80102a7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a84:	ee                   	out    %al,(%dx)
80102a85:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a8a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a8f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a90:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a92:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a95:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a9b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a9d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102aa0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102aa2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102aa5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102aa8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102aae:	a1 80 26 11 80       	mov    0x80112680,%eax
80102ab3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ab9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102abc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ac3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ad0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ad6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102adc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102adf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ae5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ae8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102af1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102af7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102afd:	c9                   	leave
80102afe:	c3                   	ret
80102aff:	90                   	nop

80102b00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b00:	55                   	push   %ebp
80102b01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b06:	ba 70 00 00 00       	mov    $0x70,%edx
80102b0b:	89 e5                	mov    %esp,%ebp
80102b0d:	57                   	push   %edi
80102b0e:	56                   	push   %esi
80102b0f:	53                   	push   %ebx
80102b10:	83 ec 4c             	sub    $0x4c,%esp
80102b13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b14:	ba 71 00 00 00       	mov    $0x71,%edx
80102b19:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b25:	8d 76 00             	lea    0x0(%esi),%esi
80102b28:	31 c0                	xor    %eax,%eax
80102b2a:	89 da                	mov    %ebx,%edx
80102b2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b32:	89 ca                	mov    %ecx,%edx
80102b34:	ec                   	in     (%dx),%al
80102b35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b38:	89 da                	mov    %ebx,%edx
80102b3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b40:	89 ca                	mov    %ecx,%edx
80102b42:	ec                   	in     (%dx),%al
80102b43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b46:	89 da                	mov    %ebx,%edx
80102b48:	b8 04 00 00 00       	mov    $0x4,%eax
80102b4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4e:	89 ca                	mov    %ecx,%edx
80102b50:	ec                   	in     (%dx),%al
80102b51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b54:	89 da                	mov    %ebx,%edx
80102b56:	b8 07 00 00 00       	mov    $0x7,%eax
80102b5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5c:	89 ca                	mov    %ecx,%edx
80102b5e:	ec                   	in     (%dx),%al
80102b5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b62:	89 da                	mov    %ebx,%edx
80102b64:	b8 08 00 00 00       	mov    $0x8,%eax
80102b69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6a:	89 ca                	mov    %ecx,%edx
80102b6c:	ec                   	in     (%dx),%al
80102b6d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6f:	89 da                	mov    %ebx,%edx
80102b71:	b8 09 00 00 00       	mov    $0x9,%eax
80102b76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b77:	89 ca                	mov    %ecx,%edx
80102b79:	ec                   	in     (%dx),%al
80102b7a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b7c:	89 da                	mov    %ebx,%edx
80102b7e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b84:	89 ca                	mov    %ecx,%edx
80102b86:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b87:	84 c0                	test   %al,%al
80102b89:	78 9d                	js     80102b28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b8b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b8f:	89 fa                	mov    %edi,%edx
80102b91:	0f b6 fa             	movzbl %dl,%edi
80102b94:	89 f2                	mov    %esi,%edx
80102b96:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b99:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b9d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba0:	89 da                	mov    %ebx,%edx
80102ba2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ba5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ba8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bac:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102baf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bb2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102bb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bb9:	31 c0                	xor    %eax,%eax
80102bbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbc:	89 ca                	mov    %ecx,%edx
80102bbe:	ec                   	in     (%dx),%al
80102bbf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc2:	89 da                	mov    %ebx,%edx
80102bc4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bc7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bcc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcd:	89 ca                	mov    %ecx,%edx
80102bcf:	ec                   	in     (%dx),%al
80102bd0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd3:	89 da                	mov    %ebx,%edx
80102bd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bdd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bde:	89 ca                	mov    %ecx,%edx
80102be0:	ec                   	in     (%dx),%al
80102be1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be4:	89 da                	mov    %ebx,%edx
80102be6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102be9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bef:	89 ca                	mov    %ecx,%edx
80102bf1:	ec                   	in     (%dx),%al
80102bf2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf5:	89 da                	mov    %ebx,%edx
80102bf7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bfa:	b8 08 00 00 00       	mov    $0x8,%eax
80102bff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c00:	89 ca                	mov    %ecx,%edx
80102c02:	ec                   	in     (%dx),%al
80102c03:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c06:	89 da                	mov    %ebx,%edx
80102c08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c11:	89 ca                	mov    %ecx,%edx
80102c13:	ec                   	in     (%dx),%al
80102c14:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c17:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c1d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c20:	6a 18                	push   $0x18
80102c22:	50                   	push   %eax
80102c23:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c26:	50                   	push   %eax
80102c27:	e8 d4 1c 00 00       	call   80104900 <memcmp>
80102c2c:	83 c4 10             	add    $0x10,%esp
80102c2f:	85 c0                	test   %eax,%eax
80102c31:	0f 85 f1 fe ff ff    	jne    80102b28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c37:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c3b:	75 78                	jne    80102cb5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c40:	89 c2                	mov    %eax,%edx
80102c42:	83 e0 0f             	and    $0xf,%eax
80102c45:	c1 ea 04             	shr    $0x4,%edx
80102c48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c51:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c54:	89 c2                	mov    %eax,%edx
80102c56:	83 e0 0f             	and    $0xf,%eax
80102c59:	c1 ea 04             	shr    $0x4,%edx
80102c5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c62:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c68:	89 c2                	mov    %eax,%edx
80102c6a:	83 e0 0f             	and    $0xf,%eax
80102c6d:	c1 ea 04             	shr    $0x4,%edx
80102c70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c76:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c7c:	89 c2                	mov    %eax,%edx
80102c7e:	83 e0 0f             	and    $0xf,%eax
80102c81:	c1 ea 04             	shr    $0x4,%edx
80102c84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c90:	89 c2                	mov    %eax,%edx
80102c92:	83 e0 0f             	and    $0xf,%eax
80102c95:	c1 ea 04             	shr    $0x4,%edx
80102c98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ca1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ca4:	89 c2                	mov    %eax,%edx
80102ca6:	83 e0 0f             	and    $0xf,%eax
80102ca9:	c1 ea 04             	shr    $0x4,%edx
80102cac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102caf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102cb5:	8b 75 08             	mov    0x8(%ebp),%esi
80102cb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cbb:	89 06                	mov    %eax,(%esi)
80102cbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cc0:	89 46 04             	mov    %eax,0x4(%esi)
80102cc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cc6:	89 46 08             	mov    %eax,0x8(%esi)
80102cc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ccc:	89 46 0c             	mov    %eax,0xc(%esi)
80102ccf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cd2:	89 46 10             	mov    %eax,0x10(%esi)
80102cd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cd8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cdb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce5:	5b                   	pop    %ebx
80102ce6:	5e                   	pop    %esi
80102ce7:	5f                   	pop    %edi
80102ce8:	5d                   	pop    %ebp
80102ce9:	c3                   	ret
80102cea:	66 90                	xchg   %ax,%ax
80102cec:	66 90                	xchg   %ax,%ax
80102cee:	66 90                	xchg   %ax,%ax

80102cf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cf0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102cf6:	85 c9                	test   %ecx,%ecx
80102cf8:	0f 8e 8a 00 00 00    	jle    80102d88 <install_trans+0x98>
{
80102cfe:	55                   	push   %ebp
80102cff:	89 e5                	mov    %esp,%ebp
80102d01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d02:	31 ff                	xor    %edi,%edi
{
80102d04:	56                   	push   %esi
80102d05:	53                   	push   %ebx
80102d06:	83 ec 0c             	sub    $0xc,%esp
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d10:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102d15:	83 ec 08             	sub    $0x8,%esp
80102d18:	01 f8                	add    %edi,%eax
80102d1a:	83 c0 01             	add    $0x1,%eax
80102d1d:	50                   	push   %eax
80102d1e:	ff 35 e4 26 11 80    	push   0x801126e4
80102d24:	e8 a7 d3 ff ff       	call   801000d0 <bread>
80102d29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d2b:	58                   	pop    %eax
80102d2c:	5a                   	pop    %edx
80102d2d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102d34:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d3d:	e8 8e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d4a:	68 00 02 00 00       	push   $0x200
80102d4f:	50                   	push   %eax
80102d50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d53:	50                   	push   %eax
80102d54:	e8 f7 1b 00 00       	call   80104950 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d59:	89 1c 24             	mov    %ebx,(%esp)
80102d5c:	e8 4f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d61:	89 34 24             	mov    %esi,(%esp)
80102d64:	e8 87 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d69:	89 1c 24             	mov    %ebx,(%esp)
80102d6c:	e8 7f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d71:	83 c4 10             	add    $0x10,%esp
80102d74:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102d7a:	7f 94                	jg     80102d10 <install_trans+0x20>
  }
}
80102d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d7f:	5b                   	pop    %ebx
80102d80:	5e                   	pop    %esi
80102d81:	5f                   	pop    %edi
80102d82:	5d                   	pop    %ebp
80102d83:	c3                   	ret
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d88:	c3                   	ret
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d97:	ff 35 d4 26 11 80    	push   0x801126d4
80102d9d:	ff 35 e4 26 11 80    	push   0x801126e4
80102da3:	e8 28 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102da8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102dad:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102db2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102db5:	85 c0                	test   %eax,%eax
80102db7:	7e 19                	jle    80102dd2 <write_head+0x42>
80102db9:	31 d2                	xor    %edx,%edx
80102dbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102dc0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102dc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dcb:	83 c2 01             	add    $0x1,%edx
80102dce:	39 d0                	cmp    %edx,%eax
80102dd0:	75 ee                	jne    80102dc0 <write_head+0x30>
  }
  bwrite(buf);
80102dd2:	83 ec 0c             	sub    $0xc,%esp
80102dd5:	53                   	push   %ebx
80102dd6:	e8 d5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ddb:	89 1c 24             	mov    %ebx,(%esp)
80102dde:	e8 0d d4 ff ff       	call   801001f0 <brelse>
}
80102de3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102de6:	83 c4 10             	add    $0x10,%esp
80102de9:	c9                   	leave
80102dea:	c3                   	ret
80102deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102df0 <initlog>:
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 2c             	sub    $0x2c,%esp
80102df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dfa:	68 b7 78 10 80       	push   $0x801078b7
80102dff:	68 a0 26 11 80       	push   $0x801126a0
80102e04:	e8 17 18 00 00       	call   80104620 <initlock>
  readsb(dev, &sb);
80102e09:	58                   	pop    %eax
80102e0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e0d:	5a                   	pop    %edx
80102e0e:	50                   	push   %eax
80102e0f:	53                   	push   %ebx
80102e10:	e8 3b e8 ff ff       	call   80101650 <readsb>
  log.start = sb.logstart;
80102e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e18:	59                   	pop    %ecx
  log.dev = dev;
80102e19:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102e1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e22:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102e27:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102e2d:	5a                   	pop    %edx
80102e2e:	50                   	push   %eax
80102e2f:	53                   	push   %ebx
80102e30:	e8 9b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e38:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e3b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102e41:	85 db                	test   %ebx,%ebx
80102e43:	7e 1d                	jle    80102e62 <initlog+0x72>
80102e45:	31 d2                	xor    %edx,%edx
80102e47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e4e:	00 
80102e4f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102e50:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e54:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e5b:	83 c2 01             	add    $0x1,%edx
80102e5e:	39 d3                	cmp    %edx,%ebx
80102e60:	75 ee                	jne    80102e50 <initlog+0x60>
  brelse(buf);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	50                   	push   %eax
80102e66:	e8 85 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e6b:	e8 80 fe ff ff       	call   80102cf0 <install_trans>
  log.lh.n = 0;
80102e70:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102e77:	00 00 00 
  write_head(); // clear the log
80102e7a:	e8 11 ff ff ff       	call   80102d90 <write_head>
}
80102e7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e82:	83 c4 10             	add    $0x10,%esp
80102e85:	c9                   	leave
80102e86:	c3                   	ret
80102e87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e8e:	00 
80102e8f:	90                   	nop

80102e90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e96:	68 a0 26 11 80       	push   $0x801126a0
80102e9b:	e8 50 19 00 00       	call   801047f0 <acquire>
80102ea0:	83 c4 10             	add    $0x10,%esp
80102ea3:	eb 18                	jmp    80102ebd <begin_op+0x2d>
80102ea5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ea8:	83 ec 08             	sub    $0x8,%esp
80102eab:	68 a0 26 11 80       	push   $0x801126a0
80102eb0:	68 a0 26 11 80       	push   $0x801126a0
80102eb5:	e8 d6 13 00 00       	call   80104290 <sleep>
80102eba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ebd:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102ec2:	85 c0                	test   %eax,%eax
80102ec4:	75 e2                	jne    80102ea8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ec6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102ecb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102ed1:	83 c0 01             	add    $0x1,%eax
80102ed4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ed7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eda:	83 fa 1e             	cmp    $0x1e,%edx
80102edd:	7f c9                	jg     80102ea8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102edf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ee2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102ee7:	68 a0 26 11 80       	push   $0x801126a0
80102eec:	e8 9f 18 00 00       	call   80104790 <release>
      break;
    }
  }
}
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	c9                   	leave
80102ef5:	c3                   	ret
80102ef6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102efd:	00 
80102efe:	66 90                	xchg   %ax,%ax

80102f00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	57                   	push   %edi
80102f04:	56                   	push   %esi
80102f05:	53                   	push   %ebx
80102f06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f09:	68 a0 26 11 80       	push   $0x801126a0
80102f0e:	e8 dd 18 00 00       	call   801047f0 <acquire>
  log.outstanding -= 1;
80102f13:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102f18:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102f1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f24:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102f2a:	85 f6                	test   %esi,%esi
80102f2c:	0f 85 22 01 00 00    	jne    80103054 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f32:	85 db                	test   %ebx,%ebx
80102f34:	0f 85 f6 00 00 00    	jne    80103030 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f3a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102f41:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 a0 26 11 80       	push   $0x801126a0
80102f4c:	e8 3f 18 00 00       	call   80104790 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f51:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102f57:	83 c4 10             	add    $0x10,%esp
80102f5a:	85 c9                	test   %ecx,%ecx
80102f5c:	7f 42                	jg     80102fa0 <end_op+0xa0>
    acquire(&log.lock);
80102f5e:	83 ec 0c             	sub    $0xc,%esp
80102f61:	68 a0 26 11 80       	push   $0x801126a0
80102f66:	e8 85 18 00 00       	call   801047f0 <acquire>
    wakeup(&log);
80102f6b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102f72:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102f79:	00 00 00 
    wakeup(&log);
80102f7c:	e8 cf 13 00 00       	call   80104350 <wakeup>
    release(&log.lock);
80102f81:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f88:	e8 03 18 00 00       	call   80104790 <release>
80102f8d:	83 c4 10             	add    $0x10,%esp
}
80102f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f93:	5b                   	pop    %ebx
80102f94:	5e                   	pop    %esi
80102f95:	5f                   	pop    %edi
80102f96:	5d                   	pop    %ebp
80102f97:	c3                   	ret
80102f98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f9f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fa0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102fa5:	83 ec 08             	sub    $0x8,%esp
80102fa8:	01 d8                	add    %ebx,%eax
80102faa:	83 c0 01             	add    $0x1,%eax
80102fad:	50                   	push   %eax
80102fae:	ff 35 e4 26 11 80    	push   0x801126e4
80102fb4:	e8 17 d1 ff ff       	call   801000d0 <bread>
80102fb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fbb:	58                   	pop    %eax
80102fbc:	5a                   	pop    %edx
80102fbd:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102fc4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102fca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fcd:	e8 fe d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102fd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fd5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fd7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fda:	68 00 02 00 00       	push   $0x200
80102fdf:	50                   	push   %eax
80102fe0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fe3:	50                   	push   %eax
80102fe4:	e8 67 19 00 00       	call   80104950 <memmove>
    bwrite(to);  // write the log
80102fe9:	89 34 24             	mov    %esi,(%esp)
80102fec:	e8 bf d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ff1:	89 3c 24             	mov    %edi,(%esp)
80102ff4:	e8 f7 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ff9:	89 34 24             	mov    %esi,(%esp)
80102ffc:	e8 ef d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103001:	83 c4 10             	add    $0x10,%esp
80103004:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
8010300a:	7c 94                	jl     80102fa0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010300c:	e8 7f fd ff ff       	call   80102d90 <write_head>
    install_trans(); // Now install writes to home locations
80103011:	e8 da fc ff ff       	call   80102cf0 <install_trans>
    log.lh.n = 0;
80103016:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
8010301d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103020:	e8 6b fd ff ff       	call   80102d90 <write_head>
80103025:	e9 34 ff ff ff       	jmp    80102f5e <end_op+0x5e>
8010302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103030:	83 ec 0c             	sub    $0xc,%esp
80103033:	68 a0 26 11 80       	push   $0x801126a0
80103038:	e8 13 13 00 00       	call   80104350 <wakeup>
  release(&log.lock);
8010303d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103044:	e8 47 17 00 00       	call   80104790 <release>
80103049:	83 c4 10             	add    $0x10,%esp
}
8010304c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304f:	5b                   	pop    %ebx
80103050:	5e                   	pop    %esi
80103051:	5f                   	pop    %edi
80103052:	5d                   	pop    %ebp
80103053:	c3                   	ret
    panic("log.committing");
80103054:	83 ec 0c             	sub    $0xc,%esp
80103057:	68 bb 78 10 80       	push   $0x801078bb
8010305c:	e8 1f d3 ff ff       	call   80100380 <panic>
80103061:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103068:	00 
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103070 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103077:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
8010307d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103080:	83 fa 1d             	cmp    $0x1d,%edx
80103083:	0f 8f 85 00 00 00    	jg     8010310e <log_write+0x9e>
80103089:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010308e:	83 e8 01             	sub    $0x1,%eax
80103091:	39 c2                	cmp    %eax,%edx
80103093:	7d 79                	jge    8010310e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103095:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010309a:	85 c0                	test   %eax,%eax
8010309c:	7e 7d                	jle    8010311b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010309e:	83 ec 0c             	sub    $0xc,%esp
801030a1:	68 a0 26 11 80       	push   $0x801126a0
801030a6:	e8 45 17 00 00       	call   801047f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801030ab:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	85 d2                	test   %edx,%edx
801030b6:	7e 4a                	jle    80103102 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030b8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030bb:	31 c0                	xor    %eax,%eax
801030bd:	eb 08                	jmp    801030c7 <log_write+0x57>
801030bf:	90                   	nop
801030c0:	83 c0 01             	add    $0x1,%eax
801030c3:	39 c2                	cmp    %eax,%edx
801030c5:	74 29                	je     801030f0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030c7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
801030ce:	75 f0                	jne    801030c0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030d7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030dd:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
801030e4:	c9                   	leave
  release(&log.lock);
801030e5:	e9 a6 16 00 00       	jmp    80104790 <release>
801030ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030f0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
801030f7:	83 c2 01             	add    $0x1,%edx
801030fa:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103100:	eb d5                	jmp    801030d7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103102:	8b 43 08             	mov    0x8(%ebx),%eax
80103105:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
8010310a:	75 cb                	jne    801030d7 <log_write+0x67>
8010310c:	eb e9                	jmp    801030f7 <log_write+0x87>
    panic("too big a transaction");
8010310e:	83 ec 0c             	sub    $0xc,%esp
80103111:	68 ca 78 10 80       	push   $0x801078ca
80103116:	e8 65 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010311b:	83 ec 0c             	sub    $0xc,%esp
8010311e:	68 e0 78 10 80       	push   $0x801078e0
80103123:	e8 58 d2 ff ff       	call   80100380 <panic>
80103128:	66 90                	xchg   %ax,%ax
8010312a:	66 90                	xchg   %ax,%ax
8010312c:	66 90                	xchg   %ax,%ax
8010312e:	66 90                	xchg   %ax,%ax

80103130 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	53                   	push   %ebx
80103134:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103137:	e8 f4 09 00 00       	call   80103b30 <cpuid>
8010313c:	89 c3                	mov    %eax,%ebx
8010313e:	e8 ed 09 00 00       	call   80103b30 <cpuid>
80103143:	83 ec 04             	sub    $0x4,%esp
80103146:	53                   	push   %ebx
80103147:	50                   	push   %eax
80103148:	68 fb 78 10 80       	push   $0x801078fb
8010314d:	e8 4e d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103152:	e8 d9 2c 00 00       	call   80105e30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103157:	e8 74 09 00 00       	call   80103ad0 <mycpu>
8010315c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010315e:	b8 01 00 00 00       	mov    $0x1,%eax
80103163:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010316a:	e8 a1 0c 00 00       	call   80103e10 <scheduler>
8010316f:	90                   	nop

80103170 <mpenter>:
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103176:	e8 a5 3d 00 00       	call   80106f20 <switchkvm>
  seginit();
8010317b:	e8 10 3d 00 00       	call   80106e90 <seginit>
  lapicinit();
80103180:	e8 9b f7 ff ff       	call   80102920 <lapicinit>
  mpmain();
80103185:	e8 a6 ff ff ff       	call   80103130 <mpmain>
8010318a:	66 90                	xchg   %ax,%ax
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <main>:
{
80103190:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103194:	83 e4 f0             	and    $0xfffffff0,%esp
80103197:	ff 71 fc             	push   -0x4(%ecx)
8010319a:	55                   	push   %ebp
8010319b:	89 e5                	mov    %esp,%ebp
8010319d:	53                   	push   %ebx
8010319e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010319f:	83 ec 08             	sub    $0x8,%esp
801031a2:	68 00 00 40 80       	push   $0x80400000
801031a7:	68 d0 7e 11 80       	push   $0x80117ed0
801031ac:	e8 8f f5 ff ff       	call   80102740 <kinit1>
  kvmalloc();      // kernel page table
801031b1:	e8 5a 42 00 00       	call   80107410 <kvmalloc>
  mpinit();        // detect other processors
801031b6:	e8 85 01 00 00       	call   80103340 <mpinit>
  lapicinit();     // interrupt controller
801031bb:	e8 60 f7 ff ff       	call   80102920 <lapicinit>
  seginit();       // segment descriptors
801031c0:	e8 cb 3c 00 00       	call   80106e90 <seginit>
  picinit();       // disable pic
801031c5:	e8 76 03 00 00       	call   80103540 <picinit>
  ioapicinit();    // another interrupt controller
801031ca:	e8 31 f3 ff ff       	call   80102500 <ioapicinit>
  consoleinit();   // console hardware
801031cf:	e8 8c d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801031d4:	e8 47 2f 00 00       	call   80106120 <uartinit>
  pinit();         // process table
801031d9:	e8 d2 08 00 00       	call   80103ab0 <pinit>
  tvinit();        // trap vectors
801031de:	e8 cd 2b 00 00       	call   80105db0 <tvinit>
  binit();         // buffer cache
801031e3:	e8 58 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031e8:	e8 53 dd ff ff       	call   80100f40 <fileinit>
  ideinit();       // disk 
801031ed:	e8 fe f0 ff ff       	call   801022f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031f2:	83 c4 0c             	add    $0xc,%esp
801031f5:	68 8a 00 00 00       	push   $0x8a
801031fa:	68 8c b4 10 80       	push   $0x8010b48c
801031ff:	68 00 70 00 80       	push   $0x80007000
80103204:	e8 47 17 00 00       	call   80104950 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103213:	00 00 00 
80103216:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010321b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103220:	76 7e                	jbe    801032a0 <main+0x110>
80103222:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103227:	eb 20                	jmp    80103249 <main+0xb9>
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103230:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103237:	00 00 00 
8010323a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103240:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103245:	39 c3                	cmp    %eax,%ebx
80103247:	73 57                	jae    801032a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103249:	e8 82 08 00 00       	call   80103ad0 <mycpu>
8010324e:	39 c3                	cmp    %eax,%ebx
80103250:	74 de                	je     80103230 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103252:	e8 59 f5 ff ff       	call   801027b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103257:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010325a:	c7 05 f8 6f 00 80 70 	movl   $0x80103170,0x80006ff8
80103261:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103264:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010326b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010326e:	05 00 10 00 00       	add    $0x1000,%eax
80103273:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103278:	0f b6 03             	movzbl (%ebx),%eax
8010327b:	68 00 70 00 00       	push   $0x7000
80103280:	50                   	push   %eax
80103281:	e8 ea f7 ff ff       	call   80102a70 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103286:	83 c4 10             	add    $0x10,%esp
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103290:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103296:	85 c0                	test   %eax,%eax
80103298:	74 f6                	je     80103290 <main+0x100>
8010329a:	eb 94                	jmp    80103230 <main+0xa0>
8010329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032a0:	83 ec 08             	sub    $0x8,%esp
801032a3:	68 00 00 00 8e       	push   $0x8e000000
801032a8:	68 00 00 40 80       	push   $0x80400000
801032ad:	e8 2e f4 ff ff       	call   801026e0 <kinit2>
  userinit();      // first user process
801032b2:	e8 c9 08 00 00       	call   80103b80 <userinit>
  mpmain();        // finish this processor's setup
801032b7:	e8 74 fe ff ff       	call   80103130 <mpmain>
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032cb:	53                   	push   %ebx
  e = addr+len;
801032cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032d2:	39 de                	cmp    %ebx,%esi
801032d4:	72 10                	jb     801032e6 <mpsearch1+0x26>
801032d6:	eb 50                	jmp    80103328 <mpsearch1+0x68>
801032d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032df:	00 
801032e0:	89 fe                	mov    %edi,%esi
801032e2:	39 fb                	cmp    %edi,%ebx
801032e4:	76 42                	jbe    80103328 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032e6:	83 ec 04             	sub    $0x4,%esp
801032e9:	8d 7e 10             	lea    0x10(%esi),%edi
801032ec:	6a 04                	push   $0x4
801032ee:	68 0f 79 10 80       	push   $0x8010790f
801032f3:	56                   	push   %esi
801032f4:	e8 07 16 00 00       	call   80104900 <memcmp>
801032f9:	83 c4 10             	add    $0x10,%esp
801032fc:	85 c0                	test   %eax,%eax
801032fe:	75 e0                	jne    801032e0 <mpsearch1+0x20>
80103300:	89 f2                	mov    %esi,%edx
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103308:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010330b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010330e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103310:	39 fa                	cmp    %edi,%edx
80103312:	75 f4                	jne    80103308 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103314:	84 c0                	test   %al,%al
80103316:	75 c8                	jne    801032e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103318:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010331b:	89 f0                	mov    %esi,%eax
8010331d:	5b                   	pop    %ebx
8010331e:	5e                   	pop    %esi
8010331f:	5f                   	pop    %edi
80103320:	5d                   	pop    %ebp
80103321:	c3                   	ret
80103322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010332b:	31 f6                	xor    %esi,%esi
}
8010332d:	5b                   	pop    %ebx
8010332e:	89 f0                	mov    %esi,%eax
80103330:	5e                   	pop    %esi
80103331:	5f                   	pop    %edi
80103332:	5d                   	pop    %ebp
80103333:	c3                   	ret
80103334:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010333b:	00 
8010333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103340 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
80103345:	53                   	push   %ebx
80103346:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103349:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103350:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103357:	c1 e0 08             	shl    $0x8,%eax
8010335a:	09 d0                	or     %edx,%eax
8010335c:	c1 e0 04             	shl    $0x4,%eax
8010335f:	75 1b                	jne    8010337c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103361:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103368:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010336f:	c1 e0 08             	shl    $0x8,%eax
80103372:	09 d0                	or     %edx,%eax
80103374:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103377:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010337c:	ba 00 04 00 00       	mov    $0x400,%edx
80103381:	e8 3a ff ff ff       	call   801032c0 <mpsearch1>
80103386:	89 c3                	mov    %eax,%ebx
80103388:	85 c0                	test   %eax,%eax
8010338a:	0f 84 40 01 00 00    	je     801034d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103390:	8b 73 04             	mov    0x4(%ebx),%esi
80103393:	85 f6                	test   %esi,%esi
80103395:	0f 84 25 01 00 00    	je     801034c0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010339b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010339e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801033a4:	6a 04                	push   $0x4
801033a6:	68 14 79 10 80       	push   $0x80107914
801033ab:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801033af:	e8 4c 15 00 00       	call   80104900 <memcmp>
801033b4:	83 c4 10             	add    $0x10,%esp
801033b7:	85 c0                	test   %eax,%eax
801033b9:	0f 85 01 01 00 00    	jne    801034c0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801033bf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033c6:	3c 01                	cmp    $0x1,%al
801033c8:	74 08                	je     801033d2 <mpinit+0x92>
801033ca:	3c 04                	cmp    $0x4,%al
801033cc:	0f 85 ee 00 00 00    	jne    801034c0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801033d2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033d9:	66 85 d2             	test   %dx,%dx
801033dc:	74 22                	je     80103400 <mpinit+0xc0>
801033de:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033e1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033e3:	31 d2                	xor    %edx,%edx
801033e5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033ef:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033f2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033f4:	39 c7                	cmp    %eax,%edi
801033f6:	75 f0                	jne    801033e8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033f8:	84 d2                	test   %dl,%dl
801033fa:	0f 85 c0 00 00 00    	jne    801034c0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103400:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103406:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010340b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103412:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103418:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010341d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103420:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103423:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103428:	39 d0                	cmp    %edx,%eax
8010342a:	73 15                	jae    80103441 <mpinit+0x101>
    switch(*p){
8010342c:	0f b6 08             	movzbl (%eax),%ecx
8010342f:	80 f9 02             	cmp    $0x2,%cl
80103432:	74 4c                	je     80103480 <mpinit+0x140>
80103434:	77 3a                	ja     80103470 <mpinit+0x130>
80103436:	84 c9                	test   %cl,%cl
80103438:	74 56                	je     80103490 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010343a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010343d:	39 d0                	cmp    %edx,%eax
8010343f:	72 eb                	jb     8010342c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103441:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103444:	85 f6                	test   %esi,%esi
80103446:	0f 84 d9 00 00 00    	je     80103525 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010344c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103450:	74 15                	je     80103467 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103452:	b8 70 00 00 00       	mov    $0x70,%eax
80103457:	ba 22 00 00 00       	mov    $0x22,%edx
8010345c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010345d:	ba 23 00 00 00       	mov    $0x23,%edx
80103462:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103463:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103466:	ee                   	out    %al,(%dx)
  }
}
80103467:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010346a:	5b                   	pop    %ebx
8010346b:	5e                   	pop    %esi
8010346c:	5f                   	pop    %edi
8010346d:	5d                   	pop    %ebp
8010346e:	c3                   	ret
8010346f:	90                   	nop
    switch(*p){
80103470:	83 e9 03             	sub    $0x3,%ecx
80103473:	80 f9 01             	cmp    $0x1,%cl
80103476:	76 c2                	jbe    8010343a <mpinit+0xfa>
80103478:	31 f6                	xor    %esi,%esi
8010347a:	eb ac                	jmp    80103428 <mpinit+0xe8>
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103480:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103484:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103487:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010348d:	eb 99                	jmp    80103428 <mpinit+0xe8>
8010348f:	90                   	nop
      if(ncpu < NCPU) {
80103490:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103496:	83 f9 07             	cmp    $0x7,%ecx
80103499:	7f 19                	jg     801034b4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010349b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801034a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801034a5:	83 c1 01             	add    $0x1,%ecx
801034a8:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034ae:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801034b4:	83 c0 14             	add    $0x14,%eax
      continue;
801034b7:	e9 6c ff ff ff       	jmp    80103428 <mpinit+0xe8>
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	68 19 79 10 80       	push   $0x80107919
801034c8:	e8 b3 ce ff ff       	call   80100380 <panic>
801034cd:	8d 76 00             	lea    0x0(%esi),%esi
{
801034d0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034d5:	eb 13                	jmp    801034ea <mpinit+0x1aa>
801034d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034de:	00 
801034df:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801034e0:	89 f3                	mov    %esi,%ebx
801034e2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034e8:	74 d6                	je     801034c0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ea:	83 ec 04             	sub    $0x4,%esp
801034ed:	8d 73 10             	lea    0x10(%ebx),%esi
801034f0:	6a 04                	push   $0x4
801034f2:	68 0f 79 10 80       	push   $0x8010790f
801034f7:	53                   	push   %ebx
801034f8:	e8 03 14 00 00       	call   80104900 <memcmp>
801034fd:	83 c4 10             	add    $0x10,%esp
80103500:	85 c0                	test   %eax,%eax
80103502:	75 dc                	jne    801034e0 <mpinit+0x1a0>
80103504:	89 da                	mov    %ebx,%edx
80103506:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010350d:	00 
8010350e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103510:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103513:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103516:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103518:	39 d6                	cmp    %edx,%esi
8010351a:	75 f4                	jne    80103510 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010351c:	84 c0                	test   %al,%al
8010351e:	75 c0                	jne    801034e0 <mpinit+0x1a0>
80103520:	e9 6b fe ff ff       	jmp    80103390 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103525:	83 ec 0c             	sub    $0xc,%esp
80103528:	68 9c 7c 10 80       	push   $0x80107c9c
8010352d:	e8 4e ce ff ff       	call   80100380 <panic>
80103532:	66 90                	xchg   %ax,%ax
80103534:	66 90                	xchg   %ax,%ax
80103536:	66 90                	xchg   %ax,%ax
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <picinit>:
80103540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103545:	ba 21 00 00 00       	mov    $0x21,%edx
8010354a:	ee                   	out    %al,(%dx)
8010354b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103550:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103551:	c3                   	ret
80103552:	66 90                	xchg   %ax,%ax
80103554:	66 90                	xchg   %ax,%ax
80103556:	66 90                	xchg   %ax,%ax
80103558:	66 90                	xchg   %ax,%ax
8010355a:	66 90                	xchg   %ax,%ax
8010355c:	66 90                	xchg   %ax,%ax
8010355e:	66 90                	xchg   %ax,%ax

80103560 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
80103566:	83 ec 0c             	sub    $0xc,%esp
80103569:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010356c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010356f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103575:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010357b:	e8 e0 d9 ff ff       	call   80100f60 <filealloc>
80103580:	89 03                	mov    %eax,(%ebx)
80103582:	85 c0                	test   %eax,%eax
80103584:	0f 84 a8 00 00 00    	je     80103632 <pipealloc+0xd2>
8010358a:	e8 d1 d9 ff ff       	call   80100f60 <filealloc>
8010358f:	89 06                	mov    %eax,(%esi)
80103591:	85 c0                	test   %eax,%eax
80103593:	0f 84 87 00 00 00    	je     80103620 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103599:	e8 12 f2 ff ff       	call   801027b0 <kalloc>
8010359e:	89 c7                	mov    %eax,%edi
801035a0:	85 c0                	test   %eax,%eax
801035a2:	0f 84 b0 00 00 00    	je     80103658 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801035a8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035af:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035b2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035bc:	00 00 00 
  p->nwrite = 0;
801035bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035c6:	00 00 00 
  p->nread = 0;
801035c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035d0:	00 00 00 
  initlock(&p->lock, "pipe");
801035d3:	68 31 79 10 80       	push   $0x80107931
801035d8:	50                   	push   %eax
801035d9:	e8 42 10 00 00       	call   80104620 <initlock>
  (*f0)->type = FD_PIPE;
801035de:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035e0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035e9:	8b 03                	mov    (%ebx),%eax
801035eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035ef:	8b 03                	mov    (%ebx),%eax
801035f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035f5:	8b 03                	mov    (%ebx),%eax
801035f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035fa:	8b 06                	mov    (%esi),%eax
801035fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103602:	8b 06                	mov    (%esi),%eax
80103604:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103608:	8b 06                	mov    (%esi),%eax
8010360a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010360e:	8b 06                	mov    (%esi),%eax
80103610:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103613:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103616:	31 c0                	xor    %eax,%eax
}
80103618:	5b                   	pop    %ebx
80103619:	5e                   	pop    %esi
8010361a:	5f                   	pop    %edi
8010361b:	5d                   	pop    %ebp
8010361c:	c3                   	ret
8010361d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103620:	8b 03                	mov    (%ebx),%eax
80103622:	85 c0                	test   %eax,%eax
80103624:	74 1e                	je     80103644 <pipealloc+0xe4>
    fileclose(*f0);
80103626:	83 ec 0c             	sub    $0xc,%esp
80103629:	50                   	push   %eax
8010362a:	e8 f1 d9 ff ff       	call   80101020 <fileclose>
8010362f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103632:	8b 06                	mov    (%esi),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	74 0c                	je     80103644 <pipealloc+0xe4>
    fileclose(*f1);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	50                   	push   %eax
8010363c:	e8 df d9 ff ff       	call   80101020 <fileclose>
80103641:	83 c4 10             	add    $0x10,%esp
}
80103644:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103658:	8b 03                	mov    (%ebx),%eax
8010365a:	85 c0                	test   %eax,%eax
8010365c:	75 c8                	jne    80103626 <pipealloc+0xc6>
8010365e:	eb d2                	jmp    80103632 <pipealloc+0xd2>

80103660 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
80103665:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103668:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010366b:	83 ec 0c             	sub    $0xc,%esp
8010366e:	53                   	push   %ebx
8010366f:	e8 7c 11 00 00       	call   801047f0 <acquire>
  if(writable){
80103674:	83 c4 10             	add    $0x10,%esp
80103677:	85 f6                	test   %esi,%esi
80103679:	74 65                	je     801036e0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010367b:	83 ec 0c             	sub    $0xc,%esp
8010367e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103684:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010368b:	00 00 00 
    wakeup(&p->nread);
8010368e:	50                   	push   %eax
8010368f:	e8 bc 0c 00 00       	call   80104350 <wakeup>
80103694:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103697:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010369d:	85 d2                	test   %edx,%edx
8010369f:	75 0a                	jne    801036ab <pipeclose+0x4b>
801036a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036a7:	85 c0                	test   %eax,%eax
801036a9:	74 15                	je     801036c0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b1:	5b                   	pop    %ebx
801036b2:	5e                   	pop    %esi
801036b3:	5d                   	pop    %ebp
    release(&p->lock);
801036b4:	e9 d7 10 00 00       	jmp    80104790 <release>
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	53                   	push   %ebx
801036c4:	e8 c7 10 00 00       	call   80104790 <release>
    kfree((char*)p);
801036c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036cc:	83 c4 10             	add    $0x10,%esp
}
801036cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d2:	5b                   	pop    %ebx
801036d3:	5e                   	pop    %esi
801036d4:	5d                   	pop    %ebp
    kfree((char*)p);
801036d5:	e9 16 ef ff ff       	jmp    801025f0 <kfree>
801036da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036f0:	00 00 00 
    wakeup(&p->nwrite);
801036f3:	50                   	push   %eax
801036f4:	e8 57 0c 00 00       	call   80104350 <wakeup>
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	eb 99                	jmp    80103697 <pipeclose+0x37>
801036fe:	66 90                	xchg   %ax,%ax

80103700 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 28             	sub    $0x28,%esp
80103709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010370c:	53                   	push   %ebx
8010370d:	e8 de 10 00 00       	call   801047f0 <acquire>
  for(i = 0; i < n; i++){
80103712:	8b 45 10             	mov    0x10(%ebp),%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	85 c0                	test   %eax,%eax
8010371a:	0f 8e c0 00 00 00    	jle    801037e0 <pipewrite+0xe0>
80103720:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103723:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103729:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010372f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103732:	03 45 10             	add    0x10(%ebp),%eax
80103735:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103738:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010373e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103744:	89 ca                	mov    %ecx,%edx
80103746:	05 00 02 00 00       	add    $0x200,%eax
8010374b:	39 c1                	cmp    %eax,%ecx
8010374d:	74 3f                	je     8010378e <pipewrite+0x8e>
8010374f:	eb 67                	jmp    801037b8 <pipewrite+0xb8>
80103751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103758:	e8 f3 03 00 00       	call   80103b50 <myproc>
8010375d:	8b 48 24             	mov    0x24(%eax),%ecx
80103760:	85 c9                	test   %ecx,%ecx
80103762:	75 34                	jne    80103798 <pipewrite+0x98>
      wakeup(&p->nread);
80103764:	83 ec 0c             	sub    $0xc,%esp
80103767:	57                   	push   %edi
80103768:	e8 e3 0b 00 00       	call   80104350 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010376d:	58                   	pop    %eax
8010376e:	5a                   	pop    %edx
8010376f:	53                   	push   %ebx
80103770:	56                   	push   %esi
80103771:	e8 1a 0b 00 00       	call   80104290 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103776:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010377c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103782:	83 c4 10             	add    $0x10,%esp
80103785:	05 00 02 00 00       	add    $0x200,%eax
8010378a:	39 c2                	cmp    %eax,%edx
8010378c:	75 2a                	jne    801037b8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010378e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103794:	85 c0                	test   %eax,%eax
80103796:	75 c0                	jne    80103758 <pipewrite+0x58>
        release(&p->lock);
80103798:	83 ec 0c             	sub    $0xc,%esp
8010379b:	53                   	push   %ebx
8010379c:	e8 ef 0f 00 00       	call   80104790 <release>
        return -1;
801037a1:	83 c4 10             	add    $0x10,%esp
801037a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ac:	5b                   	pop    %ebx
801037ad:	5e                   	pop    %esi
801037ae:	5f                   	pop    %edi
801037af:	5d                   	pop    %ebp
801037b0:	c3                   	ret
801037b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801037bb:	8d 4a 01             	lea    0x1(%edx),%ecx
801037be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037c4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037ca:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037cd:	83 c6 01             	add    $0x1,%esi
801037d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037d3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037d7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037da:	0f 85 58 ff ff ff    	jne    80103738 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037e9:	50                   	push   %eax
801037ea:	e8 61 0b 00 00       	call   80104350 <wakeup>
  release(&p->lock);
801037ef:	89 1c 24             	mov    %ebx,(%esp)
801037f2:	e8 99 0f 00 00       	call   80104790 <release>
  return n;
801037f7:	8b 45 10             	mov    0x10(%ebp),%eax
801037fa:	83 c4 10             	add    $0x10,%esp
801037fd:	eb aa                	jmp    801037a9 <pipewrite+0xa9>
801037ff:	90                   	nop

80103800 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	57                   	push   %edi
80103804:	56                   	push   %esi
80103805:	53                   	push   %ebx
80103806:	83 ec 18             	sub    $0x18,%esp
80103809:	8b 75 08             	mov    0x8(%ebp),%esi
8010380c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010380f:	56                   	push   %esi
80103810:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103816:	e8 d5 0f 00 00       	call   801047f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010381b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103821:	83 c4 10             	add    $0x10,%esp
80103824:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010382a:	74 2f                	je     8010385b <piperead+0x5b>
8010382c:	eb 37                	jmp    80103865 <piperead+0x65>
8010382e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103830:	e8 1b 03 00 00       	call   80103b50 <myproc>
80103835:	8b 48 24             	mov    0x24(%eax),%ecx
80103838:	85 c9                	test   %ecx,%ecx
8010383a:	0f 85 80 00 00 00    	jne    801038c0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103840:	83 ec 08             	sub    $0x8,%esp
80103843:	56                   	push   %esi
80103844:	53                   	push   %ebx
80103845:	e8 46 0a 00 00       	call   80104290 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010384a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103850:	83 c4 10             	add    $0x10,%esp
80103853:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103859:	75 0a                	jne    80103865 <piperead+0x65>
8010385b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103861:	85 c0                	test   %eax,%eax
80103863:	75 cb                	jne    80103830 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103865:	8b 55 10             	mov    0x10(%ebp),%edx
80103868:	31 db                	xor    %ebx,%ebx
8010386a:	85 d2                	test   %edx,%edx
8010386c:	7f 20                	jg     8010388e <piperead+0x8e>
8010386e:	eb 2c                	jmp    8010389c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103870:	8d 48 01             	lea    0x1(%eax),%ecx
80103873:	25 ff 01 00 00       	and    $0x1ff,%eax
80103878:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010387e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103883:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103886:	83 c3 01             	add    $0x1,%ebx
80103889:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010388c:	74 0e                	je     8010389c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010388e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103894:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010389a:	75 d4                	jne    80103870 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010389c:	83 ec 0c             	sub    $0xc,%esp
8010389f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038a5:	50                   	push   %eax
801038a6:	e8 a5 0a 00 00       	call   80104350 <wakeup>
  release(&p->lock);
801038ab:	89 34 24             	mov    %esi,(%esp)
801038ae:	e8 dd 0e 00 00       	call   80104790 <release>
  return i;
801038b3:	83 c4 10             	add    $0x10,%esp
}
801038b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b9:	89 d8                	mov    %ebx,%eax
801038bb:	5b                   	pop    %ebx
801038bc:	5e                   	pop    %esi
801038bd:	5f                   	pop    %edi
801038be:	5d                   	pop    %ebp
801038bf:	c3                   	ret
      release(&p->lock);
801038c0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038c8:	56                   	push   %esi
801038c9:	e8 c2 0e 00 00       	call   80104790 <release>
      return -1;
801038ce:	83 c4 10             	add    $0x10,%esp
}
801038d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038d4:	89 d8                	mov    %ebx,%eax
801038d6:	5b                   	pop    %ebx
801038d7:	5e                   	pop    %esi
801038d8:	5f                   	pop    %edi
801038d9:	5d                   	pop    %ebp
801038da:	c3                   	ret
801038db:	66 90                	xchg   %ax,%ax
801038dd:	66 90                	xchg   %ax,%ax
801038df:	90                   	nop

801038e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e5:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	68 20 2d 11 80       	push   $0x80112d20
801038f2:	e8 f9 0e 00 00       	call   801047f0 <acquire>
801038f7:	83 c4 10             	add    $0x10,%esp
801038fa:	eb 16                	jmp    80103912 <allocproc+0x32>
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103900:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80103906:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010390c:	0f 84 1e 01 00 00    	je     80103a30 <allocproc+0x150>
    if(p->state == UNUSED)
80103912:	8b 43 0c             	mov    0xc(%ebx),%eax
80103915:	85 c0                	test   %eax,%eax
80103917:	75 e7                	jne    80103900 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103919:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010391e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103921:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103928:	89 43 10             	mov    %eax,0x10(%ebx)
8010392b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010392e:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103933:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103939:	e8 52 0e 00 00       	call   80104790 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010393e:	e8 6d ee ff ff       	call   801027b0 <kalloc>
80103943:	83 c4 10             	add    $0x10,%esp
80103946:	89 43 08             	mov    %eax,0x8(%ebx)
80103949:	85 c0                	test   %eax,%eax
8010394b:	0f 84 fa 00 00 00    	je     80103a4b <allocproc+0x16b>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103951:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103957:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010395a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010395f:	89 53 18             	mov    %edx,0x18(%ebx)
  p->context->eip = (uint)forkret;

  // Make sure process name is set before adding to history
  safestrcpy(p->name, "unknown", sizeof(p->name));  // Default name
80103962:	8d 73 6c             	lea    0x6c(%ebx),%esi
  *(uint*)sp = (uint)trapret;
80103965:	c7 40 14 9f 5d 10 80 	movl   $0x80105d9f,0x14(%eax)
  p->context = (struct context*)sp;
8010396c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010396f:	6a 14                	push   $0x14
80103971:	6a 00                	push   $0x0
80103973:	50                   	push   %eax
80103974:	e8 37 0f 00 00       	call   801048b0 <memset>
  p->context->eip = (uint)forkret;
80103979:	8b 43 1c             	mov    0x1c(%ebx),%eax
  safestrcpy(p->name, "unknown", sizeof(p->name));  // Default name
8010397c:	83 c4 0c             	add    $0xc,%esp
  p->context->eip = (uint)forkret;
8010397f:	c7 40 10 60 3a 10 80 	movl   $0x80103a60,0x10(%eax)
  safestrcpy(p->name, "unknown", sizeof(p->name));  // Default name
80103986:	6a 10                	push   $0x10
80103988:	68 36 79 10 80       	push   $0x80107936
8010398d:	56                   	push   %esi
8010398e:	e8 dd 10 00 00       	call   80104a70 <safestrcpy>

  // Add process to history (Circular Buffer)
  acquire(&ptable.lock);
80103993:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010399a:	e8 51 0e 00 00       	call   801047f0 <acquire>
  process_history[history_index].pid = p->pid;
8010399f:	a1 54 65 11 80       	mov    0x80116554,%eax
801039a4:	8b 53 10             	mov    0x10(%ebx),%edx
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
801039a7:	83 c4 0c             	add    $0xc,%esp
801039aa:	6a 10                	push   $0x10
  process_history[history_index].pid = p->pid;
801039ac:	8d 04 40             	lea    (%eax,%eax,2),%eax
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
801039af:	56                   	push   %esi
  process_history[history_index].pid = p->pid;
801039b0:	c1 e0 03             	shl    $0x3,%eax
801039b3:	89 90 60 65 11 80    	mov    %edx,-0x7fee9aa0(%eax)
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
801039b9:	05 64 65 11 80       	add    $0x80116564,%eax
801039be:	50                   	push   %eax
801039bf:	e8 ac 10 00 00       	call   80104a70 <safestrcpy>
  process_history[history_index].mem_usage = p->sz;
801039c4:	8b 0d 54 65 11 80    	mov    0x80116554,%ecx
801039ca:	8b 13                	mov    (%ebx),%edx

  // Update history index (Circular Buffer)
  history_index = (history_index + 1) % MAX_HISTORY;
  if (history_count < MAX_HISTORY) {
801039cc:	83 c4 10             	add    $0x10,%esp
  process_history[history_index].mem_usage = p->sz;
801039cf:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  history_index = (history_index + 1) % MAX_HISTORY;
801039d2:	83 c1 01             	add    $0x1,%ecx
  process_history[history_index].mem_usage = p->sz;
801039d5:	89 14 c5 74 65 11 80 	mov    %edx,-0x7fee9a8c(,%eax,8)
  history_index = (history_index + 1) % MAX_HISTORY;
801039dc:	89 c8                	mov    %ecx,%eax
801039de:	ba 67 66 66 66       	mov    $0x66666667,%edx
801039e3:	f7 ea                	imul   %edx
801039e5:	89 c8                	mov    %ecx,%eax
801039e7:	c1 f8 1f             	sar    $0x1f,%eax
801039ea:	c1 fa 02             	sar    $0x2,%edx
801039ed:	29 c2                	sub    %eax,%edx
801039ef:	8d 04 92             	lea    (%edx,%edx,4),%eax
801039f2:	01 c0                	add    %eax,%eax
801039f4:	29 c1                	sub    %eax,%ecx
  if (history_count < MAX_HISTORY) {
801039f6:	a1 58 65 11 80       	mov    0x80116558,%eax
  history_index = (history_index + 1) % MAX_HISTORY;
801039fb:	89 0d 54 65 11 80    	mov    %ecx,0x80116554
  if (history_count < MAX_HISTORY) {
80103a01:	83 f8 09             	cmp    $0x9,%eax
80103a04:	7e 1a                	jle    80103a20 <allocproc+0x140>
      history_count++;  // Keep track of number of stored records
  }
  release(&ptable.lock);
80103a06:	83 ec 0c             	sub    $0xc,%esp
80103a09:	68 20 2d 11 80       	push   $0x80112d20
80103a0e:	e8 7d 0d 00 00       	call   80104790 <release>

  return p;
80103a13:	83 c4 10             	add    $0x10,%esp
}
80103a16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a19:	89 d8                	mov    %ebx,%eax
80103a1b:	5b                   	pop    %ebx
80103a1c:	5e                   	pop    %esi
80103a1d:	5d                   	pop    %ebp
80103a1e:	c3                   	ret
80103a1f:	90                   	nop
      history_count++;  // Keep track of number of stored records
80103a20:	83 c0 01             	add    $0x1,%eax
80103a23:	a3 58 65 11 80       	mov    %eax,0x80116558
80103a28:	eb dc                	jmp    80103a06 <allocproc+0x126>
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a33:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a35:	68 20 2d 11 80       	push   $0x80112d20
80103a3a:	e8 51 0d 00 00       	call   80104790 <release>
  return 0;
80103a3f:	83 c4 10             	add    $0x10,%esp
}
80103a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a45:	89 d8                	mov    %ebx,%eax
80103a47:	5b                   	pop    %ebx
80103a48:	5e                   	pop    %esi
80103a49:	5d                   	pop    %ebp
80103a4a:	c3                   	ret
    p->state = UNUSED;
80103a4b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103a52:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80103a55:	31 db                	xor    %ebx,%ebx
}
80103a57:	89 d8                	mov    %ebx,%eax
80103a59:	5b                   	pop    %ebx
80103a5a:	5e                   	pop    %esi
80103a5b:	5d                   	pop    %ebp
80103a5c:	c3                   	ret
80103a5d:	8d 76 00             	lea    0x0(%esi),%esi

80103a60 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a66:	68 20 2d 11 80       	push   $0x80112d20
80103a6b:	e8 20 0d 00 00       	call   80104790 <release>

  if (first) {
80103a70:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	85 c0                	test   %eax,%eax
80103a7a:	75 04                	jne    80103a80 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a7c:	c9                   	leave
80103a7d:	c3                   	ret
80103a7e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a80:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a87:	00 00 00 
    iinit(ROOTDEV);
80103a8a:	83 ec 0c             	sub    $0xc,%esp
80103a8d:	6a 01                	push   $0x1
80103a8f:	e8 fc db ff ff       	call   80101690 <iinit>
    initlog(ROOTDEV);
80103a94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a9b:	e8 50 f3 ff ff       	call   80102df0 <initlog>
}
80103aa0:	83 c4 10             	add    $0x10,%esp
80103aa3:	c9                   	leave
80103aa4:	c3                   	ret
80103aa5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103aac:	00 
80103aad:	8d 76 00             	lea    0x0(%esi),%esi

80103ab0 <pinit>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ab6:	68 3e 79 10 80       	push   $0x8010793e
80103abb:	68 20 2d 11 80       	push   $0x80112d20
80103ac0:	e8 5b 0b 00 00       	call   80104620 <initlock>
}
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	c9                   	leave
80103ac9:	c3                   	ret
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ad0 <mycpu>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ad5:	9c                   	pushf
80103ad6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ad7:	f6 c4 02             	test   $0x2,%ah
80103ada:	75 46                	jne    80103b22 <mycpu+0x52>
  apicid = lapicid();
80103adc:	e8 3f ef ff ff       	call   80102a20 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ae1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103ae7:	85 f6                	test   %esi,%esi
80103ae9:	7e 2a                	jle    80103b15 <mycpu+0x45>
80103aeb:	31 d2                	xor    %edx,%edx
80103aed:	eb 08                	jmp    80103af7 <mycpu+0x27>
80103aef:	90                   	nop
80103af0:	83 c2 01             	add    $0x1,%edx
80103af3:	39 f2                	cmp    %esi,%edx
80103af5:	74 1e                	je     80103b15 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103af7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103afd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103b04:	39 c3                	cmp    %eax,%ebx
80103b06:	75 e8                	jne    80103af0 <mycpu+0x20>
}
80103b08:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b0b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103b11:	5b                   	pop    %ebx
80103b12:	5e                   	pop    %esi
80103b13:	5d                   	pop    %ebp
80103b14:	c3                   	ret
  panic("unknown apicid\n");
80103b15:	83 ec 0c             	sub    $0xc,%esp
80103b18:	68 45 79 10 80       	push   $0x80107945
80103b1d:	e8 5e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b22:	83 ec 0c             	sub    $0xc,%esp
80103b25:	68 bc 7c 10 80       	push   $0x80107cbc
80103b2a:	e8 51 c8 ff ff       	call   80100380 <panic>
80103b2f:	90                   	nop

80103b30 <cpuid>:
cpuid() {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b36:	e8 95 ff ff ff       	call   80103ad0 <mycpu>
}
80103b3b:	c9                   	leave
  return mycpu()-cpus;
80103b3c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103b41:	c1 f8 04             	sar    $0x4,%eax
80103b44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b4a:	c3                   	ret
80103b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b50 <myproc>:
myproc(void) {
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b57:	e8 44 0b 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80103b5c:	e8 6f ff ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103b61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b67:	e8 84 0b 00 00       	call   801046f0 <popcli>
}
80103b6c:	89 d8                	mov    %ebx,%eax
80103b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b71:	c9                   	leave
80103b72:	c3                   	ret
80103b73:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b7a:	00 
80103b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b80 <userinit>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b87:	e8 54 fd ff ff       	call   801038e0 <allocproc>
80103b8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b8e:	a3 50 66 11 80       	mov    %eax,0x80116650
  if((p->pgdir = setupkvm()) == 0)
80103b93:	e8 f8 37 00 00       	call   80107390 <setupkvm>
80103b98:	89 43 04             	mov    %eax,0x4(%ebx)
80103b9b:	85 c0                	test   %eax,%eax
80103b9d:	0f 84 bd 00 00 00    	je     80103c60 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ba3:	83 ec 04             	sub    $0x4,%esp
80103ba6:	68 2c 00 00 00       	push   $0x2c
80103bab:	68 60 b4 10 80       	push   $0x8010b460
80103bb0:	50                   	push   %eax
80103bb1:	e8 8a 34 00 00       	call   80107040 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bb6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bb9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbf:	6a 4c                	push   $0x4c
80103bc1:	6a 00                	push   $0x0
80103bc3:	ff 73 18             	push   0x18(%ebx)
80103bc6:	e8 e5 0c 00 00       	call   801048b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bd3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bd6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bdb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bdf:	8b 43 18             	mov    0x18(%ebx),%eax
80103be2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103be6:	8b 43 18             	mov    0x18(%ebx),%eax
80103be9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bf1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bf8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bfc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c06:	8b 43 18             	mov    0x18(%ebx),%eax
80103c09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c10:	8b 43 18             	mov    0x18(%ebx),%eax
80103c13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	68 6e 79 10 80       	push   $0x8010796e
80103c24:	50                   	push   %eax
80103c25:	e8 46 0e 00 00       	call   80104a70 <safestrcpy>
  p->cwd = namei("/");
80103c2a:	c7 04 24 77 79 10 80 	movl   $0x80107977,(%esp)
80103c31:	e8 9a e5 ff ff       	call   801021d0 <namei>
80103c36:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c39:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c40:	e8 ab 0b 00 00       	call   801047f0 <acquire>
  p->state = RUNNABLE;
80103c45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c53:	e8 38 0b 00 00       	call   80104790 <release>
}
80103c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c5b:	83 c4 10             	add    $0x10,%esp
80103c5e:	c9                   	leave
80103c5f:	c3                   	ret
    panic("userinit: out of memory?");
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	68 55 79 10 80       	push   $0x80107955
80103c68:	e8 13 c7 ff ff       	call   80100380 <panic>
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi

80103c70 <growproc>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	56                   	push   %esi
80103c74:	53                   	push   %ebx
80103c75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c78:	e8 23 0a 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80103c7d:	e8 4e fe ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103c82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c88:	e8 63 0a 00 00       	call   801046f0 <popcli>
  sz = curproc->sz;
80103c8d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c8f:	85 f6                	test   %esi,%esi
80103c91:	7f 1d                	jg     80103cb0 <growproc+0x40>
  } else if(n < 0){
80103c93:	75 3b                	jne    80103cd0 <growproc+0x60>
  switchuvm(curproc);
80103c95:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c98:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c9a:	53                   	push   %ebx
80103c9b:	e8 90 32 00 00       	call   80106f30 <switchuvm>
  return 0;
80103ca0:	83 c4 10             	add    $0x10,%esp
80103ca3:	31 c0                	xor    %eax,%eax
}
80103ca5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ca8:	5b                   	pop    %ebx
80103ca9:	5e                   	pop    %esi
80103caa:	5d                   	pop    %ebp
80103cab:	c3                   	ret
80103cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 04             	push   0x4(%ebx)
80103cba:	e8 f1 34 00 00       	call   801071b0 <allocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 cf                	jne    80103c95 <growproc+0x25>
      return -1;
80103cc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ccb:	eb d8                	jmp    80103ca5 <growproc+0x35>
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cd0:	83 ec 04             	sub    $0x4,%esp
80103cd3:	01 c6                	add    %eax,%esi
80103cd5:	56                   	push   %esi
80103cd6:	50                   	push   %eax
80103cd7:	ff 73 04             	push   0x4(%ebx)
80103cda:	e8 01 36 00 00       	call   801072e0 <deallocuvm>
80103cdf:	83 c4 10             	add    $0x10,%esp
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	75 af                	jne    80103c95 <growproc+0x25>
80103ce6:	eb de                	jmp    80103cc6 <growproc+0x56>
80103ce8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cef:	00 

80103cf0 <fork>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cf9:	e8 a2 09 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80103cfe:	e8 cd fd ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103d03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d09:	e8 e2 09 00 00       	call   801046f0 <popcli>
  if((np = allocproc()) == 0){
80103d0e:	e8 cd fb ff ff       	call   801038e0 <allocproc>
80103d13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d16:	85 c0                	test   %eax,%eax
80103d18:	0f 84 b7 00 00 00    	je     80103dd5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d1e:	83 ec 08             	sub    $0x8,%esp
80103d21:	ff 33                	push   (%ebx)
80103d23:	89 c7                	mov    %eax,%edi
80103d25:	ff 73 04             	push   0x4(%ebx)
80103d28:	e8 53 37 00 00       	call   80107480 <copyuvm>
80103d2d:	83 c4 10             	add    $0x10,%esp
80103d30:	89 47 04             	mov    %eax,0x4(%edi)
80103d33:	85 c0                	test   %eax,%eax
80103d35:	0f 84 a1 00 00 00    	je     80103ddc <fork+0xec>
  np->sz = curproc->sz;
80103d3b:	8b 03                	mov    (%ebx),%eax
80103d3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d40:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d42:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d45:	89 c8                	mov    %ecx,%eax
80103d47:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d4a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d4f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d54:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d56:	8b 40 18             	mov    0x18(%eax),%eax
80103d59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d64:	85 c0                	test   %eax,%eax
80103d66:	74 13                	je     80103d7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d68:	83 ec 0c             	sub    $0xc,%esp
80103d6b:	50                   	push   %eax
80103d6c:	e8 5f d2 ff ff       	call   80100fd0 <filedup>
80103d71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d74:	83 c4 10             	add    $0x10,%esp
80103d77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d7b:	83 c6 01             	add    $0x1,%esi
80103d7e:	83 fe 10             	cmp    $0x10,%esi
80103d81:	75 dd                	jne    80103d60 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d83:	83 ec 0c             	sub    $0xc,%esp
80103d86:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d8c:	e8 ef da ff ff       	call   80101880 <idup>
80103d91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d9d:	6a 10                	push   $0x10
80103d9f:	53                   	push   %ebx
80103da0:	50                   	push   %eax
80103da1:	e8 ca 0c 00 00       	call   80104a70 <safestrcpy>
  pid = np->pid;
80103da6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103da9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103db0:	e8 3b 0a 00 00       	call   801047f0 <acquire>
  np->state = RUNNABLE;
80103db5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dbc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dc3:	e8 c8 09 00 00       	call   80104790 <release>
  return pid;
80103dc8:	83 c4 10             	add    $0x10,%esp
}
80103dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dce:	89 d8                	mov    %ebx,%eax
80103dd0:	5b                   	pop    %ebx
80103dd1:	5e                   	pop    %esi
80103dd2:	5f                   	pop    %edi
80103dd3:	5d                   	pop    %ebp
80103dd4:	c3                   	ret
    return -1;
80103dd5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dda:	eb ef                	jmp    80103dcb <fork+0xdb>
    kfree(np->kstack);
80103ddc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ddf:	83 ec 0c             	sub    $0xc,%esp
80103de2:	ff 73 08             	push   0x8(%ebx)
80103de5:	e8 06 e8 ff ff       	call   801025f0 <kfree>
    np->kstack = 0;
80103dea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103df1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103df4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103dfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e00:	eb c9                	jmp    80103dcb <fork+0xdb>
80103e02:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e09:	00 
80103e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e10 <scheduler>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e19:	e8 b2 fc ff ff       	call   80103ad0 <mycpu>
  c->proc = 0;
80103e1e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e25:	00 00 00 
  struct cpu *c = mycpu();
80103e28:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e2a:	8d 78 04             	lea    0x4(%eax),%edi
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e30:	fb                   	sti
    acquire(&ptable.lock);
80103e31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e34:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103e39:	68 20 2d 11 80       	push   $0x80112d20
80103e3e:	e8 ad 09 00 00       	call   801047f0 <acquire>
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e4d:	00 
80103e4e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103e50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e54:	75 33                	jne    80103e89 <scheduler+0x79>
      switchuvm(p);
80103e56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e5f:	53                   	push   %ebx
80103e60:	e8 cb 30 00 00       	call   80106f30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e65:	58                   	pop    %eax
80103e66:	5a                   	pop    %edx
80103e67:	ff 73 1c             	push   0x1c(%ebx)
80103e6a:	57                   	push   %edi
      p->state = RUNNING;
80103e6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e72:	e8 54 0c 00 00       	call   80104acb <swtch>
      switchkvm();
80103e77:	e8 a4 30 00 00       	call   80106f20 <switchkvm>
      c->proc = 0;
80103e7c:	83 c4 10             	add    $0x10,%esp
80103e7f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e86:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e89:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80103e8f:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103e95:	75 b9                	jne    80103e50 <scheduler+0x40>
    release(&ptable.lock);
80103e97:	83 ec 0c             	sub    $0xc,%esp
80103e9a:	68 20 2d 11 80       	push   $0x80112d20
80103e9f:	e8 ec 08 00 00       	call   80104790 <release>
    sti();
80103ea4:	83 c4 10             	add    $0x10,%esp
80103ea7:	eb 87                	jmp    80103e30 <scheduler+0x20>
80103ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103eb0 <sched>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  pushcli();
80103eb5:	e8 e6 07 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80103eba:	e8 11 fc ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103ebf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec5:	e8 26 08 00 00       	call   801046f0 <popcli>
  if(!holding(&ptable.lock))
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 20 2d 11 80       	push   $0x80112d20
80103ed2:	e8 79 08 00 00       	call   80104750 <holding>
80103ed7:	83 c4 10             	add    $0x10,%esp
80103eda:	85 c0                	test   %eax,%eax
80103edc:	74 4f                	je     80103f2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ede:	e8 ed fb ff ff       	call   80103ad0 <mycpu>
80103ee3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eea:	75 68                	jne    80103f54 <sched+0xa4>
  if(p->state == RUNNING)
80103eec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ef0:	74 55                	je     80103f47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ef2:	9c                   	pushf
80103ef3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ef4:	f6 c4 02             	test   $0x2,%ah
80103ef7:	75 41                	jne    80103f3a <sched+0x8a>
  intena = mycpu()->intena;
80103ef9:	e8 d2 fb ff ff       	call   80103ad0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103efe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f07:	e8 c4 fb ff ff       	call   80103ad0 <mycpu>
80103f0c:	83 ec 08             	sub    $0x8,%esp
80103f0f:	ff 70 04             	push   0x4(%eax)
80103f12:	53                   	push   %ebx
80103f13:	e8 b3 0b 00 00       	call   80104acb <swtch>
  mycpu()->intena = intena;
80103f18:	e8 b3 fb ff ff       	call   80103ad0 <mycpu>
}
80103f1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f29:	5b                   	pop    %ebx
80103f2a:	5e                   	pop    %esi
80103f2b:	5d                   	pop    %ebp
80103f2c:	c3                   	ret
    panic("sched ptable.lock");
80103f2d:	83 ec 0c             	sub    $0xc,%esp
80103f30:	68 79 79 10 80       	push   $0x80107979
80103f35:	e8 46 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 a5 79 10 80       	push   $0x801079a5
80103f42:	e8 39 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 97 79 10 80       	push   $0x80107997
80103f4f:	e8 2c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 8b 79 10 80       	push   $0x8010798b
80103f5c:	e8 1f c4 ff ff       	call   80100380 <panic>
80103f61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f68:	00 
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f70 <exit>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f79:	e8 d2 fb ff ff       	call   80103b50 <myproc>
  if(curproc == initproc)
80103f7e:	39 05 50 66 11 80    	cmp    %eax,0x80116650
80103f84:	0f 84 77 01 00 00    	je     80104101 <exit+0x191>
  acquire(&ptable.lock);
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	89 c3                	mov    %eax,%ebx
80103f8f:	68 20 2d 11 80       	push   $0x80112d20
80103f94:	e8 57 08 00 00       	call   801047f0 <acquire>
  for (int i = 0; i < history_count; i++) {
80103f99:	8b 0d 58 65 11 80    	mov    0x80116558,%ecx
80103f9f:	83 c4 10             	add    $0x10,%esp
80103fa2:	85 c9                	test   %ecx,%ecx
80103fa4:	7e 4a                	jle    80103ff0 <exit+0x80>
      if (process_history[i].pid == curproc->pid) {
80103fa6:	8b 7b 10             	mov    0x10(%ebx),%edi
  for (int i = 0; i < history_count; i++) {
80103fa9:	31 c0                	xor    %eax,%eax
80103fab:	eb 0a                	jmp    80103fb7 <exit+0x47>
80103fad:	8d 76 00             	lea    0x0(%esi),%esi
80103fb0:	83 c0 01             	add    $0x1,%eax
80103fb3:	39 c8                	cmp    %ecx,%eax
80103fb5:	74 39                	je     80103ff0 <exit+0x80>
      if (process_history[i].pid == curproc->pid) {
80103fb7:	8d 14 40             	lea    (%eax,%eax,2),%edx
80103fba:	8d 34 d5 00 00 00 00 	lea    0x0(,%edx,8),%esi
80103fc1:	39 3c d5 60 65 11 80 	cmp    %edi,-0x7fee9aa0(,%edx,8)
80103fc8:	75 e6                	jne    80103fb0 <exit+0x40>
        if(curproc->sz > process_history[i].mem_usage) {
80103fca:	8b 03                	mov    (%ebx),%eax
80103fcc:	3b 86 74 65 11 80    	cmp    -0x7fee9a8c(%esi),%eax
80103fd2:	76 06                	jbe    80103fda <exit+0x6a>
          process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
80103fd4:	89 86 74 65 11 80    	mov    %eax,-0x7fee9a8c(%esi)
          safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80103fda:	81 c6 64 65 11 80    	add    $0x80116564,%esi
80103fe0:	50                   	push   %eax
80103fe1:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103fe4:	6a 10                	push   $0x10
80103fe6:	50                   	push   %eax
80103fe7:	56                   	push   %esi
80103fe8:	e8 83 0a 00 00       	call   80104a70 <safestrcpy>
          break;
80103fed:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80103ff0:	83 ec 0c             	sub    $0xc,%esp
80103ff3:	8d 73 28             	lea    0x28(%ebx),%esi
80103ff6:	8d 7b 68             	lea    0x68(%ebx),%edi
80103ff9:	68 20 2d 11 80       	push   $0x80112d20
80103ffe:	e8 8d 07 00 00       	call   80104790 <release>
  for(fd = 0; fd < NOFILE; fd++){
80104003:	83 c4 10             	add    $0x10,%esp
80104006:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010400d:	00 
8010400e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
80104010:	8b 06                	mov    (%esi),%eax
80104012:	85 c0                	test   %eax,%eax
80104014:	74 12                	je     80104028 <exit+0xb8>
      fileclose(curproc->ofile[fd]);
80104016:	83 ec 0c             	sub    $0xc,%esp
80104019:	50                   	push   %eax
8010401a:	e8 01 d0 ff ff       	call   80101020 <fileclose>
      curproc->ofile[fd] = 0;
8010401f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104025:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104028:	83 c6 04             	add    $0x4,%esi
8010402b:	39 f7                	cmp    %esi,%edi
8010402d:	75 e1                	jne    80104010 <exit+0xa0>
  begin_op();
8010402f:	e8 5c ee ff ff       	call   80102e90 <begin_op>
  iput(curproc->cwd);
80104034:	83 ec 0c             	sub    $0xc,%esp
80104037:	ff 73 68             	push   0x68(%ebx)
8010403a:	e8 a1 d9 ff ff       	call   801019e0 <iput>
  end_op();
8010403f:	e8 bc ee ff ff       	call   80102f00 <end_op>
  curproc->cwd = 0;
80104044:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010404b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104052:	e8 99 07 00 00       	call   801047f0 <acquire>
  wakeup1(curproc->parent);
80104057:	8b 53 14             	mov    0x14(%ebx),%edx
8010405a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010405d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104062:	eb 10                	jmp    80104074 <exit+0x104>
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104068:	05 e0 00 00 00       	add    $0xe0,%eax
8010406d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104072:	74 1e                	je     80104092 <exit+0x122>
    if(p->state == SLEEPING && p->chan == chan)
80104074:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104078:	75 ee                	jne    80104068 <exit+0xf8>
8010407a:	3b 50 20             	cmp    0x20(%eax),%edx
8010407d:	75 e9                	jne    80104068 <exit+0xf8>
      p->state = RUNNABLE;
8010407f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104086:	05 e0 00 00 00       	add    $0xe0,%eax
8010408b:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104090:	75 e2                	jne    80104074 <exit+0x104>
      p->parent = initproc;
80104092:	8b 0d 50 66 11 80    	mov    0x80116650,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104098:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010409d:	eb 0f                	jmp    801040ae <exit+0x13e>
8010409f:	90                   	nop
801040a0:	81 c2 e0 00 00 00    	add    $0xe0,%edx
801040a6:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
801040ac:	74 3a                	je     801040e8 <exit+0x178>
    if(p->parent == curproc){
801040ae:	39 5a 14             	cmp    %ebx,0x14(%edx)
801040b1:	75 ed                	jne    801040a0 <exit+0x130>
      if(p->state == ZOMBIE)
801040b3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801040b7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040ba:	75 e4                	jne    801040a0 <exit+0x130>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040bc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040c1:	eb 11                	jmp    801040d4 <exit+0x164>
801040c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801040c8:	05 e0 00 00 00       	add    $0xe0,%eax
801040cd:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801040d2:	74 cc                	je     801040a0 <exit+0x130>
    if(p->state == SLEEPING && p->chan == chan)
801040d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040d8:	75 ee                	jne    801040c8 <exit+0x158>
801040da:	3b 48 20             	cmp    0x20(%eax),%ecx
801040dd:	75 e9                	jne    801040c8 <exit+0x158>
      p->state = RUNNABLE;
801040df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040e6:	eb e0                	jmp    801040c8 <exit+0x158>
  curproc->state = ZOMBIE;
801040e8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801040ef:	e8 bc fd ff ff       	call   80103eb0 <sched>
  panic("zombie exit");
801040f4:	83 ec 0c             	sub    $0xc,%esp
801040f7:	68 c6 79 10 80       	push   $0x801079c6
801040fc:	e8 7f c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104101:	83 ec 0c             	sub    $0xc,%esp
80104104:	68 b9 79 10 80       	push   $0x801079b9
80104109:	e8 72 c2 ff ff       	call   80100380 <panic>
8010410e:	66 90                	xchg   %ax,%ax

80104110 <wait>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
  pushcli();
80104115:	e8 86 05 00 00       	call   801046a0 <pushcli>
  c = mycpu();
8010411a:	e8 b1 f9 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
8010411f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104125:	e8 c6 05 00 00       	call   801046f0 <popcli>
  acquire(&ptable.lock);
8010412a:	83 ec 0c             	sub    $0xc,%esp
8010412d:	68 20 2d 11 80       	push   $0x80112d20
80104132:	e8 b9 06 00 00       	call   801047f0 <acquire>
80104137:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010413a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104141:	eb 13                	jmp    80104156 <wait+0x46>
80104143:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104148:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
8010414e:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80104154:	74 1e                	je     80104174 <wait+0x64>
      if(p->parent != curproc)
80104156:	39 73 14             	cmp    %esi,0x14(%ebx)
80104159:	75 ed                	jne    80104148 <wait+0x38>
      if(p->state == ZOMBIE){
8010415b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010415f:	74 5f                	je     801041c0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104161:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
      havekids = 1;
80104167:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010416c:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80104172:	75 e2                	jne    80104156 <wait+0x46>
    if(!havekids || curproc->killed){
80104174:	85 c0                	test   %eax,%eax
80104176:	0f 84 9a 00 00 00    	je     80104216 <wait+0x106>
8010417c:	8b 46 24             	mov    0x24(%esi),%eax
8010417f:	85 c0                	test   %eax,%eax
80104181:	0f 85 8f 00 00 00    	jne    80104216 <wait+0x106>
  pushcli();
80104187:	e8 14 05 00 00       	call   801046a0 <pushcli>
  c = mycpu();
8010418c:	e8 3f f9 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80104191:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104197:	e8 54 05 00 00       	call   801046f0 <popcli>
  if(p == 0)
8010419c:	85 db                	test   %ebx,%ebx
8010419e:	0f 84 89 00 00 00    	je     8010422d <wait+0x11d>
  p->chan = chan;
801041a4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801041a7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041ae:	e8 fd fc ff ff       	call   80103eb0 <sched>
  p->chan = 0;
801041b3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041ba:	e9 7b ff ff ff       	jmp    8010413a <wait+0x2a>
801041bf:	90                   	nop
        kfree(p->kstack);
801041c0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041c3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041c6:	ff 73 08             	push   0x8(%ebx)
801041c9:	e8 22 e4 ff ff       	call   801025f0 <kfree>
        p->kstack = 0;
801041ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041d5:	5a                   	pop    %edx
801041d6:	ff 73 04             	push   0x4(%ebx)
801041d9:	e8 32 31 00 00       	call   80107310 <freevm>
        p->pid = 0;
801041de:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041e5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041ec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041f0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041fe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104205:	e8 86 05 00 00       	call   80104790 <release>
        return pid;
8010420a:	83 c4 10             	add    $0x10,%esp
}
8010420d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104210:	89 f0                	mov    %esi,%eax
80104212:	5b                   	pop    %ebx
80104213:	5e                   	pop    %esi
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret
      release(&ptable.lock);
80104216:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104219:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010421e:	68 20 2d 11 80       	push   $0x80112d20
80104223:	e8 68 05 00 00       	call   80104790 <release>
      return -1;
80104228:	83 c4 10             	add    $0x10,%esp
8010422b:	eb e0                	jmp    8010420d <wait+0xfd>
    panic("sleep");
8010422d:	83 ec 0c             	sub    $0xc,%esp
80104230:	68 d2 79 10 80       	push   $0x801079d2
80104235:	e8 46 c1 ff ff       	call   80100380 <panic>
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <yield>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104247:	68 20 2d 11 80       	push   $0x80112d20
8010424c:	e8 9f 05 00 00       	call   801047f0 <acquire>
  pushcli();
80104251:	e8 4a 04 00 00       	call   801046a0 <pushcli>
  c = mycpu();
80104256:	e8 75 f8 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
8010425b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104261:	e8 8a 04 00 00       	call   801046f0 <popcli>
  myproc()->state = RUNNABLE;
80104266:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010426d:	e8 3e fc ff ff       	call   80103eb0 <sched>
  release(&ptable.lock);
80104272:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104279:	e8 12 05 00 00       	call   80104790 <release>
}
8010427e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104281:	83 c4 10             	add    $0x10,%esp
80104284:	c9                   	leave
80104285:	c3                   	ret
80104286:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010428d:	00 
8010428e:	66 90                	xchg   %ax,%ax

80104290 <sleep>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	83 ec 0c             	sub    $0xc,%esp
80104299:	8b 7d 08             	mov    0x8(%ebp),%edi
8010429c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010429f:	e8 fc 03 00 00       	call   801046a0 <pushcli>
  c = mycpu();
801042a4:	e8 27 f8 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
801042a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042af:	e8 3c 04 00 00       	call   801046f0 <popcli>
  if(p == 0)
801042b4:	85 db                	test   %ebx,%ebx
801042b6:	0f 84 87 00 00 00    	je     80104343 <sleep+0xb3>
  if(lk == 0)
801042bc:	85 f6                	test   %esi,%esi
801042be:	74 76                	je     80104336 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042c0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801042c6:	74 50                	je     80104318 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	68 20 2d 11 80       	push   $0x80112d20
801042d0:	e8 1b 05 00 00       	call   801047f0 <acquire>
    release(lk);
801042d5:	89 34 24             	mov    %esi,(%esp)
801042d8:	e8 b3 04 00 00       	call   80104790 <release>
  p->chan = chan;
801042dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042e7:	e8 c4 fb ff ff       	call   80103eb0 <sched>
  p->chan = 0;
801042ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042f3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042fa:	e8 91 04 00 00       	call   80104790 <release>
    acquire(lk);
801042ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104302:	83 c4 10             	add    $0x10,%esp
}
80104305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104308:	5b                   	pop    %ebx
80104309:	5e                   	pop    %esi
8010430a:	5f                   	pop    %edi
8010430b:	5d                   	pop    %ebp
    acquire(lk);
8010430c:	e9 df 04 00 00       	jmp    801047f0 <acquire>
80104311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104318:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010431b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104322:	e8 89 fb ff ff       	call   80103eb0 <sched>
  p->chan = 0;
80104327:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010432e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104331:	5b                   	pop    %ebx
80104332:	5e                   	pop    %esi
80104333:	5f                   	pop    %edi
80104334:	5d                   	pop    %ebp
80104335:	c3                   	ret
    panic("sleep without lk");
80104336:	83 ec 0c             	sub    $0xc,%esp
80104339:	68 d8 79 10 80       	push   $0x801079d8
8010433e:	e8 3d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	68 d2 79 10 80       	push   $0x801079d2
8010434b:	e8 30 c0 ff ff       	call   80100380 <panic>

80104350 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010435a:	68 20 2d 11 80       	push   $0x80112d20
8010435f:	e8 8c 04 00 00       	call   801047f0 <acquire>
80104364:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104367:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010436c:	eb 0e                	jmp    8010437c <wakeup+0x2c>
8010436e:	66 90                	xchg   %ax,%ax
80104370:	05 e0 00 00 00       	add    $0xe0,%eax
80104375:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010437a:	74 1e                	je     8010439a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010437c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104380:	75 ee                	jne    80104370 <wakeup+0x20>
80104382:	3b 58 20             	cmp    0x20(%eax),%ebx
80104385:	75 e9                	jne    80104370 <wakeup+0x20>
      p->state = RUNNABLE;
80104387:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010438e:	05 e0 00 00 00       	add    $0xe0,%eax
80104393:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104398:	75 e2                	jne    8010437c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010439a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801043a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a4:	c9                   	leave
  release(&ptable.lock);
801043a5:	e9 e6 03 00 00       	jmp    80104790 <release>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 10             	sub    $0x10,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ba:	68 20 2d 11 80       	push   $0x80112d20
801043bf:	e8 2c 04 00 00       	call   801047f0 <acquire>
801043c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043cc:	eb 0e                	jmp    801043dc <kill+0x2c>
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	05 e0 00 00 00       	add    $0xe0,%eax
801043d5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801043da:	74 34                	je     80104410 <kill+0x60>
    if(p->pid == pid){
801043dc:	39 58 10             	cmp    %ebx,0x10(%eax)
801043df:	75 ef                	jne    801043d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043e1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043e5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043ec:	75 07                	jne    801043f5 <kill+0x45>
        p->state = RUNNABLE;
801043ee:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043f5:	83 ec 0c             	sub    $0xc,%esp
801043f8:	68 20 2d 11 80       	push   $0x80112d20
801043fd:	e8 8e 03 00 00       	call   80104790 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104405:	83 c4 10             	add    $0x10,%esp
80104408:	31 c0                	xor    %eax,%eax
}
8010440a:	c9                   	leave
8010440b:	c3                   	ret
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	68 20 2d 11 80       	push   $0x80112d20
80104418:	e8 73 03 00 00       	call   80104790 <release>
}
8010441d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104420:	83 c4 10             	add    $0x10,%esp
80104423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104428:	c9                   	leave
80104429:	c3                   	ret
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104438:	53                   	push   %ebx
80104439:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010443e:	83 ec 3c             	sub    $0x3c,%esp
80104441:	eb 27                	jmp    8010446a <procdump+0x3a>
80104443:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	68 ae 7b 10 80       	push   $0x80107bae
80104450:	e8 4b c2 ff ff       	call   801006a0 <cprintf>
80104455:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104458:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
8010445e:	81 fb c0 65 11 80    	cmp    $0x801165c0,%ebx
80104464:	0f 84 7e 00 00 00    	je     801044e8 <procdump+0xb8>
    if(p->state == UNUSED)
8010446a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010446d:	85 c0                	test   %eax,%eax
8010446f:	74 e7                	je     80104458 <procdump+0x28>
      state = "???";
80104471:	ba e9 79 10 80       	mov    $0x801079e9,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104476:	83 f8 05             	cmp    $0x5,%eax
80104479:	77 11                	ja     8010448c <procdump+0x5c>
8010447b:	8b 14 85 a0 80 10 80 	mov    -0x7fef7f60(,%eax,4),%edx
      state = "???";
80104482:	b8 e9 79 10 80       	mov    $0x801079e9,%eax
80104487:	85 d2                	test   %edx,%edx
80104489:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010448c:	53                   	push   %ebx
8010448d:	52                   	push   %edx
8010448e:	ff 73 a4             	push   -0x5c(%ebx)
80104491:	68 ed 79 10 80       	push   $0x801079ed
80104496:	e8 05 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010449b:	83 c4 10             	add    $0x10,%esp
8010449e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044a2:	75 a4                	jne    80104448 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044a4:	83 ec 08             	sub    $0x8,%esp
801044a7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044aa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044ad:	50                   	push   %eax
801044ae:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044b1:	8b 40 0c             	mov    0xc(%eax),%eax
801044b4:	83 c0 08             	add    $0x8,%eax
801044b7:	50                   	push   %eax
801044b8:	e8 83 01 00 00       	call   80104640 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044bd:	83 c4 10             	add    $0x10,%esp
801044c0:	8b 17                	mov    (%edi),%edx
801044c2:	85 d2                	test   %edx,%edx
801044c4:	74 82                	je     80104448 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044cc:	52                   	push   %edx
801044cd:	68 21 77 10 80       	push   $0x80107721
801044d2:	e8 c9 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044d7:	83 c4 10             	add    $0x10,%esp
801044da:	39 fe                	cmp    %edi,%esi
801044dc:	75 e2                	jne    801044c0 <procdump+0x90>
801044de:	e9 65 ff ff ff       	jmp    80104448 <procdump+0x18>
801044e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801044e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044eb:	5b                   	pop    %ebx
801044ec:	5e                   	pop    %esi
801044ed:	5f                   	pop    %edi
801044ee:	5d                   	pop    %ebp
801044ef:	c3                   	ret

801044f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 0c             	sub    $0xc,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044fa:	68 20 7a 10 80       	push   $0x80107a20
801044ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104502:	50                   	push   %eax
80104503:	e8 18 01 00 00       	call   80104620 <initlock>
  lk->name = name;
80104508:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010450b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104511:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104514:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010451b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010451e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104521:	c9                   	leave
80104522:	c3                   	ret
80104523:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010452a:	00 
8010452b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104530 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104538:	8d 73 04             	lea    0x4(%ebx),%esi
8010453b:	83 ec 0c             	sub    $0xc,%esp
8010453e:	56                   	push   %esi
8010453f:	e8 ac 02 00 00       	call   801047f0 <acquire>
  while (lk->locked) {
80104544:	8b 13                	mov    (%ebx),%edx
80104546:	83 c4 10             	add    $0x10,%esp
80104549:	85 d2                	test   %edx,%edx
8010454b:	74 16                	je     80104563 <acquiresleep+0x33>
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104550:	83 ec 08             	sub    $0x8,%esp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	e8 36 fd ff ff       	call   80104290 <sleep>
  while (lk->locked) {
8010455a:	8b 03                	mov    (%ebx),%eax
8010455c:	83 c4 10             	add    $0x10,%esp
8010455f:	85 c0                	test   %eax,%eax
80104561:	75 ed                	jne    80104550 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104563:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104569:	e8 e2 f5 ff ff       	call   80103b50 <myproc>
8010456e:	8b 40 10             	mov    0x10(%eax),%eax
80104571:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104574:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104577:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010457a:	5b                   	pop    %ebx
8010457b:	5e                   	pop    %esi
8010457c:	5d                   	pop    %ebp
  release(&lk->lk);
8010457d:	e9 0e 02 00 00       	jmp    80104790 <release>
80104582:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104589:	00 
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	8d 73 04             	lea    0x4(%ebx),%esi
8010459b:	83 ec 0c             	sub    $0xc,%esp
8010459e:	56                   	push   %esi
8010459f:	e8 4c 02 00 00       	call   801047f0 <acquire>
  lk->locked = 0;
801045a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045b1:	89 1c 24             	mov    %ebx,(%esp)
801045b4:	e8 97 fd ff ff       	call   80104350 <wakeup>
  release(&lk->lk);
801045b9:	89 75 08             	mov    %esi,0x8(%ebp)
801045bc:	83 c4 10             	add    $0x10,%esp
}
801045bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c2:	5b                   	pop    %ebx
801045c3:	5e                   	pop    %esi
801045c4:	5d                   	pop    %ebp
  release(&lk->lk);
801045c5:	e9 c6 01 00 00       	jmp    80104790 <release>
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	31 ff                	xor    %edi,%edi
801045d6:	56                   	push   %esi
801045d7:	53                   	push   %ebx
801045d8:	83 ec 18             	sub    $0x18,%esp
801045db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045de:	8d 73 04             	lea    0x4(%ebx),%esi
801045e1:	56                   	push   %esi
801045e2:	e8 09 02 00 00       	call   801047f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045e7:	8b 03                	mov    (%ebx),%eax
801045e9:	83 c4 10             	add    $0x10,%esp
801045ec:	85 c0                	test   %eax,%eax
801045ee:	75 18                	jne    80104608 <holdingsleep+0x38>
  release(&lk->lk);
801045f0:	83 ec 0c             	sub    $0xc,%esp
801045f3:	56                   	push   %esi
801045f4:	e8 97 01 00 00       	call   80104790 <release>
  return r;
}
801045f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045fc:	89 f8                	mov    %edi,%eax
801045fe:	5b                   	pop    %ebx
801045ff:	5e                   	pop    %esi
80104600:	5f                   	pop    %edi
80104601:	5d                   	pop    %ebp
80104602:	c3                   	ret
80104603:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104608:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010460b:	e8 40 f5 ff ff       	call   80103b50 <myproc>
80104610:	39 58 10             	cmp    %ebx,0x10(%eax)
80104613:	0f 94 c0             	sete   %al
80104616:	0f b6 c0             	movzbl %al,%eax
80104619:	89 c7                	mov    %eax,%edi
8010461b:	eb d3                	jmp    801045f0 <holdingsleep+0x20>
8010461d:	66 90                	xchg   %ax,%ax
8010461f:	90                   	nop

80104620 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104626:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010462f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104632:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret
8010463b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104640 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104640:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104641:	31 d2                	xor    %edx,%edx
{
80104643:	89 e5                	mov    %esp,%ebp
80104645:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104646:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104649:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010464c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010464f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104650:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104656:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010465c:	77 1a                	ja     80104678 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010465e:	8b 58 04             	mov    0x4(%eax),%ebx
80104661:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104664:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104667:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104669:	83 fa 0a             	cmp    $0xa,%edx
8010466c:	75 e2                	jne    80104650 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010466e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104671:	c9                   	leave
80104672:	c3                   	ret
80104673:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104678:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010467b:	8d 51 28             	lea    0x28(%ecx),%edx
8010467e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104686:	83 c0 04             	add    $0x4,%eax
80104689:	39 d0                	cmp    %edx,%eax
8010468b:	75 f3                	jne    80104680 <getcallerpcs+0x40>
}
8010468d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104690:	c9                   	leave
80104691:	c3                   	ret
80104692:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104699:	00 
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 04             	sub    $0x4,%esp
801046a7:	9c                   	pushf
801046a8:	5b                   	pop    %ebx
  asm volatile("cli");
801046a9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801046aa:	e8 21 f4 ff ff       	call   80103ad0 <mycpu>
801046af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046b5:	85 c0                	test   %eax,%eax
801046b7:	74 17                	je     801046d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046b9:	e8 12 f4 ff ff       	call   80103ad0 <mycpu>
801046be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c8:	c9                   	leave
801046c9:	c3                   	ret
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046d0:	e8 fb f3 ff ff       	call   80103ad0 <mycpu>
801046d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046e1:	eb d6                	jmp    801046b9 <pushcli+0x19>
801046e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046ea:	00 
801046eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046f0 <popcli>:

void
popcli(void)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046f6:	9c                   	pushf
801046f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046f8:	f6 c4 02             	test   $0x2,%ah
801046fb:	75 35                	jne    80104732 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046fd:	e8 ce f3 ff ff       	call   80103ad0 <mycpu>
80104702:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104709:	78 34                	js     8010473f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010470b:	e8 c0 f3 ff ff       	call   80103ad0 <mycpu>
80104710:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104716:	85 d2                	test   %edx,%edx
80104718:	74 06                	je     80104720 <popcli+0x30>
    sti();
}
8010471a:	c9                   	leave
8010471b:	c3                   	ret
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104720:	e8 ab f3 ff ff       	call   80103ad0 <mycpu>
80104725:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010472b:	85 c0                	test   %eax,%eax
8010472d:	74 eb                	je     8010471a <popcli+0x2a>
  asm volatile("sti");
8010472f:	fb                   	sti
}
80104730:	c9                   	leave
80104731:	c3                   	ret
    panic("popcli - interruptible");
80104732:	83 ec 0c             	sub    $0xc,%esp
80104735:	68 2b 7a 10 80       	push   $0x80107a2b
8010473a:	e8 41 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010473f:	83 ec 0c             	sub    $0xc,%esp
80104742:	68 42 7a 10 80       	push   $0x80107a42
80104747:	e8 34 bc ff ff       	call   80100380 <panic>
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <holding>:
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 75 08             	mov    0x8(%ebp),%esi
80104758:	31 db                	xor    %ebx,%ebx
  pushcli();
8010475a:	e8 41 ff ff ff       	call   801046a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010475f:	8b 06                	mov    (%esi),%eax
80104761:	85 c0                	test   %eax,%eax
80104763:	75 0b                	jne    80104770 <holding+0x20>
  popcli();
80104765:	e8 86 ff ff ff       	call   801046f0 <popcli>
}
8010476a:	89 d8                	mov    %ebx,%eax
8010476c:	5b                   	pop    %ebx
8010476d:	5e                   	pop    %esi
8010476e:	5d                   	pop    %ebp
8010476f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104770:	8b 5e 08             	mov    0x8(%esi),%ebx
80104773:	e8 58 f3 ff ff       	call   80103ad0 <mycpu>
80104778:	39 c3                	cmp    %eax,%ebx
8010477a:	0f 94 c3             	sete   %bl
  popcli();
8010477d:	e8 6e ff ff ff       	call   801046f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104782:	0f b6 db             	movzbl %bl,%ebx
}
80104785:	89 d8                	mov    %ebx,%eax
80104787:	5b                   	pop    %ebx
80104788:	5e                   	pop    %esi
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret
8010478b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104790 <release>:
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104798:	e8 03 ff ff ff       	call   801046a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010479d:	8b 03                	mov    (%ebx),%eax
8010479f:	85 c0                	test   %eax,%eax
801047a1:	75 15                	jne    801047b8 <release+0x28>
  popcli();
801047a3:	e8 48 ff ff ff       	call   801046f0 <popcli>
    panic("release");
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	68 49 7a 10 80       	push   $0x80107a49
801047b0:	e8 cb bb ff ff       	call   80100380 <panic>
801047b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047b8:	8b 73 08             	mov    0x8(%ebx),%esi
801047bb:	e8 10 f3 ff ff       	call   80103ad0 <mycpu>
801047c0:	39 c6                	cmp    %eax,%esi
801047c2:	75 df                	jne    801047a3 <release+0x13>
  popcli();
801047c4:	e8 27 ff ff ff       	call   801046f0 <popcli>
  lk->pcs[0] = 0;
801047c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047e5:	5b                   	pop    %ebx
801047e6:	5e                   	pop    %esi
801047e7:	5d                   	pop    %ebp
  popcli();
801047e8:	e9 03 ff ff ff       	jmp    801046f0 <popcli>
801047ed:	8d 76 00             	lea    0x0(%esi),%esi

801047f0 <acquire>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047f7:	e8 a4 fe ff ff       	call   801046a0 <pushcli>
  if(holding(lk))
801047fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047ff:	e8 9c fe ff ff       	call   801046a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104804:	8b 03                	mov    (%ebx),%eax
80104806:	85 c0                	test   %eax,%eax
80104808:	75 7e                	jne    80104888 <acquire+0x98>
  popcli();
8010480a:	e8 e1 fe ff ff       	call   801046f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010480f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104818:	8b 55 08             	mov    0x8(%ebp),%edx
8010481b:	89 c8                	mov    %ecx,%eax
8010481d:	f0 87 02             	lock xchg %eax,(%edx)
80104820:	85 c0                	test   %eax,%eax
80104822:	75 f4                	jne    80104818 <acquire+0x28>
  __sync_synchronize();
80104824:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104829:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010482c:	e8 9f f2 ff ff       	call   80103ad0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104831:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104834:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104836:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104839:	31 c0                	xor    %eax,%eax
8010483b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104840:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104846:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010484c:	77 1a                	ja     80104868 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010484e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104851:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104855:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104858:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010485a:	83 f8 0a             	cmp    $0xa,%eax
8010485d:	75 e1                	jne    80104840 <acquire+0x50>
}
8010485f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104862:	c9                   	leave
80104863:	c3                   	ret
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104868:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010486c:	8d 51 34             	lea    0x34(%ecx),%edx
8010486f:	90                   	nop
    pcs[i] = 0;
80104870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104876:	83 c0 04             	add    $0x4,%eax
80104879:	39 c2                	cmp    %eax,%edx
8010487b:	75 f3                	jne    80104870 <acquire+0x80>
}
8010487d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104880:	c9                   	leave
80104881:	c3                   	ret
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104888:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010488b:	e8 40 f2 ff ff       	call   80103ad0 <mycpu>
80104890:	39 c3                	cmp    %eax,%ebx
80104892:	0f 85 72 ff ff ff    	jne    8010480a <acquire+0x1a>
  popcli();
80104898:	e8 53 fe ff ff       	call   801046f0 <popcli>
    panic("acquire");
8010489d:	83 ec 0c             	sub    $0xc,%esp
801048a0:	68 51 7a 10 80       	push   $0x80107a51
801048a5:	e8 d6 ba ff ff       	call   80100380 <panic>
801048aa:	66 90                	xchg   %ax,%ax
801048ac:	66 90                	xchg   %ax,%ax
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	8b 55 08             	mov    0x8(%ebp),%edx
801048b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ba:	53                   	push   %ebx
801048bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801048be:	89 d7                	mov    %edx,%edi
801048c0:	09 cf                	or     %ecx,%edi
801048c2:	83 e7 03             	and    $0x3,%edi
801048c5:	75 29                	jne    801048f0 <memset+0x40>
    c &= 0xFF;
801048c7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048ca:	c1 e0 18             	shl    $0x18,%eax
801048cd:	89 fb                	mov    %edi,%ebx
801048cf:	c1 e9 02             	shr    $0x2,%ecx
801048d2:	c1 e3 10             	shl    $0x10,%ebx
801048d5:	09 d8                	or     %ebx,%eax
801048d7:	09 f8                	or     %edi,%eax
801048d9:	c1 e7 08             	shl    $0x8,%edi
801048dc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801048de:	89 d7                	mov    %edx,%edi
801048e0:	fc                   	cld
801048e1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048e3:	5b                   	pop    %ebx
801048e4:	89 d0                	mov    %edx,%eax
801048e6:	5f                   	pop    %edi
801048e7:	5d                   	pop    %ebp
801048e8:	c3                   	ret
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048f0:	89 d7                	mov    %edx,%edi
801048f2:	fc                   	cld
801048f3:	f3 aa                	rep stos %al,%es:(%edi)
801048f5:	5b                   	pop    %ebx
801048f6:	89 d0                	mov    %edx,%eax
801048f8:	5f                   	pop    %edi
801048f9:	5d                   	pop    %ebp
801048fa:	c3                   	ret
801048fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104900 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	8b 75 10             	mov    0x10(%ebp),%esi
80104907:	8b 55 08             	mov    0x8(%ebp),%edx
8010490a:	53                   	push   %ebx
8010490b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010490e:	85 f6                	test   %esi,%esi
80104910:	74 2e                	je     80104940 <memcmp+0x40>
80104912:	01 c6                	add    %eax,%esi
80104914:	eb 14                	jmp    8010492a <memcmp+0x2a>
80104916:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010491d:	00 
8010491e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104920:	83 c0 01             	add    $0x1,%eax
80104923:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104926:	39 f0                	cmp    %esi,%eax
80104928:	74 16                	je     80104940 <memcmp+0x40>
    if(*s1 != *s2)
8010492a:	0f b6 0a             	movzbl (%edx),%ecx
8010492d:	0f b6 18             	movzbl (%eax),%ebx
80104930:	38 d9                	cmp    %bl,%cl
80104932:	74 ec                	je     80104920 <memcmp+0x20>
      return *s1 - *s2;
80104934:	0f b6 c1             	movzbl %cl,%eax
80104937:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104939:	5b                   	pop    %ebx
8010493a:	5e                   	pop    %esi
8010493b:	5d                   	pop    %ebp
8010493c:	c3                   	ret
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
80104940:	5b                   	pop    %ebx
  return 0;
80104941:	31 c0                	xor    %eax,%eax
}
80104943:	5e                   	pop    %esi
80104944:	5d                   	pop    %ebp
80104945:	c3                   	ret
80104946:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010494d:	00 
8010494e:	66 90                	xchg   %ax,%ax

80104950 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	8b 55 08             	mov    0x8(%ebp),%edx
80104957:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010495a:	56                   	push   %esi
8010495b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010495e:	39 d6                	cmp    %edx,%esi
80104960:	73 26                	jae    80104988 <memmove+0x38>
80104962:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104965:	39 fa                	cmp    %edi,%edx
80104967:	73 1f                	jae    80104988 <memmove+0x38>
80104969:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010496c:	85 c9                	test   %ecx,%ecx
8010496e:	74 0c                	je     8010497c <memmove+0x2c>
      *--d = *--s;
80104970:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104974:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104977:	83 e8 01             	sub    $0x1,%eax
8010497a:	73 f4                	jae    80104970 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010497c:	5e                   	pop    %esi
8010497d:	89 d0                	mov    %edx,%eax
8010497f:	5f                   	pop    %edi
80104980:	5d                   	pop    %ebp
80104981:	c3                   	ret
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104988:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010498b:	89 d7                	mov    %edx,%edi
8010498d:	85 c9                	test   %ecx,%ecx
8010498f:	74 eb                	je     8010497c <memmove+0x2c>
80104991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104998:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104999:	39 c6                	cmp    %eax,%esi
8010499b:	75 fb                	jne    80104998 <memmove+0x48>
}
8010499d:	5e                   	pop    %esi
8010499e:	89 d0                	mov    %edx,%eax
801049a0:	5f                   	pop    %edi
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret
801049a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049aa:	00 
801049ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801049b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801049b0:	eb 9e                	jmp    80104950 <memmove>
801049b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049b9:	00 
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	8b 75 10             	mov    0x10(%ebp),%esi
801049c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049ca:	53                   	push   %ebx
801049cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801049ce:	85 f6                	test   %esi,%esi
801049d0:	74 2e                	je     80104a00 <strncmp+0x40>
801049d2:	01 d6                	add    %edx,%esi
801049d4:	eb 18                	jmp    801049ee <strncmp+0x2e>
801049d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049dd:	00 
801049de:	66 90                	xchg   %ax,%ax
801049e0:	38 d8                	cmp    %bl,%al
801049e2:	75 14                	jne    801049f8 <strncmp+0x38>
    n--, p++, q++;
801049e4:	83 c2 01             	add    $0x1,%edx
801049e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049ea:	39 f2                	cmp    %esi,%edx
801049ec:	74 12                	je     80104a00 <strncmp+0x40>
801049ee:	0f b6 01             	movzbl (%ecx),%eax
801049f1:	0f b6 1a             	movzbl (%edx),%ebx
801049f4:	84 c0                	test   %al,%al
801049f6:	75 e8                	jne    801049e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049f8:	29 d8                	sub    %ebx,%eax
}
801049fa:	5b                   	pop    %ebx
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret
801049fe:	66 90                	xchg   %ax,%ax
80104a00:	5b                   	pop    %ebx
    return 0;
80104a01:	31 c0                	xor    %eax,%eax
}
80104a03:	5e                   	pop    %esi
80104a04:	5d                   	pop    %ebp
80104a05:	c3                   	ret
80104a06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a0d:	00 
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	56                   	push   %esi
80104a15:	8b 75 08             	mov    0x8(%ebp),%esi
80104a18:	53                   	push   %ebx
80104a19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a1c:	89 f0                	mov    %esi,%eax
80104a1e:	eb 15                	jmp    80104a35 <strncpy+0x25>
80104a20:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a24:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a27:	83 c0 01             	add    $0x1,%eax
80104a2a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a2e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a31:	84 d2                	test   %dl,%dl
80104a33:	74 09                	je     80104a3e <strncpy+0x2e>
80104a35:	89 cb                	mov    %ecx,%ebx
80104a37:	83 e9 01             	sub    $0x1,%ecx
80104a3a:	85 db                	test   %ebx,%ebx
80104a3c:	7f e2                	jg     80104a20 <strncpy+0x10>
    ;
  while(n-- > 0)
80104a3e:	89 c2                	mov    %eax,%edx
80104a40:	85 c9                	test   %ecx,%ecx
80104a42:	7e 17                	jle    80104a5b <strncpy+0x4b>
80104a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a48:	83 c2 01             	add    $0x1,%edx
80104a4b:	89 c1                	mov    %eax,%ecx
80104a4d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104a51:	29 d1                	sub    %edx,%ecx
80104a53:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a57:	85 c9                	test   %ecx,%ecx
80104a59:	7f ed                	jg     80104a48 <strncpy+0x38>
  return os;
}
80104a5b:	5b                   	pop    %ebx
80104a5c:	89 f0                	mov    %esi,%eax
80104a5e:	5e                   	pop    %esi
80104a5f:	5f                   	pop    %edi
80104a60:	5d                   	pop    %ebp
80104a61:	c3                   	ret
80104a62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a69:	00 
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	8b 55 10             	mov    0x10(%ebp),%edx
80104a77:	8b 75 08             	mov    0x8(%ebp),%esi
80104a7a:	53                   	push   %ebx
80104a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a7e:	85 d2                	test   %edx,%edx
80104a80:	7e 25                	jle    80104aa7 <safestrcpy+0x37>
80104a82:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a86:	89 f2                	mov    %esi,%edx
80104a88:	eb 16                	jmp    80104aa0 <safestrcpy+0x30>
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a90:	0f b6 08             	movzbl (%eax),%ecx
80104a93:	83 c0 01             	add    $0x1,%eax
80104a96:	83 c2 01             	add    $0x1,%edx
80104a99:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a9c:	84 c9                	test   %cl,%cl
80104a9e:	74 04                	je     80104aa4 <safestrcpy+0x34>
80104aa0:	39 d8                	cmp    %ebx,%eax
80104aa2:	75 ec                	jne    80104a90 <safestrcpy+0x20>
    ;
  *s = 0;
80104aa4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104aa7:	89 f0                	mov    %esi,%eax
80104aa9:	5b                   	pop    %ebx
80104aaa:	5e                   	pop    %esi
80104aab:	5d                   	pop    %ebp
80104aac:	c3                   	ret
80104aad:	8d 76 00             	lea    0x0(%esi),%esi

80104ab0 <strlen>:

int
strlen(const char *s)
{
80104ab0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ab1:	31 c0                	xor    %eax,%eax
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ab8:	80 3a 00             	cmpb   $0x0,(%edx)
80104abb:	74 0c                	je     80104ac9 <strlen+0x19>
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
80104ac0:	83 c0 01             	add    $0x1,%eax
80104ac3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ac7:	75 f7                	jne    80104ac0 <strlen+0x10>
    ;
  return n;
}
80104ac9:	5d                   	pop    %ebp
80104aca:	c3                   	ret

80104acb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104acb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104acf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ad3:	55                   	push   %ebp
  pushl %ebx
80104ad4:	53                   	push   %ebx
  pushl %esi
80104ad5:	56                   	push   %esi
  pushl %edi
80104ad6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ad7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ad9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104adb:	5f                   	pop    %edi
  popl %esi
80104adc:	5e                   	pop    %esi
  popl %ebx
80104add:	5b                   	pop    %ebx
  popl %ebp
80104ade:	5d                   	pop    %ebp
  ret
80104adf:	c3                   	ret

80104ae0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aea:	e8 61 f0 ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aef:	8b 00                	mov    (%eax),%eax
80104af1:	39 d8                	cmp    %ebx,%eax
80104af3:	76 1b                	jbe    80104b10 <fetchint+0x30>
80104af5:	8d 53 04             	lea    0x4(%ebx),%edx
80104af8:	39 d0                	cmp    %edx,%eax
80104afa:	72 14                	jb     80104b10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aff:	8b 13                	mov    (%ebx),%edx
80104b01:	89 10                	mov    %edx,(%eax)
  return 0;
80104b03:	31 c0                	xor    %eax,%eax
}
80104b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b08:	c9                   	leave
80104b09:	c3                   	ret
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb ee                	jmp    80104b05 <fetchint+0x25>
80104b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b1e:	00 
80104b1f:	90                   	nop

80104b20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
80104b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b2a:	e8 21 f0 ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz)
80104b2f:	39 18                	cmp    %ebx,(%eax)
80104b31:	76 2d                	jbe    80104b60 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b36:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b38:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b3a:	39 d3                	cmp    %edx,%ebx
80104b3c:	73 22                	jae    80104b60 <fetchstr+0x40>
80104b3e:	89 d8                	mov    %ebx,%eax
80104b40:	eb 0d                	jmp    80104b4f <fetchstr+0x2f>
80104b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b48:	83 c0 01             	add    $0x1,%eax
80104b4b:	39 c2                	cmp    %eax,%edx
80104b4d:	76 11                	jbe    80104b60 <fetchstr+0x40>
    if(*s == 0)
80104b4f:	80 38 00             	cmpb   $0x0,(%eax)
80104b52:	75 f4                	jne    80104b48 <fetchstr+0x28>
      return s - *pp;
80104b54:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b59:	c9                   	leave
80104b5a:	c3                   	ret
80104b5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b68:	c9                   	leave
80104b69:	c3                   	ret
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b75:	e8 d6 ef ff ff       	call   80103b50 <myproc>
80104b7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b7d:	8b 40 18             	mov    0x18(%eax),%eax
80104b80:	8b 40 44             	mov    0x44(%eax),%eax
80104b83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b86:	e8 c5 ef ff ff       	call   80103b50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b8e:	8b 00                	mov    (%eax),%eax
80104b90:	39 c6                	cmp    %eax,%esi
80104b92:	73 1c                	jae    80104bb0 <argint+0x40>
80104b94:	8d 53 08             	lea    0x8(%ebx),%edx
80104b97:	39 d0                	cmp    %edx,%eax
80104b99:	72 15                	jb     80104bb0 <argint+0x40>
  *ip = *(int*)(addr);
80104b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ba1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ba3:	31 c0                	xor    %eax,%eax
}
80104ba5:	5b                   	pop    %ebx
80104ba6:	5e                   	pop    %esi
80104ba7:	5d                   	pop    %ebp
80104ba8:	c3                   	ret
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb5:	eb ee                	jmp    80104ba5 <argint+0x35>
80104bb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bbe:	00 
80104bbf:	90                   	nop

80104bc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	53                   	push   %ebx
80104bc6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104bc9:	e8 82 ef ff ff       	call   80103b50 <myproc>
80104bce:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd0:	e8 7b ef ff ff       	call   80103b50 <myproc>
80104bd5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bd8:	8b 40 18             	mov    0x18(%eax),%eax
80104bdb:	8b 40 44             	mov    0x44(%eax),%eax
80104bde:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104be1:	e8 6a ef ff ff       	call   80103b50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104be9:	8b 00                	mov    (%eax),%eax
80104beb:	39 c7                	cmp    %eax,%edi
80104bed:	73 31                	jae    80104c20 <argptr+0x60>
80104bef:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104bf2:	39 c8                	cmp    %ecx,%eax
80104bf4:	72 2a                	jb     80104c20 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bf6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104bf9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bfc:	85 d2                	test   %edx,%edx
80104bfe:	78 20                	js     80104c20 <argptr+0x60>
80104c00:	8b 16                	mov    (%esi),%edx
80104c02:	39 c2                	cmp    %eax,%edx
80104c04:	76 1a                	jbe    80104c20 <argptr+0x60>
80104c06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c09:	01 c3                	add    %eax,%ebx
80104c0b:	39 da                	cmp    %ebx,%edx
80104c0d:	72 11                	jb     80104c20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c12:	89 02                	mov    %eax,(%edx)
  return 0;
80104c14:	31 c0                	xor    %eax,%eax
}
80104c16:	83 c4 0c             	add    $0xc,%esp
80104c19:	5b                   	pop    %ebx
80104c1a:	5e                   	pop    %esi
80104c1b:	5f                   	pop    %edi
80104c1c:	5d                   	pop    %ebp
80104c1d:	c3                   	ret
80104c1e:	66 90                	xchg   %ax,%ax
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c25:	eb ef                	jmp    80104c16 <argptr+0x56>
80104c27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c2e:	00 
80104c2f:	90                   	nop

80104c30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c35:	e8 16 ef ff ff       	call   80103b50 <myproc>
80104c3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c3d:	8b 40 18             	mov    0x18(%eax),%eax
80104c40:	8b 40 44             	mov    0x44(%eax),%eax
80104c43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c46:	e8 05 ef ff ff       	call   80103b50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c4e:	8b 00                	mov    (%eax),%eax
80104c50:	39 c6                	cmp    %eax,%esi
80104c52:	73 44                	jae    80104c98 <argstr+0x68>
80104c54:	8d 53 08             	lea    0x8(%ebx),%edx
80104c57:	39 d0                	cmp    %edx,%eax
80104c59:	72 3d                	jb     80104c98 <argstr+0x68>
  *ip = *(int*)(addr);
80104c5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c5e:	e8 ed ee ff ff       	call   80103b50 <myproc>
  if(addr >= curproc->sz)
80104c63:	3b 18                	cmp    (%eax),%ebx
80104c65:	73 31                	jae    80104c98 <argstr+0x68>
  *pp = (char*)addr;
80104c67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c6e:	39 d3                	cmp    %edx,%ebx
80104c70:	73 26                	jae    80104c98 <argstr+0x68>
80104c72:	89 d8                	mov    %ebx,%eax
80104c74:	eb 11                	jmp    80104c87 <argstr+0x57>
80104c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c7d:	00 
80104c7e:	66 90                	xchg   %ax,%ax
80104c80:	83 c0 01             	add    $0x1,%eax
80104c83:	39 c2                	cmp    %eax,%edx
80104c85:	76 11                	jbe    80104c98 <argstr+0x68>
    if(*s == 0)
80104c87:	80 38 00             	cmpb   $0x0,(%eax)
80104c8a:	75 f4                	jne    80104c80 <argstr+0x50>
      return s - *pp;
80104c8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c8e:	5b                   	pop    %ebx
80104c8f:	5e                   	pop    %esi
80104c90:	5d                   	pop    %ebp
80104c91:	c3                   	ret
80104c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c98:	5b                   	pop    %ebx
    return -1;
80104c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c9e:	5e                   	pop    %esi
80104c9f:	5d                   	pop    %ebp
80104ca0:	c3                   	ret
80104ca1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ca8:	00 
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cb0 <syscall>:
[SYS_unblock]   sys_unblock,     
};

void
syscall(void)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104cb7:	e8 94 ee ff ff       	call   80103b50 <myproc>
80104cbc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cbe:	8b 40 18             	mov    0x18(%eax),%eax
80104cc1:	8b 40 1c             	mov    0x1c(%eax),%eax

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cc7:	83 fa 17             	cmp    $0x17,%edx
80104cca:	77 24                	ja     80104cf0 <syscall+0x40>
80104ccc:	8b 14 85 c0 80 10 80 	mov    -0x7fef7f40(,%eax,4),%edx
80104cd3:	85 d2                	test   %edx,%edx
80104cd5:	74 19                	je     80104cf0 <syscall+0x40>
    // Check if the syscall is blocked
    if (curproc->blocked_syscalls[num]) {
80104cd7:	8b 4c 83 7c          	mov    0x7c(%ebx,%eax,4),%ecx
80104cdb:	85 c9                	test   %ecx,%ecx
80104cdd:	75 39                	jne    80104d18 <syscall+0x68>
      cprintf("syscall %d is blocked\n", num);
      curproc->tf->eax = -1; // Return error
      return;
    }

    curproc->tf->eax = syscalls[num]();
80104cdf:	ff d2                	call   *%edx
80104ce1:	89 c2                	mov    %eax,%edx
80104ce3:	8b 43 18             	mov    0x18(%ebx),%eax
80104ce6:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ce9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cec:	c9                   	leave
80104ced:	c3                   	ret
80104cee:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104cf0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cf1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cf4:	50                   	push   %eax
80104cf5:	ff 73 10             	push   0x10(%ebx)
80104cf8:	68 70 7a 10 80       	push   $0x80107a70
80104cfd:	e8 9e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d02:	8b 43 18             	mov    0x18(%ebx),%eax
80104d05:	83 c4 10             	add    $0x10,%esp
80104d08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d12:	c9                   	leave
80104d13:	c3                   	ret
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("syscall %d is blocked\n", num);
80104d18:	83 ec 08             	sub    $0x8,%esp
80104d1b:	50                   	push   %eax
80104d1c:	68 59 7a 10 80       	push   $0x80107a59
80104d21:	e8 7a b9 ff ff       	call   801006a0 <cprintf>
      curproc->tf->eax = -1; // Return error
80104d26:	8b 43 18             	mov    0x18(%ebx),%eax
      return;
80104d29:	83 c4 10             	add    $0x10,%esp
      curproc->tf->eax = -1; // Return error
80104d2c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
      return;
80104d33:	eb da                	jmp    80104d0f <syscall+0x5f>
80104d35:	66 90                	xchg   %ax,%ax
80104d37:	66 90                	xchg   %ax,%ax
80104d39:	66 90                	xchg   %ax,%ax
80104d3b:	66 90                	xchg   %ax,%ax
80104d3d:	66 90                	xchg   %ax,%ax
80104d3f:	90                   	nop

80104d40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d45:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d48:	53                   	push   %ebx
80104d49:	83 ec 34             	sub    $0x34,%esp
80104d4c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d52:	57                   	push   %edi
80104d53:	50                   	push   %eax
{
80104d54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d57:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d5a:	e8 91 d4 ff ff       	call   801021f0 <nameiparent>
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	85 c0                	test   %eax,%eax
80104d64:	0f 84 46 01 00 00    	je     80104eb0 <create+0x170>
    return 0;
  ilock(dp);
80104d6a:	83 ec 0c             	sub    $0xc,%esp
80104d6d:	89 c3                	mov    %eax,%ebx
80104d6f:	50                   	push   %eax
80104d70:	e8 3b cb ff ff       	call   801018b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d75:	83 c4 0c             	add    $0xc,%esp
80104d78:	6a 00                	push   $0x0
80104d7a:	57                   	push   %edi
80104d7b:	53                   	push   %ebx
80104d7c:	e8 8f d0 ff ff       	call   80101e10 <dirlookup>
80104d81:	83 c4 10             	add    $0x10,%esp
80104d84:	89 c6                	mov    %eax,%esi
80104d86:	85 c0                	test   %eax,%eax
80104d88:	74 56                	je     80104de0 <create+0xa0>
    iunlockput(dp);
80104d8a:	83 ec 0c             	sub    $0xc,%esp
80104d8d:	53                   	push   %ebx
80104d8e:	e8 ad cd ff ff       	call   80101b40 <iunlockput>
    ilock(ip);
80104d93:	89 34 24             	mov    %esi,(%esp)
80104d96:	e8 15 cb ff ff       	call   801018b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d9b:	83 c4 10             	add    $0x10,%esp
80104d9e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104da3:	75 1b                	jne    80104dc0 <create+0x80>
80104da5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104daa:	75 14                	jne    80104dc0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104daf:	89 f0                	mov    %esi,%eax
80104db1:	5b                   	pop    %ebx
80104db2:	5e                   	pop    %esi
80104db3:	5f                   	pop    %edi
80104db4:	5d                   	pop    %ebp
80104db5:	c3                   	ret
80104db6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dbd:	00 
80104dbe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104dc0:	83 ec 0c             	sub    $0xc,%esp
80104dc3:	56                   	push   %esi
    return 0;
80104dc4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104dc6:	e8 75 cd ff ff       	call   80101b40 <iunlockput>
    return 0;
80104dcb:	83 c4 10             	add    $0x10,%esp
}
80104dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dd1:	89 f0                	mov    %esi,%eax
80104dd3:	5b                   	pop    %ebx
80104dd4:	5e                   	pop    %esi
80104dd5:	5f                   	pop    %edi
80104dd6:	5d                   	pop    %ebp
80104dd7:	c3                   	ret
80104dd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ddf:	00 
  if((ip = ialloc(dp->dev, type)) == 0)
80104de0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104de4:	83 ec 08             	sub    $0x8,%esp
80104de7:	50                   	push   %eax
80104de8:	ff 33                	push   (%ebx)
80104dea:	e8 51 c9 ff ff       	call   80101740 <ialloc>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	89 c6                	mov    %eax,%esi
80104df4:	85 c0                	test   %eax,%eax
80104df6:	0f 84 cd 00 00 00    	je     80104ec9 <create+0x189>
  ilock(ip);
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	50                   	push   %eax
80104e00:	e8 ab ca ff ff       	call   801018b0 <ilock>
  ip->major = major;
80104e05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e15:	b8 01 00 00 00       	mov    $0x1,%eax
80104e1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e1e:	89 34 24             	mov    %esi,(%esp)
80104e21:	e8 da c9 ff ff       	call   80101800 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e26:	83 c4 10             	add    $0x10,%esp
80104e29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e2e:	74 30                	je     80104e60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e30:	83 ec 04             	sub    $0x4,%esp
80104e33:	ff 76 04             	push   0x4(%esi)
80104e36:	57                   	push   %edi
80104e37:	53                   	push   %ebx
80104e38:	e8 d3 d2 ff ff       	call   80102110 <dirlink>
80104e3d:	83 c4 10             	add    $0x10,%esp
80104e40:	85 c0                	test   %eax,%eax
80104e42:	78 78                	js     80104ebc <create+0x17c>
  iunlockput(dp);
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	53                   	push   %ebx
80104e48:	e8 f3 cc ff ff       	call   80101b40 <iunlockput>
  return ip;
80104e4d:	83 c4 10             	add    $0x10,%esp
}
80104e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e53:	89 f0                	mov    %esi,%eax
80104e55:	5b                   	pop    %ebx
80104e56:	5e                   	pop    %esi
80104e57:	5f                   	pop    %edi
80104e58:	5d                   	pop    %ebp
80104e59:	c3                   	ret
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e68:	53                   	push   %ebx
80104e69:	e8 92 c9 ff ff       	call   80101800 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e6e:	83 c4 0c             	add    $0xc,%esp
80104e71:	ff 76 04             	push   0x4(%esi)
80104e74:	68 a8 7a 10 80       	push   $0x80107aa8
80104e79:	56                   	push   %esi
80104e7a:	e8 91 d2 ff ff       	call   80102110 <dirlink>
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	85 c0                	test   %eax,%eax
80104e84:	78 18                	js     80104e9e <create+0x15e>
80104e86:	83 ec 04             	sub    $0x4,%esp
80104e89:	ff 73 04             	push   0x4(%ebx)
80104e8c:	68 a7 7a 10 80       	push   $0x80107aa7
80104e91:	56                   	push   %esi
80104e92:	e8 79 d2 ff ff       	call   80102110 <dirlink>
80104e97:	83 c4 10             	add    $0x10,%esp
80104e9a:	85 c0                	test   %eax,%eax
80104e9c:	79 92                	jns    80104e30 <create+0xf0>
      panic("create dots");
80104e9e:	83 ec 0c             	sub    $0xc,%esp
80104ea1:	68 9b 7a 10 80       	push   $0x80107a9b
80104ea6:	e8 d5 b4 ff ff       	call   80100380 <panic>
80104eab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80104eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104eb3:	31 f6                	xor    %esi,%esi
}
80104eb5:	5b                   	pop    %ebx
80104eb6:	89 f0                	mov    %esi,%eax
80104eb8:	5e                   	pop    %esi
80104eb9:	5f                   	pop    %edi
80104eba:	5d                   	pop    %ebp
80104ebb:	c3                   	ret
    panic("create: dirlink");
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	68 aa 7a 10 80       	push   $0x80107aaa
80104ec4:	e8 b7 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104ec9:	83 ec 0c             	sub    $0xc,%esp
80104ecc:	68 8c 7a 10 80       	push   $0x80107a8c
80104ed1:	e8 aa b4 ff ff       	call   80100380 <panic>
80104ed6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104edd:	00 
80104ede:	66 90                	xchg   %ax,%ax

80104ee0 <sys_dup>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ee5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ee8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eeb:	50                   	push   %eax
80104eec:	6a 00                	push   $0x0
80104eee:	e8 7d fc ff ff       	call   80104b70 <argint>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 36                	js     80104f30 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104efa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104efe:	77 30                	ja     80104f30 <sys_dup+0x50>
80104f00:	e8 4b ec ff ff       	call   80103b50 <myproc>
80104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f0c:	85 f6                	test   %esi,%esi
80104f0e:	74 20                	je     80104f30 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f10:	e8 3b ec ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f15:	31 db                	xor    %ebx,%ebx
80104f17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f1e:	00 
80104f1f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104f20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f24:	85 d2                	test   %edx,%edx
80104f26:	74 18                	je     80104f40 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f28:	83 c3 01             	add    $0x1,%ebx
80104f2b:	83 fb 10             	cmp    $0x10,%ebx
80104f2e:	75 f0                	jne    80104f20 <sys_dup+0x40>
}
80104f30:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f38:	89 d8                	mov    %ebx,%eax
80104f3a:	5b                   	pop    %ebx
80104f3b:	5e                   	pop    %esi
80104f3c:	5d                   	pop    %ebp
80104f3d:	c3                   	ret
80104f3e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f40:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f43:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f47:	56                   	push   %esi
80104f48:	e8 83 c0 ff ff       	call   80100fd0 <filedup>
  return fd;
80104f4d:	83 c4 10             	add    $0x10,%esp
}
80104f50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f53:	89 d8                	mov    %ebx,%eax
80104f55:	5b                   	pop    %ebx
80104f56:	5e                   	pop    %esi
80104f57:	5d                   	pop    %ebp
80104f58:	c3                   	ret
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f60 <sys_read>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f6b:	53                   	push   %ebx
80104f6c:	6a 00                	push   $0x0
80104f6e:	e8 fd fb ff ff       	call   80104b70 <argint>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 5e                	js     80104fd8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f7e:	77 58                	ja     80104fd8 <sys_read+0x78>
80104f80:	e8 cb eb ff ff       	call   80103b50 <myproc>
80104f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f8c:	85 f6                	test   %esi,%esi
80104f8e:	74 48                	je     80104fd8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f90:	83 ec 08             	sub    $0x8,%esp
80104f93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f96:	50                   	push   %eax
80104f97:	6a 02                	push   $0x2
80104f99:	e8 d2 fb ff ff       	call   80104b70 <argint>
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	78 33                	js     80104fd8 <sys_read+0x78>
80104fa5:	83 ec 04             	sub    $0x4,%esp
80104fa8:	ff 75 f0             	push   -0x10(%ebp)
80104fab:	53                   	push   %ebx
80104fac:	6a 01                	push   $0x1
80104fae:	e8 0d fc ff ff       	call   80104bc0 <argptr>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 1e                	js     80104fd8 <sys_read+0x78>
  return fileread(f, p, n);
80104fba:	83 ec 04             	sub    $0x4,%esp
80104fbd:	ff 75 f0             	push   -0x10(%ebp)
80104fc0:	ff 75 f4             	push   -0xc(%ebp)
80104fc3:	56                   	push   %esi
80104fc4:	e8 87 c1 ff ff       	call   80101150 <fileread>
80104fc9:	83 c4 10             	add    $0x10,%esp
}
80104fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fcf:	5b                   	pop    %ebx
80104fd0:	5e                   	pop    %esi
80104fd1:	5d                   	pop    %ebp
80104fd2:	c3                   	ret
80104fd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ed                	jmp    80104fcc <sys_read+0x6c>
80104fdf:	90                   	nop

80104fe0 <sys_write>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	53                   	push   %ebx
80104fec:	6a 00                	push   $0x0
80104fee:	e8 7d fb ff ff       	call   80104b70 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 5e                	js     80105058 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 58                	ja     80105058 <sys_write+0x78>
80105000:	e8 4b eb ff ff       	call   80103b50 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010500c:	85 f6                	test   %esi,%esi
8010500e:	74 48                	je     80105058 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105010:	83 ec 08             	sub    $0x8,%esp
80105013:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105016:	50                   	push   %eax
80105017:	6a 02                	push   $0x2
80105019:	e8 52 fb ff ff       	call   80104b70 <argint>
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	85 c0                	test   %eax,%eax
80105023:	78 33                	js     80105058 <sys_write+0x78>
80105025:	83 ec 04             	sub    $0x4,%esp
80105028:	ff 75 f0             	push   -0x10(%ebp)
8010502b:	53                   	push   %ebx
8010502c:	6a 01                	push   $0x1
8010502e:	e8 8d fb ff ff       	call   80104bc0 <argptr>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 1e                	js     80105058 <sys_write+0x78>
  return filewrite(f, p, n);
8010503a:	83 ec 04             	sub    $0x4,%esp
8010503d:	ff 75 f0             	push   -0x10(%ebp)
80105040:	ff 75 f4             	push   -0xc(%ebp)
80105043:	56                   	push   %esi
80105044:	e8 97 c1 ff ff       	call   801011e0 <filewrite>
80105049:	83 c4 10             	add    $0x10,%esp
}
8010504c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010504f:	5b                   	pop    %ebx
80105050:	5e                   	pop    %esi
80105051:	5d                   	pop    %ebp
80105052:	c3                   	ret
80105053:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb ed                	jmp    8010504c <sys_write+0x6c>
8010505f:	90                   	nop

80105060 <sys_close>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105065:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105068:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506b:	50                   	push   %eax
8010506c:	6a 00                	push   $0x0
8010506e:	e8 fd fa ff ff       	call   80104b70 <argint>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 3e                	js     801050b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010507e:	77 38                	ja     801050b8 <sys_close+0x58>
80105080:	e8 cb ea ff ff       	call   80103b50 <myproc>
80105085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105088:	8d 5a 08             	lea    0x8(%edx),%ebx
8010508b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010508f:	85 f6                	test   %esi,%esi
80105091:	74 25                	je     801050b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105093:	e8 b8 ea ff ff       	call   80103b50 <myproc>
  fileclose(f);
80105098:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010509b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050a2:	00 
  fileclose(f);
801050a3:	56                   	push   %esi
801050a4:	e8 77 bf ff ff       	call   80101020 <fileclose>
  return 0;
801050a9:	83 c4 10             	add    $0x10,%esp
801050ac:	31 c0                	xor    %eax,%eax
}
801050ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b1:	5b                   	pop    %ebx
801050b2:	5e                   	pop    %esi
801050b3:	5d                   	pop    %ebp
801050b4:	c3                   	ret
801050b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bd:	eb ef                	jmp    801050ae <sys_close+0x4e>
801050bf:	90                   	nop

801050c0 <sys_fstat>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050cb:	53                   	push   %ebx
801050cc:	6a 00                	push   $0x0
801050ce:	e8 9d fa ff ff       	call   80104b70 <argint>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	78 46                	js     80105120 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050de:	77 40                	ja     80105120 <sys_fstat+0x60>
801050e0:	e8 6b ea ff ff       	call   80103b50 <myproc>
801050e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050ec:	85 f6                	test   %esi,%esi
801050ee:	74 30                	je     80105120 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050f0:	83 ec 04             	sub    $0x4,%esp
801050f3:	6a 14                	push   $0x14
801050f5:	53                   	push   %ebx
801050f6:	6a 01                	push   $0x1
801050f8:	e8 c3 fa ff ff       	call   80104bc0 <argptr>
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	85 c0                	test   %eax,%eax
80105102:	78 1c                	js     80105120 <sys_fstat+0x60>
  return filestat(f, st);
80105104:	83 ec 08             	sub    $0x8,%esp
80105107:	ff 75 f4             	push   -0xc(%ebp)
8010510a:	56                   	push   %esi
8010510b:	e8 f0 bf ff ff       	call   80101100 <filestat>
80105110:	83 c4 10             	add    $0x10,%esp
}
80105113:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105116:	5b                   	pop    %ebx
80105117:	5e                   	pop    %esi
80105118:	5d                   	pop    %ebp
80105119:	c3                   	ret
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105125:	eb ec                	jmp    80105113 <sys_fstat+0x53>
80105127:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010512e:	00 
8010512f:	90                   	nop

80105130 <sys_link>:
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105135:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105138:	53                   	push   %ebx
80105139:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010513c:	50                   	push   %eax
8010513d:	6a 00                	push   $0x0
8010513f:	e8 ec fa ff ff       	call   80104c30 <argstr>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	0f 88 fb 00 00 00    	js     8010524a <sys_link+0x11a>
8010514f:	83 ec 08             	sub    $0x8,%esp
80105152:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105155:	50                   	push   %eax
80105156:	6a 01                	push   $0x1
80105158:	e8 d3 fa ff ff       	call   80104c30 <argstr>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	0f 88 e2 00 00 00    	js     8010524a <sys_link+0x11a>
  begin_op();
80105168:	e8 23 dd ff ff       	call   80102e90 <begin_op>
  if((ip = namei(old)) == 0){
8010516d:	83 ec 0c             	sub    $0xc,%esp
80105170:	ff 75 d4             	push   -0x2c(%ebp)
80105173:	e8 58 d0 ff ff       	call   801021d0 <namei>
80105178:	83 c4 10             	add    $0x10,%esp
8010517b:	89 c3                	mov    %eax,%ebx
8010517d:	85 c0                	test   %eax,%eax
8010517f:	0f 84 e4 00 00 00    	je     80105269 <sys_link+0x139>
  ilock(ip);
80105185:	83 ec 0c             	sub    $0xc,%esp
80105188:	50                   	push   %eax
80105189:	e8 22 c7 ff ff       	call   801018b0 <ilock>
  if(ip->type == T_DIR){
8010518e:	83 c4 10             	add    $0x10,%esp
80105191:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105196:	0f 84 b5 00 00 00    	je     80105251 <sys_link+0x121>
  iupdate(ip);
8010519c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010519f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051a7:	53                   	push   %ebx
801051a8:	e8 53 c6 ff ff       	call   80101800 <iupdate>
  iunlock(ip);
801051ad:	89 1c 24             	mov    %ebx,(%esp)
801051b0:	e8 db c7 ff ff       	call   80101990 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051b5:	58                   	pop    %eax
801051b6:	5a                   	pop    %edx
801051b7:	57                   	push   %edi
801051b8:	ff 75 d0             	push   -0x30(%ebp)
801051bb:	e8 30 d0 ff ff       	call   801021f0 <nameiparent>
801051c0:	83 c4 10             	add    $0x10,%esp
801051c3:	89 c6                	mov    %eax,%esi
801051c5:	85 c0                	test   %eax,%eax
801051c7:	74 5b                	je     80105224 <sys_link+0xf4>
  ilock(dp);
801051c9:	83 ec 0c             	sub    $0xc,%esp
801051cc:	50                   	push   %eax
801051cd:	e8 de c6 ff ff       	call   801018b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051d2:	8b 03                	mov    (%ebx),%eax
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	39 06                	cmp    %eax,(%esi)
801051d9:	75 3d                	jne    80105218 <sys_link+0xe8>
801051db:	83 ec 04             	sub    $0x4,%esp
801051de:	ff 73 04             	push   0x4(%ebx)
801051e1:	57                   	push   %edi
801051e2:	56                   	push   %esi
801051e3:	e8 28 cf ff ff       	call   80102110 <dirlink>
801051e8:	83 c4 10             	add    $0x10,%esp
801051eb:	85 c0                	test   %eax,%eax
801051ed:	78 29                	js     80105218 <sys_link+0xe8>
  iunlockput(dp);
801051ef:	83 ec 0c             	sub    $0xc,%esp
801051f2:	56                   	push   %esi
801051f3:	e8 48 c9 ff ff       	call   80101b40 <iunlockput>
  iput(ip);
801051f8:	89 1c 24             	mov    %ebx,(%esp)
801051fb:	e8 e0 c7 ff ff       	call   801019e0 <iput>
  end_op();
80105200:	e8 fb dc ff ff       	call   80102f00 <end_op>
  return 0;
80105205:	83 c4 10             	add    $0x10,%esp
80105208:	31 c0                	xor    %eax,%eax
}
8010520a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010520d:	5b                   	pop    %ebx
8010520e:	5e                   	pop    %esi
8010520f:	5f                   	pop    %edi
80105210:	5d                   	pop    %ebp
80105211:	c3                   	ret
80105212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	56                   	push   %esi
8010521c:	e8 1f c9 ff ff       	call   80101b40 <iunlockput>
    goto bad;
80105221:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105224:	83 ec 0c             	sub    $0xc,%esp
80105227:	53                   	push   %ebx
80105228:	e8 83 c6 ff ff       	call   801018b0 <ilock>
  ip->nlink--;
8010522d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105232:	89 1c 24             	mov    %ebx,(%esp)
80105235:	e8 c6 c5 ff ff       	call   80101800 <iupdate>
  iunlockput(ip);
8010523a:	89 1c 24             	mov    %ebx,(%esp)
8010523d:	e8 fe c8 ff ff       	call   80101b40 <iunlockput>
  end_op();
80105242:	e8 b9 dc ff ff       	call   80102f00 <end_op>
  return -1;
80105247:	83 c4 10             	add    $0x10,%esp
8010524a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524f:	eb b9                	jmp    8010520a <sys_link+0xda>
    iunlockput(ip);
80105251:	83 ec 0c             	sub    $0xc,%esp
80105254:	53                   	push   %ebx
80105255:	e8 e6 c8 ff ff       	call   80101b40 <iunlockput>
    end_op();
8010525a:	e8 a1 dc ff ff       	call   80102f00 <end_op>
    return -1;
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105267:	eb a1                	jmp    8010520a <sys_link+0xda>
    end_op();
80105269:	e8 92 dc ff ff       	call   80102f00 <end_op>
    return -1;
8010526e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105273:	eb 95                	jmp    8010520a <sys_link+0xda>
80105275:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010527c:	00 
8010527d:	8d 76 00             	lea    0x0(%esi),%esi

80105280 <sys_unlink>:
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105285:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105288:	53                   	push   %ebx
80105289:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010528c:	50                   	push   %eax
8010528d:	6a 00                	push   $0x0
8010528f:	e8 9c f9 ff ff       	call   80104c30 <argstr>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	0f 88 7a 01 00 00    	js     80105419 <sys_unlink+0x199>
  begin_op();
8010529f:	e8 ec db ff ff       	call   80102e90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052a7:	83 ec 08             	sub    $0x8,%esp
801052aa:	53                   	push   %ebx
801052ab:	ff 75 c0             	push   -0x40(%ebp)
801052ae:	e8 3d cf ff ff       	call   801021f0 <nameiparent>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052b9:	85 c0                	test   %eax,%eax
801052bb:	0f 84 62 01 00 00    	je     80105423 <sys_unlink+0x1a3>
  ilock(dp);
801052c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052c4:	83 ec 0c             	sub    $0xc,%esp
801052c7:	57                   	push   %edi
801052c8:	e8 e3 c5 ff ff       	call   801018b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052cd:	58                   	pop    %eax
801052ce:	5a                   	pop    %edx
801052cf:	68 a8 7a 10 80       	push   $0x80107aa8
801052d4:	53                   	push   %ebx
801052d5:	e8 16 cb ff ff       	call   80101df0 <namecmp>
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	85 c0                	test   %eax,%eax
801052df:	0f 84 fb 00 00 00    	je     801053e0 <sys_unlink+0x160>
801052e5:	83 ec 08             	sub    $0x8,%esp
801052e8:	68 a7 7a 10 80       	push   $0x80107aa7
801052ed:	53                   	push   %ebx
801052ee:	e8 fd ca ff ff       	call   80101df0 <namecmp>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	0f 84 e2 00 00 00    	je     801053e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052fe:	83 ec 04             	sub    $0x4,%esp
80105301:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105304:	50                   	push   %eax
80105305:	53                   	push   %ebx
80105306:	57                   	push   %edi
80105307:	e8 04 cb ff ff       	call   80101e10 <dirlookup>
8010530c:	83 c4 10             	add    $0x10,%esp
8010530f:	89 c3                	mov    %eax,%ebx
80105311:	85 c0                	test   %eax,%eax
80105313:	0f 84 c7 00 00 00    	je     801053e0 <sys_unlink+0x160>
  ilock(ip);
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	50                   	push   %eax
8010531d:	e8 8e c5 ff ff       	call   801018b0 <ilock>
  if(ip->nlink < 1)
80105322:	83 c4 10             	add    $0x10,%esp
80105325:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010532a:	0f 8e 1c 01 00 00    	jle    8010544c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105330:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105335:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105338:	74 66                	je     801053a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010533a:	83 ec 04             	sub    $0x4,%esp
8010533d:	6a 10                	push   $0x10
8010533f:	6a 00                	push   $0x0
80105341:	57                   	push   %edi
80105342:	e8 69 f5 ff ff       	call   801048b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105347:	6a 10                	push   $0x10
80105349:	ff 75 c4             	push   -0x3c(%ebp)
8010534c:	57                   	push   %edi
8010534d:	ff 75 b4             	push   -0x4c(%ebp)
80105350:	e8 6b c9 ff ff       	call   80101cc0 <writei>
80105355:	83 c4 20             	add    $0x20,%esp
80105358:	83 f8 10             	cmp    $0x10,%eax
8010535b:	0f 85 de 00 00 00    	jne    8010543f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105361:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105366:	0f 84 94 00 00 00    	je     80105400 <sys_unlink+0x180>
  iunlockput(dp);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	ff 75 b4             	push   -0x4c(%ebp)
80105372:	e8 c9 c7 ff ff       	call   80101b40 <iunlockput>
  ip->nlink--;
80105377:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010537c:	89 1c 24             	mov    %ebx,(%esp)
8010537f:	e8 7c c4 ff ff       	call   80101800 <iupdate>
  iunlockput(ip);
80105384:	89 1c 24             	mov    %ebx,(%esp)
80105387:	e8 b4 c7 ff ff       	call   80101b40 <iunlockput>
  end_op();
8010538c:	e8 6f db ff ff       	call   80102f00 <end_op>
  return 0;
80105391:	83 c4 10             	add    $0x10,%esp
80105394:	31 c0                	xor    %eax,%eax
}
80105396:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105399:	5b                   	pop    %ebx
8010539a:	5e                   	pop    %esi
8010539b:	5f                   	pop    %edi
8010539c:	5d                   	pop    %ebp
8010539d:	c3                   	ret
8010539e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053a4:	76 94                	jbe    8010533a <sys_unlink+0xba>
801053a6:	be 20 00 00 00       	mov    $0x20,%esi
801053ab:	eb 0b                	jmp    801053b8 <sys_unlink+0x138>
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
801053b0:	83 c6 10             	add    $0x10,%esi
801053b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053b6:	73 82                	jae    8010533a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053b8:	6a 10                	push   $0x10
801053ba:	56                   	push   %esi
801053bb:	57                   	push   %edi
801053bc:	53                   	push   %ebx
801053bd:	e8 fe c7 ff ff       	call   80101bc0 <readi>
801053c2:	83 c4 10             	add    $0x10,%esp
801053c5:	83 f8 10             	cmp    $0x10,%eax
801053c8:	75 68                	jne    80105432 <sys_unlink+0x1b2>
    if(de.inum != 0)
801053ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053cf:	74 df                	je     801053b0 <sys_unlink+0x130>
    iunlockput(ip);
801053d1:	83 ec 0c             	sub    $0xc,%esp
801053d4:	53                   	push   %ebx
801053d5:	e8 66 c7 ff ff       	call   80101b40 <iunlockput>
    goto bad;
801053da:	83 c4 10             	add    $0x10,%esp
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	ff 75 b4             	push   -0x4c(%ebp)
801053e6:	e8 55 c7 ff ff       	call   80101b40 <iunlockput>
  end_op();
801053eb:	e8 10 db ff ff       	call   80102f00 <end_op>
  return -1;
801053f0:	83 c4 10             	add    $0x10,%esp
801053f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f8:	eb 9c                	jmp    80105396 <sys_unlink+0x116>
801053fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105400:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105403:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105406:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010540b:	50                   	push   %eax
8010540c:	e8 ef c3 ff ff       	call   80101800 <iupdate>
80105411:	83 c4 10             	add    $0x10,%esp
80105414:	e9 53 ff ff ff       	jmp    8010536c <sys_unlink+0xec>
    return -1;
80105419:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541e:	e9 73 ff ff ff       	jmp    80105396 <sys_unlink+0x116>
    end_op();
80105423:	e8 d8 da ff ff       	call   80102f00 <end_op>
    return -1;
80105428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542d:	e9 64 ff ff ff       	jmp    80105396 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105432:	83 ec 0c             	sub    $0xc,%esp
80105435:	68 cc 7a 10 80       	push   $0x80107acc
8010543a:	e8 41 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010543f:	83 ec 0c             	sub    $0xc,%esp
80105442:	68 de 7a 10 80       	push   $0x80107ade
80105447:	e8 34 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010544c:	83 ec 0c             	sub    $0xc,%esp
8010544f:	68 ba 7a 10 80       	push   $0x80107aba
80105454:	e8 27 af ff ff       	call   80100380 <panic>
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_open>:

int
sys_open(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105465:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105468:	53                   	push   %ebx
80105469:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010546c:	50                   	push   %eax
8010546d:	6a 00                	push   $0x0
8010546f:	e8 bc f7 ff ff       	call   80104c30 <argstr>
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	85 c0                	test   %eax,%eax
80105479:	0f 88 8e 00 00 00    	js     8010550d <sys_open+0xad>
8010547f:	83 ec 08             	sub    $0x8,%esp
80105482:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105485:	50                   	push   %eax
80105486:	6a 01                	push   $0x1
80105488:	e8 e3 f6 ff ff       	call   80104b70 <argint>
8010548d:	83 c4 10             	add    $0x10,%esp
80105490:	85 c0                	test   %eax,%eax
80105492:	78 79                	js     8010550d <sys_open+0xad>
    return -1;

  begin_op();
80105494:	e8 f7 d9 ff ff       	call   80102e90 <begin_op>

  if(omode & O_CREATE){
80105499:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010549d:	75 79                	jne    80105518 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010549f:	83 ec 0c             	sub    $0xc,%esp
801054a2:	ff 75 e0             	push   -0x20(%ebp)
801054a5:	e8 26 cd ff ff       	call   801021d0 <namei>
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	89 c6                	mov    %eax,%esi
801054af:	85 c0                	test   %eax,%eax
801054b1:	0f 84 7e 00 00 00    	je     80105535 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054b7:	83 ec 0c             	sub    $0xc,%esp
801054ba:	50                   	push   %eax
801054bb:	e8 f0 c3 ff ff       	call   801018b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054c8:	0f 84 c2 00 00 00    	je     80105590 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054ce:	e8 8d ba ff ff       	call   80100f60 <filealloc>
801054d3:	89 c7                	mov    %eax,%edi
801054d5:	85 c0                	test   %eax,%eax
801054d7:	74 23                	je     801054fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801054d9:	e8 72 e6 ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054e4:	85 d2                	test   %edx,%edx
801054e6:	74 60                	je     80105548 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054e8:	83 c3 01             	add    $0x1,%ebx
801054eb:	83 fb 10             	cmp    $0x10,%ebx
801054ee:	75 f0                	jne    801054e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	57                   	push   %edi
801054f4:	e8 27 bb ff ff       	call   80101020 <fileclose>
801054f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054fc:	83 ec 0c             	sub    $0xc,%esp
801054ff:	56                   	push   %esi
80105500:	e8 3b c6 ff ff       	call   80101b40 <iunlockput>
    end_op();
80105505:	e8 f6 d9 ff ff       	call   80102f00 <end_op>
    return -1;
8010550a:	83 c4 10             	add    $0x10,%esp
8010550d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105512:	eb 6d                	jmp    80105581 <sys_open+0x121>
80105514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105518:	83 ec 0c             	sub    $0xc,%esp
8010551b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010551e:	31 c9                	xor    %ecx,%ecx
80105520:	ba 02 00 00 00       	mov    $0x2,%edx
80105525:	6a 00                	push   $0x0
80105527:	e8 14 f8 ff ff       	call   80104d40 <create>
    if(ip == 0){
8010552c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010552f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105531:	85 c0                	test   %eax,%eax
80105533:	75 99                	jne    801054ce <sys_open+0x6e>
      end_op();
80105535:	e8 c6 d9 ff ff       	call   80102f00 <end_op>
      return -1;
8010553a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010553f:	eb 40                	jmp    80105581 <sys_open+0x121>
80105541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105548:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010554b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010554f:	56                   	push   %esi
80105550:	e8 3b c4 ff ff       	call   80101990 <iunlock>
  end_op();
80105555:	e8 a6 d9 ff ff       	call   80102f00 <end_op>

  f->type = FD_INODE;
8010555a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105560:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105563:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105566:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105569:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010556b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105572:	f7 d0                	not    %eax
80105574:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105577:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010557a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010557d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105584:	89 d8                	mov    %ebx,%eax
80105586:	5b                   	pop    %ebx
80105587:	5e                   	pop    %esi
80105588:	5f                   	pop    %edi
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret
8010558b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105590:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105593:	85 c9                	test   %ecx,%ecx
80105595:	0f 84 33 ff ff ff    	je     801054ce <sys_open+0x6e>
8010559b:	e9 5c ff ff ff       	jmp    801054fc <sys_open+0x9c>

801055a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055a6:	e8 e5 d8 ff ff       	call   80102e90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055b1:	50                   	push   %eax
801055b2:	6a 00                	push   $0x0
801055b4:	e8 77 f6 ff ff       	call   80104c30 <argstr>
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	85 c0                	test   %eax,%eax
801055be:	78 30                	js     801055f0 <sys_mkdir+0x50>
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c6:	31 c9                	xor    %ecx,%ecx
801055c8:	ba 01 00 00 00       	mov    $0x1,%edx
801055cd:	6a 00                	push   $0x0
801055cf:	e8 6c f7 ff ff       	call   80104d40 <create>
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
801055d9:	74 15                	je     801055f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055db:	83 ec 0c             	sub    $0xc,%esp
801055de:	50                   	push   %eax
801055df:	e8 5c c5 ff ff       	call   80101b40 <iunlockput>
  end_op();
801055e4:	e8 17 d9 ff ff       	call   80102f00 <end_op>
  return 0;
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	31 c0                	xor    %eax,%eax
}
801055ee:	c9                   	leave
801055ef:	c3                   	ret
    end_op();
801055f0:	e8 0b d9 ff ff       	call   80102f00 <end_op>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055fa:	c9                   	leave
801055fb:	c3                   	ret
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_mknod>:

int
sys_mknod(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105606:	e8 85 d8 ff ff       	call   80102e90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010560b:	83 ec 08             	sub    $0x8,%esp
8010560e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105611:	50                   	push   %eax
80105612:	6a 00                	push   $0x0
80105614:	e8 17 f6 ff ff       	call   80104c30 <argstr>
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	85 c0                	test   %eax,%eax
8010561e:	78 60                	js     80105680 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105620:	83 ec 08             	sub    $0x8,%esp
80105623:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105626:	50                   	push   %eax
80105627:	6a 01                	push   $0x1
80105629:	e8 42 f5 ff ff       	call   80104b70 <argint>
  if((argstr(0, &path)) < 0 ||
8010562e:	83 c4 10             	add    $0x10,%esp
80105631:	85 c0                	test   %eax,%eax
80105633:	78 4b                	js     80105680 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105635:	83 ec 08             	sub    $0x8,%esp
80105638:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010563b:	50                   	push   %eax
8010563c:	6a 02                	push   $0x2
8010563e:	e8 2d f5 ff ff       	call   80104b70 <argint>
     argint(1, &major) < 0 ||
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	78 36                	js     80105680 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010564a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010564e:	83 ec 0c             	sub    $0xc,%esp
80105651:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105655:	ba 03 00 00 00       	mov    $0x3,%edx
8010565a:	50                   	push   %eax
8010565b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010565e:	e8 dd f6 ff ff       	call   80104d40 <create>
     argint(2, &minor) < 0 ||
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	85 c0                	test   %eax,%eax
80105668:	74 16                	je     80105680 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010566a:	83 ec 0c             	sub    $0xc,%esp
8010566d:	50                   	push   %eax
8010566e:	e8 cd c4 ff ff       	call   80101b40 <iunlockput>
  end_op();
80105673:	e8 88 d8 ff ff       	call   80102f00 <end_op>
  return 0;
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	31 c0                	xor    %eax,%eax
}
8010567d:	c9                   	leave
8010567e:	c3                   	ret
8010567f:	90                   	nop
    end_op();
80105680:	e8 7b d8 ff ff       	call   80102f00 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010568a:	c9                   	leave
8010568b:	c3                   	ret
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_chdir>:

int
sys_chdir(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	56                   	push   %esi
80105694:	53                   	push   %ebx
80105695:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105698:	e8 b3 e4 ff ff       	call   80103b50 <myproc>
8010569d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010569f:	e8 ec d7 ff ff       	call   80102e90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056a4:	83 ec 08             	sub    $0x8,%esp
801056a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056aa:	50                   	push   %eax
801056ab:	6a 00                	push   $0x0
801056ad:	e8 7e f5 ff ff       	call   80104c30 <argstr>
801056b2:	83 c4 10             	add    $0x10,%esp
801056b5:	85 c0                	test   %eax,%eax
801056b7:	78 77                	js     80105730 <sys_chdir+0xa0>
801056b9:	83 ec 0c             	sub    $0xc,%esp
801056bc:	ff 75 f4             	push   -0xc(%ebp)
801056bf:	e8 0c cb ff ff       	call   801021d0 <namei>
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	89 c3                	mov    %eax,%ebx
801056c9:	85 c0                	test   %eax,%eax
801056cb:	74 63                	je     80105730 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056cd:	83 ec 0c             	sub    $0xc,%esp
801056d0:	50                   	push   %eax
801056d1:	e8 da c1 ff ff       	call   801018b0 <ilock>
  if(ip->type != T_DIR){
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056de:	75 30                	jne    80105710 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	53                   	push   %ebx
801056e4:	e8 a7 c2 ff ff       	call   80101990 <iunlock>
  iput(curproc->cwd);
801056e9:	58                   	pop    %eax
801056ea:	ff 76 68             	push   0x68(%esi)
801056ed:	e8 ee c2 ff ff       	call   801019e0 <iput>
  end_op();
801056f2:	e8 09 d8 ff ff       	call   80102f00 <end_op>
  curproc->cwd = ip;
801056f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	31 c0                	xor    %eax,%eax
}
801056ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105702:	5b                   	pop    %ebx
80105703:	5e                   	pop    %esi
80105704:	5d                   	pop    %ebp
80105705:	c3                   	ret
80105706:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010570d:	00 
8010570e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	53                   	push   %ebx
80105714:	e8 27 c4 ff ff       	call   80101b40 <iunlockput>
    end_op();
80105719:	e8 e2 d7 ff ff       	call   80102f00 <end_op>
    return -1;
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105726:	eb d7                	jmp    801056ff <sys_chdir+0x6f>
80105728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010572f:	00 
    end_op();
80105730:	e8 cb d7 ff ff       	call   80102f00 <end_op>
    return -1;
80105735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573a:	eb c3                	jmp    801056ff <sys_chdir+0x6f>
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_exec>:

int
sys_exec(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105745:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010574b:	53                   	push   %ebx
8010574c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105752:	50                   	push   %eax
80105753:	6a 00                	push   $0x0
80105755:	e8 d6 f4 ff ff       	call   80104c30 <argstr>
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	85 c0                	test   %eax,%eax
8010575f:	0f 88 87 00 00 00    	js     801057ec <sys_exec+0xac>
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010576e:	50                   	push   %eax
8010576f:	6a 01                	push   $0x1
80105771:	e8 fa f3 ff ff       	call   80104b70 <argint>
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	85 c0                	test   %eax,%eax
8010577b:	78 6f                	js     801057ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010577d:	83 ec 04             	sub    $0x4,%esp
80105780:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105786:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105788:	68 80 00 00 00       	push   $0x80
8010578d:	6a 00                	push   $0x0
8010578f:	56                   	push   %esi
80105790:	e8 1b f1 ff ff       	call   801048b0 <memset>
80105795:	83 c4 10             	add    $0x10,%esp
80105798:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010579f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057a0:	83 ec 08             	sub    $0x8,%esp
801057a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057b0:	50                   	push   %eax
801057b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057b7:	01 f8                	add    %edi,%eax
801057b9:	50                   	push   %eax
801057ba:	e8 21 f3 ff ff       	call   80104ae0 <fetchint>
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	85 c0                	test   %eax,%eax
801057c4:	78 26                	js     801057ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057cc:	85 c0                	test   %eax,%eax
801057ce:	74 30                	je     80105800 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057d0:	83 ec 08             	sub    $0x8,%esp
801057d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057d6:	52                   	push   %edx
801057d7:	50                   	push   %eax
801057d8:	e8 43 f3 ff ff       	call   80104b20 <fetchstr>
801057dd:	83 c4 10             	add    $0x10,%esp
801057e0:	85 c0                	test   %eax,%eax
801057e2:	78 08                	js     801057ec <sys_exec+0xac>
  for(i=0;; i++){
801057e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057e7:	83 fb 20             	cmp    $0x20,%ebx
801057ea:	75 b4                	jne    801057a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f4:	5b                   	pop    %ebx
801057f5:	5e                   	pop    %esi
801057f6:	5f                   	pop    %edi
801057f7:	5d                   	pop    %ebp
801057f8:	c3                   	ret
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105800:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105807:	00 00 00 00 
  return exec(path, argv);
8010580b:	83 ec 08             	sub    $0x8,%esp
8010580e:	56                   	push   %esi
8010580f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105815:	e8 96 b2 ff ff       	call   80100ab0 <exec>
8010581a:	83 c4 10             	add    $0x10,%esp
}
8010581d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105820:	5b                   	pop    %ebx
80105821:	5e                   	pop    %esi
80105822:	5f                   	pop    %edi
80105823:	5d                   	pop    %ebp
80105824:	c3                   	ret
80105825:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010582c:	00 
8010582d:	8d 76 00             	lea    0x0(%esi),%esi

80105830 <sys_pipe>:

int
sys_pipe(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105835:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105838:	53                   	push   %ebx
80105839:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010583c:	6a 08                	push   $0x8
8010583e:	50                   	push   %eax
8010583f:	6a 00                	push   $0x0
80105841:	e8 7a f3 ff ff       	call   80104bc0 <argptr>
80105846:	83 c4 10             	add    $0x10,%esp
80105849:	85 c0                	test   %eax,%eax
8010584b:	78 4a                	js     80105897 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010584d:	83 ec 08             	sub    $0x8,%esp
80105850:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105853:	50                   	push   %eax
80105854:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105857:	50                   	push   %eax
80105858:	e8 03 dd ff ff       	call   80103560 <pipealloc>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	78 33                	js     80105897 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105864:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105867:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105869:	e8 e2 e2 ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010586e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105870:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105874:	85 f6                	test   %esi,%esi
80105876:	74 28                	je     801058a0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105878:	83 c3 01             	add    $0x1,%ebx
8010587b:	83 fb 10             	cmp    $0x10,%ebx
8010587e:	75 f0                	jne    80105870 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	ff 75 e0             	push   -0x20(%ebp)
80105886:	e8 95 b7 ff ff       	call   80101020 <fileclose>
    fileclose(wf);
8010588b:	58                   	pop    %eax
8010588c:	ff 75 e4             	push   -0x1c(%ebp)
8010588f:	e8 8c b7 ff ff       	call   80101020 <fileclose>
    return -1;
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589c:	eb 53                	jmp    801058f1 <sys_pipe+0xc1>
8010589e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058a0:	8d 73 08             	lea    0x8(%ebx),%esi
801058a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058aa:	e8 a1 e2 ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058af:	31 d2                	xor    %edx,%edx
801058b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058bc:	85 c9                	test   %ecx,%ecx
801058be:	74 20                	je     801058e0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801058c0:	83 c2 01             	add    $0x1,%edx
801058c3:	83 fa 10             	cmp    $0x10,%edx
801058c6:	75 f0                	jne    801058b8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801058c8:	e8 83 e2 ff ff       	call   80103b50 <myproc>
801058cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058d4:	00 
801058d5:	eb a9                	jmp    80105880 <sys_pipe+0x50>
801058d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058de:	00 
801058df:	90                   	nop
      curproc->ofile[fd] = f;
801058e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801058e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058ef:	31 c0                	xor    %eax,%eax
}
801058f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058f4:	5b                   	pop    %ebx
801058f5:	5e                   	pop    %esi
801058f6:	5f                   	pop    %edi
801058f7:	5d                   	pop    %ebp
801058f8:	c3                   	ret
801058f9:	66 90                	xchg   %ax,%ax
801058fb:	66 90                	xchg   %ax,%ax
801058fd:	66 90                	xchg   %ax,%ax
801058ff:	90                   	nop

80105900 <sys_fork>:
#include "mmu.h"
#include "proc.h"
#include "syscall.h"

int sys_fork(void) {
    return fork();
80105900:	e9 eb e3 ff ff       	jmp    80103cf0 <fork>
80105905:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010590c:	00 
8010590d:	8d 76 00             	lea    0x0(%esi),%esi

80105910 <sys_exit>:
}

int sys_exit(void) {
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 08             	sub    $0x8,%esp
    exit();
80105916:	e8 55 e6 ff ff       	call   80103f70 <exit>
    return 0;  // not reached
}
8010591b:	31 c0                	xor    %eax,%eax
8010591d:	c9                   	leave
8010591e:	c3                   	ret
8010591f:	90                   	nop

80105920 <sys_wait>:

int sys_wait(void) {
    return wait();
80105920:	e9 eb e7 ff ff       	jmp    80104110 <wait>
80105925:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010592c:	00 
8010592d:	8d 76 00             	lea    0x0(%esi),%esi

80105930 <sys_kill>:
}

int sys_kill(void) {
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 20             	sub    $0x20,%esp
    int pid;
    if(argint(0, &pid) < 0)
80105936:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105939:	50                   	push   %eax
8010593a:	6a 00                	push   $0x0
8010593c:	e8 2f f2 ff ff       	call   80104b70 <argint>
80105941:	83 c4 10             	add    $0x10,%esp
80105944:	85 c0                	test   %eax,%eax
80105946:	78 18                	js     80105960 <sys_kill+0x30>
        return -1;
    return kill(pid);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	ff 75 f4             	push   -0xc(%ebp)
8010594e:	e8 5d ea ff ff       	call   801043b0 <kill>
80105953:	83 c4 10             	add    $0x10,%esp
}
80105956:	c9                   	leave
80105957:	c3                   	ret
80105958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010595f:	00 
80105960:	c9                   	leave
        return -1;
80105961:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105966:	c3                   	ret
80105967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010596e:	00 
8010596f:	90                   	nop

80105970 <sys_getpid>:

int sys_getpid(void) {
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80105976:	e8 d5 e1 ff ff       	call   80103b50 <myproc>
8010597b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010597e:	c9                   	leave
8010597f:	c3                   	ret

80105980 <sys_sbrk>:
//     release(&ptable.lock);
    
//     return addr;
// }

int sys_sbrk(void) {
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	57                   	push   %edi
80105984:	56                   	push   %esi
80105985:	53                   	push   %ebx
80105986:	83 ec 2c             	sub    $0x2c,%esp
    int addr;
    int n;
    struct proc *curproc = myproc();
80105989:	e8 c2 e1 ff ff       	call   80103b50 <myproc>

    if(argint(0, &n) < 0)
8010598e:	83 ec 08             	sub    $0x8,%esp
    struct proc *curproc = myproc();
80105991:	89 c3                	mov    %eax,%ebx
    if(argint(0, &n) < 0)
80105993:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105996:	50                   	push   %eax
80105997:	6a 00                	push   $0x0
80105999:	e8 d2 f1 ff ff       	call   80104b70 <argint>
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	85 c0                	test   %eax,%eax
801059a3:	0f 88 b5 00 00 00    	js     80105a5e <sys_sbrk+0xde>
        return -1;

    addr = curproc->sz;
801059a9:	8b 33                	mov    (%ebx),%esi

    if(growproc(n) < 0)
801059ab:	83 ec 0c             	sub    $0xc,%esp
801059ae:	ff 75 e4             	push   -0x1c(%ebp)
    addr = curproc->sz;
801059b1:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    if(growproc(n) < 0)
801059b4:	e8 b7 e2 ff ff       	call   80103c70 <growproc>
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	85 c0                	test   %eax,%eax
801059be:	0f 88 9a 00 00 00    	js     80105a5e <sys_sbrk+0xde>
        return -1;

    // Wait for memory to be actually allocated
    int max_wait_cycles = 100000; // Avoid infinite loop
    while (curproc->sz == addr && max_wait_cycles > 0) {
801059c4:	8b 03                	mov    (%ebx),%eax
801059c6:	39 c6                	cmp    %eax,%esi
801059c8:	75 7b                	jne    80105a45 <sys_sbrk+0xc5>
        max_wait_cycles--;
    }

    if (curproc->sz == addr) {
        cprintf("sys_sbrk: Warning - Memory allocation did not reflect in time!\n");
801059ca:	83 ec 0c             	sub    $0xc,%esp
801059cd:	68 e4 7c 10 80       	push   $0x80107ce4
801059d2:	e8 c9 ac ff ff       	call   801006a0 <cprintf>
801059d7:	83 c4 10             	add    $0x10,%esp
    } else {
        cprintf("sys_sbrk: Memory size increased from %d to %d\n", addr, curproc->sz);
    }

    // Update only memory, do not overwrite name
    acquire(&ptable.lock);
801059da:	83 ec 0c             	sub    $0xc,%esp
801059dd:	68 20 2d 11 80       	push   $0x80112d20
801059e2:	e8 09 ee ff ff       	call   801047f0 <acquire>
    for (int i = 0; i < history_count; i++) {
801059e7:	8b 0d 58 65 11 80    	mov    0x80116558,%ecx
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	85 c9                	test   %ecx,%ecx
801059f2:	7e 36                	jle    80105a2a <sys_sbrk+0xaa>
        if (process_history[i].pid == curproc->pid) {
801059f4:	8b 7b 10             	mov    0x10(%ebx),%edi
    for (int i = 0; i < history_count; i++) {
801059f7:	31 c0                	xor    %eax,%eax
801059f9:	eb 0c                	jmp    80105a07 <sys_sbrk+0x87>
801059fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a00:	83 c0 01             	add    $0x1,%eax
80105a03:	39 c1                	cmp    %eax,%ecx
80105a05:	74 23                	je     80105a2a <sys_sbrk+0xaa>
        if (process_history[i].pid == curproc->pid) {
80105a07:	8d 14 40             	lea    (%eax,%eax,2),%edx
80105a0a:	8d 34 d5 00 00 00 00 	lea    0x0(,%edx,8),%esi
80105a11:	39 3c d5 60 65 11 80 	cmp    %edi,-0x7fee9aa0(,%edx,8)
80105a18:	75 e6                	jne    80105a00 <sys_sbrk+0x80>
            // process_history[i].mem_usage = curproc->sz;
            if(curproc->sz > process_history[i].mem_usage) {
80105a1a:	8b 03                	mov    (%ebx),%eax
80105a1c:	3b 86 74 65 11 80    	cmp    -0x7fee9a8c(%esi),%eax
80105a22:	76 06                	jbe    80105a2a <sys_sbrk+0xaa>
                process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
80105a24:	89 86 74 65 11 80    	mov    %eax,-0x7fee9a8c(%esi)
            }
            break;
        }
    }
    release(&ptable.lock);
80105a2a:	83 ec 0c             	sub    $0xc,%esp
80105a2d:	68 20 2d 11 80       	push   $0x80112d20
80105a32:	e8 59 ed ff ff       	call   80104790 <release>

    return addr;
80105a37:	83 c4 10             	add    $0x10,%esp
}
80105a3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105a3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a40:	5b                   	pop    %ebx
80105a41:	5e                   	pop    %esi
80105a42:	5f                   	pop    %edi
80105a43:	5d                   	pop    %ebp
80105a44:	c3                   	ret
        cprintf("sys_sbrk: Memory size increased from %d to %d\n", addr, curproc->sz);
80105a45:	83 ec 04             	sub    $0x4,%esp
80105a48:	50                   	push   %eax
80105a49:	ff 75 d4             	push   -0x2c(%ebp)
80105a4c:	68 24 7d 10 80       	push   $0x80107d24
80105a51:	e8 4a ac ff ff       	call   801006a0 <cprintf>
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	e9 7c ff ff ff       	jmp    801059da <sys_sbrk+0x5a>
        return -1;
80105a5e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
80105a65:	eb d3                	jmp    80105a3a <sys_sbrk+0xba>
80105a67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6e:	00 
80105a6f:	90                   	nop

80105a70 <sys_sleep>:


int sys_sleep(void) {
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
    int n;
    uint ticks0;
    if(argint(0, &n) < 0)
80105a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80105a77:	83 ec 1c             	sub    $0x1c,%esp
    if(argint(0, &n) < 0)
80105a7a:	50                   	push   %eax
80105a7b:	6a 00                	push   $0x0
80105a7d:	e8 ee f0 ff ff       	call   80104b70 <argint>
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	0f 88 8a 00 00 00    	js     80105b17 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 80 66 11 80       	push   $0x80116680
80105a95:	e8 56 ed ff ff       	call   801047f0 <acquire>
    ticks0 = ticks;
    while(ticks - ticks0 < n) {
80105a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    ticks0 = ticks;
80105a9d:	8b 1d 60 66 11 80    	mov    0x80116660,%ebx
    while(ticks - ticks0 < n) {
80105aa3:	83 c4 10             	add    $0x10,%esp
80105aa6:	85 d2                	test   %edx,%edx
80105aa8:	75 27                	jne    80105ad1 <sys_sleep+0x61>
80105aaa:	eb 54                	jmp    80105b00 <sys_sleep+0x90>
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105ab0:	83 ec 08             	sub    $0x8,%esp
80105ab3:	68 80 66 11 80       	push   $0x80116680
80105ab8:	68 60 66 11 80       	push   $0x80116660
80105abd:	e8 ce e7 ff ff       	call   80104290 <sleep>
    while(ticks - ticks0 < n) {
80105ac2:	a1 60 66 11 80       	mov    0x80116660,%eax
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	29 d8                	sub    %ebx,%eax
80105acc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105acf:	73 2f                	jae    80105b00 <sys_sleep+0x90>
        if(myproc()->killed) {
80105ad1:	e8 7a e0 ff ff       	call   80103b50 <myproc>
80105ad6:	8b 40 24             	mov    0x24(%eax),%eax
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	74 d3                	je     80105ab0 <sys_sleep+0x40>
            release(&tickslock);
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	68 80 66 11 80       	push   $0x80116680
80105ae5:	e8 a6 ec ff ff       	call   80104790 <release>
    }
    release(&tickslock);
    return 0;
}
80105aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return -1;
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af5:	c9                   	leave
80105af6:	c3                   	ret
80105af7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105afe:	00 
80105aff:	90                   	nop
    release(&tickslock);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	68 80 66 11 80       	push   $0x80116680
80105b08:	e8 83 ec ff ff       	call   80104790 <release>
    return 0;
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	31 c0                	xor    %eax,%eax
}
80105b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b15:	c9                   	leave
80105b16:	c3                   	ret
        return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1c:	eb f4                	jmp    80105b12 <sys_sleep+0xa2>
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
80105b24:	83 ec 10             	sub    $0x10,%esp
    uint xticks;
    acquire(&tickslock);
80105b27:	68 80 66 11 80       	push   $0x80116680
80105b2c:	e8 bf ec ff ff       	call   801047f0 <acquire>
    xticks = ticks;
80105b31:	8b 1d 60 66 11 80    	mov    0x80116660,%ebx
    release(&tickslock);
80105b37:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80105b3e:	e8 4d ec ff ff       	call   80104790 <release>
    return xticks;
}
80105b43:	89 d8                	mov    %ebx,%eax
80105b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b48:	c9                   	leave
80105b49:	c3                   	ret
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b50 <sys_gethistory>:

// System call to get process history
int sys_gethistory(void) {
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	57                   	push   %edi
80105b54:	56                   	push   %esi
    struct history_entry *hist_buf;
    int max_entries;

    // Get arguments from user space
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105b55:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_gethistory(void) {
80105b58:	53                   	push   %ebx
80105b59:	83 ec 30             	sub    $0x30,%esp
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105b5c:	6a 18                	push   $0x18
80105b5e:	50                   	push   %eax
80105b5f:	6a 00                	push   $0x0
80105b61:	e8 5a f0 ff ff       	call   80104bc0 <argptr>
80105b66:	83 c4 10             	add    $0x10,%esp
80105b69:	85 c0                	test   %eax,%eax
80105b6b:	0f 88 df 00 00 00    	js     80105c50 <sys_gethistory+0x100>
        argint(1, &max_entries) < 0) {
80105b71:	83 ec 08             	sub    $0x8,%esp
80105b74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b77:	50                   	push   %eax
80105b78:	6a 01                	push   $0x1
80105b7a:	e8 f1 ef ff ff       	call   80104b70 <argint>
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105b7f:	83 c4 10             	add    $0x10,%esp
80105b82:	85 c0                	test   %eax,%eax
80105b84:	0f 88 c6 00 00 00    	js     80105c50 <sys_gethistory+0x100>
        return -1;  // Invalid arguments
    }

    acquire(&ptable.lock);
80105b8a:	83 ec 0c             	sub    $0xc,%esp
80105b8d:	68 20 2d 11 80       	push   $0x80112d20
80105b92:	e8 59 ec ff ff       	call   801047f0 <acquire>

    // Return only the most recent `max_entries` from history
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105b97:	a1 58 65 11 80       	mov    0x80116558,%eax
80105b9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105b9f:	39 d0                	cmp    %edx,%eax
80105ba1:	89 d7                	mov    %edx,%edi
80105ba3:	0f 4e f8             	cmovle %eax,%edi
    int start = (history_count < MAX_HISTORY) ? 0 : history_index;  // Start index
80105ba6:	31 db                	xor    %ebx,%ebx
80105ba8:	83 c4 10             	add    $0x10,%esp
80105bab:	83 f8 09             	cmp    $0x9,%eax
80105bae:	0f 4f 1d 54 65 11 80 	cmovg  0x80116554,%ebx
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105bb5:	89 7d d0             	mov    %edi,-0x30(%ebp)

    for (int i = 0; i < copy_count; i++) {
80105bb8:	85 ff                	test   %edi,%edi
80105bba:	7e 79                	jle    80105c35 <sys_gethistory+0xe5>
80105bbc:	8b 45 d0             	mov    -0x30(%ebp),%eax
        int index = (start + i) % MAX_HISTORY;
        hist_buf[i].pid = process_history[index].pid;
80105bbf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105bc2:	31 f6                	xor    %esi,%esi
80105bc4:	01 d8                	add    %ebx,%eax
80105bc6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        int index = (start + i) % MAX_HISTORY;
80105bd0:	b8 67 66 66 66       	mov    $0x66666667,%eax
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105bd5:	83 ec 04             	sub    $0x4,%esp
        int index = (start + i) % MAX_HISTORY;
80105bd8:	f7 eb                	imul   %ebx
80105bda:	89 d8                	mov    %ebx,%eax
80105bdc:	c1 f8 1f             	sar    $0x1f,%eax
80105bdf:	c1 fa 02             	sar    $0x2,%edx
80105be2:	29 c2                	sub    %eax,%edx
80105be4:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105be7:	89 da                	mov    %ebx,%edx
    for (int i = 0; i < copy_count; i++) {
80105be9:	83 c3 01             	add    $0x1,%ebx
        int index = (start + i) % MAX_HISTORY;
80105bec:	01 c0                	add    %eax,%eax
80105bee:	29 c2                	sub    %eax,%edx
        hist_buf[i].pid = process_history[index].pid;
80105bf0:	8d 14 52             	lea    (%edx,%edx,2),%edx
80105bf3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80105bfa:	8b 14 d5 60 65 11 80 	mov    -0x7fee9aa0(,%edx,8),%edx
80105c01:	8d b8 60 65 11 80    	lea    -0x7fee9aa0(%eax),%edi
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105c07:	05 64 65 11 80       	add    $0x80116564,%eax
        hist_buf[i].pid = process_history[index].pid;
80105c0c:	89 14 31             	mov    %edx,(%ecx,%esi,1)
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105c0f:	6a 10                	push   $0x10
80105c11:	50                   	push   %eax
80105c12:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c15:	01 f0                	add    %esi,%eax
80105c17:	83 c0 04             	add    $0x4,%eax
80105c1a:	50                   	push   %eax
80105c1b:	e8 50 ee ff ff       	call   80104a70 <safestrcpy>
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105c20:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105c23:	8b 47 14             	mov    0x14(%edi),%eax
    for (int i = 0; i < copy_count; i++) {
80105c26:	83 c4 10             	add    $0x10,%esp
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105c29:	89 44 31 14          	mov    %eax,0x14(%ecx,%esi,1)
    for (int i = 0; i < copy_count; i++) {
80105c2d:	83 c6 18             	add    $0x18,%esi
80105c30:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
80105c33:	75 9b                	jne    80105bd0 <sys_gethistory+0x80>
    }

    release(&ptable.lock);
80105c35:	83 ec 0c             	sub    $0xc,%esp
80105c38:	68 20 2d 11 80       	push   $0x80112d20
80105c3d:	e8 4e eb ff ff       	call   80104790 <release>
    return copy_count;  // Return number of processes copied
80105c42:	83 c4 10             	add    $0x10,%esp
}
80105c45:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c4b:	5b                   	pop    %ebx
80105c4c:	5e                   	pop    %esi
80105c4d:	5f                   	pop    %edi
80105c4e:	5d                   	pop    %ebp
80105c4f:	c3                   	ret
        return -1;  // Invalid arguments
80105c50:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
80105c57:	eb ec                	jmp    80105c45 <sys_gethistory+0xf5>
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_block>:

// System call to block system calls
int sys_block(void) {
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	53                   	push   %ebx
80105c64:	83 ec 14             	sub    $0x14,%esp
    int syscall_id;
    struct proc *curproc = myproc();
80105c67:	e8 e4 de ff ff       	call   80103b50 <myproc>

    if (argint(0, &syscall_id) < 0) 
80105c6c:	83 ec 08             	sub    $0x8,%esp
    struct proc *curproc = myproc();
80105c6f:	89 c3                	mov    %eax,%ebx
    if (argint(0, &syscall_id) < 0) 
80105c71:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c74:	50                   	push   %eax
80105c75:	6a 00                	push   $0x0
80105c77:	e8 f4 ee ff ff       	call   80104b70 <argint>
80105c7c:	83 c4 10             	add    $0x10,%esp
80105c7f:	85 c0                	test   %eax,%eax
80105c81:	78 2d                	js     80105cb0 <sys_block+0x50>
        return -1;

    // Prevent blocking critical syscalls
    if (syscall_id == SYS_fork || syscall_id == SYS_exit || syscall_id == SYS_unblock) {
80105c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c86:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c89:	83 fa 01             	cmp    $0x1,%edx
80105c8c:	0f 96 c2             	setbe  %dl
80105c8f:	83 f8 18             	cmp    $0x18,%eax
80105c92:	0f 94 c1             	sete   %cl
        return -1;
    }

    // Block the syscall for the current shell session
    if (syscall_id >= 0 && syscall_id < MAX_SYSCALLS) {
80105c95:	08 ca                	or     %cl,%dl
80105c97:	75 17                	jne    80105cb0 <sys_block+0x50>
80105c99:	83 f8 18             	cmp    $0x18,%eax
80105c9c:	77 12                	ja     80105cb0 <sys_block+0x50>
        curproc->blocked_syscalls[syscall_id] = 1;
80105c9e:	c7 44 83 7c 01 00 00 	movl   $0x1,0x7c(%ebx,%eax,4)
80105ca5:	00 
        return 0;
80105ca6:	31 c0                	xor    %eax,%eax
    }

    return -1;
}
80105ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cab:	c9                   	leave
80105cac:	c3                   	ret
80105cad:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80105cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb5:	eb f1                	jmp    80105ca8 <sys_block+0x48>
80105cb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cbe:	00 
80105cbf:	90                   	nop

80105cc0 <sys_unblock>:
//     }

//     return -1;
// }

int sys_unblock(void) {
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	56                   	push   %esi
80105cc4:	53                   	push   %ebx
80105cc5:	83 ec 10             	sub    $0x10,%esp
    int syscall_id;
    struct proc *curproc = myproc();
80105cc8:	e8 83 de ff ff       	call   80103b50 <myproc>
    struct proc *p;

    if (argint(0, &syscall_id) < 0) 
80105ccd:	83 ec 08             	sub    $0x8,%esp
    struct proc *curproc = myproc();
80105cd0:	89 c6                	mov    %eax,%esi
    if (argint(0, &syscall_id) < 0) 
80105cd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd5:	50                   	push   %eax
80105cd6:	6a 00                	push   $0x0
80105cd8:	e8 93 ee ff ff       	call   80104b70 <argint>
80105cdd:	83 c4 10             	add    $0x10,%esp
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	0f 88 98 00 00 00    	js     80105d80 <sys_unblock+0xc0>
        return -1;

    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105ce8:	83 7d f4 18          	cmpl   $0x18,-0xc(%ebp)
80105cec:	0f 87 8e 00 00 00    	ja     80105d80 <sys_unblock+0xc0>
        return -1;

    acquire(&ptable.lock);
80105cf2:	83 ec 0c             	sub    $0xc,%esp
    
    // Debugging output
    cprintf("Unblocking syscall %d for PID %d and its children\n", syscall_id, curproc->pid);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105cf5:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80105cfa:	68 20 2d 11 80       	push   $0x80112d20
80105cff:	e8 ec ea ff ff       	call   801047f0 <acquire>
    cprintf("Unblocking syscall %d for PID %d and its children\n", syscall_id, curproc->pid);
80105d04:	83 c4 0c             	add    $0xc,%esp
80105d07:	ff 76 10             	push   0x10(%esi)
80105d0a:	ff 75 f4             	push   -0xc(%ebp)
80105d0d:	68 58 7d 10 80       	push   $0x80107d58
80105d12:	e8 89 a9 ff ff       	call   801006a0 <cprintf>
80105d17:	83 c4 10             	add    $0x10,%esp
80105d1a:	eb 16                	jmp    80105d32 <sys_unblock+0x72>
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->parent == curproc || p == curproc) {
80105d20:	39 de                	cmp    %ebx,%esi
80105d22:	74 13                	je     80105d37 <sys_unblock+0x77>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105d24:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80105d2a:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80105d30:	74 35                	je     80105d67 <sys_unblock+0xa7>
        if (p->parent == curproc || p == curproc) {
80105d32:	39 73 14             	cmp    %esi,0x14(%ebx)
80105d35:	75 e9                	jne    80105d20 <sys_unblock+0x60>
            p->blocked_syscalls[syscall_id] = 0;
80105d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
            cprintf("Syscall %d unblocked for PID %d\n", syscall_id, p->pid);
80105d3a:	83 ec 04             	sub    $0x4,%esp
            p->blocked_syscalls[syscall_id] = 0;
80105d3d:	c7 44 83 7c 00 00 00 	movl   $0x0,0x7c(%ebx,%eax,4)
80105d44:	00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105d45:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
            cprintf("Syscall %d unblocked for PID %d\n", syscall_id, p->pid);
80105d4b:	ff b3 30 ff ff ff    	push   -0xd0(%ebx)
80105d51:	50                   	push   %eax
80105d52:	68 8c 7d 10 80       	push   $0x80107d8c
80105d57:	e8 44 a9 ff ff       	call   801006a0 <cprintf>
80105d5c:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105d5f:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80105d65:	75 cb                	jne    80105d32 <sys_unblock+0x72>
        }
    }

    release(&ptable.lock);
80105d67:	83 ec 0c             	sub    $0xc,%esp
80105d6a:	68 20 2d 11 80       	push   $0x80112d20
80105d6f:	e8 1c ea ff ff       	call   80104790 <release>
    return 0;
80105d74:	83 c4 10             	add    $0x10,%esp
80105d77:	31 c0                	xor    %eax,%eax
}
80105d79:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d7c:	5b                   	pop    %ebx
80105d7d:	5e                   	pop    %esi
80105d7e:	5d                   	pop    %ebp
80105d7f:	c3                   	ret
        return -1;
80105d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d85:	eb f2                	jmp    80105d79 <sys_unblock+0xb9>

80105d87 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d87:	1e                   	push   %ds
  pushl %es
80105d88:	06                   	push   %es
  pushl %fs
80105d89:	0f a0                	push   %fs
  pushl %gs
80105d8b:	0f a8                	push   %gs
  pushal
80105d8d:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d8e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d92:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d94:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d96:	54                   	push   %esp
  call trap
80105d97:	e8 c4 00 00 00       	call   80105e60 <trap>
  addl $4, %esp
80105d9c:	83 c4 04             	add    $0x4,%esp

80105d9f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d9f:	61                   	popa
  popl %gs
80105da0:	0f a9                	pop    %gs
  popl %fs
80105da2:	0f a1                	pop    %fs
  popl %es
80105da4:	07                   	pop    %es
  popl %ds
80105da5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105da6:	83 c4 08             	add    $0x8,%esp
  iret
80105da9:	cf                   	iret
80105daa:	66 90                	xchg   %ax,%ax
80105dac:	66 90                	xchg   %ax,%ax
80105dae:	66 90                	xchg   %ax,%ax

80105db0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105db0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105db1:	31 c0                	xor    %eax,%eax
{
80105db3:	89 e5                	mov    %esp,%ebp
80105db5:	83 ec 08             	sub    $0x8,%esp
80105db8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dbf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105dc0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105dc7:	c7 04 c5 c2 66 11 80 	movl   $0x8e000008,-0x7fee993e(,%eax,8)
80105dce:	08 00 00 8e 
80105dd2:	66 89 14 c5 c0 66 11 	mov    %dx,-0x7fee9940(,%eax,8)
80105dd9:	80 
80105dda:	c1 ea 10             	shr    $0x10,%edx
80105ddd:	66 89 14 c5 c6 66 11 	mov    %dx,-0x7fee993a(,%eax,8)
80105de4:	80 
  for(i = 0; i < 256; i++)
80105de5:	83 c0 01             	add    $0x1,%eax
80105de8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ded:	75 d1                	jne    80105dc0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105def:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105df2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105df7:	c7 05 c2 68 11 80 08 	movl   $0xef000008,0x801168c2
80105dfe:	00 00 ef 
  initlock(&tickslock, "time");
80105e01:	68 ed 7a 10 80       	push   $0x80107aed
80105e06:	68 80 66 11 80       	push   $0x80116680
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e0b:	66 a3 c0 68 11 80    	mov    %ax,0x801168c0
80105e11:	c1 e8 10             	shr    $0x10,%eax
80105e14:	66 a3 c6 68 11 80    	mov    %ax,0x801168c6
  initlock(&tickslock, "time");
80105e1a:	e8 01 e8 ff ff       	call   80104620 <initlock>
}
80105e1f:	83 c4 10             	add    $0x10,%esp
80105e22:	c9                   	leave
80105e23:	c3                   	ret
80105e24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e2b:	00 
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <idtinit>:

void
idtinit(void)
{
80105e30:	55                   	push   %ebp
  pd[0] = size-1;
80105e31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e36:	89 e5                	mov    %esp,%ebp
80105e38:	83 ec 10             	sub    $0x10,%esp
80105e3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e3f:	b8 c0 66 11 80       	mov    $0x801166c0,%eax
80105e44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e48:	c1 e8 10             	shr    $0x10,%eax
80105e4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e55:	c9                   	leave
80105e56:	c3                   	ret
80105e57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e5e:	00 
80105e5f:	90                   	nop

80105e60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	57                   	push   %edi
80105e64:	56                   	push   %esi
80105e65:	53                   	push   %ebx
80105e66:	83 ec 1c             	sub    $0x1c,%esp
80105e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e6f:	83 f8 40             	cmp    $0x40,%eax
80105e72:	0f 84 68 01 00 00    	je     80105fe0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e78:	83 e8 20             	sub    $0x20,%eax
80105e7b:	83 f8 1f             	cmp    $0x1f,%eax
80105e7e:	0f 87 8c 00 00 00    	ja     80105f10 <trap+0xb0>
80105e84:	ff 24 85 24 81 10 80 	jmp    *-0x7fef7edc(,%eax,4)
80105e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e90:	e8 db c4 ff ff       	call   80102370 <ideintr>
    lapiceoi();
80105e95:	e8 a6 cb ff ff       	call   80102a40 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e9a:	e8 b1 dc ff ff       	call   80103b50 <myproc>
80105e9f:	85 c0                	test   %eax,%eax
80105ea1:	74 1d                	je     80105ec0 <trap+0x60>
80105ea3:	e8 a8 dc ff ff       	call   80103b50 <myproc>
80105ea8:	8b 50 24             	mov    0x24(%eax),%edx
80105eab:	85 d2                	test   %edx,%edx
80105ead:	74 11                	je     80105ec0 <trap+0x60>
80105eaf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105eb3:	83 e0 03             	and    $0x3,%eax
80105eb6:	66 83 f8 03          	cmp    $0x3,%ax
80105eba:	0f 84 e8 01 00 00    	je     801060a8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ec0:	e8 8b dc ff ff       	call   80103b50 <myproc>
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	74 0f                	je     80105ed8 <trap+0x78>
80105ec9:	e8 82 dc ff ff       	call   80103b50 <myproc>
80105ece:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ed2:	0f 84 b8 00 00 00    	je     80105f90 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ed8:	e8 73 dc ff ff       	call   80103b50 <myproc>
80105edd:	85 c0                	test   %eax,%eax
80105edf:	74 1d                	je     80105efe <trap+0x9e>
80105ee1:	e8 6a dc ff ff       	call   80103b50 <myproc>
80105ee6:	8b 40 24             	mov    0x24(%eax),%eax
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	74 11                	je     80105efe <trap+0x9e>
80105eed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ef1:	83 e0 03             	and    $0x3,%eax
80105ef4:	66 83 f8 03          	cmp    $0x3,%ax
80105ef8:	0f 84 0f 01 00 00    	je     8010600d <trap+0x1ad>
    exit();
}
80105efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f01:	5b                   	pop    %ebx
80105f02:	5e                   	pop    %esi
80105f03:	5f                   	pop    %edi
80105f04:	5d                   	pop    %ebp
80105f05:	c3                   	ret
80105f06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f0d:	00 
80105f0e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f10:	e8 3b dc ff ff       	call   80103b50 <myproc>
80105f15:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f18:	85 c0                	test   %eax,%eax
80105f1a:	0f 84 a2 01 00 00    	je     801060c2 <trap+0x262>
80105f20:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f24:	0f 84 98 01 00 00    	je     801060c2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f2a:	0f 20 d1             	mov    %cr2,%ecx
80105f2d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f30:	e8 fb db ff ff       	call   80103b30 <cpuid>
80105f35:	8b 73 30             	mov    0x30(%ebx),%esi
80105f38:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f3b:	8b 43 34             	mov    0x34(%ebx),%eax
80105f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105f41:	e8 0a dc ff ff       	call   80103b50 <myproc>
80105f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f49:	e8 02 dc ff ff       	call   80103b50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f4e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f51:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f54:	51                   	push   %ecx
80105f55:	57                   	push   %edi
80105f56:	52                   	push   %edx
80105f57:	ff 75 e4             	push   -0x1c(%ebp)
80105f5a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f5b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105f5e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f61:	56                   	push   %esi
80105f62:	ff 70 10             	push   0x10(%eax)
80105f65:	68 08 7e 10 80       	push   $0x80107e08
80105f6a:	e8 31 a7 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105f6f:	83 c4 20             	add    $0x20,%esp
80105f72:	e8 d9 db ff ff       	call   80103b50 <myproc>
80105f77:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f7e:	e8 cd db ff ff       	call   80103b50 <myproc>
80105f83:	85 c0                	test   %eax,%eax
80105f85:	0f 85 18 ff ff ff    	jne    80105ea3 <trap+0x43>
80105f8b:	e9 30 ff ff ff       	jmp    80105ec0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105f90:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f94:	0f 85 3e ff ff ff    	jne    80105ed8 <trap+0x78>
    yield();
80105f9a:	e8 a1 e2 ff ff       	call   80104240 <yield>
80105f9f:	e9 34 ff ff ff       	jmp    80105ed8 <trap+0x78>
80105fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fa8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105fab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105faf:	e8 7c db ff ff       	call   80103b30 <cpuid>
80105fb4:	57                   	push   %edi
80105fb5:	56                   	push   %esi
80105fb6:	50                   	push   %eax
80105fb7:	68 b0 7d 10 80       	push   $0x80107db0
80105fbc:	e8 df a6 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105fc1:	e8 7a ca ff ff       	call   80102a40 <lapiceoi>
    break;
80105fc6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fc9:	e8 82 db ff ff       	call   80103b50 <myproc>
80105fce:	85 c0                	test   %eax,%eax
80105fd0:	0f 85 cd fe ff ff    	jne    80105ea3 <trap+0x43>
80105fd6:	e9 e5 fe ff ff       	jmp    80105ec0 <trap+0x60>
80105fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105fe0:	e8 6b db ff ff       	call   80103b50 <myproc>
80105fe5:	8b 70 24             	mov    0x24(%eax),%esi
80105fe8:	85 f6                	test   %esi,%esi
80105fea:	0f 85 c8 00 00 00    	jne    801060b8 <trap+0x258>
    myproc()->tf = tf;
80105ff0:	e8 5b db ff ff       	call   80103b50 <myproc>
80105ff5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105ff8:	e8 b3 ec ff ff       	call   80104cb0 <syscall>
    if(myproc()->killed)
80105ffd:	e8 4e db ff ff       	call   80103b50 <myproc>
80106002:	8b 48 24             	mov    0x24(%eax),%ecx
80106005:	85 c9                	test   %ecx,%ecx
80106007:	0f 84 f1 fe ff ff    	je     80105efe <trap+0x9e>
}
8010600d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106010:	5b                   	pop    %ebx
80106011:	5e                   	pop    %esi
80106012:	5f                   	pop    %edi
80106013:	5d                   	pop    %ebp
      exit();
80106014:	e9 57 df ff ff       	jmp    80103f70 <exit>
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106020:	e8 3b 02 00 00       	call   80106260 <uartintr>
    lapiceoi();
80106025:	e8 16 ca ff ff       	call   80102a40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010602a:	e8 21 db ff ff       	call   80103b50 <myproc>
8010602f:	85 c0                	test   %eax,%eax
80106031:	0f 85 6c fe ff ff    	jne    80105ea3 <trap+0x43>
80106037:	e9 84 fe ff ff       	jmp    80105ec0 <trap+0x60>
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106040:	e8 bb c8 ff ff       	call   80102900 <kbdintr>
    lapiceoi();
80106045:	e8 f6 c9 ff ff       	call   80102a40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010604a:	e8 01 db ff ff       	call   80103b50 <myproc>
8010604f:	85 c0                	test   %eax,%eax
80106051:	0f 85 4c fe ff ff    	jne    80105ea3 <trap+0x43>
80106057:	e9 64 fe ff ff       	jmp    80105ec0 <trap+0x60>
8010605c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106060:	e8 cb da ff ff       	call   80103b30 <cpuid>
80106065:	85 c0                	test   %eax,%eax
80106067:	0f 85 28 fe ff ff    	jne    80105e95 <trap+0x35>
      acquire(&tickslock);
8010606d:	83 ec 0c             	sub    $0xc,%esp
80106070:	68 80 66 11 80       	push   $0x80116680
80106075:	e8 76 e7 ff ff       	call   801047f0 <acquire>
      wakeup(&ticks);
8010607a:	c7 04 24 60 66 11 80 	movl   $0x80116660,(%esp)
      ticks++;
80106081:	83 05 60 66 11 80 01 	addl   $0x1,0x80116660
      wakeup(&ticks);
80106088:	e8 c3 e2 ff ff       	call   80104350 <wakeup>
      release(&tickslock);
8010608d:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80106094:	e8 f7 e6 ff ff       	call   80104790 <release>
80106099:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010609c:	e9 f4 fd ff ff       	jmp    80105e95 <trap+0x35>
801060a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801060a8:	e8 c3 de ff ff       	call   80103f70 <exit>
801060ad:	e9 0e fe ff ff       	jmp    80105ec0 <trap+0x60>
801060b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801060b8:	e8 b3 de ff ff       	call   80103f70 <exit>
801060bd:	e9 2e ff ff ff       	jmp    80105ff0 <trap+0x190>
801060c2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060c5:	e8 66 da ff ff       	call   80103b30 <cpuid>
801060ca:	83 ec 0c             	sub    $0xc,%esp
801060cd:	56                   	push   %esi
801060ce:	57                   	push   %edi
801060cf:	50                   	push   %eax
801060d0:	ff 73 30             	push   0x30(%ebx)
801060d3:	68 d4 7d 10 80       	push   $0x80107dd4
801060d8:	e8 c3 a5 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801060dd:	83 c4 14             	add    $0x14,%esp
801060e0:	68 f2 7a 10 80       	push   $0x80107af2
801060e5:	e8 96 a2 ff ff       	call   80100380 <panic>
801060ea:	66 90                	xchg   %ax,%ax
801060ec:	66 90                	xchg   %ax,%ax
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060f0:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
801060f5:	85 c0                	test   %eax,%eax
801060f7:	74 17                	je     80106110 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060f9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060fe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060ff:	a8 01                	test   $0x1,%al
80106101:	74 0d                	je     80106110 <uartgetc+0x20>
80106103:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106108:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106109:	0f b6 c0             	movzbl %al,%eax
8010610c:	c3                   	ret
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106115:	c3                   	ret
80106116:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010611d:	00 
8010611e:	66 90                	xchg   %ax,%ax

80106120 <uartinit>:
{
80106120:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106121:	31 c9                	xor    %ecx,%ecx
80106123:	89 c8                	mov    %ecx,%eax
80106125:	89 e5                	mov    %esp,%ebp
80106127:	57                   	push   %edi
80106128:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010612d:	56                   	push   %esi
8010612e:	89 fa                	mov    %edi,%edx
80106130:	53                   	push   %ebx
80106131:	83 ec 1c             	sub    $0x1c,%esp
80106134:	ee                   	out    %al,(%dx)
80106135:	be fb 03 00 00       	mov    $0x3fb,%esi
8010613a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010613f:	89 f2                	mov    %esi,%edx
80106141:	ee                   	out    %al,(%dx)
80106142:	b8 0c 00 00 00       	mov    $0xc,%eax
80106147:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010614c:	ee                   	out    %al,(%dx)
8010614d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106152:	89 c8                	mov    %ecx,%eax
80106154:	89 da                	mov    %ebx,%edx
80106156:	ee                   	out    %al,(%dx)
80106157:	b8 03 00 00 00       	mov    $0x3,%eax
8010615c:	89 f2                	mov    %esi,%edx
8010615e:	ee                   	out    %al,(%dx)
8010615f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106164:	89 c8                	mov    %ecx,%eax
80106166:	ee                   	out    %al,(%dx)
80106167:	b8 01 00 00 00       	mov    $0x1,%eax
8010616c:	89 da                	mov    %ebx,%edx
8010616e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010616f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106174:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106175:	3c ff                	cmp    $0xff,%al
80106177:	74 78                	je     801061f1 <uartinit+0xd1>
  uart = 1;
80106179:	c7 05 c0 6e 11 80 01 	movl   $0x1,0x80116ec0
80106180:	00 00 00 
80106183:	89 fa                	mov    %edi,%edx
80106185:	ec                   	in     (%dx),%al
80106186:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010618b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010618c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010618f:	bf f7 7a 10 80       	mov    $0x80107af7,%edi
80106194:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106199:	6a 00                	push   $0x0
8010619b:	6a 04                	push   $0x4
8010619d:	e8 0e c4 ff ff       	call   801025b0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801061a2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801061a6:	83 c4 10             	add    $0x10,%esp
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801061b0:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
801061b5:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ba:	85 c0                	test   %eax,%eax
801061bc:	75 14                	jne    801061d2 <uartinit+0xb2>
801061be:	eb 23                	jmp    801061e3 <uartinit+0xc3>
    microdelay(10);
801061c0:	83 ec 0c             	sub    $0xc,%esp
801061c3:	6a 0a                	push   $0xa
801061c5:	e8 96 c8 ff ff       	call   80102a60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	83 eb 01             	sub    $0x1,%ebx
801061d0:	74 07                	je     801061d9 <uartinit+0xb9>
801061d2:	89 f2                	mov    %esi,%edx
801061d4:	ec                   	in     (%dx),%al
801061d5:	a8 20                	test   $0x20,%al
801061d7:	74 e7                	je     801061c0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061d9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801061dd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061e2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801061e3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801061e7:	83 c7 01             	add    $0x1,%edi
801061ea:	88 45 e7             	mov    %al,-0x19(%ebp)
801061ed:	84 c0                	test   %al,%al
801061ef:	75 bf                	jne    801061b0 <uartinit+0x90>
}
801061f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061f4:	5b                   	pop    %ebx
801061f5:	5e                   	pop    %esi
801061f6:	5f                   	pop    %edi
801061f7:	5d                   	pop    %ebp
801061f8:	c3                   	ret
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106200 <uartputc>:
  if(!uart)
80106200:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
80106205:	85 c0                	test   %eax,%eax
80106207:	74 47                	je     80106250 <uartputc+0x50>
{
80106209:	55                   	push   %ebp
8010620a:	89 e5                	mov    %esp,%ebp
8010620c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010620d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106212:	53                   	push   %ebx
80106213:	bb 80 00 00 00       	mov    $0x80,%ebx
80106218:	eb 18                	jmp    80106232 <uartputc+0x32>
8010621a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106220:	83 ec 0c             	sub    $0xc,%esp
80106223:	6a 0a                	push   $0xa
80106225:	e8 36 c8 ff ff       	call   80102a60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	83 eb 01             	sub    $0x1,%ebx
80106230:	74 07                	je     80106239 <uartputc+0x39>
80106232:	89 f2                	mov    %esi,%edx
80106234:	ec                   	in     (%dx),%al
80106235:	a8 20                	test   $0x20,%al
80106237:	74 e7                	je     80106220 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106239:	8b 45 08             	mov    0x8(%ebp),%eax
8010623c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106241:	ee                   	out    %al,(%dx)
}
80106242:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106245:	5b                   	pop    %ebx
80106246:	5e                   	pop    %esi
80106247:	5d                   	pop    %ebp
80106248:	c3                   	ret
80106249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106250:	c3                   	ret
80106251:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106258:	00 
80106259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106260 <uartintr>:

void
uartintr(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106266:	68 f0 60 10 80       	push   $0x801060f0
8010626b:	e8 10 a6 ff ff       	call   80100880 <consoleintr>
}
80106270:	83 c4 10             	add    $0x10,%esp
80106273:	c9                   	leave
80106274:	c3                   	ret

80106275 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $0
80106277:	6a 00                	push   $0x0
  jmp alltraps
80106279:	e9 09 fb ff ff       	jmp    80105d87 <alltraps>

8010627e <vector1>:
.globl vector1
vector1:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $1
80106280:	6a 01                	push   $0x1
  jmp alltraps
80106282:	e9 00 fb ff ff       	jmp    80105d87 <alltraps>

80106287 <vector2>:
.globl vector2
vector2:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $2
80106289:	6a 02                	push   $0x2
  jmp alltraps
8010628b:	e9 f7 fa ff ff       	jmp    80105d87 <alltraps>

80106290 <vector3>:
.globl vector3
vector3:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $3
80106292:	6a 03                	push   $0x3
  jmp alltraps
80106294:	e9 ee fa ff ff       	jmp    80105d87 <alltraps>

80106299 <vector4>:
.globl vector4
vector4:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $4
8010629b:	6a 04                	push   $0x4
  jmp alltraps
8010629d:	e9 e5 fa ff ff       	jmp    80105d87 <alltraps>

801062a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $5
801062a4:	6a 05                	push   $0x5
  jmp alltraps
801062a6:	e9 dc fa ff ff       	jmp    80105d87 <alltraps>

801062ab <vector6>:
.globl vector6
vector6:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $6
801062ad:	6a 06                	push   $0x6
  jmp alltraps
801062af:	e9 d3 fa ff ff       	jmp    80105d87 <alltraps>

801062b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $7
801062b6:	6a 07                	push   $0x7
  jmp alltraps
801062b8:	e9 ca fa ff ff       	jmp    80105d87 <alltraps>

801062bd <vector8>:
.globl vector8
vector8:
  pushl $8
801062bd:	6a 08                	push   $0x8
  jmp alltraps
801062bf:	e9 c3 fa ff ff       	jmp    80105d87 <alltraps>

801062c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $9
801062c6:	6a 09                	push   $0x9
  jmp alltraps
801062c8:	e9 ba fa ff ff       	jmp    80105d87 <alltraps>

801062cd <vector10>:
.globl vector10
vector10:
  pushl $10
801062cd:	6a 0a                	push   $0xa
  jmp alltraps
801062cf:	e9 b3 fa ff ff       	jmp    80105d87 <alltraps>

801062d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062d4:	6a 0b                	push   $0xb
  jmp alltraps
801062d6:	e9 ac fa ff ff       	jmp    80105d87 <alltraps>

801062db <vector12>:
.globl vector12
vector12:
  pushl $12
801062db:	6a 0c                	push   $0xc
  jmp alltraps
801062dd:	e9 a5 fa ff ff       	jmp    80105d87 <alltraps>

801062e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062e2:	6a 0d                	push   $0xd
  jmp alltraps
801062e4:	e9 9e fa ff ff       	jmp    80105d87 <alltraps>

801062e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062e9:	6a 0e                	push   $0xe
  jmp alltraps
801062eb:	e9 97 fa ff ff       	jmp    80105d87 <alltraps>

801062f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $15
801062f2:	6a 0f                	push   $0xf
  jmp alltraps
801062f4:	e9 8e fa ff ff       	jmp    80105d87 <alltraps>

801062f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $16
801062fb:	6a 10                	push   $0x10
  jmp alltraps
801062fd:	e9 85 fa ff ff       	jmp    80105d87 <alltraps>

80106302 <vector17>:
.globl vector17
vector17:
  pushl $17
80106302:	6a 11                	push   $0x11
  jmp alltraps
80106304:	e9 7e fa ff ff       	jmp    80105d87 <alltraps>

80106309 <vector18>:
.globl vector18
vector18:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $18
8010630b:	6a 12                	push   $0x12
  jmp alltraps
8010630d:	e9 75 fa ff ff       	jmp    80105d87 <alltraps>

80106312 <vector19>:
.globl vector19
vector19:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $19
80106314:	6a 13                	push   $0x13
  jmp alltraps
80106316:	e9 6c fa ff ff       	jmp    80105d87 <alltraps>

8010631b <vector20>:
.globl vector20
vector20:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $20
8010631d:	6a 14                	push   $0x14
  jmp alltraps
8010631f:	e9 63 fa ff ff       	jmp    80105d87 <alltraps>

80106324 <vector21>:
.globl vector21
vector21:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $21
80106326:	6a 15                	push   $0x15
  jmp alltraps
80106328:	e9 5a fa ff ff       	jmp    80105d87 <alltraps>

8010632d <vector22>:
.globl vector22
vector22:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $22
8010632f:	6a 16                	push   $0x16
  jmp alltraps
80106331:	e9 51 fa ff ff       	jmp    80105d87 <alltraps>

80106336 <vector23>:
.globl vector23
vector23:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $23
80106338:	6a 17                	push   $0x17
  jmp alltraps
8010633a:	e9 48 fa ff ff       	jmp    80105d87 <alltraps>

8010633f <vector24>:
.globl vector24
vector24:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $24
80106341:	6a 18                	push   $0x18
  jmp alltraps
80106343:	e9 3f fa ff ff       	jmp    80105d87 <alltraps>

80106348 <vector25>:
.globl vector25
vector25:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $25
8010634a:	6a 19                	push   $0x19
  jmp alltraps
8010634c:	e9 36 fa ff ff       	jmp    80105d87 <alltraps>

80106351 <vector26>:
.globl vector26
vector26:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $26
80106353:	6a 1a                	push   $0x1a
  jmp alltraps
80106355:	e9 2d fa ff ff       	jmp    80105d87 <alltraps>

8010635a <vector27>:
.globl vector27
vector27:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $27
8010635c:	6a 1b                	push   $0x1b
  jmp alltraps
8010635e:	e9 24 fa ff ff       	jmp    80105d87 <alltraps>

80106363 <vector28>:
.globl vector28
vector28:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $28
80106365:	6a 1c                	push   $0x1c
  jmp alltraps
80106367:	e9 1b fa ff ff       	jmp    80105d87 <alltraps>

8010636c <vector29>:
.globl vector29
vector29:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $29
8010636e:	6a 1d                	push   $0x1d
  jmp alltraps
80106370:	e9 12 fa ff ff       	jmp    80105d87 <alltraps>

80106375 <vector30>:
.globl vector30
vector30:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $30
80106377:	6a 1e                	push   $0x1e
  jmp alltraps
80106379:	e9 09 fa ff ff       	jmp    80105d87 <alltraps>

8010637e <vector31>:
.globl vector31
vector31:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $31
80106380:	6a 1f                	push   $0x1f
  jmp alltraps
80106382:	e9 00 fa ff ff       	jmp    80105d87 <alltraps>

80106387 <vector32>:
.globl vector32
vector32:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $32
80106389:	6a 20                	push   $0x20
  jmp alltraps
8010638b:	e9 f7 f9 ff ff       	jmp    80105d87 <alltraps>

80106390 <vector33>:
.globl vector33
vector33:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $33
80106392:	6a 21                	push   $0x21
  jmp alltraps
80106394:	e9 ee f9 ff ff       	jmp    80105d87 <alltraps>

80106399 <vector34>:
.globl vector34
vector34:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $34
8010639b:	6a 22                	push   $0x22
  jmp alltraps
8010639d:	e9 e5 f9 ff ff       	jmp    80105d87 <alltraps>

801063a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $35
801063a4:	6a 23                	push   $0x23
  jmp alltraps
801063a6:	e9 dc f9 ff ff       	jmp    80105d87 <alltraps>

801063ab <vector36>:
.globl vector36
vector36:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $36
801063ad:	6a 24                	push   $0x24
  jmp alltraps
801063af:	e9 d3 f9 ff ff       	jmp    80105d87 <alltraps>

801063b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $37
801063b6:	6a 25                	push   $0x25
  jmp alltraps
801063b8:	e9 ca f9 ff ff       	jmp    80105d87 <alltraps>

801063bd <vector38>:
.globl vector38
vector38:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $38
801063bf:	6a 26                	push   $0x26
  jmp alltraps
801063c1:	e9 c1 f9 ff ff       	jmp    80105d87 <alltraps>

801063c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $39
801063c8:	6a 27                	push   $0x27
  jmp alltraps
801063ca:	e9 b8 f9 ff ff       	jmp    80105d87 <alltraps>

801063cf <vector40>:
.globl vector40
vector40:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $40
801063d1:	6a 28                	push   $0x28
  jmp alltraps
801063d3:	e9 af f9 ff ff       	jmp    80105d87 <alltraps>

801063d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $41
801063da:	6a 29                	push   $0x29
  jmp alltraps
801063dc:	e9 a6 f9 ff ff       	jmp    80105d87 <alltraps>

801063e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $42
801063e3:	6a 2a                	push   $0x2a
  jmp alltraps
801063e5:	e9 9d f9 ff ff       	jmp    80105d87 <alltraps>

801063ea <vector43>:
.globl vector43
vector43:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $43
801063ec:	6a 2b                	push   $0x2b
  jmp alltraps
801063ee:	e9 94 f9 ff ff       	jmp    80105d87 <alltraps>

801063f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $44
801063f5:	6a 2c                	push   $0x2c
  jmp alltraps
801063f7:	e9 8b f9 ff ff       	jmp    80105d87 <alltraps>

801063fc <vector45>:
.globl vector45
vector45:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $45
801063fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106400:	e9 82 f9 ff ff       	jmp    80105d87 <alltraps>

80106405 <vector46>:
.globl vector46
vector46:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $46
80106407:	6a 2e                	push   $0x2e
  jmp alltraps
80106409:	e9 79 f9 ff ff       	jmp    80105d87 <alltraps>

8010640e <vector47>:
.globl vector47
vector47:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $47
80106410:	6a 2f                	push   $0x2f
  jmp alltraps
80106412:	e9 70 f9 ff ff       	jmp    80105d87 <alltraps>

80106417 <vector48>:
.globl vector48
vector48:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $48
80106419:	6a 30                	push   $0x30
  jmp alltraps
8010641b:	e9 67 f9 ff ff       	jmp    80105d87 <alltraps>

80106420 <vector49>:
.globl vector49
vector49:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $49
80106422:	6a 31                	push   $0x31
  jmp alltraps
80106424:	e9 5e f9 ff ff       	jmp    80105d87 <alltraps>

80106429 <vector50>:
.globl vector50
vector50:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $50
8010642b:	6a 32                	push   $0x32
  jmp alltraps
8010642d:	e9 55 f9 ff ff       	jmp    80105d87 <alltraps>

80106432 <vector51>:
.globl vector51
vector51:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $51
80106434:	6a 33                	push   $0x33
  jmp alltraps
80106436:	e9 4c f9 ff ff       	jmp    80105d87 <alltraps>

8010643b <vector52>:
.globl vector52
vector52:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $52
8010643d:	6a 34                	push   $0x34
  jmp alltraps
8010643f:	e9 43 f9 ff ff       	jmp    80105d87 <alltraps>

80106444 <vector53>:
.globl vector53
vector53:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $53
80106446:	6a 35                	push   $0x35
  jmp alltraps
80106448:	e9 3a f9 ff ff       	jmp    80105d87 <alltraps>

8010644d <vector54>:
.globl vector54
vector54:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $54
8010644f:	6a 36                	push   $0x36
  jmp alltraps
80106451:	e9 31 f9 ff ff       	jmp    80105d87 <alltraps>

80106456 <vector55>:
.globl vector55
vector55:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $55
80106458:	6a 37                	push   $0x37
  jmp alltraps
8010645a:	e9 28 f9 ff ff       	jmp    80105d87 <alltraps>

8010645f <vector56>:
.globl vector56
vector56:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $56
80106461:	6a 38                	push   $0x38
  jmp alltraps
80106463:	e9 1f f9 ff ff       	jmp    80105d87 <alltraps>

80106468 <vector57>:
.globl vector57
vector57:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $57
8010646a:	6a 39                	push   $0x39
  jmp alltraps
8010646c:	e9 16 f9 ff ff       	jmp    80105d87 <alltraps>

80106471 <vector58>:
.globl vector58
vector58:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $58
80106473:	6a 3a                	push   $0x3a
  jmp alltraps
80106475:	e9 0d f9 ff ff       	jmp    80105d87 <alltraps>

8010647a <vector59>:
.globl vector59
vector59:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $59
8010647c:	6a 3b                	push   $0x3b
  jmp alltraps
8010647e:	e9 04 f9 ff ff       	jmp    80105d87 <alltraps>

80106483 <vector60>:
.globl vector60
vector60:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $60
80106485:	6a 3c                	push   $0x3c
  jmp alltraps
80106487:	e9 fb f8 ff ff       	jmp    80105d87 <alltraps>

8010648c <vector61>:
.globl vector61
vector61:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $61
8010648e:	6a 3d                	push   $0x3d
  jmp alltraps
80106490:	e9 f2 f8 ff ff       	jmp    80105d87 <alltraps>

80106495 <vector62>:
.globl vector62
vector62:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $62
80106497:	6a 3e                	push   $0x3e
  jmp alltraps
80106499:	e9 e9 f8 ff ff       	jmp    80105d87 <alltraps>

8010649e <vector63>:
.globl vector63
vector63:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $63
801064a0:	6a 3f                	push   $0x3f
  jmp alltraps
801064a2:	e9 e0 f8 ff ff       	jmp    80105d87 <alltraps>

801064a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $64
801064a9:	6a 40                	push   $0x40
  jmp alltraps
801064ab:	e9 d7 f8 ff ff       	jmp    80105d87 <alltraps>

801064b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $65
801064b2:	6a 41                	push   $0x41
  jmp alltraps
801064b4:	e9 ce f8 ff ff       	jmp    80105d87 <alltraps>

801064b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $66
801064bb:	6a 42                	push   $0x42
  jmp alltraps
801064bd:	e9 c5 f8 ff ff       	jmp    80105d87 <alltraps>

801064c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $67
801064c4:	6a 43                	push   $0x43
  jmp alltraps
801064c6:	e9 bc f8 ff ff       	jmp    80105d87 <alltraps>

801064cb <vector68>:
.globl vector68
vector68:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $68
801064cd:	6a 44                	push   $0x44
  jmp alltraps
801064cf:	e9 b3 f8 ff ff       	jmp    80105d87 <alltraps>

801064d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $69
801064d6:	6a 45                	push   $0x45
  jmp alltraps
801064d8:	e9 aa f8 ff ff       	jmp    80105d87 <alltraps>

801064dd <vector70>:
.globl vector70
vector70:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $70
801064df:	6a 46                	push   $0x46
  jmp alltraps
801064e1:	e9 a1 f8 ff ff       	jmp    80105d87 <alltraps>

801064e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $71
801064e8:	6a 47                	push   $0x47
  jmp alltraps
801064ea:	e9 98 f8 ff ff       	jmp    80105d87 <alltraps>

801064ef <vector72>:
.globl vector72
vector72:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $72
801064f1:	6a 48                	push   $0x48
  jmp alltraps
801064f3:	e9 8f f8 ff ff       	jmp    80105d87 <alltraps>

801064f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $73
801064fa:	6a 49                	push   $0x49
  jmp alltraps
801064fc:	e9 86 f8 ff ff       	jmp    80105d87 <alltraps>

80106501 <vector74>:
.globl vector74
vector74:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $74
80106503:	6a 4a                	push   $0x4a
  jmp alltraps
80106505:	e9 7d f8 ff ff       	jmp    80105d87 <alltraps>

8010650a <vector75>:
.globl vector75
vector75:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $75
8010650c:	6a 4b                	push   $0x4b
  jmp alltraps
8010650e:	e9 74 f8 ff ff       	jmp    80105d87 <alltraps>

80106513 <vector76>:
.globl vector76
vector76:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $76
80106515:	6a 4c                	push   $0x4c
  jmp alltraps
80106517:	e9 6b f8 ff ff       	jmp    80105d87 <alltraps>

8010651c <vector77>:
.globl vector77
vector77:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $77
8010651e:	6a 4d                	push   $0x4d
  jmp alltraps
80106520:	e9 62 f8 ff ff       	jmp    80105d87 <alltraps>

80106525 <vector78>:
.globl vector78
vector78:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $78
80106527:	6a 4e                	push   $0x4e
  jmp alltraps
80106529:	e9 59 f8 ff ff       	jmp    80105d87 <alltraps>

8010652e <vector79>:
.globl vector79
vector79:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $79
80106530:	6a 4f                	push   $0x4f
  jmp alltraps
80106532:	e9 50 f8 ff ff       	jmp    80105d87 <alltraps>

80106537 <vector80>:
.globl vector80
vector80:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $80
80106539:	6a 50                	push   $0x50
  jmp alltraps
8010653b:	e9 47 f8 ff ff       	jmp    80105d87 <alltraps>

80106540 <vector81>:
.globl vector81
vector81:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $81
80106542:	6a 51                	push   $0x51
  jmp alltraps
80106544:	e9 3e f8 ff ff       	jmp    80105d87 <alltraps>

80106549 <vector82>:
.globl vector82
vector82:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $82
8010654b:	6a 52                	push   $0x52
  jmp alltraps
8010654d:	e9 35 f8 ff ff       	jmp    80105d87 <alltraps>

80106552 <vector83>:
.globl vector83
vector83:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $83
80106554:	6a 53                	push   $0x53
  jmp alltraps
80106556:	e9 2c f8 ff ff       	jmp    80105d87 <alltraps>

8010655b <vector84>:
.globl vector84
vector84:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $84
8010655d:	6a 54                	push   $0x54
  jmp alltraps
8010655f:	e9 23 f8 ff ff       	jmp    80105d87 <alltraps>

80106564 <vector85>:
.globl vector85
vector85:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $85
80106566:	6a 55                	push   $0x55
  jmp alltraps
80106568:	e9 1a f8 ff ff       	jmp    80105d87 <alltraps>

8010656d <vector86>:
.globl vector86
vector86:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $86
8010656f:	6a 56                	push   $0x56
  jmp alltraps
80106571:	e9 11 f8 ff ff       	jmp    80105d87 <alltraps>

80106576 <vector87>:
.globl vector87
vector87:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $87
80106578:	6a 57                	push   $0x57
  jmp alltraps
8010657a:	e9 08 f8 ff ff       	jmp    80105d87 <alltraps>

8010657f <vector88>:
.globl vector88
vector88:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $88
80106581:	6a 58                	push   $0x58
  jmp alltraps
80106583:	e9 ff f7 ff ff       	jmp    80105d87 <alltraps>

80106588 <vector89>:
.globl vector89
vector89:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $89
8010658a:	6a 59                	push   $0x59
  jmp alltraps
8010658c:	e9 f6 f7 ff ff       	jmp    80105d87 <alltraps>

80106591 <vector90>:
.globl vector90
vector90:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $90
80106593:	6a 5a                	push   $0x5a
  jmp alltraps
80106595:	e9 ed f7 ff ff       	jmp    80105d87 <alltraps>

8010659a <vector91>:
.globl vector91
vector91:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $91
8010659c:	6a 5b                	push   $0x5b
  jmp alltraps
8010659e:	e9 e4 f7 ff ff       	jmp    80105d87 <alltraps>

801065a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $92
801065a5:	6a 5c                	push   $0x5c
  jmp alltraps
801065a7:	e9 db f7 ff ff       	jmp    80105d87 <alltraps>

801065ac <vector93>:
.globl vector93
vector93:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $93
801065ae:	6a 5d                	push   $0x5d
  jmp alltraps
801065b0:	e9 d2 f7 ff ff       	jmp    80105d87 <alltraps>

801065b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $94
801065b7:	6a 5e                	push   $0x5e
  jmp alltraps
801065b9:	e9 c9 f7 ff ff       	jmp    80105d87 <alltraps>

801065be <vector95>:
.globl vector95
vector95:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $95
801065c0:	6a 5f                	push   $0x5f
  jmp alltraps
801065c2:	e9 c0 f7 ff ff       	jmp    80105d87 <alltraps>

801065c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $96
801065c9:	6a 60                	push   $0x60
  jmp alltraps
801065cb:	e9 b7 f7 ff ff       	jmp    80105d87 <alltraps>

801065d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $97
801065d2:	6a 61                	push   $0x61
  jmp alltraps
801065d4:	e9 ae f7 ff ff       	jmp    80105d87 <alltraps>

801065d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $98
801065db:	6a 62                	push   $0x62
  jmp alltraps
801065dd:	e9 a5 f7 ff ff       	jmp    80105d87 <alltraps>

801065e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $99
801065e4:	6a 63                	push   $0x63
  jmp alltraps
801065e6:	e9 9c f7 ff ff       	jmp    80105d87 <alltraps>

801065eb <vector100>:
.globl vector100
vector100:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $100
801065ed:	6a 64                	push   $0x64
  jmp alltraps
801065ef:	e9 93 f7 ff ff       	jmp    80105d87 <alltraps>

801065f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $101
801065f6:	6a 65                	push   $0x65
  jmp alltraps
801065f8:	e9 8a f7 ff ff       	jmp    80105d87 <alltraps>

801065fd <vector102>:
.globl vector102
vector102:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $102
801065ff:	6a 66                	push   $0x66
  jmp alltraps
80106601:	e9 81 f7 ff ff       	jmp    80105d87 <alltraps>

80106606 <vector103>:
.globl vector103
vector103:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $103
80106608:	6a 67                	push   $0x67
  jmp alltraps
8010660a:	e9 78 f7 ff ff       	jmp    80105d87 <alltraps>

8010660f <vector104>:
.globl vector104
vector104:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $104
80106611:	6a 68                	push   $0x68
  jmp alltraps
80106613:	e9 6f f7 ff ff       	jmp    80105d87 <alltraps>

80106618 <vector105>:
.globl vector105
vector105:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $105
8010661a:	6a 69                	push   $0x69
  jmp alltraps
8010661c:	e9 66 f7 ff ff       	jmp    80105d87 <alltraps>

80106621 <vector106>:
.globl vector106
vector106:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $106
80106623:	6a 6a                	push   $0x6a
  jmp alltraps
80106625:	e9 5d f7 ff ff       	jmp    80105d87 <alltraps>

8010662a <vector107>:
.globl vector107
vector107:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $107
8010662c:	6a 6b                	push   $0x6b
  jmp alltraps
8010662e:	e9 54 f7 ff ff       	jmp    80105d87 <alltraps>

80106633 <vector108>:
.globl vector108
vector108:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $108
80106635:	6a 6c                	push   $0x6c
  jmp alltraps
80106637:	e9 4b f7 ff ff       	jmp    80105d87 <alltraps>

8010663c <vector109>:
.globl vector109
vector109:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $109
8010663e:	6a 6d                	push   $0x6d
  jmp alltraps
80106640:	e9 42 f7 ff ff       	jmp    80105d87 <alltraps>

80106645 <vector110>:
.globl vector110
vector110:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $110
80106647:	6a 6e                	push   $0x6e
  jmp alltraps
80106649:	e9 39 f7 ff ff       	jmp    80105d87 <alltraps>

8010664e <vector111>:
.globl vector111
vector111:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $111
80106650:	6a 6f                	push   $0x6f
  jmp alltraps
80106652:	e9 30 f7 ff ff       	jmp    80105d87 <alltraps>

80106657 <vector112>:
.globl vector112
vector112:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $112
80106659:	6a 70                	push   $0x70
  jmp alltraps
8010665b:	e9 27 f7 ff ff       	jmp    80105d87 <alltraps>

80106660 <vector113>:
.globl vector113
vector113:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $113
80106662:	6a 71                	push   $0x71
  jmp alltraps
80106664:	e9 1e f7 ff ff       	jmp    80105d87 <alltraps>

80106669 <vector114>:
.globl vector114
vector114:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $114
8010666b:	6a 72                	push   $0x72
  jmp alltraps
8010666d:	e9 15 f7 ff ff       	jmp    80105d87 <alltraps>

80106672 <vector115>:
.globl vector115
vector115:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $115
80106674:	6a 73                	push   $0x73
  jmp alltraps
80106676:	e9 0c f7 ff ff       	jmp    80105d87 <alltraps>

8010667b <vector116>:
.globl vector116
vector116:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $116
8010667d:	6a 74                	push   $0x74
  jmp alltraps
8010667f:	e9 03 f7 ff ff       	jmp    80105d87 <alltraps>

80106684 <vector117>:
.globl vector117
vector117:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $117
80106686:	6a 75                	push   $0x75
  jmp alltraps
80106688:	e9 fa f6 ff ff       	jmp    80105d87 <alltraps>

8010668d <vector118>:
.globl vector118
vector118:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $118
8010668f:	6a 76                	push   $0x76
  jmp alltraps
80106691:	e9 f1 f6 ff ff       	jmp    80105d87 <alltraps>

80106696 <vector119>:
.globl vector119
vector119:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $119
80106698:	6a 77                	push   $0x77
  jmp alltraps
8010669a:	e9 e8 f6 ff ff       	jmp    80105d87 <alltraps>

8010669f <vector120>:
.globl vector120
vector120:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $120
801066a1:	6a 78                	push   $0x78
  jmp alltraps
801066a3:	e9 df f6 ff ff       	jmp    80105d87 <alltraps>

801066a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $121
801066aa:	6a 79                	push   $0x79
  jmp alltraps
801066ac:	e9 d6 f6 ff ff       	jmp    80105d87 <alltraps>

801066b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $122
801066b3:	6a 7a                	push   $0x7a
  jmp alltraps
801066b5:	e9 cd f6 ff ff       	jmp    80105d87 <alltraps>

801066ba <vector123>:
.globl vector123
vector123:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $123
801066bc:	6a 7b                	push   $0x7b
  jmp alltraps
801066be:	e9 c4 f6 ff ff       	jmp    80105d87 <alltraps>

801066c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $124
801066c5:	6a 7c                	push   $0x7c
  jmp alltraps
801066c7:	e9 bb f6 ff ff       	jmp    80105d87 <alltraps>

801066cc <vector125>:
.globl vector125
vector125:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $125
801066ce:	6a 7d                	push   $0x7d
  jmp alltraps
801066d0:	e9 b2 f6 ff ff       	jmp    80105d87 <alltraps>

801066d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $126
801066d7:	6a 7e                	push   $0x7e
  jmp alltraps
801066d9:	e9 a9 f6 ff ff       	jmp    80105d87 <alltraps>

801066de <vector127>:
.globl vector127
vector127:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $127
801066e0:	6a 7f                	push   $0x7f
  jmp alltraps
801066e2:	e9 a0 f6 ff ff       	jmp    80105d87 <alltraps>

801066e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $128
801066e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066ee:	e9 94 f6 ff ff       	jmp    80105d87 <alltraps>

801066f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $129
801066f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066fa:	e9 88 f6 ff ff       	jmp    80105d87 <alltraps>

801066ff <vector130>:
.globl vector130
vector130:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $130
80106701:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106706:	e9 7c f6 ff ff       	jmp    80105d87 <alltraps>

8010670b <vector131>:
.globl vector131
vector131:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $131
8010670d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106712:	e9 70 f6 ff ff       	jmp    80105d87 <alltraps>

80106717 <vector132>:
.globl vector132
vector132:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $132
80106719:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010671e:	e9 64 f6 ff ff       	jmp    80105d87 <alltraps>

80106723 <vector133>:
.globl vector133
vector133:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $133
80106725:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010672a:	e9 58 f6 ff ff       	jmp    80105d87 <alltraps>

8010672f <vector134>:
.globl vector134
vector134:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $134
80106731:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106736:	e9 4c f6 ff ff       	jmp    80105d87 <alltraps>

8010673b <vector135>:
.globl vector135
vector135:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $135
8010673d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106742:	e9 40 f6 ff ff       	jmp    80105d87 <alltraps>

80106747 <vector136>:
.globl vector136
vector136:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $136
80106749:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010674e:	e9 34 f6 ff ff       	jmp    80105d87 <alltraps>

80106753 <vector137>:
.globl vector137
vector137:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $137
80106755:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010675a:	e9 28 f6 ff ff       	jmp    80105d87 <alltraps>

8010675f <vector138>:
.globl vector138
vector138:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $138
80106761:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106766:	e9 1c f6 ff ff       	jmp    80105d87 <alltraps>

8010676b <vector139>:
.globl vector139
vector139:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $139
8010676d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106772:	e9 10 f6 ff ff       	jmp    80105d87 <alltraps>

80106777 <vector140>:
.globl vector140
vector140:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $140
80106779:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010677e:	e9 04 f6 ff ff       	jmp    80105d87 <alltraps>

80106783 <vector141>:
.globl vector141
vector141:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $141
80106785:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010678a:	e9 f8 f5 ff ff       	jmp    80105d87 <alltraps>

8010678f <vector142>:
.globl vector142
vector142:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $142
80106791:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106796:	e9 ec f5 ff ff       	jmp    80105d87 <alltraps>

8010679b <vector143>:
.globl vector143
vector143:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $143
8010679d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067a2:	e9 e0 f5 ff ff       	jmp    80105d87 <alltraps>

801067a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $144
801067a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067ae:	e9 d4 f5 ff ff       	jmp    80105d87 <alltraps>

801067b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $145
801067b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067ba:	e9 c8 f5 ff ff       	jmp    80105d87 <alltraps>

801067bf <vector146>:
.globl vector146
vector146:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $146
801067c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067c6:	e9 bc f5 ff ff       	jmp    80105d87 <alltraps>

801067cb <vector147>:
.globl vector147
vector147:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $147
801067cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067d2:	e9 b0 f5 ff ff       	jmp    80105d87 <alltraps>

801067d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $148
801067d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067de:	e9 a4 f5 ff ff       	jmp    80105d87 <alltraps>

801067e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $149
801067e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067ea:	e9 98 f5 ff ff       	jmp    80105d87 <alltraps>

801067ef <vector150>:
.globl vector150
vector150:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $150
801067f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067f6:	e9 8c f5 ff ff       	jmp    80105d87 <alltraps>

801067fb <vector151>:
.globl vector151
vector151:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $151
801067fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106802:	e9 80 f5 ff ff       	jmp    80105d87 <alltraps>

80106807 <vector152>:
.globl vector152
vector152:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $152
80106809:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010680e:	e9 74 f5 ff ff       	jmp    80105d87 <alltraps>

80106813 <vector153>:
.globl vector153
vector153:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $153
80106815:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010681a:	e9 68 f5 ff ff       	jmp    80105d87 <alltraps>

8010681f <vector154>:
.globl vector154
vector154:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $154
80106821:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106826:	e9 5c f5 ff ff       	jmp    80105d87 <alltraps>

8010682b <vector155>:
.globl vector155
vector155:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $155
8010682d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106832:	e9 50 f5 ff ff       	jmp    80105d87 <alltraps>

80106837 <vector156>:
.globl vector156
vector156:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $156
80106839:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010683e:	e9 44 f5 ff ff       	jmp    80105d87 <alltraps>

80106843 <vector157>:
.globl vector157
vector157:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $157
80106845:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010684a:	e9 38 f5 ff ff       	jmp    80105d87 <alltraps>

8010684f <vector158>:
.globl vector158
vector158:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $158
80106851:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106856:	e9 2c f5 ff ff       	jmp    80105d87 <alltraps>

8010685b <vector159>:
.globl vector159
vector159:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $159
8010685d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106862:	e9 20 f5 ff ff       	jmp    80105d87 <alltraps>

80106867 <vector160>:
.globl vector160
vector160:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $160
80106869:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010686e:	e9 14 f5 ff ff       	jmp    80105d87 <alltraps>

80106873 <vector161>:
.globl vector161
vector161:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $161
80106875:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010687a:	e9 08 f5 ff ff       	jmp    80105d87 <alltraps>

8010687f <vector162>:
.globl vector162
vector162:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $162
80106881:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106886:	e9 fc f4 ff ff       	jmp    80105d87 <alltraps>

8010688b <vector163>:
.globl vector163
vector163:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $163
8010688d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106892:	e9 f0 f4 ff ff       	jmp    80105d87 <alltraps>

80106897 <vector164>:
.globl vector164
vector164:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $164
80106899:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010689e:	e9 e4 f4 ff ff       	jmp    80105d87 <alltraps>

801068a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $165
801068a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068aa:	e9 d8 f4 ff ff       	jmp    80105d87 <alltraps>

801068af <vector166>:
.globl vector166
vector166:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $166
801068b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068b6:	e9 cc f4 ff ff       	jmp    80105d87 <alltraps>

801068bb <vector167>:
.globl vector167
vector167:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $167
801068bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068c2:	e9 c0 f4 ff ff       	jmp    80105d87 <alltraps>

801068c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $168
801068c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068ce:	e9 b4 f4 ff ff       	jmp    80105d87 <alltraps>

801068d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $169
801068d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068da:	e9 a8 f4 ff ff       	jmp    80105d87 <alltraps>

801068df <vector170>:
.globl vector170
vector170:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $170
801068e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068e6:	e9 9c f4 ff ff       	jmp    80105d87 <alltraps>

801068eb <vector171>:
.globl vector171
vector171:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $171
801068ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068f2:	e9 90 f4 ff ff       	jmp    80105d87 <alltraps>

801068f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $172
801068f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068fe:	e9 84 f4 ff ff       	jmp    80105d87 <alltraps>

80106903 <vector173>:
.globl vector173
vector173:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $173
80106905:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010690a:	e9 78 f4 ff ff       	jmp    80105d87 <alltraps>

8010690f <vector174>:
.globl vector174
vector174:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $174
80106911:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106916:	e9 6c f4 ff ff       	jmp    80105d87 <alltraps>

8010691b <vector175>:
.globl vector175
vector175:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $175
8010691d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106922:	e9 60 f4 ff ff       	jmp    80105d87 <alltraps>

80106927 <vector176>:
.globl vector176
vector176:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $176
80106929:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010692e:	e9 54 f4 ff ff       	jmp    80105d87 <alltraps>

80106933 <vector177>:
.globl vector177
vector177:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $177
80106935:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010693a:	e9 48 f4 ff ff       	jmp    80105d87 <alltraps>

8010693f <vector178>:
.globl vector178
vector178:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $178
80106941:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106946:	e9 3c f4 ff ff       	jmp    80105d87 <alltraps>

8010694b <vector179>:
.globl vector179
vector179:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $179
8010694d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106952:	e9 30 f4 ff ff       	jmp    80105d87 <alltraps>

80106957 <vector180>:
.globl vector180
vector180:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $180
80106959:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010695e:	e9 24 f4 ff ff       	jmp    80105d87 <alltraps>

80106963 <vector181>:
.globl vector181
vector181:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $181
80106965:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010696a:	e9 18 f4 ff ff       	jmp    80105d87 <alltraps>

8010696f <vector182>:
.globl vector182
vector182:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $182
80106971:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106976:	e9 0c f4 ff ff       	jmp    80105d87 <alltraps>

8010697b <vector183>:
.globl vector183
vector183:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $183
8010697d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106982:	e9 00 f4 ff ff       	jmp    80105d87 <alltraps>

80106987 <vector184>:
.globl vector184
vector184:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $184
80106989:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010698e:	e9 f4 f3 ff ff       	jmp    80105d87 <alltraps>

80106993 <vector185>:
.globl vector185
vector185:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $185
80106995:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010699a:	e9 e8 f3 ff ff       	jmp    80105d87 <alltraps>

8010699f <vector186>:
.globl vector186
vector186:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $186
801069a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069a6:	e9 dc f3 ff ff       	jmp    80105d87 <alltraps>

801069ab <vector187>:
.globl vector187
vector187:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $187
801069ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069b2:	e9 d0 f3 ff ff       	jmp    80105d87 <alltraps>

801069b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $188
801069b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069be:	e9 c4 f3 ff ff       	jmp    80105d87 <alltraps>

801069c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $189
801069c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069ca:	e9 b8 f3 ff ff       	jmp    80105d87 <alltraps>

801069cf <vector190>:
.globl vector190
vector190:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $190
801069d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069d6:	e9 ac f3 ff ff       	jmp    80105d87 <alltraps>

801069db <vector191>:
.globl vector191
vector191:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $191
801069dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069e2:	e9 a0 f3 ff ff       	jmp    80105d87 <alltraps>

801069e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $192
801069e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069ee:	e9 94 f3 ff ff       	jmp    80105d87 <alltraps>

801069f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $193
801069f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069fa:	e9 88 f3 ff ff       	jmp    80105d87 <alltraps>

801069ff <vector194>:
.globl vector194
vector194:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $194
80106a01:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a06:	e9 7c f3 ff ff       	jmp    80105d87 <alltraps>

80106a0b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $195
80106a0d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a12:	e9 70 f3 ff ff       	jmp    80105d87 <alltraps>

80106a17 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $196
80106a19:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a1e:	e9 64 f3 ff ff       	jmp    80105d87 <alltraps>

80106a23 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $197
80106a25:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a2a:	e9 58 f3 ff ff       	jmp    80105d87 <alltraps>

80106a2f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $198
80106a31:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a36:	e9 4c f3 ff ff       	jmp    80105d87 <alltraps>

80106a3b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $199
80106a3d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a42:	e9 40 f3 ff ff       	jmp    80105d87 <alltraps>

80106a47 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $200
80106a49:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a4e:	e9 34 f3 ff ff       	jmp    80105d87 <alltraps>

80106a53 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $201
80106a55:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a5a:	e9 28 f3 ff ff       	jmp    80105d87 <alltraps>

80106a5f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $202
80106a61:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a66:	e9 1c f3 ff ff       	jmp    80105d87 <alltraps>

80106a6b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $203
80106a6d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a72:	e9 10 f3 ff ff       	jmp    80105d87 <alltraps>

80106a77 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $204
80106a79:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a7e:	e9 04 f3 ff ff       	jmp    80105d87 <alltraps>

80106a83 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $205
80106a85:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a8a:	e9 f8 f2 ff ff       	jmp    80105d87 <alltraps>

80106a8f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $206
80106a91:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a96:	e9 ec f2 ff ff       	jmp    80105d87 <alltraps>

80106a9b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $207
80106a9d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106aa2:	e9 e0 f2 ff ff       	jmp    80105d87 <alltraps>

80106aa7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $208
80106aa9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106aae:	e9 d4 f2 ff ff       	jmp    80105d87 <alltraps>

80106ab3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $209
80106ab5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aba:	e9 c8 f2 ff ff       	jmp    80105d87 <alltraps>

80106abf <vector210>:
.globl vector210
vector210:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $210
80106ac1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ac6:	e9 bc f2 ff ff       	jmp    80105d87 <alltraps>

80106acb <vector211>:
.globl vector211
vector211:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $211
80106acd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ad2:	e9 b0 f2 ff ff       	jmp    80105d87 <alltraps>

80106ad7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $212
80106ad9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ade:	e9 a4 f2 ff ff       	jmp    80105d87 <alltraps>

80106ae3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $213
80106ae5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aea:	e9 98 f2 ff ff       	jmp    80105d87 <alltraps>

80106aef <vector214>:
.globl vector214
vector214:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $214
80106af1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106af6:	e9 8c f2 ff ff       	jmp    80105d87 <alltraps>

80106afb <vector215>:
.globl vector215
vector215:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $215
80106afd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b02:	e9 80 f2 ff ff       	jmp    80105d87 <alltraps>

80106b07 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $216
80106b09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b0e:	e9 74 f2 ff ff       	jmp    80105d87 <alltraps>

80106b13 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $217
80106b15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b1a:	e9 68 f2 ff ff       	jmp    80105d87 <alltraps>

80106b1f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $218
80106b21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b26:	e9 5c f2 ff ff       	jmp    80105d87 <alltraps>

80106b2b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $219
80106b2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b32:	e9 50 f2 ff ff       	jmp    80105d87 <alltraps>

80106b37 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $220
80106b39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b3e:	e9 44 f2 ff ff       	jmp    80105d87 <alltraps>

80106b43 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $221
80106b45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b4a:	e9 38 f2 ff ff       	jmp    80105d87 <alltraps>

80106b4f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $222
80106b51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b56:	e9 2c f2 ff ff       	jmp    80105d87 <alltraps>

80106b5b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $223
80106b5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b62:	e9 20 f2 ff ff       	jmp    80105d87 <alltraps>

80106b67 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $224
80106b69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b6e:	e9 14 f2 ff ff       	jmp    80105d87 <alltraps>

80106b73 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $225
80106b75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b7a:	e9 08 f2 ff ff       	jmp    80105d87 <alltraps>

80106b7f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $226
80106b81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b86:	e9 fc f1 ff ff       	jmp    80105d87 <alltraps>

80106b8b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $227
80106b8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b92:	e9 f0 f1 ff ff       	jmp    80105d87 <alltraps>

80106b97 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $228
80106b99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b9e:	e9 e4 f1 ff ff       	jmp    80105d87 <alltraps>

80106ba3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $229
80106ba5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106baa:	e9 d8 f1 ff ff       	jmp    80105d87 <alltraps>

80106baf <vector230>:
.globl vector230
vector230:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $230
80106bb1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106bb6:	e9 cc f1 ff ff       	jmp    80105d87 <alltraps>

80106bbb <vector231>:
.globl vector231
vector231:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $231
80106bbd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bc2:	e9 c0 f1 ff ff       	jmp    80105d87 <alltraps>

80106bc7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $232
80106bc9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bce:	e9 b4 f1 ff ff       	jmp    80105d87 <alltraps>

80106bd3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $233
80106bd5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106bda:	e9 a8 f1 ff ff       	jmp    80105d87 <alltraps>

80106bdf <vector234>:
.globl vector234
vector234:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $234
80106be1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106be6:	e9 9c f1 ff ff       	jmp    80105d87 <alltraps>

80106beb <vector235>:
.globl vector235
vector235:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $235
80106bed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bf2:	e9 90 f1 ff ff       	jmp    80105d87 <alltraps>

80106bf7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $236
80106bf9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bfe:	e9 84 f1 ff ff       	jmp    80105d87 <alltraps>

80106c03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $237
80106c05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c0a:	e9 78 f1 ff ff       	jmp    80105d87 <alltraps>

80106c0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $238
80106c11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c16:	e9 6c f1 ff ff       	jmp    80105d87 <alltraps>

80106c1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $239
80106c1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c22:	e9 60 f1 ff ff       	jmp    80105d87 <alltraps>

80106c27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $240
80106c29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c2e:	e9 54 f1 ff ff       	jmp    80105d87 <alltraps>

80106c33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $241
80106c35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c3a:	e9 48 f1 ff ff       	jmp    80105d87 <alltraps>

80106c3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $242
80106c41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c46:	e9 3c f1 ff ff       	jmp    80105d87 <alltraps>

80106c4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $243
80106c4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c52:	e9 30 f1 ff ff       	jmp    80105d87 <alltraps>

80106c57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $244
80106c59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c5e:	e9 24 f1 ff ff       	jmp    80105d87 <alltraps>

80106c63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $245
80106c65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c6a:	e9 18 f1 ff ff       	jmp    80105d87 <alltraps>

80106c6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $246
80106c71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c76:	e9 0c f1 ff ff       	jmp    80105d87 <alltraps>

80106c7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $247
80106c7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c82:	e9 00 f1 ff ff       	jmp    80105d87 <alltraps>

80106c87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $248
80106c89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c8e:	e9 f4 f0 ff ff       	jmp    80105d87 <alltraps>

80106c93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $249
80106c95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c9a:	e9 e8 f0 ff ff       	jmp    80105d87 <alltraps>

80106c9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $250
80106ca1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ca6:	e9 dc f0 ff ff       	jmp    80105d87 <alltraps>

80106cab <vector251>:
.globl vector251
vector251:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $251
80106cad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106cb2:	e9 d0 f0 ff ff       	jmp    80105d87 <alltraps>

80106cb7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $252
80106cb9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cbe:	e9 c4 f0 ff ff       	jmp    80105d87 <alltraps>

80106cc3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $253
80106cc5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cca:	e9 b8 f0 ff ff       	jmp    80105d87 <alltraps>

80106ccf <vector254>:
.globl vector254
vector254:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $254
80106cd1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106cd6:	e9 ac f0 ff ff       	jmp    80105d87 <alltraps>

80106cdb <vector255>:
.globl vector255
vector255:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $255
80106cdd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ce2:	e9 a0 f0 ff ff       	jmp    80105d87 <alltraps>
80106ce7:	66 90                	xchg   %ax,%ax
80106ce9:	66 90                	xchg   %ax,%ax
80106ceb:	66 90                	xchg   %ax,%ax
80106ced:	66 90                	xchg   %ax,%ax
80106cef:	90                   	nop

80106cf0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106cf6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106cfc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d02:	83 ec 1c             	sub    $0x1c,%esp
80106d05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d08:	39 d3                	cmp    %edx,%ebx
80106d0a:	73 49                	jae    80106d55 <deallocuvm.part.0+0x65>
80106d0c:	89 c7                	mov    %eax,%edi
80106d0e:	eb 0c                	jmp    80106d1c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d10:	83 c0 01             	add    $0x1,%eax
80106d13:	c1 e0 16             	shl    $0x16,%eax
80106d16:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d18:	39 da                	cmp    %ebx,%edx
80106d1a:	76 39                	jbe    80106d55 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106d1c:	89 d8                	mov    %ebx,%eax
80106d1e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106d21:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106d24:	f6 c1 01             	test   $0x1,%cl
80106d27:	74 e7                	je     80106d10 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106d29:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d2b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d31:	c1 ee 0a             	shr    $0xa,%esi
80106d34:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106d3a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106d41:	85 f6                	test   %esi,%esi
80106d43:	74 cb                	je     80106d10 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106d45:	8b 06                	mov    (%esi),%eax
80106d47:	a8 01                	test   $0x1,%al
80106d49:	75 15                	jne    80106d60 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106d4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d51:	39 da                	cmp    %ebx,%edx
80106d53:	77 c7                	ja     80106d1c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d5b:	5b                   	pop    %ebx
80106d5c:	5e                   	pop    %esi
80106d5d:	5f                   	pop    %edi
80106d5e:	5d                   	pop    %ebp
80106d5f:	c3                   	ret
      if(pa == 0)
80106d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d65:	74 25                	je     80106d8c <deallocuvm.part.0+0x9c>
      kfree(v);
80106d67:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d6a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d78:	50                   	push   %eax
80106d79:	e8 72 b8 ff ff       	call   801025f0 <kfree>
      *pte = 0;
80106d7e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106d84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d87:	83 c4 10             	add    $0x10,%esp
80106d8a:	eb 8c                	jmp    80106d18 <deallocuvm.part.0+0x28>
        panic("kfree");
80106d8c:	83 ec 0c             	sub    $0xc,%esp
80106d8f:	68 ac 78 10 80       	push   $0x801078ac
80106d94:	e8 e7 95 ff ff       	call   80100380 <panic>
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106da0 <mappages>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106da6:	89 d3                	mov    %edx,%ebx
80106da8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106dae:	83 ec 1c             	sub    $0x1c,%esp
80106db1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106db4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106db8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc3:	29 d8                	sub    %ebx,%eax
80106dc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106dc8:	eb 3d                	jmp    80106e07 <mappages+0x67>
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106dd0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106dd7:	c1 ea 0a             	shr    $0xa,%edx
80106dda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106de0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106de7:	85 c0                	test   %eax,%eax
80106de9:	74 75                	je     80106e60 <mappages+0xc0>
    if(*pte & PTE_P)
80106deb:	f6 00 01             	testb  $0x1,(%eax)
80106dee:	0f 85 86 00 00 00    	jne    80106e7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106df4:	0b 75 0c             	or     0xc(%ebp),%esi
80106df7:	83 ce 01             	or     $0x1,%esi
80106dfa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dfc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106dff:	74 6f                	je     80106e70 <mappages+0xd0>
    a += PGSIZE;
80106e01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106e0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106e10:	89 d8                	mov    %ebx,%eax
80106e12:	c1 e8 16             	shr    $0x16,%eax
80106e15:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106e18:	8b 07                	mov    (%edi),%eax
80106e1a:	a8 01                	test   $0x1,%al
80106e1c:	75 b2                	jne    80106dd0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e1e:	e8 8d b9 ff ff       	call   801027b0 <kalloc>
80106e23:	85 c0                	test   %eax,%eax
80106e25:	74 39                	je     80106e60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106e27:	83 ec 04             	sub    $0x4,%esp
80106e2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106e2d:	68 00 10 00 00       	push   $0x1000
80106e32:	6a 00                	push   $0x0
80106e34:	50                   	push   %eax
80106e35:	e8 76 da ff ff       	call   801048b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106e3d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e40:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106e46:	83 c8 07             	or     $0x7,%eax
80106e49:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106e4b:	89 d8                	mov    %ebx,%eax
80106e4d:	c1 e8 0a             	shr    $0xa,%eax
80106e50:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e55:	01 d0                	add    %edx,%eax
80106e57:	eb 92                	jmp    80106deb <mappages+0x4b>
80106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e68:	5b                   	pop    %ebx
80106e69:	5e                   	pop    %esi
80106e6a:	5f                   	pop    %edi
80106e6b:	5d                   	pop    %ebp
80106e6c:	c3                   	ret
80106e6d:	8d 76 00             	lea    0x0(%esi),%esi
80106e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e73:	31 c0                	xor    %eax,%eax
}
80106e75:	5b                   	pop    %ebx
80106e76:	5e                   	pop    %esi
80106e77:	5f                   	pop    %edi
80106e78:	5d                   	pop    %ebp
80106e79:	c3                   	ret
      panic("remap");
80106e7a:	83 ec 0c             	sub    $0xc,%esp
80106e7d:	68 ff 7a 10 80       	push   $0x80107aff
80106e82:	e8 f9 94 ff ff       	call   80100380 <panic>
80106e87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e8e:	00 
80106e8f:	90                   	nop

80106e90 <seginit>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e96:	e8 95 cc ff ff       	call   80103b30 <cpuid>
  pd[0] = size-1;
80106e9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ea0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ea6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eaa:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106eb1:	ff 00 00 
80106eb4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106ebb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ebe:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106ec5:	ff 00 00 
80106ec8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106ecf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ed2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106ed9:	ff 00 00 
80106edc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106ee3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ee6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106eed:	ff 00 00 
80106ef0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106ef7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106efa:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106eff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f03:	c1 e8 10             	shr    $0x10,%eax
80106f06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f0d:	0f 01 10             	lgdtl  (%eax)
}
80106f10:	c9                   	leave
80106f11:	c3                   	ret
80106f12:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f19:	00 
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f20:	a1 c4 6e 11 80       	mov    0x80116ec4,%eax
80106f25:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f2a:	0f 22 d8             	mov    %eax,%cr3
}
80106f2d:	c3                   	ret
80106f2e:	66 90                	xchg   %ax,%ax

80106f30 <switchuvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
80106f36:	83 ec 1c             	sub    $0x1c,%esp
80106f39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f3c:	85 f6                	test   %esi,%esi
80106f3e:	0f 84 cb 00 00 00    	je     8010700f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f44:	8b 46 08             	mov    0x8(%esi),%eax
80106f47:	85 c0                	test   %eax,%eax
80106f49:	0f 84 da 00 00 00    	je     80107029 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f4f:	8b 46 04             	mov    0x4(%esi),%eax
80106f52:	85 c0                	test   %eax,%eax
80106f54:	0f 84 c2 00 00 00    	je     8010701c <switchuvm+0xec>
  pushcli();
80106f5a:	e8 41 d7 ff ff       	call   801046a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f5f:	e8 6c cb ff ff       	call   80103ad0 <mycpu>
80106f64:	89 c3                	mov    %eax,%ebx
80106f66:	e8 65 cb ff ff       	call   80103ad0 <mycpu>
80106f6b:	89 c7                	mov    %eax,%edi
80106f6d:	e8 5e cb ff ff       	call   80103ad0 <mycpu>
80106f72:	83 c7 08             	add    $0x8,%edi
80106f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f78:	e8 53 cb ff ff       	call   80103ad0 <mycpu>
80106f7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f80:	ba 67 00 00 00       	mov    $0x67,%edx
80106f85:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f8c:	83 c0 08             	add    $0x8,%eax
80106f8f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f96:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f9b:	83 c1 08             	add    $0x8,%ecx
80106f9e:	c1 e8 18             	shr    $0x18,%eax
80106fa1:	c1 e9 10             	shr    $0x10,%ecx
80106fa4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106faa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106fb0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106fb5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106fc1:	e8 0a cb ff ff       	call   80103ad0 <mycpu>
80106fc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fcd:	e8 fe ca ff ff       	call   80103ad0 <mycpu>
80106fd2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fd6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106fd9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fdf:	e8 ec ca ff ff       	call   80103ad0 <mycpu>
80106fe4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fe7:	e8 e4 ca ff ff       	call   80103ad0 <mycpu>
80106fec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ff0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ff5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ff8:	8b 46 04             	mov    0x4(%esi),%eax
80106ffb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107000:	0f 22 d8             	mov    %eax,%cr3
}
80107003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107006:	5b                   	pop    %ebx
80107007:	5e                   	pop    %esi
80107008:	5f                   	pop    %edi
80107009:	5d                   	pop    %ebp
  popcli();
8010700a:	e9 e1 d6 ff ff       	jmp    801046f0 <popcli>
    panic("switchuvm: no process");
8010700f:	83 ec 0c             	sub    $0xc,%esp
80107012:	68 05 7b 10 80       	push   $0x80107b05
80107017:	e8 64 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010701c:	83 ec 0c             	sub    $0xc,%esp
8010701f:	68 30 7b 10 80       	push   $0x80107b30
80107024:	e8 57 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107029:	83 ec 0c             	sub    $0xc,%esp
8010702c:	68 1b 7b 10 80       	push   $0x80107b1b
80107031:	e8 4a 93 ff ff       	call   80100380 <panic>
80107036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010703d:	00 
8010703e:	66 90                	xchg   %ax,%ax

80107040 <inituvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
80107049:	8b 45 0c             	mov    0xc(%ebp),%eax
8010704c:	8b 75 10             	mov    0x10(%ebp),%esi
8010704f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107055:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010705b:	77 4b                	ja     801070a8 <inituvm+0x68>
  mem = kalloc();
8010705d:	e8 4e b7 ff ff       	call   801027b0 <kalloc>
  memset(mem, 0, PGSIZE);
80107062:	83 ec 04             	sub    $0x4,%esp
80107065:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010706a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010706c:	6a 00                	push   $0x0
8010706e:	50                   	push   %eax
8010706f:	e8 3c d8 ff ff       	call   801048b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107074:	58                   	pop    %eax
80107075:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010707b:	5a                   	pop    %edx
8010707c:	6a 06                	push   $0x6
8010707e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107083:	31 d2                	xor    %edx,%edx
80107085:	50                   	push   %eax
80107086:	89 f8                	mov    %edi,%eax
80107088:	e8 13 fd ff ff       	call   80106da0 <mappages>
  memmove(mem, init, sz);
8010708d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107090:	89 75 10             	mov    %esi,0x10(%ebp)
80107093:	83 c4 10             	add    $0x10,%esp
80107096:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107099:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010709c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709f:	5b                   	pop    %ebx
801070a0:	5e                   	pop    %esi
801070a1:	5f                   	pop    %edi
801070a2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070a3:	e9 a8 d8 ff ff       	jmp    80104950 <memmove>
    panic("inituvm: more than a page");
801070a8:	83 ec 0c             	sub    $0xc,%esp
801070ab:	68 44 7b 10 80       	push   $0x80107b44
801070b0:	e8 cb 92 ff ff       	call   80100380 <panic>
801070b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070bc:	00 
801070bd:	8d 76 00             	lea    0x0(%esi),%esi

801070c0 <loaduvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070cc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801070cf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801070d4:	0f 85 bb 00 00 00    	jne    80107195 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801070da:	01 f0                	add    %esi,%eax
801070dc:	89 f3                	mov    %esi,%ebx
801070de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070e1:	8b 45 14             	mov    0x14(%ebp),%eax
801070e4:	01 f0                	add    %esi,%eax
801070e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801070e9:	85 f6                	test   %esi,%esi
801070eb:	0f 84 87 00 00 00    	je     80107178 <loaduvm+0xb8>
801070f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801070f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801070fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801070fe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107100:	89 c2                	mov    %eax,%edx
80107102:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107105:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107108:	f6 c2 01             	test   $0x1,%dl
8010710b:	75 13                	jne    80107120 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010710d:	83 ec 0c             	sub    $0xc,%esp
80107110:	68 5e 7b 10 80       	push   $0x80107b5e
80107115:	e8 66 92 ff ff       	call   80100380 <panic>
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107120:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107123:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107129:	25 fc 0f 00 00       	and    $0xffc,%eax
8010712e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107135:	85 c0                	test   %eax,%eax
80107137:	74 d4                	je     8010710d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107139:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010713b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010713e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107143:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107148:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010714e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107151:	29 d9                	sub    %ebx,%ecx
80107153:	05 00 00 00 80       	add    $0x80000000,%eax
80107158:	57                   	push   %edi
80107159:	51                   	push   %ecx
8010715a:	50                   	push   %eax
8010715b:	ff 75 10             	push   0x10(%ebp)
8010715e:	e8 5d aa ff ff       	call   80101bc0 <readi>
80107163:	83 c4 10             	add    $0x10,%esp
80107166:	39 f8                	cmp    %edi,%eax
80107168:	75 1e                	jne    80107188 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010716a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107170:	89 f0                	mov    %esi,%eax
80107172:	29 d8                	sub    %ebx,%eax
80107174:	39 c6                	cmp    %eax,%esi
80107176:	77 80                	ja     801070f8 <loaduvm+0x38>
}
80107178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010717b:	31 c0                	xor    %eax,%eax
}
8010717d:	5b                   	pop    %ebx
8010717e:	5e                   	pop    %esi
8010717f:	5f                   	pop    %edi
80107180:	5d                   	pop    %ebp
80107181:	c3                   	ret
80107182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107188:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010718b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107190:	5b                   	pop    %ebx
80107191:	5e                   	pop    %esi
80107192:	5f                   	pop    %edi
80107193:	5d                   	pop    %ebp
80107194:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80107195:	83 ec 0c             	sub    $0xc,%esp
80107198:	68 4c 7e 10 80       	push   $0x80107e4c
8010719d:	e8 de 91 ff ff       	call   80100380 <panic>
801071a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071a9:	00 
801071aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071b0 <allocuvm>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071b9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801071bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071c2:	85 c0                	test   %eax,%eax
801071c4:	0f 88 b6 00 00 00    	js     80107280 <allocuvm+0xd0>
  if(newsz < oldsz)
801071ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801071cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801071d0:	0f 82 9a 00 00 00    	jb     80107270 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801071d6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801071dc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801071e2:	39 75 10             	cmp    %esi,0x10(%ebp)
801071e5:	77 44                	ja     8010722b <allocuvm+0x7b>
801071e7:	e9 87 00 00 00       	jmp    80107273 <allocuvm+0xc3>
801071ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801071f0:	83 ec 04             	sub    $0x4,%esp
801071f3:	68 00 10 00 00       	push   $0x1000
801071f8:	6a 00                	push   $0x0
801071fa:	50                   	push   %eax
801071fb:	e8 b0 d6 ff ff       	call   801048b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107200:	58                   	pop    %eax
80107201:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107207:	5a                   	pop    %edx
80107208:	6a 06                	push   $0x6
8010720a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010720f:	89 f2                	mov    %esi,%edx
80107211:	50                   	push   %eax
80107212:	89 f8                	mov    %edi,%eax
80107214:	e8 87 fb ff ff       	call   80106da0 <mappages>
80107219:	83 c4 10             	add    $0x10,%esp
8010721c:	85 c0                	test   %eax,%eax
8010721e:	78 78                	js     80107298 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107220:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107226:	39 75 10             	cmp    %esi,0x10(%ebp)
80107229:	76 48                	jbe    80107273 <allocuvm+0xc3>
    mem = kalloc();
8010722b:	e8 80 b5 ff ff       	call   801027b0 <kalloc>
80107230:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107232:	85 c0                	test   %eax,%eax
80107234:	75 ba                	jne    801071f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107236:	83 ec 0c             	sub    $0xc,%esp
80107239:	68 7c 7b 10 80       	push   $0x80107b7c
8010723e:	e8 5d 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107243:	8b 45 0c             	mov    0xc(%ebp),%eax
80107246:	83 c4 10             	add    $0x10,%esp
80107249:	39 45 10             	cmp    %eax,0x10(%ebp)
8010724c:	74 32                	je     80107280 <allocuvm+0xd0>
8010724e:	8b 55 10             	mov    0x10(%ebp),%edx
80107251:	89 c1                	mov    %eax,%ecx
80107253:	89 f8                	mov    %edi,%eax
80107255:	e8 96 fa ff ff       	call   80106cf0 <deallocuvm.part.0>
      return 0;
8010725a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107261:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107264:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107267:	5b                   	pop    %ebx
80107268:	5e                   	pop    %esi
80107269:	5f                   	pop    %edi
8010726a:	5d                   	pop    %ebp
8010726b:	c3                   	ret
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107276:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107279:	5b                   	pop    %ebx
8010727a:	5e                   	pop    %esi
8010727b:	5f                   	pop    %edi
8010727c:	5d                   	pop    %ebp
8010727d:	c3                   	ret
8010727e:	66 90                	xchg   %ax,%ax
    return 0;
80107280:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010728a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010728d:	5b                   	pop    %ebx
8010728e:	5e                   	pop    %esi
8010728f:	5f                   	pop    %edi
80107290:	5d                   	pop    %ebp
80107291:	c3                   	ret
80107292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107298:	83 ec 0c             	sub    $0xc,%esp
8010729b:	68 94 7b 10 80       	push   $0x80107b94
801072a0:	e8 fb 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072a8:	83 c4 10             	add    $0x10,%esp
801072ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801072ae:	74 0c                	je     801072bc <allocuvm+0x10c>
801072b0:	8b 55 10             	mov    0x10(%ebp),%edx
801072b3:	89 c1                	mov    %eax,%ecx
801072b5:	89 f8                	mov    %edi,%eax
801072b7:	e8 34 fa ff ff       	call   80106cf0 <deallocuvm.part.0>
      kfree(mem);
801072bc:	83 ec 0c             	sub    $0xc,%esp
801072bf:	53                   	push   %ebx
801072c0:	e8 2b b3 ff ff       	call   801025f0 <kfree>
      return 0;
801072c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072cc:	83 c4 10             	add    $0x10,%esp
}
801072cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d5:	5b                   	pop    %ebx
801072d6:	5e                   	pop    %esi
801072d7:	5f                   	pop    %edi
801072d8:	5d                   	pop    %ebp
801072d9:	c3                   	ret
801072da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072e0 <deallocuvm>:
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801072e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801072e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801072ec:	39 d1                	cmp    %edx,%ecx
801072ee:	73 10                	jae    80107300 <deallocuvm+0x20>
}
801072f0:	5d                   	pop    %ebp
801072f1:	e9 fa f9 ff ff       	jmp    80106cf0 <deallocuvm.part.0>
801072f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072fd:	00 
801072fe:	66 90                	xchg   %ax,%ax
80107300:	89 d0                	mov    %edx,%eax
80107302:	5d                   	pop    %ebp
80107303:	c3                   	ret
80107304:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010730b:	00 
8010730c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107310 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	57                   	push   %edi
80107314:	56                   	push   %esi
80107315:	53                   	push   %ebx
80107316:	83 ec 0c             	sub    $0xc,%esp
80107319:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010731c:	85 f6                	test   %esi,%esi
8010731e:	74 59                	je     80107379 <freevm+0x69>
  if(newsz >= oldsz)
80107320:	31 c9                	xor    %ecx,%ecx
80107322:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107327:	89 f0                	mov    %esi,%eax
80107329:	89 f3                	mov    %esi,%ebx
8010732b:	e8 c0 f9 ff ff       	call   80106cf0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107330:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107336:	eb 0f                	jmp    80107347 <freevm+0x37>
80107338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010733f:	00 
80107340:	83 c3 04             	add    $0x4,%ebx
80107343:	39 df                	cmp    %ebx,%edi
80107345:	74 23                	je     8010736a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107347:	8b 03                	mov    (%ebx),%eax
80107349:	a8 01                	test   $0x1,%al
8010734b:	74 f3                	je     80107340 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010734d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107352:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107355:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107358:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010735d:	50                   	push   %eax
8010735e:	e8 8d b2 ff ff       	call   801025f0 <kfree>
80107363:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107366:	39 df                	cmp    %ebx,%edi
80107368:	75 dd                	jne    80107347 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010736a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010736d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107370:	5b                   	pop    %ebx
80107371:	5e                   	pop    %esi
80107372:	5f                   	pop    %edi
80107373:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107374:	e9 77 b2 ff ff       	jmp    801025f0 <kfree>
    panic("freevm: no pgdir");
80107379:	83 ec 0c             	sub    $0xc,%esp
8010737c:	68 b0 7b 10 80       	push   $0x80107bb0
80107381:	e8 fa 8f ff ff       	call   80100380 <panic>
80107386:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010738d:	00 
8010738e:	66 90                	xchg   %ax,%ax

80107390 <setupkvm>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	56                   	push   %esi
80107394:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107395:	e8 16 b4 ff ff       	call   801027b0 <kalloc>
8010739a:	89 c6                	mov    %eax,%esi
8010739c:	85 c0                	test   %eax,%eax
8010739e:	74 42                	je     801073e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801073a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073a8:	68 00 10 00 00       	push   $0x1000
801073ad:	6a 00                	push   $0x0
801073af:	50                   	push   %eax
801073b0:	e8 fb d4 ff ff       	call   801048b0 <memset>
801073b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073bb:	83 ec 08             	sub    $0x8,%esp
801073be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073c1:	ff 73 0c             	push   0xc(%ebx)
801073c4:	8b 13                	mov    (%ebx),%edx
801073c6:	50                   	push   %eax
801073c7:	29 c1                	sub    %eax,%ecx
801073c9:	89 f0                	mov    %esi,%eax
801073cb:	e8 d0 f9 ff ff       	call   80106da0 <mappages>
801073d0:	83 c4 10             	add    $0x10,%esp
801073d3:	85 c0                	test   %eax,%eax
801073d5:	78 19                	js     801073f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073d7:	83 c3 10             	add    $0x10,%ebx
801073da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801073e0:	75 d6                	jne    801073b8 <setupkvm+0x28>
}
801073e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073e5:	89 f0                	mov    %esi,%eax
801073e7:	5b                   	pop    %ebx
801073e8:	5e                   	pop    %esi
801073e9:	5d                   	pop    %ebp
801073ea:	c3                   	ret
801073eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801073f0:	83 ec 0c             	sub    $0xc,%esp
801073f3:	56                   	push   %esi
      return 0;
801073f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801073f6:	e8 15 ff ff ff       	call   80107310 <freevm>
      return 0;
801073fb:	83 c4 10             	add    $0x10,%esp
}
801073fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107401:	89 f0                	mov    %esi,%eax
80107403:	5b                   	pop    %ebx
80107404:	5e                   	pop    %esi
80107405:	5d                   	pop    %ebp
80107406:	c3                   	ret
80107407:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010740e:	00 
8010740f:	90                   	nop

80107410 <kvmalloc>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107416:	e8 75 ff ff ff       	call   80107390 <setupkvm>
8010741b:	a3 c4 6e 11 80       	mov    %eax,0x80116ec4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107420:	05 00 00 00 80       	add    $0x80000000,%eax
80107425:	0f 22 d8             	mov    %eax,%cr3
}
80107428:	c9                   	leave
80107429:	c3                   	ret
8010742a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107430 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	83 ec 08             	sub    $0x8,%esp
80107436:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107439:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010743c:	89 c1                	mov    %eax,%ecx
8010743e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107441:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107444:	f6 c2 01             	test   $0x1,%dl
80107447:	75 17                	jne    80107460 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107449:	83 ec 0c             	sub    $0xc,%esp
8010744c:	68 c1 7b 10 80       	push   $0x80107bc1
80107451:	e8 2a 8f ff ff       	call   80100380 <panic>
80107456:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010745d:	00 
8010745e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107460:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107463:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107469:	25 fc 0f 00 00       	and    $0xffc,%eax
8010746e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107475:	85 c0                	test   %eax,%eax
80107477:	74 d0                	je     80107449 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107479:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010747c:	c9                   	leave
8010747d:	c3                   	ret
8010747e:	66 90                	xchg   %ax,%ax

80107480 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107489:	e8 02 ff ff ff       	call   80107390 <setupkvm>
8010748e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107491:	85 c0                	test   %eax,%eax
80107493:	0f 84 bd 00 00 00    	je     80107556 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107499:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010749c:	85 c9                	test   %ecx,%ecx
8010749e:	0f 84 b2 00 00 00    	je     80107556 <copyuvm+0xd6>
801074a4:	31 f6                	xor    %esi,%esi
801074a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074ad:	00 
801074ae:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801074b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801074b3:	89 f0                	mov    %esi,%eax
801074b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801074b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801074bb:	a8 01                	test   $0x1,%al
801074bd:	75 11                	jne    801074d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801074bf:	83 ec 0c             	sub    $0xc,%esp
801074c2:	68 cb 7b 10 80       	push   $0x80107bcb
801074c7:	e8 b4 8e ff ff       	call   80100380 <panic>
801074cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801074d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801074d7:	c1 ea 0a             	shr    $0xa,%edx
801074da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801074e7:	85 c0                	test   %eax,%eax
801074e9:	74 d4                	je     801074bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801074eb:	8b 00                	mov    (%eax),%eax
801074ed:	a8 01                	test   $0x1,%al
801074ef:	0f 84 9f 00 00 00    	je     80107594 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801074f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801074f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801074fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801074ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107505:	e8 a6 b2 ff ff       	call   801027b0 <kalloc>
8010750a:	89 c3                	mov    %eax,%ebx
8010750c:	85 c0                	test   %eax,%eax
8010750e:	74 64                	je     80107574 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107510:	83 ec 04             	sub    $0x4,%esp
80107513:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107519:	68 00 10 00 00       	push   $0x1000
8010751e:	57                   	push   %edi
8010751f:	50                   	push   %eax
80107520:	e8 2b d4 ff ff       	call   80104950 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107525:	58                   	pop    %eax
80107526:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010752c:	5a                   	pop    %edx
8010752d:	ff 75 e4             	push   -0x1c(%ebp)
80107530:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107535:	89 f2                	mov    %esi,%edx
80107537:	50                   	push   %eax
80107538:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010753b:	e8 60 f8 ff ff       	call   80106da0 <mappages>
80107540:	83 c4 10             	add    $0x10,%esp
80107543:	85 c0                	test   %eax,%eax
80107545:	78 21                	js     80107568 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107547:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010754d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107550:	0f 87 5a ff ff ff    	ja     801074b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107556:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107559:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010755c:	5b                   	pop    %ebx
8010755d:	5e                   	pop    %esi
8010755e:	5f                   	pop    %edi
8010755f:	5d                   	pop    %ebp
80107560:	c3                   	ret
80107561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107568:	83 ec 0c             	sub    $0xc,%esp
8010756b:	53                   	push   %ebx
8010756c:	e8 7f b0 ff ff       	call   801025f0 <kfree>
      goto bad;
80107571:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107574:	83 ec 0c             	sub    $0xc,%esp
80107577:	ff 75 e0             	push   -0x20(%ebp)
8010757a:	e8 91 fd ff ff       	call   80107310 <freevm>
  return 0;
8010757f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107586:	83 c4 10             	add    $0x10,%esp
}
80107589:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010758c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758f:	5b                   	pop    %ebx
80107590:	5e                   	pop    %esi
80107591:	5f                   	pop    %edi
80107592:	5d                   	pop    %ebp
80107593:	c3                   	ret
      panic("copyuvm: page not present");
80107594:	83 ec 0c             	sub    $0xc,%esp
80107597:	68 e5 7b 10 80       	push   $0x80107be5
8010759c:	e8 df 8d ff ff       	call   80100380 <panic>
801075a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075a8:	00 
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075b9:	89 c1                	mov    %eax,%ecx
801075bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075c1:	f6 c2 01             	test   $0x1,%dl
801075c4:	0f 84 00 01 00 00    	je     801076ca <uva2ka.cold>
  return &pgtab[PTX(va)];
801075ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801075d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801075d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801075d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801075e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801075e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075ea:	05 00 00 00 80       	add    $0x80000000,%eax
801075ef:	83 fa 05             	cmp    $0x5,%edx
801075f2:	ba 00 00 00 00       	mov    $0x0,%edx
801075f7:	0f 45 c2             	cmovne %edx,%eax
}
801075fa:	c3                   	ret
801075fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107600 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
80107606:	83 ec 0c             	sub    $0xc,%esp
80107609:	8b 75 14             	mov    0x14(%ebp),%esi
8010760c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010760f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107612:	85 f6                	test   %esi,%esi
80107614:	75 51                	jne    80107667 <copyout+0x67>
80107616:	e9 a5 00 00 00       	jmp    801076c0 <copyout+0xc0>
8010761b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107620:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107626:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010762c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107632:	74 75                	je     801076a9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107634:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107636:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107639:	29 c3                	sub    %eax,%ebx
8010763b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107641:	39 f3                	cmp    %esi,%ebx
80107643:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107646:	29 f8                	sub    %edi,%eax
80107648:	83 ec 04             	sub    $0x4,%esp
8010764b:	01 c1                	add    %eax,%ecx
8010764d:	53                   	push   %ebx
8010764e:	52                   	push   %edx
8010764f:	51                   	push   %ecx
80107650:	e8 fb d2 ff ff       	call   80104950 <memmove>
    len -= n;
    buf += n;
80107655:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107658:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010765e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107661:	01 da                	add    %ebx,%edx
  while(len > 0){
80107663:	29 de                	sub    %ebx,%esi
80107665:	74 59                	je     801076c0 <copyout+0xc0>
  if(*pde & PTE_P){
80107667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010766a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010766c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010766e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107671:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107677:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010767a:	f6 c1 01             	test   $0x1,%cl
8010767d:	0f 84 4e 00 00 00    	je     801076d1 <copyout.cold>
  return &pgtab[PTX(va)];
80107683:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107685:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010768b:	c1 eb 0c             	shr    $0xc,%ebx
8010768e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107694:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010769b:	89 d9                	mov    %ebx,%ecx
8010769d:	83 e1 05             	and    $0x5,%ecx
801076a0:	83 f9 05             	cmp    $0x5,%ecx
801076a3:	0f 84 77 ff ff ff    	je     80107620 <copyout+0x20>
  }
  return 0;
}
801076a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076b1:	5b                   	pop    %ebx
801076b2:	5e                   	pop    %esi
801076b3:	5f                   	pop    %edi
801076b4:	5d                   	pop    %ebp
801076b5:	c3                   	ret
801076b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076bd:	00 
801076be:	66 90                	xchg   %ax,%ax
801076c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076c3:	31 c0                	xor    %eax,%eax
}
801076c5:	5b                   	pop    %ebx
801076c6:	5e                   	pop    %esi
801076c7:	5f                   	pop    %edi
801076c8:	5d                   	pop    %ebp
801076c9:	c3                   	ret

801076ca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801076ca:	a1 00 00 00 00       	mov    0x0,%eax
801076cf:	0f 0b                	ud2

801076d1 <copyout.cold>:
801076d1:	a1 00 00 00 00       	mov    0x0,%eax
801076d6:	0f 0b                	ud2
