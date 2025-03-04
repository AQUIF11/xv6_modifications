
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
8010004c:	68 00 77 10 80       	push   $0x80107700
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 b5 44 00 00       	call   80104510 <initlock>
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
80100092:	68 07 77 10 80       	push   $0x80107707
80100097:	50                   	push   %eax
80100098:	e8 43 43 00 00       	call   801043e0 <initsleeplock>
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
801000e4:	e8 f7 45 00 00       	call   801046e0 <acquire>
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
80100162:	e8 19 45 00 00       	call   80104680 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 42 00 00       	call   80104420 <acquiresleep>
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
801001a1:	68 0e 77 10 80       	push   $0x8010770e
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
801001be:	e8 fd 42 00 00       	call   801044c0 <holdingsleep>
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
801001dc:	68 1f 77 10 80       	push   $0x8010771f
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
801001ff:	e8 bc 42 00 00       	call   801044c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 42 00 00       	call   80104480 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 c0 44 00 00       	call   801046e0 <acquire>
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
8010026c:	e9 0f 44 00 00       	jmp    80104680 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 77 10 80       	push   $0x80107726
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
801002a0:	e8 3b 44 00 00       	call   801046e0 <acquire>
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
801002cd:	e8 ae 3e 00 00       	call   80104180 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 59 37 00 00       	call   80103a40 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 85 43 00 00       	call   80104680 <release>
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
8010034c:	e8 2f 43 00 00       	call   80104680 <release>
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
801003a2:	68 2d 77 10 80       	push   $0x8010772d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 2e 7c 10 80 	movl   $0x80107c2e,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 41 00 00       	call   80104530 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 77 10 80       	push   $0x80107741
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
8010041a:	e8 f1 5d 00 00       	call   80106210 <uartputc>
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
80100505:	e8 06 5d 00 00       	call   80106210 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 fa 5c 00 00       	call   80106210 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ee 5c 00 00       	call   80106210 <uartputc>
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
80100551:	e8 ea 42 00 00       	call   80104840 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 35 42 00 00       	call   801047a0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 45 77 10 80       	push   $0x80107745
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
801005ab:	e8 30 41 00 00       	call   801046e0 <acquire>
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
801005e4:	e8 97 40 00 00       	call   80104680 <release>
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
80100636:	0f b6 92 80 7c 10 80 	movzbl -0x7fef8380(%edx),%edx
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
801007e8:	e8 f3 3e 00 00       	call   801046e0 <acquire>
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
80100838:	bf 58 77 10 80       	mov    $0x80107758,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 20 3e 00 00       	call   80104680 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 5f 77 10 80       	push   $0x8010775f
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
80100893:	e8 48 3e 00 00       	call   801046e0 <acquire>
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
801009d0:	e8 ab 3c 00 00       	call   80104680 <release>
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
80100a0e:	e9 0d 39 00 00       	jmp    80104320 <procdump>
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
80100a44:	e8 f7 37 00 00       	call   80104240 <wakeup>
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
80100a66:	68 68 77 10 80       	push   $0x80107768
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 9b 3a 00 00       	call   80104510 <initlock>

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
80100abc:	e8 7f 2f 00 00       	call   80103a40 <myproc>
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
80100b34:	e8 67 68 00 00       	call   801073a0 <setupkvm>
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
80100ba3:	e8 18 66 00 00       	call   801071c0 <allocuvm>
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
80100bd9:	e8 f2 64 00 00       	call   801070d0 <loaduvm>
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
80100c1b:	e8 00 67 00 00       	call   80107320 <freevm>
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
80100c62:	e8 59 65 00 00       	call   801071c0 <allocuvm>
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
80100c83:	e8 b8 67 00 00       	call   80107440 <clearpteu>
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
80100cd3:	e8 c8 3c 00 00       	call   801049a0 <strlen>
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
80100ce7:	e8 b4 3c 00 00       	call   801049a0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 13 69 00 00       	call   80107610 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 0a 66 00 00       	call   80107320 <freevm>
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
80100d63:	e8 a8 68 00 00       	call   80107610 <copyout>
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
80100da1:	e8 ba 3b 00 00       	call   80104960 <safestrcpy>
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
80100dcd:	e8 6e 61 00 00       	call   80106f40 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 46 65 00 00       	call   80107320 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 f7 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 70 77 10 80       	push   $0x80107770
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
80100e16:	68 7c 77 10 80       	push   $0x8010777c
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 eb 36 00 00       	call   80104510 <initlock>
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
80100e41:	e8 9a 38 00 00       	call   801046e0 <acquire>
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
80100e71:	e8 0a 38 00 00       	call   80104680 <release>
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
80100e8a:	e8 f1 37 00 00       	call   80104680 <release>
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
80100eaf:	e8 2c 38 00 00       	call   801046e0 <acquire>
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
80100ecc:	e8 af 37 00 00       	call   80104680 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave
80100ed7:	c3                   	ret
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 83 77 10 80       	push   $0x80107783
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
80100f01:	e8 da 37 00 00       	call   801046e0 <acquire>
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
80100f3c:	e8 3f 37 00 00       	call   80104680 <release>

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
80100f6e:	e9 0d 37 00 00       	jmp    80104680 <release>
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
80100fbc:	68 8b 77 10 80       	push   $0x8010778b
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
801010a2:	68 95 77 10 80       	push   $0x80107795
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
80101177:	68 9e 77 10 80       	push   $0x8010779e
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
801011b1:	68 a4 77 10 80       	push   $0x801077a4
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
80101227:	68 ae 77 10 80       	push   $0x801077ae
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
801012e4:	68 c1 77 10 80       	push   $0x801077c1
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
80101325:	e8 76 34 00 00       	call   801047a0 <memset>
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
8010136a:	e8 71 33 00 00       	call   801046e0 <acquire>
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
801013d7:	e8 a4 32 00 00       	call   80104680 <release>

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
80101405:	e8 76 32 00 00       	call   80104680 <release>
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
80101438:	68 d7 77 10 80       	push   $0x801077d7
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
80101515:	68 e7 77 10 80       	push   $0x801077e7
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
80101541:	e8 fa 32 00 00       	call   80104840 <memmove>
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
8010156c:	68 fa 77 10 80       	push   $0x801077fa
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 95 2f 00 00       	call   80104510 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 01 78 10 80       	push   $0x80107801
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 94 00 00 00    	add    $0x94,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 4c 2e 00 00       	call   801043e0 <initsleeplock>
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
801015bc:	e8 7f 32 00 00       	call   80104840 <memmove>
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
801015f3:	68 94 7c 10 80       	push   $0x80107c94
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
80101691:	e8 0a 31 00 00       	call   801047a0 <memset>
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
801016c6:	68 07 78 10 80       	push   $0x80107807
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
80101731:	e8 0a 31 00 00       	call   80104840 <memmove>
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
8010176f:	e8 6c 2f 00 00       	call   801046e0 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010177f:	e8 fc 2e 00 00       	call   80104680 <release>
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
801017b6:	e8 65 2c 00 00       	call   80104420 <acquiresleep>
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
80101828:	e8 13 30 00 00       	call   80104840 <memmove>
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
80101856:	68 1f 78 10 80       	push   $0x8010781f
8010185b:	e8 20 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	68 19 78 10 80       	push   $0x80107819
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
80101883:	e8 38 2c 00 00       	call   801044c0 <holdingsleep>
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
8010189f:	e9 dc 2b 00 00       	jmp    80104480 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 2e 78 10 80       	push   $0x8010782e
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
801018d0:	e8 4b 2b 00 00       	call   80104420 <acquiresleep>
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
801018ea:	e8 91 2b 00 00       	call   80104480 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018f6:	e8 e5 2d 00 00       	call   801046e0 <acquire>
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
80101910:	e9 6b 2d 00 00       	jmp    80104680 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 60 09 11 80       	push   $0x80110960
80101920:	e8 bb 2d 00 00       	call   801046e0 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010192f:	e8 4c 2d 00 00       	call   80104680 <release>
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
80101a33:	e8 88 2a 00 00       	call   801044c0 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 31 2a 00 00       	call   80104480 <releasesleep>
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
80101a63:	68 2e 78 10 80       	push   $0x8010782e
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
80101b47:	e8 f4 2c 00 00       	call   80104840 <memmove>
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
80101c43:	e8 f8 2b 00 00       	call   80104840 <memmove>
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
80101cde:	e8 cd 2b 00 00       	call   801048b0 <strncmp>
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
80101d3d:	e8 6e 2b 00 00       	call   801048b0 <strncmp>
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
80101d82:	68 48 78 10 80       	push   $0x80107848
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 36 78 10 80       	push   $0x80107836
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
80101dba:	e8 81 1c 00 00       	call   80103a40 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 09 11 80       	push   $0x80110960
80101dca:	e8 11 29 00 00       	call   801046e0 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dda:	e8 a1 28 00 00       	call   80104680 <release>
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
80101e37:	e8 04 2a 00 00       	call   80104840 <memmove>
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
80101e9c:	e8 1f 26 00 00       	call   801044c0 <holdingsleep>
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
80101ebe:	e8 bd 25 00 00       	call   80104480 <releasesleep>
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
80101eeb:	e8 50 29 00 00       	call   80104840 <memmove>
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
80101f3b:	e8 80 25 00 00       	call   801044c0 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 21 25 00 00       	call   80104480 <releasesleep>
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
80101f7d:	e8 3e 25 00 00       	call   801044c0 <holdingsleep>
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
80101fa0:	e8 1b 25 00 00       	call   801044c0 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 c4 24 00 00       	call   80104480 <releasesleep>
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
80101fdf:	68 2e 78 10 80       	push   $0x8010782e
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
8010204d:	e8 ae 28 00 00       	call   80104900 <strncpy>
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
8010208b:	68 57 78 10 80       	push   $0x80107857
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 d2 7a 10 80       	push   $0x80107ad2
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
801021ab:	68 6d 78 10 80       	push   $0x8010786d
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 64 78 10 80       	push   $0x80107864
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
801021d6:	68 7f 78 10 80       	push   $0x8010787f
801021db:	68 c0 26 11 80       	push   $0x801126c0
801021e0:	e8 2b 23 00 00       	call   80104510 <initlock>
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
8010225e:	e8 7d 24 00 00       	call   801046e0 <acquire>

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
801022bd:	e8 7e 1f 00 00       	call   80104240 <wakeup>

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
801022db:	e8 a0 23 00 00       	call   80104680 <release>

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
801022fe:	e8 bd 21 00 00       	call   801044c0 <holdingsleep>
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
80102338:	e8 a3 23 00 00       	call   801046e0 <acquire>

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
80102379:	e8 02 1e 00 00       	call   80104180 <sleep>
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
80102396:	e9 e5 22 00 00       	jmp    80104680 <release>
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
801023ba:	68 ae 78 10 80       	push   $0x801078ae
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 99 78 10 80       	push   $0x80107899
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 83 78 10 80       	push   $0x80107883
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
8010242a:	68 e8 7c 10 80       	push   $0x80107ce8
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
80102502:	e8 99 22 00 00       	call   801047a0 <memset>

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
80102538:	e8 a3 21 00 00       	call   801046e0 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 00 27 11 80 	movl   $0x80112700,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave
    release(&kmem.lock);
80102553:	e9 28 21 00 00       	jmp    80104680 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 cc 78 10 80       	push   $0x801078cc
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
8010262b:	68 d2 78 10 80       	push   $0x801078d2
80102630:	68 00 27 11 80       	push   $0x80112700
80102635:	e8 d6 1e 00 00       	call   80104510 <initlock>
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
801026c3:	e8 18 20 00 00       	call   801046e0 <acquire>
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
801026f1:	e8 8a 1f 00 00       	call   80104680 <release>
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
8010273b:	0f b6 91 60 7f 10 80 	movzbl -0x7fef80a0(%ecx),%edx
  shift ^= togglecode[data];
80102742:	0f b6 81 60 7e 10 80 	movzbl -0x7fef81a0(%ecx),%eax
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
8010275b:	8b 04 85 40 7e 10 80 	mov    -0x7fef81c0(,%eax,4),%eax
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
80102798:	0f b6 81 60 7f 10 80 	movzbl -0x7fef80a0(%ecx),%eax
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
80102b07:	e8 e4 1c 00 00       	call   801047f0 <memcmp>
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
80102c34:	e8 07 1c 00 00       	call   80104840 <memmove>
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
80102cda:	68 d7 78 10 80       	push   $0x801078d7
80102cdf:	68 60 27 11 80       	push   $0x80112760
80102ce4:	e8 27 18 00 00       	call   80104510 <initlock>
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
80102d7b:	e8 60 19 00 00       	call   801046e0 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 60 27 11 80       	push   $0x80112760
80102d90:	68 60 27 11 80       	push   $0x80112760
80102d95:	e8 e6 13 00 00       	call   80104180 <sleep>
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
80102dcc:	e8 af 18 00 00       	call   80104680 <release>
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
80102dee:	e8 ed 18 00 00       	call   801046e0 <acquire>
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
80102e2c:	e8 4f 18 00 00       	call   80104680 <release>
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
80102e46:	e8 95 18 00 00       	call   801046e0 <acquire>
    wakeup(&log);
80102e4b:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
    log.committing = 0;
80102e52:	c7 05 a0 27 11 80 00 	movl   $0x0,0x801127a0
80102e59:	00 00 00 
    wakeup(&log);
80102e5c:	e8 df 13 00 00       	call   80104240 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
80102e68:	e8 13 18 00 00       	call   80104680 <release>
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
80102ec4:	e8 77 19 00 00       	call   80104840 <memmove>
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
80102f18:	e8 23 13 00 00       	call   80104240 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
80102f24:	e8 57 17 00 00       	call   80104680 <release>
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
80102f37:	68 db 78 10 80       	push   $0x801078db
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
80102f86:	e8 55 17 00 00       	call   801046e0 <acquire>
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
80102fc5:	e9 b6 16 00 00       	jmp    80104680 <release>
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
80102ff1:	68 ea 78 10 80       	push   $0x801078ea
80102ff6:	e8 85 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 00 79 10 80       	push   $0x80107900
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
80103017:	e8 04 0a 00 00       	call   80103a20 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 fd 09 00 00       	call   80103a20 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 1b 79 10 80       	push   $0x8010791b
8010302d:	e8 6e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 09 2e 00 00       	call   80105e40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 84 09 00 00       	call   801039c0 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 b1 0c 00 00       	call   80103d00 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 d5 3e 00 00       	call   80106f30 <switchkvm>
  seginit();
8010305b:	e8 40 3e 00 00       	call   80106ea0 <seginit>
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
80103091:	e8 8a 43 00 00       	call   80107420 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 85 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 fb 3d 00 00       	call   80106ea0 <seginit>
  picinit();       // disable pic
801030a5:	e8 76 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 31 f3 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 ac d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 77 30 00 00       	call   80106130 <uartinit>
  pinit();         // process table
801030b9:	e8 e2 08 00 00       	call   801039a0 <pinit>
  tvinit();        // trap vectors
801030be:	e8 fd 2c 00 00       	call   80105dc0 <tvinit>
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
801030e4:	e8 57 17 00 00       	call   80104840 <memmove>

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
80103129:	e8 92 08 00 00       	call   801039c0 <mycpu>
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
80103192:	e8 d9 08 00 00       	call   80103a70 <userinit>
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
801031ce:	68 2f 79 10 80       	push   $0x8010792f
801031d3:	56                   	push   %esi
801031d4:	e8 17 16 00 00       	call   801047f0 <memcmp>
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
80103286:	68 34 79 10 80       	push   $0x80107934
8010328b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010328f:	e8 5c 15 00 00       	call   801047f0 <memcmp>
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
801033a3:	68 39 79 10 80       	push   $0x80107939
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
801033d2:	68 2f 79 10 80       	push   $0x8010792f
801033d7:	53                   	push   %ebx
801033d8:	e8 13 14 00 00       	call   801047f0 <memcmp>
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
80103408:	68 1c 7d 10 80       	push   $0x80107d1c
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
801034b3:	68 51 79 10 80       	push   $0x80107951
801034b8:	50                   	push   %eax
801034b9:	e8 52 10 00 00       	call   80104510 <initlock>
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
8010354f:	e8 8c 11 00 00       	call   801046e0 <acquire>
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
8010356f:	e8 cc 0c 00 00       	call   80104240 <wakeup>
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
80103594:	e9 e7 10 00 00       	jmp    80104680 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 d7 10 00 00       	call   80104680 <release>
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
801035d4:	e8 67 0c 00 00       	call   80104240 <wakeup>
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
801035ed:	e8 ee 10 00 00       	call   801046e0 <acquire>
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
80103638:	e8 03 04 00 00       	call   80103a40 <myproc>
8010363d:	8b 48 24             	mov    0x24(%eax),%ecx
80103640:	85 c9                	test   %ecx,%ecx
80103642:	75 34                	jne    80103678 <pipewrite+0x98>
      wakeup(&p->nread);
80103644:	83 ec 0c             	sub    $0xc,%esp
80103647:	57                   	push   %edi
80103648:	e8 f3 0b 00 00       	call   80104240 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	53                   	push   %ebx
80103650:	56                   	push   %esi
80103651:	e8 2a 0b 00 00       	call   80104180 <sleep>
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
8010367c:	e8 ff 0f 00 00       	call   80104680 <release>
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
801036ca:	e8 71 0b 00 00       	call   80104240 <wakeup>
  release(&p->lock);
801036cf:	89 1c 24             	mov    %ebx,(%esp)
801036d2:	e8 a9 0f 00 00       	call   80104680 <release>
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
801036f6:	e8 e5 0f 00 00       	call   801046e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010370a:	74 2f                	je     8010373b <piperead+0x5b>
8010370c:	eb 37                	jmp    80103745 <piperead+0x65>
8010370e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103710:	e8 2b 03 00 00       	call   80103a40 <myproc>
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
80103725:	e8 56 0a 00 00       	call   80104180 <sleep>
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
80103786:	e8 b5 0a 00 00       	call   80104240 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 ed 0e 00 00       	call   80104680 <release>
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
801037a9:	e8 d2 0e 00 00       	call   80104680 <release>
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
801037c3:	56                   	push   %esi
801037c4:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c5:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
  acquire(&ptable.lock);
801037ca:	83 ec 0c             	sub    $0xc,%esp
801037cd:	68 e0 2d 11 80       	push   $0x80112de0
801037d2:	e8 09 0f 00 00       	call   801046e0 <acquire>
801037d7:	83 c4 10             	add    $0x10,%esp
801037da:	eb 13                	jmp    801037ef <allocproc+0x2f>
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	83 c3 7c             	add    $0x7c,%ebx
801037e3:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
801037e9:	0f 84 29 01 00 00    	je     80103918 <allocproc+0x158>
    if(p->state == UNUSED)
801037ef:	8b 43 0c             	mov    0xc(%ebx),%eax
801037f2:	85 c0                	test   %eax,%eax
801037f4:	75 ea                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f6:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037fb:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037fe:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103805:	89 43 10             	mov    %eax,0x10(%ebx)
80103808:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010380b:	68 e0 2d 11 80       	push   $0x80112de0
  p->pid = nextpid++;
80103810:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103816:	e8 65 0e 00 00       	call   80104680 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010381b:	e8 70 ee ff ff       	call   80102690 <kalloc>
80103820:	83 c4 10             	add    $0x10,%esp
80103823:	89 43 08             	mov    %eax,0x8(%ebx)
80103826:	85 c0                	test   %eax,%eax
80103828:	0f 84 05 01 00 00    	je     80103933 <allocproc+0x173>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010382e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103834:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103837:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010383c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010383f:	c7 40 14 af 5d 10 80 	movl   $0x80105daf,0x14(%eax)
  p->context = (struct context*)sp;
80103846:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103849:	6a 14                	push   $0x14
8010384b:	6a 00                	push   $0x0
8010384d:	50                   	push   %eax
8010384e:	e8 4d 0f 00 00       	call   801047a0 <memset>
  p->context->eip = (uint)forkret;
80103853:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid == 1 || p->pid == 2) {
80103856:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103859:	c7 40 10 50 39 10 80 	movl   $0x80103950,0x10(%eax)
  if(p->pid == 1 || p->pid == 2) {
80103860:	8b 43 10             	mov    0x10(%ebx),%eax
80103863:	83 e8 01             	sub    $0x1,%eax
80103866:	83 f8 01             	cmp    $0x1,%eax
80103869:	0f 86 9c 00 00 00    	jbe    8010390b <allocproc+0x14b>
    return p;
  }

  // Make sure process name is set before adding to history
  safestrcpy(p->name, "unknown", sizeof(p->name));  // Default name
8010386f:	83 ec 04             	sub    $0x4,%esp
80103872:	8d 73 6c             	lea    0x6c(%ebx),%esi
80103875:	6a 10                	push   $0x10
80103877:	68 56 79 10 80       	push   $0x80107956
8010387c:	56                   	push   %esi
8010387d:	e8 de 10 00 00       	call   80104960 <safestrcpy>

  // Add process to history (Circular Buffer)
  acquire(&ptable.lock);
80103882:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103889:	e8 52 0e 00 00       	call   801046e0 <acquire>
  process_history[history_index].pid = p->pid;
8010388e:	a1 14 4d 11 80       	mov    0x80114d14,%eax
80103893:	8b 53 10             	mov    0x10(%ebx),%edx
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
80103896:	83 c4 0c             	add    $0xc,%esp
80103899:	6a 10                	push   $0x10
  process_history[history_index].pid = p->pid;
8010389b:	8d 04 40             	lea    (%eax,%eax,2),%eax
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
8010389e:	56                   	push   %esi
  process_history[history_index].pid = p->pid;
8010389f:	c1 e0 03             	shl    $0x3,%eax
801038a2:	89 90 20 4d 11 80    	mov    %edx,-0x7feeb2e0(%eax)
  safestrcpy(process_history[history_index].name, p->name, CMD_NAME_MAX);
801038a8:	05 24 4d 11 80       	add    $0x80114d24,%eax
801038ad:	50                   	push   %eax
801038ae:	e8 ad 10 00 00       	call   80104960 <safestrcpy>
  process_history[history_index].mem_usage = p->sz;
801038b3:	8b 0d 14 4d 11 80    	mov    0x80114d14,%ecx
801038b9:	8b 13                	mov    (%ebx),%edx

  // Update history index (Circular Buffer)
  history_index = (history_index + 1) % MAX_HISTORY;
  if (history_count < MAX_HISTORY) {
801038bb:	83 c4 10             	add    $0x10,%esp
  process_history[history_index].mem_usage = p->sz;
801038be:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  history_index = (history_index + 1) % MAX_HISTORY;
801038c1:	83 c1 01             	add    $0x1,%ecx
  process_history[history_index].mem_usage = p->sz;
801038c4:	89 14 c5 34 4d 11 80 	mov    %edx,-0x7feeb2cc(,%eax,8)
  history_index = (history_index + 1) % MAX_HISTORY;
801038cb:	89 c8                	mov    %ecx,%eax
801038cd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801038d2:	f7 ea                	imul   %edx
801038d4:	89 c8                	mov    %ecx,%eax
801038d6:	c1 f8 1f             	sar    $0x1f,%eax
801038d9:	c1 fa 05             	sar    $0x5,%edx
801038dc:	29 c2                	sub    %eax,%edx
801038de:	6b c2 64             	imul   $0x64,%edx,%eax
801038e1:	29 c1                	sub    %eax,%ecx
  if (history_count < MAX_HISTORY) {
801038e3:	a1 18 4d 11 80       	mov    0x80114d18,%eax
  history_index = (history_index + 1) % MAX_HISTORY;
801038e8:	89 0d 14 4d 11 80    	mov    %ecx,0x80114d14
  if (history_count < MAX_HISTORY) {
801038ee:	83 f8 63             	cmp    $0x63,%eax
801038f1:	7f 08                	jg     801038fb <allocproc+0x13b>
      history_count++;  // Keep track of number of stored records
801038f3:	83 c0 01             	add    $0x1,%eax
801038f6:	a3 18 4d 11 80       	mov    %eax,0x80114d18
  }
  release(&ptable.lock);
801038fb:	83 ec 0c             	sub    $0xc,%esp
801038fe:	68 e0 2d 11 80       	push   $0x80112de0
80103903:	e8 78 0d 00 00       	call   80104680 <release>

  return p;
80103908:	83 c4 10             	add    $0x10,%esp
}
8010390b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010390e:	89 d8                	mov    %ebx,%eax
80103910:	5b                   	pop    %ebx
80103911:	5e                   	pop    %esi
80103912:	5d                   	pop    %ebp
80103913:	c3                   	ret
80103914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103918:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010391b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010391d:	68 e0 2d 11 80       	push   $0x80112de0
80103922:	e8 59 0d 00 00       	call   80104680 <release>
  return 0;
80103927:	83 c4 10             	add    $0x10,%esp
}
8010392a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010392d:	89 d8                	mov    %ebx,%eax
8010392f:	5b                   	pop    %ebx
80103930:	5e                   	pop    %esi
80103931:	5d                   	pop    %ebp
80103932:	c3                   	ret
    p->state = UNUSED;
80103933:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
8010393a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010393d:	31 db                	xor    %ebx,%ebx
}
8010393f:	89 d8                	mov    %ebx,%eax
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret
80103945:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010394c:	00 
8010394d:	8d 76 00             	lea    0x0(%esi),%esi

80103950 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103956:	68 e0 2d 11 80       	push   $0x80112de0
8010395b:	e8 20 0d 00 00       	call   80104680 <release>

  if (first) {
80103960:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	85 c0                	test   %eax,%eax
8010396a:	75 04                	jne    80103970 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010396c:	c9                   	leave
8010396d:	c3                   	ret
8010396e:	66 90                	xchg   %ax,%ax
    first = 0;
80103970:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103977:	00 00 00 
    iinit(ROOTDEV);
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	6a 01                	push   $0x1
8010397f:	e8 dc db ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103984:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010398b:	e8 40 f3 ff ff       	call   80102cd0 <initlog>
}
80103990:	83 c4 10             	add    $0x10,%esp
80103993:	c9                   	leave
80103994:	c3                   	ret
80103995:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010399c:	00 
8010399d:	8d 76 00             	lea    0x0(%esi),%esi

801039a0 <pinit>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039a6:	68 5e 79 10 80       	push   $0x8010795e
801039ab:	68 e0 2d 11 80       	push   $0x80112de0
801039b0:	e8 5b 0b 00 00       	call   80104510 <initlock>
}
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	c9                   	leave
801039b9:	c3                   	ret
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <mycpu>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	56                   	push   %esi
801039c4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039c5:	9c                   	pushf
801039c6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039c7:	f6 c4 02             	test   $0x2,%ah
801039ca:	75 46                	jne    80103a12 <mycpu+0x52>
  apicid = lapicid();
801039cc:	e8 2f ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039d1:	8b 35 44 28 11 80    	mov    0x80112844,%esi
801039d7:	85 f6                	test   %esi,%esi
801039d9:	7e 2a                	jle    80103a05 <mycpu+0x45>
801039db:	31 d2                	xor    %edx,%edx
801039dd:	eb 08                	jmp    801039e7 <mycpu+0x27>
801039df:	90                   	nop
801039e0:	83 c2 01             	add    $0x1,%edx
801039e3:	39 f2                	cmp    %esi,%edx
801039e5:	74 1e                	je     80103a05 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039e7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039ed:	0f b6 99 60 28 11 80 	movzbl -0x7feed7a0(%ecx),%ebx
801039f4:	39 c3                	cmp    %eax,%ebx
801039f6:	75 e8                	jne    801039e0 <mycpu+0x20>
}
801039f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039fb:	8d 81 60 28 11 80    	lea    -0x7feed7a0(%ecx),%eax
}
80103a01:	5b                   	pop    %ebx
80103a02:	5e                   	pop    %esi
80103a03:	5d                   	pop    %ebp
80103a04:	c3                   	ret
  panic("unknown apicid\n");
80103a05:	83 ec 0c             	sub    $0xc,%esp
80103a08:	68 65 79 10 80       	push   $0x80107965
80103a0d:	e8 6e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a12:	83 ec 0c             	sub    $0xc,%esp
80103a15:	68 3c 7d 10 80       	push   $0x80107d3c
80103a1a:	e8 61 c9 ff ff       	call   80100380 <panic>
80103a1f:	90                   	nop

80103a20 <cpuid>:
cpuid() {
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a26:	e8 95 ff ff ff       	call   801039c0 <mycpu>
}
80103a2b:	c9                   	leave
  return mycpu()-cpus;
80103a2c:	2d 60 28 11 80       	sub    $0x80112860,%eax
80103a31:	c1 f8 04             	sar    $0x4,%eax
80103a34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a3a:	c3                   	ret
80103a3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a40 <myproc>:
myproc(void) {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a47:	e8 44 0b 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103a4c:	e8 6f ff ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103a51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a57:	e8 84 0b 00 00       	call   801045e0 <popcli>
}
80103a5c:	89 d8                	mov    %ebx,%eax
80103a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a61:	c9                   	leave
80103a62:	c3                   	ret
80103a63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a6a:	00 
80103a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a70 <userinit>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	53                   	push   %ebx
80103a74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a77:	e8 44 fd ff ff       	call   801037c0 <allocproc>
80103a7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a7e:	a3 80 56 11 80       	mov    %eax,0x80115680
  if((p->pgdir = setupkvm()) == 0)
80103a83:	e8 18 39 00 00       	call   801073a0 <setupkvm>
80103a88:	89 43 04             	mov    %eax,0x4(%ebx)
80103a8b:	85 c0                	test   %eax,%eax
80103a8d:	0f 84 bd 00 00 00    	je     80103b50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a93:	83 ec 04             	sub    $0x4,%esp
80103a96:	68 2c 00 00 00       	push   $0x2c
80103a9b:	68 60 b4 10 80       	push   $0x8010b460
80103aa0:	50                   	push   %eax
80103aa1:	e8 aa 35 00 00       	call   80107050 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103aa6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103aa9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aaf:	6a 4c                	push   $0x4c
80103ab1:	6a 00                	push   $0x0
80103ab3:	ff 73 18             	push   0x18(%ebx)
80103ab6:	e8 e5 0c 00 00       	call   801047a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abb:	8b 43 18             	mov    0x18(%ebx),%eax
80103abe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ac3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ac6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103acb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103acf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ad6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103add:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ae1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ae8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103aec:	8b 43 18             	mov    0x18(%ebx),%eax
80103aef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103af6:	8b 43 18             	mov    0x18(%ebx),%eax
80103af9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b00:	8b 43 18             	mov    0x18(%ebx),%eax
80103b03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b0d:	6a 10                	push   $0x10
80103b0f:	68 8e 79 10 80       	push   $0x8010798e
80103b14:	50                   	push   %eax
80103b15:	e8 46 0e 00 00       	call   80104960 <safestrcpy>
  p->cwd = namei("/");
80103b1a:	c7 04 24 97 79 10 80 	movl   $0x80107997,(%esp)
80103b21:	e8 8a e5 ff ff       	call   801020b0 <namei>
80103b26:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b29:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103b30:	e8 ab 0b 00 00       	call   801046e0 <acquire>
  p->state = RUNNABLE;
80103b35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b3c:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103b43:	e8 38 0b 00 00       	call   80104680 <release>
}
80103b48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b4b:	83 c4 10             	add    $0x10,%esp
80103b4e:	c9                   	leave
80103b4f:	c3                   	ret
    panic("userinit: out of memory?");
80103b50:	83 ec 0c             	sub    $0xc,%esp
80103b53:	68 75 79 10 80       	push   $0x80107975
80103b58:	e8 23 c8 ff ff       	call   80100380 <panic>
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi

80103b60 <growproc>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
80103b65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b68:	e8 23 0a 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103b6d:	e8 4e fe ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103b72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b78:	e8 63 0a 00 00       	call   801045e0 <popcli>
  sz = curproc->sz;
80103b7d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b7f:	85 f6                	test   %esi,%esi
80103b81:	7f 1d                	jg     80103ba0 <growproc+0x40>
  } else if(n < 0){
80103b83:	75 3b                	jne    80103bc0 <growproc+0x60>
  switchuvm(curproc);
80103b85:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b88:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b8a:	53                   	push   %ebx
80103b8b:	e8 b0 33 00 00       	call   80106f40 <switchuvm>
  return 0;
80103b90:	83 c4 10             	add    $0x10,%esp
80103b93:	31 c0                	xor    %eax,%eax
}
80103b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b98:	5b                   	pop    %ebx
80103b99:	5e                   	pop    %esi
80103b9a:	5d                   	pop    %ebp
80103b9b:	c3                   	ret
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	01 c6                	add    %eax,%esi
80103ba5:	56                   	push   %esi
80103ba6:	50                   	push   %eax
80103ba7:	ff 73 04             	push   0x4(%ebx)
80103baa:	e8 11 36 00 00       	call   801071c0 <allocuvm>
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	75 cf                	jne    80103b85 <growproc+0x25>
      return -1;
80103bb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bbb:	eb d8                	jmp    80103b95 <growproc+0x35>
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bc0:	83 ec 04             	sub    $0x4,%esp
80103bc3:	01 c6                	add    %eax,%esi
80103bc5:	56                   	push   %esi
80103bc6:	50                   	push   %eax
80103bc7:	ff 73 04             	push   0x4(%ebx)
80103bca:	e8 21 37 00 00       	call   801072f0 <deallocuvm>
80103bcf:	83 c4 10             	add    $0x10,%esp
80103bd2:	85 c0                	test   %eax,%eax
80103bd4:	75 af                	jne    80103b85 <growproc+0x25>
80103bd6:	eb de                	jmp    80103bb6 <growproc+0x56>
80103bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bdf:	00 

80103be0 <fork>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103be9:	e8 a2 09 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103bee:	e8 cd fd ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103bf3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf9:	e8 e2 09 00 00       	call   801045e0 <popcli>
  if((np = allocproc()) == 0){
80103bfe:	e8 bd fb ff ff       	call   801037c0 <allocproc>
80103c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c06:	85 c0                	test   %eax,%eax
80103c08:	0f 84 b7 00 00 00    	je     80103cc5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c0e:	83 ec 08             	sub    $0x8,%esp
80103c11:	ff 33                	push   (%ebx)
80103c13:	89 c7                	mov    %eax,%edi
80103c15:	ff 73 04             	push   0x4(%ebx)
80103c18:	e8 73 38 00 00       	call   80107490 <copyuvm>
80103c1d:	83 c4 10             	add    $0x10,%esp
80103c20:	89 47 04             	mov    %eax,0x4(%edi)
80103c23:	85 c0                	test   %eax,%eax
80103c25:	0f 84 a1 00 00 00    	je     80103ccc <fork+0xec>
  np->sz = curproc->sz;
80103c2b:	8b 03                	mov    (%ebx),%eax
80103c2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c30:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c32:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c35:	89 c8                	mov    %ecx,%eax
80103c37:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c3a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c3f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c46:	8b 40 18             	mov    0x18(%eax),%eax
80103c49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c54:	85 c0                	test   %eax,%eax
80103c56:	74 13                	je     80103c6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	50                   	push   %eax
80103c5c:	e8 3f d2 ff ff       	call   80100ea0 <filedup>
80103c61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c64:	83 c4 10             	add    $0x10,%esp
80103c67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c6b:	83 c6 01             	add    $0x1,%esi
80103c6e:	83 fe 10             	cmp    $0x10,%esi
80103c71:	75 dd                	jne    80103c50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c73:	83 ec 0c             	sub    $0xc,%esp
80103c76:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c79:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c7c:	e8 df da ff ff       	call   80101760 <idup>
80103c81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c87:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c8d:	6a 10                	push   $0x10
80103c8f:	53                   	push   %ebx
80103c90:	50                   	push   %eax
80103c91:	e8 ca 0c 00 00       	call   80104960 <safestrcpy>
  pid = np->pid;
80103c96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c99:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103ca0:	e8 3b 0a 00 00       	call   801046e0 <acquire>
  np->state = RUNNABLE;
80103ca5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103cac:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103cb3:	e8 c8 09 00 00       	call   80104680 <release>
  return pid;
80103cb8:	83 c4 10             	add    $0x10,%esp
}
80103cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cbe:	89 d8                	mov    %ebx,%eax
80103cc0:	5b                   	pop    %ebx
80103cc1:	5e                   	pop    %esi
80103cc2:	5f                   	pop    %edi
80103cc3:	5d                   	pop    %ebp
80103cc4:	c3                   	ret
    return -1;
80103cc5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cca:	eb ef                	jmp    80103cbb <fork+0xdb>
    kfree(np->kstack);
80103ccc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ccf:	83 ec 0c             	sub    $0xc,%esp
80103cd2:	ff 73 08             	push   0x8(%ebx)
80103cd5:	e8 f6 e7 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103cda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103ce1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ce4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ceb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cf0:	eb c9                	jmp    80103cbb <fork+0xdb>
80103cf2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cf9:	00 
80103cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d00 <scheduler>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d09:	e8 b2 fc ff ff       	call   801039c0 <mycpu>
  c->proc = 0;
80103d0e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d15:	00 00 00 
  struct cpu *c = mycpu();
80103d18:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d1a:	8d 78 04             	lea    0x4(%eax),%edi
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d20:	fb                   	sti
    acquire(&ptable.lock);
80103d21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d24:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
    acquire(&ptable.lock);
80103d29:	68 e0 2d 11 80       	push   $0x80112de0
80103d2e:	e8 ad 09 00 00       	call   801046e0 <acquire>
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d3d:	00 
80103d3e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d44:	75 33                	jne    80103d79 <scheduler+0x79>
      switchuvm(p);
80103d46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d4f:	53                   	push   %ebx
80103d50:	e8 eb 31 00 00       	call   80106f40 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d55:	58                   	pop    %eax
80103d56:	5a                   	pop    %edx
80103d57:	ff 73 1c             	push   0x1c(%ebx)
80103d5a:	57                   	push   %edi
      p->state = RUNNING;
80103d5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d62:	e8 54 0c 00 00       	call   801049bb <swtch>
      switchkvm();
80103d67:	e8 c4 31 00 00       	call   80106f30 <switchkvm>
      c->proc = 0;
80103d6c:	83 c4 10             	add    $0x10,%esp
80103d6f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d76:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d79:	83 c3 7c             	add    $0x7c,%ebx
80103d7c:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80103d82:	75 bc                	jne    80103d40 <scheduler+0x40>
    release(&ptable.lock);
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 e0 2d 11 80       	push   $0x80112de0
80103d8c:	e8 ef 08 00 00       	call   80104680 <release>
    sti();
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	eb 8a                	jmp    80103d20 <scheduler+0x20>
80103d96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d9d:	00 
80103d9e:	66 90                	xchg   %ax,%ax

80103da0 <sched>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	56                   	push   %esi
80103da4:	53                   	push   %ebx
  pushcli();
80103da5:	e8 e6 07 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103daa:	e8 11 fc ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103daf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db5:	e8 26 08 00 00       	call   801045e0 <popcli>
  if(!holding(&ptable.lock))
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 e0 2d 11 80       	push   $0x80112de0
80103dc2:	e8 79 08 00 00       	call   80104640 <holding>
80103dc7:	83 c4 10             	add    $0x10,%esp
80103dca:	85 c0                	test   %eax,%eax
80103dcc:	74 4f                	je     80103e1d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dce:	e8 ed fb ff ff       	call   801039c0 <mycpu>
80103dd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dda:	75 68                	jne    80103e44 <sched+0xa4>
  if(p->state == RUNNING)
80103ddc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103de0:	74 55                	je     80103e37 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103de2:	9c                   	pushf
80103de3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103de4:	f6 c4 02             	test   $0x2,%ah
80103de7:	75 41                	jne    80103e2a <sched+0x8a>
  intena = mycpu()->intena;
80103de9:	e8 d2 fb ff ff       	call   801039c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103df1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103df7:	e8 c4 fb ff ff       	call   801039c0 <mycpu>
80103dfc:	83 ec 08             	sub    $0x8,%esp
80103dff:	ff 70 04             	push   0x4(%eax)
80103e02:	53                   	push   %ebx
80103e03:	e8 b3 0b 00 00       	call   801049bb <swtch>
  mycpu()->intena = intena;
80103e08:	e8 b3 fb ff ff       	call   801039c0 <mycpu>
}
80103e0d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e10:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e19:	5b                   	pop    %ebx
80103e1a:	5e                   	pop    %esi
80103e1b:	5d                   	pop    %ebp
80103e1c:	c3                   	ret
    panic("sched ptable.lock");
80103e1d:	83 ec 0c             	sub    $0xc,%esp
80103e20:	68 99 79 10 80       	push   $0x80107999
80103e25:	e8 56 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	68 c5 79 10 80       	push   $0x801079c5
80103e32:	e8 49 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e37:	83 ec 0c             	sub    $0xc,%esp
80103e3a:	68 b7 79 10 80       	push   $0x801079b7
80103e3f:	e8 3c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e44:	83 ec 0c             	sub    $0xc,%esp
80103e47:	68 ab 79 10 80       	push   $0x801079ab
80103e4c:	e8 2f c5 ff ff       	call   80100380 <panic>
80103e51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e58:	00 
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e60 <exit>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e69:	e8 d2 fb ff ff       	call   80103a40 <myproc>
  if(curproc == initproc)
80103e6e:	39 05 80 56 11 80    	cmp    %eax,0x80115680
80103e74:	0f 84 6d 01 00 00    	je     80103fe7 <exit+0x187>
  acquire(&ptable.lock);
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	89 c3                	mov    %eax,%ebx
80103e7f:	68 e0 2d 11 80       	push   $0x80112de0
80103e84:	e8 57 08 00 00       	call   801046e0 <acquire>
  for (int i = 0; i < history_count; i++) {
80103e89:	8b 0d 18 4d 11 80    	mov    0x80114d18,%ecx
80103e8f:	83 c4 10             	add    $0x10,%esp
80103e92:	85 c9                	test   %ecx,%ecx
80103e94:	7e 4a                	jle    80103ee0 <exit+0x80>
      if (process_history[i].pid == curproc->pid) {
80103e96:	8b 7b 10             	mov    0x10(%ebx),%edi
  for (int i = 0; i < history_count; i++) {
80103e99:	31 c0                	xor    %eax,%eax
80103e9b:	eb 0a                	jmp    80103ea7 <exit+0x47>
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
80103ea0:	83 c0 01             	add    $0x1,%eax
80103ea3:	39 c8                	cmp    %ecx,%eax
80103ea5:	74 39                	je     80103ee0 <exit+0x80>
      if (process_history[i].pid == curproc->pid) {
80103ea7:	8d 14 40             	lea    (%eax,%eax,2),%edx
80103eaa:	8d 34 d5 00 00 00 00 	lea    0x0(,%edx,8),%esi
80103eb1:	39 3c d5 20 4d 11 80 	cmp    %edi,-0x7feeb2e0(,%edx,8)
80103eb8:	75 e6                	jne    80103ea0 <exit+0x40>
        if(curproc->sz > process_history[i].mem_usage) {
80103eba:	8b 03                	mov    (%ebx),%eax
80103ebc:	3b 86 34 4d 11 80    	cmp    -0x7feeb2cc(%esi),%eax
80103ec2:	76 06                	jbe    80103eca <exit+0x6a>
          process_history[i].mem_usage = curproc->sz; // Ensure correct memory tracking
80103ec4:	89 86 34 4d 11 80    	mov    %eax,-0x7feeb2cc(%esi)
          safestrcpy(process_history[i].name, curproc->name, CMD_NAME_MAX);
80103eca:	81 c6 24 4d 11 80    	add    $0x80114d24,%esi
80103ed0:	50                   	push   %eax
80103ed1:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ed4:	6a 10                	push   $0x10
80103ed6:	50                   	push   %eax
80103ed7:	56                   	push   %esi
80103ed8:	e8 83 0a 00 00       	call   80104960 <safestrcpy>
          break;
80103edd:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80103ee0:	83 ec 0c             	sub    $0xc,%esp
80103ee3:	8d 73 28             	lea    0x28(%ebx),%esi
80103ee6:	8d 7b 68             	lea    0x68(%ebx),%edi
80103ee9:	68 e0 2d 11 80       	push   $0x80112de0
80103eee:	e8 8d 07 00 00       	call   80104680 <release>
  for(fd = 0; fd < NOFILE; fd++){
80103ef3:	83 c4 10             	add    $0x10,%esp
80103ef6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103efd:	00 
80103efe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
80103f00:	8b 06                	mov    (%esi),%eax
80103f02:	85 c0                	test   %eax,%eax
80103f04:	74 12                	je     80103f18 <exit+0xb8>
      fileclose(curproc->ofile[fd]);
80103f06:	83 ec 0c             	sub    $0xc,%esp
80103f09:	50                   	push   %eax
80103f0a:	e8 e1 cf ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103f0f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f15:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f18:	83 c6 04             	add    $0x4,%esi
80103f1b:	39 f7                	cmp    %esi,%edi
80103f1d:	75 e1                	jne    80103f00 <exit+0xa0>
  begin_op();
80103f1f:	e8 4c ee ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
80103f24:	83 ec 0c             	sub    $0xc,%esp
80103f27:	ff 73 68             	push   0x68(%ebx)
80103f2a:	e8 91 d9 ff ff       	call   801018c0 <iput>
  end_op();
80103f2f:	e8 ac ee ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103f34:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f3b:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103f42:	e8 99 07 00 00       	call   801046e0 <acquire>
  wakeup1(curproc->parent);
80103f47:	8b 53 14             	mov    0x14(%ebx),%edx
80103f4a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4d:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
80103f52:	eb 0e                	jmp    80103f62 <exit+0x102>
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f58:	83 c0 7c             	add    $0x7c,%eax
80103f5b:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103f60:	74 1c                	je     80103f7e <exit+0x11e>
    if(p->state == SLEEPING && p->chan == chan)
80103f62:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f66:	75 f0                	jne    80103f58 <exit+0xf8>
80103f68:	3b 50 20             	cmp    0x20(%eax),%edx
80103f6b:	75 eb                	jne    80103f58 <exit+0xf8>
      p->state = RUNNABLE;
80103f6d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f74:	83 c0 7c             	add    $0x7c,%eax
80103f77:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103f7c:	75 e4                	jne    80103f62 <exit+0x102>
      p->parent = initproc;
80103f7e:	8b 0d 80 56 11 80    	mov    0x80115680,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f84:	ba 14 2e 11 80       	mov    $0x80112e14,%edx
80103f89:	eb 10                	jmp    80103f9b <exit+0x13b>
80103f8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f90:	83 c2 7c             	add    $0x7c,%edx
80103f93:	81 fa 14 4d 11 80    	cmp    $0x80114d14,%edx
80103f99:	74 33                	je     80103fce <exit+0x16e>
    if(p->parent == curproc){
80103f9b:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f9e:	75 f0                	jne    80103f90 <exit+0x130>
      if(p->state == ZOMBIE)
80103fa0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fa4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fa7:	75 e7                	jne    80103f90 <exit+0x130>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa9:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
80103fae:	eb 0a                	jmp    80103fba <exit+0x15a>
80103fb0:	83 c0 7c             	add    $0x7c,%eax
80103fb3:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103fb8:	74 d6                	je     80103f90 <exit+0x130>
    if(p->state == SLEEPING && p->chan == chan)
80103fba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fbe:	75 f0                	jne    80103fb0 <exit+0x150>
80103fc0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fc3:	75 eb                	jne    80103fb0 <exit+0x150>
      p->state = RUNNABLE;
80103fc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fcc:	eb e2                	jmp    80103fb0 <exit+0x150>
  curproc->state = ZOMBIE;
80103fce:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fd5:	e8 c6 fd ff ff       	call   80103da0 <sched>
  panic("zombie exit");
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 e6 79 10 80       	push   $0x801079e6
80103fe2:	e8 99 c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	68 d9 79 10 80       	push   $0x801079d9
80103fef:	e8 8c c3 ff ff       	call   80100380 <panic>
80103ff4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ffb:	00 
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104000 <wait>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
  pushcli();
80104005:	e8 86 05 00 00       	call   80104590 <pushcli>
  c = mycpu();
8010400a:	e8 b1 f9 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010400f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104015:	e8 c6 05 00 00       	call   801045e0 <popcli>
  acquire(&ptable.lock);
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 e0 2d 11 80       	push   $0x80112de0
80104022:	e8 b9 06 00 00       	call   801046e0 <acquire>
80104027:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010402a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402c:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
80104031:	eb 10                	jmp    80104043 <wait+0x43>
80104033:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104038:	83 c3 7c             	add    $0x7c,%ebx
8010403b:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80104041:	74 1b                	je     8010405e <wait+0x5e>
      if(p->parent != curproc)
80104043:	39 73 14             	cmp    %esi,0x14(%ebx)
80104046:	75 f0                	jne    80104038 <wait+0x38>
      if(p->state == ZOMBIE){
80104048:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010404c:	74 62                	je     801040b0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104051:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104056:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
8010405c:	75 e5                	jne    80104043 <wait+0x43>
    if(!havekids || curproc->killed){
8010405e:	85 c0                	test   %eax,%eax
80104060:	0f 84 a0 00 00 00    	je     80104106 <wait+0x106>
80104066:	8b 46 24             	mov    0x24(%esi),%eax
80104069:	85 c0                	test   %eax,%eax
8010406b:	0f 85 95 00 00 00    	jne    80104106 <wait+0x106>
  pushcli();
80104071:	e8 1a 05 00 00       	call   80104590 <pushcli>
  c = mycpu();
80104076:	e8 45 f9 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010407b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104081:	e8 5a 05 00 00       	call   801045e0 <popcli>
  if(p == 0)
80104086:	85 db                	test   %ebx,%ebx
80104088:	0f 84 8f 00 00 00    	je     8010411d <wait+0x11d>
  p->chan = chan;
8010408e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104091:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104098:	e8 03 fd ff ff       	call   80103da0 <sched>
  p->chan = 0;
8010409d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040a4:	eb 84                	jmp    8010402a <wait+0x2a>
801040a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040ad:	00 
801040ae:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801040b0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040b3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040b6:	ff 73 08             	push   0x8(%ebx)
801040b9:	e8 12 e4 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
801040be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040c5:	5a                   	pop    %edx
801040c6:	ff 73 04             	push   0x4(%ebx)
801040c9:	e8 52 32 00 00       	call   80107320 <freevm>
        p->pid = 0;
801040ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040ee:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
801040f5:	e8 86 05 00 00       	call   80104680 <release>
        return pid;
801040fa:	83 c4 10             	add    $0x10,%esp
}
801040fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104100:	89 f0                	mov    %esi,%eax
80104102:	5b                   	pop    %ebx
80104103:	5e                   	pop    %esi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret
      release(&ptable.lock);
80104106:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104109:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010410e:	68 e0 2d 11 80       	push   $0x80112de0
80104113:	e8 68 05 00 00       	call   80104680 <release>
      return -1;
80104118:	83 c4 10             	add    $0x10,%esp
8010411b:	eb e0                	jmp    801040fd <wait+0xfd>
    panic("sleep");
8010411d:	83 ec 0c             	sub    $0xc,%esp
80104120:	68 f2 79 10 80       	push   $0x801079f2
80104125:	e8 56 c2 ff ff       	call   80100380 <panic>
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104130 <yield>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104137:	68 e0 2d 11 80       	push   $0x80112de0
8010413c:	e8 9f 05 00 00       	call   801046e0 <acquire>
  pushcli();
80104141:	e8 4a 04 00 00       	call   80104590 <pushcli>
  c = mycpu();
80104146:	e8 75 f8 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 8a 04 00 00       	call   801045e0 <popcli>
  myproc()->state = RUNNABLE;
80104156:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010415d:	e8 3e fc ff ff       	call   80103da0 <sched>
  release(&ptable.lock);
80104162:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80104169:	e8 12 05 00 00       	call   80104680 <release>
}
8010416e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104171:	83 c4 10             	add    $0x10,%esp
80104174:	c9                   	leave
80104175:	c3                   	ret
80104176:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010417d:	00 
8010417e:	66 90                	xchg   %ax,%ax

80104180 <sleep>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	8b 7d 08             	mov    0x8(%ebp),%edi
8010418c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010418f:	e8 fc 03 00 00       	call   80104590 <pushcli>
  c = mycpu();
80104194:	e8 27 f8 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80104199:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010419f:	e8 3c 04 00 00       	call   801045e0 <popcli>
  if(p == 0)
801041a4:	85 db                	test   %ebx,%ebx
801041a6:	0f 84 87 00 00 00    	je     80104233 <sleep+0xb3>
  if(lk == 0)
801041ac:	85 f6                	test   %esi,%esi
801041ae:	74 76                	je     80104226 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041b0:	81 fe e0 2d 11 80    	cmp    $0x80112de0,%esi
801041b6:	74 50                	je     80104208 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	68 e0 2d 11 80       	push   $0x80112de0
801041c0:	e8 1b 05 00 00       	call   801046e0 <acquire>
    release(lk);
801041c5:	89 34 24             	mov    %esi,(%esp)
801041c8:	e8 b3 04 00 00       	call   80104680 <release>
  p->chan = chan;
801041cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041d7:	e8 c4 fb ff ff       	call   80103da0 <sched>
  p->chan = 0;
801041dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041e3:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
801041ea:	e8 91 04 00 00       	call   80104680 <release>
    acquire(lk);
801041ef:	89 75 08             	mov    %esi,0x8(%ebp)
801041f2:	83 c4 10             	add    $0x10,%esp
}
801041f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f8:	5b                   	pop    %ebx
801041f9:	5e                   	pop    %esi
801041fa:	5f                   	pop    %edi
801041fb:	5d                   	pop    %ebp
    acquire(lk);
801041fc:	e9 df 04 00 00       	jmp    801046e0 <acquire>
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104208:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010420b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104212:	e8 89 fb ff ff       	call   80103da0 <sched>
  p->chan = 0;
80104217:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010421e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5f                   	pop    %edi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret
    panic("sleep without lk");
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	68 f8 79 10 80       	push   $0x801079f8
8010422e:	e8 4d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104233:	83 ec 0c             	sub    $0xc,%esp
80104236:	68 f2 79 10 80       	push   $0x801079f2
8010423b:	e8 40 c1 ff ff       	call   80100380 <panic>

80104240 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
80104247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010424a:	68 e0 2d 11 80       	push   $0x80112de0
8010424f:	e8 8c 04 00 00       	call   801046e0 <acquire>
80104254:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104257:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
8010425c:	eb 0c                	jmp    8010426a <wakeup+0x2a>
8010425e:	66 90                	xchg   %ax,%ax
80104260:	83 c0 7c             	add    $0x7c,%eax
80104263:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80104268:	74 1c                	je     80104286 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010426a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010426e:	75 f0                	jne    80104260 <wakeup+0x20>
80104270:	3b 58 20             	cmp    0x20(%eax),%ebx
80104273:	75 eb                	jne    80104260 <wakeup+0x20>
      p->state = RUNNABLE;
80104275:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010427c:	83 c0 7c             	add    $0x7c,%eax
8010427f:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80104284:	75 e4                	jne    8010426a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104286:	c7 45 08 e0 2d 11 80 	movl   $0x80112de0,0x8(%ebp)
}
8010428d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104290:	c9                   	leave
  release(&ptable.lock);
80104291:	e9 ea 03 00 00       	jmp    80104680 <release>
80104296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010429d:	00 
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042aa:	68 e0 2d 11 80       	push   $0x80112de0
801042af:	e8 2c 04 00 00       	call   801046e0 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b7:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
801042bc:	eb 0c                	jmp    801042ca <kill+0x2a>
801042be:	66 90                	xchg   %ax,%ax
801042c0:	83 c0 7c             	add    $0x7c,%eax
801042c3:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
801042c8:	74 36                	je     80104300 <kill+0x60>
    if(p->pid == pid){
801042ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801042cd:	75 f1                	jne    801042c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042da:	75 07                	jne    801042e3 <kill+0x43>
        p->state = RUNNABLE;
801042dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042e3:	83 ec 0c             	sub    $0xc,%esp
801042e6:	68 e0 2d 11 80       	push   $0x80112de0
801042eb:	e8 90 03 00 00       	call   80104680 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042f3:	83 c4 10             	add    $0x10,%esp
801042f6:	31 c0                	xor    %eax,%eax
}
801042f8:	c9                   	leave
801042f9:	c3                   	ret
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 e0 2d 11 80       	push   $0x80112de0
80104308:	e8 73 03 00 00       	call   80104680 <release>
}
8010430d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104310:	83 c4 10             	add    $0x10,%esp
80104313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104318:	c9                   	leave
80104319:	c3                   	ret
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104320 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104328:	53                   	push   %ebx
80104329:	bb 80 2e 11 80       	mov    $0x80112e80,%ebx
8010432e:	83 ec 3c             	sub    $0x3c,%esp
80104331:	eb 24                	jmp    80104357 <procdump+0x37>
80104333:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	68 2e 7c 10 80       	push   $0x80107c2e
80104340:	e8 5b c3 ff ff       	call   801006a0 <cprintf>
80104345:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104348:	83 c3 7c             	add    $0x7c,%ebx
8010434b:	81 fb 80 4d 11 80    	cmp    $0x80114d80,%ebx
80104351:	0f 84 81 00 00 00    	je     801043d8 <procdump+0xb8>
    if(p->state == UNUSED)
80104357:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010435a:	85 c0                	test   %eax,%eax
8010435c:	74 ea                	je     80104348 <procdump+0x28>
      state = "???";
8010435e:	ba 09 7a 10 80       	mov    $0x80107a09,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104363:	83 f8 05             	cmp    $0x5,%eax
80104366:	77 11                	ja     80104379 <procdump+0x59>
80104368:	8b 14 85 60 80 10 80 	mov    -0x7fef7fa0(,%eax,4),%edx
      state = "???";
8010436f:	b8 09 7a 10 80       	mov    $0x80107a09,%eax
80104374:	85 d2                	test   %edx,%edx
80104376:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104379:	53                   	push   %ebx
8010437a:	52                   	push   %edx
8010437b:	ff 73 a4             	push   -0x5c(%ebx)
8010437e:	68 0d 7a 10 80       	push   $0x80107a0d
80104383:	e8 18 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010438f:	75 a7                	jne    80104338 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104391:	83 ec 08             	sub    $0x8,%esp
80104394:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104397:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010439a:	50                   	push   %eax
8010439b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010439e:	8b 40 0c             	mov    0xc(%eax),%eax
801043a1:	83 c0 08             	add    $0x8,%eax
801043a4:	50                   	push   %eax
801043a5:	e8 86 01 00 00       	call   80104530 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043aa:	83 c4 10             	add    $0x10,%esp
801043ad:	8d 76 00             	lea    0x0(%esi),%esi
801043b0:	8b 17                	mov    (%edi),%edx
801043b2:	85 d2                	test   %edx,%edx
801043b4:	74 82                	je     80104338 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043b6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043bc:	52                   	push   %edx
801043bd:	68 41 77 10 80       	push   $0x80107741
801043c2:	e8 d9 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	39 fe                	cmp    %edi,%esi
801043cc:	75 e2                	jne    801043b0 <procdump+0x90>
801043ce:	e9 65 ff ff ff       	jmp    80104338 <procdump+0x18>
801043d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801043d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043db:	5b                   	pop    %ebx
801043dc:	5e                   	pop    %esi
801043dd:	5f                   	pop    %edi
801043de:	5d                   	pop    %ebp
801043df:	c3                   	ret

801043e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ea:	68 40 7a 10 80       	push   $0x80107a40
801043ef:	8d 43 04             	lea    0x4(%ebx),%eax
801043f2:	50                   	push   %eax
801043f3:	e8 18 01 00 00       	call   80104510 <initlock>
  lk->name = name;
801043f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104401:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104404:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010440b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010440e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104411:	c9                   	leave
80104412:	c3                   	ret
80104413:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010441a:	00 
8010441b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104420 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104428:	8d 73 04             	lea    0x4(%ebx),%esi
8010442b:	83 ec 0c             	sub    $0xc,%esp
8010442e:	56                   	push   %esi
8010442f:	e8 ac 02 00 00       	call   801046e0 <acquire>
  while (lk->locked) {
80104434:	8b 13                	mov    (%ebx),%edx
80104436:	83 c4 10             	add    $0x10,%esp
80104439:	85 d2                	test   %edx,%edx
8010443b:	74 16                	je     80104453 <acquiresleep+0x33>
8010443d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104440:	83 ec 08             	sub    $0x8,%esp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	e8 36 fd ff ff       	call   80104180 <sleep>
  while (lk->locked) {
8010444a:	8b 03                	mov    (%ebx),%eax
8010444c:	83 c4 10             	add    $0x10,%esp
8010444f:	85 c0                	test   %eax,%eax
80104451:	75 ed                	jne    80104440 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104453:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104459:	e8 e2 f5 ff ff       	call   80103a40 <myproc>
8010445e:	8b 40 10             	mov    0x10(%eax),%eax
80104461:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104464:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104467:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010446a:	5b                   	pop    %ebx
8010446b:	5e                   	pop    %esi
8010446c:	5d                   	pop    %ebp
  release(&lk->lk);
8010446d:	e9 0e 02 00 00       	jmp    80104680 <release>
80104472:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104479:	00 
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104488:	8d 73 04             	lea    0x4(%ebx),%esi
8010448b:	83 ec 0c             	sub    $0xc,%esp
8010448e:	56                   	push   %esi
8010448f:	e8 4c 02 00 00       	call   801046e0 <acquire>
  lk->locked = 0;
80104494:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010449a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044a1:	89 1c 24             	mov    %ebx,(%esp)
801044a4:	e8 97 fd ff ff       	call   80104240 <wakeup>
  release(&lk->lk);
801044a9:	89 75 08             	mov    %esi,0x8(%ebp)
801044ac:	83 c4 10             	add    $0x10,%esp
}
801044af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b2:	5b                   	pop    %ebx
801044b3:	5e                   	pop    %esi
801044b4:	5d                   	pop    %ebp
  release(&lk->lk);
801044b5:	e9 c6 01 00 00       	jmp    80104680 <release>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	31 ff                	xor    %edi,%edi
801044c6:	56                   	push   %esi
801044c7:	53                   	push   %ebx
801044c8:	83 ec 18             	sub    $0x18,%esp
801044cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044ce:	8d 73 04             	lea    0x4(%ebx),%esi
801044d1:	56                   	push   %esi
801044d2:	e8 09 02 00 00       	call   801046e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044d7:	8b 03                	mov    (%ebx),%eax
801044d9:	83 c4 10             	add    $0x10,%esp
801044dc:	85 c0                	test   %eax,%eax
801044de:	75 18                	jne    801044f8 <holdingsleep+0x38>
  release(&lk->lk);
801044e0:	83 ec 0c             	sub    $0xc,%esp
801044e3:	56                   	push   %esi
801044e4:	e8 97 01 00 00       	call   80104680 <release>
  return r;
}
801044e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044ec:	89 f8                	mov    %edi,%eax
801044ee:	5b                   	pop    %ebx
801044ef:	5e                   	pop    %esi
801044f0:	5f                   	pop    %edi
801044f1:	5d                   	pop    %ebp
801044f2:	c3                   	ret
801044f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801044f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044fb:	e8 40 f5 ff ff       	call   80103a40 <myproc>
80104500:	39 58 10             	cmp    %ebx,0x10(%eax)
80104503:	0f 94 c0             	sete   %al
80104506:	0f b6 c0             	movzbl %al,%eax
80104509:	89 c7                	mov    %eax,%edi
8010450b:	eb d3                	jmp    801044e0 <holdingsleep+0x20>
8010450d:	66 90                	xchg   %ax,%ax
8010450f:	90                   	nop

80104510 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104516:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010451f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104529:	5d                   	pop    %ebp
8010452a:	c3                   	ret
8010452b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104530 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104530:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104531:	31 d2                	xor    %edx,%edx
{
80104533:	89 e5                	mov    %esp,%ebp
80104535:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104536:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104539:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010453c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010453f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104540:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104546:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010454c:	77 1a                	ja     80104568 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010454e:	8b 58 04             	mov    0x4(%eax),%ebx
80104551:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104554:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104557:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104559:	83 fa 0a             	cmp    $0xa,%edx
8010455c:	75 e2                	jne    80104540 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010455e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104561:	c9                   	leave
80104562:	c3                   	ret
80104563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104568:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010456b:	8d 51 28             	lea    0x28(%ecx),%edx
8010456e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104576:	83 c0 04             	add    $0x4,%eax
80104579:	39 d0                	cmp    %edx,%eax
8010457b:	75 f3                	jne    80104570 <getcallerpcs+0x40>
}
8010457d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104580:	c9                   	leave
80104581:	c3                   	ret
80104582:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104589:	00 
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 04             	sub    $0x4,%esp
80104597:	9c                   	pushf
80104598:	5b                   	pop    %ebx
  asm volatile("cli");
80104599:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010459a:	e8 21 f4 ff ff       	call   801039c0 <mycpu>
8010459f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045a5:	85 c0                	test   %eax,%eax
801045a7:	74 17                	je     801045c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045a9:	e8 12 f4 ff ff       	call   801039c0 <mycpu>
801045ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b8:	c9                   	leave
801045b9:	c3                   	ret
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045c0:	e8 fb f3 ff ff       	call   801039c0 <mycpu>
801045c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045d1:	eb d6                	jmp    801045a9 <pushcli+0x19>
801045d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045da:	00 
801045db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801045e0 <popcli>:

void
popcli(void)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045e6:	9c                   	pushf
801045e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045e8:	f6 c4 02             	test   $0x2,%ah
801045eb:	75 35                	jne    80104622 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045ed:	e8 ce f3 ff ff       	call   801039c0 <mycpu>
801045f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045f9:	78 34                	js     8010462f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045fb:	e8 c0 f3 ff ff       	call   801039c0 <mycpu>
80104600:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104606:	85 d2                	test   %edx,%edx
80104608:	74 06                	je     80104610 <popcli+0x30>
    sti();
}
8010460a:	c9                   	leave
8010460b:	c3                   	ret
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104610:	e8 ab f3 ff ff       	call   801039c0 <mycpu>
80104615:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010461b:	85 c0                	test   %eax,%eax
8010461d:	74 eb                	je     8010460a <popcli+0x2a>
  asm volatile("sti");
8010461f:	fb                   	sti
}
80104620:	c9                   	leave
80104621:	c3                   	ret
    panic("popcli - interruptible");
80104622:	83 ec 0c             	sub    $0xc,%esp
80104625:	68 4b 7a 10 80       	push   $0x80107a4b
8010462a:	e8 51 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010462f:	83 ec 0c             	sub    $0xc,%esp
80104632:	68 62 7a 10 80       	push   $0x80107a62
80104637:	e8 44 bd ff ff       	call   80100380 <panic>
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <holding>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 75 08             	mov    0x8(%ebp),%esi
80104648:	31 db                	xor    %ebx,%ebx
  pushcli();
8010464a:	e8 41 ff ff ff       	call   80104590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010464f:	8b 06                	mov    (%esi),%eax
80104651:	85 c0                	test   %eax,%eax
80104653:	75 0b                	jne    80104660 <holding+0x20>
  popcli();
80104655:	e8 86 ff ff ff       	call   801045e0 <popcli>
}
8010465a:	89 d8                	mov    %ebx,%eax
8010465c:	5b                   	pop    %ebx
8010465d:	5e                   	pop    %esi
8010465e:	5d                   	pop    %ebp
8010465f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104660:	8b 5e 08             	mov    0x8(%esi),%ebx
80104663:	e8 58 f3 ff ff       	call   801039c0 <mycpu>
80104668:	39 c3                	cmp    %eax,%ebx
8010466a:	0f 94 c3             	sete   %bl
  popcli();
8010466d:	e8 6e ff ff ff       	call   801045e0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104672:	0f b6 db             	movzbl %bl,%ebx
}
80104675:	89 d8                	mov    %ebx,%eax
80104677:	5b                   	pop    %ebx
80104678:	5e                   	pop    %esi
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret
8010467b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104680 <release>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104688:	e8 03 ff ff ff       	call   80104590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010468d:	8b 03                	mov    (%ebx),%eax
8010468f:	85 c0                	test   %eax,%eax
80104691:	75 15                	jne    801046a8 <release+0x28>
  popcli();
80104693:	e8 48 ff ff ff       	call   801045e0 <popcli>
    panic("release");
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	68 69 7a 10 80       	push   $0x80107a69
801046a0:	e8 db bc ff ff       	call   80100380 <panic>
801046a5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046a8:	8b 73 08             	mov    0x8(%ebx),%esi
801046ab:	e8 10 f3 ff ff       	call   801039c0 <mycpu>
801046b0:	39 c6                	cmp    %eax,%esi
801046b2:	75 df                	jne    80104693 <release+0x13>
  popcli();
801046b4:	e8 27 ff ff ff       	call   801045e0 <popcli>
  lk->pcs[0] = 0;
801046b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046c7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d5:	5b                   	pop    %ebx
801046d6:	5e                   	pop    %esi
801046d7:	5d                   	pop    %ebp
  popcli();
801046d8:	e9 03 ff ff ff       	jmp    801045e0 <popcli>
801046dd:	8d 76 00             	lea    0x0(%esi),%esi

801046e0 <acquire>:
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046e7:	e8 a4 fe ff ff       	call   80104590 <pushcli>
  if(holding(lk))
801046ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046ef:	e8 9c fe ff ff       	call   80104590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046f4:	8b 03                	mov    (%ebx),%eax
801046f6:	85 c0                	test   %eax,%eax
801046f8:	75 7e                	jne    80104778 <acquire+0x98>
  popcli();
801046fa:	e8 e1 fe ff ff       	call   801045e0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801046ff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104708:	8b 55 08             	mov    0x8(%ebp),%edx
8010470b:	89 c8                	mov    %ecx,%eax
8010470d:	f0 87 02             	lock xchg %eax,(%edx)
80104710:	85 c0                	test   %eax,%eax
80104712:	75 f4                	jne    80104708 <acquire+0x28>
  __sync_synchronize();
80104714:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104719:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010471c:	e8 9f f2 ff ff       	call   801039c0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104721:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104724:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104726:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104729:	31 c0                	xor    %eax,%eax
8010472b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104730:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104736:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010473c:	77 1a                	ja     80104758 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010473e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104741:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104745:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104748:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010474a:	83 f8 0a             	cmp    $0xa,%eax
8010474d:	75 e1                	jne    80104730 <acquire+0x50>
}
8010474f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104752:	c9                   	leave
80104753:	c3                   	ret
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104758:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010475c:	8d 51 34             	lea    0x34(%ecx),%edx
8010475f:	90                   	nop
    pcs[i] = 0;
80104760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104766:	83 c0 04             	add    $0x4,%eax
80104769:	39 c2                	cmp    %eax,%edx
8010476b:	75 f3                	jne    80104760 <acquire+0x80>
}
8010476d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104770:	c9                   	leave
80104771:	c3                   	ret
80104772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104778:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010477b:	e8 40 f2 ff ff       	call   801039c0 <mycpu>
80104780:	39 c3                	cmp    %eax,%ebx
80104782:	0f 85 72 ff ff ff    	jne    801046fa <acquire+0x1a>
  popcli();
80104788:	e8 53 fe ff ff       	call   801045e0 <popcli>
    panic("acquire");
8010478d:	83 ec 0c             	sub    $0xc,%esp
80104790:	68 71 7a 10 80       	push   $0x80107a71
80104795:	e8 e6 bb ff ff       	call   80100380 <panic>
8010479a:	66 90                	xchg   %ax,%ax
8010479c:	66 90                	xchg   %ax,%ax
8010479e:	66 90                	xchg   %ax,%ax

801047a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	8b 55 08             	mov    0x8(%ebp),%edx
801047a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047aa:	53                   	push   %ebx
801047ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047ae:	89 d7                	mov    %edx,%edi
801047b0:	09 cf                	or     %ecx,%edi
801047b2:	83 e7 03             	and    $0x3,%edi
801047b5:	75 29                	jne    801047e0 <memset+0x40>
    c &= 0xFF;
801047b7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ba:	c1 e0 18             	shl    $0x18,%eax
801047bd:	89 fb                	mov    %edi,%ebx
801047bf:	c1 e9 02             	shr    $0x2,%ecx
801047c2:	c1 e3 10             	shl    $0x10,%ebx
801047c5:	09 d8                	or     %ebx,%eax
801047c7:	09 f8                	or     %edi,%eax
801047c9:	c1 e7 08             	shl    $0x8,%edi
801047cc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047ce:	89 d7                	mov    %edx,%edi
801047d0:	fc                   	cld
801047d1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047d3:	5b                   	pop    %ebx
801047d4:	89 d0                	mov    %edx,%eax
801047d6:	5f                   	pop    %edi
801047d7:	5d                   	pop    %ebp
801047d8:	c3                   	ret
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801047e0:	89 d7                	mov    %edx,%edi
801047e2:	fc                   	cld
801047e3:	f3 aa                	rep stos %al,%es:(%edi)
801047e5:	5b                   	pop    %ebx
801047e6:	89 d0                	mov    %edx,%eax
801047e8:	5f                   	pop    %edi
801047e9:	5d                   	pop    %ebp
801047ea:	c3                   	ret
801047eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801047f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	8b 75 10             	mov    0x10(%ebp),%esi
801047f7:	8b 55 08             	mov    0x8(%ebp),%edx
801047fa:	53                   	push   %ebx
801047fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047fe:	85 f6                	test   %esi,%esi
80104800:	74 2e                	je     80104830 <memcmp+0x40>
80104802:	01 c6                	add    %eax,%esi
80104804:	eb 14                	jmp    8010481a <memcmp+0x2a>
80104806:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010480d:	00 
8010480e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104810:	83 c0 01             	add    $0x1,%eax
80104813:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104816:	39 f0                	cmp    %esi,%eax
80104818:	74 16                	je     80104830 <memcmp+0x40>
    if(*s1 != *s2)
8010481a:	0f b6 0a             	movzbl (%edx),%ecx
8010481d:	0f b6 18             	movzbl (%eax),%ebx
80104820:	38 d9                	cmp    %bl,%cl
80104822:	74 ec                	je     80104810 <memcmp+0x20>
      return *s1 - *s2;
80104824:	0f b6 c1             	movzbl %cl,%eax
80104827:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104829:	5b                   	pop    %ebx
8010482a:	5e                   	pop    %esi
8010482b:	5d                   	pop    %ebp
8010482c:	c3                   	ret
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
80104830:	5b                   	pop    %ebx
  return 0;
80104831:	31 c0                	xor    %eax,%eax
}
80104833:	5e                   	pop    %esi
80104834:	5d                   	pop    %ebp
80104835:	c3                   	ret
80104836:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010483d:	00 
8010483e:	66 90                	xchg   %ax,%ax

80104840 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	8b 55 08             	mov    0x8(%ebp),%edx
80104847:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010484a:	56                   	push   %esi
8010484b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010484e:	39 d6                	cmp    %edx,%esi
80104850:	73 26                	jae    80104878 <memmove+0x38>
80104852:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104855:	39 fa                	cmp    %edi,%edx
80104857:	73 1f                	jae    80104878 <memmove+0x38>
80104859:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010485c:	85 c9                	test   %ecx,%ecx
8010485e:	74 0c                	je     8010486c <memmove+0x2c>
      *--d = *--s;
80104860:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104864:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104867:	83 e8 01             	sub    $0x1,%eax
8010486a:	73 f4                	jae    80104860 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010486c:	5e                   	pop    %esi
8010486d:	89 d0                	mov    %edx,%eax
8010486f:	5f                   	pop    %edi
80104870:	5d                   	pop    %ebp
80104871:	c3                   	ret
80104872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104878:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010487b:	89 d7                	mov    %edx,%edi
8010487d:	85 c9                	test   %ecx,%ecx
8010487f:	74 eb                	je     8010486c <memmove+0x2c>
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104888:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104889:	39 c6                	cmp    %eax,%esi
8010488b:	75 fb                	jne    80104888 <memmove+0x48>
}
8010488d:	5e                   	pop    %esi
8010488e:	89 d0                	mov    %edx,%eax
80104890:	5f                   	pop    %edi
80104891:	5d                   	pop    %ebp
80104892:	c3                   	ret
80104893:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010489a:	00 
8010489b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801048a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048a0:	eb 9e                	jmp    80104840 <memmove>
801048a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048a9:	00 
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	8b 75 10             	mov    0x10(%ebp),%esi
801048b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ba:	53                   	push   %ebx
801048bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801048be:	85 f6                	test   %esi,%esi
801048c0:	74 2e                	je     801048f0 <strncmp+0x40>
801048c2:	01 d6                	add    %edx,%esi
801048c4:	eb 18                	jmp    801048de <strncmp+0x2e>
801048c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048cd:	00 
801048ce:	66 90                	xchg   %ax,%ax
801048d0:	38 d8                	cmp    %bl,%al
801048d2:	75 14                	jne    801048e8 <strncmp+0x38>
    n--, p++, q++;
801048d4:	83 c2 01             	add    $0x1,%edx
801048d7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048da:	39 f2                	cmp    %esi,%edx
801048dc:	74 12                	je     801048f0 <strncmp+0x40>
801048de:	0f b6 01             	movzbl (%ecx),%eax
801048e1:	0f b6 1a             	movzbl (%edx),%ebx
801048e4:	84 c0                	test   %al,%al
801048e6:	75 e8                	jne    801048d0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048e8:	29 d8                	sub    %ebx,%eax
}
801048ea:	5b                   	pop    %ebx
801048eb:	5e                   	pop    %esi
801048ec:	5d                   	pop    %ebp
801048ed:	c3                   	ret
801048ee:	66 90                	xchg   %ax,%ax
801048f0:	5b                   	pop    %ebx
    return 0;
801048f1:	31 c0                	xor    %eax,%eax
}
801048f3:	5e                   	pop    %esi
801048f4:	5d                   	pop    %ebp
801048f5:	c3                   	ret
801048f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048fd:	00 
801048fe:	66 90                	xchg   %ax,%ax

80104900 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	56                   	push   %esi
80104905:	8b 75 08             	mov    0x8(%ebp),%esi
80104908:	53                   	push   %ebx
80104909:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010490c:	89 f0                	mov    %esi,%eax
8010490e:	eb 15                	jmp    80104925 <strncpy+0x25>
80104910:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104914:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104917:	83 c0 01             	add    $0x1,%eax
8010491a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010491e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104921:	84 d2                	test   %dl,%dl
80104923:	74 09                	je     8010492e <strncpy+0x2e>
80104925:	89 cb                	mov    %ecx,%ebx
80104927:	83 e9 01             	sub    $0x1,%ecx
8010492a:	85 db                	test   %ebx,%ebx
8010492c:	7f e2                	jg     80104910 <strncpy+0x10>
    ;
  while(n-- > 0)
8010492e:	89 c2                	mov    %eax,%edx
80104930:	85 c9                	test   %ecx,%ecx
80104932:	7e 17                	jle    8010494b <strncpy+0x4b>
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104938:	83 c2 01             	add    $0x1,%edx
8010493b:	89 c1                	mov    %eax,%ecx
8010493d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104941:	29 d1                	sub    %edx,%ecx
80104943:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104947:	85 c9                	test   %ecx,%ecx
80104949:	7f ed                	jg     80104938 <strncpy+0x38>
  return os;
}
8010494b:	5b                   	pop    %ebx
8010494c:	89 f0                	mov    %esi,%eax
8010494e:	5e                   	pop    %esi
8010494f:	5f                   	pop    %edi
80104950:	5d                   	pop    %ebp
80104951:	c3                   	ret
80104952:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104959:	00 
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104960 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	8b 55 10             	mov    0x10(%ebp),%edx
80104967:	8b 75 08             	mov    0x8(%ebp),%esi
8010496a:	53                   	push   %ebx
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010496e:	85 d2                	test   %edx,%edx
80104970:	7e 25                	jle    80104997 <safestrcpy+0x37>
80104972:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104976:	89 f2                	mov    %esi,%edx
80104978:	eb 16                	jmp    80104990 <safestrcpy+0x30>
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104980:	0f b6 08             	movzbl (%eax),%ecx
80104983:	83 c0 01             	add    $0x1,%eax
80104986:	83 c2 01             	add    $0x1,%edx
80104989:	88 4a ff             	mov    %cl,-0x1(%edx)
8010498c:	84 c9                	test   %cl,%cl
8010498e:	74 04                	je     80104994 <safestrcpy+0x34>
80104990:	39 d8                	cmp    %ebx,%eax
80104992:	75 ec                	jne    80104980 <safestrcpy+0x20>
    ;
  *s = 0;
80104994:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104997:	89 f0                	mov    %esi,%eax
80104999:	5b                   	pop    %ebx
8010499a:	5e                   	pop    %esi
8010499b:	5d                   	pop    %ebp
8010499c:	c3                   	ret
8010499d:	8d 76 00             	lea    0x0(%esi),%esi

801049a0 <strlen>:

int
strlen(const char *s)
{
801049a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049a1:	31 c0                	xor    %eax,%eax
{
801049a3:	89 e5                	mov    %esp,%ebp
801049a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049a8:	80 3a 00             	cmpb   $0x0,(%edx)
801049ab:	74 0c                	je     801049b9 <strlen+0x19>
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
801049b0:	83 c0 01             	add    $0x1,%eax
801049b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049b7:	75 f7                	jne    801049b0 <strlen+0x10>
    ;
  return n;
}
801049b9:	5d                   	pop    %ebp
801049ba:	c3                   	ret

801049bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049c3:	55                   	push   %ebp
  pushl %ebx
801049c4:	53                   	push   %ebx
  pushl %esi
801049c5:	56                   	push   %esi
  pushl %edi
801049c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049cb:	5f                   	pop    %edi
  popl %esi
801049cc:	5e                   	pop    %esi
  popl %ebx
801049cd:	5b                   	pop    %ebx
  popl %ebp
801049ce:	5d                   	pop    %ebp
  ret
801049cf:	c3                   	ret

801049d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	53                   	push   %ebx
801049d4:	83 ec 04             	sub    $0x4,%esp
801049d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049da:	e8 61 f0 ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049df:	8b 00                	mov    (%eax),%eax
801049e1:	39 d8                	cmp    %ebx,%eax
801049e3:	76 1b                	jbe    80104a00 <fetchint+0x30>
801049e5:	8d 53 04             	lea    0x4(%ebx),%edx
801049e8:	39 d0                	cmp    %edx,%eax
801049ea:	72 14                	jb     80104a00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ef:	8b 13                	mov    (%ebx),%edx
801049f1:	89 10                	mov    %edx,(%eax)
  return 0;
801049f3:	31 c0                	xor    %eax,%eax
}
801049f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f8:	c9                   	leave
801049f9:	c3                   	ret
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a05:	eb ee                	jmp    801049f5 <fetchint+0x25>
80104a07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a0e:	00 
80104a0f:	90                   	nop

80104a10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
80104a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a1a:	e8 21 f0 ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz)
80104a1f:	39 18                	cmp    %ebx,(%eax)
80104a21:	76 2d                	jbe    80104a50 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a26:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a28:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a2a:	39 d3                	cmp    %edx,%ebx
80104a2c:	73 22                	jae    80104a50 <fetchstr+0x40>
80104a2e:	89 d8                	mov    %ebx,%eax
80104a30:	eb 0d                	jmp    80104a3f <fetchstr+0x2f>
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a38:	83 c0 01             	add    $0x1,%eax
80104a3b:	39 c2                	cmp    %eax,%edx
80104a3d:	76 11                	jbe    80104a50 <fetchstr+0x40>
    if(*s == 0)
80104a3f:	80 38 00             	cmpb   $0x0,(%eax)
80104a42:	75 f4                	jne    80104a38 <fetchstr+0x28>
      return s - *pp;
80104a44:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a49:	c9                   	leave
80104a4a:	c3                   	ret
80104a4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a58:	c9                   	leave
80104a59:	c3                   	ret
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a65:	e8 d6 ef ff ff       	call   80103a40 <myproc>
80104a6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a6d:	8b 40 18             	mov    0x18(%eax),%eax
80104a70:	8b 40 44             	mov    0x44(%eax),%eax
80104a73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a76:	e8 c5 ef ff ff       	call   80103a40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a7e:	8b 00                	mov    (%eax),%eax
80104a80:	39 c6                	cmp    %eax,%esi
80104a82:	73 1c                	jae    80104aa0 <argint+0x40>
80104a84:	8d 53 08             	lea    0x8(%ebx),%edx
80104a87:	39 d0                	cmp    %edx,%eax
80104a89:	72 15                	jb     80104aa0 <argint+0x40>
  *ip = *(int*)(addr);
80104a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a91:	89 10                	mov    %edx,(%eax)
  return 0;
80104a93:	31 c0                	xor    %eax,%eax
}
80104a95:	5b                   	pop    %ebx
80104a96:	5e                   	pop    %esi
80104a97:	5d                   	pop    %ebp
80104a98:	c3                   	ret
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aa5:	eb ee                	jmp    80104a95 <argint+0x35>
80104aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aae:	00 
80104aaf:	90                   	nop

80104ab0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	53                   	push   %ebx
80104ab6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ab9:	e8 82 ef ff ff       	call   80103a40 <myproc>
80104abe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac0:	e8 7b ef ff ff       	call   80103a40 <myproc>
80104ac5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ac8:	8b 40 18             	mov    0x18(%eax),%eax
80104acb:	8b 40 44             	mov    0x44(%eax),%eax
80104ace:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ad1:	e8 6a ef ff ff       	call   80103a40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ad6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ad9:	8b 00                	mov    (%eax),%eax
80104adb:	39 c7                	cmp    %eax,%edi
80104add:	73 31                	jae    80104b10 <argptr+0x60>
80104adf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ae2:	39 c8                	cmp    %ecx,%eax
80104ae4:	72 2a                	jb     80104b10 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ae6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ae9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104aec:	85 d2                	test   %edx,%edx
80104aee:	78 20                	js     80104b10 <argptr+0x60>
80104af0:	8b 16                	mov    (%esi),%edx
80104af2:	39 c2                	cmp    %eax,%edx
80104af4:	76 1a                	jbe    80104b10 <argptr+0x60>
80104af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104af9:	01 c3                	add    %eax,%ebx
80104afb:	39 da                	cmp    %ebx,%edx
80104afd:	72 11                	jb     80104b10 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104aff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b02:	89 02                	mov    %eax,(%edx)
  return 0;
80104b04:	31 c0                	xor    %eax,%eax
}
80104b06:	83 c4 0c             	add    $0xc,%esp
80104b09:	5b                   	pop    %ebx
80104b0a:	5e                   	pop    %esi
80104b0b:	5f                   	pop    %edi
80104b0c:	5d                   	pop    %ebp
80104b0d:	c3                   	ret
80104b0e:	66 90                	xchg   %ax,%ax
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb ef                	jmp    80104b06 <argptr+0x56>
80104b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b1e:	00 
80104b1f:	90                   	nop

80104b20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b25:	e8 16 ef ff ff       	call   80103a40 <myproc>
80104b2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b2d:	8b 40 18             	mov    0x18(%eax),%eax
80104b30:	8b 40 44             	mov    0x44(%eax),%eax
80104b33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b36:	e8 05 ef ff ff       	call   80103a40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b3e:	8b 00                	mov    (%eax),%eax
80104b40:	39 c6                	cmp    %eax,%esi
80104b42:	73 44                	jae    80104b88 <argstr+0x68>
80104b44:	8d 53 08             	lea    0x8(%ebx),%edx
80104b47:	39 d0                	cmp    %edx,%eax
80104b49:	72 3d                	jb     80104b88 <argstr+0x68>
  *ip = *(int*)(addr);
80104b4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b4e:	e8 ed ee ff ff       	call   80103a40 <myproc>
  if(addr >= curproc->sz)
80104b53:	3b 18                	cmp    (%eax),%ebx
80104b55:	73 31                	jae    80104b88 <argstr+0x68>
  *pp = (char*)addr;
80104b57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b5e:	39 d3                	cmp    %edx,%ebx
80104b60:	73 26                	jae    80104b88 <argstr+0x68>
80104b62:	89 d8                	mov    %ebx,%eax
80104b64:	eb 11                	jmp    80104b77 <argstr+0x57>
80104b66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b6d:	00 
80104b6e:	66 90                	xchg   %ax,%ax
80104b70:	83 c0 01             	add    $0x1,%eax
80104b73:	39 c2                	cmp    %eax,%edx
80104b75:	76 11                	jbe    80104b88 <argstr+0x68>
    if(*s == 0)
80104b77:	80 38 00             	cmpb   $0x0,(%eax)
80104b7a:	75 f4                	jne    80104b70 <argstr+0x50>
      return s - *pp;
80104b7c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b7e:	5b                   	pop    %ebx
80104b7f:	5e                   	pop    %esi
80104b80:	5d                   	pop    %ebp
80104b81:	c3                   	ret
80104b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b88:	5b                   	pop    %ebx
    return -1;
80104b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b8e:	5e                   	pop    %esi
80104b8f:	5d                   	pop    %ebp
80104b90:	c3                   	ret
80104b91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b98:	00 
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <strcmp>:

// Helper function for comparing two strings.
int
strcmp(const char *p, const char *q)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	53                   	push   %ebx
80104ba4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ba7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
80104baa:	0f b6 02             	movzbl (%edx),%eax
80104bad:	84 c0                	test   %al,%al
80104baf:	75 17                	jne    80104bc8 <strcmp+0x28>
80104bb1:	eb 3a                	jmp    80104bed <strcmp+0x4d>
80104bb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bb8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
80104bbc:	83 c2 01             	add    $0x1,%edx
80104bbf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
80104bc2:	84 c0                	test   %al,%al
80104bc4:	74 1a                	je     80104be0 <strcmp+0x40>
    p++, q++;
80104bc6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
80104bc8:	0f b6 19             	movzbl (%ecx),%ebx
80104bcb:	38 c3                	cmp    %al,%bl
80104bcd:	74 e9                	je     80104bb8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
80104bcf:	29 d8                	sub    %ebx,%eax
}
80104bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd4:	c9                   	leave
80104bd5:	c3                   	ret
80104bd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bdd:	00 
80104bde:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
80104be0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
80104be4:	31 c0                	xor    %eax,%eax
80104be6:	29 d8                	sub    %ebx,%eax
}
80104be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104beb:	c9                   	leave
80104bec:	c3                   	ret
  return (uchar)*p - (uchar)*q;
80104bed:	0f b6 19             	movzbl (%ecx),%ebx
80104bf0:	31 c0                	xor    %eax,%eax
80104bf2:	eb db                	jmp    80104bcf <strcmp+0x2f>
80104bf4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bfb:	00 
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c00 <syscall>:
[SYS_block]   sys_block,
[SYS_unblock]   sys_unblock,
[SYS_chmod]   sys_chmod,     
};

void syscall(void) {
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c07:	e8 34 ee ff ff       	call   80103a40 <myproc>
80104c0c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c0e:	8b 40 18             	mov    0x18(%eax),%eax
80104c11:	8b 40 1c             	mov    0x1c(%eax),%eax

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c14:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c17:	83 fa 18             	cmp    $0x18,%edx
80104c1a:	77 2c                	ja     80104c48 <syscall+0x48>
80104c1c:	8b 14 85 80 80 10 80 	mov    -0x7fef7f80(,%eax,4),%edx
80104c23:	85 d2                	test   %edx,%edx
80104c25:	74 21                	je     80104c48 <syscall+0x48>
    // Check if the syscall is blocked
    if (blocked_syscalls[num]) {
80104c27:	8b 0c 85 a0 56 11 80 	mov    -0x7feea960(,%eax,4),%ecx
80104c2e:	85 c9                	test   %ecx,%ecx
80104c30:	75 3e                	jne    80104c70 <syscall+0x70>
      cprintf("syscall %d is blocked\n", num);
      curproc->tf->eax = -1;  // Return error
      return;
    }

    curproc->tf->eax = syscalls[num]();
80104c32:	ff d2                	call   *%edx
80104c34:	89 c2                	mov    %eax,%edx
80104c36:	8b 43 18             	mov    0x18(%ebx),%eax
80104c39:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c3f:	c9                   	leave
80104c40:	c3                   	ret
80104c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c48:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c49:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c4c:	50                   	push   %eax
80104c4d:	ff 73 10             	push   0x10(%ebx)
80104c50:	68 90 7a 10 80       	push   $0x80107a90
80104c55:	e8 46 ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c5a:	8b 43 18             	mov    0x18(%ebx),%eax
80104c5d:	83 c4 10             	add    $0x10,%esp
80104c60:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c6a:	c9                   	leave
80104c6b:	c3                   	ret
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("syscall %d is blocked\n", num);
80104c70:	83 ec 08             	sub    $0x8,%esp
80104c73:	50                   	push   %eax
80104c74:	68 79 7a 10 80       	push   $0x80107a79
80104c79:	e8 22 ba ff ff       	call   801006a0 <cprintf>
      curproc->tf->eax = -1;  // Return error
80104c7e:	8b 43 18             	mov    0x18(%ebx),%eax
      return;
80104c81:	83 c4 10             	add    $0x10,%esp
      curproc->tf->eax = -1;  // Return error
80104c84:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
      return;
80104c8b:	eb da                	jmp    80104c67 <syscall+0x67>
80104c8d:	66 90                	xchg   %ax,%ax
80104c8f:	90                   	nop

80104c90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c98:	53                   	push   %ebx
80104c99:	83 ec 34             	sub    $0x34,%esp
80104c9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ca2:	57                   	push   %edi
80104ca3:	50                   	push   %eax
{
80104ca4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ca7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104caa:	e8 21 d4 ff ff       	call   801020d0 <nameiparent>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	0f 84 4e 01 00 00    	je     80104e08 <create+0x178>
    return 0;
  ilock(dp);
80104cba:	83 ec 0c             	sub    $0xc,%esp
80104cbd:	89 c3                	mov    %eax,%ebx
80104cbf:	50                   	push   %eax
80104cc0:	e8 cb ca ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cc5:	83 c4 0c             	add    $0xc,%esp
80104cc8:	6a 00                	push   $0x0
80104cca:	57                   	push   %edi
80104ccb:	53                   	push   %ebx
80104ccc:	e8 1f d0 ff ff       	call   80101cf0 <dirlookup>
80104cd1:	83 c4 10             	add    $0x10,%esp
80104cd4:	89 c6                	mov    %eax,%esi
80104cd6:	85 c0                	test   %eax,%eax
80104cd8:	74 56                	je     80104d30 <create+0xa0>
    iunlockput(dp);
80104cda:	83 ec 0c             	sub    $0xc,%esp
80104cdd:	53                   	push   %ebx
80104cde:	e8 3d cd ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104ce3:	89 34 24             	mov    %esi,(%esp)
80104ce6:	e8 a5 ca ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ceb:	83 c4 10             	add    $0x10,%esp
80104cee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104cf3:	75 1b                	jne    80104d10 <create+0x80>
80104cf5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104cfa:	75 14                	jne    80104d10 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cff:	89 f0                	mov    %esi,%eax
80104d01:	5b                   	pop    %ebx
80104d02:	5e                   	pop    %esi
80104d03:	5f                   	pop    %edi
80104d04:	5d                   	pop    %ebp
80104d05:	c3                   	ret
80104d06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d0d:	00 
80104d0e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104d10:	83 ec 0c             	sub    $0xc,%esp
80104d13:	56                   	push   %esi
    return 0;
80104d14:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d16:	e8 05 cd ff ff       	call   80101a20 <iunlockput>
    return 0;
80104d1b:	83 c4 10             	add    $0x10,%esp
}
80104d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d21:	89 f0                	mov    %esi,%eax
80104d23:	5b                   	pop    %ebx
80104d24:	5e                   	pop    %esi
80104d25:	5f                   	pop    %edi
80104d26:	5d                   	pop    %ebp
80104d27:	c3                   	ret
80104d28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d2f:	00 
  if((ip = ialloc(dp->dev, type)) == 0)
80104d30:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d34:	83 ec 08             	sub    $0x8,%esp
80104d37:	50                   	push   %eax
80104d38:	ff 33                	push   (%ebx)
80104d3a:	e8 d1 c8 ff ff       	call   80101610 <ialloc>
80104d3f:	83 c4 10             	add    $0x10,%esp
80104d42:	89 c6                	mov    %eax,%esi
80104d44:	85 c0                	test   %eax,%eax
80104d46:	0f 84 d5 00 00 00    	je     80104e21 <create+0x191>
  ilock(ip);
80104d4c:	83 ec 0c             	sub    $0xc,%esp
80104d4f:	50                   	push   %eax
80104d50:	e8 3b ca ff ff       	call   80101790 <ilock>
  ip->major = major;
80104d55:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->mode = 7;   // // rwx (read, write, execute) for directories and files
80104d59:	c7 86 90 00 00 00 07 	movl   $0x7,0x90(%esi)
80104d60:	00 00 00 
  ip->major = major;
80104d63:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d67:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d6b:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d6f:	b8 01 00 00 00       	mov    $0x1,%eax
80104d74:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d78:	89 34 24             	mov    %esi,(%esp)
80104d7b:	e8 50 c9 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d80:	83 c4 10             	add    $0x10,%esp
80104d83:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d88:	74 2e                	je     80104db8 <create+0x128>
  if(dirlink(dp, name, ip->inum) < 0)
80104d8a:	83 ec 04             	sub    $0x4,%esp
80104d8d:	ff 76 04             	push   0x4(%esi)
80104d90:	57                   	push   %edi
80104d91:	53                   	push   %ebx
80104d92:	e8 59 d2 ff ff       	call   80101ff0 <dirlink>
80104d97:	83 c4 10             	add    $0x10,%esp
80104d9a:	85 c0                	test   %eax,%eax
80104d9c:	78 76                	js     80104e14 <create+0x184>
  iunlockput(dp);
80104d9e:	83 ec 0c             	sub    $0xc,%esp
80104da1:	53                   	push   %ebx
80104da2:	e8 79 cc ff ff       	call   80101a20 <iunlockput>
  return ip;
80104da7:	83 c4 10             	add    $0x10,%esp
}
80104daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dad:	89 f0                	mov    %esi,%eax
80104daf:	5b                   	pop    %ebx
80104db0:	5e                   	pop    %esi
80104db1:	5f                   	pop    %edi
80104db2:	5d                   	pop    %ebp
80104db3:	c3                   	ret
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iupdate(dp);
80104db8:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104dbb:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104dc0:	53                   	push   %ebx
80104dc1:	e8 0a c9 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dc6:	83 c4 0c             	add    $0xc,%esp
80104dc9:	ff 76 04             	push   0x4(%esi)
80104dcc:	68 c8 7a 10 80       	push   $0x80107ac8
80104dd1:	56                   	push   %esi
80104dd2:	e8 19 d2 ff ff       	call   80101ff0 <dirlink>
80104dd7:	83 c4 10             	add    $0x10,%esp
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	78 18                	js     80104df6 <create+0x166>
80104dde:	83 ec 04             	sub    $0x4,%esp
80104de1:	ff 73 04             	push   0x4(%ebx)
80104de4:	68 c7 7a 10 80       	push   $0x80107ac7
80104de9:	56                   	push   %esi
80104dea:	e8 01 d2 ff ff       	call   80101ff0 <dirlink>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	79 94                	jns    80104d8a <create+0xfa>
      panic("create dots");
80104df6:	83 ec 0c             	sub    $0xc,%esp
80104df9:	68 bb 7a 10 80       	push   $0x80107abb
80104dfe:	e8 7d b5 ff ff       	call   80100380 <panic>
80104e03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80104e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e0b:	31 f6                	xor    %esi,%esi
}
80104e0d:	5b                   	pop    %ebx
80104e0e:	89 f0                	mov    %esi,%eax
80104e10:	5e                   	pop    %esi
80104e11:	5f                   	pop    %edi
80104e12:	5d                   	pop    %ebp
80104e13:	c3                   	ret
    panic("create: dirlink");
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	68 ca 7a 10 80       	push   $0x80107aca
80104e1c:	e8 5f b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e21:	83 ec 0c             	sub    $0xc,%esp
80104e24:	68 ac 7a 10 80       	push   $0x80107aac
80104e29:	e8 52 b5 ff ff       	call   80100380 <panic>
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <sys_dup>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e3b:	50                   	push   %eax
80104e3c:	6a 00                	push   $0x0
80104e3e:	e8 1d fc ff ff       	call   80104a60 <argint>
80104e43:	83 c4 10             	add    $0x10,%esp
80104e46:	85 c0                	test   %eax,%eax
80104e48:	78 36                	js     80104e80 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e4e:	77 30                	ja     80104e80 <sys_dup+0x50>
80104e50:	e8 eb eb ff ff       	call   80103a40 <myproc>
80104e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e5c:	85 f6                	test   %esi,%esi
80104e5e:	74 20                	je     80104e80 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e60:	e8 db eb ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e65:	31 db                	xor    %ebx,%ebx
80104e67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e6e:	00 
80104e6f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104e70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e74:	85 d2                	test   %edx,%edx
80104e76:	74 18                	je     80104e90 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e78:	83 c3 01             	add    $0x1,%ebx
80104e7b:	83 fb 10             	cmp    $0x10,%ebx
80104e7e:	75 f0                	jne    80104e70 <sys_dup+0x40>
}
80104e80:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e83:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e88:	89 d8                	mov    %ebx,%eax
80104e8a:	5b                   	pop    %ebx
80104e8b:	5e                   	pop    %esi
80104e8c:	5d                   	pop    %ebp
80104e8d:	c3                   	ret
80104e8e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e90:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e93:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e97:	56                   	push   %esi
80104e98:	e8 03 c0 ff ff       	call   80100ea0 <filedup>
  return fd;
80104e9d:	83 c4 10             	add    $0x10,%esp
}
80104ea0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea3:	89 d8                	mov    %ebx,%eax
80104ea5:	5b                   	pop    %ebx
80104ea6:	5e                   	pop    %esi
80104ea7:	5d                   	pop    %ebp
80104ea8:	c3                   	ret
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <sys_read>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104eb5:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80104eb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ebb:	56                   	push   %esi
80104ebc:	6a 00                	push   $0x0
80104ebe:	e8 9d fb ff ff       	call   80104a60 <argint>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	0f 88 a2 00 00 00    	js     80104f70 <sys_read+0xc0>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ece:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ed2:	0f 87 98 00 00 00    	ja     80104f70 <sys_read+0xc0>
80104ed8:	e8 63 eb ff ff       	call   80103a40 <myproc>
80104edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee0:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
80104ee4:	85 db                	test   %ebx,%ebx
80104ee6:	0f 84 84 00 00 00    	je     80104f70 <sys_read+0xc0>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eec:	83 ec 08             	sub    $0x8,%esp
80104eef:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ef2:	50                   	push   %eax
80104ef3:	6a 02                	push   $0x2
80104ef5:	e8 66 fb ff ff       	call   80104a60 <argint>
80104efa:	83 c4 10             	add    $0x10,%esp
80104efd:	85 c0                	test   %eax,%eax
80104eff:	78 6f                	js     80104f70 <sys_read+0xc0>
80104f01:	83 ec 04             	sub    $0x4,%esp
80104f04:	ff 75 f0             	push   -0x10(%ebp)
80104f07:	56                   	push   %esi
80104f08:	6a 01                	push   $0x1
80104f0a:	e8 a1 fb ff ff       	call   80104ab0 <argptr>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	85 c0                	test   %eax,%eax
80104f14:	78 5a                	js     80104f70 <sys_read+0xc0>
  ilock(f->ip);
80104f16:	83 ec 0c             	sub    $0xc,%esp
80104f19:	ff 73 10             	push   0x10(%ebx)
80104f1c:	e8 6f c8 ff ff       	call   80101790 <ilock>
  if (!(f->ip->mode & 4)) {  // Check if Read permission is missing
80104f21:	8b 43 10             	mov    0x10(%ebx),%eax
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	f6 80 90 00 00 00 04 	testb  $0x4,0x90(%eax)
80104f2e:	74 22                	je     80104f52 <sys_read+0xa2>
  iunlock(f->ip);
80104f30:	83 ec 0c             	sub    $0xc,%esp
80104f33:	50                   	push   %eax
80104f34:	e8 37 c9 ff ff       	call   80101870 <iunlock>
  return fileread(f, p, n);
80104f39:	83 c4 0c             	add    $0xc,%esp
80104f3c:	ff 75 f0             	push   -0x10(%ebp)
80104f3f:	ff 75 f4             	push   -0xc(%ebp)
80104f42:	53                   	push   %ebx
80104f43:	e8 d8 c0 ff ff       	call   80101020 <fileread>
80104f48:	83 c4 10             	add    $0x10,%esp
}
80104f4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f4e:	5b                   	pop    %ebx
80104f4f:	5e                   	pop    %esi
80104f50:	5d                   	pop    %ebp
80104f51:	c3                   	ret
    iunlock(f->ip);
80104f52:	83 ec 0c             	sub    $0xc,%esp
80104f55:	50                   	push   %eax
80104f56:	e8 15 c9 ff ff       	call   80101870 <iunlock>
    cprintf("Operation read failed\n");
80104f5b:	c7 04 24 da 7a 10 80 	movl   $0x80107ada,(%esp)
80104f62:	e8 39 b7 ff ff       	call   801006a0 <cprintf>
    return -1;
80104f67:	83 c4 10             	add    $0x10,%esp
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f75:	eb d4                	jmp    80104f4b <sys_read+0x9b>
80104f77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f7e:	00 
80104f7f:	90                   	nop

80104f80 <sys_write>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f85:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80104f88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f8b:	56                   	push   %esi
80104f8c:	6a 00                	push   $0x0
80104f8e:	e8 cd fa ff ff       	call   80104a60 <argint>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	0f 88 ca 00 00 00    	js     80105068 <sys_write+0xe8>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fa2:	0f 87 c0 00 00 00    	ja     80105068 <sys_write+0xe8>
80104fa8:	e8 93 ea ff ff       	call   80103a40 <myproc>
80104fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb0:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
80104fb4:	85 db                	test   %ebx,%ebx
80104fb6:	0f 84 ac 00 00 00    	je     80105068 <sys_write+0xe8>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fbc:	83 ec 08             	sub    $0x8,%esp
80104fbf:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fc2:	50                   	push   %eax
80104fc3:	6a 02                	push   $0x2
80104fc5:	e8 96 fa ff ff       	call   80104a60 <argint>
80104fca:	83 c4 10             	add    $0x10,%esp
80104fcd:	85 c0                	test   %eax,%eax
80104fcf:	0f 88 93 00 00 00    	js     80105068 <sys_write+0xe8>
80104fd5:	83 ec 04             	sub    $0x4,%esp
80104fd8:	ff 75 f0             	push   -0x10(%ebp)
80104fdb:	56                   	push   %esi
80104fdc:	6a 01                	push   $0x1
80104fde:	e8 cd fa ff ff       	call   80104ab0 <argptr>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	78 7e                	js     80105068 <sys_write+0xe8>
  ilock(f->ip);
80104fea:	83 ec 0c             	sub    $0xc,%esp
80104fed:	ff 73 10             	push   0x10(%ebx)
80104ff0:	e8 9b c7 ff ff       	call   80101790 <ilock>
  if (!(f->ip->mode & 2)) {  // Check Write Permission (w = bit 1)
80104ff5:	8b 43 10             	mov    0x10(%ebx),%eax
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	f6 80 90 00 00 00 02 	testb  $0x2,0x90(%eax)
80105002:	74 2c                	je     80105030 <sys_write+0xb0>
  iunlock(f->ip);
80105004:	83 ec 0c             	sub    $0xc,%esp
80105007:	50                   	push   %eax
80105008:	e8 63 c8 ff ff       	call   80101870 <iunlock>
  return filewrite(f, p, n);
8010500d:	83 c4 0c             	add    $0xc,%esp
80105010:	ff 75 f0             	push   -0x10(%ebp)
80105013:	ff 75 f4             	push   -0xc(%ebp)
80105016:	53                   	push   %ebx
  last_failed_fd = -1;  // Reset if write succeeds
80105017:	c7 05 08 b0 10 80 ff 	movl   $0xffffffff,0x8010b008
8010501e:	ff ff ff 
  return filewrite(f, p, n);
80105021:	e8 8a c0 ff ff       	call   801010b0 <filewrite>
80105026:	83 c4 10             	add    $0x10,%esp
}
80105029:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010502c:	5b                   	pop    %ebx
8010502d:	5e                   	pop    %esi
8010502e:	5d                   	pop    %ebp
8010502f:	c3                   	ret
    iunlock(f->ip);
80105030:	83 ec 0c             	sub    $0xc,%esp
80105033:	50                   	push   %eax
80105034:	e8 37 c8 ff ff       	call   80101870 <iunlock>
    if (last_failed_fd != f->ip->inum) {  // Only print once per file
80105039:	8b 43 10             	mov    0x10(%ebx),%eax
8010503c:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
80105042:	83 c4 10             	add    $0x10,%esp
80105045:	39 48 04             	cmp    %ecx,0x4(%eax)
80105048:	74 1e                	je     80105068 <sys_write+0xe8>
      cprintf("Operation write failed\n");
8010504a:	83 ec 0c             	sub    $0xc,%esp
8010504d:	68 f1 7a 10 80       	push   $0x80107af1
80105052:	e8 49 b6 ff ff       	call   801006a0 <cprintf>
      last_failed_fd = f->ip->inum;
80105057:	8b 43 10             	mov    0x10(%ebx),%eax
8010505a:	83 c4 10             	add    $0x10,%esp
8010505d:	8b 40 04             	mov    0x4(%eax),%eax
80105060:	a3 08 b0 10 80       	mov    %eax,0x8010b008
80105065:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;  // ❌ No write permission
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506d:	eb ba                	jmp    80105029 <sys_write+0xa9>
8010506f:	90                   	nop

80105070 <sys_close>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105075:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105078:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010507b:	50                   	push   %eax
8010507c:	6a 00                	push   $0x0
8010507e:	e8 dd f9 ff ff       	call   80104a60 <argint>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	78 3e                	js     801050c8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010508a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010508e:	77 38                	ja     801050c8 <sys_close+0x58>
80105090:	e8 ab e9 ff ff       	call   80103a40 <myproc>
80105095:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105098:	8d 5a 08             	lea    0x8(%edx),%ebx
8010509b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010509f:	85 f6                	test   %esi,%esi
801050a1:	74 25                	je     801050c8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050a3:	e8 98 e9 ff ff       	call   80103a40 <myproc>
  fileclose(f);
801050a8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050ab:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050b2:	00 
  fileclose(f);
801050b3:	56                   	push   %esi
801050b4:	e8 37 be ff ff       	call   80100ef0 <fileclose>
  return 0;
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	31 c0                	xor    %eax,%eax
}
801050be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050c1:	5b                   	pop    %ebx
801050c2:	5e                   	pop    %esi
801050c3:	5d                   	pop    %ebp
801050c4:	c3                   	ret
801050c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cd:	eb ef                	jmp    801050be <sys_close+0x4e>
801050cf:	90                   	nop

801050d0 <sys_fstat>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050db:	53                   	push   %ebx
801050dc:	6a 00                	push   $0x0
801050de:	e8 7d f9 ff ff       	call   80104a60 <argint>
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	78 46                	js     80105130 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ee:	77 40                	ja     80105130 <sys_fstat+0x60>
801050f0:	e8 4b e9 ff ff       	call   80103a40 <myproc>
801050f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050fc:	85 f6                	test   %esi,%esi
801050fe:	74 30                	je     80105130 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105100:	83 ec 04             	sub    $0x4,%esp
80105103:	6a 14                	push   $0x14
80105105:	53                   	push   %ebx
80105106:	6a 01                	push   $0x1
80105108:	e8 a3 f9 ff ff       	call   80104ab0 <argptr>
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	85 c0                	test   %eax,%eax
80105112:	78 1c                	js     80105130 <sys_fstat+0x60>
  return filestat(f, st);
80105114:	83 ec 08             	sub    $0x8,%esp
80105117:	ff 75 f4             	push   -0xc(%ebp)
8010511a:	56                   	push   %esi
8010511b:	e8 b0 be ff ff       	call   80100fd0 <filestat>
80105120:	83 c4 10             	add    $0x10,%esp
}
80105123:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105126:	5b                   	pop    %ebx
80105127:	5e                   	pop    %esi
80105128:	5d                   	pop    %ebp
80105129:	c3                   	ret
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	eb ec                	jmp    80105123 <sys_fstat+0x53>
80105137:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010513e:	00 
8010513f:	90                   	nop

80105140 <sys_link>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105145:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105148:	53                   	push   %ebx
80105149:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010514c:	50                   	push   %eax
8010514d:	6a 00                	push   $0x0
8010514f:	e8 cc f9 ff ff       	call   80104b20 <argstr>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
80105159:	0f 88 fb 00 00 00    	js     8010525a <sys_link+0x11a>
8010515f:	83 ec 08             	sub    $0x8,%esp
80105162:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105165:	50                   	push   %eax
80105166:	6a 01                	push   $0x1
80105168:	e8 b3 f9 ff ff       	call   80104b20 <argstr>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	85 c0                	test   %eax,%eax
80105172:	0f 88 e2 00 00 00    	js     8010525a <sys_link+0x11a>
  begin_op();
80105178:	e8 f3 db ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
8010517d:	83 ec 0c             	sub    $0xc,%esp
80105180:	ff 75 d4             	push   -0x2c(%ebp)
80105183:	e8 28 cf ff ff       	call   801020b0 <namei>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	89 c3                	mov    %eax,%ebx
8010518d:	85 c0                	test   %eax,%eax
8010518f:	0f 84 e4 00 00 00    	je     80105279 <sys_link+0x139>
  ilock(ip);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	50                   	push   %eax
80105199:	e8 f2 c5 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051a6:	0f 84 b5 00 00 00    	je     80105261 <sys_link+0x121>
  iupdate(ip);
801051ac:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051af:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051b4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051b7:	53                   	push   %ebx
801051b8:	e8 13 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801051bd:	89 1c 24             	mov    %ebx,(%esp)
801051c0:	e8 ab c6 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051c5:	58                   	pop    %eax
801051c6:	5a                   	pop    %edx
801051c7:	57                   	push   %edi
801051c8:	ff 75 d0             	push   -0x30(%ebp)
801051cb:	e8 00 cf ff ff       	call   801020d0 <nameiparent>
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	89 c6                	mov    %eax,%esi
801051d5:	85 c0                	test   %eax,%eax
801051d7:	74 5b                	je     80105234 <sys_link+0xf4>
  ilock(dp);
801051d9:	83 ec 0c             	sub    $0xc,%esp
801051dc:	50                   	push   %eax
801051dd:	e8 ae c5 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051e2:	8b 03                	mov    (%ebx),%eax
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	39 06                	cmp    %eax,(%esi)
801051e9:	75 3d                	jne    80105228 <sys_link+0xe8>
801051eb:	83 ec 04             	sub    $0x4,%esp
801051ee:	ff 73 04             	push   0x4(%ebx)
801051f1:	57                   	push   %edi
801051f2:	56                   	push   %esi
801051f3:	e8 f8 cd ff ff       	call   80101ff0 <dirlink>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	78 29                	js     80105228 <sys_link+0xe8>
  iunlockput(dp);
801051ff:	83 ec 0c             	sub    $0xc,%esp
80105202:	56                   	push   %esi
80105203:	e8 18 c8 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
80105208:	89 1c 24             	mov    %ebx,(%esp)
8010520b:	e8 b0 c6 ff ff       	call   801018c0 <iput>
  end_op();
80105210:	e8 cb db ff ff       	call   80102de0 <end_op>
  return 0;
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	31 c0                	xor    %eax,%eax
}
8010521a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010521d:	5b                   	pop    %ebx
8010521e:	5e                   	pop    %esi
8010521f:	5f                   	pop    %edi
80105220:	5d                   	pop    %ebp
80105221:	c3                   	ret
80105222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105228:	83 ec 0c             	sub    $0xc,%esp
8010522b:	56                   	push   %esi
8010522c:	e8 ef c7 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105231:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	53                   	push   %ebx
80105238:	e8 53 c5 ff ff       	call   80101790 <ilock>
  ip->nlink--;
8010523d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105242:	89 1c 24             	mov    %ebx,(%esp)
80105245:	e8 86 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010524a:	89 1c 24             	mov    %ebx,(%esp)
8010524d:	e8 ce c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105252:	e8 89 db ff ff       	call   80102de0 <end_op>
  return -1;
80105257:	83 c4 10             	add    $0x10,%esp
8010525a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525f:	eb b9                	jmp    8010521a <sys_link+0xda>
    iunlockput(ip);
80105261:	83 ec 0c             	sub    $0xc,%esp
80105264:	53                   	push   %ebx
80105265:	e8 b6 c7 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010526a:	e8 71 db ff ff       	call   80102de0 <end_op>
    return -1;
8010526f:	83 c4 10             	add    $0x10,%esp
80105272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105277:	eb a1                	jmp    8010521a <sys_link+0xda>
    end_op();
80105279:	e8 62 db ff ff       	call   80102de0 <end_op>
    return -1;
8010527e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105283:	eb 95                	jmp    8010521a <sys_link+0xda>
80105285:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010528c:	00 
8010528d:	8d 76 00             	lea    0x0(%esi),%esi

80105290 <sys_unlink>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	57                   	push   %edi
80105294:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105295:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105298:	53                   	push   %ebx
80105299:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010529c:	50                   	push   %eax
8010529d:	6a 00                	push   $0x0
8010529f:	e8 7c f8 ff ff       	call   80104b20 <argstr>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	0f 88 82 01 00 00    	js     80105431 <sys_unlink+0x1a1>
  begin_op();
801052af:	e8 bc da ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052b4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052b7:	83 ec 08             	sub    $0x8,%esp
801052ba:	53                   	push   %ebx
801052bb:	ff 75 c0             	push   -0x40(%ebp)
801052be:	e8 0d ce ff ff       	call   801020d0 <nameiparent>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052c9:	85 c0                	test   %eax,%eax
801052cb:	0f 84 6a 01 00 00    	je     8010543b <sys_unlink+0x1ab>
  ilock(dp);
801052d1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	57                   	push   %edi
801052d8:	e8 b3 c4 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052dd:	58                   	pop    %eax
801052de:	5a                   	pop    %edx
801052df:	68 c8 7a 10 80       	push   $0x80107ac8
801052e4:	53                   	push   %ebx
801052e5:	e8 e6 c9 ff ff       	call   80101cd0 <namecmp>
801052ea:	83 c4 10             	add    $0x10,%esp
801052ed:	85 c0                	test   %eax,%eax
801052ef:	0f 84 03 01 00 00    	je     801053f8 <sys_unlink+0x168>
801052f5:	83 ec 08             	sub    $0x8,%esp
801052f8:	68 c7 7a 10 80       	push   $0x80107ac7
801052fd:	53                   	push   %ebx
801052fe:	e8 cd c9 ff ff       	call   80101cd0 <namecmp>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	0f 84 ea 00 00 00    	je     801053f8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010530e:	83 ec 04             	sub    $0x4,%esp
80105311:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105314:	50                   	push   %eax
80105315:	53                   	push   %ebx
80105316:	57                   	push   %edi
80105317:	e8 d4 c9 ff ff       	call   80101cf0 <dirlookup>
8010531c:	83 c4 10             	add    $0x10,%esp
8010531f:	89 c3                	mov    %eax,%ebx
80105321:	85 c0                	test   %eax,%eax
80105323:	0f 84 cf 00 00 00    	je     801053f8 <sys_unlink+0x168>
  ilock(ip);
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	50                   	push   %eax
8010532d:	e8 5e c4 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010533a:	0f 8e 24 01 00 00    	jle    80105464 <sys_unlink+0x1d4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105340:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105345:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105348:	74 66                	je     801053b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010534a:	83 ec 04             	sub    $0x4,%esp
8010534d:	6a 10                	push   $0x10
8010534f:	6a 00                	push   $0x0
80105351:	57                   	push   %edi
80105352:	e8 49 f4 ff ff       	call   801047a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105357:	6a 10                	push   $0x10
80105359:	ff 75 c4             	push   -0x3c(%ebp)
8010535c:	57                   	push   %edi
8010535d:	ff 75 b4             	push   -0x4c(%ebp)
80105360:	e8 3b c8 ff ff       	call   80101ba0 <writei>
80105365:	83 c4 20             	add    $0x20,%esp
80105368:	83 f8 10             	cmp    $0x10,%eax
8010536b:	0f 85 e6 00 00 00    	jne    80105457 <sys_unlink+0x1c7>
  if(ip->type == T_DIR){
80105371:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105376:	0f 84 9c 00 00 00    	je     80105418 <sys_unlink+0x188>
  iunlockput(dp);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	ff 75 b4             	push   -0x4c(%ebp)
80105382:	e8 99 c6 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105387:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010538c:	89 1c 24             	mov    %ebx,(%esp)
8010538f:	e8 3c c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105394:	89 1c 24             	mov    %ebx,(%esp)
80105397:	e8 84 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010539c:	e8 3f da ff ff       	call   80102de0 <end_op>
  return 0;
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	31 c0                	xor    %eax,%eax
}
801053a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a9:	5b                   	pop    %ebx
801053aa:	5e                   	pop    %esi
801053ab:	5f                   	pop    %edi
801053ac:	5d                   	pop    %ebp
801053ad:	c3                   	ret
801053ae:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053b4:	76 94                	jbe    8010534a <sys_unlink+0xba>
801053b6:	be 20 00 00 00       	mov    $0x20,%esi
801053bb:	eb 0f                	jmp    801053cc <sys_unlink+0x13c>
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
801053c0:	83 c6 10             	add    $0x10,%esi
801053c3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053c6:	0f 83 7e ff ff ff    	jae    8010534a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053cc:	6a 10                	push   $0x10
801053ce:	56                   	push   %esi
801053cf:	57                   	push   %edi
801053d0:	53                   	push   %ebx
801053d1:	e8 ca c6 ff ff       	call   80101aa0 <readi>
801053d6:	83 c4 10             	add    $0x10,%esp
801053d9:	83 f8 10             	cmp    $0x10,%eax
801053dc:	75 6c                	jne    8010544a <sys_unlink+0x1ba>
    if(de.inum != 0)
801053de:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053e3:	74 db                	je     801053c0 <sys_unlink+0x130>
    iunlockput(ip);
801053e5:	83 ec 0c             	sub    $0xc,%esp
801053e8:	53                   	push   %ebx
801053e9:	e8 32 c6 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801053f8:	83 ec 0c             	sub    $0xc,%esp
801053fb:	ff 75 b4             	push   -0x4c(%ebp)
801053fe:	e8 1d c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105403:	e8 d8 d9 ff ff       	call   80102de0 <end_op>
  return -1;
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105410:	eb 94                	jmp    801053a6 <sys_unlink+0x116>
80105412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105418:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010541b:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
8010541e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105423:	50                   	push   %eax
80105424:	e8 a7 c2 ff ff       	call   801016d0 <iupdate>
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	e9 4b ff ff ff       	jmp    8010537c <sys_unlink+0xec>
    return -1;
80105431:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105436:	e9 6b ff ff ff       	jmp    801053a6 <sys_unlink+0x116>
    end_op();
8010543b:	e8 a0 d9 ff ff       	call   80102de0 <end_op>
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105445:	e9 5c ff ff ff       	jmp    801053a6 <sys_unlink+0x116>
      panic("isdirempty: readi");
8010544a:	83 ec 0c             	sub    $0xc,%esp
8010544d:	68 1b 7b 10 80       	push   $0x80107b1b
80105452:	e8 29 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105457:	83 ec 0c             	sub    $0xc,%esp
8010545a:	68 2d 7b 10 80       	push   $0x80107b2d
8010545f:	e8 1c af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105464:	83 ec 0c             	sub    $0xc,%esp
80105467:	68 09 7b 10 80       	push   $0x80107b09
8010546c:	e8 0f af ff ff       	call   80100380 <panic>
80105471:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105478:	00 
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_open>:

int
sys_open(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	57                   	push   %edi
80105484:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105485:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105488:	53                   	push   %ebx
80105489:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010548c:	50                   	push   %eax
8010548d:	6a 00                	push   $0x0
8010548f:	e8 8c f6 ff ff       	call   80104b20 <argstr>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	85 c0                	test   %eax,%eax
80105499:	0f 88 ae 00 00 00    	js     8010554d <sys_open+0xcd>
8010549f:	83 ec 08             	sub    $0x8,%esp
801054a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054a5:	50                   	push   %eax
801054a6:	6a 01                	push   $0x1
801054a8:	e8 b3 f5 ff ff       	call   80104a60 <argint>
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	85 c0                	test   %eax,%eax
801054b2:	0f 88 95 00 00 00    	js     8010554d <sys_open+0xcd>
    return -1;

  begin_op();
801054b8:	e8 b3 d8 ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
801054bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054c1:	0f 85 91 00 00 00    	jne    80105558 <sys_open+0xd8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054c7:	83 ec 0c             	sub    $0xc,%esp
801054ca:	ff 75 e0             	push   -0x20(%ebp)
801054cd:	e8 de cb ff ff       	call   801020b0 <namei>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	89 c6                	mov    %eax,%esi
801054d7:	85 c0                	test   %eax,%eax
801054d9:	0f 84 96 00 00 00    	je     80105575 <sys_open+0xf5>
      end_op();
      return -1;
    }
    ilock(ip);
801054df:	83 ec 0c             	sub    $0xc,%esp
801054e2:	50                   	push   %eax
801054e3:	e8 a8 c2 ff ff       	call   80101790 <ilock>
      end_op();
      cprintf("Operation open failed\n");
      return -1;  // ❌ No read permission
    }

    if ((omode & O_WRONLY) && !(ip->mode & 2)) {  // Check Write Permission
801054e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801054eb:	83 c4 10             	add    $0x10,%esp
801054ee:	a8 01                	test   $0x1,%al
801054f0:	74 0d                	je     801054ff <sys_open+0x7f>
801054f2:	f6 86 90 00 00 00 02 	testb  $0x2,0x90(%esi)
801054f9:	0f 84 cc 00 00 00    	je     801055cb <sys_open+0x14b>
      end_op();
      cprintf("Operation open failed\n");
      return -1;  // ❌ No write permission
    }

    if(ip->type == T_DIR && omode != O_RDONLY){
801054ff:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105504:	75 04                	jne    8010550a <sys_open+0x8a>
80105506:	85 c0                	test   %eax,%eax
80105508:	75 32                	jne    8010553c <sys_open+0xbc>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010550a:	e8 21 b9 ff ff       	call   80100e30 <filealloc>
8010550f:	89 c7                	mov    %eax,%edi
80105511:	85 c0                	test   %eax,%eax
80105513:	74 27                	je     8010553c <sys_open+0xbc>
  struct proc *curproc = myproc();
80105515:	e8 26 e5 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010551a:	31 db                	xor    %ebx,%ebx
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105520:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105524:	85 d2                	test   %edx,%edx
80105526:	74 60                	je     80105588 <sys_open+0x108>
  for(fd = 0; fd < NOFILE; fd++){
80105528:	83 c3 01             	add    $0x1,%ebx
8010552b:	83 fb 10             	cmp    $0x10,%ebx
8010552e:	75 f0                	jne    80105520 <sys_open+0xa0>
    if(f)
      fileclose(f);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	57                   	push   %edi
80105534:	e8 b7 b9 ff ff       	call   80100ef0 <fileclose>
80105539:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	56                   	push   %esi
80105540:	e8 db c4 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105545:	e8 96 d8 ff ff       	call   80102de0 <end_op>
    return -1;
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105552:	eb 6d                	jmp    801055c1 <sys_open+0x141>
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010555e:	31 c9                	xor    %ecx,%ecx
80105560:	ba 02 00 00 00       	mov    $0x2,%edx
80105565:	6a 00                	push   $0x0
80105567:	e8 24 f7 ff ff       	call   80104c90 <create>
    if(ip == 0){
8010556c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010556f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105571:	85 c0                	test   %eax,%eax
80105573:	75 95                	jne    8010550a <sys_open+0x8a>
      end_op();
80105575:	e8 66 d8 ff ff       	call   80102de0 <end_op>
      return -1;
8010557a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010557f:	eb 40                	jmp    801055c1 <sys_open+0x141>
80105581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105588:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010558b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010558f:	56                   	push   %esi
80105590:	e8 db c2 ff ff       	call   80101870 <iunlock>
  end_op();
80105595:	e8 46 d8 ff ff       	call   80102de0 <end_op>

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
      iunlockput(ip);
801055cb:	83 ec 0c             	sub    $0xc,%esp
      return -1;  // ❌ No write permission
801055ce:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      iunlockput(ip);
801055d3:	56                   	push   %esi
801055d4:	e8 47 c4 ff ff       	call   80101a20 <iunlockput>
      end_op();
801055d9:	e8 02 d8 ff ff       	call   80102de0 <end_op>
      cprintf("Operation open failed\n");
801055de:	c7 04 24 3c 7b 10 80 	movl   $0x80107b3c,(%esp)
801055e5:	e8 b6 b0 ff ff       	call   801006a0 <cprintf>
      return -1;  // ❌ No write permission
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	eb d2                	jmp    801055c1 <sys_open+0x141>
801055ef:	90                   	nop

801055f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055f6:	e8 75 d7 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055fb:	83 ec 08             	sub    $0x8,%esp
801055fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105601:	50                   	push   %eax
80105602:	6a 00                	push   $0x0
80105604:	e8 17 f5 ff ff       	call   80104b20 <argstr>
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	85 c0                	test   %eax,%eax
8010560e:	78 30                	js     80105640 <sys_mkdir+0x50>
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105616:	31 c9                	xor    %ecx,%ecx
80105618:	ba 01 00 00 00       	mov    $0x1,%edx
8010561d:	6a 00                	push   $0x0
8010561f:	e8 6c f6 ff ff       	call   80104c90 <create>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	74 15                	je     80105640 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010562b:	83 ec 0c             	sub    $0xc,%esp
8010562e:	50                   	push   %eax
8010562f:	e8 ec c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105634:	e8 a7 d7 ff ff       	call   80102de0 <end_op>
  return 0;
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	31 c0                	xor    %eax,%eax
}
8010563e:	c9                   	leave
8010563f:	c3                   	ret
    end_op();
80105640:	e8 9b d7 ff ff       	call   80102de0 <end_op>
    return -1;
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564a:	c9                   	leave
8010564b:	c3                   	ret
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_mknod>:

int
sys_mknod(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105656:	e8 15 d7 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010565b:	83 ec 08             	sub    $0x8,%esp
8010565e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105661:	50                   	push   %eax
80105662:	6a 00                	push   $0x0
80105664:	e8 b7 f4 ff ff       	call   80104b20 <argstr>
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	85 c0                	test   %eax,%eax
8010566e:	78 60                	js     801056d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105670:	83 ec 08             	sub    $0x8,%esp
80105673:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105676:	50                   	push   %eax
80105677:	6a 01                	push   $0x1
80105679:	e8 e2 f3 ff ff       	call   80104a60 <argint>
  if((argstr(0, &path)) < 0 ||
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	85 c0                	test   %eax,%eax
80105683:	78 4b                	js     801056d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105685:	83 ec 08             	sub    $0x8,%esp
80105688:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568b:	50                   	push   %eax
8010568c:	6a 02                	push   $0x2
8010568e:	e8 cd f3 ff ff       	call   80104a60 <argint>
     argint(1, &major) < 0 ||
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	78 36                	js     801056d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010569a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010569e:	83 ec 0c             	sub    $0xc,%esp
801056a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056a5:	ba 03 00 00 00       	mov    $0x3,%edx
801056aa:	50                   	push   %eax
801056ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056ae:	e8 dd f5 ff ff       	call   80104c90 <create>
     argint(2, &minor) < 0 ||
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	74 16                	je     801056d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	50                   	push   %eax
801056be:	e8 5d c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
801056c3:	e8 18 d7 ff ff       	call   80102de0 <end_op>
  return 0;
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	31 c0                	xor    %eax,%eax
}
801056cd:	c9                   	leave
801056ce:	c3                   	ret
801056cf:	90                   	nop
    end_op();
801056d0:	e8 0b d7 ff ff       	call   80102de0 <end_op>
    return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056da:	c9                   	leave
801056db:	c3                   	ret
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_chdir>:

int
sys_chdir(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	56                   	push   %esi
801056e4:	53                   	push   %ebx
801056e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056e8:	e8 53 e3 ff ff       	call   80103a40 <myproc>
801056ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056ef:	e8 7c d6 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056f4:	83 ec 08             	sub    $0x8,%esp
801056f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056fa:	50                   	push   %eax
801056fb:	6a 00                	push   $0x0
801056fd:	e8 1e f4 ff ff       	call   80104b20 <argstr>
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	85 c0                	test   %eax,%eax
80105707:	78 77                	js     80105780 <sys_chdir+0xa0>
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	ff 75 f4             	push   -0xc(%ebp)
8010570f:	e8 9c c9 ff ff       	call   801020b0 <namei>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	89 c3                	mov    %eax,%ebx
80105719:	85 c0                	test   %eax,%eax
8010571b:	74 63                	je     80105780 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	50                   	push   %eax
80105721:	e8 6a c0 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010572e:	75 30                	jne    80105760 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	53                   	push   %ebx
80105734:	e8 37 c1 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
80105739:	58                   	pop    %eax
8010573a:	ff 76 68             	push   0x68(%esi)
8010573d:	e8 7e c1 ff ff       	call   801018c0 <iput>
  end_op();
80105742:	e8 99 d6 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
80105747:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	31 c0                	xor    %eax,%eax
}
8010574f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105752:	5b                   	pop    %ebx
80105753:	5e                   	pop    %esi
80105754:	5d                   	pop    %ebp
80105755:	c3                   	ret
80105756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010575d:	00 
8010575e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 b7 c2 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105769:	e8 72 d6 ff ff       	call   80102de0 <end_op>
    return -1;
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105776:	eb d7                	jmp    8010574f <sys_chdir+0x6f>
80105778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010577f:	00 
    end_op();
80105780:	e8 5b d6 ff ff       	call   80102de0 <end_op>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010578a:	eb c3                	jmp    8010574f <sys_chdir+0x6f>
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_exec>:

int sys_exec(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;
  struct inode *ip;  // NEW: Inode pointer to check permissions

  if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105795:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010579b:	53                   	push   %ebx
8010579c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
801057a2:	50                   	push   %eax
801057a3:	6a 00                	push   $0x0
801057a5:	e8 76 f3 ff ff       	call   80104b20 <argstr>
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	85 c0                	test   %eax,%eax
801057af:	0f 88 87 00 00 00    	js     8010583c <sys_exec+0xac>
801057b5:	83 ec 08             	sub    $0x8,%esp
801057b8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057be:	50                   	push   %eax
801057bf:	6a 01                	push   $0x1
801057c1:	e8 9a f2 ff ff       	call   80104a60 <argint>
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	85 c0                	test   %eax,%eax
801057cb:	78 6f                	js     8010583c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057cd:	83 ec 04             	sub    $0x4,%esp
801057d0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++) {
801057d6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057d8:	68 80 00 00 00       	push   $0x80
801057dd:	6a 00                	push   $0x0
801057df:	56                   	push   %esi
801057e0:	e8 bb ef ff ff       	call   801047a0 <memset>
801057e5:	83 c4 10             	add    $0x10,%esp
801057e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057ef:	00 
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int*)&uarg) < 0)
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057f9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105800:	50                   	push   %eax
80105801:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105807:	01 f8                	add    %edi,%eax
80105809:	50                   	push   %eax
8010580a:	e8 c1 f1 ff ff       	call   801049d0 <fetchint>
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	85 c0                	test   %eax,%eax
80105814:	78 26                	js     8010583c <sys_exec+0xac>
      return -1;
    if (uarg == 0) {
80105816:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010581c:	85 c0                	test   %eax,%eax
8010581e:	74 30                	je     80105850 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105826:	52                   	push   %edx
80105827:	50                   	push   %eax
80105828:	e8 e3 f1 ff ff       	call   80104a10 <fetchstr>
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	85 c0                	test   %eax,%eax
80105832:	78 08                	js     8010583c <sys_exec+0xac>
  for (i = 0;; i++) {
80105834:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80105837:	83 fb 20             	cmp    $0x20,%ebx
8010583a:	75 b4                	jne    801057f0 <sys_exec+0x60>

  // 🔹 NEW: Lookup inode and check execute permission
  begin_op();
  if ((ip = namei(path)) == 0) {  // Get the inode of the file
    end_op();
    return -1;  // ❌ File not found
8010583c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  iunlock(ip);
  end_op();

  return exec(path, argv);  // ✅ Allowed execution
}
80105841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105844:	5b                   	pop    %ebx
80105845:	5e                   	pop    %esi
80105846:	5f                   	pop    %edi
80105847:	5d                   	pop    %ebp
80105848:	c3                   	ret
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105850:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105857:	00 00 00 00 
  begin_op();
8010585b:	e8 10 d5 ff ff       	call   80102d70 <begin_op>
  if ((ip = namei(path)) == 0) {  // Get the inode of the file
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105869:	e8 42 c8 ff ff       	call   801020b0 <namei>
8010586e:	83 c4 10             	add    $0x10,%esp
80105871:	89 c3                	mov    %eax,%ebx
80105873:	85 c0                	test   %eax,%eax
80105875:	74 63                	je     801058da <sys_exec+0x14a>
  ilock(ip);
80105877:	83 ec 0c             	sub    $0xc,%esp
8010587a:	50                   	push   %eax
8010587b:	e8 10 bf ff ff       	call   80101790 <ilock>
  if (!(ip->mode & 1)) {  // Check if execute (x) permission is set
80105880:	83 c4 10             	add    $0x10,%esp
80105883:	f6 83 90 00 00 00 01 	testb  $0x1,0x90(%ebx)
8010588a:	74 27                	je     801058b3 <sys_exec+0x123>
  iunlock(ip);
8010588c:	83 ec 0c             	sub    $0xc,%esp
8010588f:	53                   	push   %ebx
80105890:	e8 db bf ff ff       	call   80101870 <iunlock>
  end_op();
80105895:	e8 46 d5 ff ff       	call   80102de0 <end_op>
  return exec(path, argv);  // ✅ Allowed execution
8010589a:	58                   	pop    %eax
8010589b:	5a                   	pop    %edx
8010589c:	56                   	push   %esi
8010589d:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058a3:	e8 08 b2 ff ff       	call   80100ab0 <exec>
801058a8:	83 c4 10             	add    $0x10,%esp
}
801058ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058ae:	5b                   	pop    %ebx
801058af:	5e                   	pop    %esi
801058b0:	5f                   	pop    %edi
801058b1:	5d                   	pop    %ebp
801058b2:	c3                   	ret
    iunlockput(ip);
801058b3:	83 ec 0c             	sub    $0xc,%esp
801058b6:	53                   	push   %ebx
801058b7:	e8 64 c1 ff ff       	call   80101a20 <iunlockput>
    end_op();
801058bc:	e8 1f d5 ff ff       	call   80102de0 <end_op>
    cprintf("Operation execute failed\n");
801058c1:	c7 04 24 53 7b 10 80 	movl   $0x80107b53,(%esp)
801058c8:	e8 d3 ad ff ff       	call   801006a0 <cprintf>
    return -1;  // ❌ No execute permission
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d5:	e9 67 ff ff ff       	jmp    80105841 <sys_exec+0xb1>
    end_op();
801058da:	e8 01 d5 ff ff       	call   80102de0 <end_op>
801058df:	e9 58 ff ff ff       	jmp    8010583c <sys_exec+0xac>
801058e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058eb:	00 
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_pipe>:

int
sys_pipe(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	57                   	push   %edi
801058f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058f8:	53                   	push   %ebx
801058f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058fc:	6a 08                	push   $0x8
801058fe:	50                   	push   %eax
801058ff:	6a 00                	push   $0x0
80105901:	e8 aa f1 ff ff       	call   80104ab0 <argptr>
80105906:	83 c4 10             	add    $0x10,%esp
80105909:	85 c0                	test   %eax,%eax
8010590b:	78 4a                	js     80105957 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010590d:	83 ec 08             	sub    $0x8,%esp
80105910:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105913:	50                   	push   %eax
80105914:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105917:	50                   	push   %eax
80105918:	e8 23 db ff ff       	call   80103440 <pipealloc>
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	85 c0                	test   %eax,%eax
80105922:	78 33                	js     80105957 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105924:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105927:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105929:	e8 12 e1 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010592e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105930:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105934:	85 f6                	test   %esi,%esi
80105936:	74 28                	je     80105960 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105938:	83 c3 01             	add    $0x1,%ebx
8010593b:	83 fb 10             	cmp    $0x10,%ebx
8010593e:	75 f0                	jne    80105930 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	ff 75 e0             	push   -0x20(%ebp)
80105946:	e8 a5 b5 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010594b:	58                   	pop    %eax
8010594c:	ff 75 e4             	push   -0x1c(%ebp)
8010594f:	e8 9c b5 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105954:	83 c4 10             	add    $0x10,%esp
80105957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595c:	eb 53                	jmp    801059b1 <sys_pipe+0xc1>
8010595e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105960:	8d 73 08             	lea    0x8(%ebx),%esi
80105963:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010596a:	e8 d1 e0 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010596f:	31 d2                	xor    %edx,%edx
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105978:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010597c:	85 c9                	test   %ecx,%ecx
8010597e:	74 20                	je     801059a0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105980:	83 c2 01             	add    $0x1,%edx
80105983:	83 fa 10             	cmp    $0x10,%edx
80105986:	75 f0                	jne    80105978 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105988:	e8 b3 e0 ff ff       	call   80103a40 <myproc>
8010598d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105994:	00 
80105995:	eb a9                	jmp    80105940 <sys_pipe+0x50>
80105997:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599e:	00 
8010599f:	90                   	nop
      curproc->ofile[fd] = f;
801059a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801059a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801059a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801059af:	31 c0                	xor    %eax,%eax
}
801059b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b4:	5b                   	pop    %ebx
801059b5:	5e                   	pop    %esi
801059b6:	5f                   	pop    %edi
801059b7:	5d                   	pop    %ebp
801059b8:	c3                   	ret
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_chmod>:

// System call to implement chmod
int sys_chmod(void) {
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	53                   	push   %ebx
  char *path;
  int mode;
  
  if (argstr(0, &path) < 0 || argint(1, &mode) < 0)
801059c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_chmod(void) {
801059c7:	83 ec 1c             	sub    $0x1c,%esp
  if (argstr(0, &path) < 0 || argint(1, &mode) < 0)
801059ca:	50                   	push   %eax
801059cb:	6a 00                	push   $0x0
801059cd:	e8 4e f1 ff ff       	call   80104b20 <argstr>
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	85 c0                	test   %eax,%eax
801059d7:	78 67                	js     80105a40 <sys_chmod+0x80>
801059d9:	83 ec 08             	sub    $0x8,%esp
801059dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059df:	50                   	push   %eax
801059e0:	6a 01                	push   $0x1
801059e2:	e8 79 f0 ff ff       	call   80104a60 <argint>
801059e7:	83 c4 10             	add    $0x10,%esp
801059ea:	85 c0                	test   %eax,%eax
801059ec:	78 52                	js     80105a40 <sys_chmod+0x80>
      return -1;

  struct inode *ip = namei(path);
801059ee:	83 ec 0c             	sub    $0xc,%esp
801059f1:	ff 75 f0             	push   -0x10(%ebp)
801059f4:	e8 b7 c6 ff ff       	call   801020b0 <namei>
  if (ip == 0)
801059f9:	83 c4 10             	add    $0x10,%esp
  struct inode *ip = namei(path);
801059fc:	89 c3                	mov    %eax,%ebx
  if (ip == 0)
801059fe:	85 c0                	test   %eax,%eax
80105a00:	74 3e                	je     80105a40 <sys_chmod+0x80>
      return -1;

  begin_op();
80105a02:	e8 69 d3 ff ff       	call   80102d70 <begin_op>
  ilock(ip);
80105a07:	83 ec 0c             	sub    $0xc,%esp
80105a0a:	53                   	push   %ebx
80105a0b:	e8 80 bd ff ff       	call   80101790 <ilock>

  ip->mode = mode; // Set new permissions
80105a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a13:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  iupdate(ip);      // Update the inode
80105a19:	89 1c 24             	mov    %ebx,(%esp)
80105a1c:	e8 af bc ff ff       	call   801016d0 <iupdate>

  iunlock(ip);
80105a21:	89 1c 24             	mov    %ebx,(%esp)
80105a24:	e8 47 be ff ff       	call   80101870 <iunlock>
  end_op();
80105a29:	e8 b2 d3 ff ff       	call   80102de0 <end_op>

  return 0;
80105a2e:	83 c4 10             	add    $0x10,%esp
80105a31:	31 c0                	xor    %eax,%eax
}
80105a33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a36:	c9                   	leave
80105a37:	c3                   	ret
80105a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a3f:	00 
      return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a45:	eb ec                	jmp    80105a33 <sys_chmod+0x73>
80105a47:	66 90                	xchg   %ax,%ax
80105a49:	66 90                	xchg   %ax,%ax
80105a4b:	66 90                	xchg   %ax,%ax
80105a4d:	66 90                	xchg   %ax,%ax
80105a4f:	90                   	nop

80105a50 <sys_fork>:

int blocked_syscalls[MAX_SYSCALLS] = {0};  // Global kernel-side tracking


int sys_fork(void) {
    return fork();
80105a50:	e9 8b e1 ff ff       	jmp    80103be0 <fork>
80105a55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a5c:	00 
80105a5d:	8d 76 00             	lea    0x0(%esi),%esi

80105a60 <sys_exit>:
}

int sys_exit(void) {
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 08             	sub    $0x8,%esp
    exit();
80105a66:	e8 f5 e3 ff ff       	call   80103e60 <exit>
    return 0;  // not reached
}
80105a6b:	31 c0                	xor    %eax,%eax
80105a6d:	c9                   	leave
80105a6e:	c3                   	ret
80105a6f:	90                   	nop

80105a70 <sys_wait>:

int sys_wait(void) {
    return wait();
80105a70:	e9 8b e5 ff ff       	jmp    80104000 <wait>
80105a75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a7c:	00 
80105a7d:	8d 76 00             	lea    0x0(%esi),%esi

80105a80 <sys_kill>:
}

int sys_kill(void) {
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	83 ec 20             	sub    $0x20,%esp
    int pid;
    if(argint(0, &pid) < 0)
80105a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a89:	50                   	push   %eax
80105a8a:	6a 00                	push   $0x0
80105a8c:	e8 cf ef ff ff       	call   80104a60 <argint>
80105a91:	83 c4 10             	add    $0x10,%esp
80105a94:	85 c0                	test   %eax,%eax
80105a96:	78 18                	js     80105ab0 <sys_kill+0x30>
        return -1;
    return kill(pid);
80105a98:	83 ec 0c             	sub    $0xc,%esp
80105a9b:	ff 75 f4             	push   -0xc(%ebp)
80105a9e:	e8 fd e7 ff ff       	call   801042a0 <kill>
80105aa3:	83 c4 10             	add    $0x10,%esp
}
80105aa6:	c9                   	leave
80105aa7:	c3                   	ret
80105aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aaf:	00 
80105ab0:	c9                   	leave
        return -1;
80105ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab6:	c3                   	ret
80105ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105abe:	00 
80105abf:	90                   	nop

80105ac0 <sys_getpid>:

int sys_getpid(void) {
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80105ac6:	e8 75 df ff ff       	call   80103a40 <myproc>
80105acb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105ace:	c9                   	leave
80105acf:	c3                   	ret

80105ad0 <sys_sbrk>:
//     release(&ptable.lock);
    
//     return addr;
// }

int sys_sbrk(void) {
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	53                   	push   %ebx
80105ad4:	83 ec 14             	sub    $0x14,%esp
    int addr;
    int n;
    struct proc *curproc = myproc();
80105ad7:	e8 64 df ff ff       	call   80103a40 <myproc>

    if(argint(0, &n) < 0)
80105adc:	83 ec 08             	sub    $0x8,%esp
    struct proc *curproc = myproc();
80105adf:	89 c3                	mov    %eax,%ebx
    if(argint(0, &n) < 0)
80105ae1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae4:	50                   	push   %eax
80105ae5:	6a 00                	push   $0x0
80105ae7:	e8 74 ef ff ff       	call   80104a60 <argint>
80105aec:	83 c4 10             	add    $0x10,%esp
80105aef:	85 c0                	test   %eax,%eax
80105af1:	78 1d                	js     80105b10 <sys_sbrk+0x40>
        return -1;
    addr = curproc->sz;

    if(growproc(n) < 0)
80105af3:	83 ec 0c             	sub    $0xc,%esp
    addr = curproc->sz;
80105af6:	8b 1b                	mov    (%ebx),%ebx
    if(growproc(n) < 0)
80105af8:	ff 75 f4             	push   -0xc(%ebp)
80105afb:	e8 60 e0 ff ff       	call   80103b60 <growproc>
80105b00:	83 c4 10             	add    $0x10,%esp
80105b03:	85 c0                	test   %eax,%eax
80105b05:	78 09                	js     80105b10 <sys_sbrk+0x40>
        return -1;
    
    return addr;
}
80105b07:	89 d8                	mov    %ebx,%eax
80105b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b0c:	c9                   	leave
80105b0d:	c3                   	ret
80105b0e:	66 90                	xchg   %ax,%ax
        return -1;
80105b10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b15:	eb f0                	jmp    80105b07 <sys_sbrk+0x37>
80105b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b1e:	00 
80105b1f:	90                   	nop

80105b20 <sys_sleep>:

//     return addr;
// }


int sys_sleep(void) {
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
    int n;
    uint ticks0;
    if(argint(0, &n) < 0)
80105b24:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80105b27:	83 ec 1c             	sub    $0x1c,%esp
    if(argint(0, &n) < 0)
80105b2a:	50                   	push   %eax
80105b2b:	6a 00                	push   $0x0
80105b2d:	e8 2e ef ff ff       	call   80104a60 <argint>
80105b32:	83 c4 10             	add    $0x10,%esp
80105b35:	85 c0                	test   %eax,%eax
80105b37:	0f 88 8a 00 00 00    	js     80105bc7 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
80105b3d:	83 ec 0c             	sub    $0xc,%esp
80105b40:	68 40 57 11 80       	push   $0x80115740
80105b45:	e8 96 eb ff ff       	call   801046e0 <acquire>
    ticks0 = ticks;
    while(ticks - ticks0 < n) {
80105b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    ticks0 = ticks;
80105b4d:	8b 1d 20 57 11 80    	mov    0x80115720,%ebx
    while(ticks - ticks0 < n) {
80105b53:	83 c4 10             	add    $0x10,%esp
80105b56:	85 d2                	test   %edx,%edx
80105b58:	75 27                	jne    80105b81 <sys_sleep+0x61>
80105b5a:	eb 54                	jmp    80105bb0 <sys_sleep+0x90>
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105b60:	83 ec 08             	sub    $0x8,%esp
80105b63:	68 40 57 11 80       	push   $0x80115740
80105b68:	68 20 57 11 80       	push   $0x80115720
80105b6d:	e8 0e e6 ff ff       	call   80104180 <sleep>
    while(ticks - ticks0 < n) {
80105b72:	a1 20 57 11 80       	mov    0x80115720,%eax
80105b77:	83 c4 10             	add    $0x10,%esp
80105b7a:	29 d8                	sub    %ebx,%eax
80105b7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b7f:	73 2f                	jae    80105bb0 <sys_sleep+0x90>
        if(myproc()->killed) {
80105b81:	e8 ba de ff ff       	call   80103a40 <myproc>
80105b86:	8b 40 24             	mov    0x24(%eax),%eax
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	74 d3                	je     80105b60 <sys_sleep+0x40>
            release(&tickslock);
80105b8d:	83 ec 0c             	sub    $0xc,%esp
80105b90:	68 40 57 11 80       	push   $0x80115740
80105b95:	e8 e6 ea ff ff       	call   80104680 <release>
    }
    release(&tickslock);
    return 0;
}
80105b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return -1;
80105b9d:	83 c4 10             	add    $0x10,%esp
80105ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba5:	c9                   	leave
80105ba6:	c3                   	ret
80105ba7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bae:	00 
80105baf:	90                   	nop
    release(&tickslock);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	68 40 57 11 80       	push   $0x80115740
80105bb8:	e8 c3 ea ff ff       	call   80104680 <release>
    return 0;
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	31 c0                	xor    %eax,%eax
}
80105bc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc5:	c9                   	leave
80105bc6:	c3                   	ret
        return -1;
80105bc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bcc:	eb f4                	jmp    80105bc2 <sys_sleep+0xa2>
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	53                   	push   %ebx
80105bd4:	83 ec 10             	sub    $0x10,%esp
    uint xticks;
    acquire(&tickslock);
80105bd7:	68 40 57 11 80       	push   $0x80115740
80105bdc:	e8 ff ea ff ff       	call   801046e0 <acquire>
    xticks = ticks;
80105be1:	8b 1d 20 57 11 80    	mov    0x80115720,%ebx
    release(&tickslock);
80105be7:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80105bee:	e8 8d ea ff ff       	call   80104680 <release>
    return xticks;
}
80105bf3:	89 d8                	mov    %ebx,%eax
80105bf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bf8:	c9                   	leave
80105bf9:	c3                   	ret
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c00 <sys_gethistory>:

// System call to get process history
int sys_gethistory(void) {
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	57                   	push   %edi
80105c04:	56                   	push   %esi
    struct history_entry *hist_buf;
    int max_entries;

    // Get arguments from user space
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105c05:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_gethistory(void) {
80105c08:	53                   	push   %ebx
80105c09:	83 ec 30             	sub    $0x30,%esp
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105c0c:	6a 18                	push   $0x18
80105c0e:	50                   	push   %eax
80105c0f:	6a 00                	push   $0x0
80105c11:	e8 9a ee ff ff       	call   80104ab0 <argptr>
80105c16:	83 c4 10             	add    $0x10,%esp
80105c19:	85 c0                	test   %eax,%eax
80105c1b:	0f 88 dd 00 00 00    	js     80105cfe <sys_gethistory+0xfe>
        argint(1, &max_entries) < 0) {
80105c21:	83 ec 08             	sub    $0x8,%esp
80105c24:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c27:	50                   	push   %eax
80105c28:	6a 01                	push   $0x1
80105c2a:	e8 31 ee ff ff       	call   80104a60 <argint>
    if (argptr(0, (void*)&hist_buf, sizeof(*hist_buf)) < 0 ||
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	85 c0                	test   %eax,%eax
80105c34:	0f 88 c4 00 00 00    	js     80105cfe <sys_gethistory+0xfe>
        return -1;  // Invalid arguments
    }

    acquire(&ptable.lock);
80105c3a:	83 ec 0c             	sub    $0xc,%esp
80105c3d:	68 e0 2d 11 80       	push   $0x80112de0
80105c42:	e8 99 ea ff ff       	call   801046e0 <acquire>

    // Return only the most recent `max_entries` from history
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105c47:	a1 18 4d 11 80       	mov    0x80114d18,%eax
80105c4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105c4f:	39 d0                	cmp    %edx,%eax
80105c51:	89 d7                	mov    %edx,%edi
80105c53:	0f 4e f8             	cmovle %eax,%edi
    int start = (history_count < MAX_HISTORY) ? 0 : history_index;  // Start index
80105c56:	31 db                	xor    %ebx,%ebx
80105c58:	83 c4 10             	add    $0x10,%esp
80105c5b:	83 f8 63             	cmp    $0x63,%eax
80105c5e:	0f 4f 1d 14 4d 11 80 	cmovg  0x80114d14,%ebx
    int copy_count = (history_count < max_entries) ? history_count : max_entries;
80105c65:	89 7d d0             	mov    %edi,-0x30(%ebp)

    for (int i = 0; i < copy_count; i++) {
80105c68:	85 ff                	test   %edi,%edi
80105c6a:	7e 77                	jle    80105ce3 <sys_gethistory+0xe3>
80105c6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
        int index = (start + i) % MAX_HISTORY;
        hist_buf[i].pid = process_history[index].pid;
80105c6f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105c72:	31 f6                	xor    %esi,%esi
80105c74:	01 d8                	add    %ebx,%eax
80105c76:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        int index = (start + i) % MAX_HISTORY;
80105c80:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105c85:	83 ec 04             	sub    $0x4,%esp
        int index = (start + i) % MAX_HISTORY;
80105c88:	f7 eb                	imul   %ebx
80105c8a:	89 d8                	mov    %ebx,%eax
80105c8c:	c1 f8 1f             	sar    $0x1f,%eax
80105c8f:	c1 fa 05             	sar    $0x5,%edx
80105c92:	29 c2                	sub    %eax,%edx
80105c94:	6b c2 64             	imul   $0x64,%edx,%eax
80105c97:	89 da                	mov    %ebx,%edx
    for (int i = 0; i < copy_count; i++) {
80105c99:	83 c3 01             	add    $0x1,%ebx
        int index = (start + i) % MAX_HISTORY;
80105c9c:	29 c2                	sub    %eax,%edx
        hist_buf[i].pid = process_history[index].pid;
80105c9e:	8d 14 52             	lea    (%edx,%edx,2),%edx
80105ca1:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80105ca8:	8b 14 d5 20 4d 11 80 	mov    -0x7feeb2e0(,%edx,8),%edx
80105caf:	8d b8 20 4d 11 80    	lea    -0x7feeb2e0(%eax),%edi
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105cb5:	05 24 4d 11 80       	add    $0x80114d24,%eax
        hist_buf[i].pid = process_history[index].pid;
80105cba:	89 14 31             	mov    %edx,(%ecx,%esi,1)
        safestrcpy(hist_buf[i].name, process_history[index].name, CMD_NAME_MAX); // Ensure name copy
80105cbd:	6a 10                	push   $0x10
80105cbf:	50                   	push   %eax
80105cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cc3:	01 f0                	add    %esi,%eax
80105cc5:	83 c0 04             	add    $0x4,%eax
80105cc8:	50                   	push   %eax
80105cc9:	e8 92 ec ff ff       	call   80104960 <safestrcpy>
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105cce:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105cd1:	8b 47 14             	mov    0x14(%edi),%eax
    for (int i = 0; i < copy_count; i++) {
80105cd4:	83 c4 10             	add    $0x10,%esp
        hist_buf[i].mem_usage = process_history[index].mem_usage;
80105cd7:	89 44 31 14          	mov    %eax,0x14(%ecx,%esi,1)
    for (int i = 0; i < copy_count; i++) {
80105cdb:	83 c6 18             	add    $0x18,%esi
80105cde:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
80105ce1:	75 9d                	jne    80105c80 <sys_gethistory+0x80>
    }

    release(&ptable.lock);
80105ce3:	83 ec 0c             	sub    $0xc,%esp
80105ce6:	68 e0 2d 11 80       	push   $0x80112de0
80105ceb:	e8 90 e9 ff ff       	call   80104680 <release>
    return copy_count;  // Return number of processes copied
80105cf0:	83 c4 10             	add    $0x10,%esp
}
80105cf3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf9:	5b                   	pop    %ebx
80105cfa:	5e                   	pop    %esi
80105cfb:	5f                   	pop    %edi
80105cfc:	5d                   	pop    %ebp
80105cfd:	c3                   	ret
        return -1;  // Invalid arguments
80105cfe:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
80105d05:	eb ec                	jmp    80105cf3 <sys_gethistory+0xf3>
80105d07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d0e:	00 
80105d0f:	90                   	nop

80105d10 <sys_block>:
//         return 0;
//     }

//     return -1;
// }
int sys_block(void) {
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 20             	sub    $0x20,%esp
    int syscall_id;
    if (argint(0, &syscall_id) < 0) 
80105d16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d19:	50                   	push   %eax
80105d1a:	6a 00                	push   $0x0
80105d1c:	e8 3f ed ff ff       	call   80104a60 <argint>
80105d21:	83 c4 10             	add    $0x10,%esp
80105d24:	85 c0                	test   %eax,%eax
80105d26:	78 28                	js     80105d50 <sys_block+0x40>
        return -1;
    
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2b:	83 f8 19             	cmp    $0x19,%eax
80105d2e:	77 20                	ja     80105d50 <sys_block+0x40>
        return -1;

    // Prevent blocking critical system calls
    if (syscall_id == SYS_fork || syscall_id == SYS_exit || syscall_id == SYS_unblock) {
80105d30:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d33:	83 fa 01             	cmp    $0x1,%edx
80105d36:	76 18                	jbe    80105d50 <sys_block+0x40>
80105d38:	83 f8 18             	cmp    $0x18,%eax
80105d3b:	74 13                	je     80105d50 <sys_block+0x40>
        return -1;
    }

    blocked_syscalls[syscall_id] = 1;  // Store in the kernel
80105d3d:	c7 04 85 a0 56 11 80 	movl   $0x1,-0x7feea960(,%eax,4)
80105d44:	01 00 00 00 
    return 0;
80105d48:	31 c0                	xor    %eax,%eax
}
80105d4a:	c9                   	leave
80105d4b:	c3                   	ret
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d50:	c9                   	leave
        return -1;
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d56:	c3                   	ret
80105d57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d5e:	00 
80105d5f:	90                   	nop

80105d60 <sys_unblock>:
//     }

//     release(&ptable.lock);
//     return 0;
// }
int sys_unblock(void) {
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 20             	sub    $0x20,%esp
    int syscall_id;

    // Get the syscall ID from arguments
    if (argint(0, &syscall_id) < 0) 
80105d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d69:	50                   	push   %eax
80105d6a:	6a 00                	push   $0x0
80105d6c:	e8 ef ec ff ff       	call   80104a60 <argint>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	78 18                	js     80105d90 <sys_unblock+0x30>
        return -1;

    // Validate syscall ID range
    if (syscall_id < 0 || syscall_id >= MAX_SYSCALLS) 
80105d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d7b:	83 f8 19             	cmp    $0x19,%eax
80105d7e:	77 10                	ja     80105d90 <sys_unblock+0x30>
        return -1;

    // Unblock the specified syscall
    blocked_syscalls[syscall_id] = 0;
80105d80:	c7 04 85 a0 56 11 80 	movl   $0x0,-0x7feea960(,%eax,4)
80105d87:	00 00 00 00 

    return 0;
80105d8b:	31 c0                	xor    %eax,%eax
}
80105d8d:	c9                   	leave
80105d8e:	c3                   	ret
80105d8f:	90                   	nop
80105d90:	c9                   	leave
        return -1;
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d96:	c3                   	ret

80105d97 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d97:	1e                   	push   %ds
  pushl %es
80105d98:	06                   	push   %es
  pushl %fs
80105d99:	0f a0                	push   %fs
  pushl %gs
80105d9b:	0f a8                	push   %gs
  pushal
80105d9d:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d9e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105da2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105da4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105da6:	54                   	push   %esp
  call trap
80105da7:	e8 c4 00 00 00       	call   80105e70 <trap>
  addl $4, %esp
80105dac:	83 c4 04             	add    $0x4,%esp

80105daf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105daf:	61                   	popa
  popl %gs
80105db0:	0f a9                	pop    %gs
  popl %fs
80105db2:	0f a1                	pop    %fs
  popl %es
80105db4:	07                   	pop    %es
  popl %ds
80105db5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105db6:	83 c4 08             	add    $0x8,%esp
  iret
80105db9:	cf                   	iret
80105dba:	66 90                	xchg   %ax,%ax
80105dbc:	66 90                	xchg   %ax,%ax
80105dbe:	66 90                	xchg   %ax,%ax

80105dc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105dc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105dc1:	31 c0                	xor    %eax,%eax
{
80105dc3:	89 e5                	mov    %esp,%ebp
80105dc5:	83 ec 08             	sub    $0x8,%esp
80105dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dcf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105dd0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105dd7:	c7 04 c5 82 57 11 80 	movl   $0x8e000008,-0x7feea87e(,%eax,8)
80105dde:	08 00 00 8e 
80105de2:	66 89 14 c5 80 57 11 	mov    %dx,-0x7feea880(,%eax,8)
80105de9:	80 
80105dea:	c1 ea 10             	shr    $0x10,%edx
80105ded:	66 89 14 c5 86 57 11 	mov    %dx,-0x7feea87a(,%eax,8)
80105df4:	80 
  for(i = 0; i < 256; i++)
80105df5:	83 c0 01             	add    $0x1,%eax
80105df8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105dfd:	75 d1                	jne    80105dd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105dff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e02:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80105e07:	c7 05 82 59 11 80 08 	movl   $0xef000008,0x80115982
80105e0e:	00 00 ef 
  initlock(&tickslock, "time");
80105e11:	68 6d 7b 10 80       	push   $0x80107b6d
80105e16:	68 40 57 11 80       	push   $0x80115740
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e1b:	66 a3 80 59 11 80    	mov    %ax,0x80115980
80105e21:	c1 e8 10             	shr    $0x10,%eax
80105e24:	66 a3 86 59 11 80    	mov    %ax,0x80115986
  initlock(&tickslock, "time");
80105e2a:	e8 e1 e6 ff ff       	call   80104510 <initlock>
}
80105e2f:	83 c4 10             	add    $0x10,%esp
80105e32:	c9                   	leave
80105e33:	c3                   	ret
80105e34:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e3b:	00 
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e40 <idtinit>:

void
idtinit(void)
{
80105e40:	55                   	push   %ebp
  pd[0] = size-1;
80105e41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e46:	89 e5                	mov    %esp,%ebp
80105e48:	83 ec 10             	sub    $0x10,%esp
80105e4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e4f:	b8 80 57 11 80       	mov    $0x80115780,%eax
80105e54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e58:	c1 e8 10             	shr    $0x10,%eax
80105e5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e65:	c9                   	leave
80105e66:	c3                   	ret
80105e67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e6e:	00 
80105e6f:	90                   	nop

80105e70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	57                   	push   %edi
80105e74:	56                   	push   %esi
80105e75:	53                   	push   %ebx
80105e76:	83 ec 1c             	sub    $0x1c,%esp
80105e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e7c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e7f:	83 f8 40             	cmp    $0x40,%eax
80105e82:	0f 84 68 01 00 00    	je     80105ff0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e88:	83 e8 20             	sub    $0x20,%eax
80105e8b:	83 f8 1f             	cmp    $0x1f,%eax
80105e8e:	0f 87 8c 00 00 00    	ja     80105f20 <trap+0xb0>
80105e94:	ff 24 85 e8 80 10 80 	jmp    *-0x7fef7f18(,%eax,4)
80105e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ea0:	e8 ab c3 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105ea5:	e8 76 ca ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eaa:	e8 91 db ff ff       	call   80103a40 <myproc>
80105eaf:	85 c0                	test   %eax,%eax
80105eb1:	74 1d                	je     80105ed0 <trap+0x60>
80105eb3:	e8 88 db ff ff       	call   80103a40 <myproc>
80105eb8:	8b 50 24             	mov    0x24(%eax),%edx
80105ebb:	85 d2                	test   %edx,%edx
80105ebd:	74 11                	je     80105ed0 <trap+0x60>
80105ebf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ec3:	83 e0 03             	and    $0x3,%eax
80105ec6:	66 83 f8 03          	cmp    $0x3,%ax
80105eca:	0f 84 e8 01 00 00    	je     801060b8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ed0:	e8 6b db ff ff       	call   80103a40 <myproc>
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	74 0f                	je     80105ee8 <trap+0x78>
80105ed9:	e8 62 db ff ff       	call   80103a40 <myproc>
80105ede:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ee2:	0f 84 b8 00 00 00    	je     80105fa0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ee8:	e8 53 db ff ff       	call   80103a40 <myproc>
80105eed:	85 c0                	test   %eax,%eax
80105eef:	74 1d                	je     80105f0e <trap+0x9e>
80105ef1:	e8 4a db ff ff       	call   80103a40 <myproc>
80105ef6:	8b 40 24             	mov    0x24(%eax),%eax
80105ef9:	85 c0                	test   %eax,%eax
80105efb:	74 11                	je     80105f0e <trap+0x9e>
80105efd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f01:	83 e0 03             	and    $0x3,%eax
80105f04:	66 83 f8 03          	cmp    $0x3,%ax
80105f08:	0f 84 0f 01 00 00    	je     8010601d <trap+0x1ad>
    exit();
}
80105f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f11:	5b                   	pop    %ebx
80105f12:	5e                   	pop    %esi
80105f13:	5f                   	pop    %edi
80105f14:	5d                   	pop    %ebp
80105f15:	c3                   	ret
80105f16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f1d:	00 
80105f1e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f20:	e8 1b db ff ff       	call   80103a40 <myproc>
80105f25:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f28:	85 c0                	test   %eax,%eax
80105f2a:	0f 84 a2 01 00 00    	je     801060d2 <trap+0x262>
80105f30:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f34:	0f 84 98 01 00 00    	je     801060d2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f3a:	0f 20 d1             	mov    %cr2,%ecx
80105f3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f40:	e8 db da ff ff       	call   80103a20 <cpuid>
80105f45:	8b 73 30             	mov    0x30(%ebx),%esi
80105f48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f4b:	8b 43 34             	mov    0x34(%ebx),%eax
80105f4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105f51:	e8 ea da ff ff       	call   80103a40 <myproc>
80105f56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f59:	e8 e2 da ff ff       	call   80103a40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f64:	51                   	push   %ecx
80105f65:	57                   	push   %edi
80105f66:	52                   	push   %edx
80105f67:	ff 75 e4             	push   -0x1c(%ebp)
80105f6a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f6b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105f6e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f71:	56                   	push   %esi
80105f72:	ff 70 10             	push   0x10(%eax)
80105f75:	68 bc 7d 10 80       	push   $0x80107dbc
80105f7a:	e8 21 a7 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105f7f:	83 c4 20             	add    $0x20,%esp
80105f82:	e8 b9 da ff ff       	call   80103a40 <myproc>
80105f87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f8e:	e8 ad da ff ff       	call   80103a40 <myproc>
80105f93:	85 c0                	test   %eax,%eax
80105f95:	0f 85 18 ff ff ff    	jne    80105eb3 <trap+0x43>
80105f9b:	e9 30 ff ff ff       	jmp    80105ed0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105fa0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105fa4:	0f 85 3e ff ff ff    	jne    80105ee8 <trap+0x78>
    yield();
80105faa:	e8 81 e1 ff ff       	call   80104130 <yield>
80105faf:	e9 34 ff ff ff       	jmp    80105ee8 <trap+0x78>
80105fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fb8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105fbb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105fbf:	e8 5c da ff ff       	call   80103a20 <cpuid>
80105fc4:	57                   	push   %edi
80105fc5:	56                   	push   %esi
80105fc6:	50                   	push   %eax
80105fc7:	68 64 7d 10 80       	push   $0x80107d64
80105fcc:	e8 cf a6 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105fd1:	e8 4a c9 ff ff       	call   80102920 <lapiceoi>
    break;
80105fd6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fd9:	e8 62 da ff ff       	call   80103a40 <myproc>
80105fde:	85 c0                	test   %eax,%eax
80105fe0:	0f 85 cd fe ff ff    	jne    80105eb3 <trap+0x43>
80105fe6:	e9 e5 fe ff ff       	jmp    80105ed0 <trap+0x60>
80105feb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ff0:	e8 4b da ff ff       	call   80103a40 <myproc>
80105ff5:	8b 70 24             	mov    0x24(%eax),%esi
80105ff8:	85 f6                	test   %esi,%esi
80105ffa:	0f 85 c8 00 00 00    	jne    801060c8 <trap+0x258>
    myproc()->tf = tf;
80106000:	e8 3b da ff ff       	call   80103a40 <myproc>
80106005:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106008:	e8 f3 eb ff ff       	call   80104c00 <syscall>
    if(myproc()->killed)
8010600d:	e8 2e da ff ff       	call   80103a40 <myproc>
80106012:	8b 48 24             	mov    0x24(%eax),%ecx
80106015:	85 c9                	test   %ecx,%ecx
80106017:	0f 84 f1 fe ff ff    	je     80105f0e <trap+0x9e>
}
8010601d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106020:	5b                   	pop    %ebx
80106021:	5e                   	pop    %esi
80106022:	5f                   	pop    %edi
80106023:	5d                   	pop    %ebp
      exit();
80106024:	e9 37 de ff ff       	jmp    80103e60 <exit>
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106030:	e8 3b 02 00 00       	call   80106270 <uartintr>
    lapiceoi();
80106035:	e8 e6 c8 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010603a:	e8 01 da ff ff       	call   80103a40 <myproc>
8010603f:	85 c0                	test   %eax,%eax
80106041:	0f 85 6c fe ff ff    	jne    80105eb3 <trap+0x43>
80106047:	e9 84 fe ff ff       	jmp    80105ed0 <trap+0x60>
8010604c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106050:	e8 8b c7 ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80106055:	e8 c6 c8 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010605a:	e8 e1 d9 ff ff       	call   80103a40 <myproc>
8010605f:	85 c0                	test   %eax,%eax
80106061:	0f 85 4c fe ff ff    	jne    80105eb3 <trap+0x43>
80106067:	e9 64 fe ff ff       	jmp    80105ed0 <trap+0x60>
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106070:	e8 ab d9 ff ff       	call   80103a20 <cpuid>
80106075:	85 c0                	test   %eax,%eax
80106077:	0f 85 28 fe ff ff    	jne    80105ea5 <trap+0x35>
      acquire(&tickslock);
8010607d:	83 ec 0c             	sub    $0xc,%esp
80106080:	68 40 57 11 80       	push   $0x80115740
80106085:	e8 56 e6 ff ff       	call   801046e0 <acquire>
      wakeup(&ticks);
8010608a:	c7 04 24 20 57 11 80 	movl   $0x80115720,(%esp)
      ticks++;
80106091:	83 05 20 57 11 80 01 	addl   $0x1,0x80115720
      wakeup(&ticks);
80106098:	e8 a3 e1 ff ff       	call   80104240 <wakeup>
      release(&tickslock);
8010609d:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801060a4:	e8 d7 e5 ff ff       	call   80104680 <release>
801060a9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801060ac:	e9 f4 fd ff ff       	jmp    80105ea5 <trap+0x35>
801060b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801060b8:	e8 a3 dd ff ff       	call   80103e60 <exit>
801060bd:	e9 0e fe ff ff       	jmp    80105ed0 <trap+0x60>
801060c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801060c8:	e8 93 dd ff ff       	call   80103e60 <exit>
801060cd:	e9 2e ff ff ff       	jmp    80106000 <trap+0x190>
801060d2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060d5:	e8 46 d9 ff ff       	call   80103a20 <cpuid>
801060da:	83 ec 0c             	sub    $0xc,%esp
801060dd:	56                   	push   %esi
801060de:	57                   	push   %edi
801060df:	50                   	push   %eax
801060e0:	ff 73 30             	push   0x30(%ebx)
801060e3:	68 88 7d 10 80       	push   $0x80107d88
801060e8:	e8 b3 a5 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801060ed:	83 c4 14             	add    $0x14,%esp
801060f0:	68 72 7b 10 80       	push   $0x80107b72
801060f5:	e8 86 a2 ff ff       	call   80100380 <panic>
801060fa:	66 90                	xchg   %ax,%ax
801060fc:	66 90                	xchg   %ax,%ax
801060fe:	66 90                	xchg   %ax,%ax

80106100 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106100:	a1 80 5f 11 80       	mov    0x80115f80,%eax
80106105:	85 c0                	test   %eax,%eax
80106107:	74 17                	je     80106120 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106109:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010610e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010610f:	a8 01                	test   $0x1,%al
80106111:	74 0d                	je     80106120 <uartgetc+0x20>
80106113:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106118:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106119:	0f b6 c0             	movzbl %al,%eax
8010611c:	c3                   	ret
8010611d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106125:	c3                   	ret
80106126:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010612d:	00 
8010612e:	66 90                	xchg   %ax,%ax

80106130 <uartinit>:
{
80106130:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106131:	31 c9                	xor    %ecx,%ecx
80106133:	89 c8                	mov    %ecx,%eax
80106135:	89 e5                	mov    %esp,%ebp
80106137:	57                   	push   %edi
80106138:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010613d:	56                   	push   %esi
8010613e:	89 fa                	mov    %edi,%edx
80106140:	53                   	push   %ebx
80106141:	83 ec 1c             	sub    $0x1c,%esp
80106144:	ee                   	out    %al,(%dx)
80106145:	be fb 03 00 00       	mov    $0x3fb,%esi
8010614a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010614f:	89 f2                	mov    %esi,%edx
80106151:	ee                   	out    %al,(%dx)
80106152:	b8 0c 00 00 00       	mov    $0xc,%eax
80106157:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010615c:	ee                   	out    %al,(%dx)
8010615d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106162:	89 c8                	mov    %ecx,%eax
80106164:	89 da                	mov    %ebx,%edx
80106166:	ee                   	out    %al,(%dx)
80106167:	b8 03 00 00 00       	mov    $0x3,%eax
8010616c:	89 f2                	mov    %esi,%edx
8010616e:	ee                   	out    %al,(%dx)
8010616f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106174:	89 c8                	mov    %ecx,%eax
80106176:	ee                   	out    %al,(%dx)
80106177:	b8 01 00 00 00       	mov    $0x1,%eax
8010617c:	89 da                	mov    %ebx,%edx
8010617e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010617f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106184:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106185:	3c ff                	cmp    $0xff,%al
80106187:	74 78                	je     80106201 <uartinit+0xd1>
  uart = 1;
80106189:	c7 05 80 5f 11 80 01 	movl   $0x1,0x80115f80
80106190:	00 00 00 
80106193:	89 fa                	mov    %edi,%edx
80106195:	ec                   	in     (%dx),%al
80106196:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010619b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010619c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010619f:	bf 77 7b 10 80       	mov    $0x80107b77,%edi
801061a4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801061a9:	6a 00                	push   $0x0
801061ab:	6a 04                	push   $0x4
801061ad:	e8 de c2 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801061b2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801061b6:	83 c4 10             	add    $0x10,%esp
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801061c0:	a1 80 5f 11 80       	mov    0x80115f80,%eax
801061c5:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ca:	85 c0                	test   %eax,%eax
801061cc:	75 14                	jne    801061e2 <uartinit+0xb2>
801061ce:	eb 23                	jmp    801061f3 <uartinit+0xc3>
    microdelay(10);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	6a 0a                	push   $0xa
801061d5:	e8 66 c7 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061da:	83 c4 10             	add    $0x10,%esp
801061dd:	83 eb 01             	sub    $0x1,%ebx
801061e0:	74 07                	je     801061e9 <uartinit+0xb9>
801061e2:	89 f2                	mov    %esi,%edx
801061e4:	ec                   	in     (%dx),%al
801061e5:	a8 20                	test   $0x20,%al
801061e7:	74 e7                	je     801061d0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061e9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801061ed:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061f2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801061f3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801061f7:	83 c7 01             	add    $0x1,%edi
801061fa:	88 45 e7             	mov    %al,-0x19(%ebp)
801061fd:	84 c0                	test   %al,%al
801061ff:	75 bf                	jne    801061c0 <uartinit+0x90>
}
80106201:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106204:	5b                   	pop    %ebx
80106205:	5e                   	pop    %esi
80106206:	5f                   	pop    %edi
80106207:	5d                   	pop    %ebp
80106208:	c3                   	ret
80106209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106210 <uartputc>:
  if(!uart)
80106210:	a1 80 5f 11 80       	mov    0x80115f80,%eax
80106215:	85 c0                	test   %eax,%eax
80106217:	74 47                	je     80106260 <uartputc+0x50>
{
80106219:	55                   	push   %ebp
8010621a:	89 e5                	mov    %esp,%ebp
8010621c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010621d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106222:	53                   	push   %ebx
80106223:	bb 80 00 00 00       	mov    $0x80,%ebx
80106228:	eb 18                	jmp    80106242 <uartputc+0x32>
8010622a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106230:	83 ec 0c             	sub    $0xc,%esp
80106233:	6a 0a                	push   $0xa
80106235:	e8 06 c7 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010623a:	83 c4 10             	add    $0x10,%esp
8010623d:	83 eb 01             	sub    $0x1,%ebx
80106240:	74 07                	je     80106249 <uartputc+0x39>
80106242:	89 f2                	mov    %esi,%edx
80106244:	ec                   	in     (%dx),%al
80106245:	a8 20                	test   $0x20,%al
80106247:	74 e7                	je     80106230 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106249:	8b 45 08             	mov    0x8(%ebp),%eax
8010624c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106251:	ee                   	out    %al,(%dx)
}
80106252:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106255:	5b                   	pop    %ebx
80106256:	5e                   	pop    %esi
80106257:	5d                   	pop    %ebp
80106258:	c3                   	ret
80106259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106260:	c3                   	ret
80106261:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106268:	00 
80106269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106270 <uartintr>:

void
uartintr(void)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106276:	68 00 61 10 80       	push   $0x80106100
8010627b:	e8 00 a6 ff ff       	call   80100880 <consoleintr>
}
80106280:	83 c4 10             	add    $0x10,%esp
80106283:	c9                   	leave
80106284:	c3                   	ret

80106285 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $0
80106287:	6a 00                	push   $0x0
  jmp alltraps
80106289:	e9 09 fb ff ff       	jmp    80105d97 <alltraps>

8010628e <vector1>:
.globl vector1
vector1:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $1
80106290:	6a 01                	push   $0x1
  jmp alltraps
80106292:	e9 00 fb ff ff       	jmp    80105d97 <alltraps>

80106297 <vector2>:
.globl vector2
vector2:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $2
80106299:	6a 02                	push   $0x2
  jmp alltraps
8010629b:	e9 f7 fa ff ff       	jmp    80105d97 <alltraps>

801062a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $3
801062a2:	6a 03                	push   $0x3
  jmp alltraps
801062a4:	e9 ee fa ff ff       	jmp    80105d97 <alltraps>

801062a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $4
801062ab:	6a 04                	push   $0x4
  jmp alltraps
801062ad:	e9 e5 fa ff ff       	jmp    80105d97 <alltraps>

801062b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $5
801062b4:	6a 05                	push   $0x5
  jmp alltraps
801062b6:	e9 dc fa ff ff       	jmp    80105d97 <alltraps>

801062bb <vector6>:
.globl vector6
vector6:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $6
801062bd:	6a 06                	push   $0x6
  jmp alltraps
801062bf:	e9 d3 fa ff ff       	jmp    80105d97 <alltraps>

801062c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $7
801062c6:	6a 07                	push   $0x7
  jmp alltraps
801062c8:	e9 ca fa ff ff       	jmp    80105d97 <alltraps>

801062cd <vector8>:
.globl vector8
vector8:
  pushl $8
801062cd:	6a 08                	push   $0x8
  jmp alltraps
801062cf:	e9 c3 fa ff ff       	jmp    80105d97 <alltraps>

801062d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $9
801062d6:	6a 09                	push   $0x9
  jmp alltraps
801062d8:	e9 ba fa ff ff       	jmp    80105d97 <alltraps>

801062dd <vector10>:
.globl vector10
vector10:
  pushl $10
801062dd:	6a 0a                	push   $0xa
  jmp alltraps
801062df:	e9 b3 fa ff ff       	jmp    80105d97 <alltraps>

801062e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062e4:	6a 0b                	push   $0xb
  jmp alltraps
801062e6:	e9 ac fa ff ff       	jmp    80105d97 <alltraps>

801062eb <vector12>:
.globl vector12
vector12:
  pushl $12
801062eb:	6a 0c                	push   $0xc
  jmp alltraps
801062ed:	e9 a5 fa ff ff       	jmp    80105d97 <alltraps>

801062f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062f2:	6a 0d                	push   $0xd
  jmp alltraps
801062f4:	e9 9e fa ff ff       	jmp    80105d97 <alltraps>

801062f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062f9:	6a 0e                	push   $0xe
  jmp alltraps
801062fb:	e9 97 fa ff ff       	jmp    80105d97 <alltraps>

80106300 <vector15>:
.globl vector15
vector15:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $15
80106302:	6a 0f                	push   $0xf
  jmp alltraps
80106304:	e9 8e fa ff ff       	jmp    80105d97 <alltraps>

80106309 <vector16>:
.globl vector16
vector16:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $16
8010630b:	6a 10                	push   $0x10
  jmp alltraps
8010630d:	e9 85 fa ff ff       	jmp    80105d97 <alltraps>

80106312 <vector17>:
.globl vector17
vector17:
  pushl $17
80106312:	6a 11                	push   $0x11
  jmp alltraps
80106314:	e9 7e fa ff ff       	jmp    80105d97 <alltraps>

80106319 <vector18>:
.globl vector18
vector18:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $18
8010631b:	6a 12                	push   $0x12
  jmp alltraps
8010631d:	e9 75 fa ff ff       	jmp    80105d97 <alltraps>

80106322 <vector19>:
.globl vector19
vector19:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $19
80106324:	6a 13                	push   $0x13
  jmp alltraps
80106326:	e9 6c fa ff ff       	jmp    80105d97 <alltraps>

8010632b <vector20>:
.globl vector20
vector20:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $20
8010632d:	6a 14                	push   $0x14
  jmp alltraps
8010632f:	e9 63 fa ff ff       	jmp    80105d97 <alltraps>

80106334 <vector21>:
.globl vector21
vector21:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $21
80106336:	6a 15                	push   $0x15
  jmp alltraps
80106338:	e9 5a fa ff ff       	jmp    80105d97 <alltraps>

8010633d <vector22>:
.globl vector22
vector22:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $22
8010633f:	6a 16                	push   $0x16
  jmp alltraps
80106341:	e9 51 fa ff ff       	jmp    80105d97 <alltraps>

80106346 <vector23>:
.globl vector23
vector23:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $23
80106348:	6a 17                	push   $0x17
  jmp alltraps
8010634a:	e9 48 fa ff ff       	jmp    80105d97 <alltraps>

8010634f <vector24>:
.globl vector24
vector24:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $24
80106351:	6a 18                	push   $0x18
  jmp alltraps
80106353:	e9 3f fa ff ff       	jmp    80105d97 <alltraps>

80106358 <vector25>:
.globl vector25
vector25:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $25
8010635a:	6a 19                	push   $0x19
  jmp alltraps
8010635c:	e9 36 fa ff ff       	jmp    80105d97 <alltraps>

80106361 <vector26>:
.globl vector26
vector26:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $26
80106363:	6a 1a                	push   $0x1a
  jmp alltraps
80106365:	e9 2d fa ff ff       	jmp    80105d97 <alltraps>

8010636a <vector27>:
.globl vector27
vector27:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $27
8010636c:	6a 1b                	push   $0x1b
  jmp alltraps
8010636e:	e9 24 fa ff ff       	jmp    80105d97 <alltraps>

80106373 <vector28>:
.globl vector28
vector28:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $28
80106375:	6a 1c                	push   $0x1c
  jmp alltraps
80106377:	e9 1b fa ff ff       	jmp    80105d97 <alltraps>

8010637c <vector29>:
.globl vector29
vector29:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $29
8010637e:	6a 1d                	push   $0x1d
  jmp alltraps
80106380:	e9 12 fa ff ff       	jmp    80105d97 <alltraps>

80106385 <vector30>:
.globl vector30
vector30:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $30
80106387:	6a 1e                	push   $0x1e
  jmp alltraps
80106389:	e9 09 fa ff ff       	jmp    80105d97 <alltraps>

8010638e <vector31>:
.globl vector31
vector31:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $31
80106390:	6a 1f                	push   $0x1f
  jmp alltraps
80106392:	e9 00 fa ff ff       	jmp    80105d97 <alltraps>

80106397 <vector32>:
.globl vector32
vector32:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $32
80106399:	6a 20                	push   $0x20
  jmp alltraps
8010639b:	e9 f7 f9 ff ff       	jmp    80105d97 <alltraps>

801063a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $33
801063a2:	6a 21                	push   $0x21
  jmp alltraps
801063a4:	e9 ee f9 ff ff       	jmp    80105d97 <alltraps>

801063a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $34
801063ab:	6a 22                	push   $0x22
  jmp alltraps
801063ad:	e9 e5 f9 ff ff       	jmp    80105d97 <alltraps>

801063b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $35
801063b4:	6a 23                	push   $0x23
  jmp alltraps
801063b6:	e9 dc f9 ff ff       	jmp    80105d97 <alltraps>

801063bb <vector36>:
.globl vector36
vector36:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $36
801063bd:	6a 24                	push   $0x24
  jmp alltraps
801063bf:	e9 d3 f9 ff ff       	jmp    80105d97 <alltraps>

801063c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $37
801063c6:	6a 25                	push   $0x25
  jmp alltraps
801063c8:	e9 ca f9 ff ff       	jmp    80105d97 <alltraps>

801063cd <vector38>:
.globl vector38
vector38:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $38
801063cf:	6a 26                	push   $0x26
  jmp alltraps
801063d1:	e9 c1 f9 ff ff       	jmp    80105d97 <alltraps>

801063d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $39
801063d8:	6a 27                	push   $0x27
  jmp alltraps
801063da:	e9 b8 f9 ff ff       	jmp    80105d97 <alltraps>

801063df <vector40>:
.globl vector40
vector40:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $40
801063e1:	6a 28                	push   $0x28
  jmp alltraps
801063e3:	e9 af f9 ff ff       	jmp    80105d97 <alltraps>

801063e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $41
801063ea:	6a 29                	push   $0x29
  jmp alltraps
801063ec:	e9 a6 f9 ff ff       	jmp    80105d97 <alltraps>

801063f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $42
801063f3:	6a 2a                	push   $0x2a
  jmp alltraps
801063f5:	e9 9d f9 ff ff       	jmp    80105d97 <alltraps>

801063fa <vector43>:
.globl vector43
vector43:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $43
801063fc:	6a 2b                	push   $0x2b
  jmp alltraps
801063fe:	e9 94 f9 ff ff       	jmp    80105d97 <alltraps>

80106403 <vector44>:
.globl vector44
vector44:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $44
80106405:	6a 2c                	push   $0x2c
  jmp alltraps
80106407:	e9 8b f9 ff ff       	jmp    80105d97 <alltraps>

8010640c <vector45>:
.globl vector45
vector45:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $45
8010640e:	6a 2d                	push   $0x2d
  jmp alltraps
80106410:	e9 82 f9 ff ff       	jmp    80105d97 <alltraps>

80106415 <vector46>:
.globl vector46
vector46:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $46
80106417:	6a 2e                	push   $0x2e
  jmp alltraps
80106419:	e9 79 f9 ff ff       	jmp    80105d97 <alltraps>

8010641e <vector47>:
.globl vector47
vector47:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $47
80106420:	6a 2f                	push   $0x2f
  jmp alltraps
80106422:	e9 70 f9 ff ff       	jmp    80105d97 <alltraps>

80106427 <vector48>:
.globl vector48
vector48:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $48
80106429:	6a 30                	push   $0x30
  jmp alltraps
8010642b:	e9 67 f9 ff ff       	jmp    80105d97 <alltraps>

80106430 <vector49>:
.globl vector49
vector49:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $49
80106432:	6a 31                	push   $0x31
  jmp alltraps
80106434:	e9 5e f9 ff ff       	jmp    80105d97 <alltraps>

80106439 <vector50>:
.globl vector50
vector50:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $50
8010643b:	6a 32                	push   $0x32
  jmp alltraps
8010643d:	e9 55 f9 ff ff       	jmp    80105d97 <alltraps>

80106442 <vector51>:
.globl vector51
vector51:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $51
80106444:	6a 33                	push   $0x33
  jmp alltraps
80106446:	e9 4c f9 ff ff       	jmp    80105d97 <alltraps>

8010644b <vector52>:
.globl vector52
vector52:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $52
8010644d:	6a 34                	push   $0x34
  jmp alltraps
8010644f:	e9 43 f9 ff ff       	jmp    80105d97 <alltraps>

80106454 <vector53>:
.globl vector53
vector53:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $53
80106456:	6a 35                	push   $0x35
  jmp alltraps
80106458:	e9 3a f9 ff ff       	jmp    80105d97 <alltraps>

8010645d <vector54>:
.globl vector54
vector54:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $54
8010645f:	6a 36                	push   $0x36
  jmp alltraps
80106461:	e9 31 f9 ff ff       	jmp    80105d97 <alltraps>

80106466 <vector55>:
.globl vector55
vector55:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $55
80106468:	6a 37                	push   $0x37
  jmp alltraps
8010646a:	e9 28 f9 ff ff       	jmp    80105d97 <alltraps>

8010646f <vector56>:
.globl vector56
vector56:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $56
80106471:	6a 38                	push   $0x38
  jmp alltraps
80106473:	e9 1f f9 ff ff       	jmp    80105d97 <alltraps>

80106478 <vector57>:
.globl vector57
vector57:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $57
8010647a:	6a 39                	push   $0x39
  jmp alltraps
8010647c:	e9 16 f9 ff ff       	jmp    80105d97 <alltraps>

80106481 <vector58>:
.globl vector58
vector58:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $58
80106483:	6a 3a                	push   $0x3a
  jmp alltraps
80106485:	e9 0d f9 ff ff       	jmp    80105d97 <alltraps>

8010648a <vector59>:
.globl vector59
vector59:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $59
8010648c:	6a 3b                	push   $0x3b
  jmp alltraps
8010648e:	e9 04 f9 ff ff       	jmp    80105d97 <alltraps>

80106493 <vector60>:
.globl vector60
vector60:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $60
80106495:	6a 3c                	push   $0x3c
  jmp alltraps
80106497:	e9 fb f8 ff ff       	jmp    80105d97 <alltraps>

8010649c <vector61>:
.globl vector61
vector61:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $61
8010649e:	6a 3d                	push   $0x3d
  jmp alltraps
801064a0:	e9 f2 f8 ff ff       	jmp    80105d97 <alltraps>

801064a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $62
801064a7:	6a 3e                	push   $0x3e
  jmp alltraps
801064a9:	e9 e9 f8 ff ff       	jmp    80105d97 <alltraps>

801064ae <vector63>:
.globl vector63
vector63:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $63
801064b0:	6a 3f                	push   $0x3f
  jmp alltraps
801064b2:	e9 e0 f8 ff ff       	jmp    80105d97 <alltraps>

801064b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $64
801064b9:	6a 40                	push   $0x40
  jmp alltraps
801064bb:	e9 d7 f8 ff ff       	jmp    80105d97 <alltraps>

801064c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $65
801064c2:	6a 41                	push   $0x41
  jmp alltraps
801064c4:	e9 ce f8 ff ff       	jmp    80105d97 <alltraps>

801064c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $66
801064cb:	6a 42                	push   $0x42
  jmp alltraps
801064cd:	e9 c5 f8 ff ff       	jmp    80105d97 <alltraps>

801064d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $67
801064d4:	6a 43                	push   $0x43
  jmp alltraps
801064d6:	e9 bc f8 ff ff       	jmp    80105d97 <alltraps>

801064db <vector68>:
.globl vector68
vector68:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $68
801064dd:	6a 44                	push   $0x44
  jmp alltraps
801064df:	e9 b3 f8 ff ff       	jmp    80105d97 <alltraps>

801064e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $69
801064e6:	6a 45                	push   $0x45
  jmp alltraps
801064e8:	e9 aa f8 ff ff       	jmp    80105d97 <alltraps>

801064ed <vector70>:
.globl vector70
vector70:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $70
801064ef:	6a 46                	push   $0x46
  jmp alltraps
801064f1:	e9 a1 f8 ff ff       	jmp    80105d97 <alltraps>

801064f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $71
801064f8:	6a 47                	push   $0x47
  jmp alltraps
801064fa:	e9 98 f8 ff ff       	jmp    80105d97 <alltraps>

801064ff <vector72>:
.globl vector72
vector72:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $72
80106501:	6a 48                	push   $0x48
  jmp alltraps
80106503:	e9 8f f8 ff ff       	jmp    80105d97 <alltraps>

80106508 <vector73>:
.globl vector73
vector73:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $73
8010650a:	6a 49                	push   $0x49
  jmp alltraps
8010650c:	e9 86 f8 ff ff       	jmp    80105d97 <alltraps>

80106511 <vector74>:
.globl vector74
vector74:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $74
80106513:	6a 4a                	push   $0x4a
  jmp alltraps
80106515:	e9 7d f8 ff ff       	jmp    80105d97 <alltraps>

8010651a <vector75>:
.globl vector75
vector75:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $75
8010651c:	6a 4b                	push   $0x4b
  jmp alltraps
8010651e:	e9 74 f8 ff ff       	jmp    80105d97 <alltraps>

80106523 <vector76>:
.globl vector76
vector76:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $76
80106525:	6a 4c                	push   $0x4c
  jmp alltraps
80106527:	e9 6b f8 ff ff       	jmp    80105d97 <alltraps>

8010652c <vector77>:
.globl vector77
vector77:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $77
8010652e:	6a 4d                	push   $0x4d
  jmp alltraps
80106530:	e9 62 f8 ff ff       	jmp    80105d97 <alltraps>

80106535 <vector78>:
.globl vector78
vector78:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $78
80106537:	6a 4e                	push   $0x4e
  jmp alltraps
80106539:	e9 59 f8 ff ff       	jmp    80105d97 <alltraps>

8010653e <vector79>:
.globl vector79
vector79:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $79
80106540:	6a 4f                	push   $0x4f
  jmp alltraps
80106542:	e9 50 f8 ff ff       	jmp    80105d97 <alltraps>

80106547 <vector80>:
.globl vector80
vector80:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $80
80106549:	6a 50                	push   $0x50
  jmp alltraps
8010654b:	e9 47 f8 ff ff       	jmp    80105d97 <alltraps>

80106550 <vector81>:
.globl vector81
vector81:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $81
80106552:	6a 51                	push   $0x51
  jmp alltraps
80106554:	e9 3e f8 ff ff       	jmp    80105d97 <alltraps>

80106559 <vector82>:
.globl vector82
vector82:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $82
8010655b:	6a 52                	push   $0x52
  jmp alltraps
8010655d:	e9 35 f8 ff ff       	jmp    80105d97 <alltraps>

80106562 <vector83>:
.globl vector83
vector83:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $83
80106564:	6a 53                	push   $0x53
  jmp alltraps
80106566:	e9 2c f8 ff ff       	jmp    80105d97 <alltraps>

8010656b <vector84>:
.globl vector84
vector84:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $84
8010656d:	6a 54                	push   $0x54
  jmp alltraps
8010656f:	e9 23 f8 ff ff       	jmp    80105d97 <alltraps>

80106574 <vector85>:
.globl vector85
vector85:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $85
80106576:	6a 55                	push   $0x55
  jmp alltraps
80106578:	e9 1a f8 ff ff       	jmp    80105d97 <alltraps>

8010657d <vector86>:
.globl vector86
vector86:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $86
8010657f:	6a 56                	push   $0x56
  jmp alltraps
80106581:	e9 11 f8 ff ff       	jmp    80105d97 <alltraps>

80106586 <vector87>:
.globl vector87
vector87:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $87
80106588:	6a 57                	push   $0x57
  jmp alltraps
8010658a:	e9 08 f8 ff ff       	jmp    80105d97 <alltraps>

8010658f <vector88>:
.globl vector88
vector88:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $88
80106591:	6a 58                	push   $0x58
  jmp alltraps
80106593:	e9 ff f7 ff ff       	jmp    80105d97 <alltraps>

80106598 <vector89>:
.globl vector89
vector89:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $89
8010659a:	6a 59                	push   $0x59
  jmp alltraps
8010659c:	e9 f6 f7 ff ff       	jmp    80105d97 <alltraps>

801065a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $90
801065a3:	6a 5a                	push   $0x5a
  jmp alltraps
801065a5:	e9 ed f7 ff ff       	jmp    80105d97 <alltraps>

801065aa <vector91>:
.globl vector91
vector91:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $91
801065ac:	6a 5b                	push   $0x5b
  jmp alltraps
801065ae:	e9 e4 f7 ff ff       	jmp    80105d97 <alltraps>

801065b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $92
801065b5:	6a 5c                	push   $0x5c
  jmp alltraps
801065b7:	e9 db f7 ff ff       	jmp    80105d97 <alltraps>

801065bc <vector93>:
.globl vector93
vector93:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $93
801065be:	6a 5d                	push   $0x5d
  jmp alltraps
801065c0:	e9 d2 f7 ff ff       	jmp    80105d97 <alltraps>

801065c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $94
801065c7:	6a 5e                	push   $0x5e
  jmp alltraps
801065c9:	e9 c9 f7 ff ff       	jmp    80105d97 <alltraps>

801065ce <vector95>:
.globl vector95
vector95:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $95
801065d0:	6a 5f                	push   $0x5f
  jmp alltraps
801065d2:	e9 c0 f7 ff ff       	jmp    80105d97 <alltraps>

801065d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $96
801065d9:	6a 60                	push   $0x60
  jmp alltraps
801065db:	e9 b7 f7 ff ff       	jmp    80105d97 <alltraps>

801065e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $97
801065e2:	6a 61                	push   $0x61
  jmp alltraps
801065e4:	e9 ae f7 ff ff       	jmp    80105d97 <alltraps>

801065e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $98
801065eb:	6a 62                	push   $0x62
  jmp alltraps
801065ed:	e9 a5 f7 ff ff       	jmp    80105d97 <alltraps>

801065f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $99
801065f4:	6a 63                	push   $0x63
  jmp alltraps
801065f6:	e9 9c f7 ff ff       	jmp    80105d97 <alltraps>

801065fb <vector100>:
.globl vector100
vector100:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $100
801065fd:	6a 64                	push   $0x64
  jmp alltraps
801065ff:	e9 93 f7 ff ff       	jmp    80105d97 <alltraps>

80106604 <vector101>:
.globl vector101
vector101:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $101
80106606:	6a 65                	push   $0x65
  jmp alltraps
80106608:	e9 8a f7 ff ff       	jmp    80105d97 <alltraps>

8010660d <vector102>:
.globl vector102
vector102:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $102
8010660f:	6a 66                	push   $0x66
  jmp alltraps
80106611:	e9 81 f7 ff ff       	jmp    80105d97 <alltraps>

80106616 <vector103>:
.globl vector103
vector103:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $103
80106618:	6a 67                	push   $0x67
  jmp alltraps
8010661a:	e9 78 f7 ff ff       	jmp    80105d97 <alltraps>

8010661f <vector104>:
.globl vector104
vector104:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $104
80106621:	6a 68                	push   $0x68
  jmp alltraps
80106623:	e9 6f f7 ff ff       	jmp    80105d97 <alltraps>

80106628 <vector105>:
.globl vector105
vector105:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $105
8010662a:	6a 69                	push   $0x69
  jmp alltraps
8010662c:	e9 66 f7 ff ff       	jmp    80105d97 <alltraps>

80106631 <vector106>:
.globl vector106
vector106:
  pushl $0
80106631:	6a 00                	push   $0x0
  pushl $106
80106633:	6a 6a                	push   $0x6a
  jmp alltraps
80106635:	e9 5d f7 ff ff       	jmp    80105d97 <alltraps>

8010663a <vector107>:
.globl vector107
vector107:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $107
8010663c:	6a 6b                	push   $0x6b
  jmp alltraps
8010663e:	e9 54 f7 ff ff       	jmp    80105d97 <alltraps>

80106643 <vector108>:
.globl vector108
vector108:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $108
80106645:	6a 6c                	push   $0x6c
  jmp alltraps
80106647:	e9 4b f7 ff ff       	jmp    80105d97 <alltraps>

8010664c <vector109>:
.globl vector109
vector109:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $109
8010664e:	6a 6d                	push   $0x6d
  jmp alltraps
80106650:	e9 42 f7 ff ff       	jmp    80105d97 <alltraps>

80106655 <vector110>:
.globl vector110
vector110:
  pushl $0
80106655:	6a 00                	push   $0x0
  pushl $110
80106657:	6a 6e                	push   $0x6e
  jmp alltraps
80106659:	e9 39 f7 ff ff       	jmp    80105d97 <alltraps>

8010665e <vector111>:
.globl vector111
vector111:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $111
80106660:	6a 6f                	push   $0x6f
  jmp alltraps
80106662:	e9 30 f7 ff ff       	jmp    80105d97 <alltraps>

80106667 <vector112>:
.globl vector112
vector112:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $112
80106669:	6a 70                	push   $0x70
  jmp alltraps
8010666b:	e9 27 f7 ff ff       	jmp    80105d97 <alltraps>

80106670 <vector113>:
.globl vector113
vector113:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $113
80106672:	6a 71                	push   $0x71
  jmp alltraps
80106674:	e9 1e f7 ff ff       	jmp    80105d97 <alltraps>

80106679 <vector114>:
.globl vector114
vector114:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $114
8010667b:	6a 72                	push   $0x72
  jmp alltraps
8010667d:	e9 15 f7 ff ff       	jmp    80105d97 <alltraps>

80106682 <vector115>:
.globl vector115
vector115:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $115
80106684:	6a 73                	push   $0x73
  jmp alltraps
80106686:	e9 0c f7 ff ff       	jmp    80105d97 <alltraps>

8010668b <vector116>:
.globl vector116
vector116:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $116
8010668d:	6a 74                	push   $0x74
  jmp alltraps
8010668f:	e9 03 f7 ff ff       	jmp    80105d97 <alltraps>

80106694 <vector117>:
.globl vector117
vector117:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $117
80106696:	6a 75                	push   $0x75
  jmp alltraps
80106698:	e9 fa f6 ff ff       	jmp    80105d97 <alltraps>

8010669d <vector118>:
.globl vector118
vector118:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $118
8010669f:	6a 76                	push   $0x76
  jmp alltraps
801066a1:	e9 f1 f6 ff ff       	jmp    80105d97 <alltraps>

801066a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $119
801066a8:	6a 77                	push   $0x77
  jmp alltraps
801066aa:	e9 e8 f6 ff ff       	jmp    80105d97 <alltraps>

801066af <vector120>:
.globl vector120
vector120:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $120
801066b1:	6a 78                	push   $0x78
  jmp alltraps
801066b3:	e9 df f6 ff ff       	jmp    80105d97 <alltraps>

801066b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $121
801066ba:	6a 79                	push   $0x79
  jmp alltraps
801066bc:	e9 d6 f6 ff ff       	jmp    80105d97 <alltraps>

801066c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $122
801066c3:	6a 7a                	push   $0x7a
  jmp alltraps
801066c5:	e9 cd f6 ff ff       	jmp    80105d97 <alltraps>

801066ca <vector123>:
.globl vector123
vector123:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $123
801066cc:	6a 7b                	push   $0x7b
  jmp alltraps
801066ce:	e9 c4 f6 ff ff       	jmp    80105d97 <alltraps>

801066d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $124
801066d5:	6a 7c                	push   $0x7c
  jmp alltraps
801066d7:	e9 bb f6 ff ff       	jmp    80105d97 <alltraps>

801066dc <vector125>:
.globl vector125
vector125:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $125
801066de:	6a 7d                	push   $0x7d
  jmp alltraps
801066e0:	e9 b2 f6 ff ff       	jmp    80105d97 <alltraps>

801066e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $126
801066e7:	6a 7e                	push   $0x7e
  jmp alltraps
801066e9:	e9 a9 f6 ff ff       	jmp    80105d97 <alltraps>

801066ee <vector127>:
.globl vector127
vector127:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $127
801066f0:	6a 7f                	push   $0x7f
  jmp alltraps
801066f2:	e9 a0 f6 ff ff       	jmp    80105d97 <alltraps>

801066f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $128
801066f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066fe:	e9 94 f6 ff ff       	jmp    80105d97 <alltraps>

80106703 <vector129>:
.globl vector129
vector129:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $129
80106705:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010670a:	e9 88 f6 ff ff       	jmp    80105d97 <alltraps>

8010670f <vector130>:
.globl vector130
vector130:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $130
80106711:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106716:	e9 7c f6 ff ff       	jmp    80105d97 <alltraps>

8010671b <vector131>:
.globl vector131
vector131:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $131
8010671d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106722:	e9 70 f6 ff ff       	jmp    80105d97 <alltraps>

80106727 <vector132>:
.globl vector132
vector132:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $132
80106729:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010672e:	e9 64 f6 ff ff       	jmp    80105d97 <alltraps>

80106733 <vector133>:
.globl vector133
vector133:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $133
80106735:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010673a:	e9 58 f6 ff ff       	jmp    80105d97 <alltraps>

8010673f <vector134>:
.globl vector134
vector134:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $134
80106741:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106746:	e9 4c f6 ff ff       	jmp    80105d97 <alltraps>

8010674b <vector135>:
.globl vector135
vector135:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $135
8010674d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106752:	e9 40 f6 ff ff       	jmp    80105d97 <alltraps>

80106757 <vector136>:
.globl vector136
vector136:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $136
80106759:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010675e:	e9 34 f6 ff ff       	jmp    80105d97 <alltraps>

80106763 <vector137>:
.globl vector137
vector137:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $137
80106765:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010676a:	e9 28 f6 ff ff       	jmp    80105d97 <alltraps>

8010676f <vector138>:
.globl vector138
vector138:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $138
80106771:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106776:	e9 1c f6 ff ff       	jmp    80105d97 <alltraps>

8010677b <vector139>:
.globl vector139
vector139:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $139
8010677d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106782:	e9 10 f6 ff ff       	jmp    80105d97 <alltraps>

80106787 <vector140>:
.globl vector140
vector140:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $140
80106789:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010678e:	e9 04 f6 ff ff       	jmp    80105d97 <alltraps>

80106793 <vector141>:
.globl vector141
vector141:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $141
80106795:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010679a:	e9 f8 f5 ff ff       	jmp    80105d97 <alltraps>

8010679f <vector142>:
.globl vector142
vector142:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $142
801067a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801067a6:	e9 ec f5 ff ff       	jmp    80105d97 <alltraps>

801067ab <vector143>:
.globl vector143
vector143:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $143
801067ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067b2:	e9 e0 f5 ff ff       	jmp    80105d97 <alltraps>

801067b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $144
801067b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067be:	e9 d4 f5 ff ff       	jmp    80105d97 <alltraps>

801067c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $145
801067c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067ca:	e9 c8 f5 ff ff       	jmp    80105d97 <alltraps>

801067cf <vector146>:
.globl vector146
vector146:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $146
801067d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067d6:	e9 bc f5 ff ff       	jmp    80105d97 <alltraps>

801067db <vector147>:
.globl vector147
vector147:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $147
801067dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067e2:	e9 b0 f5 ff ff       	jmp    80105d97 <alltraps>

801067e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $148
801067e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067ee:	e9 a4 f5 ff ff       	jmp    80105d97 <alltraps>

801067f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $149
801067f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067fa:	e9 98 f5 ff ff       	jmp    80105d97 <alltraps>

801067ff <vector150>:
.globl vector150
vector150:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $150
80106801:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106806:	e9 8c f5 ff ff       	jmp    80105d97 <alltraps>

8010680b <vector151>:
.globl vector151
vector151:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $151
8010680d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106812:	e9 80 f5 ff ff       	jmp    80105d97 <alltraps>

80106817 <vector152>:
.globl vector152
vector152:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $152
80106819:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010681e:	e9 74 f5 ff ff       	jmp    80105d97 <alltraps>

80106823 <vector153>:
.globl vector153
vector153:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $153
80106825:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010682a:	e9 68 f5 ff ff       	jmp    80105d97 <alltraps>

8010682f <vector154>:
.globl vector154
vector154:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $154
80106831:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106836:	e9 5c f5 ff ff       	jmp    80105d97 <alltraps>

8010683b <vector155>:
.globl vector155
vector155:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $155
8010683d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106842:	e9 50 f5 ff ff       	jmp    80105d97 <alltraps>

80106847 <vector156>:
.globl vector156
vector156:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $156
80106849:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010684e:	e9 44 f5 ff ff       	jmp    80105d97 <alltraps>

80106853 <vector157>:
.globl vector157
vector157:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $157
80106855:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010685a:	e9 38 f5 ff ff       	jmp    80105d97 <alltraps>

8010685f <vector158>:
.globl vector158
vector158:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $158
80106861:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106866:	e9 2c f5 ff ff       	jmp    80105d97 <alltraps>

8010686b <vector159>:
.globl vector159
vector159:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $159
8010686d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106872:	e9 20 f5 ff ff       	jmp    80105d97 <alltraps>

80106877 <vector160>:
.globl vector160
vector160:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $160
80106879:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010687e:	e9 14 f5 ff ff       	jmp    80105d97 <alltraps>

80106883 <vector161>:
.globl vector161
vector161:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $161
80106885:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010688a:	e9 08 f5 ff ff       	jmp    80105d97 <alltraps>

8010688f <vector162>:
.globl vector162
vector162:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $162
80106891:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106896:	e9 fc f4 ff ff       	jmp    80105d97 <alltraps>

8010689b <vector163>:
.globl vector163
vector163:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $163
8010689d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801068a2:	e9 f0 f4 ff ff       	jmp    80105d97 <alltraps>

801068a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $164
801068a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801068ae:	e9 e4 f4 ff ff       	jmp    80105d97 <alltraps>

801068b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $165
801068b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068ba:	e9 d8 f4 ff ff       	jmp    80105d97 <alltraps>

801068bf <vector166>:
.globl vector166
vector166:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $166
801068c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068c6:	e9 cc f4 ff ff       	jmp    80105d97 <alltraps>

801068cb <vector167>:
.globl vector167
vector167:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $167
801068cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068d2:	e9 c0 f4 ff ff       	jmp    80105d97 <alltraps>

801068d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $168
801068d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068de:	e9 b4 f4 ff ff       	jmp    80105d97 <alltraps>

801068e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $169
801068e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068ea:	e9 a8 f4 ff ff       	jmp    80105d97 <alltraps>

801068ef <vector170>:
.globl vector170
vector170:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $170
801068f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068f6:	e9 9c f4 ff ff       	jmp    80105d97 <alltraps>

801068fb <vector171>:
.globl vector171
vector171:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $171
801068fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106902:	e9 90 f4 ff ff       	jmp    80105d97 <alltraps>

80106907 <vector172>:
.globl vector172
vector172:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $172
80106909:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010690e:	e9 84 f4 ff ff       	jmp    80105d97 <alltraps>

80106913 <vector173>:
.globl vector173
vector173:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $173
80106915:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010691a:	e9 78 f4 ff ff       	jmp    80105d97 <alltraps>

8010691f <vector174>:
.globl vector174
vector174:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $174
80106921:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106926:	e9 6c f4 ff ff       	jmp    80105d97 <alltraps>

8010692b <vector175>:
.globl vector175
vector175:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $175
8010692d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106932:	e9 60 f4 ff ff       	jmp    80105d97 <alltraps>

80106937 <vector176>:
.globl vector176
vector176:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $176
80106939:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010693e:	e9 54 f4 ff ff       	jmp    80105d97 <alltraps>

80106943 <vector177>:
.globl vector177
vector177:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $177
80106945:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010694a:	e9 48 f4 ff ff       	jmp    80105d97 <alltraps>

8010694f <vector178>:
.globl vector178
vector178:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $178
80106951:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106956:	e9 3c f4 ff ff       	jmp    80105d97 <alltraps>

8010695b <vector179>:
.globl vector179
vector179:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $179
8010695d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106962:	e9 30 f4 ff ff       	jmp    80105d97 <alltraps>

80106967 <vector180>:
.globl vector180
vector180:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $180
80106969:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010696e:	e9 24 f4 ff ff       	jmp    80105d97 <alltraps>

80106973 <vector181>:
.globl vector181
vector181:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $181
80106975:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010697a:	e9 18 f4 ff ff       	jmp    80105d97 <alltraps>

8010697f <vector182>:
.globl vector182
vector182:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $182
80106981:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106986:	e9 0c f4 ff ff       	jmp    80105d97 <alltraps>

8010698b <vector183>:
.globl vector183
vector183:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $183
8010698d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106992:	e9 00 f4 ff ff       	jmp    80105d97 <alltraps>

80106997 <vector184>:
.globl vector184
vector184:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $184
80106999:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010699e:	e9 f4 f3 ff ff       	jmp    80105d97 <alltraps>

801069a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $185
801069a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801069aa:	e9 e8 f3 ff ff       	jmp    80105d97 <alltraps>

801069af <vector186>:
.globl vector186
vector186:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $186
801069b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069b6:	e9 dc f3 ff ff       	jmp    80105d97 <alltraps>

801069bb <vector187>:
.globl vector187
vector187:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $187
801069bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069c2:	e9 d0 f3 ff ff       	jmp    80105d97 <alltraps>

801069c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $188
801069c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069ce:	e9 c4 f3 ff ff       	jmp    80105d97 <alltraps>

801069d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $189
801069d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069da:	e9 b8 f3 ff ff       	jmp    80105d97 <alltraps>

801069df <vector190>:
.globl vector190
vector190:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $190
801069e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069e6:	e9 ac f3 ff ff       	jmp    80105d97 <alltraps>

801069eb <vector191>:
.globl vector191
vector191:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $191
801069ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069f2:	e9 a0 f3 ff ff       	jmp    80105d97 <alltraps>

801069f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $192
801069f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069fe:	e9 94 f3 ff ff       	jmp    80105d97 <alltraps>

80106a03 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $193
80106a05:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a0a:	e9 88 f3 ff ff       	jmp    80105d97 <alltraps>

80106a0f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $194
80106a11:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a16:	e9 7c f3 ff ff       	jmp    80105d97 <alltraps>

80106a1b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $195
80106a1d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a22:	e9 70 f3 ff ff       	jmp    80105d97 <alltraps>

80106a27 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $196
80106a29:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a2e:	e9 64 f3 ff ff       	jmp    80105d97 <alltraps>

80106a33 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $197
80106a35:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a3a:	e9 58 f3 ff ff       	jmp    80105d97 <alltraps>

80106a3f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $198
80106a41:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a46:	e9 4c f3 ff ff       	jmp    80105d97 <alltraps>

80106a4b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $199
80106a4d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a52:	e9 40 f3 ff ff       	jmp    80105d97 <alltraps>

80106a57 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $200
80106a59:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a5e:	e9 34 f3 ff ff       	jmp    80105d97 <alltraps>

80106a63 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $201
80106a65:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a6a:	e9 28 f3 ff ff       	jmp    80105d97 <alltraps>

80106a6f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $202
80106a71:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a76:	e9 1c f3 ff ff       	jmp    80105d97 <alltraps>

80106a7b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $203
80106a7d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a82:	e9 10 f3 ff ff       	jmp    80105d97 <alltraps>

80106a87 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $204
80106a89:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a8e:	e9 04 f3 ff ff       	jmp    80105d97 <alltraps>

80106a93 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $205
80106a95:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a9a:	e9 f8 f2 ff ff       	jmp    80105d97 <alltraps>

80106a9f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $206
80106aa1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106aa6:	e9 ec f2 ff ff       	jmp    80105d97 <alltraps>

80106aab <vector207>:
.globl vector207
vector207:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $207
80106aad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ab2:	e9 e0 f2 ff ff       	jmp    80105d97 <alltraps>

80106ab7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $208
80106ab9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106abe:	e9 d4 f2 ff ff       	jmp    80105d97 <alltraps>

80106ac3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $209
80106ac5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aca:	e9 c8 f2 ff ff       	jmp    80105d97 <alltraps>

80106acf <vector210>:
.globl vector210
vector210:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $210
80106ad1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ad6:	e9 bc f2 ff ff       	jmp    80105d97 <alltraps>

80106adb <vector211>:
.globl vector211
vector211:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $211
80106add:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ae2:	e9 b0 f2 ff ff       	jmp    80105d97 <alltraps>

80106ae7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $212
80106ae9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106aee:	e9 a4 f2 ff ff       	jmp    80105d97 <alltraps>

80106af3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $213
80106af5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106afa:	e9 98 f2 ff ff       	jmp    80105d97 <alltraps>

80106aff <vector214>:
.globl vector214
vector214:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $214
80106b01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b06:	e9 8c f2 ff ff       	jmp    80105d97 <alltraps>

80106b0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $215
80106b0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b12:	e9 80 f2 ff ff       	jmp    80105d97 <alltraps>

80106b17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $216
80106b19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b1e:	e9 74 f2 ff ff       	jmp    80105d97 <alltraps>

80106b23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $217
80106b25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b2a:	e9 68 f2 ff ff       	jmp    80105d97 <alltraps>

80106b2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $218
80106b31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b36:	e9 5c f2 ff ff       	jmp    80105d97 <alltraps>

80106b3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $219
80106b3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b42:	e9 50 f2 ff ff       	jmp    80105d97 <alltraps>

80106b47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $220
80106b49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b4e:	e9 44 f2 ff ff       	jmp    80105d97 <alltraps>

80106b53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $221
80106b55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b5a:	e9 38 f2 ff ff       	jmp    80105d97 <alltraps>

80106b5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $222
80106b61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b66:	e9 2c f2 ff ff       	jmp    80105d97 <alltraps>

80106b6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $223
80106b6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b72:	e9 20 f2 ff ff       	jmp    80105d97 <alltraps>

80106b77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $224
80106b79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b7e:	e9 14 f2 ff ff       	jmp    80105d97 <alltraps>

80106b83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $225
80106b85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b8a:	e9 08 f2 ff ff       	jmp    80105d97 <alltraps>

80106b8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $226
80106b91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b96:	e9 fc f1 ff ff       	jmp    80105d97 <alltraps>

80106b9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $227
80106b9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ba2:	e9 f0 f1 ff ff       	jmp    80105d97 <alltraps>

80106ba7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $228
80106ba9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106bae:	e9 e4 f1 ff ff       	jmp    80105d97 <alltraps>

80106bb3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $229
80106bb5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106bba:	e9 d8 f1 ff ff       	jmp    80105d97 <alltraps>

80106bbf <vector230>:
.globl vector230
vector230:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $230
80106bc1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106bc6:	e9 cc f1 ff ff       	jmp    80105d97 <alltraps>

80106bcb <vector231>:
.globl vector231
vector231:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $231
80106bcd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bd2:	e9 c0 f1 ff ff       	jmp    80105d97 <alltraps>

80106bd7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $232
80106bd9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bde:	e9 b4 f1 ff ff       	jmp    80105d97 <alltraps>

80106be3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $233
80106be5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106bea:	e9 a8 f1 ff ff       	jmp    80105d97 <alltraps>

80106bef <vector234>:
.globl vector234
vector234:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $234
80106bf1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106bf6:	e9 9c f1 ff ff       	jmp    80105d97 <alltraps>

80106bfb <vector235>:
.globl vector235
vector235:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $235
80106bfd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c02:	e9 90 f1 ff ff       	jmp    80105d97 <alltraps>

80106c07 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $236
80106c09:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c0e:	e9 84 f1 ff ff       	jmp    80105d97 <alltraps>

80106c13 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $237
80106c15:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c1a:	e9 78 f1 ff ff       	jmp    80105d97 <alltraps>

80106c1f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $238
80106c21:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c26:	e9 6c f1 ff ff       	jmp    80105d97 <alltraps>

80106c2b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $239
80106c2d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c32:	e9 60 f1 ff ff       	jmp    80105d97 <alltraps>

80106c37 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $240
80106c39:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c3e:	e9 54 f1 ff ff       	jmp    80105d97 <alltraps>

80106c43 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $241
80106c45:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c4a:	e9 48 f1 ff ff       	jmp    80105d97 <alltraps>

80106c4f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $242
80106c51:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c56:	e9 3c f1 ff ff       	jmp    80105d97 <alltraps>

80106c5b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $243
80106c5d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c62:	e9 30 f1 ff ff       	jmp    80105d97 <alltraps>

80106c67 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $244
80106c69:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c6e:	e9 24 f1 ff ff       	jmp    80105d97 <alltraps>

80106c73 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $245
80106c75:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c7a:	e9 18 f1 ff ff       	jmp    80105d97 <alltraps>

80106c7f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $246
80106c81:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c86:	e9 0c f1 ff ff       	jmp    80105d97 <alltraps>

80106c8b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $247
80106c8d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c92:	e9 00 f1 ff ff       	jmp    80105d97 <alltraps>

80106c97 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $248
80106c99:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c9e:	e9 f4 f0 ff ff       	jmp    80105d97 <alltraps>

80106ca3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $249
80106ca5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106caa:	e9 e8 f0 ff ff       	jmp    80105d97 <alltraps>

80106caf <vector250>:
.globl vector250
vector250:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $250
80106cb1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106cb6:	e9 dc f0 ff ff       	jmp    80105d97 <alltraps>

80106cbb <vector251>:
.globl vector251
vector251:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $251
80106cbd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106cc2:	e9 d0 f0 ff ff       	jmp    80105d97 <alltraps>

80106cc7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $252
80106cc9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cce:	e9 c4 f0 ff ff       	jmp    80105d97 <alltraps>

80106cd3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $253
80106cd5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cda:	e9 b8 f0 ff ff       	jmp    80105d97 <alltraps>

80106cdf <vector254>:
.globl vector254
vector254:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $254
80106ce1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ce6:	e9 ac f0 ff ff       	jmp    80105d97 <alltraps>

80106ceb <vector255>:
.globl vector255
vector255:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $255
80106ced:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106cf2:	e9 a0 f0 ff ff       	jmp    80105d97 <alltraps>
80106cf7:	66 90                	xchg   %ax,%ax
80106cf9:	66 90                	xchg   %ax,%ax
80106cfb:	66 90                	xchg   %ax,%ax
80106cfd:	66 90                	xchg   %ax,%ax
80106cff:	90                   	nop

80106d00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106d0c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d12:	83 ec 1c             	sub    $0x1c,%esp
80106d15:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d18:	39 d3                	cmp    %edx,%ebx
80106d1a:	73 49                	jae    80106d65 <deallocuvm.part.0+0x65>
80106d1c:	89 c7                	mov    %eax,%edi
80106d1e:	eb 0c                	jmp    80106d2c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d20:	83 c0 01             	add    $0x1,%eax
80106d23:	c1 e0 16             	shl    $0x16,%eax
80106d26:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d28:	39 da                	cmp    %ebx,%edx
80106d2a:	76 39                	jbe    80106d65 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106d2c:	89 d8                	mov    %ebx,%eax
80106d2e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106d31:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106d34:	f6 c1 01             	test   $0x1,%cl
80106d37:	74 e7                	je     80106d20 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106d39:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d3b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d41:	c1 ee 0a             	shr    $0xa,%esi
80106d44:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106d4a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106d51:	85 f6                	test   %esi,%esi
80106d53:	74 cb                	je     80106d20 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106d55:	8b 06                	mov    (%esi),%eax
80106d57:	a8 01                	test   $0x1,%al
80106d59:	75 15                	jne    80106d70 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106d5b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d61:	39 da                	cmp    %ebx,%edx
80106d63:	77 c7                	ja     80106d2c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d6b:	5b                   	pop    %ebx
80106d6c:	5e                   	pop    %esi
80106d6d:	5f                   	pop    %edi
80106d6e:	5d                   	pop    %ebp
80106d6f:	c3                   	ret
      if(pa == 0)
80106d70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d75:	74 25                	je     80106d9c <deallocuvm.part.0+0x9c>
      kfree(v);
80106d77:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d7a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d82:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d88:	50                   	push   %eax
80106d89:	e8 42 b7 ff ff       	call   801024d0 <kfree>
      *pte = 0;
80106d8e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106d94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d97:	83 c4 10             	add    $0x10,%esp
80106d9a:	eb 8c                	jmp    80106d28 <deallocuvm.part.0+0x28>
        panic("kfree");
80106d9c:	83 ec 0c             	sub    $0xc,%esp
80106d9f:	68 cc 78 10 80       	push   $0x801078cc
80106da4:	e8 d7 95 ff ff       	call   80100380 <panic>
80106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106db0 <mappages>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106db6:	89 d3                	mov    %edx,%ebx
80106db8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106dbe:	83 ec 1c             	sub    $0x1c,%esp
80106dc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106dc4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106dc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dcd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80106dd3:	29 d8                	sub    %ebx,%eax
80106dd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106dd8:	eb 3d                	jmp    80106e17 <mappages+0x67>
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106de0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106de2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106de7:	c1 ea 0a             	shr    $0xa,%edx
80106dea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106df0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106df7:	85 c0                	test   %eax,%eax
80106df9:	74 75                	je     80106e70 <mappages+0xc0>
    if(*pte & PTE_P)
80106dfb:	f6 00 01             	testb  $0x1,(%eax)
80106dfe:	0f 85 86 00 00 00    	jne    80106e8a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106e04:	0b 75 0c             	or     0xc(%ebp),%esi
80106e07:	83 ce 01             	or     $0x1,%esi
80106e0a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e0c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106e0f:	74 6f                	je     80106e80 <mappages+0xd0>
    a += PGSIZE;
80106e11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106e17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106e1a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e1d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106e20:	89 d8                	mov    %ebx,%eax
80106e22:	c1 e8 16             	shr    $0x16,%eax
80106e25:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106e28:	8b 07                	mov    (%edi),%eax
80106e2a:	a8 01                	test   $0x1,%al
80106e2c:	75 b2                	jne    80106de0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e2e:	e8 5d b8 ff ff       	call   80102690 <kalloc>
80106e33:	85 c0                	test   %eax,%eax
80106e35:	74 39                	je     80106e70 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106e37:	83 ec 04             	sub    $0x4,%esp
80106e3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106e3d:	68 00 10 00 00       	push   $0x1000
80106e42:	6a 00                	push   $0x0
80106e44:	50                   	push   %eax
80106e45:	e8 56 d9 ff ff       	call   801047a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106e4d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e50:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106e56:	83 c8 07             	or     $0x7,%eax
80106e59:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106e5b:	89 d8                	mov    %ebx,%eax
80106e5d:	c1 e8 0a             	shr    $0xa,%eax
80106e60:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e65:	01 d0                	add    %edx,%eax
80106e67:	eb 92                	jmp    80106dfb <mappages+0x4b>
80106e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e78:	5b                   	pop    %ebx
80106e79:	5e                   	pop    %esi
80106e7a:	5f                   	pop    %edi
80106e7b:	5d                   	pop    %ebp
80106e7c:	c3                   	ret
80106e7d:	8d 76 00             	lea    0x0(%esi),%esi
80106e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e83:	31 c0                	xor    %eax,%eax
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret
      panic("remap");
80106e8a:	83 ec 0c             	sub    $0xc,%esp
80106e8d:	68 7f 7b 10 80       	push   $0x80107b7f
80106e92:	e8 e9 94 ff ff       	call   80100380 <panic>
80106e97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e9e:	00 
80106e9f:	90                   	nop

80106ea0 <seginit>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ea6:	e8 75 cb ff ff       	call   80103a20 <cpuid>
  pd[0] = size-1;
80106eab:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106eb0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106eb6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eba:	c7 80 d8 28 11 80 ff 	movl   $0xffff,-0x7feed728(%eax)
80106ec1:	ff 00 00 
80106ec4:	c7 80 dc 28 11 80 00 	movl   $0xcf9a00,-0x7feed724(%eax)
80106ecb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ece:	c7 80 e0 28 11 80 ff 	movl   $0xffff,-0x7feed720(%eax)
80106ed5:	ff 00 00 
80106ed8:	c7 80 e4 28 11 80 00 	movl   $0xcf9200,-0x7feed71c(%eax)
80106edf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ee2:	c7 80 e8 28 11 80 ff 	movl   $0xffff,-0x7feed718(%eax)
80106ee9:	ff 00 00 
80106eec:	c7 80 ec 28 11 80 00 	movl   $0xcffa00,-0x7feed714(%eax)
80106ef3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ef6:	c7 80 f0 28 11 80 ff 	movl   $0xffff,-0x7feed710(%eax)
80106efd:	ff 00 00 
80106f00:	c7 80 f4 28 11 80 00 	movl   $0xcff200,-0x7feed70c(%eax)
80106f07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f0a:	05 d0 28 11 80       	add    $0x801128d0,%eax
  pd[1] = (uint)p;
80106f0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f13:	c1 e8 10             	shr    $0x10,%eax
80106f16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f1d:	0f 01 10             	lgdtl  (%eax)
}
80106f20:	c9                   	leave
80106f21:	c3                   	ret
80106f22:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f29:	00 
80106f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f30:	a1 84 5f 11 80       	mov    0x80115f84,%eax
80106f35:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f3a:	0f 22 d8             	mov    %eax,%cr3
}
80106f3d:	c3                   	ret
80106f3e:	66 90                	xchg   %ax,%ax

80106f40 <switchuvm>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
80106f46:	83 ec 1c             	sub    $0x1c,%esp
80106f49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f4c:	85 f6                	test   %esi,%esi
80106f4e:	0f 84 cb 00 00 00    	je     8010701f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f54:	8b 46 08             	mov    0x8(%esi),%eax
80106f57:	85 c0                	test   %eax,%eax
80106f59:	0f 84 da 00 00 00    	je     80107039 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f5f:	8b 46 04             	mov    0x4(%esi),%eax
80106f62:	85 c0                	test   %eax,%eax
80106f64:	0f 84 c2 00 00 00    	je     8010702c <switchuvm+0xec>
  pushcli();
80106f6a:	e8 21 d6 ff ff       	call   80104590 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f6f:	e8 4c ca ff ff       	call   801039c0 <mycpu>
80106f74:	89 c3                	mov    %eax,%ebx
80106f76:	e8 45 ca ff ff       	call   801039c0 <mycpu>
80106f7b:	89 c7                	mov    %eax,%edi
80106f7d:	e8 3e ca ff ff       	call   801039c0 <mycpu>
80106f82:	83 c7 08             	add    $0x8,%edi
80106f85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f88:	e8 33 ca ff ff       	call   801039c0 <mycpu>
80106f8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f90:	ba 67 00 00 00       	mov    $0x67,%edx
80106f95:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f9c:	83 c0 08             	add    $0x8,%eax
80106f9f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fa6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fab:	83 c1 08             	add    $0x8,%ecx
80106fae:	c1 e8 18             	shr    $0x18,%eax
80106fb1:	c1 e9 10             	shr    $0x10,%ecx
80106fb4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106fba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106fc0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106fc5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fcc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106fd1:	e8 ea c9 ff ff       	call   801039c0 <mycpu>
80106fd6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fdd:	e8 de c9 ff ff       	call   801039c0 <mycpu>
80106fe2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fe6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106fe9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fef:	e8 cc c9 ff ff       	call   801039c0 <mycpu>
80106ff4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ff7:	e8 c4 c9 ff ff       	call   801039c0 <mycpu>
80106ffc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107000:	b8 28 00 00 00       	mov    $0x28,%eax
80107005:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107008:	8b 46 04             	mov    0x4(%esi),%eax
8010700b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107010:	0f 22 d8             	mov    %eax,%cr3
}
80107013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107016:	5b                   	pop    %ebx
80107017:	5e                   	pop    %esi
80107018:	5f                   	pop    %edi
80107019:	5d                   	pop    %ebp
  popcli();
8010701a:	e9 c1 d5 ff ff       	jmp    801045e0 <popcli>
    panic("switchuvm: no process");
8010701f:	83 ec 0c             	sub    $0xc,%esp
80107022:	68 85 7b 10 80       	push   $0x80107b85
80107027:	e8 54 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010702c:	83 ec 0c             	sub    $0xc,%esp
8010702f:	68 b0 7b 10 80       	push   $0x80107bb0
80107034:	e8 47 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107039:	83 ec 0c             	sub    $0xc,%esp
8010703c:	68 9b 7b 10 80       	push   $0x80107b9b
80107041:	e8 3a 93 ff ff       	call   80100380 <panic>
80107046:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010704d:	00 
8010704e:	66 90                	xchg   %ax,%ax

80107050 <inituvm>:
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
80107056:	83 ec 1c             	sub    $0x1c,%esp
80107059:	8b 45 0c             	mov    0xc(%ebp),%eax
8010705c:	8b 75 10             	mov    0x10(%ebp),%esi
8010705f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107062:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107065:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010706b:	77 4b                	ja     801070b8 <inituvm+0x68>
  mem = kalloc();
8010706d:	e8 1e b6 ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80107072:	83 ec 04             	sub    $0x4,%esp
80107075:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010707a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010707c:	6a 00                	push   $0x0
8010707e:	50                   	push   %eax
8010707f:	e8 1c d7 ff ff       	call   801047a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107084:	58                   	pop    %eax
80107085:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010708b:	5a                   	pop    %edx
8010708c:	6a 06                	push   $0x6
8010708e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107093:	31 d2                	xor    %edx,%edx
80107095:	50                   	push   %eax
80107096:	89 f8                	mov    %edi,%eax
80107098:	e8 13 fd ff ff       	call   80106db0 <mappages>
  memmove(mem, init, sz);
8010709d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070a0:	89 75 10             	mov    %esi,0x10(%ebp)
801070a3:	83 c4 10             	add    $0x10,%esp
801070a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801070a9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801070ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070af:	5b                   	pop    %ebx
801070b0:	5e                   	pop    %esi
801070b1:	5f                   	pop    %edi
801070b2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070b3:	e9 88 d7 ff ff       	jmp    80104840 <memmove>
    panic("inituvm: more than a page");
801070b8:	83 ec 0c             	sub    $0xc,%esp
801070bb:	68 c4 7b 10 80       	push   $0x80107bc4
801070c0:	e8 bb 92 ff ff       	call   80100380 <panic>
801070c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070cc:	00 
801070cd:	8d 76 00             	lea    0x0(%esi),%esi

801070d0 <loaduvm>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
801070d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070dc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801070df:	a9 ff 0f 00 00       	test   $0xfff,%eax
801070e4:	0f 85 bb 00 00 00    	jne    801071a5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801070ea:	01 f0                	add    %esi,%eax
801070ec:	89 f3                	mov    %esi,%ebx
801070ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070f1:	8b 45 14             	mov    0x14(%ebp),%eax
801070f4:	01 f0                	add    %esi,%eax
801070f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801070f9:	85 f6                	test   %esi,%esi
801070fb:	0f 84 87 00 00 00    	je     80107188 <loaduvm+0xb8>
80107101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010710b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010710e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107110:	89 c2                	mov    %eax,%edx
80107112:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107115:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107118:	f6 c2 01             	test   $0x1,%dl
8010711b:	75 13                	jne    80107130 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010711d:	83 ec 0c             	sub    $0xc,%esp
80107120:	68 de 7b 10 80       	push   $0x80107bde
80107125:	e8 56 92 ff ff       	call   80100380 <panic>
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107130:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107133:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107139:	25 fc 0f 00 00       	and    $0xffc,%eax
8010713e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107145:	85 c0                	test   %eax,%eax
80107147:	74 d4                	je     8010711d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107149:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010714b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010714e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107153:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107158:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010715e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107161:	29 d9                	sub    %ebx,%ecx
80107163:	05 00 00 00 80       	add    $0x80000000,%eax
80107168:	57                   	push   %edi
80107169:	51                   	push   %ecx
8010716a:	50                   	push   %eax
8010716b:	ff 75 10             	push   0x10(%ebp)
8010716e:	e8 2d a9 ff ff       	call   80101aa0 <readi>
80107173:	83 c4 10             	add    $0x10,%esp
80107176:	39 f8                	cmp    %edi,%eax
80107178:	75 1e                	jne    80107198 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010717a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107180:	89 f0                	mov    %esi,%eax
80107182:	29 d8                	sub    %ebx,%eax
80107184:	39 c6                	cmp    %eax,%esi
80107186:	77 80                	ja     80107108 <loaduvm+0x38>
}
80107188:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010718b:	31 c0                	xor    %eax,%eax
}
8010718d:	5b                   	pop    %ebx
8010718e:	5e                   	pop    %esi
8010718f:	5f                   	pop    %edi
80107190:	5d                   	pop    %ebp
80107191:	c3                   	ret
80107192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107198:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010719b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071a0:	5b                   	pop    %ebx
801071a1:	5e                   	pop    %esi
801071a2:	5f                   	pop    %edi
801071a3:	5d                   	pop    %ebp
801071a4:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801071a5:	83 ec 0c             	sub    $0xc,%esp
801071a8:	68 00 7e 10 80       	push   $0x80107e00
801071ad:	e8 ce 91 ff ff       	call   80100380 <panic>
801071b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071b9:	00 
801071ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071c0 <allocuvm>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071c9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801071cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071d2:	85 c0                	test   %eax,%eax
801071d4:	0f 88 b6 00 00 00    	js     80107290 <allocuvm+0xd0>
  if(newsz < oldsz)
801071da:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801071dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801071e0:	0f 82 9a 00 00 00    	jb     80107280 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801071e6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801071ec:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801071f2:	39 75 10             	cmp    %esi,0x10(%ebp)
801071f5:	77 44                	ja     8010723b <allocuvm+0x7b>
801071f7:	e9 87 00 00 00       	jmp    80107283 <allocuvm+0xc3>
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107200:	83 ec 04             	sub    $0x4,%esp
80107203:	68 00 10 00 00       	push   $0x1000
80107208:	6a 00                	push   $0x0
8010720a:	50                   	push   %eax
8010720b:	e8 90 d5 ff ff       	call   801047a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107210:	58                   	pop    %eax
80107211:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107217:	5a                   	pop    %edx
80107218:	6a 06                	push   $0x6
8010721a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010721f:	89 f2                	mov    %esi,%edx
80107221:	50                   	push   %eax
80107222:	89 f8                	mov    %edi,%eax
80107224:	e8 87 fb ff ff       	call   80106db0 <mappages>
80107229:	83 c4 10             	add    $0x10,%esp
8010722c:	85 c0                	test   %eax,%eax
8010722e:	78 78                	js     801072a8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107230:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107236:	39 75 10             	cmp    %esi,0x10(%ebp)
80107239:	76 48                	jbe    80107283 <allocuvm+0xc3>
    mem = kalloc();
8010723b:	e8 50 b4 ff ff       	call   80102690 <kalloc>
80107240:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107242:	85 c0                	test   %eax,%eax
80107244:	75 ba                	jne    80107200 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	68 fc 7b 10 80       	push   $0x80107bfc
8010724e:	e8 4d 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107253:	8b 45 0c             	mov    0xc(%ebp),%eax
80107256:	83 c4 10             	add    $0x10,%esp
80107259:	39 45 10             	cmp    %eax,0x10(%ebp)
8010725c:	74 32                	je     80107290 <allocuvm+0xd0>
8010725e:	8b 55 10             	mov    0x10(%ebp),%edx
80107261:	89 c1                	mov    %eax,%ecx
80107263:	89 f8                	mov    %edi,%eax
80107265:	e8 96 fa ff ff       	call   80106d00 <deallocuvm.part.0>
      return 0;
8010726a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107274:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107277:	5b                   	pop    %ebx
80107278:	5e                   	pop    %esi
80107279:	5f                   	pop    %edi
8010727a:	5d                   	pop    %ebp
8010727b:	c3                   	ret
8010727c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107280:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107286:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107289:	5b                   	pop    %ebx
8010728a:	5e                   	pop    %esi
8010728b:	5f                   	pop    %edi
8010728c:	5d                   	pop    %ebp
8010728d:	c3                   	ret
8010728e:	66 90                	xchg   %ax,%ax
    return 0;
80107290:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010729a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010729d:	5b                   	pop    %ebx
8010729e:	5e                   	pop    %esi
8010729f:	5f                   	pop    %edi
801072a0:	5d                   	pop    %ebp
801072a1:	c3                   	ret
801072a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072a8:	83 ec 0c             	sub    $0xc,%esp
801072ab:	68 14 7c 10 80       	push   $0x80107c14
801072b0:	e8 eb 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072b8:	83 c4 10             	add    $0x10,%esp
801072bb:	39 45 10             	cmp    %eax,0x10(%ebp)
801072be:	74 0c                	je     801072cc <allocuvm+0x10c>
801072c0:	8b 55 10             	mov    0x10(%ebp),%edx
801072c3:	89 c1                	mov    %eax,%ecx
801072c5:	89 f8                	mov    %edi,%eax
801072c7:	e8 34 fa ff ff       	call   80106d00 <deallocuvm.part.0>
      kfree(mem);
801072cc:	83 ec 0c             	sub    $0xc,%esp
801072cf:	53                   	push   %ebx
801072d0:	e8 fb b1 ff ff       	call   801024d0 <kfree>
      return 0;
801072d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072dc:	83 c4 10             	add    $0x10,%esp
}
801072df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e5:	5b                   	pop    %ebx
801072e6:	5e                   	pop    %esi
801072e7:	5f                   	pop    %edi
801072e8:	5d                   	pop    %ebp
801072e9:	c3                   	ret
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072f0 <deallocuvm>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801072f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801072f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801072fc:	39 d1                	cmp    %edx,%ecx
801072fe:	73 10                	jae    80107310 <deallocuvm+0x20>
}
80107300:	5d                   	pop    %ebp
80107301:	e9 fa f9 ff ff       	jmp    80106d00 <deallocuvm.part.0>
80107306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010730d:	00 
8010730e:	66 90                	xchg   %ax,%ax
80107310:	89 d0                	mov    %edx,%eax
80107312:	5d                   	pop    %ebp
80107313:	c3                   	ret
80107314:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010731b:	00 
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107320 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010732c:	85 f6                	test   %esi,%esi
8010732e:	74 59                	je     80107389 <freevm+0x69>
  if(newsz >= oldsz)
80107330:	31 c9                	xor    %ecx,%ecx
80107332:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107337:	89 f0                	mov    %esi,%eax
80107339:	89 f3                	mov    %esi,%ebx
8010733b:	e8 c0 f9 ff ff       	call   80106d00 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107340:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107346:	eb 0f                	jmp    80107357 <freevm+0x37>
80107348:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010734f:	00 
80107350:	83 c3 04             	add    $0x4,%ebx
80107353:	39 df                	cmp    %ebx,%edi
80107355:	74 23                	je     8010737a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107357:	8b 03                	mov    (%ebx),%eax
80107359:	a8 01                	test   $0x1,%al
8010735b:	74 f3                	je     80107350 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010735d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107362:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107365:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107368:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010736d:	50                   	push   %eax
8010736e:	e8 5d b1 ff ff       	call   801024d0 <kfree>
80107373:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107376:	39 df                	cmp    %ebx,%edi
80107378:	75 dd                	jne    80107357 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010737a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010737d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107380:	5b                   	pop    %ebx
80107381:	5e                   	pop    %esi
80107382:	5f                   	pop    %edi
80107383:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107384:	e9 47 b1 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
80107389:	83 ec 0c             	sub    $0xc,%esp
8010738c:	68 30 7c 10 80       	push   $0x80107c30
80107391:	e8 ea 8f ff ff       	call   80100380 <panic>
80107396:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010739d:	00 
8010739e:	66 90                	xchg   %ax,%ax

801073a0 <setupkvm>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	56                   	push   %esi
801073a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073a5:	e8 e6 b2 ff ff       	call   80102690 <kalloc>
801073aa:	89 c6                	mov    %eax,%esi
801073ac:	85 c0                	test   %eax,%eax
801073ae:	74 42                	je     801073f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801073b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073b8:	68 00 10 00 00       	push   $0x1000
801073bd:	6a 00                	push   $0x0
801073bf:	50                   	push   %eax
801073c0:	e8 db d3 ff ff       	call   801047a0 <memset>
801073c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073cb:	83 ec 08             	sub    $0x8,%esp
801073ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073d1:	ff 73 0c             	push   0xc(%ebx)
801073d4:	8b 13                	mov    (%ebx),%edx
801073d6:	50                   	push   %eax
801073d7:	29 c1                	sub    %eax,%ecx
801073d9:	89 f0                	mov    %esi,%eax
801073db:	e8 d0 f9 ff ff       	call   80106db0 <mappages>
801073e0:	83 c4 10             	add    $0x10,%esp
801073e3:	85 c0                	test   %eax,%eax
801073e5:	78 19                	js     80107400 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073e7:	83 c3 10             	add    $0x10,%ebx
801073ea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801073f0:	75 d6                	jne    801073c8 <setupkvm+0x28>
}
801073f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073f5:	89 f0                	mov    %esi,%eax
801073f7:	5b                   	pop    %ebx
801073f8:	5e                   	pop    %esi
801073f9:	5d                   	pop    %ebp
801073fa:	c3                   	ret
801073fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107400:	83 ec 0c             	sub    $0xc,%esp
80107403:	56                   	push   %esi
      return 0;
80107404:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107406:	e8 15 ff ff ff       	call   80107320 <freevm>
      return 0;
8010740b:	83 c4 10             	add    $0x10,%esp
}
8010740e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107411:	89 f0                	mov    %esi,%eax
80107413:	5b                   	pop    %ebx
80107414:	5e                   	pop    %esi
80107415:	5d                   	pop    %ebp
80107416:	c3                   	ret
80107417:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010741e:	00 
8010741f:	90                   	nop

80107420 <kvmalloc>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107426:	e8 75 ff ff ff       	call   801073a0 <setupkvm>
8010742b:	a3 84 5f 11 80       	mov    %eax,0x80115f84
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107430:	05 00 00 00 80       	add    $0x80000000,%eax
80107435:	0f 22 d8             	mov    %eax,%cr3
}
80107438:	c9                   	leave
80107439:	c3                   	ret
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107440 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	83 ec 08             	sub    $0x8,%esp
80107446:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107449:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010744c:	89 c1                	mov    %eax,%ecx
8010744e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107451:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107454:	f6 c2 01             	test   $0x1,%dl
80107457:	75 17                	jne    80107470 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107459:	83 ec 0c             	sub    $0xc,%esp
8010745c:	68 41 7c 10 80       	push   $0x80107c41
80107461:	e8 1a 8f ff ff       	call   80100380 <panic>
80107466:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010746d:	00 
8010746e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107470:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107473:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107479:	25 fc 0f 00 00       	and    $0xffc,%eax
8010747e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107485:	85 c0                	test   %eax,%eax
80107487:	74 d0                	je     80107459 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107489:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010748c:	c9                   	leave
8010748d:	c3                   	ret
8010748e:	66 90                	xchg   %ax,%ax

80107490 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107499:	e8 02 ff ff ff       	call   801073a0 <setupkvm>
8010749e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074a1:	85 c0                	test   %eax,%eax
801074a3:	0f 84 bd 00 00 00    	je     80107566 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074ac:	85 c9                	test   %ecx,%ecx
801074ae:	0f 84 b2 00 00 00    	je     80107566 <copyuvm+0xd6>
801074b4:	31 f6                	xor    %esi,%esi
801074b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074bd:	00 
801074be:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801074c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801074c3:	89 f0                	mov    %esi,%eax
801074c5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801074c8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801074cb:	a8 01                	test   $0x1,%al
801074cd:	75 11                	jne    801074e0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801074cf:	83 ec 0c             	sub    $0xc,%esp
801074d2:	68 4b 7c 10 80       	push   $0x80107c4b
801074d7:	e8 a4 8e ff ff       	call   80100380 <panic>
801074dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801074e0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801074e7:	c1 ea 0a             	shr    $0xa,%edx
801074ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801074f7:	85 c0                	test   %eax,%eax
801074f9:	74 d4                	je     801074cf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801074fb:	8b 00                	mov    (%eax),%eax
801074fd:	a8 01                	test   $0x1,%al
801074ff:	0f 84 9f 00 00 00    	je     801075a4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107505:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107507:	25 ff 0f 00 00       	and    $0xfff,%eax
8010750c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010750f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107515:	e8 76 b1 ff ff       	call   80102690 <kalloc>
8010751a:	89 c3                	mov    %eax,%ebx
8010751c:	85 c0                	test   %eax,%eax
8010751e:	74 64                	je     80107584 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107520:	83 ec 04             	sub    $0x4,%esp
80107523:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107529:	68 00 10 00 00       	push   $0x1000
8010752e:	57                   	push   %edi
8010752f:	50                   	push   %eax
80107530:	e8 0b d3 ff ff       	call   80104840 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107535:	58                   	pop    %eax
80107536:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010753c:	5a                   	pop    %edx
8010753d:	ff 75 e4             	push   -0x1c(%ebp)
80107540:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107545:	89 f2                	mov    %esi,%edx
80107547:	50                   	push   %eax
80107548:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010754b:	e8 60 f8 ff ff       	call   80106db0 <mappages>
80107550:	83 c4 10             	add    $0x10,%esp
80107553:	85 c0                	test   %eax,%eax
80107555:	78 21                	js     80107578 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107557:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010755d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107560:	0f 87 5a ff ff ff    	ja     801074c0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107566:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107569:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010756c:	5b                   	pop    %ebx
8010756d:	5e                   	pop    %esi
8010756e:	5f                   	pop    %edi
8010756f:	5d                   	pop    %ebp
80107570:	c3                   	ret
80107571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107578:	83 ec 0c             	sub    $0xc,%esp
8010757b:	53                   	push   %ebx
8010757c:	e8 4f af ff ff       	call   801024d0 <kfree>
      goto bad;
80107581:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107584:	83 ec 0c             	sub    $0xc,%esp
80107587:	ff 75 e0             	push   -0x20(%ebp)
8010758a:	e8 91 fd ff ff       	call   80107320 <freevm>
  return 0;
8010758f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107596:	83 c4 10             	add    $0x10,%esp
}
80107599:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010759c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010759f:	5b                   	pop    %ebx
801075a0:	5e                   	pop    %esi
801075a1:	5f                   	pop    %edi
801075a2:	5d                   	pop    %ebp
801075a3:	c3                   	ret
      panic("copyuvm: page not present");
801075a4:	83 ec 0c             	sub    $0xc,%esp
801075a7:	68 65 7c 10 80       	push   $0x80107c65
801075ac:	e8 cf 8d ff ff       	call   80100380 <panic>
801075b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075b8:	00 
801075b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075c6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075c9:	89 c1                	mov    %eax,%ecx
801075cb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075ce:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075d1:	f6 c2 01             	test   $0x1,%dl
801075d4:	0f 84 00 01 00 00    	je     801076da <uva2ka.cold>
  return &pgtab[PTX(va)];
801075da:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075dd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801075e3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801075e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801075e9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801075f0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801075f7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075fa:	05 00 00 00 80       	add    $0x80000000,%eax
801075ff:	83 fa 05             	cmp    $0x5,%edx
80107602:	ba 00 00 00 00       	mov    $0x0,%edx
80107607:	0f 45 c2             	cmovne %edx,%eax
}
8010760a:	c3                   	ret
8010760b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107610 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
80107616:	83 ec 0c             	sub    $0xc,%esp
80107619:	8b 75 14             	mov    0x14(%ebp),%esi
8010761c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010761f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107622:	85 f6                	test   %esi,%esi
80107624:	75 51                	jne    80107677 <copyout+0x67>
80107626:	e9 a5 00 00 00       	jmp    801076d0 <copyout+0xc0>
8010762b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107630:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107636:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010763c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107642:	74 75                	je     801076b9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107644:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107646:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107649:	29 c3                	sub    %eax,%ebx
8010764b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107651:	39 f3                	cmp    %esi,%ebx
80107653:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107656:	29 f8                	sub    %edi,%eax
80107658:	83 ec 04             	sub    $0x4,%esp
8010765b:	01 c1                	add    %eax,%ecx
8010765d:	53                   	push   %ebx
8010765e:	52                   	push   %edx
8010765f:	51                   	push   %ecx
80107660:	e8 db d1 ff ff       	call   80104840 <memmove>
    len -= n;
    buf += n;
80107665:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107668:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010766e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107671:	01 da                	add    %ebx,%edx
  while(len > 0){
80107673:	29 de                	sub    %ebx,%esi
80107675:	74 59                	je     801076d0 <copyout+0xc0>
  if(*pde & PTE_P){
80107677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010767a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010767c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010767e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107681:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107687:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010768a:	f6 c1 01             	test   $0x1,%cl
8010768d:	0f 84 4e 00 00 00    	je     801076e1 <copyout.cold>
  return &pgtab[PTX(va)];
80107693:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107695:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010769b:	c1 eb 0c             	shr    $0xc,%ebx
8010769e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801076a4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801076ab:	89 d9                	mov    %ebx,%ecx
801076ad:	83 e1 05             	and    $0x5,%ecx
801076b0:	83 f9 05             	cmp    $0x5,%ecx
801076b3:	0f 84 77 ff ff ff    	je     80107630 <copyout+0x20>
  }
  return 0;
}
801076b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076c1:	5b                   	pop    %ebx
801076c2:	5e                   	pop    %esi
801076c3:	5f                   	pop    %edi
801076c4:	5d                   	pop    %ebp
801076c5:	c3                   	ret
801076c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076cd:	00 
801076ce:	66 90                	xchg   %ax,%ax
801076d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076d3:	31 c0                	xor    %eax,%eax
}
801076d5:	5b                   	pop    %ebx
801076d6:	5e                   	pop    %esi
801076d7:	5f                   	pop    %edi
801076d8:	5d                   	pop    %ebp
801076d9:	c3                   	ret

801076da <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801076da:	a1 00 00 00 00       	mov    0x0,%eax
801076df:	0f 0b                	ud2

801076e1 <copyout.cold>:
801076e1:	a1 00 00 00 00       	mov    0x0,%eax
801076e6:	0f 0b                	ud2
