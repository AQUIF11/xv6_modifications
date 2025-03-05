
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
80100028:	bc 90 6f 11 80       	mov    $0x80116f90,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 30 10 80       	mov    $0x80103070,%eax
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
8010004c:	68 60 76 10 80       	push   $0x80107660
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 15 44 00 00       	call   80104470 <initlock>
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
80100092:	68 67 76 10 80       	push   $0x80107667
80100097:	50                   	push   %eax
80100098:	e8 a3 42 00 00       	call   80104340 <initsleeplock>
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
801000e4:	e8 57 45 00 00       	call   80104640 <acquire>
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
80100162:	e8 79 44 00 00       	call   801045e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 42 00 00       	call   80104380 <acquiresleep>
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
8010018c:	e8 5f 21 00 00       	call   801022f0 <iderw>
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
801001a1:	68 6e 76 10 80       	push   $0x8010766e
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
801001be:	e8 5d 42 00 00       	call   80104420 <holdingsleep>
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
801001d4:	e9 17 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 76 10 80       	push   $0x8010767f
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
801001ff:	e8 1c 42 00 00       	call   80104420 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 41 00 00       	call   801043e0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 20 44 00 00       	call   80104640 <acquire>
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
8010026c:	e9 6f 43 00 00       	jmp    801045e0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 76 10 80       	push   $0x80107686
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
80100294:	e8 d7 15 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 9b 43 00 00       	call   80104640 <acquire>
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
801002cd:	e8 0e 3e 00 00       	call   801040e0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 99 36 00 00       	call   80103980 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 e5 42 00 00       	call   801045e0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 14 00 00       	call   80101790 <ilock>
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
8010034c:	e8 8f 42 00 00       	call   801045e0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 14 00 00       	call   80101790 <ilock>
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
80100399:	e8 62 25 00 00       	call   80102900 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 76 10 80       	push   $0x8010768d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 86 7b 10 80 	movl   $0x80107b86,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 40 00 00       	call   80104490 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 76 10 80       	push   $0x801076a1
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
8010041a:	e8 61 5d 00 00       	call   80106180 <uartputc>
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
80100505:	e8 76 5c 00 00       	call   80106180 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 6a 5c 00 00       	call   80106180 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 5e 5c 00 00       	call   80106180 <uartputc>
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
80100551:	e8 4a 42 00 00       	call   801047a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 95 41 00 00       	call   80104700 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 76 10 80       	push   $0x801076a5
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
8010059f:	e8 cc 12 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 90 40 00 00       	call   80104640 <acquire>
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
801005e4:	e8 f7 3f 00 00       	call   801045e0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 9e 11 00 00       	call   80101790 <ilock>

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
80100636:	0f b6 92 d8 7b 10 80 	movzbl -0x7fef8428(%edx),%edx
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
801007e8:	e8 53 3e 00 00       	call   80104640 <acquire>
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
80100838:	bf b8 76 10 80       	mov    $0x801076b8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 80 3d 00 00       	call   801045e0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 76 10 80       	push   $0x801076bf
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
80100893:	e8 a8 3d 00 00       	call   80104640 <acquire>
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
801009d0:	e8 0b 3c 00 00       	call   801045e0 <release>
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
80100a0e:	e9 6d 38 00 00       	jmp    80104280 <procdump>
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
80100a44:	e8 57 37 00 00       	call   801041a0 <wakeup>
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
80100a66:	68 c8 76 10 80       	push   $0x801076c8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 fb 39 00 00       	call   80104470 <initlock>

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
80100a99:	e8 f2 19 00 00       	call   80102490 <ioapicenable>
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
80100abc:	e8 bf 2e 00 00       	call   80103980 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 15 00 00       	call   801020b0 <namei>
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
80100ae8:	e8 a3 0c 00 00       	call   80101790 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 a2 0f 00 00       	call   80101aa0 <readi>
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
80100b0a:	e8 11 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100b0f:	e8 cc 22 00 00       	call   80102de0 <end_op>
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
80100b34:	e8 d7 67 00 00       	call   80107310 <setupkvm>
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
80100ba3:	e8 88 65 00 00       	call   80107130 <allocuvm>
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
80100bd9:	e8 62 64 00 00       	call   80107040 <loaduvm>
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
80100c01:	e8 9a 0e 00 00       	call   80101aa0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 70 66 00 00       	call   80107290 <freevm>
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
80100c4c:	e8 cf 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c51:	e8 8a 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 c9 64 00 00       	call   80107130 <allocuvm>
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
80100c83:	e8 28 67 00 00       	call   801073b0 <clearpteu>
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
80100cd3:	e8 28 3c 00 00       	call   80104900 <strlen>
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
80100ce7:	e8 14 3c 00 00       	call   80104900 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 83 68 00 00       	call   80107580 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 7a 65 00 00       	call   80107290 <freevm>
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
80100d63:	e8 18 68 00 00       	call   80107580 <copyout>
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
80100da1:	e8 1a 3b 00 00       	call   801048c0 <safestrcpy>
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
80100dcd:	e8 de 60 00 00       	call   80106eb0 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 b6 64 00 00       	call   80107290 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 f7 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 d0 76 10 80       	push   $0x801076d0
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
80100e16:	68 dc 76 10 80       	push   $0x801076dc
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 4b 36 00 00       	call   80104470 <initlock>
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
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 fa 37 00 00       	call   80104640 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
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
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 6a 37 00 00       	call   801045e0 <release>
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
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 51 37 00 00       	call   801045e0 <release>
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
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 8c 37 00 00       	call   80104640 <acquire>
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
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 0f 37 00 00       	call   801045e0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave
80100ed7:	c3                   	ret
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 e3 76 10 80       	push   $0x801076e3
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
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 3a 37 00 00       	call   80104640 <acquire>
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
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 9f 36 00 00       	call   801045e0 <release>

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
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 6d 36 00 00       	jmp    801045e0 <release>
80100f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f78:	e8 f3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 38 09 00 00       	call   801018c0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 49 1e 00 00       	jmp    80102de0 <end_op>
80100f97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f9e:	00 
80100f9f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 92 25 00 00       	call   80103540 <pipeclose>
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
80100fbc:	68 eb 76 10 80       	push   $0x801076eb
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
80100fe5:	e8 a6 07 00 00       	call   80101790 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 79 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 70 08 00 00       	call   80101870 <iunlock>
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
8010104a:	e8 41 07 00 00       	call   80101790 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 44 0a 00 00       	call   80101aa0 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 fd 07 00 00       	call   80101870 <iunlock>
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
8010108d:	e9 4e 26 00 00       	jmp    801036e0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 f5 76 10 80       	push   $0x801076f5
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
80101104:	e8 67 07 00 00       	call   80101870 <iunlock>
      end_op();
80101109:	e8 d2 1c 00 00       	call   80102de0 <end_op>

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
8010112e:	e8 3d 1c 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 52 06 00 00       	call   80101790 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 50 0a 00 00       	call   80101ba0 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 0b 07 00 00       	call   80101870 <iunlock>
      end_op();
80101165:	e8 76 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 fe 76 10 80       	push   $0x801076fe
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
801011a9:	e9 32 24 00 00       	jmp    801035e0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 04 77 10 80       	push   $0x80107704
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
801011c8:	03 05 94 26 11 80    	add    0x80112694,%eax
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
8010120d:	e8 3e 1d 00 00       	call   80102f50 <log_write>
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
80101227:	68 0e 77 10 80       	push   $0x8010770e
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
80101249:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
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
8010126c:	03 05 94 26 11 80    	add    0x80112694,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 7c 26 11 80       	mov    0x8011267c,%eax
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
801012d9:	39 05 7c 26 11 80    	cmp    %eax,0x8011267c
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 21 77 10 80       	push   $0x80107721
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
801012fd:	e8 4e 1c 00 00       	call   80102f50 <log_write>
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
80101325:	e8 d6 33 00 00       	call   80104700 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 1e 1c 00 00       	call   80102f50 <log_write>
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
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 d1 32 00 00       	call   80104640 <acquire>
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
80101384:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010138a:	81 fb 7c 26 11 80    	cmp    $0x8011267c,%ebx
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
801013a3:	81 c3 94 00 00 00    	add    $0x94,%ebx
801013a9:	81 fb 7c 26 11 80    	cmp    $0x8011267c,%ebx
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
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 04 32 00 00       	call   801045e0 <release>

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
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 d6 31 00 00       	call   801045e0 <release>
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
80101417:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010141d:	81 fb 7c 26 11 80    	cmp    $0x8011267c,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 37 77 10 80       	push   $0x80107737
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
801014c5:	e8 86 1a 00 00       	call   80102f50 <log_write>
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
80101515:	68 47 77 10 80       	push   $0x80107747
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
80101541:	e8 5a 32 00 00       	call   801047a0 <memmove>
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
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 5a 77 10 80       	push   $0x8010775a
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 f5 2e 00 00       	call   80104470 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 61 77 10 80       	push   $0x80107761
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 94 00 00 00    	add    $0x94,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 ac 2d 00 00       	call   80104340 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb 88 26 11 80    	cmp    $0x80112688,%ebx
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
801015b7:	68 7c 26 11 80       	push   $0x8011267c
801015bc:	e8 df 31 00 00       	call   801047a0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 94 26 11 80    	push   0x80112694
801015cf:	ff 35 90 26 11 80    	push   0x80112690
801015d5:	ff 35 8c 26 11 80    	push   0x8011268c
801015db:	ff 35 88 26 11 80    	push   0x80112688
801015e1:	ff 35 84 26 11 80    	push   0x80112684
801015e7:	ff 35 80 26 11 80    	push   0x80112680
801015ed:	ff 35 7c 26 11 80    	push   0x8011267c
801015f3:	68 ec 7b 10 80       	push   $0x80107bec
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
8010161c:	83 3d 84 26 11 80 01 	cmpl   $0x1,0x80112684
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 94 00 00 00    	jbe    801016c3 <ialloc+0xb3>
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
8010164f:	3b 3d 84 26 11 80    	cmp    0x80112684,%edi
80101655:	73 6c                	jae    801016c3 <ialloc+0xb3>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 02             	shr    $0x2,%eax
8010165f:	03 05 90 26 11 80    	add    0x80112690,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 03             	and    $0x3,%eax
80101676:	c1 e0 07             	shl    $0x7,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	68 80 00 00 00       	push   $0x80
8010168e:	6a 00                	push   $0x0
80101690:	51                   	push   %ecx
80101691:	e8 6a 30 00 00       	call   80104700 <memset>
      dip->type = type;
80101696:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010169a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169d:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016a0:	89 1c 24             	mov    %ebx,(%esp)
801016a3:	e8 a8 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016a8:	89 1c 24             	mov    %ebx,(%esp)
801016ab:	e8 40 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016b0:	83 c4 10             	add    $0x10,%esp
}
801016b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b6:	89 fa                	mov    %edi,%edx
}
801016b8:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b9:	89 f0                	mov    %esi,%eax
}
801016bb:	5e                   	pop    %esi
801016bc:	5f                   	pop    %edi
801016bd:	5d                   	pop    %ebp
      return iget(dev, inum);
801016be:	e9 8d fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c3:	83 ec 0c             	sub    $0xc,%esp
801016c6:	68 67 77 10 80       	push   $0x80107767
801016cb:	e8 b0 ec ff ff       	call   80100380 <panic>

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	57                   	push   %edi
801016d4:	56                   	push   %esi
801016d5:	53                   	push   %ebx
801016d6:	83 ec 14             	sub    $0x14,%esp
801016d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016dc:	8b 43 04             	mov    0x4(%ebx),%eax
801016df:	c1 e8 02             	shr    $0x2,%eax
801016e2:	03 05 90 26 11 80    	add    0x80112690,%eax
801016e8:	50                   	push   %eax
801016e9:	ff 33                	push   (%ebx)
801016eb:	e8 e0 e9 ff ff       	call   801000d0 <bread>
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f0:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f3:	89 c7                	mov    %eax,%edi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f5:	8b 43 04             	mov    0x4(%ebx),%eax
801016f8:	83 e0 03             	and    $0x3,%eax
801016fb:	c1 e0 07             	shl    $0x7,%eax
801016fe:	8d 74 07 5c          	lea    0x5c(%edi,%eax,1),%esi
  dip->type = ip->type;
80101702:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
80101706:	66 89 06             	mov    %ax,(%esi)
  dip->major = ip->major;
80101709:	0f b7 43 52          	movzwl 0x52(%ebx),%eax
8010170d:	66 89 46 02          	mov    %ax,0x2(%esi)
  dip->minor = ip->minor;
80101711:	0f b7 43 54          	movzwl 0x54(%ebx),%eax
80101715:	66 89 46 04          	mov    %ax,0x4(%esi)
  dip->nlink = ip->nlink;
80101719:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
8010171d:	66 89 46 06          	mov    %ax,0x6(%esi)
  dip->size = ip->size;
80101721:	8b 43 58             	mov    0x58(%ebx),%eax
80101724:	89 46 08             	mov    %eax,0x8(%esi)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101727:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010172a:	6a 34                	push   $0x34
8010172c:	50                   	push   %eax
8010172d:	8d 46 0c             	lea    0xc(%esi),%eax
80101730:	50                   	push   %eax
80101731:	e8 6a 30 00 00       	call   801047a0 <memmove>
  dip->mode = ip->mode;  // Save file permissions
80101736:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
8010173c:	89 46 40             	mov    %eax,0x40(%esi)
  log_write(bp);
8010173f:	89 3c 24             	mov    %edi,(%esp)
80101742:	e8 09 18 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101747:	89 7d 08             	mov    %edi,0x8(%ebp)
8010174a:	83 c4 10             	add    $0x10,%esp
}
8010174d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101750:	5b                   	pop    %ebx
80101751:	5e                   	pop    %esi
80101752:	5f                   	pop    %edi
80101753:	5d                   	pop    %ebp
  brelse(bp);
80101754:	e9 97 ea ff ff       	jmp    801001f0 <brelse>
80101759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101760 <idup>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	83 ec 10             	sub    $0x10,%esp
80101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010176a:	68 60 09 11 80       	push   $0x80110960
8010176f:	e8 cc 2e 00 00       	call   80104640 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010177f:	e8 5c 2e 00 00       	call   801045e0 <release>
}
80101784:	89 d8                	mov    %ebx,%eax
80101786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101789:	c9                   	leave
8010178a:	c3                   	ret
8010178b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101790 <ilock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 0c             	sub    $0xc,%esp
80101799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010179c:	85 db                	test   %ebx,%ebx
8010179e:	0f 84 bc 00 00 00    	je     80101860 <ilock+0xd0>
801017a4:	8b 53 08             	mov    0x8(%ebx),%edx
801017a7:	85 d2                	test   %edx,%edx
801017a9:	0f 8e b1 00 00 00    	jle    80101860 <ilock+0xd0>
  acquiresleep(&ip->lock);
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	8d 43 0c             	lea    0xc(%ebx),%eax
801017b5:	50                   	push   %eax
801017b6:	e8 c5 2b 00 00       	call   80104380 <acquiresleep>
  if(ip->valid == 0){
801017bb:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017be:	83 c4 10             	add    $0x10,%esp
801017c1:	85 c0                	test   %eax,%eax
801017c3:	74 0b                	je     801017d0 <ilock+0x40>
}
801017c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017c8:	5b                   	pop    %ebx
801017c9:	5e                   	pop    %esi
801017ca:	5f                   	pop    %edi
801017cb:	5d                   	pop    %ebp
801017cc:	c3                   	ret
801017cd:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d0:	8b 43 04             	mov    0x4(%ebx),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	c1 e8 02             	shr    $0x2,%eax
801017d9:	03 05 90 26 11 80    	add    0x80112690,%eax
801017df:	50                   	push   %eax
801017e0:	ff 33                	push   (%ebx)
801017e2:	e8 e9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 04             	mov    0x4(%ebx),%eax
801017ef:	83 e0 03             	and    $0x3,%eax
801017f2:	c1 e0 07             	shl    $0x7,%eax
801017f5:	8d 74 07 5c          	lea    0x5c(%edi,%eax,1),%esi
    ip->type = dip->type;
801017f9:	0f b7 06             	movzwl (%esi),%eax
801017fc:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
80101800:	0f b7 46 02          	movzwl 0x2(%esi),%eax
80101804:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101808:	0f b7 46 04          	movzwl 0x4(%esi),%eax
8010180c:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
80101810:	0f b7 46 06          	movzwl 0x6(%esi),%eax
80101814:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101818:	8b 46 08             	mov    0x8(%esi),%eax
8010181b:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010181e:	8d 46 0c             	lea    0xc(%esi),%eax
80101821:	6a 34                	push   $0x34
80101823:	50                   	push   %eax
80101824:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101827:	50                   	push   %eax
80101828:	e8 73 2f 00 00       	call   801047a0 <memmove>
    ip->mode = dip->mode;  // Load file permissions
8010182d:	8b 46 40             	mov    0x40(%esi),%eax
80101830:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
    brelse(bp);
80101836:	89 3c 24             	mov    %edi,(%esp)
80101839:	e8 b2 e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
8010183e:	83 c4 10             	add    $0x10,%esp
80101841:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101846:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010184d:	0f 85 72 ff ff ff    	jne    801017c5 <ilock+0x35>
      panic("ilock: no type");
80101853:	83 ec 0c             	sub    $0xc,%esp
80101856:	68 7f 77 10 80       	push   $0x8010777f
8010185b:	e8 20 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	68 79 77 10 80       	push   $0x80107779
80101868:	e8 13 eb ff ff       	call   80100380 <panic>
8010186d:	8d 76 00             	lea    0x0(%esi),%esi

80101870 <iunlock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	74 28                	je     801018a4 <iunlock+0x34>
8010187c:	83 ec 0c             	sub    $0xc,%esp
8010187f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101882:	56                   	push   %esi
80101883:	e8 98 2b 00 00       	call   80104420 <holdingsleep>
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 c0                	test   %eax,%eax
8010188d:	74 15                	je     801018a4 <iunlock+0x34>
8010188f:	8b 43 08             	mov    0x8(%ebx),%eax
80101892:	85 c0                	test   %eax,%eax
80101894:	7e 0e                	jle    801018a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101896:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101899:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010189f:	e9 3c 2b 00 00       	jmp    801043e0 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 8e 77 10 80       	push   $0x8010778e
801018ac:	e8 cf ea ff ff       	call   80100380 <panic>
801018b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018b8:	00 
801018b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018c0 <iput>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 28             	sub    $0x28,%esp
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018cf:	57                   	push   %edi
801018d0:	e8 ab 2a 00 00       	call   80104380 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 d2                	test   %edx,%edx
801018dd:	74 07                	je     801018e6 <iput+0x26>
801018df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018e4:	74 32                	je     80101918 <iput+0x58>
  releasesleep(&ip->lock);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	57                   	push   %edi
801018ea:	e8 f1 2a 00 00       	call   801043e0 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018f6:	e8 45 2d 00 00       	call   80104640 <acquire>
  ip->ref--;
801018fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5f                   	pop    %edi
8010190f:	5d                   	pop    %ebp
  release(&icache.lock);
80101910:	e9 cb 2c 00 00       	jmp    801045e0 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 60 09 11 80       	push   $0x80110960
80101920:	e8 1b 2d 00 00       	call   80104640 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010192f:	e8 ac 2c 00 00       	call   801045e0 <release>
    if(r == 1){
80101934:	83 c4 10             	add    $0x10,%esp
80101937:	83 fe 01             	cmp    $0x1,%esi
8010193a:	75 aa                	jne    801018e6 <iput+0x26>
8010193c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101942:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101945:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101948:	89 cf                	mov    %ecx,%edi
8010194a:	eb 0b                	jmp    80101957 <iput+0x97>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101950:	83 c6 04             	add    $0x4,%esi
80101953:	39 fe                	cmp    %edi,%esi
80101955:	74 19                	je     80101970 <iput+0xb0>
    if(ip->addrs[i]){
80101957:	8b 16                	mov    (%esi),%edx
80101959:	85 d2                	test   %edx,%edx
8010195b:	74 f3                	je     80101950 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010195d:	8b 03                	mov    (%ebx),%eax
8010195f:	e8 5c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101964:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010196a:	eb e4                	jmp    80101950 <iput+0x90>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101970:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101976:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101979:	85 c0                	test   %eax,%eax
8010197b:	75 2d                	jne    801019aa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010197d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101980:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101987:	53                   	push   %ebx
80101988:	e8 43 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010198d:	31 c0                	xor    %eax,%eax
8010198f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101993:	89 1c 24             	mov    %ebx,(%esp)
80101996:	e8 35 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010199b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019a2:	83 c4 10             	add    $0x10,%esp
801019a5:	e9 3c ff ff ff       	jmp    801018e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019aa:	83 ec 08             	sub    $0x8,%esp
801019ad:	50                   	push   %eax
801019ae:	ff 33                	push   (%ebx)
801019b0:	e8 1b e7 ff ff       	call   801000d0 <bread>
801019b5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c7:	89 cf                	mov    %ecx,%edi
801019c9:	eb 0c                	jmp    801019d7 <iput+0x117>
801019cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 0f                	je     801019e6 <iput+0x126>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 dc f7 ff ff       	call   801011c0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x110>
    brelse(bp);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	ff 75 e4             	push   -0x1c(%ebp)
801019ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ef:	e8 fc e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019f4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019fa:	8b 03                	mov    (%ebx),%eax
801019fc:	e8 bf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a01:	83 c4 10             	add    $0x10,%esp
80101a04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a0b:	00 00 00 
80101a0e:	e9 6a ff ff ff       	jmp    8010197d <iput+0xbd>
80101a13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a1a:	00 
80101a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101a20 <iunlockput>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 34                	je     80101a60 <iunlockput+0x40>
80101a2c:	83 ec 0c             	sub    $0xc,%esp
80101a2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a32:	56                   	push   %esi
80101a33:	e8 e8 29 00 00       	call   80104420 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 91 29 00 00       	call   801043e0 <releasesleep>
  iput(ip);
80101a4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a52:	83 c4 10             	add    $0x10,%esp
}
80101a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5d                   	pop    %ebp
  iput(ip);
80101a5b:	e9 60 fe ff ff       	jmp    801018c0 <iput>
    panic("iunlock");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 8e 77 10 80       	push   $0x8010778e
80101a68:	e8 13 e9 ff ff       	call   80100380 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a79:	8b 0a                	mov    (%edx),%ecx
80101a7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a93:	8b 52 58             	mov    0x58(%edx),%edx
80101a96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret
80101a9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 a7 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	8b 40 58             	mov    0x58(%eax),%eax
80101acf:	39 c6                	cmp    %eax,%esi
80101ad1:	0f 87 ba 00 00 00    	ja     80101b91 <readi+0xf1>
80101ad7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ada:	31 c9                	xor    %ecx,%ecx
80101adc:	89 da                	mov    %ebx,%edx
80101ade:	01 f2                	add    %esi,%edx
80101ae0:	0f 92 c1             	setb   %cl
80101ae3:	89 cf                	mov    %ecx,%edi
80101ae5:	0f 82 a6 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aeb:	89 c1                	mov    %eax,%ecx
80101aed:	29 f1                	sub    %esi,%ecx
80101aef:	39 d0                	cmp    %edx,%eax
80101af1:	0f 43 cb             	cmovae %ebx,%ecx
80101af4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	85 c9                	test   %ecx,%ecx
80101af9:	74 67                	je     80101b62 <readi+0xc2>
80101afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 41 f9 ff ff       	call   80101450 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	push   (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b24:	89 f0                	mov    %esi,%eax
80101b26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b36:	39 d9                	cmp    %ebx,%ecx
80101b38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3b:	83 c4 0c             	add    $0xc,%esp
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	push   -0x20(%ebp)
80101b47:	e8 54 2c 00 00       	call   801047a0 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b9f:	00 

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 b7 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	0f 87 e7 00 00 00    	ja     80101cbc <writei+0x11c>
80101bd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bd8:	31 d2                	xor    %edx,%edx
80101bda:	89 f8                	mov    %edi,%eax
80101bdc:	01 f0                	add    %esi,%eax
80101bde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101be6:	0f 87 d0 00 00 00    	ja     80101cbc <writei+0x11c>
80101bec:	85 d2                	test   %edx,%edx
80101bee:	0f 85 c8 00 00 00    	jne    80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bfb:	85 ff                	test   %edi,%edi
80101bfd:	74 72                	je     80101c71 <writei+0xd1>
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 41 f8 ff ff       	call   80101450 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	push   (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c30:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c34:	39 d9                	cmp    %ebx,%ecx
80101c36:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c39:	83 c4 0c             	add    $0xc,%esp
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	push   -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 58 2b 00 00       	call   801047a0 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 00 13 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 19 fa ff ff       	call   801016d0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cca:	00 
80101ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 2d 2b 00 00       	call   80104810 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 7e fd ff ff       	call   80101aa0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 ce 2a 00 00       	call   80104810 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 d9 f5 ff ff       	call   80101350 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 a8 77 10 80       	push   $0x801077a8
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 96 77 10 80       	push   $0x80107796
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 64 01 00 00    	je     80101f1e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 c1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 09 11 80       	push   $0x80110960
80101dca:	e8 71 28 00 00       	call   80104640 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dda:	e8 01 28 00 00       	call   801045e0 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
    path++;
80101e32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 64 29 00 00       	call   801047a0 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 37 f9 ff ff       	call   80101790 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 cd 00 00 00    	jne    80101f34 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 22 01 00 00    	je     80101f99 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	89 c7                	mov    %eax,%edi
80101e8d:	85 c0                	test   %eax,%eax
80101e8f:	0f 84 e1 00 00 00    	je     80101f76 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e9b:	52                   	push   %edx
80101e9c:	e8 7f 25 00 00       	call   80104420 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 30 01 00 00    	je     80101fdc <namex+0x23c>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e 25 01 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101eb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	52                   	push   %edx
80101ebe:	e8 1d 25 00 00       	call   801043e0 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
80101ec6:	89 fe                	mov    %edi,%esi
80101ec8:	e8 f3 f9 ff ff       	call   801018c0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101edb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 b0 28 00 00       	call   801047a0 <memmove>
    name[len] = 0;
80101ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 02 00             	movb   $0x0,(%edx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 be 00 00 00    	jne    80101fc9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f1e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f23:	b8 01 00 00 00       	mov    $0x1,%eax
80101f28:	e8 23 f4 ff ff       	call   80101350 <iget>
80101f2d:	89 c6                	mov    %eax,%esi
80101f2f:	e9 b7 fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f3a:	53                   	push   %ebx
80101f3b:	e8 e0 24 00 00       	call   80104420 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 81 24 00 00       	call   801043e0 <releasesleep>
  iput(ip);
80101f5f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f62:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f64:	e8 57 f9 ff ff       	call   801018c0 <iput>
      return 0;
80101f69:	83 c4 10             	add    $0x10,%esp
}
80101f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6f:	89 f0                	mov    %esi,%eax
80101f71:	5b                   	pop    %ebx
80101f72:	5e                   	pop    %esi
80101f73:	5f                   	pop    %edi
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f76:	83 ec 0c             	sub    $0xc,%esp
80101f79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f7c:	52                   	push   %edx
80101f7d:	e8 9e 24 00 00       	call   80104420 <holdingsleep>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	85 c0                	test   %eax,%eax
80101f87:	74 53                	je     80101fdc <namex+0x23c>
80101f89:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f8c:	85 c9                	test   %ecx,%ecx
80101f8e:	7e 4c                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f93:	83 ec 0c             	sub    $0xc,%esp
80101f96:	52                   	push   %edx
80101f97:	eb c1                	jmp    80101f5a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9f:	53                   	push   %ebx
80101fa0:	e8 7b 24 00 00       	call   80104420 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 24 24 00 00       	call   801043e0 <releasesleep>
}
80101fbc:	83 c4 10             	add    $0x10,%esp
}
80101fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	5b                   	pop    %ebx
80101fc5:	5e                   	pop    %esi
80101fc6:	5f                   	pop    %edi
80101fc7:	5d                   	pop    %ebp
80101fc8:	c3                   	ret
    iput(ip);
80101fc9:	83 ec 0c             	sub    $0xc,%esp
80101fcc:	56                   	push   %esi
    return 0;
80101fcd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fcf:	e8 ec f8 ff ff       	call   801018c0 <iput>
    return 0;
80101fd4:	83 c4 10             	add    $0x10,%esp
80101fd7:	e9 2f ff ff ff       	jmp    80101f0b <namex+0x16b>
    panic("iunlock");
80101fdc:	83 ec 0c             	sub    $0xc,%esp
80101fdf:	68 8e 77 10 80       	push   $0x8010778e
80101fe4:	e8 97 e3 ff ff       	call   80100380 <panic>
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 e9 fc ff ff       	call   80101cf0 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 6e fa ff ff       	call   80101aa0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 0e 28 00 00       	call   80104860 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102052:	6a 10                	push   $0x10
  de.inum = inum;
80102054:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
  de.inum = inum;
8010205a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010205e:	e8 3d fb ff ff       	call   80101ba0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 42 f8 ff ff       	call   801018c0 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 b7 77 10 80       	push   $0x801077b7
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 2a 7a 10 80       	push   $0x80107a2a
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020a9:	00 
801020aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 dd fc ff ff       	call   80101da0 <namex>
}
801020c3:	c9                   	leave
801020c4:	c3                   	ret
801020c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020cc:	00 
801020cd:	8d 76 00             	lea    0x0(%esi),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 bc fc ff ff       	jmp    80101da0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010211e:	00 
8010211f:	90                   	nop
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 cd 77 10 80       	push   $0x801077cd
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 c4 77 10 80       	push   $0x801077c4
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021c9:	00 
801021ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 df 77 10 80       	push   $0x801077df
801021db:	68 c0 26 11 80       	push   $0x801126c0
801021e0:	e8 8b 22 00 00       	call   80104470 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 44 28 11 80       	mov    0x80112844,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 a0 26 11 80 01 	movl   $0x1,0x801126a0
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave
80102240:	c3                   	ret
80102241:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102248:	00 
80102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 c0 26 11 80       	push   $0x801126c0
8010225e:	e8 dd 23 00 00       	call   80104640 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d a4 26 11 80    	mov    0x801126a4,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 63                	je     801022d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 a4 26 11 80       	mov    %eax,0x801126a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 33                	mov    (%ebx),%esi
8010227a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102280:	75 2f                	jne    801022b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010228e:	00 
8010228f:	90                   	nop
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 12                	jne    801022b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b7:	83 ce 02             	or     $0x2,%esi
801022ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022bc:	53                   	push   %ebx
801022bd:	e8 de 1e 00 00       	call   801041a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c2:	a1 a4 26 11 80       	mov    0x801126a4,%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	74 05                	je     801022d3 <ideintr+0x83>
    idestart(idequeue);
801022ce:	e8 1d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	68 c0 26 11 80       	push   $0x801126c0
801022db:	e8 00 23 00 00       	call   801045e0 <release>

  release(&idelock);
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret
801022e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022ef:	00 

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 1d 21 00 00       	call   80104420 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c3 00 00 00    	je     801023d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 a8 00 00 00    	je     801023c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 87 00 00 00    	je     801023b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 c0 26 11 80       	push   $0x801126c0
80102338:	e8 03 23 00 00       	call   80104640 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	a1 a4 26 11 80       	mov    0x801126a4,%eax
  b->qnext = 0;
80102342:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 c0                	test   %eax,%eax
8010234e:	74 60                	je     801023b0 <iderw+0xc0>
80102350:	89 c2                	mov    %eax,%edx
80102352:	8b 40 58             	mov    0x58(%eax),%eax
80102355:	85 c0                	test   %eax,%eax
80102357:	75 f7                	jne    80102350 <iderw+0x60>
80102359:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010235c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010235e:	39 1d a4 26 11 80    	cmp    %ebx,0x801126a4
80102364:	74 3a                	je     801023a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102366:	8b 03                	mov    (%ebx),%eax
80102368:	83 e0 06             	and    $0x6,%eax
8010236b:	83 f8 02             	cmp    $0x2,%eax
8010236e:	74 1b                	je     8010238b <iderw+0x9b>
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 c0 26 11 80       	push   $0x801126c0
80102378:	53                   	push   %ebx
80102379:	e8 62 1d 00 00       	call   801040e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x80>
  }


  release(&idelock);
8010238b:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave
  release(&idelock);
80102396:	e9 45 22 00 00       	jmp    801045e0 <release>
8010239b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 49 fd ff ff       	call   801020f0 <idestart>
801023a7:	eb bd                	jmp    80102366 <iderw+0x76>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba a4 26 11 80       	mov    $0x801126a4,%edx
801023b5:	eb a5                	jmp    8010235c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 0e 78 10 80       	push   $0x8010780e
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 f9 77 10 80       	push   $0x801077f9
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 e3 77 10 80       	push   $0x801077e3
801023d9:	e8 a2 df ff ff       	call   80100380 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e1:	c7 05 f4 26 11 80 00 	movl   $0xfec00000,0x801126f4
801023e8:	00 c0 fe 
{
801023eb:	89 e5                	mov    %esp,%ebp
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	8b 15 f4 26 11 80    	mov    0x801126f4,%edx
801023ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102402:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102408:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240e:	0f b6 15 40 28 11 80 	movzbl 0x80112840,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102415:	c1 ee 10             	shr    $0x10,%esi
80102418:	89 f0                	mov    %esi,%eax
8010241a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010241d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102420:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102423:	39 c2                	cmp    %eax,%edx
80102425:	74 16                	je     8010243d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 40 7c 10 80       	push   $0x80107c40
8010242f:	e8 6c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102434:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
8010243a:	83 c4 10             	add    $0x10,%esp
8010243d:	83 c6 21             	add    $0x21,%esi
{
80102440:	ba 10 00 00 00       	mov    $0x10,%edx
80102445:	b8 20 00 00 00       	mov    $0x20,%eax
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102452:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102454:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
  for(i = 0; i <= maxintr; i++){
8010245a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010245d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102463:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102466:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102469:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010246c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010246e:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
80102474:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247b:	39 f0                	cmp    %esi,%eax
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret
80102486:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010248d:	00 
8010248e:	66 90                	xchg   %ax,%ax

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 f4 26 11 80       	mov    0x801126f4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb 90 6f 11 80    	cmp    $0x80116f90,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 f9 21 00 00       	call   80104700 <memset>

  if(kmem.use_lock)
80102507:	8b 15 34 27 11 80    	mov    0x80112734,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 38 27 11 80       	mov    0x80112738,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 34 27 11 80       	mov    0x80112734,%eax
  kmem.freelist = r;
80102520:	89 1d 38 27 11 80    	mov    %ebx,0x80112738
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave
8010252e:	c3                   	ret
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 00 27 11 80       	push   $0x80112700
80102538:	e8 03 21 00 00       	call   80104640 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 00 27 11 80 	movl   $0x80112700,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave
    release(&kmem.lock);
80102553:	e9 88 20 00 00       	jmp    801045e0 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 2c 78 10 80       	push   $0x8010782c
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010256c:	00 
8010256d:	8d 76 00             	lea    0x0(%esi),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102574:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102577:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret
801025bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 34 27 11 80 01 	movl   $0x1,0x80112734
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret
80102615:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010261c:	00 
8010261d:	8d 76 00             	lea    0x0(%esi),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 32 78 10 80       	push   $0x80107832
80102630:	68 00 27 11 80       	push   $0x80112700
80102635:	e8 36 1e 00 00       	call   80104470 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 34 27 11 80 00 	movl   $0x0,0x80112734
80102647:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265c:	39 de                	cmp    %ebx,%esi
8010265e:	72 1c                	jb     8010267c <kinit1+0x5c>
    kfree(p);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010266f:	50                   	push   %eax
80102670:	e8 5b fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	39 de                	cmp    %ebx,%esi
8010267a:	73 e4                	jae    80102660 <kinit1+0x40>
}
8010267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010267f:	5b                   	pop    %ebx
80102680:	5e                   	pop    %esi
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret
80102683:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268a:	00 
8010268b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102690 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102690:	a1 34 27 11 80       	mov    0x80112734,%eax
80102695:	85 c0                	test   %eax,%eax
80102697:	75 1f                	jne    801026b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102699:	a1 38 27 11 80       	mov    0x80112738,%eax
  if(r)
8010269e:	85 c0                	test   %eax,%eax
801026a0:	74 0e                	je     801026b0 <kalloc+0x20>
    kmem.freelist = r->next;
801026a2:	8b 10                	mov    (%eax),%edx
801026a4:	89 15 38 27 11 80    	mov    %edx,0x80112738
  if(kmem.use_lock)
801026aa:	c3                   	ret
801026ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
  return (char*)r;
}
801026b0:	c3                   	ret
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026be:	68 00 27 11 80       	push   $0x80112700
801026c3:	e8 78 1f 00 00       	call   80104640 <acquire>
  r = kmem.freelist;
801026c8:	a1 38 27 11 80       	mov    0x80112738,%eax
  if(kmem.use_lock)
801026cd:	8b 15 34 27 11 80    	mov    0x80112734,%edx
  if(r)
801026d3:	83 c4 10             	add    $0x10,%esp
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 08                	je     801026e2 <kalloc+0x52>
    kmem.freelist = r->next;
801026da:	8b 08                	mov    (%eax),%ecx
801026dc:	89 0d 38 27 11 80    	mov    %ecx,0x80112738
  if(kmem.use_lock)
801026e2:	85 d2                	test   %edx,%edx
801026e4:	74 16                	je     801026fc <kalloc+0x6c>
    release(&kmem.lock);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ec:	68 00 27 11 80       	push   $0x80112700
801026f1:	e8 ea 1e 00 00       	call   801045e0 <release>
  return (char*)r;
801026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave
801026fd:	c3                   	ret
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102700:	ba 64 00 00 00       	mov    $0x64,%edx
80102705:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102706:	a8 01                	test   $0x1,%al
80102708:	0f 84 c2 00 00 00    	je     801027d0 <kbdgetc+0xd0>
{
8010270e:	55                   	push   %ebp
8010270f:	ba 60 00 00 00       	mov    $0x60,%edx
80102714:	89 e5                	mov    %esp,%ebp
80102716:	53                   	push   %ebx
80102717:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102718:	8b 1d 3c 27 11 80    	mov    0x8011273c,%ebx
  data = inb(KBDATAP);
8010271e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102721:	3c e0                	cmp    $0xe0,%al
80102723:	74 5b                	je     80102780 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102725:	89 da                	mov    %ebx,%edx
80102727:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010272a:	84 c0                	test   %al,%al
8010272c:	78 62                	js     80102790 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010272e:	85 d2                	test   %edx,%edx
80102730:	74 09                	je     8010273b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102732:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102735:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102738:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010273b:	0f b6 91 a0 7e 10 80 	movzbl -0x7fef8160(%ecx),%edx
  shift ^= togglecode[data];
80102742:	0f b6 81 a0 7d 10 80 	movzbl -0x7fef8260(%ecx),%eax
  shift |= shiftcode[data];
80102749:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010274b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010274f:	89 15 3c 27 11 80    	mov    %edx,0x8011273c
  c = charcode[shift & (CTL | SHIFT)][data];
80102755:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102758:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275b:	8b 04 85 80 7d 10 80 	mov    -0x7fef8280(,%eax,4),%eax
80102762:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102766:	74 0b                	je     80102773 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102768:	8d 50 9f             	lea    -0x61(%eax),%edx
8010276b:	83 fa 19             	cmp    $0x19,%edx
8010276e:	77 48                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102770:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102776:	c9                   	leave
80102777:	c3                   	ret
80102778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010277f:	00 
    shift |= E0ESC;
80102780:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102783:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102785:	89 1d 3c 27 11 80    	mov    %ebx,0x8011273c
}
8010278b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278e:	c9                   	leave
8010278f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102790:	83 e0 7f             	and    $0x7f,%eax
80102793:	85 d2                	test   %edx,%edx
80102795:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102798:	0f b6 81 a0 7e 10 80 	movzbl -0x7fef8160(%ecx),%eax
8010279f:	83 c8 40             	or     $0x40,%eax
801027a2:	0f b6 c0             	movzbl %al,%eax
801027a5:	f7 d0                	not    %eax
801027a7:	21 d8                	and    %ebx,%eax
}
801027a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027ac:	a3 3c 27 11 80       	mov    %eax,0x8011273c
    return 0;
801027b1:	31 c0                	xor    %eax,%eax
}
801027b3:	c9                   	leave
801027b4:	c3                   	ret
801027b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c1:	c9                   	leave
      c += 'a' - 'A';
801027c2:	83 f9 1a             	cmp    $0x1a,%ecx
801027c5:	0f 42 c2             	cmovb  %edx,%eax
}
801027c8:	c3                   	ret
801027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret
801027d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027dd:	00 
801027de:	66 90                	xchg   %ax,%ax

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027e6:	68 00 27 10 80       	push   $0x80102700
801027eb:	e8 90 e0 ff ff       	call   80100880 <consoleintr>
}
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	c9                   	leave
801027f4:	c3                   	ret
801027f5:	66 90                	xchg   %ax,%ax
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102800:	a1 40 27 11 80       	mov    0x80112740,%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	0f 84 cb 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
8010280d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102814:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010282e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102848:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102855:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285b:	8b 50 30             	mov    0x30(%eax),%edx
8010285e:	c1 ea 10             	shr    $0x10,%edx
80102861:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102867:	75 77                	jne    801028e0 <lapicinit+0xe0>
  lapic[index] = value;
80102869:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102870:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102876:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
801028b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028be:	00 
801028bf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	c3                   	ret
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ed:	e9 77 ff ff ff       	jmp    80102869 <lapicinit+0x69>
801028f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028f9:	00 
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	a1 40 27 11 80       	mov    0x80112740,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 07                	je     80102910 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102909:	8b 40 20             	mov    0x20(%eax),%eax
8010290c:	c1 e8 18             	shr    $0x18,%eax
8010290f:	c3                   	ret
    return 0;
80102910:	31 c0                	xor    %eax,%eax
}
80102912:	c3                   	ret
80102913:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010291a:	00 
8010291b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 40 27 11 80       	mov    0x80112740,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 0d                	je     80102936 <lapiceoi+0x16>
  lapic[index] = value;
80102929:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102930:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102936:	c3                   	ret
80102937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010293e:	00 
8010293f:	90                   	nop

80102940 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102940:	c3                   	ret
80102941:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102948:	00 
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102980:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102982:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 40 27 11 80       	mov    0x80112740,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave
801029de:	c3                   	ret
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 da                	mov    %ebx,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 da                	mov    %ebx,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 da                	mov    %ebx,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5c:	89 da                	mov    %ebx,%edx
80102a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a67:	84 c0                	test   %al,%al
80102a69:	78 9d                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	0f b6 fa             	movzbl %dl,%edi
80102a74:	89 f2                	mov    %esi,%edx
80102a76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a80:	89 da                	mov    %ebx,%edx
80102a82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a99:	31 c0                	xor    %eax,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa7:	b8 02 00 00 00       	mov    $0x2,%eax
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	89 ca                	mov    %ecx,%edx
80102aaf:	ec                   	in     (%dx),%al
80102ab0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab3:	89 da                	mov    %ebx,%edx
80102ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 da                	mov    %ebx,%edx
80102ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acf:	89 ca                	mov    %ecx,%edx
80102ad1:	ec                   	in     (%dx),%al
80102ad2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	89 da                	mov    %ebx,%edx
80102ad7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ada:	b8 08 00 00 00       	mov    $0x8,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
80102ae3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae6:	89 da                	mov    %ebx,%edx
80102ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aeb:	b8 09 00 00 00       	mov    $0x9,%eax
80102af0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af1:	89 ca                	mov    %ecx,%edx
80102af3:	ec                   	in     (%dx),%al
80102af4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102afd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b00:	6a 18                	push   $0x18
80102b02:	50                   	push   %eax
80102b03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b06:	50                   	push   %eax
80102b07:	e8 44 1c 00 00       	call   80104750 <memcmp>
80102b0c:	83 c4 10             	add    $0x10,%esp
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	0f 85 f1 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b1b:	75 78                	jne    80102b95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b95:	8b 75 08             	mov    0x8(%ebp),%esi
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 06                	mov    %eax,(%esi)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 46 04             	mov    %eax,0x4(%esi)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 46 08             	mov    %eax,0x8(%esi)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 46 0c             	mov    %eax,0xc(%esi)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 46 10             	mov    %eax,0x10(%esi)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d a8 27 11 80    	mov    0x801127a8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 94 27 11 80       	mov    0x80112794,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 a4 27 11 80    	push   0x801127a4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd ac 27 11 80 	push   -0x7feed854(,%edi,4)
80102c14:	ff 35 a4 27 11 80    	push   0x801127a4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 67 1b 00 00       	call   801047a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d a8 27 11 80    	cmp    %edi,0x801127a8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 94 27 11 80    	push   0x80112794
80102c7d:	ff 35 a4 27 11 80    	push   0x801127a4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 a8 27 11 80       	mov    0x801127a8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 ac 27 11 80 	mov    -0x7feed854(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave
80102cca:	c3                   	ret
80102ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 37 78 10 80       	push   $0x80107837
80102cdf:	68 60 27 11 80       	push   $0x80112760
80102ce4:	e8 87 17 00 00       	call   80104470 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 2b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cf8:	59                   	pop    %ecx
  log.dev = dev;
80102cf9:	89 1d a4 27 11 80    	mov    %ebx,0x801127a4
  log.size = sb.nlog;
80102cff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d02:	a3 94 27 11 80       	mov    %eax,0x80112794
  log.size = sb.nlog;
80102d07:	89 15 98 27 11 80    	mov    %edx,0x80112798
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d1b:	89 1d a8 27 11 80    	mov    %ebx,0x801127a8
  for (i = 0; i < log.lh.n; i++) {
80102d21:	85 db                	test   %ebx,%ebx
80102d23:	7e 1d                	jle    80102d42 <initlog+0x72>
80102d25:	31 d2                	xor    %edx,%edx
80102d27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d2e:	00 
80102d2f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d34:	89 0c 95 ac 27 11 80 	mov    %ecx,-0x7feed854(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d3                	cmp    %edx,%ebx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 a8 27 11 80 00 	movl   $0x0,0x801127a8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave
80102d66:	c3                   	ret
80102d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d6e:	00 
80102d6f:	90                   	nop

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 60 27 11 80       	push   $0x80112760
80102d7b:	e8 c0 18 00 00       	call   80104640 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 60 27 11 80       	push   $0x80112760
80102d90:	68 60 27 11 80       	push   $0x80112760
80102d95:	e8 46 13 00 00       	call   801040e0 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 a0 27 11 80       	mov    0x801127a0,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 9c 27 11 80       	mov    0x8011279c,%eax
80102dab:	8b 15 a8 27 11 80    	mov    0x801127a8,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 9c 27 11 80       	mov    %eax,0x8011279c
      release(&log.lock);
80102dc7:	68 60 27 11 80       	push   $0x80112760
80102dcc:	e8 0f 18 00 00       	call   801045e0 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave
80102dd5:	c3                   	ret
80102dd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ddd:	00 
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 60 27 11 80       	push   $0x80112760
80102dee:	e8 4d 18 00 00       	call   80104640 <acquire>
  log.outstanding -= 1;
80102df3:	a1 9c 27 11 80       	mov    0x8011279c,%eax
  if(log.committing)
80102df8:	8b 35 a0 27 11 80    	mov    0x801127a0,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e04:	89 1d 9c 27 11 80    	mov    %ebx,0x8011279c
  if(log.committing)
80102e0a:	85 f6                	test   %esi,%esi
80102e0c:	0f 85 22 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 f6 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1a:	c7 05 a0 27 11 80 01 	movl   $0x1,0x801127a0
80102e21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 60 27 11 80       	push   $0x80112760
80102e2c:	e8 af 17 00 00       	call   801045e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d a8 27 11 80    	mov    0x801127a8,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	7f 42                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e3e:	83 ec 0c             	sub    $0xc,%esp
80102e41:	68 60 27 11 80       	push   $0x80112760
80102e46:	e8 f5 17 00 00       	call   80104640 <acquire>
    wakeup(&log);
80102e4b:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
    log.committing = 0;
80102e52:	c7 05 a0 27 11 80 00 	movl   $0x0,0x801127a0
80102e59:	00 00 00 
    wakeup(&log);
80102e5c:	e8 3f 13 00 00       	call   801041a0 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
80102e68:	e8 73 17 00 00       	call   801045e0 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
}
80102e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e73:	5b                   	pop    %ebx
80102e74:	5e                   	pop    %esi
80102e75:	5f                   	pop    %edi
80102e76:	5d                   	pop    %ebp
80102e77:	c3                   	ret
80102e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e7f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 94 27 11 80       	mov    0x80112794,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 a4 27 11 80    	push   0x801127a4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d ac 27 11 80 	push   -0x7feed854(,%ebx,4)
80102ea4:	ff 35 a4 27 11 80    	push   0x801127a4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 d7 18 00 00       	call   801047a0 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d a8 27 11 80    	cmp    0x801127a8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 a8 27 11 80 00 	movl   $0x0,0x801127a8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 34 ff ff ff       	jmp    80102e3e <end_op+0x5e>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 60 27 11 80       	push   $0x80112760
80102f18:	e8 83 12 00 00       	call   801041a0 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
80102f24:	e8 b7 16 00 00       	call   801045e0 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 3b 78 10 80       	push   $0x8010783b
80102f3c:	e8 3f d4 ff ff       	call   80100380 <panic>
80102f41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f48:	00 
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f57:	8b 15 a8 27 11 80    	mov    0x801127a8,%edx
{
80102f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f60:	83 fa 1d             	cmp    $0x1d,%edx
80102f63:	0f 8f 85 00 00 00    	jg     80102fee <log_write+0x9e>
80102f69:	a1 98 27 11 80       	mov    0x80112798,%eax
80102f6e:	83 e8 01             	sub    $0x1,%eax
80102f71:	39 c2                	cmp    %eax,%edx
80102f73:	7d 79                	jge    80102fee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f75:	a1 9c 27 11 80       	mov    0x8011279c,%eax
80102f7a:	85 c0                	test   %eax,%eax
80102f7c:	7e 7d                	jle    80102ffb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	68 60 27 11 80       	push   $0x80112760
80102f86:	e8 b5 16 00 00       	call   80104640 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	8b 15 a8 27 11 80    	mov    0x801127a8,%edx
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	85 d2                	test   %edx,%edx
80102f96:	7e 4a                	jle    80102fe2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f98:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	31 c0                	xor    %eax,%eax
80102f9d:	eb 08                	jmp    80102fa7 <log_write+0x57>
80102f9f:	90                   	nop
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 ac 27 11 80 	cmp    %ecx,-0x7feed854(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ac 27 11 80 	mov    %ecx,-0x7feed854(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fbd:	c7 45 08 60 27 11 80 	movl   $0x80112760,0x8(%ebp)
}
80102fc4:	c9                   	leave
  release(&log.lock);
80102fc5:	e9 16 16 00 00       	jmp    801045e0 <release>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ac 27 11 80 	mov    %ecx,-0x7feed854(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 a8 27 11 80    	mov    %edx,0x801127a8
80102fe0:	eb d5                	jmp    80102fb7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fe2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fe5:	a3 ac 27 11 80       	mov    %eax,0x801127ac
  if (i == log.lh.n)
80102fea:	75 cb                	jne    80102fb7 <log_write+0x67>
80102fec:	eb e9                	jmp    80102fd7 <log_write+0x87>
    panic("too big a transaction");
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 4a 78 10 80       	push   $0x8010784a
80102ff6:	e8 85 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 60 78 10 80       	push   $0x80107860
80103003:	e8 78 d3 ff ff       	call   80100380 <panic>
80103008:	66 90                	xchg   %ax,%ax
8010300a:	66 90                	xchg   %ax,%ax
8010300c:	66 90                	xchg   %ax,%ax
8010300e:	66 90                	xchg   %ax,%ax

80103010 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103017:	e8 44 09 00 00       	call   80103960 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 3d 09 00 00       	call   80103960 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 7b 78 10 80       	push   $0x8010787b
8010302d:	e8 6e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 79 2d 00 00       	call   80105db0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 c4 08 00 00       	call   80103900 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 f1 0b 00 00       	call   80103c40 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 45 3e 00 00       	call   80106ea0 <switchkvm>
  seginit();
8010305b:	e8 b0 3d 00 00       	call   80106e10 <seginit>
  lapicinit();
80103060:	e8 9b f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103065:	e8 a6 ff ff ff       	call   80103010 <mpmain>
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <main>:
{
80103070:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103074:	83 e4 f0             	and    $0xfffffff0,%esp
80103077:	ff 71 fc             	push   -0x4(%ecx)
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	53                   	push   %ebx
8010307e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010307f:	83 ec 08             	sub    $0x8,%esp
80103082:	68 00 00 40 80       	push   $0x80400000
80103087:	68 90 6f 11 80       	push   $0x80116f90
8010308c:	e8 8f f5 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103091:	e8 fa 42 00 00       	call   80107390 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 85 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 6b 3d 00 00       	call   80106e10 <seginit>
  picinit();       // disable pic
801030a5:	e8 76 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 31 f3 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 ac d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 e7 2f 00 00       	call   801060a0 <uartinit>
  pinit();         // process table
801030b9:	e8 22 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
801030be:	e8 6d 2c 00 00       	call   80105d30 <tvinit>
  binit();         // buffer cache
801030c3:	e8 78 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030c8:	e8 43 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030cd:	e8 fe f0 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d2:	83 c4 0c             	add    $0xc,%esp
801030d5:	68 8a 00 00 00       	push   $0x8a
801030da:	68 8c b4 10 80       	push   $0x8010b48c
801030df:	68 00 70 00 80       	push   $0x80007000
801030e4:	e8 b7 16 00 00       	call   801047a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	69 05 44 28 11 80 b0 	imul   $0xb0,0x80112844,%eax
801030f3:	00 00 00 
801030f6:	05 60 28 11 80       	add    $0x80112860,%eax
801030fb:	3d 60 28 11 80       	cmp    $0x80112860,%eax
80103100:	76 7e                	jbe    80103180 <main+0x110>
80103102:	bb 60 28 11 80       	mov    $0x80112860,%ebx
80103107:	eb 20                	jmp    80103129 <main+0xb9>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103110:	69 05 44 28 11 80 b0 	imul   $0xb0,0x80112844,%eax
80103117:	00 00 00 
8010311a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103120:	05 60 28 11 80       	add    $0x80112860,%eax
80103125:	39 c3                	cmp    %eax,%ebx
80103127:	73 57                	jae    80103180 <main+0x110>
    if(c == mycpu())  // We've started already.
80103129:	e8 d2 07 00 00       	call   80103900 <mycpu>
8010312e:	39 c3                	cmp    %eax,%ebx
80103130:	74 de                	je     80103110 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103132:	e8 59 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103137:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010313a:	c7 05 f8 6f 00 80 50 	movl   $0x80103050,0x80006ff8
80103141:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103144:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010314b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010314e:	05 00 10 00 00       	add    $0x1000,%eax
80103153:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103158:	0f b6 03             	movzbl (%ebx),%eax
8010315b:	68 00 70 00 00       	push   $0x7000
80103160:	50                   	push   %eax
80103161:	e8 ea f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103166:	83 c4 10             	add    $0x10,%esp
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	74 f6                	je     80103170 <main+0x100>
8010317a:	eb 94                	jmp    80103110 <main+0xa0>
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103180:	83 ec 08             	sub    $0x8,%esp
80103183:	68 00 00 00 8e       	push   $0x8e000000
80103188:	68 00 00 40 80       	push   $0x80400000
8010318d:	e8 2e f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103192:	e8 19 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103197:	e8 74 fe ff ff       	call   80103010 <mpmain>
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031ab:	53                   	push   %ebx
  e = addr+len;
801031ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031b2:	39 de                	cmp    %ebx,%esi
801031b4:	72 10                	jb     801031c6 <mpsearch1+0x26>
801031b6:	eb 50                	jmp    80103208 <mpsearch1+0x68>
801031b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031bf:	00 
801031c0:	89 fe                	mov    %edi,%esi
801031c2:	39 fb                	cmp    %edi,%ebx
801031c4:	76 42                	jbe    80103208 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c6:	83 ec 04             	sub    $0x4,%esp
801031c9:	8d 7e 10             	lea    0x10(%esi),%edi
801031cc:	6a 04                	push   $0x4
801031ce:	68 8f 78 10 80       	push   $0x8010788f
801031d3:	56                   	push   %esi
801031d4:	e8 77 15 00 00       	call   80104750 <memcmp>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	85 c0                	test   %eax,%eax
801031de:	75 e0                	jne    801031c0 <mpsearch1+0x20>
801031e0:	89 f2                	mov    %esi,%edx
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031f0:	39 fa                	cmp    %edi,%edx
801031f2:	75 f4                	jne    801031e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f4:	84 c0                	test   %al,%al
801031f6:	75 c8                	jne    801031c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	89 f0                	mov    %esi,%eax
801031fd:	5b                   	pop    %ebx
801031fe:	5e                   	pop    %esi
801031ff:	5f                   	pop    %edi
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010320b:	31 f6                	xor    %esi,%esi
}
8010320d:	5b                   	pop    %ebx
8010320e:	89 f0                	mov    %esi,%eax
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret
80103214:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010321b:	00 
8010321c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103220 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
80103226:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103229:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103230:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103237:	c1 e0 08             	shl    $0x8,%eax
8010323a:	09 d0                	or     %edx,%eax
8010323c:	c1 e0 04             	shl    $0x4,%eax
8010323f:	75 1b                	jne    8010325c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103241:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103248:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010324f:	c1 e0 08             	shl    $0x8,%eax
80103252:	09 d0                	or     %edx,%eax
80103254:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103257:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010325c:	ba 00 04 00 00       	mov    $0x400,%edx
80103261:	e8 3a ff ff ff       	call   801031a0 <mpsearch1>
80103266:	89 c3                	mov    %eax,%ebx
80103268:	85 c0                	test   %eax,%eax
8010326a:	0f 84 40 01 00 00    	je     801033b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103270:	8b 73 04             	mov    0x4(%ebx),%esi
80103273:	85 f6                	test   %esi,%esi
80103275:	0f 84 25 01 00 00    	je     801033a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010327b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103284:	6a 04                	push   $0x4
80103286:	68 94 78 10 80       	push   $0x80107894
8010328b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010328f:	e8 bc 14 00 00       	call   80104750 <memcmp>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 85 01 01 00 00    	jne    801033a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010329f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032a6:	3c 01                	cmp    $0x1,%al
801032a8:	74 08                	je     801032b2 <mpinit+0x92>
801032aa:	3c 04                	cmp    $0x4,%al
801032ac:	0f 85 ee 00 00 00    	jne    801033a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032b9:	66 85 d2             	test   %dx,%dx
801032bc:	74 22                	je     801032e0 <mpinit+0xc0>
801032be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032c3:	31 d2                	xor    %edx,%edx
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032d4:	39 c7                	cmp    %eax,%edi
801032d6:	75 f0                	jne    801032c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032d8:	84 d2                	test   %dl,%dl
801032da:	0f 85 c0 00 00 00    	jne    801033a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032e6:	a3 40 27 11 80       	mov    %eax,0x80112740
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103300:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103303:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103308:	39 d0                	cmp    %edx,%eax
8010330a:	73 15                	jae    80103321 <mpinit+0x101>
    switch(*p){
8010330c:	0f b6 08             	movzbl (%eax),%ecx
8010330f:	80 f9 02             	cmp    $0x2,%cl
80103312:	74 4c                	je     80103360 <mpinit+0x140>
80103314:	77 3a                	ja     80103350 <mpinit+0x130>
80103316:	84 c9                	test   %cl,%cl
80103318:	74 56                	je     80103370 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010331a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331d:	39 d0                	cmp    %edx,%eax
8010331f:	72 eb                	jb     8010330c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103321:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103324:	85 f6                	test   %esi,%esi
80103326:	0f 84 d9 00 00 00    	je     80103405 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103330:	74 15                	je     80103347 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103332:	b8 70 00 00 00       	mov    $0x70,%eax
80103337:	ba 22 00 00 00       	mov    $0x22,%edx
8010333c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333d:	ba 23 00 00 00       	mov    $0x23,%edx
80103342:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103343:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103346:	ee                   	out    %al,(%dx)
  }
}
80103347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334a:	5b                   	pop    %ebx
8010334b:	5e                   	pop    %esi
8010334c:	5f                   	pop    %edi
8010334d:	5d                   	pop    %ebp
8010334e:	c3                   	ret
8010334f:	90                   	nop
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 c2                	jbe    8010331a <mpinit+0xfa>
80103358:	31 f6                	xor    %esi,%esi
8010335a:	eb ac                	jmp    80103308 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 40 28 11 80    	mov    %cl,0x80112840
      continue;
8010336d:	eb 99                	jmp    80103308 <mpinit+0xe8>
8010336f:	90                   	nop
      if(ncpu < NCPU) {
80103370:	8b 0d 44 28 11 80    	mov    0x80112844,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 44 28 11 80    	mov    %ecx,0x80112844
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 60 28 11 80    	mov    %bl,-0x7feed7a0(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 6c ff ff ff       	jmp    80103308 <mpinit+0xe8>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 99 78 10 80       	push   $0x80107899
801033a8:	e8 d3 cf ff ff       	call   80100380 <panic>
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033b5:	eb 13                	jmp    801033ca <mpinit+0x1aa>
801033b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033be:	00 
801033bf:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 d6                	je     801033a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 8f 78 10 80       	push   $0x8010788f
801033d7:	53                   	push   %ebx
801033d8:	e8 73 13 00 00       	call   80104750 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1a0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033ed:	00 
801033ee:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1a0>
80103400:	e9 6b fe ff ff       	jmp    80103270 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 74 7c 10 80       	push   $0x80107c74
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 d0 d9 ff ff       	call   80100e30 <filealloc>
80103460:	89 03                	mov    %eax,(%ebx)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 c1 d9 ff ff       	call   80100e30 <filealloc>
8010346f:	89 06                	mov    %eax,(%esi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 12 f2 ff ff       	call   80102690 <kalloc>
8010347e:	89 c7                	mov    %eax,%edi
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 b1 78 10 80       	push   $0x801078b1
801034b8:	50                   	push   %eax
801034b9:	e8 b2 0f 00 00       	call   80104470 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 03                	mov    (%ebx),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 03                	mov    (%ebx),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 03                	mov    (%ebx),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 06                	mov    (%esi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 06                	mov    (%esi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 e1 d9 ff ff       	call   80100ef0 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 06                	mov    (%esi),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 cf d9 ff ff       	call   80100ef0 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103538:	8b 03                	mov    (%ebx),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 ec 10 00 00       	call   80104640 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 65                	je     801035c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 2c 0c 00 00       	call   801041a0 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 15                	je     801035a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
    release(&p->lock);
80103594:	e9 47 10 00 00       	jmp    801045e0 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 37 10 00 00       	call   801045e0 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 16 ef ff ff       	jmp    801024d0 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 c7 0b 00 00       	call   801041a0 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb 99                	jmp    80103577 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 4e 10 00 00       	call   80104640 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e c0 00 00 00    	jle    801036c0 <pipewrite+0xe0>
80103600:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103603:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103612:	03 45 10             	add    0x10(%ebp),%eax
80103615:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103624:	89 ca                	mov    %ecx,%edx
80103626:	05 00 02 00 00       	add    $0x200,%eax
8010362b:	39 c1                	cmp    %eax,%ecx
8010362d:	74 3f                	je     8010366e <pipewrite+0x8e>
8010362f:	eb 67                	jmp    80103698 <pipewrite+0xb8>
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103638:	e8 43 03 00 00       	call   80103980 <myproc>
8010363d:	8b 48 24             	mov    0x24(%eax),%ecx
80103640:	85 c9                	test   %ecx,%ecx
80103642:	75 34                	jne    80103678 <pipewrite+0x98>
      wakeup(&p->nread);
80103644:	83 ec 0c             	sub    $0xc,%esp
80103647:	57                   	push   %edi
80103648:	e8 53 0b 00 00       	call   801041a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	53                   	push   %ebx
80103650:	56                   	push   %esi
80103651:	e8 8a 0a 00 00       	call   801040e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103656:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010365c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103662:	83 c4 10             	add    $0x10,%esp
80103665:	05 00 02 00 00       	add    $0x200,%eax
8010366a:	39 c2                	cmp    %eax,%edx
8010366c:	75 2a                	jne    80103698 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010366e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103674:	85 c0                	test   %eax,%eax
80103676:	75 c0                	jne    80103638 <pipewrite+0x58>
        release(&p->lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	53                   	push   %ebx
8010367c:	e8 5f 0f 00 00       	call   801045e0 <release>
        return -1;
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103698:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010369b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010369e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036ad:	83 c6 01             	add    $0x1,%esi
801036b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ba:	0f 85 58 ff ff ff    	jne    80103618 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c9:	50                   	push   %eax
801036ca:	e8 d1 0a 00 00       	call   801041a0 <wakeup>
  release(&p->lock);
801036cf:	89 1c 24             	mov    %ebx,(%esp)
801036d2:	e8 09 0f 00 00       	call   801045e0 <release>
  return n;
801036d7:	8b 45 10             	mov    0x10(%ebp),%eax
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	eb aa                	jmp    80103689 <pipewrite+0xa9>
801036df:	90                   	nop

801036e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	56                   	push   %esi
801036f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036f6:	e8 45 0f 00 00       	call   80104640 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010370a:	74 2f                	je     8010373b <piperead+0x5b>
8010370c:	eb 37                	jmp    80103745 <piperead+0x65>
8010370e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103710:	e8 6b 02 00 00       	call   80103980 <myproc>
80103715:	8b 48 24             	mov    0x24(%eax),%ecx
80103718:	85 c9                	test   %ecx,%ecx
8010371a:	0f 85 80 00 00 00    	jne    801037a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	e8 b6 09 00 00       	call   801040e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103739:	75 0a                	jne    80103745 <piperead+0x65>
8010373b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103741:	85 c0                	test   %eax,%eax
80103743:	75 cb                	jne    80103710 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	8b 55 10             	mov    0x10(%ebp),%edx
80103748:	31 db                	xor    %ebx,%ebx
8010374a:	85 d2                	test   %edx,%edx
8010374c:	7f 20                	jg     8010376e <piperead+0x8e>
8010374e:	eb 2c                	jmp    8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103750:	8d 48 01             	lea    0x1(%eax),%ecx
80103753:	25 ff 01 00 00       	and    $0x1ff,%eax
80103758:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010375e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103763:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103766:	83 c3 01             	add    $0x1,%ebx
80103769:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376c:	74 0e                	je     8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010376e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103774:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010377a:	75 d4                	jne    80103750 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 15 0a 00 00       	call   801041a0 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 4d 0e 00 00       	call   801045e0 <release>
  return i;
80103793:	83 c4 10             	add    $0x10,%esp
}
80103796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103799:	89 d8                	mov    %ebx,%eax
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5f                   	pop    %edi
8010379e:	5d                   	pop    %ebp
8010379f:	c3                   	ret
      release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037a8:	56                   	push   %esi
801037a9:	e8 32 0e 00 00       	call   801045e0 <release>
      return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	89 d8                	mov    %ebx,%eax
801037b6:	5b                   	pop    %ebx
801037b7:	5e                   	pop    %esi
801037b8:	5f                   	pop    %edi
801037b9:	5d                   	pop    %ebp
801037ba:	c3                   	ret
801037bb:	66 90                	xchg   %ax,%ax
801037bd:	66 90                	xchg   %ax,%ax
801037bf:	90                   	nop

801037c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c4:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
{
801037c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037cc:	68 e0 2d 11 80       	push   $0x80112de0
801037d1:	e8 6a 0e 00 00       	call   80104640 <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	eb 10                	jmp    801037eb <allocproc+0x2b>
801037db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	83 c3 7c             	add    $0x7c,%ebx
801037e3:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
801037e9:	74 75                	je     80103860 <allocproc+0xa0>
    if(p->state == UNUSED)
801037eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801037ee:	85 c0                	test   %eax,%eax
801037f0:	75 ee                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037f7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103801:	89 43 10             	mov    %eax,0x10(%ebx)
80103804:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103807:	68 e0 2d 11 80       	push   $0x80112de0
  p->pid = nextpid++;
8010380c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103812:	e8 c9 0d 00 00       	call   801045e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103817:	e8 74 ee ff ff       	call   80102690 <kalloc>
8010381c:	83 c4 10             	add    $0x10,%esp
8010381f:	89 43 08             	mov    %eax,0x8(%ebx)
80103822:	85 c0                	test   %eax,%eax
80103824:	74 53                	je     80103879 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103826:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010382c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010382f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103834:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103837:	c7 40 14 1f 5d 10 80 	movl   $0x80105d1f,0x14(%eax)
  p->context = (struct context*)sp;
8010383e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103841:	6a 14                	push   $0x14
80103843:	6a 00                	push   $0x0
80103845:	50                   	push   %eax
80103846:	e8 b5 0e 00 00       	call   80104700 <memset>
  p->context->eip = (uint)forkret;
8010384b:	8b 43 1c             	mov    0x1c(%ebx),%eax
  // if (history_count < MAX_HISTORY) {
  //     history_count++;  // Keep track of number of stored records
  // }
  // release(&ptable.lock);

  return p;
8010384e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103851:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)
}
80103858:	89 d8                	mov    %ebx,%eax
8010385a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385d:	c9                   	leave
8010385e:	c3                   	ret
8010385f:	90                   	nop
  release(&ptable.lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103863:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103865:	68 e0 2d 11 80       	push   $0x80112de0
8010386a:	e8 71 0d 00 00       	call   801045e0 <release>
}
8010386f:	89 d8                	mov    %ebx,%eax
  return 0;
80103871:	83 c4 10             	add    $0x10,%esp
}
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave
80103878:	c3                   	ret
    p->state = UNUSED;
80103879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103880:	31 db                	xor    %ebx,%ebx
}
80103882:	89 d8                	mov    %ebx,%eax
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave
80103888:	c3                   	ret
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	68 e0 2d 11 80       	push   $0x80112de0
8010389b:	e8 40 0d 00 00       	call   801045e0 <release>

  if (first) {
801038a0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 04                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ac:	c9                   	leave
801038ad:	c3                   	ret
801038ae:	66 90                	xchg   %ax,%ax
    first = 0;
801038b0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038b7:	00 00 00 
    iinit(ROOTDEV);
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	6a 01                	push   $0x1
801038bf:	e8 9c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cb:	e8 00 f4 ff ff       	call   80102cd0 <initlog>
}
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	c9                   	leave
801038d4:	c3                   	ret
801038d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038dc:	00 
801038dd:	8d 76 00             	lea    0x0(%esi),%esi

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 b6 78 10 80       	push   $0x801078b6
801038eb:	68 e0 2d 11 80       	push   $0x80112de0
801038f0:	e8 7b 0b 00 00       	call   80104470 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave
801038f9:	c3                   	ret
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103905:	9c                   	pushf
80103906:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103907:	f6 c4 02             	test   $0x2,%ah
8010390a:	75 46                	jne    80103952 <mycpu+0x52>
  apicid = lapicid();
8010390c:	e8 ef ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103911:	8b 35 44 28 11 80    	mov    0x80112844,%esi
80103917:	85 f6                	test   %esi,%esi
80103919:	7e 2a                	jle    80103945 <mycpu+0x45>
8010391b:	31 d2                	xor    %edx,%edx
8010391d:	eb 08                	jmp    80103927 <mycpu+0x27>
8010391f:	90                   	nop
80103920:	83 c2 01             	add    $0x1,%edx
80103923:	39 f2                	cmp    %esi,%edx
80103925:	74 1e                	je     80103945 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103927:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010392d:	0f b6 99 60 28 11 80 	movzbl -0x7feed7a0(%ecx),%ebx
80103934:	39 c3                	cmp    %eax,%ebx
80103936:	75 e8                	jne    80103920 <mycpu+0x20>
}
80103938:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010393b:	8d 81 60 28 11 80    	lea    -0x7feed7a0(%ecx),%eax
}
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret
  panic("unknown apicid\n");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 bd 78 10 80       	push   $0x801078bd
8010394d:	e8 2e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103952:	83 ec 0c             	sub    $0xc,%esp
80103955:	68 94 7c 10 80       	push   $0x80107c94
8010395a:	e8 21 ca ff ff       	call   80100380 <panic>
8010395f:	90                   	nop

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 95 ff ff ff       	call   80103900 <mycpu>
}
8010396b:	c9                   	leave
  return mycpu()-cpus;
8010396c:	2d 60 28 11 80       	sub    $0x80112860,%eax
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret
8010397b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 64 0b 00 00       	call   801044f0 <pushcli>
  c = mycpu();
8010398c:	e8 6f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 a4 0b 00 00       	call   80104540 <popcli>
}
8010399c:	89 d8                	mov    %ebx,%eax
8010399e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a1:	c9                   	leave
801039a2:	c3                   	ret
801039a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039aa:	00 
801039ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 04 fe ff ff       	call   801037c0 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 80 56 11 80       	mov    %eax,0x80115680
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 48 39 00 00       	call   80107310 <setupkvm>
801039c8:	89 43 04             	mov    %eax,0x4(%ebx)
801039cb:	85 c0                	test   %eax,%eax
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 b4 10 80       	push   $0x8010b460
801039e0:	50                   	push   %eax
801039e1:	e8 da 35 00 00       	call   80106fc0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	push   0x18(%ebx)
801039f6:	e8 05 0d 00 00       	call   80104700 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 e6 78 10 80       	push   $0x801078e6
80103a54:	50                   	push   %eax
80103a55:	e8 66 0e 00 00       	call   801048c0 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 ef 78 10 80 	movl   $0x801078ef,(%esp)
80103a61:	e8 4a e6 ff ff       	call   801020b0 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103a70:	e8 cb 0b 00 00       	call   80104640 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103a83:	e8 58 0b 00 00       	call   801045e0 <release>
}
80103a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8b:	83 c4 10             	add    $0x10,%esp
80103a8e:	c9                   	leave
80103a8f:	c3                   	ret
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 cd 78 10 80       	push   $0x801078cd
80103a98:	e8 e3 c8 ff ff       	call   80100380 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aa8:	e8 43 0a 00 00       	call   801044f0 <pushcli>
  c = mycpu();
80103aad:	e8 4e fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ab2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab8:	e8 83 0a 00 00       	call   80104540 <popcli>
  sz = curproc->sz;
80103abd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103abf:	85 f6                	test   %esi,%esi
80103ac1:	7f 1d                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac3:	75 3b                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ac8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aca:	53                   	push   %ebx
80103acb:	e8 e0 33 00 00       	call   80106eb0 <switchuvm>
  return 0;
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	31 c0                	xor    %eax,%eax
}
80103ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad8:	5b                   	pop    %ebx
80103ad9:	5e                   	pop    %esi
80103ada:	5d                   	pop    %ebp
80103adb:	c3                   	ret
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	push   0x4(%ebx)
80103aea:	e8 41 36 00 00       	call   80107130 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 cf                	jne    80103ac5 <growproc+0x25>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d8                	jmp    80103ad5 <growproc+0x35>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 51 37 00 00       	call   80107260 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 af                	jne    80103ac5 <growproc+0x25>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b1f:	00 

80103b20 <fork>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b29:	e8 c2 09 00 00       	call   801044f0 <pushcli>
  c = mycpu();
80103b2e:	e8 cd fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b39:	e8 02 0a 00 00       	call   80104540 <popcli>
  if((np = allocproc()) == 0){
80103b3e:	e8 7d fc ff ff       	call   801037c0 <allocproc>
80103b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b46:	85 c0                	test   %eax,%eax
80103b48:	0f 84 b7 00 00 00    	je     80103c05 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b4e:	83 ec 08             	sub    $0x8,%esp
80103b51:	ff 33                	push   (%ebx)
80103b53:	89 c7                	mov    %eax,%edi
80103b55:	ff 73 04             	push   0x4(%ebx)
80103b58:	e8 a3 38 00 00       	call   80107400 <copyuvm>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	89 47 04             	mov    %eax,0x4(%edi)
80103b63:	85 c0                	test   %eax,%eax
80103b65:	0f 84 a1 00 00 00    	je     80103c0c <fork+0xec>
  np->sz = curproc->sz;
80103b6b:	8b 03                	mov    (%ebx),%eax
80103b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b75:	89 c8                	mov    %ecx,%eax
80103b77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b86:	8b 40 18             	mov    0x18(%eax),%eax
80103b89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 13                	je     80103bab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b98:	83 ec 0c             	sub    $0xc,%esp
80103b9b:	50                   	push   %eax
80103b9c:	e8 ff d2 ff ff       	call   80100ea0 <filedup>
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
80103bae:	83 fe 10             	cmp    $0x10,%esi
80103bb1:	75 dd                	jne    80103b90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bb3:	83 ec 0c             	sub    $0xc,%esp
80103bb6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bbc:	e8 9f db ff ff       	call   80101760 <idup>
80103bc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bcd:	6a 10                	push   $0x10
80103bcf:	53                   	push   %ebx
80103bd0:	50                   	push   %eax
80103bd1:	e8 ea 0c 00 00       	call   801048c0 <safestrcpy>
  pid = np->pid;
80103bd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bd9:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103be0:	e8 5b 0a 00 00       	call   80104640 <acquire>
  np->state = RUNNABLE;
80103be5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bec:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103bf3:	e8 e8 09 00 00       	call   801045e0 <release>
  return pid;
80103bf8:	83 c4 10             	add    $0x10,%esp
}
80103bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bfe:	89 d8                	mov    %ebx,%eax
80103c00:	5b                   	pop    %ebx
80103c01:	5e                   	pop    %esi
80103c02:	5f                   	pop    %edi
80103c03:	5d                   	pop    %ebp
80103c04:	c3                   	ret
    return -1;
80103c05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c0a:	eb ef                	jmp    80103bfb <fork+0xdb>
    kfree(np->kstack);
80103c0c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c0f:	83 ec 0c             	sub    $0xc,%esp
80103c12:	ff 73 08             	push   0x8(%ebx)
80103c15:	e8 b6 e8 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103c1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c21:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c24:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c30:	eb c9                	jmp    80103bfb <fork+0xdb>
80103c32:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c39:	00 
80103c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c40 <scheduler>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c49:	e8 b2 fc ff ff       	call   80103900 <mycpu>
  c->proc = 0;
80103c4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c55:	00 00 00 
  struct cpu *c = mycpu();
80103c58:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c5a:	8d 78 04             	lea    0x4(%eax),%edi
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c60:	fb                   	sti
    acquire(&ptable.lock);
80103c61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c64:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
    acquire(&ptable.lock);
80103c69:	68 e0 2d 11 80       	push   $0x80112de0
80103c6e:	e8 cd 09 00 00       	call   80104640 <acquire>
80103c73:	83 c4 10             	add    $0x10,%esp
80103c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c7d:	00 
80103c7e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c84:	75 33                	jne    80103cb9 <scheduler+0x79>
      switchuvm(p);
80103c86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c8f:	53                   	push   %ebx
80103c90:	e8 1b 32 00 00       	call   80106eb0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c95:	58                   	pop    %eax
80103c96:	5a                   	pop    %edx
80103c97:	ff 73 1c             	push   0x1c(%ebx)
80103c9a:	57                   	push   %edi
      p->state = RUNNING;
80103c9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ca2:	e8 74 0c 00 00       	call   8010491b <swtch>
      switchkvm();
80103ca7:	e8 f4 31 00 00       	call   80106ea0 <switchkvm>
      c->proc = 0;
80103cac:	83 c4 10             	add    $0x10,%esp
80103caf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cb6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb9:	83 c3 7c             	add    $0x7c,%ebx
80103cbc:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80103cc2:	75 bc                	jne    80103c80 <scheduler+0x40>
    release(&ptable.lock);
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	68 e0 2d 11 80       	push   $0x80112de0
80103ccc:	e8 0f 09 00 00       	call   801045e0 <release>
    sti();
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	eb 8a                	jmp    80103c60 <scheduler+0x20>
80103cd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cdd:	00 
80103cde:	66 90                	xchg   %ax,%ax

80103ce0 <sched>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
  pushcli();
80103ce5:	e8 06 08 00 00       	call   801044f0 <pushcli>
  c = mycpu();
80103cea:	e8 11 fc ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103cef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf5:	e8 46 08 00 00       	call   80104540 <popcli>
  if(!holding(&ptable.lock))
80103cfa:	83 ec 0c             	sub    $0xc,%esp
80103cfd:	68 e0 2d 11 80       	push   $0x80112de0
80103d02:	e8 99 08 00 00       	call   801045a0 <holding>
80103d07:	83 c4 10             	add    $0x10,%esp
80103d0a:	85 c0                	test   %eax,%eax
80103d0c:	74 4f                	je     80103d5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d0e:	e8 ed fb ff ff       	call   80103900 <mycpu>
80103d13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d1a:	75 68                	jne    80103d84 <sched+0xa4>
  if(p->state == RUNNING)
80103d1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d20:	74 55                	je     80103d77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d22:	9c                   	pushf
80103d23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d24:	f6 c4 02             	test   $0x2,%ah
80103d27:	75 41                	jne    80103d6a <sched+0x8a>
  intena = mycpu()->intena;
80103d29:	e8 d2 fb ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d37:	e8 c4 fb ff ff       	call   80103900 <mycpu>
80103d3c:	83 ec 08             	sub    $0x8,%esp
80103d3f:	ff 70 04             	push   0x4(%eax)
80103d42:	53                   	push   %ebx
80103d43:	e8 d3 0b 00 00       	call   8010491b <swtch>
  mycpu()->intena = intena;
80103d48:	e8 b3 fb ff ff       	call   80103900 <mycpu>
}
80103d4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d59:	5b                   	pop    %ebx
80103d5a:	5e                   	pop    %esi
80103d5b:	5d                   	pop    %ebp
80103d5c:	c3                   	ret
    panic("sched ptable.lock");
80103d5d:	83 ec 0c             	sub    $0xc,%esp
80103d60:	68 f1 78 10 80       	push   $0x801078f1
80103d65:	e8 16 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d6a:	83 ec 0c             	sub    $0xc,%esp
80103d6d:	68 1d 79 10 80       	push   $0x8010791d
80103d72:	e8 09 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	68 0f 79 10 80       	push   $0x8010790f
80103d7f:	e8 fc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 03 79 10 80       	push   $0x80107903
80103d8c:	e8 ef c5 ff ff       	call   80100380 <panic>
80103d91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d98:	00 
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <exit>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103da9:	e8 d2 fb ff ff       	call   80103980 <myproc>
  if(curproc == initproc)
80103dae:	39 05 80 56 11 80    	cmp    %eax,0x80115680
80103db4:	0f 84 8a 01 00 00    	je     80103f44 <exit+0x1a4>
  acquire(&ptable.lock);
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	89 c3                	mov    %eax,%ebx
80103dbf:	68 e0 2d 11 80       	push   $0x80112de0
80103dc4:	e8 77 08 00 00       	call   80104640 <acquire>
  process_history[history_index].pid = curproc->pid;
80103dc9:	a1 14 4d 11 80       	mov    0x80114d14,%eax
80103dce:	8b 53 10             	mov    0x10(%ebx),%edx
  safestrcpy(process_history[history_index].name, curproc->name, CMD_NAME_MAX);
80103dd1:	83 c4 0c             	add    $0xc,%esp
80103dd4:	6a 10                	push   $0x10
  process_history[history_index].pid = curproc->pid;
80103dd6:	8d 04 40             	lea    (%eax,%eax,2),%eax
80103dd9:	c1 e0 03             	shl    $0x3,%eax
80103ddc:	89 90 20 4d 11 80    	mov    %edx,-0x7feeb2e0(%eax)
  safestrcpy(process_history[history_index].name, curproc->name, CMD_NAME_MAX);
80103de2:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103de5:	05 24 4d 11 80       	add    $0x80114d24,%eax
80103dea:	52                   	push   %edx
80103deb:	50                   	push   %eax
80103dec:	e8 cf 0a 00 00       	call   801048c0 <safestrcpy>
  process_history[history_index].mem_usage = curproc->sz;
80103df1:	8b 0d 14 4d 11 80    	mov    0x80114d14,%ecx
80103df7:	8b 13                	mov    (%ebx),%edx
  if (history_count < MAX_HISTORY) {
80103df9:	83 c4 10             	add    $0x10,%esp
  process_history[history_index].mem_usage = curproc->sz;
80103dfc:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  history_index = (history_index + 1) % MAX_HISTORY;
80103dff:	83 c1 01             	add    $0x1,%ecx
  process_history[history_index].mem_usage = curproc->sz;
80103e02:	89 14 c5 34 4d 11 80 	mov    %edx,-0x7feeb2cc(,%eax,8)
  history_index = (history_index + 1) % MAX_HISTORY;
80103e09:	89 c8                	mov    %ecx,%eax
80103e0b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80103e10:	f7 ea                	imul   %edx
80103e12:	89 c8                	mov    %ecx,%eax
80103e14:	c1 f8 1f             	sar    $0x1f,%eax
80103e17:	c1 fa 05             	sar    $0x5,%edx
80103e1a:	29 c2                	sub    %eax,%edx
80103e1c:	6b c2 64             	imul   $0x64,%edx,%eax
80103e1f:	29 c1                	sub    %eax,%ecx
  if (history_count < MAX_HISTORY) {
80103e21:	a1 18 4d 11 80       	mov    0x80114d18,%eax
  history_index = (history_index + 1) % MAX_HISTORY;
80103e26:	89 0d 14 4d 11 80    	mov    %ecx,0x80114d14
  if (history_count < MAX_HISTORY) {
80103e2c:	83 f8 63             	cmp    $0x63,%eax
80103e2f:	0f 8e 02 01 00 00    	jle    80103f37 <exit+0x197>
  release(&ptable.lock);
80103e35:	83 ec 0c             	sub    $0xc,%esp
80103e38:	8d 73 28             	lea    0x28(%ebx),%esi
80103e3b:	8d 7b 68             	lea    0x68(%ebx),%edi
80103e3e:	68 e0 2d 11 80       	push   $0x80112de0
80103e43:	e8 98 07 00 00       	call   801045e0 <release>
  for(fd = 0; fd < NOFILE; fd++){
80103e48:	83 c4 10             	add    $0x10,%esp
80103e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103e50:	8b 06                	mov    (%esi),%eax
80103e52:	85 c0                	test   %eax,%eax
80103e54:	74 12                	je     80103e68 <exit+0xc8>
      fileclose(curproc->ofile[fd]);
80103e56:	83 ec 0c             	sub    $0xc,%esp
80103e59:	50                   	push   %eax
80103e5a:	e8 91 d0 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103e5f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e65:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e68:	83 c6 04             	add    $0x4,%esi
80103e6b:	39 f7                	cmp    %esi,%edi
80103e6d:	75 e1                	jne    80103e50 <exit+0xb0>
  begin_op();
80103e6f:	e8 fc ee ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
80103e74:	83 ec 0c             	sub    $0xc,%esp
80103e77:	ff 73 68             	push   0x68(%ebx)
80103e7a:	e8 41 da ff ff       	call   801018c0 <iput>
  end_op();
80103e7f:	e8 5c ef ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103e84:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e8b:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103e92:	e8 a9 07 00 00       	call   80104640 <acquire>
  wakeup1(curproc->parent);
80103e97:	8b 53 14             	mov    0x14(%ebx),%edx
80103e9a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9d:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
80103ea2:	eb 0e                	jmp    80103eb2 <exit+0x112>
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea8:	83 c0 7c             	add    $0x7c,%eax
80103eab:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103eb0:	74 1c                	je     80103ece <exit+0x12e>
    if(p->state == SLEEPING && p->chan == chan)
80103eb2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eb6:	75 f0                	jne    80103ea8 <exit+0x108>
80103eb8:	3b 50 20             	cmp    0x20(%eax),%edx
80103ebb:	75 eb                	jne    80103ea8 <exit+0x108>
      p->state = RUNNABLE;
80103ebd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec4:	83 c0 7c             	add    $0x7c,%eax
80103ec7:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103ecc:	75 e4                	jne    80103eb2 <exit+0x112>
      p->parent = initproc;
80103ece:	8b 0d 80 56 11 80    	mov    0x80115680,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed4:	ba 14 2e 11 80       	mov    $0x80112e14,%edx
80103ed9:	eb 10                	jmp    80103eeb <exit+0x14b>
80103edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ee0:	83 c2 7c             	add    $0x7c,%edx
80103ee3:	81 fa 14 4d 11 80    	cmp    $0x80114d14,%edx
80103ee9:	74 33                	je     80103f1e <exit+0x17e>
    if(p->parent == curproc){
80103eeb:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103eee:	75 f0                	jne    80103ee0 <exit+0x140>
      if(p->state == ZOMBIE)
80103ef0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ef4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ef7:	75 e7                	jne    80103ee0 <exit+0x140>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ef9:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
80103efe:	eb 0a                	jmp    80103f0a <exit+0x16a>
80103f00:	83 c0 7c             	add    $0x7c,%eax
80103f03:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103f08:	74 d6                	je     80103ee0 <exit+0x140>
    if(p->state == SLEEPING && p->chan == chan)
80103f0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f0e:	75 f0                	jne    80103f00 <exit+0x160>
80103f10:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f13:	75 eb                	jne    80103f00 <exit+0x160>
      p->state = RUNNABLE;
80103f15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f1c:	eb e2                	jmp    80103f00 <exit+0x160>
  curproc->state = ZOMBIE;
80103f1e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f25:	e8 b6 fd ff ff       	call   80103ce0 <sched>
  panic("zombie exit");
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 3e 79 10 80       	push   $0x8010793e
80103f32:	e8 49 c4 ff ff       	call   80100380 <panic>
      history_count++;  // Keep track of number of stored records
80103f37:	83 c0 01             	add    $0x1,%eax
80103f3a:	a3 18 4d 11 80       	mov    %eax,0x80114d18
80103f3f:	e9 f1 fe ff ff       	jmp    80103e35 <exit+0x95>
    panic("init exiting");
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 31 79 10 80       	push   $0x80107931
80103f4c:	e8 2f c4 ff ff       	call   80100380 <panic>
80103f51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f58:	00 
80103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f60 <wait>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
  pushcli();
80103f65:	e8 86 05 00 00       	call   801044f0 <pushcli>
  c = mycpu();
80103f6a:	e8 91 f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103f6f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f75:	e8 c6 05 00 00       	call   80104540 <popcli>
  acquire(&ptable.lock);
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 e0 2d 11 80       	push   $0x80112de0
80103f82:	e8 b9 06 00 00       	call   80104640 <acquire>
80103f87:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f8a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f8c:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
80103f91:	eb 10                	jmp    80103fa3 <wait+0x43>
80103f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f98:	83 c3 7c             	add    $0x7c,%ebx
80103f9b:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80103fa1:	74 1b                	je     80103fbe <wait+0x5e>
      if(p->parent != curproc)
80103fa3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fa6:	75 f0                	jne    80103f98 <wait+0x38>
      if(p->state == ZOMBIE){
80103fa8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fac:	74 62                	je     80104010 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fae:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fb1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb6:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80103fbc:	75 e5                	jne    80103fa3 <wait+0x43>
    if(!havekids || curproc->killed){
80103fbe:	85 c0                	test   %eax,%eax
80103fc0:	0f 84 a0 00 00 00    	je     80104066 <wait+0x106>
80103fc6:	8b 46 24             	mov    0x24(%esi),%eax
80103fc9:	85 c0                	test   %eax,%eax
80103fcb:	0f 85 95 00 00 00    	jne    80104066 <wait+0x106>
  pushcli();
80103fd1:	e8 1a 05 00 00       	call   801044f0 <pushcli>
  c = mycpu();
80103fd6:	e8 25 f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103fdb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe1:	e8 5a 05 00 00       	call   80104540 <popcli>
  if(p == 0)
80103fe6:	85 db                	test   %ebx,%ebx
80103fe8:	0f 84 8f 00 00 00    	je     8010407d <wait+0x11d>
  p->chan = chan;
80103fee:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103ff1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ff8:	e8 e3 fc ff ff       	call   80103ce0 <sched>
  p->chan = 0;
80103ffd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104004:	eb 84                	jmp    80103f8a <wait+0x2a>
80104006:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010400d:	00 
8010400e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104010:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104013:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104016:	ff 73 08             	push   0x8(%ebx)
80104019:	e8 b2 e4 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
8010401e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104025:	5a                   	pop    %edx
80104026:	ff 73 04             	push   0x4(%ebx)
80104029:	e8 62 32 00 00       	call   80107290 <freevm>
        p->pid = 0;
8010402e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104035:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010403c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104040:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104047:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010404e:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80104055:	e8 86 05 00 00       	call   801045e0 <release>
        return pid;
8010405a:	83 c4 10             	add    $0x10,%esp
}
8010405d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104060:	89 f0                	mov    %esi,%eax
80104062:	5b                   	pop    %ebx
80104063:	5e                   	pop    %esi
80104064:	5d                   	pop    %ebp
80104065:	c3                   	ret
      release(&ptable.lock);
80104066:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104069:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010406e:	68 e0 2d 11 80       	push   $0x80112de0
80104073:	e8 68 05 00 00       	call   801045e0 <release>
      return -1;
80104078:	83 c4 10             	add    $0x10,%esp
8010407b:	eb e0                	jmp    8010405d <wait+0xfd>
    panic("sleep");
8010407d:	83 ec 0c             	sub    $0xc,%esp
80104080:	68 4a 79 10 80       	push   $0x8010794a
80104085:	e8 f6 c2 ff ff       	call   80100380 <panic>
8010408a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104090 <yield>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	53                   	push   %ebx
80104094:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104097:	68 e0 2d 11 80       	push   $0x80112de0
8010409c:	e8 9f 05 00 00       	call   80104640 <acquire>
  pushcli();
801040a1:	e8 4a 04 00 00       	call   801044f0 <pushcli>
  c = mycpu();
801040a6:	e8 55 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801040ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040b1:	e8 8a 04 00 00       	call   80104540 <popcli>
  myproc()->state = RUNNABLE;
801040b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040bd:	e8 1e fc ff ff       	call   80103ce0 <sched>
  release(&ptable.lock);
801040c2:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
801040c9:	e8 12 05 00 00       	call   801045e0 <release>
}
801040ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d1:	83 c4 10             	add    $0x10,%esp
801040d4:	c9                   	leave
801040d5:	c3                   	ret
801040d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040dd:	00 
801040de:	66 90                	xchg   %ax,%ax

801040e0 <sleep>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	57                   	push   %edi
801040e4:	56                   	push   %esi
801040e5:	53                   	push   %ebx
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040ef:	e8 fc 03 00 00       	call   801044f0 <pushcli>
  c = mycpu();
801040f4:	e8 07 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801040f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040ff:	e8 3c 04 00 00       	call   80104540 <popcli>
  if(p == 0)
80104104:	85 db                	test   %ebx,%ebx
80104106:	0f 84 87 00 00 00    	je     80104193 <sleep+0xb3>
  if(lk == 0)
8010410c:	85 f6                	test   %esi,%esi
8010410e:	74 76                	je     80104186 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104110:	81 fe e0 2d 11 80    	cmp    $0x80112de0,%esi
80104116:	74 50                	je     80104168 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104118:	83 ec 0c             	sub    $0xc,%esp
8010411b:	68 e0 2d 11 80       	push   $0x80112de0
80104120:	e8 1b 05 00 00       	call   80104640 <acquire>
    release(lk);
80104125:	89 34 24             	mov    %esi,(%esp)
80104128:	e8 b3 04 00 00       	call   801045e0 <release>
  p->chan = chan;
8010412d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104130:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104137:	e8 a4 fb ff ff       	call   80103ce0 <sched>
  p->chan = 0;
8010413c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104143:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
8010414a:	e8 91 04 00 00       	call   801045e0 <release>
    acquire(lk);
8010414f:	89 75 08             	mov    %esi,0x8(%ebp)
80104152:	83 c4 10             	add    $0x10,%esp
}
80104155:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104158:	5b                   	pop    %ebx
80104159:	5e                   	pop    %esi
8010415a:	5f                   	pop    %edi
8010415b:	5d                   	pop    %ebp
    acquire(lk);
8010415c:	e9 df 04 00 00       	jmp    80104640 <acquire>
80104161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104168:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010416b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104172:	e8 69 fb ff ff       	call   80103ce0 <sched>
  p->chan = 0;
80104177:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010417e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104181:	5b                   	pop    %ebx
80104182:	5e                   	pop    %esi
80104183:	5f                   	pop    %edi
80104184:	5d                   	pop    %ebp
80104185:	c3                   	ret
    panic("sleep without lk");
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	68 50 79 10 80       	push   $0x80107950
8010418e:	e8 ed c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104193:	83 ec 0c             	sub    $0xc,%esp
80104196:	68 4a 79 10 80       	push   $0x8010794a
8010419b:	e8 e0 c1 ff ff       	call   80100380 <panic>

801041a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 10             	sub    $0x10,%esp
801041a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041aa:	68 e0 2d 11 80       	push   $0x80112de0
801041af:	e8 8c 04 00 00       	call   80104640 <acquire>
801041b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b7:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
801041bc:	eb 0c                	jmp    801041ca <wakeup+0x2a>
801041be:	66 90                	xchg   %ax,%ax
801041c0:	83 c0 7c             	add    $0x7c,%eax
801041c3:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
801041c8:	74 1c                	je     801041e6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801041ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041ce:	75 f0                	jne    801041c0 <wakeup+0x20>
801041d0:	3b 58 20             	cmp    0x20(%eax),%ebx
801041d3:	75 eb                	jne    801041c0 <wakeup+0x20>
      p->state = RUNNABLE;
801041d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041dc:	83 c0 7c             	add    $0x7c,%eax
801041df:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
801041e4:	75 e4                	jne    801041ca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801041e6:	c7 45 08 e0 2d 11 80 	movl   $0x80112de0,0x8(%ebp)
}
801041ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041f0:	c9                   	leave
  release(&ptable.lock);
801041f1:	e9 ea 03 00 00       	jmp    801045e0 <release>
801041f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041fd:	00 
801041fe:	66 90                	xchg   %ax,%ax

80104200 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 10             	sub    $0x10,%esp
80104207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010420a:	68 e0 2d 11 80       	push   $0x80112de0
8010420f:	e8 2c 04 00 00       	call   80104640 <acquire>
80104214:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104217:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
8010421c:	eb 0c                	jmp    8010422a <kill+0x2a>
8010421e:	66 90                	xchg   %ax,%ax
80104220:	83 c0 7c             	add    $0x7c,%eax
80104223:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80104228:	74 36                	je     80104260 <kill+0x60>
    if(p->pid == pid){
8010422a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010422d:	75 f1                	jne    80104220 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010422f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104233:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010423a:	75 07                	jne    80104243 <kill+0x43>
        p->state = RUNNABLE;
8010423c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104243:	83 ec 0c             	sub    $0xc,%esp
80104246:	68 e0 2d 11 80       	push   $0x80112de0
8010424b:	e8 90 03 00 00       	call   801045e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104253:	83 c4 10             	add    $0x10,%esp
80104256:	31 c0                	xor    %eax,%eax
}
80104258:	c9                   	leave
80104259:	c3                   	ret
8010425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104260:	83 ec 0c             	sub    $0xc,%esp
80104263:	68 e0 2d 11 80       	push   $0x80112de0
80104268:	e8 73 03 00 00       	call   801045e0 <release>
}
8010426d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104270:	83 c4 10             	add    $0x10,%esp
80104273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104278:	c9                   	leave
80104279:	c3                   	ret
8010427a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104280 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	57                   	push   %edi
80104284:	56                   	push   %esi
80104285:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104288:	53                   	push   %ebx
80104289:	bb 80 2e 11 80       	mov    $0x80112e80,%ebx
8010428e:	83 ec 3c             	sub    $0x3c,%esp
80104291:	eb 24                	jmp    801042b7 <procdump+0x37>
80104293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	68 86 7b 10 80       	push   $0x80107b86
801042a0:	e8 fb c3 ff ff       	call   801006a0 <cprintf>
801042a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a8:	83 c3 7c             	add    $0x7c,%ebx
801042ab:	81 fb 80 4d 11 80    	cmp    $0x80114d80,%ebx
801042b1:	0f 84 81 00 00 00    	je     80104338 <procdump+0xb8>
    if(p->state == UNUSED)
801042b7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042ba:	85 c0                	test   %eax,%eax
801042bc:	74 ea                	je     801042a8 <procdump+0x28>
      state = "???";
801042be:	ba 61 79 10 80       	mov    $0x80107961,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042c3:	83 f8 05             	cmp    $0x5,%eax
801042c6:	77 11                	ja     801042d9 <procdump+0x59>
801042c8:	8b 14 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%edx
      state = "???";
801042cf:	b8 61 79 10 80       	mov    $0x80107961,%eax
801042d4:	85 d2                	test   %edx,%edx
801042d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042d9:	53                   	push   %ebx
801042da:	52                   	push   %edx
801042db:	ff 73 a4             	push   -0x5c(%ebx)
801042de:	68 65 79 10 80       	push   $0x80107965
801042e3:	e8 b8 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801042e8:	83 c4 10             	add    $0x10,%esp
801042eb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042ef:	75 a7                	jne    80104298 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042f1:	83 ec 08             	sub    $0x8,%esp
801042f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042f7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042fa:	50                   	push   %eax
801042fb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104301:	83 c0 08             	add    $0x8,%eax
80104304:	50                   	push   %eax
80104305:	e8 86 01 00 00       	call   80104490 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010430a:	83 c4 10             	add    $0x10,%esp
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
80104310:	8b 17                	mov    (%edi),%edx
80104312:	85 d2                	test   %edx,%edx
80104314:	74 82                	je     80104298 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104316:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104319:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010431c:	52                   	push   %edx
8010431d:	68 a1 76 10 80       	push   $0x801076a1
80104322:	e8 79 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104327:	83 c4 10             	add    $0x10,%esp
8010432a:	39 fe                	cmp    %edi,%esi
8010432c:	75 e2                	jne    80104310 <procdump+0x90>
8010432e:	e9 65 ff ff ff       	jmp    80104298 <procdump+0x18>
80104333:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104338:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010433b:	5b                   	pop    %ebx
8010433c:	5e                   	pop    %esi
8010433d:	5f                   	pop    %edi
8010433e:	5d                   	pop    %ebp
8010433f:	c3                   	ret

80104340 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 0c             	sub    $0xc,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010434a:	68 98 79 10 80       	push   $0x80107998
8010434f:	8d 43 04             	lea    0x4(%ebx),%eax
80104352:	50                   	push   %eax
80104353:	e8 18 01 00 00       	call   80104470 <initlock>
  lk->name = name;
80104358:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010435b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104361:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104364:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010436b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010436e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104371:	c9                   	leave
80104372:	c3                   	ret
80104373:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010437a:	00 
8010437b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104380 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104388:	8d 73 04             	lea    0x4(%ebx),%esi
8010438b:	83 ec 0c             	sub    $0xc,%esp
8010438e:	56                   	push   %esi
8010438f:	e8 ac 02 00 00       	call   80104640 <acquire>
  while (lk->locked) {
80104394:	8b 13                	mov    (%ebx),%edx
80104396:	83 c4 10             	add    $0x10,%esp
80104399:	85 d2                	test   %edx,%edx
8010439b:	74 16                	je     801043b3 <acquiresleep+0x33>
8010439d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801043a0:	83 ec 08             	sub    $0x8,%esp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
801043a5:	e8 36 fd ff ff       	call   801040e0 <sleep>
  while (lk->locked) {
801043aa:	8b 03                	mov    (%ebx),%eax
801043ac:	83 c4 10             	add    $0x10,%esp
801043af:	85 c0                	test   %eax,%eax
801043b1:	75 ed                	jne    801043a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801043b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043b9:	e8 c2 f5 ff ff       	call   80103980 <myproc>
801043be:	8b 40 10             	mov    0x10(%eax),%eax
801043c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043ca:	5b                   	pop    %ebx
801043cb:	5e                   	pop    %esi
801043cc:	5d                   	pop    %ebp
  release(&lk->lk);
801043cd:	e9 0e 02 00 00       	jmp    801045e0 <release>
801043d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043d9:	00 
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	56                   	push   %esi
801043e4:	53                   	push   %ebx
801043e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043e8:	8d 73 04             	lea    0x4(%ebx),%esi
801043eb:	83 ec 0c             	sub    $0xc,%esp
801043ee:	56                   	push   %esi
801043ef:	e8 4c 02 00 00       	call   80104640 <acquire>
  lk->locked = 0;
801043f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104401:	89 1c 24             	mov    %ebx,(%esp)
80104404:	e8 97 fd ff ff       	call   801041a0 <wakeup>
  release(&lk->lk);
80104409:	89 75 08             	mov    %esi,0x8(%ebp)
8010440c:	83 c4 10             	add    $0x10,%esp
}
8010440f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104412:	5b                   	pop    %ebx
80104413:	5e                   	pop    %esi
80104414:	5d                   	pop    %ebp
  release(&lk->lk);
80104415:	e9 c6 01 00 00       	jmp    801045e0 <release>
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	31 ff                	xor    %edi,%edi
80104426:	56                   	push   %esi
80104427:	53                   	push   %ebx
80104428:	83 ec 18             	sub    $0x18,%esp
8010442b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010442e:	8d 73 04             	lea    0x4(%ebx),%esi
80104431:	56                   	push   %esi
80104432:	e8 09 02 00 00       	call   80104640 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104437:	8b 03                	mov    (%ebx),%eax
80104439:	83 c4 10             	add    $0x10,%esp
8010443c:	85 c0                	test   %eax,%eax
8010443e:	75 18                	jne    80104458 <holdingsleep+0x38>
  release(&lk->lk);
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	56                   	push   %esi
80104444:	e8 97 01 00 00       	call   801045e0 <release>
  return r;
}
80104449:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010444c:	89 f8                	mov    %edi,%eax
8010444e:	5b                   	pop    %ebx
8010444f:	5e                   	pop    %esi
80104450:	5f                   	pop    %edi
80104451:	5d                   	pop    %ebp
80104452:	c3                   	ret
80104453:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104458:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010445b:	e8 20 f5 ff ff       	call   80103980 <myproc>
80104460:	39 58 10             	cmp    %ebx,0x10(%eax)
80104463:	0f 94 c0             	sete   %al
80104466:	0f b6 c0             	movzbl %al,%eax
80104469:	89 c7                	mov    %eax,%edi
8010446b:	eb d3                	jmp    80104440 <holdingsleep+0x20>
8010446d:	66 90                	xchg   %ax,%ax
8010446f:	90                   	nop

80104470 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104476:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010447f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104482:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104489:	5d                   	pop    %ebp
8010448a:	c3                   	ret
8010448b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104490 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104490:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104491:	31 d2                	xor    %edx,%edx
{
80104493:	89 e5                	mov    %esp,%ebp
80104495:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104496:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104499:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010449c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010449f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044ac:	77 1a                	ja     801044c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044ae:	8b 58 04             	mov    0x4(%eax),%ebx
801044b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044b9:	83 fa 0a             	cmp    $0xa,%edx
801044bc:	75 e2                	jne    801044a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c1:	c9                   	leave
801044c2:	c3                   	ret
801044c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801044c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044cb:	8d 51 28             	lea    0x28(%ecx),%edx
801044ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801044d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044d6:	83 c0 04             	add    $0x4,%eax
801044d9:	39 d0                	cmp    %edx,%eax
801044db:	75 f3                	jne    801044d0 <getcallerpcs+0x40>
}
801044dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e0:	c9                   	leave
801044e1:	c3                   	ret
801044e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044e9:	00 
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 04             	sub    $0x4,%esp
801044f7:	9c                   	pushf
801044f8:	5b                   	pop    %ebx
  asm volatile("cli");
801044f9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044fa:	e8 01 f4 ff ff       	call   80103900 <mycpu>
801044ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104505:	85 c0                	test   %eax,%eax
80104507:	74 17                	je     80104520 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104509:	e8 f2 f3 ff ff       	call   80103900 <mycpu>
8010450e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104518:	c9                   	leave
80104519:	c3                   	ret
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104520:	e8 db f3 ff ff       	call   80103900 <mycpu>
80104525:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010452b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104531:	eb d6                	jmp    80104509 <pushcli+0x19>
80104533:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010453a:	00 
8010453b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104540 <popcli>:

void
popcli(void)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104546:	9c                   	pushf
80104547:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104548:	f6 c4 02             	test   $0x2,%ah
8010454b:	75 35                	jne    80104582 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010454d:	e8 ae f3 ff ff       	call   80103900 <mycpu>
80104552:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104559:	78 34                	js     8010458f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010455b:	e8 a0 f3 ff ff       	call   80103900 <mycpu>
80104560:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104566:	85 d2                	test   %edx,%edx
80104568:	74 06                	je     80104570 <popcli+0x30>
    sti();
}
8010456a:	c9                   	leave
8010456b:	c3                   	ret
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104570:	e8 8b f3 ff ff       	call   80103900 <mycpu>
80104575:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010457b:	85 c0                	test   %eax,%eax
8010457d:	74 eb                	je     8010456a <popcli+0x2a>
  asm volatile("sti");
8010457f:	fb                   	sti
}
80104580:	c9                   	leave
80104581:	c3                   	ret
    panic("popcli - interruptible");
80104582:	83 ec 0c             	sub    $0xc,%esp
80104585:	68 a3 79 10 80       	push   $0x801079a3
8010458a:	e8 f1 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010458f:	83 ec 0c             	sub    $0xc,%esp
80104592:	68 ba 79 10 80       	push   $0x801079ba
80104597:	e8 e4 bd ff ff       	call   80100380 <panic>
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <holding>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	8b 75 08             	mov    0x8(%ebp),%esi
801045a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801045aa:	e8 41 ff ff ff       	call   801044f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045af:	8b 06                	mov    (%esi),%eax
801045b1:	85 c0                	test   %eax,%eax
801045b3:	75 0b                	jne    801045c0 <holding+0x20>
  popcli();
801045b5:	e8 86 ff ff ff       	call   80104540 <popcli>
}
801045ba:	89 d8                	mov    %ebx,%eax
801045bc:	5b                   	pop    %ebx
801045bd:	5e                   	pop    %esi
801045be:	5d                   	pop    %ebp
801045bf:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801045c0:	8b 5e 08             	mov    0x8(%esi),%ebx
801045c3:	e8 38 f3 ff ff       	call   80103900 <mycpu>
801045c8:	39 c3                	cmp    %eax,%ebx
801045ca:	0f 94 c3             	sete   %bl
  popcli();
801045cd:	e8 6e ff ff ff       	call   80104540 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801045d2:	0f b6 db             	movzbl %bl,%ebx
}
801045d5:	89 d8                	mov    %ebx,%eax
801045d7:	5b                   	pop    %ebx
801045d8:	5e                   	pop    %esi
801045d9:	5d                   	pop    %ebp
801045da:	c3                   	ret
801045db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801045e0 <release>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045e8:	e8 03 ff ff ff       	call   801044f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045ed:	8b 03                	mov    (%ebx),%eax
801045ef:	85 c0                	test   %eax,%eax
801045f1:	75 15                	jne    80104608 <release+0x28>
  popcli();
801045f3:	e8 48 ff ff ff       	call   80104540 <popcli>
    panic("release");
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 c1 79 10 80       	push   $0x801079c1
80104600:	e8 7b bd ff ff       	call   80100380 <panic>
80104605:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104608:	8b 73 08             	mov    0x8(%ebx),%esi
8010460b:	e8 f0 f2 ff ff       	call   80103900 <mycpu>
80104610:	39 c6                	cmp    %eax,%esi
80104612:	75 df                	jne    801045f3 <release+0x13>
  popcli();
80104614:	e8 27 ff ff ff       	call   80104540 <popcli>
  lk->pcs[0] = 0;
80104619:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104620:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104627:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010462c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104632:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104635:	5b                   	pop    %ebx
80104636:	5e                   	pop    %esi
80104637:	5d                   	pop    %ebp
  popcli();
80104638:	e9 03 ff ff ff       	jmp    80104540 <popcli>
8010463d:	8d 76 00             	lea    0x0(%esi),%esi

80104640 <acquire>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	53                   	push   %ebx
80104644:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104647:	e8 a4 fe ff ff       	call   801044f0 <pushcli>
  if(holding(lk))
8010464c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010464f:	e8 9c fe ff ff       	call   801044f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104654:	8b 03                	mov    (%ebx),%eax
80104656:	85 c0                	test   %eax,%eax
80104658:	75 7e                	jne    801046d8 <acquire+0x98>
  popcli();
8010465a:	e8 e1 fe ff ff       	call   80104540 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010465f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104668:	8b 55 08             	mov    0x8(%ebp),%edx
8010466b:	89 c8                	mov    %ecx,%eax
8010466d:	f0 87 02             	lock xchg %eax,(%edx)
80104670:	85 c0                	test   %eax,%eax
80104672:	75 f4                	jne    80104668 <acquire+0x28>
  __sync_synchronize();
80104674:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104679:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010467c:	e8 7f f2 ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104681:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104684:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104686:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104689:	31 c0                	xor    %eax,%eax
8010468b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104690:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104696:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010469c:	77 1a                	ja     801046b8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010469e:	8b 5a 04             	mov    0x4(%edx),%ebx
801046a1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801046a5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801046a8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801046aa:	83 f8 0a             	cmp    $0xa,%eax
801046ad:	75 e1                	jne    80104690 <acquire+0x50>
}
801046af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b2:	c9                   	leave
801046b3:	c3                   	ret
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801046b8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801046bc:	8d 51 34             	lea    0x34(%ecx),%edx
801046bf:	90                   	nop
    pcs[i] = 0;
801046c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046c6:	83 c0 04             	add    $0x4,%eax
801046c9:	39 c2                	cmp    %eax,%edx
801046cb:	75 f3                	jne    801046c0 <acquire+0x80>
}
801046cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d0:	c9                   	leave
801046d1:	c3                   	ret
801046d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046d8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801046db:	e8 20 f2 ff ff       	call   80103900 <mycpu>
801046e0:	39 c3                	cmp    %eax,%ebx
801046e2:	0f 85 72 ff ff ff    	jne    8010465a <acquire+0x1a>
  popcli();
801046e8:	e8 53 fe ff ff       	call   80104540 <popcli>
    panic("acquire");
801046ed:	83 ec 0c             	sub    $0xc,%esp
801046f0:	68 c9 79 10 80       	push   $0x801079c9
801046f5:	e8 86 bc ff ff       	call   80100380 <panic>
801046fa:	66 90                	xchg   %ax,%ax
801046fc:	66 90                	xchg   %ax,%ax
801046fe:	66 90                	xchg   %ax,%ax

80104700 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	8b 55 08             	mov    0x8(%ebp),%edx
80104707:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010470a:	53                   	push   %ebx
8010470b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010470e:	89 d7                	mov    %edx,%edi
80104710:	09 cf                	or     %ecx,%edi
80104712:	83 e7 03             	and    $0x3,%edi
80104715:	75 29                	jne    80104740 <memset+0x40>
    c &= 0xFF;
80104717:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010471a:	c1 e0 18             	shl    $0x18,%eax
8010471d:	89 fb                	mov    %edi,%ebx
8010471f:	c1 e9 02             	shr    $0x2,%ecx
80104722:	c1 e3 10             	shl    $0x10,%ebx
80104725:	09 d8                	or     %ebx,%eax
80104727:	09 f8                	or     %edi,%eax
80104729:	c1 e7 08             	shl    $0x8,%edi
8010472c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010472e:	89 d7                	mov    %edx,%edi
80104730:	fc                   	cld
80104731:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104733:	5b                   	pop    %ebx
80104734:	89 d0                	mov    %edx,%eax
80104736:	5f                   	pop    %edi
80104737:	5d                   	pop    %ebp
80104738:	c3                   	ret
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104740:	89 d7                	mov    %edx,%edi
80104742:	fc                   	cld
80104743:	f3 aa                	rep stos %al,%es:(%edi)
80104745:	5b                   	pop    %ebx
80104746:	89 d0                	mov    %edx,%eax
80104748:	5f                   	pop    %edi
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret
8010474b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104750 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	8b 75 10             	mov    0x10(%ebp),%esi
80104757:	8b 55 08             	mov    0x8(%ebp),%edx
8010475a:	53                   	push   %ebx
8010475b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010475e:	85 f6                	test   %esi,%esi
80104760:	74 2e                	je     80104790 <memcmp+0x40>
80104762:	01 c6                	add    %eax,%esi
80104764:	eb 14                	jmp    8010477a <memcmp+0x2a>
80104766:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010476d:	00 
8010476e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104770:	83 c0 01             	add    $0x1,%eax
80104773:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104776:	39 f0                	cmp    %esi,%eax
80104778:	74 16                	je     80104790 <memcmp+0x40>
    if(*s1 != *s2)
8010477a:	0f b6 0a             	movzbl (%edx),%ecx
8010477d:	0f b6 18             	movzbl (%eax),%ebx
80104780:	38 d9                	cmp    %bl,%cl
80104782:	74 ec                	je     80104770 <memcmp+0x20>
      return *s1 - *s2;
80104784:	0f b6 c1             	movzbl %cl,%eax
80104787:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104789:	5b                   	pop    %ebx
8010478a:	5e                   	pop    %esi
8010478b:	5d                   	pop    %ebp
8010478c:	c3                   	ret
8010478d:	8d 76 00             	lea    0x0(%esi),%esi
80104790:	5b                   	pop    %ebx
  return 0;
80104791:	31 c0                	xor    %eax,%eax
}
80104793:	5e                   	pop    %esi
80104794:	5d                   	pop    %ebp
80104795:	c3                   	ret
80104796:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010479d:	00 
8010479e:	66 90                	xchg   %ax,%ax

801047a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	8b 55 08             	mov    0x8(%ebp),%edx
801047a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047aa:	56                   	push   %esi
801047ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047ae:	39 d6                	cmp    %edx,%esi
801047b0:	73 26                	jae    801047d8 <memmove+0x38>
801047b2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801047b5:	39 fa                	cmp    %edi,%edx
801047b7:	73 1f                	jae    801047d8 <memmove+0x38>
801047b9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801047bc:	85 c9                	test   %ecx,%ecx
801047be:	74 0c                	je     801047cc <memmove+0x2c>
      *--d = *--s;
801047c0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801047c4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801047c7:	83 e8 01             	sub    $0x1,%eax
801047ca:	73 f4                	jae    801047c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047cc:	5e                   	pop    %esi
801047cd:	89 d0                	mov    %edx,%eax
801047cf:	5f                   	pop    %edi
801047d0:	5d                   	pop    %ebp
801047d1:	c3                   	ret
801047d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801047d8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801047db:	89 d7                	mov    %edx,%edi
801047dd:	85 c9                	test   %ecx,%ecx
801047df:	74 eb                	je     801047cc <memmove+0x2c>
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047e8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047e9:	39 c6                	cmp    %eax,%esi
801047eb:	75 fb                	jne    801047e8 <memmove+0x48>
}
801047ed:	5e                   	pop    %esi
801047ee:	89 d0                	mov    %edx,%eax
801047f0:	5f                   	pop    %edi
801047f1:	5d                   	pop    %ebp
801047f2:	c3                   	ret
801047f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047fa:	00 
801047fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104800 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104800:	eb 9e                	jmp    801047a0 <memmove>
80104802:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104809:	00 
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104810 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	8b 75 10             	mov    0x10(%ebp),%esi
80104817:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010481a:	53                   	push   %ebx
8010481b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010481e:	85 f6                	test   %esi,%esi
80104820:	74 2e                	je     80104850 <strncmp+0x40>
80104822:	01 d6                	add    %edx,%esi
80104824:	eb 18                	jmp    8010483e <strncmp+0x2e>
80104826:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010482d:	00 
8010482e:	66 90                	xchg   %ax,%ax
80104830:	38 d8                	cmp    %bl,%al
80104832:	75 14                	jne    80104848 <strncmp+0x38>
    n--, p++, q++;
80104834:	83 c2 01             	add    $0x1,%edx
80104837:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010483a:	39 f2                	cmp    %esi,%edx
8010483c:	74 12                	je     80104850 <strncmp+0x40>
8010483e:	0f b6 01             	movzbl (%ecx),%eax
80104841:	0f b6 1a             	movzbl (%edx),%ebx
80104844:	84 c0                	test   %al,%al
80104846:	75 e8                	jne    80104830 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104848:	29 d8                	sub    %ebx,%eax
}
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5d                   	pop    %ebp
8010484d:	c3                   	ret
8010484e:	66 90                	xchg   %ax,%ax
80104850:	5b                   	pop    %ebx
    return 0;
80104851:	31 c0                	xor    %eax,%eax
}
80104853:	5e                   	pop    %esi
80104854:	5d                   	pop    %ebp
80104855:	c3                   	ret
80104856:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010485d:	00 
8010485e:	66 90                	xchg   %ax,%ax

80104860 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	56                   	push   %esi
80104865:	8b 75 08             	mov    0x8(%ebp),%esi
80104868:	53                   	push   %ebx
80104869:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010486c:	89 f0                	mov    %esi,%eax
8010486e:	eb 15                	jmp    80104885 <strncpy+0x25>
80104870:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104874:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104877:	83 c0 01             	add    $0x1,%eax
8010487a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010487e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104881:	84 d2                	test   %dl,%dl
80104883:	74 09                	je     8010488e <strncpy+0x2e>
80104885:	89 cb                	mov    %ecx,%ebx
80104887:	83 e9 01             	sub    $0x1,%ecx
8010488a:	85 db                	test   %ebx,%ebx
8010488c:	7f e2                	jg     80104870 <strncpy+0x10>
    ;
  while(n-- > 0)
8010488e:	89 c2                	mov    %eax,%edx
80104890:	85 c9                	test   %ecx,%ecx
80104892:	7e 17                	jle    801048ab <strncpy+0x4b>
80104894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104898:	83 c2 01             	add    $0x1,%edx
8010489b:	89 c1                	mov    %eax,%ecx
8010489d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801048a1:	29 d1                	sub    %edx,%ecx
801048a3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801048a7:	85 c9                	test   %ecx,%ecx
801048a9:	7f ed                	jg     80104898 <strncpy+0x38>
  return os;
}
801048ab:	5b                   	pop    %ebx
801048ac:	89 f0                	mov    %esi,%eax
801048ae:	5e                   	pop    %esi
801048af:	5f                   	pop    %edi
801048b0:	5d                   	pop    %ebp
801048b1:	c3                   	ret
801048b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048b9:	00 
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	8b 55 10             	mov    0x10(%ebp),%edx
801048c7:	8b 75 08             	mov    0x8(%ebp),%esi
801048ca:	53                   	push   %ebx
801048cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048ce:	85 d2                	test   %edx,%edx
801048d0:	7e 25                	jle    801048f7 <safestrcpy+0x37>
801048d2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801048d6:	89 f2                	mov    %esi,%edx
801048d8:	eb 16                	jmp    801048f0 <safestrcpy+0x30>
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048e0:	0f b6 08             	movzbl (%eax),%ecx
801048e3:	83 c0 01             	add    $0x1,%eax
801048e6:	83 c2 01             	add    $0x1,%edx
801048e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048ec:	84 c9                	test   %cl,%cl
801048ee:	74 04                	je     801048f4 <safestrcpy+0x34>
801048f0:	39 d8                	cmp    %ebx,%eax
801048f2:	75 ec                	jne    801048e0 <safestrcpy+0x20>
    ;
  *s = 0;
801048f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048f7:	89 f0                	mov    %esi,%eax
801048f9:	5b                   	pop    %ebx
801048fa:	5e                   	pop    %esi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret
801048fd:	8d 76 00             	lea    0x0(%esi),%esi

80104900 <strlen>:

int
strlen(const char *s)
{
80104900:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104901:	31 c0                	xor    %eax,%eax
{
80104903:	89 e5                	mov    %esp,%ebp
80104905:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104908:	80 3a 00             	cmpb   $0x0,(%edx)
8010490b:	74 0c                	je     80104919 <strlen+0x19>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
80104910:	83 c0 01             	add    $0x1,%eax
80104913:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104917:	75 f7                	jne    80104910 <strlen+0x10>
    ;
  return n;
}
80104919:	5d                   	pop    %ebp
8010491a:	c3                   	ret

8010491b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010491b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010491f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104923:	55                   	push   %ebp
  pushl %ebx
80104924:	53                   	push   %ebx
  pushl %esi
80104925:	56                   	push   %esi
  pushl %edi
80104926:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104927:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104929:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010492b:	5f                   	pop    %edi
  popl %esi
8010492c:	5e                   	pop    %esi
  popl %ebx
8010492d:	5b                   	pop    %ebx
  popl %ebp
8010492e:	5d                   	pop    %ebp
  ret
8010492f:	c3                   	ret

80104930 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010493a:	e8 41 f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010493f:	8b 00                	mov    (%eax),%eax
80104941:	39 d8                	cmp    %ebx,%eax
80104943:	76 1b                	jbe    80104960 <fetchint+0x30>
80104945:	8d 53 04             	lea    0x4(%ebx),%edx
80104948:	39 d0                	cmp    %edx,%eax
8010494a:	72 14                	jb     80104960 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010494c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010494f:	8b 13                	mov    (%ebx),%edx
80104951:	89 10                	mov    %edx,(%eax)
  return 0;
80104953:	31 c0                	xor    %eax,%eax
}
80104955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104958:	c9                   	leave
80104959:	c3                   	ret
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104965:	eb ee                	jmp    80104955 <fetchint+0x25>
80104967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010496e:	00 
8010496f:	90                   	nop

80104970 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010497a:	e8 01 f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
8010497f:	39 18                	cmp    %ebx,(%eax)
80104981:	76 2d                	jbe    801049b0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104983:	8b 55 0c             	mov    0xc(%ebp),%edx
80104986:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104988:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010498a:	39 d3                	cmp    %edx,%ebx
8010498c:	73 22                	jae    801049b0 <fetchstr+0x40>
8010498e:	89 d8                	mov    %ebx,%eax
80104990:	eb 0d                	jmp    8010499f <fetchstr+0x2f>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104998:	83 c0 01             	add    $0x1,%eax
8010499b:	39 c2                	cmp    %eax,%edx
8010499d:	76 11                	jbe    801049b0 <fetchstr+0x40>
    if(*s == 0)
8010499f:	80 38 00             	cmpb   $0x0,(%eax)
801049a2:	75 f4                	jne    80104998 <fetchstr+0x28>
      return s - *pp;
801049a4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801049a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a9:	c9                   	leave
801049aa:	c3                   	ret
801049ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801049b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049b8:	c9                   	leave
801049b9:	c3                   	ret
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049c5:	e8 b6 ef ff ff       	call   80103980 <myproc>
801049ca:	8b 55 08             	mov    0x8(%ebp),%edx
801049cd:	8b 40 18             	mov    0x18(%eax),%eax
801049d0:	8b 40 44             	mov    0x44(%eax),%eax
801049d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049d6:	e8 a5 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049db:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049de:	8b 00                	mov    (%eax),%eax
801049e0:	39 c6                	cmp    %eax,%esi
801049e2:	73 1c                	jae    80104a00 <argint+0x40>
801049e4:	8d 53 08             	lea    0x8(%ebx),%edx
801049e7:	39 d0                	cmp    %edx,%eax
801049e9:	72 15                	jb     80104a00 <argint+0x40>
  *ip = *(int*)(addr);
801049eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ee:	8b 53 04             	mov    0x4(%ebx),%edx
801049f1:	89 10                	mov    %edx,(%eax)
  return 0;
801049f3:	31 c0                	xor    %eax,%eax
}
801049f5:	5b                   	pop    %ebx
801049f6:	5e                   	pop    %esi
801049f7:	5d                   	pop    %ebp
801049f8:	c3                   	ret
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a05:	eb ee                	jmp    801049f5 <argint+0x35>
80104a07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a0e:	00 
80104a0f:	90                   	nop

80104a10 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	56                   	push   %esi
80104a15:	53                   	push   %ebx
80104a16:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104a19:	e8 62 ef ff ff       	call   80103980 <myproc>
80104a1e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a20:	e8 5b ef ff ff       	call   80103980 <myproc>
80104a25:	8b 55 08             	mov    0x8(%ebp),%edx
80104a28:	8b 40 18             	mov    0x18(%eax),%eax
80104a2b:	8b 40 44             	mov    0x44(%eax),%eax
80104a2e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a31:	e8 4a ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a36:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a39:	8b 00                	mov    (%eax),%eax
80104a3b:	39 c7                	cmp    %eax,%edi
80104a3d:	73 31                	jae    80104a70 <argptr+0x60>
80104a3f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104a42:	39 c8                	cmp    %ecx,%eax
80104a44:	72 2a                	jb     80104a70 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a46:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104a49:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a4c:	85 d2                	test   %edx,%edx
80104a4e:	78 20                	js     80104a70 <argptr+0x60>
80104a50:	8b 16                	mov    (%esi),%edx
80104a52:	39 c2                	cmp    %eax,%edx
80104a54:	76 1a                	jbe    80104a70 <argptr+0x60>
80104a56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a59:	01 c3                	add    %eax,%ebx
80104a5b:	39 da                	cmp    %ebx,%edx
80104a5d:	72 11                	jb     80104a70 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a62:	89 02                	mov    %eax,(%edx)
  return 0;
80104a64:	31 c0                	xor    %eax,%eax
}
80104a66:	83 c4 0c             	add    $0xc,%esp
80104a69:	5b                   	pop    %ebx
80104a6a:	5e                   	pop    %esi
80104a6b:	5f                   	pop    %edi
80104a6c:	5d                   	pop    %ebp
80104a6d:	c3                   	ret
80104a6e:	66 90                	xchg   %ax,%ax
    return -1;
80104a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a75:	eb ef                	jmp    80104a66 <argptr+0x56>
80104a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a7e:	00 
80104a7f:	90                   	nop

80104a80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a85:	e8 f6 ee ff ff       	call   80103980 <myproc>
80104a8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a8d:	8b 40 18             	mov    0x18(%eax),%eax
80104a90:	8b 40 44             	mov    0x44(%eax),%eax
80104a93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a96:	e8 e5 ee ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a9e:	8b 00                	mov    (%eax),%eax
80104aa0:	39 c6                	cmp    %eax,%esi
80104aa2:	73 44                	jae    80104ae8 <argstr+0x68>
80104aa4:	8d 53 08             	lea    0x8(%ebx),%edx
80104aa7:	39 d0                	cmp    %edx,%eax
80104aa9:	72 3d                	jb     80104ae8 <argstr+0x68>
  *ip = *(int*)(addr);
80104aab:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104aae:	e8 cd ee ff ff       	call   80103980 <myproc>
  if(addr >= curproc->sz)
80104ab3:	3b 18                	cmp    (%eax),%ebx
80104ab5:	73 31                	jae    80104ae8 <argstr+0x68>
  *pp = (char*)addr;
80104ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104aba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104abc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104abe:	39 d3                	cmp    %edx,%ebx
80104ac0:	73 26                	jae    80104ae8 <argstr+0x68>
80104ac2:	89 d8                	mov    %ebx,%eax
80104ac4:	eb 11                	jmp    80104ad7 <argstr+0x57>
80104ac6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104acd:	00 
80104ace:	66 90                	xchg   %ax,%ax
80104ad0:	83 c0 01             	add    $0x1,%eax
80104ad3:	39 c2                	cmp    %eax,%edx
80104ad5:	76 11                	jbe    80104ae8 <argstr+0x68>
    if(*s == 0)
80104ad7:	80 38 00             	cmpb   $0x0,(%eax)
80104ada:	75 f4                	jne    80104ad0 <argstr+0x50>
      return s - *pp;
80104adc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104ade:	5b                   	pop    %ebx
80104adf:	5e                   	pop    %esi
80104ae0:	5d                   	pop    %ebp
80104ae1:	c3                   	ret
80104ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ae8:	5b                   	pop    %ebx
    return -1;
80104ae9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aee:	5e                   	pop    %esi
80104aef:	5d                   	pop    %ebp
80104af0:	c3                   	ret
80104af1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104af8:	00 
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b00 <strcmp>:

// Helper function for comparing two strings.
int
strcmp(const char *p, const char *q)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	8b 55 08             	mov    0x8(%ebp),%edx
80104b07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
80104b0a:	0f b6 02             	movzbl (%edx),%eax
80104b0d:	84 c0                	test   %al,%al
80104b0f:	75 17                	jne    80104b28 <strcmp+0x28>
80104b11:	eb 3a                	jmp    80104b4d <strcmp+0x4d>
80104b13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b18:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
80104b1c:	83 c2 01             	add    $0x1,%edx
80104b1f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
80104b22:	84 c0                	test   %al,%al
80104b24:	74 1a                	je     80104b40 <strcmp+0x40>
    p++, q++;
80104b26:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
80104b28:	0f b6 19             	movzbl (%ecx),%ebx
80104b2b:	38 c3                	cmp    %al,%bl
80104b2d:	74 e9                	je     80104b18 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
80104b2f:	29 d8                	sub    %ebx,%eax
}
80104b31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b34:	c9                   	leave
80104b35:	c3                   	ret
80104b36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b3d:	00 
80104b3e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
80104b40:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
80104b44:	31 c0                	xor    %eax,%eax
80104b46:	29 d8                	sub    %ebx,%eax
}
80104b48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b4b:	c9                   	leave
80104b4c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
80104b4d:	0f b6 19             	movzbl (%ecx),%ebx
80104b50:	31 c0                	xor    %eax,%eax
80104b52:	eb db                	jmp    80104b2f <strcmp+0x2f>
80104b54:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b5b:	00 
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <syscall>:
[SYS_block]   sys_block,
[SYS_unblock]   sys_unblock,
[SYS_chmod]   sys_chmod,     
};

void syscall(void) {
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b67:	e8 14 ee ff ff       	call   80103980 <myproc>
80104b6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b6e:	8b 40 18             	mov    0x18(%eax),%eax
80104b71:	8b 40 1c             	mov    0x1c(%eax),%eax

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b77:	83 fa 18             	cmp    $0x18,%edx
80104b7a:	77 34                	ja     80104bb0 <syscall+0x50>
80104b7c:	8b 14 85 c0 7f 10 80 	mov    -0x7fef8040(,%eax,4),%edx
80104b83:	85 d2                	test   %edx,%edx
80104b85:	74 29                	je     80104bb0 <syscall+0x50>
    // Check if the syscall is blocked
    if (blocked_syscalls[num] && num != SYS_exec) {
80104b87:	8b 0c 85 a0 56 11 80 	mov    -0x7feea960(,%eax,4),%ecx
80104b8e:	85 c9                	test   %ecx,%ecx
80104b90:	74 05                	je     80104b97 <syscall+0x37>
80104b92:	83 f8 07             	cmp    $0x7,%eax
80104b95:	75 41                	jne    80104bd8 <syscall+0x78>
      cprintf("syscall %d is blocked\n", num);
      curproc->tf->eax = -1;  // Return error
      return;
    }

    curproc->tf->eax = syscalls[num]();
80104b97:	ff d2                	call   *%edx
80104b99:	89 c2                	mov    %eax,%edx
80104b9b:	8b 43 18             	mov    0x18(%ebx),%eax
80104b9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba4:	c9                   	leave
80104ba5:	c3                   	ret
80104ba6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bad:	00 
80104bae:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104bb0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104bb1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bb4:	50                   	push   %eax
80104bb5:	ff 73 10             	push   0x10(%ebx)
80104bb8:	68 e8 79 10 80       	push   $0x801079e8
80104bbd:	e8 de ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104bc2:	8b 43 18             	mov    0x18(%ebx),%eax
80104bc5:	83 c4 10             	add    $0x10,%esp
80104bc8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd2:	c9                   	leave
80104bd3:	c3                   	ret
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("syscall %d is blocked\n", num);
80104bd8:	83 ec 08             	sub    $0x8,%esp
80104bdb:	50                   	push   %eax
80104bdc:	68 d1 79 10 80       	push   $0x801079d1
80104be1:	e8 ba ba ff ff       	call   801006a0 <cprintf>
      curproc->tf->eax = -1;  // Return error
80104be6:	8b 43 18             	mov    0x18(%ebx),%eax
      return;
80104be9:	83 c4 10             	add    $0x10,%esp
      curproc->tf->eax = -1;  // Return error
80104bec:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
      return;
80104bf3:	eb da                	jmp    80104bcf <syscall+0x6f>
80104bf5:	66 90                	xchg   %ax,%ax
80104bf7:	66 90                	xchg   %ax,%ax
80104bf9:	66 90                	xchg   %ax,%ax
80104bfb:	66 90                	xchg   %ax,%ax
80104bfd:	66 90                	xchg   %ax,%ax
80104bff:	90                   	nop

80104c00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	57                   	push   %edi
80104c04:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c08:	53                   	push   %ebx
80104c09:	83 ec 34             	sub    $0x34,%esp
80104c0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c12:	57                   	push   %edi
80104c13:	50                   	push   %eax
{
80104c14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c1a:	e8 b1 d4 ff ff       	call   801020d0 <nameiparent>
80104c1f:	83 c4 10             	add    $0x10,%esp
80104c22:	85 c0                	test   %eax,%eax
80104c24:	0f 84 4e 01 00 00    	je     80104d78 <create+0x178>
    return 0;
  ilock(dp);
80104c2a:	83 ec 0c             	sub    $0xc,%esp
80104c2d:	89 c3                	mov    %eax,%ebx
80104c2f:	50                   	push   %eax
80104c30:	e8 5b cb ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c35:	83 c4 0c             	add    $0xc,%esp
80104c38:	6a 00                	push   $0x0
80104c3a:	57                   	push   %edi
80104c3b:	53                   	push   %ebx
80104c3c:	e8 af d0 ff ff       	call   80101cf0 <dirlookup>
80104c41:	83 c4 10             	add    $0x10,%esp
80104c44:	89 c6                	mov    %eax,%esi
80104c46:	85 c0                	test   %eax,%eax
80104c48:	74 56                	je     80104ca0 <create+0xa0>
    iunlockput(dp);
80104c4a:	83 ec 0c             	sub    $0xc,%esp
80104c4d:	53                   	push   %ebx
80104c4e:	e8 cd cd ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104c53:	89 34 24             	mov    %esi,(%esp)
80104c56:	e8 35 cb ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c5b:	83 c4 10             	add    $0x10,%esp
80104c5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c63:	75 1b                	jne    80104c80 <create+0x80>
80104c65:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c6a:	75 14                	jne    80104c80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c6f:	89 f0                	mov    %esi,%eax
80104c71:	5b                   	pop    %ebx
80104c72:	5e                   	pop    %esi
80104c73:	5f                   	pop    %edi
80104c74:	5d                   	pop    %ebp
80104c75:	c3                   	ret
80104c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c7d:	00 
80104c7e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	56                   	push   %esi
    return 0;
80104c84:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c86:	e8 95 cd ff ff       	call   80101a20 <iunlockput>
    return 0;
80104c8b:	83 c4 10             	add    $0x10,%esp
}
80104c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c91:	89 f0                	mov    %esi,%eax
80104c93:	5b                   	pop    %ebx
80104c94:	5e                   	pop    %esi
80104c95:	5f                   	pop    %edi
80104c96:	5d                   	pop    %ebp
80104c97:	c3                   	ret
80104c98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c9f:	00 
  if((ip = ialloc(dp->dev, type)) == 0)
80104ca0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ca4:	83 ec 08             	sub    $0x8,%esp
80104ca7:	50                   	push   %eax
80104ca8:	ff 33                	push   (%ebx)
80104caa:	e8 61 c9 ff ff       	call   80101610 <ialloc>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	89 c6                	mov    %eax,%esi
80104cb4:	85 c0                	test   %eax,%eax
80104cb6:	0f 84 d5 00 00 00    	je     80104d91 <create+0x191>
  ilock(ip);
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	50                   	push   %eax
80104cc0:	e8 cb ca ff ff       	call   80101790 <ilock>
  ip->major = major;
80104cc5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->mode = 7;   // // rwx (read, write, execute) for directories and files
80104cc9:	c7 86 90 00 00 00 07 	movl   $0x7,0x90(%esi)
80104cd0:	00 00 00 
  ip->major = major;
80104cd3:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104cd7:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104cdb:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104cdf:	b8 01 00 00 00       	mov    $0x1,%eax
80104ce4:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104ce8:	89 34 24             	mov    %esi,(%esp)
80104ceb:	e8 e0 c9 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cf0:	83 c4 10             	add    $0x10,%esp
80104cf3:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104cf8:	74 2e                	je     80104d28 <create+0x128>
  if(dirlink(dp, name, ip->inum) < 0)
80104cfa:	83 ec 04             	sub    $0x4,%esp
80104cfd:	ff 76 04             	push   0x4(%esi)
80104d00:	57                   	push   %edi
80104d01:	53                   	push   %ebx
80104d02:	e8 e9 d2 ff ff       	call   80101ff0 <dirlink>
80104d07:	83 c4 10             	add    $0x10,%esp
80104d0a:	85 c0                	test   %eax,%eax
80104d0c:	78 76                	js     80104d84 <create+0x184>
  iunlockput(dp);
80104d0e:	83 ec 0c             	sub    $0xc,%esp
80104d11:	53                   	push   %ebx
80104d12:	e8 09 cd ff ff       	call   80101a20 <iunlockput>
  return ip;
80104d17:	83 c4 10             	add    $0x10,%esp
}
80104d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d1d:	89 f0                	mov    %esi,%eax
80104d1f:	5b                   	pop    %ebx
80104d20:	5e                   	pop    %esi
80104d21:	5f                   	pop    %edi
80104d22:	5d                   	pop    %ebp
80104d23:	c3                   	ret
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iupdate(dp);
80104d28:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d2b:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d30:	53                   	push   %ebx
80104d31:	e8 9a c9 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d36:	83 c4 0c             	add    $0xc,%esp
80104d39:	ff 76 04             	push   0x4(%esi)
80104d3c:	68 20 7a 10 80       	push   $0x80107a20
80104d41:	56                   	push   %esi
80104d42:	e8 a9 d2 ff ff       	call   80101ff0 <dirlink>
80104d47:	83 c4 10             	add    $0x10,%esp
80104d4a:	85 c0                	test   %eax,%eax
80104d4c:	78 18                	js     80104d66 <create+0x166>
80104d4e:	83 ec 04             	sub    $0x4,%esp
80104d51:	ff 73 04             	push   0x4(%ebx)
80104d54:	68 1f 7a 10 80       	push   $0x80107a1f
80104d59:	56                   	push   %esi
80104d5a:	e8 91 d2 ff ff       	call   80101ff0 <dirlink>
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	85 c0                	test   %eax,%eax
80104d64:	79 94                	jns    80104cfa <create+0xfa>
      panic("create dots");
80104d66:	83 ec 0c             	sub    $0xc,%esp
80104d69:	68 13 7a 10 80       	push   $0x80107a13
80104d6e:	e8 0d b6 ff ff       	call   80100380 <panic>
80104d73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80104d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d7b:	31 f6                	xor    %esi,%esi
}
80104d7d:	5b                   	pop    %ebx
80104d7e:	89 f0                	mov    %esi,%eax
80104d80:	5e                   	pop    %esi
80104d81:	5f                   	pop    %edi
80104d82:	5d                   	pop    %ebp
80104d83:	c3                   	ret
    panic("create: dirlink");
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	68 22 7a 10 80       	push   $0x80107a22
80104d8c:	e8 ef b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104d91:	83 ec 0c             	sub    $0xc,%esp
80104d94:	68 04 7a 10 80       	push   $0x80107a04
80104d99:	e8 e2 b5 ff ff       	call   80100380 <panic>
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <sys_dup>:
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104da5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104da8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dab:	50                   	push   %eax
80104dac:	6a 00                	push   $0x0
80104dae:	e8 0d fc ff ff       	call   801049c0 <argint>
80104db3:	83 c4 10             	add    $0x10,%esp
80104db6:	85 c0                	test   %eax,%eax
80104db8:	78 36                	js     80104df0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dbe:	77 30                	ja     80104df0 <sys_dup+0x50>
80104dc0:	e8 bb eb ff ff       	call   80103980 <myproc>
80104dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dcc:	85 f6                	test   %esi,%esi
80104dce:	74 20                	je     80104df0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104dd0:	e8 ab eb ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104dd5:	31 db                	xor    %ebx,%ebx
80104dd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dde:	00 
80104ddf:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104de0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104de4:	85 d2                	test   %edx,%edx
80104de6:	74 18                	je     80104e00 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104de8:	83 c3 01             	add    $0x1,%ebx
80104deb:	83 fb 10             	cmp    $0x10,%ebx
80104dee:	75 f0                	jne    80104de0 <sys_dup+0x40>
}
80104df0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104df3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104df8:	89 d8                	mov    %ebx,%eax
80104dfa:	5b                   	pop    %ebx
80104dfb:	5e                   	pop    %esi
80104dfc:	5d                   	pop    %ebp
80104dfd:	c3                   	ret
80104dfe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e00:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e03:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e07:	56                   	push   %esi
80104e08:	e8 93 c0 ff ff       	call   80100ea0 <filedup>
  return fd;
80104e0d:	83 c4 10             	add    $0x10,%esp
}
80104e10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e13:	89 d8                	mov    %ebx,%eax
80104e15:	5b                   	pop    %ebx
80104e16:	5e                   	pop    %esi
80104e17:	5d                   	pop    %ebp
80104e18:	c3                   	ret
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e20 <sys_read>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e25:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80104e28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e2b:	56                   	push   %esi
80104e2c:	6a 00                	push   $0x0
80104e2e:	e8 8d fb ff ff       	call   801049c0 <argint>
80104e33:	83 c4 10             	add    $0x10,%esp
80104e36:	85 c0                	test   %eax,%eax
80104e38:	0f 88 a2 00 00 00    	js     80104ee0 <sys_read+0xc0>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e42:	0f 87 98 00 00 00    	ja     80104ee0 <sys_read+0xc0>
80104e48:	e8 33 eb ff ff       	call   80103980 <myproc>
80104e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e50:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
80104e54:	85 db                	test   %ebx,%ebx
80104e56:	0f 84 84 00 00 00    	je     80104ee0 <sys_read+0xc0>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e5c:	83 ec 08             	sub    $0x8,%esp
80104e5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e62:	50                   	push   %eax
80104e63:	6a 02                	push   $0x2
80104e65:	e8 56 fb ff ff       	call   801049c0 <argint>
80104e6a:	83 c4 10             	add    $0x10,%esp
80104e6d:	85 c0                	test   %eax,%eax
80104e6f:	78 6f                	js     80104ee0 <sys_read+0xc0>
80104e71:	83 ec 04             	sub    $0x4,%esp
80104e74:	ff 75 f0             	push   -0x10(%ebp)
80104e77:	56                   	push   %esi
80104e78:	6a 01                	push   $0x1
80104e7a:	e8 91 fb ff ff       	call   80104a10 <argptr>
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	85 c0                	test   %eax,%eax
80104e84:	78 5a                	js     80104ee0 <sys_read+0xc0>
  ilock(f->ip);
80104e86:	83 ec 0c             	sub    $0xc,%esp
80104e89:	ff 73 10             	push   0x10(%ebx)
80104e8c:	e8 ff c8 ff ff       	call   80101790 <ilock>
  if (!(f->ip->mode & 4)) {  // Check if Read permission is missing
80104e91:	8b 43 10             	mov    0x10(%ebx),%eax
80104e94:	83 c4 10             	add    $0x10,%esp
80104e97:	f6 80 90 00 00 00 04 	testb  $0x4,0x90(%eax)
80104e9e:	74 22                	je     80104ec2 <sys_read+0xa2>
  iunlock(f->ip);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
80104ea3:	50                   	push   %eax
80104ea4:	e8 c7 c9 ff ff       	call   80101870 <iunlock>
  return fileread(f, p, n);
80104ea9:	83 c4 0c             	add    $0xc,%esp
80104eac:	ff 75 f0             	push   -0x10(%ebp)
80104eaf:	ff 75 f4             	push   -0xc(%ebp)
80104eb2:	53                   	push   %ebx
80104eb3:	e8 68 c1 ff ff       	call   80101020 <fileread>
80104eb8:	83 c4 10             	add    $0x10,%esp
}
80104ebb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ebe:	5b                   	pop    %ebx
80104ebf:	5e                   	pop    %esi
80104ec0:	5d                   	pop    %ebp
80104ec1:	c3                   	ret
    iunlock(f->ip);
80104ec2:	83 ec 0c             	sub    $0xc,%esp
80104ec5:	50                   	push   %eax
80104ec6:	e8 a5 c9 ff ff       	call   80101870 <iunlock>
    cprintf("Operation read failed\n");
80104ecb:	c7 04 24 32 7a 10 80 	movl   $0x80107a32,(%esp)
80104ed2:	e8 c9 b7 ff ff       	call   801006a0 <cprintf>
    return -1;
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee5:	eb d4                	jmp    80104ebb <sys_read+0x9b>
80104ee7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104eee:	00 
80104eef:	90                   	nop

80104ef0 <sys_write>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ef5:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80104ef8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104efb:	56                   	push   %esi
80104efc:	6a 00                	push   $0x0
80104efe:	e8 bd fa ff ff       	call   801049c0 <argint>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	0f 88 ca 00 00 00    	js     80104fd8 <sys_write+0xe8>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f12:	0f 87 c0 00 00 00    	ja     80104fd8 <sys_write+0xe8>
80104f18:	e8 63 ea ff ff       	call   80103980 <myproc>
80104f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f20:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
80104f24:	85 db                	test   %ebx,%ebx
80104f26:	0f 84 ac 00 00 00    	je     80104fd8 <sys_write+0xe8>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f2c:	83 ec 08             	sub    $0x8,%esp
80104f2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f32:	50                   	push   %eax
80104f33:	6a 02                	push   $0x2
80104f35:	e8 86 fa ff ff       	call   801049c0 <argint>
80104f3a:	83 c4 10             	add    $0x10,%esp
80104f3d:	85 c0                	test   %eax,%eax
80104f3f:	0f 88 93 00 00 00    	js     80104fd8 <sys_write+0xe8>
80104f45:	83 ec 04             	sub    $0x4,%esp
80104f48:	ff 75 f0             	push   -0x10(%ebp)
80104f4b:	56                   	push   %esi
80104f4c:	6a 01                	push   $0x1
80104f4e:	e8 bd fa ff ff       	call   80104a10 <argptr>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 7e                	js     80104fd8 <sys_write+0xe8>
  ilock(f->ip);
80104f5a:	83 ec 0c             	sub    $0xc,%esp
80104f5d:	ff 73 10             	push   0x10(%ebx)
80104f60:	e8 2b c8 ff ff       	call   80101790 <ilock>
  if (!(f->ip->mode & 2)) {  // Check Write Permission (w = bit 1)
80104f65:	8b 43 10             	mov    0x10(%ebx),%eax
80104f68:	83 c4 10             	add    $0x10,%esp
80104f6b:	f6 80 90 00 00 00 02 	testb  $0x2,0x90(%eax)
80104f72:	74 2c                	je     80104fa0 <sys_write+0xb0>
  iunlock(f->ip);
80104f74:	83 ec 0c             	sub    $0xc,%esp
80104f77:	50                   	push   %eax
80104f78:	e8 f3 c8 ff ff       	call   80101870 <iunlock>
  return filewrite(f, p, n);
80104f7d:	83 c4 0c             	add    $0xc,%esp
80104f80:	ff 75 f0             	push   -0x10(%ebp)
80104f83:	ff 75 f4             	push   -0xc(%ebp)
80104f86:	53                   	push   %ebx
  last_failed_fd = -1;  // Reset if write succeeds
80104f87:	c7 05 08 b0 10 80 ff 	movl   $0xffffffff,0x8010b008
80104f8e:	ff ff ff 
  return filewrite(f, p, n);
80104f91:	e8 1a c1 ff ff       	call   801010b0 <filewrite>
80104f96:	83 c4 10             	add    $0x10,%esp
}
80104f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f9c:	5b                   	pop    %ebx
80104f9d:	5e                   	pop    %esi
80104f9e:	5d                   	pop    %ebp
80104f9f:	c3                   	ret
    iunlock(f->ip);
80104fa0:	83 ec 0c             	sub    $0xc,%esp
80104fa3:	50                   	push   %eax
80104fa4:	e8 c7 c8 ff ff       	call   80101870 <iunlock>
    if (last_failed_fd != f->ip->inum) {  // Only print once per file
80104fa9:	8b 43 10             	mov    0x10(%ebx),%eax
80104fac:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
80104fb2:	83 c4 10             	add    $0x10,%esp
80104fb5:	39 48 04             	cmp    %ecx,0x4(%eax)
80104fb8:	74 1e                	je     80104fd8 <sys_write+0xe8>
      cprintf("Operation write failed\n");
80104fba:	83 ec 0c             	sub    $0xc,%esp
80104fbd:	68 49 7a 10 80       	push   $0x80107a49
80104fc2:	e8 d9 b6 ff ff       	call   801006a0 <cprintf>
      last_failed_fd = f->ip->inum;
80104fc7:	8b 43 10             	mov    0x10(%ebx),%eax
80104fca:	83 c4 10             	add    $0x10,%esp
80104fcd:	8b 40 04             	mov    0x4(%eax),%eax
80104fd0:	a3 08 b0 10 80       	mov    %eax,0x8010b008
80104fd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;  // ❌ No write permission
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ba                	jmp    80104f99 <sys_write+0xa9>
80104fdf:	90                   	nop

80104fe0 <sys_close>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	50                   	push   %eax
80104fec:	6a 00                	push   $0x0
80104fee:	e8 cd f9 ff ff       	call   801049c0 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 3e                	js     80105038 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 38                	ja     80105038 <sys_close+0x58>
80105000:	e8 7b e9 ff ff       	call   80103980 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8d 5a 08             	lea    0x8(%edx),%ebx
8010500b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010500f:	85 f6                	test   %esi,%esi
80105011:	74 25                	je     80105038 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105013:	e8 68 e9 ff ff       	call   80103980 <myproc>
  fileclose(f);
80105018:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010501b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105022:	00 
  fileclose(f);
80105023:	56                   	push   %esi
80105024:	e8 c7 be ff ff       	call   80100ef0 <fileclose>
  return 0;
80105029:	83 c4 10             	add    $0x10,%esp
8010502c:	31 c0                	xor    %eax,%eax
}
8010502e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105031:	5b                   	pop    %ebx
80105032:	5e                   	pop    %esi
80105033:	5d                   	pop    %ebp
80105034:	c3                   	ret
80105035:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503d:	eb ef                	jmp    8010502e <sys_close+0x4e>
8010503f:	90                   	nop

80105040 <sys_fstat>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105045:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105048:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010504b:	53                   	push   %ebx
8010504c:	6a 00                	push   $0x0
8010504e:	e8 6d f9 ff ff       	call   801049c0 <argint>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	78 46                	js     801050a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010505a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010505e:	77 40                	ja     801050a0 <sys_fstat+0x60>
80105060:	e8 1b e9 ff ff       	call   80103980 <myproc>
80105065:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105068:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010506c:	85 f6                	test   %esi,%esi
8010506e:	74 30                	je     801050a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105070:	83 ec 04             	sub    $0x4,%esp
80105073:	6a 14                	push   $0x14
80105075:	53                   	push   %ebx
80105076:	6a 01                	push   $0x1
80105078:	e8 93 f9 ff ff       	call   80104a10 <argptr>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	78 1c                	js     801050a0 <sys_fstat+0x60>
  return filestat(f, st);
80105084:	83 ec 08             	sub    $0x8,%esp
80105087:	ff 75 f4             	push   -0xc(%ebp)
8010508a:	56                   	push   %esi
8010508b:	e8 40 bf ff ff       	call   80100fd0 <filestat>
80105090:	83 c4 10             	add    $0x10,%esp
}
80105093:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105096:	5b                   	pop    %ebx
80105097:	5e                   	pop    %esi
80105098:	5d                   	pop    %ebp
80105099:	c3                   	ret
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb ec                	jmp    80105093 <sys_fstat+0x53>
801050a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050ae:	00 
801050af:	90                   	nop

801050b0 <sys_link>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050b8:	53                   	push   %ebx
801050b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050bc:	50                   	push   %eax
801050bd:	6a 00                	push   $0x0
801050bf:	e8 bc f9 ff ff       	call   80104a80 <argstr>
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	85 c0                	test   %eax,%eax
801050c9:	0f 88 fb 00 00 00    	js     801051ca <sys_link+0x11a>
801050cf:	83 ec 08             	sub    $0x8,%esp
801050d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050d5:	50                   	push   %eax
801050d6:	6a 01                	push   $0x1
801050d8:	e8 a3 f9 ff ff       	call   80104a80 <argstr>
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	85 c0                	test   %eax,%eax
801050e2:	0f 88 e2 00 00 00    	js     801051ca <sys_link+0x11a>
  begin_op();
801050e8:	e8 83 dc ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
801050ed:	83 ec 0c             	sub    $0xc,%esp
801050f0:	ff 75 d4             	push   -0x2c(%ebp)
801050f3:	e8 b8 cf ff ff       	call   801020b0 <namei>
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	89 c3                	mov    %eax,%ebx
801050fd:	85 c0                	test   %eax,%eax
801050ff:	0f 84 e4 00 00 00    	je     801051e9 <sys_link+0x139>
  ilock(ip);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	50                   	push   %eax
80105109:	e8 82 c6 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105116:	0f 84 b5 00 00 00    	je     801051d1 <sys_link+0x121>
  iupdate(ip);
8010511c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010511f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105124:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105127:	53                   	push   %ebx
80105128:	e8 a3 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010512d:	89 1c 24             	mov    %ebx,(%esp)
80105130:	e8 3b c7 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105135:	58                   	pop    %eax
80105136:	5a                   	pop    %edx
80105137:	57                   	push   %edi
80105138:	ff 75 d0             	push   -0x30(%ebp)
8010513b:	e8 90 cf ff ff       	call   801020d0 <nameiparent>
80105140:	83 c4 10             	add    $0x10,%esp
80105143:	89 c6                	mov    %eax,%esi
80105145:	85 c0                	test   %eax,%eax
80105147:	74 5b                	je     801051a4 <sys_link+0xf4>
  ilock(dp);
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	50                   	push   %eax
8010514d:	e8 3e c6 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105152:	8b 03                	mov    (%ebx),%eax
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	39 06                	cmp    %eax,(%esi)
80105159:	75 3d                	jne    80105198 <sys_link+0xe8>
8010515b:	83 ec 04             	sub    $0x4,%esp
8010515e:	ff 73 04             	push   0x4(%ebx)
80105161:	57                   	push   %edi
80105162:	56                   	push   %esi
80105163:	e8 88 ce ff ff       	call   80101ff0 <dirlink>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	85 c0                	test   %eax,%eax
8010516d:	78 29                	js     80105198 <sys_link+0xe8>
  iunlockput(dp);
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	56                   	push   %esi
80105173:	e8 a8 c8 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
80105178:	89 1c 24             	mov    %ebx,(%esp)
8010517b:	e8 40 c7 ff ff       	call   801018c0 <iput>
  end_op();
80105180:	e8 5b dc ff ff       	call   80102de0 <end_op>
  return 0;
80105185:	83 c4 10             	add    $0x10,%esp
80105188:	31 c0                	xor    %eax,%eax
}
8010518a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010518d:	5b                   	pop    %ebx
8010518e:	5e                   	pop    %esi
8010518f:	5f                   	pop    %edi
80105190:	5d                   	pop    %ebp
80105191:	c3                   	ret
80105192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105198:	83 ec 0c             	sub    $0xc,%esp
8010519b:	56                   	push   %esi
8010519c:	e8 7f c8 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801051a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	53                   	push   %ebx
801051a8:	e8 e3 c5 ff ff       	call   80101790 <ilock>
  ip->nlink--;
801051ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051b2:	89 1c 24             	mov    %ebx,(%esp)
801051b5:	e8 16 c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801051ba:	89 1c 24             	mov    %ebx,(%esp)
801051bd:	e8 5e c8 ff ff       	call   80101a20 <iunlockput>
  end_op();
801051c2:	e8 19 dc ff ff       	call   80102de0 <end_op>
  return -1;
801051c7:	83 c4 10             	add    $0x10,%esp
801051ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051cf:	eb b9                	jmp    8010518a <sys_link+0xda>
    iunlockput(ip);
801051d1:	83 ec 0c             	sub    $0xc,%esp
801051d4:	53                   	push   %ebx
801051d5:	e8 46 c8 ff ff       	call   80101a20 <iunlockput>
    end_op();
801051da:	e8 01 dc ff ff       	call   80102de0 <end_op>
    return -1;
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e7:	eb a1                	jmp    8010518a <sys_link+0xda>
    end_op();
801051e9:	e8 f2 db ff ff       	call   80102de0 <end_op>
    return -1;
801051ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f3:	eb 95                	jmp    8010518a <sys_link+0xda>
801051f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051fc:	00 
801051fd:	8d 76 00             	lea    0x0(%esi),%esi

80105200 <sys_unlink>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105205:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105208:	53                   	push   %ebx
80105209:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 6c f8 ff ff       	call   80104a80 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 82 01 00 00    	js     801053a1 <sys_unlink+0x1a1>
  begin_op();
8010521f:	e8 4c db ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105224:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	53                   	push   %ebx
8010522b:	ff 75 c0             	push   -0x40(%ebp)
8010522e:	e8 9d ce ff ff       	call   801020d0 <nameiparent>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105239:	85 c0                	test   %eax,%eax
8010523b:	0f 84 6a 01 00 00    	je     801053ab <sys_unlink+0x1ab>
  ilock(dp);
80105241:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	57                   	push   %edi
80105248:	e8 43 c5 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010524d:	58                   	pop    %eax
8010524e:	5a                   	pop    %edx
8010524f:	68 20 7a 10 80       	push   $0x80107a20
80105254:	53                   	push   %ebx
80105255:	e8 76 ca ff ff       	call   80101cd0 <namecmp>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	0f 84 03 01 00 00    	je     80105368 <sys_unlink+0x168>
80105265:	83 ec 08             	sub    $0x8,%esp
80105268:	68 1f 7a 10 80       	push   $0x80107a1f
8010526d:	53                   	push   %ebx
8010526e:	e8 5d ca ff ff       	call   80101cd0 <namecmp>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	0f 84 ea 00 00 00    	je     80105368 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010527e:	83 ec 04             	sub    $0x4,%esp
80105281:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105284:	50                   	push   %eax
80105285:	53                   	push   %ebx
80105286:	57                   	push   %edi
80105287:	e8 64 ca ff ff       	call   80101cf0 <dirlookup>
8010528c:	83 c4 10             	add    $0x10,%esp
8010528f:	89 c3                	mov    %eax,%ebx
80105291:	85 c0                	test   %eax,%eax
80105293:	0f 84 cf 00 00 00    	je     80105368 <sys_unlink+0x168>
  ilock(ip);
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	50                   	push   %eax
8010529d:	e8 ee c4 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052aa:	0f 8e 24 01 00 00    	jle    801053d4 <sys_unlink+0x1d4>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052b8:	74 66                	je     80105320 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052ba:	83 ec 04             	sub    $0x4,%esp
801052bd:	6a 10                	push   $0x10
801052bf:	6a 00                	push   $0x0
801052c1:	57                   	push   %edi
801052c2:	e8 39 f4 ff ff       	call   80104700 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052c7:	6a 10                	push   $0x10
801052c9:	ff 75 c4             	push   -0x3c(%ebp)
801052cc:	57                   	push   %edi
801052cd:	ff 75 b4             	push   -0x4c(%ebp)
801052d0:	e8 cb c8 ff ff       	call   80101ba0 <writei>
801052d5:	83 c4 20             	add    $0x20,%esp
801052d8:	83 f8 10             	cmp    $0x10,%eax
801052db:	0f 85 e6 00 00 00    	jne    801053c7 <sys_unlink+0x1c7>
  if(ip->type == T_DIR){
801052e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052e6:	0f 84 9c 00 00 00    	je     80105388 <sys_unlink+0x188>
  iunlockput(dp);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	ff 75 b4             	push   -0x4c(%ebp)
801052f2:	e8 29 c7 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
801052f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052fc:	89 1c 24             	mov    %ebx,(%esp)
801052ff:	e8 cc c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105304:	89 1c 24             	mov    %ebx,(%esp)
80105307:	e8 14 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010530c:	e8 cf da ff ff       	call   80102de0 <end_op>
  return 0;
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	31 c0                	xor    %eax,%eax
}
80105316:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105319:	5b                   	pop    %ebx
8010531a:	5e                   	pop    %esi
8010531b:	5f                   	pop    %edi
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret
8010531e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105320:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105324:	76 94                	jbe    801052ba <sys_unlink+0xba>
80105326:	be 20 00 00 00       	mov    $0x20,%esi
8010532b:	eb 0f                	jmp    8010533c <sys_unlink+0x13c>
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
80105330:	83 c6 10             	add    $0x10,%esi
80105333:	3b 73 58             	cmp    0x58(%ebx),%esi
80105336:	0f 83 7e ff ff ff    	jae    801052ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010533c:	6a 10                	push   $0x10
8010533e:	56                   	push   %esi
8010533f:	57                   	push   %edi
80105340:	53                   	push   %ebx
80105341:	e8 5a c7 ff ff       	call   80101aa0 <readi>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	83 f8 10             	cmp    $0x10,%eax
8010534c:	75 6c                	jne    801053ba <sys_unlink+0x1ba>
    if(de.inum != 0)
8010534e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105353:	74 db                	je     80105330 <sys_unlink+0x130>
    iunlockput(ip);
80105355:	83 ec 0c             	sub    $0xc,%esp
80105358:	53                   	push   %ebx
80105359:	e8 c2 c6 ff ff       	call   80101a20 <iunlockput>
    goto bad;
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105368:	83 ec 0c             	sub    $0xc,%esp
8010536b:	ff 75 b4             	push   -0x4c(%ebp)
8010536e:	e8 ad c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105373:	e8 68 da ff ff       	call   80102de0 <end_op>
  return -1;
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105380:	eb 94                	jmp    80105316 <sys_unlink+0x116>
80105382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105388:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010538b:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
8010538e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105393:	50                   	push   %eax
80105394:	e8 37 c3 ff ff       	call   801016d0 <iupdate>
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	e9 4b ff ff ff       	jmp    801052ec <sys_unlink+0xec>
    return -1;
801053a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a6:	e9 6b ff ff ff       	jmp    80105316 <sys_unlink+0x116>
    end_op();
801053ab:	e8 30 da ff ff       	call   80102de0 <end_op>
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b5:	e9 5c ff ff ff       	jmp    80105316 <sys_unlink+0x116>
      panic("isdirempty: readi");
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	68 73 7a 10 80       	push   $0x80107a73
801053c2:	e8 b9 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053c7:	83 ec 0c             	sub    $0xc,%esp
801053ca:	68 85 7a 10 80       	push   $0x80107a85
801053cf:	e8 ac af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	68 61 7a 10 80       	push   $0x80107a61
801053dc:	e8 9f af ff ff       	call   80100380 <panic>
801053e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053e8:	00 
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_open>:

int
sys_open(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053f8:	53                   	push   %ebx
801053f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053fc:	50                   	push   %eax
801053fd:	6a 00                	push   $0x0
801053ff:	e8 7c f6 ff ff       	call   80104a80 <argstr>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	85 c0                	test   %eax,%eax
80105409:	0f 88 ae 00 00 00    	js     801054bd <sys_open+0xcd>
8010540f:	83 ec 08             	sub    $0x8,%esp
80105412:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105415:	50                   	push   %eax
80105416:	6a 01                	push   $0x1
80105418:	e8 a3 f5 ff ff       	call   801049c0 <argint>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	0f 88 95 00 00 00    	js     801054bd <sys_open+0xcd>
    return -1;

  begin_op();
80105428:	e8 43 d9 ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
8010542d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105431:	0f 85 91 00 00 00    	jne    801054c8 <sys_open+0xd8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105437:	83 ec 0c             	sub    $0xc,%esp
8010543a:	ff 75 e0             	push   -0x20(%ebp)
8010543d:	e8 6e cc ff ff       	call   801020b0 <namei>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	89 c6                	mov    %eax,%esi
80105447:	85 c0                	test   %eax,%eax
80105449:	0f 84 96 00 00 00    	je     801054e5 <sys_open+0xf5>
      end_op();
      return -1;
    }
    ilock(ip);
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	50                   	push   %eax
80105453:	e8 38 c3 ff ff       	call   80101790 <ilock>
      end_op();
      cprintf("Operation open failed\n");
      return -1;  // ❌ No read permission
    }

    if ((omode & O_WRONLY) && !(ip->mode & 2)) {  // Check Write Permission
80105458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010545b:	83 c4 10             	add    $0x10,%esp
8010545e:	a8 01                	test   $0x1,%al
80105460:	74 0d                	je     8010546f <sys_open+0x7f>
80105462:	f6 86 90 00 00 00 02 	testb  $0x2,0x90(%esi)
80105469:	0f 84 cc 00 00 00    	je     8010553b <sys_open+0x14b>
      end_op();
      cprintf("Operation open failed\n");
      return -1;  // ❌ No write permission
    }

    if(ip->type == T_DIR && omode != O_RDONLY){
8010546f:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105474:	75 04                	jne    8010547a <sys_open+0x8a>
80105476:	85 c0                	test   %eax,%eax
80105478:	75 32                	jne    801054ac <sys_open+0xbc>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010547a:	e8 b1 b9 ff ff       	call   80100e30 <filealloc>
8010547f:	89 c7                	mov    %eax,%edi
80105481:	85 c0                	test   %eax,%eax
80105483:	74 27                	je     801054ac <sys_open+0xbc>
  struct proc *curproc = myproc();
80105485:	e8 f6 e4 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010548a:	31 db                	xor    %ebx,%ebx
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105490:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105494:	85 d2                	test   %edx,%edx
80105496:	74 60                	je     801054f8 <sys_open+0x108>
  for(fd = 0; fd < NOFILE; fd++){
80105498:	83 c3 01             	add    $0x1,%ebx
8010549b:	83 fb 10             	cmp    $0x10,%ebx
8010549e:	75 f0                	jne    80105490 <sys_open+0xa0>
    if(f)
      fileclose(f);
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	57                   	push   %edi
801054a4:	e8 47 ba ff ff       	call   80100ef0 <fileclose>
801054a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054ac:	83 ec 0c             	sub    $0xc,%esp
801054af:	56                   	push   %esi
801054b0:	e8 6b c5 ff ff       	call   80101a20 <iunlockput>
    end_op();
801054b5:	e8 26 d9 ff ff       	call   80102de0 <end_op>
    return -1;
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054c2:	eb 6d                	jmp    80105531 <sys_open+0x141>
801054c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054ce:	31 c9                	xor    %ecx,%ecx
801054d0:	ba 02 00 00 00       	mov    $0x2,%edx
801054d5:	6a 00                	push   $0x0
801054d7:	e8 24 f7 ff ff       	call   80104c00 <create>
    if(ip == 0){
801054dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054df:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054e1:	85 c0                	test   %eax,%eax
801054e3:	75 95                	jne    8010547a <sys_open+0x8a>
      end_op();
801054e5:	e8 f6 d8 ff ff       	call   80102de0 <end_op>
      return -1;
801054ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054ef:	eb 40                	jmp    80105531 <sys_open+0x141>
801054f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054fb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054ff:	56                   	push   %esi
80105500:	e8 6b c3 ff ff       	call   80101870 <iunlock>
  end_op();
80105505:	e8 d6 d8 ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
8010550a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105510:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105513:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105516:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105519:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010551b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105522:	f7 d0                	not    %eax
80105524:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105527:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010552a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010552d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105534:	89 d8                	mov    %ebx,%eax
80105536:	5b                   	pop    %ebx
80105537:	5e                   	pop    %esi
80105538:	5f                   	pop    %edi
80105539:	5d                   	pop    %ebp
8010553a:	c3                   	ret
      iunlockput(ip);
8010553b:	83 ec 0c             	sub    $0xc,%esp
      return -1;  // ❌ No write permission
8010553e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      iunlockput(ip);
80105543:	56                   	push   %esi
80105544:	e8 d7 c4 ff ff       	call   80101a20 <iunlockput>
      end_op();
80105549:	e8 92 d8 ff ff       	call   80102de0 <end_op>
      cprintf("Operation open failed\n");
8010554e:	c7 04 24 94 7a 10 80 	movl   $0x80107a94,(%esp)
80105555:	e8 46 b1 ff ff       	call   801006a0 <cprintf>
      return -1;  // ❌ No write permission
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	eb d2                	jmp    80105531 <sys_open+0x141>
8010555f:	90                   	nop

80105560 <sys_mkdir>:

int
sys_mkdir(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105566:	e8 05 d8 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105571:	50                   	push   %eax
80105572:	6a 00                	push   $0x0
80105574:	e8 07 f5 ff ff       	call   80104a80 <argstr>
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	85 c0                	test   %eax,%eax
8010557e:	78 30                	js     801055b0 <sys_mkdir+0x50>
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105586:	31 c9                	xor    %ecx,%ecx
80105588:	ba 01 00 00 00       	mov    $0x1,%edx
8010558d:	6a 00                	push   $0x0
8010558f:	e8 6c f6 ff ff       	call   80104c00 <create>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	74 15                	je     801055b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010559b:	83 ec 0c             	sub    $0xc,%esp
8010559e:	50                   	push   %eax
8010559f:	e8 7c c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
801055a4:	e8 37 d8 ff ff       	call   80102de0 <end_op>
  return 0;
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	31 c0                	xor    %eax,%eax
}
801055ae:	c9                   	leave
801055af:	c3                   	ret
    end_op();
801055b0:	e8 2b d8 ff ff       	call   80102de0 <end_op>
    return -1;
801055b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ba:	c9                   	leave
801055bb:	c3                   	ret
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_mknod>:

int
sys_mknod(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055c6:	e8 a5 d7 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055cb:	83 ec 08             	sub    $0x8,%esp
801055ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055d1:	50                   	push   %eax
801055d2:	6a 00                	push   $0x0
801055d4:	e8 a7 f4 ff ff       	call   80104a80 <argstr>
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	85 c0                	test   %eax,%eax
801055de:	78 60                	js     80105640 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e6:	50                   	push   %eax
801055e7:	6a 01                	push   $0x1
801055e9:	e8 d2 f3 ff ff       	call   801049c0 <argint>
  if((argstr(0, &path)) < 0 ||
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 4b                	js     80105640 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055f5:	83 ec 08             	sub    $0x8,%esp
801055f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055fb:	50                   	push   %eax
801055fc:	6a 02                	push   $0x2
801055fe:	e8 bd f3 ff ff       	call   801049c0 <argint>
     argint(1, &major) < 0 ||
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	78 36                	js     80105640 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010560a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010560e:	83 ec 0c             	sub    $0xc,%esp
80105611:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105615:	ba 03 00 00 00       	mov    $0x3,%edx
8010561a:	50                   	push   %eax
8010561b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010561e:	e8 dd f5 ff ff       	call   80104c00 <create>
     argint(2, &minor) < 0 ||
80105623:	83 c4 10             	add    $0x10,%esp
80105626:	85 c0                	test   %eax,%eax
80105628:	74 16                	je     80105640 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010562a:	83 ec 0c             	sub    $0xc,%esp
8010562d:	50                   	push   %eax
8010562e:	e8 ed c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105633:	e8 a8 d7 ff ff       	call   80102de0 <end_op>
  return 0;
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	31 c0                	xor    %eax,%eax
}
8010563d:	c9                   	leave
8010563e:	c3                   	ret
8010563f:	90                   	nop
    end_op();
80105640:	e8 9b d7 ff ff       	call   80102de0 <end_op>
    return -1;
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564a:	c9                   	leave
8010564b:	c3                   	ret
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_chdir>:

int
sys_chdir(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	56                   	push   %esi
80105654:	53                   	push   %ebx
80105655:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105658:	e8 23 e3 ff ff       	call   80103980 <myproc>
8010565d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010565f:	e8 0c d7 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105664:	83 ec 08             	sub    $0x8,%esp
80105667:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566a:	50                   	push   %eax
8010566b:	6a 00                	push   $0x0
8010566d:	e8 0e f4 ff ff       	call   80104a80 <argstr>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	85 c0                	test   %eax,%eax
80105677:	78 77                	js     801056f0 <sys_chdir+0xa0>
80105679:	83 ec 0c             	sub    $0xc,%esp
8010567c:	ff 75 f4             	push   -0xc(%ebp)
8010567f:	e8 2c ca ff ff       	call   801020b0 <namei>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	89 c3                	mov    %eax,%ebx
80105689:	85 c0                	test   %eax,%eax
8010568b:	74 63                	je     801056f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	50                   	push   %eax
80105691:	e8 fa c0 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
80105696:	83 c4 10             	add    $0x10,%esp
80105699:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010569e:	75 30                	jne    801056d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	53                   	push   %ebx
801056a4:	e8 c7 c1 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
801056a9:	58                   	pop    %eax
801056aa:	ff 76 68             	push   0x68(%esi)
801056ad:	e8 0e c2 ff ff       	call   801018c0 <iput>
  end_op();
801056b2:	e8 29 d7 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
801056b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	31 c0                	xor    %eax,%eax
}
801056bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056c2:	5b                   	pop    %ebx
801056c3:	5e                   	pop    %esi
801056c4:	5d                   	pop    %ebp
801056c5:	c3                   	ret
801056c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056cd:	00 
801056ce:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 47 c3 ff ff       	call   80101a20 <iunlockput>
    end_op();
801056d9:	e8 02 d7 ff ff       	call   80102de0 <end_op>
    return -1;
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e6:	eb d7                	jmp    801056bf <sys_chdir+0x6f>
801056e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ef:	00 
    end_op();
801056f0:	e8 eb d6 ff ff       	call   80102de0 <end_op>
    return -1;
801056f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fa:	eb c3                	jmp    801056bf <sys_chdir+0x6f>
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_exec>:

int sys_exec(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;
  struct inode *ip;  // NEW: Inode pointer to check permissions

  if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105705:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010570b:	53                   	push   %ebx
8010570c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105712:	50                   	push   %eax
80105713:	6a 00                	push   $0x0
80105715:	e8 66 f3 ff ff       	call   80104a80 <argstr>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	0f 88 87 00 00 00    	js     801057ac <sys_exec+0xac>
80105725:	83 ec 08             	sub    $0x8,%esp
80105728:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010572e:	50                   	push   %eax
8010572f:	6a 01                	push   $0x1
80105731:	e8 8a f2 ff ff       	call   801049c0 <argint>
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	85 c0                	test   %eax,%eax
8010573b:	78 6f                	js     801057ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010573d:	83 ec 04             	sub    $0x4,%esp
80105740:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++) {
80105746:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105748:	68 80 00 00 00       	push   $0x80
8010574d:	6a 00                	push   $0x0
8010574f:	56                   	push   %esi
80105750:	e8 ab ef ff ff       	call   80104700 <memset>
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010575f:	00 
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int*)&uarg) < 0)
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105769:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105770:	50                   	push   %eax
80105771:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105777:	01 f8                	add    %edi,%eax
80105779:	50                   	push   %eax
8010577a:	e8 b1 f1 ff ff       	call   80104930 <fetchint>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	85 c0                	test   %eax,%eax
80105784:	78 26                	js     801057ac <sys_exec+0xac>
      return -1;
    if (uarg == 0) {
80105786:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010578c:	85 c0                	test   %eax,%eax
8010578e:	74 30                	je     801057c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80105790:	83 ec 08             	sub    $0x8,%esp
80105793:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105796:	52                   	push   %edx
80105797:	50                   	push   %eax
80105798:	e8 d3 f1 ff ff       	call   80104970 <fetchstr>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 08                	js     801057ac <sys_exec+0xac>
  for (i = 0;; i++) {
801057a4:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
801057a7:	83 fb 20             	cmp    $0x20,%ebx
801057aa:	75 b4                	jne    80105760 <sys_exec+0x60>

  // 🔹 NEW: Lookup inode and check execute permission
  begin_op();
  if ((ip = namei(path)) == 0) {  // Get the inode of the file
    end_op();
    return -1;  // ❌ File not found
801057ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  iunlock(ip);
  end_op();

  return exec(path, argv);  // ✅ Allowed execution
}
801057b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057c0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057c7:	00 00 00 00 
  begin_op();
801057cb:	e8 a0 d5 ff ff       	call   80102d70 <begin_op>
  if ((ip = namei(path)) == 0) {  // Get the inode of the file
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057d9:	e8 d2 c8 ff ff       	call   801020b0 <namei>
801057de:	83 c4 10             	add    $0x10,%esp
801057e1:	89 c3                	mov    %eax,%ebx
801057e3:	85 c0                	test   %eax,%eax
801057e5:	74 63                	je     8010584a <sys_exec+0x14a>
  ilock(ip);
801057e7:	83 ec 0c             	sub    $0xc,%esp
801057ea:	50                   	push   %eax
801057eb:	e8 a0 bf ff ff       	call   80101790 <ilock>
  if (!(ip->mode & 1)) {  // Check if execute (x) permission is set
801057f0:	83 c4 10             	add    $0x10,%esp
801057f3:	f6 83 90 00 00 00 01 	testb  $0x1,0x90(%ebx)
801057fa:	74 27                	je     80105823 <sys_exec+0x123>
  iunlock(ip);
801057fc:	83 ec 0c             	sub    $0xc,%esp
801057ff:	53                   	push   %ebx
80105800:	e8 6b c0 ff ff       	call   80101870 <iunlock>
  end_op();
80105805:	e8 d6 d5 ff ff       	call   80102de0 <end_op>
  return exec(path, argv);  // ✅ Allowed execution
8010580a:	58                   	pop    %eax
8010580b:	5a                   	pop    %edx
8010580c:	56                   	push   %esi
8010580d:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105813:	e8 98 b2 ff ff       	call   80100ab0 <exec>
80105818:	83 c4 10             	add    $0x10,%esp
}
8010581b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010581e:	5b                   	pop    %ebx
8010581f:	5e                   	pop    %esi
80105820:	5f                   	pop    %edi
80105821:	5d                   	pop    %ebp
80105822:	c3                   	ret
    iunlockput(ip);
80105823:	83 ec 0c             	sub    $0xc,%esp
80105826:	53                   	push   %ebx
80105827:	e8 f4 c1 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010582c:	e8 af d5 ff ff       	call   80102de0 <end_op>
    cprintf("Operation execute failed\n");
80105831:	c7 04 24 ab 7a 10 80 	movl   $0x80107aab,(%esp)
80105838:	e8 63 ae ff ff       	call   801006a0 <cprintf>
    return -1;  // ❌ No execute permission
8010583d:	83 c4 10             	add    $0x10,%esp
80105840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105845:	e9 67 ff ff ff       	jmp    801057b1 <sys_exec+0xb1>
    end_op();
8010584a:	e8 91 d5 ff ff       	call   80102de0 <end_op>
8010584f:	e9 58 ff ff ff       	jmp    801057ac <sys_exec+0xac>
80105854:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010585b:	00 
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_pipe>:

int
sys_pipe(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105865:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105868:	53                   	push   %ebx
80105869:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010586c:	6a 08                	push   $0x8
8010586e:	50                   	push   %eax
8010586f:	6a 00                	push   $0x0
80105871:	e8 9a f1 ff ff       	call   80104a10 <argptr>
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	85 c0                	test   %eax,%eax
8010587b:	78 4a                	js     801058c7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010587d:	83 ec 08             	sub    $0x8,%esp
80105880:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105883:	50                   	push   %eax
80105884:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105887:	50                   	push   %eax
80105888:	e8 b3 db ff ff       	call   80103440 <pipealloc>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	78 33                	js     801058c7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105894:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105897:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105899:	e8 e2 e0 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010589e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058a0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058a4:	85 f6                	test   %esi,%esi
801058a6:	74 28                	je     801058d0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058a8:	83 c3 01             	add    $0x1,%ebx
801058ab:	83 fb 10             	cmp    $0x10,%ebx
801058ae:	75 f0                	jne    801058a0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	ff 75 e0             	push   -0x20(%ebp)
801058b6:	e8 35 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801058bb:	58                   	pop    %eax
801058bc:	ff 75 e4             	push   -0x1c(%ebp)
801058bf:	e8 2c b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cc:	eb 53                	jmp    80105921 <sys_pipe+0xc1>
801058ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058d0:	8d 73 08             	lea    0x8(%ebx),%esi
801058d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058da:	e8 a1 e0 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058df:	31 d2                	xor    %edx,%edx
801058e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058ec:	85 c9                	test   %ecx,%ecx
801058ee:	74 20                	je     80105910 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801058f0:	83 c2 01             	add    $0x1,%edx
801058f3:	83 fa 10             	cmp    $0x10,%edx
801058f6:	75 f0                	jne    801058e8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801058f8:	e8 83 e0 ff ff       	call   80103980 <myproc>
801058fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105904:	00 
80105905:	eb a9                	jmp    801058b0 <sys_pipe+0x50>
80105907:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010590e:	00 
8010590f:	90                   	nop
      curproc->ofile[fd] = f;
80105910:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105914:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105917:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105919:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010591c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010591f:	31 c0                	xor    %eax,%eax
}
80105921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
80105928:	c3                   	ret
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_chmod>:

// System call to implement chmod
int sys_chmod(void) {
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	53                   	push   %ebx
  char *path;
  int mode;
  
  if (argstr(0, &path) < 0 || argint(1, &mode) < 0)
80105934:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_chmod(void) {
80105937:	83 ec 1c             	sub    $0x1c,%esp
  if (argstr(0, &path) < 0 || argint(1, &mode) < 0)
8010593a:	50                   	push   %eax
8010593b:	6a 00                	push   $0x0
8010593d:	e8 3e f1 ff ff       	call   80104a80 <argstr>
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	85 c0                	test   %eax,%eax
80105947:	78 67                	js     801059b0 <sys_chmod+0x80>
80105949:	83 ec 08             	sub    $0x8,%esp
8010594c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594f:	50                   	push   %eax
80105950:	6a 01                	push   $0x1
80105952:	e8 69 f0 ff ff       	call   801049c0 <argint>
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	85 c0                	test   %eax,%eax
8010595c:	78 52                	js     801059b0 <sys_chmod+0x80>
      return -1;

  struct inode *ip = namei(path);
8010595e:	83 ec 0c             	sub    $0xc,%esp
80105961:	ff 75 f0             	push   -0x10(%ebp)
80105964:	e8 47 c7 ff ff       	call   801020b0 <namei>
  if (ip == 0)
80105969:	83 c4 10             	add    $0x10,%esp
  struct inode *ip = namei(path);
8010596c:	89 c3                	mov    %eax,%ebx
  if (ip == 0)
8010596e:	85 c0                	test   %eax,%eax
80105970:	74 3e                	je     801059b0 <sys_chmod+0x80>
      return -1;

  begin_op();
80105972:	e8 f9 d3 ff ff       	call   80102d70 <begin_op>
  ilock(ip);
80105977:	83 ec 0c             	sub    $0xc,%esp
8010597a:	53                   	push   %ebx
8010597b:	e8 10 be ff ff       	call   80101790 <ilock>

  ip->mode = mode; // Set new permissions
80105980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105983:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  iupdate(ip);      // Update the inode
80105989:	89 1c 24             	mov    %ebx,(%esp)
8010598c:	e8 3f bd ff ff       	call   801016d0 <iupdate>

  iunlock(ip);
80105991:	89 1c 24             	mov    %ebx,(%esp)
80105994:	e8 d7 be ff ff       	call   80101870 <iunlock>
  end_op();
80105999:	e8 42 d4 ff ff       	call   80102de0 <end_op>

  return 0;
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	31 c0                	xor    %eax,%eax
}
801059a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a6:	c9                   	leave
801059a7:	c3                   	ret
801059a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059af:	00 
      return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b5:	eb ec                	jmp    801059a3 <sys_chmod+0x73>
801059b7:	66 90                	xchg   %ax,%ax
801059b9:	66 90                	xchg   %ax,%ax
801059bb:	66 90                	xchg   %ax,%ax
801059bd:	66 90                	xchg   %ax,%ax
801059bf:	90                   	nop

801059c0 <sys_fork>:

int blocked_syscalls[MAX_SYSCALLS] = {0};  // Global kernel-side tracking


int sys_fork(void) {
    return fork();
801059c0:	e9 5b e1 ff ff       	jmp    80103b20 <fork>
801059c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059cc:	00 
801059cd:	8d 76 00             	lea    0x0(%esi),%esi

801059d0 <sys_exit>:
}

int sys_exit(void) {
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 08             	sub    $0x8,%esp
    exit();
801059d6:	e8 c5 e3 ff ff       	call   80103da0 <exit>
    return 0;  // not reached
}
801059db:	31 c0                	xor    %eax,%eax
801059dd:	c9                   	leave
801059de:	c3                   	ret
801059df:	90                   	nop

801059e0 <sys_wait>:

int sys_wait(void) {
    return wait();
801059e0:	e9 7b e5 ff ff       	jmp    80103f60 <wait>
801059e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ec:	00 
801059ed:	8d 76 00             	lea    0x0(%esi),%esi

801059f0 <sys_kill>:
}

int sys_kill(void) {
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 20             	sub    $0x20,%esp
    int pid;
    if(argint(0, &pid) < 0)
801059f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f9:	50                   	push   %eax
801059fa:	6a 00                	push   $0x0
801059fc:	e8 bf ef ff ff       	call   801049c0 <argint>
80105a01:	83 c4 10             	add    $0x10,%esp
80105a04:	85 c0                	test   %eax,%eax
80105a06:	78 18                	js     80105a20 <sys_kill+0x30>
        return -1;
    return kill(pid);
80105a08:	83 ec 0c             	sub    $0xc,%esp
80105a0b:	ff 75 f4             	push   -0xc(%ebp)
80105a0e:	e8 ed e7 ff ff       	call   80104200 <kill>
80105a13:	83 c4 10             	add    $0x10,%esp
}
80105a16:	c9                   	leave
80105a17:	c3                   	ret
80105a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a1f:	00 
80105a20:	c9                   	leave
        return -1;
80105a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a26:	c3                   	ret
80105a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a2e:	00 
80105a2f:	90                   	nop

80105a30 <sys_getpid>:

int sys_getpid(void) {
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80105a36:	e8 45 df ff ff       	call   80103980 <myproc>
80105a3b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a3e:	c9                   	leave
80105a3f:	c3                   	ret

80105a40 <sys_sbrk>:
//     release(&ptable.lock);
    
//     return addr;
// }

int sys_sbrk(void) {
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	53                   	push   %ebx
80105a44:	83 ec 14             	sub    $0x14,%esp
    int addr;
    int n;
    struct proc *curproc = myproc();
80105a47:	e8 34 df ff ff       	call   80103980 <myproc>

    if(argint(0, &n) < 0)
80105a4c:	83 ec 08             	sub    $0x8,%esp
    struct proc *curproc = myproc();
80105a4f:	89 c3                	mov    %eax,%ebx
    if(argint(0, &n) < 0)
80105a51:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a54:	50                   	push   %eax
80105a55:	6a 00                	push   $0x0
80105a57:	e8 64 ef ff ff       	call   801049c0 <argint>
80105a5c:	83 c4 10             	add    $0x10,%esp
80105a5f:	85 c0                	test   %eax,%eax
80105a61:	78 1d                	js     80105a80 <sys_sbrk+0x40>
        return -1;
    addr = curproc->sz;

    if(growproc(n) < 0)
80105a63:	83 ec 0c             	sub    $0xc,%esp
    addr = curproc->sz;
80105a66:	8b 1b                	mov    (%ebx),%ebx
    if(growproc(n) < 0)
80105a68:	ff 75 f4             	push   -0xc(%ebp)
80105a6b:	e8 30 e0 ff ff       	call   80103aa0 <growproc>
80105a70:	83 c4 10             	add    $0x10,%esp
80105a73:	85 c0                	test   %eax,%eax
80105a75:	78 09                	js     80105a80 <sys_sbrk+0x40>
        return -1;
    
    return addr;
}
80105a77:	89 d8                	mov    %ebx,%eax
80105a79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a7c:	c9                   	leave
80105a7d:	c3                   	ret
80105a7e:	66 90                	xchg   %ax,%ax
        return -1;
80105a80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a85:	eb f0                	jmp    80105a77 <sys_sbrk+0x37>
80105a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a8e:	00 
80105a8f:	90                   	nop

80105a90 <sys_sleep>:

//     return addr;
// }


int sys_sleep(void) {
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	53                   	push   %ebx
    int n;
    uint ticks0;
    if(argint(0, &n) < 0)
80105a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80105a97:	83 ec 1c             	sub    $0x1c,%esp
    if(argint(0, &n) < 0)
80105a9a:	50                   	push   %eax
80105a9b:	6a 00                	push   $0x0
80105a9d:	e8 1e ef ff ff       	call   801049c0 <argint>
80105aa2:	83 c4 10             	add    $0x10,%esp
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	0f 88 8a 00 00 00    	js     80105b37 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
80105aad:	83 ec 0c             	sub    $0xc,%esp
80105ab0:	68 40 57 11 80       	push   $0x80115740
80105ab5:	e8 86 eb ff ff       	call   80104640 <acquire>
    ticks0 = ticks;
    while(ticks - ticks0 < n) {
80105aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
    ticks0 = ticks;
80105abd:	8b 1d 20 57 11 80    	mov    0x80115720,%ebx
    while(ticks - ticks0 < n) {
80105ac3:	83 c4 10             	add    $0x10,%esp
80105ac6:	85 d2                	test   %edx,%edx
80105ac8:	75 27                	jne    80105af1 <sys_sleep+0x61>
80105aca:	eb 54                	jmp    80105b20 <sys_sleep+0x90>
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	68 40 57 11 80       	push   $0x80115740
80105ad8:	68 20 57 11 80       	push   $0x80115720
80105add:	e8 fe e5 ff ff       	call   801040e0 <sleep>
    while(ticks - ticks0 < n) {
80105ae2:	a1 20 57 11 80       	mov    0x80115720,%eax
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	29 d8                	sub    %ebx,%eax
80105aec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105aef:	73 2f                	jae    80105b20 <sys_sleep+0x90>
        if(myproc()->killed) {
80105af1:	e8 8a de ff ff       	call   80103980 <myproc>
80105af6:	8b 40 24             	mov    0x24(%eax),%eax
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 d3                	je     80105ad0 <sys_sleep+0x40>
            release(&tickslock);
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	68 40 57 11 80       	push   $0x80115740
80105b05:	e8 d6 ea ff ff       	call   801045e0 <release>
    }
    release(&tickslock);
    return 0;
}
80105b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return -1;
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b15:	c9                   	leave
80105b16:	c3                   	ret
80105b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b1e:	00 
80105b1f:	90                   	nop
    release(&tickslock);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	68 40 57 11 80       	push   $0x80115740
80105b28:	e8 b3 ea ff ff       	call   801045e0 <release>
    return 0;
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	31 c0                	xor    %eax,%eax
}
80105b32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b35:	c9                   	leave
80105b36:	c3                   	ret
        return -1;
80105b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3c:	eb f4                	jmp    80105b32 <sys_sleep+0xa2>
80105b3e:	66 90                	xchg   %ax,%ax

80105b40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	53                   	push   %ebx
80105b44:	83 ec 10             	sub    $0x10,%esp
    uint xticks;
    acquire(&tickslock);
80105b47:	68 40 57 11 80       	push   $0x80115740
80105b4c:	e8 ef ea ff ff       	call   80104640 <acquire>
    xticks = ticks;
80105b51:	8b 1d 20 57 11 80    	mov    0x80115720,%ebx
    release(&tickslock);
80105b57:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80105b5e:	e8 7d ea ff ff       	call   801045e0 <release>
    return xticks;
}
80105b63:	89 d8                	mov    %ebx,%eax
80105b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b68:	c9                   	leave
80105b69:	c3                   	ret
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b70 <sys_gethistory>:

// System call to get process history
int sys_gethistory(void) {
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
    struct history_entry *hist_buf;
    int max_entries;

    // Get arguments from user space
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105b75:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_gethistory(void) {
80105b78:	53                   	push   %ebx
80105b79:	83 ec 30             	sub    $0x30,%esp
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105b7c:	6a 18                	push   $0x18
80105b7e:	50                   	push   %eax
80105b7f:	6a 00                	push   $0x0
80105b81:	e8 8a ee ff ff       	call   80104a10 <argptr>
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	0f 88 dd 00 00 00    	js     80105c6e <sys_gethistory+0xfe>
        argint(1, &max_entries) < 0) {
80105b91:	83 ec 08             	sub    $0x8,%esp
80105b94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b97:	50                   	push   %eax
80105b98:	6a 01                	push   $0x1
80105b9a:	e8 21 ee ff ff       	call   801049c0 <argint>
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105b9f:	83 c4 10             	add    $0x10,%esp
80105ba2:	85 c0                	test   %eax,%eax
80105ba4:	0f 88 c4 00 00 00    	js     80105c6e <sys_gethistory+0xfe>
        return -1;  // Invalid arguments
    }

    acquire(&ptable.lock);
80105baa:	83 ec 0c             	sub    $0xc,%esp
80105bad:	68 e0 2d 11 80       	push   $0x80112de0
80105bb2:	e8 89 ea ff ff       	call   80104640 <acquire>

    // Return only the most recent `max_entries` from history
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105bb7:	a1 18 4d 11 80       	mov    0x80114d18,%eax
80105bbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105bbf:	39 d0                	cmp    %edx,%eax
80105bc1:	89 d7                	mov    %edx,%edi
80105bc3:	0f 4e f8             	cmovle %eax,%edi
    int start = (history_count < MAX_HISTORY) ? 0 : history_index;  // Start index
80105bc6:	31 db                	xor    %ebx,%ebx
80105bc8:	83 c4 10             	add    $0x10,%esp
80105bcb:	83 f8 63             	cmp    $0x63,%eax
80105bce:	0f 4f 1d 14 4d 11 80 	cmovg  0x80114d14,%ebx
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105bd5:	89 7d d0             	mov    %edi,-0x30(%ebp)

    for (int i = 0; i < copy_count; i++) {
80105bd8:	85 ff                	test   %edi,%edi
80105bda:	7e 77                	jle    80105c53 <sys_gethistory+0xe3>
80105bdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
        int index = (start + i) % MAX_HISTORY;
        hist_buf[i].pid = process_history[index].pid;
80105bdf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105be2:	31 f6                	xor    %esi,%esi
80105be4:	01 d8                	add    %ebx,%eax
80105be6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        int index = (start + i) % MAX_HISTORY;
80105bf0:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105bf5:	83 ec 04             	sub    $0x4,%esp
        int index = (start + i) % MAX_HISTORY;
80105bf8:	f7 eb                	imul   %ebx
80105bfa:	89 d8                	mov    %ebx,%eax
80105bfc:	c1 f8 1f             	sar    $0x1f,%eax
80105bff:	c1 fa 05             	sar    $0x5,%edx
80105c02:	29 c2                	sub    %eax,%edx
80105c04:	6b c2 64             	imul   $0x64,%edx,%eax
80105c07:	89 da                	mov    %ebx,%edx
    for (int i = 0; i < copy_count; i++) {
80105c09:	83 c3 01             	add    $0x1,%ebx
        int index = (start + i) % MAX_HISTORY;
80105c0c:	29 c2                	sub    %eax,%edx
        hist_buf[i].pid = process_history[index].pid;
80105c0e:	8d 14 52             	lea    (%edx,%edx,2),%edx
80105c11:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80105c18:	8b 14 d5 20 4d 11 80 	mov    -0x7feeb2e0(,%edx,8),%edx
80105c1f:	8d b8 20 4d 11 80    	lea    -0x7feeb2e0(%eax),%edi
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105c25:	05 24 4d 11 80       	add    $0x80114d24,%eax
        hist_buf[i].pid = process_history[index].pid;
80105c2a:	89 14 31             	mov    %edx,(%ecx,%esi,1)
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105c2d:	6a 10                	push   $0x10
80105c2f:	50                   	push   %eax
80105c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c33:	01 f0                	add    %esi,%eax
80105c35:	83 c0 04             	add    $0x4,%eax
80105c38:	50                   	push   %eax
80105c39:	e8 82 ec ff ff       	call   801048c0 <safestrcpy>
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105c3e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105c41:	8b 47 14             	mov    0x14(%edi),%eax
    for (int i = 0; i < copy_count; i++) {
80105c44:	83 c4 10             	add    $0x10,%esp
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105c47:	89 44 31 14          	mov    %eax,0x14(%ecx,%esi,1)
    for (int i = 0; i < copy_count; i++) {
80105c4b:	83 c6 18             	add    $0x18,%esi
80105c4e:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
80105c51:	75 9d                	jne    80105bf0 <sys_gethistory+0x80>
    }

    release(&ptable.lock);
80105c53:	83 ec 0c             	sub    $0xc,%esp
80105c56:	68 e0 2d 11 80       	push   $0x80112de0
80105c5b:	e8 80 e9 ff ff       	call   801045e0 <release>
    return copy_count;  // Return number of processes copied
80105c60:	83 c4 10             	add    $0x10,%esp
}
80105c63:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c69:	5b                   	pop    %ebx
80105c6a:	5e                   	pop    %esi
80105c6b:	5f                   	pop    %edi
80105c6c:	5d                   	pop    %ebp
80105c6d:	c3                   	ret
        return -1;  // Invalid arguments
80105c6e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
80105c75:	eb ec                	jmp    80105c63 <sys_gethistory+0xf3>
80105c77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c7e:	00 
80105c7f:	90                   	nop

80105c80 <sys_block>:
//         return 0;
//     }

//     return -1;
// }
int sys_block(void) {
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 20             	sub    $0x20,%esp
    int syscall_id;
    if (argint(0, &syscall_id) < 0) 
80105c86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c89:	50                   	push   %eax
80105c8a:	6a 00                	push   $0x0
80105c8c:	e8 2f ed ff ff       	call   801049c0 <argint>
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	85 c0                	test   %eax,%eax
80105c96:	78 28                	js     80105cc0 <sys_block+0x40>
        return -1;
    
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9b:	83 f8 19             	cmp    $0x19,%eax
80105c9e:	77 20                	ja     80105cc0 <sys_block+0x40>
        return -1;

    // Prevent blocking critical system calls
    if (syscall_id == SYS_fork || syscall_id == SYS_exit || syscall_id == SYS_unblock) {
80105ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ca3:	83 fa 01             	cmp    $0x1,%edx
80105ca6:	76 18                	jbe    80105cc0 <sys_block+0x40>
80105ca8:	83 f8 18             	cmp    $0x18,%eax
80105cab:	74 13                	je     80105cc0 <sys_block+0x40>
        return -1;
    }

    blocked_syscalls[syscall_id] = 1;  // Store in the kernel
80105cad:	c7 04 85 a0 56 11 80 	movl   $0x1,-0x7feea960(,%eax,4)
80105cb4:	01 00 00 00 
    return 0;
80105cb8:	31 c0                	xor    %eax,%eax
}
80105cba:	c9                   	leave
80105cbb:	c3                   	ret
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cc0:	c9                   	leave
        return -1;
80105cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc6:	c3                   	ret
80105cc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cce:	00 
80105ccf:	90                   	nop

80105cd0 <sys_unblock>:
//     }

//     release(&ptable.lock);
//     return 0;
// }
int sys_unblock(void) {
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 20             	sub    $0x20,%esp
    int syscall_id;

    // Get the syscall ID from arguments
    if (argint(0, &syscall_id) < 0) 
80105cd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd9:	50                   	push   %eax
80105cda:	6a 00                	push   $0x0
80105cdc:	e8 df ec ff ff       	call   801049c0 <argint>
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	85 c0                	test   %eax,%eax
80105ce6:	78 18                	js     80105d00 <sys_unblock+0x30>
        return -1;

    // Validate syscall ID range
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ceb:	83 f8 19             	cmp    $0x19,%eax
80105cee:	77 10                	ja     80105d00 <sys_unblock+0x30>
        return -1;

    // Unblock the specified syscall
    blocked_syscalls[syscall_id] = 0;
80105cf0:	c7 04 85 a0 56 11 80 	movl   $0x0,-0x7feea960(,%eax,4)
80105cf7:	00 00 00 00 

    return 0;
80105cfb:	31 c0                	xor    %eax,%eax
}
80105cfd:	c9                   	leave
80105cfe:	c3                   	ret
80105cff:	90                   	nop
80105d00:	c9                   	leave
        return -1;
80105d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d06:	c3                   	ret

80105d07 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d07:	1e                   	push   %ds
  pushl %es
80105d08:	06                   	push   %es
  pushl %fs
80105d09:	0f a0                	push   %fs
  pushl %gs
80105d0b:	0f a8                	push   %gs
  pushal
80105d0d:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d0e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d12:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d14:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d16:	54                   	push   %esp
  call trap
80105d17:	e8 c4 00 00 00       	call   80105de0 <trap>
  addl $4, %esp
80105d1c:	83 c4 04             	add    $0x4,%esp

80105d1f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d1f:	61                   	popa
  popl %gs
80105d20:	0f a9                	pop    %gs
  popl %fs
80105d22:	0f a1                	pop    %fs
  popl %es
80105d24:	07                   	pop    %es
  popl %ds
80105d25:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d26:	83 c4 08             	add    $0x8,%esp
  iret
80105d29:	cf                   	iret
80105d2a:	66 90                	xchg   %ax,%ax
80105d2c:	66 90                	xchg   %ax,%ax
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d30:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d31:	31 c0                	xor    %eax,%eax
{
80105d33:	89 e5                	mov    %esp,%ebp
80105d35:	83 ec 08             	sub    $0x8,%esp
80105d38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d3f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d40:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105d47:	c7 04 c5 82 57 11 80 	movl   $0x8e000008,-0x7feea87e(,%eax,8)
80105d4e:	08 00 00 8e 
80105d52:	66 89 14 c5 80 57 11 	mov    %dx,-0x7feea880(,%eax,8)
80105d59:	80 
80105d5a:	c1 ea 10             	shr    $0x10,%edx
80105d5d:	66 89 14 c5 86 57 11 	mov    %dx,-0x7feea87a(,%eax,8)
80105d64:	80 
  for(i = 0; i < 256; i++)
80105d65:	83 c0 01             	add    $0x1,%eax
80105d68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d6d:	75 d1                	jne    80105d40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d6f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d72:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80105d77:	c7 05 82 59 11 80 08 	movl   $0xef000008,0x80115982
80105d7e:	00 00 ef 
  initlock(&tickslock, "time");
80105d81:	68 c5 7a 10 80       	push   $0x80107ac5
80105d86:	68 40 57 11 80       	push   $0x80115740
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d8b:	66 a3 80 59 11 80    	mov    %ax,0x80115980
80105d91:	c1 e8 10             	shr    $0x10,%eax
80105d94:	66 a3 86 59 11 80    	mov    %ax,0x80115986
  initlock(&tickslock, "time");
80105d9a:	e8 d1 e6 ff ff       	call   80104470 <initlock>
}
80105d9f:	83 c4 10             	add    $0x10,%esp
80105da2:	c9                   	leave
80105da3:	c3                   	ret
80105da4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dab:	00 
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105db0 <idtinit>:

void
idtinit(void)
{
80105db0:	55                   	push   %ebp
  pd[0] = size-1;
80105db1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105db6:	89 e5                	mov    %esp,%ebp
80105db8:	83 ec 10             	sub    $0x10,%esp
80105dbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105dbf:	b8 80 57 11 80       	mov    $0x80115780,%eax
80105dc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105dc8:	c1 e8 10             	shr    $0x10,%eax
80105dcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105dcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105dd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105dd5:	c9                   	leave
80105dd6:	c3                   	ret
80105dd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dde:	00 
80105ddf:	90                   	nop

80105de0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	57                   	push   %edi
80105de4:	56                   	push   %esi
80105de5:	53                   	push   %ebx
80105de6:	83 ec 1c             	sub    $0x1c,%esp
80105de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105dec:	8b 43 30             	mov    0x30(%ebx),%eax
80105def:	83 f8 40             	cmp    $0x40,%eax
80105df2:	0f 84 68 01 00 00    	je     80105f60 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105df8:	83 e8 20             	sub    $0x20,%eax
80105dfb:	83 f8 1f             	cmp    $0x1f,%eax
80105dfe:	0f 87 8c 00 00 00    	ja     80105e90 <trap+0xb0>
80105e04:	ff 24 85 28 80 10 80 	jmp    *-0x7fef7fd8(,%eax,4)
80105e0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e10:	e8 3b c4 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105e15:	e8 06 cb ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e1a:	e8 61 db ff ff       	call   80103980 <myproc>
80105e1f:	85 c0                	test   %eax,%eax
80105e21:	74 1d                	je     80105e40 <trap+0x60>
80105e23:	e8 58 db ff ff       	call   80103980 <myproc>
80105e28:	8b 50 24             	mov    0x24(%eax),%edx
80105e2b:	85 d2                	test   %edx,%edx
80105e2d:	74 11                	je     80105e40 <trap+0x60>
80105e2f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e33:	83 e0 03             	and    $0x3,%eax
80105e36:	66 83 f8 03          	cmp    $0x3,%ax
80105e3a:	0f 84 e8 01 00 00    	je     80106028 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e40:	e8 3b db ff ff       	call   80103980 <myproc>
80105e45:	85 c0                	test   %eax,%eax
80105e47:	74 0f                	je     80105e58 <trap+0x78>
80105e49:	e8 32 db ff ff       	call   80103980 <myproc>
80105e4e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e52:	0f 84 b8 00 00 00    	je     80105f10 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e58:	e8 23 db ff ff       	call   80103980 <myproc>
80105e5d:	85 c0                	test   %eax,%eax
80105e5f:	74 1d                	je     80105e7e <trap+0x9e>
80105e61:	e8 1a db ff ff       	call   80103980 <myproc>
80105e66:	8b 40 24             	mov    0x24(%eax),%eax
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	74 11                	je     80105e7e <trap+0x9e>
80105e6d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e71:	83 e0 03             	and    $0x3,%eax
80105e74:	66 83 f8 03          	cmp    $0x3,%ax
80105e78:	0f 84 0f 01 00 00    	je     80105f8d <trap+0x1ad>
    exit();
}
80105e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e81:	5b                   	pop    %ebx
80105e82:	5e                   	pop    %esi
80105e83:	5f                   	pop    %edi
80105e84:	5d                   	pop    %ebp
80105e85:	c3                   	ret
80105e86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e8d:	00 
80105e8e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e90:	e8 eb da ff ff       	call   80103980 <myproc>
80105e95:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e98:	85 c0                	test   %eax,%eax
80105e9a:	0f 84 a2 01 00 00    	je     80106042 <trap+0x262>
80105ea0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ea4:	0f 84 98 01 00 00    	je     80106042 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eaa:	0f 20 d1             	mov    %cr2,%ecx
80105ead:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eb0:	e8 ab da ff ff       	call   80103960 <cpuid>
80105eb5:	8b 73 30             	mov    0x30(%ebx),%esi
80105eb8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ebb:	8b 43 34             	mov    0x34(%ebx),%eax
80105ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ec1:	e8 ba da ff ff       	call   80103980 <myproc>
80105ec6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ec9:	e8 b2 da ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ece:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ed1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ed4:	51                   	push   %ecx
80105ed5:	57                   	push   %edi
80105ed6:	52                   	push   %edx
80105ed7:	ff 75 e4             	push   -0x1c(%ebp)
80105eda:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105edb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105ede:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ee1:	56                   	push   %esi
80105ee2:	ff 70 10             	push   0x10(%eax)
80105ee5:	68 14 7d 10 80       	push   $0x80107d14
80105eea:	e8 b1 a7 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105eef:	83 c4 20             	add    $0x20,%esp
80105ef2:	e8 89 da ff ff       	call   80103980 <myproc>
80105ef7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105efe:	e8 7d da ff ff       	call   80103980 <myproc>
80105f03:	85 c0                	test   %eax,%eax
80105f05:	0f 85 18 ff ff ff    	jne    80105e23 <trap+0x43>
80105f0b:	e9 30 ff ff ff       	jmp    80105e40 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105f10:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f14:	0f 85 3e ff ff ff    	jne    80105e58 <trap+0x78>
    yield();
80105f1a:	e8 71 e1 ff ff       	call   80104090 <yield>
80105f1f:	e9 34 ff ff ff       	jmp    80105e58 <trap+0x78>
80105f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f28:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f2b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f2f:	e8 2c da ff ff       	call   80103960 <cpuid>
80105f34:	57                   	push   %edi
80105f35:	56                   	push   %esi
80105f36:	50                   	push   %eax
80105f37:	68 bc 7c 10 80       	push   $0x80107cbc
80105f3c:	e8 5f a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105f41:	e8 da c9 ff ff       	call   80102920 <lapiceoi>
    break;
80105f46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f49:	e8 32 da ff ff       	call   80103980 <myproc>
80105f4e:	85 c0                	test   %eax,%eax
80105f50:	0f 85 cd fe ff ff    	jne    80105e23 <trap+0x43>
80105f56:	e9 e5 fe ff ff       	jmp    80105e40 <trap+0x60>
80105f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f60:	e8 1b da ff ff       	call   80103980 <myproc>
80105f65:	8b 70 24             	mov    0x24(%eax),%esi
80105f68:	85 f6                	test   %esi,%esi
80105f6a:	0f 85 c8 00 00 00    	jne    80106038 <trap+0x258>
    myproc()->tf = tf;
80105f70:	e8 0b da ff ff       	call   80103980 <myproc>
80105f75:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105f78:	e8 e3 eb ff ff       	call   80104b60 <syscall>
    if(myproc()->killed)
80105f7d:	e8 fe d9 ff ff       	call   80103980 <myproc>
80105f82:	8b 48 24             	mov    0x24(%eax),%ecx
80105f85:	85 c9                	test   %ecx,%ecx
80105f87:	0f 84 f1 fe ff ff    	je     80105e7e <trap+0x9e>
}
80105f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f90:	5b                   	pop    %ebx
80105f91:	5e                   	pop    %esi
80105f92:	5f                   	pop    %edi
80105f93:	5d                   	pop    %ebp
      exit();
80105f94:	e9 07 de ff ff       	jmp    80103da0 <exit>
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fa0:	e8 3b 02 00 00       	call   801061e0 <uartintr>
    lapiceoi();
80105fa5:	e8 76 c9 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105faa:	e8 d1 d9 ff ff       	call   80103980 <myproc>
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	0f 85 6c fe ff ff    	jne    80105e23 <trap+0x43>
80105fb7:	e9 84 fe ff ff       	jmp    80105e40 <trap+0x60>
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fc0:	e8 1b c8 ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80105fc5:	e8 56 c9 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fca:	e8 b1 d9 ff ff       	call   80103980 <myproc>
80105fcf:	85 c0                	test   %eax,%eax
80105fd1:	0f 85 4c fe ff ff    	jne    80105e23 <trap+0x43>
80105fd7:	e9 64 fe ff ff       	jmp    80105e40 <trap+0x60>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105fe0:	e8 7b d9 ff ff       	call   80103960 <cpuid>
80105fe5:	85 c0                	test   %eax,%eax
80105fe7:	0f 85 28 fe ff ff    	jne    80105e15 <trap+0x35>
      acquire(&tickslock);
80105fed:	83 ec 0c             	sub    $0xc,%esp
80105ff0:	68 40 57 11 80       	push   $0x80115740
80105ff5:	e8 46 e6 ff ff       	call   80104640 <acquire>
      wakeup(&ticks);
80105ffa:	c7 04 24 20 57 11 80 	movl   $0x80115720,(%esp)
      ticks++;
80106001:	83 05 20 57 11 80 01 	addl   $0x1,0x80115720
      wakeup(&ticks);
80106008:	e8 93 e1 ff ff       	call   801041a0 <wakeup>
      release(&tickslock);
8010600d:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80106014:	e8 c7 e5 ff ff       	call   801045e0 <release>
80106019:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010601c:	e9 f4 fd ff ff       	jmp    80105e15 <trap+0x35>
80106021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106028:	e8 73 dd ff ff       	call   80103da0 <exit>
8010602d:	e9 0e fe ff ff       	jmp    80105e40 <trap+0x60>
80106032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106038:	e8 63 dd ff ff       	call   80103da0 <exit>
8010603d:	e9 2e ff ff ff       	jmp    80105f70 <trap+0x190>
80106042:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106045:	e8 16 d9 ff ff       	call   80103960 <cpuid>
8010604a:	83 ec 0c             	sub    $0xc,%esp
8010604d:	56                   	push   %esi
8010604e:	57                   	push   %edi
8010604f:	50                   	push   %eax
80106050:	ff 73 30             	push   0x30(%ebx)
80106053:	68 e0 7c 10 80       	push   $0x80107ce0
80106058:	e8 43 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010605d:	83 c4 14             	add    $0x14,%esp
80106060:	68 ca 7a 10 80       	push   $0x80107aca
80106065:	e8 16 a3 ff ff       	call   80100380 <panic>
8010606a:	66 90                	xchg   %ax,%ax
8010606c:	66 90                	xchg   %ax,%ax
8010606e:	66 90                	xchg   %ax,%ax

80106070 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106070:	a1 80 5f 11 80       	mov    0x80115f80,%eax
80106075:	85 c0                	test   %eax,%eax
80106077:	74 17                	je     80106090 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106079:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010607e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010607f:	a8 01                	test   $0x1,%al
80106081:	74 0d                	je     80106090 <uartgetc+0x20>
80106083:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106088:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106089:	0f b6 c0             	movzbl %al,%eax
8010608c:	c3                   	ret
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106095:	c3                   	ret
80106096:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010609d:	00 
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <uartinit>:
{
801060a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a1:	31 c9                	xor    %ecx,%ecx
801060a3:	89 c8                	mov    %ecx,%eax
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	57                   	push   %edi
801060a8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060ad:	56                   	push   %esi
801060ae:	89 fa                	mov    %edi,%edx
801060b0:	53                   	push   %ebx
801060b1:	83 ec 1c             	sub    $0x1c,%esp
801060b4:	ee                   	out    %al,(%dx)
801060b5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060bf:	89 f2                	mov    %esi,%edx
801060c1:	ee                   	out    %al,(%dx)
801060c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060cc:	ee                   	out    %al,(%dx)
801060cd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060d2:	89 c8                	mov    %ecx,%eax
801060d4:	89 da                	mov    %ebx,%edx
801060d6:	ee                   	out    %al,(%dx)
801060d7:	b8 03 00 00 00       	mov    $0x3,%eax
801060dc:	89 f2                	mov    %esi,%edx
801060de:	ee                   	out    %al,(%dx)
801060df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060e4:	89 c8                	mov    %ecx,%eax
801060e6:	ee                   	out    %al,(%dx)
801060e7:	b8 01 00 00 00       	mov    $0x1,%eax
801060ec:	89 da                	mov    %ebx,%edx
801060ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060f5:	3c ff                	cmp    $0xff,%al
801060f7:	74 78                	je     80106171 <uartinit+0xd1>
  uart = 1;
801060f9:	c7 05 80 5f 11 80 01 	movl   $0x1,0x80115f80
80106100:	00 00 00 
80106103:	89 fa                	mov    %edi,%edx
80106105:	ec                   	in     (%dx),%al
80106106:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010610b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010610c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010610f:	bf cf 7a 10 80       	mov    $0x80107acf,%edi
80106114:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106119:	6a 00                	push   $0x0
8010611b:	6a 04                	push   $0x4
8010611d:	e8 6e c3 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106122:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106126:	83 c4 10             	add    $0x10,%esp
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106130:	a1 80 5f 11 80       	mov    0x80115f80,%eax
80106135:	bb 80 00 00 00       	mov    $0x80,%ebx
8010613a:	85 c0                	test   %eax,%eax
8010613c:	75 14                	jne    80106152 <uartinit+0xb2>
8010613e:	eb 23                	jmp    80106163 <uartinit+0xc3>
    microdelay(10);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	6a 0a                	push   $0xa
80106145:	e8 f6 c7 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010614a:	83 c4 10             	add    $0x10,%esp
8010614d:	83 eb 01             	sub    $0x1,%ebx
80106150:	74 07                	je     80106159 <uartinit+0xb9>
80106152:	89 f2                	mov    %esi,%edx
80106154:	ec                   	in     (%dx),%al
80106155:	a8 20                	test   $0x20,%al
80106157:	74 e7                	je     80106140 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106159:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010615d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106162:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106163:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106167:	83 c7 01             	add    $0x1,%edi
8010616a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010616d:	84 c0                	test   %al,%al
8010616f:	75 bf                	jne    80106130 <uartinit+0x90>
}
80106171:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106174:	5b                   	pop    %ebx
80106175:	5e                   	pop    %esi
80106176:	5f                   	pop    %edi
80106177:	5d                   	pop    %ebp
80106178:	c3                   	ret
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106180 <uartputc>:
  if(!uart)
80106180:	a1 80 5f 11 80       	mov    0x80115f80,%eax
80106185:	85 c0                	test   %eax,%eax
80106187:	74 47                	je     801061d0 <uartputc+0x50>
{
80106189:	55                   	push   %ebp
8010618a:	89 e5                	mov    %esp,%ebp
8010618c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010618d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106192:	53                   	push   %ebx
80106193:	bb 80 00 00 00       	mov    $0x80,%ebx
80106198:	eb 18                	jmp    801061b2 <uartputc+0x32>
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061a0:	83 ec 0c             	sub    $0xc,%esp
801061a3:	6a 0a                	push   $0xa
801061a5:	e8 96 c7 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061aa:	83 c4 10             	add    $0x10,%esp
801061ad:	83 eb 01             	sub    $0x1,%ebx
801061b0:	74 07                	je     801061b9 <uartputc+0x39>
801061b2:	89 f2                	mov    %esi,%edx
801061b4:	ec                   	in     (%dx),%al
801061b5:	a8 20                	test   $0x20,%al
801061b7:	74 e7                	je     801061a0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061b9:	8b 45 08             	mov    0x8(%ebp),%eax
801061bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061c1:	ee                   	out    %al,(%dx)
}
801061c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061c5:	5b                   	pop    %ebx
801061c6:	5e                   	pop    %esi
801061c7:	5d                   	pop    %ebp
801061c8:	c3                   	ret
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061d0:	c3                   	ret
801061d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061d8:	00 
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061e0 <uartintr>:

void
uartintr(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061e6:	68 70 60 10 80       	push   $0x80106070
801061eb:	e8 90 a6 ff ff       	call   80100880 <consoleintr>
}
801061f0:	83 c4 10             	add    $0x10,%esp
801061f3:	c9                   	leave
801061f4:	c3                   	ret

801061f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $0
801061f7:	6a 00                	push   $0x0
  jmp alltraps
801061f9:	e9 09 fb ff ff       	jmp    80105d07 <alltraps>

801061fe <vector1>:
.globl vector1
vector1:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $1
80106200:	6a 01                	push   $0x1
  jmp alltraps
80106202:	e9 00 fb ff ff       	jmp    80105d07 <alltraps>

80106207 <vector2>:
.globl vector2
vector2:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $2
80106209:	6a 02                	push   $0x2
  jmp alltraps
8010620b:	e9 f7 fa ff ff       	jmp    80105d07 <alltraps>

80106210 <vector3>:
.globl vector3
vector3:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $3
80106212:	6a 03                	push   $0x3
  jmp alltraps
80106214:	e9 ee fa ff ff       	jmp    80105d07 <alltraps>

80106219 <vector4>:
.globl vector4
vector4:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $4
8010621b:	6a 04                	push   $0x4
  jmp alltraps
8010621d:	e9 e5 fa ff ff       	jmp    80105d07 <alltraps>

80106222 <vector5>:
.globl vector5
vector5:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $5
80106224:	6a 05                	push   $0x5
  jmp alltraps
80106226:	e9 dc fa ff ff       	jmp    80105d07 <alltraps>

8010622b <vector6>:
.globl vector6
vector6:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $6
8010622d:	6a 06                	push   $0x6
  jmp alltraps
8010622f:	e9 d3 fa ff ff       	jmp    80105d07 <alltraps>

80106234 <vector7>:
.globl vector7
vector7:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $7
80106236:	6a 07                	push   $0x7
  jmp alltraps
80106238:	e9 ca fa ff ff       	jmp    80105d07 <alltraps>

8010623d <vector8>:
.globl vector8
vector8:
  pushl $8
8010623d:	6a 08                	push   $0x8
  jmp alltraps
8010623f:	e9 c3 fa ff ff       	jmp    80105d07 <alltraps>

80106244 <vector9>:
.globl vector9
vector9:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $9
80106246:	6a 09                	push   $0x9
  jmp alltraps
80106248:	e9 ba fa ff ff       	jmp    80105d07 <alltraps>

8010624d <vector10>:
.globl vector10
vector10:
  pushl $10
8010624d:	6a 0a                	push   $0xa
  jmp alltraps
8010624f:	e9 b3 fa ff ff       	jmp    80105d07 <alltraps>

80106254 <vector11>:
.globl vector11
vector11:
  pushl $11
80106254:	6a 0b                	push   $0xb
  jmp alltraps
80106256:	e9 ac fa ff ff       	jmp    80105d07 <alltraps>

8010625b <vector12>:
.globl vector12
vector12:
  pushl $12
8010625b:	6a 0c                	push   $0xc
  jmp alltraps
8010625d:	e9 a5 fa ff ff       	jmp    80105d07 <alltraps>

80106262 <vector13>:
.globl vector13
vector13:
  pushl $13
80106262:	6a 0d                	push   $0xd
  jmp alltraps
80106264:	e9 9e fa ff ff       	jmp    80105d07 <alltraps>

80106269 <vector14>:
.globl vector14
vector14:
  pushl $14
80106269:	6a 0e                	push   $0xe
  jmp alltraps
8010626b:	e9 97 fa ff ff       	jmp    80105d07 <alltraps>

80106270 <vector15>:
.globl vector15
vector15:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $15
80106272:	6a 0f                	push   $0xf
  jmp alltraps
80106274:	e9 8e fa ff ff       	jmp    80105d07 <alltraps>

80106279 <vector16>:
.globl vector16
vector16:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $16
8010627b:	6a 10                	push   $0x10
  jmp alltraps
8010627d:	e9 85 fa ff ff       	jmp    80105d07 <alltraps>

80106282 <vector17>:
.globl vector17
vector17:
  pushl $17
80106282:	6a 11                	push   $0x11
  jmp alltraps
80106284:	e9 7e fa ff ff       	jmp    80105d07 <alltraps>

80106289 <vector18>:
.globl vector18
vector18:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $18
8010628b:	6a 12                	push   $0x12
  jmp alltraps
8010628d:	e9 75 fa ff ff       	jmp    80105d07 <alltraps>

80106292 <vector19>:
.globl vector19
vector19:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $19
80106294:	6a 13                	push   $0x13
  jmp alltraps
80106296:	e9 6c fa ff ff       	jmp    80105d07 <alltraps>

8010629b <vector20>:
.globl vector20
vector20:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $20
8010629d:	6a 14                	push   $0x14
  jmp alltraps
8010629f:	e9 63 fa ff ff       	jmp    80105d07 <alltraps>

801062a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $21
801062a6:	6a 15                	push   $0x15
  jmp alltraps
801062a8:	e9 5a fa ff ff       	jmp    80105d07 <alltraps>

801062ad <vector22>:
.globl vector22
vector22:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $22
801062af:	6a 16                	push   $0x16
  jmp alltraps
801062b1:	e9 51 fa ff ff       	jmp    80105d07 <alltraps>

801062b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $23
801062b8:	6a 17                	push   $0x17
  jmp alltraps
801062ba:	e9 48 fa ff ff       	jmp    80105d07 <alltraps>

801062bf <vector24>:
.globl vector24
vector24:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $24
801062c1:	6a 18                	push   $0x18
  jmp alltraps
801062c3:	e9 3f fa ff ff       	jmp    80105d07 <alltraps>

801062c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $25
801062ca:	6a 19                	push   $0x19
  jmp alltraps
801062cc:	e9 36 fa ff ff       	jmp    80105d07 <alltraps>

801062d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $26
801062d3:	6a 1a                	push   $0x1a
  jmp alltraps
801062d5:	e9 2d fa ff ff       	jmp    80105d07 <alltraps>

801062da <vector27>:
.globl vector27
vector27:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $27
801062dc:	6a 1b                	push   $0x1b
  jmp alltraps
801062de:	e9 24 fa ff ff       	jmp    80105d07 <alltraps>

801062e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $28
801062e5:	6a 1c                	push   $0x1c
  jmp alltraps
801062e7:	e9 1b fa ff ff       	jmp    80105d07 <alltraps>

801062ec <vector29>:
.globl vector29
vector29:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $29
801062ee:	6a 1d                	push   $0x1d
  jmp alltraps
801062f0:	e9 12 fa ff ff       	jmp    80105d07 <alltraps>

801062f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $30
801062f7:	6a 1e                	push   $0x1e
  jmp alltraps
801062f9:	e9 09 fa ff ff       	jmp    80105d07 <alltraps>

801062fe <vector31>:
.globl vector31
vector31:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $31
80106300:	6a 1f                	push   $0x1f
  jmp alltraps
80106302:	e9 00 fa ff ff       	jmp    80105d07 <alltraps>

80106307 <vector32>:
.globl vector32
vector32:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $32
80106309:	6a 20                	push   $0x20
  jmp alltraps
8010630b:	e9 f7 f9 ff ff       	jmp    80105d07 <alltraps>

80106310 <vector33>:
.globl vector33
vector33:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $33
80106312:	6a 21                	push   $0x21
  jmp alltraps
80106314:	e9 ee f9 ff ff       	jmp    80105d07 <alltraps>

80106319 <vector34>:
.globl vector34
vector34:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $34
8010631b:	6a 22                	push   $0x22
  jmp alltraps
8010631d:	e9 e5 f9 ff ff       	jmp    80105d07 <alltraps>

80106322 <vector35>:
.globl vector35
vector35:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $35
80106324:	6a 23                	push   $0x23
  jmp alltraps
80106326:	e9 dc f9 ff ff       	jmp    80105d07 <alltraps>

8010632b <vector36>:
.globl vector36
vector36:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $36
8010632d:	6a 24                	push   $0x24
  jmp alltraps
8010632f:	e9 d3 f9 ff ff       	jmp    80105d07 <alltraps>

80106334 <vector37>:
.globl vector37
vector37:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $37
80106336:	6a 25                	push   $0x25
  jmp alltraps
80106338:	e9 ca f9 ff ff       	jmp    80105d07 <alltraps>

8010633d <vector38>:
.globl vector38
vector38:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $38
8010633f:	6a 26                	push   $0x26
  jmp alltraps
80106341:	e9 c1 f9 ff ff       	jmp    80105d07 <alltraps>

80106346 <vector39>:
.globl vector39
vector39:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $39
80106348:	6a 27                	push   $0x27
  jmp alltraps
8010634a:	e9 b8 f9 ff ff       	jmp    80105d07 <alltraps>

8010634f <vector40>:
.globl vector40
vector40:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $40
80106351:	6a 28                	push   $0x28
  jmp alltraps
80106353:	e9 af f9 ff ff       	jmp    80105d07 <alltraps>

80106358 <vector41>:
.globl vector41
vector41:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $41
8010635a:	6a 29                	push   $0x29
  jmp alltraps
8010635c:	e9 a6 f9 ff ff       	jmp    80105d07 <alltraps>

80106361 <vector42>:
.globl vector42
vector42:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $42
80106363:	6a 2a                	push   $0x2a
  jmp alltraps
80106365:	e9 9d f9 ff ff       	jmp    80105d07 <alltraps>

8010636a <vector43>:
.globl vector43
vector43:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $43
8010636c:	6a 2b                	push   $0x2b
  jmp alltraps
8010636e:	e9 94 f9 ff ff       	jmp    80105d07 <alltraps>

80106373 <vector44>:
.globl vector44
vector44:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $44
80106375:	6a 2c                	push   $0x2c
  jmp alltraps
80106377:	e9 8b f9 ff ff       	jmp    80105d07 <alltraps>

8010637c <vector45>:
.globl vector45
vector45:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $45
8010637e:	6a 2d                	push   $0x2d
  jmp alltraps
80106380:	e9 82 f9 ff ff       	jmp    80105d07 <alltraps>

80106385 <vector46>:
.globl vector46
vector46:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $46
80106387:	6a 2e                	push   $0x2e
  jmp alltraps
80106389:	e9 79 f9 ff ff       	jmp    80105d07 <alltraps>

8010638e <vector47>:
.globl vector47
vector47:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $47
80106390:	6a 2f                	push   $0x2f
  jmp alltraps
80106392:	e9 70 f9 ff ff       	jmp    80105d07 <alltraps>

80106397 <vector48>:
.globl vector48
vector48:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $48
80106399:	6a 30                	push   $0x30
  jmp alltraps
8010639b:	e9 67 f9 ff ff       	jmp    80105d07 <alltraps>

801063a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $49
801063a2:	6a 31                	push   $0x31
  jmp alltraps
801063a4:	e9 5e f9 ff ff       	jmp    80105d07 <alltraps>

801063a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $50
801063ab:	6a 32                	push   $0x32
  jmp alltraps
801063ad:	e9 55 f9 ff ff       	jmp    80105d07 <alltraps>

801063b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $51
801063b4:	6a 33                	push   $0x33
  jmp alltraps
801063b6:	e9 4c f9 ff ff       	jmp    80105d07 <alltraps>

801063bb <vector52>:
.globl vector52
vector52:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $52
801063bd:	6a 34                	push   $0x34
  jmp alltraps
801063bf:	e9 43 f9 ff ff       	jmp    80105d07 <alltraps>

801063c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $53
801063c6:	6a 35                	push   $0x35
  jmp alltraps
801063c8:	e9 3a f9 ff ff       	jmp    80105d07 <alltraps>

801063cd <vector54>:
.globl vector54
vector54:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $54
801063cf:	6a 36                	push   $0x36
  jmp alltraps
801063d1:	e9 31 f9 ff ff       	jmp    80105d07 <alltraps>

801063d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $55
801063d8:	6a 37                	push   $0x37
  jmp alltraps
801063da:	e9 28 f9 ff ff       	jmp    80105d07 <alltraps>

801063df <vector56>:
.globl vector56
vector56:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $56
801063e1:	6a 38                	push   $0x38
  jmp alltraps
801063e3:	e9 1f f9 ff ff       	jmp    80105d07 <alltraps>

801063e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $57
801063ea:	6a 39                	push   $0x39
  jmp alltraps
801063ec:	e9 16 f9 ff ff       	jmp    80105d07 <alltraps>

801063f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $58
801063f3:	6a 3a                	push   $0x3a
  jmp alltraps
801063f5:	e9 0d f9 ff ff       	jmp    80105d07 <alltraps>

801063fa <vector59>:
.globl vector59
vector59:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $59
801063fc:	6a 3b                	push   $0x3b
  jmp alltraps
801063fe:	e9 04 f9 ff ff       	jmp    80105d07 <alltraps>

80106403 <vector60>:
.globl vector60
vector60:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $60
80106405:	6a 3c                	push   $0x3c
  jmp alltraps
80106407:	e9 fb f8 ff ff       	jmp    80105d07 <alltraps>

8010640c <vector61>:
.globl vector61
vector61:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $61
8010640e:	6a 3d                	push   $0x3d
  jmp alltraps
80106410:	e9 f2 f8 ff ff       	jmp    80105d07 <alltraps>

80106415 <vector62>:
.globl vector62
vector62:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $62
80106417:	6a 3e                	push   $0x3e
  jmp alltraps
80106419:	e9 e9 f8 ff ff       	jmp    80105d07 <alltraps>

8010641e <vector63>:
.globl vector63
vector63:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $63
80106420:	6a 3f                	push   $0x3f
  jmp alltraps
80106422:	e9 e0 f8 ff ff       	jmp    80105d07 <alltraps>

80106427 <vector64>:
.globl vector64
vector64:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $64
80106429:	6a 40                	push   $0x40
  jmp alltraps
8010642b:	e9 d7 f8 ff ff       	jmp    80105d07 <alltraps>

80106430 <vector65>:
.globl vector65
vector65:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $65
80106432:	6a 41                	push   $0x41
  jmp alltraps
80106434:	e9 ce f8 ff ff       	jmp    80105d07 <alltraps>

80106439 <vector66>:
.globl vector66
vector66:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $66
8010643b:	6a 42                	push   $0x42
  jmp alltraps
8010643d:	e9 c5 f8 ff ff       	jmp    80105d07 <alltraps>

80106442 <vector67>:
.globl vector67
vector67:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $67
80106444:	6a 43                	push   $0x43
  jmp alltraps
80106446:	e9 bc f8 ff ff       	jmp    80105d07 <alltraps>

8010644b <vector68>:
.globl vector68
vector68:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $68
8010644d:	6a 44                	push   $0x44
  jmp alltraps
8010644f:	e9 b3 f8 ff ff       	jmp    80105d07 <alltraps>

80106454 <vector69>:
.globl vector69
vector69:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $69
80106456:	6a 45                	push   $0x45
  jmp alltraps
80106458:	e9 aa f8 ff ff       	jmp    80105d07 <alltraps>

8010645d <vector70>:
.globl vector70
vector70:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $70
8010645f:	6a 46                	push   $0x46
  jmp alltraps
80106461:	e9 a1 f8 ff ff       	jmp    80105d07 <alltraps>

80106466 <vector71>:
.globl vector71
vector71:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $71
80106468:	6a 47                	push   $0x47
  jmp alltraps
8010646a:	e9 98 f8 ff ff       	jmp    80105d07 <alltraps>

8010646f <vector72>:
.globl vector72
vector72:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $72
80106471:	6a 48                	push   $0x48
  jmp alltraps
80106473:	e9 8f f8 ff ff       	jmp    80105d07 <alltraps>

80106478 <vector73>:
.globl vector73
vector73:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $73
8010647a:	6a 49                	push   $0x49
  jmp alltraps
8010647c:	e9 86 f8 ff ff       	jmp    80105d07 <alltraps>

80106481 <vector74>:
.globl vector74
vector74:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $74
80106483:	6a 4a                	push   $0x4a
  jmp alltraps
80106485:	e9 7d f8 ff ff       	jmp    80105d07 <alltraps>

8010648a <vector75>:
.globl vector75
vector75:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $75
8010648c:	6a 4b                	push   $0x4b
  jmp alltraps
8010648e:	e9 74 f8 ff ff       	jmp    80105d07 <alltraps>

80106493 <vector76>:
.globl vector76
vector76:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $76
80106495:	6a 4c                	push   $0x4c
  jmp alltraps
80106497:	e9 6b f8 ff ff       	jmp    80105d07 <alltraps>

8010649c <vector77>:
.globl vector77
vector77:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $77
8010649e:	6a 4d                	push   $0x4d
  jmp alltraps
801064a0:	e9 62 f8 ff ff       	jmp    80105d07 <alltraps>

801064a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $78
801064a7:	6a 4e                	push   $0x4e
  jmp alltraps
801064a9:	e9 59 f8 ff ff       	jmp    80105d07 <alltraps>

801064ae <vector79>:
.globl vector79
vector79:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $79
801064b0:	6a 4f                	push   $0x4f
  jmp alltraps
801064b2:	e9 50 f8 ff ff       	jmp    80105d07 <alltraps>

801064b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $80
801064b9:	6a 50                	push   $0x50
  jmp alltraps
801064bb:	e9 47 f8 ff ff       	jmp    80105d07 <alltraps>

801064c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $81
801064c2:	6a 51                	push   $0x51
  jmp alltraps
801064c4:	e9 3e f8 ff ff       	jmp    80105d07 <alltraps>

801064c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $82
801064cb:	6a 52                	push   $0x52
  jmp alltraps
801064cd:	e9 35 f8 ff ff       	jmp    80105d07 <alltraps>

801064d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $83
801064d4:	6a 53                	push   $0x53
  jmp alltraps
801064d6:	e9 2c f8 ff ff       	jmp    80105d07 <alltraps>

801064db <vector84>:
.globl vector84
vector84:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $84
801064dd:	6a 54                	push   $0x54
  jmp alltraps
801064df:	e9 23 f8 ff ff       	jmp    80105d07 <alltraps>

801064e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $85
801064e6:	6a 55                	push   $0x55
  jmp alltraps
801064e8:	e9 1a f8 ff ff       	jmp    80105d07 <alltraps>

801064ed <vector86>:
.globl vector86
vector86:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $86
801064ef:	6a 56                	push   $0x56
  jmp alltraps
801064f1:	e9 11 f8 ff ff       	jmp    80105d07 <alltraps>

801064f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $87
801064f8:	6a 57                	push   $0x57
  jmp alltraps
801064fa:	e9 08 f8 ff ff       	jmp    80105d07 <alltraps>

801064ff <vector88>:
.globl vector88
vector88:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $88
80106501:	6a 58                	push   $0x58
  jmp alltraps
80106503:	e9 ff f7 ff ff       	jmp    80105d07 <alltraps>

80106508 <vector89>:
.globl vector89
vector89:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $89
8010650a:	6a 59                	push   $0x59
  jmp alltraps
8010650c:	e9 f6 f7 ff ff       	jmp    80105d07 <alltraps>

80106511 <vector90>:
.globl vector90
vector90:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $90
80106513:	6a 5a                	push   $0x5a
  jmp alltraps
80106515:	e9 ed f7 ff ff       	jmp    80105d07 <alltraps>

8010651a <vector91>:
.globl vector91
vector91:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $91
8010651c:	6a 5b                	push   $0x5b
  jmp alltraps
8010651e:	e9 e4 f7 ff ff       	jmp    80105d07 <alltraps>

80106523 <vector92>:
.globl vector92
vector92:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $92
80106525:	6a 5c                	push   $0x5c
  jmp alltraps
80106527:	e9 db f7 ff ff       	jmp    80105d07 <alltraps>

8010652c <vector93>:
.globl vector93
vector93:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $93
8010652e:	6a 5d                	push   $0x5d
  jmp alltraps
80106530:	e9 d2 f7 ff ff       	jmp    80105d07 <alltraps>

80106535 <vector94>:
.globl vector94
vector94:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $94
80106537:	6a 5e                	push   $0x5e
  jmp alltraps
80106539:	e9 c9 f7 ff ff       	jmp    80105d07 <alltraps>

8010653e <vector95>:
.globl vector95
vector95:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $95
80106540:	6a 5f                	push   $0x5f
  jmp alltraps
80106542:	e9 c0 f7 ff ff       	jmp    80105d07 <alltraps>

80106547 <vector96>:
.globl vector96
vector96:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $96
80106549:	6a 60                	push   $0x60
  jmp alltraps
8010654b:	e9 b7 f7 ff ff       	jmp    80105d07 <alltraps>

80106550 <vector97>:
.globl vector97
vector97:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $97
80106552:	6a 61                	push   $0x61
  jmp alltraps
80106554:	e9 ae f7 ff ff       	jmp    80105d07 <alltraps>

80106559 <vector98>:
.globl vector98
vector98:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $98
8010655b:	6a 62                	push   $0x62
  jmp alltraps
8010655d:	e9 a5 f7 ff ff       	jmp    80105d07 <alltraps>

80106562 <vector99>:
.globl vector99
vector99:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $99
80106564:	6a 63                	push   $0x63
  jmp alltraps
80106566:	e9 9c f7 ff ff       	jmp    80105d07 <alltraps>

8010656b <vector100>:
.globl vector100
vector100:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $100
8010656d:	6a 64                	push   $0x64
  jmp alltraps
8010656f:	e9 93 f7 ff ff       	jmp    80105d07 <alltraps>

80106574 <vector101>:
.globl vector101
vector101:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $101
80106576:	6a 65                	push   $0x65
  jmp alltraps
80106578:	e9 8a f7 ff ff       	jmp    80105d07 <alltraps>

8010657d <vector102>:
.globl vector102
vector102:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $102
8010657f:	6a 66                	push   $0x66
  jmp alltraps
80106581:	e9 81 f7 ff ff       	jmp    80105d07 <alltraps>

80106586 <vector103>:
.globl vector103
vector103:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $103
80106588:	6a 67                	push   $0x67
  jmp alltraps
8010658a:	e9 78 f7 ff ff       	jmp    80105d07 <alltraps>

8010658f <vector104>:
.globl vector104
vector104:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $104
80106591:	6a 68                	push   $0x68
  jmp alltraps
80106593:	e9 6f f7 ff ff       	jmp    80105d07 <alltraps>

80106598 <vector105>:
.globl vector105
vector105:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $105
8010659a:	6a 69                	push   $0x69
  jmp alltraps
8010659c:	e9 66 f7 ff ff       	jmp    80105d07 <alltraps>

801065a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $106
801065a3:	6a 6a                	push   $0x6a
  jmp alltraps
801065a5:	e9 5d f7 ff ff       	jmp    80105d07 <alltraps>

801065aa <vector107>:
.globl vector107
vector107:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $107
801065ac:	6a 6b                	push   $0x6b
  jmp alltraps
801065ae:	e9 54 f7 ff ff       	jmp    80105d07 <alltraps>

801065b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $108
801065b5:	6a 6c                	push   $0x6c
  jmp alltraps
801065b7:	e9 4b f7 ff ff       	jmp    80105d07 <alltraps>

801065bc <vector109>:
.globl vector109
vector109:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $109
801065be:	6a 6d                	push   $0x6d
  jmp alltraps
801065c0:	e9 42 f7 ff ff       	jmp    80105d07 <alltraps>

801065c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $110
801065c7:	6a 6e                	push   $0x6e
  jmp alltraps
801065c9:	e9 39 f7 ff ff       	jmp    80105d07 <alltraps>

801065ce <vector111>:
.globl vector111
vector111:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $111
801065d0:	6a 6f                	push   $0x6f
  jmp alltraps
801065d2:	e9 30 f7 ff ff       	jmp    80105d07 <alltraps>

801065d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $112
801065d9:	6a 70                	push   $0x70
  jmp alltraps
801065db:	e9 27 f7 ff ff       	jmp    80105d07 <alltraps>

801065e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $113
801065e2:	6a 71                	push   $0x71
  jmp alltraps
801065e4:	e9 1e f7 ff ff       	jmp    80105d07 <alltraps>

801065e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $114
801065eb:	6a 72                	push   $0x72
  jmp alltraps
801065ed:	e9 15 f7 ff ff       	jmp    80105d07 <alltraps>

801065f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $115
801065f4:	6a 73                	push   $0x73
  jmp alltraps
801065f6:	e9 0c f7 ff ff       	jmp    80105d07 <alltraps>

801065fb <vector116>:
.globl vector116
vector116:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $116
801065fd:	6a 74                	push   $0x74
  jmp alltraps
801065ff:	e9 03 f7 ff ff       	jmp    80105d07 <alltraps>

80106604 <vector117>:
.globl vector117
vector117:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $117
80106606:	6a 75                	push   $0x75
  jmp alltraps
80106608:	e9 fa f6 ff ff       	jmp    80105d07 <alltraps>

8010660d <vector118>:
.globl vector118
vector118:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $118
8010660f:	6a 76                	push   $0x76
  jmp alltraps
80106611:	e9 f1 f6 ff ff       	jmp    80105d07 <alltraps>

80106616 <vector119>:
.globl vector119
vector119:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $119
80106618:	6a 77                	push   $0x77
  jmp alltraps
8010661a:	e9 e8 f6 ff ff       	jmp    80105d07 <alltraps>

8010661f <vector120>:
.globl vector120
vector120:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $120
80106621:	6a 78                	push   $0x78
  jmp alltraps
80106623:	e9 df f6 ff ff       	jmp    80105d07 <alltraps>

80106628 <vector121>:
.globl vector121
vector121:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $121
8010662a:	6a 79                	push   $0x79
  jmp alltraps
8010662c:	e9 d6 f6 ff ff       	jmp    80105d07 <alltraps>

80106631 <vector122>:
.globl vector122
vector122:
  pushl $0
80106631:	6a 00                	push   $0x0
  pushl $122
80106633:	6a 7a                	push   $0x7a
  jmp alltraps
80106635:	e9 cd f6 ff ff       	jmp    80105d07 <alltraps>

8010663a <vector123>:
.globl vector123
vector123:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $123
8010663c:	6a 7b                	push   $0x7b
  jmp alltraps
8010663e:	e9 c4 f6 ff ff       	jmp    80105d07 <alltraps>

80106643 <vector124>:
.globl vector124
vector124:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $124
80106645:	6a 7c                	push   $0x7c
  jmp alltraps
80106647:	e9 bb f6 ff ff       	jmp    80105d07 <alltraps>

8010664c <vector125>:
.globl vector125
vector125:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $125
8010664e:	6a 7d                	push   $0x7d
  jmp alltraps
80106650:	e9 b2 f6 ff ff       	jmp    80105d07 <alltraps>

80106655 <vector126>:
.globl vector126
vector126:
  pushl $0
80106655:	6a 00                	push   $0x0
  pushl $126
80106657:	6a 7e                	push   $0x7e
  jmp alltraps
80106659:	e9 a9 f6 ff ff       	jmp    80105d07 <alltraps>

8010665e <vector127>:
.globl vector127
vector127:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $127
80106660:	6a 7f                	push   $0x7f
  jmp alltraps
80106662:	e9 a0 f6 ff ff       	jmp    80105d07 <alltraps>

80106667 <vector128>:
.globl vector128
vector128:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $128
80106669:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010666e:	e9 94 f6 ff ff       	jmp    80105d07 <alltraps>

80106673 <vector129>:
.globl vector129
vector129:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $129
80106675:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010667a:	e9 88 f6 ff ff       	jmp    80105d07 <alltraps>

8010667f <vector130>:
.globl vector130
vector130:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $130
80106681:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106686:	e9 7c f6 ff ff       	jmp    80105d07 <alltraps>

8010668b <vector131>:
.globl vector131
vector131:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $131
8010668d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106692:	e9 70 f6 ff ff       	jmp    80105d07 <alltraps>

80106697 <vector132>:
.globl vector132
vector132:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $132
80106699:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010669e:	e9 64 f6 ff ff       	jmp    80105d07 <alltraps>

801066a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $133
801066a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066aa:	e9 58 f6 ff ff       	jmp    80105d07 <alltraps>

801066af <vector134>:
.globl vector134
vector134:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $134
801066b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066b6:	e9 4c f6 ff ff       	jmp    80105d07 <alltraps>

801066bb <vector135>:
.globl vector135
vector135:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $135
801066bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066c2:	e9 40 f6 ff ff       	jmp    80105d07 <alltraps>

801066c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $136
801066c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066ce:	e9 34 f6 ff ff       	jmp    80105d07 <alltraps>

801066d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $137
801066d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066da:	e9 28 f6 ff ff       	jmp    80105d07 <alltraps>

801066df <vector138>:
.globl vector138
vector138:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $138
801066e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066e6:	e9 1c f6 ff ff       	jmp    80105d07 <alltraps>

801066eb <vector139>:
.globl vector139
vector139:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $139
801066ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066f2:	e9 10 f6 ff ff       	jmp    80105d07 <alltraps>

801066f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $140
801066f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066fe:	e9 04 f6 ff ff       	jmp    80105d07 <alltraps>

80106703 <vector141>:
.globl vector141
vector141:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $141
80106705:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010670a:	e9 f8 f5 ff ff       	jmp    80105d07 <alltraps>

8010670f <vector142>:
.globl vector142
vector142:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $142
80106711:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106716:	e9 ec f5 ff ff       	jmp    80105d07 <alltraps>

8010671b <vector143>:
.globl vector143
vector143:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $143
8010671d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106722:	e9 e0 f5 ff ff       	jmp    80105d07 <alltraps>

80106727 <vector144>:
.globl vector144
vector144:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $144
80106729:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010672e:	e9 d4 f5 ff ff       	jmp    80105d07 <alltraps>

80106733 <vector145>:
.globl vector145
vector145:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $145
80106735:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010673a:	e9 c8 f5 ff ff       	jmp    80105d07 <alltraps>

8010673f <vector146>:
.globl vector146
vector146:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $146
80106741:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106746:	e9 bc f5 ff ff       	jmp    80105d07 <alltraps>

8010674b <vector147>:
.globl vector147
vector147:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $147
8010674d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106752:	e9 b0 f5 ff ff       	jmp    80105d07 <alltraps>

80106757 <vector148>:
.globl vector148
vector148:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $148
80106759:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010675e:	e9 a4 f5 ff ff       	jmp    80105d07 <alltraps>

80106763 <vector149>:
.globl vector149
vector149:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $149
80106765:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010676a:	e9 98 f5 ff ff       	jmp    80105d07 <alltraps>

8010676f <vector150>:
.globl vector150
vector150:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $150
80106771:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106776:	e9 8c f5 ff ff       	jmp    80105d07 <alltraps>

8010677b <vector151>:
.globl vector151
vector151:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $151
8010677d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106782:	e9 80 f5 ff ff       	jmp    80105d07 <alltraps>

80106787 <vector152>:
.globl vector152
vector152:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $152
80106789:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010678e:	e9 74 f5 ff ff       	jmp    80105d07 <alltraps>

80106793 <vector153>:
.globl vector153
vector153:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $153
80106795:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010679a:	e9 68 f5 ff ff       	jmp    80105d07 <alltraps>

8010679f <vector154>:
.globl vector154
vector154:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $154
801067a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067a6:	e9 5c f5 ff ff       	jmp    80105d07 <alltraps>

801067ab <vector155>:
.globl vector155
vector155:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $155
801067ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067b2:	e9 50 f5 ff ff       	jmp    80105d07 <alltraps>

801067b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $156
801067b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067be:	e9 44 f5 ff ff       	jmp    80105d07 <alltraps>

801067c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $157
801067c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ca:	e9 38 f5 ff ff       	jmp    80105d07 <alltraps>

801067cf <vector158>:
.globl vector158
vector158:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $158
801067d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067d6:	e9 2c f5 ff ff       	jmp    80105d07 <alltraps>

801067db <vector159>:
.globl vector159
vector159:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $159
801067dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067e2:	e9 20 f5 ff ff       	jmp    80105d07 <alltraps>

801067e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $160
801067e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067ee:	e9 14 f5 ff ff       	jmp    80105d07 <alltraps>

801067f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $161
801067f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067fa:	e9 08 f5 ff ff       	jmp    80105d07 <alltraps>

801067ff <vector162>:
.globl vector162
vector162:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $162
80106801:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106806:	e9 fc f4 ff ff       	jmp    80105d07 <alltraps>

8010680b <vector163>:
.globl vector163
vector163:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $163
8010680d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106812:	e9 f0 f4 ff ff       	jmp    80105d07 <alltraps>

80106817 <vector164>:
.globl vector164
vector164:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $164
80106819:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010681e:	e9 e4 f4 ff ff       	jmp    80105d07 <alltraps>

80106823 <vector165>:
.globl vector165
vector165:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $165
80106825:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010682a:	e9 d8 f4 ff ff       	jmp    80105d07 <alltraps>

8010682f <vector166>:
.globl vector166
vector166:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $166
80106831:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106836:	e9 cc f4 ff ff       	jmp    80105d07 <alltraps>

8010683b <vector167>:
.globl vector167
vector167:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $167
8010683d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106842:	e9 c0 f4 ff ff       	jmp    80105d07 <alltraps>

80106847 <vector168>:
.globl vector168
vector168:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $168
80106849:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010684e:	e9 b4 f4 ff ff       	jmp    80105d07 <alltraps>

80106853 <vector169>:
.globl vector169
vector169:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $169
80106855:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010685a:	e9 a8 f4 ff ff       	jmp    80105d07 <alltraps>

8010685f <vector170>:
.globl vector170
vector170:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $170
80106861:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106866:	e9 9c f4 ff ff       	jmp    80105d07 <alltraps>

8010686b <vector171>:
.globl vector171
vector171:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $171
8010686d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106872:	e9 90 f4 ff ff       	jmp    80105d07 <alltraps>

80106877 <vector172>:
.globl vector172
vector172:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $172
80106879:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010687e:	e9 84 f4 ff ff       	jmp    80105d07 <alltraps>

80106883 <vector173>:
.globl vector173
vector173:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $173
80106885:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010688a:	e9 78 f4 ff ff       	jmp    80105d07 <alltraps>

8010688f <vector174>:
.globl vector174
vector174:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $174
80106891:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106896:	e9 6c f4 ff ff       	jmp    80105d07 <alltraps>

8010689b <vector175>:
.globl vector175
vector175:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $175
8010689d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068a2:	e9 60 f4 ff ff       	jmp    80105d07 <alltraps>

801068a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $176
801068a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068ae:	e9 54 f4 ff ff       	jmp    80105d07 <alltraps>

801068b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $177
801068b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068ba:	e9 48 f4 ff ff       	jmp    80105d07 <alltraps>

801068bf <vector178>:
.globl vector178
vector178:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $178
801068c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068c6:	e9 3c f4 ff ff       	jmp    80105d07 <alltraps>

801068cb <vector179>:
.globl vector179
vector179:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $179
801068cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068d2:	e9 30 f4 ff ff       	jmp    80105d07 <alltraps>

801068d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $180
801068d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068de:	e9 24 f4 ff ff       	jmp    80105d07 <alltraps>

801068e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $181
801068e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068ea:	e9 18 f4 ff ff       	jmp    80105d07 <alltraps>

801068ef <vector182>:
.globl vector182
vector182:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $182
801068f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068f6:	e9 0c f4 ff ff       	jmp    80105d07 <alltraps>

801068fb <vector183>:
.globl vector183
vector183:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $183
801068fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106902:	e9 00 f4 ff ff       	jmp    80105d07 <alltraps>

80106907 <vector184>:
.globl vector184
vector184:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $184
80106909:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010690e:	e9 f4 f3 ff ff       	jmp    80105d07 <alltraps>

80106913 <vector185>:
.globl vector185
vector185:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $185
80106915:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010691a:	e9 e8 f3 ff ff       	jmp    80105d07 <alltraps>

8010691f <vector186>:
.globl vector186
vector186:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $186
80106921:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106926:	e9 dc f3 ff ff       	jmp    80105d07 <alltraps>

8010692b <vector187>:
.globl vector187
vector187:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $187
8010692d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106932:	e9 d0 f3 ff ff       	jmp    80105d07 <alltraps>

80106937 <vector188>:
.globl vector188
vector188:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $188
80106939:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010693e:	e9 c4 f3 ff ff       	jmp    80105d07 <alltraps>

80106943 <vector189>:
.globl vector189
vector189:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $189
80106945:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010694a:	e9 b8 f3 ff ff       	jmp    80105d07 <alltraps>

8010694f <vector190>:
.globl vector190
vector190:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $190
80106951:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106956:	e9 ac f3 ff ff       	jmp    80105d07 <alltraps>

8010695b <vector191>:
.globl vector191
vector191:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $191
8010695d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106962:	e9 a0 f3 ff ff       	jmp    80105d07 <alltraps>

80106967 <vector192>:
.globl vector192
vector192:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $192
80106969:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010696e:	e9 94 f3 ff ff       	jmp    80105d07 <alltraps>

80106973 <vector193>:
.globl vector193
vector193:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $193
80106975:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010697a:	e9 88 f3 ff ff       	jmp    80105d07 <alltraps>

8010697f <vector194>:
.globl vector194
vector194:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $194
80106981:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106986:	e9 7c f3 ff ff       	jmp    80105d07 <alltraps>

8010698b <vector195>:
.globl vector195
vector195:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $195
8010698d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106992:	e9 70 f3 ff ff       	jmp    80105d07 <alltraps>

80106997 <vector196>:
.globl vector196
vector196:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $196
80106999:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010699e:	e9 64 f3 ff ff       	jmp    80105d07 <alltraps>

801069a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $197
801069a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069aa:	e9 58 f3 ff ff       	jmp    80105d07 <alltraps>

801069af <vector198>:
.globl vector198
vector198:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $198
801069b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069b6:	e9 4c f3 ff ff       	jmp    80105d07 <alltraps>

801069bb <vector199>:
.globl vector199
vector199:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $199
801069bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069c2:	e9 40 f3 ff ff       	jmp    80105d07 <alltraps>

801069c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $200
801069c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069ce:	e9 34 f3 ff ff       	jmp    80105d07 <alltraps>

801069d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $201
801069d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069da:	e9 28 f3 ff ff       	jmp    80105d07 <alltraps>

801069df <vector202>:
.globl vector202
vector202:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $202
801069e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069e6:	e9 1c f3 ff ff       	jmp    80105d07 <alltraps>

801069eb <vector203>:
.globl vector203
vector203:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $203
801069ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069f2:	e9 10 f3 ff ff       	jmp    80105d07 <alltraps>

801069f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $204
801069f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069fe:	e9 04 f3 ff ff       	jmp    80105d07 <alltraps>

80106a03 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $205
80106a05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a0a:	e9 f8 f2 ff ff       	jmp    80105d07 <alltraps>

80106a0f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $206
80106a11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a16:	e9 ec f2 ff ff       	jmp    80105d07 <alltraps>

80106a1b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $207
80106a1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a22:	e9 e0 f2 ff ff       	jmp    80105d07 <alltraps>

80106a27 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $208
80106a29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a2e:	e9 d4 f2 ff ff       	jmp    80105d07 <alltraps>

80106a33 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $209
80106a35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a3a:	e9 c8 f2 ff ff       	jmp    80105d07 <alltraps>

80106a3f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $210
80106a41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a46:	e9 bc f2 ff ff       	jmp    80105d07 <alltraps>

80106a4b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $211
80106a4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a52:	e9 b0 f2 ff ff       	jmp    80105d07 <alltraps>

80106a57 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $212
80106a59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a5e:	e9 a4 f2 ff ff       	jmp    80105d07 <alltraps>

80106a63 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $213
80106a65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a6a:	e9 98 f2 ff ff       	jmp    80105d07 <alltraps>

80106a6f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $214
80106a71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a76:	e9 8c f2 ff ff       	jmp    80105d07 <alltraps>

80106a7b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $215
80106a7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a82:	e9 80 f2 ff ff       	jmp    80105d07 <alltraps>

80106a87 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $216
80106a89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a8e:	e9 74 f2 ff ff       	jmp    80105d07 <alltraps>

80106a93 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $217
80106a95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a9a:	e9 68 f2 ff ff       	jmp    80105d07 <alltraps>

80106a9f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $218
80106aa1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106aa6:	e9 5c f2 ff ff       	jmp    80105d07 <alltraps>

80106aab <vector219>:
.globl vector219
vector219:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $219
80106aad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ab2:	e9 50 f2 ff ff       	jmp    80105d07 <alltraps>

80106ab7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $220
80106ab9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106abe:	e9 44 f2 ff ff       	jmp    80105d07 <alltraps>

80106ac3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $221
80106ac5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aca:	e9 38 f2 ff ff       	jmp    80105d07 <alltraps>

80106acf <vector222>:
.globl vector222
vector222:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $222
80106ad1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ad6:	e9 2c f2 ff ff       	jmp    80105d07 <alltraps>

80106adb <vector223>:
.globl vector223
vector223:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $223
80106add:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ae2:	e9 20 f2 ff ff       	jmp    80105d07 <alltraps>

80106ae7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $224
80106ae9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106aee:	e9 14 f2 ff ff       	jmp    80105d07 <alltraps>

80106af3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $225
80106af5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106afa:	e9 08 f2 ff ff       	jmp    80105d07 <alltraps>

80106aff <vector226>:
.globl vector226
vector226:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $226
80106b01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b06:	e9 fc f1 ff ff       	jmp    80105d07 <alltraps>

80106b0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $227
80106b0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b12:	e9 f0 f1 ff ff       	jmp    80105d07 <alltraps>

80106b17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $228
80106b19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b1e:	e9 e4 f1 ff ff       	jmp    80105d07 <alltraps>

80106b23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $229
80106b25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b2a:	e9 d8 f1 ff ff       	jmp    80105d07 <alltraps>

80106b2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $230
80106b31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b36:	e9 cc f1 ff ff       	jmp    80105d07 <alltraps>

80106b3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $231
80106b3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b42:	e9 c0 f1 ff ff       	jmp    80105d07 <alltraps>

80106b47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $232
80106b49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b4e:	e9 b4 f1 ff ff       	jmp    80105d07 <alltraps>

80106b53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $233
80106b55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b5a:	e9 a8 f1 ff ff       	jmp    80105d07 <alltraps>

80106b5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $234
80106b61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b66:	e9 9c f1 ff ff       	jmp    80105d07 <alltraps>

80106b6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $235
80106b6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b72:	e9 90 f1 ff ff       	jmp    80105d07 <alltraps>

80106b77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $236
80106b79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b7e:	e9 84 f1 ff ff       	jmp    80105d07 <alltraps>

80106b83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $237
80106b85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b8a:	e9 78 f1 ff ff       	jmp    80105d07 <alltraps>

80106b8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $238
80106b91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b96:	e9 6c f1 ff ff       	jmp    80105d07 <alltraps>

80106b9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $239
80106b9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ba2:	e9 60 f1 ff ff       	jmp    80105d07 <alltraps>

80106ba7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $240
80106ba9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bae:	e9 54 f1 ff ff       	jmp    80105d07 <alltraps>

80106bb3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $241
80106bb5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bba:	e9 48 f1 ff ff       	jmp    80105d07 <alltraps>

80106bbf <vector242>:
.globl vector242
vector242:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $242
80106bc1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bc6:	e9 3c f1 ff ff       	jmp    80105d07 <alltraps>

80106bcb <vector243>:
.globl vector243
vector243:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $243
80106bcd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bd2:	e9 30 f1 ff ff       	jmp    80105d07 <alltraps>

80106bd7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $244
80106bd9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bde:	e9 24 f1 ff ff       	jmp    80105d07 <alltraps>

80106be3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $245
80106be5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bea:	e9 18 f1 ff ff       	jmp    80105d07 <alltraps>

80106bef <vector246>:
.globl vector246
vector246:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $246
80106bf1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bf6:	e9 0c f1 ff ff       	jmp    80105d07 <alltraps>

80106bfb <vector247>:
.globl vector247
vector247:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $247
80106bfd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c02:	e9 00 f1 ff ff       	jmp    80105d07 <alltraps>

80106c07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $248
80106c09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c0e:	e9 f4 f0 ff ff       	jmp    80105d07 <alltraps>

80106c13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $249
80106c15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c1a:	e9 e8 f0 ff ff       	jmp    80105d07 <alltraps>

80106c1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $250
80106c21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c26:	e9 dc f0 ff ff       	jmp    80105d07 <alltraps>

80106c2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $251
80106c2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c32:	e9 d0 f0 ff ff       	jmp    80105d07 <alltraps>

80106c37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $252
80106c39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c3e:	e9 c4 f0 ff ff       	jmp    80105d07 <alltraps>

80106c43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $253
80106c45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c4a:	e9 b8 f0 ff ff       	jmp    80105d07 <alltraps>

80106c4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $254
80106c51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c56:	e9 ac f0 ff ff       	jmp    80105d07 <alltraps>

80106c5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $255
80106c5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c62:	e9 a0 f0 ff ff       	jmp    80105d07 <alltraps>
80106c67:	66 90                	xchg   %ax,%ax
80106c69:	66 90                	xchg   %ax,%ax
80106c6b:	66 90                	xchg   %ax,%ax
80106c6d:	66 90                	xchg   %ax,%ax
80106c6f:	90                   	nop

80106c70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	57                   	push   %edi
80106c74:	56                   	push   %esi
80106c75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c82:	83 ec 1c             	sub    $0x1c,%esp
80106c85:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c88:	39 d3                	cmp    %edx,%ebx
80106c8a:	73 49                	jae    80106cd5 <deallocuvm.part.0+0x65>
80106c8c:	89 c7                	mov    %eax,%edi
80106c8e:	eb 0c                	jmp    80106c9c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c90:	83 c0 01             	add    $0x1,%eax
80106c93:	c1 e0 16             	shl    $0x16,%eax
80106c96:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c98:	39 da                	cmp    %ebx,%edx
80106c9a:	76 39                	jbe    80106cd5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106c9c:	89 d8                	mov    %ebx,%eax
80106c9e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106ca1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106ca4:	f6 c1 01             	test   $0x1,%cl
80106ca7:	74 e7                	je     80106c90 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106ca9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106cb1:	c1 ee 0a             	shr    $0xa,%esi
80106cb4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106cba:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106cc1:	85 f6                	test   %esi,%esi
80106cc3:	74 cb                	je     80106c90 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106cc5:	8b 06                	mov    (%esi),%eax
80106cc7:	a8 01                	test   $0x1,%al
80106cc9:	75 15                	jne    80106ce0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106ccb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cd1:	39 da                	cmp    %ebx,%edx
80106cd3:	77 c7                	ja     80106c9c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cdb:	5b                   	pop    %ebx
80106cdc:	5e                   	pop    %esi
80106cdd:	5f                   	pop    %edi
80106cde:	5d                   	pop    %ebp
80106cdf:	c3                   	ret
      if(pa == 0)
80106ce0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ce5:	74 25                	je     80106d0c <deallocuvm.part.0+0x9c>
      kfree(v);
80106ce7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cea:	05 00 00 00 80       	add    $0x80000000,%eax
80106cef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cf2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106cf8:	50                   	push   %eax
80106cf9:	e8 d2 b7 ff ff       	call   801024d0 <kfree>
      *pte = 0;
80106cfe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106d04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d07:	83 c4 10             	add    $0x10,%esp
80106d0a:	eb 8c                	jmp    80106c98 <deallocuvm.part.0+0x28>
        panic("kfree");
80106d0c:	83 ec 0c             	sub    $0xc,%esp
80106d0f:	68 2c 78 10 80       	push   $0x8010782c
80106d14:	e8 67 96 ff ff       	call   80100380 <panic>
80106d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d20 <mappages>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d26:	89 d3                	mov    %edx,%ebx
80106d28:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d2e:	83 ec 1c             	sub    $0x1c,%esp
80106d31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d34:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d40:	8b 45 08             	mov    0x8(%ebp),%eax
80106d43:	29 d8                	sub    %ebx,%eax
80106d45:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d48:	eb 3d                	jmp    80106d87 <mappages+0x67>
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d50:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d57:	c1 ea 0a             	shr    $0xa,%edx
80106d5a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d60:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d67:	85 c0                	test   %eax,%eax
80106d69:	74 75                	je     80106de0 <mappages+0xc0>
    if(*pte & PTE_P)
80106d6b:	f6 00 01             	testb  $0x1,(%eax)
80106d6e:	0f 85 86 00 00 00    	jne    80106dfa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d74:	0b 75 0c             	or     0xc(%ebp),%esi
80106d77:	83 ce 01             	or     $0x1,%esi
80106d7a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d7c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106d7f:	74 6f                	je     80106df0 <mappages+0xd0>
    a += PGSIZE;
80106d81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106d87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106d8a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d8d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106d90:	89 d8                	mov    %ebx,%eax
80106d92:	c1 e8 16             	shr    $0x16,%eax
80106d95:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106d98:	8b 07                	mov    (%edi),%eax
80106d9a:	a8 01                	test   $0x1,%al
80106d9c:	75 b2                	jne    80106d50 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d9e:	e8 ed b8 ff ff       	call   80102690 <kalloc>
80106da3:	85 c0                	test   %eax,%eax
80106da5:	74 39                	je     80106de0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106da7:	83 ec 04             	sub    $0x4,%esp
80106daa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106dad:	68 00 10 00 00       	push   $0x1000
80106db2:	6a 00                	push   $0x0
80106db4:	50                   	push   %eax
80106db5:	e8 46 d9 ff ff       	call   80104700 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106dbd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dc0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106dc6:	83 c8 07             	or     $0x7,%eax
80106dc9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106dcb:	89 d8                	mov    %ebx,%eax
80106dcd:	c1 e8 0a             	shr    $0xa,%eax
80106dd0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106dd5:	01 d0                	add    %edx,%eax
80106dd7:	eb 92                	jmp    80106d6b <mappages+0x4b>
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106de8:	5b                   	pop    %ebx
80106de9:	5e                   	pop    %esi
80106dea:	5f                   	pop    %edi
80106deb:	5d                   	pop    %ebp
80106dec:	c3                   	ret
80106ded:	8d 76 00             	lea    0x0(%esi),%esi
80106df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106df3:	31 c0                	xor    %eax,%eax
}
80106df5:	5b                   	pop    %ebx
80106df6:	5e                   	pop    %esi
80106df7:	5f                   	pop    %edi
80106df8:	5d                   	pop    %ebp
80106df9:	c3                   	ret
      panic("remap");
80106dfa:	83 ec 0c             	sub    $0xc,%esp
80106dfd:	68 d7 7a 10 80       	push   $0x80107ad7
80106e02:	e8 79 95 ff ff       	call   80100380 <panic>
80106e07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e0e:	00 
80106e0f:	90                   	nop

80106e10 <seginit>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e16:	e8 45 cb ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
80106e1b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e20:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e26:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e2a:	c7 80 d8 28 11 80 ff 	movl   $0xffff,-0x7feed728(%eax)
80106e31:	ff 00 00 
80106e34:	c7 80 dc 28 11 80 00 	movl   $0xcf9a00,-0x7feed724(%eax)
80106e3b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e3e:	c7 80 e0 28 11 80 ff 	movl   $0xffff,-0x7feed720(%eax)
80106e45:	ff 00 00 
80106e48:	c7 80 e4 28 11 80 00 	movl   $0xcf9200,-0x7feed71c(%eax)
80106e4f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e52:	c7 80 e8 28 11 80 ff 	movl   $0xffff,-0x7feed718(%eax)
80106e59:	ff 00 00 
80106e5c:	c7 80 ec 28 11 80 00 	movl   $0xcffa00,-0x7feed714(%eax)
80106e63:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e66:	c7 80 f0 28 11 80 ff 	movl   $0xffff,-0x7feed710(%eax)
80106e6d:	ff 00 00 
80106e70:	c7 80 f4 28 11 80 00 	movl   $0xcff200,-0x7feed70c(%eax)
80106e77:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e7a:	05 d0 28 11 80       	add    $0x801128d0,%eax
  pd[1] = (uint)p;
80106e7f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e83:	c1 e8 10             	shr    $0x10,%eax
80106e86:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e8a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e8d:	0f 01 10             	lgdtl  (%eax)
}
80106e90:	c9                   	leave
80106e91:	c3                   	ret
80106e92:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e99:	00 
80106e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ea0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ea0:	a1 84 5f 11 80       	mov    0x80115f84,%eax
80106ea5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eaa:	0f 22 d8             	mov    %eax,%cr3
}
80106ead:	c3                   	ret
80106eae:	66 90                	xchg   %ax,%ax

80106eb0 <switchuvm>:
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
80106eb6:	83 ec 1c             	sub    $0x1c,%esp
80106eb9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ebc:	85 f6                	test   %esi,%esi
80106ebe:	0f 84 cb 00 00 00    	je     80106f8f <switchuvm+0xdf>
  if(p->kstack == 0)
80106ec4:	8b 46 08             	mov    0x8(%esi),%eax
80106ec7:	85 c0                	test   %eax,%eax
80106ec9:	0f 84 da 00 00 00    	je     80106fa9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106ecf:	8b 46 04             	mov    0x4(%esi),%eax
80106ed2:	85 c0                	test   %eax,%eax
80106ed4:	0f 84 c2 00 00 00    	je     80106f9c <switchuvm+0xec>
  pushcli();
80106eda:	e8 11 d6 ff ff       	call   801044f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106edf:	e8 1c ca ff ff       	call   80103900 <mycpu>
80106ee4:	89 c3                	mov    %eax,%ebx
80106ee6:	e8 15 ca ff ff       	call   80103900 <mycpu>
80106eeb:	89 c7                	mov    %eax,%edi
80106eed:	e8 0e ca ff ff       	call   80103900 <mycpu>
80106ef2:	83 c7 08             	add    $0x8,%edi
80106ef5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ef8:	e8 03 ca ff ff       	call   80103900 <mycpu>
80106efd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f00:	ba 67 00 00 00       	mov    $0x67,%edx
80106f05:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f0c:	83 c0 08             	add    $0x8,%eax
80106f0f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f16:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f1b:	83 c1 08             	add    $0x8,%ecx
80106f1e:	c1 e8 18             	shr    $0x18,%eax
80106f21:	c1 e9 10             	shr    $0x10,%ecx
80106f24:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f2a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f30:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f35:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f3c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f41:	e8 ba c9 ff ff       	call   80103900 <mycpu>
80106f46:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f4d:	e8 ae c9 ff ff       	call   80103900 <mycpu>
80106f52:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f56:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f5f:	e8 9c c9 ff ff       	call   80103900 <mycpu>
80106f64:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f67:	e8 94 c9 ff ff       	call   80103900 <mycpu>
80106f6c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f70:	b8 28 00 00 00       	mov    $0x28,%eax
80106f75:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f78:	8b 46 04             	mov    0x4(%esi),%eax
80106f7b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f80:	0f 22 d8             	mov    %eax,%cr3
}
80106f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f86:	5b                   	pop    %ebx
80106f87:	5e                   	pop    %esi
80106f88:	5f                   	pop    %edi
80106f89:	5d                   	pop    %ebp
  popcli();
80106f8a:	e9 b1 d5 ff ff       	jmp    80104540 <popcli>
    panic("switchuvm: no process");
80106f8f:	83 ec 0c             	sub    $0xc,%esp
80106f92:	68 dd 7a 10 80       	push   $0x80107add
80106f97:	e8 e4 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106f9c:	83 ec 0c             	sub    $0xc,%esp
80106f9f:	68 08 7b 10 80       	push   $0x80107b08
80106fa4:	e8 d7 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106fa9:	83 ec 0c             	sub    $0xc,%esp
80106fac:	68 f3 7a 10 80       	push   $0x80107af3
80106fb1:	e8 ca 93 ff ff       	call   80100380 <panic>
80106fb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fbd:	00 
80106fbe:	66 90                	xchg   %ax,%ax

80106fc0 <inituvm>:
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fcc:	8b 75 10             	mov    0x10(%ebp),%esi
80106fcf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106fd5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fdb:	77 4b                	ja     80107028 <inituvm+0x68>
  mem = kalloc();
80106fdd:	e8 ae b6 ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80106fe2:	83 ec 04             	sub    $0x4,%esp
80106fe5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106fea:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106fec:	6a 00                	push   $0x0
80106fee:	50                   	push   %eax
80106fef:	e8 0c d7 ff ff       	call   80104700 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ff4:	58                   	pop    %eax
80106ff5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ffb:	5a                   	pop    %edx
80106ffc:	6a 06                	push   $0x6
80106ffe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107003:	31 d2                	xor    %edx,%edx
80107005:	50                   	push   %eax
80107006:	89 f8                	mov    %edi,%eax
80107008:	e8 13 fd ff ff       	call   80106d20 <mappages>
  memmove(mem, init, sz);
8010700d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107010:	89 75 10             	mov    %esi,0x10(%ebp)
80107013:	83 c4 10             	add    $0x10,%esp
80107016:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107019:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010701c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010701f:	5b                   	pop    %ebx
80107020:	5e                   	pop    %esi
80107021:	5f                   	pop    %edi
80107022:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107023:	e9 78 d7 ff ff       	jmp    801047a0 <memmove>
    panic("inituvm: more than a page");
80107028:	83 ec 0c             	sub    $0xc,%esp
8010702b:	68 1c 7b 10 80       	push   $0x80107b1c
80107030:	e8 4b 93 ff ff       	call   80100380 <panic>
80107035:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010703c:	00 
8010703d:	8d 76 00             	lea    0x0(%esi),%esi

80107040 <loaduvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
80107049:	8b 45 0c             	mov    0xc(%ebp),%eax
8010704c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010704f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107054:	0f 85 bb 00 00 00    	jne    80107115 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010705a:	01 f0                	add    %esi,%eax
8010705c:	89 f3                	mov    %esi,%ebx
8010705e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107061:	8b 45 14             	mov    0x14(%ebp),%eax
80107064:	01 f0                	add    %esi,%eax
80107066:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107069:	85 f6                	test   %esi,%esi
8010706b:	0f 84 87 00 00 00    	je     801070f8 <loaduvm+0xb8>
80107071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010707b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010707e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107080:	89 c2                	mov    %eax,%edx
80107082:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107085:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107088:	f6 c2 01             	test   $0x1,%dl
8010708b:	75 13                	jne    801070a0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010708d:	83 ec 0c             	sub    $0xc,%esp
80107090:	68 36 7b 10 80       	push   $0x80107b36
80107095:	e8 e6 92 ff ff       	call   80100380 <panic>
8010709a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801070a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801070ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070b5:	85 c0                	test   %eax,%eax
801070b7:	74 d4                	je     8010708d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801070b9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801070be:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070c8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801070ce:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070d1:	29 d9                	sub    %ebx,%ecx
801070d3:	05 00 00 00 80       	add    $0x80000000,%eax
801070d8:	57                   	push   %edi
801070d9:	51                   	push   %ecx
801070da:	50                   	push   %eax
801070db:	ff 75 10             	push   0x10(%ebp)
801070de:	e8 bd a9 ff ff       	call   80101aa0 <readi>
801070e3:	83 c4 10             	add    $0x10,%esp
801070e6:	39 f8                	cmp    %edi,%eax
801070e8:	75 1e                	jne    80107108 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801070ea:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801070f0:	89 f0                	mov    %esi,%eax
801070f2:	29 d8                	sub    %ebx,%eax
801070f4:	39 c6                	cmp    %eax,%esi
801070f6:	77 80                	ja     80107078 <loaduvm+0x38>
}
801070f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070fb:	31 c0                	xor    %eax,%eax
}
801070fd:	5b                   	pop    %ebx
801070fe:	5e                   	pop    %esi
801070ff:	5f                   	pop    %edi
80107100:	5d                   	pop    %ebp
80107101:	c3                   	ret
80107102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107108:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010710b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107110:	5b                   	pop    %ebx
80107111:	5e                   	pop    %esi
80107112:	5f                   	pop    %edi
80107113:	5d                   	pop    %ebp
80107114:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80107115:	83 ec 0c             	sub    $0xc,%esp
80107118:	68 58 7d 10 80       	push   $0x80107d58
8010711d:	e8 5e 92 ff ff       	call   80100380 <panic>
80107122:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107129:	00 
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107130 <allocuvm>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107139:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010713c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010713f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107142:	85 c0                	test   %eax,%eax
80107144:	0f 88 b6 00 00 00    	js     80107200 <allocuvm+0xd0>
  if(newsz < oldsz)
8010714a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010714d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107150:	0f 82 9a 00 00 00    	jb     801071f0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107156:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010715c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107162:	39 75 10             	cmp    %esi,0x10(%ebp)
80107165:	77 44                	ja     801071ab <allocuvm+0x7b>
80107167:	e9 87 00 00 00       	jmp    801071f3 <allocuvm+0xc3>
8010716c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107170:	83 ec 04             	sub    $0x4,%esp
80107173:	68 00 10 00 00       	push   $0x1000
80107178:	6a 00                	push   $0x0
8010717a:	50                   	push   %eax
8010717b:	e8 80 d5 ff ff       	call   80104700 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107180:	58                   	pop    %eax
80107181:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107187:	5a                   	pop    %edx
80107188:	6a 06                	push   $0x6
8010718a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010718f:	89 f2                	mov    %esi,%edx
80107191:	50                   	push   %eax
80107192:	89 f8                	mov    %edi,%eax
80107194:	e8 87 fb ff ff       	call   80106d20 <mappages>
80107199:	83 c4 10             	add    $0x10,%esp
8010719c:	85 c0                	test   %eax,%eax
8010719e:	78 78                	js     80107218 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801071a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801071a9:	76 48                	jbe    801071f3 <allocuvm+0xc3>
    mem = kalloc();
801071ab:	e8 e0 b4 ff ff       	call   80102690 <kalloc>
801071b0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071b2:	85 c0                	test   %eax,%eax
801071b4:	75 ba                	jne    80107170 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071b6:	83 ec 0c             	sub    $0xc,%esp
801071b9:	68 54 7b 10 80       	push   $0x80107b54
801071be:	e8 dd 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801071c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071c6:	83 c4 10             	add    $0x10,%esp
801071c9:	39 45 10             	cmp    %eax,0x10(%ebp)
801071cc:	74 32                	je     80107200 <allocuvm+0xd0>
801071ce:	8b 55 10             	mov    0x10(%ebp),%edx
801071d1:	89 c1                	mov    %eax,%ecx
801071d3:	89 f8                	mov    %edi,%eax
801071d5:	e8 96 fa ff ff       	call   80106c70 <deallocuvm.part.0>
      return 0;
801071da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e7:	5b                   	pop    %ebx
801071e8:	5e                   	pop    %esi
801071e9:	5f                   	pop    %edi
801071ea:	5d                   	pop    %ebp
801071eb:	c3                   	ret
801071ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801071f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801071f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f9:	5b                   	pop    %ebx
801071fa:	5e                   	pop    %esi
801071fb:	5f                   	pop    %edi
801071fc:	5d                   	pop    %ebp
801071fd:	c3                   	ret
801071fe:	66 90                	xchg   %ax,%ax
    return 0;
80107200:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010720a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720d:	5b                   	pop    %ebx
8010720e:	5e                   	pop    %esi
8010720f:	5f                   	pop    %edi
80107210:	5d                   	pop    %ebp
80107211:	c3                   	ret
80107212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107218:	83 ec 0c             	sub    $0xc,%esp
8010721b:	68 6c 7b 10 80       	push   $0x80107b6c
80107220:	e8 7b 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107225:	8b 45 0c             	mov    0xc(%ebp),%eax
80107228:	83 c4 10             	add    $0x10,%esp
8010722b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010722e:	74 0c                	je     8010723c <allocuvm+0x10c>
80107230:	8b 55 10             	mov    0x10(%ebp),%edx
80107233:	89 c1                	mov    %eax,%ecx
80107235:	89 f8                	mov    %edi,%eax
80107237:	e8 34 fa ff ff       	call   80106c70 <deallocuvm.part.0>
      kfree(mem);
8010723c:	83 ec 0c             	sub    $0xc,%esp
8010723f:	53                   	push   %ebx
80107240:	e8 8b b2 ff ff       	call   801024d0 <kfree>
      return 0;
80107245:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010724c:	83 c4 10             	add    $0x10,%esp
}
8010724f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107252:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107255:	5b                   	pop    %ebx
80107256:	5e                   	pop    %esi
80107257:	5f                   	pop    %edi
80107258:	5d                   	pop    %ebp
80107259:	c3                   	ret
8010725a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107260 <deallocuvm>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	8b 55 0c             	mov    0xc(%ebp),%edx
80107266:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107269:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010726c:	39 d1                	cmp    %edx,%ecx
8010726e:	73 10                	jae    80107280 <deallocuvm+0x20>
}
80107270:	5d                   	pop    %ebp
80107271:	e9 fa f9 ff ff       	jmp    80106c70 <deallocuvm.part.0>
80107276:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010727d:	00 
8010727e:	66 90                	xchg   %ax,%ax
80107280:	89 d0                	mov    %edx,%eax
80107282:	5d                   	pop    %ebp
80107283:	c3                   	ret
80107284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010728b:	00 
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 0c             	sub    $0xc,%esp
80107299:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010729c:	85 f6                	test   %esi,%esi
8010729e:	74 59                	je     801072f9 <freevm+0x69>
  if(newsz >= oldsz)
801072a0:	31 c9                	xor    %ecx,%ecx
801072a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072a7:	89 f0                	mov    %esi,%eax
801072a9:	89 f3                	mov    %esi,%ebx
801072ab:	e8 c0 f9 ff ff       	call   80106c70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072b6:	eb 0f                	jmp    801072c7 <freevm+0x37>
801072b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072bf:	00 
801072c0:	83 c3 04             	add    $0x4,%ebx
801072c3:	39 df                	cmp    %ebx,%edi
801072c5:	74 23                	je     801072ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072c7:	8b 03                	mov    (%ebx),%eax
801072c9:	a8 01                	test   $0x1,%al
801072cb:	74 f3                	je     801072c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072d2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072dd:	50                   	push   %eax
801072de:	e8 ed b1 ff ff       	call   801024d0 <kfree>
801072e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072e6:	39 df                	cmp    %ebx,%edi
801072e8:	75 dd                	jne    801072c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f0:	5b                   	pop    %ebx
801072f1:	5e                   	pop    %esi
801072f2:	5f                   	pop    %edi
801072f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072f4:	e9 d7 b1 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
801072f9:	83 ec 0c             	sub    $0xc,%esp
801072fc:	68 88 7b 10 80       	push   $0x80107b88
80107301:	e8 7a 90 ff ff       	call   80100380 <panic>
80107306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010730d:	00 
8010730e:	66 90                	xchg   %ax,%ax

80107310 <setupkvm>:
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	56                   	push   %esi
80107314:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107315:	e8 76 b3 ff ff       	call   80102690 <kalloc>
8010731a:	89 c6                	mov    %eax,%esi
8010731c:	85 c0                	test   %eax,%eax
8010731e:	74 42                	je     80107362 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107320:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107323:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107328:	68 00 10 00 00       	push   $0x1000
8010732d:	6a 00                	push   $0x0
8010732f:	50                   	push   %eax
80107330:	e8 cb d3 ff ff       	call   80104700 <memset>
80107335:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107338:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010733b:	83 ec 08             	sub    $0x8,%esp
8010733e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107341:	ff 73 0c             	push   0xc(%ebx)
80107344:	8b 13                	mov    (%ebx),%edx
80107346:	50                   	push   %eax
80107347:	29 c1                	sub    %eax,%ecx
80107349:	89 f0                	mov    %esi,%eax
8010734b:	e8 d0 f9 ff ff       	call   80106d20 <mappages>
80107350:	83 c4 10             	add    $0x10,%esp
80107353:	85 c0                	test   %eax,%eax
80107355:	78 19                	js     80107370 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107357:	83 c3 10             	add    $0x10,%ebx
8010735a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107360:	75 d6                	jne    80107338 <setupkvm+0x28>
}
80107362:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107365:	89 f0                	mov    %esi,%eax
80107367:	5b                   	pop    %ebx
80107368:	5e                   	pop    %esi
80107369:	5d                   	pop    %ebp
8010736a:	c3                   	ret
8010736b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107370:	83 ec 0c             	sub    $0xc,%esp
80107373:	56                   	push   %esi
      return 0;
80107374:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107376:	e8 15 ff ff ff       	call   80107290 <freevm>
      return 0;
8010737b:	83 c4 10             	add    $0x10,%esp
}
8010737e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107381:	89 f0                	mov    %esi,%eax
80107383:	5b                   	pop    %ebx
80107384:	5e                   	pop    %esi
80107385:	5d                   	pop    %ebp
80107386:	c3                   	ret
80107387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010738e:	00 
8010738f:	90                   	nop

80107390 <kvmalloc>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107396:	e8 75 ff ff ff       	call   80107310 <setupkvm>
8010739b:	a3 84 5f 11 80       	mov    %eax,0x80115f84
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073a0:	05 00 00 00 80       	add    $0x80000000,%eax
801073a5:	0f 22 d8             	mov    %eax,%cr3
}
801073a8:	c9                   	leave
801073a9:	c3                   	ret
801073aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	83 ec 08             	sub    $0x8,%esp
801073b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073b9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073bc:	89 c1                	mov    %eax,%ecx
801073be:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073c1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073c4:	f6 c2 01             	test   $0x1,%dl
801073c7:	75 17                	jne    801073e0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073c9:	83 ec 0c             	sub    $0xc,%esp
801073cc:	68 99 7b 10 80       	push   $0x80107b99
801073d1:	e8 aa 8f ff ff       	call   80100380 <panic>
801073d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073dd:	00 
801073de:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801073e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801073e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801073ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801073f5:	85 c0                	test   %eax,%eax
801073f7:	74 d0                	je     801073c9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801073f9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073fc:	c9                   	leave
801073fd:	c3                   	ret
801073fe:	66 90                	xchg   %ax,%ax

80107400 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107409:	e8 02 ff ff ff       	call   80107310 <setupkvm>
8010740e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107411:	85 c0                	test   %eax,%eax
80107413:	0f 84 bd 00 00 00    	je     801074d6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010741c:	85 c9                	test   %ecx,%ecx
8010741e:	0f 84 b2 00 00 00    	je     801074d6 <copyuvm+0xd6>
80107424:	31 f6                	xor    %esi,%esi
80107426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010742d:	00 
8010742e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107430:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107433:	89 f0                	mov    %esi,%eax
80107435:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107438:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010743b:	a8 01                	test   $0x1,%al
8010743d:	75 11                	jne    80107450 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010743f:	83 ec 0c             	sub    $0xc,%esp
80107442:	68 a3 7b 10 80       	push   $0x80107ba3
80107447:	e8 34 8f ff ff       	call   80100380 <panic>
8010744c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107450:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107452:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107457:	c1 ea 0a             	shr    $0xa,%edx
8010745a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107460:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107467:	85 c0                	test   %eax,%eax
80107469:	74 d4                	je     8010743f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010746b:	8b 00                	mov    (%eax),%eax
8010746d:	a8 01                	test   $0x1,%al
8010746f:	0f 84 9f 00 00 00    	je     80107514 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107475:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107477:	25 ff 0f 00 00       	and    $0xfff,%eax
8010747c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010747f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107485:	e8 06 b2 ff ff       	call   80102690 <kalloc>
8010748a:	89 c3                	mov    %eax,%ebx
8010748c:	85 c0                	test   %eax,%eax
8010748e:	74 64                	je     801074f4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107490:	83 ec 04             	sub    $0x4,%esp
80107493:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107499:	68 00 10 00 00       	push   $0x1000
8010749e:	57                   	push   %edi
8010749f:	50                   	push   %eax
801074a0:	e8 fb d2 ff ff       	call   801047a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074a5:	58                   	pop    %eax
801074a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074ac:	5a                   	pop    %edx
801074ad:	ff 75 e4             	push   -0x1c(%ebp)
801074b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074b5:	89 f2                	mov    %esi,%edx
801074b7:	50                   	push   %eax
801074b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074bb:	e8 60 f8 ff ff       	call   80106d20 <mappages>
801074c0:	83 c4 10             	add    $0x10,%esp
801074c3:	85 c0                	test   %eax,%eax
801074c5:	78 21                	js     801074e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801074c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801074d0:	0f 87 5a ff ff ff    	ja     80107430 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801074d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074dc:	5b                   	pop    %ebx
801074dd:	5e                   	pop    %esi
801074de:	5f                   	pop    %edi
801074df:	5d                   	pop    %ebp
801074e0:	c3                   	ret
801074e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801074e8:	83 ec 0c             	sub    $0xc,%esp
801074eb:	53                   	push   %ebx
801074ec:	e8 df af ff ff       	call   801024d0 <kfree>
      goto bad;
801074f1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801074f4:	83 ec 0c             	sub    $0xc,%esp
801074f7:	ff 75 e0             	push   -0x20(%ebp)
801074fa:	e8 91 fd ff ff       	call   80107290 <freevm>
  return 0;
801074ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107506:	83 c4 10             	add    $0x10,%esp
}
80107509:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010750c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010750f:	5b                   	pop    %ebx
80107510:	5e                   	pop    %esi
80107511:	5f                   	pop    %edi
80107512:	5d                   	pop    %ebp
80107513:	c3                   	ret
      panic("copyuvm: page not present");
80107514:	83 ec 0c             	sub    $0xc,%esp
80107517:	68 bd 7b 10 80       	push   $0x80107bbd
8010751c:	e8 5f 8e ff ff       	call   80100380 <panic>
80107521:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107528:	00 
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107530 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107536:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107539:	89 c1                	mov    %eax,%ecx
8010753b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010753e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107541:	f6 c2 01             	test   $0x1,%dl
80107544:	0f 84 00 01 00 00    	je     8010764a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010754a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010754d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107553:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107554:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107559:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107560:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107562:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107567:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010756a:	05 00 00 00 80       	add    $0x80000000,%eax
8010756f:	83 fa 05             	cmp    $0x5,%edx
80107572:	ba 00 00 00 00       	mov    $0x0,%edx
80107577:	0f 45 c2             	cmovne %edx,%eax
}
8010757a:	c3                   	ret
8010757b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107580 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 0c             	sub    $0xc,%esp
80107589:	8b 75 14             	mov    0x14(%ebp),%esi
8010758c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010758f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107592:	85 f6                	test   %esi,%esi
80107594:	75 51                	jne    801075e7 <copyout+0x67>
80107596:	e9 a5 00 00 00       	jmp    80107640 <copyout+0xc0>
8010759b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801075a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801075a6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801075ac:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801075b2:	74 75                	je     80107629 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801075b4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075b6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801075b9:	29 c3                	sub    %eax,%ebx
801075bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075c1:	39 f3                	cmp    %esi,%ebx
801075c3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801075c6:	29 f8                	sub    %edi,%eax
801075c8:	83 ec 04             	sub    $0x4,%esp
801075cb:	01 c1                	add    %eax,%ecx
801075cd:	53                   	push   %ebx
801075ce:	52                   	push   %edx
801075cf:	51                   	push   %ecx
801075d0:	e8 cb d1 ff ff       	call   801047a0 <memmove>
    len -= n;
    buf += n;
801075d5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801075d8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801075de:	83 c4 10             	add    $0x10,%esp
    buf += n;
801075e1:	01 da                	add    %ebx,%edx
  while(len > 0){
801075e3:	29 de                	sub    %ebx,%esi
801075e5:	74 59                	je     80107640 <copyout+0xc0>
  if(*pde & PTE_P){
801075e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801075ea:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075ec:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801075ee:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075f1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801075f7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801075fa:	f6 c1 01             	test   $0x1,%cl
801075fd:	0f 84 4e 00 00 00    	je     80107651 <copyout.cold>
  return &pgtab[PTX(va)];
80107603:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107605:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010760b:	c1 eb 0c             	shr    $0xc,%ebx
8010760e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107614:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010761b:	89 d9                	mov    %ebx,%ecx
8010761d:	83 e1 05             	and    $0x5,%ecx
80107620:	83 f9 05             	cmp    $0x5,%ecx
80107623:	0f 84 77 ff ff ff    	je     801075a0 <copyout+0x20>
  }
  return 0;
}
80107629:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010762c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107631:	5b                   	pop    %ebx
80107632:	5e                   	pop    %esi
80107633:	5f                   	pop    %edi
80107634:	5d                   	pop    %ebp
80107635:	c3                   	ret
80107636:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010763d:	00 
8010763e:	66 90                	xchg   %ax,%ax
80107640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107643:	31 c0                	xor    %eax,%eax
}
80107645:	5b                   	pop    %ebx
80107646:	5e                   	pop    %esi
80107647:	5f                   	pop    %edi
80107648:	5d                   	pop    %ebp
80107649:	c3                   	ret

8010764a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010764a:	a1 00 00 00 00       	mov    0x0,%eax
8010764f:	0f 0b                	ud2

80107651 <copyout.cold>:
80107651:	a1 00 00 00 00       	mov    0x0,%eax
80107656:	0f 0b                	ud2
