
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
80100028:	bc 50 66 11 80       	mov    $0x80116650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 31 10 80       	mov    $0x80103170,%eax
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
8010004c:	68 80 76 10 80       	push   $0x80107680
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 a5 45 00 00       	call   80104600 <initlock>
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
80100092:	68 87 76 10 80       	push   $0x80107687
80100097:	50                   	push   %eax
80100098:	e8 33 44 00 00       	call   801044d0 <initsleeplock>
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
801000e4:	e8 e7 46 00 00       	call   801047d0 <acquire>
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
80100162:	e8 09 46 00 00       	call   80104770 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 43 00 00       	call   80104510 <acquiresleep>
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
8010018c:	e8 5f 22 00 00       	call   801023f0 <iderw>
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
801001a1:	68 8e 76 10 80       	push   $0x8010768e
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
801001be:	e8 ed 43 00 00       	call   801045b0 <holdingsleep>
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
801001d4:	e9 17 22 00 00       	jmp    801023f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 76 10 80       	push   $0x8010769f
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
801001ff:	e8 ac 43 00 00       	call   801045b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 43 00 00       	call   80104570 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 b0 45 00 00       	call   801047d0 <acquire>
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
8010026c:	e9 ff 44 00 00       	jmp    80104770 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 76 10 80       	push   $0x801076a6
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
80100294:	e8 d7 16 00 00       	call   80101970 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 2b 45 00 00       	call   801047d0 <acquire>
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
801002cd:	e8 9e 3f 00 00       	call   80104270 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 38 00 00       	call   80103b30 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 75 44 00 00       	call   80104770 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 15 00 00       	call   80101890 <ilock>
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
8010034c:	e8 1f 44 00 00       	call   80104770 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 15 00 00       	call   80101890 <ilock>
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
80100399:	e8 62 26 00 00       	call   80102a00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 76 10 80       	push   $0x801076ad
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 4e 7b 10 80 	movl   $0x80107b4e,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 42 00 00       	call   80104620 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 76 10 80       	push   $0x801076c1
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
8010041a:	e8 81 5d 00 00       	call   801061a0 <uartputc>
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
80100505:	e8 96 5c 00 00       	call   801061a0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 8a 5c 00 00       	call   801061a0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 7e 5c 00 00       	call   801061a0 <uartputc>
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
80100551:	e8 da 43 00 00       	call   80104930 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 25 43 00 00       	call   80104890 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 c5 76 10 80       	push   $0x801076c5
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
8010059f:	e8 cc 13 00 00       	call   80101970 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 20 42 00 00       	call   801047d0 <acquire>
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
801005e4:	e8 87 41 00 00       	call   80104770 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 9e 12 00 00       	call   80101890 <ilock>

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
80100636:	0f b6 92 a0 7b 10 80 	movzbl -0x7fef8460(%edx),%edx
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
801007e8:	e8 e3 3f 00 00       	call   801047d0 <acquire>
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
80100838:	bf d8 76 10 80       	mov    $0x801076d8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 10 3f 00 00       	call   80104770 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 df 76 10 80       	push   $0x801076df
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
80100893:	e8 38 3f 00 00       	call   801047d0 <acquire>
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
801009d0:	e8 9b 3d 00 00       	call   80104770 <release>
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
80100a0e:	e9 fd 39 00 00       	jmp    80104410 <procdump>
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
80100a44:	e8 e7 38 00 00       	call   80104330 <wakeup>
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
80100a66:	68 e8 76 10 80       	push   $0x801076e8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 8b 3b 00 00       	call   80104600 <initlock>

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
80100a99:	e8 f2 1a 00 00       	call   80102590 <ioapicenable>
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
80100abc:	e8 6f 30 00 00       	call   80103b30 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 23 00 00       	call   80102e70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 16 00 00       	call   801021b0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 0f 04 00 00    	je     80100ef1 <exec+0x441>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 a3 0d 00 00       	call   80101890 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 a2 10 00 00       	call   80101ba0 <readi>
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
80100b0a:	e8 11 10 00 00       	call   80101b20 <iunlockput>
    end_op();
80100b0f:	e8 cc 23 00 00       	call   80102ee0 <end_op>
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
80100b34:	e8 f7 67 00 00       	call   80107330 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 b9 03 00 00    	je     80100f10 <exec+0x460>
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
80100ba3:	e8 a8 65 00 00       	call   80107150 <allocuvm>
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
80100bd9:	e8 82 64 00 00       	call   80107060 <loaduvm>
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
80100c01:	e8 9a 0f 00 00       	call   80101ba0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 90 66 00 00       	call   801072b0 <freevm>
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
80100c4c:	e8 cf 0e 00 00       	call   80101b20 <iunlockput>
  end_op();
80100c51:	e8 8a 22 00 00       	call   80102ee0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c60:	57                   	push   %edi
80100c61:	56                   	push   %esi
80100c62:	e8 e9 64 00 00       	call   80107150 <allocuvm>
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
80100c83:	e8 48 67 00 00       	call   801073d0 <clearpteu>
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
80100cd3:	e8 b8 3d 00 00       	call   80104a90 <strlen>
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
80100ce7:	e8 a4 3d 00 00       	call   80104a90 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 a3 68 00 00       	call   801075a0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 9a 65 00 00       	call   801072b0 <freevm>
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
80100d6b:	e8 30 68 00 00       	call   801075a0 <copyout>
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
80100db5:	e8 96 3c 00 00       	call   80104a50 <safestrcpy>
  acquire(&ptable.lock);
80100dba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80100dc1:	e8 0a 3a 00 00       	call   801047d0 <acquire>
  for (int i = 0; i < history_count; i++) {
80100dc6:	8b 35 58 4c 11 80    	mov    0x80114c58,%esi
80100dcc:	83 c4 10             	add    $0x10,%esp
80100dcf:	85 f6                	test   %esi,%esi
80100dd1:	7e 4f                	jle    80100e22 <exec+0x372>
    if (process_history[i].pid == curproc->pid) {
80100dd3:	8b 5b 10             	mov    0x10(%ebx),%ebx
  for (int i = 0; i < history_count; i++) {
80100dd6:	31 c0                	xor    %eax,%eax
80100dd8:	eb 0d                	jmp    80100de7 <exec+0x337>
80100dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100de0:	83 c0 01             	add    $0x1,%eax
80100de3:	39 f0                	cmp    %esi,%eax
80100de5:	74 3b                	je     80100e22 <exec+0x372>
    if (process_history[i].pid == curproc->pid) {
80100de7:	8d 14 40             	lea    (%eax,%eax,2),%edx
80100dea:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80100df1:	39 1c d5 60 4c 11 80 	cmp    %ebx,-0x7feeb3a0(,%edx,8)
80100df8:	75 e6                	jne    80100de0 <exec+0x330>
      process_history[i].mem_usage = curproc->sz; // Capture memory before switching
80100dfa:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
      safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80100e00:	83 ec 04             	sub    $0x4,%esp
      process_history[i].mem_usage = curproc->sz; // Capture memory before switching
80100e03:	8b 00                	mov    (%eax),%eax
      safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80100e05:	6a 10                	push   $0x10
80100e07:	ff b5 e8 fe ff ff    	push   -0x118(%ebp)
      process_history[i].mem_usage = curproc->sz; // Capture memory before switching
80100e0d:	89 81 74 4c 11 80    	mov    %eax,-0x7feeb38c(%ecx)
      safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80100e13:	81 c1 64 4c 11 80    	add    $0x80114c64,%ecx
80100e19:	51                   	push   %ecx
80100e1a:	e8 31 3c 00 00       	call   80104a50 <safestrcpy>
      break;
80100e1f:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80100e22:	83 ec 0c             	sub    $0xc,%esp
80100e25:	68 20 2d 11 80       	push   $0x80112d20
80100e2a:	e8 41 39 00 00       	call   80104770 <release>
  oldpgdir = curproc->pgdir;
80100e2f:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  curproc->pgdir = pgdir;
80100e35:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100e3b:	8b 5e 04             	mov    0x4(%esi),%ebx
  curproc->sz = sz;
80100e3e:	89 3e                	mov    %edi,(%esi)
  curproc->pgdir = pgdir;
80100e40:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->tf->eip = elf.entry;  // main
80100e43:	8b 46 18             	mov    0x18(%esi),%eax
80100e46:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e4c:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e4f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e55:	8b 46 18             	mov    0x18(%esi),%eax
80100e58:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100e5b:	89 34 24             	mov    %esi,(%esp)
80100e5e:	e8 6d 60 00 00       	call   80106ed0 <switchuvm>
  freevm(oldpgdir);
80100e63:	89 1c 24             	mov    %ebx,(%esp)
80100e66:	e8 45 64 00 00       	call   801072b0 <freevm>
  acquire(&ptable.lock);
80100e6b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80100e72:	e8 59 39 00 00       	call   801047d0 <acquire>
  for (int i = 0; i < history_count; i++) {
80100e77:	8b 1d 58 4c 11 80    	mov    0x80114c58,%ebx
80100e7d:	83 c4 10             	add    $0x10,%esp
80100e80:	85 db                	test   %ebx,%ebx
80100e82:	7e 56                	jle    80100eda <exec+0x42a>
      if (process_history[i].pid == curproc->pid) {
80100e84:	8b 76 10             	mov    0x10(%esi),%esi
  for (int i = 0; i < history_count; i++) {
80100e87:	31 c0                	xor    %eax,%eax
80100e89:	eb 0c                	jmp    80100e97 <exec+0x3e7>
80100e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e90:	83 c0 01             	add    $0x1,%eax
80100e93:	39 d8                	cmp    %ebx,%eax
80100e95:	74 43                	je     80100eda <exec+0x42a>
      if (process_history[i].pid == curproc->pid) {
80100e97:	8d 14 40             	lea    (%eax,%eax,2),%edx
80100e9a:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80100ea1:	39 34 d5 60 4c 11 80 	cmp    %esi,-0x7feeb3a0(,%edx,8)
80100ea8:	75 e6                	jne    80100e90 <exec+0x3e0>
          if(curproc->sz > process_history[i].mem_usage) {
80100eaa:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100eb0:	8b 00                	mov    (%eax),%eax
80100eb2:	3b 81 74 4c 11 80    	cmp    -0x7feeb38c(%ecx),%eax
80100eb8:	76 06                	jbe    80100ec0 <exec+0x410>
            process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
80100eba:	89 81 74 4c 11 80    	mov    %eax,-0x7feeb38c(%ecx)
          safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80100ec0:	83 ec 04             	sub    $0x4,%esp
80100ec3:	81 c1 64 4c 11 80    	add    $0x80114c64,%ecx
80100ec9:	6a 10                	push   $0x10
80100ecb:	ff b5 e8 fe ff ff    	push   -0x118(%ebp)
80100ed1:	51                   	push   %ecx
80100ed2:	e8 79 3b 00 00       	call   80104a50 <safestrcpy>
          break;
80100ed7:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80100eda:	83 ec 0c             	sub    $0xc,%esp
80100edd:	68 20 2d 11 80       	push   $0x80112d20
80100ee2:	e8 89 38 00 00       	call   80104770 <release>
  return 0;
80100ee7:	83 c4 10             	add    $0x10,%esp
80100eea:	31 c0                	xor    %eax,%eax
80100eec:	e9 2b fc ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100ef1:	e8 ea 1f 00 00       	call   80102ee0 <end_op>
    cprintf("exec: fail\n");
80100ef6:	83 ec 0c             	sub    $0xc,%esp
80100ef9:	68 f0 76 10 80       	push   $0x801076f0
80100efe:	e8 9d f7 ff ff       	call   801006a0 <cprintf>
    return -1;
80100f03:	83 c4 10             	add    $0x10,%esp
80100f06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f0b:	e9 0c fc ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f10:	be 00 20 00 00       	mov    $0x2000,%esi
80100f15:	31 ff                	xor    %edi,%edi
80100f17:	e9 2c fd ff ff       	jmp    80100c48 <exec+0x198>
80100f1c:	66 90                	xchg   %ax,%ax
80100f1e:	66 90                	xchg   %ax,%ax

80100f20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f26:	68 fc 76 10 80       	push   $0x801076fc
80100f2b:	68 60 ff 10 80       	push   $0x8010ff60
80100f30:	e8 cb 36 00 00       	call   80104600 <initlock>
}
80100f35:	83 c4 10             	add    $0x10,%esp
80100f38:	c9                   	leave
80100f39:	c3                   	ret
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f44:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100f49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f4c:	68 60 ff 10 80       	push   $0x8010ff60
80100f51:	e8 7a 38 00 00       	call   801047d0 <acquire>
80100f56:	83 c4 10             	add    $0x10,%esp
80100f59:	eb 10                	jmp    80100f6b <filealloc+0x2b>
80100f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f60:	83 c3 18             	add    $0x18,%ebx
80100f63:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100f69:	74 25                	je     80100f90 <filealloc+0x50>
    if(f->ref == 0){
80100f6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f6e:	85 c0                	test   %eax,%eax
80100f70:	75 ee                	jne    80100f60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f7c:	68 60 ff 10 80       	push   $0x8010ff60
80100f81:	e8 ea 37 00 00       	call   80104770 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f86:	89 d8                	mov    %ebx,%eax
      return f;
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f8e:	c9                   	leave
80100f8f:	c3                   	ret
  release(&ftable.lock);
80100f90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f95:	68 60 ff 10 80       	push   $0x8010ff60
80100f9a:	e8 d1 37 00 00       	call   80104770 <release>
}
80100f9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100fa1:	83 c4 10             	add    $0x10,%esp
}
80100fa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fa7:	c9                   	leave
80100fa8:	c3                   	ret
80100fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	53                   	push   %ebx
80100fb4:	83 ec 10             	sub    $0x10,%esp
80100fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fba:	68 60 ff 10 80       	push   $0x8010ff60
80100fbf:	e8 0c 38 00 00       	call   801047d0 <acquire>
  if(f->ref < 1)
80100fc4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fc7:	83 c4 10             	add    $0x10,%esp
80100fca:	85 c0                	test   %eax,%eax
80100fcc:	7e 1a                	jle    80100fe8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fd1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fd4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fd7:	68 60 ff 10 80       	push   $0x8010ff60
80100fdc:	e8 8f 37 00 00       	call   80104770 <release>
  return f;
}
80100fe1:	89 d8                	mov    %ebx,%eax
80100fe3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe6:	c9                   	leave
80100fe7:	c3                   	ret
    panic("filedup");
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	68 03 77 10 80       	push   $0x80107703
80100ff0:	e8 8b f3 ff ff       	call   80100380 <panic>
80100ff5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ffc:	00 
80100ffd:	8d 76 00             	lea    0x0(%esi),%esi

80101000 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 28             	sub    $0x28,%esp
80101009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010100c:	68 60 ff 10 80       	push   $0x8010ff60
80101011:	e8 ba 37 00 00       	call   801047d0 <acquire>
  if(f->ref < 1)
80101016:	8b 53 04             	mov    0x4(%ebx),%edx
80101019:	83 c4 10             	add    $0x10,%esp
8010101c:	85 d2                	test   %edx,%edx
8010101e:	0f 8e a5 00 00 00    	jle    801010c9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101024:	83 ea 01             	sub    $0x1,%edx
80101027:	89 53 04             	mov    %edx,0x4(%ebx)
8010102a:	75 44                	jne    80101070 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010102c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101030:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101033:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101035:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010103b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010103e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101041:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101044:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80101049:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010104c:	e8 1f 37 00 00       	call   80104770 <release>

  if(ff.type == FD_PIPE)
80101051:	83 c4 10             	add    $0x10,%esp
80101054:	83 ff 01             	cmp    $0x1,%edi
80101057:	74 57                	je     801010b0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101059:	83 ff 02             	cmp    $0x2,%edi
8010105c:	74 2a                	je     80101088 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
80101065:	c3                   	ret
80101066:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010106d:	00 
8010106e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101070:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101077:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010107a:	5b                   	pop    %ebx
8010107b:	5e                   	pop    %esi
8010107c:	5f                   	pop    %edi
8010107d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010107e:	e9 ed 36 00 00       	jmp    80104770 <release>
80101083:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101088:	e8 e3 1d 00 00       	call   80102e70 <begin_op>
    iput(ff.ip);
8010108d:	83 ec 0c             	sub    $0xc,%esp
80101090:	ff 75 e0             	push   -0x20(%ebp)
80101093:	e8 28 09 00 00       	call   801019c0 <iput>
    end_op();
80101098:	83 c4 10             	add    $0x10,%esp
}
8010109b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010109e:	5b                   	pop    %ebx
8010109f:	5e                   	pop    %esi
801010a0:	5f                   	pop    %edi
801010a1:	5d                   	pop    %ebp
    end_op();
801010a2:	e9 39 1e 00 00       	jmp    80102ee0 <end_op>
801010a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801010ae:	00 
801010af:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
801010b0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010b4:	83 ec 08             	sub    $0x8,%esp
801010b7:	53                   	push   %ebx
801010b8:	56                   	push   %esi
801010b9:	e8 82 25 00 00       	call   80103640 <pipeclose>
801010be:	83 c4 10             	add    $0x10,%esp
}
801010c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c4:	5b                   	pop    %ebx
801010c5:	5e                   	pop    %esi
801010c6:	5f                   	pop    %edi
801010c7:	5d                   	pop    %ebp
801010c8:	c3                   	ret
    panic("fileclose");
801010c9:	83 ec 0c             	sub    $0xc,%esp
801010cc:	68 0b 77 10 80       	push   $0x8010770b
801010d1:	e8 aa f2 ff ff       	call   80100380 <panic>
801010d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801010dd:	00 
801010de:	66 90                	xchg   %ax,%ax

801010e0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	53                   	push   %ebx
801010e4:	83 ec 04             	sub    $0x4,%esp
801010e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010ea:	83 3b 02             	cmpl   $0x2,(%ebx)
801010ed:	75 31                	jne    80101120 <filestat+0x40>
    ilock(f->ip);
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	ff 73 10             	push   0x10(%ebx)
801010f5:	e8 96 07 00 00       	call   80101890 <ilock>
    stati(f->ip, st);
801010fa:	58                   	pop    %eax
801010fb:	5a                   	pop    %edx
801010fc:	ff 75 0c             	push   0xc(%ebp)
801010ff:	ff 73 10             	push   0x10(%ebx)
80101102:	e8 69 0a 00 00       	call   80101b70 <stati>
    iunlock(f->ip);
80101107:	59                   	pop    %ecx
80101108:	ff 73 10             	push   0x10(%ebx)
8010110b:	e8 60 08 00 00       	call   80101970 <iunlock>
    return 0;
  }
  return -1;
}
80101110:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101113:	83 c4 10             	add    $0x10,%esp
80101116:	31 c0                	xor    %eax,%eax
}
80101118:	c9                   	leave
80101119:	c3                   	ret
8010111a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101128:	c9                   	leave
80101129:	c3                   	ret
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101130 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 0c             	sub    $0xc,%esp
80101139:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010113c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010113f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101142:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101146:	74 60                	je     801011a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101148:	8b 03                	mov    (%ebx),%eax
8010114a:	83 f8 01             	cmp    $0x1,%eax
8010114d:	74 41                	je     80101190 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114f:	83 f8 02             	cmp    $0x2,%eax
80101152:	75 5b                	jne    801011af <fileread+0x7f>
    ilock(f->ip);
80101154:	83 ec 0c             	sub    $0xc,%esp
80101157:	ff 73 10             	push   0x10(%ebx)
8010115a:	e8 31 07 00 00       	call   80101890 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010115f:	57                   	push   %edi
80101160:	ff 73 14             	push   0x14(%ebx)
80101163:	56                   	push   %esi
80101164:	ff 73 10             	push   0x10(%ebx)
80101167:	e8 34 0a 00 00       	call   80101ba0 <readi>
8010116c:	83 c4 20             	add    $0x20,%esp
8010116f:	89 c6                	mov    %eax,%esi
80101171:	85 c0                	test   %eax,%eax
80101173:	7e 03                	jle    80101178 <fileread+0x48>
      f->off += r;
80101175:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101178:	83 ec 0c             	sub    $0xc,%esp
8010117b:	ff 73 10             	push   0x10(%ebx)
8010117e:	e8 ed 07 00 00       	call   80101970 <iunlock>
    return r;
80101183:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101189:	89 f0                	mov    %esi,%eax
8010118b:	5b                   	pop    %ebx
8010118c:	5e                   	pop    %esi
8010118d:	5f                   	pop    %edi
8010118e:	5d                   	pop    %ebp
8010118f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101190:	8b 43 0c             	mov    0xc(%ebx),%eax
80101193:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	5b                   	pop    %ebx
8010119a:	5e                   	pop    %esi
8010119b:	5f                   	pop    %edi
8010119c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010119d:	e9 3e 26 00 00       	jmp    801037e0 <piperead>
801011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011ad:	eb d7                	jmp    80101186 <fileread+0x56>
  panic("fileread");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 15 77 10 80       	push   $0x80107715
801011b7:	e8 c4 f1 ff ff       	call   80100380 <panic>
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
801011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801011d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011dc:	0f 84 bd 00 00 00    	je     8010129f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801011e2:	8b 03                	mov    (%ebx),%eax
801011e4:	83 f8 01             	cmp    $0x1,%eax
801011e7:	0f 84 bf 00 00 00    	je     801012ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011ed:	83 f8 02             	cmp    $0x2,%eax
801011f0:	0f 85 c8 00 00 00    	jne    801012be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801011f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801011fb:	85 c0                	test   %eax,%eax
801011fd:	7f 30                	jg     8010122f <filewrite+0x6f>
801011ff:	e9 94 00 00 00       	jmp    80101298 <filewrite+0xd8>
80101204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101208:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010120b:	83 ec 0c             	sub    $0xc,%esp
8010120e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101211:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101214:	e8 57 07 00 00       	call   80101970 <iunlock>
      end_op();
80101219:	e8 c2 1c 00 00       	call   80102ee0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010121e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101221:	83 c4 10             	add    $0x10,%esp
80101224:	39 c7                	cmp    %eax,%edi
80101226:	75 5c                	jne    80101284 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101228:	01 fe                	add    %edi,%esi
    while(i < n){
8010122a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010122d:	7e 69                	jle    80101298 <filewrite+0xd8>
      int n1 = n - i;
8010122f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101232:	b8 00 06 00 00       	mov    $0x600,%eax
80101237:	29 f7                	sub    %esi,%edi
80101239:	39 c7                	cmp    %eax,%edi
8010123b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010123e:	e8 2d 1c 00 00       	call   80102e70 <begin_op>
      ilock(f->ip);
80101243:	83 ec 0c             	sub    $0xc,%esp
80101246:	ff 73 10             	push   0x10(%ebx)
80101249:	e8 42 06 00 00       	call   80101890 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010124e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101251:	57                   	push   %edi
80101252:	ff 73 14             	push   0x14(%ebx)
80101255:	01 f0                	add    %esi,%eax
80101257:	50                   	push   %eax
80101258:	ff 73 10             	push   0x10(%ebx)
8010125b:	e8 40 0a 00 00       	call   80101ca0 <writei>
80101260:	83 c4 20             	add    $0x20,%esp
80101263:	85 c0                	test   %eax,%eax
80101265:	7f a1                	jg     80101208 <filewrite+0x48>
      iunlock(f->ip);
80101267:	83 ec 0c             	sub    $0xc,%esp
8010126a:	ff 73 10             	push   0x10(%ebx)
8010126d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101270:	e8 fb 06 00 00       	call   80101970 <iunlock>
      end_op();
80101275:	e8 66 1c 00 00       	call   80102ee0 <end_op>
      if(r < 0)
8010127a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010127d:	83 c4 10             	add    $0x10,%esp
80101280:	85 c0                	test   %eax,%eax
80101282:	75 1b                	jne    8010129f <filewrite+0xdf>
        panic("short filewrite");
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	68 1e 77 10 80       	push   $0x8010771e
8010128c:	e8 ef f0 ff ff       	call   80100380 <panic>
80101291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101298:	89 f0                	mov    %esi,%eax
8010129a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010129d:	74 05                	je     801012a4 <filewrite+0xe4>
8010129f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a7:	5b                   	pop    %ebx
801012a8:	5e                   	pop    %esi
801012a9:	5f                   	pop    %edi
801012aa:	5d                   	pop    %ebp
801012ab:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801012ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801012af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b5:	5b                   	pop    %ebx
801012b6:	5e                   	pop    %esi
801012b7:	5f                   	pop    %edi
801012b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012b9:	e9 22 24 00 00       	jmp    801036e0 <pipewrite>
  panic("filewrite");
801012be:	83 ec 0c             	sub    $0xc,%esp
801012c1:	68 24 77 10 80       	push   $0x80107724
801012c6:	e8 b5 f0 ff ff       	call   80100380 <panic>
801012cb:	66 90                	xchg   %ax,%ax
801012cd:	66 90                	xchg   %ax,%ax
801012cf:	90                   	nop

801012d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801012d0:	55                   	push   %ebp
801012d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801012d3:	89 d0                	mov    %edx,%eax
801012d5:	c1 e8 0c             	shr    $0xc,%eax
801012d8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801012de:	89 e5                	mov    %esp,%ebp
801012e0:	56                   	push   %esi
801012e1:	53                   	push   %ebx
801012e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801012e4:	83 ec 08             	sub    $0x8,%esp
801012e7:	50                   	push   %eax
801012e8:	51                   	push   %ecx
801012e9:	e8 e2 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801012ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801012f0:	c1 fb 03             	sar    $0x3,%ebx
801012f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801012f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801012f8:	83 e1 07             	and    $0x7,%ecx
801012fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101300:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101306:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101308:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010130d:	85 c1                	test   %eax,%ecx
8010130f:	74 23                	je     80101334 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101311:	f7 d0                	not    %eax
  log_write(bp);
80101313:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101316:	21 c8                	and    %ecx,%eax
80101318:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010131c:	56                   	push   %esi
8010131d:	e8 2e 1d 00 00       	call   80103050 <log_write>
  brelse(bp);
80101322:	89 34 24             	mov    %esi,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	83 c4 10             	add    $0x10,%esp
8010132d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101330:	5b                   	pop    %ebx
80101331:	5e                   	pop    %esi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret
    panic("freeing free block");
80101334:	83 ec 0c             	sub    $0xc,%esp
80101337:	68 2e 77 10 80       	push   $0x8010772e
8010133c:	e8 3f f0 ff ff       	call   80100380 <panic>
80101341:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101348:	00 
80101349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101350 <balloc>:
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101359:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010135f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101362:	85 c9                	test   %ecx,%ecx
80101364:	0f 84 87 00 00 00    	je     801013f1 <balloc+0xa1>
8010136a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101371:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101374:	83 ec 08             	sub    $0x8,%esp
80101377:	89 f0                	mov    %esi,%eax
80101379:	c1 f8 0c             	sar    $0xc,%eax
8010137c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101382:	50                   	push   %eax
80101383:	ff 75 d8             	push   -0x28(%ebp)
80101386:	e8 45 ed ff ff       	call   801000d0 <bread>
8010138b:	83 c4 10             	add    $0x10,%esp
8010138e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101391:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101396:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101399:	31 c0                	xor    %eax,%eax
8010139b:	eb 2f                	jmp    801013cc <balloc+0x7c>
8010139d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013a0:	89 c1                	mov    %eax,%ecx
801013a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013aa:	83 e1 07             	and    $0x7,%ecx
801013ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013af:	89 c1                	mov    %eax,%ecx
801013b1:	c1 f9 03             	sar    $0x3,%ecx
801013b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013b9:	89 fa                	mov    %edi,%edx
801013bb:	85 df                	test   %ebx,%edi
801013bd:	74 41                	je     80101400 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013bf:	83 c0 01             	add    $0x1,%eax
801013c2:	83 c6 01             	add    $0x1,%esi
801013c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013ca:	74 05                	je     801013d1 <balloc+0x81>
801013cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013cf:	77 cf                	ja     801013a0 <balloc+0x50>
    brelse(bp);
801013d1:	83 ec 0c             	sub    $0xc,%esp
801013d4:	ff 75 e4             	push   -0x1c(%ebp)
801013d7:	e8 14 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801013e3:	83 c4 10             	add    $0x10,%esp
801013e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013e9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801013ef:	77 80                	ja     80101371 <balloc+0x21>
  panic("balloc: out of blocks");
801013f1:	83 ec 0c             	sub    $0xc,%esp
801013f4:	68 41 77 10 80       	push   $0x80107741
801013f9:	e8 82 ef ff ff       	call   80100380 <panic>
801013fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101403:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101406:	09 da                	or     %ebx,%edx
80101408:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010140c:	57                   	push   %edi
8010140d:	e8 3e 1c 00 00       	call   80103050 <log_write>
        brelse(bp);
80101412:	89 3c 24             	mov    %edi,(%esp)
80101415:	e8 d6 ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010141a:	58                   	pop    %eax
8010141b:	5a                   	pop    %edx
8010141c:	56                   	push   %esi
8010141d:	ff 75 d8             	push   -0x28(%ebp)
80101420:	e8 ab ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101425:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101428:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010142a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010142d:	68 00 02 00 00       	push   $0x200
80101432:	6a 00                	push   $0x0
80101434:	50                   	push   %eax
80101435:	e8 56 34 00 00       	call   80104890 <memset>
  log_write(bp);
8010143a:	89 1c 24             	mov    %ebx,(%esp)
8010143d:	e8 0e 1c 00 00       	call   80103050 <log_write>
  brelse(bp);
80101442:	89 1c 24             	mov    %ebx,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144d:	89 f0                	mov    %esi,%eax
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5f                   	pop    %edi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
80101454:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010145b:	00 
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101460 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	89 c7                	mov    %eax,%edi
80101466:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101467:	31 f6                	xor    %esi,%esi
{
80101469:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010146a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010146f:	83 ec 28             	sub    $0x28,%esp
80101472:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101475:	68 60 09 11 80       	push   $0x80110960
8010147a:	e8 51 33 00 00       	call   801047d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010147f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101482:	83 c4 10             	add    $0x10,%esp
80101485:	eb 1b                	jmp    801014a2 <iget+0x42>
80101487:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010148e:	00 
8010148f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101490:	39 3b                	cmp    %edi,(%ebx)
80101492:	74 6c                	je     80101500 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101494:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014a0:	73 26                	jae    801014c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014a2:	8b 43 08             	mov    0x8(%ebx),%eax
801014a5:	85 c0                	test   %eax,%eax
801014a7:	7f e7                	jg     80101490 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014a9:	85 f6                	test   %esi,%esi
801014ab:	75 e7                	jne    80101494 <iget+0x34>
801014ad:	85 c0                	test   %eax,%eax
801014af:	75 76                	jne    80101527 <iget+0xc7>
801014b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014b9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014bf:	72 e1                	jb     801014a2 <iget+0x42>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014c8:	85 f6                	test   %esi,%esi
801014ca:	74 79                	je     80101545 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801014e2:	68 60 09 11 80       	push   $0x80110960
801014e7:	e8 84 32 00 00       	call   80104770 <release>

  return ip;
801014ec:	83 c4 10             	add    $0x10,%esp
}
801014ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f2:	89 f0                	mov    %esi,%eax
801014f4:	5b                   	pop    %ebx
801014f5:	5e                   	pop    %esi
801014f6:	5f                   	pop    %edi
801014f7:	5d                   	pop    %ebp
801014f8:	c3                   	ret
801014f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101500:	39 53 04             	cmp    %edx,0x4(%ebx)
80101503:	75 8f                	jne    80101494 <iget+0x34>
      release(&icache.lock);
80101505:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101508:	83 c0 01             	add    $0x1,%eax
      return ip;
8010150b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010150d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101512:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101515:	e8 56 32 00 00       	call   80104770 <release>
      return ip;
8010151a:	83 c4 10             	add    $0x10,%esp
}
8010151d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101520:	89 f0                	mov    %esi,%eax
80101522:	5b                   	pop    %ebx
80101523:	5e                   	pop    %esi
80101524:	5f                   	pop    %edi
80101525:	5d                   	pop    %ebp
80101526:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101527:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010152d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101533:	73 10                	jae    80101545 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101535:	8b 43 08             	mov    0x8(%ebx),%eax
80101538:	85 c0                	test   %eax,%eax
8010153a:	0f 8f 50 ff ff ff    	jg     80101490 <iget+0x30>
80101540:	e9 68 ff ff ff       	jmp    801014ad <iget+0x4d>
    panic("iget: no inodes");
80101545:	83 ec 0c             	sub    $0xc,%esp
80101548:	68 57 77 10 80       	push   $0x80107757
8010154d:	e8 2e ee ff ff       	call   80100380 <panic>
80101552:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101559:	00 
8010155a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101560 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	56                   	push   %esi
80101565:	89 c6                	mov    %eax,%esi
80101567:	53                   	push   %ebx
80101568:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010156b:	83 fa 0b             	cmp    $0xb,%edx
8010156e:	0f 86 8c 00 00 00    	jbe    80101600 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101574:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101577:	83 fb 7f             	cmp    $0x7f,%ebx
8010157a:	0f 87 a2 00 00 00    	ja     80101622 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101580:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101586:	85 c0                	test   %eax,%eax
80101588:	74 5e                	je     801015e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010158a:	83 ec 08             	sub    $0x8,%esp
8010158d:	50                   	push   %eax
8010158e:	ff 36                	push   (%esi)
80101590:	e8 3b eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101595:	83 c4 10             	add    $0x10,%esp
80101598:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010159c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010159e:	8b 3b                	mov    (%ebx),%edi
801015a0:	85 ff                	test   %edi,%edi
801015a2:	74 1c                	je     801015c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801015a4:	83 ec 0c             	sub    $0xc,%esp
801015a7:	52                   	push   %edx
801015a8:	e8 43 ec ff ff       	call   801001f0 <brelse>
801015ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b3:	89 f8                	mov    %edi,%eax
801015b5:	5b                   	pop    %ebx
801015b6:	5e                   	pop    %esi
801015b7:	5f                   	pop    %edi
801015b8:	5d                   	pop    %ebp
801015b9:	c3                   	ret
801015ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015c3:	8b 06                	mov    (%esi),%eax
801015c5:	e8 86 fd ff ff       	call   80101350 <balloc>
      log_write(bp);
801015ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015d0:	89 03                	mov    %eax,(%ebx)
801015d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801015d4:	52                   	push   %edx
801015d5:	e8 76 1a 00 00       	call   80103050 <log_write>
801015da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015dd:	83 c4 10             	add    $0x10,%esp
801015e0:	eb c2                	jmp    801015a4 <bmap+0x44>
801015e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015e8:	8b 06                	mov    (%esi),%eax
801015ea:	e8 61 fd ff ff       	call   80101350 <balloc>
801015ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015f5:	eb 93                	jmp    8010158a <bmap+0x2a>
801015f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015fe:	00 
801015ff:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101600:	8d 5a 14             	lea    0x14(%edx),%ebx
80101603:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101607:	85 ff                	test   %edi,%edi
80101609:	75 a5                	jne    801015b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010160b:	8b 00                	mov    (%eax),%eax
8010160d:	e8 3e fd ff ff       	call   80101350 <balloc>
80101612:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101616:	89 c7                	mov    %eax,%edi
}
80101618:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010161b:	5b                   	pop    %ebx
8010161c:	89 f8                	mov    %edi,%eax
8010161e:	5e                   	pop    %esi
8010161f:	5f                   	pop    %edi
80101620:	5d                   	pop    %ebp
80101621:	c3                   	ret
  panic("bmap: out of range");
80101622:	83 ec 0c             	sub    $0xc,%esp
80101625:	68 67 77 10 80       	push   $0x80107767
8010162a:	e8 51 ed ff ff       	call   80100380 <panic>
8010162f:	90                   	nop

80101630 <readsb>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101638:	83 ec 08             	sub    $0x8,%esp
8010163b:	6a 01                	push   $0x1
8010163d:	ff 75 08             	push   0x8(%ebp)
80101640:	e8 8b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101645:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101648:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010164a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010164d:	6a 1c                	push   $0x1c
8010164f:	50                   	push   %eax
80101650:	56                   	push   %esi
80101651:	e8 da 32 00 00       	call   80104930 <memmove>
  brelse(bp);
80101656:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101659:	83 c4 10             	add    $0x10,%esp
}
8010165c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010165f:	5b                   	pop    %ebx
80101660:	5e                   	pop    %esi
80101661:	5d                   	pop    %ebp
  brelse(bp);
80101662:	e9 89 eb ff ff       	jmp    801001f0 <brelse>
80101667:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010166e:	00 
8010166f:	90                   	nop

80101670 <iinit>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101679:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010167c:	68 7a 77 10 80       	push   $0x8010777a
80101681:	68 60 09 11 80       	push   $0x80110960
80101686:	e8 75 2f 00 00       	call   80104600 <initlock>
  for(i = 0; i < NINODE; i++) {
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	68 81 77 10 80       	push   $0x80107781
80101698:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101699:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010169f:	e8 2c 2e 00 00       	call   801044d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801016ad:	75 e1                	jne    80101690 <iinit+0x20>
  bp = bread(dev, 1);
801016af:	83 ec 08             	sub    $0x8,%esp
801016b2:	6a 01                	push   $0x1
801016b4:	ff 75 08             	push   0x8(%ebp)
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016c4:	6a 1c                	push   $0x1c
801016c6:	50                   	push   %eax
801016c7:	68 b4 25 11 80       	push   $0x801125b4
801016cc:	e8 5f 32 00 00       	call   80104930 <memmove>
  brelse(bp);
801016d1:	89 1c 24             	mov    %ebx,(%esp)
801016d4:	e8 17 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016d9:	ff 35 cc 25 11 80    	push   0x801125cc
801016df:	ff 35 c8 25 11 80    	push   0x801125c8
801016e5:	ff 35 c4 25 11 80    	push   0x801125c4
801016eb:	ff 35 c0 25 11 80    	push   0x801125c0
801016f1:	ff 35 bc 25 11 80    	push   0x801125bc
801016f7:	ff 35 b8 25 11 80    	push   0x801125b8
801016fd:	ff 35 b4 25 11 80    	push   0x801125b4
80101703:	68 b4 7b 10 80       	push   $0x80107bb4
80101708:	e8 93 ef ff ff       	call   801006a0 <cprintf>
}
8010170d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101710:	83 c4 30             	add    $0x30,%esp
80101713:	c9                   	leave
80101714:	c3                   	ret
80101715:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010171c:	00 
8010171d:	8d 76 00             	lea    0x0(%esi),%esi

80101720 <ialloc>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	83 ec 1c             	sub    $0x1c,%esp
80101729:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010172c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101733:	8b 75 08             	mov    0x8(%ebp),%esi
80101736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101739:	0f 86 91 00 00 00    	jbe    801017d0 <ialloc+0xb0>
8010173f:	bf 01 00 00 00       	mov    $0x1,%edi
80101744:	eb 21                	jmp    80101767 <ialloc+0x47>
80101746:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010174d:	00 
8010174e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101750:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101753:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101756:	53                   	push   %ebx
80101757:	e8 94 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010175c:	83 c4 10             	add    $0x10,%esp
8010175f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101765:	73 69                	jae    801017d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101767:	89 f8                	mov    %edi,%eax
80101769:	83 ec 08             	sub    $0x8,%esp
8010176c:	c1 e8 03             	shr    $0x3,%eax
8010176f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101775:	50                   	push   %eax
80101776:	56                   	push   %esi
80101777:	e8 54 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010177c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010177f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101781:	89 f8                	mov    %edi,%eax
80101783:	83 e0 07             	and    $0x7,%eax
80101786:	c1 e0 06             	shl    $0x6,%eax
80101789:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010178d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101791:	75 bd                	jne    80101750 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101793:	83 ec 04             	sub    $0x4,%esp
80101796:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101799:	6a 40                	push   $0x40
8010179b:	6a 00                	push   $0x0
8010179d:	51                   	push   %ecx
8010179e:	e8 ed 30 00 00       	call   80104890 <memset>
      dip->type = type;
801017a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ad:	89 1c 24             	mov    %ebx,(%esp)
801017b0:	e8 9b 18 00 00       	call   80103050 <log_write>
      brelse(bp);
801017b5:	89 1c 24             	mov    %ebx,(%esp)
801017b8:	e8 33 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017bd:	83 c4 10             	add    $0x10,%esp
}
801017c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017c3:	89 fa                	mov    %edi,%edx
}
801017c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017c6:	89 f0                	mov    %esi,%eax
}
801017c8:	5e                   	pop    %esi
801017c9:	5f                   	pop    %edi
801017ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801017cb:	e9 90 fc ff ff       	jmp    80101460 <iget>
  panic("ialloc: no inodes");
801017d0:	83 ec 0c             	sub    $0xc,%esp
801017d3:	68 87 77 10 80       	push   $0x80107787
801017d8:	e8 a3 eb ff ff       	call   80100380 <panic>
801017dd:	8d 76 00             	lea    0x0(%esi),%esi

801017e0 <iupdate>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ee:	83 ec 08             	sub    $0x8,%esp
801017f1:	c1 e8 03             	shr    $0x3,%eax
801017f4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017fa:	50                   	push   %eax
801017fb:	ff 73 a4             	push   -0x5c(%ebx)
801017fe:	e8 cd e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101803:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101807:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010180f:	83 e0 07             	and    $0x7,%eax
80101812:	c1 e0 06             	shl    $0x6,%eax
80101815:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101819:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010181c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101820:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101823:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101827:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010182b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010182f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101833:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101837:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010183a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183d:	6a 34                	push   $0x34
8010183f:	53                   	push   %ebx
80101840:	50                   	push   %eax
80101841:	e8 ea 30 00 00       	call   80104930 <memmove>
  log_write(bp);
80101846:	89 34 24             	mov    %esi,(%esp)
80101849:	e8 02 18 00 00       	call   80103050 <log_write>
  brelse(bp);
8010184e:	89 75 08             	mov    %esi,0x8(%ebp)
80101851:	83 c4 10             	add    $0x10,%esp
}
80101854:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101857:	5b                   	pop    %ebx
80101858:	5e                   	pop    %esi
80101859:	5d                   	pop    %ebp
  brelse(bp);
8010185a:	e9 91 e9 ff ff       	jmp    801001f0 <brelse>
8010185f:	90                   	nop

80101860 <idup>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	53                   	push   %ebx
80101864:	83 ec 10             	sub    $0x10,%esp
80101867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010186a:	68 60 09 11 80       	push   $0x80110960
8010186f:	e8 5c 2f 00 00       	call   801047d0 <acquire>
  ip->ref++;
80101874:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101878:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010187f:	e8 ec 2e 00 00       	call   80104770 <release>
}
80101884:	89 d8                	mov    %ebx,%eax
80101886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101889:	c9                   	leave
8010188a:	c3                   	ret
8010188b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101890 <ilock>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101898:	85 db                	test   %ebx,%ebx
8010189a:	0f 84 b7 00 00 00    	je     80101957 <ilock+0xc7>
801018a0:	8b 53 08             	mov    0x8(%ebx),%edx
801018a3:	85 d2                	test   %edx,%edx
801018a5:	0f 8e ac 00 00 00    	jle    80101957 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018ab:	83 ec 0c             	sub    $0xc,%esp
801018ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801018b1:	50                   	push   %eax
801018b2:	e8 59 2c 00 00       	call   80104510 <acquiresleep>
  if(ip->valid == 0){
801018b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	85 c0                	test   %eax,%eax
801018bf:	74 0f                	je     801018d0 <ilock+0x40>
}
801018c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018c4:	5b                   	pop    %ebx
801018c5:	5e                   	pop    %esi
801018c6:	5d                   	pop    %ebp
801018c7:	c3                   	ret
801018c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018cf:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018d0:	8b 43 04             	mov    0x4(%ebx),%eax
801018d3:	83 ec 08             	sub    $0x8,%esp
801018d6:	c1 e8 03             	shr    $0x3,%eax
801018d9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801018df:	50                   	push   %eax
801018e0:	ff 33                	push   (%ebx)
801018e2:	e8 e9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ec:	8b 43 04             	mov    0x4(%ebx),%eax
801018ef:	83 e0 07             	and    $0x7,%eax
801018f2:	c1 e0 06             	shl    $0x6,%eax
801018f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101903:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101907:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010190b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010190f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101913:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101917:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010191b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010191e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101921:	6a 34                	push   $0x34
80101923:	50                   	push   %eax
80101924:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101927:	50                   	push   %eax
80101928:	e8 03 30 00 00       	call   80104930 <memmove>
    brelse(bp);
8010192d:	89 34 24             	mov    %esi,(%esp)
80101930:	e8 bb e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101935:	83 c4 10             	add    $0x10,%esp
80101938:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010193d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101944:	0f 85 77 ff ff ff    	jne    801018c1 <ilock+0x31>
      panic("ilock: no type");
8010194a:	83 ec 0c             	sub    $0xc,%esp
8010194d:	68 9f 77 10 80       	push   $0x8010779f
80101952:	e8 29 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 99 77 10 80       	push   $0x80107799
8010195f:	e8 1c ea ff ff       	call   80100380 <panic>
80101964:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010196b:	00 
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <iunlock>:
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	56                   	push   %esi
80101974:	53                   	push   %ebx
80101975:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101978:	85 db                	test   %ebx,%ebx
8010197a:	74 28                	je     801019a4 <iunlock+0x34>
8010197c:	83 ec 0c             	sub    $0xc,%esp
8010197f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101982:	56                   	push   %esi
80101983:	e8 28 2c 00 00       	call   801045b0 <holdingsleep>
80101988:	83 c4 10             	add    $0x10,%esp
8010198b:	85 c0                	test   %eax,%eax
8010198d:	74 15                	je     801019a4 <iunlock+0x34>
8010198f:	8b 43 08             	mov    0x8(%ebx),%eax
80101992:	85 c0                	test   %eax,%eax
80101994:	7e 0e                	jle    801019a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101996:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101999:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010199c:	5b                   	pop    %ebx
8010199d:	5e                   	pop    %esi
8010199e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010199f:	e9 cc 2b 00 00       	jmp    80104570 <releasesleep>
    panic("iunlock");
801019a4:	83 ec 0c             	sub    $0xc,%esp
801019a7:	68 ae 77 10 80       	push   $0x801077ae
801019ac:	e8 cf e9 ff ff       	call   80100380 <panic>
801019b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019b8:	00 
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801019c0 <iput>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	57                   	push   %edi
801019c4:	56                   	push   %esi
801019c5:	53                   	push   %ebx
801019c6:	83 ec 28             	sub    $0x28,%esp
801019c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019cf:	57                   	push   %edi
801019d0:	e8 3b 2b 00 00       	call   80104510 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	85 d2                	test   %edx,%edx
801019dd:	74 07                	je     801019e6 <iput+0x26>
801019df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019e4:	74 32                	je     80101a18 <iput+0x58>
  releasesleep(&ip->lock);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	57                   	push   %edi
801019ea:	e8 81 2b 00 00       	call   80104570 <releasesleep>
  acquire(&icache.lock);
801019ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019f6:	e8 d5 2d 00 00       	call   801047d0 <acquire>
  ip->ref--;
801019fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019ff:	83 c4 10             	add    $0x10,%esp
80101a02:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0c:	5b                   	pop    %ebx
80101a0d:	5e                   	pop    %esi
80101a0e:	5f                   	pop    %edi
80101a0f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a10:	e9 5b 2d 00 00       	jmp    80104770 <release>
80101a15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a18:	83 ec 0c             	sub    $0xc,%esp
80101a1b:	68 60 09 11 80       	push   $0x80110960
80101a20:	e8 ab 2d 00 00       	call   801047d0 <acquire>
    int r = ip->ref;
80101a25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a28:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a2f:	e8 3c 2d 00 00       	call   80104770 <release>
    if(r == 1){
80101a34:	83 c4 10             	add    $0x10,%esp
80101a37:	83 fe 01             	cmp    $0x1,%esi
80101a3a:	75 aa                	jne    801019e6 <iput+0x26>
80101a3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a48:	89 cf                	mov    %ecx,%edi
80101a4a:	eb 0b                	jmp    80101a57 <iput+0x97>
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a50:	83 c6 04             	add    $0x4,%esi
80101a53:	39 fe                	cmp    %edi,%esi
80101a55:	74 19                	je     80101a70 <iput+0xb0>
    if(ip->addrs[i]){
80101a57:	8b 16                	mov    (%esi),%edx
80101a59:	85 d2                	test   %edx,%edx
80101a5b:	74 f3                	je     80101a50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a5d:	8b 03                	mov    (%ebx),%eax
80101a5f:	e8 6c f8 ff ff       	call   801012d0 <bfree>
      ip->addrs[i] = 0;
80101a64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a6a:	eb e4                	jmp    80101a50 <iput+0x90>
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a70:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a79:	85 c0                	test   %eax,%eax
80101a7b:	75 2d                	jne    80101aaa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a7d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a80:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a87:	53                   	push   %ebx
80101a88:	e8 53 fd ff ff       	call   801017e0 <iupdate>
      ip->type = 0;
80101a8d:	31 c0                	xor    %eax,%eax
80101a8f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a93:	89 1c 24             	mov    %ebx,(%esp)
80101a96:	e8 45 fd ff ff       	call   801017e0 <iupdate>
      ip->valid = 0;
80101a9b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101aa2:	83 c4 10             	add    $0x10,%esp
80101aa5:	e9 3c ff ff ff       	jmp    801019e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aaa:	83 ec 08             	sub    $0x8,%esp
80101aad:	50                   	push   %eax
80101aae:	ff 33                	push   (%ebx)
80101ab0:	e8 1b e6 ff ff       	call   801000d0 <bread>
80101ab5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab8:	83 c4 10             	add    $0x10,%esp
80101abb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ac4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ac7:	89 cf                	mov    %ecx,%edi
80101ac9:	eb 0c                	jmp    80101ad7 <iput+0x117>
80101acb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ad0:	83 c6 04             	add    $0x4,%esi
80101ad3:	39 f7                	cmp    %esi,%edi
80101ad5:	74 0f                	je     80101ae6 <iput+0x126>
      if(a[j])
80101ad7:	8b 16                	mov    (%esi),%edx
80101ad9:	85 d2                	test   %edx,%edx
80101adb:	74 f3                	je     80101ad0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101add:	8b 03                	mov    (%ebx),%eax
80101adf:	e8 ec f7 ff ff       	call   801012d0 <bfree>
80101ae4:	eb ea                	jmp    80101ad0 <iput+0x110>
    brelse(bp);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	ff 75 e4             	push   -0x1c(%ebp)
80101aec:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aef:	e8 fc e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101af4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101afa:	8b 03                	mov    (%ebx),%eax
80101afc:	e8 cf f7 ff ff       	call   801012d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b01:	83 c4 10             	add    $0x10,%esp
80101b04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b0b:	00 00 00 
80101b0e:	e9 6a ff ff ff       	jmp    80101a7d <iput+0xbd>
80101b13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b1a:	00 
80101b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b20 <iunlockput>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	56                   	push   %esi
80101b24:	53                   	push   %ebx
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b28:	85 db                	test   %ebx,%ebx
80101b2a:	74 34                	je     80101b60 <iunlockput+0x40>
80101b2c:	83 ec 0c             	sub    $0xc,%esp
80101b2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b32:	56                   	push   %esi
80101b33:	e8 78 2a 00 00       	call   801045b0 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 21                	je     80101b60 <iunlockput+0x40>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 1a                	jle    80101b60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	56                   	push   %esi
80101b4a:	e8 21 2a 00 00       	call   80104570 <releasesleep>
  iput(ip);
80101b4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b52:	83 c4 10             	add    $0x10,%esp
}
80101b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5d                   	pop    %ebp
  iput(ip);
80101b5b:	e9 60 fe ff ff       	jmp    801019c0 <iput>
    panic("iunlock");
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	68 ae 77 10 80       	push   $0x801077ae
80101b68:	e8 13 e8 ff ff       	call   80100380 <panic>
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi

80101b70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	8b 55 08             	mov    0x8(%ebp),%edx
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b79:	8b 0a                	mov    (%edx),%ecx
80101b7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b93:	8b 52 58             	mov    0x58(%edx),%edx
80101b96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b99:	5d                   	pop    %ebp
80101b9a:	c3                   	ret
80101b9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ba0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bb5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bc0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 a7 00 00 00    	je     80101c70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	8b 40 58             	mov    0x58(%eax),%eax
80101bcf:	39 c6                	cmp    %eax,%esi
80101bd1:	0f 87 ba 00 00 00    	ja     80101c91 <readi+0xf1>
80101bd7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bda:	31 c9                	xor    %ecx,%ecx
80101bdc:	89 da                	mov    %ebx,%edx
80101bde:	01 f2                	add    %esi,%edx
80101be0:	0f 92 c1             	setb   %cl
80101be3:	89 cf                	mov    %ecx,%edi
80101be5:	0f 82 a6 00 00 00    	jb     80101c91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101beb:	89 c1                	mov    %eax,%ecx
80101bed:	29 f1                	sub    %esi,%ecx
80101bef:	39 d0                	cmp    %edx,%eax
80101bf1:	0f 43 cb             	cmovae %ebx,%ecx
80101bf4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf7:	85 c9                	test   %ecx,%ecx
80101bf9:	74 67                	je     80101c62 <readi+0xc2>
80101bfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 d8                	mov    %ebx,%eax
80101c0a:	e8 51 f9 ff ff       	call   80101560 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 33                	push   (%ebx)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	89 f0                	mov    %esi,%eax
80101c26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c36:	39 d9                	cmp    %ebx,%ecx
80101c38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c3b:	83 c4 0c             	add    $0xc,%esp
80101c3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c3f:	01 df                	add    %ebx,%edi
80101c41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c43:	50                   	push   %eax
80101c44:	ff 75 e0             	push   -0x20(%ebp)
80101c47:	e8 e4 2c 00 00       	call   80104930 <memmove>
    brelse(bp);
80101c4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c4f:	89 14 24             	mov    %edx,(%esp)
80101c52:	e8 99 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c60:	77 9e                	ja     80101c00 <readi+0x60>
  }
  return n;
80101c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c68:	5b                   	pop    %ebx
80101c69:	5e                   	pop    %esi
80101c6a:	5f                   	pop    %edi
80101c6b:	5d                   	pop    %ebp
80101c6c:	c3                   	ret
80101c6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 17                	ja     80101c91 <readi+0xf1>
80101c7a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 0c                	je     80101c91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c8f:	ff e0                	jmp    *%eax
      return -1;
80101c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c96:	eb cd                	jmp    80101c65 <readi+0xc5>
80101c98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c9f:	00 

80101ca0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	83 ec 1c             	sub    $0x1c,%esp
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101caf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101cc3:	0f 84 b7 00 00 00    	je     80101d80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ccc:	3b 70 58             	cmp    0x58(%eax),%esi
80101ccf:	0f 87 e7 00 00 00    	ja     80101dbc <writei+0x11c>
80101cd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cd8:	31 d2                	xor    %edx,%edx
80101cda:	89 f8                	mov    %edi,%eax
80101cdc:	01 f0                	add    %esi,%eax
80101cde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ce1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ce6:	0f 87 d0 00 00 00    	ja     80101dbc <writei+0x11c>
80101cec:	85 d2                	test   %edx,%edx
80101cee:	0f 85 c8 00 00 00    	jne    80101dbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cfb:	85 ff                	test   %edi,%edi
80101cfd:	74 72                	je     80101d71 <writei+0xd1>
80101cff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d03:	89 f2                	mov    %esi,%edx
80101d05:	c1 ea 09             	shr    $0x9,%edx
80101d08:	89 f8                	mov    %edi,%eax
80101d0a:	e8 51 f8 ff ff       	call   80101560 <bmap>
80101d0f:	83 ec 08             	sub    $0x8,%esp
80101d12:	50                   	push   %eax
80101d13:	ff 37                	push   (%edi)
80101d15:	e8 b6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d27:	89 f0                	mov    %esi,%eax
80101d29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d2e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d30:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d34:	39 d9                	cmp    %ebx,%ecx
80101d36:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d39:	83 c4 0c             	add    $0xc,%esp
80101d3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d3f:	ff 75 dc             	push   -0x24(%ebp)
80101d42:	50                   	push   %eax
80101d43:	e8 e8 2b 00 00       	call   80104930 <memmove>
    log_write(bp);
80101d48:	89 3c 24             	mov    %edi,(%esp)
80101d4b:	e8 00 13 00 00       	call   80103050 <log_write>
    brelse(bp);
80101d50:	89 3c 24             	mov    %edi,(%esp)
80101d53:	e8 98 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d67:	77 97                	ja     80101d00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d6f:	77 37                	ja     80101da8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d77:	5b                   	pop    %ebx
80101d78:	5e                   	pop    %esi
80101d79:	5f                   	pop    %edi
80101d7a:	5d                   	pop    %ebp
80101d7b:	c3                   	ret
80101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d84:	66 83 f8 09          	cmp    $0x9,%ax
80101d88:	77 32                	ja     80101dbc <writei+0x11c>
80101d8a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d91:	85 c0                	test   %eax,%eax
80101d93:	74 27                	je     80101dbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101d95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9b:	5b                   	pop    %ebx
80101d9c:	5e                   	pop    %esi
80101d9d:	5f                   	pop    %edi
80101d9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d9f:	ff e0                	jmp    *%eax
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101da8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101db1:	50                   	push   %eax
80101db2:	e8 29 fa ff ff       	call   801017e0 <iupdate>
80101db7:	83 c4 10             	add    $0x10,%esp
80101dba:	eb b5                	jmp    80101d71 <writei+0xd1>
      return -1;
80101dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dc1:	eb b1                	jmp    80101d74 <writei+0xd4>
80101dc3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dca:	00 
80101dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101dd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101dd6:	6a 0e                	push   $0xe
80101dd8:	ff 75 0c             	push   0xc(%ebp)
80101ddb:	ff 75 08             	push   0x8(%ebp)
80101dde:	e8 bd 2b 00 00       	call   801049a0 <strncmp>
}
80101de3:	c9                   	leave
80101de4:	c3                   	ret
80101de5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dec:	00 
80101ded:	8d 76 00             	lea    0x0(%esi),%esi

80101df0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 1c             	sub    $0x1c,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e01:	0f 85 85 00 00 00    	jne    80101e8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e07:	8b 53 58             	mov    0x58(%ebx),%edx
80101e0a:	31 ff                	xor    %edi,%edi
80101e0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e0f:	85 d2                	test   %edx,%edx
80101e11:	74 3e                	je     80101e51 <dirlookup+0x61>
80101e13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e18:	6a 10                	push   $0x10
80101e1a:	57                   	push   %edi
80101e1b:	56                   	push   %esi
80101e1c:	53                   	push   %ebx
80101e1d:	e8 7e fd ff ff       	call   80101ba0 <readi>
80101e22:	83 c4 10             	add    $0x10,%esp
80101e25:	83 f8 10             	cmp    $0x10,%eax
80101e28:	75 55                	jne    80101e7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e2f:	74 18                	je     80101e49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e31:	83 ec 04             	sub    $0x4,%esp
80101e34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e37:	6a 0e                	push   $0xe
80101e39:	50                   	push   %eax
80101e3a:	ff 75 0c             	push   0xc(%ebp)
80101e3d:	e8 5e 2b 00 00       	call   801049a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	85 c0                	test   %eax,%eax
80101e47:	74 17                	je     80101e60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e49:	83 c7 10             	add    $0x10,%edi
80101e4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e4f:	72 c7                	jb     80101e18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e54:	31 c0                	xor    %eax,%eax
}
80101e56:	5b                   	pop    %ebx
80101e57:	5e                   	pop    %esi
80101e58:	5f                   	pop    %edi
80101e59:	5d                   	pop    %ebp
80101e5a:	c3                   	ret
80101e5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101e60:	8b 45 10             	mov    0x10(%ebp),%eax
80101e63:	85 c0                	test   %eax,%eax
80101e65:	74 05                	je     80101e6c <dirlookup+0x7c>
        *poff = off;
80101e67:	8b 45 10             	mov    0x10(%ebp),%eax
80101e6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e70:	8b 03                	mov    (%ebx),%eax
80101e72:	e8 e9 f5 ff ff       	call   80101460 <iget>
}
80101e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e7a:	5b                   	pop    %ebx
80101e7b:	5e                   	pop    %esi
80101e7c:	5f                   	pop    %edi
80101e7d:	5d                   	pop    %ebp
80101e7e:	c3                   	ret
      panic("dirlookup read");
80101e7f:	83 ec 0c             	sub    $0xc,%esp
80101e82:	68 c8 77 10 80       	push   $0x801077c8
80101e87:	e8 f4 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101e8c:	83 ec 0c             	sub    $0xc,%esp
80101e8f:	68 b6 77 10 80       	push   $0x801077b6
80101e94:	e8 e7 e4 ff ff       	call   80100380 <panic>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ea0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	89 c3                	mov    %eax,%ebx
80101ea8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101eab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101eae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101eb1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101eb4:	0f 84 64 01 00 00    	je     8010201e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eba:	e8 71 1c 00 00       	call   80103b30 <myproc>
  acquire(&icache.lock);
80101ebf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ec2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ec5:	68 60 09 11 80       	push   $0x80110960
80101eca:	e8 01 29 00 00       	call   801047d0 <acquire>
  ip->ref++;
80101ecf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ed3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eda:	e8 91 28 00 00       	call   80104770 <release>
80101edf:	83 c4 10             	add    $0x10,%esp
80101ee2:	eb 07                	jmp    80101eeb <namex+0x4b>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eeb:	0f b6 03             	movzbl (%ebx),%eax
80101eee:	3c 2f                	cmp    $0x2f,%al
80101ef0:	74 f6                	je     80101ee8 <namex+0x48>
  if(*path == 0)
80101ef2:	84 c0                	test   %al,%al
80101ef4:	0f 84 06 01 00 00    	je     80102000 <namex+0x160>
  while(*path != '/' && *path != 0)
80101efa:	0f b6 03             	movzbl (%ebx),%eax
80101efd:	84 c0                	test   %al,%al
80101eff:	0f 84 10 01 00 00    	je     80102015 <namex+0x175>
80101f05:	89 df                	mov    %ebx,%edi
80101f07:	3c 2f                	cmp    $0x2f,%al
80101f09:	0f 84 06 01 00 00    	je     80102015 <namex+0x175>
80101f0f:	90                   	nop
80101f10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f17:	3c 2f                	cmp    $0x2f,%al
80101f19:	74 04                	je     80101f1f <namex+0x7f>
80101f1b:	84 c0                	test   %al,%al
80101f1d:	75 f1                	jne    80101f10 <namex+0x70>
  len = path - s;
80101f1f:	89 f8                	mov    %edi,%eax
80101f21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f23:	83 f8 0d             	cmp    $0xd,%eax
80101f26:	0f 8e ac 00 00 00    	jle    80101fd8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f2c:	83 ec 04             	sub    $0x4,%esp
80101f2f:	6a 0e                	push   $0xe
80101f31:	53                   	push   %ebx
    path++;
80101f32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f34:	ff 75 e4             	push   -0x1c(%ebp)
80101f37:	e8 f4 29 00 00       	call   80104930 <memmove>
80101f3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f42:	75 0c                	jne    80101f50 <namex+0xb0>
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f4e:	74 f8                	je     80101f48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
80101f54:	e8 37 f9 ff ff       	call   80101890 <ilock>
    if(ip->type != T_DIR){
80101f59:	83 c4 10             	add    $0x10,%esp
80101f5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f61:	0f 85 cd 00 00 00    	jne    80102034 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	74 09                	je     80101f77 <namex+0xd7>
80101f6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f71:	0f 84 22 01 00 00    	je     80102099 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f77:	83 ec 04             	sub    $0x4,%esp
80101f7a:	6a 00                	push   $0x0
80101f7c:	ff 75 e4             	push   -0x1c(%ebp)
80101f7f:	56                   	push   %esi
80101f80:	e8 6b fe ff ff       	call   80101df0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	89 c7                	mov    %eax,%edi
80101f8d:	85 c0                	test   %eax,%eax
80101f8f:	0f 84 e1 00 00 00    	je     80102076 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f9b:	52                   	push   %edx
80101f9c:	e8 0f 26 00 00       	call   801045b0 <holdingsleep>
80101fa1:	83 c4 10             	add    $0x10,%esp
80101fa4:	85 c0                	test   %eax,%eax
80101fa6:	0f 84 30 01 00 00    	je     801020dc <namex+0x23c>
80101fac:	8b 56 08             	mov    0x8(%esi),%edx
80101faf:	85 d2                	test   %edx,%edx
80101fb1:	0f 8e 25 01 00 00    	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	52                   	push   %edx
80101fbe:	e8 ad 25 00 00       	call   80104570 <releasesleep>
  iput(ip);
80101fc3:	89 34 24             	mov    %esi,(%esp)
80101fc6:	89 fe                	mov    %edi,%esi
80101fc8:	e8 f3 f9 ff ff       	call   801019c0 <iput>
80101fcd:	83 c4 10             	add    $0x10,%esp
80101fd0:	e9 16 ff ff ff       	jmp    80101eeb <namex+0x4b>
80101fd5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fd8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fdb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101fde:	83 ec 04             	sub    $0x4,%esp
80101fe1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	53                   	push   %ebx
    name[len] = 0;
80101fe6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fe8:	ff 75 e4             	push   -0x1c(%ebp)
80101feb:	e8 40 29 00 00       	call   80104930 <memmove>
    name[len] = 0;
80101ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ff3:	83 c4 10             	add    $0x10,%esp
80101ff6:	c6 02 00             	movb   $0x0,(%edx)
80101ff9:	e9 41 ff ff ff       	jmp    80101f3f <namex+0x9f>
80101ffe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102000:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102003:	85 c0                	test   %eax,%eax
80102005:	0f 85 be 00 00 00    	jne    801020c9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010200b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200e:	89 f0                	mov    %esi,%eax
80102010:	5b                   	pop    %ebx
80102011:	5e                   	pop    %esi
80102012:	5f                   	pop    %edi
80102013:	5d                   	pop    %ebp
80102014:	c3                   	ret
  while(*path != '/' && *path != 0)
80102015:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102018:	89 df                	mov    %ebx,%edi
8010201a:	31 c0                	xor    %eax,%eax
8010201c:	eb c0                	jmp    80101fde <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010201e:	ba 01 00 00 00       	mov    $0x1,%edx
80102023:	b8 01 00 00 00       	mov    $0x1,%eax
80102028:	e8 33 f4 ff ff       	call   80101460 <iget>
8010202d:	89 c6                	mov    %eax,%esi
8010202f:	e9 b7 fe ff ff       	jmp    80101eeb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102034:	83 ec 0c             	sub    $0xc,%esp
80102037:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010203a:	53                   	push   %ebx
8010203b:	e8 70 25 00 00       	call   801045b0 <holdingsleep>
80102040:	83 c4 10             	add    $0x10,%esp
80102043:	85 c0                	test   %eax,%eax
80102045:	0f 84 91 00 00 00    	je     801020dc <namex+0x23c>
8010204b:	8b 46 08             	mov    0x8(%esi),%eax
8010204e:	85 c0                	test   %eax,%eax
80102050:	0f 8e 86 00 00 00    	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80102056:	83 ec 0c             	sub    $0xc,%esp
80102059:	53                   	push   %ebx
8010205a:	e8 11 25 00 00       	call   80104570 <releasesleep>
  iput(ip);
8010205f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102062:	31 f6                	xor    %esi,%esi
  iput(ip);
80102064:	e8 57 f9 ff ff       	call   801019c0 <iput>
      return 0;
80102069:	83 c4 10             	add    $0x10,%esp
}
8010206c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010206f:	89 f0                	mov    %esi,%eax
80102071:	5b                   	pop    %ebx
80102072:	5e                   	pop    %esi
80102073:	5f                   	pop    %edi
80102074:	5d                   	pop    %ebp
80102075:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102076:	83 ec 0c             	sub    $0xc,%esp
80102079:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010207c:	52                   	push   %edx
8010207d:	e8 2e 25 00 00       	call   801045b0 <holdingsleep>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	85 c0                	test   %eax,%eax
80102087:	74 53                	je     801020dc <namex+0x23c>
80102089:	8b 4e 08             	mov    0x8(%esi),%ecx
8010208c:	85 c9                	test   %ecx,%ecx
8010208e:	7e 4c                	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80102090:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102093:	83 ec 0c             	sub    $0xc,%esp
80102096:	52                   	push   %edx
80102097:	eb c1                	jmp    8010205a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102099:	83 ec 0c             	sub    $0xc,%esp
8010209c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010209f:	53                   	push   %ebx
801020a0:	e8 0b 25 00 00       	call   801045b0 <holdingsleep>
801020a5:	83 c4 10             	add    $0x10,%esp
801020a8:	85 c0                	test   %eax,%eax
801020aa:	74 30                	je     801020dc <namex+0x23c>
801020ac:	8b 7e 08             	mov    0x8(%esi),%edi
801020af:	85 ff                	test   %edi,%edi
801020b1:	7e 29                	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
801020b3:	83 ec 0c             	sub    $0xc,%esp
801020b6:	53                   	push   %ebx
801020b7:	e8 b4 24 00 00       	call   80104570 <releasesleep>
}
801020bc:	83 c4 10             	add    $0x10,%esp
}
801020bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c2:	89 f0                	mov    %esi,%eax
801020c4:	5b                   	pop    %ebx
801020c5:	5e                   	pop    %esi
801020c6:	5f                   	pop    %edi
801020c7:	5d                   	pop    %ebp
801020c8:	c3                   	ret
    iput(ip);
801020c9:	83 ec 0c             	sub    $0xc,%esp
801020cc:	56                   	push   %esi
    return 0;
801020cd:	31 f6                	xor    %esi,%esi
    iput(ip);
801020cf:	e8 ec f8 ff ff       	call   801019c0 <iput>
    return 0;
801020d4:	83 c4 10             	add    $0x10,%esp
801020d7:	e9 2f ff ff ff       	jmp    8010200b <namex+0x16b>
    panic("iunlock");
801020dc:	83 ec 0c             	sub    $0xc,%esp
801020df:	68 ae 77 10 80       	push   $0x801077ae
801020e4:	e8 97 e2 ff ff       	call   80100380 <panic>
801020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020f0 <dirlink>:
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 20             	sub    $0x20,%esp
801020f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020fc:	6a 00                	push   $0x0
801020fe:	ff 75 0c             	push   0xc(%ebp)
80102101:	53                   	push   %ebx
80102102:	e8 e9 fc ff ff       	call   80101df0 <dirlookup>
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	85 c0                	test   %eax,%eax
8010210c:	75 67                	jne    80102175 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010210e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102111:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102114:	85 ff                	test   %edi,%edi
80102116:	74 29                	je     80102141 <dirlink+0x51>
80102118:	31 ff                	xor    %edi,%edi
8010211a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010211d:	eb 09                	jmp    80102128 <dirlink+0x38>
8010211f:	90                   	nop
80102120:	83 c7 10             	add    $0x10,%edi
80102123:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102126:	73 19                	jae    80102141 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102128:	6a 10                	push   $0x10
8010212a:	57                   	push   %edi
8010212b:	56                   	push   %esi
8010212c:	53                   	push   %ebx
8010212d:	e8 6e fa ff ff       	call   80101ba0 <readi>
80102132:	83 c4 10             	add    $0x10,%esp
80102135:	83 f8 10             	cmp    $0x10,%eax
80102138:	75 4e                	jne    80102188 <dirlink+0x98>
    if(de.inum == 0)
8010213a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010213f:	75 df                	jne    80102120 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102141:	83 ec 04             	sub    $0x4,%esp
80102144:	8d 45 da             	lea    -0x26(%ebp),%eax
80102147:	6a 0e                	push   $0xe
80102149:	ff 75 0c             	push   0xc(%ebp)
8010214c:	50                   	push   %eax
8010214d:	e8 9e 28 00 00       	call   801049f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102152:	6a 10                	push   $0x10
  de.inum = inum;
80102154:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102157:	57                   	push   %edi
80102158:	56                   	push   %esi
80102159:	53                   	push   %ebx
  de.inum = inum;
8010215a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010215e:	e8 3d fb ff ff       	call   80101ca0 <writei>
80102163:	83 c4 20             	add    $0x20,%esp
80102166:	83 f8 10             	cmp    $0x10,%eax
80102169:	75 2a                	jne    80102195 <dirlink+0xa5>
  return 0;
8010216b:	31 c0                	xor    %eax,%eax
}
8010216d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102170:	5b                   	pop    %ebx
80102171:	5e                   	pop    %esi
80102172:	5f                   	pop    %edi
80102173:	5d                   	pop    %ebp
80102174:	c3                   	ret
    iput(ip);
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	50                   	push   %eax
80102179:	e8 42 f8 ff ff       	call   801019c0 <iput>
    return -1;
8010217e:	83 c4 10             	add    $0x10,%esp
80102181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102186:	eb e5                	jmp    8010216d <dirlink+0x7d>
      panic("dirlink read");
80102188:	83 ec 0c             	sub    $0xc,%esp
8010218b:	68 d7 77 10 80       	push   $0x801077d7
80102190:	e8 eb e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	68 52 7a 10 80       	push   $0x80107a52
8010219d:	e8 de e1 ff ff       	call   80100380 <panic>
801021a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021a9:	00 
801021aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021b0 <namei>:

struct inode*
namei(char *path)
{
801021b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021b1:	31 d2                	xor    %edx,%edx
{
801021b3:	89 e5                	mov    %esp,%ebp
801021b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021b8:	8b 45 08             	mov    0x8(%ebp),%eax
801021bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021be:	e8 dd fc ff ff       	call   80101ea0 <namex>
}
801021c3:	c9                   	leave
801021c4:	c3                   	ret
801021c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021cc:	00 
801021cd:	8d 76 00             	lea    0x0(%esi),%esi

801021d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021d0:	55                   	push   %ebp
  return namex(path, 1, name);
801021d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021df:	e9 bc fc ff ff       	jmp    80101ea0 <namex>
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	57                   	push   %edi
801021f4:	56                   	push   %esi
801021f5:	53                   	push   %ebx
801021f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021f9:	85 c0                	test   %eax,%eax
801021fb:	0f 84 b4 00 00 00    	je     801022b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102201:	8b 70 08             	mov    0x8(%eax),%esi
80102204:	89 c3                	mov    %eax,%ebx
80102206:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010220c:	0f 87 96 00 00 00    	ja     801022a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102212:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102217:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010221e:	00 
8010221f:	90                   	nop
80102220:	89 ca                	mov    %ecx,%edx
80102222:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102223:	83 e0 c0             	and    $0xffffffc0,%eax
80102226:	3c 40                	cmp    $0x40,%al
80102228:	75 f6                	jne    80102220 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010222a:	31 ff                	xor    %edi,%edi
8010222c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102231:	89 f8                	mov    %edi,%eax
80102233:	ee                   	out    %al,(%dx)
80102234:	b8 01 00 00 00       	mov    $0x1,%eax
80102239:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010223e:	ee                   	out    %al,(%dx)
8010223f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102244:	89 f0                	mov    %esi,%eax
80102246:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102247:	89 f0                	mov    %esi,%eax
80102249:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010224e:	c1 f8 08             	sar    $0x8,%eax
80102251:	ee                   	out    %al,(%dx)
80102252:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102257:	89 f8                	mov    %edi,%eax
80102259:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010225a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010225e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102263:	c1 e0 04             	shl    $0x4,%eax
80102266:	83 e0 10             	and    $0x10,%eax
80102269:	83 c8 e0             	or     $0xffffffe0,%eax
8010226c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010226d:	f6 03 04             	testb  $0x4,(%ebx)
80102270:	75 16                	jne    80102288 <idestart+0x98>
80102272:	b8 20 00 00 00       	mov    $0x20,%eax
80102277:	89 ca                	mov    %ecx,%edx
80102279:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010227a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227d:	5b                   	pop    %ebx
8010227e:	5e                   	pop    %esi
8010227f:	5f                   	pop    %edi
80102280:	5d                   	pop    %ebp
80102281:	c3                   	ret
80102282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102288:	b8 30 00 00 00       	mov    $0x30,%eax
8010228d:	89 ca                	mov    %ecx,%edx
8010228f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102290:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102295:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102298:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229d:	fc                   	cld
8010229e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022a3:	5b                   	pop    %ebx
801022a4:	5e                   	pop    %esi
801022a5:	5f                   	pop    %edi
801022a6:	5d                   	pop    %ebp
801022a7:	c3                   	ret
    panic("incorrect blockno");
801022a8:	83 ec 0c             	sub    $0xc,%esp
801022ab:	68 ed 77 10 80       	push   $0x801077ed
801022b0:	e8 cb e0 ff ff       	call   80100380 <panic>
    panic("idestart");
801022b5:	83 ec 0c             	sub    $0xc,%esp
801022b8:	68 e4 77 10 80       	push   $0x801077e4
801022bd:	e8 be e0 ff ff       	call   80100380 <panic>
801022c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022c9:	00 
801022ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022d0 <ideinit>:
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022d6:	68 ff 77 10 80       	push   $0x801077ff
801022db:	68 00 26 11 80       	push   $0x80112600
801022e0:	e8 1b 23 00 00       	call   80104600 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022e5:	58                   	pop    %eax
801022e6:	a1 84 27 11 80       	mov    0x80112784,%eax
801022eb:	5a                   	pop    %edx
801022ec:	83 e8 01             	sub    $0x1,%eax
801022ef:	50                   	push   %eax
801022f0:	6a 0e                	push   $0xe
801022f2:	e8 99 02 00 00       	call   80102590 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ff:	90                   	nop
80102300:	ec                   	in     (%dx),%al
80102301:	83 e0 c0             	and    $0xffffffc0,%eax
80102304:	3c 40                	cmp    $0x40,%al
80102306:	75 f8                	jne    80102300 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102308:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010230d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102312:	ee                   	out    %al,(%dx)
80102313:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102318:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010231d:	eb 06                	jmp    80102325 <ideinit+0x55>
8010231f:	90                   	nop
  for(i=0; i<1000; i++){
80102320:	83 e9 01             	sub    $0x1,%ecx
80102323:	74 0f                	je     80102334 <ideinit+0x64>
80102325:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102326:	84 c0                	test   %al,%al
80102328:	74 f6                	je     80102320 <ideinit+0x50>
      havedisk1 = 1;
8010232a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102331:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102334:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102339:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010233e:	ee                   	out    %al,(%dx)
}
8010233f:	c9                   	leave
80102340:	c3                   	ret
80102341:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102348:	00 
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102350 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	57                   	push   %edi
80102354:	56                   	push   %esi
80102355:	53                   	push   %ebx
80102356:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102359:	68 00 26 11 80       	push   $0x80112600
8010235e:	e8 6d 24 00 00       	call   801047d0 <acquire>

  if((b = idequeue) == 0){
80102363:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	85 db                	test   %ebx,%ebx
8010236e:	74 63                	je     801023d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102370:	8b 43 58             	mov    0x58(%ebx),%eax
80102373:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102378:	8b 33                	mov    (%ebx),%esi
8010237a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102380:	75 2f                	jne    801023b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102382:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010238e:	00 
8010238f:	90                   	nop
80102390:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102391:	89 c1                	mov    %eax,%ecx
80102393:	83 e1 c0             	and    $0xffffffc0,%ecx
80102396:	80 f9 40             	cmp    $0x40,%cl
80102399:	75 f5                	jne    80102390 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010239b:	a8 21                	test   $0x21,%al
8010239d:	75 12                	jne    801023b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010239f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801023a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023ac:	fc                   	cld
801023ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801023af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801023b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801023b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023b7:	83 ce 02             	or     $0x2,%esi
801023ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801023bc:	53                   	push   %ebx
801023bd:	e8 6e 1f 00 00       	call   80104330 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023c2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801023c7:	83 c4 10             	add    $0x10,%esp
801023ca:	85 c0                	test   %eax,%eax
801023cc:	74 05                	je     801023d3 <ideintr+0x83>
    idestart(idequeue);
801023ce:	e8 1d fe ff ff       	call   801021f0 <idestart>
    release(&idelock);
801023d3:	83 ec 0c             	sub    $0xc,%esp
801023d6:	68 00 26 11 80       	push   $0x80112600
801023db:	e8 90 23 00 00       	call   80104770 <release>

  release(&idelock);
}
801023e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e3:	5b                   	pop    %ebx
801023e4:	5e                   	pop    %esi
801023e5:	5f                   	pop    %edi
801023e6:	5d                   	pop    %ebp
801023e7:	c3                   	ret
801023e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801023ef:	00 

801023f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	53                   	push   %ebx
801023f4:	83 ec 10             	sub    $0x10,%esp
801023f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801023fd:	50                   	push   %eax
801023fe:	e8 ad 21 00 00       	call   801045b0 <holdingsleep>
80102403:	83 c4 10             	add    $0x10,%esp
80102406:	85 c0                	test   %eax,%eax
80102408:	0f 84 c3 00 00 00    	je     801024d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010240e:	8b 03                	mov    (%ebx),%eax
80102410:	83 e0 06             	and    $0x6,%eax
80102413:	83 f8 02             	cmp    $0x2,%eax
80102416:	0f 84 a8 00 00 00    	je     801024c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010241c:	8b 53 04             	mov    0x4(%ebx),%edx
8010241f:	85 d2                	test   %edx,%edx
80102421:	74 0d                	je     80102430 <iderw+0x40>
80102423:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102428:	85 c0                	test   %eax,%eax
8010242a:	0f 84 87 00 00 00    	je     801024b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102430:	83 ec 0c             	sub    $0xc,%esp
80102433:	68 00 26 11 80       	push   $0x80112600
80102438:	e8 93 23 00 00       	call   801047d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010243d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102442:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102449:	83 c4 10             	add    $0x10,%esp
8010244c:	85 c0                	test   %eax,%eax
8010244e:	74 60                	je     801024b0 <iderw+0xc0>
80102450:	89 c2                	mov    %eax,%edx
80102452:	8b 40 58             	mov    0x58(%eax),%eax
80102455:	85 c0                	test   %eax,%eax
80102457:	75 f7                	jne    80102450 <iderw+0x60>
80102459:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010245c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010245e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102464:	74 3a                	je     801024a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102466:	8b 03                	mov    (%ebx),%eax
80102468:	83 e0 06             	and    $0x6,%eax
8010246b:	83 f8 02             	cmp    $0x2,%eax
8010246e:	74 1b                	je     8010248b <iderw+0x9b>
    sleep(b, &idelock);
80102470:	83 ec 08             	sub    $0x8,%esp
80102473:	68 00 26 11 80       	push   $0x80112600
80102478:	53                   	push   %ebx
80102479:	e8 f2 1d 00 00       	call   80104270 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010247e:	8b 03                	mov    (%ebx),%eax
80102480:	83 c4 10             	add    $0x10,%esp
80102483:	83 e0 06             	and    $0x6,%eax
80102486:	83 f8 02             	cmp    $0x2,%eax
80102489:	75 e5                	jne    80102470 <iderw+0x80>
  }


  release(&idelock);
8010248b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102495:	c9                   	leave
  release(&idelock);
80102496:	e9 d5 22 00 00       	jmp    80104770 <release>
8010249b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801024a0:	89 d8                	mov    %ebx,%eax
801024a2:	e8 49 fd ff ff       	call   801021f0 <idestart>
801024a7:	eb bd                	jmp    80102466 <iderw+0x76>
801024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024b0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801024b5:	eb a5                	jmp    8010245c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801024b7:	83 ec 0c             	sub    $0xc,%esp
801024ba:	68 2e 78 10 80       	push   $0x8010782e
801024bf:	e8 bc de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	68 19 78 10 80       	push   $0x80107819
801024cc:	e8 af de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801024d1:	83 ec 0c             	sub    $0xc,%esp
801024d4:	68 03 78 10 80       	push   $0x80107803
801024d9:	e8 a2 de ff ff       	call   80100380 <panic>
801024de:	66 90                	xchg   %ax,%ax

801024e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024e1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801024e8:	00 c0 fe 
{
801024eb:	89 e5                	mov    %esp,%ebp
801024ed:	56                   	push   %esi
801024ee:	53                   	push   %ebx
  ioapic->reg = reg;
801024ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024f6:	00 00 00 
  return ioapic->data;
801024f9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102502:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102508:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010250e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102515:	c1 ee 10             	shr    $0x10,%esi
80102518:	89 f0                	mov    %esi,%eax
8010251a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010251d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102520:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102523:	39 c2                	cmp    %eax,%edx
80102525:	74 16                	je     8010253d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102527:	83 ec 0c             	sub    $0xc,%esp
8010252a:	68 08 7c 10 80       	push   $0x80107c08
8010252f:	e8 6c e1 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102534:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010253a:	83 c4 10             	add    $0x10,%esp
8010253d:	83 c6 21             	add    $0x21,%esi
{
80102540:	ba 10 00 00 00       	mov    $0x10,%edx
80102545:	b8 20 00 00 00       	mov    $0x20,%eax
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102550:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102552:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102554:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010255a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010255d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102563:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102566:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102569:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010256c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010256e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102574:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010257b:	39 f0                	cmp    %esi,%eax
8010257d:	75 d1                	jne    80102550 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010257f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102582:	5b                   	pop    %ebx
80102583:	5e                   	pop    %esi
80102584:	5d                   	pop    %ebp
80102585:	c3                   	ret
80102586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010258d:	00 
8010258e:	66 90                	xchg   %ax,%ax

80102590 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102590:	55                   	push   %ebp
  ioapic->reg = reg;
80102591:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102597:	89 e5                	mov    %esp,%ebp
80102599:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010259c:	8d 50 20             	lea    0x20(%eax),%edx
8010259f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025b6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025be:	89 50 10             	mov    %edx,0x10(%eax)
}
801025c1:	5d                   	pop    %ebp
801025c2:	c3                   	ret
801025c3:	66 90                	xchg   %ax,%ax
801025c5:	66 90                	xchg   %ax,%ax
801025c7:	66 90                	xchg   %ax,%ax
801025c9:	66 90                	xchg   %ax,%ax
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	53                   	push   %ebx
801025d4:	83 ec 04             	sub    $0x4,%esp
801025d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025e0:	75 76                	jne    80102658 <kfree+0x88>
801025e2:	81 fb 50 66 11 80    	cmp    $0x80116650,%ebx
801025e8:	72 6e                	jb     80102658 <kfree+0x88>
801025ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025f5:	77 61                	ja     80102658 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025f7:	83 ec 04             	sub    $0x4,%esp
801025fa:	68 00 10 00 00       	push   $0x1000
801025ff:	6a 01                	push   $0x1
80102601:	53                   	push   %ebx
80102602:	e8 89 22 00 00       	call   80104890 <memset>

  if(kmem.use_lock)
80102607:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	85 d2                	test   %edx,%edx
80102612:	75 1c                	jne    80102630 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102614:	a1 78 26 11 80       	mov    0x80112678,%eax
80102619:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010261b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102620:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102626:	85 c0                	test   %eax,%eax
80102628:	75 1e                	jne    80102648 <kfree+0x78>
    release(&kmem.lock);
}
8010262a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010262d:	c9                   	leave
8010262e:	c3                   	ret
8010262f:	90                   	nop
    acquire(&kmem.lock);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	68 40 26 11 80       	push   $0x80112640
80102638:	e8 93 21 00 00       	call   801047d0 <acquire>
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	eb d2                	jmp    80102614 <kfree+0x44>
80102642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102648:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010264f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102652:	c9                   	leave
    release(&kmem.lock);
80102653:	e9 18 21 00 00       	jmp    80104770 <release>
    panic("kfree");
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	68 4c 78 10 80       	push   $0x8010784c
80102660:	e8 1b dd ff ff       	call   80100380 <panic>
80102665:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010266c:	00 
8010266d:	8d 76 00             	lea    0x0(%esi),%esi

80102670 <freerange>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102674:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102677:	8b 75 0c             	mov    0xc(%ebp),%esi
8010267a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010267b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102681:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102687:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010268d:	39 de                	cmp    %ebx,%esi
8010268f:	72 23                	jb     801026b4 <freerange+0x44>
80102691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102698:	83 ec 0c             	sub    $0xc,%esp
8010269b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026a7:	50                   	push   %eax
801026a8:	e8 23 ff ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
801026b0:	39 f3                	cmp    %esi,%ebx
801026b2:	76 e4                	jbe    80102698 <freerange+0x28>
}
801026b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b7:	5b                   	pop    %ebx
801026b8:	5e                   	pop    %esi
801026b9:	5d                   	pop    %ebp
801026ba:	c3                   	ret
801026bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026c0 <kinit2>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dd:	39 de                	cmp    %ebx,%esi
801026df:	72 23                	jb     80102704 <kinit2+0x44>
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026e8:	83 ec 0c             	sub    $0xc,%esp
801026eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026f7:	50                   	push   %eax
801026f8:	e8 d3 fe ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	39 de                	cmp    %ebx,%esi
80102702:	73 e4                	jae    801026e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102704:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010270b:	00 00 00 
}
8010270e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102711:	5b                   	pop    %ebx
80102712:	5e                   	pop    %esi
80102713:	5d                   	pop    %ebp
80102714:	c3                   	ret
80102715:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010271c:	00 
8010271d:	8d 76 00             	lea    0x0(%esi),%esi

80102720 <kinit1>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
80102725:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 52 78 10 80       	push   $0x80107852
80102730:	68 40 26 11 80       	push   $0x80112640
80102735:	e8 c6 1e 00 00       	call   80104600 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102740:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102747:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010274a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102750:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102756:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	72 1c                	jb     8010277c <kinit1+0x5c>
    kfree(p);
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010276f:	50                   	push   %eax
80102770:	e8 5b fe ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	39 de                	cmp    %ebx,%esi
8010277a:	73 e4                	jae    80102760 <kinit1+0x40>
}
8010277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5d                   	pop    %ebp
80102782:	c3                   	ret
80102783:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010278a:	00 
8010278b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102790 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102790:	a1 74 26 11 80       	mov    0x80112674,%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	75 1f                	jne    801027b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102799:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010279e:	85 c0                	test   %eax,%eax
801027a0:	74 0e                	je     801027b0 <kalloc+0x20>
    kmem.freelist = r->next;
801027a2:	8b 10                	mov    (%eax),%edx
801027a4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801027aa:	c3                   	ret
801027ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
  return (char*)r;
}
801027b0:	c3                   	ret
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027b8:	55                   	push   %ebp
801027b9:	89 e5                	mov    %esp,%ebp
801027bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027be:	68 40 26 11 80       	push   $0x80112640
801027c3:	e8 08 20 00 00       	call   801047d0 <acquire>
  r = kmem.freelist;
801027c8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801027cd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801027d3:	83 c4 10             	add    $0x10,%esp
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 08                	je     801027e2 <kalloc+0x52>
    kmem.freelist = r->next;
801027da:	8b 08                	mov    (%eax),%ecx
801027dc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801027e2:	85 d2                	test   %edx,%edx
801027e4:	74 16                	je     801027fc <kalloc+0x6c>
    release(&kmem.lock);
801027e6:	83 ec 0c             	sub    $0xc,%esp
801027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027ec:	68 40 26 11 80       	push   $0x80112640
801027f1:	e8 7a 1f 00 00       	call   80104770 <release>
  return (char*)r;
801027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027f9:	83 c4 10             	add    $0x10,%esp
}
801027fc:	c9                   	leave
801027fd:	c3                   	ret
801027fe:	66 90                	xchg   %ax,%ax

80102800 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102800:	ba 64 00 00 00       	mov    $0x64,%edx
80102805:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102806:	a8 01                	test   $0x1,%al
80102808:	0f 84 c2 00 00 00    	je     801028d0 <kbdgetc+0xd0>
{
8010280e:	55                   	push   %ebp
8010280f:	ba 60 00 00 00       	mov    $0x60,%edx
80102814:	89 e5                	mov    %esp,%ebp
80102816:	53                   	push   %ebx
80102817:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102818:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010281e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102821:	3c e0                	cmp    $0xe0,%al
80102823:	74 5b                	je     80102880 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102825:	89 da                	mov    %ebx,%edx
80102827:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010282a:	84 c0                	test   %al,%al
8010282c:	78 62                	js     80102890 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010282e:	85 d2                	test   %edx,%edx
80102830:	74 09                	je     8010283b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102832:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102835:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102838:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010283b:	0f b6 91 e0 7e 10 80 	movzbl -0x7fef8120(%ecx),%edx
  shift ^= togglecode[data];
80102842:	0f b6 81 e0 7d 10 80 	movzbl -0x7fef8220(%ecx),%eax
  shift |= shiftcode[data];
80102849:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010284b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010284d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010284f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102855:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102858:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010285b:	8b 04 85 c0 7d 10 80 	mov    -0x7fef8240(,%eax,4),%eax
80102862:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102866:	74 0b                	je     80102873 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102868:	8d 50 9f             	lea    -0x61(%eax),%edx
8010286b:	83 fa 19             	cmp    $0x19,%edx
8010286e:	77 48                	ja     801028b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102870:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102873:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102876:	c9                   	leave
80102877:	c3                   	ret
80102878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010287f:	00 
    shift |= E0ESC;
80102880:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102883:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102885:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010288b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288e:	c9                   	leave
8010288f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102890:	83 e0 7f             	and    $0x7f,%eax
80102893:	85 d2                	test   %edx,%edx
80102895:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102898:	0f b6 81 e0 7e 10 80 	movzbl -0x7fef8120(%ecx),%eax
8010289f:	83 c8 40             	or     $0x40,%eax
801028a2:	0f b6 c0             	movzbl %al,%eax
801028a5:	f7 d0                	not    %eax
801028a7:	21 d8                	and    %ebx,%eax
}
801028a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028ac:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801028b1:	31 c0                	xor    %eax,%eax
}
801028b3:	c9                   	leave
801028b4:	c3                   	ret
801028b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801028b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801028be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c1:	c9                   	leave
      c += 'a' - 'A';
801028c2:	83 f9 1a             	cmp    $0x1a,%ecx
801028c5:	0f 42 c2             	cmovb  %edx,%eax
}
801028c8:	c3                   	ret
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028d5:	c3                   	ret
801028d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028dd:	00 
801028de:	66 90                	xchg   %ax,%ax

801028e0 <kbdintr>:

void
kbdintr(void)
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
801028e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028e6:	68 00 28 10 80       	push   $0x80102800
801028eb:	e8 90 df ff ff       	call   80100880 <consoleintr>
}
801028f0:	83 c4 10             	add    $0x10,%esp
801028f3:	c9                   	leave
801028f4:	c3                   	ret
801028f5:	66 90                	xchg   %ax,%ax
801028f7:	66 90                	xchg   %ax,%ax
801028f9:	66 90                	xchg   %ax,%ax
801028fb:	66 90                	xchg   %ax,%ax
801028fd:	66 90                	xchg   %ax,%ax
801028ff:	90                   	nop

80102900 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102900:	a1 80 26 11 80       	mov    0x80112680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	0f 84 cb 00 00 00    	je     801029d8 <lapicinit+0xd8>
  lapic[index] = value;
8010290d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102914:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102921:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102924:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102927:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010292e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102931:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102934:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010293b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010293e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102941:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102948:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102955:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102958:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010295b:	8b 50 30             	mov    0x30(%eax),%edx
8010295e:	c1 ea 10             	shr    $0x10,%edx
80102961:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102967:	75 77                	jne    801029e0 <lapicinit+0xe0>
  lapic[index] = value;
80102969:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102976:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010297d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102980:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102983:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010298a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102990:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102997:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029b4:	8b 50 20             	mov    0x20(%eax),%edx
801029b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029be:	00 
801029bf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029c6:	80 e6 10             	and    $0x10,%dh
801029c9:	75 f5                	jne    801029c0 <lapicinit+0xc0>
  lapic[index] = value;
801029cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029d8:	c3                   	ret
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801029ed:	e9 77 ff ff ff       	jmp    80102969 <lapicinit+0x69>
801029f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029f9:	00 
801029fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a00:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	74 07                	je     80102a10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a09:	8b 40 20             	mov    0x20(%eax),%eax
80102a0c:	c1 e8 18             	shr    $0x18,%eax
80102a0f:	c3                   	ret
    return 0;
80102a10:	31 c0                	xor    %eax,%eax
}
80102a12:	c3                   	ret
80102a13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a1a:	00 
80102a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102a20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a20:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 0d                	je     80102a36 <lapiceoi+0x16>
  lapic[index] = value;
80102a29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a36:	c3                   	ret
80102a37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a3e:	00 
80102a3f:	90                   	nop

80102a40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a40:	c3                   	ret
80102a41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a48:	00 
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a56:	ba 70 00 00 00       	mov    $0x70,%edx
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	53                   	push   %ebx
80102a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a64:	ee                   	out    %al,(%dx)
80102a65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a8e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102aa3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aa9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ab0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ab6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102abc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102abf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ace:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ad7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102add:	c9                   	leave
80102ade:	c3                   	ret
80102adf:	90                   	nop

80102ae0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ae0:	55                   	push   %ebp
80102ae1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ae6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	57                   	push   %edi
80102aee:	56                   	push   %esi
80102aef:	53                   	push   %ebx
80102af0:	83 ec 4c             	sub    $0x4c,%esp
80102af3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af4:	ba 71 00 00 00       	mov    $0x71,%edx
80102af9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102afa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b05:	8d 76 00             	lea    0x0(%esi),%esi
80102b08:	31 c0                	xor    %eax,%eax
80102b0a:	89 da                	mov    %ebx,%edx
80102b0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b12:	89 ca                	mov    %ecx,%edx
80102b14:	ec                   	in     (%dx),%al
80102b15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b18:	89 da                	mov    %ebx,%edx
80102b1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b20:	89 ca                	mov    %ecx,%edx
80102b22:	ec                   	in     (%dx),%al
80102b23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b26:	89 da                	mov    %ebx,%edx
80102b28:	b8 04 00 00 00       	mov    $0x4,%eax
80102b2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2e:	89 ca                	mov    %ecx,%edx
80102b30:	ec                   	in     (%dx),%al
80102b31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b34:	89 da                	mov    %ebx,%edx
80102b36:	b8 07 00 00 00       	mov    $0x7,%eax
80102b3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	89 ca                	mov    %ecx,%edx
80102b3e:	ec                   	in     (%dx),%al
80102b3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b42:	89 da                	mov    %ebx,%edx
80102b44:	b8 08 00 00 00       	mov    $0x8,%eax
80102b49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4a:	89 ca                	mov    %ecx,%edx
80102b4c:	ec                   	in     (%dx),%al
80102b4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4f:	89 da                	mov    %ebx,%edx
80102b51:	b8 09 00 00 00       	mov    $0x9,%eax
80102b56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b57:	89 ca                	mov    %ecx,%edx
80102b59:	ec                   	in     (%dx),%al
80102b5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5c:	89 da                	mov    %ebx,%edx
80102b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b64:	89 ca                	mov    %ecx,%edx
80102b66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b67:	84 c0                	test   %al,%al
80102b69:	78 9d                	js     80102b08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b6f:	89 fa                	mov    %edi,%edx
80102b71:	0f b6 fa             	movzbl %dl,%edi
80102b74:	89 f2                	mov    %esi,%edx
80102b76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b80:	89 da                	mov    %ebx,%edx
80102b82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b99:	31 c0                	xor    %eax,%eax
80102b9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9c:	89 ca                	mov    %ecx,%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba2:	89 da                	mov    %ebx,%edx
80102ba4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ba7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bad:	89 ca                	mov    %ecx,%edx
80102baf:	ec                   	in     (%dx),%al
80102bb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb3:	89 da                	mov    %ebx,%edx
80102bb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbe:	89 ca                	mov    %ecx,%edx
80102bc0:	ec                   	in     (%dx),%al
80102bc1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc4:	89 da                	mov    %ebx,%edx
80102bc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcf:	89 ca                	mov    %ecx,%edx
80102bd1:	ec                   	in     (%dx),%al
80102bd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd5:	89 da                	mov    %ebx,%edx
80102bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bda:	b8 08 00 00 00       	mov    $0x8,%eax
80102bdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be0:	89 ca                	mov    %ecx,%edx
80102be2:	ec                   	in     (%dx),%al
80102be3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be6:	89 da                	mov    %ebx,%edx
80102be8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102beb:	b8 09 00 00 00       	mov    $0x9,%eax
80102bf0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf1:	89 ca                	mov    %ecx,%edx
80102bf3:	ec                   	in     (%dx),%al
80102bf4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bf7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bfd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c00:	6a 18                	push   $0x18
80102c02:	50                   	push   %eax
80102c03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c06:	50                   	push   %eax
80102c07:	e8 d4 1c 00 00       	call   801048e0 <memcmp>
80102c0c:	83 c4 10             	add    $0x10,%esp
80102c0f:	85 c0                	test   %eax,%eax
80102c11:	0f 85 f1 fe ff ff    	jne    80102b08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c1b:	75 78                	jne    80102c95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c20:	89 c2                	mov    %eax,%edx
80102c22:	83 e0 0f             	and    $0xf,%eax
80102c25:	c1 ea 04             	shr    $0x4,%edx
80102c28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c34:	89 c2                	mov    %eax,%edx
80102c36:	83 e0 0f             	and    $0xf,%eax
80102c39:	c1 ea 04             	shr    $0x4,%edx
80102c3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c48:	89 c2                	mov    %eax,%edx
80102c4a:	83 e0 0f             	and    $0xf,%eax
80102c4d:	c1 ea 04             	shr    $0x4,%edx
80102c50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c5c:	89 c2                	mov    %eax,%edx
80102c5e:	83 e0 0f             	and    $0xf,%eax
80102c61:	c1 ea 04             	shr    $0x4,%edx
80102c64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c70:	89 c2                	mov    %eax,%edx
80102c72:	83 e0 0f             	and    $0xf,%eax
80102c75:	c1 ea 04             	shr    $0x4,%edx
80102c78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c84:	89 c2                	mov    %eax,%edx
80102c86:	83 e0 0f             	and    $0xf,%eax
80102c89:	c1 ea 04             	shr    $0x4,%edx
80102c8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c95:	8b 75 08             	mov    0x8(%ebp),%esi
80102c98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c9b:	89 06                	mov    %eax,(%esi)
80102c9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ca0:	89 46 04             	mov    %eax,0x4(%esi)
80102ca3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ca6:	89 46 08             	mov    %eax,0x8(%esi)
80102ca9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cac:	89 46 0c             	mov    %eax,0xc(%esi)
80102caf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cb2:	89 46 10             	mov    %eax,0x10(%esi)
80102cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cc5:	5b                   	pop    %ebx
80102cc6:	5e                   	pop    %esi
80102cc7:	5f                   	pop    %edi
80102cc8:	5d                   	pop    %ebp
80102cc9:	c3                   	ret
80102cca:	66 90                	xchg   %ax,%ax
80102ccc:	66 90                	xchg   %ax,%ax
80102cce:	66 90                	xchg   %ax,%ax

80102cd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cd0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102cd6:	85 c9                	test   %ecx,%ecx
80102cd8:	0f 8e 8a 00 00 00    	jle    80102d68 <install_trans+0x98>
{
80102cde:	55                   	push   %ebp
80102cdf:	89 e5                	mov    %esp,%ebp
80102ce1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce2:	31 ff                	xor    %edi,%edi
{
80102ce4:	56                   	push   %esi
80102ce5:	53                   	push   %ebx
80102ce6:	83 ec 0c             	sub    $0xc,%esp
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cf0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102cf5:	83 ec 08             	sub    $0x8,%esp
80102cf8:	01 f8                	add    %edi,%eax
80102cfa:	83 c0 01             	add    $0x1,%eax
80102cfd:	50                   	push   %eax
80102cfe:	ff 35 e4 26 11 80    	push   0x801126e4
80102d04:	e8 c7 d3 ff ff       	call   801000d0 <bread>
80102d09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d0b:	58                   	pop    %eax
80102d0c:	5a                   	pop    %edx
80102d0d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102d14:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d1d:	e8 ae d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d2a:	68 00 02 00 00       	push   $0x200
80102d2f:	50                   	push   %eax
80102d30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d33:	50                   	push   %eax
80102d34:	e8 f7 1b 00 00       	call   80104930 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d39:	89 1c 24             	mov    %ebx,(%esp)
80102d3c:	e8 6f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d41:	89 34 24             	mov    %esi,(%esp)
80102d44:	e8 a7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d49:	89 1c 24             	mov    %ebx,(%esp)
80102d4c:	e8 9f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102d5a:	7f 94                	jg     80102cf0 <install_trans+0x20>
  }
}
80102d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5f:	5b                   	pop    %ebx
80102d60:	5e                   	pop    %esi
80102d61:	5f                   	pop    %edi
80102d62:	5d                   	pop    %ebp
80102d63:	c3                   	ret
80102d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d68:	c3                   	ret
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d77:	ff 35 d4 26 11 80    	push   0x801126d4
80102d7d:	ff 35 e4 26 11 80    	push   0x801126e4
80102d83:	e8 48 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d8d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102d92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d95:	85 c0                	test   %eax,%eax
80102d97:	7e 19                	jle    80102db2 <write_head+0x42>
80102d99:	31 d2                	xor    %edx,%edx
80102d9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102da0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102da7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dab:	83 c2 01             	add    $0x1,%edx
80102dae:	39 d0                	cmp    %edx,%eax
80102db0:	75 ee                	jne    80102da0 <write_head+0x30>
  }
  bwrite(buf);
80102db2:	83 ec 0c             	sub    $0xc,%esp
80102db5:	53                   	push   %ebx
80102db6:	e8 f5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102dbb:	89 1c 24             	mov    %ebx,(%esp)
80102dbe:	e8 2d d4 ff ff       	call   801001f0 <brelse>
}
80102dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc6:	83 c4 10             	add    $0x10,%esp
80102dc9:	c9                   	leave
80102dca:	c3                   	ret
80102dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102dd0 <initlog>:
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 2c             	sub    $0x2c,%esp
80102dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dda:	68 57 78 10 80       	push   $0x80107857
80102ddf:	68 a0 26 11 80       	push   $0x801126a0
80102de4:	e8 17 18 00 00       	call   80104600 <initlock>
  readsb(dev, &sb);
80102de9:	58                   	pop    %eax
80102dea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ded:	5a                   	pop    %edx
80102dee:	50                   	push   %eax
80102def:	53                   	push   %ebx
80102df0:	e8 3b e8 ff ff       	call   80101630 <readsb>
  log.start = sb.logstart;
80102df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102df8:	59                   	pop    %ecx
  log.dev = dev;
80102df9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102dff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e02:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102e07:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102e0d:	5a                   	pop    %edx
80102e0e:	50                   	push   %eax
80102e0f:	53                   	push   %ebx
80102e10:	e8 bb d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e1b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102e21:	85 db                	test   %ebx,%ebx
80102e23:	7e 1d                	jle    80102e42 <initlog+0x72>
80102e25:	31 d2                	xor    %edx,%edx
80102e27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e2e:	00 
80102e2f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102e30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e34:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e3b:	83 c2 01             	add    $0x1,%edx
80102e3e:	39 d3                	cmp    %edx,%ebx
80102e40:	75 ee                	jne    80102e30 <initlog+0x60>
  brelse(buf);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	50                   	push   %eax
80102e46:	e8 a5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e4b:	e8 80 fe ff ff       	call   80102cd0 <install_trans>
  log.lh.n = 0;
80102e50:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102e57:	00 00 00 
  write_head(); // clear the log
80102e5a:	e8 11 ff ff ff       	call   80102d70 <write_head>
}
80102e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e62:	83 c4 10             	add    $0x10,%esp
80102e65:	c9                   	leave
80102e66:	c3                   	ret
80102e67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e6e:	00 
80102e6f:	90                   	nop

80102e70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e76:	68 a0 26 11 80       	push   $0x801126a0
80102e7b:	e8 50 19 00 00       	call   801047d0 <acquire>
80102e80:	83 c4 10             	add    $0x10,%esp
80102e83:	eb 18                	jmp    80102e9d <begin_op+0x2d>
80102e85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e88:	83 ec 08             	sub    $0x8,%esp
80102e8b:	68 a0 26 11 80       	push   $0x801126a0
80102e90:	68 a0 26 11 80       	push   $0x801126a0
80102e95:	e8 d6 13 00 00       	call   80104270 <sleep>
80102e9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e9d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102ea2:	85 c0                	test   %eax,%eax
80102ea4:	75 e2                	jne    80102e88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ea6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102eab:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102eb1:	83 c0 01             	add    $0x1,%eax
80102eb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102eb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eba:	83 fa 1e             	cmp    $0x1e,%edx
80102ebd:	7f c9                	jg     80102e88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ebf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ec2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102ec7:	68 a0 26 11 80       	push   $0x801126a0
80102ecc:	e8 9f 18 00 00       	call   80104770 <release>
      break;
    }
  }
}
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	c9                   	leave
80102ed5:	c3                   	ret
80102ed6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102edd:	00 
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	57                   	push   %edi
80102ee4:	56                   	push   %esi
80102ee5:	53                   	push   %ebx
80102ee6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ee9:	68 a0 26 11 80       	push   $0x801126a0
80102eee:	e8 dd 18 00 00       	call   801047d0 <acquire>
  log.outstanding -= 1;
80102ef3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102ef8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102efe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f04:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102f0a:	85 f6                	test   %esi,%esi
80102f0c:	0f 85 22 01 00 00    	jne    80103034 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f12:	85 db                	test   %ebx,%ebx
80102f14:	0f 85 f6 00 00 00    	jne    80103010 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f1a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102f21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 a0 26 11 80       	push   $0x801126a0
80102f2c:	e8 3f 18 00 00       	call   80104770 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f31:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102f37:	83 c4 10             	add    $0x10,%esp
80102f3a:	85 c9                	test   %ecx,%ecx
80102f3c:	7f 42                	jg     80102f80 <end_op+0xa0>
    acquire(&log.lock);
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	68 a0 26 11 80       	push   $0x801126a0
80102f46:	e8 85 18 00 00       	call   801047d0 <acquire>
    wakeup(&log);
80102f4b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102f52:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102f59:	00 00 00 
    wakeup(&log);
80102f5c:	e8 cf 13 00 00       	call   80104330 <wakeup>
    release(&log.lock);
80102f61:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f68:	e8 03 18 00 00       	call   80104770 <release>
80102f6d:	83 c4 10             	add    $0x10,%esp
}
80102f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f73:	5b                   	pop    %ebx
80102f74:	5e                   	pop    %esi
80102f75:	5f                   	pop    %edi
80102f76:	5d                   	pop    %ebp
80102f77:	c3                   	ret
80102f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f7f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f80:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102f85:	83 ec 08             	sub    $0x8,%esp
80102f88:	01 d8                	add    %ebx,%eax
80102f8a:	83 c0 01             	add    $0x1,%eax
80102f8d:	50                   	push   %eax
80102f8e:	ff 35 e4 26 11 80    	push   0x801126e4
80102f94:	e8 37 d1 ff ff       	call   801000d0 <bread>
80102f99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f9b:	58                   	pop    %eax
80102f9c:	5a                   	pop    %edx
80102f9d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102fa4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102faa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fad:	e8 1e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102fb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fba:	68 00 02 00 00       	push   $0x200
80102fbf:	50                   	push   %eax
80102fc0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fc3:	50                   	push   %eax
80102fc4:	e8 67 19 00 00       	call   80104930 <memmove>
    bwrite(to);  // write the log
80102fc9:	89 34 24             	mov    %esi,(%esp)
80102fcc:	e8 df d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102fd1:	89 3c 24             	mov    %edi,(%esp)
80102fd4:	e8 17 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102fd9:	89 34 24             	mov    %esi,(%esp)
80102fdc:	e8 0f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fe1:	83 c4 10             	add    $0x10,%esp
80102fe4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102fea:	7c 94                	jl     80102f80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fec:	e8 7f fd ff ff       	call   80102d70 <write_head>
    install_trans(); // Now install writes to home locations
80102ff1:	e8 da fc ff ff       	call   80102cd0 <install_trans>
    log.lh.n = 0;
80102ff6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ffd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103000:	e8 6b fd ff ff       	call   80102d70 <write_head>
80103005:	e9 34 ff ff ff       	jmp    80102f3e <end_op+0x5e>
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103010:	83 ec 0c             	sub    $0xc,%esp
80103013:	68 a0 26 11 80       	push   $0x801126a0
80103018:	e8 13 13 00 00       	call   80104330 <wakeup>
  release(&log.lock);
8010301d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103024:	e8 47 17 00 00       	call   80104770 <release>
80103029:	83 c4 10             	add    $0x10,%esp
}
8010302c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret
    panic("log.committing");
80103034:	83 ec 0c             	sub    $0xc,%esp
80103037:	68 5b 78 10 80       	push   $0x8010785b
8010303c:	e8 3f d3 ff ff       	call   80100380 <panic>
80103041:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103048:	00 
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103050 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103057:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
8010305d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103060:	83 fa 1d             	cmp    $0x1d,%edx
80103063:	0f 8f 85 00 00 00    	jg     801030ee <log_write+0x9e>
80103069:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010306e:	83 e8 01             	sub    $0x1,%eax
80103071:	39 c2                	cmp    %eax,%edx
80103073:	7d 79                	jge    801030ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103075:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010307a:	85 c0                	test   %eax,%eax
8010307c:	7e 7d                	jle    801030fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010307e:	83 ec 0c             	sub    $0xc,%esp
80103081:	68 a0 26 11 80       	push   $0x801126a0
80103086:	e8 45 17 00 00       	call   801047d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010308b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	85 d2                	test   %edx,%edx
80103096:	7e 4a                	jle    801030e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103098:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010309b:	31 c0                	xor    %eax,%eax
8010309d:	eb 08                	jmp    801030a7 <log_write+0x57>
8010309f:	90                   	nop
801030a0:	83 c0 01             	add    $0x1,%eax
801030a3:	39 c2                	cmp    %eax,%edx
801030a5:	74 29                	je     801030d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030a7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
801030ae:	75 f0                	jne    801030a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030bd:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
801030c4:	c9                   	leave
  release(&log.lock);
801030c5:	e9 a6 16 00 00       	jmp    80104770 <release>
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
801030d7:	83 c2 01             	add    $0x1,%edx
801030da:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
801030e0:	eb d5                	jmp    801030b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801030e2:	8b 43 08             	mov    0x8(%ebx),%eax
801030e5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
801030ea:	75 cb                	jne    801030b7 <log_write+0x67>
801030ec:	eb e9                	jmp    801030d7 <log_write+0x87>
    panic("too big a transaction");
801030ee:	83 ec 0c             	sub    $0xc,%esp
801030f1:	68 6a 78 10 80       	push   $0x8010786a
801030f6:	e8 85 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801030fb:	83 ec 0c             	sub    $0xc,%esp
801030fe:	68 80 78 10 80       	push   $0x80107880
80103103:	e8 78 d2 ff ff       	call   80100380 <panic>
80103108:	66 90                	xchg   %ax,%ax
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103117:	e8 f4 09 00 00       	call   80103b10 <cpuid>
8010311c:	89 c3                	mov    %eax,%ebx
8010311e:	e8 ed 09 00 00       	call   80103b10 <cpuid>
80103123:	83 ec 04             	sub    $0x4,%esp
80103126:	53                   	push   %ebx
80103127:	50                   	push   %eax
80103128:	68 9b 78 10 80       	push   $0x8010789b
8010312d:	e8 6e d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103132:	e8 99 2c 00 00       	call   80105dd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103137:	e8 74 09 00 00       	call   80103ab0 <mycpu>
8010313c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010313e:	b8 01 00 00 00       	mov    $0x1,%eax
80103143:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010314a:	e8 a1 0c 00 00       	call   80103df0 <scheduler>
8010314f:	90                   	nop

80103150 <mpenter>:
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103156:	e8 65 3d 00 00       	call   80106ec0 <switchkvm>
  seginit();
8010315b:	e8 d0 3c 00 00       	call   80106e30 <seginit>
  lapicinit();
80103160:	e8 9b f7 ff ff       	call   80102900 <lapicinit>
  mpmain();
80103165:	e8 a6 ff ff ff       	call   80103110 <mpmain>
8010316a:	66 90                	xchg   %ax,%ax
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <main>:
{
80103170:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103174:	83 e4 f0             	and    $0xfffffff0,%esp
80103177:	ff 71 fc             	push   -0x4(%ecx)
8010317a:	55                   	push   %ebp
8010317b:	89 e5                	mov    %esp,%ebp
8010317d:	53                   	push   %ebx
8010317e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010317f:	83 ec 08             	sub    $0x8,%esp
80103182:	68 00 00 40 80       	push   $0x80400000
80103187:	68 50 66 11 80       	push   $0x80116650
8010318c:	e8 8f f5 ff ff       	call   80102720 <kinit1>
  kvmalloc();      // kernel page table
80103191:	e8 1a 42 00 00       	call   801073b0 <kvmalloc>
  mpinit();        // detect other processors
80103196:	e8 85 01 00 00       	call   80103320 <mpinit>
  lapicinit();     // interrupt controller
8010319b:	e8 60 f7 ff ff       	call   80102900 <lapicinit>
  seginit();       // segment descriptors
801031a0:	e8 8b 3c 00 00       	call   80106e30 <seginit>
  picinit();       // disable pic
801031a5:	e8 76 03 00 00       	call   80103520 <picinit>
  ioapicinit();    // another interrupt controller
801031aa:	e8 31 f3 ff ff       	call   801024e0 <ioapicinit>
  consoleinit();   // console hardware
801031af:	e8 ac d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801031b4:	e8 07 2f 00 00       	call   801060c0 <uartinit>
  pinit();         // process table
801031b9:	e8 d2 08 00 00       	call   80103a90 <pinit>
  tvinit();        // trap vectors
801031be:	e8 8d 2b 00 00       	call   80105d50 <tvinit>
  binit();         // buffer cache
801031c3:	e8 78 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031c8:	e8 53 dd ff ff       	call   80100f20 <fileinit>
  ideinit();       // disk 
801031cd:	e8 fe f0 ff ff       	call   801022d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031d2:	83 c4 0c             	add    $0xc,%esp
801031d5:	68 8a 00 00 00       	push   $0x8a
801031da:	68 8c b4 10 80       	push   $0x8010b48c
801031df:	68 00 70 00 80       	push   $0x80007000
801031e4:	e8 47 17 00 00       	call   80104930 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801031f3:	00 00 00 
801031f6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801031fb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103200:	76 7e                	jbe    80103280 <main+0x110>
80103202:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103207:	eb 20                	jmp    80103229 <main+0xb9>
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103210:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103217:	00 00 00 
8010321a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103220:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103225:	39 c3                	cmp    %eax,%ebx
80103227:	73 57                	jae    80103280 <main+0x110>
    if(c == mycpu())  // We've started already.
80103229:	e8 82 08 00 00       	call   80103ab0 <mycpu>
8010322e:	39 c3                	cmp    %eax,%ebx
80103230:	74 de                	je     80103210 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103232:	e8 59 f5 ff ff       	call   80102790 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103237:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010323a:	c7 05 f8 6f 00 80 50 	movl   $0x80103150,0x80006ff8
80103241:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103244:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010324b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010324e:	05 00 10 00 00       	add    $0x1000,%eax
80103253:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103258:	0f b6 03             	movzbl (%ebx),%eax
8010325b:	68 00 70 00 00       	push   $0x7000
80103260:	50                   	push   %eax
80103261:	e8 ea f7 ff ff       	call   80102a50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103266:	83 c4 10             	add    $0x10,%esp
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103270:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103276:	85 c0                	test   %eax,%eax
80103278:	74 f6                	je     80103270 <main+0x100>
8010327a:	eb 94                	jmp    80103210 <main+0xa0>
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103280:	83 ec 08             	sub    $0x8,%esp
80103283:	68 00 00 00 8e       	push   $0x8e000000
80103288:	68 00 00 40 80       	push   $0x80400000
8010328d:	e8 2e f4 ff ff       	call   801026c0 <kinit2>
  userinit();      // first user process
80103292:	e8 c9 08 00 00       	call   80103b60 <userinit>
  mpmain();        // finish this processor's setup
80103297:	e8 74 fe ff ff       	call   80103110 <mpmain>
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032ab:	53                   	push   %ebx
  e = addr+len;
801032ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032b2:	39 de                	cmp    %ebx,%esi
801032b4:	72 10                	jb     801032c6 <mpsearch1+0x26>
801032b6:	eb 50                	jmp    80103308 <mpsearch1+0x68>
801032b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032bf:	00 
801032c0:	89 fe                	mov    %edi,%esi
801032c2:	39 fb                	cmp    %edi,%ebx
801032c4:	76 42                	jbe    80103308 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032c6:	83 ec 04             	sub    $0x4,%esp
801032c9:	8d 7e 10             	lea    0x10(%esi),%edi
801032cc:	6a 04                	push   $0x4
801032ce:	68 af 78 10 80       	push   $0x801078af
801032d3:	56                   	push   %esi
801032d4:	e8 07 16 00 00       	call   801048e0 <memcmp>
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	85 c0                	test   %eax,%eax
801032de:	75 e0                	jne    801032c0 <mpsearch1+0x20>
801032e0:	89 f2                	mov    %esi,%edx
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801032eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801032ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032f0:	39 fa                	cmp    %edi,%edx
801032f2:	75 f4                	jne    801032e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032f4:	84 c0                	test   %al,%al
801032f6:	75 c8                	jne    801032c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032fb:	89 f0                	mov    %esi,%eax
801032fd:	5b                   	pop    %ebx
801032fe:	5e                   	pop    %esi
801032ff:	5f                   	pop    %edi
80103300:	5d                   	pop    %ebp
80103301:	c3                   	ret
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010330b:	31 f6                	xor    %esi,%esi
}
8010330d:	5b                   	pop    %ebx
8010330e:	89 f0                	mov    %esi,%eax
80103310:	5e                   	pop    %esi
80103311:	5f                   	pop    %edi
80103312:	5d                   	pop    %ebp
80103313:	c3                   	ret
80103314:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010331b:	00 
8010331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103320 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103329:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103330:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103337:	c1 e0 08             	shl    $0x8,%eax
8010333a:	09 d0                	or     %edx,%eax
8010333c:	c1 e0 04             	shl    $0x4,%eax
8010333f:	75 1b                	jne    8010335c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103341:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103348:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010334f:	c1 e0 08             	shl    $0x8,%eax
80103352:	09 d0                	or     %edx,%eax
80103354:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103357:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010335c:	ba 00 04 00 00       	mov    $0x400,%edx
80103361:	e8 3a ff ff ff       	call   801032a0 <mpsearch1>
80103366:	89 c3                	mov    %eax,%ebx
80103368:	85 c0                	test   %eax,%eax
8010336a:	0f 84 40 01 00 00    	je     801034b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103370:	8b 73 04             	mov    0x4(%ebx),%esi
80103373:	85 f6                	test   %esi,%esi
80103375:	0f 84 25 01 00 00    	je     801034a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010337b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010337e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103384:	6a 04                	push   $0x4
80103386:	68 b4 78 10 80       	push   $0x801078b4
8010338b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010338c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010338f:	e8 4c 15 00 00       	call   801048e0 <memcmp>
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 c0                	test   %eax,%eax
80103399:	0f 85 01 01 00 00    	jne    801034a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010339f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033a6:	3c 01                	cmp    $0x1,%al
801033a8:	74 08                	je     801033b2 <mpinit+0x92>
801033aa:	3c 04                	cmp    $0x4,%al
801033ac:	0f 85 ee 00 00 00    	jne    801034a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801033b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033b9:	66 85 d2             	test   %dx,%dx
801033bc:	74 22                	je     801033e0 <mpinit+0xc0>
801033be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033c3:	31 d2                	xor    %edx,%edx
801033c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033d4:	39 c7                	cmp    %eax,%edi
801033d6:	75 f0                	jne    801033c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033d8:	84 d2                	test   %dl,%dl
801033da:	0f 85 c0 00 00 00    	jne    801034a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801033e6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801033f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103400:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103403:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103408:	39 d0                	cmp    %edx,%eax
8010340a:	73 15                	jae    80103421 <mpinit+0x101>
    switch(*p){
8010340c:	0f b6 08             	movzbl (%eax),%ecx
8010340f:	80 f9 02             	cmp    $0x2,%cl
80103412:	74 4c                	je     80103460 <mpinit+0x140>
80103414:	77 3a                	ja     80103450 <mpinit+0x130>
80103416:	84 c9                	test   %cl,%cl
80103418:	74 56                	je     80103470 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010341a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010341d:	39 d0                	cmp    %edx,%eax
8010341f:	72 eb                	jb     8010340c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103421:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103424:	85 f6                	test   %esi,%esi
80103426:	0f 84 d9 00 00 00    	je     80103505 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010342c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103430:	74 15                	je     80103447 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103432:	b8 70 00 00 00       	mov    $0x70,%eax
80103437:	ba 22 00 00 00       	mov    $0x22,%edx
8010343c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010343d:	ba 23 00 00 00       	mov    $0x23,%edx
80103442:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103443:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103446:	ee                   	out    %al,(%dx)
  }
}
80103447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010344a:	5b                   	pop    %ebx
8010344b:	5e                   	pop    %esi
8010344c:	5f                   	pop    %edi
8010344d:	5d                   	pop    %ebp
8010344e:	c3                   	ret
8010344f:	90                   	nop
    switch(*p){
80103450:	83 e9 03             	sub    $0x3,%ecx
80103453:	80 f9 01             	cmp    $0x1,%cl
80103456:	76 c2                	jbe    8010341a <mpinit+0xfa>
80103458:	31 f6                	xor    %esi,%esi
8010345a:	eb ac                	jmp    80103408 <mpinit+0xe8>
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103460:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103464:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103467:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010346d:	eb 99                	jmp    80103408 <mpinit+0xe8>
8010346f:	90                   	nop
      if(ncpu < NCPU) {
80103470:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103494:	83 c0 14             	add    $0x14,%eax
      continue;
80103497:	e9 6c ff ff ff       	jmp    80103408 <mpinit+0xe8>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	68 b9 78 10 80       	push   $0x801078b9
801034a8:	e8 d3 ce ff ff       	call   80100380 <panic>
801034ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801034b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034b5:	eb 13                	jmp    801034ca <mpinit+0x1aa>
801034b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034be:	00 
801034bf:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801034c0:	89 f3                	mov    %esi,%ebx
801034c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034c8:	74 d6                	je     801034a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ca:	83 ec 04             	sub    $0x4,%esp
801034cd:	8d 73 10             	lea    0x10(%ebx),%esi
801034d0:	6a 04                	push   $0x4
801034d2:	68 af 78 10 80       	push   $0x801078af
801034d7:	53                   	push   %ebx
801034d8:	e8 03 14 00 00       	call   801048e0 <memcmp>
801034dd:	83 c4 10             	add    $0x10,%esp
801034e0:	85 c0                	test   %eax,%eax
801034e2:	75 dc                	jne    801034c0 <mpinit+0x1a0>
801034e4:	89 da                	mov    %ebx,%edx
801034e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034ed:	00 
801034ee:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801034f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034f8:	39 d6                	cmp    %edx,%esi
801034fa:	75 f4                	jne    801034f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034fc:	84 c0                	test   %al,%al
801034fe:	75 c0                	jne    801034c0 <mpinit+0x1a0>
80103500:	e9 6b fe ff ff       	jmp    80103370 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103505:	83 ec 0c             	sub    $0xc,%esp
80103508:	68 3c 7c 10 80       	push   $0x80107c3c
8010350d:	e8 6e ce ff ff       	call   80100380 <panic>
80103512:	66 90                	xchg   %ax,%ax
80103514:	66 90                	xchg   %ax,%ax
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <picinit>:
80103520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103525:	ba 21 00 00 00       	mov    $0x21,%edx
8010352a:	ee                   	out    %al,(%dx)
8010352b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103530:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103531:	c3                   	ret
80103532:	66 90                	xchg   %ax,%ax
80103534:	66 90                	xchg   %ax,%ax
80103536:	66 90                	xchg   %ax,%ax
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010354c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010354f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103555:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010355b:	e8 e0 d9 ff ff       	call   80100f40 <filealloc>
80103560:	89 03                	mov    %eax,(%ebx)
80103562:	85 c0                	test   %eax,%eax
80103564:	0f 84 a8 00 00 00    	je     80103612 <pipealloc+0xd2>
8010356a:	e8 d1 d9 ff ff       	call   80100f40 <filealloc>
8010356f:	89 06                	mov    %eax,(%esi)
80103571:	85 c0                	test   %eax,%eax
80103573:	0f 84 87 00 00 00    	je     80103600 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103579:	e8 12 f2 ff ff       	call   80102790 <kalloc>
8010357e:	89 c7                	mov    %eax,%edi
80103580:	85 c0                	test   %eax,%eax
80103582:	0f 84 b0 00 00 00    	je     80103638 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103588:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010358f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103592:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103595:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010359c:	00 00 00 
  p->nwrite = 0;
8010359f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035a6:	00 00 00 
  p->nread = 0;
801035a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035b0:	00 00 00 
  initlock(&p->lock, "pipe");
801035b3:	68 d1 78 10 80       	push   $0x801078d1
801035b8:	50                   	push   %eax
801035b9:	e8 42 10 00 00       	call   80104600 <initlock>
  (*f0)->type = FD_PIPE;
801035be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035c9:	8b 03                	mov    (%ebx),%eax
801035cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035cf:	8b 03                	mov    (%ebx),%eax
801035d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035d5:	8b 03                	mov    (%ebx),%eax
801035d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035da:	8b 06                	mov    (%esi),%eax
801035dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035e2:	8b 06                	mov    (%esi),%eax
801035e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035e8:	8b 06                	mov    (%esi),%eax
801035ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035ee:	8b 06                	mov    (%esi),%eax
801035f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035f6:	31 c0                	xor    %eax,%eax
}
801035f8:	5b                   	pop    %ebx
801035f9:	5e                   	pop    %esi
801035fa:	5f                   	pop    %edi
801035fb:	5d                   	pop    %ebp
801035fc:	c3                   	ret
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103600:	8b 03                	mov    (%ebx),%eax
80103602:	85 c0                	test   %eax,%eax
80103604:	74 1e                	je     80103624 <pipealloc+0xe4>
    fileclose(*f0);
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	50                   	push   %eax
8010360a:	e8 f1 d9 ff ff       	call   80101000 <fileclose>
8010360f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103612:	8b 06                	mov    (%esi),%eax
80103614:	85 c0                	test   %eax,%eax
80103616:	74 0c                	je     80103624 <pipealloc+0xe4>
    fileclose(*f1);
80103618:	83 ec 0c             	sub    $0xc,%esp
8010361b:	50                   	push   %eax
8010361c:	e8 df d9 ff ff       	call   80101000 <fileclose>
80103621:	83 c4 10             	add    $0x10,%esp
}
80103624:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103638:	8b 03                	mov    (%ebx),%eax
8010363a:	85 c0                	test   %eax,%eax
8010363c:	75 c8                	jne    80103606 <pipealloc+0xc6>
8010363e:	eb d2                	jmp    80103612 <pipealloc+0xd2>

80103640 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103648:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	53                   	push   %ebx
8010364f:	e8 7c 11 00 00       	call   801047d0 <acquire>
  if(writable){
80103654:	83 c4 10             	add    $0x10,%esp
80103657:	85 f6                	test   %esi,%esi
80103659:	74 65                	je     801036c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103664:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010366b:	00 00 00 
    wakeup(&p->nread);
8010366e:	50                   	push   %eax
8010366f:	e8 bc 0c 00 00       	call   80104330 <wakeup>
80103674:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103677:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010367d:	85 d2                	test   %edx,%edx
8010367f:	75 0a                	jne    8010368b <pipeclose+0x4b>
80103681:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103687:	85 c0                	test   %eax,%eax
80103689:	74 15                	je     801036a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010368b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010368e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103691:	5b                   	pop    %ebx
80103692:	5e                   	pop    %esi
80103693:	5d                   	pop    %ebp
    release(&p->lock);
80103694:	e9 d7 10 00 00       	jmp    80104770 <release>
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	53                   	push   %ebx
801036a4:	e8 c7 10 00 00       	call   80104770 <release>
    kfree((char*)p);
801036a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ac:	83 c4 10             	add    $0x10,%esp
}
801036af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b2:	5b                   	pop    %ebx
801036b3:	5e                   	pop    %esi
801036b4:	5d                   	pop    %ebp
    kfree((char*)p);
801036b5:	e9 16 ef ff ff       	jmp    801025d0 <kfree>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036d0:	00 00 00 
    wakeup(&p->nwrite);
801036d3:	50                   	push   %eax
801036d4:	e8 57 0c 00 00       	call   80104330 <wakeup>
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	eb 99                	jmp    80103677 <pipeclose+0x37>
801036de:	66 90                	xchg   %ax,%ax

801036e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 28             	sub    $0x28,%esp
801036e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036ec:	53                   	push   %ebx
801036ed:	e8 de 10 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++){
801036f2:	8b 45 10             	mov    0x10(%ebp),%eax
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 8e c0 00 00 00    	jle    801037c0 <pipewrite+0xe0>
80103700:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103703:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103709:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010370f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103712:	03 45 10             	add    0x10(%ebp),%eax
80103715:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103718:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103724:	89 ca                	mov    %ecx,%edx
80103726:	05 00 02 00 00       	add    $0x200,%eax
8010372b:	39 c1                	cmp    %eax,%ecx
8010372d:	74 3f                	je     8010376e <pipewrite+0x8e>
8010372f:	eb 67                	jmp    80103798 <pipewrite+0xb8>
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103738:	e8 f3 03 00 00       	call   80103b30 <myproc>
8010373d:	8b 48 24             	mov    0x24(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	75 34                	jne    80103778 <pipewrite+0x98>
      wakeup(&p->nread);
80103744:	83 ec 0c             	sub    $0xc,%esp
80103747:	57                   	push   %edi
80103748:	e8 e3 0b 00 00       	call   80104330 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010374d:	58                   	pop    %eax
8010374e:	5a                   	pop    %edx
8010374f:	53                   	push   %ebx
80103750:	56                   	push   %esi
80103751:	e8 1a 0b 00 00       	call   80104270 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103756:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010375c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103762:	83 c4 10             	add    $0x10,%esp
80103765:	05 00 02 00 00       	add    $0x200,%eax
8010376a:	39 c2                	cmp    %eax,%edx
8010376c:	75 2a                	jne    80103798 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010376e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103774:	85 c0                	test   %eax,%eax
80103776:	75 c0                	jne    80103738 <pipewrite+0x58>
        release(&p->lock);
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	53                   	push   %ebx
8010377c:	e8 ef 0f 00 00       	call   80104770 <release>
        return -1;
80103781:	83 c4 10             	add    $0x10,%esp
80103784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103798:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010379b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010379e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037ad:	83 c6 01             	add    $0x1,%esi
801037b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037ba:	0f 85 58 ff ff ff    	jne    80103718 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037c9:	50                   	push   %eax
801037ca:	e8 61 0b 00 00       	call   80104330 <wakeup>
  release(&p->lock);
801037cf:	89 1c 24             	mov    %ebx,(%esp)
801037d2:	e8 99 0f 00 00       	call   80104770 <release>
  return n;
801037d7:	8b 45 10             	mov    0x10(%ebp),%eax
801037da:	83 c4 10             	add    $0x10,%esp
801037dd:	eb aa                	jmp    80103789 <pipewrite+0xa9>
801037df:	90                   	nop

801037e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 18             	sub    $0x18,%esp
801037e9:	8b 75 08             	mov    0x8(%ebp),%esi
801037ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037ef:	56                   	push   %esi
801037f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037f6:	e8 d5 0f 00 00       	call   801047d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103801:	83 c4 10             	add    $0x10,%esp
80103804:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010380a:	74 2f                	je     8010383b <piperead+0x5b>
8010380c:	eb 37                	jmp    80103845 <piperead+0x65>
8010380e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103810:	e8 1b 03 00 00       	call   80103b30 <myproc>
80103815:	8b 48 24             	mov    0x24(%eax),%ecx
80103818:	85 c9                	test   %ecx,%ecx
8010381a:	0f 85 80 00 00 00    	jne    801038a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	e8 46 0a 00 00       	call   80104270 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010382a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103839:	75 0a                	jne    80103845 <piperead+0x65>
8010383b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103841:	85 c0                	test   %eax,%eax
80103843:	75 cb                	jne    80103810 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103845:	8b 55 10             	mov    0x10(%ebp),%edx
80103848:	31 db                	xor    %ebx,%ebx
8010384a:	85 d2                	test   %edx,%edx
8010384c:	7f 20                	jg     8010386e <piperead+0x8e>
8010384e:	eb 2c                	jmp    8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103850:	8d 48 01             	lea    0x1(%eax),%ecx
80103853:	25 ff 01 00 00       	and    $0x1ff,%eax
80103858:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010385e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103863:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103866:	83 c3 01             	add    $0x1,%ebx
80103869:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010386c:	74 0e                	je     8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010386e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103874:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010387a:	75 d4                	jne    80103850 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010387c:	83 ec 0c             	sub    $0xc,%esp
8010387f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103885:	50                   	push   %eax
80103886:	e8 a5 0a 00 00       	call   80104330 <wakeup>
  release(&p->lock);
8010388b:	89 34 24             	mov    %esi,(%esp)
8010388e:	e8 dd 0e 00 00       	call   80104770 <release>
  return i;
80103893:	83 c4 10             	add    $0x10,%esp
}
80103896:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103899:	89 d8                	mov    %ebx,%eax
8010389b:	5b                   	pop    %ebx
8010389c:	5e                   	pop    %esi
8010389d:	5f                   	pop    %edi
8010389e:	5d                   	pop    %ebp
8010389f:	c3                   	ret
      release(&p->lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038a8:	56                   	push   %esi
801038a9:	e8 c2 0e 00 00       	call   80104770 <release>
      return -1;
801038ae:	83 c4 10             	add    $0x10,%esp
}
801038b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b4:	89 d8                	mov    %ebx,%eax
801038b6:	5b                   	pop    %ebx
801038b7:	5e                   	pop    %esi
801038b8:	5f                   	pop    %edi
801038b9:	5d                   	pop    %ebp
801038ba:	c3                   	ret
801038bb:	66 90                	xchg   %ax,%ax
801038bd:	66 90                	xchg   %ax,%ax
801038bf:	90                   	nop

801038c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c5:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	68 20 2d 11 80       	push   $0x80112d20
801038d2:	e8 f9 0e 00 00       	call   801047d0 <acquire>
801038d7:	83 c4 10             	add    $0x10,%esp
801038da:	eb 13                	jmp    801038ef <allocproc+0x2f>
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	83 c3 7c             	add    $0x7c,%ebx
801038e3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801038e9:	0f 84 21 01 00 00    	je     80103a10 <allocproc+0x150>
    if(p->state == UNUSED)
801038ef:	8b 43 0c             	mov    0xc(%ebx),%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	75 ea                	jne    801038e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038f6:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801038fb:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038fe:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103905:	89 43 10             	mov    %eax,0x10(%ebx)
80103908:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010390b:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103910:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103916:	e8 55 0e 00 00       	call   80104770 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010391b:	e8 70 ee ff ff       	call   80102790 <kalloc>
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	89 43 08             	mov    %eax,0x8(%ebx)
80103926:	85 c0                	test   %eax,%eax
80103928:	0f 84 fd 00 00 00    	je     80103a2b <allocproc+0x16b>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010392e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103934:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103937:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010393c:	89 53 18             	mov    %edx,0x18(%ebx)
  p->context->eip = (uint)forkret;

  // Make sure process name is set before adding to history
  safestrcpy(p->name, "unknown", sizeof(p->name));  // Default name
8010393f:	8d 73 6c             	lea    0x6c(%ebx),%esi
  *(uint*)sp = (uint)trapret;
80103942:	c7 40 14 3f 5d 10 80 	movl   $0x80105d3f,0x14(%eax)
  p->context = (struct context*)sp;
80103949:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010394c:	6a 14                	push   $0x14
8010394e:	6a 00                	push   $0x0
80103950:	50                   	push   %eax
80103951:	e8 3a 0f 00 00       	call   80104890 <memset>
  p->context->eip = (uint)forkret;
80103956:	8b 43 1c             	mov    0x1c(%ebx),%eax
  safestrcpy(p->name, "unknown", sizeof(p->name));  // Default name
80103959:	83 c4 0c             	add    $0xc,%esp
  p->context->eip = (uint)forkret;
8010395c:	c7 40 10 40 3a 10 80 	movl   $0x80103a40,0x10(%eax)
  safestrcpy(p->name, "unknown", sizeof(p->name));  // Default name
80103963:	6a 10                	push   $0x10
80103965:	68 d6 78 10 80       	push   $0x801078d6
8010396a:	56                   	push   %esi
8010396b:	e8 e0 10 00 00       	call   80104a50 <safestrcpy>

  // Add process to history (Circular Buffer)
  acquire(&ptable.lock);
80103970:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103977:	e8 54 0e 00 00       	call   801047d0 <acquire>
  process_history[history_index].pid = p->pid;
8010397c:	a1 54 4c 11 80       	mov    0x80114c54,%eax
80103981:	8b 53 10             	mov    0x10(%ebx),%edx
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
80103984:	83 c4 0c             	add    $0xc,%esp
80103987:	6a 10                	push   $0x10
  process_history[history_index].pid = p->pid;
80103989:	8d 04 40             	lea    (%eax,%eax,2),%eax
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
8010398c:	56                   	push   %esi
  process_history[history_index].pid = p->pid;
8010398d:	c1 e0 03             	shl    $0x3,%eax
80103990:	89 90 60 4c 11 80    	mov    %edx,-0x7feeb3a0(%eax)
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
80103996:	05 64 4c 11 80       	add    $0x80114c64,%eax
8010399b:	50                   	push   %eax
8010399c:	e8 af 10 00 00       	call   80104a50 <safestrcpy>
  process_history[history_index].mem_usage = p->sz;
801039a1:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
801039a7:	8b 13                	mov    (%ebx),%edx

  // Update history index (Circular Buffer)
  history_index = (history_index + 1) % MAX_HISTORY;
  if (history_count < MAX_HISTORY) {
801039a9:	83 c4 10             	add    $0x10,%esp
  process_history[history_index].mem_usage = p->sz;
801039ac:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  history_index = (history_index + 1) % MAX_HISTORY;
801039af:	83 c1 01             	add    $0x1,%ecx
  process_history[history_index].mem_usage = p->sz;
801039b2:	89 14 c5 74 4c 11 80 	mov    %edx,-0x7feeb38c(,%eax,8)
  history_index = (history_index + 1) % MAX_HISTORY;
801039b9:	89 c8                	mov    %ecx,%eax
801039bb:	ba 67 66 66 66       	mov    $0x66666667,%edx
801039c0:	f7 ea                	imul   %edx
801039c2:	89 c8                	mov    %ecx,%eax
801039c4:	c1 f8 1f             	sar    $0x1f,%eax
801039c7:	c1 fa 02             	sar    $0x2,%edx
801039ca:	29 c2                	sub    %eax,%edx
801039cc:	8d 04 92             	lea    (%edx,%edx,4),%eax
801039cf:	01 c0                	add    %eax,%eax
801039d1:	29 c1                	sub    %eax,%ecx
  if (history_count < MAX_HISTORY) {
801039d3:	a1 58 4c 11 80       	mov    0x80114c58,%eax
  history_index = (history_index + 1) % MAX_HISTORY;
801039d8:	89 0d 54 4c 11 80    	mov    %ecx,0x80114c54
  if (history_count < MAX_HISTORY) {
801039de:	83 f8 09             	cmp    $0x9,%eax
801039e1:	7e 1d                	jle    80103a00 <allocproc+0x140>
      history_count++;  // Keep track of number of stored records
  }
  release(&ptable.lock);
801039e3:	83 ec 0c             	sub    $0xc,%esp
801039e6:	68 20 2d 11 80       	push   $0x80112d20
801039eb:	e8 80 0d 00 00       	call   80104770 <release>

  return p;
801039f0:	83 c4 10             	add    $0x10,%esp
}
801039f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039f6:	89 d8                	mov    %ebx,%eax
801039f8:	5b                   	pop    %ebx
801039f9:	5e                   	pop    %esi
801039fa:	5d                   	pop    %ebp
801039fb:	c3                   	ret
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      history_count++;  // Keep track of number of stored records
80103a00:	83 c0 01             	add    $0x1,%eax
80103a03:	a3 58 4c 11 80       	mov    %eax,0x80114c58
80103a08:	eb d9                	jmp    801039e3 <allocproc+0x123>
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a15:	68 20 2d 11 80       	push   $0x80112d20
80103a1a:	e8 51 0d 00 00       	call   80104770 <release>
  return 0;
80103a1f:	83 c4 10             	add    $0x10,%esp
}
80103a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a25:	89 d8                	mov    %ebx,%eax
80103a27:	5b                   	pop    %ebx
80103a28:	5e                   	pop    %esi
80103a29:	5d                   	pop    %ebp
80103a2a:	c3                   	ret
    p->state = UNUSED;
80103a2b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80103a35:	31 db                	xor    %ebx,%ebx
}
80103a37:	89 d8                	mov    %ebx,%eax
80103a39:	5b                   	pop    %ebx
80103a3a:	5e                   	pop    %esi
80103a3b:	5d                   	pop    %ebp
80103a3c:	c3                   	ret
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi

80103a40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a46:	68 20 2d 11 80       	push   $0x80112d20
80103a4b:	e8 20 0d 00 00       	call   80104770 <release>

  if (first) {
80103a50:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	85 c0                	test   %eax,%eax
80103a5a:	75 04                	jne    80103a60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a5c:	c9                   	leave
80103a5d:	c3                   	ret
80103a5e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a60:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a67:	00 00 00 
    iinit(ROOTDEV);
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	6a 01                	push   $0x1
80103a6f:	e8 fc db ff ff       	call   80101670 <iinit>
    initlog(ROOTDEV);
80103a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a7b:	e8 50 f3 ff ff       	call   80102dd0 <initlog>
}
80103a80:	83 c4 10             	add    $0x10,%esp
80103a83:	c9                   	leave
80103a84:	c3                   	ret
80103a85:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a8c:	00 
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi

80103a90 <pinit>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a96:	68 de 78 10 80       	push   $0x801078de
80103a9b:	68 20 2d 11 80       	push   $0x80112d20
80103aa0:	e8 5b 0b 00 00       	call   80104600 <initlock>
}
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	c9                   	leave
80103aa9:	c3                   	ret
80103aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ab0 <mycpu>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ab5:	9c                   	pushf
80103ab6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ab7:	f6 c4 02             	test   $0x2,%ah
80103aba:	75 46                	jne    80103b02 <mycpu+0x52>
  apicid = lapicid();
80103abc:	e8 3f ef ff ff       	call   80102a00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ac1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103ac7:	85 f6                	test   %esi,%esi
80103ac9:	7e 2a                	jle    80103af5 <mycpu+0x45>
80103acb:	31 d2                	xor    %edx,%edx
80103acd:	eb 08                	jmp    80103ad7 <mycpu+0x27>
80103acf:	90                   	nop
80103ad0:	83 c2 01             	add    $0x1,%edx
80103ad3:	39 f2                	cmp    %esi,%edx
80103ad5:	74 1e                	je     80103af5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ad7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103add:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103ae4:	39 c3                	cmp    %eax,%ebx
80103ae6:	75 e8                	jne    80103ad0 <mycpu+0x20>
}
80103ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103aeb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103af1:	5b                   	pop    %ebx
80103af2:	5e                   	pop    %esi
80103af3:	5d                   	pop    %ebp
80103af4:	c3                   	ret
  panic("unknown apicid\n");
80103af5:	83 ec 0c             	sub    $0xc,%esp
80103af8:	68 e5 78 10 80       	push   $0x801078e5
80103afd:	e8 7e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b02:	83 ec 0c             	sub    $0xc,%esp
80103b05:	68 5c 7c 10 80       	push   $0x80107c5c
80103b0a:	e8 71 c8 ff ff       	call   80100380 <panic>
80103b0f:	90                   	nop

80103b10 <cpuid>:
cpuid() {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b16:	e8 95 ff ff ff       	call   80103ab0 <mycpu>
}
80103b1b:	c9                   	leave
  return mycpu()-cpus;
80103b1c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103b21:	c1 f8 04             	sar    $0x4,%eax
80103b24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b2a:	c3                   	ret
80103b2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b30 <myproc>:
myproc(void) {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	53                   	push   %ebx
80103b34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b37:	e8 44 0b 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103b3c:	e8 6f ff ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103b41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b47:	e8 84 0b 00 00       	call   801046d0 <popcli>
}
80103b4c:	89 d8                	mov    %ebx,%eax
80103b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b51:	c9                   	leave
80103b52:	c3                   	ret
80103b53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b5a:	00 
80103b5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b60 <userinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b67:	e8 54 fd ff ff       	call   801038c0 <allocproc>
80103b6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b6e:	a3 50 4d 11 80       	mov    %eax,0x80114d50
  if((p->pgdir = setupkvm()) == 0)
80103b73:	e8 b8 37 00 00       	call   80107330 <setupkvm>
80103b78:	89 43 04             	mov    %eax,0x4(%ebx)
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	0f 84 bd 00 00 00    	je     80103c40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b83:	83 ec 04             	sub    $0x4,%esp
80103b86:	68 2c 00 00 00       	push   $0x2c
80103b8b:	68 60 b4 10 80       	push   $0x8010b460
80103b90:	50                   	push   %eax
80103b91:	e8 4a 34 00 00       	call   80106fe0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b9f:	6a 4c                	push   $0x4c
80103ba1:	6a 00                	push   $0x0
80103ba3:	ff 73 18             	push   0x18(%ebx)
80103ba6:	e8 e5 0c 00 00       	call   80104890 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	8b 43 18             	mov    0x18(%ebx),%eax
80103bae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bb3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bb6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bdc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103be6:	8b 43 18             	mov    0x18(%ebx),%eax
80103be9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bf0:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	68 0e 79 10 80       	push   $0x8010790e
80103c04:	50                   	push   %eax
80103c05:	e8 46 0e 00 00       	call   80104a50 <safestrcpy>
  p->cwd = namei("/");
80103c0a:	c7 04 24 17 79 10 80 	movl   $0x80107917,(%esp)
80103c11:	e8 9a e5 ff ff       	call   801021b0 <namei>
80103c16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c19:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c20:	e8 ab 0b 00 00       	call   801047d0 <acquire>
  p->state = RUNNABLE;
80103c25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c33:	e8 38 0b 00 00       	call   80104770 <release>
}
80103c38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c3b:	83 c4 10             	add    $0x10,%esp
80103c3e:	c9                   	leave
80103c3f:	c3                   	ret
    panic("userinit: out of memory?");
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	68 f5 78 10 80       	push   $0x801078f5
80103c48:	e8 33 c7 ff ff       	call   80100380 <panic>
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi

80103c50 <growproc>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
80103c55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c58:	e8 23 0a 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103c5d:	e8 4e fe ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103c62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c68:	e8 63 0a 00 00       	call   801046d0 <popcli>
  sz = curproc->sz;
80103c6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c6f:	85 f6                	test   %esi,%esi
80103c71:	7f 1d                	jg     80103c90 <growproc+0x40>
  } else if(n < 0){
80103c73:	75 3b                	jne    80103cb0 <growproc+0x60>
  switchuvm(curproc);
80103c75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c7a:	53                   	push   %ebx
80103c7b:	e8 50 32 00 00       	call   80106ed0 <switchuvm>
  return 0;
80103c80:	83 c4 10             	add    $0x10,%esp
80103c83:	31 c0                	xor    %eax,%eax
}
80103c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c88:	5b                   	pop    %ebx
80103c89:	5e                   	pop    %esi
80103c8a:	5d                   	pop    %ebp
80103c8b:	c3                   	ret
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 04             	push   0x4(%ebx)
80103c9a:	e8 b1 34 00 00       	call   80107150 <allocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 cf                	jne    80103c75 <growproc+0x25>
      return -1;
80103ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cab:	eb d8                	jmp    80103c85 <growproc+0x35>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 04             	push   0x4(%ebx)
80103cba:	e8 c1 35 00 00       	call   80107280 <deallocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 af                	jne    80103c75 <growproc+0x25>
80103cc6:	eb de                	jmp    80103ca6 <growproc+0x56>
80103cc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ccf:	00 

80103cd0 <fork>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cd9:	e8 a2 09 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103cde:	e8 cd fd ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103ce3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce9:	e8 e2 09 00 00       	call   801046d0 <popcli>
  if((np = allocproc()) == 0){
80103cee:	e8 cd fb ff ff       	call   801038c0 <allocproc>
80103cf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cf6:	85 c0                	test   %eax,%eax
80103cf8:	0f 84 b7 00 00 00    	je     80103db5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cfe:	83 ec 08             	sub    $0x8,%esp
80103d01:	ff 33                	push   (%ebx)
80103d03:	89 c7                	mov    %eax,%edi
80103d05:	ff 73 04             	push   0x4(%ebx)
80103d08:	e8 13 37 00 00       	call   80107420 <copyuvm>
80103d0d:	83 c4 10             	add    $0x10,%esp
80103d10:	89 47 04             	mov    %eax,0x4(%edi)
80103d13:	85 c0                	test   %eax,%eax
80103d15:	0f 84 a1 00 00 00    	je     80103dbc <fork+0xec>
  np->sz = curproc->sz;
80103d1b:	8b 03                	mov    (%ebx),%eax
80103d1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d25:	89 c8                	mov    %ecx,%eax
80103d27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d2f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d36:	8b 40 18             	mov    0x18(%eax),%eax
80103d39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d44:	85 c0                	test   %eax,%eax
80103d46:	74 13                	je     80103d5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	50                   	push   %eax
80103d4c:	e8 5f d2 ff ff       	call   80100fb0 <filedup>
80103d51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d54:	83 c4 10             	add    $0x10,%esp
80103d57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d5b:	83 c6 01             	add    $0x1,%esi
80103d5e:	83 fe 10             	cmp    $0x10,%esi
80103d61:	75 dd                	jne    80103d40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d63:	83 ec 0c             	sub    $0xc,%esp
80103d66:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d6c:	e8 ef da ff ff       	call   80101860 <idup>
80103d71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d7d:	6a 10                	push   $0x10
80103d7f:	53                   	push   %ebx
80103d80:	50                   	push   %eax
80103d81:	e8 ca 0c 00 00       	call   80104a50 <safestrcpy>
  pid = np->pid;
80103d86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d90:	e8 3b 0a 00 00       	call   801047d0 <acquire>
  np->state = RUNNABLE;
80103d95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d9c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103da3:	e8 c8 09 00 00       	call   80104770 <release>
  return pid;
80103da8:	83 c4 10             	add    $0x10,%esp
}
80103dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dae:	89 d8                	mov    %ebx,%eax
80103db0:	5b                   	pop    %ebx
80103db1:	5e                   	pop    %esi
80103db2:	5f                   	pop    %edi
80103db3:	5d                   	pop    %ebp
80103db4:	c3                   	ret
    return -1;
80103db5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dba:	eb ef                	jmp    80103dab <fork+0xdb>
    kfree(np->kstack);
80103dbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103dbf:	83 ec 0c             	sub    $0xc,%esp
80103dc2:	ff 73 08             	push   0x8(%ebx)
80103dc5:	e8 06 e8 ff ff       	call   801025d0 <kfree>
    np->kstack = 0;
80103dca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103dd1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103dd4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ddb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103de0:	eb c9                	jmp    80103dab <fork+0xdb>
80103de2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103de9:	00 
80103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103df0 <scheduler>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103df9:	e8 b2 fc ff ff       	call   80103ab0 <mycpu>
  c->proc = 0;
80103dfe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e05:	00 00 00 
  struct cpu *c = mycpu();
80103e08:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e0a:	8d 78 04             	lea    0x4(%eax),%edi
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e10:	fb                   	sti
    acquire(&ptable.lock);
80103e11:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e14:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103e19:	68 20 2d 11 80       	push   $0x80112d20
80103e1e:	e8 ad 09 00 00       	call   801047d0 <acquire>
80103e23:	83 c4 10             	add    $0x10,%esp
80103e26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e2d:	00 
80103e2e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103e30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e34:	75 33                	jne    80103e69 <scheduler+0x79>
      switchuvm(p);
80103e36:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e3f:	53                   	push   %ebx
80103e40:	e8 8b 30 00 00       	call   80106ed0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e45:	58                   	pop    %eax
80103e46:	5a                   	pop    %edx
80103e47:	ff 73 1c             	push   0x1c(%ebx)
80103e4a:	57                   	push   %edi
      p->state = RUNNING;
80103e4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e52:	e8 54 0c 00 00       	call   80104aab <swtch>
      switchkvm();
80103e57:	e8 64 30 00 00       	call   80106ec0 <switchkvm>
      c->proc = 0;
80103e5c:	83 c4 10             	add    $0x10,%esp
80103e5f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e66:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e69:	83 c3 7c             	add    $0x7c,%ebx
80103e6c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103e72:	75 bc                	jne    80103e30 <scheduler+0x40>
    release(&ptable.lock);
80103e74:	83 ec 0c             	sub    $0xc,%esp
80103e77:	68 20 2d 11 80       	push   $0x80112d20
80103e7c:	e8 ef 08 00 00       	call   80104770 <release>
    sti();
80103e81:	83 c4 10             	add    $0x10,%esp
80103e84:	eb 8a                	jmp    80103e10 <scheduler+0x20>
80103e86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e8d:	00 
80103e8e:	66 90                	xchg   %ax,%ax

80103e90 <sched>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	56                   	push   %esi
80103e94:	53                   	push   %ebx
  pushcli();
80103e95:	e8 e6 07 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103e9a:	e8 11 fc ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103e9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ea5:	e8 26 08 00 00       	call   801046d0 <popcli>
  if(!holding(&ptable.lock))
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 20 2d 11 80       	push   $0x80112d20
80103eb2:	e8 79 08 00 00       	call   80104730 <holding>
80103eb7:	83 c4 10             	add    $0x10,%esp
80103eba:	85 c0                	test   %eax,%eax
80103ebc:	74 4f                	je     80103f0d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ebe:	e8 ed fb ff ff       	call   80103ab0 <mycpu>
80103ec3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eca:	75 68                	jne    80103f34 <sched+0xa4>
  if(p->state == RUNNING)
80103ecc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ed0:	74 55                	je     80103f27 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ed2:	9c                   	pushf
80103ed3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ed4:	f6 c4 02             	test   $0x2,%ah
80103ed7:	75 41                	jne    80103f1a <sched+0x8a>
  intena = mycpu()->intena;
80103ed9:	e8 d2 fb ff ff       	call   80103ab0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ede:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ee1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ee7:	e8 c4 fb ff ff       	call   80103ab0 <mycpu>
80103eec:	83 ec 08             	sub    $0x8,%esp
80103eef:	ff 70 04             	push   0x4(%eax)
80103ef2:	53                   	push   %ebx
80103ef3:	e8 b3 0b 00 00       	call   80104aab <swtch>
  mycpu()->intena = intena;
80103ef8:	e8 b3 fb ff ff       	call   80103ab0 <mycpu>
}
80103efd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f09:	5b                   	pop    %ebx
80103f0a:	5e                   	pop    %esi
80103f0b:	5d                   	pop    %ebp
80103f0c:	c3                   	ret
    panic("sched ptable.lock");
80103f0d:	83 ec 0c             	sub    $0xc,%esp
80103f10:	68 19 79 10 80       	push   $0x80107919
80103f15:	e8 66 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f1a:	83 ec 0c             	sub    $0xc,%esp
80103f1d:	68 45 79 10 80       	push   $0x80107945
80103f22:	e8 59 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f27:	83 ec 0c             	sub    $0xc,%esp
80103f2a:	68 37 79 10 80       	push   $0x80107937
80103f2f:	e8 4c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f34:	83 ec 0c             	sub    $0xc,%esp
80103f37:	68 2b 79 10 80       	push   $0x8010792b
80103f3c:	e8 3f c4 ff ff       	call   80100380 <panic>
80103f41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f48:	00 
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f50 <exit>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	57                   	push   %edi
80103f54:	56                   	push   %esi
80103f55:	53                   	push   %ebx
80103f56:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f59:	e8 d2 fb ff ff       	call   80103b30 <myproc>
  if(curproc == initproc)
80103f5e:	39 05 50 4d 11 80    	cmp    %eax,0x80114d50
80103f64:	0f 84 6d 01 00 00    	je     801040d7 <exit+0x187>
  acquire(&ptable.lock);
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	89 c3                	mov    %eax,%ebx
80103f6f:	68 20 2d 11 80       	push   $0x80112d20
80103f74:	e8 57 08 00 00       	call   801047d0 <acquire>
  for (int i = 0; i < history_count; i++) {
80103f79:	8b 0d 58 4c 11 80    	mov    0x80114c58,%ecx
80103f7f:	83 c4 10             	add    $0x10,%esp
80103f82:	85 c9                	test   %ecx,%ecx
80103f84:	7e 4a                	jle    80103fd0 <exit+0x80>
      if (process_history[i].pid == curproc->pid) {
80103f86:	8b 7b 10             	mov    0x10(%ebx),%edi
  for (int i = 0; i < history_count; i++) {
80103f89:	31 c0                	xor    %eax,%eax
80103f8b:	eb 0a                	jmp    80103f97 <exit+0x47>
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
80103f90:	83 c0 01             	add    $0x1,%eax
80103f93:	39 c8                	cmp    %ecx,%eax
80103f95:	74 39                	je     80103fd0 <exit+0x80>
      if (process_history[i].pid == curproc->pid) {
80103f97:	8d 14 40             	lea    (%eax,%eax,2),%edx
80103f9a:	8d 34 d5 00 00 00 00 	lea    0x0(,%edx,8),%esi
80103fa1:	39 3c d5 60 4c 11 80 	cmp    %edi,-0x7feeb3a0(,%edx,8)
80103fa8:	75 e6                	jne    80103f90 <exit+0x40>
        if(curproc->sz > process_history[i].mem_usage) {
80103faa:	8b 03                	mov    (%ebx),%eax
80103fac:	3b 86 74 4c 11 80    	cmp    -0x7feeb38c(%esi),%eax
80103fb2:	76 06                	jbe    80103fba <exit+0x6a>
          process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
80103fb4:	89 86 74 4c 11 80    	mov    %eax,-0x7feeb38c(%esi)
          safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80103fba:	81 c6 64 4c 11 80    	add    $0x80114c64,%esi
80103fc0:	50                   	push   %eax
80103fc1:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103fc4:	6a 10                	push   $0x10
80103fc6:	50                   	push   %eax
80103fc7:	56                   	push   %esi
80103fc8:	e8 83 0a 00 00       	call   80104a50 <safestrcpy>
          break;
80103fcd:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
80103fd3:	8d 73 28             	lea    0x28(%ebx),%esi
80103fd6:	8d 7b 68             	lea    0x68(%ebx),%edi
80103fd9:	68 20 2d 11 80       	push   $0x80112d20
80103fde:	e8 8d 07 00 00       	call   80104770 <release>
  for(fd = 0; fd < NOFILE; fd++){
80103fe3:	83 c4 10             	add    $0x10,%esp
80103fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fed:	00 
80103fee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
80103ff0:	8b 06                	mov    (%esi),%eax
80103ff2:	85 c0                	test   %eax,%eax
80103ff4:	74 12                	je     80104008 <exit+0xb8>
      fileclose(curproc->ofile[fd]);
80103ff6:	83 ec 0c             	sub    $0xc,%esp
80103ff9:	50                   	push   %eax
80103ffa:	e8 01 d0 ff ff       	call   80101000 <fileclose>
      curproc->ofile[fd] = 0;
80103fff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104005:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104008:	83 c6 04             	add    $0x4,%esi
8010400b:	39 f7                	cmp    %esi,%edi
8010400d:	75 e1                	jne    80103ff0 <exit+0xa0>
  begin_op();
8010400f:	e8 5c ee ff ff       	call   80102e70 <begin_op>
  iput(curproc->cwd);
80104014:	83 ec 0c             	sub    $0xc,%esp
80104017:	ff 73 68             	push   0x68(%ebx)
8010401a:	e8 a1 d9 ff ff       	call   801019c0 <iput>
  end_op();
8010401f:	e8 bc ee ff ff       	call   80102ee0 <end_op>
  curproc->cwd = 0;
80104024:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010402b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104032:	e8 99 07 00 00       	call   801047d0 <acquire>
  wakeup1(curproc->parent);
80104037:	8b 53 14             	mov    0x14(%ebx),%edx
8010403a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104042:	eb 0e                	jmp    80104052 <exit+0x102>
80104044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104048:	83 c0 7c             	add    $0x7c,%eax
8010404b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104050:	74 1c                	je     8010406e <exit+0x11e>
    if(p->state == SLEEPING && p->chan == chan)
80104052:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104056:	75 f0                	jne    80104048 <exit+0xf8>
80104058:	3b 50 20             	cmp    0x20(%eax),%edx
8010405b:	75 eb                	jne    80104048 <exit+0xf8>
      p->state = RUNNABLE;
8010405d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104064:	83 c0 7c             	add    $0x7c,%eax
80104067:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
8010406c:	75 e4                	jne    80104052 <exit+0x102>
      p->parent = initproc;
8010406e:	8b 0d 50 4d 11 80    	mov    0x80114d50,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104074:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104079:	eb 10                	jmp    8010408b <exit+0x13b>
8010407b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104080:	83 c2 7c             	add    $0x7c,%edx
80104083:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80104089:	74 33                	je     801040be <exit+0x16e>
    if(p->parent == curproc){
8010408b:	39 5a 14             	cmp    %ebx,0x14(%edx)
8010408e:	75 f0                	jne    80104080 <exit+0x130>
      if(p->state == ZOMBIE)
80104090:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104094:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104097:	75 e7                	jne    80104080 <exit+0x130>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104099:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010409e:	eb 0a                	jmp    801040aa <exit+0x15a>
801040a0:	83 c0 7c             	add    $0x7c,%eax
801040a3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040a8:	74 d6                	je     80104080 <exit+0x130>
    if(p->state == SLEEPING && p->chan == chan)
801040aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040ae:	75 f0                	jne    801040a0 <exit+0x150>
801040b0:	3b 48 20             	cmp    0x20(%eax),%ecx
801040b3:	75 eb                	jne    801040a0 <exit+0x150>
      p->state = RUNNABLE;
801040b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040bc:	eb e2                	jmp    801040a0 <exit+0x150>
  curproc->state = ZOMBIE;
801040be:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801040c5:	e8 c6 fd ff ff       	call   80103e90 <sched>
  panic("zombie exit");
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 66 79 10 80       	push   $0x80107966
801040d2:	e8 a9 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	68 59 79 10 80       	push   $0x80107959
801040df:	e8 9c c2 ff ff       	call   80100380 <panic>
801040e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040eb:	00 
801040ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040f0 <wait>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
  pushcli();
801040f5:	e8 86 05 00 00       	call   80104680 <pushcli>
  c = mycpu();
801040fa:	e8 b1 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801040ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104105:	e8 c6 05 00 00       	call   801046d0 <popcli>
  acquire(&ptable.lock);
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 20 2d 11 80       	push   $0x80112d20
80104112:	e8 b9 06 00 00       	call   801047d0 <acquire>
80104117:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010411a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104121:	eb 10                	jmp    80104133 <wait+0x43>
80104123:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104128:	83 c3 7c             	add    $0x7c,%ebx
8010412b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104131:	74 1b                	je     8010414e <wait+0x5e>
      if(p->parent != curproc)
80104133:	39 73 14             	cmp    %esi,0x14(%ebx)
80104136:	75 f0                	jne    80104128 <wait+0x38>
      if(p->state == ZOMBIE){
80104138:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010413c:	74 62                	je     801041a0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104141:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104146:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
8010414c:	75 e5                	jne    80104133 <wait+0x43>
    if(!havekids || curproc->killed){
8010414e:	85 c0                	test   %eax,%eax
80104150:	0f 84 a0 00 00 00    	je     801041f6 <wait+0x106>
80104156:	8b 46 24             	mov    0x24(%esi),%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	0f 85 95 00 00 00    	jne    801041f6 <wait+0x106>
  pushcli();
80104161:	e8 1a 05 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104166:	e8 45 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 5a 05 00 00       	call   801046d0 <popcli>
  if(p == 0)
80104176:	85 db                	test   %ebx,%ebx
80104178:	0f 84 8f 00 00 00    	je     8010420d <wait+0x11d>
  p->chan = chan;
8010417e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104181:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104188:	e8 03 fd ff ff       	call   80103e90 <sched>
  p->chan = 0;
8010418d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104194:	eb 84                	jmp    8010411a <wait+0x2a>
80104196:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010419d:	00 
8010419e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801041a0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041a3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041a6:	ff 73 08             	push   0x8(%ebx)
801041a9:	e8 22 e4 ff ff       	call   801025d0 <kfree>
        p->kstack = 0;
801041ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041b5:	5a                   	pop    %edx
801041b6:	ff 73 04             	push   0x4(%ebx)
801041b9:	e8 f2 30 00 00       	call   801072b0 <freevm>
        p->pid = 0;
801041be:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041c5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041cc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041d0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041de:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801041e5:	e8 86 05 00 00       	call   80104770 <release>
        return pid;
801041ea:	83 c4 10             	add    $0x10,%esp
}
801041ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041f0:	89 f0                	mov    %esi,%eax
801041f2:	5b                   	pop    %ebx
801041f3:	5e                   	pop    %esi
801041f4:	5d                   	pop    %ebp
801041f5:	c3                   	ret
      release(&ptable.lock);
801041f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041fe:	68 20 2d 11 80       	push   $0x80112d20
80104203:	e8 68 05 00 00       	call   80104770 <release>
      return -1;
80104208:	83 c4 10             	add    $0x10,%esp
8010420b:	eb e0                	jmp    801041ed <wait+0xfd>
    panic("sleep");
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 72 79 10 80       	push   $0x80107972
80104215:	e8 66 c1 ff ff       	call   80100380 <panic>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <yield>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104227:	68 20 2d 11 80       	push   $0x80112d20
8010422c:	e8 9f 05 00 00       	call   801047d0 <acquire>
  pushcli();
80104231:	e8 4a 04 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104236:	e8 75 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010423b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104241:	e8 8a 04 00 00       	call   801046d0 <popcli>
  myproc()->state = RUNNABLE;
80104246:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010424d:	e8 3e fc ff ff       	call   80103e90 <sched>
  release(&ptable.lock);
80104252:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104259:	e8 12 05 00 00       	call   80104770 <release>
}
8010425e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104261:	83 c4 10             	add    $0x10,%esp
80104264:	c9                   	leave
80104265:	c3                   	ret
80104266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010426d:	00 
8010426e:	66 90                	xchg   %ax,%ax

80104270 <sleep>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010427c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010427f:	e8 fc 03 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104284:	e8 27 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104289:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010428f:	e8 3c 04 00 00       	call   801046d0 <popcli>
  if(p == 0)
80104294:	85 db                	test   %ebx,%ebx
80104296:	0f 84 87 00 00 00    	je     80104323 <sleep+0xb3>
  if(lk == 0)
8010429c:	85 f6                	test   %esi,%esi
8010429e:	74 76                	je     80104316 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042a0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801042a6:	74 50                	je     801042f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 20 2d 11 80       	push   $0x80112d20
801042b0:	e8 1b 05 00 00       	call   801047d0 <acquire>
    release(lk);
801042b5:	89 34 24             	mov    %esi,(%esp)
801042b8:	e8 b3 04 00 00       	call   80104770 <release>
  p->chan = chan;
801042bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042c7:	e8 c4 fb ff ff       	call   80103e90 <sched>
  p->chan = 0;
801042cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042d3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042da:	e8 91 04 00 00       	call   80104770 <release>
    acquire(lk);
801042df:	89 75 08             	mov    %esi,0x8(%ebp)
801042e2:	83 c4 10             	add    $0x10,%esp
}
801042e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e8:	5b                   	pop    %ebx
801042e9:	5e                   	pop    %esi
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
    acquire(lk);
801042ec:	e9 df 04 00 00       	jmp    801047d0 <acquire>
801042f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104302:	e8 89 fb ff ff       	call   80103e90 <sched>
  p->chan = 0;
80104307:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010430e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104311:	5b                   	pop    %ebx
80104312:	5e                   	pop    %esi
80104313:	5f                   	pop    %edi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret
    panic("sleep without lk");
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 78 79 10 80       	push   $0x80107978
8010431e:	e8 5d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	68 72 79 10 80       	push   $0x80107972
8010432b:	e8 50 c0 ff ff       	call   80100380 <panic>

80104330 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010433a:	68 20 2d 11 80       	push   $0x80112d20
8010433f:	e8 8c 04 00 00       	call   801047d0 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104347:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010434c:	eb 0c                	jmp    8010435a <wakeup+0x2a>
8010434e:	66 90                	xchg   %ax,%ax
80104350:	83 c0 7c             	add    $0x7c,%eax
80104353:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104358:	74 1c                	je     80104376 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010435a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010435e:	75 f0                	jne    80104350 <wakeup+0x20>
80104360:	3b 58 20             	cmp    0x20(%eax),%ebx
80104363:	75 eb                	jne    80104350 <wakeup+0x20>
      p->state = RUNNABLE;
80104365:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010436c:	83 c0 7c             	add    $0x7c,%eax
8010436f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104374:	75 e4                	jne    8010435a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104376:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010437d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104380:	c9                   	leave
  release(&ptable.lock);
80104381:	e9 ea 03 00 00       	jmp    80104770 <release>
80104386:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010438d:	00 
8010438e:	66 90                	xchg   %ax,%ax

80104390 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010439a:	68 20 2d 11 80       	push   $0x80112d20
8010439f:	e8 2c 04 00 00       	call   801047d0 <acquire>
801043a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043ac:	eb 0c                	jmp    801043ba <kill+0x2a>
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	83 c0 7c             	add    $0x7c,%eax
801043b3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801043b8:	74 36                	je     801043f0 <kill+0x60>
    if(p->pid == pid){
801043ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801043bd:	75 f1                	jne    801043b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043ca:	75 07                	jne    801043d3 <kill+0x43>
        p->state = RUNNABLE;
801043cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 20 2d 11 80       	push   $0x80112d20
801043db:	e8 90 03 00 00       	call   80104770 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043e3:	83 c4 10             	add    $0x10,%esp
801043e6:	31 c0                	xor    %eax,%eax
}
801043e8:	c9                   	leave
801043e9:	c3                   	ret
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 20 2d 11 80       	push   $0x80112d20
801043f8:	e8 73 03 00 00       	call   80104770 <release>
}
801043fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104400:	83 c4 10             	add    $0x10,%esp
80104403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104408:	c9                   	leave
80104409:	c3                   	ret
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104418:	53                   	push   %ebx
80104419:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010441e:	83 ec 3c             	sub    $0x3c,%esp
80104421:	eb 24                	jmp    80104447 <procdump+0x37>
80104423:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 4e 7b 10 80       	push   $0x80107b4e
80104430:	e8 6b c2 ff ff       	call   801006a0 <cprintf>
80104435:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104438:	83 c3 7c             	add    $0x7c,%ebx
8010443b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104441:	0f 84 81 00 00 00    	je     801044c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104447:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010444a:	85 c0                	test   %eax,%eax
8010444c:	74 ea                	je     80104438 <procdump+0x28>
      state = "???";
8010444e:	ba 89 79 10 80       	mov    $0x80107989,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104453:	83 f8 05             	cmp    $0x5,%eax
80104456:	77 11                	ja     80104469 <procdump+0x59>
80104458:	8b 14 85 e0 7f 10 80 	mov    -0x7fef8020(,%eax,4),%edx
      state = "???";
8010445f:	b8 89 79 10 80       	mov    $0x80107989,%eax
80104464:	85 d2                	test   %edx,%edx
80104466:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104469:	53                   	push   %ebx
8010446a:	52                   	push   %edx
8010446b:	ff 73 a4             	push   -0x5c(%ebx)
8010446e:	68 8d 79 10 80       	push   $0x8010798d
80104473:	e8 28 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104478:	83 c4 10             	add    $0x10,%esp
8010447b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010447f:	75 a7                	jne    80104428 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104481:	83 ec 08             	sub    $0x8,%esp
80104484:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104487:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010448a:	50                   	push   %eax
8010448b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010448e:	8b 40 0c             	mov    0xc(%eax),%eax
80104491:	83 c0 08             	add    $0x8,%eax
80104494:	50                   	push   %eax
80104495:	e8 86 01 00 00       	call   80104620 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010449a:	83 c4 10             	add    $0x10,%esp
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	8b 17                	mov    (%edi),%edx
801044a2:	85 d2                	test   %edx,%edx
801044a4:	74 82                	je     80104428 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044ac:	52                   	push   %edx
801044ad:	68 c1 76 10 80       	push   $0x801076c1
801044b2:	e8 e9 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044b7:	83 c4 10             	add    $0x10,%esp
801044ba:	39 fe                	cmp    %edi,%esi
801044bc:	75 e2                	jne    801044a0 <procdump+0x90>
801044be:	e9 65 ff ff ff       	jmp    80104428 <procdump+0x18>
801044c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801044c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044cb:	5b                   	pop    %ebx
801044cc:	5e                   	pop    %esi
801044cd:	5f                   	pop    %edi
801044ce:	5d                   	pop    %ebp
801044cf:	c3                   	ret

801044d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044da:	68 c0 79 10 80       	push   $0x801079c0
801044df:	8d 43 04             	lea    0x4(%ebx),%eax
801044e2:	50                   	push   %eax
801044e3:	e8 18 01 00 00       	call   80104600 <initlock>
  lk->name = name;
801044e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104501:	c9                   	leave
80104502:	c3                   	ret
80104503:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010450a:	00 
8010450b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104510 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104518:	8d 73 04             	lea    0x4(%ebx),%esi
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	56                   	push   %esi
8010451f:	e8 ac 02 00 00       	call   801047d0 <acquire>
  while (lk->locked) {
80104524:	8b 13                	mov    (%ebx),%edx
80104526:	83 c4 10             	add    $0x10,%esp
80104529:	85 d2                	test   %edx,%edx
8010452b:	74 16                	je     80104543 <acquiresleep+0x33>
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104530:	83 ec 08             	sub    $0x8,%esp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	e8 36 fd ff ff       	call   80104270 <sleep>
  while (lk->locked) {
8010453a:	8b 03                	mov    (%ebx),%eax
8010453c:	83 c4 10             	add    $0x10,%esp
8010453f:	85 c0                	test   %eax,%eax
80104541:	75 ed                	jne    80104530 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104543:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104549:	e8 e2 f5 ff ff       	call   80103b30 <myproc>
8010454e:	8b 40 10             	mov    0x10(%eax),%eax
80104551:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104554:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104557:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010455a:	5b                   	pop    %ebx
8010455b:	5e                   	pop    %esi
8010455c:	5d                   	pop    %ebp
  release(&lk->lk);
8010455d:	e9 0e 02 00 00       	jmp    80104770 <release>
80104562:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104569:	00 
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104570 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104578:	8d 73 04             	lea    0x4(%ebx),%esi
8010457b:	83 ec 0c             	sub    $0xc,%esp
8010457e:	56                   	push   %esi
8010457f:	e8 4c 02 00 00       	call   801047d0 <acquire>
  lk->locked = 0;
80104584:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010458a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104591:	89 1c 24             	mov    %ebx,(%esp)
80104594:	e8 97 fd ff ff       	call   80104330 <wakeup>
  release(&lk->lk);
80104599:	89 75 08             	mov    %esi,0x8(%ebp)
8010459c:	83 c4 10             	add    $0x10,%esp
}
8010459f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a2:	5b                   	pop    %ebx
801045a3:	5e                   	pop    %esi
801045a4:	5d                   	pop    %ebp
  release(&lk->lk);
801045a5:	e9 c6 01 00 00       	jmp    80104770 <release>
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	31 ff                	xor    %edi,%edi
801045b6:	56                   	push   %esi
801045b7:	53                   	push   %ebx
801045b8:	83 ec 18             	sub    $0x18,%esp
801045bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045be:	8d 73 04             	lea    0x4(%ebx),%esi
801045c1:	56                   	push   %esi
801045c2:	e8 09 02 00 00       	call   801047d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045c7:	8b 03                	mov    (%ebx),%eax
801045c9:	83 c4 10             	add    $0x10,%esp
801045cc:	85 c0                	test   %eax,%eax
801045ce:	75 18                	jne    801045e8 <holdingsleep+0x38>
  release(&lk->lk);
801045d0:	83 ec 0c             	sub    $0xc,%esp
801045d3:	56                   	push   %esi
801045d4:	e8 97 01 00 00       	call   80104770 <release>
  return r;
}
801045d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045dc:	89 f8                	mov    %edi,%eax
801045de:	5b                   	pop    %ebx
801045df:	5e                   	pop    %esi
801045e0:	5f                   	pop    %edi
801045e1:	5d                   	pop    %ebp
801045e2:	c3                   	ret
801045e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801045e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045eb:	e8 40 f5 ff ff       	call   80103b30 <myproc>
801045f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801045f3:	0f 94 c0             	sete   %al
801045f6:	0f b6 c0             	movzbl %al,%eax
801045f9:	89 c7                	mov    %eax,%edi
801045fb:	eb d3                	jmp    801045d0 <holdingsleep+0x20>
801045fd:	66 90                	xchg   %ax,%ax
801045ff:	90                   	nop

80104600 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104606:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010460f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104619:	5d                   	pop    %ebp
8010461a:	c3                   	ret
8010461b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104620 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104620:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104621:	31 d2                	xor    %edx,%edx
{
80104623:	89 e5                	mov    %esp,%ebp
80104625:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104626:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010462c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010462f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104630:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104636:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010463c:	77 1a                	ja     80104658 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010463e:	8b 58 04             	mov    0x4(%eax),%ebx
80104641:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104644:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104647:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104649:	83 fa 0a             	cmp    $0xa,%edx
8010464c:	75 e2                	jne    80104630 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010464e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104651:	c9                   	leave
80104652:	c3                   	ret
80104653:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104658:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010465b:	8d 51 28             	lea    0x28(%ecx),%edx
8010465e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104666:	83 c0 04             	add    $0x4,%eax
80104669:	39 d0                	cmp    %edx,%eax
8010466b:	75 f3                	jne    80104660 <getcallerpcs+0x40>
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave
80104671:	c3                   	ret
80104672:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104679:	00 
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	83 ec 04             	sub    $0x4,%esp
80104687:	9c                   	pushf
80104688:	5b                   	pop    %ebx
  asm volatile("cli");
80104689:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010468a:	e8 21 f4 ff ff       	call   80103ab0 <mycpu>
8010468f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104695:	85 c0                	test   %eax,%eax
80104697:	74 17                	je     801046b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104699:	e8 12 f4 ff ff       	call   80103ab0 <mycpu>
8010469e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a8:	c9                   	leave
801046a9:	c3                   	ret
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046b0:	e8 fb f3 ff ff       	call   80103ab0 <mycpu>
801046b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046c1:	eb d6                	jmp    80104699 <pushcli+0x19>
801046c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046ca:	00 
801046cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046d0 <popcli>:

void
popcli(void)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046d6:	9c                   	pushf
801046d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046d8:	f6 c4 02             	test   $0x2,%ah
801046db:	75 35                	jne    80104712 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046dd:	e8 ce f3 ff ff       	call   80103ab0 <mycpu>
801046e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046e9:	78 34                	js     8010471f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046eb:	e8 c0 f3 ff ff       	call   80103ab0 <mycpu>
801046f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046f6:	85 d2                	test   %edx,%edx
801046f8:	74 06                	je     80104700 <popcli+0x30>
    sti();
}
801046fa:	c9                   	leave
801046fb:	c3                   	ret
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104700:	e8 ab f3 ff ff       	call   80103ab0 <mycpu>
80104705:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010470b:	85 c0                	test   %eax,%eax
8010470d:	74 eb                	je     801046fa <popcli+0x2a>
  asm volatile("sti");
8010470f:	fb                   	sti
}
80104710:	c9                   	leave
80104711:	c3                   	ret
    panic("popcli - interruptible");
80104712:	83 ec 0c             	sub    $0xc,%esp
80104715:	68 cb 79 10 80       	push   $0x801079cb
8010471a:	e8 61 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010471f:	83 ec 0c             	sub    $0xc,%esp
80104722:	68 e2 79 10 80       	push   $0x801079e2
80104727:	e8 54 bc ff ff       	call   80100380 <panic>
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <holding>:
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 75 08             	mov    0x8(%ebp),%esi
80104738:	31 db                	xor    %ebx,%ebx
  pushcli();
8010473a:	e8 41 ff ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010473f:	8b 06                	mov    (%esi),%eax
80104741:	85 c0                	test   %eax,%eax
80104743:	75 0b                	jne    80104750 <holding+0x20>
  popcli();
80104745:	e8 86 ff ff ff       	call   801046d0 <popcli>
}
8010474a:	89 d8                	mov    %ebx,%eax
8010474c:	5b                   	pop    %ebx
8010474d:	5e                   	pop    %esi
8010474e:	5d                   	pop    %ebp
8010474f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104750:	8b 5e 08             	mov    0x8(%esi),%ebx
80104753:	e8 58 f3 ff ff       	call   80103ab0 <mycpu>
80104758:	39 c3                	cmp    %eax,%ebx
8010475a:	0f 94 c3             	sete   %bl
  popcli();
8010475d:	e8 6e ff ff ff       	call   801046d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104762:	0f b6 db             	movzbl %bl,%ebx
}
80104765:	89 d8                	mov    %ebx,%eax
80104767:	5b                   	pop    %ebx
80104768:	5e                   	pop    %esi
80104769:	5d                   	pop    %ebp
8010476a:	c3                   	ret
8010476b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104770 <release>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104778:	e8 03 ff ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010477d:	8b 03                	mov    (%ebx),%eax
8010477f:	85 c0                	test   %eax,%eax
80104781:	75 15                	jne    80104798 <release+0x28>
  popcli();
80104783:	e8 48 ff ff ff       	call   801046d0 <popcli>
    panic("release");
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	68 e9 79 10 80       	push   $0x801079e9
80104790:	e8 eb bb ff ff       	call   80100380 <panic>
80104795:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104798:	8b 73 08             	mov    0x8(%ebx),%esi
8010479b:	e8 10 f3 ff ff       	call   80103ab0 <mycpu>
801047a0:	39 c6                	cmp    %eax,%esi
801047a2:	75 df                	jne    80104783 <release+0x13>
  popcli();
801047a4:	e8 27 ff ff ff       	call   801046d0 <popcli>
  lk->pcs[0] = 0;
801047a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c5:	5b                   	pop    %ebx
801047c6:	5e                   	pop    %esi
801047c7:	5d                   	pop    %ebp
  popcli();
801047c8:	e9 03 ff ff ff       	jmp    801046d0 <popcli>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <acquire>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047d7:	e8 a4 fe ff ff       	call   80104680 <pushcli>
  if(holding(lk))
801047dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047df:	e8 9c fe ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047e4:	8b 03                	mov    (%ebx),%eax
801047e6:	85 c0                	test   %eax,%eax
801047e8:	75 7e                	jne    80104868 <acquire+0x98>
  popcli();
801047ea:	e8 e1 fe ff ff       	call   801046d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801047f8:	8b 55 08             	mov    0x8(%ebp),%edx
801047fb:	89 c8                	mov    %ecx,%eax
801047fd:	f0 87 02             	lock xchg %eax,(%edx)
80104800:	85 c0                	test   %eax,%eax
80104802:	75 f4                	jne    801047f8 <acquire+0x28>
  __sync_synchronize();
80104804:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104809:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010480c:	e8 9f f2 ff ff       	call   80103ab0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104814:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104816:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104819:	31 c0                	xor    %eax,%eax
8010481b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104820:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104826:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010482c:	77 1a                	ja     80104848 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010482e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104831:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104835:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104838:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010483a:	83 f8 0a             	cmp    $0xa,%eax
8010483d:	75 e1                	jne    80104820 <acquire+0x50>
}
8010483f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104842:	c9                   	leave
80104843:	c3                   	ret
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104848:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010484c:	8d 51 34             	lea    0x34(%ecx),%edx
8010484f:	90                   	nop
    pcs[i] = 0;
80104850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104856:	83 c0 04             	add    $0x4,%eax
80104859:	39 c2                	cmp    %eax,%edx
8010485b:	75 f3                	jne    80104850 <acquire+0x80>
}
8010485d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104860:	c9                   	leave
80104861:	c3                   	ret
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104868:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010486b:	e8 40 f2 ff ff       	call   80103ab0 <mycpu>
80104870:	39 c3                	cmp    %eax,%ebx
80104872:	0f 85 72 ff ff ff    	jne    801047ea <acquire+0x1a>
  popcli();
80104878:	e8 53 fe ff ff       	call   801046d0 <popcli>
    panic("acquire");
8010487d:	83 ec 0c             	sub    $0xc,%esp
80104880:	68 f1 79 10 80       	push   $0x801079f1
80104885:	e8 f6 ba ff ff       	call   80100380 <panic>
8010488a:	66 90                	xchg   %ax,%ax
8010488c:	66 90                	xchg   %ax,%ax
8010488e:	66 90                	xchg   %ax,%ax

80104890 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	8b 55 08             	mov    0x8(%ebp),%edx
80104897:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010489a:	53                   	push   %ebx
8010489b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010489e:	89 d7                	mov    %edx,%edi
801048a0:	09 cf                	or     %ecx,%edi
801048a2:	83 e7 03             	and    $0x3,%edi
801048a5:	75 29                	jne    801048d0 <memset+0x40>
    c &= 0xFF;
801048a7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048aa:	c1 e0 18             	shl    $0x18,%eax
801048ad:	89 fb                	mov    %edi,%ebx
801048af:	c1 e9 02             	shr    $0x2,%ecx
801048b2:	c1 e3 10             	shl    $0x10,%ebx
801048b5:	09 d8                	or     %ebx,%eax
801048b7:	09 f8                	or     %edi,%eax
801048b9:	c1 e7 08             	shl    $0x8,%edi
801048bc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801048be:	89 d7                	mov    %edx,%edi
801048c0:	fc                   	cld
801048c1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048c3:	5b                   	pop    %ebx
801048c4:	89 d0                	mov    %edx,%eax
801048c6:	5f                   	pop    %edi
801048c7:	5d                   	pop    %ebp
801048c8:	c3                   	ret
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048d0:	89 d7                	mov    %edx,%edi
801048d2:	fc                   	cld
801048d3:	f3 aa                	rep stos %al,%es:(%edi)
801048d5:	5b                   	pop    %ebx
801048d6:	89 d0                	mov    %edx,%eax
801048d8:	5f                   	pop    %edi
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret
801048db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801048e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	8b 75 10             	mov    0x10(%ebp),%esi
801048e7:	8b 55 08             	mov    0x8(%ebp),%edx
801048ea:	53                   	push   %ebx
801048eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ee:	85 f6                	test   %esi,%esi
801048f0:	74 2e                	je     80104920 <memcmp+0x40>
801048f2:	01 c6                	add    %eax,%esi
801048f4:	eb 14                	jmp    8010490a <memcmp+0x2a>
801048f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048fd:	00 
801048fe:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104900:	83 c0 01             	add    $0x1,%eax
80104903:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104906:	39 f0                	cmp    %esi,%eax
80104908:	74 16                	je     80104920 <memcmp+0x40>
    if(*s1 != *s2)
8010490a:	0f b6 0a             	movzbl (%edx),%ecx
8010490d:	0f b6 18             	movzbl (%eax),%ebx
80104910:	38 d9                	cmp    %bl,%cl
80104912:	74 ec                	je     80104900 <memcmp+0x20>
      return *s1 - *s2;
80104914:	0f b6 c1             	movzbl %cl,%eax
80104917:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104919:	5b                   	pop    %ebx
8010491a:	5e                   	pop    %esi
8010491b:	5d                   	pop    %ebp
8010491c:	c3                   	ret
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
80104920:	5b                   	pop    %ebx
  return 0;
80104921:	31 c0                	xor    %eax,%eax
}
80104923:	5e                   	pop    %esi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret
80104926:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010492d:	00 
8010492e:	66 90                	xchg   %ax,%ax

80104930 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	8b 55 08             	mov    0x8(%ebp),%edx
80104937:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010493a:	56                   	push   %esi
8010493b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010493e:	39 d6                	cmp    %edx,%esi
80104940:	73 26                	jae    80104968 <memmove+0x38>
80104942:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104945:	39 fa                	cmp    %edi,%edx
80104947:	73 1f                	jae    80104968 <memmove+0x38>
80104949:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010494c:	85 c9                	test   %ecx,%ecx
8010494e:	74 0c                	je     8010495c <memmove+0x2c>
      *--d = *--s;
80104950:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104954:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104957:	83 e8 01             	sub    $0x1,%eax
8010495a:	73 f4                	jae    80104950 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010495c:	5e                   	pop    %esi
8010495d:	89 d0                	mov    %edx,%eax
8010495f:	5f                   	pop    %edi
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret
80104962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104968:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010496b:	89 d7                	mov    %edx,%edi
8010496d:	85 c9                	test   %ecx,%ecx
8010496f:	74 eb                	je     8010495c <memmove+0x2c>
80104971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104978:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104979:	39 c6                	cmp    %eax,%esi
8010497b:	75 fb                	jne    80104978 <memmove+0x48>
}
8010497d:	5e                   	pop    %esi
8010497e:	89 d0                	mov    %edx,%eax
80104980:	5f                   	pop    %edi
80104981:	5d                   	pop    %ebp
80104982:	c3                   	ret
80104983:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010498a:	00 
8010498b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104990 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104990:	eb 9e                	jmp    80104930 <memmove>
80104992:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104999:	00 
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	8b 75 10             	mov    0x10(%ebp),%esi
801049a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049aa:	53                   	push   %ebx
801049ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801049ae:	85 f6                	test   %esi,%esi
801049b0:	74 2e                	je     801049e0 <strncmp+0x40>
801049b2:	01 d6                	add    %edx,%esi
801049b4:	eb 18                	jmp    801049ce <strncmp+0x2e>
801049b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049bd:	00 
801049be:	66 90                	xchg   %ax,%ax
801049c0:	38 d8                	cmp    %bl,%al
801049c2:	75 14                	jne    801049d8 <strncmp+0x38>
    n--, p++, q++;
801049c4:	83 c2 01             	add    $0x1,%edx
801049c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049ca:	39 f2                	cmp    %esi,%edx
801049cc:	74 12                	je     801049e0 <strncmp+0x40>
801049ce:	0f b6 01             	movzbl (%ecx),%eax
801049d1:	0f b6 1a             	movzbl (%edx),%ebx
801049d4:	84 c0                	test   %al,%al
801049d6:	75 e8                	jne    801049c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049d8:	29 d8                	sub    %ebx,%eax
}
801049da:	5b                   	pop    %ebx
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret
801049de:	66 90                	xchg   %ax,%ax
801049e0:	5b                   	pop    %ebx
    return 0;
801049e1:	31 c0                	xor    %eax,%eax
}
801049e3:	5e                   	pop    %esi
801049e4:	5d                   	pop    %ebp
801049e5:	c3                   	ret
801049e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049ed:	00 
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	8b 75 08             	mov    0x8(%ebp),%esi
801049f8:	53                   	push   %ebx
801049f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049fc:	89 f0                	mov    %esi,%eax
801049fe:	eb 15                	jmp    80104a15 <strncpy+0x25>
80104a00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a04:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a07:	83 c0 01             	add    $0x1,%eax
80104a0a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a0e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a11:	84 d2                	test   %dl,%dl
80104a13:	74 09                	je     80104a1e <strncpy+0x2e>
80104a15:	89 cb                	mov    %ecx,%ebx
80104a17:	83 e9 01             	sub    $0x1,%ecx
80104a1a:	85 db                	test   %ebx,%ebx
80104a1c:	7f e2                	jg     80104a00 <strncpy+0x10>
    ;
  while(n-- > 0)
80104a1e:	89 c2                	mov    %eax,%edx
80104a20:	85 c9                	test   %ecx,%ecx
80104a22:	7e 17                	jle    80104a3b <strncpy+0x4b>
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a28:	83 c2 01             	add    $0x1,%edx
80104a2b:	89 c1                	mov    %eax,%ecx
80104a2d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104a31:	29 d1                	sub    %edx,%ecx
80104a33:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a37:	85 c9                	test   %ecx,%ecx
80104a39:	7f ed                	jg     80104a28 <strncpy+0x38>
  return os;
}
80104a3b:	5b                   	pop    %ebx
80104a3c:	89 f0                	mov    %esi,%eax
80104a3e:	5e                   	pop    %esi
80104a3f:	5f                   	pop    %edi
80104a40:	5d                   	pop    %ebp
80104a41:	c3                   	ret
80104a42:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a49:	00 
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	8b 55 10             	mov    0x10(%ebp),%edx
80104a57:	8b 75 08             	mov    0x8(%ebp),%esi
80104a5a:	53                   	push   %ebx
80104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a5e:	85 d2                	test   %edx,%edx
80104a60:	7e 25                	jle    80104a87 <safestrcpy+0x37>
80104a62:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a66:	89 f2                	mov    %esi,%edx
80104a68:	eb 16                	jmp    80104a80 <safestrcpy+0x30>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a70:	0f b6 08             	movzbl (%eax),%ecx
80104a73:	83 c0 01             	add    $0x1,%eax
80104a76:	83 c2 01             	add    $0x1,%edx
80104a79:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a7c:	84 c9                	test   %cl,%cl
80104a7e:	74 04                	je     80104a84 <safestrcpy+0x34>
80104a80:	39 d8                	cmp    %ebx,%eax
80104a82:	75 ec                	jne    80104a70 <safestrcpy+0x20>
    ;
  *s = 0;
80104a84:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a87:	89 f0                	mov    %esi,%eax
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <strlen>:

int
strlen(const char *s)
{
80104a90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a91:	31 c0                	xor    %eax,%eax
{
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a98:	80 3a 00             	cmpb   $0x0,(%edx)
80104a9b:	74 0c                	je     80104aa9 <strlen+0x19>
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	83 c0 01             	add    $0x1,%eax
80104aa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104aa7:	75 f7                	jne    80104aa0 <strlen+0x10>
    ;
  return n;
}
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret

80104aab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104aab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104aaf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ab3:	55                   	push   %ebp
  pushl %ebx
80104ab4:	53                   	push   %ebx
  pushl %esi
80104ab5:	56                   	push   %esi
  pushl %edi
80104ab6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ab7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ab9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104abb:	5f                   	pop    %edi
  popl %esi
80104abc:	5e                   	pop    %esi
  popl %ebx
80104abd:	5b                   	pop    %ebx
  popl %ebp
80104abe:	5d                   	pop    %ebp
  ret
80104abf:	c3                   	ret

80104ac0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aca:	e8 61 f0 ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104acf:	8b 00                	mov    (%eax),%eax
80104ad1:	39 d8                	cmp    %ebx,%eax
80104ad3:	76 1b                	jbe    80104af0 <fetchint+0x30>
80104ad5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ad8:	39 d0                	cmp    %edx,%eax
80104ada:	72 14                	jb     80104af0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104adf:	8b 13                	mov    (%ebx),%edx
80104ae1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ae3:	31 c0                	xor    %eax,%eax
}
80104ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae8:	c9                   	leave
80104ae9:	c3                   	ret
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af5:	eb ee                	jmp    80104ae5 <fetchint+0x25>
80104af7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104afe:	00 
80104aff:	90                   	nop

80104b00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
80104b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b0a:	e8 21 f0 ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz)
80104b0f:	39 18                	cmp    %ebx,(%eax)
80104b11:	76 2d                	jbe    80104b40 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b16:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b18:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b1a:	39 d3                	cmp    %edx,%ebx
80104b1c:	73 22                	jae    80104b40 <fetchstr+0x40>
80104b1e:	89 d8                	mov    %ebx,%eax
80104b20:	eb 0d                	jmp    80104b2f <fetchstr+0x2f>
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b28:	83 c0 01             	add    $0x1,%eax
80104b2b:	39 c2                	cmp    %eax,%edx
80104b2d:	76 11                	jbe    80104b40 <fetchstr+0x40>
    if(*s == 0)
80104b2f:	80 38 00             	cmpb   $0x0,(%eax)
80104b32:	75 f4                	jne    80104b28 <fetchstr+0x28>
      return s - *pp;
80104b34:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b39:	c9                   	leave
80104b3a:	c3                   	ret
80104b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b48:	c9                   	leave
80104b49:	c3                   	ret
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b55:	e8 d6 ef ff ff       	call   80103b30 <myproc>
80104b5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b5d:	8b 40 18             	mov    0x18(%eax),%eax
80104b60:	8b 40 44             	mov    0x44(%eax),%eax
80104b63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b66:	e8 c5 ef ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b6e:	8b 00                	mov    (%eax),%eax
80104b70:	39 c6                	cmp    %eax,%esi
80104b72:	73 1c                	jae    80104b90 <argint+0x40>
80104b74:	8d 53 08             	lea    0x8(%ebx),%edx
80104b77:	39 d0                	cmp    %edx,%eax
80104b79:	72 15                	jb     80104b90 <argint+0x40>
  *ip = *(int*)(addr);
80104b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b81:	89 10                	mov    %edx,(%eax)
  return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	5b                   	pop    %ebx
80104b86:	5e                   	pop    %esi
80104b87:	5d                   	pop    %ebp
80104b88:	c3                   	ret
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	eb ee                	jmp    80104b85 <argint+0x35>
80104b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b9e:	00 
80104b9f:	90                   	nop

80104ba0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	53                   	push   %ebx
80104ba6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ba9:	e8 82 ef ff ff       	call   80103b30 <myproc>
80104bae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb0:	e8 7b ef ff ff       	call   80103b30 <myproc>
80104bb5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bb8:	8b 40 18             	mov    0x18(%eax),%eax
80104bbb:	8b 40 44             	mov    0x44(%eax),%eax
80104bbe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bc1:	e8 6a ef ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bc9:	8b 00                	mov    (%eax),%eax
80104bcb:	39 c7                	cmp    %eax,%edi
80104bcd:	73 31                	jae    80104c00 <argptr+0x60>
80104bcf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104bd2:	39 c8                	cmp    %ecx,%eax
80104bd4:	72 2a                	jb     80104c00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bd6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104bd9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bdc:	85 d2                	test   %edx,%edx
80104bde:	78 20                	js     80104c00 <argptr+0x60>
80104be0:	8b 16                	mov    (%esi),%edx
80104be2:	39 c2                	cmp    %eax,%edx
80104be4:	76 1a                	jbe    80104c00 <argptr+0x60>
80104be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104be9:	01 c3                	add    %eax,%ebx
80104beb:	39 da                	cmp    %ebx,%edx
80104bed:	72 11                	jb     80104c00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bef:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bf2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bf4:	31 c0                	xor    %eax,%eax
}
80104bf6:	83 c4 0c             	add    $0xc,%esp
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5f                   	pop    %edi
80104bfc:	5d                   	pop    %ebp
80104bfd:	c3                   	ret
80104bfe:	66 90                	xchg   %ax,%ax
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c05:	eb ef                	jmp    80104bf6 <argptr+0x56>
80104c07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c0e:	00 
80104c0f:	90                   	nop

80104c10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	e8 16 ef ff ff       	call   80103b30 <myproc>
80104c1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c1d:	8b 40 18             	mov    0x18(%eax),%eax
80104c20:	8b 40 44             	mov    0x44(%eax),%eax
80104c23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c26:	e8 05 ef ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c2e:	8b 00                	mov    (%eax),%eax
80104c30:	39 c6                	cmp    %eax,%esi
80104c32:	73 44                	jae    80104c78 <argstr+0x68>
80104c34:	8d 53 08             	lea    0x8(%ebx),%edx
80104c37:	39 d0                	cmp    %edx,%eax
80104c39:	72 3d                	jb     80104c78 <argstr+0x68>
  *ip = *(int*)(addr);
80104c3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c3e:	e8 ed ee ff ff       	call   80103b30 <myproc>
  if(addr >= curproc->sz)
80104c43:	3b 18                	cmp    (%eax),%ebx
80104c45:	73 31                	jae    80104c78 <argstr+0x68>
  *pp = (char*)addr;
80104c47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c4e:	39 d3                	cmp    %edx,%ebx
80104c50:	73 26                	jae    80104c78 <argstr+0x68>
80104c52:	89 d8                	mov    %ebx,%eax
80104c54:	eb 11                	jmp    80104c67 <argstr+0x57>
80104c56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c5d:	00 
80104c5e:	66 90                	xchg   %ax,%ax
80104c60:	83 c0 01             	add    $0x1,%eax
80104c63:	39 c2                	cmp    %eax,%edx
80104c65:	76 11                	jbe    80104c78 <argstr+0x68>
    if(*s == 0)
80104c67:	80 38 00             	cmpb   $0x0,(%eax)
80104c6a:	75 f4                	jne    80104c60 <argstr+0x50>
      return s - *pp;
80104c6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c6e:	5b                   	pop    %ebx
80104c6f:	5e                   	pop    %esi
80104c70:	5d                   	pop    %ebp
80104c71:	c3                   	ret
80104c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c78:	5b                   	pop    %ebx
    return -1;
80104c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c7e:	5e                   	pop    %esi
80104c7f:	5d                   	pop    %ebp
80104c80:	c3                   	ret
80104c81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c88:	00 
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c90 <strcmp>:

// Helper function for comparing two strings.
int
strcmp(const char *p, const char *q)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	8b 55 08             	mov    0x8(%ebp),%edx
80104c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
80104c9a:	0f b6 02             	movzbl (%edx),%eax
80104c9d:	84 c0                	test   %al,%al
80104c9f:	75 17                	jne    80104cb8 <strcmp+0x28>
80104ca1:	eb 3a                	jmp    80104cdd <strcmp+0x4d>
80104ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ca8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
80104cac:	83 c2 01             	add    $0x1,%edx
80104caf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
80104cb2:	84 c0                	test   %al,%al
80104cb4:	74 1a                	je     80104cd0 <strcmp+0x40>
    p++, q++;
80104cb6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
80104cb8:	0f b6 19             	movzbl (%ecx),%ebx
80104cbb:	38 c3                	cmp    %al,%bl
80104cbd:	74 e9                	je     80104ca8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
80104cbf:	29 d8                	sub    %ebx,%eax
}
80104cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc4:	c9                   	leave
80104cc5:	c3                   	ret
80104cc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ccd:	00 
80104cce:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
80104cd0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
80104cd4:	31 c0                	xor    %eax,%eax
80104cd6:	29 d8                	sub    %ebx,%eax
}
80104cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cdb:	c9                   	leave
80104cdc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
80104cdd:	0f b6 19             	movzbl (%ecx),%ebx
80104ce0:	31 c0                	xor    %eax,%eax
80104ce2:	eb db                	jmp    80104cbf <strcmp+0x2f>
80104ce4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ceb:	00 
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <syscall>:
[SYS_gethistory]  sys_gethistory,
[SYS_block]   sys_block,
[SYS_unblock]   sys_unblock,     
};

void syscall(void) {
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104cf7:	e8 34 ee ff ff       	call   80103b30 <myproc>
80104cfc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cfe:	8b 40 18             	mov    0x18(%eax),%eax
80104d01:	8b 40 1c             	mov    0x1c(%eax),%eax

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d07:	83 fa 17             	cmp    $0x17,%edx
80104d0a:	77 2c                	ja     80104d38 <syscall+0x48>
80104d0c:	8b 14 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%edx
80104d13:	85 d2                	test   %edx,%edx
80104d15:	74 21                	je     80104d38 <syscall+0x48>
    // Check if the syscall is blocked
    if (blocked_syscalls[num]) {
80104d17:	8b 0c 85 60 4d 11 80 	mov    -0x7feeb2a0(,%eax,4),%ecx
80104d1e:	85 c9                	test   %ecx,%ecx
80104d20:	75 3e                	jne    80104d60 <syscall+0x70>
      cprintf("syscall %d is blocked\n", num);
      curproc->tf->eax = -1;  // Return error
      return;
    }

    curproc->tf->eax = syscalls[num]();
80104d22:	ff d2                	call   *%edx
80104d24:	89 c2                	mov    %eax,%edx
80104d26:	8b 43 18             	mov    0x18(%ebx),%eax
80104d29:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d2f:	c9                   	leave
80104d30:	c3                   	ret
80104d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d38:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d39:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d3c:	50                   	push   %eax
80104d3d:	ff 73 10             	push   0x10(%ebx)
80104d40:	68 10 7a 10 80       	push   $0x80107a10
80104d45:	e8 56 b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d4a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d4d:	83 c4 10             	add    $0x10,%esp
80104d50:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d5a:	c9                   	leave
80104d5b:	c3                   	ret
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("syscall %d is blocked\n", num);
80104d60:	83 ec 08             	sub    $0x8,%esp
80104d63:	50                   	push   %eax
80104d64:	68 f9 79 10 80       	push   $0x801079f9
80104d69:	e8 32 b9 ff ff       	call   801006a0 <cprintf>
      curproc->tf->eax = -1;  // Return error
80104d6e:	8b 43 18             	mov    0x18(%ebx),%eax
      return;
80104d71:	83 c4 10             	add    $0x10,%esp
      curproc->tf->eax = -1;  // Return error
80104d74:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
      return;
80104d7b:	eb da                	jmp    80104d57 <syscall+0x67>
80104d7d:	66 90                	xchg   %ax,%ax
80104d7f:	90                   	nop

80104d80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d88:	53                   	push   %ebx
80104d89:	83 ec 34             	sub    $0x34,%esp
80104d8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d92:	57                   	push   %edi
80104d93:	50                   	push   %eax
{
80104d94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d9a:	e8 31 d4 ff ff       	call   801021d0 <nameiparent>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	0f 84 46 01 00 00    	je     80104ef0 <create+0x170>
    return 0;
  ilock(dp);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	89 c3                	mov    %eax,%ebx
80104daf:	50                   	push   %eax
80104db0:	e8 db ca ff ff       	call   80101890 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104db5:	83 c4 0c             	add    $0xc,%esp
80104db8:	6a 00                	push   $0x0
80104dba:	57                   	push   %edi
80104dbb:	53                   	push   %ebx
80104dbc:	e8 2f d0 ff ff       	call   80101df0 <dirlookup>
80104dc1:	83 c4 10             	add    $0x10,%esp
80104dc4:	89 c6                	mov    %eax,%esi
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	74 56                	je     80104e20 <create+0xa0>
    iunlockput(dp);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	53                   	push   %ebx
80104dce:	e8 4d cd ff ff       	call   80101b20 <iunlockput>
    ilock(ip);
80104dd3:	89 34 24             	mov    %esi,(%esp)
80104dd6:	e8 b5 ca ff ff       	call   80101890 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ddb:	83 c4 10             	add    $0x10,%esp
80104dde:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104de3:	75 1b                	jne    80104e00 <create+0x80>
80104de5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dea:	75 14                	jne    80104e00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104def:	89 f0                	mov    %esi,%eax
80104df1:	5b                   	pop    %ebx
80104df2:	5e                   	pop    %esi
80104df3:	5f                   	pop    %edi
80104df4:	5d                   	pop    %ebp
80104df5:	c3                   	ret
80104df6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dfd:	00 
80104dfe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	56                   	push   %esi
    return 0;
80104e04:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e06:	e8 15 cd ff ff       	call   80101b20 <iunlockput>
    return 0;
80104e0b:	83 c4 10             	add    $0x10,%esp
}
80104e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e11:	89 f0                	mov    %esi,%eax
80104e13:	5b                   	pop    %ebx
80104e14:	5e                   	pop    %esi
80104e15:	5f                   	pop    %edi
80104e16:	5d                   	pop    %ebp
80104e17:	c3                   	ret
80104e18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e1f:	00 
  if((ip = ialloc(dp->dev, type)) == 0)
80104e20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	50                   	push   %eax
80104e28:	ff 33                	push   (%ebx)
80104e2a:	e8 f1 c8 ff ff       	call   80101720 <ialloc>
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	89 c6                	mov    %eax,%esi
80104e34:	85 c0                	test   %eax,%eax
80104e36:	0f 84 cd 00 00 00    	je     80104f09 <create+0x189>
  ilock(ip);
80104e3c:	83 ec 0c             	sub    $0xc,%esp
80104e3f:	50                   	push   %eax
80104e40:	e8 4b ca ff ff       	call   80101890 <ilock>
  ip->major = major;
80104e45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e49:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e51:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e55:	b8 01 00 00 00       	mov    $0x1,%eax
80104e5a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e5e:	89 34 24             	mov    %esi,(%esp)
80104e61:	e8 7a c9 ff ff       	call   801017e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e66:	83 c4 10             	add    $0x10,%esp
80104e69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e6e:	74 30                	je     80104ea0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e70:	83 ec 04             	sub    $0x4,%esp
80104e73:	ff 76 04             	push   0x4(%esi)
80104e76:	57                   	push   %edi
80104e77:	53                   	push   %ebx
80104e78:	e8 73 d2 ff ff       	call   801020f0 <dirlink>
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 78                	js     80104efc <create+0x17c>
  iunlockput(dp);
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	53                   	push   %ebx
80104e88:	e8 93 cc ff ff       	call   80101b20 <iunlockput>
  return ip;
80104e8d:	83 c4 10             	add    $0x10,%esp
}
80104e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e93:	89 f0                	mov    %esi,%eax
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5f                   	pop    %edi
80104e98:	5d                   	pop    %ebp
80104e99:	c3                   	ret
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ea3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ea8:	53                   	push   %ebx
80104ea9:	e8 32 c9 ff ff       	call   801017e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eae:	83 c4 0c             	add    $0xc,%esp
80104eb1:	ff 76 04             	push   0x4(%esi)
80104eb4:	68 48 7a 10 80       	push   $0x80107a48
80104eb9:	56                   	push   %esi
80104eba:	e8 31 d2 ff ff       	call   801020f0 <dirlink>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	78 18                	js     80104ede <create+0x15e>
80104ec6:	83 ec 04             	sub    $0x4,%esp
80104ec9:	ff 73 04             	push   0x4(%ebx)
80104ecc:	68 47 7a 10 80       	push   $0x80107a47
80104ed1:	56                   	push   %esi
80104ed2:	e8 19 d2 ff ff       	call   801020f0 <dirlink>
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	85 c0                	test   %eax,%eax
80104edc:	79 92                	jns    80104e70 <create+0xf0>
      panic("create dots");
80104ede:	83 ec 0c             	sub    $0xc,%esp
80104ee1:	68 3b 7a 10 80       	push   $0x80107a3b
80104ee6:	e8 95 b4 ff ff       	call   80100380 <panic>
80104eeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ef3:	31 f6                	xor    %esi,%esi
}
80104ef5:	5b                   	pop    %ebx
80104ef6:	89 f0                	mov    %esi,%eax
80104ef8:	5e                   	pop    %esi
80104ef9:	5f                   	pop    %edi
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret
    panic("create: dirlink");
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	68 4a 7a 10 80       	push   $0x80107a4a
80104f04:	e8 77 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	68 2c 7a 10 80       	push   $0x80107a2c
80104f11:	e8 6a b4 ff ff       	call   80100380 <panic>
80104f16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f1d:	00 
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <sys_dup>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	50                   	push   %eax
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 1d fc ff ff       	call   80104b50 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 36                	js     80104f70 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 30                	ja     80104f70 <sys_dup+0x50>
80104f40:	e8 eb eb ff ff       	call   80103b30 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 20                	je     80104f70 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f50:	e8 db eb ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f55:	31 db                	xor    %ebx,%ebx
80104f57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f5e:	00 
80104f5f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104f60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f64:	85 d2                	test   %edx,%edx
80104f66:	74 18                	je     80104f80 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	83 fb 10             	cmp    $0x10,%ebx
80104f6e:	75 f0                	jne    80104f60 <sys_dup+0x40>
}
80104f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f78:	89 d8                	mov    %ebx,%eax
80104f7a:	5b                   	pop    %ebx
80104f7b:	5e                   	pop    %esi
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret
80104f7e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f80:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f83:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f87:	56                   	push   %esi
80104f88:	e8 23 c0 ff ff       	call   80100fb0 <filedup>
  return fd;
80104f8d:	83 c4 10             	add    $0x10,%esp
}
80104f90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f93:	89 d8                	mov    %ebx,%eax
80104f95:	5b                   	pop    %ebx
80104f96:	5e                   	pop    %esi
80104f97:	5d                   	pop    %ebp
80104f98:	c3                   	ret
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <sys_read>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 9d fb ff ff       	call   80104b50 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 5e                	js     80105018 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 58                	ja     80105018 <sys_read+0x78>
80104fc0:	e8 6b eb ff ff       	call   80103b30 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 48                	je     80105018 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	6a 02                	push   $0x2
80104fd9:	e8 72 fb ff ff       	call   80104b50 <argint>
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 33                	js     80105018 <sys_read+0x78>
80104fe5:	83 ec 04             	sub    $0x4,%esp
80104fe8:	ff 75 f0             	push   -0x10(%ebp)
80104feb:	53                   	push   %ebx
80104fec:	6a 01                	push   $0x1
80104fee:	e8 ad fb ff ff       	call   80104ba0 <argptr>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 1e                	js     80105018 <sys_read+0x78>
  return fileread(f, p, n);
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	ff 75 f0             	push   -0x10(%ebp)
80105000:	ff 75 f4             	push   -0xc(%ebp)
80105003:	56                   	push   %esi
80105004:	e8 27 c1 ff ff       	call   80101130 <fileread>
80105009:	83 c4 10             	add    $0x10,%esp
}
8010500c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret
80105013:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ed                	jmp    8010500c <sys_read+0x6c>
8010501f:	90                   	nop

80105020 <sys_write>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	53                   	push   %ebx
8010502c:	6a 00                	push   $0x0
8010502e:	e8 1d fb ff ff       	call   80104b50 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 5e                	js     80105098 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 58                	ja     80105098 <sys_write+0x78>
80105040:	e8 eb ea ff ff       	call   80103b30 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010504c:	85 f6                	test   %esi,%esi
8010504e:	74 48                	je     80105098 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105050:	83 ec 08             	sub    $0x8,%esp
80105053:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105056:	50                   	push   %eax
80105057:	6a 02                	push   $0x2
80105059:	e8 f2 fa ff ff       	call   80104b50 <argint>
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	85 c0                	test   %eax,%eax
80105063:	78 33                	js     80105098 <sys_write+0x78>
80105065:	83 ec 04             	sub    $0x4,%esp
80105068:	ff 75 f0             	push   -0x10(%ebp)
8010506b:	53                   	push   %ebx
8010506c:	6a 01                	push   $0x1
8010506e:	e8 2d fb ff ff       	call   80104ba0 <argptr>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 1e                	js     80105098 <sys_write+0x78>
  return filewrite(f, p, n);
8010507a:	83 ec 04             	sub    $0x4,%esp
8010507d:	ff 75 f0             	push   -0x10(%ebp)
80105080:	ff 75 f4             	push   -0xc(%ebp)
80105083:	56                   	push   %esi
80105084:	e8 37 c1 ff ff       	call   801011c0 <filewrite>
80105089:	83 c4 10             	add    $0x10,%esp
}
8010508c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010508f:	5b                   	pop    %ebx
80105090:	5e                   	pop    %esi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret
80105093:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb ed                	jmp    8010508c <sys_write+0x6c>
8010509f:	90                   	nop

801050a0 <sys_close>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ab:	50                   	push   %eax
801050ac:	6a 00                	push   $0x0
801050ae:	e8 9d fa ff ff       	call   80104b50 <argint>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 3e                	js     801050f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050be:	77 38                	ja     801050f8 <sys_close+0x58>
801050c0:	e8 6b ea ff ff       	call   80103b30 <myproc>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801050cb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801050cf:	85 f6                	test   %esi,%esi
801050d1:	74 25                	je     801050f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050d3:	e8 58 ea ff ff       	call   80103b30 <myproc>
  fileclose(f);
801050d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050db:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050e2:	00 
  fileclose(f);
801050e3:	56                   	push   %esi
801050e4:	e8 17 bf ff ff       	call   80101000 <fileclose>
  return 0;
801050e9:	83 c4 10             	add    $0x10,%esp
801050ec:	31 c0                	xor    %eax,%eax
}
801050ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f1:	5b                   	pop    %ebx
801050f2:	5e                   	pop    %esi
801050f3:	5d                   	pop    %ebp
801050f4:	c3                   	ret
801050f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fd:	eb ef                	jmp    801050ee <sys_close+0x4e>
801050ff:	90                   	nop

80105100 <sys_fstat>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105105:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105108:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010510b:	53                   	push   %ebx
8010510c:	6a 00                	push   $0x0
8010510e:	e8 3d fa ff ff       	call   80104b50 <argint>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 46                	js     80105160 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010511a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010511e:	77 40                	ja     80105160 <sys_fstat+0x60>
80105120:	e8 0b ea ff ff       	call   80103b30 <myproc>
80105125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105128:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010512c:	85 f6                	test   %esi,%esi
8010512e:	74 30                	je     80105160 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105130:	83 ec 04             	sub    $0x4,%esp
80105133:	6a 14                	push   $0x14
80105135:	53                   	push   %ebx
80105136:	6a 01                	push   $0x1
80105138:	e8 63 fa ff ff       	call   80104ba0 <argptr>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	78 1c                	js     80105160 <sys_fstat+0x60>
  return filestat(f, st);
80105144:	83 ec 08             	sub    $0x8,%esp
80105147:	ff 75 f4             	push   -0xc(%ebp)
8010514a:	56                   	push   %esi
8010514b:	e8 90 bf ff ff       	call   801010e0 <filestat>
80105150:	83 c4 10             	add    $0x10,%esp
}
80105153:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105156:	5b                   	pop    %ebx
80105157:	5e                   	pop    %esi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb ec                	jmp    80105153 <sys_fstat+0x53>
80105167:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010516e:	00 
8010516f:	90                   	nop

80105170 <sys_link>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105175:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105178:	53                   	push   %ebx
80105179:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010517c:	50                   	push   %eax
8010517d:	6a 00                	push   $0x0
8010517f:	e8 8c fa ff ff       	call   80104c10 <argstr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	0f 88 fb 00 00 00    	js     8010528a <sys_link+0x11a>
8010518f:	83 ec 08             	sub    $0x8,%esp
80105192:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105195:	50                   	push   %eax
80105196:	6a 01                	push   $0x1
80105198:	e8 73 fa ff ff       	call   80104c10 <argstr>
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	0f 88 e2 00 00 00    	js     8010528a <sys_link+0x11a>
  begin_op();
801051a8:	e8 c3 dc ff ff       	call   80102e70 <begin_op>
  if((ip = namei(old)) == 0){
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	ff 75 d4             	push   -0x2c(%ebp)
801051b3:	e8 f8 cf ff ff       	call   801021b0 <namei>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	89 c3                	mov    %eax,%ebx
801051bd:	85 c0                	test   %eax,%eax
801051bf:	0f 84 e4 00 00 00    	je     801052a9 <sys_link+0x139>
  ilock(ip);
801051c5:	83 ec 0c             	sub    $0xc,%esp
801051c8:	50                   	push   %eax
801051c9:	e8 c2 c6 ff ff       	call   80101890 <ilock>
  if(ip->type == T_DIR){
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d6:	0f 84 b5 00 00 00    	je     80105291 <sys_link+0x121>
  iupdate(ip);
801051dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051e7:	53                   	push   %ebx
801051e8:	e8 f3 c5 ff ff       	call   801017e0 <iupdate>
  iunlock(ip);
801051ed:	89 1c 24             	mov    %ebx,(%esp)
801051f0:	e8 7b c7 ff ff       	call   80101970 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051f5:	58                   	pop    %eax
801051f6:	5a                   	pop    %edx
801051f7:	57                   	push   %edi
801051f8:	ff 75 d0             	push   -0x30(%ebp)
801051fb:	e8 d0 cf ff ff       	call   801021d0 <nameiparent>
80105200:	83 c4 10             	add    $0x10,%esp
80105203:	89 c6                	mov    %eax,%esi
80105205:	85 c0                	test   %eax,%eax
80105207:	74 5b                	je     80105264 <sys_link+0xf4>
  ilock(dp);
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	50                   	push   %eax
8010520d:	e8 7e c6 ff ff       	call   80101890 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105212:	8b 03                	mov    (%ebx),%eax
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	39 06                	cmp    %eax,(%esi)
80105219:	75 3d                	jne    80105258 <sys_link+0xe8>
8010521b:	83 ec 04             	sub    $0x4,%esp
8010521e:	ff 73 04             	push   0x4(%ebx)
80105221:	57                   	push   %edi
80105222:	56                   	push   %esi
80105223:	e8 c8 ce ff ff       	call   801020f0 <dirlink>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	78 29                	js     80105258 <sys_link+0xe8>
  iunlockput(dp);
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	56                   	push   %esi
80105233:	e8 e8 c8 ff ff       	call   80101b20 <iunlockput>
  iput(ip);
80105238:	89 1c 24             	mov    %ebx,(%esp)
8010523b:	e8 80 c7 ff ff       	call   801019c0 <iput>
  end_op();
80105240:	e8 9b dc ff ff       	call   80102ee0 <end_op>
  return 0;
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	31 c0                	xor    %eax,%eax
}
8010524a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010524d:	5b                   	pop    %ebx
8010524e:	5e                   	pop    %esi
8010524f:	5f                   	pop    %edi
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret
80105252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	56                   	push   %esi
8010525c:	e8 bf c8 ff ff       	call   80101b20 <iunlockput>
    goto bad;
80105261:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	53                   	push   %ebx
80105268:	e8 23 c6 ff ff       	call   80101890 <ilock>
  ip->nlink--;
8010526d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105272:	89 1c 24             	mov    %ebx,(%esp)
80105275:	e8 66 c5 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
8010527a:	89 1c 24             	mov    %ebx,(%esp)
8010527d:	e8 9e c8 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105282:	e8 59 dc ff ff       	call   80102ee0 <end_op>
  return -1;
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528f:	eb b9                	jmp    8010524a <sys_link+0xda>
    iunlockput(ip);
80105291:	83 ec 0c             	sub    $0xc,%esp
80105294:	53                   	push   %ebx
80105295:	e8 86 c8 ff ff       	call   80101b20 <iunlockput>
    end_op();
8010529a:	e8 41 dc ff ff       	call   80102ee0 <end_op>
    return -1;
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a7:	eb a1                	jmp    8010524a <sys_link+0xda>
    end_op();
801052a9:	e8 32 dc ff ff       	call   80102ee0 <end_op>
    return -1;
801052ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b3:	eb 95                	jmp    8010524a <sys_link+0xda>
801052b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052bc:	00 
801052bd:	8d 76 00             	lea    0x0(%esi),%esi

801052c0 <sys_unlink>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 3c f9 ff ff       	call   80104c10 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 7a 01 00 00    	js     80105459 <sys_unlink+0x199>
  begin_op();
801052df:	e8 8c db ff ff       	call   80102e70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	53                   	push   %ebx
801052eb:	ff 75 c0             	push   -0x40(%ebp)
801052ee:	e8 dd ce ff ff       	call   801021d0 <nameiparent>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052f9:	85 c0                	test   %eax,%eax
801052fb:	0f 84 62 01 00 00    	je     80105463 <sys_unlink+0x1a3>
  ilock(dp);
80105301:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	57                   	push   %edi
80105308:	e8 83 c5 ff ff       	call   80101890 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010530d:	58                   	pop    %eax
8010530e:	5a                   	pop    %edx
8010530f:	68 48 7a 10 80       	push   $0x80107a48
80105314:	53                   	push   %ebx
80105315:	e8 b6 ca ff ff       	call   80101dd0 <namecmp>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	0f 84 fb 00 00 00    	je     80105420 <sys_unlink+0x160>
80105325:	83 ec 08             	sub    $0x8,%esp
80105328:	68 47 7a 10 80       	push   $0x80107a47
8010532d:	53                   	push   %ebx
8010532e:	e8 9d ca ff ff       	call   80101dd0 <namecmp>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	0f 84 e2 00 00 00    	je     80105420 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010533e:	83 ec 04             	sub    $0x4,%esp
80105341:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105344:	50                   	push   %eax
80105345:	53                   	push   %ebx
80105346:	57                   	push   %edi
80105347:	e8 a4 ca ff ff       	call   80101df0 <dirlookup>
8010534c:	83 c4 10             	add    $0x10,%esp
8010534f:	89 c3                	mov    %eax,%ebx
80105351:	85 c0                	test   %eax,%eax
80105353:	0f 84 c7 00 00 00    	je     80105420 <sys_unlink+0x160>
  ilock(ip);
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	50                   	push   %eax
8010535d:	e8 2e c5 ff ff       	call   80101890 <ilock>
  if(ip->nlink < 1)
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010536a:	0f 8e 1c 01 00 00    	jle    8010548c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105370:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105375:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105378:	74 66                	je     801053e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010537a:	83 ec 04             	sub    $0x4,%esp
8010537d:	6a 10                	push   $0x10
8010537f:	6a 00                	push   $0x0
80105381:	57                   	push   %edi
80105382:	e8 09 f5 ff ff       	call   80104890 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105387:	6a 10                	push   $0x10
80105389:	ff 75 c4             	push   -0x3c(%ebp)
8010538c:	57                   	push   %edi
8010538d:	ff 75 b4             	push   -0x4c(%ebp)
80105390:	e8 0b c9 ff ff       	call   80101ca0 <writei>
80105395:	83 c4 20             	add    $0x20,%esp
80105398:	83 f8 10             	cmp    $0x10,%eax
8010539b:	0f 85 de 00 00 00    	jne    8010547f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053a6:	0f 84 94 00 00 00    	je     80105440 <sys_unlink+0x180>
  iunlockput(dp);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	ff 75 b4             	push   -0x4c(%ebp)
801053b2:	e8 69 c7 ff ff       	call   80101b20 <iunlockput>
  ip->nlink--;
801053b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053bc:	89 1c 24             	mov    %ebx,(%esp)
801053bf:	e8 1c c4 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
801053c4:	89 1c 24             	mov    %ebx,(%esp)
801053c7:	e8 54 c7 ff ff       	call   80101b20 <iunlockput>
  end_op();
801053cc:	e8 0f db ff ff       	call   80102ee0 <end_op>
  return 0;
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	31 c0                	xor    %eax,%eax
}
801053d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d9:	5b                   	pop    %ebx
801053da:	5e                   	pop    %esi
801053db:	5f                   	pop    %edi
801053dc:	5d                   	pop    %ebp
801053dd:	c3                   	ret
801053de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053e4:	76 94                	jbe    8010537a <sys_unlink+0xba>
801053e6:	be 20 00 00 00       	mov    $0x20,%esi
801053eb:	eb 0b                	jmp    801053f8 <sys_unlink+0x138>
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
801053f0:	83 c6 10             	add    $0x10,%esi
801053f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053f6:	73 82                	jae    8010537a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053f8:	6a 10                	push   $0x10
801053fa:	56                   	push   %esi
801053fb:	57                   	push   %edi
801053fc:	53                   	push   %ebx
801053fd:	e8 9e c7 ff ff       	call   80101ba0 <readi>
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	83 f8 10             	cmp    $0x10,%eax
80105408:	75 68                	jne    80105472 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010540a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010540f:	74 df                	je     801053f0 <sys_unlink+0x130>
    iunlockput(ip);
80105411:	83 ec 0c             	sub    $0xc,%esp
80105414:	53                   	push   %ebx
80105415:	e8 06 c7 ff ff       	call   80101b20 <iunlockput>
    goto bad;
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	ff 75 b4             	push   -0x4c(%ebp)
80105426:	e8 f5 c6 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010542b:	e8 b0 da ff ff       	call   80102ee0 <end_op>
  return -1;
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105438:	eb 9c                	jmp    801053d6 <sys_unlink+0x116>
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105440:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105443:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105446:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010544b:	50                   	push   %eax
8010544c:	e8 8f c3 ff ff       	call   801017e0 <iupdate>
80105451:	83 c4 10             	add    $0x10,%esp
80105454:	e9 53 ff ff ff       	jmp    801053ac <sys_unlink+0xec>
    return -1;
80105459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545e:	e9 73 ff ff ff       	jmp    801053d6 <sys_unlink+0x116>
    end_op();
80105463:	e8 78 da ff ff       	call   80102ee0 <end_op>
    return -1;
80105468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546d:	e9 64 ff ff ff       	jmp    801053d6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105472:	83 ec 0c             	sub    $0xc,%esp
80105475:	68 6c 7a 10 80       	push   $0x80107a6c
8010547a:	e8 01 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	68 7e 7a 10 80       	push   $0x80107a7e
80105487:	e8 f4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 5a 7a 10 80       	push   $0x80107a5a
80105494:	e8 e7 ae ff ff       	call   80100380 <panic>
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_open>:

int
sys_open(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054a8:	53                   	push   %ebx
801054a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ac:	50                   	push   %eax
801054ad:	6a 00                	push   $0x0
801054af:	e8 5c f7 ff ff       	call   80104c10 <argstr>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	0f 88 8e 00 00 00    	js     8010554d <sys_open+0xad>
801054bf:	83 ec 08             	sub    $0x8,%esp
801054c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054c5:	50                   	push   %eax
801054c6:	6a 01                	push   $0x1
801054c8:	e8 83 f6 ff ff       	call   80104b50 <argint>
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	85 c0                	test   %eax,%eax
801054d2:	78 79                	js     8010554d <sys_open+0xad>
    return -1;

  begin_op();
801054d4:	e8 97 d9 ff ff       	call   80102e70 <begin_op>

  if(omode & O_CREATE){
801054d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054dd:	75 79                	jne    80105558 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054df:	83 ec 0c             	sub    $0xc,%esp
801054e2:	ff 75 e0             	push   -0x20(%ebp)
801054e5:	e8 c6 cc ff ff       	call   801021b0 <namei>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	89 c6                	mov    %eax,%esi
801054ef:	85 c0                	test   %eax,%eax
801054f1:	0f 84 7e 00 00 00    	je     80105575 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054f7:	83 ec 0c             	sub    $0xc,%esp
801054fa:	50                   	push   %eax
801054fb:	e8 90 c3 ff ff       	call   80101890 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105500:	83 c4 10             	add    $0x10,%esp
80105503:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105508:	0f 84 c2 00 00 00    	je     801055d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010550e:	e8 2d ba ff ff       	call   80100f40 <filealloc>
80105513:	89 c7                	mov    %eax,%edi
80105515:	85 c0                	test   %eax,%eax
80105517:	74 23                	je     8010553c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105519:	e8 12 e6 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010551e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105520:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105524:	85 d2                	test   %edx,%edx
80105526:	74 60                	je     80105588 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105528:	83 c3 01             	add    $0x1,%ebx
8010552b:	83 fb 10             	cmp    $0x10,%ebx
8010552e:	75 f0                	jne    80105520 <sys_open+0x80>
    if(f)
      fileclose(f);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	57                   	push   %edi
80105534:	e8 c7 ba ff ff       	call   80101000 <fileclose>
80105539:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	56                   	push   %esi
80105540:	e8 db c5 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105545:	e8 96 d9 ff ff       	call   80102ee0 <end_op>
    return -1;
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105552:	eb 6d                	jmp    801055c1 <sys_open+0x121>
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010555e:	31 c9                	xor    %ecx,%ecx
80105560:	ba 02 00 00 00       	mov    $0x2,%edx
80105565:	6a 00                	push   $0x0
80105567:	e8 14 f8 ff ff       	call   80104d80 <create>
    if(ip == 0){
8010556c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010556f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105571:	85 c0                	test   %eax,%eax
80105573:	75 99                	jne    8010550e <sys_open+0x6e>
      end_op();
80105575:	e8 66 d9 ff ff       	call   80102ee0 <end_op>
      return -1;
8010557a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010557f:	eb 40                	jmp    801055c1 <sys_open+0x121>
80105581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105588:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010558b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010558f:	56                   	push   %esi
80105590:	e8 db c3 ff ff       	call   80101970 <iunlock>
  end_op();
80105595:	e8 46 d9 ff ff       	call   80102ee0 <end_op>

  f->type = FD_INODE;
8010559a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055b2:	f7 d0                	not    %eax
801055b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c4:	89 d8                	mov    %ebx,%eax
801055c6:	5b                   	pop    %ebx
801055c7:	5e                   	pop    %esi
801055c8:	5f                   	pop    %edi
801055c9:	5d                   	pop    %ebp
801055ca:	c3                   	ret
801055cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055d3:	85 c9                	test   %ecx,%ecx
801055d5:	0f 84 33 ff ff ff    	je     8010550e <sys_open+0x6e>
801055db:	e9 5c ff ff ff       	jmp    8010553c <sys_open+0x9c>

801055e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055e6:	e8 85 d8 ff ff       	call   80102e70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f1:	50                   	push   %eax
801055f2:	6a 00                	push   $0x0
801055f4:	e8 17 f6 ff ff       	call   80104c10 <argstr>
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	85 c0                	test   %eax,%eax
801055fe:	78 30                	js     80105630 <sys_mkdir+0x50>
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105606:	31 c9                	xor    %ecx,%ecx
80105608:	ba 01 00 00 00       	mov    $0x1,%edx
8010560d:	6a 00                	push   $0x0
8010560f:	e8 6c f7 ff ff       	call   80104d80 <create>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	85 c0                	test   %eax,%eax
80105619:	74 15                	je     80105630 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010561b:	83 ec 0c             	sub    $0xc,%esp
8010561e:	50                   	push   %eax
8010561f:	e8 fc c4 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105624:	e8 b7 d8 ff ff       	call   80102ee0 <end_op>
  return 0;
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	31 c0                	xor    %eax,%eax
}
8010562e:	c9                   	leave
8010562f:	c3                   	ret
    end_op();
80105630:	e8 ab d8 ff ff       	call   80102ee0 <end_op>
    return -1;
80105635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010563a:	c9                   	leave
8010563b:	c3                   	ret
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_mknod>:

int
sys_mknod(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105646:	e8 25 d8 ff ff       	call   80102e70 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010564b:	83 ec 08             	sub    $0x8,%esp
8010564e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105651:	50                   	push   %eax
80105652:	6a 00                	push   $0x0
80105654:	e8 b7 f5 ff ff       	call   80104c10 <argstr>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	85 c0                	test   %eax,%eax
8010565e:	78 60                	js     801056c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105660:	83 ec 08             	sub    $0x8,%esp
80105663:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105666:	50                   	push   %eax
80105667:	6a 01                	push   $0x1
80105669:	e8 e2 f4 ff ff       	call   80104b50 <argint>
  if((argstr(0, &path)) < 0 ||
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	78 4b                	js     801056c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105675:	83 ec 08             	sub    $0x8,%esp
80105678:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567b:	50                   	push   %eax
8010567c:	6a 02                	push   $0x2
8010567e:	e8 cd f4 ff ff       	call   80104b50 <argint>
     argint(1, &major) < 0 ||
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	85 c0                	test   %eax,%eax
80105688:	78 36                	js     801056c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010568a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010568e:	83 ec 0c             	sub    $0xc,%esp
80105691:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105695:	ba 03 00 00 00       	mov    $0x3,%edx
8010569a:	50                   	push   %eax
8010569b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010569e:	e8 dd f6 ff ff       	call   80104d80 <create>
     argint(2, &minor) < 0 ||
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	74 16                	je     801056c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	50                   	push   %eax
801056ae:	e8 6d c4 ff ff       	call   80101b20 <iunlockput>
  end_op();
801056b3:	e8 28 d8 ff ff       	call   80102ee0 <end_op>
  return 0;
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	31 c0                	xor    %eax,%eax
}
801056bd:	c9                   	leave
801056be:	c3                   	ret
801056bf:	90                   	nop
    end_op();
801056c0:	e8 1b d8 ff ff       	call   80102ee0 <end_op>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ca:	c9                   	leave
801056cb:	c3                   	ret
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_chdir>:

int
sys_chdir(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	56                   	push   %esi
801056d4:	53                   	push   %ebx
801056d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056d8:	e8 53 e4 ff ff       	call   80103b30 <myproc>
801056dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056df:	e8 8c d7 ff ff       	call   80102e70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ea:	50                   	push   %eax
801056eb:	6a 00                	push   $0x0
801056ed:	e8 1e f5 ff ff       	call   80104c10 <argstr>
801056f2:	83 c4 10             	add    $0x10,%esp
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 77                	js     80105770 <sys_chdir+0xa0>
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	ff 75 f4             	push   -0xc(%ebp)
801056ff:	e8 ac ca ff ff       	call   801021b0 <namei>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	89 c3                	mov    %eax,%ebx
80105709:	85 c0                	test   %eax,%eax
8010570b:	74 63                	je     80105770 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	50                   	push   %eax
80105711:	e8 7a c1 ff ff       	call   80101890 <ilock>
  if(ip->type != T_DIR){
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010571e:	75 30                	jne    80105750 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 47 c2 ff ff       	call   80101970 <iunlock>
  iput(curproc->cwd);
80105729:	58                   	pop    %eax
8010572a:	ff 76 68             	push   0x68(%esi)
8010572d:	e8 8e c2 ff ff       	call   801019c0 <iput>
  end_op();
80105732:	e8 a9 d7 ff ff       	call   80102ee0 <end_op>
  curproc->cwd = ip;
80105737:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	31 c0                	xor    %eax,%eax
}
8010573f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105742:	5b                   	pop    %ebx
80105743:	5e                   	pop    %esi
80105744:	5d                   	pop    %ebp
80105745:	c3                   	ret
80105746:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010574d:	00 
8010574e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	53                   	push   %ebx
80105754:	e8 c7 c3 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105759:	e8 82 d7 ff ff       	call   80102ee0 <end_op>
    return -1;
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105766:	eb d7                	jmp    8010573f <sys_chdir+0x6f>
80105768:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010576f:	00 
    end_op();
80105770:	e8 6b d7 ff ff       	call   80102ee0 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577a:	eb c3                	jmp    8010573f <sys_chdir+0x6f>
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_exec>:

int
sys_exec(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105785:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010578b:	53                   	push   %ebx
8010578c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105792:	50                   	push   %eax
80105793:	6a 00                	push   $0x0
80105795:	e8 76 f4 ff ff       	call   80104c10 <argstr>
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	85 c0                	test   %eax,%eax
8010579f:	0f 88 87 00 00 00    	js     8010582c <sys_exec+0xac>
801057a5:	83 ec 08             	sub    $0x8,%esp
801057a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057ae:	50                   	push   %eax
801057af:	6a 01                	push   $0x1
801057b1:	e8 9a f3 ff ff       	call   80104b50 <argint>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 6f                	js     8010582c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057bd:	83 ec 04             	sub    $0x4,%esp
801057c0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801057c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057c8:	68 80 00 00 00       	push   $0x80
801057cd:	6a 00                	push   $0x0
801057cf:	56                   	push   %esi
801057d0:	e8 bb f0 ff ff       	call   80104890 <memset>
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057df:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057e0:	83 ec 08             	sub    $0x8,%esp
801057e3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057e9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057f0:	50                   	push   %eax
801057f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057f7:	01 f8                	add    %edi,%eax
801057f9:	50                   	push   %eax
801057fa:	e8 c1 f2 ff ff       	call   80104ac0 <fetchint>
801057ff:	83 c4 10             	add    $0x10,%esp
80105802:	85 c0                	test   %eax,%eax
80105804:	78 26                	js     8010582c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105806:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010580c:	85 c0                	test   %eax,%eax
8010580e:	74 30                	je     80105840 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105810:	83 ec 08             	sub    $0x8,%esp
80105813:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105816:	52                   	push   %edx
80105817:	50                   	push   %eax
80105818:	e8 e3 f2 ff ff       	call   80104b00 <fetchstr>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 08                	js     8010582c <sys_exec+0xac>
  for(i=0;; i++){
80105824:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105827:	83 fb 20             	cmp    $0x20,%ebx
8010582a:	75 b4                	jne    801057e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010582c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010582f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
80105838:	c3                   	ret
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105840:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105847:	00 00 00 00 
  return exec(path, argv);
8010584b:	83 ec 08             	sub    $0x8,%esp
8010584e:	56                   	push   %esi
8010584f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105855:	e8 56 b2 ff ff       	call   80100ab0 <exec>
8010585a:	83 c4 10             	add    $0x10,%esp
}
8010585d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105860:	5b                   	pop    %ebx
80105861:	5e                   	pop    %esi
80105862:	5f                   	pop    %edi
80105863:	5d                   	pop    %ebp
80105864:	c3                   	ret
80105865:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010586c:	00 
8010586d:	8d 76 00             	lea    0x0(%esi),%esi

80105870 <sys_pipe>:

int
sys_pipe(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105875:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105878:	53                   	push   %ebx
80105879:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010587c:	6a 08                	push   $0x8
8010587e:	50                   	push   %eax
8010587f:	6a 00                	push   $0x0
80105881:	e8 1a f3 ff ff       	call   80104ba0 <argptr>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	78 4a                	js     801058d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010588d:	83 ec 08             	sub    $0x8,%esp
80105890:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105893:	50                   	push   %eax
80105894:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105897:	50                   	push   %eax
80105898:	e8 a3 dc ff ff       	call   80103540 <pipealloc>
8010589d:	83 c4 10             	add    $0x10,%esp
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 33                	js     801058d7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058a7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058a9:	e8 82 e2 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058b4:	85 f6                	test   %esi,%esi
801058b6:	74 28                	je     801058e0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058b8:	83 c3 01             	add    $0x1,%ebx
801058bb:	83 fb 10             	cmp    $0x10,%ebx
801058be:	75 f0                	jne    801058b0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	ff 75 e0             	push   -0x20(%ebp)
801058c6:	e8 35 b7 ff ff       	call   80101000 <fileclose>
    fileclose(wf);
801058cb:	58                   	pop    %eax
801058cc:	ff 75 e4             	push   -0x1c(%ebp)
801058cf:	e8 2c b7 ff ff       	call   80101000 <fileclose>
    return -1;
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dc:	eb 53                	jmp    80105931 <sys_pipe+0xc1>
801058de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058e0:	8d 73 08             	lea    0x8(%ebx),%esi
801058e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ea:	e8 41 e2 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ef:	31 d2                	xor    %edx,%edx
801058f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058fc:	85 c9                	test   %ecx,%ecx
801058fe:	74 20                	je     80105920 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105900:	83 c2 01             	add    $0x1,%edx
80105903:	83 fa 10             	cmp    $0x10,%edx
80105906:	75 f0                	jne    801058f8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105908:	e8 23 e2 ff ff       	call   80103b30 <myproc>
8010590d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105914:	00 
80105915:	eb a9                	jmp    801058c0 <sys_pipe+0x50>
80105917:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010591e:	00 
8010591f:	90                   	nop
      curproc->ofile[fd] = f;
80105920:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105924:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105927:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105929:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010592c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010592f:	31 c0                	xor    %eax,%eax
}
80105931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105934:	5b                   	pop    %ebx
80105935:	5e                   	pop    %esi
80105936:	5f                   	pop    %edi
80105937:	5d                   	pop    %ebp
80105938:	c3                   	ret
80105939:	66 90                	xchg   %ax,%ax
8010593b:	66 90                	xchg   %ax,%ax
8010593d:	66 90                	xchg   %ax,%ax
8010593f:	90                   	nop

80105940 <sys_fork>:

int blocked_syscalls[MAX_SYSCALLS] = {0};  // Global kernel-side tracking


int sys_fork(void) {
    return fork();
80105940:	e9 8b e3 ff ff       	jmp    80103cd0 <fork>
80105945:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010594c:	00 
8010594d:	8d 76 00             	lea    0x0(%esi),%esi

80105950 <sys_exit>:
}

int sys_exit(void) {
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 08             	sub    $0x8,%esp
    exit();
80105956:	e8 f5 e5 ff ff       	call   80103f50 <exit>
    return 0;  // not reached
}
8010595b:	31 c0                	xor    %eax,%eax
8010595d:	c9                   	leave
8010595e:	c3                   	ret
8010595f:	90                   	nop

80105960 <sys_wait>:

int sys_wait(void) {
    return wait();
80105960:	e9 8b e7 ff ff       	jmp    801040f0 <wait>
80105965:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010596c:	00 
8010596d:	8d 76 00             	lea    0x0(%esi),%esi

80105970 <sys_kill>:
}

int sys_kill(void) {
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 20             	sub    $0x20,%esp
    int pid;
    if(argint(0, &pid) < 0)
80105976:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105979:	50                   	push   %eax
8010597a:	6a 00                	push   $0x0
8010597c:	e8 cf f1 ff ff       	call   80104b50 <argint>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	85 c0                	test   %eax,%eax
80105986:	78 18                	js     801059a0 <sys_kill+0x30>
        return -1;
    return kill(pid);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	ff 75 f4             	push   -0xc(%ebp)
8010598e:	e8 fd e9 ff ff       	call   80104390 <kill>
80105993:	83 c4 10             	add    $0x10,%esp
}
80105996:	c9                   	leave
80105997:	c3                   	ret
80105998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599f:	00 
801059a0:	c9                   	leave
        return -1;
801059a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059a6:	c3                   	ret
801059a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ae:	00 
801059af:	90                   	nop

801059b0 <sys_getpid>:

int sys_getpid(void) {
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
801059b6:	e8 75 e1 ff ff       	call   80103b30 <myproc>
801059bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059be:	c9                   	leave
801059bf:	c3                   	ret

801059c0 <sys_sbrk>:
//     release(&ptable.lock);
    
//     return addr;
// }

int sys_sbrk(void) {
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	57                   	push   %edi
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
801059c6:	83 ec 2c             	sub    $0x2c,%esp
    int addr;
    int n;
    struct proc *curproc = myproc();
801059c9:	e8 62 e1 ff ff       	call   80103b30 <myproc>

    if(argint(0, &n) < 0)
801059ce:	83 ec 08             	sub    $0x8,%esp
    struct proc *curproc = myproc();
801059d1:	89 c3                	mov    %eax,%ebx
    if(argint(0, &n) < 0)
801059d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059d6:	50                   	push   %eax
801059d7:	6a 00                	push   $0x0
801059d9:	e8 72 f1 ff ff       	call   80104b50 <argint>
801059de:	83 c4 10             	add    $0x10,%esp
801059e1:	85 c0                	test   %eax,%eax
801059e3:	0f 88 b5 00 00 00    	js     80105a9e <sys_sbrk+0xde>
        return -1;

    addr = curproc->sz;
801059e9:	8b 33                	mov    (%ebx),%esi

    if(growproc(n) < 0)
801059eb:	83 ec 0c             	sub    $0xc,%esp
801059ee:	ff 75 e4             	push   -0x1c(%ebp)
    addr = curproc->sz;
801059f1:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    if(growproc(n) < 0)
801059f4:	e8 57 e2 ff ff       	call   80103c50 <growproc>
801059f9:	83 c4 10             	add    $0x10,%esp
801059fc:	85 c0                	test   %eax,%eax
801059fe:	0f 88 9a 00 00 00    	js     80105a9e <sys_sbrk+0xde>
        return -1;

    // Wait for memory to be actually allocated
    int max_wait_cycles = 100000; // Avoid infinite loop
    while (curproc->sz == addr && max_wait_cycles > 0) {
80105a04:	8b 03                	mov    (%ebx),%eax
80105a06:	39 c6                	cmp    %eax,%esi
80105a08:	75 7b                	jne    80105a85 <sys_sbrk+0xc5>
        max_wait_cycles--;
    }

    if (curproc->sz == addr) {
        cprintf("sys_sbrk: Warning - Memory allocation did not reflect in time!\n");
80105a0a:	83 ec 0c             	sub    $0xc,%esp
80105a0d:	68 84 7c 10 80       	push   $0x80107c84
80105a12:	e8 89 ac ff ff       	call   801006a0 <cprintf>
80105a17:	83 c4 10             	add    $0x10,%esp
    } else {
        cprintf("sys_sbrk: Memory size increased from %d to %d\n", addr, curproc->sz);
    }

    // Update only memory, do not overwrite name
    acquire(&ptable.lock);
80105a1a:	83 ec 0c             	sub    $0xc,%esp
80105a1d:	68 20 2d 11 80       	push   $0x80112d20
80105a22:	e8 a9 ed ff ff       	call   801047d0 <acquire>
    for (int i = 0; i < history_count; i++) {
80105a27:	8b 0d 58 4c 11 80    	mov    0x80114c58,%ecx
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	85 c9                	test   %ecx,%ecx
80105a32:	7e 36                	jle    80105a6a <sys_sbrk+0xaa>
        if (process_history[i].pid == curproc->pid) {
80105a34:	8b 7b 10             	mov    0x10(%ebx),%edi
    for (int i = 0; i < history_count; i++) {
80105a37:	31 c0                	xor    %eax,%eax
80105a39:	eb 0c                	jmp    80105a47 <sys_sbrk+0x87>
80105a3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a40:	83 c0 01             	add    $0x1,%eax
80105a43:	39 c1                	cmp    %eax,%ecx
80105a45:	74 23                	je     80105a6a <sys_sbrk+0xaa>
        if (process_history[i].pid == curproc->pid) {
80105a47:	8d 14 40             	lea    (%eax,%eax,2),%edx
80105a4a:	8d 34 d5 00 00 00 00 	lea    0x0(,%edx,8),%esi
80105a51:	39 3c d5 60 4c 11 80 	cmp    %edi,-0x7feeb3a0(,%edx,8)
80105a58:	75 e6                	jne    80105a40 <sys_sbrk+0x80>
            // process_history[i].mem_usage = curproc->sz;
            if(curproc->sz > process_history[i].mem_usage) {
80105a5a:	8b 03                	mov    (%ebx),%eax
80105a5c:	3b 86 74 4c 11 80    	cmp    -0x7feeb38c(%esi),%eax
80105a62:	76 06                	jbe    80105a6a <sys_sbrk+0xaa>
                process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
80105a64:	89 86 74 4c 11 80    	mov    %eax,-0x7feeb38c(%esi)
            }
            break;
        }
    }
    release(&ptable.lock);
80105a6a:	83 ec 0c             	sub    $0xc,%esp
80105a6d:	68 20 2d 11 80       	push   $0x80112d20
80105a72:	e8 f9 ec ff ff       	call   80104770 <release>

    return addr;
80105a77:	83 c4 10             	add    $0x10,%esp
}
80105a7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a80:	5b                   	pop    %ebx
80105a81:	5e                   	pop    %esi
80105a82:	5f                   	pop    %edi
80105a83:	5d                   	pop    %ebp
80105a84:	c3                   	ret
        cprintf("sys_sbrk: Memory size increased from %d to %d\n", addr, curproc->sz);
80105a85:	83 ec 04             	sub    $0x4,%esp
80105a88:	50                   	push   %eax
80105a89:	ff 75 d4             	push   -0x2c(%ebp)
80105a8c:	68 c4 7c 10 80       	push   $0x80107cc4
80105a91:	e8 0a ac ff ff       	call   801006a0 <cprintf>
80105a96:	83 c4 10             	add    $0x10,%esp
80105a99:	e9 7c ff ff ff       	jmp    80105a1a <sys_sbrk+0x5a>
        return -1;
80105a9e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
80105aa5:	eb d3                	jmp    80105a7a <sys_sbrk+0xba>
80105aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aae:	00 
80105aaf:	90                   	nop

80105ab0 <sys_sleep>:


int sys_sleep(void) {
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	53                   	push   %ebx
    int n;
    uint ticks0;
    if(argint(0, &n) < 0)
80105ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80105ab7:	83 ec 1c             	sub    $0x1c,%esp
    if(argint(0, &n) < 0)
80105aba:	50                   	push   %eax
80105abb:	6a 00                	push   $0x0
80105abd:	e8 8e f0 ff ff       	call   80104b50 <argint>
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	0f 88 8a 00 00 00    	js     80105b57 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	68 00 4e 11 80       	push   $0x80114e00
80105ad5:	e8 f6 ec ff ff       	call   801047d0 <acquire>
    ticks0 = ticks;
    while(ticks - ticks0 < n) {
80105ada:	8b 55 f4             	mov    -0xc(%ebp),%edx
    ticks0 = ticks;
80105add:	8b 1d e0 4d 11 80    	mov    0x80114de0,%ebx
    while(ticks - ticks0 < n) {
80105ae3:	83 c4 10             	add    $0x10,%esp
80105ae6:	85 d2                	test   %edx,%edx
80105ae8:	75 27                	jne    80105b11 <sys_sleep+0x61>
80105aea:	eb 54                	jmp    80105b40 <sys_sleep+0x90>
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105af0:	83 ec 08             	sub    $0x8,%esp
80105af3:	68 00 4e 11 80       	push   $0x80114e00
80105af8:	68 e0 4d 11 80       	push   $0x80114de0
80105afd:	e8 6e e7 ff ff       	call   80104270 <sleep>
    while(ticks - ticks0 < n) {
80105b02:	a1 e0 4d 11 80       	mov    0x80114de0,%eax
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	29 d8                	sub    %ebx,%eax
80105b0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b0f:	73 2f                	jae    80105b40 <sys_sleep+0x90>
        if(myproc()->killed) {
80105b11:	e8 1a e0 ff ff       	call   80103b30 <myproc>
80105b16:	8b 40 24             	mov    0x24(%eax),%eax
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	74 d3                	je     80105af0 <sys_sleep+0x40>
            release(&tickslock);
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	68 00 4e 11 80       	push   $0x80114e00
80105b25:	e8 46 ec ff ff       	call   80104770 <release>
    }
    release(&tickslock);
    return 0;
}
80105b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return -1;
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b35:	c9                   	leave
80105b36:	c3                   	ret
80105b37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b3e:	00 
80105b3f:	90                   	nop
    release(&tickslock);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	68 00 4e 11 80       	push   $0x80114e00
80105b48:	e8 23 ec ff ff       	call   80104770 <release>
    return 0;
80105b4d:	83 c4 10             	add    $0x10,%esp
80105b50:	31 c0                	xor    %eax,%eax
}
80105b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b55:	c9                   	leave
80105b56:	c3                   	ret
        return -1;
80105b57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5c:	eb f4                	jmp    80105b52 <sys_sleep+0xa2>
80105b5e:	66 90                	xchg   %ax,%ax

80105b60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	53                   	push   %ebx
80105b64:	83 ec 10             	sub    $0x10,%esp
    uint xticks;
    acquire(&tickslock);
80105b67:	68 00 4e 11 80       	push   $0x80114e00
80105b6c:	e8 5f ec ff ff       	call   801047d0 <acquire>
    xticks = ticks;
80105b71:	8b 1d e0 4d 11 80    	mov    0x80114de0,%ebx
    release(&tickslock);
80105b77:	c7 04 24 00 4e 11 80 	movl   $0x80114e00,(%esp)
80105b7e:	e8 ed eb ff ff       	call   80104770 <release>
    return xticks;
}
80105b83:	89 d8                	mov    %ebx,%eax
80105b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b88:	c9                   	leave
80105b89:	c3                   	ret
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b90 <sys_gethistory>:

// System call to get process history
int sys_gethistory(void) {
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
    struct history_entry *hist_buf;
    int max_entries;

    // Get arguments from user space
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105b95:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_gethistory(void) {
80105b98:	53                   	push   %ebx
80105b99:	83 ec 30             	sub    $0x30,%esp
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105b9c:	6a 18                	push   $0x18
80105b9e:	50                   	push   %eax
80105b9f:	6a 00                	push   $0x0
80105ba1:	e8 fa ef ff ff       	call   80104ba0 <argptr>
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	0f 88 df 00 00 00    	js     80105c90 <sys_gethistory+0x100>
        argint(1, &max_entries) < 0) {
80105bb1:	83 ec 08             	sub    $0x8,%esp
80105bb4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bb7:	50                   	push   %eax
80105bb8:	6a 01                	push   $0x1
80105bba:	e8 91 ef ff ff       	call   80104b50 <argint>
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	85 c0                	test   %eax,%eax
80105bc4:	0f 88 c6 00 00 00    	js     80105c90 <sys_gethistory+0x100>
        return -1;  // Invalid arguments
    }

    acquire(&ptable.lock);
80105bca:	83 ec 0c             	sub    $0xc,%esp
80105bcd:	68 20 2d 11 80       	push   $0x80112d20
80105bd2:	e8 f9 eb ff ff       	call   801047d0 <acquire>

    // Return only the most recent `max_entries` from history
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105bd7:	a1 58 4c 11 80       	mov    0x80114c58,%eax
80105bdc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105bdf:	39 d0                	cmp    %edx,%eax
80105be1:	89 d7                	mov    %edx,%edi
80105be3:	0f 4e f8             	cmovle %eax,%edi
    int start = (history_count < MAX_HISTORY) ? 0 : history_index;  // Start index
80105be6:	31 db                	xor    %ebx,%ebx
80105be8:	83 c4 10             	add    $0x10,%esp
80105beb:	83 f8 09             	cmp    $0x9,%eax
80105bee:	0f 4f 1d 54 4c 11 80 	cmovg  0x80114c54,%ebx
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105bf5:	89 7d d0             	mov    %edi,-0x30(%ebp)

    for (int i = 0; i < copy_count; i++) {
80105bf8:	85 ff                	test   %edi,%edi
80105bfa:	7e 79                	jle    80105c75 <sys_gethistory+0xe5>
80105bfc:	8b 45 d0             	mov    -0x30(%ebp),%eax
        int index = (start + i) % MAX_HISTORY;
        hist_buf[i].pid = process_history[index].pid;
80105bff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105c02:	31 f6                	xor    %esi,%esi
80105c04:	01 d8                	add    %ebx,%eax
80105c06:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        int index = (start + i) % MAX_HISTORY;
80105c10:	b8 67 66 66 66       	mov    $0x66666667,%eax
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105c15:	83 ec 04             	sub    $0x4,%esp
        int index = (start + i) % MAX_HISTORY;
80105c18:	f7 eb                	imul   %ebx
80105c1a:	89 d8                	mov    %ebx,%eax
80105c1c:	c1 f8 1f             	sar    $0x1f,%eax
80105c1f:	c1 fa 02             	sar    $0x2,%edx
80105c22:	29 c2                	sub    %eax,%edx
80105c24:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105c27:	89 da                	mov    %ebx,%edx
    for (int i = 0; i < copy_count; i++) {
80105c29:	83 c3 01             	add    $0x1,%ebx
        int index = (start + i) % MAX_HISTORY;
80105c2c:	01 c0                	add    %eax,%eax
80105c2e:	29 c2                	sub    %eax,%edx
        hist_buf[i].pid = process_history[index].pid;
80105c30:	8d 14 52             	lea    (%edx,%edx,2),%edx
80105c33:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80105c3a:	8b 14 d5 60 4c 11 80 	mov    -0x7feeb3a0(,%edx,8),%edx
80105c41:	8d b8 60 4c 11 80    	lea    -0x7feeb3a0(%eax),%edi
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105c47:	05 64 4c 11 80       	add    $0x80114c64,%eax
        hist_buf[i].pid = process_history[index].pid;
80105c4c:	89 14 31             	mov    %edx,(%ecx,%esi,1)
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105c4f:	6a 10                	push   $0x10
80105c51:	50                   	push   %eax
80105c52:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c55:	01 f0                	add    %esi,%eax
80105c57:	83 c0 04             	add    $0x4,%eax
80105c5a:	50                   	push   %eax
80105c5b:	e8 f0 ed ff ff       	call   80104a50 <safestrcpy>
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105c60:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105c63:	8b 47 14             	mov    0x14(%edi),%eax
    for (int i = 0; i < copy_count; i++) {
80105c66:	83 c4 10             	add    $0x10,%esp
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105c69:	89 44 31 14          	mov    %eax,0x14(%ecx,%esi,1)
    for (int i = 0; i < copy_count; i++) {
80105c6d:	83 c6 18             	add    $0x18,%esi
80105c70:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
80105c73:	75 9b                	jne    80105c10 <sys_gethistory+0x80>
    }

    release(&ptable.lock);
80105c75:	83 ec 0c             	sub    $0xc,%esp
80105c78:	68 20 2d 11 80       	push   $0x80112d20
80105c7d:	e8 ee ea ff ff       	call   80104770 <release>
    return copy_count;  // Return number of processes copied
80105c82:	83 c4 10             	add    $0x10,%esp
}
80105c85:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c8b:	5b                   	pop    %ebx
80105c8c:	5e                   	pop    %esi
80105c8d:	5f                   	pop    %edi
80105c8e:	5d                   	pop    %ebp
80105c8f:	c3                   	ret
        return -1;  // Invalid arguments
80105c90:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
80105c97:	eb ec                	jmp    80105c85 <sys_gethistory+0xf5>
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ca0 <sys_block>:
//         return 0;
//     }

//     return -1;
// }
int sys_block(void) {
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 20             	sub    $0x20,%esp
    int syscall_id;
    if (argint(0, &syscall_id) < 0) 
80105ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ca9:	50                   	push   %eax
80105caa:	6a 00                	push   $0x0
80105cac:	e8 9f ee ff ff       	call   80104b50 <argint>
80105cb1:	83 c4 10             	add    $0x10,%esp
80105cb4:	85 c0                	test   %eax,%eax
80105cb6:	78 28                	js     80105ce0 <sys_block+0x40>
        return -1;
    
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbb:	83 f8 18             	cmp    $0x18,%eax
80105cbe:	77 20                	ja     80105ce0 <sys_block+0x40>
        return -1;

    // Prevent blocking critical system calls
    if (syscall_id == SYS_fork || syscall_id == SYS_exit || syscall_id == SYS_unblock) {
80105cc0:	8d 50 ff             	lea    -0x1(%eax),%edx
80105cc3:	83 fa 01             	cmp    $0x1,%edx
80105cc6:	76 18                	jbe    80105ce0 <sys_block+0x40>
80105cc8:	83 f8 18             	cmp    $0x18,%eax
80105ccb:	74 13                	je     80105ce0 <sys_block+0x40>
        return -1;
    }

    blocked_syscalls[syscall_id] = 1;  // Store in the kernel
80105ccd:	c7 04 85 60 4d 11 80 	movl   $0x1,-0x7feeb2a0(,%eax,4)
80105cd4:	01 00 00 00 
    return 0;
80105cd8:	31 c0                	xor    %eax,%eax
}
80105cda:	c9                   	leave
80105cdb:	c3                   	ret
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ce0:	c9                   	leave
        return -1;
80105ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ce6:	c3                   	ret
80105ce7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cee:	00 
80105cef:	90                   	nop

80105cf0 <sys_unblock>:
//     }

//     release(&ptable.lock);
//     return 0;
// }
int sys_unblock(void) {
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	83 ec 20             	sub    $0x20,%esp
    int syscall_id;

    // Get the syscall ID from arguments
    if (argint(0, &syscall_id) < 0) 
80105cf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cf9:	50                   	push   %eax
80105cfa:	6a 00                	push   $0x0
80105cfc:	e8 4f ee ff ff       	call   80104b50 <argint>
80105d01:	83 c4 10             	add    $0x10,%esp
80105d04:	85 c0                	test   %eax,%eax
80105d06:	78 18                	js     80105d20 <sys_unblock+0x30>
        return -1;

    // Validate syscall ID range
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d0b:	83 f8 18             	cmp    $0x18,%eax
80105d0e:	77 10                	ja     80105d20 <sys_unblock+0x30>
        return -1;

    // Unblock the specified syscall
    blocked_syscalls[syscall_id] = 0;
80105d10:	c7 04 85 60 4d 11 80 	movl   $0x0,-0x7feeb2a0(,%eax,4)
80105d17:	00 00 00 00 

    return 0;
80105d1b:	31 c0                	xor    %eax,%eax
}
80105d1d:	c9                   	leave
80105d1e:	c3                   	ret
80105d1f:	90                   	nop
80105d20:	c9                   	leave
        return -1;
80105d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d26:	c3                   	ret

80105d27 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d27:	1e                   	push   %ds
  pushl %es
80105d28:	06                   	push   %es
  pushl %fs
80105d29:	0f a0                	push   %fs
  pushl %gs
80105d2b:	0f a8                	push   %gs
  pushal
80105d2d:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d2e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d32:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d34:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d36:	54                   	push   %esp
  call trap
80105d37:	e8 c4 00 00 00       	call   80105e00 <trap>
  addl $4, %esp
80105d3c:	83 c4 04             	add    $0x4,%esp

80105d3f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d3f:	61                   	popa
  popl %gs
80105d40:	0f a9                	pop    %gs
  popl %fs
80105d42:	0f a1                	pop    %fs
  popl %es
80105d44:	07                   	pop    %es
  popl %ds
80105d45:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d46:	83 c4 08             	add    $0x8,%esp
  iret
80105d49:	cf                   	iret
80105d4a:	66 90                	xchg   %ax,%ax
80105d4c:	66 90                	xchg   %ax,%ax
80105d4e:	66 90                	xchg   %ax,%ax

80105d50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d51:	31 c0                	xor    %eax,%eax
{
80105d53:	89 e5                	mov    %esp,%ebp
80105d55:	83 ec 08             	sub    $0x8,%esp
80105d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d5f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d67:	c7 04 c5 42 4e 11 80 	movl   $0x8e000008,-0x7feeb1be(,%eax,8)
80105d6e:	08 00 00 8e 
80105d72:	66 89 14 c5 40 4e 11 	mov    %dx,-0x7feeb1c0(,%eax,8)
80105d79:	80 
80105d7a:	c1 ea 10             	shr    $0x10,%edx
80105d7d:	66 89 14 c5 46 4e 11 	mov    %dx,-0x7feeb1ba(,%eax,8)
80105d84:	80 
  for(i = 0; i < 256; i++)
80105d85:	83 c0 01             	add    $0x1,%eax
80105d88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d8d:	75 d1                	jne    80105d60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d92:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d97:	c7 05 42 50 11 80 08 	movl   $0xef000008,0x80115042
80105d9e:	00 00 ef 
  initlock(&tickslock, "time");
80105da1:	68 8d 7a 10 80       	push   $0x80107a8d
80105da6:	68 00 4e 11 80       	push   $0x80114e00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dab:	66 a3 40 50 11 80    	mov    %ax,0x80115040
80105db1:	c1 e8 10             	shr    $0x10,%eax
80105db4:	66 a3 46 50 11 80    	mov    %ax,0x80115046
  initlock(&tickslock, "time");
80105dba:	e8 41 e8 ff ff       	call   80104600 <initlock>
}
80105dbf:	83 c4 10             	add    $0x10,%esp
80105dc2:	c9                   	leave
80105dc3:	c3                   	ret
80105dc4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dcb:	00 
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <idtinit>:

void
idtinit(void)
{
80105dd0:	55                   	push   %ebp
  pd[0] = size-1;
80105dd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dd6:	89 e5                	mov    %esp,%ebp
80105dd8:	83 ec 10             	sub    $0x10,%esp
80105ddb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ddf:	b8 40 4e 11 80       	mov    $0x80114e40,%eax
80105de4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105de8:	c1 e8 10             	shr    $0x10,%eax
80105deb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105def:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105df2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105df5:	c9                   	leave
80105df6:	c3                   	ret
80105df7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dfe:	00 
80105dff:	90                   	nop

80105e00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
80105e06:	83 ec 1c             	sub    $0x1c,%esp
80105e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e0f:	83 f8 40             	cmp    $0x40,%eax
80105e12:	0f 84 68 01 00 00    	je     80105f80 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e18:	83 e8 20             	sub    $0x20,%eax
80105e1b:	83 f8 1f             	cmp    $0x1f,%eax
80105e1e:	0f 87 8c 00 00 00    	ja     80105eb0 <trap+0xb0>
80105e24:	ff 24 85 64 80 10 80 	jmp    *-0x7fef7f9c(,%eax,4)
80105e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e30:	e8 1b c5 ff ff       	call   80102350 <ideintr>
    lapiceoi();
80105e35:	e8 e6 cb ff ff       	call   80102a20 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3a:	e8 f1 dc ff ff       	call   80103b30 <myproc>
80105e3f:	85 c0                	test   %eax,%eax
80105e41:	74 1d                	je     80105e60 <trap+0x60>
80105e43:	e8 e8 dc ff ff       	call   80103b30 <myproc>
80105e48:	8b 50 24             	mov    0x24(%eax),%edx
80105e4b:	85 d2                	test   %edx,%edx
80105e4d:	74 11                	je     80105e60 <trap+0x60>
80105e4f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e53:	83 e0 03             	and    $0x3,%eax
80105e56:	66 83 f8 03          	cmp    $0x3,%ax
80105e5a:	0f 84 e8 01 00 00    	je     80106048 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e60:	e8 cb dc ff ff       	call   80103b30 <myproc>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	74 0f                	je     80105e78 <trap+0x78>
80105e69:	e8 c2 dc ff ff       	call   80103b30 <myproc>
80105e6e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e72:	0f 84 b8 00 00 00    	je     80105f30 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e78:	e8 b3 dc ff ff       	call   80103b30 <myproc>
80105e7d:	85 c0                	test   %eax,%eax
80105e7f:	74 1d                	je     80105e9e <trap+0x9e>
80105e81:	e8 aa dc ff ff       	call   80103b30 <myproc>
80105e86:	8b 40 24             	mov    0x24(%eax),%eax
80105e89:	85 c0                	test   %eax,%eax
80105e8b:	74 11                	je     80105e9e <trap+0x9e>
80105e8d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e91:	83 e0 03             	and    $0x3,%eax
80105e94:	66 83 f8 03          	cmp    $0x3,%ax
80105e98:	0f 84 0f 01 00 00    	je     80105fad <trap+0x1ad>
    exit();
}
80105e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea1:	5b                   	pop    %ebx
80105ea2:	5e                   	pop    %esi
80105ea3:	5f                   	pop    %edi
80105ea4:	5d                   	pop    %ebp
80105ea5:	c3                   	ret
80105ea6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ead:	00 
80105eae:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105eb0:	e8 7b dc ff ff       	call   80103b30 <myproc>
80105eb5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	0f 84 a2 01 00 00    	je     80106062 <trap+0x262>
80105ec0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ec4:	0f 84 98 01 00 00    	je     80106062 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eca:	0f 20 d1             	mov    %cr2,%ecx
80105ecd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ed0:	e8 3b dc ff ff       	call   80103b10 <cpuid>
80105ed5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ed8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105edb:	8b 43 34             	mov    0x34(%ebx),%eax
80105ede:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ee1:	e8 4a dc ff ff       	call   80103b30 <myproc>
80105ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ee9:	e8 42 dc ff ff       	call   80103b30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ef1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ef4:	51                   	push   %ecx
80105ef5:	57                   	push   %edi
80105ef6:	52                   	push   %edx
80105ef7:	ff 75 e4             	push   -0x1c(%ebp)
80105efa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105efb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105efe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f01:	56                   	push   %esi
80105f02:	ff 70 10             	push   0x10(%eax)
80105f05:	68 4c 7d 10 80       	push   $0x80107d4c
80105f0a:	e8 91 a7 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105f0f:	83 c4 20             	add    $0x20,%esp
80105f12:	e8 19 dc ff ff       	call   80103b30 <myproc>
80105f17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f1e:	e8 0d dc ff ff       	call   80103b30 <myproc>
80105f23:	85 c0                	test   %eax,%eax
80105f25:	0f 85 18 ff ff ff    	jne    80105e43 <trap+0x43>
80105f2b:	e9 30 ff ff ff       	jmp    80105e60 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105f30:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f34:	0f 85 3e ff ff ff    	jne    80105e78 <trap+0x78>
    yield();
80105f3a:	e8 e1 e2 ff ff       	call   80104220 <yield>
80105f3f:	e9 34 ff ff ff       	jmp    80105e78 <trap+0x78>
80105f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f48:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f4b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f4f:	e8 bc db ff ff       	call   80103b10 <cpuid>
80105f54:	57                   	push   %edi
80105f55:	56                   	push   %esi
80105f56:	50                   	push   %eax
80105f57:	68 f4 7c 10 80       	push   $0x80107cf4
80105f5c:	e8 3f a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105f61:	e8 ba ca ff ff       	call   80102a20 <lapiceoi>
    break;
80105f66:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f69:	e8 c2 db ff ff       	call   80103b30 <myproc>
80105f6e:	85 c0                	test   %eax,%eax
80105f70:	0f 85 cd fe ff ff    	jne    80105e43 <trap+0x43>
80105f76:	e9 e5 fe ff ff       	jmp    80105e60 <trap+0x60>
80105f7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f80:	e8 ab db ff ff       	call   80103b30 <myproc>
80105f85:	8b 70 24             	mov    0x24(%eax),%esi
80105f88:	85 f6                	test   %esi,%esi
80105f8a:	0f 85 c8 00 00 00    	jne    80106058 <trap+0x258>
    myproc()->tf = tf;
80105f90:	e8 9b db ff ff       	call   80103b30 <myproc>
80105f95:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105f98:	e8 53 ed ff ff       	call   80104cf0 <syscall>
    if(myproc()->killed)
80105f9d:	e8 8e db ff ff       	call   80103b30 <myproc>
80105fa2:	8b 48 24             	mov    0x24(%eax),%ecx
80105fa5:	85 c9                	test   %ecx,%ecx
80105fa7:	0f 84 f1 fe ff ff    	je     80105e9e <trap+0x9e>
}
80105fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb0:	5b                   	pop    %ebx
80105fb1:	5e                   	pop    %esi
80105fb2:	5f                   	pop    %edi
80105fb3:	5d                   	pop    %ebp
      exit();
80105fb4:	e9 97 df ff ff       	jmp    80103f50 <exit>
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fc0:	e8 3b 02 00 00       	call   80106200 <uartintr>
    lapiceoi();
80105fc5:	e8 56 ca ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fca:	e8 61 db ff ff       	call   80103b30 <myproc>
80105fcf:	85 c0                	test   %eax,%eax
80105fd1:	0f 85 6c fe ff ff    	jne    80105e43 <trap+0x43>
80105fd7:	e9 84 fe ff ff       	jmp    80105e60 <trap+0x60>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fe0:	e8 fb c8 ff ff       	call   801028e0 <kbdintr>
    lapiceoi();
80105fe5:	e8 36 ca ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fea:	e8 41 db ff ff       	call   80103b30 <myproc>
80105fef:	85 c0                	test   %eax,%eax
80105ff1:	0f 85 4c fe ff ff    	jne    80105e43 <trap+0x43>
80105ff7:	e9 64 fe ff ff       	jmp    80105e60 <trap+0x60>
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106000:	e8 0b db ff ff       	call   80103b10 <cpuid>
80106005:	85 c0                	test   %eax,%eax
80106007:	0f 85 28 fe ff ff    	jne    80105e35 <trap+0x35>
      acquire(&tickslock);
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	68 00 4e 11 80       	push   $0x80114e00
80106015:	e8 b6 e7 ff ff       	call   801047d0 <acquire>
      wakeup(&ticks);
8010601a:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
      ticks++;
80106021:	83 05 e0 4d 11 80 01 	addl   $0x1,0x80114de0
      wakeup(&ticks);
80106028:	e8 03 e3 ff ff       	call   80104330 <wakeup>
      release(&tickslock);
8010602d:	c7 04 24 00 4e 11 80 	movl   $0x80114e00,(%esp)
80106034:	e8 37 e7 ff ff       	call   80104770 <release>
80106039:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010603c:	e9 f4 fd ff ff       	jmp    80105e35 <trap+0x35>
80106041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106048:	e8 03 df ff ff       	call   80103f50 <exit>
8010604d:	e9 0e fe ff ff       	jmp    80105e60 <trap+0x60>
80106052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106058:	e8 f3 de ff ff       	call   80103f50 <exit>
8010605d:	e9 2e ff ff ff       	jmp    80105f90 <trap+0x190>
80106062:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106065:	e8 a6 da ff ff       	call   80103b10 <cpuid>
8010606a:	83 ec 0c             	sub    $0xc,%esp
8010606d:	56                   	push   %esi
8010606e:	57                   	push   %edi
8010606f:	50                   	push   %eax
80106070:	ff 73 30             	push   0x30(%ebx)
80106073:	68 18 7d 10 80       	push   $0x80107d18
80106078:	e8 23 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010607d:	83 c4 14             	add    $0x14,%esp
80106080:	68 92 7a 10 80       	push   $0x80107a92
80106085:	e8 f6 a2 ff ff       	call   80100380 <panic>
8010608a:	66 90                	xchg   %ax,%ax
8010608c:	66 90                	xchg   %ax,%ax
8010608e:	66 90                	xchg   %ax,%ax

80106090 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106090:	a1 40 56 11 80       	mov    0x80115640,%eax
80106095:	85 c0                	test   %eax,%eax
80106097:	74 17                	je     801060b0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106099:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010609e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010609f:	a8 01                	test   $0x1,%al
801060a1:	74 0d                	je     801060b0 <uartgetc+0x20>
801060a3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060a8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060a9:	0f b6 c0             	movzbl %al,%eax
801060ac:	c3                   	ret
801060ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060b5:	c3                   	ret
801060b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801060bd:	00 
801060be:	66 90                	xchg   %ax,%ax

801060c0 <uartinit>:
{
801060c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060c1:	31 c9                	xor    %ecx,%ecx
801060c3:	89 c8                	mov    %ecx,%eax
801060c5:	89 e5                	mov    %esp,%ebp
801060c7:	57                   	push   %edi
801060c8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060cd:	56                   	push   %esi
801060ce:	89 fa                	mov    %edi,%edx
801060d0:	53                   	push   %ebx
801060d1:	83 ec 1c             	sub    $0x1c,%esp
801060d4:	ee                   	out    %al,(%dx)
801060d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060df:	89 f2                	mov    %esi,%edx
801060e1:	ee                   	out    %al,(%dx)
801060e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ec:	ee                   	out    %al,(%dx)
801060ed:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060f2:	89 c8                	mov    %ecx,%eax
801060f4:	89 da                	mov    %ebx,%edx
801060f6:	ee                   	out    %al,(%dx)
801060f7:	b8 03 00 00 00       	mov    $0x3,%eax
801060fc:	89 f2                	mov    %esi,%edx
801060fe:	ee                   	out    %al,(%dx)
801060ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106104:	89 c8                	mov    %ecx,%eax
80106106:	ee                   	out    %al,(%dx)
80106107:	b8 01 00 00 00       	mov    $0x1,%eax
8010610c:	89 da                	mov    %ebx,%edx
8010610e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010610f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106114:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106115:	3c ff                	cmp    $0xff,%al
80106117:	74 78                	je     80106191 <uartinit+0xd1>
  uart = 1;
80106119:	c7 05 40 56 11 80 01 	movl   $0x1,0x80115640
80106120:	00 00 00 
80106123:	89 fa                	mov    %edi,%edx
80106125:	ec                   	in     (%dx),%al
80106126:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010612b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010612c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010612f:	bf 97 7a 10 80       	mov    $0x80107a97,%edi
80106134:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106139:	6a 00                	push   $0x0
8010613b:	6a 04                	push   $0x4
8010613d:	e8 4e c4 ff ff       	call   80102590 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106142:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106146:	83 c4 10             	add    $0x10,%esp
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106150:	a1 40 56 11 80       	mov    0x80115640,%eax
80106155:	bb 80 00 00 00       	mov    $0x80,%ebx
8010615a:	85 c0                	test   %eax,%eax
8010615c:	75 14                	jne    80106172 <uartinit+0xb2>
8010615e:	eb 23                	jmp    80106183 <uartinit+0xc3>
    microdelay(10);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	6a 0a                	push   $0xa
80106165:	e8 d6 c8 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010616a:	83 c4 10             	add    $0x10,%esp
8010616d:	83 eb 01             	sub    $0x1,%ebx
80106170:	74 07                	je     80106179 <uartinit+0xb9>
80106172:	89 f2                	mov    %esi,%edx
80106174:	ec                   	in     (%dx),%al
80106175:	a8 20                	test   $0x20,%al
80106177:	74 e7                	je     80106160 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106179:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010617d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106182:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106183:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106187:	83 c7 01             	add    $0x1,%edi
8010618a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010618d:	84 c0                	test   %al,%al
8010618f:	75 bf                	jne    80106150 <uartinit+0x90>
}
80106191:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106194:	5b                   	pop    %ebx
80106195:	5e                   	pop    %esi
80106196:	5f                   	pop    %edi
80106197:	5d                   	pop    %ebp
80106198:	c3                   	ret
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061a0 <uartputc>:
  if(!uart)
801061a0:	a1 40 56 11 80       	mov    0x80115640,%eax
801061a5:	85 c0                	test   %eax,%eax
801061a7:	74 47                	je     801061f0 <uartputc+0x50>
{
801061a9:	55                   	push   %ebp
801061aa:	89 e5                	mov    %esp,%ebp
801061ac:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801061b2:	53                   	push   %ebx
801061b3:	bb 80 00 00 00       	mov    $0x80,%ebx
801061b8:	eb 18                	jmp    801061d2 <uartputc+0x32>
801061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061c0:	83 ec 0c             	sub    $0xc,%esp
801061c3:	6a 0a                	push   $0xa
801061c5:	e8 76 c8 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	83 eb 01             	sub    $0x1,%ebx
801061d0:	74 07                	je     801061d9 <uartputc+0x39>
801061d2:	89 f2                	mov    %esi,%edx
801061d4:	ec                   	in     (%dx),%al
801061d5:	a8 20                	test   $0x20,%al
801061d7:	74 e7                	je     801061c0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061d9:	8b 45 08             	mov    0x8(%ebp),%eax
801061dc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061e1:	ee                   	out    %al,(%dx)
}
801061e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061e5:	5b                   	pop    %ebx
801061e6:	5e                   	pop    %esi
801061e7:	5d                   	pop    %ebp
801061e8:	c3                   	ret
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061f0:	c3                   	ret
801061f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061f8:	00 
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106200 <uartintr>:

void
uartintr(void)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106206:	68 90 60 10 80       	push   $0x80106090
8010620b:	e8 70 a6 ff ff       	call   80100880 <consoleintr>
}
80106210:	83 c4 10             	add    $0x10,%esp
80106213:	c9                   	leave
80106214:	c3                   	ret

80106215 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $0
80106217:	6a 00                	push   $0x0
  jmp alltraps
80106219:	e9 09 fb ff ff       	jmp    80105d27 <alltraps>

8010621e <vector1>:
.globl vector1
vector1:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $1
80106220:	6a 01                	push   $0x1
  jmp alltraps
80106222:	e9 00 fb ff ff       	jmp    80105d27 <alltraps>

80106227 <vector2>:
.globl vector2
vector2:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $2
80106229:	6a 02                	push   $0x2
  jmp alltraps
8010622b:	e9 f7 fa ff ff       	jmp    80105d27 <alltraps>

80106230 <vector3>:
.globl vector3
vector3:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $3
80106232:	6a 03                	push   $0x3
  jmp alltraps
80106234:	e9 ee fa ff ff       	jmp    80105d27 <alltraps>

80106239 <vector4>:
.globl vector4
vector4:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $4
8010623b:	6a 04                	push   $0x4
  jmp alltraps
8010623d:	e9 e5 fa ff ff       	jmp    80105d27 <alltraps>

80106242 <vector5>:
.globl vector5
vector5:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $5
80106244:	6a 05                	push   $0x5
  jmp alltraps
80106246:	e9 dc fa ff ff       	jmp    80105d27 <alltraps>

8010624b <vector6>:
.globl vector6
vector6:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $6
8010624d:	6a 06                	push   $0x6
  jmp alltraps
8010624f:	e9 d3 fa ff ff       	jmp    80105d27 <alltraps>

80106254 <vector7>:
.globl vector7
vector7:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $7
80106256:	6a 07                	push   $0x7
  jmp alltraps
80106258:	e9 ca fa ff ff       	jmp    80105d27 <alltraps>

8010625d <vector8>:
.globl vector8
vector8:
  pushl $8
8010625d:	6a 08                	push   $0x8
  jmp alltraps
8010625f:	e9 c3 fa ff ff       	jmp    80105d27 <alltraps>

80106264 <vector9>:
.globl vector9
vector9:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $9
80106266:	6a 09                	push   $0x9
  jmp alltraps
80106268:	e9 ba fa ff ff       	jmp    80105d27 <alltraps>

8010626d <vector10>:
.globl vector10
vector10:
  pushl $10
8010626d:	6a 0a                	push   $0xa
  jmp alltraps
8010626f:	e9 b3 fa ff ff       	jmp    80105d27 <alltraps>

80106274 <vector11>:
.globl vector11
vector11:
  pushl $11
80106274:	6a 0b                	push   $0xb
  jmp alltraps
80106276:	e9 ac fa ff ff       	jmp    80105d27 <alltraps>

8010627b <vector12>:
.globl vector12
vector12:
  pushl $12
8010627b:	6a 0c                	push   $0xc
  jmp alltraps
8010627d:	e9 a5 fa ff ff       	jmp    80105d27 <alltraps>

80106282 <vector13>:
.globl vector13
vector13:
  pushl $13
80106282:	6a 0d                	push   $0xd
  jmp alltraps
80106284:	e9 9e fa ff ff       	jmp    80105d27 <alltraps>

80106289 <vector14>:
.globl vector14
vector14:
  pushl $14
80106289:	6a 0e                	push   $0xe
  jmp alltraps
8010628b:	e9 97 fa ff ff       	jmp    80105d27 <alltraps>

80106290 <vector15>:
.globl vector15
vector15:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $15
80106292:	6a 0f                	push   $0xf
  jmp alltraps
80106294:	e9 8e fa ff ff       	jmp    80105d27 <alltraps>

80106299 <vector16>:
.globl vector16
vector16:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $16
8010629b:	6a 10                	push   $0x10
  jmp alltraps
8010629d:	e9 85 fa ff ff       	jmp    80105d27 <alltraps>

801062a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062a2:	6a 11                	push   $0x11
  jmp alltraps
801062a4:	e9 7e fa ff ff       	jmp    80105d27 <alltraps>

801062a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $18
801062ab:	6a 12                	push   $0x12
  jmp alltraps
801062ad:	e9 75 fa ff ff       	jmp    80105d27 <alltraps>

801062b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $19
801062b4:	6a 13                	push   $0x13
  jmp alltraps
801062b6:	e9 6c fa ff ff       	jmp    80105d27 <alltraps>

801062bb <vector20>:
.globl vector20
vector20:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $20
801062bd:	6a 14                	push   $0x14
  jmp alltraps
801062bf:	e9 63 fa ff ff       	jmp    80105d27 <alltraps>

801062c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $21
801062c6:	6a 15                	push   $0x15
  jmp alltraps
801062c8:	e9 5a fa ff ff       	jmp    80105d27 <alltraps>

801062cd <vector22>:
.globl vector22
vector22:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $22
801062cf:	6a 16                	push   $0x16
  jmp alltraps
801062d1:	e9 51 fa ff ff       	jmp    80105d27 <alltraps>

801062d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $23
801062d8:	6a 17                	push   $0x17
  jmp alltraps
801062da:	e9 48 fa ff ff       	jmp    80105d27 <alltraps>

801062df <vector24>:
.globl vector24
vector24:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $24
801062e1:	6a 18                	push   $0x18
  jmp alltraps
801062e3:	e9 3f fa ff ff       	jmp    80105d27 <alltraps>

801062e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $25
801062ea:	6a 19                	push   $0x19
  jmp alltraps
801062ec:	e9 36 fa ff ff       	jmp    80105d27 <alltraps>

801062f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $26
801062f3:	6a 1a                	push   $0x1a
  jmp alltraps
801062f5:	e9 2d fa ff ff       	jmp    80105d27 <alltraps>

801062fa <vector27>:
.globl vector27
vector27:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $27
801062fc:	6a 1b                	push   $0x1b
  jmp alltraps
801062fe:	e9 24 fa ff ff       	jmp    80105d27 <alltraps>

80106303 <vector28>:
.globl vector28
vector28:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $28
80106305:	6a 1c                	push   $0x1c
  jmp alltraps
80106307:	e9 1b fa ff ff       	jmp    80105d27 <alltraps>

8010630c <vector29>:
.globl vector29
vector29:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $29
8010630e:	6a 1d                	push   $0x1d
  jmp alltraps
80106310:	e9 12 fa ff ff       	jmp    80105d27 <alltraps>

80106315 <vector30>:
.globl vector30
vector30:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $30
80106317:	6a 1e                	push   $0x1e
  jmp alltraps
80106319:	e9 09 fa ff ff       	jmp    80105d27 <alltraps>

8010631e <vector31>:
.globl vector31
vector31:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $31
80106320:	6a 1f                	push   $0x1f
  jmp alltraps
80106322:	e9 00 fa ff ff       	jmp    80105d27 <alltraps>

80106327 <vector32>:
.globl vector32
vector32:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $32
80106329:	6a 20                	push   $0x20
  jmp alltraps
8010632b:	e9 f7 f9 ff ff       	jmp    80105d27 <alltraps>

80106330 <vector33>:
.globl vector33
vector33:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $33
80106332:	6a 21                	push   $0x21
  jmp alltraps
80106334:	e9 ee f9 ff ff       	jmp    80105d27 <alltraps>

80106339 <vector34>:
.globl vector34
vector34:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $34
8010633b:	6a 22                	push   $0x22
  jmp alltraps
8010633d:	e9 e5 f9 ff ff       	jmp    80105d27 <alltraps>

80106342 <vector35>:
.globl vector35
vector35:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $35
80106344:	6a 23                	push   $0x23
  jmp alltraps
80106346:	e9 dc f9 ff ff       	jmp    80105d27 <alltraps>

8010634b <vector36>:
.globl vector36
vector36:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $36
8010634d:	6a 24                	push   $0x24
  jmp alltraps
8010634f:	e9 d3 f9 ff ff       	jmp    80105d27 <alltraps>

80106354 <vector37>:
.globl vector37
vector37:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $37
80106356:	6a 25                	push   $0x25
  jmp alltraps
80106358:	e9 ca f9 ff ff       	jmp    80105d27 <alltraps>

8010635d <vector38>:
.globl vector38
vector38:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $38
8010635f:	6a 26                	push   $0x26
  jmp alltraps
80106361:	e9 c1 f9 ff ff       	jmp    80105d27 <alltraps>

80106366 <vector39>:
.globl vector39
vector39:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $39
80106368:	6a 27                	push   $0x27
  jmp alltraps
8010636a:	e9 b8 f9 ff ff       	jmp    80105d27 <alltraps>

8010636f <vector40>:
.globl vector40
vector40:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $40
80106371:	6a 28                	push   $0x28
  jmp alltraps
80106373:	e9 af f9 ff ff       	jmp    80105d27 <alltraps>

80106378 <vector41>:
.globl vector41
vector41:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $41
8010637a:	6a 29                	push   $0x29
  jmp alltraps
8010637c:	e9 a6 f9 ff ff       	jmp    80105d27 <alltraps>

80106381 <vector42>:
.globl vector42
vector42:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $42
80106383:	6a 2a                	push   $0x2a
  jmp alltraps
80106385:	e9 9d f9 ff ff       	jmp    80105d27 <alltraps>

8010638a <vector43>:
.globl vector43
vector43:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $43
8010638c:	6a 2b                	push   $0x2b
  jmp alltraps
8010638e:	e9 94 f9 ff ff       	jmp    80105d27 <alltraps>

80106393 <vector44>:
.globl vector44
vector44:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $44
80106395:	6a 2c                	push   $0x2c
  jmp alltraps
80106397:	e9 8b f9 ff ff       	jmp    80105d27 <alltraps>

8010639c <vector45>:
.globl vector45
vector45:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $45
8010639e:	6a 2d                	push   $0x2d
  jmp alltraps
801063a0:	e9 82 f9 ff ff       	jmp    80105d27 <alltraps>

801063a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $46
801063a7:	6a 2e                	push   $0x2e
  jmp alltraps
801063a9:	e9 79 f9 ff ff       	jmp    80105d27 <alltraps>

801063ae <vector47>:
.globl vector47
vector47:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $47
801063b0:	6a 2f                	push   $0x2f
  jmp alltraps
801063b2:	e9 70 f9 ff ff       	jmp    80105d27 <alltraps>

801063b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $48
801063b9:	6a 30                	push   $0x30
  jmp alltraps
801063bb:	e9 67 f9 ff ff       	jmp    80105d27 <alltraps>

801063c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $49
801063c2:	6a 31                	push   $0x31
  jmp alltraps
801063c4:	e9 5e f9 ff ff       	jmp    80105d27 <alltraps>

801063c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $50
801063cb:	6a 32                	push   $0x32
  jmp alltraps
801063cd:	e9 55 f9 ff ff       	jmp    80105d27 <alltraps>

801063d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $51
801063d4:	6a 33                	push   $0x33
  jmp alltraps
801063d6:	e9 4c f9 ff ff       	jmp    80105d27 <alltraps>

801063db <vector52>:
.globl vector52
vector52:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $52
801063dd:	6a 34                	push   $0x34
  jmp alltraps
801063df:	e9 43 f9 ff ff       	jmp    80105d27 <alltraps>

801063e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $53
801063e6:	6a 35                	push   $0x35
  jmp alltraps
801063e8:	e9 3a f9 ff ff       	jmp    80105d27 <alltraps>

801063ed <vector54>:
.globl vector54
vector54:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $54
801063ef:	6a 36                	push   $0x36
  jmp alltraps
801063f1:	e9 31 f9 ff ff       	jmp    80105d27 <alltraps>

801063f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $55
801063f8:	6a 37                	push   $0x37
  jmp alltraps
801063fa:	e9 28 f9 ff ff       	jmp    80105d27 <alltraps>

801063ff <vector56>:
.globl vector56
vector56:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $56
80106401:	6a 38                	push   $0x38
  jmp alltraps
80106403:	e9 1f f9 ff ff       	jmp    80105d27 <alltraps>

80106408 <vector57>:
.globl vector57
vector57:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $57
8010640a:	6a 39                	push   $0x39
  jmp alltraps
8010640c:	e9 16 f9 ff ff       	jmp    80105d27 <alltraps>

80106411 <vector58>:
.globl vector58
vector58:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $58
80106413:	6a 3a                	push   $0x3a
  jmp alltraps
80106415:	e9 0d f9 ff ff       	jmp    80105d27 <alltraps>

8010641a <vector59>:
.globl vector59
vector59:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $59
8010641c:	6a 3b                	push   $0x3b
  jmp alltraps
8010641e:	e9 04 f9 ff ff       	jmp    80105d27 <alltraps>

80106423 <vector60>:
.globl vector60
vector60:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $60
80106425:	6a 3c                	push   $0x3c
  jmp alltraps
80106427:	e9 fb f8 ff ff       	jmp    80105d27 <alltraps>

8010642c <vector61>:
.globl vector61
vector61:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $61
8010642e:	6a 3d                	push   $0x3d
  jmp alltraps
80106430:	e9 f2 f8 ff ff       	jmp    80105d27 <alltraps>

80106435 <vector62>:
.globl vector62
vector62:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $62
80106437:	6a 3e                	push   $0x3e
  jmp alltraps
80106439:	e9 e9 f8 ff ff       	jmp    80105d27 <alltraps>

8010643e <vector63>:
.globl vector63
vector63:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $63
80106440:	6a 3f                	push   $0x3f
  jmp alltraps
80106442:	e9 e0 f8 ff ff       	jmp    80105d27 <alltraps>

80106447 <vector64>:
.globl vector64
vector64:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $64
80106449:	6a 40                	push   $0x40
  jmp alltraps
8010644b:	e9 d7 f8 ff ff       	jmp    80105d27 <alltraps>

80106450 <vector65>:
.globl vector65
vector65:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $65
80106452:	6a 41                	push   $0x41
  jmp alltraps
80106454:	e9 ce f8 ff ff       	jmp    80105d27 <alltraps>

80106459 <vector66>:
.globl vector66
vector66:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $66
8010645b:	6a 42                	push   $0x42
  jmp alltraps
8010645d:	e9 c5 f8 ff ff       	jmp    80105d27 <alltraps>

80106462 <vector67>:
.globl vector67
vector67:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $67
80106464:	6a 43                	push   $0x43
  jmp alltraps
80106466:	e9 bc f8 ff ff       	jmp    80105d27 <alltraps>

8010646b <vector68>:
.globl vector68
vector68:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $68
8010646d:	6a 44                	push   $0x44
  jmp alltraps
8010646f:	e9 b3 f8 ff ff       	jmp    80105d27 <alltraps>

80106474 <vector69>:
.globl vector69
vector69:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $69
80106476:	6a 45                	push   $0x45
  jmp alltraps
80106478:	e9 aa f8 ff ff       	jmp    80105d27 <alltraps>

8010647d <vector70>:
.globl vector70
vector70:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $70
8010647f:	6a 46                	push   $0x46
  jmp alltraps
80106481:	e9 a1 f8 ff ff       	jmp    80105d27 <alltraps>

80106486 <vector71>:
.globl vector71
vector71:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $71
80106488:	6a 47                	push   $0x47
  jmp alltraps
8010648a:	e9 98 f8 ff ff       	jmp    80105d27 <alltraps>

8010648f <vector72>:
.globl vector72
vector72:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $72
80106491:	6a 48                	push   $0x48
  jmp alltraps
80106493:	e9 8f f8 ff ff       	jmp    80105d27 <alltraps>

80106498 <vector73>:
.globl vector73
vector73:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $73
8010649a:	6a 49                	push   $0x49
  jmp alltraps
8010649c:	e9 86 f8 ff ff       	jmp    80105d27 <alltraps>

801064a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $74
801064a3:	6a 4a                	push   $0x4a
  jmp alltraps
801064a5:	e9 7d f8 ff ff       	jmp    80105d27 <alltraps>

801064aa <vector75>:
.globl vector75
vector75:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $75
801064ac:	6a 4b                	push   $0x4b
  jmp alltraps
801064ae:	e9 74 f8 ff ff       	jmp    80105d27 <alltraps>

801064b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $76
801064b5:	6a 4c                	push   $0x4c
  jmp alltraps
801064b7:	e9 6b f8 ff ff       	jmp    80105d27 <alltraps>

801064bc <vector77>:
.globl vector77
vector77:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $77
801064be:	6a 4d                	push   $0x4d
  jmp alltraps
801064c0:	e9 62 f8 ff ff       	jmp    80105d27 <alltraps>

801064c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $78
801064c7:	6a 4e                	push   $0x4e
  jmp alltraps
801064c9:	e9 59 f8 ff ff       	jmp    80105d27 <alltraps>

801064ce <vector79>:
.globl vector79
vector79:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $79
801064d0:	6a 4f                	push   $0x4f
  jmp alltraps
801064d2:	e9 50 f8 ff ff       	jmp    80105d27 <alltraps>

801064d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $80
801064d9:	6a 50                	push   $0x50
  jmp alltraps
801064db:	e9 47 f8 ff ff       	jmp    80105d27 <alltraps>

801064e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $81
801064e2:	6a 51                	push   $0x51
  jmp alltraps
801064e4:	e9 3e f8 ff ff       	jmp    80105d27 <alltraps>

801064e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $82
801064eb:	6a 52                	push   $0x52
  jmp alltraps
801064ed:	e9 35 f8 ff ff       	jmp    80105d27 <alltraps>

801064f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $83
801064f4:	6a 53                	push   $0x53
  jmp alltraps
801064f6:	e9 2c f8 ff ff       	jmp    80105d27 <alltraps>

801064fb <vector84>:
.globl vector84
vector84:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $84
801064fd:	6a 54                	push   $0x54
  jmp alltraps
801064ff:	e9 23 f8 ff ff       	jmp    80105d27 <alltraps>

80106504 <vector85>:
.globl vector85
vector85:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $85
80106506:	6a 55                	push   $0x55
  jmp alltraps
80106508:	e9 1a f8 ff ff       	jmp    80105d27 <alltraps>

8010650d <vector86>:
.globl vector86
vector86:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $86
8010650f:	6a 56                	push   $0x56
  jmp alltraps
80106511:	e9 11 f8 ff ff       	jmp    80105d27 <alltraps>

80106516 <vector87>:
.globl vector87
vector87:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $87
80106518:	6a 57                	push   $0x57
  jmp alltraps
8010651a:	e9 08 f8 ff ff       	jmp    80105d27 <alltraps>

8010651f <vector88>:
.globl vector88
vector88:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $88
80106521:	6a 58                	push   $0x58
  jmp alltraps
80106523:	e9 ff f7 ff ff       	jmp    80105d27 <alltraps>

80106528 <vector89>:
.globl vector89
vector89:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $89
8010652a:	6a 59                	push   $0x59
  jmp alltraps
8010652c:	e9 f6 f7 ff ff       	jmp    80105d27 <alltraps>

80106531 <vector90>:
.globl vector90
vector90:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $90
80106533:	6a 5a                	push   $0x5a
  jmp alltraps
80106535:	e9 ed f7 ff ff       	jmp    80105d27 <alltraps>

8010653a <vector91>:
.globl vector91
vector91:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $91
8010653c:	6a 5b                	push   $0x5b
  jmp alltraps
8010653e:	e9 e4 f7 ff ff       	jmp    80105d27 <alltraps>

80106543 <vector92>:
.globl vector92
vector92:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $92
80106545:	6a 5c                	push   $0x5c
  jmp alltraps
80106547:	e9 db f7 ff ff       	jmp    80105d27 <alltraps>

8010654c <vector93>:
.globl vector93
vector93:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $93
8010654e:	6a 5d                	push   $0x5d
  jmp alltraps
80106550:	e9 d2 f7 ff ff       	jmp    80105d27 <alltraps>

80106555 <vector94>:
.globl vector94
vector94:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $94
80106557:	6a 5e                	push   $0x5e
  jmp alltraps
80106559:	e9 c9 f7 ff ff       	jmp    80105d27 <alltraps>

8010655e <vector95>:
.globl vector95
vector95:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $95
80106560:	6a 5f                	push   $0x5f
  jmp alltraps
80106562:	e9 c0 f7 ff ff       	jmp    80105d27 <alltraps>

80106567 <vector96>:
.globl vector96
vector96:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $96
80106569:	6a 60                	push   $0x60
  jmp alltraps
8010656b:	e9 b7 f7 ff ff       	jmp    80105d27 <alltraps>

80106570 <vector97>:
.globl vector97
vector97:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $97
80106572:	6a 61                	push   $0x61
  jmp alltraps
80106574:	e9 ae f7 ff ff       	jmp    80105d27 <alltraps>

80106579 <vector98>:
.globl vector98
vector98:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $98
8010657b:	6a 62                	push   $0x62
  jmp alltraps
8010657d:	e9 a5 f7 ff ff       	jmp    80105d27 <alltraps>

80106582 <vector99>:
.globl vector99
vector99:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $99
80106584:	6a 63                	push   $0x63
  jmp alltraps
80106586:	e9 9c f7 ff ff       	jmp    80105d27 <alltraps>

8010658b <vector100>:
.globl vector100
vector100:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $100
8010658d:	6a 64                	push   $0x64
  jmp alltraps
8010658f:	e9 93 f7 ff ff       	jmp    80105d27 <alltraps>

80106594 <vector101>:
.globl vector101
vector101:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $101
80106596:	6a 65                	push   $0x65
  jmp alltraps
80106598:	e9 8a f7 ff ff       	jmp    80105d27 <alltraps>

8010659d <vector102>:
.globl vector102
vector102:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $102
8010659f:	6a 66                	push   $0x66
  jmp alltraps
801065a1:	e9 81 f7 ff ff       	jmp    80105d27 <alltraps>

801065a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $103
801065a8:	6a 67                	push   $0x67
  jmp alltraps
801065aa:	e9 78 f7 ff ff       	jmp    80105d27 <alltraps>

801065af <vector104>:
.globl vector104
vector104:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $104
801065b1:	6a 68                	push   $0x68
  jmp alltraps
801065b3:	e9 6f f7 ff ff       	jmp    80105d27 <alltraps>

801065b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $105
801065ba:	6a 69                	push   $0x69
  jmp alltraps
801065bc:	e9 66 f7 ff ff       	jmp    80105d27 <alltraps>

801065c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $106
801065c3:	6a 6a                	push   $0x6a
  jmp alltraps
801065c5:	e9 5d f7 ff ff       	jmp    80105d27 <alltraps>

801065ca <vector107>:
.globl vector107
vector107:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $107
801065cc:	6a 6b                	push   $0x6b
  jmp alltraps
801065ce:	e9 54 f7 ff ff       	jmp    80105d27 <alltraps>

801065d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $108
801065d5:	6a 6c                	push   $0x6c
  jmp alltraps
801065d7:	e9 4b f7 ff ff       	jmp    80105d27 <alltraps>

801065dc <vector109>:
.globl vector109
vector109:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $109
801065de:	6a 6d                	push   $0x6d
  jmp alltraps
801065e0:	e9 42 f7 ff ff       	jmp    80105d27 <alltraps>

801065e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $110
801065e7:	6a 6e                	push   $0x6e
  jmp alltraps
801065e9:	e9 39 f7 ff ff       	jmp    80105d27 <alltraps>

801065ee <vector111>:
.globl vector111
vector111:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $111
801065f0:	6a 6f                	push   $0x6f
  jmp alltraps
801065f2:	e9 30 f7 ff ff       	jmp    80105d27 <alltraps>

801065f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $112
801065f9:	6a 70                	push   $0x70
  jmp alltraps
801065fb:	e9 27 f7 ff ff       	jmp    80105d27 <alltraps>

80106600 <vector113>:
.globl vector113
vector113:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $113
80106602:	6a 71                	push   $0x71
  jmp alltraps
80106604:	e9 1e f7 ff ff       	jmp    80105d27 <alltraps>

80106609 <vector114>:
.globl vector114
vector114:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $114
8010660b:	6a 72                	push   $0x72
  jmp alltraps
8010660d:	e9 15 f7 ff ff       	jmp    80105d27 <alltraps>

80106612 <vector115>:
.globl vector115
vector115:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $115
80106614:	6a 73                	push   $0x73
  jmp alltraps
80106616:	e9 0c f7 ff ff       	jmp    80105d27 <alltraps>

8010661b <vector116>:
.globl vector116
vector116:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $116
8010661d:	6a 74                	push   $0x74
  jmp alltraps
8010661f:	e9 03 f7 ff ff       	jmp    80105d27 <alltraps>

80106624 <vector117>:
.globl vector117
vector117:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $117
80106626:	6a 75                	push   $0x75
  jmp alltraps
80106628:	e9 fa f6 ff ff       	jmp    80105d27 <alltraps>

8010662d <vector118>:
.globl vector118
vector118:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $118
8010662f:	6a 76                	push   $0x76
  jmp alltraps
80106631:	e9 f1 f6 ff ff       	jmp    80105d27 <alltraps>

80106636 <vector119>:
.globl vector119
vector119:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $119
80106638:	6a 77                	push   $0x77
  jmp alltraps
8010663a:	e9 e8 f6 ff ff       	jmp    80105d27 <alltraps>

8010663f <vector120>:
.globl vector120
vector120:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $120
80106641:	6a 78                	push   $0x78
  jmp alltraps
80106643:	e9 df f6 ff ff       	jmp    80105d27 <alltraps>

80106648 <vector121>:
.globl vector121
vector121:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $121
8010664a:	6a 79                	push   $0x79
  jmp alltraps
8010664c:	e9 d6 f6 ff ff       	jmp    80105d27 <alltraps>

80106651 <vector122>:
.globl vector122
vector122:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $122
80106653:	6a 7a                	push   $0x7a
  jmp alltraps
80106655:	e9 cd f6 ff ff       	jmp    80105d27 <alltraps>

8010665a <vector123>:
.globl vector123
vector123:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $123
8010665c:	6a 7b                	push   $0x7b
  jmp alltraps
8010665e:	e9 c4 f6 ff ff       	jmp    80105d27 <alltraps>

80106663 <vector124>:
.globl vector124
vector124:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $124
80106665:	6a 7c                	push   $0x7c
  jmp alltraps
80106667:	e9 bb f6 ff ff       	jmp    80105d27 <alltraps>

8010666c <vector125>:
.globl vector125
vector125:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $125
8010666e:	6a 7d                	push   $0x7d
  jmp alltraps
80106670:	e9 b2 f6 ff ff       	jmp    80105d27 <alltraps>

80106675 <vector126>:
.globl vector126
vector126:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $126
80106677:	6a 7e                	push   $0x7e
  jmp alltraps
80106679:	e9 a9 f6 ff ff       	jmp    80105d27 <alltraps>

8010667e <vector127>:
.globl vector127
vector127:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $127
80106680:	6a 7f                	push   $0x7f
  jmp alltraps
80106682:	e9 a0 f6 ff ff       	jmp    80105d27 <alltraps>

80106687 <vector128>:
.globl vector128
vector128:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $128
80106689:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010668e:	e9 94 f6 ff ff       	jmp    80105d27 <alltraps>

80106693 <vector129>:
.globl vector129
vector129:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $129
80106695:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010669a:	e9 88 f6 ff ff       	jmp    80105d27 <alltraps>

8010669f <vector130>:
.globl vector130
vector130:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $130
801066a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066a6:	e9 7c f6 ff ff       	jmp    80105d27 <alltraps>

801066ab <vector131>:
.globl vector131
vector131:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $131
801066ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066b2:	e9 70 f6 ff ff       	jmp    80105d27 <alltraps>

801066b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $132
801066b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066be:	e9 64 f6 ff ff       	jmp    80105d27 <alltraps>

801066c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $133
801066c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066ca:	e9 58 f6 ff ff       	jmp    80105d27 <alltraps>

801066cf <vector134>:
.globl vector134
vector134:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $134
801066d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066d6:	e9 4c f6 ff ff       	jmp    80105d27 <alltraps>

801066db <vector135>:
.globl vector135
vector135:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $135
801066dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066e2:	e9 40 f6 ff ff       	jmp    80105d27 <alltraps>

801066e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $136
801066e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066ee:	e9 34 f6 ff ff       	jmp    80105d27 <alltraps>

801066f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $137
801066f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066fa:	e9 28 f6 ff ff       	jmp    80105d27 <alltraps>

801066ff <vector138>:
.globl vector138
vector138:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $138
80106701:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106706:	e9 1c f6 ff ff       	jmp    80105d27 <alltraps>

8010670b <vector139>:
.globl vector139
vector139:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $139
8010670d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106712:	e9 10 f6 ff ff       	jmp    80105d27 <alltraps>

80106717 <vector140>:
.globl vector140
vector140:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $140
80106719:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010671e:	e9 04 f6 ff ff       	jmp    80105d27 <alltraps>

80106723 <vector141>:
.globl vector141
vector141:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $141
80106725:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010672a:	e9 f8 f5 ff ff       	jmp    80105d27 <alltraps>

8010672f <vector142>:
.globl vector142
vector142:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $142
80106731:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106736:	e9 ec f5 ff ff       	jmp    80105d27 <alltraps>

8010673b <vector143>:
.globl vector143
vector143:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $143
8010673d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106742:	e9 e0 f5 ff ff       	jmp    80105d27 <alltraps>

80106747 <vector144>:
.globl vector144
vector144:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $144
80106749:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010674e:	e9 d4 f5 ff ff       	jmp    80105d27 <alltraps>

80106753 <vector145>:
.globl vector145
vector145:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $145
80106755:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010675a:	e9 c8 f5 ff ff       	jmp    80105d27 <alltraps>

8010675f <vector146>:
.globl vector146
vector146:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $146
80106761:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106766:	e9 bc f5 ff ff       	jmp    80105d27 <alltraps>

8010676b <vector147>:
.globl vector147
vector147:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $147
8010676d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106772:	e9 b0 f5 ff ff       	jmp    80105d27 <alltraps>

80106777 <vector148>:
.globl vector148
vector148:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $148
80106779:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010677e:	e9 a4 f5 ff ff       	jmp    80105d27 <alltraps>

80106783 <vector149>:
.globl vector149
vector149:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $149
80106785:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010678a:	e9 98 f5 ff ff       	jmp    80105d27 <alltraps>

8010678f <vector150>:
.globl vector150
vector150:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $150
80106791:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106796:	e9 8c f5 ff ff       	jmp    80105d27 <alltraps>

8010679b <vector151>:
.globl vector151
vector151:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $151
8010679d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067a2:	e9 80 f5 ff ff       	jmp    80105d27 <alltraps>

801067a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $152
801067a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067ae:	e9 74 f5 ff ff       	jmp    80105d27 <alltraps>

801067b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $153
801067b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ba:	e9 68 f5 ff ff       	jmp    80105d27 <alltraps>

801067bf <vector154>:
.globl vector154
vector154:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $154
801067c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067c6:	e9 5c f5 ff ff       	jmp    80105d27 <alltraps>

801067cb <vector155>:
.globl vector155
vector155:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $155
801067cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067d2:	e9 50 f5 ff ff       	jmp    80105d27 <alltraps>

801067d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $156
801067d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067de:	e9 44 f5 ff ff       	jmp    80105d27 <alltraps>

801067e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $157
801067e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ea:	e9 38 f5 ff ff       	jmp    80105d27 <alltraps>

801067ef <vector158>:
.globl vector158
vector158:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $158
801067f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067f6:	e9 2c f5 ff ff       	jmp    80105d27 <alltraps>

801067fb <vector159>:
.globl vector159
vector159:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $159
801067fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106802:	e9 20 f5 ff ff       	jmp    80105d27 <alltraps>

80106807 <vector160>:
.globl vector160
vector160:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $160
80106809:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010680e:	e9 14 f5 ff ff       	jmp    80105d27 <alltraps>

80106813 <vector161>:
.globl vector161
vector161:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $161
80106815:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010681a:	e9 08 f5 ff ff       	jmp    80105d27 <alltraps>

8010681f <vector162>:
.globl vector162
vector162:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $162
80106821:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106826:	e9 fc f4 ff ff       	jmp    80105d27 <alltraps>

8010682b <vector163>:
.globl vector163
vector163:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $163
8010682d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106832:	e9 f0 f4 ff ff       	jmp    80105d27 <alltraps>

80106837 <vector164>:
.globl vector164
vector164:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $164
80106839:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010683e:	e9 e4 f4 ff ff       	jmp    80105d27 <alltraps>

80106843 <vector165>:
.globl vector165
vector165:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $165
80106845:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010684a:	e9 d8 f4 ff ff       	jmp    80105d27 <alltraps>

8010684f <vector166>:
.globl vector166
vector166:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $166
80106851:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106856:	e9 cc f4 ff ff       	jmp    80105d27 <alltraps>

8010685b <vector167>:
.globl vector167
vector167:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $167
8010685d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106862:	e9 c0 f4 ff ff       	jmp    80105d27 <alltraps>

80106867 <vector168>:
.globl vector168
vector168:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $168
80106869:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010686e:	e9 b4 f4 ff ff       	jmp    80105d27 <alltraps>

80106873 <vector169>:
.globl vector169
vector169:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $169
80106875:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010687a:	e9 a8 f4 ff ff       	jmp    80105d27 <alltraps>

8010687f <vector170>:
.globl vector170
vector170:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $170
80106881:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106886:	e9 9c f4 ff ff       	jmp    80105d27 <alltraps>

8010688b <vector171>:
.globl vector171
vector171:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $171
8010688d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106892:	e9 90 f4 ff ff       	jmp    80105d27 <alltraps>

80106897 <vector172>:
.globl vector172
vector172:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $172
80106899:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010689e:	e9 84 f4 ff ff       	jmp    80105d27 <alltraps>

801068a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $173
801068a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068aa:	e9 78 f4 ff ff       	jmp    80105d27 <alltraps>

801068af <vector174>:
.globl vector174
vector174:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $174
801068b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068b6:	e9 6c f4 ff ff       	jmp    80105d27 <alltraps>

801068bb <vector175>:
.globl vector175
vector175:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $175
801068bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068c2:	e9 60 f4 ff ff       	jmp    80105d27 <alltraps>

801068c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $176
801068c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068ce:	e9 54 f4 ff ff       	jmp    80105d27 <alltraps>

801068d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $177
801068d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068da:	e9 48 f4 ff ff       	jmp    80105d27 <alltraps>

801068df <vector178>:
.globl vector178
vector178:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $178
801068e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068e6:	e9 3c f4 ff ff       	jmp    80105d27 <alltraps>

801068eb <vector179>:
.globl vector179
vector179:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $179
801068ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068f2:	e9 30 f4 ff ff       	jmp    80105d27 <alltraps>

801068f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $180
801068f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068fe:	e9 24 f4 ff ff       	jmp    80105d27 <alltraps>

80106903 <vector181>:
.globl vector181
vector181:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $181
80106905:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010690a:	e9 18 f4 ff ff       	jmp    80105d27 <alltraps>

8010690f <vector182>:
.globl vector182
vector182:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $182
80106911:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106916:	e9 0c f4 ff ff       	jmp    80105d27 <alltraps>

8010691b <vector183>:
.globl vector183
vector183:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $183
8010691d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106922:	e9 00 f4 ff ff       	jmp    80105d27 <alltraps>

80106927 <vector184>:
.globl vector184
vector184:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $184
80106929:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010692e:	e9 f4 f3 ff ff       	jmp    80105d27 <alltraps>

80106933 <vector185>:
.globl vector185
vector185:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $185
80106935:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010693a:	e9 e8 f3 ff ff       	jmp    80105d27 <alltraps>

8010693f <vector186>:
.globl vector186
vector186:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $186
80106941:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106946:	e9 dc f3 ff ff       	jmp    80105d27 <alltraps>

8010694b <vector187>:
.globl vector187
vector187:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $187
8010694d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106952:	e9 d0 f3 ff ff       	jmp    80105d27 <alltraps>

80106957 <vector188>:
.globl vector188
vector188:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $188
80106959:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010695e:	e9 c4 f3 ff ff       	jmp    80105d27 <alltraps>

80106963 <vector189>:
.globl vector189
vector189:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $189
80106965:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010696a:	e9 b8 f3 ff ff       	jmp    80105d27 <alltraps>

8010696f <vector190>:
.globl vector190
vector190:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $190
80106971:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106976:	e9 ac f3 ff ff       	jmp    80105d27 <alltraps>

8010697b <vector191>:
.globl vector191
vector191:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $191
8010697d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106982:	e9 a0 f3 ff ff       	jmp    80105d27 <alltraps>

80106987 <vector192>:
.globl vector192
vector192:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $192
80106989:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010698e:	e9 94 f3 ff ff       	jmp    80105d27 <alltraps>

80106993 <vector193>:
.globl vector193
vector193:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $193
80106995:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010699a:	e9 88 f3 ff ff       	jmp    80105d27 <alltraps>

8010699f <vector194>:
.globl vector194
vector194:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $194
801069a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069a6:	e9 7c f3 ff ff       	jmp    80105d27 <alltraps>

801069ab <vector195>:
.globl vector195
vector195:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $195
801069ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069b2:	e9 70 f3 ff ff       	jmp    80105d27 <alltraps>

801069b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $196
801069b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069be:	e9 64 f3 ff ff       	jmp    80105d27 <alltraps>

801069c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $197
801069c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069ca:	e9 58 f3 ff ff       	jmp    80105d27 <alltraps>

801069cf <vector198>:
.globl vector198
vector198:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $198
801069d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069d6:	e9 4c f3 ff ff       	jmp    80105d27 <alltraps>

801069db <vector199>:
.globl vector199
vector199:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $199
801069dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069e2:	e9 40 f3 ff ff       	jmp    80105d27 <alltraps>

801069e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $200
801069e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069ee:	e9 34 f3 ff ff       	jmp    80105d27 <alltraps>

801069f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $201
801069f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069fa:	e9 28 f3 ff ff       	jmp    80105d27 <alltraps>

801069ff <vector202>:
.globl vector202
vector202:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $202
80106a01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a06:	e9 1c f3 ff ff       	jmp    80105d27 <alltraps>

80106a0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $203
80106a0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a12:	e9 10 f3 ff ff       	jmp    80105d27 <alltraps>

80106a17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $204
80106a19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a1e:	e9 04 f3 ff ff       	jmp    80105d27 <alltraps>

80106a23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $205
80106a25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a2a:	e9 f8 f2 ff ff       	jmp    80105d27 <alltraps>

80106a2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $206
80106a31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a36:	e9 ec f2 ff ff       	jmp    80105d27 <alltraps>

80106a3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $207
80106a3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a42:	e9 e0 f2 ff ff       	jmp    80105d27 <alltraps>

80106a47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $208
80106a49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a4e:	e9 d4 f2 ff ff       	jmp    80105d27 <alltraps>

80106a53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $209
80106a55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a5a:	e9 c8 f2 ff ff       	jmp    80105d27 <alltraps>

80106a5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $210
80106a61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a66:	e9 bc f2 ff ff       	jmp    80105d27 <alltraps>

80106a6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $211
80106a6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a72:	e9 b0 f2 ff ff       	jmp    80105d27 <alltraps>

80106a77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $212
80106a79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a7e:	e9 a4 f2 ff ff       	jmp    80105d27 <alltraps>

80106a83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $213
80106a85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a8a:	e9 98 f2 ff ff       	jmp    80105d27 <alltraps>

80106a8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $214
80106a91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a96:	e9 8c f2 ff ff       	jmp    80105d27 <alltraps>

80106a9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $215
80106a9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106aa2:	e9 80 f2 ff ff       	jmp    80105d27 <alltraps>

80106aa7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $216
80106aa9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106aae:	e9 74 f2 ff ff       	jmp    80105d27 <alltraps>

80106ab3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $217
80106ab5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aba:	e9 68 f2 ff ff       	jmp    80105d27 <alltraps>

80106abf <vector218>:
.globl vector218
vector218:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $218
80106ac1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ac6:	e9 5c f2 ff ff       	jmp    80105d27 <alltraps>

80106acb <vector219>:
.globl vector219
vector219:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $219
80106acd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ad2:	e9 50 f2 ff ff       	jmp    80105d27 <alltraps>

80106ad7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $220
80106ad9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ade:	e9 44 f2 ff ff       	jmp    80105d27 <alltraps>

80106ae3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $221
80106ae5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aea:	e9 38 f2 ff ff       	jmp    80105d27 <alltraps>

80106aef <vector222>:
.globl vector222
vector222:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $222
80106af1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106af6:	e9 2c f2 ff ff       	jmp    80105d27 <alltraps>

80106afb <vector223>:
.globl vector223
vector223:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $223
80106afd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b02:	e9 20 f2 ff ff       	jmp    80105d27 <alltraps>

80106b07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $224
80106b09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b0e:	e9 14 f2 ff ff       	jmp    80105d27 <alltraps>

80106b13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $225
80106b15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b1a:	e9 08 f2 ff ff       	jmp    80105d27 <alltraps>

80106b1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $226
80106b21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b26:	e9 fc f1 ff ff       	jmp    80105d27 <alltraps>

80106b2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $227
80106b2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b32:	e9 f0 f1 ff ff       	jmp    80105d27 <alltraps>

80106b37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $228
80106b39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b3e:	e9 e4 f1 ff ff       	jmp    80105d27 <alltraps>

80106b43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $229
80106b45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b4a:	e9 d8 f1 ff ff       	jmp    80105d27 <alltraps>

80106b4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $230
80106b51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b56:	e9 cc f1 ff ff       	jmp    80105d27 <alltraps>

80106b5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $231
80106b5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b62:	e9 c0 f1 ff ff       	jmp    80105d27 <alltraps>

80106b67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $232
80106b69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b6e:	e9 b4 f1 ff ff       	jmp    80105d27 <alltraps>

80106b73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $233
80106b75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b7a:	e9 a8 f1 ff ff       	jmp    80105d27 <alltraps>

80106b7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $234
80106b81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b86:	e9 9c f1 ff ff       	jmp    80105d27 <alltraps>

80106b8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $235
80106b8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b92:	e9 90 f1 ff ff       	jmp    80105d27 <alltraps>

80106b97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $236
80106b99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b9e:	e9 84 f1 ff ff       	jmp    80105d27 <alltraps>

80106ba3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $237
80106ba5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106baa:	e9 78 f1 ff ff       	jmp    80105d27 <alltraps>

80106baf <vector238>:
.globl vector238
vector238:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $238
80106bb1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106bb6:	e9 6c f1 ff ff       	jmp    80105d27 <alltraps>

80106bbb <vector239>:
.globl vector239
vector239:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $239
80106bbd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bc2:	e9 60 f1 ff ff       	jmp    80105d27 <alltraps>

80106bc7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $240
80106bc9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bce:	e9 54 f1 ff ff       	jmp    80105d27 <alltraps>

80106bd3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $241
80106bd5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bda:	e9 48 f1 ff ff       	jmp    80105d27 <alltraps>

80106bdf <vector242>:
.globl vector242
vector242:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $242
80106be1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106be6:	e9 3c f1 ff ff       	jmp    80105d27 <alltraps>

80106beb <vector243>:
.globl vector243
vector243:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $243
80106bed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bf2:	e9 30 f1 ff ff       	jmp    80105d27 <alltraps>

80106bf7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $244
80106bf9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bfe:	e9 24 f1 ff ff       	jmp    80105d27 <alltraps>

80106c03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $245
80106c05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c0a:	e9 18 f1 ff ff       	jmp    80105d27 <alltraps>

80106c0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $246
80106c11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c16:	e9 0c f1 ff ff       	jmp    80105d27 <alltraps>

80106c1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $247
80106c1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c22:	e9 00 f1 ff ff       	jmp    80105d27 <alltraps>

80106c27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $248
80106c29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c2e:	e9 f4 f0 ff ff       	jmp    80105d27 <alltraps>

80106c33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $249
80106c35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c3a:	e9 e8 f0 ff ff       	jmp    80105d27 <alltraps>

80106c3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $250
80106c41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c46:	e9 dc f0 ff ff       	jmp    80105d27 <alltraps>

80106c4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $251
80106c4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c52:	e9 d0 f0 ff ff       	jmp    80105d27 <alltraps>

80106c57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $252
80106c59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c5e:	e9 c4 f0 ff ff       	jmp    80105d27 <alltraps>

80106c63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $253
80106c65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c6a:	e9 b8 f0 ff ff       	jmp    80105d27 <alltraps>

80106c6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $254
80106c71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c76:	e9 ac f0 ff ff       	jmp    80105d27 <alltraps>

80106c7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $255
80106c7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c82:	e9 a0 f0 ff ff       	jmp    80105d27 <alltraps>
80106c87:	66 90                	xchg   %ax,%ax
80106c89:	66 90                	xchg   %ax,%ax
80106c8b:	66 90                	xchg   %ax,%ax
80106c8d:	66 90                	xchg   %ax,%ax
80106c8f:	90                   	nop

80106c90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c96:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c9c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca2:	83 ec 1c             	sub    $0x1c,%esp
80106ca5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ca8:	39 d3                	cmp    %edx,%ebx
80106caa:	73 49                	jae    80106cf5 <deallocuvm.part.0+0x65>
80106cac:	89 c7                	mov    %eax,%edi
80106cae:	eb 0c                	jmp    80106cbc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cb0:	83 c0 01             	add    $0x1,%eax
80106cb3:	c1 e0 16             	shl    $0x16,%eax
80106cb6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cb8:	39 da                	cmp    %ebx,%edx
80106cba:	76 39                	jbe    80106cf5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106cbc:	89 d8                	mov    %ebx,%eax
80106cbe:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106cc1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106cc4:	f6 c1 01             	test   $0x1,%cl
80106cc7:	74 e7                	je     80106cb0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106cc9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ccb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106cd1:	c1 ee 0a             	shr    $0xa,%esi
80106cd4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106cda:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106ce1:	85 f6                	test   %esi,%esi
80106ce3:	74 cb                	je     80106cb0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106ce5:	8b 06                	mov    (%esi),%eax
80106ce7:	a8 01                	test   $0x1,%al
80106ce9:	75 15                	jne    80106d00 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106ceb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cf1:	39 da                	cmp    %ebx,%edx
80106cf3:	77 c7                	ja     80106cbc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cfb:	5b                   	pop    %ebx
80106cfc:	5e                   	pop    %esi
80106cfd:	5f                   	pop    %edi
80106cfe:	5d                   	pop    %ebp
80106cff:	c3                   	ret
      if(pa == 0)
80106d00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d05:	74 25                	je     80106d2c <deallocuvm.part.0+0x9c>
      kfree(v);
80106d07:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d0a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d12:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d18:	50                   	push   %eax
80106d19:	e8 b2 b8 ff ff       	call   801025d0 <kfree>
      *pte = 0;
80106d1e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106d24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d27:	83 c4 10             	add    $0x10,%esp
80106d2a:	eb 8c                	jmp    80106cb8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106d2c:	83 ec 0c             	sub    $0xc,%esp
80106d2f:	68 4c 78 10 80       	push   $0x8010784c
80106d34:	e8 47 96 ff ff       	call   80100380 <panic>
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d40 <mappages>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d46:	89 d3                	mov    %edx,%ebx
80106d48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d4e:	83 ec 1c             	sub    $0x1c,%esp
80106d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d60:	8b 45 08             	mov    0x8(%ebp),%eax
80106d63:	29 d8                	sub    %ebx,%eax
80106d65:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d68:	eb 3d                	jmp    80106da7 <mappages+0x67>
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d70:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d77:	c1 ea 0a             	shr    $0xa,%edx
80106d7a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d80:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d87:	85 c0                	test   %eax,%eax
80106d89:	74 75                	je     80106e00 <mappages+0xc0>
    if(*pte & PTE_P)
80106d8b:	f6 00 01             	testb  $0x1,(%eax)
80106d8e:	0f 85 86 00 00 00    	jne    80106e1a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d94:	0b 75 0c             	or     0xc(%ebp),%esi
80106d97:	83 ce 01             	or     $0x1,%esi
80106d9a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d9c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106d9f:	74 6f                	je     80106e10 <mappages+0xd0>
    a += PGSIZE;
80106da1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106daa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dad:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106db0:	89 d8                	mov    %ebx,%eax
80106db2:	c1 e8 16             	shr    $0x16,%eax
80106db5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106db8:	8b 07                	mov    (%edi),%eax
80106dba:	a8 01                	test   $0x1,%al
80106dbc:	75 b2                	jne    80106d70 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106dbe:	e8 cd b9 ff ff       	call   80102790 <kalloc>
80106dc3:	85 c0                	test   %eax,%eax
80106dc5:	74 39                	je     80106e00 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106dc7:	83 ec 04             	sub    $0x4,%esp
80106dca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106dcd:	68 00 10 00 00       	push   $0x1000
80106dd2:	6a 00                	push   $0x0
80106dd4:	50                   	push   %eax
80106dd5:	e8 b6 da ff ff       	call   80104890 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dda:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106ddd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106de0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106de6:	83 c8 07             	or     $0x7,%eax
80106de9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106deb:	89 d8                	mov    %ebx,%eax
80106ded:	c1 e8 0a             	shr    $0xa,%eax
80106df0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106df5:	01 d0                	add    %edx,%eax
80106df7:	eb 92                	jmp    80106d8b <mappages+0x4b>
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e08:	5b                   	pop    %ebx
80106e09:	5e                   	pop    %esi
80106e0a:	5f                   	pop    %edi
80106e0b:	5d                   	pop    %ebp
80106e0c:	c3                   	ret
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e13:	31 c0                	xor    %eax,%eax
}
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5f                   	pop    %edi
80106e18:	5d                   	pop    %ebp
80106e19:	c3                   	ret
      panic("remap");
80106e1a:	83 ec 0c             	sub    $0xc,%esp
80106e1d:	68 9f 7a 10 80       	push   $0x80107a9f
80106e22:	e8 59 95 ff ff       	call   80100380 <panic>
80106e27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e2e:	00 
80106e2f:	90                   	nop

80106e30 <seginit>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e36:	e8 d5 cc ff ff       	call   80103b10 <cpuid>
  pd[0] = size-1;
80106e3b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e40:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e46:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e4a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106e51:	ff 00 00 
80106e54:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106e5b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e5e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106e65:	ff 00 00 
80106e68:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106e6f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e72:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106e79:	ff 00 00 
80106e7c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106e83:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e86:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106e8d:	ff 00 00 
80106e90:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106e97:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e9a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106e9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ea3:	c1 e8 10             	shr    $0x10,%eax
80106ea6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eaa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ead:	0f 01 10             	lgdtl  (%eax)
}
80106eb0:	c9                   	leave
80106eb1:	c3                   	ret
80106eb2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106eb9:	00 
80106eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ec0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ec0:	a1 44 56 11 80       	mov    0x80115644,%eax
80106ec5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eca:	0f 22 d8             	mov    %eax,%cr3
}
80106ecd:	c3                   	ret
80106ece:	66 90                	xchg   %ax,%ax

80106ed0 <switchuvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106edc:	85 f6                	test   %esi,%esi
80106ede:	0f 84 cb 00 00 00    	je     80106faf <switchuvm+0xdf>
  if(p->kstack == 0)
80106ee4:	8b 46 08             	mov    0x8(%esi),%eax
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	0f 84 da 00 00 00    	je     80106fc9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106eef:	8b 46 04             	mov    0x4(%esi),%eax
80106ef2:	85 c0                	test   %eax,%eax
80106ef4:	0f 84 c2 00 00 00    	je     80106fbc <switchuvm+0xec>
  pushcli();
80106efa:	e8 81 d7 ff ff       	call   80104680 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eff:	e8 ac cb ff ff       	call   80103ab0 <mycpu>
80106f04:	89 c3                	mov    %eax,%ebx
80106f06:	e8 a5 cb ff ff       	call   80103ab0 <mycpu>
80106f0b:	89 c7                	mov    %eax,%edi
80106f0d:	e8 9e cb ff ff       	call   80103ab0 <mycpu>
80106f12:	83 c7 08             	add    $0x8,%edi
80106f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f18:	e8 93 cb ff ff       	call   80103ab0 <mycpu>
80106f1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f20:	ba 67 00 00 00       	mov    $0x67,%edx
80106f25:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f2c:	83 c0 08             	add    $0x8,%eax
80106f2f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f36:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f3b:	83 c1 08             	add    $0x8,%ecx
80106f3e:	c1 e8 18             	shr    $0x18,%eax
80106f41:	c1 e9 10             	shr    $0x10,%ecx
80106f44:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f4a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f50:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f55:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f5c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f61:	e8 4a cb ff ff       	call   80103ab0 <mycpu>
80106f66:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f6d:	e8 3e cb ff ff       	call   80103ab0 <mycpu>
80106f72:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f76:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f7f:	e8 2c cb ff ff       	call   80103ab0 <mycpu>
80106f84:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f87:	e8 24 cb ff ff       	call   80103ab0 <mycpu>
80106f8c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f90:	b8 28 00 00 00       	mov    $0x28,%eax
80106f95:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f98:	8b 46 04             	mov    0x4(%esi),%eax
80106f9b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fa0:	0f 22 d8             	mov    %eax,%cr3
}
80106fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa6:	5b                   	pop    %ebx
80106fa7:	5e                   	pop    %esi
80106fa8:	5f                   	pop    %edi
80106fa9:	5d                   	pop    %ebp
  popcli();
80106faa:	e9 21 d7 ff ff       	jmp    801046d0 <popcli>
    panic("switchuvm: no process");
80106faf:	83 ec 0c             	sub    $0xc,%esp
80106fb2:	68 a5 7a 10 80       	push   $0x80107aa5
80106fb7:	e8 c4 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106fbc:	83 ec 0c             	sub    $0xc,%esp
80106fbf:	68 d0 7a 10 80       	push   $0x80107ad0
80106fc4:	e8 b7 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106fc9:	83 ec 0c             	sub    $0xc,%esp
80106fcc:	68 bb 7a 10 80       	push   $0x80107abb
80106fd1:	e8 aa 93 ff ff       	call   80100380 <panic>
80106fd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fdd:	00 
80106fde:	66 90                	xchg   %ax,%ax

80106fe0 <inituvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 1c             	sub    $0x1c,%esp
80106fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fec:	8b 75 10             	mov    0x10(%ebp),%esi
80106fef:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ff5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ffb:	77 4b                	ja     80107048 <inituvm+0x68>
  mem = kalloc();
80106ffd:	e8 8e b7 ff ff       	call   80102790 <kalloc>
  memset(mem, 0, PGSIZE);
80107002:	83 ec 04             	sub    $0x4,%esp
80107005:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010700a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010700c:	6a 00                	push   $0x0
8010700e:	50                   	push   %eax
8010700f:	e8 7c d8 ff ff       	call   80104890 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107014:	58                   	pop    %eax
80107015:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010701b:	5a                   	pop    %edx
8010701c:	6a 06                	push   $0x6
8010701e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107023:	31 d2                	xor    %edx,%edx
80107025:	50                   	push   %eax
80107026:	89 f8                	mov    %edi,%eax
80107028:	e8 13 fd ff ff       	call   80106d40 <mappages>
  memmove(mem, init, sz);
8010702d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107030:	89 75 10             	mov    %esi,0x10(%ebp)
80107033:	83 c4 10             	add    $0x10,%esp
80107036:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107039:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010703c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703f:	5b                   	pop    %ebx
80107040:	5e                   	pop    %esi
80107041:	5f                   	pop    %edi
80107042:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107043:	e9 e8 d8 ff ff       	jmp    80104930 <memmove>
    panic("inituvm: more than a page");
80107048:	83 ec 0c             	sub    $0xc,%esp
8010704b:	68 e4 7a 10 80       	push   $0x80107ae4
80107050:	e8 2b 93 ff ff       	call   80100380 <panic>
80107055:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010705c:	00 
8010705d:	8d 76 00             	lea    0x0(%esi),%esi

80107060 <loaduvm>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	83 ec 1c             	sub    $0x1c,%esp
80107069:	8b 45 0c             	mov    0xc(%ebp),%eax
8010706c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010706f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107074:	0f 85 bb 00 00 00    	jne    80107135 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010707a:	01 f0                	add    %esi,%eax
8010707c:	89 f3                	mov    %esi,%ebx
8010707e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107081:	8b 45 14             	mov    0x14(%ebp),%eax
80107084:	01 f0                	add    %esi,%eax
80107086:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107089:	85 f6                	test   %esi,%esi
8010708b:	0f 84 87 00 00 00    	je     80107118 <loaduvm+0xb8>
80107091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010709b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010709e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801070a0:	89 c2                	mov    %eax,%edx
801070a2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801070a5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801070a8:	f6 c2 01             	test   $0x1,%dl
801070ab:	75 13                	jne    801070c0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801070ad:	83 ec 0c             	sub    $0xc,%esp
801070b0:	68 fe 7a 10 80       	push   $0x80107afe
801070b5:	e8 c6 92 ff ff       	call   80100380 <panic>
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801070c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801070ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070d5:	85 c0                	test   %eax,%eax
801070d7:	74 d4                	je     801070ad <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801070d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801070de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801070ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070f1:	29 d9                	sub    %ebx,%ecx
801070f3:	05 00 00 00 80       	add    $0x80000000,%eax
801070f8:	57                   	push   %edi
801070f9:	51                   	push   %ecx
801070fa:	50                   	push   %eax
801070fb:	ff 75 10             	push   0x10(%ebp)
801070fe:	e8 9d aa ff ff       	call   80101ba0 <readi>
80107103:	83 c4 10             	add    $0x10,%esp
80107106:	39 f8                	cmp    %edi,%eax
80107108:	75 1e                	jne    80107128 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010710a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107110:	89 f0                	mov    %esi,%eax
80107112:	29 d8                	sub    %ebx,%eax
80107114:	39 c6                	cmp    %eax,%esi
80107116:	77 80                	ja     80107098 <loaduvm+0x38>
}
80107118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010711b:	31 c0                	xor    %eax,%eax
}
8010711d:	5b                   	pop    %ebx
8010711e:	5e                   	pop    %esi
8010711f:	5f                   	pop    %edi
80107120:	5d                   	pop    %ebp
80107121:	c3                   	ret
80107122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107128:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010712b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107130:	5b                   	pop    %ebx
80107131:	5e                   	pop    %esi
80107132:	5f                   	pop    %edi
80107133:	5d                   	pop    %ebp
80107134:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80107135:	83 ec 0c             	sub    $0xc,%esp
80107138:	68 90 7d 10 80       	push   $0x80107d90
8010713d:	e8 3e 92 ff ff       	call   80100380 <panic>
80107142:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107149:	00 
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107150 <allocuvm>:
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107159:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010715c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010715f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107162:	85 c0                	test   %eax,%eax
80107164:	0f 88 b6 00 00 00    	js     80107220 <allocuvm+0xd0>
  if(newsz < oldsz)
8010716a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010716d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107170:	0f 82 9a 00 00 00    	jb     80107210 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107176:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010717c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107182:	39 75 10             	cmp    %esi,0x10(%ebp)
80107185:	77 44                	ja     801071cb <allocuvm+0x7b>
80107187:	e9 87 00 00 00       	jmp    80107213 <allocuvm+0xc3>
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
80107193:	68 00 10 00 00       	push   $0x1000
80107198:	6a 00                	push   $0x0
8010719a:	50                   	push   %eax
8010719b:	e8 f0 d6 ff ff       	call   80104890 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071a0:	58                   	pop    %eax
801071a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071a7:	5a                   	pop    %edx
801071a8:	6a 06                	push   $0x6
801071aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071af:	89 f2                	mov    %esi,%edx
801071b1:	50                   	push   %eax
801071b2:	89 f8                	mov    %edi,%eax
801071b4:	e8 87 fb ff ff       	call   80106d40 <mappages>
801071b9:	83 c4 10             	add    $0x10,%esp
801071bc:	85 c0                	test   %eax,%eax
801071be:	78 78                	js     80107238 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801071c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801071c9:	76 48                	jbe    80107213 <allocuvm+0xc3>
    mem = kalloc();
801071cb:	e8 c0 b5 ff ff       	call   80102790 <kalloc>
801071d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071d2:	85 c0                	test   %eax,%eax
801071d4:	75 ba                	jne    80107190 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071d6:	83 ec 0c             	sub    $0xc,%esp
801071d9:	68 1c 7b 10 80       	push   $0x80107b1c
801071de:	e8 bd 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801071e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e6:	83 c4 10             	add    $0x10,%esp
801071e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801071ec:	74 32                	je     80107220 <allocuvm+0xd0>
801071ee:	8b 55 10             	mov    0x10(%ebp),%edx
801071f1:	89 c1                	mov    %eax,%ecx
801071f3:	89 f8                	mov    %edi,%eax
801071f5:	e8 96 fa ff ff       	call   80106c90 <deallocuvm.part.0>
      return 0;
801071fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107207:	5b                   	pop    %ebx
80107208:	5e                   	pop    %esi
80107209:	5f                   	pop    %edi
8010720a:	5d                   	pop    %ebp
8010720b:	c3                   	ret
8010720c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107219:	5b                   	pop    %ebx
8010721a:	5e                   	pop    %esi
8010721b:	5f                   	pop    %edi
8010721c:	5d                   	pop    %ebp
8010721d:	c3                   	ret
8010721e:	66 90                	xchg   %ax,%ax
    return 0;
80107220:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010722a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010722d:	5b                   	pop    %ebx
8010722e:	5e                   	pop    %esi
8010722f:	5f                   	pop    %edi
80107230:	5d                   	pop    %ebp
80107231:	c3                   	ret
80107232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107238:	83 ec 0c             	sub    $0xc,%esp
8010723b:	68 34 7b 10 80       	push   $0x80107b34
80107240:	e8 5b 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107245:	8b 45 0c             	mov    0xc(%ebp),%eax
80107248:	83 c4 10             	add    $0x10,%esp
8010724b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010724e:	74 0c                	je     8010725c <allocuvm+0x10c>
80107250:	8b 55 10             	mov    0x10(%ebp),%edx
80107253:	89 c1                	mov    %eax,%ecx
80107255:	89 f8                	mov    %edi,%eax
80107257:	e8 34 fa ff ff       	call   80106c90 <deallocuvm.part.0>
      kfree(mem);
8010725c:	83 ec 0c             	sub    $0xc,%esp
8010725f:	53                   	push   %ebx
80107260:	e8 6b b3 ff ff       	call   801025d0 <kfree>
      return 0;
80107265:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010726c:	83 c4 10             	add    $0x10,%esp
}
8010726f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107272:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret
8010727a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107280 <deallocuvm>:
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	8b 55 0c             	mov    0xc(%ebp),%edx
80107286:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107289:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010728c:	39 d1                	cmp    %edx,%ecx
8010728e:	73 10                	jae    801072a0 <deallocuvm+0x20>
}
80107290:	5d                   	pop    %ebp
80107291:	e9 fa f9 ff ff       	jmp    80106c90 <deallocuvm.part.0>
80107296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010729d:	00 
8010729e:	66 90                	xchg   %ax,%ax
801072a0:	89 d0                	mov    %edx,%eax
801072a2:	5d                   	pop    %ebp
801072a3:	c3                   	ret
801072a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072ab:	00 
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 0c             	sub    $0xc,%esp
801072b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072bc:	85 f6                	test   %esi,%esi
801072be:	74 59                	je     80107319 <freevm+0x69>
  if(newsz >= oldsz)
801072c0:	31 c9                	xor    %ecx,%ecx
801072c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072c7:	89 f0                	mov    %esi,%eax
801072c9:	89 f3                	mov    %esi,%ebx
801072cb:	e8 c0 f9 ff ff       	call   80106c90 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072d6:	eb 0f                	jmp    801072e7 <freevm+0x37>
801072d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072df:	00 
801072e0:	83 c3 04             	add    $0x4,%ebx
801072e3:	39 df                	cmp    %ebx,%edi
801072e5:	74 23                	je     8010730a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072e7:	8b 03                	mov    (%ebx),%eax
801072e9:	a8 01                	test   $0x1,%al
801072eb:	74 f3                	je     801072e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072f2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072fd:	50                   	push   %eax
801072fe:	e8 cd b2 ff ff       	call   801025d0 <kfree>
80107303:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107306:	39 df                	cmp    %ebx,%edi
80107308:	75 dd                	jne    801072e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010730a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010730d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5f                   	pop    %edi
80107313:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107314:	e9 b7 b2 ff ff       	jmp    801025d0 <kfree>
    panic("freevm: no pgdir");
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	68 50 7b 10 80       	push   $0x80107b50
80107321:	e8 5a 90 ff ff       	call   80100380 <panic>
80107326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010732d:	00 
8010732e:	66 90                	xchg   %ax,%ax

80107330 <setupkvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	56                   	push   %esi
80107334:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107335:	e8 56 b4 ff ff       	call   80102790 <kalloc>
8010733a:	89 c6                	mov    %eax,%esi
8010733c:	85 c0                	test   %eax,%eax
8010733e:	74 42                	je     80107382 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107340:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107343:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107348:	68 00 10 00 00       	push   $0x1000
8010734d:	6a 00                	push   $0x0
8010734f:	50                   	push   %eax
80107350:	e8 3b d5 ff ff       	call   80104890 <memset>
80107355:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107358:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010735b:	83 ec 08             	sub    $0x8,%esp
8010735e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107361:	ff 73 0c             	push   0xc(%ebx)
80107364:	8b 13                	mov    (%ebx),%edx
80107366:	50                   	push   %eax
80107367:	29 c1                	sub    %eax,%ecx
80107369:	89 f0                	mov    %esi,%eax
8010736b:	e8 d0 f9 ff ff       	call   80106d40 <mappages>
80107370:	83 c4 10             	add    $0x10,%esp
80107373:	85 c0                	test   %eax,%eax
80107375:	78 19                	js     80107390 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107377:	83 c3 10             	add    $0x10,%ebx
8010737a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107380:	75 d6                	jne    80107358 <setupkvm+0x28>
}
80107382:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107385:	89 f0                	mov    %esi,%eax
80107387:	5b                   	pop    %ebx
80107388:	5e                   	pop    %esi
80107389:	5d                   	pop    %ebp
8010738a:	c3                   	ret
8010738b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107390:	83 ec 0c             	sub    $0xc,%esp
80107393:	56                   	push   %esi
      return 0;
80107394:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107396:	e8 15 ff ff ff       	call   801072b0 <freevm>
      return 0;
8010739b:	83 c4 10             	add    $0x10,%esp
}
8010739e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073a1:	89 f0                	mov    %esi,%eax
801073a3:	5b                   	pop    %ebx
801073a4:	5e                   	pop    %esi
801073a5:	5d                   	pop    %ebp
801073a6:	c3                   	ret
801073a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073ae:	00 
801073af:	90                   	nop

801073b0 <kvmalloc>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073b6:	e8 75 ff ff ff       	call   80107330 <setupkvm>
801073bb:	a3 44 56 11 80       	mov    %eax,0x80115644
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073c0:	05 00 00 00 80       	add    $0x80000000,%eax
801073c5:	0f 22 d8             	mov    %eax,%cr3
}
801073c8:	c9                   	leave
801073c9:	c3                   	ret
801073ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	83 ec 08             	sub    $0x8,%esp
801073d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073d9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073dc:	89 c1                	mov    %eax,%ecx
801073de:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073e1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073e4:	f6 c2 01             	test   $0x1,%dl
801073e7:	75 17                	jne    80107400 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073e9:	83 ec 0c             	sub    $0xc,%esp
801073ec:	68 61 7b 10 80       	push   $0x80107b61
801073f1:	e8 8a 8f ff ff       	call   80100380 <panic>
801073f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073fd:	00 
801073fe:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107400:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107403:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107409:	25 fc 0f 00 00       	and    $0xffc,%eax
8010740e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107415:	85 c0                	test   %eax,%eax
80107417:	74 d0                	je     801073e9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107419:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010741c:	c9                   	leave
8010741d:	c3                   	ret
8010741e:	66 90                	xchg   %ax,%ax

80107420 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107429:	e8 02 ff ff ff       	call   80107330 <setupkvm>
8010742e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107431:	85 c0                	test   %eax,%eax
80107433:	0f 84 bd 00 00 00    	je     801074f6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010743c:	85 c9                	test   %ecx,%ecx
8010743e:	0f 84 b2 00 00 00    	je     801074f6 <copyuvm+0xd6>
80107444:	31 f6                	xor    %esi,%esi
80107446:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010744d:	00 
8010744e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107450:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107453:	89 f0                	mov    %esi,%eax
80107455:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107458:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010745b:	a8 01                	test   $0x1,%al
8010745d:	75 11                	jne    80107470 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010745f:	83 ec 0c             	sub    $0xc,%esp
80107462:	68 6b 7b 10 80       	push   $0x80107b6b
80107467:	e8 14 8f ff ff       	call   80100380 <panic>
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107470:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107472:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107477:	c1 ea 0a             	shr    $0xa,%edx
8010747a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107480:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107487:	85 c0                	test   %eax,%eax
80107489:	74 d4                	je     8010745f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010748b:	8b 00                	mov    (%eax),%eax
8010748d:	a8 01                	test   $0x1,%al
8010748f:	0f 84 9f 00 00 00    	je     80107534 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107495:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107497:	25 ff 0f 00 00       	and    $0xfff,%eax
8010749c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010749f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801074a5:	e8 e6 b2 ff ff       	call   80102790 <kalloc>
801074aa:	89 c3                	mov    %eax,%ebx
801074ac:	85 c0                	test   %eax,%eax
801074ae:	74 64                	je     80107514 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074b0:	83 ec 04             	sub    $0x4,%esp
801074b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801074b9:	68 00 10 00 00       	push   $0x1000
801074be:	57                   	push   %edi
801074bf:	50                   	push   %eax
801074c0:	e8 6b d4 ff ff       	call   80104930 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074c5:	58                   	pop    %eax
801074c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074cc:	5a                   	pop    %edx
801074cd:	ff 75 e4             	push   -0x1c(%ebp)
801074d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074d5:	89 f2                	mov    %esi,%edx
801074d7:	50                   	push   %eax
801074d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074db:	e8 60 f8 ff ff       	call   80106d40 <mappages>
801074e0:	83 c4 10             	add    $0x10,%esp
801074e3:	85 c0                	test   %eax,%eax
801074e5:	78 21                	js     80107508 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801074e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074ed:	39 75 0c             	cmp    %esi,0xc(%ebp)
801074f0:	0f 87 5a ff ff ff    	ja     80107450 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801074f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074fc:	5b                   	pop    %ebx
801074fd:	5e                   	pop    %esi
801074fe:	5f                   	pop    %edi
801074ff:	5d                   	pop    %ebp
80107500:	c3                   	ret
80107501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107508:	83 ec 0c             	sub    $0xc,%esp
8010750b:	53                   	push   %ebx
8010750c:	e8 bf b0 ff ff       	call   801025d0 <kfree>
      goto bad;
80107511:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107514:	83 ec 0c             	sub    $0xc,%esp
80107517:	ff 75 e0             	push   -0x20(%ebp)
8010751a:	e8 91 fd ff ff       	call   801072b0 <freevm>
  return 0;
8010751f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107526:	83 c4 10             	add    $0x10,%esp
}
80107529:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010752c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010752f:	5b                   	pop    %ebx
80107530:	5e                   	pop    %esi
80107531:	5f                   	pop    %edi
80107532:	5d                   	pop    %ebp
80107533:	c3                   	ret
      panic("copyuvm: page not present");
80107534:	83 ec 0c             	sub    $0xc,%esp
80107537:	68 85 7b 10 80       	push   $0x80107b85
8010753c:	e8 3f 8e ff ff       	call   80100380 <panic>
80107541:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107548:	00 
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107550 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107556:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107559:	89 c1                	mov    %eax,%ecx
8010755b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010755e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107561:	f6 c2 01             	test   $0x1,%dl
80107564:	0f 84 00 01 00 00    	je     8010766a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010756a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010756d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107573:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107574:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107579:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107580:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107582:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107587:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010758a:	05 00 00 00 80       	add    $0x80000000,%eax
8010758f:	83 fa 05             	cmp    $0x5,%edx
80107592:	ba 00 00 00 00       	mov    $0x0,%edx
80107597:	0f 45 c2             	cmovne %edx,%eax
}
8010759a:	c3                   	ret
8010759b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801075a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	8b 75 14             	mov    0x14(%ebp),%esi
801075ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801075af:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075b2:	85 f6                	test   %esi,%esi
801075b4:	75 51                	jne    80107607 <copyout+0x67>
801075b6:	e9 a5 00 00 00       	jmp    80107660 <copyout+0xc0>
801075bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801075c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801075c6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801075cc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801075d2:	74 75                	je     80107649 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801075d4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075d6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801075d9:	29 c3                	sub    %eax,%ebx
801075db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075e1:	39 f3                	cmp    %esi,%ebx
801075e3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801075e6:	29 f8                	sub    %edi,%eax
801075e8:	83 ec 04             	sub    $0x4,%esp
801075eb:	01 c1                	add    %eax,%ecx
801075ed:	53                   	push   %ebx
801075ee:	52                   	push   %edx
801075ef:	51                   	push   %ecx
801075f0:	e8 3b d3 ff ff       	call   80104930 <memmove>
    len -= n;
    buf += n;
801075f5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801075f8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801075fe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107601:	01 da                	add    %ebx,%edx
  while(len > 0){
80107603:	29 de                	sub    %ebx,%esi
80107605:	74 59                	je     80107660 <copyout+0xc0>
  if(*pde & PTE_P){
80107607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010760a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010760c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010760e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107611:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107617:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010761a:	f6 c1 01             	test   $0x1,%cl
8010761d:	0f 84 4e 00 00 00    	je     80107671 <copyout.cold>
  return &pgtab[PTX(va)];
80107623:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107625:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010762b:	c1 eb 0c             	shr    $0xc,%ebx
8010762e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107634:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010763b:	89 d9                	mov    %ebx,%ecx
8010763d:	83 e1 05             	and    $0x5,%ecx
80107640:	83 f9 05             	cmp    $0x5,%ecx
80107643:	0f 84 77 ff ff ff    	je     801075c0 <copyout+0x20>
  }
  return 0;
}
80107649:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010764c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107651:	5b                   	pop    %ebx
80107652:	5e                   	pop    %esi
80107653:	5f                   	pop    %edi
80107654:	5d                   	pop    %ebp
80107655:	c3                   	ret
80107656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010765d:	00 
8010765e:	66 90                	xchg   %ax,%ax
80107660:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107663:	31 c0                	xor    %eax,%eax
}
80107665:	5b                   	pop    %ebx
80107666:	5e                   	pop    %esi
80107667:	5f                   	pop    %edi
80107668:	5d                   	pop    %ebp
80107669:	c3                   	ret

8010766a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010766a:	a1 00 00 00 00       	mov    0x0,%eax
8010766f:	0f 0b                	ud2

80107671 <copyout.cold>:
80107671:	a1 00 00 00 00       	mov    0x0,%eax
80107676:	0f 0b                	ud2
