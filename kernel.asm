
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 31 10 80       	mov    $0x80103180,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 74 10 80       	push   $0x801074c0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 85 44 00 00       	call   801044e0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 74 10 80       	push   $0x801074c7
80100097:	50                   	push   %eax
80100098:	e8 13 43 00 00       	call   801043b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 37 45 00 00       	call   80104620 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 79 45 00 00       	call   801046e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 42 00 00       	call   801043f0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 7d 22 00 00       	call   80102400 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 74 10 80       	push   $0x801074ce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 dd 42 00 00       	call   80104490 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 37 22 00 00       	jmp    80102400 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 74 10 80       	push   $0x801074df
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 9c 42 00 00       	call   80104490 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 42 00 00       	call   80104450 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 10 44 00 00       	call   80104620 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 7f 44 00 00       	jmp    801046e0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 74 10 80       	push   $0x801074e6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 0b 16 00 00       	call   80101890 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 8f 43 00 00       	call   80104620 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 96 3d 00 00       	call   80104060 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 e0 37 00 00       	call   80103ac0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 ec 43 00 00       	call   801046e0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 14 00 00       	call   801017b0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 8e 43 00 00       	call   801046e0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 14 00 00       	call   801017b0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 62 26 00 00       	call   80102a10 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 74 10 80       	push   $0x801074ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 7f 7e 10 80 	movl   $0x80107e7f,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 23 41 00 00       	call   80104500 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 75 10 80       	push   $0x80107501
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 91 5c 00 00       	call   801060d0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 df 5b 00 00       	call   801060d0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 5b 00 00       	call   801060d0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 5b 00 00       	call   801060d0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 b7 42 00 00       	call   801047e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ea 41 00 00       	call   80104730 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 75 10 80       	push   $0x80107505
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 75 10 80 	movzbl -0x7fef8ad0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 7c 12 00 00       	call   80101890 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 00 40 00 00       	call   80104620 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 94 40 00 00       	call   801046e0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 11 00 00       	call   801017b0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 bc 3f 00 00       	call   801046e0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 75 10 80       	mov    $0x80107518,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 2b 3e 00 00       	call   80104620 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 75 10 80       	push   $0x8010751f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 f8 3d 00 00       	call   80104620 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 53 3e 00 00       	call   801046e0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 f5 38 00 00       	call   80104210 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 54 39 00 00       	jmp    801042f0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 75 10 80       	push   $0x80107528
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 0b 3b 00 00       	call   801044e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 b2 1b 00 00       	call   801025b0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:

#define LINK_LIMIT 50

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
  char pathname[LINK_LIMIT];  //???

  begin_op();
  if (read_symlink(path, pathname, LINK_LIMIT) == 0) // ??? read symlink into path
80100a16:	8d 9d f2 fe ff ff    	lea    -0x10e(%ebp),%ebx
{
80100a1c:	81 ec 3c 01 00 00    	sub    $0x13c,%esp
  struct proc *curproc = myproc();
80100a22:	e8 99 30 00 00       	call   80103ac0 <myproc>
80100a27:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  begin_op();
80100a2d:	e8 4e 24 00 00       	call   80102e80 <begin_op>
  if (read_symlink(path, pathname, LINK_LIMIT) == 0) // ??? read symlink into path
80100a32:	83 ec 04             	sub    $0x4,%esp
80100a35:	6a 32                	push   $0x32
80100a37:	53                   	push   %ebx
80100a38:	ff 75 08             	pushl  0x8(%ebp)
80100a3b:	e8 d0 4b 00 00       	call   80105610 <read_symlink>
80100a40:	83 c4 10             	add    $0x10,%esp
80100a43:	85 c0                	test   %eax,%eax
80100a45:	75 59                	jne    80100aa0 <exec+0x90>
  {
    if ((ip = namei(pathname,1)) == 0)
80100a47:	83 ec 08             	sub    $0x8,%esp
80100a4a:	6a 01                	push   $0x1
80100a4c:	53                   	push   %ebx
80100a4d:	e8 6e 17 00 00       	call   801021c0 <namei>
80100a52:	83 c4 10             	add    $0x10,%esp
80100a55:	85 c0                	test   %eax,%eax
80100a57:	89 c3                	mov    %eax,%ebx
80100a59:	0f 84 a5 01 00 00    	je     80100c04 <exec+0x1f4>
      cprintf("exec: fail\n");
      return -1;
    }
}

  ilock(ip);
80100a5f:	83 ec 0c             	sub    $0xc,%esp
80100a62:	50                   	push   %eax
80100a63:	e8 48 0d 00 00       	call   801017b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a68:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a6e:	6a 34                	push   $0x34
80100a70:	6a 00                	push   $0x0
80100a72:	50                   	push   %eax
80100a73:	53                   	push   %ebx
80100a74:	e8 d7 10 00 00       	call   80101b50 <readi>
80100a79:	83 c4 20             	add    $0x20,%esp
80100a7c:	83 f8 34             	cmp    $0x34,%eax
80100a7f:	74 2f                	je     80100ab0 <exec+0xa0>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a81:	83 ec 0c             	sub    $0xc,%esp
80100a84:	53                   	push   %ebx
80100a85:	e8 76 10 00 00       	call   80101b00 <iunlockput>
    end_op();
80100a8a:	e8 61 24 00 00       	call   80102ef0 <end_op>
80100a8f:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a9a:	5b                   	pop    %ebx
80100a9b:	5e                   	pop    %esi
80100a9c:	5f                   	pop    %edi
80100a9d:	5d                   	pop    %ebp
80100a9e:	c3                   	ret    
80100a9f:	90                   	nop
    if ((ip = namei(path,1)) == 0) // ??
80100aa0:	83 ec 08             	sub    $0x8,%esp
80100aa3:	6a 01                	push   $0x1
80100aa5:	ff 75 08             	pushl  0x8(%ebp)
80100aa8:	eb a3                	jmp    80100a4d <exec+0x3d>
80100aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100ab0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100ab7:	45 4c 46 
80100aba:	75 c5                	jne    80100a81 <exec+0x71>
  if((pgdir = setupkvm()) == 0)
80100abc:	e8 5f 67 00 00       	call   80107220 <setupkvm>
80100ac1:	85 c0                	test   %eax,%eax
80100ac3:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
80100ac9:	74 b6                	je     80100a81 <exec+0x71>
  sz = 0;
80100acb:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100acd:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ad4:	00 
80100ad5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100adb:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
80100ae1:	0f 84 94 02 00 00    	je     80100d7b <exec+0x36b>
80100ae7:	31 f6                	xor    %esi,%esi
80100ae9:	eb 7f                	jmp    80100b6a <exec+0x15a>
80100aeb:	90                   	nop
80100aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100af0:	83 bd d0 fe ff ff 01 	cmpl   $0x1,-0x130(%ebp)
80100af7:	75 63                	jne    80100b5c <exec+0x14c>
    if(ph.memsz < ph.filesz)
80100af9:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80100aff:	3b 85 e0 fe ff ff    	cmp    -0x120(%ebp),%eax
80100b05:	0f 82 86 00 00 00    	jb     80100b91 <exec+0x181>
80100b0b:	03 85 d8 fe ff ff    	add    -0x128(%ebp),%eax
80100b11:	72 7e                	jb     80100b91 <exec+0x181>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b13:	83 ec 04             	sub    $0x4,%esp
80100b16:	50                   	push   %eax
80100b17:	57                   	push   %edi
80100b18:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
80100b1e:	e8 1d 65 00 00       	call   80107040 <allocuvm>
80100b23:	83 c4 10             	add    $0x10,%esp
80100b26:	85 c0                	test   %eax,%eax
80100b28:	89 c7                	mov    %eax,%edi
80100b2a:	74 65                	je     80100b91 <exec+0x181>
    if(ph.vaddr % PGSIZE != 0)
80100b2c:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
80100b32:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b37:	75 58                	jne    80100b91 <exec+0x181>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b39:	83 ec 0c             	sub    $0xc,%esp
80100b3c:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
80100b42:	ff b5 d4 fe ff ff    	pushl  -0x12c(%ebp)
80100b48:	53                   	push   %ebx
80100b49:	50                   	push   %eax
80100b4a:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
80100b50:	e8 2b 64 00 00       	call   80106f80 <loaduvm>
80100b55:	83 c4 20             	add    $0x20,%esp
80100b58:	85 c0                	test   %eax,%eax
80100b5a:	78 35                	js     80100b91 <exec+0x181>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b63:	83 c6 01             	add    $0x1,%esi
80100b66:	39 f0                	cmp    %esi,%eax
80100b68:	7e 46                	jle    80100bb0 <exec+0x1a0>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b6a:	89 f0                	mov    %esi,%eax
80100b6c:	6a 20                	push   $0x20
80100b6e:	c1 e0 05             	shl    $0x5,%eax
80100b71:	03 85 bc fe ff ff    	add    -0x144(%ebp),%eax
80100b77:	50                   	push   %eax
80100b78:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
80100b7e:	50                   	push   %eax
80100b7f:	53                   	push   %ebx
80100b80:	e8 cb 0f 00 00       	call   80101b50 <readi>
80100b85:	83 c4 10             	add    $0x10,%esp
80100b88:	83 f8 20             	cmp    $0x20,%eax
80100b8b:	0f 84 5f ff ff ff    	je     80100af0 <exec+0xe0>
    freevm(pgdir);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
80100b9a:	e8 01 66 00 00       	call   801071a0 <freevm>
80100b9f:	83 c4 10             	add    $0x10,%esp
80100ba2:	e9 da fe ff ff       	jmp    80100a81 <exec+0x71>
80100ba7:	89 f6                	mov    %esi,%esi
80100ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100bb0:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100bb6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100bbc:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	53                   	push   %ebx
80100bc6:	e8 35 0f 00 00       	call   80101b00 <iunlockput>
  end_op();
80100bcb:	e8 20 23 00 00       	call   80102ef0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bd0:	83 c4 0c             	add    $0xc,%esp
80100bd3:	56                   	push   %esi
80100bd4:	57                   	push   %edi
80100bd5:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
80100bdb:	e8 60 64 00 00       	call   80107040 <allocuvm>
80100be0:	83 c4 10             	add    $0x10,%esp
80100be3:	85 c0                	test   %eax,%eax
80100be5:	89 c6                	mov    %eax,%esi
80100be7:	75 3a                	jne    80100c23 <exec+0x213>
    freevm(pgdir);
80100be9:	83 ec 0c             	sub    $0xc,%esp
80100bec:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
80100bf2:	e8 a9 65 00 00       	call   801071a0 <freevm>
80100bf7:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bff:	e9 93 fe ff ff       	jmp    80100a97 <exec+0x87>
      end_op();
80100c04:	e8 e7 22 00 00       	call   80102ef0 <end_op>
      cprintf("exec: fail\n");
80100c09:	83 ec 0c             	sub    $0xc,%esp
80100c0c:	68 41 75 10 80       	push   $0x80107541
80100c11:	e8 4a fa ff ff       	call   80100660 <cprintf>
      return -1;
80100c16:	83 c4 10             	add    $0x10,%esp
80100c19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c1e:	e9 74 fe ff ff       	jmp    80100a97 <exec+0x87>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c23:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c29:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c2c:	31 ff                	xor    %edi,%edi
80100c2e:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c30:	50                   	push   %eax
80100c31:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
80100c37:	e8 84 66 00 00       	call   801072c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c3f:	83 c4 10             	add    $0x10,%esp
80100c42:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c48:	8b 00                	mov    (%eax),%eax
80100c4a:	85 c0                	test   %eax,%eax
80100c4c:	74 6f                	je     80100cbd <exec+0x2ad>
80100c4e:	89 b5 bc fe ff ff    	mov    %esi,-0x144(%ebp)
80100c54:	8b b5 c0 fe ff ff    	mov    -0x140(%ebp),%esi
80100c5a:	eb 09                	jmp    80100c65 <exec+0x255>
80100c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c60:	83 ff 20             	cmp    $0x20,%edi
80100c63:	74 84                	je     80100be9 <exec+0x1d9>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c65:	83 ec 0c             	sub    $0xc,%esp
80100c68:	50                   	push   %eax
80100c69:	e8 e2 3c 00 00       	call   80104950 <strlen>
80100c6e:	f7 d0                	not    %eax
80100c70:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c72:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c75:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c76:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c79:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c7c:	e8 cf 3c 00 00       	call   80104950 <strlen>
80100c81:	83 c0 01             	add    $0x1,%eax
80100c84:	50                   	push   %eax
80100c85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c88:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c8b:	53                   	push   %ebx
80100c8c:	56                   	push   %esi
80100c8d:	e8 8e 67 00 00       	call   80107420 <copyout>
80100c92:	83 c4 20             	add    $0x20,%esp
80100c95:	85 c0                	test   %eax,%eax
80100c97:	0f 88 4c ff ff ff    	js     80100be9 <exec+0x1d9>
  for(argc = 0; argv[argc]; argc++) {
80100c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ca0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100ca7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100caa:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cb0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cb3:	85 c0                	test   %eax,%eax
80100cb5:	75 a9                	jne    80100c60 <exec+0x250>
80100cb7:	8b b5 bc fe ff ff    	mov    -0x144(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cbd:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cc4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cc6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100ccd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100cd1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cd8:	ff ff ff 
  ustack[1] = argc;
80100cdb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ce1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100ce3:	83 c0 0c             	add    $0xc,%eax
80100ce6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ce8:	50                   	push   %eax
80100ce9:	52                   	push   %edx
80100cea:	53                   	push   %ebx
80100ceb:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cf7:	e8 24 67 00 00       	call   80107420 <copyout>
80100cfc:	83 c4 10             	add    $0x10,%esp
80100cff:	85 c0                	test   %eax,%eax
80100d01:	0f 88 e2 fe ff ff    	js     80100be9 <exec+0x1d9>
  for(last=s=path; *s; s++)
80100d07:	8b 45 08             	mov    0x8(%ebp),%eax
80100d0a:	0f b6 00             	movzbl (%eax),%eax
80100d0d:	84 c0                	test   %al,%al
80100d0f:	74 17                	je     80100d28 <exec+0x318>
80100d11:	8b 55 08             	mov    0x8(%ebp),%edx
80100d14:	89 d1                	mov    %edx,%ecx
80100d16:	83 c1 01             	add    $0x1,%ecx
80100d19:	3c 2f                	cmp    $0x2f,%al
80100d1b:	0f b6 01             	movzbl (%ecx),%eax
80100d1e:	0f 44 d1             	cmove  %ecx,%edx
80100d21:	84 c0                	test   %al,%al
80100d23:	75 f1                	jne    80100d16 <exec+0x306>
80100d25:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d28:	8b bd c4 fe ff ff    	mov    -0x13c(%ebp),%edi
80100d2e:	50                   	push   %eax
80100d2f:	6a 10                	push   $0x10
80100d31:	ff 75 08             	pushl  0x8(%ebp)
80100d34:	89 f8                	mov    %edi,%eax
80100d36:	83 c0 6c             	add    $0x6c,%eax
80100d39:	50                   	push   %eax
80100d3a:	e8 d1 3b 00 00       	call   80104910 <safestrcpy>
  curproc->pgdir = pgdir;
80100d3f:	8b 95 c0 fe ff ff    	mov    -0x140(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d45:	89 f9                	mov    %edi,%ecx
80100d47:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d4a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d4d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d4f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d52:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d58:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d5b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d5e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d61:	89 0c 24             	mov    %ecx,(%esp)
80100d64:	e8 87 60 00 00       	call   80106df0 <switchuvm>
  freevm(oldpgdir);
80100d69:	89 3c 24             	mov    %edi,(%esp)
80100d6c:	e8 2f 64 00 00       	call   801071a0 <freevm>
  return 0;
80100d71:	83 c4 10             	add    $0x10,%esp
80100d74:	31 c0                	xor    %eax,%eax
80100d76:	e9 1c fd ff ff       	jmp    80100a97 <exec+0x87>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d7b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d80:	e9 3d fe ff ff       	jmp    80100bc2 <exec+0x1b2>
80100d85:	66 90                	xchg   %ax,%ax
80100d87:	66 90                	xchg   %ax,%ax
80100d89:	66 90                	xchg   %ax,%ax
80100d8b:	66 90                	xchg   %ax,%ax
80100d8d:	66 90                	xchg   %ax,%ax
80100d8f:	90                   	nop

80100d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d96:	68 4d 75 10 80       	push   $0x8010754d
80100d9b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100da0:	e8 3b 37 00 00       	call   801044e0 <initlock>
}
80100da5:	83 c4 10             	add    $0x10,%esp
80100da8:	c9                   	leave  
80100da9:	c3                   	ret    
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 5a 38 00 00       	call   80104620 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100dd9:	73 25                	jae    80100e00 <filealloc+0x50>
    if(f->ref == 0){
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100de2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100de5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dec:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df1:	e8 ea 38 00 00       	call   801046e0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100df6:	89 d8                	mov    %ebx,%eax
      return f;
80100df8:	83 c4 10             	add    $0x10,%esp
}
80100dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dfe:	c9                   	leave  
80100dff:	c3                   	ret    
  release(&ftable.lock);
80100e00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e05:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0a:	e8 d1 38 00 00       	call   801046e0 <release>
}
80100e0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e11:	83 c4 10             	add    $0x10,%esp
}
80100e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e17:	c9                   	leave  
80100e18:	c3                   	ret    
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 10             	sub    $0x10,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e2a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e2f:	e8 ec 37 00 00       	call   80104620 <acquire>
  if(f->ref < 1)
80100e34:	8b 43 04             	mov    0x4(%ebx),%eax
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	7e 1a                	jle    80100e58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e47:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e4c:	e8 8f 38 00 00       	call   801046e0 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 54 75 10 80       	push   $0x80107554
80100e60:	e8 2b f5 ff ff       	call   80100390 <panic>
80100e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 28             	sub    $0x28,%esp
80100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e81:	e8 9a 37 00 00       	call   80104620 <acquire>
  if(f->ref < 1)
80100e86:	8b 43 04             	mov    0x4(%ebx),%eax
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	85 c0                	test   %eax,%eax
80100e8e:	0f 8e 9b 00 00 00    	jle    80100f2f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e94:	83 e8 01             	sub    $0x1,%eax
80100e97:	85 c0                	test   %eax,%eax
80100e99:	89 43 04             	mov    %eax,0x4(%ebx)
80100e9c:	74 1a                	je     80100eb8 <fileclose+0x48>
    release(&ftable.lock);
80100e9e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea8:	5b                   	pop    %ebx
80100ea9:	5e                   	pop    %esi
80100eaa:	5f                   	pop    %edi
80100eab:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eac:	e9 2f 38 00 00       	jmp    801046e0 <release>
80100eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100eb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ebc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ebe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ec1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ec4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ecd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ed0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ed8:	e8 03 38 00 00       	call   801046e0 <release>
  if(ff.type == FD_PIPE)
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	83 ff 01             	cmp    $0x1,%edi
80100ee3:	74 13                	je     80100ef8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ee5:	83 ff 02             	cmp    $0x2,%edi
80100ee8:	74 26                	je     80100f10 <fileclose+0xa0>
}
80100eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eed:	5b                   	pop    %ebx
80100eee:	5e                   	pop    %esi
80100eef:	5f                   	pop    %edi
80100ef0:	5d                   	pop    %ebp
80100ef1:	c3                   	ret    
80100ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ef8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100efc:	83 ec 08             	sub    $0x8,%esp
80100eff:	53                   	push   %ebx
80100f00:	56                   	push   %esi
80100f01:	e8 2a 27 00 00       	call   80103630 <pipeclose>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb df                	jmp    80100eea <fileclose+0x7a>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f10:	e8 6b 1f 00 00       	call   80102e80 <begin_op>
    iput(ff.ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 75 e0             	pushl  -0x20(%ebp)
80100f1b:	e8 c0 09 00 00       	call   801018e0 <iput>
    end_op();
80100f20:	83 c4 10             	add    $0x10,%esp
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
    end_op();
80100f2a:	e9 c1 1f 00 00       	jmp    80102ef0 <end_op>
    panic("fileclose");
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	68 5c 75 10 80       	push   $0x8010755c
80100f37:	e8 54 f4 ff ff       	call   80100390 <panic>
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f4a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f4d:	75 31                	jne    80100f80 <filestat+0x40>
    ilock(f->ip);
80100f4f:	83 ec 0c             	sub    $0xc,%esp
80100f52:	ff 73 10             	pushl  0x10(%ebx)
80100f55:	e8 56 08 00 00       	call   801017b0 <ilock>
    stati(f->ip, st);
80100f5a:	58                   	pop    %eax
80100f5b:	5a                   	pop    %edx
80100f5c:	ff 75 0c             	pushl  0xc(%ebp)
80100f5f:	ff 73 10             	pushl  0x10(%ebx)
80100f62:	e8 b9 0b 00 00       	call   80101b20 <stati>
    iunlock(f->ip);
80100f67:	59                   	pop    %ecx
80100f68:	ff 73 10             	pushl  0x10(%ebx)
80100f6b:	e8 20 09 00 00       	call   80101890 <iunlock>
    return 0;
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f85:	eb ee                	jmp    80100f75 <filestat+0x35>
80100f87:	89 f6                	mov    %esi,%esi
80100f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f90 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 0c             	sub    $0xc,%esp
80100f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fa2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fa6:	74 60                	je     80101008 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fa8:	8b 03                	mov    (%ebx),%eax
80100faa:	83 f8 01             	cmp    $0x1,%eax
80100fad:	74 41                	je     80100ff0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100faf:	83 f8 02             	cmp    $0x2,%eax
80100fb2:	75 5b                	jne    8010100f <fileread+0x7f>
    ilock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 73 10             	pushl  0x10(%ebx)
80100fba:	e8 f1 07 00 00       	call   801017b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fbf:	57                   	push   %edi
80100fc0:	ff 73 14             	pushl  0x14(%ebx)
80100fc3:	56                   	push   %esi
80100fc4:	ff 73 10             	pushl  0x10(%ebx)
80100fc7:	e8 84 0b 00 00       	call   80101b50 <readi>
80100fcc:	83 c4 20             	add    $0x20,%esp
80100fcf:	85 c0                	test   %eax,%eax
80100fd1:	89 c6                	mov    %eax,%esi
80100fd3:	7e 03                	jle    80100fd8 <fileread+0x48>
      f->off += r;
80100fd5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 73 10             	pushl  0x10(%ebx)
80100fde:	e8 ad 08 00 00       	call   80101890 <iunlock>
    return r;
80100fe3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	89 f0                	mov    %esi,%eax
80100feb:	5b                   	pop    %ebx
80100fec:	5e                   	pop    %esi
80100fed:	5f                   	pop    %edi
80100fee:	5d                   	pop    %ebp
80100fef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ff0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100ff3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	5b                   	pop    %ebx
80100ffa:	5e                   	pop    %esi
80100ffb:	5f                   	pop    %edi
80100ffc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100ffd:	e9 de 27 00 00       	jmp    801037e0 <piperead>
80101002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010100d:	eb d7                	jmp    80100fe6 <fileread+0x56>
  panic("fileread");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 66 75 10 80       	push   $0x80107566
80101017:	e8 74 f3 ff ff       	call   80100390 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 1c             	sub    $0x1c,%esp
80101029:	8b 75 08             	mov    0x8(%ebp),%esi
8010102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010102f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101033:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101036:	8b 45 10             	mov    0x10(%ebp),%eax
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010103c:	0f 84 aa 00 00 00    	je     801010ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 06                	mov    (%esi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c3 00 00 00    	je     80101110 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d9 00 00 00    	jne    8010112f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101059:	31 ff                	xor    %edi,%edi
    while(i < n){
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 34                	jg     80101093 <filewrite+0x73>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101068:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101071:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101074:	e8 17 08 00 00       	call   80101890 <iunlock>
      end_op();
80101079:	e8 72 1e 00 00       	call   80102ef0 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101081:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101084:	39 c3                	cmp    %eax,%ebx
80101086:	0f 85 96 00 00 00    	jne    80101122 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010108c:	01 df                	add    %ebx,%edi
    while(i < n){
8010108e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101091:	7e 6d                	jle    80101100 <filewrite+0xe0>
      int n1 = n - i;
80101093:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101096:	b8 00 06 00 00       	mov    $0x600,%eax
8010109b:	29 fb                	sub    %edi,%ebx
8010109d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010a6:	e8 d5 1d 00 00       	call   80102e80 <begin_op>
      ilock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
801010b1:	e8 fa 06 00 00       	call   801017b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b9:	53                   	push   %ebx
801010ba:	ff 76 14             	pushl  0x14(%esi)
801010bd:	01 f8                	add    %edi,%eax
801010bf:	50                   	push   %eax
801010c0:	ff 76 10             	pushl  0x10(%esi)
801010c3:	e8 88 0b 00 00       	call   80101c50 <writei>
801010c8:	83 c4 20             	add    $0x20,%esp
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 99                	jg     80101068 <filewrite+0x48>
      iunlock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 76 10             	pushl  0x10(%esi)
801010d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010d8:	e8 b3 07 00 00       	call   80101890 <iunlock>
      end_op();
801010dd:	e8 0e 1e 00 00       	call   80102ef0 <end_op>
      if(r < 0)
801010e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	85 c0                	test   %eax,%eax
801010ea:	74 98                	je     80101084 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010f4:	89 f8                	mov    %edi,%eax
801010f6:	5b                   	pop    %ebx
801010f7:	5e                   	pop    %esi
801010f8:	5f                   	pop    %edi
801010f9:	5d                   	pop    %ebp
801010fa:	c3                   	ret    
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101100:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101103:	75 e7                	jne    801010ec <filewrite+0xcc>
}
80101105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101108:	89 f8                	mov    %edi,%eax
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
8010110f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101110:	8b 46 0c             	mov    0xc(%esi),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010111d:	e9 ae 25 00 00       	jmp    801036d0 <pipewrite>
        panic("short filewrite");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 6f 75 10 80       	push   $0x8010756f
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 75 75 10 80       	push   $0x80107575
80101137:	e8 54 f2 ff ff       	call   80100390 <panic>
8010113c:	66 90                	xchg   %ax,%ax
8010113e:	66 90                	xchg   %ax,%ax

80101140 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	56                   	push   %esi
80101144:	53                   	push   %ebx
80101145:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101147:	c1 ea 0c             	shr    $0xc,%edx
8010114a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101150:	83 ec 08             	sub    $0x8,%esp
80101153:	52                   	push   %edx
80101154:	50                   	push   %eax
80101155:	e8 76 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010115a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010115c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010115f:	ba 01 00 00 00       	mov    $0x1,%edx
80101164:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101167:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010116d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101170:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101172:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101177:	85 d1                	test   %edx,%ecx
80101179:	74 25                	je     801011a0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010117b:	f7 d2                	not    %edx
8010117d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101182:	21 ca                	and    %ecx,%edx
80101184:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101188:	56                   	push   %esi
80101189:	e8 c2 1e 00 00       	call   80103050 <log_write>
  brelse(bp);
8010118e:	89 34 24             	mov    %esi,(%esp)
80101191:	e8 4a f0 ff ff       	call   801001e0 <brelse>
}
80101196:	83 c4 10             	add    $0x10,%esp
80101199:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010119c:	5b                   	pop    %ebx
8010119d:	5e                   	pop    %esi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    
    panic("freeing free block");
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 7f 75 10 80       	push   $0x8010757f
801011a8:	e8 e3 f1 ff ff       	call   80100390 <panic>
801011ad:	8d 76 00             	lea    0x0(%esi),%esi

801011b0 <balloc>:
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011b9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ee:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011f3:	83 c4 10             	add    $0x10,%esp
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101202:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101205:	bb 01 00 00 00       	mov    $0x1,%ebx
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	85 df                	test   %ebx,%edi
8010121b:	89 fa                	mov    %edi,%edx
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 a4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 92 75 10 80       	push   $0x80107592
80101259:	e8 32 f1 ff ff       	call   80100390 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 de 1d 00 00       	call   80103050 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
80101285:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101287:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128a:	83 c4 0c             	add    $0xc,%esp
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 96 34 00 00       	call   80104730 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 ae 1d 00 00       	call   80103050 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 36 ef ff ff       	call   801001e0 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 09 11 80       	push   $0x801109e0
801012da:	e8 41 33 00 00       	call   80104620 <acquire>
801012df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012e5:	eb 17                	jmp    801012fe <iget+0x3e>
801012e7:	89 f6                	mov    %esi,%esi
801012e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012f0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801012f6:	81 fb fc 26 11 80    	cmp    $0x801126fc,%ebx
801012fc:	73 22                	jae    80101320 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101301:	85 c9                	test   %ecx,%ecx
80101303:	7e 04                	jle    80101309 <iget+0x49>
80101305:	39 3b                	cmp    %edi,(%ebx)
80101307:	74 4f                	je     80101358 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e3                	jne    801012f0 <iget+0x30>
8010130d:	85 c9                	test   %ecx,%ecx
8010130f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101312:	81 c3 94 00 00 00    	add    $0x94,%ebx
80101318:	81 fb fc 26 11 80    	cmp    $0x801126fc,%ebx
8010131e:	72 de                	jb     801012fe <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 5b                	je     8010137f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101324:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101327:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101329:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010132c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101333:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010133a:	68 e0 09 11 80       	push   $0x801109e0
8010133f:	e8 9c 33 00 00       	call   801046e0 <release>

  return ip;
80101344:	83 c4 10             	add    $0x10,%esp
}
80101347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134a:	89 f0                	mov    %esi,%eax
8010134c:	5b                   	pop    %ebx
8010134d:	5e                   	pop    %esi
8010134e:	5f                   	pop    %edi
8010134f:	5d                   	pop    %ebp
80101350:	c3                   	ret    
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101358:	39 53 04             	cmp    %edx,0x4(%ebx)
8010135b:	75 ac                	jne    80101309 <iget+0x49>
      release(&icache.lock);
8010135d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101360:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101363:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101365:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010136a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010136d:	e8 6e 33 00 00       	call   801046e0 <release>
      return ip;
80101372:	83 c4 10             	add    $0x10,%esp
}
80101375:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101378:	89 f0                	mov    %esi,%eax
8010137a:	5b                   	pop    %ebx
8010137b:	5e                   	pop    %esi
8010137c:	5f                   	pop    %edi
8010137d:	5d                   	pop    %ebp
8010137e:	c3                   	ret    
    panic("iget: no inodes");
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	68 a8 75 10 80       	push   $0x801075a8
80101387:	e8 04 f0 ff ff       	call   80100390 <panic>
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	89 c6                	mov    %eax,%esi
80101398:	83 ec 1c             	sub    $0x1c,%esp
  // cprintf("bmap started\n");
  uint addr, *a, offset;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	77 20                	ja     801013c0 <bmap+0x30>
801013a0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013a3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013a6:	85 db                	test   %ebx,%ebx
801013a8:	0f 84 e2 00 00 00    	je     80101490 <bmap+0x100>
    brelse(bp);
    return addr;    
  }

  panic("bmap: out of range");
}
801013ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b1:	89 d8                	mov    %ebx,%eax
801013b3:	5b                   	pop    %ebx
801013b4:	5e                   	pop    %esi
801013b5:	5f                   	pop    %edi
801013b6:	5d                   	pop    %ebp
801013b7:	c3                   	ret    
801013b8:	90                   	nop
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013c0:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013c3:	83 fb 7f             	cmp    $0x7f,%ebx
801013c6:	0f 86 84 00 00 00    	jbe    80101450 <bmap+0xc0>
  bn -= NINDIRECT;
801013cc:	8d 9a 74 ff ff ff    	lea    -0x8c(%edx),%ebx
  if(bn < NDINDIRECT){
801013d2:	81 fb ff 3f 00 00    	cmp    $0x3fff,%ebx
801013d8:	0f 87 7e 01 00 00    	ja     8010155c <bmap+0x1cc>
    if((addr = ip->addrs[NDIRECT+1]) == 0) 
801013de:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801013e4:	8b 00                	mov    (%eax),%eax
801013e6:	85 d2                	test   %edx,%edx
801013e8:	0f 84 5a 01 00 00    	je     80101548 <bmap+0x1b8>
    bp = bread(ip->dev, addr); // panic
801013ee:	83 ec 08             	sub    $0x8,%esp
    offset = bn % 128;
801013f1:	89 df                	mov    %ebx,%edi
    bn = bn / 128;
801013f3:	c1 eb 07             	shr    $0x7,%ebx
    bp = bread(ip->dev, addr); // panic
801013f6:	52                   	push   %edx
801013f7:	50                   	push   %eax
    offset = bn % 128;
801013f8:	83 e7 7f             	and    $0x7f,%edi
    bp = bread(ip->dev, addr); // panic
801013fb:	e8 d0 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0) {
80101400:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
80101404:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr); // panic
80101407:	89 c1                	mov    %eax,%ecx
    if((addr = a[bn]) == 0) {
80101409:	8b 1a                	mov    (%edx),%ebx
8010140b:	85 db                	test   %ebx,%ebx
8010140d:	0f 84 ed 00 00 00    	je     80101500 <bmap+0x170>
    brelse(bp);
80101413:	83 ec 0c             	sub    $0xc,%esp
80101416:	51                   	push   %ecx
80101417:	e8 c4 ed ff ff       	call   801001e0 <brelse>
    bp = bread(ip->dev, addr);
8010141c:	58                   	pop    %eax
8010141d:	5a                   	pop    %edx
8010141e:	53                   	push   %ebx
8010141f:	ff 36                	pushl  (%esi)
80101421:	e8 aa ec ff ff       	call   801000d0 <bread>
    if((addr = a[offset]) == 0){
80101426:	8d 7c b8 5c          	lea    0x5c(%eax,%edi,4),%edi
8010142a:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
8010142d:	89 c2                	mov    %eax,%edx
    if((addr = a[offset]) == 0){
8010142f:	8b 1f                	mov    (%edi),%ebx
80101431:	85 db                	test   %ebx,%ebx
80101433:	74 7b                	je     801014b0 <bmap+0x120>
    brelse(bp);
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	52                   	push   %edx
80101439:	e8 a2 ed ff ff       	call   801001e0 <brelse>
8010143e:	83 c4 10             	add    $0x10,%esp
}
80101441:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101444:	89 d8                	mov    %ebx,%eax
80101446:	5b                   	pop    %ebx
80101447:	5e                   	pop    %esi
80101448:	5f                   	pop    %edi
80101449:	5d                   	pop    %ebp
8010144a:	c3                   	ret    
8010144b:	90                   	nop
8010144c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101456:	8b 00                	mov    (%eax),%eax
80101458:	85 d2                	test   %edx,%edx
8010145a:	0f 84 d0 00 00 00    	je     80101530 <bmap+0x1a0>
    bp = bread(ip->dev, addr);
80101460:	83 ec 08             	sub    $0x8,%esp
80101463:	52                   	push   %edx
80101464:	50                   	push   %eax
80101465:	e8 66 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010146a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010146e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101471:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101473:	8b 1a                	mov    (%edx),%ebx
80101475:	85 db                	test   %ebx,%ebx
80101477:	74 5f                	je     801014d8 <bmap+0x148>
    brelse(bp);
80101479:	83 ec 0c             	sub    $0xc,%esp
8010147c:	57                   	push   %edi
8010147d:	e8 5e ed ff ff       	call   801001e0 <brelse>
80101482:	83 c4 10             	add    $0x10,%esp
}
80101485:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101488:	89 d8                	mov    %ebx,%eax
8010148a:	5b                   	pop    %ebx
8010148b:	5e                   	pop    %esi
8010148c:	5f                   	pop    %edi
8010148d:	5d                   	pop    %ebp
8010148e:	c3                   	ret    
8010148f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101490:	8b 00                	mov    (%eax),%eax
80101492:	e8 19 fd ff ff       	call   801011b0 <balloc>
80101497:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010149a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010149d:	89 c3                	mov    %eax,%ebx
}
8010149f:	89 d8                	mov    %ebx,%eax
801014a1:	5b                   	pop    %ebx
801014a2:	5e                   	pop    %esi
801014a3:	5f                   	pop    %edi
801014a4:	5d                   	pop    %ebp
801014a5:	c3                   	ret    
801014a6:	8d 76 00             	lea    0x0(%esi),%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[offset] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 f6 fc ff ff       	call   801011b0 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[offset] = addr = balloc(ip->dev);
801014c0:	89 07                	mov    %eax,(%edi)
801014c2:	89 c3                	mov    %eax,%ebx
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 86 1b 00 00       	call   80103050 <log_write>
801014ca:	83 c4 10             	add    $0x10,%esp
801014cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014d0:	e9 60 ff ff ff       	jmp    80101435 <bmap+0xa5>
801014d5:	8d 76 00             	lea    0x0(%esi),%esi
      a[bn] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014dd:	e8 ce fc ff ff       	call   801011b0 <balloc>
801014e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014e5:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e8:	89 c3                	mov    %eax,%ebx
801014ea:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014ec:	57                   	push   %edi
801014ed:	e8 5e 1b 00 00       	call   80103050 <log_write>
801014f2:	83 c4 10             	add    $0x10,%esp
801014f5:	eb 82                	jmp    80101479 <bmap+0xe9>
801014f7:	89 f6                	mov    %esi,%esi
801014f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101503:	8b 06                	mov    (%esi),%eax
80101505:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101508:	e8 a3 fc ff ff       	call   801011b0 <balloc>
      log_write(bp);
8010150d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      a[bn] = addr = balloc(ip->dev);
80101510:	8b 55 e0             	mov    -0x20(%ebp),%edx
      log_write(bp);
80101513:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101516:	89 c3                	mov    %eax,%ebx
80101518:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010151a:	51                   	push   %ecx
8010151b:	e8 30 1b 00 00       	call   80103050 <log_write>
80101520:	83 c4 10             	add    $0x10,%esp
80101523:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101526:	e9 e8 fe ff ff       	jmp    80101413 <bmap+0x83>
8010152b:	90                   	nop
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101530:	e8 7b fc ff ff       	call   801011b0 <balloc>
80101535:	89 c2                	mov    %eax,%edx
80101537:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010153d:	8b 06                	mov    (%esi),%eax
8010153f:	e9 1c ff ff ff       	jmp    80101460 <bmap+0xd0>
80101544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
80101548:	e8 63 fc ff ff       	call   801011b0 <balloc>
8010154d:	89 c2                	mov    %eax,%edx
8010154f:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
80101555:	8b 06                	mov    (%esi),%eax
80101557:	e9 92 fe ff ff       	jmp    801013ee <bmap+0x5e>
  panic("bmap: out of range");
8010155c:	83 ec 0c             	sub    $0xc,%esp
8010155f:	68 b8 75 10 80       	push   $0x801075b8
80101564:	e8 27 ee ff ff       	call   80100390 <panic>
80101569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	pushl  0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
80101585:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101587:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158a:	83 c4 0c             	add    $0xc,%esp
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 4a 32 00 00       	call   801047e0 <memmove>
  brelse(bp);
80101596:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101599:	83 c4 10             	add    $0x10,%esp
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 39 ec ff ff       	jmp    801001e0 <brelse>
801015a7:	89 f6                	mov    %esi,%esi
801015a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801015b0 <iinit>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801015b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015bc:	68 cb 75 10 80       	push   $0x801075cb
801015c1:	68 e0 09 11 80       	push   $0x801109e0
801015c6:	e8 15 2f 00 00       	call   801044e0 <initlock>
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 d2 75 10 80       	push   $0x801075d2
801015d8:	53                   	push   %ebx
801015d9:	81 c3 94 00 00 00    	add    $0x94,%ebx
801015df:	e8 cc 2d 00 00       	call   801043b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	81 fb 08 27 11 80    	cmp    $0x80112708,%ebx
801015ed:	75 e1                	jne    801015d0 <iinit+0x20>
  readsb(dev, &sb);
801015ef:	83 ec 08             	sub    $0x8,%esp
801015f2:	68 c0 09 11 80       	push   $0x801109c0
801015f7:	ff 75 08             	pushl  0x8(%ebp)
801015fa:	e8 71 ff ff ff       	call   80101570 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015ff:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101605:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010160b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101611:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101617:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010161d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101623:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101629:	68 38 76 10 80       	push   $0x80107638
8010162e:	e8 2d f0 ff ff       	call   80100660 <cprintf>
}
80101633:	83 c4 30             	add    $0x30,%esp
80101636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101639:	c9                   	leave  
8010163a:	c3                   	ret    
8010163b:	90                   	nop
8010163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101640 <ialloc>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	57                   	push   %edi
80101644:	56                   	push   %esi
80101645:	53                   	push   %ebx
80101646:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101650:	8b 45 0c             	mov    0xc(%ebp),%eax
80101653:	8b 75 08             	mov    0x8(%ebp),%esi
80101656:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101659:	0f 86 94 00 00 00    	jbe    801016f3 <ialloc+0xb3>
8010165f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101664:	eb 21                	jmp    80101687 <ialloc+0x47>
80101666:	8d 76 00             	lea    0x0(%esi),%esi
80101669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101670:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101673:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101676:	57                   	push   %edi
80101677:	e8 64 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010167c:	83 c4 10             	add    $0x10,%esp
8010167f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101685:	76 6c                	jbe    801016f3 <ialloc+0xb3>
    bp = bread(dev, IBLOCK(inum, sb));
80101687:	89 d8                	mov    %ebx,%eax
80101689:	83 ec 08             	sub    $0x8,%esp
8010168c:	c1 e8 02             	shr    $0x2,%eax
8010168f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101695:	50                   	push   %eax
80101696:	56                   	push   %esi
80101697:	e8 34 ea ff ff       	call   801000d0 <bread>
8010169c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010169e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801016a0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801016a3:	83 e0 03             	and    $0x3,%eax
801016a6:	c1 e0 07             	shl    $0x7,%eax
801016a9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016b1:	75 bd                	jne    80101670 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016b3:	83 ec 04             	sub    $0x4,%esp
801016b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016b9:	68 80 00 00 00       	push   $0x80
801016be:	6a 00                	push   $0x0
801016c0:	51                   	push   %ecx
801016c1:	e8 6a 30 00 00       	call   80104730 <memset>
      dip->type = type;
801016c6:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016ca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016cd:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016d0:	89 3c 24             	mov    %edi,(%esp)
801016d3:	e8 78 19 00 00       	call   80103050 <log_write>
      brelse(bp);
801016d8:	89 3c 24             	mov    %edi,(%esp)
801016db:	e8 00 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801016e0:	83 c4 10             	add    $0x10,%esp
}
801016e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016e6:	89 da                	mov    %ebx,%edx
801016e8:	89 f0                	mov    %esi,%eax
}
801016ea:	5b                   	pop    %ebx
801016eb:	5e                   	pop    %esi
801016ec:	5f                   	pop    %edi
801016ed:	5d                   	pop    %ebp
      return iget(dev, inum);
801016ee:	e9 cd fb ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
801016f3:	83 ec 0c             	sub    $0xc,%esp
801016f6:	68 d8 75 10 80       	push   $0x801075d8
801016fb:	e8 90 ec ff ff       	call   80100390 <panic>

80101700 <iupdate>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101708:	83 ec 08             	sub    $0x8,%esp
8010170b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101711:	c1 e8 02             	shr    $0x2,%eax
80101714:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010171a:	50                   	push   %eax
8010171b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010171e:	e8 ad e9 ff ff       	call   801000d0 <bread>
80101723:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101725:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101728:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010172f:	83 e0 03             	and    $0x3,%eax
80101732:	c1 e0 07             	shl    $0x7,%eax
80101735:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101739:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010173c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101740:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101743:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101747:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010174b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010174f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101753:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101757:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010175a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010175d:	6a 38                	push   $0x38
8010175f:	53                   	push   %ebx
80101760:	50                   	push   %eax
80101761:	e8 7a 30 00 00       	call   801047e0 <memmove>
  log_write(bp);
80101766:	89 34 24             	mov    %esi,(%esp)
80101769:	e8 e2 18 00 00       	call   80103050 <log_write>
  brelse(bp);
8010176e:	89 75 08             	mov    %esi,0x8(%ebp)
80101771:	83 c4 10             	add    $0x10,%esp
}
80101774:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101777:	5b                   	pop    %ebx
80101778:	5e                   	pop    %esi
80101779:	5d                   	pop    %ebp
  brelse(bp);
8010177a:	e9 61 ea ff ff       	jmp    801001e0 <brelse>
8010177f:	90                   	nop

80101780 <idup>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	53                   	push   %ebx
80101784:	83 ec 10             	sub    $0x10,%esp
80101787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010178a:	68 e0 09 11 80       	push   $0x801109e0
8010178f:	e8 8c 2e 00 00       	call   80104620 <acquire>
  ip->ref++;
80101794:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101798:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010179f:	e8 3c 2f 00 00       	call   801046e0 <release>
}
801017a4:	89 d8                	mov    %ebx,%eax
801017a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017a9:	c9                   	leave  
801017aa:	c3                   	ret    
801017ab:	90                   	nop
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017b0 <ilock>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017b8:	85 db                	test   %ebx,%ebx
801017ba:	0f 84 b7 00 00 00    	je     80101877 <ilock+0xc7>
801017c0:	8b 53 08             	mov    0x8(%ebx),%edx
801017c3:	85 d2                	test   %edx,%edx
801017c5:	0f 8e ac 00 00 00    	jle    80101877 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801017ce:	83 ec 0c             	sub    $0xc,%esp
801017d1:	50                   	push   %eax
801017d2:	e8 19 2c 00 00       	call   801043f0 <acquiresleep>
  if(ip->valid == 0){
801017d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017da:	83 c4 10             	add    $0x10,%esp
801017dd:	85 c0                	test   %eax,%eax
801017df:	74 0f                	je     801017f0 <ilock+0x40>
}
801017e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017e4:	5b                   	pop    %ebx
801017e5:	5e                   	pop    %esi
801017e6:	5d                   	pop    %ebp
801017e7:	c3                   	ret    
801017e8:	90                   	nop
801017e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017f0:	8b 43 04             	mov    0x4(%ebx),%eax
801017f3:	83 ec 08             	sub    $0x8,%esp
801017f6:	c1 e8 02             	shr    $0x2,%eax
801017f9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017ff:	50                   	push   %eax
80101800:	ff 33                	pushl  (%ebx)
80101802:	e8 c9 e8 ff ff       	call   801000d0 <bread>
80101807:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101809:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180f:	83 e0 03             	and    $0x3,%eax
80101812:	c1 e0 07             	shl    $0x7,%eax
80101815:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101819:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010181c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010181f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101823:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101827:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010182b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010182f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101833:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101837:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010183b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010183e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101841:	6a 38                	push   $0x38
80101843:	50                   	push   %eax
80101844:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101847:	50                   	push   %eax
80101848:	e8 93 2f 00 00       	call   801047e0 <memmove>
    brelse(bp);
8010184d:	89 34 24             	mov    %esi,(%esp)
80101850:	e8 8b e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101855:	83 c4 10             	add    $0x10,%esp
80101858:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010185d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101864:	0f 85 77 ff ff ff    	jne    801017e1 <ilock+0x31>
      panic("ilock: no type");
8010186a:	83 ec 0c             	sub    $0xc,%esp
8010186d:	68 f0 75 10 80       	push   $0x801075f0
80101872:	e8 19 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101877:	83 ec 0c             	sub    $0xc,%esp
8010187a:	68 ea 75 10 80       	push   $0x801075ea
8010187f:	e8 0c eb ff ff       	call   80100390 <panic>
80101884:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010188a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101890 <iunlock>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101898:	85 db                	test   %ebx,%ebx
8010189a:	74 28                	je     801018c4 <iunlock+0x34>
8010189c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010189f:	83 ec 0c             	sub    $0xc,%esp
801018a2:	56                   	push   %esi
801018a3:	e8 e8 2b 00 00       	call   80104490 <holdingsleep>
801018a8:	83 c4 10             	add    $0x10,%esp
801018ab:	85 c0                	test   %eax,%eax
801018ad:	74 15                	je     801018c4 <iunlock+0x34>
801018af:	8b 43 08             	mov    0x8(%ebx),%eax
801018b2:	85 c0                	test   %eax,%eax
801018b4:	7e 0e                	jle    801018c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018bc:	5b                   	pop    %ebx
801018bd:	5e                   	pop    %esi
801018be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018bf:	e9 8c 2b 00 00       	jmp    80104450 <releasesleep>
    panic("iunlock");
801018c4:	83 ec 0c             	sub    $0xc,%esp
801018c7:	68 ff 75 10 80       	push   $0x801075ff
801018cc:	e8 bf ea ff ff       	call   80100390 <panic>
801018d1:	eb 0d                	jmp    801018e0 <iput>
801018d3:	90                   	nop
801018d4:	90                   	nop
801018d5:	90                   	nop
801018d6:	90                   	nop
801018d7:	90                   	nop
801018d8:	90                   	nop
801018d9:	90                   	nop
801018da:	90                   	nop
801018db:	90                   	nop
801018dc:	90                   	nop
801018dd:	90                   	nop
801018de:	90                   	nop
801018df:	90                   	nop

801018e0 <iput>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	57                   	push   %edi
801018e4:	56                   	push   %esi
801018e5:	53                   	push   %ebx
801018e6:	83 ec 38             	sub    $0x38,%esp
801018e9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801018ec:	8d 46 0c             	lea    0xc(%esi),%eax
801018ef:	50                   	push   %eax
801018f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801018f3:	e8 f8 2a 00 00       	call   801043f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018f8:	8b 56 4c             	mov    0x4c(%esi),%edx
801018fb:	83 c4 10             	add    $0x10,%esp
801018fe:	85 d2                	test   %edx,%edx
80101900:	74 07                	je     80101909 <iput+0x29>
80101902:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101907:	74 31                	je     8010193a <iput+0x5a>
  releasesleep(&ip->lock);
80101909:	83 ec 0c             	sub    $0xc,%esp
8010190c:	ff 75 e0             	pushl  -0x20(%ebp)
8010190f:	e8 3c 2b 00 00       	call   80104450 <releasesleep>
  acquire(&icache.lock);
80101914:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010191b:	e8 00 2d 00 00       	call   80104620 <acquire>
  ip->ref--;
80101920:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
8010192e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101931:	5b                   	pop    %ebx
80101932:	5e                   	pop    %esi
80101933:	5f                   	pop    %edi
80101934:	5d                   	pop    %ebp
  release(&icache.lock);
80101935:	e9 a6 2d 00 00       	jmp    801046e0 <release>
    acquire(&icache.lock);
8010193a:	83 ec 0c             	sub    $0xc,%esp
8010193d:	68 e0 09 11 80       	push   $0x801109e0
80101942:	e8 d9 2c 00 00       	call   80104620 <acquire>
    int r = ip->ref;
80101947:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010194a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101951:	e8 8a 2d 00 00       	call   801046e0 <release>
    if(r == 1){
80101956:	83 c4 10             	add    $0x10,%esp
80101959:	83 fb 01             	cmp    $0x1,%ebx
8010195c:	75 ab                	jne    80101909 <iput+0x29>
8010195e:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101961:	8d be 8c 00 00 00    	lea    0x8c(%esi),%edi
80101967:	eb 0e                	jmp    80101977 <iput+0x97>
80101969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101970:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp, *bpp;
  uint *a, *b;

  for(i = 0; i < NDIRECT; i++){
80101973:	39 fb                	cmp    %edi,%ebx
80101975:	74 15                	je     8010198c <iput+0xac>
    if(ip->addrs[i]){
80101977:	8b 13                	mov    (%ebx),%edx
80101979:	85 d2                	test   %edx,%edx
8010197b:	74 f3                	je     80101970 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010197d:	8b 06                	mov    (%esi),%eax
8010197f:	e8 bc f7 ff ff       	call   80101140 <bfree>
      ip->addrs[i] = 0;
80101984:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010198a:	eb e4                	jmp    80101970 <iput+0x90>
    }
  }

  if(ip->addrs[NDIRECT]){
8010198c:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101992:	85 c0                	test   %eax,%eax
80101994:	0f 85 fd 00 00 00    	jne    80101a97 <iput+0x1b7>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  if(ip->addrs[NDIRECT+1]){ // i?
8010199a:	8b 86 90 00 00 00    	mov    0x90(%esi),%eax
801019a0:	85 c0                	test   %eax,%eax
801019a2:	75 2d                	jne    801019d1 <iput+0xf1>
    brelse(bp);
    bfree(ip->dev,  ip->addrs[NINDIRECT]);
    ip->addrs[NINDIRECT] = 0;
  }
  ip->size = 0;
  iupdate(ip);
801019a4:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019a7:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801019ae:	56                   	push   %esi
801019af:	e8 4c fd ff ff       	call   80101700 <iupdate>
      ip->type = 0;
801019b4:	31 c0                	xor    %eax,%eax
801019b6:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801019ba:	89 34 24             	mov    %esi,(%esp)
801019bd:	e8 3e fd ff ff       	call   80101700 <iupdate>
      ip->valid = 0;
801019c2:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801019c9:	83 c4 10             	add    $0x10,%esp
801019cc:	e9 38 ff ff ff       	jmp    80101909 <iput+0x29>
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
801019d1:	83 ec 08             	sub    $0x8,%esp
801019d4:	50                   	push   %eax
801019d5:	ff 36                	pushl  (%esi)
801019d7:	e8 f4 e6 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
801019dc:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
801019df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801019e2:	05 5c 02 00 00       	add    $0x25c,%eax
801019e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801019ea:	83 c4 10             	add    $0x10,%esp
    a = (uint*)bp->data;
801019ed:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801019f0:	eb 12                	jmp    80101a04 <iput+0x124>
801019f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019f8:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
801019fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    for(i = 0; i < NINDIRECT; i++){
801019ff:	39 45 dc             	cmp    %eax,-0x24(%ebp)
80101a02:	74 69                	je     80101a6d <iput+0x18d>
      if(a[i])
80101a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a07:	8b 00                	mov    (%eax),%eax
80101a09:	85 c0                	test   %eax,%eax
80101a0b:	74 eb                	je     801019f8 <iput+0x118>
        bpp = bread(ip->dev, a[i]);
80101a0d:	83 ec 08             	sub    $0x8,%esp
80101a10:	50                   	push   %eax
80101a11:	ff 36                	pushl  (%esi)
80101a13:	e8 b8 e6 ff ff       	call   801000d0 <bread>
80101a18:	83 c4 10             	add    $0x10,%esp
80101a1b:	89 45 d8             	mov    %eax,-0x28(%ebp)
        b = (uint*)bpp->data;
80101a1e:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101a21:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
80101a27:	eb 0e                	jmp    80101a37 <iput+0x157>
80101a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a30:	83 c3 04             	add    $0x4,%ebx
        for(j=0; j < NINDIRECT; j++)
80101a33:	39 df                	cmp    %ebx,%edi
80101a35:	74 14                	je     80101a4b <iput+0x16b>
          if(b[j])
80101a37:	8b 13                	mov    (%ebx),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x150>
            bfree(ip->dev, b[j]);
80101a3d:	8b 06                	mov    (%esi),%eax
80101a3f:	83 c3 04             	add    $0x4,%ebx
80101a42:	e8 f9 f6 ff ff       	call   80101140 <bfree>
        for(j=0; j < NINDIRECT; j++)
80101a47:	39 df                	cmp    %ebx,%edi
80101a49:	75 ec                	jne    80101a37 <iput+0x157>
        brelse(bpp);
80101a4b:	83 ec 0c             	sub    $0xc,%esp
80101a4e:	ff 75 d8             	pushl  -0x28(%ebp)
80101a51:	e8 8a e7 ff ff       	call   801001e0 <brelse>
        bfree(ip->dev, a[i]);
80101a56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a59:	8b 06                	mov    (%esi),%eax
80101a5b:	8b 17                	mov    (%edi),%edx
80101a5d:	e8 de f6 ff ff       	call   80101140 <bfree>
        a[i] = 0;
80101a62:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80101a68:	83 c4 10             	add    $0x10,%esp
80101a6b:	eb 8b                	jmp    801019f8 <iput+0x118>
    brelse(bp);
80101a6d:	83 ec 0c             	sub    $0xc,%esp
80101a70:	ff 75 d4             	pushl  -0x2c(%ebp)
80101a73:	e8 68 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev,  ip->addrs[NINDIRECT]);
80101a78:	8b 96 5c 02 00 00    	mov    0x25c(%esi),%edx
80101a7e:	8b 06                	mov    (%esi),%eax
80101a80:	e8 bb f6 ff ff       	call   80101140 <bfree>
    ip->addrs[NINDIRECT] = 0;
80101a85:	c7 86 5c 02 00 00 00 	movl   $0x0,0x25c(%esi)
80101a8c:	00 00 00 
80101a8f:	83 c4 10             	add    $0x10,%esp
80101a92:	e9 0d ff ff ff       	jmp    801019a4 <iput+0xc4>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a97:	83 ec 08             	sub    $0x8,%esp
80101a9a:	50                   	push   %eax
80101a9b:	ff 36                	pushl  (%esi)
80101a9d:	e8 2e e6 ff ff       	call   801000d0 <bread>
80101aa2:	83 c4 10             	add    $0x10,%esp
80101aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101aa8:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101aab:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
80101ab1:	eb 0c                	jmp    80101abf <iput+0x1df>
80101ab3:	90                   	nop
80101ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ab8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101abb:	39 fb                	cmp    %edi,%ebx
80101abd:	74 0f                	je     80101ace <iput+0x1ee>
      if(a[j])
80101abf:	8b 13                	mov    (%ebx),%edx
80101ac1:	85 d2                	test   %edx,%edx
80101ac3:	74 f3                	je     80101ab8 <iput+0x1d8>
        bfree(ip->dev, a[j]);
80101ac5:	8b 06                	mov    (%esi),%eax
80101ac7:	e8 74 f6 ff ff       	call   80101140 <bfree>
80101acc:	eb ea                	jmp    80101ab8 <iput+0x1d8>
    brelse(bp);
80101ace:	83 ec 0c             	sub    $0xc,%esp
80101ad1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ad4:	e8 07 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ad9:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101adf:	8b 06                	mov    (%esi),%eax
80101ae1:	e8 5a f6 ff ff       	call   80101140 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ae6:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101aed:	00 00 00 
80101af0:	83 c4 10             	add    $0x10,%esp
80101af3:	e9 a2 fe ff ff       	jmp    8010199a <iput+0xba>
80101af8:	90                   	nop
80101af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b00 <iunlockput>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	53                   	push   %ebx
80101b04:	83 ec 10             	sub    $0x10,%esp
80101b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b0a:	53                   	push   %ebx
80101b0b:	e8 80 fd ff ff       	call   80101890 <iunlock>
  iput(ip);
80101b10:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b13:	83 c4 10             	add    $0x10,%esp
}
80101b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b19:	c9                   	leave  
  iput(ip);
80101b1a:	e9 c1 fd ff ff       	jmp    801018e0 <iput>
80101b1f:	90                   	nop

80101b20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	8b 55 08             	mov    0x8(%ebp),%edx
80101b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b29:	8b 0a                	mov    (%edx),%ecx
80101b2b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b2e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b31:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b34:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b38:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b3b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b3f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b43:	8b 52 58             	mov    0x58(%edx),%edx
80101b46:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b49:	5d                   	pop    %ebp
80101b4a:	c3                   	ret    
80101b4b:	90                   	nop
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b50 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	57                   	push   %edi
80101b54:	56                   	push   %esi
80101b55:	53                   	push   %ebx
80101b56:	83 ec 1c             	sub    $0x1c,%esp
80101b59:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b67:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b70:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b73:	0f 84 a7 00 00 00    	je     80101c20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7c:	8b 40 58             	mov    0x58(%eax),%eax
80101b7f:	39 c6                	cmp    %eax,%esi
80101b81:	0f 87 ba 00 00 00    	ja     80101c41 <readi+0xf1>
80101b87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b8a:	89 f9                	mov    %edi,%ecx
80101b8c:	01 f1                	add    %esi,%ecx
80101b8e:	0f 82 ad 00 00 00    	jb     80101c41 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b94:	89 c2                	mov    %eax,%edx
80101b96:	29 f2                	sub    %esi,%edx
80101b98:	39 c8                	cmp    %ecx,%eax
80101b9a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9d:	31 ff                	xor    %edi,%edi
80101b9f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101ba1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ba4:	74 6c                	je     80101c12 <readi+0xc2>
80101ba6:	8d 76 00             	lea    0x0(%esi),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bb0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101bb3:	89 f2                	mov    %esi,%edx
80101bb5:	c1 ea 09             	shr    $0x9,%edx
80101bb8:	89 d8                	mov    %ebx,%eax
80101bba:	e8 d1 f7 ff ff       	call   80101390 <bmap>
80101bbf:	83 ec 08             	sub    $0x8,%esp
80101bc2:	50                   	push   %eax
80101bc3:	ff 33                	pushl  (%ebx)
80101bc5:	e8 06 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bcd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bcf:	89 f0                	mov    %esi,%eax
80101bd1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bd6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdb:	83 c4 0c             	add    $0xc,%esp
80101bde:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101be0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101be4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	29 fb                	sub    %edi,%ebx
80101be9:	39 d9                	cmp    %ebx,%ecx
80101beb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bee:	53                   	push   %ebx
80101bef:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bf2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bf7:	e8 e4 2b 00 00       	call   801047e0 <memmove>
    brelse(bp);
80101bfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bff:	89 14 24             	mov    %edx,(%esp)
80101c02:	e8 d9 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c07:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c0a:	83 c4 10             	add    $0x10,%esp
80101c0d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c10:	77 9e                	ja     80101bb0 <readi+0x60>
  }
  // if(off/BSIZE >= 140)
  //   cprintf("after bmap in writei  \n");

  return n;
80101c12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c18:	5b                   	pop    %ebx
80101c19:	5e                   	pop    %esi
80101c1a:	5f                   	pop    %edi
80101c1b:	5d                   	pop    %ebp
80101c1c:	c3                   	ret    
80101c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c24:	66 83 f8 09          	cmp    $0x9,%ax
80101c28:	77 17                	ja     80101c41 <readi+0xf1>
80101c2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101c31:	85 c0                	test   %eax,%eax
80101c33:	74 0c                	je     80101c41 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3b:	5b                   	pop    %ebx
80101c3c:	5e                   	pop    %esi
80101c3d:	5f                   	pop    %edi
80101c3e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c3f:	ff e0                	jmp    *%eax
      return -1;
80101c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c46:	eb cd                	jmp    80101c15 <readi+0xc5>
80101c48:	90                   	nop
80101c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c73:	0f 84 b7 00 00 00    	je     80101d30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c7f:	0f 82 eb 00 00 00    	jb     80101d70 <writei+0x120>
80101c85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c88:	31 d2                	xor    %edx,%edx
80101c8a:	89 f8                	mov    %edi,%eax
80101c8c:	01 f0                	add    %esi,%eax
80101c8e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c91:	3d 00 18 81 00       	cmp    $0x811800,%eax
80101c96:	0f 87 d4 00 00 00    	ja     80101d70 <writei+0x120>
80101c9c:	85 d2                	test   %edx,%edx
80101c9e:	0f 85 cc 00 00 00    	jne    80101d70 <writei+0x120>
    return -1;
  

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca4:	85 ff                	test   %edi,%edi
80101ca6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cad:	74 72                	je     80101d21 <writei+0xd1>
80101caf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101cb3:	89 f2                	mov    %esi,%edx
80101cb5:	c1 ea 09             	shr    $0x9,%edx
80101cb8:	89 f8                	mov    %edi,%eax
80101cba:	e8 d1 f6 ff ff       	call   80101390 <bmap>
80101cbf:	83 ec 08             	sub    $0x8,%esp
80101cc2:	50                   	push   %eax
80101cc3:	ff 37                	pushl  (%edi)
80101cc5:	e8 06 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cca:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ccd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cd0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cd2:	89 f0                	mov    %esi,%eax
80101cd4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cd9:	83 c4 0c             	add    $0xc,%esp
80101cdc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ce1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ce3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ce7:	39 d9                	cmp    %ebx,%ecx
80101ce9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cec:	53                   	push   %ebx
80101ced:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cf2:	50                   	push   %eax
80101cf3:	e8 e8 2a 00 00       	call   801047e0 <memmove>
    log_write(bp);
80101cf8:	89 3c 24             	mov    %edi,(%esp)
80101cfb:	e8 50 13 00 00       	call   80103050 <log_write>
    brelse(bp);
80101d00:	89 3c 24             	mov    %edi,(%esp)
80101d03:	e8 d8 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d08:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d0b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d0e:	83 c4 10             	add    $0x10,%esp
80101d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d14:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d17:	77 97                	ja     80101cb0 <writei+0x60>
  }
  
  if(n > 0 && off > ip->size){
80101d19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d1c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d1f:	77 37                	ja     80101d58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d27:	5b                   	pop    %ebx
80101d28:	5e                   	pop    %esi
80101d29:	5f                   	pop    %edi
80101d2a:	5d                   	pop    %ebp
80101d2b:	c3                   	ret    
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d34:	66 83 f8 09          	cmp    $0x9,%ax
80101d38:	77 36                	ja     80101d70 <writei+0x120>
80101d3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101d41:	85 c0                	test   %eax,%eax
80101d43:	74 2b                	je     80101d70 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d4b:	5b                   	pop    %ebx
80101d4c:	5e                   	pop    %esi
80101d4d:	5f                   	pop    %edi
80101d4e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d4f:	ff e0                	jmp    *%eax
80101d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d5b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d61:	50                   	push   %eax
80101d62:	e8 99 f9 ff ff       	call   80101700 <iupdate>
80101d67:	83 c4 10             	add    $0x10,%esp
80101d6a:	eb b5                	jmp    80101d21 <writei+0xd1>
80101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d75:	eb ad                	jmp    80101d24 <writei+0xd4>
80101d77:	89 f6                	mov    %esi,%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d86:	6a 0e                	push   $0xe
80101d88:	ff 75 0c             	pushl  0xc(%ebp)
80101d8b:	ff 75 08             	pushl  0x8(%ebp)
80101d8e:	e8 bd 2a 00 00       	call   80104850 <strncmp>
}
80101d93:	c9                   	leave  
80101d94:	c3                   	ret    
80101d95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101da0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	83 ec 1c             	sub    $0x1c,%esp
80101da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101db1:	0f 85 85 00 00 00    	jne    80101e3c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101db7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dba:	31 ff                	xor    %edi,%edi
80101dbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dbf:	85 d2                	test   %edx,%edx
80101dc1:	74 3e                	je     80101e01 <dirlookup+0x61>
80101dc3:	90                   	nop
80101dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dc8:	6a 10                	push   $0x10
80101dca:	57                   	push   %edi
80101dcb:	56                   	push   %esi
80101dcc:	53                   	push   %ebx
80101dcd:	e8 7e fd ff ff       	call   80101b50 <readi>
80101dd2:	83 c4 10             	add    $0x10,%esp
80101dd5:	83 f8 10             	cmp    $0x10,%eax
80101dd8:	75 55                	jne    80101e2f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101dda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ddf:	74 18                	je     80101df9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101de1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101de4:	83 ec 04             	sub    $0x4,%esp
80101de7:	6a 0e                	push   $0xe
80101de9:	50                   	push   %eax
80101dea:	ff 75 0c             	pushl  0xc(%ebp)
80101ded:	e8 5e 2a 00 00       	call   80104850 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101df2:	83 c4 10             	add    $0x10,%esp
80101df5:	85 c0                	test   %eax,%eax
80101df7:	74 17                	je     80101e10 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101df9:	83 c7 10             	add    $0x10,%edi
80101dfc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dff:	72 c7                	jb     80101dc8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e04:	31 c0                	xor    %eax,%eax
}
80101e06:	5b                   	pop    %ebx
80101e07:	5e                   	pop    %esi
80101e08:	5f                   	pop    %edi
80101e09:	5d                   	pop    %ebp
80101e0a:	c3                   	ret    
80101e0b:	90                   	nop
80101e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101e10:	8b 45 10             	mov    0x10(%ebp),%eax
80101e13:	85 c0                	test   %eax,%eax
80101e15:	74 05                	je     80101e1c <dirlookup+0x7c>
        *poff = off;
80101e17:	8b 45 10             	mov    0x10(%ebp),%eax
80101e1a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e1c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e20:	8b 03                	mov    (%ebx),%eax
80101e22:	e8 99 f4 ff ff       	call   801012c0 <iget>
}
80101e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e2a:	5b                   	pop    %ebx
80101e2b:	5e                   	pop    %esi
80101e2c:	5f                   	pop    %edi
80101e2d:	5d                   	pop    %ebp
80101e2e:	c3                   	ret    
      panic("dirlookup read");
80101e2f:	83 ec 0c             	sub    $0xc,%esp
80101e32:	68 19 76 10 80       	push   $0x80107619
80101e37:	e8 54 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	68 07 76 10 80       	push   $0x80107607
80101e44:	e8 47 e5 ff ff       	call   80100390 <panic>
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(struct inode *root, char *path, int nameiparent, char *name, int depth, int cont)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	81 ec ac 00 00 00    	sub    $0xac,%esp
  // cprintf("namex was called, path: %s, name: %s\n", path, name);
  struct inode *ip, *next;
  char buf[128];
  char tname[DIRSIZ];

  if(depth > MAX_DEREFERENCE)
80101e5c:	83 7d 0c 20          	cmpl   $0x20,0xc(%ebp)
{
80101e60:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
  if(depth > MAX_DEREFERENCE)
80101e66:	0f 84 75 02 00 00    	je     801020e1 <namex+0x291>
    return 0;

  if(*path == '/')
80101e6c:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101e6f:	89 d3                	mov    %edx,%ebx
80101e71:	0f 84 16 02 00 00    	je     8010208d <namex+0x23d>
    ip = iget(ROOTDEV, ROOTINO);
  else if(root)
80101e77:	85 c0                	test   %eax,%eax
80101e79:	89 c6                	mov    %eax,%esi
80101e7b:	0f 84 ff 01 00 00    	je     80102080 <namex+0x230>
  acquire(&icache.lock);
80101e81:	83 ec 0c             	sub    $0xc,%esp
80101e84:	68 e0 09 11 80       	push   $0x801109e0
80101e89:	e8 92 27 00 00       	call   80104620 <acquire>
  ip->ref++;
80101e8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e92:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101e99:	e8 42 28 00 00       	call   801046e0 <release>
80101e9e:	83 c4 10             	add    $0x10,%esp
80101ea1:	eb 08                	jmp    80101eab <namex+0x5b>
80101ea3:	90                   	nop
80101ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ea8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eab:	0f b6 03             	movzbl (%ebx),%eax
80101eae:	3c 2f                	cmp    $0x2f,%al
80101eb0:	74 f6                	je     80101ea8 <namex+0x58>
  if(*path == 0)
80101eb2:	84 c0                	test   %al,%al
80101eb4:	0f 84 86 01 00 00    	je     80102040 <namex+0x1f0>
  while(*path != '/' && *path != 0)
80101eba:	0f b6 03             	movzbl (%ebx),%eax
80101ebd:	84 c0                	test   %al,%al
80101ebf:	0f 84 db 00 00 00    	je     80101fa0 <namex+0x150>
80101ec5:	3c 2f                	cmp    $0x2f,%al
80101ec7:	89 df                	mov    %ebx,%edi
80101ec9:	75 09                	jne    80101ed4 <namex+0x84>
80101ecb:	e9 d0 00 00 00       	jmp    80101fa0 <namex+0x150>
80101ed0:	84 c0                	test   %al,%al
80101ed2:	74 0a                	je     80101ede <namex+0x8e>
    path++;
80101ed4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101ed7:	0f b6 07             	movzbl (%edi),%eax
80101eda:	3c 2f                	cmp    $0x2f,%al
80101edc:	75 f2                	jne    80101ed0 <namex+0x80>
80101ede:	89 fa                	mov    %edi,%edx
80101ee0:	29 da                	sub    %ebx,%edx
  if(len >= DIRSIZ)
80101ee2:	83 fa 0d             	cmp    $0xd,%edx
80101ee5:	0f 8e b9 00 00 00    	jle    80101fa4 <namex+0x154>
    memmove(name, s, DIRSIZ);
80101eeb:	83 ec 04             	sub    $0x4,%esp
80101eee:	6a 0e                	push   $0xe
80101ef0:	53                   	push   %ebx
    path++;
80101ef1:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101ef3:	ff 75 08             	pushl  0x8(%ebp)
80101ef6:	e8 e5 28 00 00       	call   801047e0 <memmove>
80101efb:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101efe:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f01:	75 0d                	jne    80101f10 <namex+0xc0>
80101f03:	90                   	nop
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f08:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f0b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f0e:	74 f8                	je     80101f08 <namex+0xb8>
    ip = idup(root);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f10:	83 ec 0c             	sub    $0xc,%esp
80101f13:	56                   	push   %esi
80101f14:	e8 97 f8 ff ff       	call   801017b0 <ilock>
    if(ip->type != T_DIR){
80101f19:	83 c4 10             	add    $0x10,%esp
80101f1c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f21:	0f 85 39 01 00 00    	jne    80102060 <namex+0x210>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f27:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
80101f2d:	85 c9                	test   %ecx,%ecx
80101f2f:	74 09                	je     80101f3a <namex+0xea>
80101f31:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f34:	0f 84 69 01 00 00    	je     801020a3 <namex+0x253>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f3a:	83 ec 04             	sub    $0x4,%esp
80101f3d:	6a 00                	push   $0x0
80101f3f:	ff 75 08             	pushl  0x8(%ebp)
80101f42:	56                   	push   %esi
80101f43:	e8 58 fe ff ff       	call   80101da0 <dirlookup>
80101f48:	83 c4 10             	add    $0x10,%esp
80101f4b:	85 c0                	test   %eax,%eax
80101f4d:	89 c7                	mov    %eax,%edi
80101f4f:	0f 84 0b 01 00 00    	je     80102060 <namex+0x210>
      iunlockput(ip);
      return 0;
    }
    iunlock(ip);
80101f55:	83 ec 0c             	sub    $0xc,%esp
80101f58:	56                   	push   %esi
80101f59:	e8 32 f9 ff ff       	call   80101890 <iunlock>
    ilock(next);
80101f5e:	89 3c 24             	mov    %edi,(%esp)
80101f61:	e8 4a f8 ff ff       	call   801017b0 <ilock>
    if(next->type == T_SYMLINK && cont) {
80101f66:	83 c4 10             	add    $0x10,%esp
80101f69:	66 83 7f 50 04       	cmpw   $0x4,0x50(%edi)
80101f6e:	75 07                	jne    80101f77 <namex+0x127>
80101f70:	8b 55 10             	mov    0x10(%ebp),%edx
80101f73:	85 d2                	test   %edx,%edx
80101f75:	75 59                	jne    80101fd0 <namex+0x180>
      iunlockput(next);
      next = namex(next, buf, 0, tname, depth + 1, cont);
    }
    else
    {
      iunlock(next);
80101f77:	83 ec 0c             	sub    $0xc,%esp
80101f7a:	57                   	push   %edi
80101f7b:	e8 10 f9 ff ff       	call   80101890 <iunlock>
80101f80:	83 c4 10             	add    $0x10,%esp
    }
    iput(ip);
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	56                   	push   %esi
    ip = next;
80101f87:	89 fe                	mov    %edi,%esi
    iput(ip);
80101f89:	e8 52 f9 ff ff       	call   801018e0 <iput>
    ip = next;
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	e9 15 ff ff ff       	jmp    80101eab <namex+0x5b>
80101f96:	8d 76 00             	lea    0x0(%esi),%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while(*path != '/' && *path != 0)
80101fa0:	89 df                	mov    %ebx,%edi
80101fa2:	31 d2                	xor    %edx,%edx
    memmove(name, s, len);
80101fa4:	83 ec 04             	sub    $0x4,%esp
80101fa7:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
80101fad:	52                   	push   %edx
80101fae:	53                   	push   %ebx
    name[len] = 0;
80101faf:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fb1:	ff 75 08             	pushl  0x8(%ebp)
80101fb4:	e8 27 28 00 00       	call   801047e0 <memmove>
    name[len] = 0;
80101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbc:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
80101fc2:	83 c4 10             	add    $0x10,%esp
80101fc5:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
80101fc9:	e9 30 ff ff ff       	jmp    80101efe <namex+0xae>
80101fce:	66 90                	xchg   %ax,%ax
      if(next->size >= sizeof(buf) || readi(next, buf, 0, next->size) != next->size){
80101fd0:	8b 47 58             	mov    0x58(%edi),%eax
80101fd3:	83 f8 7f             	cmp    $0x7f,%eax
80101fd6:	0f 87 dd 00 00 00    	ja     801020b9 <namex+0x269>
80101fdc:	50                   	push   %eax
80101fdd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80101fe3:	6a 00                	push   $0x0
80101fe5:	50                   	push   %eax
80101fe6:	57                   	push   %edi
80101fe7:	e8 64 fb ff ff       	call   80101b50 <readi>
80101fec:	83 c4 10             	add    $0x10,%esp
80101fef:	3b 47 58             	cmp    0x58(%edi),%eax
80101ff2:	0f 85 c1 00 00 00    	jne    801020b9 <namex+0x269>
  iunlock(ip);
80101ff8:	83 ec 0c             	sub    $0xc,%esp
      buf[next->size] = 0;
80101ffb:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
80102002:	00 
  iunlock(ip);
80102003:	57                   	push   %edi
80102004:	e8 87 f8 ff ff       	call   80101890 <iunlock>
  iput(ip);
80102009:	89 3c 24             	mov    %edi,(%esp)
8010200c:	e8 cf f8 ff ff       	call   801018e0 <iput>
      next = namex(next, buf, 0, tname, depth + 1, cont);
80102011:	8b 45 0c             	mov    0xc(%ebp),%eax
80102014:	83 c4 0c             	add    $0xc,%esp
80102017:	ff 75 10             	pushl  0x10(%ebp)
8010201a:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
80102020:	31 c9                	xor    %ecx,%ecx
80102022:	83 c0 01             	add    $0x1,%eax
80102025:	50                   	push   %eax
80102026:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
8010202c:	50                   	push   %eax
8010202d:	89 f8                	mov    %edi,%eax
8010202f:	e8 1c fe ff ff       	call   80101e50 <namex>
80102034:	83 c4 10             	add    $0x10,%esp
80102037:	89 c7                	mov    %eax,%edi
80102039:	e9 45 ff ff ff       	jmp    80101f83 <namex+0x133>
8010203e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80102040:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
80102046:	85 c0                	test   %eax,%eax
80102048:	0f 85 9a 00 00 00    	jne    801020e8 <namex+0x298>
    iput(ip);
    return 0;
  }
  return ip;
}
8010204e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102051:	89 f0                	mov    %esi,%eax
80102053:	5b                   	pop    %ebx
80102054:	5e                   	pop    %esi
80102055:	5f                   	pop    %edi
80102056:	5d                   	pop    %ebp
80102057:	c3                   	ret    
80102058:	90                   	nop
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102060:	83 ec 0c             	sub    $0xc,%esp
80102063:	56                   	push   %esi
80102064:	e8 27 f8 ff ff       	call   80101890 <iunlock>
  iput(ip);
80102069:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010206c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010206e:	e8 6d f8 ff ff       	call   801018e0 <iput>
      return 0;
80102073:	83 c4 10             	add    $0x10,%esp
}
80102076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102079:	89 f0                	mov    %esi,%eax
8010207b:	5b                   	pop    %ebx
8010207c:	5e                   	pop    %esi
8010207d:	5f                   	pop    %edi
8010207e:	5d                   	pop    %ebp
8010207f:	c3                   	ret    
    ip = idup(myproc()->cwd);
80102080:	e8 3b 1a 00 00       	call   80103ac0 <myproc>
80102085:	8b 70 68             	mov    0x68(%eax),%esi
80102088:	e9 f4 fd ff ff       	jmp    80101e81 <namex+0x31>
    ip = iget(ROOTDEV, ROOTINO);
8010208d:	ba 01 00 00 00       	mov    $0x1,%edx
80102092:	b8 01 00 00 00       	mov    $0x1,%eax
80102097:	e8 24 f2 ff ff       	call   801012c0 <iget>
8010209c:	89 c6                	mov    %eax,%esi
8010209e:	e9 08 fe ff ff       	jmp    80101eab <namex+0x5b>
      iunlock(ip);
801020a3:	83 ec 0c             	sub    $0xc,%esp
801020a6:	56                   	push   %esi
801020a7:	e8 e4 f7 ff ff       	call   80101890 <iunlock>
      return ip;
801020ac:	83 c4 10             	add    $0x10,%esp
}
801020af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b2:	89 f0                	mov    %esi,%eax
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
  iunlock(ip);
801020b9:	83 ec 0c             	sub    $0xc,%esp
801020bc:	57                   	push   %edi
801020bd:	e8 ce f7 ff ff       	call   80101890 <iunlock>
  iput(ip);
801020c2:	89 3c 24             	mov    %edi,(%esp)
801020c5:	e8 16 f8 ff ff       	call   801018e0 <iput>
        iput(ip);
801020ca:	89 34 24             	mov    %esi,(%esp)
        return 0;
801020cd:	31 f6                	xor    %esi,%esi
        iput(ip);
801020cf:	e8 0c f8 ff ff       	call   801018e0 <iput>
        return 0;
801020d4:	83 c4 10             	add    $0x10,%esp
}
801020d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020da:	89 f0                	mov    %esi,%eax
801020dc:	5b                   	pop    %ebx
801020dd:	5e                   	pop    %esi
801020de:	5f                   	pop    %edi
801020df:	5d                   	pop    %ebp
801020e0:	c3                   	ret    
    return 0;
801020e1:	31 f6                	xor    %esi,%esi
801020e3:	e9 66 ff ff ff       	jmp    8010204e <namex+0x1fe>
    iput(ip);
801020e8:	83 ec 0c             	sub    $0xc,%esp
801020eb:	56                   	push   %esi
    return 0;
801020ec:	31 f6                	xor    %esi,%esi
    iput(ip);
801020ee:	e8 ed f7 ff ff       	call   801018e0 <iput>
    return 0;
801020f3:	83 c4 10             	add    $0x10,%esp
801020f6:	e9 53 ff ff ff       	jmp    8010204e <namex+0x1fe>
801020fb:	90                   	nop
801020fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102100 <dirlink>:
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 20             	sub    $0x20,%esp
80102109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010210c:	6a 00                	push   $0x0
8010210e:	ff 75 0c             	pushl  0xc(%ebp)
80102111:	53                   	push   %ebx
80102112:	e8 89 fc ff ff       	call   80101da0 <dirlookup>
80102117:	83 c4 10             	add    $0x10,%esp
8010211a:	85 c0                	test   %eax,%eax
8010211c:	75 67                	jne    80102185 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010211e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102121:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102124:	85 ff                	test   %edi,%edi
80102126:	74 29                	je     80102151 <dirlink+0x51>
80102128:	31 ff                	xor    %edi,%edi
8010212a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010212d:	eb 09                	jmp    80102138 <dirlink+0x38>
8010212f:	90                   	nop
80102130:	83 c7 10             	add    $0x10,%edi
80102133:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102136:	73 19                	jae    80102151 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102138:	6a 10                	push   $0x10
8010213a:	57                   	push   %edi
8010213b:	56                   	push   %esi
8010213c:	53                   	push   %ebx
8010213d:	e8 0e fa ff ff       	call   80101b50 <readi>
80102142:	83 c4 10             	add    $0x10,%esp
80102145:	83 f8 10             	cmp    $0x10,%eax
80102148:	75 4e                	jne    80102198 <dirlink+0x98>
    if(de.inum == 0)
8010214a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010214f:	75 df                	jne    80102130 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102151:	8d 45 da             	lea    -0x26(%ebp),%eax
80102154:	83 ec 04             	sub    $0x4,%esp
80102157:	6a 0e                	push   $0xe
80102159:	ff 75 0c             	pushl  0xc(%ebp)
8010215c:	50                   	push   %eax
8010215d:	e8 4e 27 00 00       	call   801048b0 <strncpy>
  de.inum = inum;
80102162:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102165:	6a 10                	push   $0x10
80102167:	57                   	push   %edi
80102168:	56                   	push   %esi
80102169:	53                   	push   %ebx
  de.inum = inum;
8010216a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010216e:	e8 dd fa ff ff       	call   80101c50 <writei>
80102173:	83 c4 20             	add    $0x20,%esp
80102176:	83 f8 10             	cmp    $0x10,%eax
80102179:	75 2a                	jne    801021a5 <dirlink+0xa5>
  return 0;
8010217b:	31 c0                	xor    %eax,%eax
}
8010217d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102180:	5b                   	pop    %ebx
80102181:	5e                   	pop    %esi
80102182:	5f                   	pop    %edi
80102183:	5d                   	pop    %ebp
80102184:	c3                   	ret    
    iput(ip);
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	50                   	push   %eax
80102189:	e8 52 f7 ff ff       	call   801018e0 <iput>
    return -1;
8010218e:	83 c4 10             	add    $0x10,%esp
80102191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102196:	eb e5                	jmp    8010217d <dirlink+0x7d>
      panic("dirlink read");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 28 76 10 80       	push   $0x80107628
801021a0:	e8 eb e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 26 7c 10 80       	push   $0x80107c26
801021ad:	e8 de e1 ff ff       	call   80100390 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <namei>:

struct inode*
namei(char *path, int cont)
{
801021c0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(0, path, 0, name, 0, cont);
801021c1:	31 c9                	xor    %ecx,%ecx
{
801021c3:	89 e5                	mov    %esp,%ebp
801021c5:	83 ec 1c             	sub    $0x1c,%esp
  return namex(0, path, 0, name, 0, cont);
801021c8:	8d 45 ea             	lea    -0x16(%ebp),%eax
801021cb:	8b 55 08             	mov    0x8(%ebp),%edx
801021ce:	ff 75 0c             	pushl  0xc(%ebp)
801021d1:	6a 00                	push   $0x0
801021d3:	50                   	push   %eax
801021d4:	31 c0                	xor    %eax,%eax
801021d6:	e8 75 fc ff ff       	call   80101e50 <namex>
}
801021db:	c9                   	leave  
801021dc:	c3                   	ret    
801021dd:	8d 76 00             	lea    0x0(%esi),%esi

801021e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021e0:	55                   	push   %ebp
  return namex(0, path, 1, name, 0, 1);
801021e1:	b9 01 00 00 00       	mov    $0x1,%ecx
801021e6:	31 c0                	xor    %eax,%eax
{
801021e8:	89 e5                	mov    %esp,%ebp
801021ea:	83 ec 0c             	sub    $0xc,%esp
  return namex(0, path, 1, name, 0, 1);
801021ed:	8b 55 08             	mov    0x8(%ebp),%edx
801021f0:	6a 01                	push   $0x1
801021f2:	6a 00                	push   $0x0
801021f4:	ff 75 0c             	pushl  0xc(%ebp)
801021f7:	e8 54 fc ff ff       	call   80101e50 <namex>
}
801021fc:	c9                   	leave  
801021fd:	c3                   	ret    
801021fe:	66 90                	xchg   %ax,%ax

80102200 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	57                   	push   %edi
80102204:	56                   	push   %esi
80102205:	53                   	push   %ebx
80102206:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102209:	85 c0                	test   %eax,%eax
8010220b:	0f 84 b4 00 00 00    	je     801022c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102211:	8b 58 08             	mov    0x8(%eax),%ebx
80102214:	89 c6                	mov    %eax,%esi
80102216:	81 fb ff 7f 00 00    	cmp    $0x7fff,%ebx
8010221c:	0f 87 96 00 00 00    	ja     801022b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102222:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102227:	89 f6                	mov    %esi,%esi
80102229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102230:	89 ca                	mov    %ecx,%edx
80102232:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102233:	83 e0 c0             	and    $0xffffffc0,%eax
80102236:	3c 40                	cmp    $0x40,%al
80102238:	75 f6                	jne    80102230 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010223a:	31 ff                	xor    %edi,%edi
8010223c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102241:	89 f8                	mov    %edi,%eax
80102243:	ee                   	out    %al,(%dx)
80102244:	b8 01 00 00 00       	mov    $0x1,%eax
80102249:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010224e:	ee                   	out    %al,(%dx)
8010224f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102254:	89 d8                	mov    %ebx,%eax
80102256:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102257:	89 d8                	mov    %ebx,%eax
80102259:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010225e:	c1 f8 08             	sar    $0x8,%eax
80102261:	ee                   	out    %al,(%dx)
80102262:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102267:	89 f8                	mov    %edi,%eax
80102269:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010226a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010226e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102273:	c1 e0 04             	shl    $0x4,%eax
80102276:	83 e0 10             	and    $0x10,%eax
80102279:	83 c8 e0             	or     $0xffffffe0,%eax
8010227c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010227d:	f6 06 04             	testb  $0x4,(%esi)
80102280:	75 16                	jne    80102298 <idestart+0x98>
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 ca                	mov    %ecx,%edx
80102289:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010228a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010228d:	5b                   	pop    %ebx
8010228e:	5e                   	pop    %esi
8010228f:	5f                   	pop    %edi
80102290:	5d                   	pop    %ebp
80102291:	c3                   	ret    
80102292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102298:	b8 30 00 00 00       	mov    $0x30,%eax
8010229d:	89 ca                	mov    %ecx,%edx
8010229f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022a5:	83 c6 5c             	add    $0x5c,%esi
801022a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ad:	fc                   	cld    
801022ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022b3:	5b                   	pop    %ebx
801022b4:	5e                   	pop    %esi
801022b5:	5f                   	pop    %edi
801022b6:	5d                   	pop    %ebp
801022b7:	c3                   	ret    
    panic("incorrect blockno");
801022b8:	83 ec 0c             	sub    $0xc,%esp
801022bb:	68 94 76 10 80       	push   $0x80107694
801022c0:	e8 cb e0 ff ff       	call   80100390 <panic>
    panic("idestart");
801022c5:	83 ec 0c             	sub    $0xc,%esp
801022c8:	68 8b 76 10 80       	push   $0x8010768b
801022cd:	e8 be e0 ff ff       	call   80100390 <panic>
801022d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ideinit>:
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022e6:	68 a6 76 10 80       	push   $0x801076a6
801022eb:	68 80 a5 10 80       	push   $0x8010a580
801022f0:	e8 eb 21 00 00       	call   801044e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022f5:	58                   	pop    %eax
801022f6:	a1 c0 2d 11 80       	mov    0x80112dc0,%eax
801022fb:	5a                   	pop    %edx
801022fc:	83 e8 01             	sub    $0x1,%eax
801022ff:	50                   	push   %eax
80102300:	6a 0e                	push   $0xe
80102302:	e8 a9 02 00 00       	call   801025b0 <ioapicenable>
80102307:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010230a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010230f:	90                   	nop
80102310:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102311:	83 e0 c0             	and    $0xffffffc0,%eax
80102314:	3c 40                	cmp    $0x40,%al
80102316:	75 f8                	jne    80102310 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102318:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010231d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102322:	ee                   	out    %al,(%dx)
80102323:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102328:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010232d:	eb 06                	jmp    80102335 <ideinit+0x55>
8010232f:	90                   	nop
  for(i=0; i<1000; i++){
80102330:	83 e9 01             	sub    $0x1,%ecx
80102333:	74 0f                	je     80102344 <ideinit+0x64>
80102335:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102336:	84 c0                	test   %al,%al
80102338:	74 f6                	je     80102330 <ideinit+0x50>
      havedisk1 = 1;
8010233a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102341:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102344:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102349:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010234e:	ee                   	out    %al,(%dx)
}
8010234f:	c9                   	leave  
80102350:	c3                   	ret    
80102351:	eb 0d                	jmp    80102360 <ideintr>
80102353:	90                   	nop
80102354:	90                   	nop
80102355:	90                   	nop
80102356:	90                   	nop
80102357:	90                   	nop
80102358:	90                   	nop
80102359:	90                   	nop
8010235a:	90                   	nop
8010235b:	90                   	nop
8010235c:	90                   	nop
8010235d:	90                   	nop
8010235e:	90                   	nop
8010235f:	90                   	nop

80102360 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	57                   	push   %edi
80102364:	56                   	push   %esi
80102365:	53                   	push   %ebx
80102366:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102369:	68 80 a5 10 80       	push   $0x8010a580
8010236e:	e8 ad 22 00 00       	call   80104620 <acquire>

  if((b = idequeue) == 0){
80102373:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102379:	83 c4 10             	add    $0x10,%esp
8010237c:	85 db                	test   %ebx,%ebx
8010237e:	74 67                	je     801023e7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102380:	8b 43 58             	mov    0x58(%ebx),%eax
80102383:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102388:	8b 3b                	mov    (%ebx),%edi
8010238a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102390:	75 31                	jne    801023c3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102392:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102397:	89 f6                	mov    %esi,%esi
80102399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801023a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023a1:	89 c6                	mov    %eax,%esi
801023a3:	83 e6 c0             	and    $0xffffffc0,%esi
801023a6:	89 f1                	mov    %esi,%ecx
801023a8:	80 f9 40             	cmp    $0x40,%cl
801023ab:	75 f3                	jne    801023a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023ad:	a8 21                	test   $0x21,%al
801023af:	75 12                	jne    801023c3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801023b1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023b4:	b9 80 00 00 00       	mov    $0x80,%ecx
801023b9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023be:	fc                   	cld    
801023bf:	f3 6d                	rep insl (%dx),%es:(%edi)
801023c1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801023c3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801023c6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023c9:	89 f9                	mov    %edi,%ecx
801023cb:	83 c9 02             	or     $0x2,%ecx
801023ce:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801023d0:	53                   	push   %ebx
801023d1:	e8 3a 1e 00 00       	call   80104210 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023d6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801023db:	83 c4 10             	add    $0x10,%esp
801023de:	85 c0                	test   %eax,%eax
801023e0:	74 05                	je     801023e7 <ideintr+0x87>
    idestart(idequeue);
801023e2:	e8 19 fe ff ff       	call   80102200 <idestart>
    release(&idelock);
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	68 80 a5 10 80       	push   $0x8010a580
801023ef:	e8 ec 22 00 00       	call   801046e0 <release>

  release(&idelock);
}
801023f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5f                   	pop    %edi
801023fa:	5d                   	pop    %ebp
801023fb:	c3                   	ret    
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	53                   	push   %ebx
80102404:	83 ec 10             	sub    $0x10,%esp
80102407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010240a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010240d:	50                   	push   %eax
8010240e:	e8 7d 20 00 00       	call   80104490 <holdingsleep>
80102413:	83 c4 10             	add    $0x10,%esp
80102416:	85 c0                	test   %eax,%eax
80102418:	0f 84 c6 00 00 00    	je     801024e4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010241e:	8b 03                	mov    (%ebx),%eax
80102420:	83 e0 06             	and    $0x6,%eax
80102423:	83 f8 02             	cmp    $0x2,%eax
80102426:	0f 84 ab 00 00 00    	je     801024d7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010242c:	8b 53 04             	mov    0x4(%ebx),%edx
8010242f:	85 d2                	test   %edx,%edx
80102431:	74 0d                	je     80102440 <iderw+0x40>
80102433:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102438:	85 c0                	test   %eax,%eax
8010243a:	0f 84 b1 00 00 00    	je     801024f1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102440:	83 ec 0c             	sub    $0xc,%esp
80102443:	68 80 a5 10 80       	push   $0x8010a580
80102448:	e8 d3 21 00 00       	call   80104620 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010244d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102453:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102456:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010245d:	85 d2                	test   %edx,%edx
8010245f:	75 09                	jne    8010246a <iderw+0x6a>
80102461:	eb 6d                	jmp    801024d0 <iderw+0xd0>
80102463:	90                   	nop
80102464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102468:	89 c2                	mov    %eax,%edx
8010246a:	8b 42 58             	mov    0x58(%edx),%eax
8010246d:	85 c0                	test   %eax,%eax
8010246f:	75 f7                	jne    80102468 <iderw+0x68>
80102471:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102474:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102476:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010247c:	74 42                	je     801024c0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010247e:	8b 03                	mov    (%ebx),%eax
80102480:	83 e0 06             	and    $0x6,%eax
80102483:	83 f8 02             	cmp    $0x2,%eax
80102486:	74 23                	je     801024ab <iderw+0xab>
80102488:	90                   	nop
80102489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102490:	83 ec 08             	sub    $0x8,%esp
80102493:	68 80 a5 10 80       	push   $0x8010a580
80102498:	53                   	push   %ebx
80102499:	e8 c2 1b 00 00       	call   80104060 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010249e:	8b 03                	mov    (%ebx),%eax
801024a0:	83 c4 10             	add    $0x10,%esp
801024a3:	83 e0 06             	and    $0x6,%eax
801024a6:	83 f8 02             	cmp    $0x2,%eax
801024a9:	75 e5                	jne    80102490 <iderw+0x90>
  }


  release(&idelock);
801024ab:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801024b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024b5:	c9                   	leave  
  release(&idelock);
801024b6:	e9 25 22 00 00       	jmp    801046e0 <release>
801024bb:	90                   	nop
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801024c0:	89 d8                	mov    %ebx,%eax
801024c2:	e8 39 fd ff ff       	call   80102200 <idestart>
801024c7:	eb b5                	jmp    8010247e <iderw+0x7e>
801024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024d0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801024d5:	eb 9d                	jmp    80102474 <iderw+0x74>
    panic("iderw: nothing to do");
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	68 c0 76 10 80       	push   $0x801076c0
801024df:	e8 ac de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801024e4:	83 ec 0c             	sub    $0xc,%esp
801024e7:	68 aa 76 10 80       	push   $0x801076aa
801024ec:	e8 9f de ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801024f1:	83 ec 0c             	sub    $0xc,%esp
801024f4:	68 d5 76 10 80       	push   $0x801076d5
801024f9:	e8 92 de ff ff       	call   80100390 <panic>
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
80102501:	c7 05 fc 26 11 80 00 	movl   $0xfec00000,0x801126fc
80102508:	00 c0 fe 
{
8010250b:	89 e5                	mov    %esp,%ebp
8010250d:	56                   	push   %esi
8010250e:	53                   	push   %ebx
  ioapic->reg = reg;
8010250f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102516:	00 00 00 
  return ioapic->data;
80102519:	a1 fc 26 11 80       	mov    0x801126fc,%eax
8010251e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102527:	8b 0d fc 26 11 80    	mov    0x801126fc,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010252d:	0f b6 15 20 28 11 80 	movzbl 0x80112820,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102534:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102537:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010253a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010253d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102540:	39 c2                	cmp    %eax,%edx
80102542:	74 16                	je     8010255a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102544:	83 ec 0c             	sub    $0xc,%esp
80102547:	68 f4 76 10 80       	push   $0x801076f4
8010254c:	e8 0f e1 ff ff       	call   80100660 <cprintf>
80102551:	8b 0d fc 26 11 80    	mov    0x801126fc,%ecx
80102557:	83 c4 10             	add    $0x10,%esp
8010255a:	83 c3 21             	add    $0x21,%ebx
{
8010255d:	ba 10 00 00 00       	mov    $0x10,%edx
80102562:	b8 20 00 00 00       	mov    $0x20,%eax
80102567:	89 f6                	mov    %esi,%esi
80102569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102570:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102572:	8b 0d fc 26 11 80    	mov    0x801126fc,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102578:	89 c6                	mov    %eax,%esi
8010257a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102580:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102583:	89 71 10             	mov    %esi,0x10(%ecx)
80102586:	8d 72 01             	lea    0x1(%edx),%esi
80102589:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010258c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010258e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102590:	8b 0d fc 26 11 80    	mov    0x801126fc,%ecx
80102596:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010259d:	75 d1                	jne    80102570 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010259f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a2:	5b                   	pop    %ebx
801025a3:	5e                   	pop    %esi
801025a4:	5d                   	pop    %ebp
801025a5:	c3                   	ret    
801025a6:	8d 76 00             	lea    0x0(%esi),%esi
801025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801025b0:	55                   	push   %ebp
  ioapic->reg = reg;
801025b1:	8b 0d fc 26 11 80    	mov    0x801126fc,%ecx
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
801025c5:	8b 0d fc 26 11 80    	mov    0x801126fc,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025d6:	a1 fc 26 11 80       	mov    0x801126fc,%eax
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
80102600:	75 70                	jne    80102672 <kfree+0x82>
80102602:	81 fb 68 55 11 80    	cmp    $0x80115568,%ebx
80102608:	72 68                	jb     80102672 <kfree+0x82>
8010260a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102610:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102615:	77 5b                	ja     80102672 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102617:	83 ec 04             	sub    $0x4,%esp
8010261a:	68 00 10 00 00       	push   $0x1000
8010261f:	6a 01                	push   $0x1
80102621:	53                   	push   %ebx
80102622:	e8 09 21 00 00       	call   80104730 <memset>

  if(kmem.use_lock)
80102627:	8b 15 34 27 11 80    	mov    0x80112734,%edx
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	85 d2                	test   %edx,%edx
80102632:	75 2c                	jne    80102660 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102634:	a1 38 27 11 80       	mov    0x80112738,%eax
80102639:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010263b:	a1 34 27 11 80       	mov    0x80112734,%eax
  kmem.freelist = r;
80102640:	89 1d 38 27 11 80    	mov    %ebx,0x80112738
  if(kmem.use_lock)
80102646:	85 c0                	test   %eax,%eax
80102648:	75 06                	jne    80102650 <kfree+0x60>
    release(&kmem.lock);
}
8010264a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010264d:	c9                   	leave  
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
80102650:	c7 45 08 00 27 11 80 	movl   $0x80112700,0x8(%ebp)
}
80102657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010265a:	c9                   	leave  
    release(&kmem.lock);
8010265b:	e9 80 20 00 00       	jmp    801046e0 <release>
    acquire(&kmem.lock);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	68 00 27 11 80       	push   $0x80112700
80102668:	e8 b3 1f 00 00       	call   80104620 <acquire>
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	eb c2                	jmp    80102634 <kfree+0x44>
    panic("kfree");
80102672:	83 ec 0c             	sub    $0xc,%esp
80102675:	68 26 77 10 80       	push   $0x80107726
8010267a:	e8 11 dd ff ff       	call   80100390 <panic>
8010267f:	90                   	nop

80102680 <freerange>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102688:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010268b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102691:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102697:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269d:	39 de                	cmp    %ebx,%esi
8010269f:	72 23                	jb     801026c4 <freerange+0x44>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026b7:	50                   	push   %eax
801026b8:	e8 33 ff ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	39 f3                	cmp    %esi,%ebx
801026c2:	76 e4                	jbe    801026a8 <freerange+0x28>
}
801026c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026c7:	5b                   	pop    %ebx
801026c8:	5e                   	pop    %esi
801026c9:	5d                   	pop    %ebp
801026ca:	c3                   	ret    
801026cb:	90                   	nop
801026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026d0 <kinit1>:
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	53                   	push   %ebx
801026d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026d8:	83 ec 08             	sub    $0x8,%esp
801026db:	68 2c 77 10 80       	push   $0x8010772c
801026e0:	68 00 27 11 80       	push   $0x80112700
801026e5:	e8 f6 1d 00 00       	call   801044e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026f0:	c7 05 34 27 11 80 00 	movl   $0x0,0x80112734
801026f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102700:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102706:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010270c:	39 de                	cmp    %ebx,%esi
8010270e:	72 1c                	jb     8010272c <kinit1+0x5c>
    kfree(p);
80102710:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102716:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102719:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010271f:	50                   	push   %eax
80102720:	e8 cb fe ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102725:	83 c4 10             	add    $0x10,%esp
80102728:	39 de                	cmp    %ebx,%esi
8010272a:	73 e4                	jae    80102710 <kinit1+0x40>
}
8010272c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010272f:	5b                   	pop    %ebx
80102730:	5e                   	pop    %esi
80102731:	5d                   	pop    %ebp
80102732:	c3                   	ret    
80102733:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <kinit2>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102745:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102748:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010274b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102751:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275d:	39 de                	cmp    %ebx,%esi
8010275f:	72 23                	jb     80102784 <kinit2+0x44>
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102768:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010276e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102777:	50                   	push   %eax
80102778:	e8 73 fe ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	39 de                	cmp    %ebx,%esi
80102782:	73 e4                	jae    80102768 <kinit2+0x28>
  kmem.use_lock = 1;
80102784:	c7 05 34 27 11 80 01 	movl   $0x1,0x80112734
8010278b:	00 00 00 
}
8010278e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102791:	5b                   	pop    %ebx
80102792:	5e                   	pop    %esi
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801027a0:	a1 34 27 11 80       	mov    0x80112734,%eax
801027a5:	85 c0                	test   %eax,%eax
801027a7:	75 1f                	jne    801027c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027a9:	a1 38 27 11 80       	mov    0x80112738,%eax
  if(r)
801027ae:	85 c0                	test   %eax,%eax
801027b0:	74 0e                	je     801027c0 <kalloc+0x20>
    kmem.freelist = r->next;
801027b2:	8b 10                	mov    (%eax),%edx
801027b4:	89 15 38 27 11 80    	mov    %edx,0x80112738
801027ba:	c3                   	ret    
801027bb:	90                   	nop
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801027c0:	f3 c3                	repz ret 
801027c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801027c8:	55                   	push   %ebp
801027c9:	89 e5                	mov    %esp,%ebp
801027cb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027ce:	68 00 27 11 80       	push   $0x80112700
801027d3:	e8 48 1e 00 00       	call   80104620 <acquire>
  r = kmem.freelist;
801027d8:	a1 38 27 11 80       	mov    0x80112738,%eax
  if(r)
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	8b 15 34 27 11 80    	mov    0x80112734,%edx
801027e6:	85 c0                	test   %eax,%eax
801027e8:	74 08                	je     801027f2 <kalloc+0x52>
    kmem.freelist = r->next;
801027ea:	8b 08                	mov    (%eax),%ecx
801027ec:	89 0d 38 27 11 80    	mov    %ecx,0x80112738
  if(kmem.use_lock)
801027f2:	85 d2                	test   %edx,%edx
801027f4:	74 16                	je     8010280c <kalloc+0x6c>
    release(&kmem.lock);
801027f6:	83 ec 0c             	sub    $0xc,%esp
801027f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027fc:	68 00 27 11 80       	push   $0x80112700
80102801:	e8 da 1e 00 00       	call   801046e0 <release>
  return (char*)r;
80102806:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102809:	83 c4 10             	add    $0x10,%esp
}
8010280c:	c9                   	leave  
8010280d:	c3                   	ret    
8010280e:	66 90                	xchg   %ax,%ax

80102810 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102810:	ba 64 00 00 00       	mov    $0x64,%edx
80102815:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102816:	a8 01                	test   $0x1,%al
80102818:	0f 84 c2 00 00 00    	je     801028e0 <kbdgetc+0xd0>
8010281e:	ba 60 00 00 00       	mov    $0x60,%edx
80102823:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102824:	0f b6 d0             	movzbl %al,%edx
80102827:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010282d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102833:	0f 84 7f 00 00 00    	je     801028b8 <kbdgetc+0xa8>
{
80102839:	55                   	push   %ebp
8010283a:	89 e5                	mov    %esp,%ebp
8010283c:	53                   	push   %ebx
8010283d:	89 cb                	mov    %ecx,%ebx
8010283f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102842:	84 c0                	test   %al,%al
80102844:	78 4a                	js     80102890 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102846:	85 db                	test   %ebx,%ebx
80102848:	74 09                	je     80102853 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010284a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010284d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102850:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102853:	0f b6 82 60 78 10 80 	movzbl -0x7fef87a0(%edx),%eax
8010285a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010285c:	0f b6 82 60 77 10 80 	movzbl -0x7fef88a0(%edx),%eax
80102863:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102865:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102867:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010286d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102870:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102873:	8b 04 85 40 77 10 80 	mov    -0x7fef88c0(,%eax,4),%eax
8010287a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010287e:	74 31                	je     801028b1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102880:	8d 50 9f             	lea    -0x61(%eax),%edx
80102883:	83 fa 19             	cmp    $0x19,%edx
80102886:	77 40                	ja     801028c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102888:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010288b:	5b                   	pop    %ebx
8010288c:	5d                   	pop    %ebp
8010288d:	c3                   	ret    
8010288e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102890:	83 e0 7f             	and    $0x7f,%eax
80102893:	85 db                	test   %ebx,%ebx
80102895:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102898:	0f b6 82 60 78 10 80 	movzbl -0x7fef87a0(%edx),%eax
8010289f:	83 c8 40             	or     $0x40,%eax
801028a2:	0f b6 c0             	movzbl %al,%eax
801028a5:	f7 d0                	not    %eax
801028a7:	21 c1                	and    %eax,%ecx
    return 0;
801028a9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801028ab:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801028b1:	5b                   	pop    %ebx
801028b2:	5d                   	pop    %ebp
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801028b8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801028bb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028bd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801028c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801028ce:	5b                   	pop    %ebx
      c += 'a' - 'A';
801028cf:	83 f9 1a             	cmp    $0x1a,%ecx
801028d2:	0f 42 c2             	cmovb  %edx,%eax
}
801028d5:	5d                   	pop    %ebp
801028d6:	c3                   	ret    
801028d7:	89 f6                	mov    %esi,%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801028e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028e5:	c3                   	ret    
801028e6:	8d 76 00             	lea    0x0(%esi),%esi
801028e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028f0 <kbdintr>:

void
kbdintr(void)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028f6:	68 10 28 10 80       	push   $0x80102810
801028fb:	e8 10 df ff ff       	call   80100810 <consoleintr>
}
80102900:	83 c4 10             	add    $0x10,%esp
80102903:	c9                   	leave  
80102904:	c3                   	ret    
80102905:	66 90                	xchg   %ax,%ax
80102907:	66 90                	xchg   %ax,%ax
80102909:	66 90                	xchg   %ax,%ax
8010290b:	66 90                	xchg   %ax,%ax
8010290d:	66 90                	xchg   %ax,%ax
8010290f:	90                   	nop

80102910 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102910:	a1 3c 27 11 80       	mov    0x8011273c,%eax
{
80102915:	55                   	push   %ebp
80102916:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102918:	85 c0                	test   %eax,%eax
8010291a:	0f 84 c8 00 00 00    	je     801029e8 <lapicinit+0xd8>
  lapic[index] = value;
80102920:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102927:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010292a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102934:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102941:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102944:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102947:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010294e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102951:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102954:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010295b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010295e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102961:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102968:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010296b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010296e:	8b 50 30             	mov    0x30(%eax),%edx
80102971:	c1 ea 10             	shr    $0x10,%edx
80102974:	80 fa 03             	cmp    $0x3,%dl
80102977:	77 77                	ja     801029f0 <lapicinit+0xe0>
  lapic[index] = value;
80102979:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102980:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102986:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010298d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102990:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102993:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010299a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029c4:	8b 50 20             	mov    0x20(%eax),%edx
801029c7:	89 f6                	mov    %esi,%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029d6:	80 e6 10             	and    $0x10,%dh
801029d9:	75 f5                	jne    801029d0 <lapicinit+0xc0>
  lapic[index] = value;
801029db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029e8:	5d                   	pop    %ebp
801029e9:	c3                   	ret    
801029ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801029f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029fa:	8b 50 20             	mov    0x20(%eax),%edx
801029fd:	e9 77 ff ff ff       	jmp    80102979 <lapicinit+0x69>
80102a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a10 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a10:	8b 15 3c 27 11 80    	mov    0x8011273c,%edx
{
80102a16:	55                   	push   %ebp
80102a17:	31 c0                	xor    %eax,%eax
80102a19:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102a1b:	85 d2                	test   %edx,%edx
80102a1d:	74 06                	je     80102a25 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102a1f:	8b 42 20             	mov    0x20(%edx),%eax
80102a22:	c1 e8 18             	shr    $0x18,%eax
}
80102a25:	5d                   	pop    %ebp
80102a26:	c3                   	ret    
80102a27:	89 f6                	mov    %esi,%esi
80102a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a30:	a1 3c 27 11 80       	mov    0x8011273c,%eax
{
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102a38:	85 c0                	test   %eax,%eax
80102a3a:	74 0d                	je     80102a49 <lapiceoi+0x19>
  lapic[index] = value;
80102a3c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a43:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a46:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a49:	5d                   	pop    %ebp
80102a4a:	c3                   	ret    
80102a4b:	90                   	nop
80102a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a50 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
}
80102a53:	5d                   	pop    %ebp
80102a54:	c3                   	ret    
80102a55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a61:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a66:	ba 70 00 00 00       	mov    $0x70,%edx
80102a6b:	89 e5                	mov    %esp,%ebp
80102a6d:	53                   	push   %ebx
80102a6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a74:	ee                   	out    %al,(%dx)
80102a75:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a7a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a7f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a80:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a82:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a85:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a8b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a8d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102a90:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102a93:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a95:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a98:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a9e:	a1 3c 27 11 80       	mov    0x8011273c,%eax
80102aa3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aa9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ab3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ab9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ac0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102acc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102acf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ad5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ad8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ade:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ae1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ae7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102aea:	5b                   	pop    %ebx
80102aeb:	5d                   	pop    %ebp
80102aec:	c3                   	ret    
80102aed:	8d 76 00             	lea    0x0(%esi),%esi

80102af0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102af0:	55                   	push   %ebp
80102af1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102af6:	ba 70 00 00 00       	mov    $0x70,%edx
80102afb:	89 e5                	mov    %esp,%ebp
80102afd:	57                   	push   %edi
80102afe:	56                   	push   %esi
80102aff:	53                   	push   %ebx
80102b00:	83 ec 4c             	sub    $0x4c,%esp
80102b03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b04:	ba 71 00 00 00       	mov    $0x71,%edx
80102b09:	ec                   	in     (%dx),%al
80102b0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b15:	8d 76 00             	lea    0x0(%esi),%esi
80102b18:	31 c0                	xor    %eax,%eax
80102b1a:	89 da                	mov    %ebx,%edx
80102b1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b22:	89 ca                	mov    %ecx,%edx
80102b24:	ec                   	in     (%dx),%al
80102b25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b28:	89 da                	mov    %ebx,%edx
80102b2a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	89 ca                	mov    %ecx,%edx
80102b32:	ec                   	in     (%dx),%al
80102b33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b36:	89 da                	mov    %ebx,%edx
80102b38:	b8 04 00 00 00       	mov    $0x4,%eax
80102b3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3e:	89 ca                	mov    %ecx,%edx
80102b40:	ec                   	in     (%dx),%al
80102b41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b44:	89 da                	mov    %ebx,%edx
80102b46:	b8 07 00 00 00       	mov    $0x7,%eax
80102b4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4c:	89 ca                	mov    %ecx,%edx
80102b4e:	ec                   	in     (%dx),%al
80102b4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b52:	89 da                	mov    %ebx,%edx
80102b54:	b8 08 00 00 00       	mov    $0x8,%eax
80102b59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5a:	89 ca                	mov    %ecx,%edx
80102b5c:	ec                   	in     (%dx),%al
80102b5d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5f:	89 da                	mov    %ebx,%edx
80102b61:	b8 09 00 00 00       	mov    $0x9,%eax
80102b66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b67:	89 ca                	mov    %ecx,%edx
80102b69:	ec                   	in     (%dx),%al
80102b6a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6c:	89 da                	mov    %ebx,%edx
80102b6e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b74:	89 ca                	mov    %ecx,%edx
80102b76:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b77:	84 c0                	test   %al,%al
80102b79:	78 9d                	js     80102b18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b7b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b7f:	89 fa                	mov    %edi,%edx
80102b81:	0f b6 fa             	movzbl %dl,%edi
80102b84:	89 f2                	mov    %esi,%edx
80102b86:	0f b6 f2             	movzbl %dl,%esi
80102b89:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8c:	89 da                	mov    %ebx,%edx
80102b8e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b91:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b94:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b98:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b9b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b9f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ba2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ba6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ba9:	31 c0                	xor    %eax,%eax
80102bab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bac:	89 ca                	mov    %ecx,%edx
80102bae:	ec                   	in     (%dx),%al
80102baf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb2:	89 da                	mov    %ebx,%edx
80102bb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bb7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbd:	89 ca                	mov    %ecx,%edx
80102bbf:	ec                   	in     (%dx),%al
80102bc0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc3:	89 da                	mov    %ebx,%edx
80102bc5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bc8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bce:	89 ca                	mov    %ecx,%edx
80102bd0:	ec                   	in     (%dx),%al
80102bd1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd4:	89 da                	mov    %ebx,%edx
80102bd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bd9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bde:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdf:	89 ca                	mov    %ecx,%edx
80102be1:	ec                   	in     (%dx),%al
80102be2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be5:	89 da                	mov    %ebx,%edx
80102be7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bea:	b8 08 00 00 00       	mov    $0x8,%eax
80102bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	89 ca                	mov    %ecx,%edx
80102bf2:	ec                   	in     (%dx),%al
80102bf3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf6:	89 da                	mov    %ebx,%edx
80102bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102bfb:	b8 09 00 00 00       	mov    $0x9,%eax
80102c00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c01:	89 ca                	mov    %ecx,%edx
80102c03:	ec                   	in     (%dx),%al
80102c04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c10:	6a 18                	push   $0x18
80102c12:	50                   	push   %eax
80102c13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c16:	50                   	push   %eax
80102c17:	e8 64 1b 00 00       	call   80104780 <memcmp>
80102c1c:	83 c4 10             	add    $0x10,%esp
80102c1f:	85 c0                	test   %eax,%eax
80102c21:	0f 85 f1 fe ff ff    	jne    80102b18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c2b:	75 78                	jne    80102ca5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c30:	89 c2                	mov    %eax,%edx
80102c32:	83 e0 0f             	and    $0xf,%eax
80102c35:	c1 ea 04             	shr    $0x4,%edx
80102c38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c44:	89 c2                	mov    %eax,%edx
80102c46:	83 e0 0f             	and    $0xf,%eax
80102c49:	c1 ea 04             	shr    $0x4,%edx
80102c4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c58:	89 c2                	mov    %eax,%edx
80102c5a:	83 e0 0f             	and    $0xf,%eax
80102c5d:	c1 ea 04             	shr    $0x4,%edx
80102c60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c6c:	89 c2                	mov    %eax,%edx
80102c6e:	83 e0 0f             	and    $0xf,%eax
80102c71:	c1 ea 04             	shr    $0x4,%edx
80102c74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c80:	89 c2                	mov    %eax,%edx
80102c82:	83 e0 0f             	and    $0xf,%eax
80102c85:	c1 ea 04             	shr    $0x4,%edx
80102c88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c94:	89 c2                	mov    %eax,%edx
80102c96:	83 e0 0f             	and    $0xf,%eax
80102c99:	c1 ea 04             	shr    $0x4,%edx
80102c9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ca2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ca5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ca8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cab:	89 06                	mov    %eax,(%esi)
80102cad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cb0:	89 46 04             	mov    %eax,0x4(%esi)
80102cb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cb6:	89 46 08             	mov    %eax,0x8(%esi)
80102cb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cbc:	89 46 0c             	mov    %eax,0xc(%esi)
80102cbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cc2:	89 46 10             	mov    %eax,0x10(%esi)
80102cc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cc8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ccb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cd5:	5b                   	pop    %ebx
80102cd6:	5e                   	pop    %esi
80102cd7:	5f                   	pop    %edi
80102cd8:	5d                   	pop    %ebp
80102cd9:	c3                   	ret    
80102cda:	66 90                	xchg   %ax,%ax
80102cdc:	66 90                	xchg   %ax,%ax
80102cde:	66 90                	xchg   %ax,%ax

80102ce0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ce0:	8b 0d 88 27 11 80    	mov    0x80112788,%ecx
80102ce6:	85 c9                	test   %ecx,%ecx
80102ce8:	0f 8e 8a 00 00 00    	jle    80102d78 <install_trans+0x98>
{
80102cee:	55                   	push   %ebp
80102cef:	89 e5                	mov    %esp,%ebp
80102cf1:	57                   	push   %edi
80102cf2:	56                   	push   %esi
80102cf3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf4:	31 db                	xor    %ebx,%ebx
{
80102cf6:	83 ec 0c             	sub    $0xc,%esp
80102cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d00:	a1 74 27 11 80       	mov    0x80112774,%eax
80102d05:	83 ec 08             	sub    $0x8,%esp
80102d08:	01 d8                	add    %ebx,%eax
80102d0a:	83 c0 01             	add    $0x1,%eax
80102d0d:	50                   	push   %eax
80102d0e:	ff 35 84 27 11 80    	pushl  0x80112784
80102d14:	e8 b7 d3 ff ff       	call   801000d0 <bread>
80102d19:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d1b:	58                   	pop    %eax
80102d1c:	5a                   	pop    %edx
80102d1d:	ff 34 9d 8c 27 11 80 	pushl  -0x7feed874(,%ebx,4)
80102d24:	ff 35 84 27 11 80    	pushl  0x80112784
  for (tail = 0; tail < log.lh.n; tail++) {
80102d2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d2d:	e8 9e d3 ff ff       	call   801000d0 <bread>
80102d32:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d34:	8d 47 5c             	lea    0x5c(%edi),%eax
80102d37:	83 c4 0c             	add    $0xc,%esp
80102d3a:	68 00 02 00 00       	push   $0x200
80102d3f:	50                   	push   %eax
80102d40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d43:	50                   	push   %eax
80102d44:	e8 97 1a 00 00       	call   801047e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d49:	89 34 24             	mov    %esi,(%esp)
80102d4c:	e8 4f d4 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102d51:	89 3c 24             	mov    %edi,(%esp)
80102d54:	e8 87 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102d59:	89 34 24             	mov    %esi,(%esp)
80102d5c:	e8 7f d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d61:	83 c4 10             	add    $0x10,%esp
80102d64:	39 1d 88 27 11 80    	cmp    %ebx,0x80112788
80102d6a:	7f 94                	jg     80102d00 <install_trans+0x20>
  }
}
80102d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6f:	5b                   	pop    %ebx
80102d70:	5e                   	pop    %esi
80102d71:	5f                   	pop    %edi
80102d72:	5d                   	pop    %ebp
80102d73:	c3                   	ret    
80102d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d78:	f3 c3                	repz ret 
80102d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102d80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	56                   	push   %esi
80102d84:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102d85:	83 ec 08             	sub    $0x8,%esp
80102d88:	ff 35 74 27 11 80    	pushl  0x80112774
80102d8e:	ff 35 84 27 11 80    	pushl  0x80112784
80102d94:	e8 37 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d99:	8b 1d 88 27 11 80    	mov    0x80112788,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d9f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102da2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102da4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102da6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102da9:	7e 16                	jle    80102dc1 <write_head+0x41>
80102dab:	c1 e3 02             	shl    $0x2,%ebx
80102dae:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102db0:	8b 8a 8c 27 11 80    	mov    -0x7feed874(%edx),%ecx
80102db6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102dba:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102dbd:	39 da                	cmp    %ebx,%edx
80102dbf:	75 ef                	jne    80102db0 <write_head+0x30>
  }
  bwrite(buf);
80102dc1:	83 ec 0c             	sub    $0xc,%esp
80102dc4:	56                   	push   %esi
80102dc5:	e8 d6 d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102dca:	89 34 24             	mov    %esi,(%esp)
80102dcd:	e8 0e d4 ff ff       	call   801001e0 <brelse>
}
80102dd2:	83 c4 10             	add    $0x10,%esp
80102dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102dd8:	5b                   	pop    %ebx
80102dd9:	5e                   	pop    %esi
80102dda:	5d                   	pop    %ebp
80102ddb:	c3                   	ret    
80102ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102de0 <initlog>:
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 2c             	sub    $0x2c,%esp
80102de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dea:	68 60 79 10 80       	push   $0x80107960
80102def:	68 40 27 11 80       	push   $0x80112740
80102df4:	e8 e7 16 00 00       	call   801044e0 <initlock>
  readsb(dev, &sb);
80102df9:	58                   	pop    %eax
80102dfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dfd:	5a                   	pop    %edx
80102dfe:	50                   	push   %eax
80102dff:	53                   	push   %ebx
80102e00:	e8 6b e7 ff ff       	call   80101570 <readsb>
  log.size = sb.nlog;
80102e05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e0b:	59                   	pop    %ecx
  log.dev = dev;
80102e0c:	89 1d 84 27 11 80    	mov    %ebx,0x80112784
  log.size = sb.nlog;
80102e12:	89 15 78 27 11 80    	mov    %edx,0x80112778
  log.start = sb.logstart;
80102e18:	a3 74 27 11 80       	mov    %eax,0x80112774
  struct buf *buf = bread(log.dev, log.start);
80102e1d:	5a                   	pop    %edx
80102e1e:	50                   	push   %eax
80102e1f:	53                   	push   %ebx
80102e20:	e8 ab d2 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102e25:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e28:	83 c4 10             	add    $0x10,%esp
80102e2b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102e2d:	89 1d 88 27 11 80    	mov    %ebx,0x80112788
  for (i = 0; i < log.lh.n; i++) {
80102e33:	7e 1c                	jle    80102e51 <initlog+0x71>
80102e35:	c1 e3 02             	shl    $0x2,%ebx
80102e38:	31 d2                	xor    %edx,%edx
80102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102e40:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102e44:	83 c2 04             	add    $0x4,%edx
80102e47:	89 8a 88 27 11 80    	mov    %ecx,-0x7feed878(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102e4d:	39 d3                	cmp    %edx,%ebx
80102e4f:	75 ef                	jne    80102e40 <initlog+0x60>
  brelse(buf);
80102e51:	83 ec 0c             	sub    $0xc,%esp
80102e54:	50                   	push   %eax
80102e55:	e8 86 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e5a:	e8 81 fe ff ff       	call   80102ce0 <install_trans>
  log.lh.n = 0;
80102e5f:	c7 05 88 27 11 80 00 	movl   $0x0,0x80112788
80102e66:	00 00 00 
  write_head(); // clear the log
80102e69:	e8 12 ff ff ff       	call   80102d80 <write_head>
}
80102e6e:	83 c4 10             	add    $0x10,%esp
80102e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e74:	c9                   	leave  
80102e75:	c3                   	ret    
80102e76:	8d 76 00             	lea    0x0(%esi),%esi
80102e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e86:	68 40 27 11 80       	push   $0x80112740
80102e8b:	e8 90 17 00 00       	call   80104620 <acquire>
80102e90:	83 c4 10             	add    $0x10,%esp
80102e93:	eb 18                	jmp    80102ead <begin_op+0x2d>
80102e95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e98:	83 ec 08             	sub    $0x8,%esp
80102e9b:	68 40 27 11 80       	push   $0x80112740
80102ea0:	68 40 27 11 80       	push   $0x80112740
80102ea5:	e8 b6 11 00 00       	call   80104060 <sleep>
80102eaa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ead:	a1 80 27 11 80       	mov    0x80112780,%eax
80102eb2:	85 c0                	test   %eax,%eax
80102eb4:	75 e2                	jne    80102e98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102eb6:	a1 7c 27 11 80       	mov    0x8011277c,%eax
80102ebb:	8b 15 88 27 11 80    	mov    0x80112788,%edx
80102ec1:	83 c0 01             	add    $0x1,%eax
80102ec4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ec7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eca:	83 fa 1e             	cmp    $0x1e,%edx
80102ecd:	7f c9                	jg     80102e98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ecf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ed2:	a3 7c 27 11 80       	mov    %eax,0x8011277c
      release(&log.lock);
80102ed7:	68 40 27 11 80       	push   $0x80112740
80102edc:	e8 ff 17 00 00       	call   801046e0 <release>
      break;
    }
  }
}
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	c9                   	leave  
80102ee5:	c3                   	ret    
80102ee6:	8d 76 00             	lea    0x0(%esi),%esi
80102ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ef0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	57                   	push   %edi
80102ef4:	56                   	push   %esi
80102ef5:	53                   	push   %ebx
80102ef6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ef9:	68 40 27 11 80       	push   $0x80112740
80102efe:	e8 1d 17 00 00       	call   80104620 <acquire>
  log.outstanding -= 1;
80102f03:	a1 7c 27 11 80       	mov    0x8011277c,%eax
  if(log.committing)
80102f08:	8b 35 80 27 11 80    	mov    0x80112780,%esi
80102f0e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f11:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102f14:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102f16:	89 1d 7c 27 11 80    	mov    %ebx,0x8011277c
  if(log.committing)
80102f1c:	0f 85 1a 01 00 00    	jne    8010303c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102f22:	85 db                	test   %ebx,%ebx
80102f24:	0f 85 ee 00 00 00    	jne    80103018 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f2a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102f2d:	c7 05 80 27 11 80 01 	movl   $0x1,0x80112780
80102f34:	00 00 00 
  release(&log.lock);
80102f37:	68 40 27 11 80       	push   $0x80112740
80102f3c:	e8 9f 17 00 00       	call   801046e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f41:	8b 0d 88 27 11 80    	mov    0x80112788,%ecx
80102f47:	83 c4 10             	add    $0x10,%esp
80102f4a:	85 c9                	test   %ecx,%ecx
80102f4c:	0f 8e 85 00 00 00    	jle    80102fd7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f52:	a1 74 27 11 80       	mov    0x80112774,%eax
80102f57:	83 ec 08             	sub    $0x8,%esp
80102f5a:	01 d8                	add    %ebx,%eax
80102f5c:	83 c0 01             	add    $0x1,%eax
80102f5f:	50                   	push   %eax
80102f60:	ff 35 84 27 11 80    	pushl  0x80112784
80102f66:	e8 65 d1 ff ff       	call   801000d0 <bread>
80102f6b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f6d:	58                   	pop    %eax
80102f6e:	5a                   	pop    %edx
80102f6f:	ff 34 9d 8c 27 11 80 	pushl  -0x7feed874(,%ebx,4)
80102f76:	ff 35 84 27 11 80    	pushl  0x80112784
  for (tail = 0; tail < log.lh.n; tail++) {
80102f7c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f7f:	e8 4c d1 ff ff       	call   801000d0 <bread>
80102f84:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f86:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f89:	83 c4 0c             	add    $0xc,%esp
80102f8c:	68 00 02 00 00       	push   $0x200
80102f91:	50                   	push   %eax
80102f92:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f95:	50                   	push   %eax
80102f96:	e8 45 18 00 00       	call   801047e0 <memmove>
    bwrite(to);  // write the log
80102f9b:	89 34 24             	mov    %esi,(%esp)
80102f9e:	e8 fd d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102fa3:	89 3c 24             	mov    %edi,(%esp)
80102fa6:	e8 35 d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102fab:	89 34 24             	mov    %esi,(%esp)
80102fae:	e8 2d d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fb3:	83 c4 10             	add    $0x10,%esp
80102fb6:	3b 1d 88 27 11 80    	cmp    0x80112788,%ebx
80102fbc:	7c 94                	jl     80102f52 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fbe:	e8 bd fd ff ff       	call   80102d80 <write_head>
    install_trans(); // Now install writes to home locations
80102fc3:	e8 18 fd ff ff       	call   80102ce0 <install_trans>
    log.lh.n = 0;
80102fc8:	c7 05 88 27 11 80 00 	movl   $0x0,0x80112788
80102fcf:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fd2:	e8 a9 fd ff ff       	call   80102d80 <write_head>
    acquire(&log.lock);
80102fd7:	83 ec 0c             	sub    $0xc,%esp
80102fda:	68 40 27 11 80       	push   $0x80112740
80102fdf:	e8 3c 16 00 00       	call   80104620 <acquire>
    wakeup(&log);
80102fe4:	c7 04 24 40 27 11 80 	movl   $0x80112740,(%esp)
    log.committing = 0;
80102feb:	c7 05 80 27 11 80 00 	movl   $0x0,0x80112780
80102ff2:	00 00 00 
    wakeup(&log);
80102ff5:	e8 16 12 00 00       	call   80104210 <wakeup>
    release(&log.lock);
80102ffa:	c7 04 24 40 27 11 80 	movl   $0x80112740,(%esp)
80103001:	e8 da 16 00 00       	call   801046e0 <release>
80103006:	83 c4 10             	add    $0x10,%esp
}
80103009:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010300c:	5b                   	pop    %ebx
8010300d:	5e                   	pop    %esi
8010300e:	5f                   	pop    %edi
8010300f:	5d                   	pop    %ebp
80103010:	c3                   	ret    
80103011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103018:	83 ec 0c             	sub    $0xc,%esp
8010301b:	68 40 27 11 80       	push   $0x80112740
80103020:	e8 eb 11 00 00       	call   80104210 <wakeup>
  release(&log.lock);
80103025:	c7 04 24 40 27 11 80 	movl   $0x80112740,(%esp)
8010302c:	e8 af 16 00 00       	call   801046e0 <release>
80103031:	83 c4 10             	add    $0x10,%esp
}
80103034:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103037:	5b                   	pop    %ebx
80103038:	5e                   	pop    %esi
80103039:	5f                   	pop    %edi
8010303a:	5d                   	pop    %ebp
8010303b:	c3                   	ret    
    panic("log.committing");
8010303c:	83 ec 0c             	sub    $0xc,%esp
8010303f:	68 64 79 10 80       	push   $0x80107964
80103044:	e8 47 d3 ff ff       	call   80100390 <panic>
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
80103057:	8b 15 88 27 11 80    	mov    0x80112788,%edx
{
8010305d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103060:	83 fa 1d             	cmp    $0x1d,%edx
80103063:	0f 8f 9d 00 00 00    	jg     80103106 <log_write+0xb6>
80103069:	a1 78 27 11 80       	mov    0x80112778,%eax
8010306e:	83 e8 01             	sub    $0x1,%eax
80103071:	39 c2                	cmp    %eax,%edx
80103073:	0f 8d 8d 00 00 00    	jge    80103106 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103079:	a1 7c 27 11 80       	mov    0x8011277c,%eax
8010307e:	85 c0                	test   %eax,%eax
80103080:	0f 8e 8d 00 00 00    	jle    80103113 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103086:	83 ec 0c             	sub    $0xc,%esp
80103089:	68 40 27 11 80       	push   $0x80112740
8010308e:	e8 8d 15 00 00       	call   80104620 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103093:	8b 0d 88 27 11 80    	mov    0x80112788,%ecx
80103099:	83 c4 10             	add    $0x10,%esp
8010309c:	83 f9 00             	cmp    $0x0,%ecx
8010309f:	7e 57                	jle    801030f8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030a1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801030a4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030a6:	3b 15 8c 27 11 80    	cmp    0x8011278c,%edx
801030ac:	75 0b                	jne    801030b9 <log_write+0x69>
801030ae:	eb 38                	jmp    801030e8 <log_write+0x98>
801030b0:	39 14 85 8c 27 11 80 	cmp    %edx,-0x7feed874(,%eax,4)
801030b7:	74 2f                	je     801030e8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801030b9:	83 c0 01             	add    $0x1,%eax
801030bc:	39 c1                	cmp    %eax,%ecx
801030be:	75 f0                	jne    801030b0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801030c0:	89 14 85 8c 27 11 80 	mov    %edx,-0x7feed874(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801030c7:	83 c0 01             	add    $0x1,%eax
801030ca:	a3 88 27 11 80       	mov    %eax,0x80112788
  b->flags |= B_DIRTY; // prevent eviction
801030cf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801030d2:	c7 45 08 40 27 11 80 	movl   $0x80112740,0x8(%ebp)
}
801030d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030dc:	c9                   	leave  
  release(&log.lock);
801030dd:	e9 fe 15 00 00       	jmp    801046e0 <release>
801030e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030e8:	89 14 85 8c 27 11 80 	mov    %edx,-0x7feed874(,%eax,4)
801030ef:	eb de                	jmp    801030cf <log_write+0x7f>
801030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f8:	8b 43 08             	mov    0x8(%ebx),%eax
801030fb:	a3 8c 27 11 80       	mov    %eax,0x8011278c
  if (i == log.lh.n)
80103100:	75 cd                	jne    801030cf <log_write+0x7f>
80103102:	31 c0                	xor    %eax,%eax
80103104:	eb c1                	jmp    801030c7 <log_write+0x77>
    panic("too big a transaction");
80103106:	83 ec 0c             	sub    $0xc,%esp
80103109:	68 73 79 10 80       	push   $0x80107973
8010310e:	e8 7d d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103113:	83 ec 0c             	sub    $0xc,%esp
80103116:	68 89 79 10 80       	push   $0x80107989
8010311b:	e8 70 d2 ff ff       	call   80100390 <panic>

80103120 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103127:	e8 74 09 00 00       	call   80103aa0 <cpuid>
8010312c:	89 c3                	mov    %eax,%ebx
8010312e:	e8 6d 09 00 00       	call   80103aa0 <cpuid>
80103133:	83 ec 04             	sub    $0x4,%esp
80103136:	53                   	push   %ebx
80103137:	50                   	push   %eax
80103138:	68 a4 79 10 80       	push   $0x801079a4
8010313d:	e8 1e d5 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103142:	e8 99 2b 00 00       	call   80105ce0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103147:	e8 d4 08 00 00       	call   80103a20 <mycpu>
8010314c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010314e:	b8 01 00 00 00       	mov    $0x1,%eax
80103153:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010315a:	e8 21 0c 00 00       	call   80103d80 <scheduler>
8010315f:	90                   	nop

80103160 <mpenter>:
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103166:	e8 65 3c 00 00       	call   80106dd0 <switchkvm>
  seginit();
8010316b:	e8 d0 3b 00 00       	call   80106d40 <seginit>
  lapicinit();
80103170:	e8 9b f7 ff ff       	call   80102910 <lapicinit>
  mpmain();
80103175:	e8 a6 ff ff ff       	call   80103120 <mpmain>
8010317a:	66 90                	xchg   %ax,%ax
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <main>:
{
80103180:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103184:	83 e4 f0             	and    $0xfffffff0,%esp
80103187:	ff 71 fc             	pushl  -0x4(%ecx)
8010318a:	55                   	push   %ebp
8010318b:	89 e5                	mov    %esp,%ebp
8010318d:	53                   	push   %ebx
8010318e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010318f:	83 ec 08             	sub    $0x8,%esp
80103192:	68 00 00 40 80       	push   $0x80400000
80103197:	68 68 55 11 80       	push   $0x80115568
8010319c:	e8 2f f5 ff ff       	call   801026d0 <kinit1>
  kvmalloc();      // kernel page table
801031a1:	e8 fa 40 00 00       	call   801072a0 <kvmalloc>
  mpinit();        // detect other processors
801031a6:	e8 75 01 00 00       	call   80103320 <mpinit>
  lapicinit();     // interrupt controller
801031ab:	e8 60 f7 ff ff       	call   80102910 <lapicinit>
  seginit();       // segment descriptors
801031b0:	e8 8b 3b 00 00       	call   80106d40 <seginit>
  picinit();       // disable pic
801031b5:	e8 46 03 00 00       	call   80103500 <picinit>
  ioapicinit();    // another interrupt controller
801031ba:	e8 41 f3 ff ff       	call   80102500 <ioapicinit>
  consoleinit();   // console hardware
801031bf:	e8 fc d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801031c4:	e8 47 2e 00 00       	call   80106010 <uartinit>
  pinit();         // process table
801031c9:	e8 32 08 00 00       	call   80103a00 <pinit>
  tvinit();        // trap vectors
801031ce:	e8 8d 2a 00 00       	call   80105c60 <tvinit>
  binit();         // buffer cache
801031d3:	e8 68 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031d8:	e8 b3 db ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk 
801031dd:	e8 fe f0 ff ff       	call   801022e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031e2:	83 c4 0c             	add    $0xc,%esp
801031e5:	68 8a 00 00 00       	push   $0x8a
801031ea:	68 8c a4 10 80       	push   $0x8010a48c
801031ef:	68 00 70 00 80       	push   $0x80007000
801031f4:	e8 e7 15 00 00       	call   801047e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031f9:	69 05 c0 2d 11 80 b0 	imul   $0xb0,0x80112dc0,%eax
80103200:	00 00 00 
80103203:	83 c4 10             	add    $0x10,%esp
80103206:	05 40 28 11 80       	add    $0x80112840,%eax
8010320b:	3d 40 28 11 80       	cmp    $0x80112840,%eax
80103210:	76 71                	jbe    80103283 <main+0x103>
80103212:	bb 40 28 11 80       	mov    $0x80112840,%ebx
80103217:	89 f6                	mov    %esi,%esi
80103219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103220:	e8 fb 07 00 00       	call   80103a20 <mycpu>
80103225:	39 d8                	cmp    %ebx,%eax
80103227:	74 41                	je     8010326a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103229:	e8 72 f5 ff ff       	call   801027a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010322e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103233:	c7 05 f8 6f 00 80 60 	movl   $0x80103160,0x80006ff8
8010323a:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010323d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103244:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103247:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010324c:	0f b6 03             	movzbl (%ebx),%eax
8010324f:	83 ec 08             	sub    $0x8,%esp
80103252:	68 00 70 00 00       	push   $0x7000
80103257:	50                   	push   %eax
80103258:	e8 03 f8 ff ff       	call   80102a60 <lapicstartap>
8010325d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103260:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103266:	85 c0                	test   %eax,%eax
80103268:	74 f6                	je     80103260 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010326a:	69 05 c0 2d 11 80 b0 	imul   $0xb0,0x80112dc0,%eax
80103271:	00 00 00 
80103274:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010327a:	05 40 28 11 80       	add    $0x80112840,%eax
8010327f:	39 c3                	cmp    %eax,%ebx
80103281:	72 9d                	jb     80103220 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103283:	83 ec 08             	sub    $0x8,%esp
80103286:	68 00 00 00 8e       	push   $0x8e000000
8010328b:	68 00 00 40 80       	push   $0x80400000
80103290:	e8 ab f4 ff ff       	call   80102740 <kinit2>
  userinit();      // first user process
80103295:	e8 56 08 00 00       	call   80103af0 <userinit>
  mpmain();        // finish this processor's setup
8010329a:	e8 81 fe ff ff       	call   80103120 <mpmain>
8010329f:	90                   	nop

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
801032b8:	90                   	nop
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032c0:	39 fb                	cmp    %edi,%ebx
801032c2:	89 fe                	mov    %edi,%esi
801032c4:	76 42                	jbe    80103308 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032c6:	83 ec 04             	sub    $0x4,%esp
801032c9:	8d 7e 10             	lea    0x10(%esi),%edi
801032cc:	6a 04                	push   $0x4
801032ce:	68 b8 79 10 80       	push   $0x801079b8
801032d3:	56                   	push   %esi
801032d4:	e8 a7 14 00 00       	call   80104780 <memcmp>
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	85 c0                	test   %eax,%eax
801032de:	75 e0                	jne    801032c0 <mpsearch1+0x20>
801032e0:	89 f1                	mov    %esi,%ecx
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032e8:	0f b6 11             	movzbl (%ecx),%edx
801032eb:	83 c1 01             	add    $0x1,%ecx
801032ee:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801032f0:	39 f9                	cmp    %edi,%ecx
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
8010330d:	89 f0                	mov    %esi,%eax
8010330f:	5b                   	pop    %ebx
80103310:	5e                   	pop    %esi
80103311:	5f                   	pop    %edi
80103312:	5d                   	pop    %ebp
80103313:	c3                   	ret    
80103314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010331a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
8010333f:	85 c0                	test   %eax,%eax
80103341:	75 1b                	jne    8010335e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103343:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010334a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103351:	c1 e0 08             	shl    $0x8,%eax
80103354:	09 d0                	or     %edx,%eax
80103356:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103359:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010335e:	ba 00 04 00 00       	mov    $0x400,%edx
80103363:	e8 38 ff ff ff       	call   801032a0 <mpsearch1>
80103368:	85 c0                	test   %eax,%eax
8010336a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010336d:	0f 84 3d 01 00 00    	je     801034b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103376:	8b 58 04             	mov    0x4(%eax),%ebx
80103379:	85 db                	test   %ebx,%ebx
8010337b:	0f 84 4f 01 00 00    	je     801034d0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103381:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103387:	83 ec 04             	sub    $0x4,%esp
8010338a:	6a 04                	push   $0x4
8010338c:	68 d5 79 10 80       	push   $0x801079d5
80103391:	56                   	push   %esi
80103392:	e8 e9 13 00 00       	call   80104780 <memcmp>
80103397:	83 c4 10             	add    $0x10,%esp
8010339a:	85 c0                	test   %eax,%eax
8010339c:	0f 85 2e 01 00 00    	jne    801034d0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801033a2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801033a9:	3c 01                	cmp    $0x1,%al
801033ab:	0f 95 c2             	setne  %dl
801033ae:	3c 04                	cmp    $0x4,%al
801033b0:	0f 95 c0             	setne  %al
801033b3:	20 c2                	and    %al,%dl
801033b5:	0f 85 15 01 00 00    	jne    801034d0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801033bb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801033c2:	66 85 ff             	test   %di,%di
801033c5:	74 1a                	je     801033e1 <mpinit+0xc1>
801033c7:	89 f0                	mov    %esi,%eax
801033c9:	01 f7                	add    %esi,%edi
  sum = 0;
801033cb:	31 d2                	xor    %edx,%edx
801033cd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033d0:	0f b6 08             	movzbl (%eax),%ecx
801033d3:	83 c0 01             	add    $0x1,%eax
801033d6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033d8:	39 c7                	cmp    %eax,%edi
801033da:	75 f4                	jne    801033d0 <mpinit+0xb0>
801033dc:	84 d2                	test   %dl,%dl
801033de:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801033e1:	85 f6                	test   %esi,%esi
801033e3:	0f 84 e7 00 00 00    	je     801034d0 <mpinit+0x1b0>
801033e9:	84 d2                	test   %dl,%dl
801033eb:	0f 85 df 00 00 00    	jne    801034d0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033f1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801033f7:	a3 3c 27 11 80       	mov    %eax,0x8011273c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033fc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103403:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103409:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010340e:	01 d6                	add    %edx,%esi
80103410:	39 c6                	cmp    %eax,%esi
80103412:	76 23                	jbe    80103437 <mpinit+0x117>
    switch(*p){
80103414:	0f b6 10             	movzbl (%eax),%edx
80103417:	80 fa 04             	cmp    $0x4,%dl
8010341a:	0f 87 ca 00 00 00    	ja     801034ea <mpinit+0x1ca>
80103420:	ff 24 95 fc 79 10 80 	jmp    *-0x7fef8604(,%edx,4)
80103427:	89 f6                	mov    %esi,%esi
80103429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103430:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103433:	39 c6                	cmp    %eax,%esi
80103435:	77 dd                	ja     80103414 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103437:	85 db                	test   %ebx,%ebx
80103439:	0f 84 9e 00 00 00    	je     801034dd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010343f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103442:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103446:	74 15                	je     8010345d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103448:	b8 70 00 00 00       	mov    $0x70,%eax
8010344d:	ba 22 00 00 00       	mov    $0x22,%edx
80103452:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103453:	ba 23 00 00 00       	mov    $0x23,%edx
80103458:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103459:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010345c:	ee                   	out    %al,(%dx)
  }
}
8010345d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103460:	5b                   	pop    %ebx
80103461:	5e                   	pop    %esi
80103462:	5f                   	pop    %edi
80103463:	5d                   	pop    %ebp
80103464:	c3                   	ret    
80103465:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103468:	8b 0d c0 2d 11 80    	mov    0x80112dc0,%ecx
8010346e:	83 f9 07             	cmp    $0x7,%ecx
80103471:	7f 19                	jg     8010348c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103473:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103477:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010347d:	83 c1 01             	add    $0x1,%ecx
80103480:	89 0d c0 2d 11 80    	mov    %ecx,0x80112dc0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103486:	88 97 40 28 11 80    	mov    %dl,-0x7feed7c0(%edi)
      p += sizeof(struct mpproc);
8010348c:	83 c0 14             	add    $0x14,%eax
      continue;
8010348f:	e9 7c ff ff ff       	jmp    80103410 <mpinit+0xf0>
80103494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103498:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010349c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010349f:	88 15 20 28 11 80    	mov    %dl,0x80112820
      continue;
801034a5:	e9 66 ff ff ff       	jmp    80103410 <mpinit+0xf0>
801034aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801034b0:	ba 00 00 01 00       	mov    $0x10000,%edx
801034b5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801034ba:	e8 e1 fd ff ff       	call   801032a0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034bf:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801034c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034c4:	0f 85 a9 fe ff ff    	jne    80103373 <mpinit+0x53>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	68 bd 79 10 80       	push   $0x801079bd
801034d8:	e8 b3 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801034dd:	83 ec 0c             	sub    $0xc,%esp
801034e0:	68 dc 79 10 80       	push   $0x801079dc
801034e5:	e8 a6 ce ff ff       	call   80100390 <panic>
      ismp = 0;
801034ea:	31 db                	xor    %ebx,%ebx
801034ec:	e9 26 ff ff ff       	jmp    80103417 <mpinit+0xf7>
801034f1:	66 90                	xchg   %ax,%ax
801034f3:	66 90                	xchg   %ax,%ax
801034f5:	66 90                	xchg   %ax,%ax
801034f7:	66 90                	xchg   %ax,%ax
801034f9:	66 90                	xchg   %ax,%ax
801034fb:	66 90                	xchg   %ax,%ax
801034fd:	66 90                	xchg   %ax,%ax
801034ff:	90                   	nop

80103500 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103500:	55                   	push   %ebp
80103501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103506:	ba 21 00 00 00       	mov    $0x21,%edx
8010350b:	89 e5                	mov    %esp,%ebp
8010350d:	ee                   	out    %al,(%dx)
8010350e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103513:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103514:	5d                   	pop    %ebp
80103515:	c3                   	ret    
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010352c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010352f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103535:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010353b:	e8 70 d8 ff ff       	call   80100db0 <filealloc>
80103540:	85 c0                	test   %eax,%eax
80103542:	89 03                	mov    %eax,(%ebx)
80103544:	74 22                	je     80103568 <pipealloc+0x48>
80103546:	e8 65 d8 ff ff       	call   80100db0 <filealloc>
8010354b:	85 c0                	test   %eax,%eax
8010354d:	89 06                	mov    %eax,(%esi)
8010354f:	74 3f                	je     80103590 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103551:	e8 4a f2 ff ff       	call   801027a0 <kalloc>
80103556:	85 c0                	test   %eax,%eax
80103558:	89 c7                	mov    %eax,%edi
8010355a:	75 54                	jne    801035b0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010355c:	8b 03                	mov    (%ebx),%eax
8010355e:	85 c0                	test   %eax,%eax
80103560:	75 34                	jne    80103596 <pipealloc+0x76>
80103562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103568:	8b 06                	mov    (%esi),%eax
8010356a:	85 c0                	test   %eax,%eax
8010356c:	74 0c                	je     8010357a <pipealloc+0x5a>
    fileclose(*f1);
8010356e:	83 ec 0c             	sub    $0xc,%esp
80103571:	50                   	push   %eax
80103572:	e8 f9 d8 ff ff       	call   80100e70 <fileclose>
80103577:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010357a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010357d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103582:	5b                   	pop    %ebx
80103583:	5e                   	pop    %esi
80103584:	5f                   	pop    %edi
80103585:	5d                   	pop    %ebp
80103586:	c3                   	ret    
80103587:	89 f6                	mov    %esi,%esi
80103589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103590:	8b 03                	mov    (%ebx),%eax
80103592:	85 c0                	test   %eax,%eax
80103594:	74 e4                	je     8010357a <pipealloc+0x5a>
    fileclose(*f0);
80103596:	83 ec 0c             	sub    $0xc,%esp
80103599:	50                   	push   %eax
8010359a:	e8 d1 d8 ff ff       	call   80100e70 <fileclose>
  if(*f1)
8010359f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801035a1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035a4:	85 c0                	test   %eax,%eax
801035a6:	75 c6                	jne    8010356e <pipealloc+0x4e>
801035a8:	eb d0                	jmp    8010357a <pipealloc+0x5a>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801035b0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801035b3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035ba:	00 00 00 
  p->writeopen = 1;
801035bd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035c4:	00 00 00 
  p->nwrite = 0;
801035c7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035ce:	00 00 00 
  p->nread = 0;
801035d1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035d8:	00 00 00 
  initlock(&p->lock, "pipe");
801035db:	68 10 7a 10 80       	push   $0x80107a10
801035e0:	50                   	push   %eax
801035e1:	e8 fa 0e 00 00       	call   801044e0 <initlock>
  (*f0)->type = FD_PIPE;
801035e6:	8b 03                	mov    (%ebx),%eax
  return 0;
801035e8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035eb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035f1:	8b 03                	mov    (%ebx),%eax
801035f3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035f7:	8b 03                	mov    (%ebx),%eax
801035f9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035fd:	8b 03                	mov    (%ebx),%eax
801035ff:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103602:	8b 06                	mov    (%esi),%eax
80103604:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010360a:	8b 06                	mov    (%esi),%eax
8010360c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103610:	8b 06                	mov    (%esi),%eax
80103612:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103616:	8b 06                	mov    (%esi),%eax
80103618:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010361b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010361e:	31 c0                	xor    %eax,%eax
}
80103620:	5b                   	pop    %ebx
80103621:	5e                   	pop    %esi
80103622:	5f                   	pop    %edi
80103623:	5d                   	pop    %ebp
80103624:	c3                   	ret    
80103625:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103630 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103638:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010363b:	83 ec 0c             	sub    $0xc,%esp
8010363e:	53                   	push   %ebx
8010363f:	e8 dc 0f 00 00       	call   80104620 <acquire>
  if(writable){
80103644:	83 c4 10             	add    $0x10,%esp
80103647:	85 f6                	test   %esi,%esi
80103649:	74 45                	je     80103690 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010364b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103651:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103654:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010365b:	00 00 00 
    wakeup(&p->nread);
8010365e:	50                   	push   %eax
8010365f:	e8 ac 0b 00 00       	call   80104210 <wakeup>
80103664:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103667:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010366d:	85 d2                	test   %edx,%edx
8010366f:	75 0a                	jne    8010367b <pipeclose+0x4b>
80103671:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103677:	85 c0                	test   %eax,%eax
80103679:	74 35                	je     801036b0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010367b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010367e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103681:	5b                   	pop    %ebx
80103682:	5e                   	pop    %esi
80103683:	5d                   	pop    %ebp
    release(&p->lock);
80103684:	e9 57 10 00 00       	jmp    801046e0 <release>
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103690:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103696:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103699:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036a0:	00 00 00 
    wakeup(&p->nwrite);
801036a3:	50                   	push   %eax
801036a4:	e8 67 0b 00 00       	call   80104210 <wakeup>
801036a9:	83 c4 10             	add    $0x10,%esp
801036ac:	eb b9                	jmp    80103667 <pipeclose+0x37>
801036ae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	53                   	push   %ebx
801036b4:	e8 27 10 00 00       	call   801046e0 <release>
    kfree((char*)p);
801036b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036bc:	83 c4 10             	add    $0x10,%esp
}
801036bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036c2:	5b                   	pop    %ebx
801036c3:	5e                   	pop    %esi
801036c4:	5d                   	pop    %ebp
    kfree((char*)p);
801036c5:	e9 26 ef ff ff       	jmp    801025f0 <kfree>
801036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 28             	sub    $0x28,%esp
801036d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036dc:	53                   	push   %ebx
801036dd:	e8 3e 0f 00 00       	call   80104620 <acquire>
  for(i = 0; i < n; i++){
801036e2:	8b 45 10             	mov    0x10(%ebp),%eax
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	85 c0                	test   %eax,%eax
801036ea:	0f 8e c9 00 00 00    	jle    801037b9 <pipewrite+0xe9>
801036f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801036f3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801036ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103702:	03 4d 10             	add    0x10(%ebp),%ecx
80103705:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103708:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010370e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103714:	39 d0                	cmp    %edx,%eax
80103716:	75 71                	jne    80103789 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103718:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010371e:	85 c0                	test   %eax,%eax
80103720:	74 4e                	je     80103770 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103722:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103728:	eb 3a                	jmp    80103764 <pipewrite+0x94>
8010372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	57                   	push   %edi
80103734:	e8 d7 0a 00 00       	call   80104210 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103739:	5a                   	pop    %edx
8010373a:	59                   	pop    %ecx
8010373b:	53                   	push   %ebx
8010373c:	56                   	push   %esi
8010373d:	e8 1e 09 00 00       	call   80104060 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103742:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103748:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010374e:	83 c4 10             	add    $0x10,%esp
80103751:	05 00 02 00 00       	add    $0x200,%eax
80103756:	39 c2                	cmp    %eax,%edx
80103758:	75 36                	jne    80103790 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010375a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103760:	85 c0                	test   %eax,%eax
80103762:	74 0c                	je     80103770 <pipewrite+0xa0>
80103764:	e8 57 03 00 00       	call   80103ac0 <myproc>
80103769:	8b 40 24             	mov    0x24(%eax),%eax
8010376c:	85 c0                	test   %eax,%eax
8010376e:	74 c0                	je     80103730 <pipewrite+0x60>
        release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	53                   	push   %ebx
80103774:	e8 67 0f 00 00       	call   801046e0 <release>
        return -1;
80103779:	83 c4 10             	add    $0x10,%esp
8010377c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103784:	5b                   	pop    %ebx
80103785:	5e                   	pop    %esi
80103786:	5f                   	pop    %edi
80103787:	5d                   	pop    %ebp
80103788:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103789:	89 c2                	mov    %eax,%edx
8010378b:	90                   	nop
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103790:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103793:	8d 42 01             	lea    0x1(%edx),%eax
80103796:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010379c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037a2:	83 c6 01             	add    $0x1,%esi
801037a5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801037a9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037ac:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037af:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037b3:	0f 85 4f ff ff ff    	jne    80103708 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037b9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037bf:	83 ec 0c             	sub    $0xc,%esp
801037c2:	50                   	push   %eax
801037c3:	e8 48 0a 00 00       	call   80104210 <wakeup>
  release(&p->lock);
801037c8:	89 1c 24             	mov    %ebx,(%esp)
801037cb:	e8 10 0f 00 00       	call   801046e0 <release>
  return n;
801037d0:	83 c4 10             	add    $0x10,%esp
801037d3:	8b 45 10             	mov    0x10(%ebp),%eax
801037d6:	eb a9                	jmp    80103781 <pipewrite+0xb1>
801037d8:	90                   	nop
801037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
801037f0:	e8 2b 0e 00 00       	call   80104620 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037fe:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103804:	75 6a                	jne    80103870 <piperead+0x90>
80103806:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010380c:	85 db                	test   %ebx,%ebx
8010380e:	0f 84 c4 00 00 00    	je     801038d8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103814:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010381a:	eb 2d                	jmp    80103849 <piperead+0x69>
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	e8 36 08 00 00       	call   80104060 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103833:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103839:	75 35                	jne    80103870 <piperead+0x90>
8010383b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103841:	85 d2                	test   %edx,%edx
80103843:	0f 84 8f 00 00 00    	je     801038d8 <piperead+0xf8>
    if(myproc()->killed){
80103849:	e8 72 02 00 00       	call   80103ac0 <myproc>
8010384e:	8b 48 24             	mov    0x24(%eax),%ecx
80103851:	85 c9                	test   %ecx,%ecx
80103853:	74 cb                	je     80103820 <piperead+0x40>
      release(&p->lock);
80103855:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103858:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010385d:	56                   	push   %esi
8010385e:	e8 7d 0e 00 00       	call   801046e0 <release>
      return -1;
80103863:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103866:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103869:	89 d8                	mov    %ebx,%eax
8010386b:	5b                   	pop    %ebx
8010386c:	5e                   	pop    %esi
8010386d:	5f                   	pop    %edi
8010386e:	5d                   	pop    %ebp
8010386f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103870:	8b 45 10             	mov    0x10(%ebp),%eax
80103873:	85 c0                	test   %eax,%eax
80103875:	7e 61                	jle    801038d8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103877:	31 db                	xor    %ebx,%ebx
80103879:	eb 13                	jmp    8010388e <piperead+0xae>
8010387b:	90                   	nop
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103880:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103886:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010388c:	74 1f                	je     801038ad <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010388e:	8d 41 01             	lea    0x1(%ecx),%eax
80103891:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103897:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010389d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801038a2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038a5:	83 c3 01             	add    $0x1,%ebx
801038a8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801038ab:	75 d3                	jne    80103880 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038ad:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038b3:	83 ec 0c             	sub    $0xc,%esp
801038b6:	50                   	push   %eax
801038b7:	e8 54 09 00 00       	call   80104210 <wakeup>
  release(&p->lock);
801038bc:	89 34 24             	mov    %esi,(%esp)
801038bf:	e8 1c 0e 00 00       	call   801046e0 <release>
  return i;
801038c4:	83 c4 10             	add    $0x10,%esp
}
801038c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038ca:	89 d8                	mov    %ebx,%eax
801038cc:	5b                   	pop    %ebx
801038cd:	5e                   	pop    %esi
801038ce:	5f                   	pop    %edi
801038cf:	5d                   	pop    %ebp
801038d0:	c3                   	ret    
801038d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038d8:	31 db                	xor    %ebx,%ebx
801038da:	eb d1                	jmp    801038ad <piperead+0xcd>
801038dc:	66 90                	xchg   %ax,%ax
801038de:	66 90                	xchg   %ax,%ax

801038e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e4:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
{
801038e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038ec:	68 e0 2d 11 80       	push   $0x80112de0
801038f1:	e8 2a 0d 00 00       	call   80104620 <acquire>
801038f6:	83 c4 10             	add    $0x10,%esp
801038f9:	eb 10                	jmp    8010390b <allocproc+0x2b>
801038fb:	90                   	nop
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103900:	83 c3 7c             	add    $0x7c,%ebx
80103903:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80103909:	73 75                	jae    80103980 <allocproc+0xa0>
    if(p->state == UNUSED)
8010390b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010390e:	85 c0                	test   %eax,%eax
80103910:	75 ee                	jne    80103900 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103912:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103917:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010391a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103921:	8d 50 01             	lea    0x1(%eax),%edx
80103924:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103927:	68 e0 2d 11 80       	push   $0x80112de0
  p->pid = nextpid++;
8010392c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103932:	e8 a9 0d 00 00       	call   801046e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103937:	e8 64 ee ff ff       	call   801027a0 <kalloc>
8010393c:	83 c4 10             	add    $0x10,%esp
8010393f:	85 c0                	test   %eax,%eax
80103941:	89 43 08             	mov    %eax,0x8(%ebx)
80103944:	74 53                	je     80103999 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103946:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010394c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010394f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103954:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103957:	c7 40 14 4f 5c 10 80 	movl   $0x80105c4f,0x14(%eax)
  p->context = (struct context*)sp;
8010395e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103961:	6a 14                	push   $0x14
80103963:	6a 00                	push   $0x0
80103965:	50                   	push   %eax
80103966:	e8 c5 0d 00 00       	call   80104730 <memset>
  p->context->eip = (uint)forkret;
8010396b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010396e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103971:	c7 40 10 b0 39 10 80 	movl   $0x801039b0,0x10(%eax)
}
80103978:	89 d8                	mov    %ebx,%eax
8010397a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397d:	c9                   	leave  
8010397e:	c3                   	ret    
8010397f:	90                   	nop
  release(&ptable.lock);
80103980:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103983:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103985:	68 e0 2d 11 80       	push   $0x80112de0
8010398a:	e8 51 0d 00 00       	call   801046e0 <release>
}
8010398f:	89 d8                	mov    %ebx,%eax
  return 0;
80103991:	83 c4 10             	add    $0x10,%esp
}
80103994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103997:	c9                   	leave  
80103998:	c3                   	ret    
    p->state = UNUSED;
80103999:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039a0:	31 db                	xor    %ebx,%ebx
801039a2:	eb d4                	jmp    80103978 <allocproc+0x98>
801039a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039b6:	68 e0 2d 11 80       	push   $0x80112de0
801039bb:	e8 20 0d 00 00       	call   801046e0 <release>

  if (first) {
801039c0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	85 c0                	test   %eax,%eax
801039ca:	75 04                	jne    801039d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039cc:	c9                   	leave  
801039cd:	c3                   	ret    
801039ce:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801039d0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801039d3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039da:	00 00 00 
    iinit(ROOTDEV);
801039dd:	6a 01                	push   $0x1
801039df:	e8 cc db ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
801039e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039eb:	e8 f0 f3 ff ff       	call   80102de0 <initlog>
801039f0:	83 c4 10             	add    $0x10,%esp
}
801039f3:	c9                   	leave  
801039f4:	c3                   	ret    
801039f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a00 <pinit>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a06:	68 15 7a 10 80       	push   $0x80107a15
80103a0b:	68 e0 2d 11 80       	push   $0x80112de0
80103a10:	e8 cb 0a 00 00       	call   801044e0 <initlock>
}
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	c9                   	leave  
80103a19:	c3                   	ret    
80103a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a20 <mycpu>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a25:	9c                   	pushf  
80103a26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a27:	f6 c4 02             	test   $0x2,%ah
80103a2a:	75 5e                	jne    80103a8a <mycpu+0x6a>
  apicid = lapicid();
80103a2c:	e8 df ef ff ff       	call   80102a10 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a31:	8b 35 c0 2d 11 80    	mov    0x80112dc0,%esi
80103a37:	85 f6                	test   %esi,%esi
80103a39:	7e 42                	jle    80103a7d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a3b:	0f b6 15 40 28 11 80 	movzbl 0x80112840,%edx
80103a42:	39 d0                	cmp    %edx,%eax
80103a44:	74 30                	je     80103a76 <mycpu+0x56>
80103a46:	b9 f0 28 11 80       	mov    $0x801128f0,%ecx
  for (i = 0; i < ncpu; ++i) {
80103a4b:	31 d2                	xor    %edx,%edx
80103a4d:	8d 76 00             	lea    0x0(%esi),%esi
80103a50:	83 c2 01             	add    $0x1,%edx
80103a53:	39 f2                	cmp    %esi,%edx
80103a55:	74 26                	je     80103a7d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a57:	0f b6 19             	movzbl (%ecx),%ebx
80103a5a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103a60:	39 c3                	cmp    %eax,%ebx
80103a62:	75 ec                	jne    80103a50 <mycpu+0x30>
80103a64:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103a6a:	05 40 28 11 80       	add    $0x80112840,%eax
}
80103a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a72:	5b                   	pop    %ebx
80103a73:	5e                   	pop    %esi
80103a74:	5d                   	pop    %ebp
80103a75:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a76:	b8 40 28 11 80       	mov    $0x80112840,%eax
      return &cpus[i];
80103a7b:	eb f2                	jmp    80103a6f <mycpu+0x4f>
  panic("unknown apicid\n");
80103a7d:	83 ec 0c             	sub    $0xc,%esp
80103a80:	68 1c 7a 10 80       	push   $0x80107a1c
80103a85:	e8 06 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a8a:	83 ec 0c             	sub    $0xc,%esp
80103a8d:	68 f8 7a 10 80       	push   $0x80107af8
80103a92:	e8 f9 c8 ff ff       	call   80100390 <panic>
80103a97:	89 f6                	mov    %esi,%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103aa0 <cpuid>:
cpuid() {
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103aa6:	e8 75 ff ff ff       	call   80103a20 <mycpu>
80103aab:	2d 40 28 11 80       	sub    $0x80112840,%eax
}
80103ab0:	c9                   	leave  
  return mycpu()-cpus;
80103ab1:	c1 f8 04             	sar    $0x4,%eax
80103ab4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aba:	c3                   	ret    
80103abb:	90                   	nop
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <myproc>:
myproc(void) {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
80103ac4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ac7:	e8 84 0a 00 00       	call   80104550 <pushcli>
  c = mycpu();
80103acc:	e8 4f ff ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103ad1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad7:	e8 b4 0a 00 00       	call   80104590 <popcli>
}
80103adc:	83 c4 04             	add    $0x4,%esp
80103adf:	89 d8                	mov    %ebx,%eax
80103ae1:	5b                   	pop    %ebx
80103ae2:	5d                   	pop    %ebp
80103ae3:	c3                   	ret    
80103ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103af0 <userinit>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
80103af4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103af7:	e8 e4 fd ff ff       	call   801038e0 <allocproc>
80103afc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103afe:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103b03:	e8 18 37 00 00       	call   80107220 <setupkvm>
80103b08:	85 c0                	test   %eax,%eax
80103b0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b0d:	0f 84 bf 00 00 00    	je     80103bd2 <userinit+0xe2>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b13:	83 ec 04             	sub    $0x4,%esp
80103b16:	68 2c 00 00 00       	push   $0x2c
80103b1b:	68 60 a4 10 80       	push   $0x8010a460
80103b20:	50                   	push   %eax
80103b21:	e8 da 33 00 00       	call   80106f00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b2f:	6a 4c                	push   $0x4c
80103b31:	6a 00                	push   $0x0
80103b33:	ff 73 18             	pushl  0x18(%ebx)
80103b36:	e8 f5 0b 00 00       	call   80104730 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b43:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b48:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b56:	8b 43 18             	mov    0x18(%ebx),%eax
80103b59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b61:	8b 43 18             	mov    0x18(%ebx),%eax
80103b64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b76:	8b 43 18             	mov    0x18(%ebx),%eax
80103b79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b80:	8b 43 18             	mov    0x18(%ebx),%eax
80103b83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b8d:	6a 10                	push   $0x10
80103b8f:	68 45 7a 10 80       	push   $0x80107a45
80103b94:	50                   	push   %eax
80103b95:	e8 76 0d 00 00       	call   80104910 <safestrcpy>
  p->cwd = namei("/", 1);
80103b9a:	58                   	pop    %eax
80103b9b:	5a                   	pop    %edx
80103b9c:	6a 01                	push   $0x1
80103b9e:	68 4e 7a 10 80       	push   $0x80107a4e
80103ba3:	e8 18 e6 ff ff       	call   801021c0 <namei>
80103ba8:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bab:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103bb2:	e8 69 0a 00 00       	call   80104620 <acquire>
  p->state = RUNNABLE;
80103bb7:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bbe:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103bc5:	e8 16 0b 00 00       	call   801046e0 <release>
}
80103bca:	83 c4 10             	add    $0x10,%esp
80103bcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bd0:	c9                   	leave  
80103bd1:	c3                   	ret    
    panic("userinit: out of memory?");
80103bd2:	83 ec 0c             	sub    $0xc,%esp
80103bd5:	68 2c 7a 10 80       	push   $0x80107a2c
80103bda:	e8 b1 c7 ff ff       	call   80100390 <panic>
80103bdf:	90                   	nop

80103be0 <growproc>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
80103be5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103be8:	e8 63 09 00 00       	call   80104550 <pushcli>
  c = mycpu();
80103bed:	e8 2e fe ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103bf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf8:	e8 93 09 00 00       	call   80104590 <popcli>
  if(n > 0){
80103bfd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c00:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c02:	7f 1c                	jg     80103c20 <growproc+0x40>
  } else if(n < 0){
80103c04:	75 3a                	jne    80103c40 <growproc+0x60>
  switchuvm(curproc);
80103c06:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c09:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c0b:	53                   	push   %ebx
80103c0c:	e8 df 31 00 00       	call   80106df0 <switchuvm>
  return 0;
80103c11:	83 c4 10             	add    $0x10,%esp
80103c14:	31 c0                	xor    %eax,%eax
}
80103c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c19:	5b                   	pop    %ebx
80103c1a:	5e                   	pop    %esi
80103c1b:	5d                   	pop    %ebp
80103c1c:	c3                   	ret    
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c20:	83 ec 04             	sub    $0x4,%esp
80103c23:	01 c6                	add    %eax,%esi
80103c25:	56                   	push   %esi
80103c26:	50                   	push   %eax
80103c27:	ff 73 04             	pushl  0x4(%ebx)
80103c2a:	e8 11 34 00 00       	call   80107040 <allocuvm>
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 d0                	jne    80103c06 <growproc+0x26>
      return -1;
80103c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c3b:	eb d9                	jmp    80103c16 <growproc+0x36>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	pushl  0x4(%ebx)
80103c4a:	e8 21 35 00 00       	call   80107170 <deallocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 b0                	jne    80103c06 <growproc+0x26>
80103c56:	eb de                	jmp    80103c36 <growproc+0x56>
80103c58:	90                   	nop
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <fork>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c69:	e8 e2 08 00 00       	call   80104550 <pushcli>
  c = mycpu();
80103c6e:	e8 ad fd ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103c73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c79:	e8 12 09 00 00       	call   80104590 <popcli>
  if((np = allocproc()) == 0){
80103c7e:	e8 5d fc ff ff       	call   801038e0 <allocproc>
80103c83:	85 c0                	test   %eax,%eax
80103c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c88:	0f 84 b7 00 00 00    	je     80103d45 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c8e:	83 ec 08             	sub    $0x8,%esp
80103c91:	ff 33                	pushl  (%ebx)
80103c93:	ff 73 04             	pushl  0x4(%ebx)
80103c96:	89 c7                	mov    %eax,%edi
80103c98:	e8 53 36 00 00       	call   801072f0 <copyuvm>
80103c9d:	83 c4 10             	add    $0x10,%esp
80103ca0:	85 c0                	test   %eax,%eax
80103ca2:	89 47 04             	mov    %eax,0x4(%edi)
80103ca5:	0f 84 a1 00 00 00    	je     80103d4c <fork+0xec>
  np->sz = curproc->sz;
80103cab:	8b 03                	mov    (%ebx),%eax
80103cad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cb0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103cb2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103cb5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103cb7:	8b 79 18             	mov    0x18(%ecx),%edi
80103cba:	8b 73 18             	mov    0x18(%ebx),%esi
80103cbd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cc4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cc6:	8b 40 18             	mov    0x18(%eax),%eax
80103cc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103cd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cd4:	85 c0                	test   %eax,%eax
80103cd6:	74 13                	je     80103ceb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cd8:	83 ec 0c             	sub    $0xc,%esp
80103cdb:	50                   	push   %eax
80103cdc:	e8 3f d1 ff ff       	call   80100e20 <filedup>
80103ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ceb:	83 c6 01             	add    $0x1,%esi
80103cee:	83 fe 10             	cmp    $0x10,%esi
80103cf1:	75 dd                	jne    80103cd0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cfc:	e8 7f da ff ff       	call   80101780 <idup>
80103d01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d0d:	6a 10                	push   $0x10
80103d0f:	53                   	push   %ebx
80103d10:	50                   	push   %eax
80103d11:	e8 fa 0b 00 00       	call   80104910 <safestrcpy>
  pid = np->pid;
80103d16:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d19:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103d20:	e8 fb 08 00 00       	call   80104620 <acquire>
  np->state = RUNNABLE;
80103d25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d2c:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103d33:	e8 a8 09 00 00       	call   801046e0 <release>
  return pid;
80103d38:	83 c4 10             	add    $0x10,%esp
}
80103d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d3e:	89 d8                	mov    %ebx,%eax
80103d40:	5b                   	pop    %ebx
80103d41:	5e                   	pop    %esi
80103d42:	5f                   	pop    %edi
80103d43:	5d                   	pop    %ebp
80103d44:	c3                   	ret    
    return -1;
80103d45:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d4a:	eb ef                	jmp    80103d3b <fork+0xdb>
    kfree(np->kstack);
80103d4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d4f:	83 ec 0c             	sub    $0xc,%esp
80103d52:	ff 73 08             	pushl  0x8(%ebx)
80103d55:	e8 96 e8 ff ff       	call   801025f0 <kfree>
    np->kstack = 0;
80103d5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103d61:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d68:	83 c4 10             	add    $0x10,%esp
80103d6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d70:	eb c9                	jmp    80103d3b <fork+0xdb>
80103d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <scheduler>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d89:	e8 92 fc ff ff       	call   80103a20 <mycpu>
80103d8e:	8d 78 04             	lea    0x4(%eax),%edi
80103d91:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d93:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d9a:	00 00 00 
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103da0:	fb                   	sti    
    acquire(&ptable.lock);
80103da1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da4:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
    acquire(&ptable.lock);
80103da9:	68 e0 2d 11 80       	push   $0x80112de0
80103dae:	e8 6d 08 00 00       	call   80104620 <acquire>
80103db3:	83 c4 10             	add    $0x10,%esp
80103db6:	8d 76 00             	lea    0x0(%esi),%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103dc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103dc4:	75 33                	jne    80103df9 <scheduler+0x79>
      switchuvm(p);
80103dc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103dc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103dcf:	53                   	push   %ebx
80103dd0:	e8 1b 30 00 00       	call   80106df0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103dd5:	58                   	pop    %eax
80103dd6:	5a                   	pop    %edx
80103dd7:	ff 73 1c             	pushl  0x1c(%ebx)
80103dda:	57                   	push   %edi
      p->state = RUNNING;
80103ddb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103de2:	e8 84 0b 00 00       	call   8010496b <swtch>
      switchkvm();
80103de7:	e8 e4 2f 00 00       	call   80106dd0 <switchkvm>
      c->proc = 0;
80103dec:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103df3:	00 00 00 
80103df6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df9:	83 c3 7c             	add    $0x7c,%ebx
80103dfc:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80103e02:	72 bc                	jb     80103dc0 <scheduler+0x40>
    release(&ptable.lock);
80103e04:	83 ec 0c             	sub    $0xc,%esp
80103e07:	68 e0 2d 11 80       	push   $0x80112de0
80103e0c:	e8 cf 08 00 00       	call   801046e0 <release>
    sti();
80103e11:	83 c4 10             	add    $0x10,%esp
80103e14:	eb 8a                	jmp    80103da0 <scheduler+0x20>
80103e16:	8d 76 00             	lea    0x0(%esi),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <sched>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	56                   	push   %esi
80103e24:	53                   	push   %ebx
  pushcli();
80103e25:	e8 26 07 00 00       	call   80104550 <pushcli>
  c = mycpu();
80103e2a:	e8 f1 fb ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103e2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e35:	e8 56 07 00 00       	call   80104590 <popcli>
  if(!holding(&ptable.lock))
80103e3a:	83 ec 0c             	sub    $0xc,%esp
80103e3d:	68 e0 2d 11 80       	push   $0x80112de0
80103e42:	e8 a9 07 00 00       	call   801045f0 <holding>
80103e47:	83 c4 10             	add    $0x10,%esp
80103e4a:	85 c0                	test   %eax,%eax
80103e4c:	74 4f                	je     80103e9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e4e:	e8 cd fb ff ff       	call   80103a20 <mycpu>
80103e53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e5a:	75 68                	jne    80103ec4 <sched+0xa4>
  if(p->state == RUNNING)
80103e5c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e60:	74 55                	je     80103eb7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e62:	9c                   	pushf  
80103e63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e64:	f6 c4 02             	test   $0x2,%ah
80103e67:	75 41                	jne    80103eaa <sched+0x8a>
  intena = mycpu()->intena;
80103e69:	e8 b2 fb ff ff       	call   80103a20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e6e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e77:	e8 a4 fb ff ff       	call   80103a20 <mycpu>
80103e7c:	83 ec 08             	sub    $0x8,%esp
80103e7f:	ff 70 04             	pushl  0x4(%eax)
80103e82:	53                   	push   %ebx
80103e83:	e8 e3 0a 00 00       	call   8010496b <swtch>
  mycpu()->intena = intena;
80103e88:	e8 93 fb ff ff       	call   80103a20 <mycpu>
}
80103e8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e99:	5b                   	pop    %ebx
80103e9a:	5e                   	pop    %esi
80103e9b:	5d                   	pop    %ebp
80103e9c:	c3                   	ret    
    panic("sched ptable.lock");
80103e9d:	83 ec 0c             	sub    $0xc,%esp
80103ea0:	68 50 7a 10 80       	push   $0x80107a50
80103ea5:	e8 e6 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 7c 7a 10 80       	push   $0x80107a7c
80103eb2:	e8 d9 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103eb7:	83 ec 0c             	sub    $0xc,%esp
80103eba:	68 6e 7a 10 80       	push   $0x80107a6e
80103ebf:	e8 cc c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 62 7a 10 80       	push   $0x80107a62
80103ecc:	e8 bf c4 ff ff       	call   80100390 <panic>
80103ed1:	eb 0d                	jmp    80103ee0 <exit>
80103ed3:	90                   	nop
80103ed4:	90                   	nop
80103ed5:	90                   	nop
80103ed6:	90                   	nop
80103ed7:	90                   	nop
80103ed8:	90                   	nop
80103ed9:	90                   	nop
80103eda:	90                   	nop
80103edb:	90                   	nop
80103edc:	90                   	nop
80103edd:	90                   	nop
80103ede:	90                   	nop
80103edf:	90                   	nop

80103ee0 <exit>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ee9:	e8 62 06 00 00       	call   80104550 <pushcli>
  c = mycpu();
80103eee:	e8 2d fb ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103ef3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ef9:	e8 92 06 00 00       	call   80104590 <popcli>
  if(curproc == initproc)
80103efe:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103f04:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f07:	8d 7e 68             	lea    0x68(%esi),%edi
80103f0a:	0f 84 e7 00 00 00    	je     80103ff7 <exit+0x117>
    if(curproc->ofile[fd]){
80103f10:	8b 03                	mov    (%ebx),%eax
80103f12:	85 c0                	test   %eax,%eax
80103f14:	74 12                	je     80103f28 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	50                   	push   %eax
80103f1a:	e8 51 cf ff ff       	call   80100e70 <fileclose>
      curproc->ofile[fd] = 0;
80103f1f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f25:	83 c4 10             	add    $0x10,%esp
80103f28:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103f2b:	39 fb                	cmp    %edi,%ebx
80103f2d:	75 e1                	jne    80103f10 <exit+0x30>
  begin_op();
80103f2f:	e8 4c ef ff ff       	call   80102e80 <begin_op>
  iput(curproc->cwd);
80103f34:	83 ec 0c             	sub    $0xc,%esp
80103f37:	ff 76 68             	pushl  0x68(%esi)
80103f3a:	e8 a1 d9 ff ff       	call   801018e0 <iput>
  end_op();
80103f3f:	e8 ac ef ff ff       	call   80102ef0 <end_op>
  curproc->cwd = 0;
80103f44:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f4b:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80103f52:	e8 c9 06 00 00       	call   80104620 <acquire>
  wakeup1(curproc->parent);
80103f57:	8b 56 14             	mov    0x14(%esi),%edx
80103f5a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f5d:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
80103f62:	eb 0e                	jmp    80103f72 <exit+0x92>
80103f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f68:	83 c0 7c             	add    $0x7c,%eax
80103f6b:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103f70:	73 1c                	jae    80103f8e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103f72:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f76:	75 f0                	jne    80103f68 <exit+0x88>
80103f78:	3b 50 20             	cmp    0x20(%eax),%edx
80103f7b:	75 eb                	jne    80103f68 <exit+0x88>
      p->state = RUNNABLE;
80103f7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f84:	83 c0 7c             	add    $0x7c,%eax
80103f87:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103f8c:	72 e4                	jb     80103f72 <exit+0x92>
      p->parent = initproc;
80103f8e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f94:	ba 14 2e 11 80       	mov    $0x80112e14,%edx
80103f99:	eb 10                	jmp    80103fab <exit+0xcb>
80103f9b:	90                   	nop
80103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa0:	83 c2 7c             	add    $0x7c,%edx
80103fa3:	81 fa 14 4d 11 80    	cmp    $0x80114d14,%edx
80103fa9:	73 33                	jae    80103fde <exit+0xfe>
    if(p->parent == curproc){
80103fab:	39 72 14             	cmp    %esi,0x14(%edx)
80103fae:	75 f0                	jne    80103fa0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103fb0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fb4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fb7:	75 e7                	jne    80103fa0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb9:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
80103fbe:	eb 0a                	jmp    80103fca <exit+0xea>
80103fc0:	83 c0 7c             	add    $0x7c,%eax
80103fc3:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80103fc8:	73 d6                	jae    80103fa0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103fca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fce:	75 f0                	jne    80103fc0 <exit+0xe0>
80103fd0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fd3:	75 eb                	jne    80103fc0 <exit+0xe0>
      p->state = RUNNABLE;
80103fd5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fdc:	eb e2                	jmp    80103fc0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fde:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103fe5:	e8 36 fe ff ff       	call   80103e20 <sched>
  panic("zombie exit");
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 9d 7a 10 80       	push   $0x80107a9d
80103ff2:	e8 99 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103ff7:	83 ec 0c             	sub    $0xc,%esp
80103ffa:	68 90 7a 10 80       	push   $0x80107a90
80103fff:	e8 8c c3 ff ff       	call   80100390 <panic>
80104004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010400a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104010 <yield>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104017:	68 e0 2d 11 80       	push   $0x80112de0
8010401c:	e8 ff 05 00 00       	call   80104620 <acquire>
  pushcli();
80104021:	e8 2a 05 00 00       	call   80104550 <pushcli>
  c = mycpu();
80104026:	e8 f5 f9 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
8010402b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104031:	e8 5a 05 00 00       	call   80104590 <popcli>
  myproc()->state = RUNNABLE;
80104036:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010403d:	e8 de fd ff ff       	call   80103e20 <sched>
  release(&ptable.lock);
80104042:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
80104049:	e8 92 06 00 00       	call   801046e0 <release>
}
8010404e:	83 c4 10             	add    $0x10,%esp
80104051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104054:	c9                   	leave  
80104055:	c3                   	ret    
80104056:	8d 76 00             	lea    0x0(%esi),%esi
80104059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104060 <sleep>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	83 ec 0c             	sub    $0xc,%esp
80104069:	8b 7d 08             	mov    0x8(%ebp),%edi
8010406c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010406f:	e8 dc 04 00 00       	call   80104550 <pushcli>
  c = mycpu();
80104074:	e8 a7 f9 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104079:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010407f:	e8 0c 05 00 00       	call   80104590 <popcli>
  if(p == 0)
80104084:	85 db                	test   %ebx,%ebx
80104086:	0f 84 87 00 00 00    	je     80104113 <sleep+0xb3>
  if(lk == 0)
8010408c:	85 f6                	test   %esi,%esi
8010408e:	74 76                	je     80104106 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104090:	81 fe e0 2d 11 80    	cmp    $0x80112de0,%esi
80104096:	74 50                	je     801040e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	68 e0 2d 11 80       	push   $0x80112de0
801040a0:	e8 7b 05 00 00       	call   80104620 <acquire>
    release(lk);
801040a5:	89 34 24             	mov    %esi,(%esp)
801040a8:	e8 33 06 00 00       	call   801046e0 <release>
  p->chan = chan;
801040ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040b7:	e8 64 fd ff ff       	call   80103e20 <sched>
  p->chan = 0;
801040bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040c3:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
801040ca:	e8 11 06 00 00       	call   801046e0 <release>
    acquire(lk);
801040cf:	89 75 08             	mov    %esi,0x8(%ebp)
801040d2:	83 c4 10             	add    $0x10,%esp
}
801040d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d8:	5b                   	pop    %ebx
801040d9:	5e                   	pop    %esi
801040da:	5f                   	pop    %edi
801040db:	5d                   	pop    %ebp
    acquire(lk);
801040dc:	e9 3f 05 00 00       	jmp    80104620 <acquire>
801040e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040f2:	e8 29 fd ff ff       	call   80103e20 <sched>
  p->chan = 0;
801040f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104101:	5b                   	pop    %ebx
80104102:	5e                   	pop    %esi
80104103:	5f                   	pop    %edi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret    
    panic("sleep without lk");
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	68 af 7a 10 80       	push   $0x80107aaf
8010410e:	e8 7d c2 ff ff       	call   80100390 <panic>
    panic("sleep");
80104113:	83 ec 0c             	sub    $0xc,%esp
80104116:	68 a9 7a 10 80       	push   $0x80107aa9
8010411b:	e8 70 c2 ff ff       	call   80100390 <panic>

80104120 <wait>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
  pushcli();
80104125:	e8 26 04 00 00       	call   80104550 <pushcli>
  c = mycpu();
8010412a:	e8 f1 f8 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
8010412f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104135:	e8 56 04 00 00       	call   80104590 <popcli>
  acquire(&ptable.lock);
8010413a:	83 ec 0c             	sub    $0xc,%esp
8010413d:	68 e0 2d 11 80       	push   $0x80112de0
80104142:	e8 d9 04 00 00       	call   80104620 <acquire>
80104147:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010414a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414c:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
80104151:	eb 10                	jmp    80104163 <wait+0x43>
80104153:	90                   	nop
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104158:	83 c3 7c             	add    $0x7c,%ebx
8010415b:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80104161:	73 1b                	jae    8010417e <wait+0x5e>
      if(p->parent != curproc)
80104163:	39 73 14             	cmp    %esi,0x14(%ebx)
80104166:	75 f0                	jne    80104158 <wait+0x38>
      if(p->state == ZOMBIE){
80104168:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010416c:	74 32                	je     801041a0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010416e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104171:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104176:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
8010417c:	72 e5                	jb     80104163 <wait+0x43>
    if(!havekids || curproc->killed){
8010417e:	85 c0                	test   %eax,%eax
80104180:	74 74                	je     801041f6 <wait+0xd6>
80104182:	8b 46 24             	mov    0x24(%esi),%eax
80104185:	85 c0                	test   %eax,%eax
80104187:	75 6d                	jne    801041f6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104189:	83 ec 08             	sub    $0x8,%esp
8010418c:	68 e0 2d 11 80       	push   $0x80112de0
80104191:	56                   	push   %esi
80104192:	e8 c9 fe ff ff       	call   80104060 <sleep>
    havekids = 0;
80104197:	83 c4 10             	add    $0x10,%esp
8010419a:	eb ae                	jmp    8010414a <wait+0x2a>
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801041a6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041a9:	e8 42 e4 ff ff       	call   801025f0 <kfree>
        freevm(p->pgdir);
801041ae:	5a                   	pop    %edx
801041af:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801041b2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041b9:	e8 e2 2f 00 00       	call   801071a0 <freevm>
        release(&ptable.lock);
801041be:	c7 04 24 e0 2d 11 80 	movl   $0x80112de0,(%esp)
        p->pid = 0;
801041c5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041cc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041d3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041d7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041de:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041e5:	e8 f6 04 00 00       	call   801046e0 <release>
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
801041fe:	68 e0 2d 11 80       	push   $0x80112de0
80104203:	e8 d8 04 00 00       	call   801046e0 <release>
      return -1;
80104208:	83 c4 10             	add    $0x10,%esp
8010420b:	eb e0                	jmp    801041ed <wait+0xcd>
8010420d:	8d 76 00             	lea    0x0(%esi),%esi

80104210 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 10             	sub    $0x10,%esp
80104217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010421a:	68 e0 2d 11 80       	push   $0x80112de0
8010421f:	e8 fc 03 00 00       	call   80104620 <acquire>
80104224:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104227:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
8010422c:	eb 0c                	jmp    8010423a <wakeup+0x2a>
8010422e:	66 90                	xchg   %ax,%ax
80104230:	83 c0 7c             	add    $0x7c,%eax
80104233:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80104238:	73 1c                	jae    80104256 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010423a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010423e:	75 f0                	jne    80104230 <wakeup+0x20>
80104240:	3b 58 20             	cmp    0x20(%eax),%ebx
80104243:	75 eb                	jne    80104230 <wakeup+0x20>
      p->state = RUNNABLE;
80104245:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010424c:	83 c0 7c             	add    $0x7c,%eax
8010424f:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80104254:	72 e4                	jb     8010423a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104256:	c7 45 08 e0 2d 11 80 	movl   $0x80112de0,0x8(%ebp)
}
8010425d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104260:	c9                   	leave  
  release(&ptable.lock);
80104261:	e9 7a 04 00 00       	jmp    801046e0 <release>
80104266:	8d 76 00             	lea    0x0(%esi),%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104270 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	53                   	push   %ebx
80104274:	83 ec 10             	sub    $0x10,%esp
80104277:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010427a:	68 e0 2d 11 80       	push   $0x80112de0
8010427f:	e8 9c 03 00 00       	call   80104620 <acquire>
80104284:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104287:	b8 14 2e 11 80       	mov    $0x80112e14,%eax
8010428c:	eb 0c                	jmp    8010429a <kill+0x2a>
8010428e:	66 90                	xchg   %ax,%ax
80104290:	83 c0 7c             	add    $0x7c,%eax
80104293:	3d 14 4d 11 80       	cmp    $0x80114d14,%eax
80104298:	73 36                	jae    801042d0 <kill+0x60>
    if(p->pid == pid){
8010429a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010429d:	75 f1                	jne    80104290 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010429f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042aa:	75 07                	jne    801042b3 <kill+0x43>
        p->state = RUNNABLE;
801042ac:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042b3:	83 ec 0c             	sub    $0xc,%esp
801042b6:	68 e0 2d 11 80       	push   $0x80112de0
801042bb:	e8 20 04 00 00       	call   801046e0 <release>
      return 0;
801042c0:	83 c4 10             	add    $0x10,%esp
801042c3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801042c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042c8:	c9                   	leave  
801042c9:	c3                   	ret    
801042ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801042d0:	83 ec 0c             	sub    $0xc,%esp
801042d3:	68 e0 2d 11 80       	push   $0x80112de0
801042d8:	e8 03 04 00 00       	call   801046e0 <release>
  return -1;
801042dd:	83 c4 10             	add    $0x10,%esp
801042e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e8:	c9                   	leave  
801042e9:	c3                   	ret    
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f9:	bb 14 2e 11 80       	mov    $0x80112e14,%ebx
{
801042fe:	83 ec 3c             	sub    $0x3c,%esp
80104301:	eb 24                	jmp    80104327 <procdump+0x37>
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	68 7f 7e 10 80       	push   $0x80107e7f
80104310:	e8 4b c3 ff ff       	call   80100660 <cprintf>
80104315:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104318:	83 c3 7c             	add    $0x7c,%ebx
8010431b:	81 fb 14 4d 11 80    	cmp    $0x80114d14,%ebx
80104321:	0f 83 81 00 00 00    	jae    801043a8 <procdump+0xb8>
    if(p->state == UNUSED)
80104327:	8b 43 0c             	mov    0xc(%ebx),%eax
8010432a:	85 c0                	test   %eax,%eax
8010432c:	74 ea                	je     80104318 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010432e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104331:	ba c0 7a 10 80       	mov    $0x80107ac0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104336:	77 11                	ja     80104349 <procdump+0x59>
80104338:	8b 14 85 20 7b 10 80 	mov    -0x7fef84e0(,%eax,4),%edx
      state = "???";
8010433f:	b8 c0 7a 10 80       	mov    $0x80107ac0,%eax
80104344:	85 d2                	test   %edx,%edx
80104346:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104349:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010434c:	50                   	push   %eax
8010434d:	52                   	push   %edx
8010434e:	ff 73 10             	pushl  0x10(%ebx)
80104351:	68 c4 7a 10 80       	push   $0x80107ac4
80104356:	e8 05 c3 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010435b:	83 c4 10             	add    $0x10,%esp
8010435e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104362:	75 a4                	jne    80104308 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104364:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104367:	83 ec 08             	sub    $0x8,%esp
8010436a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010436d:	50                   	push   %eax
8010436e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104371:	8b 40 0c             	mov    0xc(%eax),%eax
80104374:	83 c0 08             	add    $0x8,%eax
80104377:	50                   	push   %eax
80104378:	e8 83 01 00 00       	call   80104500 <getcallerpcs>
8010437d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104380:	8b 17                	mov    (%edi),%edx
80104382:	85 d2                	test   %edx,%edx
80104384:	74 82                	je     80104308 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104386:	83 ec 08             	sub    $0x8,%esp
80104389:	83 c7 04             	add    $0x4,%edi
8010438c:	52                   	push   %edx
8010438d:	68 01 75 10 80       	push   $0x80107501
80104392:	e8 c9 c2 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104397:	83 c4 10             	add    $0x10,%esp
8010439a:	39 fe                	cmp    %edi,%esi
8010439c:	75 e2                	jne    80104380 <procdump+0x90>
8010439e:	e9 65 ff ff ff       	jmp    80104308 <procdump+0x18>
801043a3:	90                   	nop
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801043a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043ab:	5b                   	pop    %ebx
801043ac:	5e                   	pop    %esi
801043ad:	5f                   	pop    %edi
801043ae:	5d                   	pop    %ebp
801043af:	c3                   	ret    

801043b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 0c             	sub    $0xc,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ba:	68 38 7b 10 80       	push   $0x80107b38
801043bf:	8d 43 04             	lea    0x4(%ebx),%eax
801043c2:	50                   	push   %eax
801043c3:	e8 18 01 00 00       	call   801044e0 <initlock>
  lk->name = name;
801043c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e1:	c9                   	leave  
801043e2:	c3                   	ret    
801043e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	8d 73 04             	lea    0x4(%ebx),%esi
801043fe:	56                   	push   %esi
801043ff:	e8 1c 02 00 00       	call   80104620 <acquire>
  while (lk->locked) {
80104404:	8b 13                	mov    (%ebx),%edx
80104406:	83 c4 10             	add    $0x10,%esp
80104409:	85 d2                	test   %edx,%edx
8010440b:	74 16                	je     80104423 <acquiresleep+0x33>
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104410:	83 ec 08             	sub    $0x8,%esp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	e8 46 fc ff ff       	call   80104060 <sleep>
  while (lk->locked) {
8010441a:	8b 03                	mov    (%ebx),%eax
8010441c:	83 c4 10             	add    $0x10,%esp
8010441f:	85 c0                	test   %eax,%eax
80104421:	75 ed                	jne    80104410 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104423:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104429:	e8 92 f6 ff ff       	call   80103ac0 <myproc>
8010442e:	8b 40 10             	mov    0x10(%eax),%eax
80104431:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104434:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104437:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010443a:	5b                   	pop    %ebx
8010443b:	5e                   	pop    %esi
8010443c:	5d                   	pop    %ebp
  release(&lk->lk);
8010443d:	e9 9e 02 00 00       	jmp    801046e0 <release>
80104442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104450 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	8d 73 04             	lea    0x4(%ebx),%esi
8010445e:	56                   	push   %esi
8010445f:	e8 bc 01 00 00       	call   80104620 <acquire>
  lk->locked = 0;
80104464:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010446a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104471:	89 1c 24             	mov    %ebx,(%esp)
80104474:	e8 97 fd ff ff       	call   80104210 <wakeup>
  release(&lk->lk);
80104479:	89 75 08             	mov    %esi,0x8(%ebp)
8010447c:	83 c4 10             	add    $0x10,%esp
}
8010447f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104482:	5b                   	pop    %ebx
80104483:	5e                   	pop    %esi
80104484:	5d                   	pop    %ebp
  release(&lk->lk);
80104485:	e9 56 02 00 00       	jmp    801046e0 <release>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	31 ff                	xor    %edi,%edi
80104498:	83 ec 18             	sub    $0x18,%esp
8010449b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010449e:	8d 73 04             	lea    0x4(%ebx),%esi
801044a1:	56                   	push   %esi
801044a2:	e8 79 01 00 00       	call   80104620 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044a7:	8b 03                	mov    (%ebx),%eax
801044a9:	83 c4 10             	add    $0x10,%esp
801044ac:	85 c0                	test   %eax,%eax
801044ae:	74 13                	je     801044c3 <holdingsleep+0x33>
801044b0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044b3:	e8 08 f6 ff ff       	call   80103ac0 <myproc>
801044b8:	39 58 10             	cmp    %ebx,0x10(%eax)
801044bb:	0f 94 c0             	sete   %al
801044be:	0f b6 c0             	movzbl %al,%eax
801044c1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801044c3:	83 ec 0c             	sub    $0xc,%esp
801044c6:	56                   	push   %esi
801044c7:	e8 14 02 00 00       	call   801046e0 <release>
  return r;
}
801044cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044cf:	89 f8                	mov    %edi,%eax
801044d1:	5b                   	pop    %ebx
801044d2:	5e                   	pop    %esi
801044d3:	5f                   	pop    %edi
801044d4:	5d                   	pop    %ebp
801044d5:	c3                   	ret    
801044d6:	66 90                	xchg   %ax,%ax
801044d8:	66 90                	xchg   %ax,%ax
801044da:	66 90                	xchg   %ax,%ax
801044dc:	66 90                	xchg   %ax,%ax
801044de:	66 90                	xchg   %ax,%ax

801044e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044f9:	5d                   	pop    %ebp
801044fa:	c3                   	ret    
801044fb:	90                   	nop
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104500 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104500:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104501:	31 d2                	xor    %edx,%edx
{
80104503:	89 e5                	mov    %esp,%ebp
80104505:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104506:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104509:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010450c:	83 e8 08             	sub    $0x8,%eax
8010450f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104510:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104516:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010451c:	77 1a                	ja     80104538 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010451e:	8b 58 04             	mov    0x4(%eax),%ebx
80104521:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104524:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104527:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104529:	83 fa 0a             	cmp    $0xa,%edx
8010452c:	75 e2                	jne    80104510 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010452e:	5b                   	pop    %ebx
8010452f:	5d                   	pop    %ebp
80104530:	c3                   	ret    
80104531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104538:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010453b:	83 c1 28             	add    $0x28,%ecx
8010453e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104546:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104549:	39 c1                	cmp    %eax,%ecx
8010454b:	75 f3                	jne    80104540 <getcallerpcs+0x40>
}
8010454d:	5b                   	pop    %ebx
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret    

80104550 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 04             	sub    $0x4,%esp
80104557:	9c                   	pushf  
80104558:	5b                   	pop    %ebx
  asm volatile("cli");
80104559:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010455a:	e8 c1 f4 ff ff       	call   80103a20 <mycpu>
8010455f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104565:	85 c0                	test   %eax,%eax
80104567:	75 11                	jne    8010457a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104569:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010456f:	e8 ac f4 ff ff       	call   80103a20 <mycpu>
80104574:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010457a:	e8 a1 f4 ff ff       	call   80103a20 <mycpu>
8010457f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104586:	83 c4 04             	add    $0x4,%esp
80104589:	5b                   	pop    %ebx
8010458a:	5d                   	pop    %ebp
8010458b:	c3                   	ret    
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104590 <popcli>:

void
popcli(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104596:	9c                   	pushf  
80104597:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104598:	f6 c4 02             	test   $0x2,%ah
8010459b:	75 35                	jne    801045d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010459d:	e8 7e f4 ff ff       	call   80103a20 <mycpu>
801045a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045a9:	78 34                	js     801045df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045ab:	e8 70 f4 ff ff       	call   80103a20 <mycpu>
801045b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045b6:	85 d2                	test   %edx,%edx
801045b8:	74 06                	je     801045c0 <popcli+0x30>
    sti();
}
801045ba:	c9                   	leave  
801045bb:	c3                   	ret    
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045c0:	e8 5b f4 ff ff       	call   80103a20 <mycpu>
801045c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045cb:	85 c0                	test   %eax,%eax
801045cd:	74 eb                	je     801045ba <popcli+0x2a>
  asm volatile("sti");
801045cf:	fb                   	sti    
}
801045d0:	c9                   	leave  
801045d1:	c3                   	ret    
    panic("popcli - interruptible");
801045d2:	83 ec 0c             	sub    $0xc,%esp
801045d5:	68 43 7b 10 80       	push   $0x80107b43
801045da:	e8 b1 bd ff ff       	call   80100390 <panic>
    panic("popcli");
801045df:	83 ec 0c             	sub    $0xc,%esp
801045e2:	68 5a 7b 10 80       	push   $0x80107b5a
801045e7:	e8 a4 bd ff ff       	call   80100390 <panic>
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <holding>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 75 08             	mov    0x8(%ebp),%esi
801045f8:	31 db                	xor    %ebx,%ebx
  pushcli();
801045fa:	e8 51 ff ff ff       	call   80104550 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045ff:	8b 06                	mov    (%esi),%eax
80104601:	85 c0                	test   %eax,%eax
80104603:	74 10                	je     80104615 <holding+0x25>
80104605:	8b 5e 08             	mov    0x8(%esi),%ebx
80104608:	e8 13 f4 ff ff       	call   80103a20 <mycpu>
8010460d:	39 c3                	cmp    %eax,%ebx
8010460f:	0f 94 c3             	sete   %bl
80104612:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104615:	e8 76 ff ff ff       	call   80104590 <popcli>
}
8010461a:	89 d8                	mov    %ebx,%eax
8010461c:	5b                   	pop    %ebx
8010461d:	5e                   	pop    %esi
8010461e:	5d                   	pop    %ebp
8010461f:	c3                   	ret    

80104620 <acquire>:
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104625:	e8 26 ff ff ff       	call   80104550 <pushcli>
  if(holding(lk))
8010462a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010462d:	83 ec 0c             	sub    $0xc,%esp
80104630:	53                   	push   %ebx
80104631:	e8 ba ff ff ff       	call   801045f0 <holding>
80104636:	83 c4 10             	add    $0x10,%esp
80104639:	85 c0                	test   %eax,%eax
8010463b:	0f 85 83 00 00 00    	jne    801046c4 <acquire+0xa4>
80104641:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104643:	ba 01 00 00 00       	mov    $0x1,%edx
80104648:	eb 09                	jmp    80104653 <acquire+0x33>
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104650:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104653:	89 d0                	mov    %edx,%eax
80104655:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104658:	85 c0                	test   %eax,%eax
8010465a:	75 f4                	jne    80104650 <acquire+0x30>
  __sync_synchronize();
8010465c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104661:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104664:	e8 b7 f3 ff ff       	call   80103a20 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104669:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010466c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010466f:	89 e8                	mov    %ebp,%eax
80104671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104678:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010467e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104684:	77 1a                	ja     801046a0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104686:	8b 48 04             	mov    0x4(%eax),%ecx
80104689:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010468c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010468f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104691:	83 fe 0a             	cmp    $0xa,%esi
80104694:	75 e2                	jne    80104678 <acquire+0x58>
}
80104696:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104699:	5b                   	pop    %ebx
8010469a:	5e                   	pop    %esi
8010469b:	5d                   	pop    %ebp
8010469c:	c3                   	ret    
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
801046a0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801046a3:	83 c2 28             	add    $0x28,%edx
801046a6:	8d 76 00             	lea    0x0(%esi),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801046b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046b6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801046b9:	39 d0                	cmp    %edx,%eax
801046bb:	75 f3                	jne    801046b0 <acquire+0x90>
}
801046bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c0:	5b                   	pop    %ebx
801046c1:	5e                   	pop    %esi
801046c2:	5d                   	pop    %ebp
801046c3:	c3                   	ret    
    panic("acquire");
801046c4:	83 ec 0c             	sub    $0xc,%esp
801046c7:	68 61 7b 10 80       	push   $0x80107b61
801046cc:	e8 bf bc ff ff       	call   80100390 <panic>
801046d1:	eb 0d                	jmp    801046e0 <release>
801046d3:	90                   	nop
801046d4:	90                   	nop
801046d5:	90                   	nop
801046d6:	90                   	nop
801046d7:	90                   	nop
801046d8:	90                   	nop
801046d9:	90                   	nop
801046da:	90                   	nop
801046db:	90                   	nop
801046dc:	90                   	nop
801046dd:	90                   	nop
801046de:	90                   	nop
801046df:	90                   	nop

801046e0 <release>:
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	83 ec 10             	sub    $0x10,%esp
801046e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801046ea:	53                   	push   %ebx
801046eb:	e8 00 ff ff ff       	call   801045f0 <holding>
801046f0:	83 c4 10             	add    $0x10,%esp
801046f3:	85 c0                	test   %eax,%eax
801046f5:	74 22                	je     80104719 <release+0x39>
  lk->pcs[0] = 0;
801046f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046fe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104705:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010470a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104710:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104713:	c9                   	leave  
  popcli();
80104714:	e9 77 fe ff ff       	jmp    80104590 <popcli>
    panic("release");
80104719:	83 ec 0c             	sub    $0xc,%esp
8010471c:	68 69 7b 10 80       	push   $0x80107b69
80104721:	e8 6a bc ff ff       	call   80100390 <panic>
80104726:	66 90                	xchg   %ax,%ax
80104728:	66 90                	xchg   %ax,%ax
8010472a:	66 90                	xchg   %ax,%ax
8010472c:	66 90                	xchg   %ax,%ax
8010472e:	66 90                	xchg   %ax,%ax

80104730 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	53                   	push   %ebx
80104735:	8b 55 08             	mov    0x8(%ebp),%edx
80104738:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010473b:	f6 c2 03             	test   $0x3,%dl
8010473e:	75 05                	jne    80104745 <memset+0x15>
80104740:	f6 c1 03             	test   $0x3,%cl
80104743:	74 13                	je     80104758 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104745:	89 d7                	mov    %edx,%edi
80104747:	8b 45 0c             	mov    0xc(%ebp),%eax
8010474a:	fc                   	cld    
8010474b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010474d:	5b                   	pop    %ebx
8010474e:	89 d0                	mov    %edx,%eax
80104750:	5f                   	pop    %edi
80104751:	5d                   	pop    %ebp
80104752:	c3                   	ret    
80104753:	90                   	nop
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104758:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010475c:	c1 e9 02             	shr    $0x2,%ecx
8010475f:	89 f8                	mov    %edi,%eax
80104761:	89 fb                	mov    %edi,%ebx
80104763:	c1 e0 18             	shl    $0x18,%eax
80104766:	c1 e3 10             	shl    $0x10,%ebx
80104769:	09 d8                	or     %ebx,%eax
8010476b:	09 f8                	or     %edi,%eax
8010476d:	c1 e7 08             	shl    $0x8,%edi
80104770:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104772:	89 d7                	mov    %edx,%edi
80104774:	fc                   	cld    
80104775:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104777:	5b                   	pop    %ebx
80104778:	89 d0                	mov    %edx,%eax
8010477a:	5f                   	pop    %edi
8010477b:	5d                   	pop    %ebp
8010477c:	c3                   	ret    
8010477d:	8d 76 00             	lea    0x0(%esi),%esi

80104780 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	53                   	push   %ebx
80104786:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104789:	8b 75 08             	mov    0x8(%ebp),%esi
8010478c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010478f:	85 db                	test   %ebx,%ebx
80104791:	74 29                	je     801047bc <memcmp+0x3c>
    if(*s1 != *s2)
80104793:	0f b6 16             	movzbl (%esi),%edx
80104796:	0f b6 0f             	movzbl (%edi),%ecx
80104799:	38 d1                	cmp    %dl,%cl
8010479b:	75 2b                	jne    801047c8 <memcmp+0x48>
8010479d:	b8 01 00 00 00       	mov    $0x1,%eax
801047a2:	eb 14                	jmp    801047b8 <memcmp+0x38>
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801047ac:	83 c0 01             	add    $0x1,%eax
801047af:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801047b4:	38 ca                	cmp    %cl,%dl
801047b6:	75 10                	jne    801047c8 <memcmp+0x48>
  while(n-- > 0){
801047b8:	39 d8                	cmp    %ebx,%eax
801047ba:	75 ec                	jne    801047a8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801047bc:	5b                   	pop    %ebx
  return 0;
801047bd:	31 c0                	xor    %eax,%eax
}
801047bf:	5e                   	pop    %esi
801047c0:	5f                   	pop    %edi
801047c1:	5d                   	pop    %ebp
801047c2:	c3                   	ret    
801047c3:	90                   	nop
801047c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801047c8:	0f b6 c2             	movzbl %dl,%eax
}
801047cb:	5b                   	pop    %ebx
      return *s1 - *s2;
801047cc:	29 c8                	sub    %ecx,%eax
}
801047ce:	5e                   	pop    %esi
801047cf:	5f                   	pop    %edi
801047d0:	5d                   	pop    %ebp
801047d1:	c3                   	ret    
801047d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	8b 45 08             	mov    0x8(%ebp),%eax
801047e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047eb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047ee:	39 c3                	cmp    %eax,%ebx
801047f0:	73 26                	jae    80104818 <memmove+0x38>
801047f2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801047f5:	39 c8                	cmp    %ecx,%eax
801047f7:	73 1f                	jae    80104818 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047f9:	85 f6                	test   %esi,%esi
801047fb:	8d 56 ff             	lea    -0x1(%esi),%edx
801047fe:	74 0f                	je     8010480f <memmove+0x2f>
      *--d = *--s;
80104800:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104804:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104807:	83 ea 01             	sub    $0x1,%edx
8010480a:	83 fa ff             	cmp    $0xffffffff,%edx
8010480d:	75 f1                	jne    80104800 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010480f:	5b                   	pop    %ebx
80104810:	5e                   	pop    %esi
80104811:	5d                   	pop    %ebp
80104812:	c3                   	ret    
80104813:	90                   	nop
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104818:	31 d2                	xor    %edx,%edx
8010481a:	85 f6                	test   %esi,%esi
8010481c:	74 f1                	je     8010480f <memmove+0x2f>
8010481e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104820:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104824:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104827:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010482a:	39 d6                	cmp    %edx,%esi
8010482c:	75 f2                	jne    80104820 <memmove+0x40>
}
8010482e:	5b                   	pop    %ebx
8010482f:	5e                   	pop    %esi
80104830:	5d                   	pop    %ebp
80104831:	c3                   	ret    
80104832:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104843:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104844:	eb 9a                	jmp    801047e0 <memmove>
80104846:	8d 76 00             	lea    0x0(%esi),%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	8b 7d 10             	mov    0x10(%ebp),%edi
80104858:	53                   	push   %ebx
80104859:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010485c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010485f:	85 ff                	test   %edi,%edi
80104861:	74 2f                	je     80104892 <strncmp+0x42>
80104863:	0f b6 01             	movzbl (%ecx),%eax
80104866:	0f b6 1e             	movzbl (%esi),%ebx
80104869:	84 c0                	test   %al,%al
8010486b:	74 37                	je     801048a4 <strncmp+0x54>
8010486d:	38 c3                	cmp    %al,%bl
8010486f:	75 33                	jne    801048a4 <strncmp+0x54>
80104871:	01 f7                	add    %esi,%edi
80104873:	eb 13                	jmp    80104888 <strncmp+0x38>
80104875:	8d 76 00             	lea    0x0(%esi),%esi
80104878:	0f b6 01             	movzbl (%ecx),%eax
8010487b:	84 c0                	test   %al,%al
8010487d:	74 21                	je     801048a0 <strncmp+0x50>
8010487f:	0f b6 1a             	movzbl (%edx),%ebx
80104882:	89 d6                	mov    %edx,%esi
80104884:	38 d8                	cmp    %bl,%al
80104886:	75 1c                	jne    801048a4 <strncmp+0x54>
    n--, p++, q++;
80104888:	8d 56 01             	lea    0x1(%esi),%edx
8010488b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010488e:	39 fa                	cmp    %edi,%edx
80104890:	75 e6                	jne    80104878 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104892:	5b                   	pop    %ebx
    return 0;
80104893:	31 c0                	xor    %eax,%eax
}
80104895:	5e                   	pop    %esi
80104896:	5f                   	pop    %edi
80104897:	5d                   	pop    %ebp
80104898:	c3                   	ret    
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801048a4:	29 d8                	sub    %ebx,%eax
}
801048a6:	5b                   	pop    %ebx
801048a7:	5e                   	pop    %esi
801048a8:	5f                   	pop    %edi
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret    
801048ab:	90                   	nop
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 45 08             	mov    0x8(%ebp),%eax
801048b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801048bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048be:	89 c2                	mov    %eax,%edx
801048c0:	eb 19                	jmp    801048db <strncpy+0x2b>
801048c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c8:	83 c3 01             	add    $0x1,%ebx
801048cb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801048cf:	83 c2 01             	add    $0x1,%edx
801048d2:	84 c9                	test   %cl,%cl
801048d4:	88 4a ff             	mov    %cl,-0x1(%edx)
801048d7:	74 09                	je     801048e2 <strncpy+0x32>
801048d9:	89 f1                	mov    %esi,%ecx
801048db:	85 c9                	test   %ecx,%ecx
801048dd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801048e0:	7f e6                	jg     801048c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801048e2:	31 c9                	xor    %ecx,%ecx
801048e4:	85 f6                	test   %esi,%esi
801048e6:	7e 17                	jle    801048ff <strncpy+0x4f>
801048e8:	90                   	nop
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801048f0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801048f4:	89 f3                	mov    %esi,%ebx
801048f6:	83 c1 01             	add    $0x1,%ecx
801048f9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801048fb:	85 db                	test   %ebx,%ebx
801048fd:	7f f1                	jg     801048f0 <strncpy+0x40>
  return os;
}
801048ff:	5b                   	pop    %ebx
80104900:	5e                   	pop    %esi
80104901:	5d                   	pop    %ebp
80104902:	c3                   	ret    
80104903:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104910 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	56                   	push   %esi
80104914:	53                   	push   %ebx
80104915:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104918:	8b 45 08             	mov    0x8(%ebp),%eax
8010491b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010491e:	85 c9                	test   %ecx,%ecx
80104920:	7e 26                	jle    80104948 <safestrcpy+0x38>
80104922:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104926:	89 c1                	mov    %eax,%ecx
80104928:	eb 17                	jmp    80104941 <safestrcpy+0x31>
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104930:	83 c2 01             	add    $0x1,%edx
80104933:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104937:	83 c1 01             	add    $0x1,%ecx
8010493a:	84 db                	test   %bl,%bl
8010493c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010493f:	74 04                	je     80104945 <safestrcpy+0x35>
80104941:	39 f2                	cmp    %esi,%edx
80104943:	75 eb                	jne    80104930 <safestrcpy+0x20>
    ;
  *s = 0;
80104945:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104948:	5b                   	pop    %ebx
80104949:	5e                   	pop    %esi
8010494a:	5d                   	pop    %ebp
8010494b:	c3                   	ret    
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104950 <strlen>:

int
strlen(const char *s)
{
80104950:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104951:	31 c0                	xor    %eax,%eax
{
80104953:	89 e5                	mov    %esp,%ebp
80104955:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104958:	80 3a 00             	cmpb   $0x0,(%edx)
8010495b:	74 0c                	je     80104969 <strlen+0x19>
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
80104960:	83 c0 01             	add    $0x1,%eax
80104963:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104967:	75 f7                	jne    80104960 <strlen+0x10>
    ;
  return n;
}
80104969:	5d                   	pop    %ebp
8010496a:	c3                   	ret    

8010496b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010496b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010496f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104973:	55                   	push   %ebp
  pushl %ebx
80104974:	53                   	push   %ebx
  pushl %esi
80104975:	56                   	push   %esi
  pushl %edi
80104976:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104977:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104979:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010497b:	5f                   	pop    %edi
  popl %esi
8010497c:	5e                   	pop    %esi
  popl %ebx
8010497d:	5b                   	pop    %ebx
  popl %ebp
8010497e:	5d                   	pop    %ebp
  ret
8010497f:	c3                   	ret    

80104980 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 04             	sub    $0x4,%esp
80104987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010498a:	e8 31 f1 ff ff       	call   80103ac0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010498f:	8b 00                	mov    (%eax),%eax
80104991:	39 d8                	cmp    %ebx,%eax
80104993:	76 1b                	jbe    801049b0 <fetchint+0x30>
80104995:	8d 53 04             	lea    0x4(%ebx),%edx
80104998:	39 d0                	cmp    %edx,%eax
8010499a:	72 14                	jb     801049b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010499c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010499f:	8b 13                	mov    (%ebx),%edx
801049a1:	89 10                	mov    %edx,(%eax)
  return 0;
801049a3:	31 c0                	xor    %eax,%eax
}
801049a5:	83 c4 04             	add    $0x4,%esp
801049a8:	5b                   	pop    %ebx
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret    
801049ab:	90                   	nop
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b5:	eb ee                	jmp    801049a5 <fetchint+0x25>
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 04             	sub    $0x4,%esp
801049c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049ca:	e8 f1 f0 ff ff       	call   80103ac0 <myproc>

  if(addr >= curproc->sz)
801049cf:	39 18                	cmp    %ebx,(%eax)
801049d1:	76 29                	jbe    801049fc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801049d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801049d6:	89 da                	mov    %ebx,%edx
801049d8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801049da:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801049dc:	39 c3                	cmp    %eax,%ebx
801049de:	73 1c                	jae    801049fc <fetchstr+0x3c>
    if(*s == 0)
801049e0:	80 3b 00             	cmpb   $0x0,(%ebx)
801049e3:	75 10                	jne    801049f5 <fetchstr+0x35>
801049e5:	eb 39                	jmp    80104a20 <fetchstr+0x60>
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049f0:	80 3a 00             	cmpb   $0x0,(%edx)
801049f3:	74 1b                	je     80104a10 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801049f5:	83 c2 01             	add    $0x1,%edx
801049f8:	39 d0                	cmp    %edx,%eax
801049fa:	77 f4                	ja     801049f0 <fetchstr+0x30>
    return -1;
801049fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104a01:	83 c4 04             	add    $0x4,%esp
80104a04:	5b                   	pop    %ebx
80104a05:	5d                   	pop    %ebp
80104a06:	c3                   	ret    
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a10:	83 c4 04             	add    $0x4,%esp
80104a13:	89 d0                	mov    %edx,%eax
80104a15:	29 d8                	sub    %ebx,%eax
80104a17:	5b                   	pop    %ebx
80104a18:	5d                   	pop    %ebp
80104a19:	c3                   	ret    
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104a20:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104a22:	eb dd                	jmp    80104a01 <fetchstr+0x41>
80104a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a35:	e8 86 f0 ff ff       	call   80103ac0 <myproc>
80104a3a:	8b 40 18             	mov    0x18(%eax),%eax
80104a3d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a40:	8b 40 44             	mov    0x44(%eax),%eax
80104a43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a46:	e8 75 f0 ff ff       	call   80103ac0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a4b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a4d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a50:	39 c6                	cmp    %eax,%esi
80104a52:	73 1c                	jae    80104a70 <argint+0x40>
80104a54:	8d 53 08             	lea    0x8(%ebx),%edx
80104a57:	39 d0                	cmp    %edx,%eax
80104a59:	72 15                	jb     80104a70 <argint+0x40>
  *ip = *(int*)(addr);
80104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a61:	89 10                	mov    %edx,(%eax)
  return 0;
80104a63:	31 c0                	xor    %eax,%eax
}
80104a65:	5b                   	pop    %ebx
80104a66:	5e                   	pop    %esi
80104a67:	5d                   	pop    %ebp
80104a68:	c3                   	ret    
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a75:	eb ee                	jmp    80104a65 <argint+0x35>
80104a77:	89 f6                	mov    %esi,%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
80104a85:	83 ec 10             	sub    $0x10,%esp
80104a88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a8b:	e8 30 f0 ff ff       	call   80103ac0 <myproc>
80104a90:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104a92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a95:	83 ec 08             	sub    $0x8,%esp
80104a98:	50                   	push   %eax
80104a99:	ff 75 08             	pushl  0x8(%ebp)
80104a9c:	e8 8f ff ff ff       	call   80104a30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104aa1:	83 c4 10             	add    $0x10,%esp
80104aa4:	85 c0                	test   %eax,%eax
80104aa6:	78 28                	js     80104ad0 <argptr+0x50>
80104aa8:	85 db                	test   %ebx,%ebx
80104aaa:	78 24                	js     80104ad0 <argptr+0x50>
80104aac:	8b 16                	mov    (%esi),%edx
80104aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab1:	39 c2                	cmp    %eax,%edx
80104ab3:	76 1b                	jbe    80104ad0 <argptr+0x50>
80104ab5:	01 c3                	add    %eax,%ebx
80104ab7:	39 da                	cmp    %ebx,%edx
80104ab9:	72 15                	jb     80104ad0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104abb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104abe:	89 02                	mov    %eax,(%edx)
  return 0;
80104ac0:	31 c0                	xor    %eax,%eax
}
80104ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ac5:	5b                   	pop    %ebx
80104ac6:	5e                   	pop    %esi
80104ac7:	5d                   	pop    %ebp
80104ac8:	c3                   	ret    
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad5:	eb eb                	jmp    80104ac2 <argptr+0x42>
80104ad7:	89 f6                	mov    %esi,%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ae9:	50                   	push   %eax
80104aea:	ff 75 08             	pushl  0x8(%ebp)
80104aed:	e8 3e ff ff ff       	call   80104a30 <argint>
80104af2:	83 c4 10             	add    $0x10,%esp
80104af5:	85 c0                	test   %eax,%eax
80104af7:	78 17                	js     80104b10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104af9:	83 ec 08             	sub    $0x8,%esp
80104afc:	ff 75 0c             	pushl  0xc(%ebp)
80104aff:	ff 75 f4             	pushl  -0xc(%ebp)
80104b02:	e8 b9 fe ff ff       	call   801049c0 <fetchstr>
80104b07:	83 c4 10             	add    $0x10,%esp
}
80104b0a:	c9                   	leave  
80104b0b:	c3                   	ret    
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b15:	c9                   	leave  
80104b16:	c3                   	ret    
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <syscall>:
[SYS_readlink]sys_readlink
};

void
syscall(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b27:	e8 94 ef ff ff       	call   80103ac0 <myproc>
80104b2c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b2e:	8b 40 18             	mov    0x18(%eax),%eax
80104b31:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b34:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b37:	83 fa 16             	cmp    $0x16,%edx
80104b3a:	77 1c                	ja     80104b58 <syscall+0x38>
80104b3c:	8b 14 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%edx
80104b43:	85 d2                	test   %edx,%edx
80104b45:	74 11                	je     80104b58 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b47:	ff d2                	call   *%edx
80104b49:	8b 53 18             	mov    0x18(%ebx),%edx
80104b4c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b52:	c9                   	leave  
80104b53:	c3                   	ret    
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b58:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b59:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b5c:	50                   	push   %eax
80104b5d:	ff 73 10             	pushl  0x10(%ebx)
80104b60:	68 71 7b 10 80       	push   $0x80107b71
80104b65:	e8 f6 ba ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104b6a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b7a:	c9                   	leave  
80104b7b:	c3                   	ret    
80104b7c:	66 90                	xchg   %ax,%ax
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	57                   	push   %edi
80104b84:	56                   	push   %esi
80104b85:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b86:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104b89:	83 ec 34             	sub    $0x34,%esp
80104b8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b92:	56                   	push   %esi
80104b93:	50                   	push   %eax
{
80104b94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b9a:	e8 41 d6 ff ff       	call   801021e0 <nameiparent>
80104b9f:	83 c4 10             	add    $0x10,%esp
80104ba2:	85 c0                	test   %eax,%eax
80104ba4:	0f 84 46 01 00 00    	je     80104cf0 <create+0x170>
    return 0;
  ilock(dp);
80104baa:	83 ec 0c             	sub    $0xc,%esp
80104bad:	89 c3                	mov    %eax,%ebx
80104baf:	50                   	push   %eax
80104bb0:	e8 fb cb ff ff       	call   801017b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104bb5:	83 c4 0c             	add    $0xc,%esp
80104bb8:	6a 00                	push   $0x0
80104bba:	56                   	push   %esi
80104bbb:	53                   	push   %ebx
80104bbc:	e8 df d1 ff ff       	call   80101da0 <dirlookup>
80104bc1:	83 c4 10             	add    $0x10,%esp
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	89 c7                	mov    %eax,%edi
80104bc8:	74 56                	je     80104c20 <create+0xa0>
    iunlockput(dp);
80104bca:	83 ec 0c             	sub    $0xc,%esp
80104bcd:	53                   	push   %ebx
80104bce:	e8 2d cf ff ff       	call   80101b00 <iunlockput>
    ilock(ip);
80104bd3:	89 3c 24             	mov    %edi,(%esp)
80104bd6:	e8 d5 cb ff ff       	call   801017b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bdb:	83 c4 10             	add    $0x10,%esp
80104bde:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104be3:	74 1b                	je     80104c00 <create+0x80>
      return ip;
    if (type == T_SYMLINK)
80104be5:	66 83 7d d4 04       	cmpw   $0x4,-0x2c(%ebp)
80104bea:	75 1b                	jne    80104c07 <create+0x87>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104bec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bef:	89 f8                	mov    %edi,%eax
80104bf1:	5b                   	pop    %ebx
80104bf2:	5e                   	pop    %esi
80104bf3:	5f                   	pop    %edi
80104bf4:	5d                   	pop    %ebp
80104bf5:	c3                   	ret    
80104bf6:	8d 76 00             	lea    0x0(%esi),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(type == T_FILE && ip->type == T_FILE)
80104c00:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104c05:	74 e5                	je     80104bec <create+0x6c>
    iunlockput(ip);
80104c07:	83 ec 0c             	sub    $0xc,%esp
80104c0a:	57                   	push   %edi
    return 0;
80104c0b:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104c0d:	e8 ee ce ff ff       	call   80101b00 <iunlockput>
    return 0;
80104c12:	83 c4 10             	add    $0x10,%esp
80104c15:	eb d5                	jmp    80104bec <create+0x6c>
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80104c20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104c24:	83 ec 08             	sub    $0x8,%esp
80104c27:	50                   	push   %eax
80104c28:	ff 33                	pushl  (%ebx)
80104c2a:	e8 11 ca ff ff       	call   80101640 <ialloc>
80104c2f:	83 c4 10             	add    $0x10,%esp
80104c32:	85 c0                	test   %eax,%eax
80104c34:	89 c7                	mov    %eax,%edi
80104c36:	0f 84 c8 00 00 00    	je     80104d04 <create+0x184>
  ilock(ip);
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	50                   	push   %eax
80104c40:	e8 6b cb ff ff       	call   801017b0 <ilock>
  ip->major = major;
80104c45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104c49:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104c4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104c51:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c55:	b8 01 00 00 00       	mov    $0x1,%eax
80104c5a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c5e:	89 3c 24             	mov    %edi,(%esp)
80104c61:	e8 9a ca ff ff       	call   80101700 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c66:	83 c4 10             	add    $0x10,%esp
80104c69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c6e:	74 30                	je     80104ca0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c70:	83 ec 04             	sub    $0x4,%esp
80104c73:	ff 77 04             	pushl  0x4(%edi)
80104c76:	56                   	push   %esi
80104c77:	53                   	push   %ebx
80104c78:	e8 83 d4 ff ff       	call   80102100 <dirlink>
80104c7d:	83 c4 10             	add    $0x10,%esp
80104c80:	85 c0                	test   %eax,%eax
80104c82:	78 73                	js     80104cf7 <create+0x177>
  iunlockput(dp);
80104c84:	83 ec 0c             	sub    $0xc,%esp
80104c87:	53                   	push   %ebx
80104c88:	e8 73 ce ff ff       	call   80101b00 <iunlockput>
  return ip;
80104c8d:	83 c4 10             	add    $0x10,%esp
}
80104c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c93:	89 f8                	mov    %edi,%eax
80104c95:	5b                   	pop    %ebx
80104c96:	5e                   	pop    %esi
80104c97:	5f                   	pop    %edi
80104c98:	5d                   	pop    %ebp
80104c99:	c3                   	ret    
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink++;  // for ".."
80104ca0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ca5:	83 ec 0c             	sub    $0xc,%esp
80104ca8:	53                   	push   %ebx
80104ca9:	e8 52 ca ff ff       	call   80101700 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cae:	83 c4 0c             	add    $0xc,%esp
80104cb1:	ff 77 04             	pushl  0x4(%edi)
80104cb4:	68 1c 7c 10 80       	push   $0x80107c1c
80104cb9:	57                   	push   %edi
80104cba:	e8 41 d4 ff ff       	call   80102100 <dirlink>
80104cbf:	83 c4 10             	add    $0x10,%esp
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	78 18                	js     80104cde <create+0x15e>
80104cc6:	83 ec 04             	sub    $0x4,%esp
80104cc9:	ff 73 04             	pushl  0x4(%ebx)
80104ccc:	68 1b 7c 10 80       	push   $0x80107c1b
80104cd1:	57                   	push   %edi
80104cd2:	e8 29 d4 ff ff       	call   80102100 <dirlink>
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	85 c0                	test   %eax,%eax
80104cdc:	79 92                	jns    80104c70 <create+0xf0>
      panic("create dots");
80104cde:	83 ec 0c             	sub    $0xc,%esp
80104ce1:	68 0f 7c 10 80       	push   $0x80107c0f
80104ce6:	e8 a5 b6 ff ff       	call   80100390 <panic>
80104ceb:	90                   	nop
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80104cf0:	31 ff                	xor    %edi,%edi
80104cf2:	e9 f5 fe ff ff       	jmp    80104bec <create+0x6c>
    panic("create: dirlink");
80104cf7:	83 ec 0c             	sub    $0xc,%esp
80104cfa:	68 1e 7c 10 80       	push   $0x80107c1e
80104cff:	e8 8c b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d04:	83 ec 0c             	sub    $0xc,%esp
80104d07:	68 00 7c 10 80       	push   $0x80107c00
80104d0c:	e8 7f b6 ff ff       	call   80100390 <panic>
80104d11:	eb 0d                	jmp    80104d20 <argfd.constprop.0>
80104d13:	90                   	nop
80104d14:	90                   	nop
80104d15:	90                   	nop
80104d16:	90                   	nop
80104d17:	90                   	nop
80104d18:	90                   	nop
80104d19:	90                   	nop
80104d1a:	90                   	nop
80104d1b:	90                   	nop
80104d1c:	90                   	nop
80104d1d:	90                   	nop
80104d1e:	90                   	nop
80104d1f:	90                   	nop

80104d20 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
80104d25:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d27:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d2a:	89 d6                	mov    %edx,%esi
80104d2c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d2f:	50                   	push   %eax
80104d30:	6a 00                	push   $0x0
80104d32:	e8 f9 fc ff ff       	call   80104a30 <argint>
80104d37:	83 c4 10             	add    $0x10,%esp
80104d3a:	85 c0                	test   %eax,%eax
80104d3c:	78 2a                	js     80104d68 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d42:	77 24                	ja     80104d68 <argfd.constprop.0+0x48>
80104d44:	e8 77 ed ff ff       	call   80103ac0 <myproc>
80104d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d4c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d50:	85 c0                	test   %eax,%eax
80104d52:	74 14                	je     80104d68 <argfd.constprop.0+0x48>
  if(pfd)
80104d54:	85 db                	test   %ebx,%ebx
80104d56:	74 02                	je     80104d5a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d58:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d5a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d5c:	31 c0                	xor    %eax,%eax
}
80104d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d61:	5b                   	pop    %ebx
80104d62:	5e                   	pop    %esi
80104d63:	5d                   	pop    %ebp
80104d64:	c3                   	ret    
80104d65:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d6d:	eb ef                	jmp    80104d5e <argfd.constprop.0+0x3e>
80104d6f:	90                   	nop

80104d70 <sys_dup>:
{
80104d70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d71:	31 c0                	xor    %eax,%eax
{
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	56                   	push   %esi
80104d76:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d77:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d7a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d7d:	e8 9e ff ff ff       	call   80104d20 <argfd.constprop.0>
80104d82:	85 c0                	test   %eax,%eax
80104d84:	78 42                	js     80104dc8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104d86:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d89:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d8b:	e8 30 ed ff ff       	call   80103ac0 <myproc>
80104d90:	eb 0e                	jmp    80104da0 <sys_dup+0x30>
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d98:	83 c3 01             	add    $0x1,%ebx
80104d9b:	83 fb 10             	cmp    $0x10,%ebx
80104d9e:	74 28                	je     80104dc8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104da0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104da4:	85 d2                	test   %edx,%edx
80104da6:	75 f0                	jne    80104d98 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104da8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104dac:	83 ec 0c             	sub    $0xc,%esp
80104daf:	ff 75 f4             	pushl  -0xc(%ebp)
80104db2:	e8 69 c0 ff ff       	call   80100e20 <filedup>
  return fd;
80104db7:	83 c4 10             	add    $0x10,%esp
}
80104dba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dbd:	89 d8                	mov    %ebx,%eax
80104dbf:	5b                   	pop    %ebx
80104dc0:	5e                   	pop    %esi
80104dc1:	5d                   	pop    %ebp
80104dc2:	c3                   	ret    
80104dc3:	90                   	nop
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104dcb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104dd0:	89 d8                	mov    %ebx,%eax
80104dd2:	5b                   	pop    %ebx
80104dd3:	5e                   	pop    %esi
80104dd4:	5d                   	pop    %ebp
80104dd5:	c3                   	ret    
80104dd6:	8d 76 00             	lea    0x0(%esi),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <sys_read>:
{
80104de0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de1:	31 c0                	xor    %eax,%eax
{
80104de3:	89 e5                	mov    %esp,%ebp
80104de5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104deb:	e8 30 ff ff ff       	call   80104d20 <argfd.constprop.0>
80104df0:	85 c0                	test   %eax,%eax
80104df2:	78 4c                	js     80104e40 <sys_read+0x60>
80104df4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104df7:	83 ec 08             	sub    $0x8,%esp
80104dfa:	50                   	push   %eax
80104dfb:	6a 02                	push   $0x2
80104dfd:	e8 2e fc ff ff       	call   80104a30 <argint>
80104e02:	83 c4 10             	add    $0x10,%esp
80104e05:	85 c0                	test   %eax,%eax
80104e07:	78 37                	js     80104e40 <sys_read+0x60>
80104e09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e0c:	83 ec 04             	sub    $0x4,%esp
80104e0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e12:	50                   	push   %eax
80104e13:	6a 01                	push   $0x1
80104e15:	e8 66 fc ff ff       	call   80104a80 <argptr>
80104e1a:	83 c4 10             	add    $0x10,%esp
80104e1d:	85 c0                	test   %eax,%eax
80104e1f:	78 1f                	js     80104e40 <sys_read+0x60>
  return fileread(f, p, n);
80104e21:	83 ec 04             	sub    $0x4,%esp
80104e24:	ff 75 f0             	pushl  -0x10(%ebp)
80104e27:	ff 75 f4             	pushl  -0xc(%ebp)
80104e2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e2d:	e8 5e c1 ff ff       	call   80100f90 <fileread>
80104e32:	83 c4 10             	add    $0x10,%esp
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e45:	c9                   	leave  
80104e46:	c3                   	ret    
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <sys_write>:
{
80104e50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e51:	31 c0                	xor    %eax,%eax
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e5b:	e8 c0 fe ff ff       	call   80104d20 <argfd.constprop.0>
80104e60:	85 c0                	test   %eax,%eax
80104e62:	78 4c                	js     80104eb0 <sys_write+0x60>
80104e64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e67:	83 ec 08             	sub    $0x8,%esp
80104e6a:	50                   	push   %eax
80104e6b:	6a 02                	push   $0x2
80104e6d:	e8 be fb ff ff       	call   80104a30 <argint>
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	85 c0                	test   %eax,%eax
80104e77:	78 37                	js     80104eb0 <sys_write+0x60>
80104e79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7c:	83 ec 04             	sub    $0x4,%esp
80104e7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e82:	50                   	push   %eax
80104e83:	6a 01                	push   $0x1
80104e85:	e8 f6 fb ff ff       	call   80104a80 <argptr>
80104e8a:	83 c4 10             	add    $0x10,%esp
80104e8d:	85 c0                	test   %eax,%eax
80104e8f:	78 1f                	js     80104eb0 <sys_write+0x60>
  return filewrite(f, p, n);
80104e91:	83 ec 04             	sub    $0x4,%esp
80104e94:	ff 75 f0             	pushl  -0x10(%ebp)
80104e97:	ff 75 f4             	pushl  -0xc(%ebp)
80104e9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e9d:	e8 7e c1 ff ff       	call   80101020 <filewrite>
80104ea2:	83 c4 10             	add    $0x10,%esp
}
80104ea5:	c9                   	leave  
80104ea6:	c3                   	ret    
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <sys_close>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104ec6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ec9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ecc:	e8 4f fe ff ff       	call   80104d20 <argfd.constprop.0>
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	78 2b                	js     80104f00 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ed5:	e8 e6 eb ff ff       	call   80103ac0 <myproc>
80104eda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104edd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ee0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ee7:	00 
  fileclose(f);
80104ee8:	ff 75 f4             	pushl  -0xc(%ebp)
80104eeb:	e8 80 bf ff ff       	call   80100e70 <fileclose>
  return 0;
80104ef0:	83 c4 10             	add    $0x10,%esp
80104ef3:	31 c0                	xor    %eax,%eax
}
80104ef5:	c9                   	leave  
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f05:	c9                   	leave  
80104f06:	c3                   	ret    
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <sys_fstat>:
{
80104f10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f11:	31 c0                	xor    %eax,%eax
{
80104f13:	89 e5                	mov    %esp,%ebp
80104f15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f1b:	e8 00 fe ff ff       	call   80104d20 <argfd.constprop.0>
80104f20:	85 c0                	test   %eax,%eax
80104f22:	78 2c                	js     80104f50 <sys_fstat+0x40>
80104f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f27:	83 ec 04             	sub    $0x4,%esp
80104f2a:	6a 14                	push   $0x14
80104f2c:	50                   	push   %eax
80104f2d:	6a 01                	push   $0x1
80104f2f:	e8 4c fb ff ff       	call   80104a80 <argptr>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	78 15                	js     80104f50 <sys_fstat+0x40>
  return filestat(f, st);
80104f3b:	83 ec 08             	sub    $0x8,%esp
80104f3e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f41:	ff 75 f0             	pushl  -0x10(%ebp)
80104f44:	e8 f7 bf ff ff       	call   80100f40 <filestat>
80104f49:	83 c4 10             	add    $0x10,%esp
}
80104f4c:	c9                   	leave  
80104f4d:	c3                   	ret    
80104f4e:	66 90                	xchg   %ax,%ax
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <sys_link>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	57                   	push   %edi
80104f64:	56                   	push   %esi
80104f65:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f66:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f69:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f6c:	50                   	push   %eax
80104f6d:	6a 00                	push   $0x0
80104f6f:	e8 6c fb ff ff       	call   80104ae0 <argstr>
80104f74:	83 c4 10             	add    $0x10,%esp
80104f77:	85 c0                	test   %eax,%eax
80104f79:	0f 88 fb 00 00 00    	js     8010507a <sys_link+0x11a>
80104f7f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f82:	83 ec 08             	sub    $0x8,%esp
80104f85:	50                   	push   %eax
80104f86:	6a 01                	push   $0x1
80104f88:	e8 53 fb ff ff       	call   80104ae0 <argstr>
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	0f 88 e2 00 00 00    	js     8010507a <sys_link+0x11a>
  begin_op();
80104f98:	e8 e3 de ff ff       	call   80102e80 <begin_op>
  if((ip = namei(old, 1)) == 0){
80104f9d:	83 ec 08             	sub    $0x8,%esp
80104fa0:	6a 01                	push   $0x1
80104fa2:	ff 75 d4             	pushl  -0x2c(%ebp)
80104fa5:	e8 16 d2 ff ff       	call   801021c0 <namei>
80104faa:	83 c4 10             	add    $0x10,%esp
80104fad:	85 c0                	test   %eax,%eax
80104faf:	89 c3                	mov    %eax,%ebx
80104fb1:	0f 84 e8 00 00 00    	je     8010509f <sys_link+0x13f>
  ilock(ip);
80104fb7:	83 ec 0c             	sub    $0xc,%esp
80104fba:	50                   	push   %eax
80104fbb:	e8 f0 c7 ff ff       	call   801017b0 <ilock>
  if(ip->type == T_DIR){
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fc8:	0f 84 b9 00 00 00    	je     80105087 <sys_link+0x127>
  ip->nlink++;
80104fce:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fd3:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104fd6:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fd9:	53                   	push   %ebx
80104fda:	e8 21 c7 ff ff       	call   80101700 <iupdate>
  iunlock(ip);
80104fdf:	89 1c 24             	mov    %ebx,(%esp)
80104fe2:	e8 a9 c8 ff ff       	call   80101890 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fe7:	58                   	pop    %eax
80104fe8:	5a                   	pop    %edx
80104fe9:	57                   	push   %edi
80104fea:	ff 75 d0             	pushl  -0x30(%ebp)
80104fed:	e8 ee d1 ff ff       	call   801021e0 <nameiparent>
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	89 c6                	mov    %eax,%esi
80104ff9:	74 59                	je     80105054 <sys_link+0xf4>
  ilock(dp);
80104ffb:	83 ec 0c             	sub    $0xc,%esp
80104ffe:	50                   	push   %eax
80104fff:	e8 ac c7 ff ff       	call   801017b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	8b 03                	mov    (%ebx),%eax
80105009:	39 06                	cmp    %eax,(%esi)
8010500b:	75 3b                	jne    80105048 <sys_link+0xe8>
8010500d:	83 ec 04             	sub    $0x4,%esp
80105010:	ff 73 04             	pushl  0x4(%ebx)
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
80105015:	e8 e6 d0 ff ff       	call   80102100 <dirlink>
8010501a:	83 c4 10             	add    $0x10,%esp
8010501d:	85 c0                	test   %eax,%eax
8010501f:	78 27                	js     80105048 <sys_link+0xe8>
  iunlockput(dp);
80105021:	83 ec 0c             	sub    $0xc,%esp
80105024:	56                   	push   %esi
80105025:	e8 d6 ca ff ff       	call   80101b00 <iunlockput>
  iput(ip);
8010502a:	89 1c 24             	mov    %ebx,(%esp)
8010502d:	e8 ae c8 ff ff       	call   801018e0 <iput>
  end_op();
80105032:	e8 b9 de ff ff       	call   80102ef0 <end_op>
  return 0;
80105037:	83 c4 10             	add    $0x10,%esp
8010503a:	31 c0                	xor    %eax,%eax
}
8010503c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503f:	5b                   	pop    %ebx
80105040:	5e                   	pop    %esi
80105041:	5f                   	pop    %edi
80105042:	5d                   	pop    %ebp
80105043:	c3                   	ret    
80105044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp);
80105048:	83 ec 0c             	sub    $0xc,%esp
8010504b:	56                   	push   %esi
8010504c:	e8 af ca ff ff       	call   80101b00 <iunlockput>
    goto bad;
80105051:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	53                   	push   %ebx
80105058:	e8 53 c7 ff ff       	call   801017b0 <ilock>
  ip->nlink--;
8010505d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105062:	89 1c 24             	mov    %ebx,(%esp)
80105065:	e8 96 c6 ff ff       	call   80101700 <iupdate>
  iunlockput(ip);
8010506a:	89 1c 24             	mov    %ebx,(%esp)
8010506d:	e8 8e ca ff ff       	call   80101b00 <iunlockput>
  end_op();
80105072:	e8 79 de ff ff       	call   80102ef0 <end_op>
  return -1;
80105077:	83 c4 10             	add    $0x10,%esp
}
8010507a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010507d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105082:	5b                   	pop    %ebx
80105083:	5e                   	pop    %esi
80105084:	5f                   	pop    %edi
80105085:	5d                   	pop    %ebp
80105086:	c3                   	ret    
    iunlockput(ip);
80105087:	83 ec 0c             	sub    $0xc,%esp
8010508a:	53                   	push   %ebx
8010508b:	e8 70 ca ff ff       	call   80101b00 <iunlockput>
    end_op();
80105090:	e8 5b de ff ff       	call   80102ef0 <end_op>
    return -1;
80105095:	83 c4 10             	add    $0x10,%esp
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb 9d                	jmp    8010503c <sys_link+0xdc>
    end_op();
8010509f:	e8 4c de ff ff       	call   80102ef0 <end_op>
    return -1;
801050a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a9:	eb 91                	jmp    8010503c <sys_link+0xdc>
801050ab:	90                   	nop
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050b0 <sys_unlink>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
801050b5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801050b6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050b9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801050bc:	50                   	push   %eax
801050bd:	6a 00                	push   $0x0
801050bf:	e8 1c fa ff ff       	call   80104ae0 <argstr>
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	85 c0                	test   %eax,%eax
801050c9:	0f 88 77 01 00 00    	js     80105246 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801050cf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801050d2:	e8 a9 dd ff ff       	call   80102e80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050d7:	83 ec 08             	sub    $0x8,%esp
801050da:	53                   	push   %ebx
801050db:	ff 75 c0             	pushl  -0x40(%ebp)
801050de:	e8 fd d0 ff ff       	call   801021e0 <nameiparent>
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	89 c6                	mov    %eax,%esi
801050ea:	0f 84 60 01 00 00    	je     80105250 <sys_unlink+0x1a0>
  ilock(dp);
801050f0:	83 ec 0c             	sub    $0xc,%esp
801050f3:	50                   	push   %eax
801050f4:	e8 b7 c6 ff ff       	call   801017b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050f9:	58                   	pop    %eax
801050fa:	5a                   	pop    %edx
801050fb:	68 1c 7c 10 80       	push   $0x80107c1c
80105100:	53                   	push   %ebx
80105101:	e8 7a cc ff ff       	call   80101d80 <namecmp>
80105106:	83 c4 10             	add    $0x10,%esp
80105109:	85 c0                	test   %eax,%eax
8010510b:	0f 84 03 01 00 00    	je     80105214 <sys_unlink+0x164>
80105111:	83 ec 08             	sub    $0x8,%esp
80105114:	68 1b 7c 10 80       	push   $0x80107c1b
80105119:	53                   	push   %ebx
8010511a:	e8 61 cc ff ff       	call   80101d80 <namecmp>
8010511f:	83 c4 10             	add    $0x10,%esp
80105122:	85 c0                	test   %eax,%eax
80105124:	0f 84 ea 00 00 00    	je     80105214 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010512a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010512d:	83 ec 04             	sub    $0x4,%esp
80105130:	50                   	push   %eax
80105131:	53                   	push   %ebx
80105132:	56                   	push   %esi
80105133:	e8 68 cc ff ff       	call   80101da0 <dirlookup>
80105138:	83 c4 10             	add    $0x10,%esp
8010513b:	85 c0                	test   %eax,%eax
8010513d:	89 c3                	mov    %eax,%ebx
8010513f:	0f 84 cf 00 00 00    	je     80105214 <sys_unlink+0x164>
  ilock(ip);
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	50                   	push   %eax
80105149:	e8 62 c6 ff ff       	call   801017b0 <ilock>
  if(ip->nlink < 1)
8010514e:	83 c4 10             	add    $0x10,%esp
80105151:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105156:	0f 8e 10 01 00 00    	jle    8010526c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010515c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105161:	74 6d                	je     801051d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105163:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105166:	83 ec 04             	sub    $0x4,%esp
80105169:	6a 10                	push   $0x10
8010516b:	6a 00                	push   $0x0
8010516d:	50                   	push   %eax
8010516e:	e8 bd f5 ff ff       	call   80104730 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105173:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105176:	6a 10                	push   $0x10
80105178:	ff 75 c4             	pushl  -0x3c(%ebp)
8010517b:	50                   	push   %eax
8010517c:	56                   	push   %esi
8010517d:	e8 ce ca ff ff       	call   80101c50 <writei>
80105182:	83 c4 20             	add    $0x20,%esp
80105185:	83 f8 10             	cmp    $0x10,%eax
80105188:	0f 85 eb 00 00 00    	jne    80105279 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010518e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105193:	0f 84 97 00 00 00    	je     80105230 <sys_unlink+0x180>
  iunlockput(dp);
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	56                   	push   %esi
8010519d:	e8 5e c9 ff ff       	call   80101b00 <iunlockput>
  ip->nlink--;
801051a2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051a7:	89 1c 24             	mov    %ebx,(%esp)
801051aa:	e8 51 c5 ff ff       	call   80101700 <iupdate>
  iunlockput(ip);
801051af:	89 1c 24             	mov    %ebx,(%esp)
801051b2:	e8 49 c9 ff ff       	call   80101b00 <iunlockput>
  end_op();
801051b7:	e8 34 dd ff ff       	call   80102ef0 <end_op>
  return 0;
801051bc:	83 c4 10             	add    $0x10,%esp
801051bf:	31 c0                	xor    %eax,%eax
}
801051c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c4:	5b                   	pop    %ebx
801051c5:	5e                   	pop    %esi
801051c6:	5f                   	pop    %edi
801051c7:	5d                   	pop    %ebp
801051c8:	c3                   	ret    
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051d4:	76 8d                	jbe    80105163 <sys_unlink+0xb3>
801051d6:	bf 20 00 00 00       	mov    $0x20,%edi
801051db:	eb 0f                	jmp    801051ec <sys_unlink+0x13c>
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
801051e0:	83 c7 10             	add    $0x10,%edi
801051e3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801051e6:	0f 83 77 ff ff ff    	jae    80105163 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051ef:	6a 10                	push   $0x10
801051f1:	57                   	push   %edi
801051f2:	50                   	push   %eax
801051f3:	53                   	push   %ebx
801051f4:	e8 57 c9 ff ff       	call   80101b50 <readi>
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	83 f8 10             	cmp    $0x10,%eax
801051ff:	75 5e                	jne    8010525f <sys_unlink+0x1af>
    if(de.inum != 0)
80105201:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105206:	74 d8                	je     801051e0 <sys_unlink+0x130>
    iunlockput(ip);
80105208:	83 ec 0c             	sub    $0xc,%esp
8010520b:	53                   	push   %ebx
8010520c:	e8 ef c8 ff ff       	call   80101b00 <iunlockput>
    goto bad;
80105211:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105214:	83 ec 0c             	sub    $0xc,%esp
80105217:	56                   	push   %esi
80105218:	e8 e3 c8 ff ff       	call   80101b00 <iunlockput>
  end_op();
8010521d:	e8 ce dc ff ff       	call   80102ef0 <end_op>
  return -1;
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522a:	eb 95                	jmp    801051c1 <sys_unlink+0x111>
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105230:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105235:	83 ec 0c             	sub    $0xc,%esp
80105238:	56                   	push   %esi
80105239:	e8 c2 c4 ff ff       	call   80101700 <iupdate>
8010523e:	83 c4 10             	add    $0x10,%esp
80105241:	e9 53 ff ff ff       	jmp    80105199 <sys_unlink+0xe9>
    return -1;
80105246:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524b:	e9 71 ff ff ff       	jmp    801051c1 <sys_unlink+0x111>
    end_op();
80105250:	e8 9b dc ff ff       	call   80102ef0 <end_op>
    return -1;
80105255:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525a:	e9 62 ff ff ff       	jmp    801051c1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010525f:	83 ec 0c             	sub    $0xc,%esp
80105262:	68 40 7c 10 80       	push   $0x80107c40
80105267:	e8 24 b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010526c:	83 ec 0c             	sub    $0xc,%esp
8010526f:	68 2e 7c 10 80       	push   $0x80107c2e
80105274:	e8 17 b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105279:	83 ec 0c             	sub    $0xc,%esp
8010527c:	68 52 7c 10 80       	push   $0x80107c52
80105281:	e8 0a b1 ff ff       	call   80100390 <panic>
80105286:	8d 76 00             	lea    0x0(%esi),%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105296:	e8 e5 db ff ff       	call   80102e80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010529b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529e:	83 ec 08             	sub    $0x8,%esp
801052a1:	50                   	push   %eax
801052a2:	6a 00                	push   $0x0
801052a4:	e8 37 f8 ff ff       	call   80104ae0 <argstr>
801052a9:	83 c4 10             	add    $0x10,%esp
801052ac:	85 c0                	test   %eax,%eax
801052ae:	78 30                	js     801052e0 <sys_mkdir+0x50>
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b6:	31 c9                	xor    %ecx,%ecx
801052b8:	6a 00                	push   $0x0
801052ba:	ba 01 00 00 00       	mov    $0x1,%edx
801052bf:	e8 bc f8 ff ff       	call   80104b80 <create>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	74 15                	je     801052e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052cb:	83 ec 0c             	sub    $0xc,%esp
801052ce:	50                   	push   %eax
801052cf:	e8 2c c8 ff ff       	call   80101b00 <iunlockput>
  end_op();
801052d4:	e8 17 dc ff ff       	call   80102ef0 <end_op>
  return 0;
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	31 c0                	xor    %eax,%eax
}
801052de:	c9                   	leave  
801052df:	c3                   	ret    
    end_op();
801052e0:	e8 0b dc ff ff       	call   80102ef0 <end_op>
    return -1;
801052e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ea:	c9                   	leave  
801052eb:	c3                   	ret    
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_mknod>:

int
sys_mknod(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801052f6:	e8 85 db ff ff       	call   80102e80 <begin_op>
  if((argstr(0, &path)) < 0 ||
801052fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052fe:	83 ec 08             	sub    $0x8,%esp
80105301:	50                   	push   %eax
80105302:	6a 00                	push   $0x0
80105304:	e8 d7 f7 ff ff       	call   80104ae0 <argstr>
80105309:	83 c4 10             	add    $0x10,%esp
8010530c:	85 c0                	test   %eax,%eax
8010530e:	78 60                	js     80105370 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105310:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105313:	83 ec 08             	sub    $0x8,%esp
80105316:	50                   	push   %eax
80105317:	6a 01                	push   $0x1
80105319:	e8 12 f7 ff ff       	call   80104a30 <argint>
  if((argstr(0, &path)) < 0 ||
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	85 c0                	test   %eax,%eax
80105323:	78 4b                	js     80105370 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105325:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105328:	83 ec 08             	sub    $0x8,%esp
8010532b:	50                   	push   %eax
8010532c:	6a 02                	push   $0x2
8010532e:	e8 fd f6 ff ff       	call   80104a30 <argint>
     argint(1, &major) < 0 ||
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 36                	js     80105370 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010533a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010533e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105341:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105345:	ba 03 00 00 00       	mov    $0x3,%edx
8010534a:	50                   	push   %eax
8010534b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010534e:	e8 2d f8 ff ff       	call   80104b80 <create>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	74 16                	je     80105370 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	50                   	push   %eax
8010535e:	e8 9d c7 ff ff       	call   80101b00 <iunlockput>
  end_op();
80105363:	e8 88 db ff ff       	call   80102ef0 <end_op>
  return 0;
80105368:	83 c4 10             	add    $0x10,%esp
8010536b:	31 c0                	xor    %eax,%eax
}
8010536d:	c9                   	leave  
8010536e:	c3                   	ret    
8010536f:	90                   	nop
    end_op();
80105370:	e8 7b db ff ff       	call   80102ef0 <end_op>
    return -1;
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105386:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010538c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105392:	50                   	push   %eax
80105393:	6a 00                	push   $0x0
80105395:	e8 46 f7 ff ff       	call   80104ae0 <argstr>
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	85 c0                	test   %eax,%eax
8010539f:	0f 88 87 00 00 00    	js     8010542c <sys_exec+0xac>
801053a5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053ab:	83 ec 08             	sub    $0x8,%esp
801053ae:	50                   	push   %eax
801053af:	6a 01                	push   $0x1
801053b1:	e8 7a f6 ff ff       	call   80104a30 <argint>
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	85 c0                	test   %eax,%eax
801053bb:	78 6f                	js     8010542c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053bd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053c3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801053c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801053c8:	68 80 00 00 00       	push   $0x80
801053cd:	6a 00                	push   $0x0
801053cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053d5:	50                   	push   %eax
801053d6:	e8 55 f3 ff ff       	call   80104730 <memset>
801053db:	83 c4 10             	add    $0x10,%esp
801053de:	eb 2c                	jmp    8010540c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801053e0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053e6:	85 c0                	test   %eax,%eax
801053e8:	74 56                	je     80105440 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053ea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801053f0:	83 ec 08             	sub    $0x8,%esp
801053f3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801053f6:	52                   	push   %edx
801053f7:	50                   	push   %eax
801053f8:	e8 c3 f5 ff ff       	call   801049c0 <fetchstr>
801053fd:	83 c4 10             	add    $0x10,%esp
80105400:	85 c0                	test   %eax,%eax
80105402:	78 28                	js     8010542c <sys_exec+0xac>
  for(i=0;; i++){
80105404:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105407:	83 fb 20             	cmp    $0x20,%ebx
8010540a:	74 20                	je     8010542c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010540c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105412:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105419:	83 ec 08             	sub    $0x8,%esp
8010541c:	57                   	push   %edi
8010541d:	01 f0                	add    %esi,%eax
8010541f:	50                   	push   %eax
80105420:	e8 5b f5 ff ff       	call   80104980 <fetchint>
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	85 c0                	test   %eax,%eax
8010542a:	79 b4                	jns    801053e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010542c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010542f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105434:	5b                   	pop    %ebx
80105435:	5e                   	pop    %esi
80105436:	5f                   	pop    %edi
80105437:	5d                   	pop    %ebp
80105438:	c3                   	ret    
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105440:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105446:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105449:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105450:	00 00 00 00 
  return exec(path, argv);
80105454:	50                   	push   %eax
80105455:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010545b:	e8 b0 b5 ff ff       	call   80100a10 <exec>
80105460:	83 c4 10             	add    $0x10,%esp
}
80105463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105466:	5b                   	pop    %ebx
80105467:	5e                   	pop    %esi
80105468:	5f                   	pop    %edi
80105469:	5d                   	pop    %ebp
8010546a:	c3                   	ret    
8010546b:	90                   	nop
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_pipe>:

int
sys_pipe(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105476:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105479:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010547c:	6a 08                	push   $0x8
8010547e:	50                   	push   %eax
8010547f:	6a 00                	push   $0x0
80105481:	e8 fa f5 ff ff       	call   80104a80 <argptr>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	0f 88 ae 00 00 00    	js     8010553f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105491:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105494:	83 ec 08             	sub    $0x8,%esp
80105497:	50                   	push   %eax
80105498:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010549b:	50                   	push   %eax
8010549c:	e8 7f e0 ff ff       	call   80103520 <pipealloc>
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	85 c0                	test   %eax,%eax
801054a6:	0f 88 93 00 00 00    	js     8010553f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801054af:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054b1:	e8 0a e6 ff ff       	call   80103ac0 <myproc>
801054b6:	eb 10                	jmp    801054c8 <sys_pipe+0x58>
801054b8:	90                   	nop
801054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054c0:	83 c3 01             	add    $0x1,%ebx
801054c3:	83 fb 10             	cmp    $0x10,%ebx
801054c6:	74 60                	je     80105528 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801054c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801054cc:	85 f6                	test   %esi,%esi
801054ce:	75 f0                	jne    801054c0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801054d0:	8d 73 08             	lea    0x8(%ebx),%esi
801054d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801054da:	e8 e1 e5 ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054df:	31 d2                	xor    %edx,%edx
801054e1:	eb 0d                	jmp    801054f0 <sys_pipe+0x80>
801054e3:	90                   	nop
801054e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054e8:	83 c2 01             	add    $0x1,%edx
801054eb:	83 fa 10             	cmp    $0x10,%edx
801054ee:	74 28                	je     80105518 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801054f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801054f4:	85 c9                	test   %ecx,%ecx
801054f6:	75 f0                	jne    801054e8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801054f8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801054fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054ff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105501:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105504:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105507:	31 c0                	xor    %eax,%eax
}
80105509:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010550c:	5b                   	pop    %ebx
8010550d:	5e                   	pop    %esi
8010550e:	5f                   	pop    %edi
8010550f:	5d                   	pop    %ebp
80105510:	c3                   	ret    
80105511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105518:	e8 a3 e5 ff ff       	call   80103ac0 <myproc>
8010551d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105524:	00 
80105525:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105528:	83 ec 0c             	sub    $0xc,%esp
8010552b:	ff 75 e0             	pushl  -0x20(%ebp)
8010552e:	e8 3d b9 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105533:	58                   	pop    %eax
80105534:	ff 75 e4             	pushl  -0x1c(%ebp)
80105537:	e8 34 b9 ff ff       	call   80100e70 <fileclose>
    return -1;
8010553c:	83 c4 10             	add    $0x10,%esp
8010553f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105544:	eb c3                	jmp    80105509 <sys_pipe+0x99>
80105546:	8d 76 00             	lea    0x0(%esi),%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <create_symlink>:

int
create_symlink(const char* oldpath , const char* newpath)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
80105556:	83 ec 0c             	sub    $0xc,%esp
80105559:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file *f;
  struct inode *ip;

  begin_op();
8010555c:	e8 1f d9 ff ff       	call   80102e80 <begin_op>

  if((ip = create((char*)newpath, T_SYMLINK, 0, 0)) == 0)
80105561:	83 ec 0c             	sub    $0xc,%esp
80105564:	8b 45 0c             	mov    0xc(%ebp),%eax
80105567:	31 c9                	xor    %ecx,%ecx
80105569:	6a 00                	push   $0x0
8010556b:	ba 04 00 00 00       	mov    $0x4,%edx
80105570:	e8 0b f6 ff ff       	call   80104b80 <create>
80105575:	83 c4 10             	add    $0x10,%esp
80105578:	85 c0                	test   %eax,%eax
8010557a:	74 5a                	je     801055d6 <create_symlink+0x86>
8010557c:	89 c3                	mov    %eax,%ebx
  {
    end_op();
    return -1;
  }

  end_op();
8010557e:	e8 6d d9 ff ff       	call   80102ef0 <end_op>

  if((f = filealloc()) == 0)
80105583:	e8 28 b8 ff ff       	call   80100db0 <filealloc>
80105588:	85 c0                	test   %eax,%eax
8010558a:	89 c6                	mov    %eax,%esi
8010558c:	74 54                	je     801055e2 <create_symlink+0x92>
      fileclose(f);
    iunlockput(ip);
    return -1;
  }

  if(strlen(oldpath) > LINK_LIMIT)
8010558e:	83 ec 0c             	sub    $0xc,%esp
80105591:	57                   	push   %edi
80105592:	e8 b9 f3 ff ff       	call   80104950 <strlen>
80105597:	83 c4 10             	add    $0x10,%esp
8010559a:	83 f8 32             	cmp    $0x32,%eax
8010559d:	7f 56                	jg     801055f5 <create_symlink+0xa5>
    panic("symlink: new path is too long");
  safestrcpy((char*)ip->addrs, oldpath, LINK_LIMIT);
8010559f:	8d 43 5c             	lea    0x5c(%ebx),%eax
801055a2:	83 ec 04             	sub    $0x4,%esp
801055a5:	6a 32                	push   $0x32
801055a7:	57                   	push   %edi
801055a8:	50                   	push   %eax
801055a9:	e8 62 f3 ff ff       	call   80104910 <safestrcpy>
  iunlock(ip);
801055ae:	89 1c 24             	mov    %ebx,(%esp)
801055b1:	e8 da c2 ff ff       	call   80101890 <iunlock>

  f->ip = ip;
  f->off = 0;
  f->readable = 1;
801055b6:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
801055bb:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
801055be:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = 1;
801055c5:	66 89 46 08          	mov    %ax,0x8(%esi)
  f->writable = 0;

  return 0;
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	31 c0                	xor    %eax,%eax
}
801055ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055d1:	5b                   	pop    %ebx
801055d2:	5e                   	pop    %esi
801055d3:	5f                   	pop    %edi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret    
    end_op();
801055d6:	e8 15 d9 ff ff       	call   80102ef0 <end_op>
    return -1;
801055db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e0:	eb ec                	jmp    801055ce <create_symlink+0x7e>
    iunlockput(ip);
801055e2:	83 ec 0c             	sub    $0xc,%esp
801055e5:	53                   	push   %ebx
801055e6:	e8 15 c5 ff ff       	call   80101b00 <iunlockput>
    return -1;
801055eb:	83 c4 10             	add    $0x10,%esp
801055ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f3:	eb d9                	jmp    801055ce <create_symlink+0x7e>
    panic("symlink: new path is too long");
801055f5:	83 ec 0c             	sub    $0xc,%esp
801055f8:	68 61 7c 10 80       	push   $0x80107c61
801055fd:	e8 8e ad ff ff       	call   80100390 <panic>
80105602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <read_symlink>:

int
read_symlink(const char* pathname, char* buf, size_t bufsize)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
80105616:	83 ec 58             	sub    $0x58,%esp
80105619:	8b 5d 08             	mov    0x8(%ebp),%ebx

  if(strlen(pathname) > bufsize)
8010561c:	53                   	push   %ebx
8010561d:	e8 2e f3 ff ff       	call   80104950 <strlen>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	3b 45 10             	cmp    0x10(%ebp),%eax
80105628:	0f 87 c2 00 00 00    	ja     801056f0 <read_symlink+0xe0>
    cprintf("pathname is bigger than bufsize\n");
    return -1;
  }

  struct inode * ip;
  if ((ip = namei((char*)pathname, 1)) == 0)  // checks if the path exists
8010562e:	83 ec 08             	sub    $0x8,%esp
80105631:	6a 01                	push   $0x1
80105633:	53                   	push   %ebx
80105634:	e8 87 cb ff ff       	call   801021c0 <namei>
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	85 c0                	test   %eax,%eax
8010563e:	89 c3                	mov    %eax,%ebx
80105640:	0f 84 ca 00 00 00    	je     80105710 <read_symlink+0x100>
  {
    return -1;
  }
  
  ilock(ip);
80105646:	83 ec 0c             	sub    $0xc,%esp
80105649:	50                   	push   %eax
8010564a:	e8 61 c1 ff ff       	call   801017b0 <ilock>
  if(ip->type != T_SYMLINK)
8010564f:	83 c4 10             	add    $0x10,%esp
80105652:	66 83 7b 50 04       	cmpw   $0x4,0x50(%ebx)
80105657:	75 7f                	jne    801056d8 <read_symlink+0xc8>
    iunlock(ip);
    return -1;
  }
  
  char buf_temp[LINK_LIMIT];
  safestrcpy(buf_temp,(char*)ip->addrs, LINK_LIMIT);
80105659:	8d 7d b6             	lea    -0x4a(%ebp),%edi
8010565c:	8d 73 5c             	lea    0x5c(%ebx),%esi
8010565f:	83 ec 04             	sub    $0x4,%esp
80105662:	6a 32                	push   $0x32
80105664:	56                   	push   %esi
80105665:	57                   	push   %edi
80105666:	e8 a5 f2 ff ff       	call   80104910 <safestrcpy>
  struct inode * ip_next;
  if ((ip_next = namei((char*)buf_temp, 1)) > 0)  // checks if the path exists
8010566b:	58                   	pop    %eax
8010566c:	5a                   	pop    %edx
8010566d:	6a 01                	push   $0x1
8010566f:	57                   	push   %edi
80105670:	e8 4b cb ff ff       	call   801021c0 <namei>
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	85 c0                	test   %eax,%eax
8010567a:	74 5c                	je     801056d8 <read_symlink+0xc8>
  {
      if(ip_next->type != T_SYMLINK)
8010567c:	66 83 78 50 04       	cmpw   $0x4,0x50(%eax)
80105681:	74 2d                	je     801056b0 <read_symlink+0xa0>
      {
        safestrcpy(buf,(char*)ip->addrs, bufsize);
80105683:	83 ec 04             	sub    $0x4,%esp
80105686:	ff 75 10             	pushl  0x10(%ebp)
80105689:	56                   	push   %esi
8010568a:	ff 75 0c             	pushl  0xc(%ebp)
8010568d:	e8 7e f2 ff ff       	call   80104910 <safestrcpy>
        iunlock(ip);
80105692:	89 1c 24             	mov    %ebx,(%esp)
80105695:	e8 f6 c1 ff ff       	call   80101890 <iunlock>
        return 0;
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	31 c0                	xor    %eax,%eax
  {
    iunlock(ip);
    return -1;
  }
  
8010569f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a2:	5b                   	pop    %ebx
801056a3:	5e                   	pop    %esi
801056a4:	5f                   	pop    %edi
801056a5:	5d                   	pop    %ebp
801056a6:	c3                   	ret    
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          iunlock(ip);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	53                   	push   %ebx
801056b4:	e8 d7 c1 ff ff       	call   80101890 <iunlock>
          return read_symlink(buf_temp,buf, bufsize);
801056b9:	83 c4 0c             	add    $0xc,%esp
801056bc:	ff 75 10             	pushl  0x10(%ebp)
801056bf:	ff 75 0c             	pushl  0xc(%ebp)
801056c2:	57                   	push   %edi
801056c3:	e8 48 ff ff ff       	call   80105610 <read_symlink>
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ce:	5b                   	pop    %ebx
801056cf:	5e                   	pop    %esi
801056d0:	5f                   	pop    %edi
801056d1:	5d                   	pop    %ebp
801056d2:	c3                   	ret    
801056d3:	90                   	nop
801056d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlock(ip);
801056d8:	83 ec 0c             	sub    $0xc,%esp
801056db:	53                   	push   %ebx
801056dc:	e8 af c1 ff ff       	call   80101890 <iunlock>
    return -1;
801056e1:	83 c4 10             	add    $0x10,%esp
801056e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e9:	eb b4                	jmp    8010569f <read_symlink+0x8f>
801056eb:	90                   	nop
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("pathname is bigger than bufsize\n");
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	68 80 7c 10 80       	push   $0x80107c80
801056f8:	e8 63 af ff ff       	call   80100660 <cprintf>
    return -1;
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105705:	eb 98                	jmp    8010569f <read_symlink+0x8f>
80105707:	89 f6                	mov    %esi,%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105715:	eb 88                	jmp    8010569f <read_symlink+0x8f>
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <sys_open>:
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	57                   	push   %edi
80105724:	56                   	push   %esi
80105725:	53                   	push   %ebx
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105726:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
{
8010572c:	81 ec 84 00 00 00    	sub    $0x84,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105732:	50                   	push   %eax
80105733:	6a 00                	push   $0x0
80105735:	e8 a6 f3 ff ff       	call   80104ae0 <argstr>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	85 c0                	test   %eax,%eax
8010573f:	0f 88 37 01 00 00    	js     8010587c <sys_open+0x15c>
80105745:	8d 45 80             	lea    -0x80(%ebp),%eax
80105748:	83 ec 08             	sub    $0x8,%esp
8010574b:	50                   	push   %eax
8010574c:	6a 01                	push   $0x1
8010574e:	e8 dd f2 ff ff       	call   80104a30 <argint>
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	0f 88 1e 01 00 00    	js     8010587c <sys_open+0x15c>
  begin_op();
8010575e:	e8 1d d7 ff ff       	call   80102e80 <begin_op>
  if(omode & O_CREATE){
80105763:	f6 45 81 02          	testb  $0x2,-0x7f(%ebp)
80105767:	0f 85 c3 00 00 00    	jne    80105830 <sys_open+0x110>
    if((ip = namei(path, 1)) == 0){
8010576d:	83 ec 08             	sub    $0x8,%esp
80105770:	6a 01                	push   $0x1
80105772:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
80105778:	e8 43 ca ff ff       	call   801021c0 <namei>
8010577d:	83 c4 10             	add    $0x10,%esp
80105780:	85 c0                	test   %eax,%eax
80105782:	89 c6                	mov    %eax,%esi
80105784:	0f 84 ca 00 00 00    	je     80105854 <sys_open+0x134>
    ilock(ip);
8010578a:	83 ec 0c             	sub    $0xc,%esp
8010578d:	50                   	push   %eax
8010578e:	e8 1d c0 ff ff       	call   801017b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105793:	0f b7 46 50          	movzwl 0x50(%esi),%eax
80105797:	83 c4 10             	add    $0x10,%esp
8010579a:	66 83 f8 01          	cmp    $0x1,%ax
8010579e:	0f 84 bc 00 00 00    	je     80105860 <sys_open+0x140>
    if(ip->type == T_SYMLINK)
801057a4:	66 83 f8 04          	cmp    $0x4,%ax
801057a8:	0f 84 da 00 00 00    	je     80105888 <sys_open+0x168>
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057ae:	e8 fd b5 ff ff       	call   80100db0 <filealloc>
801057b3:	85 c0                	test   %eax,%eax
801057b5:	89 c7                	mov    %eax,%edi
801057b7:	0f 84 ae 00 00 00    	je     8010586b <sys_open+0x14b>
  struct proc *curproc = myproc();
801057bd:	e8 fe e2 ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057c2:	31 db                	xor    %ebx,%ebx
801057c4:	eb 16                	jmp    801057dc <sys_open+0xbc>
801057c6:	8d 76 00             	lea    0x0(%esi),%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801057d0:	83 c3 01             	add    $0x1,%ebx
801057d3:	83 fb 10             	cmp    $0x10,%ebx
801057d6:	0f 84 ec 00 00 00    	je     801058c8 <sys_open+0x1a8>
    if(curproc->ofile[fd] == 0){
801057dc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057e0:	85 d2                	test   %edx,%edx
801057e2:	75 ec                	jne    801057d0 <sys_open+0xb0>
  iunlock(ip);
801057e4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801057e7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801057eb:	56                   	push   %esi
801057ec:	e8 9f c0 ff ff       	call   80101890 <iunlock>
  end_op();
801057f1:	e8 fa d6 ff ff       	call   80102ef0 <end_op>
  f->type = FD_INODE;
801057f6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->readable = !(omode & O_WRONLY);
801057fc:	8b 55 80             	mov    -0x80(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057ff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105802:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105805:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010580c:	89 d0                	mov    %edx,%eax
8010580e:	f7 d0                	not    %eax
80105810:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105813:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105816:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105819:	0f 95 47 09          	setne  0x9(%edi)
}
8010581d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105820:	89 d8                	mov    %ebx,%eax
80105822:	5b                   	pop    %ebx
80105823:	5e                   	pop    %esi
80105824:	5f                   	pop    %edi
80105825:	5d                   	pop    %ebp
80105826:	c3                   	ret    
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
80105839:	31 c9                	xor    %ecx,%ecx
8010583b:	6a 00                	push   $0x0
8010583d:	ba 02 00 00 00       	mov    $0x2,%edx
80105842:	e8 39 f3 ff ff       	call   80104b80 <create>
    if(ip == 0){
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
8010584c:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010584e:	0f 85 5a ff ff ff    	jne    801057ae <sys_open+0x8e>
      end_op();
80105854:	e8 97 d6 ff ff       	call   80102ef0 <end_op>
      return -1;
80105859:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010585e:	eb bd                	jmp    8010581d <sys_open+0xfd>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105860:	8b 7d 80             	mov    -0x80(%ebp),%edi
80105863:	85 ff                	test   %edi,%edi
80105865:	0f 84 43 ff ff ff    	je     801057ae <sys_open+0x8e>
    iunlockput(ip);
8010586b:	83 ec 0c             	sub    $0xc,%esp
8010586e:	56                   	push   %esi
8010586f:	e8 8c c2 ff ff       	call   80101b00 <iunlockput>
    end_op();
80105874:	e8 77 d6 ff ff       	call   80102ef0 <end_op>
    return -1;
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105881:	eb 9a                	jmp    8010581d <sys_open+0xfd>
80105883:	90                   	nop
80105884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      iunlock(ip);
80105888:	83 ec 0c             	sub    $0xc,%esp
      read_symlink(path, buf, 100);
8010588b:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
      iunlock(ip);
8010588e:	56                   	push   %esi
8010588f:	e8 fc bf ff ff       	call   80101890 <iunlock>
      read_symlink(path, buf, 100);
80105894:	83 c4 0c             	add    $0xc,%esp
80105897:	6a 64                	push   $0x64
80105899:	53                   	push   %ebx
8010589a:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
801058a0:	e8 6b fd ff ff       	call   80105610 <read_symlink>
      ip = namei(buf,1);
801058a5:	59                   	pop    %ecx
801058a6:	5e                   	pop    %esi
801058a7:	6a 01                	push   $0x1
801058a9:	53                   	push   %ebx
801058aa:	e8 11 c9 ff ff       	call   801021c0 <namei>
      ilock(ip);
801058af:	89 04 24             	mov    %eax,(%esp)
      ip = namei(buf,1);
801058b2:	89 c6                	mov    %eax,%esi
      ilock(ip);
801058b4:	e8 f7 be ff ff       	call   801017b0 <ilock>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	e9 ed fe ff ff       	jmp    801057ae <sys_open+0x8e>
801058c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	57                   	push   %edi
801058cc:	e8 9f b5 ff ff       	call   80100e70 <fileclose>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	eb 95                	jmp    8010586b <sys_open+0x14b>
801058d6:	8d 76 00             	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <sys_chdir>:
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	56                   	push   %esi
801058e4:	53                   	push   %ebx
801058e5:	83 ec 40             	sub    $0x40,%esp
  struct proc *curproc = myproc();
801058e8:	e8 d3 e1 ff ff       	call   80103ac0 <myproc>
801058ed:	89 c6                	mov    %eax,%esi
  begin_op();
801058ef:	e8 8c d5 ff ff       	call   80102e80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path, 1)) == 0){
801058f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801058f7:	83 ec 08             	sub    $0x8,%esp
801058fa:	50                   	push   %eax
801058fb:	6a 00                	push   $0x0
801058fd:	e8 de f1 ff ff       	call   80104ae0 <argstr>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	85 c0                	test   %eax,%eax
80105907:	0f 88 b3 00 00 00    	js     801059c0 <sys_chdir+0xe0>
8010590d:	83 ec 08             	sub    $0x8,%esp
80105910:	6a 01                	push   $0x1
80105912:	ff 75 c0             	pushl  -0x40(%ebp)
80105915:	e8 a6 c8 ff ff       	call   801021c0 <namei>
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	85 c0                	test   %eax,%eax
8010591f:	0f 84 9b 00 00 00    	je     801059c0 <sys_chdir+0xe0>
  if(read_symlink(path, path_name, LINK_LIMIT) == 0) // ?? if it's not symbolic link ??
80105925:	8d 5d c6             	lea    -0x3a(%ebp),%ebx
80105928:	83 ec 04             	sub    $0x4,%esp
8010592b:	6a 32                	push   $0x32
8010592d:	53                   	push   %ebx
8010592e:	ff 75 c0             	pushl  -0x40(%ebp)
80105931:	e8 da fc ff ff       	call   80105610 <read_symlink>
80105936:	83 c4 10             	add    $0x10,%esp
80105939:	85 c0                	test   %eax,%eax
8010593b:	74 53                	je     80105990 <sys_chdir+0xb0>
  else if((ip = namei(path, 1) )== 0) // ?? if the current path doesnt exist
8010593d:	83 ec 08             	sub    $0x8,%esp
80105940:	6a 01                	push   $0x1
80105942:	ff 75 c0             	pushl  -0x40(%ebp)
80105945:	e8 76 c8 ff ff       	call   801021c0 <namei>
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	85 c0                	test   %eax,%eax
8010594f:	89 c3                	mov    %eax,%ebx
80105951:	74 6d                	je     801059c0 <sys_chdir+0xe0>
  ilock(ip);
80105953:	83 ec 0c             	sub    $0xc,%esp
80105956:	50                   	push   %eax
80105957:	e8 54 be ff ff       	call   801017b0 <ilock>
  if(ip->type != T_DIR){
8010595c:	83 c4 10             	add    $0x10,%esp
8010595f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105964:	75 3a                	jne    801059a0 <sys_chdir+0xc0>
  iunlock(ip);
80105966:	83 ec 0c             	sub    $0xc,%esp
80105969:	53                   	push   %ebx
8010596a:	e8 21 bf ff ff       	call   80101890 <iunlock>
  iput(curproc->cwd);
8010596f:	58                   	pop    %eax
80105970:	ff 76 68             	pushl  0x68(%esi)
80105973:	e8 68 bf ff ff       	call   801018e0 <iput>
  end_op();
80105978:	e8 73 d5 ff ff       	call   80102ef0 <end_op>
  curproc->cwd = ip;
8010597d:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105980:	83 c4 10             	add    $0x10,%esp
80105983:	31 c0                	xor    %eax,%eax
}
80105985:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105988:	5b                   	pop    %ebx
80105989:	5e                   	pop    %esi
8010598a:	5d                   	pop    %ebp
8010598b:	c3                   	ret    
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path_name, 1)) == 0) // ?? if the indoe doesn't exists
80105990:	83 ec 08             	sub    $0x8,%esp
80105993:	6a 01                	push   $0x1
80105995:	53                   	push   %ebx
80105996:	eb ad                	jmp    80105945 <sys_chdir+0x65>
80105998:	90                   	nop
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	53                   	push   %ebx
801059a4:	e8 57 c1 ff ff       	call   80101b00 <iunlockput>
    end_op();
801059a9:	e8 42 d5 ff ff       	call   80102ef0 <end_op>
    return -1;
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b6:	eb cd                	jmp    80105985 <sys_chdir+0xa5>
801059b8:	90                   	nop
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801059c0:	e8 2b d5 ff ff       	call   80102ef0 <end_op>
    return -1;
801059c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ca:	eb b9                	jmp    80105985 <sys_chdir+0xa5>
801059cc:	66 90                	xchg   %ax,%ax
801059ce:	66 90                	xchg   %ax,%ax

801059d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059d3:	5d                   	pop    %ebp
  return fork();
801059d4:	e9 87 e2 ff ff       	jmp    80103c60 <fork>
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_exit>:

int
sys_exit(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059e6:	e8 f5 e4 ff ff       	call   80103ee0 <exit>
  return 0;  // not reached
}
801059eb:	31 c0                	xor    %eax,%eax
801059ed:	c9                   	leave  
801059ee:	c3                   	ret    
801059ef:	90                   	nop

801059f0 <sys_wait>:

int
sys_wait(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801059f3:	5d                   	pop    %ebp
  return wait();
801059f4:	e9 27 e7 ff ff       	jmp    80104120 <wait>
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_kill>:

int
sys_kill(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a09:	50                   	push   %eax
80105a0a:	6a 00                	push   $0x0
80105a0c:	e8 1f f0 ff ff       	call   80104a30 <argint>
80105a11:	83 c4 10             	add    $0x10,%esp
80105a14:	85 c0                	test   %eax,%eax
80105a16:	78 18                	js     80105a30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a18:	83 ec 0c             	sub    $0xc,%esp
80105a1b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a1e:	e8 4d e8 ff ff       	call   80104270 <kill>
80105a23:	83 c4 10             	add    $0x10,%esp
}
80105a26:	c9                   	leave  
80105a27:	c3                   	ret    
80105a28:	90                   	nop
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_getpid>:

int
sys_getpid(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a46:	e8 75 e0 ff ff       	call   80103ac0 <myproc>
80105a4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a4e:	c9                   	leave  
80105a4f:	c3                   	ret    

80105a50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a5a:	50                   	push   %eax
80105a5b:	6a 00                	push   $0x0
80105a5d:	e8 ce ef ff ff       	call   80104a30 <argint>
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	85 c0                	test   %eax,%eax
80105a67:	78 27                	js     80105a90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a69:	e8 52 e0 ff ff       	call   80103ac0 <myproc>
  if(growproc(n) < 0)
80105a6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a73:	ff 75 f4             	pushl  -0xc(%ebp)
80105a76:	e8 65 e1 ff ff       	call   80103be0 <growproc>
80105a7b:	83 c4 10             	add    $0x10,%esp
80105a7e:	85 c0                	test   %eax,%eax
80105a80:	78 0e                	js     80105a90 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a82:	89 d8                	mov    %ebx,%eax
80105a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a87:	c9                   	leave  
80105a88:	c3                   	ret    
80105a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a95:	eb eb                	jmp    80105a82 <sys_sbrk+0x32>
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <sys_sleep>:

int
sys_sleep(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105aa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aaa:	50                   	push   %eax
80105aab:	6a 00                	push   $0x0
80105aad:	e8 7e ef ff ff       	call   80104a30 <argint>
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	0f 88 8a 00 00 00    	js     80105b47 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	68 20 4d 11 80       	push   $0x80114d20
80105ac5:	e8 56 eb ff ff       	call   80104620 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105aca:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105acd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105ad0:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  while(ticks - ticks0 < n){
80105ad6:	85 d2                	test   %edx,%edx
80105ad8:	75 27                	jne    80105b01 <sys_sleep+0x61>
80105ada:	eb 54                	jmp    80105b30 <sys_sleep+0x90>
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ae0:	83 ec 08             	sub    $0x8,%esp
80105ae3:	68 20 4d 11 80       	push   $0x80114d20
80105ae8:	68 60 55 11 80       	push   $0x80115560
80105aed:	e8 6e e5 ff ff       	call   80104060 <sleep>
  while(ticks - ticks0 < n){
80105af2:	a1 60 55 11 80       	mov    0x80115560,%eax
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	29 d8                	sub    %ebx,%eax
80105afc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105aff:	73 2f                	jae    80105b30 <sys_sleep+0x90>
    if(myproc()->killed){
80105b01:	e8 ba df ff ff       	call   80103ac0 <myproc>
80105b06:	8b 40 24             	mov    0x24(%eax),%eax
80105b09:	85 c0                	test   %eax,%eax
80105b0b:	74 d3                	je     80105ae0 <sys_sleep+0x40>
      release(&tickslock);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	68 20 4d 11 80       	push   $0x80114d20
80105b15:	e8 c6 eb ff ff       	call   801046e0 <release>
      return -1;
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105b22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b25:	c9                   	leave  
80105b26:	c3                   	ret    
80105b27:	89 f6                	mov    %esi,%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	68 20 4d 11 80       	push   $0x80114d20
80105b38:	e8 a3 eb ff ff       	call   801046e0 <release>
  return 0;
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	31 c0                	xor    %eax,%eax
}
80105b42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b45:	c9                   	leave  
80105b46:	c3                   	ret    
    return -1;
80105b47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b4c:	eb f4                	jmp    80105b42 <sys_sleep+0xa2>
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	53                   	push   %ebx
80105b54:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b57:	68 20 4d 11 80       	push   $0x80114d20
80105b5c:	e8 bf ea ff ff       	call   80104620 <acquire>
  xticks = ticks;
80105b61:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  release(&tickslock);
80105b67:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80105b6e:	e8 6d eb ff ff       	call   801046e0 <release>
  return xticks;
}
80105b73:	89 d8                	mov    %ebx,%eax
80105b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b78:	c9                   	leave  
80105b79:	c3                   	ret    
80105b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b80 <sys_symlink>:

int
sys_symlink(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 1c             	sub    $0x1c,%esp
  const char *oldpath;
  const char *newpath;
  
  if(argptr(0, (char**)&oldpath, 4) < 0)
80105b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b89:	6a 04                	push   $0x4
80105b8b:	50                   	push   %eax
80105b8c:	6a 00                	push   $0x0
80105b8e:	e8 ed ee ff ff       	call   80104a80 <argptr>
80105b93:	83 c4 10             	add    $0x10,%esp
80105b96:	85 c0                	test   %eax,%eax
80105b98:	78 2e                	js     80105bc8 <sys_symlink+0x48>
    return -1;
  if(argptr(1, (char**)&newpath, 4) < 0)
80105b9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b9d:	83 ec 04             	sub    $0x4,%esp
80105ba0:	6a 04                	push   $0x4
80105ba2:	50                   	push   %eax
80105ba3:	6a 01                	push   $0x1
80105ba5:	e8 d6 ee ff ff       	call   80104a80 <argptr>
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	85 c0                	test   %eax,%eax
80105baf:	78 17                	js     80105bc8 <sys_symlink+0x48>
    return -1;


  return create_symlink(oldpath, newpath);
80105bb1:	83 ec 08             	sub    $0x8,%esp
80105bb4:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb7:	ff 75 f0             	pushl  -0x10(%ebp)
80105bba:	e8 91 f9 ff ff       	call   80105550 <create_symlink>
80105bbf:	83 c4 10             	add    $0x10,%esp
}
80105bc2:	c9                   	leave  
80105bc3:	c3                   	ret    
80105bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bcd:	c9                   	leave  
80105bce:	c3                   	ret    
80105bcf:	90                   	nop

80105bd0 <sys_readlink>:

int
sys_readlink(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 1c             	sub    $0x1c,%esp
  const char *pathname;
  char *buf;
  size_t bufsize;
  
  if(argptr(0, (char**)&pathname, 4) < 0)
80105bd6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bd9:	6a 04                	push   $0x4
80105bdb:	50                   	push   %eax
80105bdc:	6a 00                	push   $0x0
80105bde:	e8 9d ee ff ff       	call   80104a80 <argptr>
80105be3:	83 c4 10             	add    $0x10,%esp
80105be6:	85 c0                	test   %eax,%eax
80105be8:	78 46                	js     80105c30 <sys_readlink+0x60>
    return -1;
  if(argptr(1, (char**)&buf, 4) < 0)
80105bea:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bed:	83 ec 04             	sub    $0x4,%esp
80105bf0:	6a 04                	push   $0x4
80105bf2:	50                   	push   %eax
80105bf3:	6a 01                	push   $0x1
80105bf5:	e8 86 ee ff ff       	call   80104a80 <argptr>
80105bfa:	83 c4 10             	add    $0x10,%esp
80105bfd:	85 c0                	test   %eax,%eax
80105bff:	78 2f                	js     80105c30 <sys_readlink+0x60>
    return -1;
  if(argint(2, (int*)&bufsize) < 0)
80105c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c04:	83 ec 08             	sub    $0x8,%esp
80105c07:	50                   	push   %eax
80105c08:	6a 02                	push   $0x2
80105c0a:	e8 21 ee ff ff       	call   80104a30 <argint>
80105c0f:	83 c4 10             	add    $0x10,%esp
80105c12:	85 c0                	test   %eax,%eax
80105c14:	78 1a                	js     80105c30 <sys_readlink+0x60>
    return -1;

  return read_symlink(pathname, buf, bufsize);
80105c16:	83 ec 04             	sub    $0x4,%esp
80105c19:	ff 75 f4             	pushl  -0xc(%ebp)
80105c1c:	ff 75 f0             	pushl  -0x10(%ebp)
80105c1f:	ff 75 ec             	pushl  -0x14(%ebp)
80105c22:	e8 e9 f9 ff ff       	call   80105610 <read_symlink>
80105c27:	83 c4 10             	add    $0x10,%esp
}
80105c2a:	c9                   	leave  
80105c2b:	c3                   	ret    
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c35:	c9                   	leave  
80105c36:	c3                   	ret    

80105c37 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c37:	1e                   	push   %ds
  pushl %es
80105c38:	06                   	push   %es
  pushl %fs
80105c39:	0f a0                	push   %fs
  pushl %gs
80105c3b:	0f a8                	push   %gs
  pushal
80105c3d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c3e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c42:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c44:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c46:	54                   	push   %esp
  call trap
80105c47:	e8 c4 00 00 00       	call   80105d10 <trap>
  addl $4, %esp
80105c4c:	83 c4 04             	add    $0x4,%esp

80105c4f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c4f:	61                   	popa   
  popl %gs
80105c50:	0f a9                	pop    %gs
  popl %fs
80105c52:	0f a1                	pop    %fs
  popl %es
80105c54:	07                   	pop    %es
  popl %ds
80105c55:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c56:	83 c4 08             	add    $0x8,%esp
  iret
80105c59:	cf                   	iret   
80105c5a:	66 90                	xchg   %ax,%ax
80105c5c:	66 90                	xchg   %ax,%ax
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c60:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c61:	31 c0                	xor    %eax,%eax
{
80105c63:	89 e5                	mov    %esp,%ebp
80105c65:	83 ec 08             	sub    $0x8,%esp
80105c68:	90                   	nop
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c70:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c77:	c7 04 c5 62 4d 11 80 	movl   $0x8e000008,-0x7feeb29e(,%eax,8)
80105c7e:	08 00 00 8e 
80105c82:	66 89 14 c5 60 4d 11 	mov    %dx,-0x7feeb2a0(,%eax,8)
80105c89:	80 
80105c8a:	c1 ea 10             	shr    $0x10,%edx
80105c8d:	66 89 14 c5 66 4d 11 	mov    %dx,-0x7feeb29a(,%eax,8)
80105c94:	80 
  for(i = 0; i < 256; i++)
80105c95:	83 c0 01             	add    $0x1,%eax
80105c98:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c9d:	75 d1                	jne    80105c70 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c9f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105ca4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ca7:	c7 05 62 4f 11 80 08 	movl   $0xef000008,0x80114f62
80105cae:	00 00 ef 
  initlock(&tickslock, "time");
80105cb1:	68 a1 7c 10 80       	push   $0x80107ca1
80105cb6:	68 20 4d 11 80       	push   $0x80114d20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cbb:	66 a3 60 4f 11 80    	mov    %ax,0x80114f60
80105cc1:	c1 e8 10             	shr    $0x10,%eax
80105cc4:	66 a3 66 4f 11 80    	mov    %ax,0x80114f66
  initlock(&tickslock, "time");
80105cca:	e8 11 e8 ff ff       	call   801044e0 <initlock>
}
80105ccf:	83 c4 10             	add    $0x10,%esp
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    
80105cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ce0 <idtinit>:

void
idtinit(void)
{
80105ce0:	55                   	push   %ebp
  pd[0] = size-1;
80105ce1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ce6:	89 e5                	mov    %esp,%ebp
80105ce8:	83 ec 10             	sub    $0x10,%esp
80105ceb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cef:	b8 60 4d 11 80       	mov    $0x80114d60,%eax
80105cf4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cf8:	c1 e8 10             	shr    $0x10,%eax
80105cfb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
80105d15:	53                   	push   %ebx
80105d16:	83 ec 1c             	sub    $0x1c,%esp
80105d19:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d1c:	8b 47 30             	mov    0x30(%edi),%eax
80105d1f:	83 f8 40             	cmp    $0x40,%eax
80105d22:	0f 84 f0 00 00 00    	je     80105e18 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d28:	83 e8 20             	sub    $0x20,%eax
80105d2b:	83 f8 1f             	cmp    $0x1f,%eax
80105d2e:	77 10                	ja     80105d40 <trap+0x30>
80105d30:	ff 24 85 48 7d 10 80 	jmp    *-0x7fef82b8(,%eax,4)
80105d37:	89 f6                	mov    %esi,%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d40:	e8 7b dd ff ff       	call   80103ac0 <myproc>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d4a:	0f 84 14 02 00 00    	je     80105f64 <trap+0x254>
80105d50:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d54:	0f 84 0a 02 00 00    	je     80105f64 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d5a:	0f 20 d1             	mov    %cr2,%ecx
80105d5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d60:	e8 3b dd ff ff       	call   80103aa0 <cpuid>
80105d65:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d68:	8b 47 34             	mov    0x34(%edi),%eax
80105d6b:	8b 77 30             	mov    0x30(%edi),%esi
80105d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d71:	e8 4a dd ff ff       	call   80103ac0 <myproc>
80105d76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d79:	e8 42 dd ff ff       	call   80103ac0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d84:	51                   	push   %ecx
80105d85:	53                   	push   %ebx
80105d86:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105d87:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d8a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d8d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d8e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d91:	52                   	push   %edx
80105d92:	ff 70 10             	pushl  0x10(%eax)
80105d95:	68 04 7d 10 80       	push   $0x80107d04
80105d9a:	e8 c1 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d9f:	83 c4 20             	add    $0x20,%esp
80105da2:	e8 19 dd ff ff       	call   80103ac0 <myproc>
80105da7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dae:	e8 0d dd ff ff       	call   80103ac0 <myproc>
80105db3:	85 c0                	test   %eax,%eax
80105db5:	74 1d                	je     80105dd4 <trap+0xc4>
80105db7:	e8 04 dd ff ff       	call   80103ac0 <myproc>
80105dbc:	8b 50 24             	mov    0x24(%eax),%edx
80105dbf:	85 d2                	test   %edx,%edx
80105dc1:	74 11                	je     80105dd4 <trap+0xc4>
80105dc3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105dc7:	83 e0 03             	and    $0x3,%eax
80105dca:	66 83 f8 03          	cmp    $0x3,%ax
80105dce:	0f 84 4c 01 00 00    	je     80105f20 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105dd4:	e8 e7 dc ff ff       	call   80103ac0 <myproc>
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	74 0b                	je     80105de8 <trap+0xd8>
80105ddd:	e8 de dc ff ff       	call   80103ac0 <myproc>
80105de2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105de6:	74 68                	je     80105e50 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105de8:	e8 d3 dc ff ff       	call   80103ac0 <myproc>
80105ded:	85 c0                	test   %eax,%eax
80105def:	74 19                	je     80105e0a <trap+0xfa>
80105df1:	e8 ca dc ff ff       	call   80103ac0 <myproc>
80105df6:	8b 40 24             	mov    0x24(%eax),%eax
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	74 0d                	je     80105e0a <trap+0xfa>
80105dfd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e01:	83 e0 03             	and    $0x3,%eax
80105e04:	66 83 f8 03          	cmp    $0x3,%ax
80105e08:	74 37                	je     80105e41 <trap+0x131>
    exit();
}
80105e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e0d:	5b                   	pop    %ebx
80105e0e:	5e                   	pop    %esi
80105e0f:	5f                   	pop    %edi
80105e10:	5d                   	pop    %ebp
80105e11:	c3                   	ret    
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e18:	e8 a3 dc ff ff       	call   80103ac0 <myproc>
80105e1d:	8b 58 24             	mov    0x24(%eax),%ebx
80105e20:	85 db                	test   %ebx,%ebx
80105e22:	0f 85 e8 00 00 00    	jne    80105f10 <trap+0x200>
    myproc()->tf = tf;
80105e28:	e8 93 dc ff ff       	call   80103ac0 <myproc>
80105e2d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e30:	e8 eb ec ff ff       	call   80104b20 <syscall>
    if(myproc()->killed)
80105e35:	e8 86 dc ff ff       	call   80103ac0 <myproc>
80105e3a:	8b 48 24             	mov    0x24(%eax),%ecx
80105e3d:	85 c9                	test   %ecx,%ecx
80105e3f:	74 c9                	je     80105e0a <trap+0xfa>
}
80105e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e44:	5b                   	pop    %ebx
80105e45:	5e                   	pop    %esi
80105e46:	5f                   	pop    %edi
80105e47:	5d                   	pop    %ebp
      exit();
80105e48:	e9 93 e0 ff ff       	jmp    80103ee0 <exit>
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105e50:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e54:	75 92                	jne    80105de8 <trap+0xd8>
    yield();
80105e56:	e8 b5 e1 ff ff       	call   80104010 <yield>
80105e5b:	eb 8b                	jmp    80105de8 <trap+0xd8>
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105e60:	e8 3b dc ff ff       	call   80103aa0 <cpuid>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	0f 84 c3 00 00 00    	je     80105f30 <trap+0x220>
    lapiceoi();
80105e6d:	e8 be cb ff ff       	call   80102a30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e72:	e8 49 dc ff ff       	call   80103ac0 <myproc>
80105e77:	85 c0                	test   %eax,%eax
80105e79:	0f 85 38 ff ff ff    	jne    80105db7 <trap+0xa7>
80105e7f:	e9 50 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e88:	e8 63 ca ff ff       	call   801028f0 <kbdintr>
    lapiceoi();
80105e8d:	e8 9e cb ff ff       	call   80102a30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e92:	e8 29 dc ff ff       	call   80103ac0 <myproc>
80105e97:	85 c0                	test   %eax,%eax
80105e99:	0f 85 18 ff ff ff    	jne    80105db7 <trap+0xa7>
80105e9f:	e9 30 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ea8:	e8 53 02 00 00       	call   80106100 <uartintr>
    lapiceoi();
80105ead:	e8 7e cb ff ff       	call   80102a30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eb2:	e8 09 dc ff ff       	call   80103ac0 <myproc>
80105eb7:	85 c0                	test   %eax,%eax
80105eb9:	0f 85 f8 fe ff ff    	jne    80105db7 <trap+0xa7>
80105ebf:	e9 10 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ec8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105ecc:	8b 77 38             	mov    0x38(%edi),%esi
80105ecf:	e8 cc db ff ff       	call   80103aa0 <cpuid>
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	50                   	push   %eax
80105ed7:	68 ac 7c 10 80       	push   $0x80107cac
80105edc:	e8 7f a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105ee1:	e8 4a cb ff ff       	call   80102a30 <lapiceoi>
    break;
80105ee6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ee9:	e8 d2 db ff ff       	call   80103ac0 <myproc>
80105eee:	85 c0                	test   %eax,%eax
80105ef0:	0f 85 c1 fe ff ff    	jne    80105db7 <trap+0xa7>
80105ef6:	e9 d9 fe ff ff       	jmp    80105dd4 <trap+0xc4>
80105efb:	90                   	nop
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f00:	e8 5b c4 ff ff       	call   80102360 <ideintr>
80105f05:	e9 63 ff ff ff       	jmp    80105e6d <trap+0x15d>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f10:	e8 cb df ff ff       	call   80103ee0 <exit>
80105f15:	e9 0e ff ff ff       	jmp    80105e28 <trap+0x118>
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f20:	e8 bb df ff ff       	call   80103ee0 <exit>
80105f25:	e9 aa fe ff ff       	jmp    80105dd4 <trap+0xc4>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	68 20 4d 11 80       	push   $0x80114d20
80105f38:	e8 e3 e6 ff ff       	call   80104620 <acquire>
      wakeup(&ticks);
80105f3d:	c7 04 24 60 55 11 80 	movl   $0x80115560,(%esp)
      ticks++;
80105f44:	83 05 60 55 11 80 01 	addl   $0x1,0x80115560
      wakeup(&ticks);
80105f4b:	e8 c0 e2 ff ff       	call   80104210 <wakeup>
      release(&tickslock);
80105f50:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80105f57:	e8 84 e7 ff ff       	call   801046e0 <release>
80105f5c:	83 c4 10             	add    $0x10,%esp
80105f5f:	e9 09 ff ff ff       	jmp    80105e6d <trap+0x15d>
80105f64:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f67:	e8 34 db ff ff       	call   80103aa0 <cpuid>
80105f6c:	83 ec 0c             	sub    $0xc,%esp
80105f6f:	56                   	push   %esi
80105f70:	53                   	push   %ebx
80105f71:	50                   	push   %eax
80105f72:	ff 77 30             	pushl  0x30(%edi)
80105f75:	68 d0 7c 10 80       	push   $0x80107cd0
80105f7a:	e8 e1 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105f7f:	83 c4 14             	add    $0x14,%esp
80105f82:	68 a6 7c 10 80       	push   $0x80107ca6
80105f87:	e8 04 a4 ff ff       	call   80100390 <panic>
80105f8c:	66 90                	xchg   %ax,%ax
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f90:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105f95:	55                   	push   %ebp
80105f96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f98:	85 c0                	test   %eax,%eax
80105f9a:	74 1c                	je     80105fb8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fa1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fa2:	a8 01                	test   $0x1,%al
80105fa4:	74 12                	je     80105fb8 <uartgetc+0x28>
80105fa6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fac:	0f b6 c0             	movzbl %al,%eax
}
80105faf:	5d                   	pop    %ebp
80105fb0:	c3                   	ret    
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fbd:	5d                   	pop    %ebp
80105fbe:	c3                   	ret    
80105fbf:	90                   	nop

80105fc0 <uartputc.part.0>:
uartputc(int c)
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
80105fc6:	89 c7                	mov    %eax,%edi
80105fc8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fcd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fd2:	83 ec 0c             	sub    $0xc,%esp
80105fd5:	eb 1b                	jmp    80105ff2 <uartputc.part.0+0x32>
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	6a 0a                	push   $0xa
80105fe5:	e8 66 ca ff ff       	call   80102a50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	83 eb 01             	sub    $0x1,%ebx
80105ff0:	74 07                	je     80105ff9 <uartputc.part.0+0x39>
80105ff2:	89 f2                	mov    %esi,%edx
80105ff4:	ec                   	in     (%dx),%al
80105ff5:	a8 20                	test   $0x20,%al
80105ff7:	74 e7                	je     80105fe0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ff9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffe:	89 f8                	mov    %edi,%eax
80106000:	ee                   	out    %al,(%dx)
}
80106001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106004:	5b                   	pop    %ebx
80106005:	5e                   	pop    %esi
80106006:	5f                   	pop    %edi
80106007:	5d                   	pop    %ebp
80106008:	c3                   	ret    
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106010 <uartinit>:
{
80106010:	55                   	push   %ebp
80106011:	31 c9                	xor    %ecx,%ecx
80106013:	89 c8                	mov    %ecx,%eax
80106015:	89 e5                	mov    %esp,%ebp
80106017:	57                   	push   %edi
80106018:	56                   	push   %esi
80106019:	53                   	push   %ebx
8010601a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010601f:	89 da                	mov    %ebx,%edx
80106021:	83 ec 0c             	sub    $0xc,%esp
80106024:	ee                   	out    %al,(%dx)
80106025:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010602a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010602f:	89 fa                	mov    %edi,%edx
80106031:	ee                   	out    %al,(%dx)
80106032:	b8 0c 00 00 00       	mov    $0xc,%eax
80106037:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010603c:	ee                   	out    %al,(%dx)
8010603d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106042:	89 c8                	mov    %ecx,%eax
80106044:	89 f2                	mov    %esi,%edx
80106046:	ee                   	out    %al,(%dx)
80106047:	b8 03 00 00 00       	mov    $0x3,%eax
8010604c:	89 fa                	mov    %edi,%edx
8010604e:	ee                   	out    %al,(%dx)
8010604f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106054:	89 c8                	mov    %ecx,%eax
80106056:	ee                   	out    %al,(%dx)
80106057:	b8 01 00 00 00       	mov    $0x1,%eax
8010605c:	89 f2                	mov    %esi,%edx
8010605e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010605f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106064:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106065:	3c ff                	cmp    $0xff,%al
80106067:	74 5a                	je     801060c3 <uartinit+0xb3>
  uart = 1;
80106069:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80106070:	00 00 00 
80106073:	89 da                	mov    %ebx,%edx
80106075:	ec                   	in     (%dx),%al
80106076:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010607b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010607c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010607f:	bb c8 7d 10 80       	mov    $0x80107dc8,%ebx
  ioapicenable(IRQ_COM1, 0);
80106084:	6a 00                	push   $0x0
80106086:	6a 04                	push   $0x4
80106088:	e8 23 c5 ff ff       	call   801025b0 <ioapicenable>
8010608d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106090:	b8 78 00 00 00       	mov    $0x78,%eax
80106095:	eb 13                	jmp    801060aa <uartinit+0x9a>
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060a0:	83 c3 01             	add    $0x1,%ebx
801060a3:	0f be 03             	movsbl (%ebx),%eax
801060a6:	84 c0                	test   %al,%al
801060a8:	74 19                	je     801060c3 <uartinit+0xb3>
  if(!uart)
801060aa:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
801060b0:	85 d2                	test   %edx,%edx
801060b2:	74 ec                	je     801060a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801060b4:	83 c3 01             	add    $0x1,%ebx
801060b7:	e8 04 ff ff ff       	call   80105fc0 <uartputc.part.0>
801060bc:	0f be 03             	movsbl (%ebx),%eax
801060bf:	84 c0                	test   %al,%al
801060c1:	75 e7                	jne    801060aa <uartinit+0x9a>
}
801060c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c6:	5b                   	pop    %ebx
801060c7:	5e                   	pop    %esi
801060c8:	5f                   	pop    %edi
801060c9:	5d                   	pop    %ebp
801060ca:	c3                   	ret    
801060cb:	90                   	nop
801060cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060d0 <uartputc>:
  if(!uart)
801060d0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
801060d6:	55                   	push   %ebp
801060d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060d9:	85 d2                	test   %edx,%edx
{
801060db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801060de:	74 10                	je     801060f0 <uartputc+0x20>
}
801060e0:	5d                   	pop    %ebp
801060e1:	e9 da fe ff ff       	jmp    80105fc0 <uartputc.part.0>
801060e6:	8d 76 00             	lea    0x0(%esi),%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060f0:	5d                   	pop    %ebp
801060f1:	c3                   	ret    
801060f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106100 <uartintr>:

void
uartintr(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106106:	68 90 5f 10 80       	push   $0x80105f90
8010610b:	e8 00 a7 ff ff       	call   80100810 <consoleintr>
}
80106110:	83 c4 10             	add    $0x10,%esp
80106113:	c9                   	leave  
80106114:	c3                   	ret    

80106115 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $0
80106117:	6a 00                	push   $0x0
  jmp alltraps
80106119:	e9 19 fb ff ff       	jmp    80105c37 <alltraps>

8010611e <vector1>:
.globl vector1
vector1:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $1
80106120:	6a 01                	push   $0x1
  jmp alltraps
80106122:	e9 10 fb ff ff       	jmp    80105c37 <alltraps>

80106127 <vector2>:
.globl vector2
vector2:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $2
80106129:	6a 02                	push   $0x2
  jmp alltraps
8010612b:	e9 07 fb ff ff       	jmp    80105c37 <alltraps>

80106130 <vector3>:
.globl vector3
vector3:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $3
80106132:	6a 03                	push   $0x3
  jmp alltraps
80106134:	e9 fe fa ff ff       	jmp    80105c37 <alltraps>

80106139 <vector4>:
.globl vector4
vector4:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $4
8010613b:	6a 04                	push   $0x4
  jmp alltraps
8010613d:	e9 f5 fa ff ff       	jmp    80105c37 <alltraps>

80106142 <vector5>:
.globl vector5
vector5:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $5
80106144:	6a 05                	push   $0x5
  jmp alltraps
80106146:	e9 ec fa ff ff       	jmp    80105c37 <alltraps>

8010614b <vector6>:
.globl vector6
vector6:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $6
8010614d:	6a 06                	push   $0x6
  jmp alltraps
8010614f:	e9 e3 fa ff ff       	jmp    80105c37 <alltraps>

80106154 <vector7>:
.globl vector7
vector7:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $7
80106156:	6a 07                	push   $0x7
  jmp alltraps
80106158:	e9 da fa ff ff       	jmp    80105c37 <alltraps>

8010615d <vector8>:
.globl vector8
vector8:
  pushl $8
8010615d:	6a 08                	push   $0x8
  jmp alltraps
8010615f:	e9 d3 fa ff ff       	jmp    80105c37 <alltraps>

80106164 <vector9>:
.globl vector9
vector9:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $9
80106166:	6a 09                	push   $0x9
  jmp alltraps
80106168:	e9 ca fa ff ff       	jmp    80105c37 <alltraps>

8010616d <vector10>:
.globl vector10
vector10:
  pushl $10
8010616d:	6a 0a                	push   $0xa
  jmp alltraps
8010616f:	e9 c3 fa ff ff       	jmp    80105c37 <alltraps>

80106174 <vector11>:
.globl vector11
vector11:
  pushl $11
80106174:	6a 0b                	push   $0xb
  jmp alltraps
80106176:	e9 bc fa ff ff       	jmp    80105c37 <alltraps>

8010617b <vector12>:
.globl vector12
vector12:
  pushl $12
8010617b:	6a 0c                	push   $0xc
  jmp alltraps
8010617d:	e9 b5 fa ff ff       	jmp    80105c37 <alltraps>

80106182 <vector13>:
.globl vector13
vector13:
  pushl $13
80106182:	6a 0d                	push   $0xd
  jmp alltraps
80106184:	e9 ae fa ff ff       	jmp    80105c37 <alltraps>

80106189 <vector14>:
.globl vector14
vector14:
  pushl $14
80106189:	6a 0e                	push   $0xe
  jmp alltraps
8010618b:	e9 a7 fa ff ff       	jmp    80105c37 <alltraps>

80106190 <vector15>:
.globl vector15
vector15:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $15
80106192:	6a 0f                	push   $0xf
  jmp alltraps
80106194:	e9 9e fa ff ff       	jmp    80105c37 <alltraps>

80106199 <vector16>:
.globl vector16
vector16:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $16
8010619b:	6a 10                	push   $0x10
  jmp alltraps
8010619d:	e9 95 fa ff ff       	jmp    80105c37 <alltraps>

801061a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061a2:	6a 11                	push   $0x11
  jmp alltraps
801061a4:	e9 8e fa ff ff       	jmp    80105c37 <alltraps>

801061a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $18
801061ab:	6a 12                	push   $0x12
  jmp alltraps
801061ad:	e9 85 fa ff ff       	jmp    80105c37 <alltraps>

801061b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $19
801061b4:	6a 13                	push   $0x13
  jmp alltraps
801061b6:	e9 7c fa ff ff       	jmp    80105c37 <alltraps>

801061bb <vector20>:
.globl vector20
vector20:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $20
801061bd:	6a 14                	push   $0x14
  jmp alltraps
801061bf:	e9 73 fa ff ff       	jmp    80105c37 <alltraps>

801061c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $21
801061c6:	6a 15                	push   $0x15
  jmp alltraps
801061c8:	e9 6a fa ff ff       	jmp    80105c37 <alltraps>

801061cd <vector22>:
.globl vector22
vector22:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $22
801061cf:	6a 16                	push   $0x16
  jmp alltraps
801061d1:	e9 61 fa ff ff       	jmp    80105c37 <alltraps>

801061d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $23
801061d8:	6a 17                	push   $0x17
  jmp alltraps
801061da:	e9 58 fa ff ff       	jmp    80105c37 <alltraps>

801061df <vector24>:
.globl vector24
vector24:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $24
801061e1:	6a 18                	push   $0x18
  jmp alltraps
801061e3:	e9 4f fa ff ff       	jmp    80105c37 <alltraps>

801061e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $25
801061ea:	6a 19                	push   $0x19
  jmp alltraps
801061ec:	e9 46 fa ff ff       	jmp    80105c37 <alltraps>

801061f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $26
801061f3:	6a 1a                	push   $0x1a
  jmp alltraps
801061f5:	e9 3d fa ff ff       	jmp    80105c37 <alltraps>

801061fa <vector27>:
.globl vector27
vector27:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $27
801061fc:	6a 1b                	push   $0x1b
  jmp alltraps
801061fe:	e9 34 fa ff ff       	jmp    80105c37 <alltraps>

80106203 <vector28>:
.globl vector28
vector28:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $28
80106205:	6a 1c                	push   $0x1c
  jmp alltraps
80106207:	e9 2b fa ff ff       	jmp    80105c37 <alltraps>

8010620c <vector29>:
.globl vector29
vector29:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $29
8010620e:	6a 1d                	push   $0x1d
  jmp alltraps
80106210:	e9 22 fa ff ff       	jmp    80105c37 <alltraps>

80106215 <vector30>:
.globl vector30
vector30:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $30
80106217:	6a 1e                	push   $0x1e
  jmp alltraps
80106219:	e9 19 fa ff ff       	jmp    80105c37 <alltraps>

8010621e <vector31>:
.globl vector31
vector31:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $31
80106220:	6a 1f                	push   $0x1f
  jmp alltraps
80106222:	e9 10 fa ff ff       	jmp    80105c37 <alltraps>

80106227 <vector32>:
.globl vector32
vector32:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $32
80106229:	6a 20                	push   $0x20
  jmp alltraps
8010622b:	e9 07 fa ff ff       	jmp    80105c37 <alltraps>

80106230 <vector33>:
.globl vector33
vector33:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $33
80106232:	6a 21                	push   $0x21
  jmp alltraps
80106234:	e9 fe f9 ff ff       	jmp    80105c37 <alltraps>

80106239 <vector34>:
.globl vector34
vector34:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $34
8010623b:	6a 22                	push   $0x22
  jmp alltraps
8010623d:	e9 f5 f9 ff ff       	jmp    80105c37 <alltraps>

80106242 <vector35>:
.globl vector35
vector35:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $35
80106244:	6a 23                	push   $0x23
  jmp alltraps
80106246:	e9 ec f9 ff ff       	jmp    80105c37 <alltraps>

8010624b <vector36>:
.globl vector36
vector36:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $36
8010624d:	6a 24                	push   $0x24
  jmp alltraps
8010624f:	e9 e3 f9 ff ff       	jmp    80105c37 <alltraps>

80106254 <vector37>:
.globl vector37
vector37:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $37
80106256:	6a 25                	push   $0x25
  jmp alltraps
80106258:	e9 da f9 ff ff       	jmp    80105c37 <alltraps>

8010625d <vector38>:
.globl vector38
vector38:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $38
8010625f:	6a 26                	push   $0x26
  jmp alltraps
80106261:	e9 d1 f9 ff ff       	jmp    80105c37 <alltraps>

80106266 <vector39>:
.globl vector39
vector39:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $39
80106268:	6a 27                	push   $0x27
  jmp alltraps
8010626a:	e9 c8 f9 ff ff       	jmp    80105c37 <alltraps>

8010626f <vector40>:
.globl vector40
vector40:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $40
80106271:	6a 28                	push   $0x28
  jmp alltraps
80106273:	e9 bf f9 ff ff       	jmp    80105c37 <alltraps>

80106278 <vector41>:
.globl vector41
vector41:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $41
8010627a:	6a 29                	push   $0x29
  jmp alltraps
8010627c:	e9 b6 f9 ff ff       	jmp    80105c37 <alltraps>

80106281 <vector42>:
.globl vector42
vector42:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $42
80106283:	6a 2a                	push   $0x2a
  jmp alltraps
80106285:	e9 ad f9 ff ff       	jmp    80105c37 <alltraps>

8010628a <vector43>:
.globl vector43
vector43:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $43
8010628c:	6a 2b                	push   $0x2b
  jmp alltraps
8010628e:	e9 a4 f9 ff ff       	jmp    80105c37 <alltraps>

80106293 <vector44>:
.globl vector44
vector44:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $44
80106295:	6a 2c                	push   $0x2c
  jmp alltraps
80106297:	e9 9b f9 ff ff       	jmp    80105c37 <alltraps>

8010629c <vector45>:
.globl vector45
vector45:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $45
8010629e:	6a 2d                	push   $0x2d
  jmp alltraps
801062a0:	e9 92 f9 ff ff       	jmp    80105c37 <alltraps>

801062a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $46
801062a7:	6a 2e                	push   $0x2e
  jmp alltraps
801062a9:	e9 89 f9 ff ff       	jmp    80105c37 <alltraps>

801062ae <vector47>:
.globl vector47
vector47:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $47
801062b0:	6a 2f                	push   $0x2f
  jmp alltraps
801062b2:	e9 80 f9 ff ff       	jmp    80105c37 <alltraps>

801062b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $48
801062b9:	6a 30                	push   $0x30
  jmp alltraps
801062bb:	e9 77 f9 ff ff       	jmp    80105c37 <alltraps>

801062c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $49
801062c2:	6a 31                	push   $0x31
  jmp alltraps
801062c4:	e9 6e f9 ff ff       	jmp    80105c37 <alltraps>

801062c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $50
801062cb:	6a 32                	push   $0x32
  jmp alltraps
801062cd:	e9 65 f9 ff ff       	jmp    80105c37 <alltraps>

801062d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $51
801062d4:	6a 33                	push   $0x33
  jmp alltraps
801062d6:	e9 5c f9 ff ff       	jmp    80105c37 <alltraps>

801062db <vector52>:
.globl vector52
vector52:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $52
801062dd:	6a 34                	push   $0x34
  jmp alltraps
801062df:	e9 53 f9 ff ff       	jmp    80105c37 <alltraps>

801062e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $53
801062e6:	6a 35                	push   $0x35
  jmp alltraps
801062e8:	e9 4a f9 ff ff       	jmp    80105c37 <alltraps>

801062ed <vector54>:
.globl vector54
vector54:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $54
801062ef:	6a 36                	push   $0x36
  jmp alltraps
801062f1:	e9 41 f9 ff ff       	jmp    80105c37 <alltraps>

801062f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $55
801062f8:	6a 37                	push   $0x37
  jmp alltraps
801062fa:	e9 38 f9 ff ff       	jmp    80105c37 <alltraps>

801062ff <vector56>:
.globl vector56
vector56:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $56
80106301:	6a 38                	push   $0x38
  jmp alltraps
80106303:	e9 2f f9 ff ff       	jmp    80105c37 <alltraps>

80106308 <vector57>:
.globl vector57
vector57:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $57
8010630a:	6a 39                	push   $0x39
  jmp alltraps
8010630c:	e9 26 f9 ff ff       	jmp    80105c37 <alltraps>

80106311 <vector58>:
.globl vector58
vector58:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $58
80106313:	6a 3a                	push   $0x3a
  jmp alltraps
80106315:	e9 1d f9 ff ff       	jmp    80105c37 <alltraps>

8010631a <vector59>:
.globl vector59
vector59:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $59
8010631c:	6a 3b                	push   $0x3b
  jmp alltraps
8010631e:	e9 14 f9 ff ff       	jmp    80105c37 <alltraps>

80106323 <vector60>:
.globl vector60
vector60:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $60
80106325:	6a 3c                	push   $0x3c
  jmp alltraps
80106327:	e9 0b f9 ff ff       	jmp    80105c37 <alltraps>

8010632c <vector61>:
.globl vector61
vector61:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $61
8010632e:	6a 3d                	push   $0x3d
  jmp alltraps
80106330:	e9 02 f9 ff ff       	jmp    80105c37 <alltraps>

80106335 <vector62>:
.globl vector62
vector62:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $62
80106337:	6a 3e                	push   $0x3e
  jmp alltraps
80106339:	e9 f9 f8 ff ff       	jmp    80105c37 <alltraps>

8010633e <vector63>:
.globl vector63
vector63:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $63
80106340:	6a 3f                	push   $0x3f
  jmp alltraps
80106342:	e9 f0 f8 ff ff       	jmp    80105c37 <alltraps>

80106347 <vector64>:
.globl vector64
vector64:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $64
80106349:	6a 40                	push   $0x40
  jmp alltraps
8010634b:	e9 e7 f8 ff ff       	jmp    80105c37 <alltraps>

80106350 <vector65>:
.globl vector65
vector65:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $65
80106352:	6a 41                	push   $0x41
  jmp alltraps
80106354:	e9 de f8 ff ff       	jmp    80105c37 <alltraps>

80106359 <vector66>:
.globl vector66
vector66:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $66
8010635b:	6a 42                	push   $0x42
  jmp alltraps
8010635d:	e9 d5 f8 ff ff       	jmp    80105c37 <alltraps>

80106362 <vector67>:
.globl vector67
vector67:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $67
80106364:	6a 43                	push   $0x43
  jmp alltraps
80106366:	e9 cc f8 ff ff       	jmp    80105c37 <alltraps>

8010636b <vector68>:
.globl vector68
vector68:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $68
8010636d:	6a 44                	push   $0x44
  jmp alltraps
8010636f:	e9 c3 f8 ff ff       	jmp    80105c37 <alltraps>

80106374 <vector69>:
.globl vector69
vector69:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $69
80106376:	6a 45                	push   $0x45
  jmp alltraps
80106378:	e9 ba f8 ff ff       	jmp    80105c37 <alltraps>

8010637d <vector70>:
.globl vector70
vector70:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $70
8010637f:	6a 46                	push   $0x46
  jmp alltraps
80106381:	e9 b1 f8 ff ff       	jmp    80105c37 <alltraps>

80106386 <vector71>:
.globl vector71
vector71:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $71
80106388:	6a 47                	push   $0x47
  jmp alltraps
8010638a:	e9 a8 f8 ff ff       	jmp    80105c37 <alltraps>

8010638f <vector72>:
.globl vector72
vector72:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $72
80106391:	6a 48                	push   $0x48
  jmp alltraps
80106393:	e9 9f f8 ff ff       	jmp    80105c37 <alltraps>

80106398 <vector73>:
.globl vector73
vector73:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $73
8010639a:	6a 49                	push   $0x49
  jmp alltraps
8010639c:	e9 96 f8 ff ff       	jmp    80105c37 <alltraps>

801063a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $74
801063a3:	6a 4a                	push   $0x4a
  jmp alltraps
801063a5:	e9 8d f8 ff ff       	jmp    80105c37 <alltraps>

801063aa <vector75>:
.globl vector75
vector75:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $75
801063ac:	6a 4b                	push   $0x4b
  jmp alltraps
801063ae:	e9 84 f8 ff ff       	jmp    80105c37 <alltraps>

801063b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $76
801063b5:	6a 4c                	push   $0x4c
  jmp alltraps
801063b7:	e9 7b f8 ff ff       	jmp    80105c37 <alltraps>

801063bc <vector77>:
.globl vector77
vector77:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $77
801063be:	6a 4d                	push   $0x4d
  jmp alltraps
801063c0:	e9 72 f8 ff ff       	jmp    80105c37 <alltraps>

801063c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $78
801063c7:	6a 4e                	push   $0x4e
  jmp alltraps
801063c9:	e9 69 f8 ff ff       	jmp    80105c37 <alltraps>

801063ce <vector79>:
.globl vector79
vector79:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $79
801063d0:	6a 4f                	push   $0x4f
  jmp alltraps
801063d2:	e9 60 f8 ff ff       	jmp    80105c37 <alltraps>

801063d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $80
801063d9:	6a 50                	push   $0x50
  jmp alltraps
801063db:	e9 57 f8 ff ff       	jmp    80105c37 <alltraps>

801063e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $81
801063e2:	6a 51                	push   $0x51
  jmp alltraps
801063e4:	e9 4e f8 ff ff       	jmp    80105c37 <alltraps>

801063e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $82
801063eb:	6a 52                	push   $0x52
  jmp alltraps
801063ed:	e9 45 f8 ff ff       	jmp    80105c37 <alltraps>

801063f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $83
801063f4:	6a 53                	push   $0x53
  jmp alltraps
801063f6:	e9 3c f8 ff ff       	jmp    80105c37 <alltraps>

801063fb <vector84>:
.globl vector84
vector84:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $84
801063fd:	6a 54                	push   $0x54
  jmp alltraps
801063ff:	e9 33 f8 ff ff       	jmp    80105c37 <alltraps>

80106404 <vector85>:
.globl vector85
vector85:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $85
80106406:	6a 55                	push   $0x55
  jmp alltraps
80106408:	e9 2a f8 ff ff       	jmp    80105c37 <alltraps>

8010640d <vector86>:
.globl vector86
vector86:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $86
8010640f:	6a 56                	push   $0x56
  jmp alltraps
80106411:	e9 21 f8 ff ff       	jmp    80105c37 <alltraps>

80106416 <vector87>:
.globl vector87
vector87:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $87
80106418:	6a 57                	push   $0x57
  jmp alltraps
8010641a:	e9 18 f8 ff ff       	jmp    80105c37 <alltraps>

8010641f <vector88>:
.globl vector88
vector88:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $88
80106421:	6a 58                	push   $0x58
  jmp alltraps
80106423:	e9 0f f8 ff ff       	jmp    80105c37 <alltraps>

80106428 <vector89>:
.globl vector89
vector89:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $89
8010642a:	6a 59                	push   $0x59
  jmp alltraps
8010642c:	e9 06 f8 ff ff       	jmp    80105c37 <alltraps>

80106431 <vector90>:
.globl vector90
vector90:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $90
80106433:	6a 5a                	push   $0x5a
  jmp alltraps
80106435:	e9 fd f7 ff ff       	jmp    80105c37 <alltraps>

8010643a <vector91>:
.globl vector91
vector91:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $91
8010643c:	6a 5b                	push   $0x5b
  jmp alltraps
8010643e:	e9 f4 f7 ff ff       	jmp    80105c37 <alltraps>

80106443 <vector92>:
.globl vector92
vector92:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $92
80106445:	6a 5c                	push   $0x5c
  jmp alltraps
80106447:	e9 eb f7 ff ff       	jmp    80105c37 <alltraps>

8010644c <vector93>:
.globl vector93
vector93:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $93
8010644e:	6a 5d                	push   $0x5d
  jmp alltraps
80106450:	e9 e2 f7 ff ff       	jmp    80105c37 <alltraps>

80106455 <vector94>:
.globl vector94
vector94:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $94
80106457:	6a 5e                	push   $0x5e
  jmp alltraps
80106459:	e9 d9 f7 ff ff       	jmp    80105c37 <alltraps>

8010645e <vector95>:
.globl vector95
vector95:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $95
80106460:	6a 5f                	push   $0x5f
  jmp alltraps
80106462:	e9 d0 f7 ff ff       	jmp    80105c37 <alltraps>

80106467 <vector96>:
.globl vector96
vector96:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $96
80106469:	6a 60                	push   $0x60
  jmp alltraps
8010646b:	e9 c7 f7 ff ff       	jmp    80105c37 <alltraps>

80106470 <vector97>:
.globl vector97
vector97:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $97
80106472:	6a 61                	push   $0x61
  jmp alltraps
80106474:	e9 be f7 ff ff       	jmp    80105c37 <alltraps>

80106479 <vector98>:
.globl vector98
vector98:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $98
8010647b:	6a 62                	push   $0x62
  jmp alltraps
8010647d:	e9 b5 f7 ff ff       	jmp    80105c37 <alltraps>

80106482 <vector99>:
.globl vector99
vector99:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $99
80106484:	6a 63                	push   $0x63
  jmp alltraps
80106486:	e9 ac f7 ff ff       	jmp    80105c37 <alltraps>

8010648b <vector100>:
.globl vector100
vector100:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $100
8010648d:	6a 64                	push   $0x64
  jmp alltraps
8010648f:	e9 a3 f7 ff ff       	jmp    80105c37 <alltraps>

80106494 <vector101>:
.globl vector101
vector101:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $101
80106496:	6a 65                	push   $0x65
  jmp alltraps
80106498:	e9 9a f7 ff ff       	jmp    80105c37 <alltraps>

8010649d <vector102>:
.globl vector102
vector102:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $102
8010649f:	6a 66                	push   $0x66
  jmp alltraps
801064a1:	e9 91 f7 ff ff       	jmp    80105c37 <alltraps>

801064a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $103
801064a8:	6a 67                	push   $0x67
  jmp alltraps
801064aa:	e9 88 f7 ff ff       	jmp    80105c37 <alltraps>

801064af <vector104>:
.globl vector104
vector104:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $104
801064b1:	6a 68                	push   $0x68
  jmp alltraps
801064b3:	e9 7f f7 ff ff       	jmp    80105c37 <alltraps>

801064b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $105
801064ba:	6a 69                	push   $0x69
  jmp alltraps
801064bc:	e9 76 f7 ff ff       	jmp    80105c37 <alltraps>

801064c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $106
801064c3:	6a 6a                	push   $0x6a
  jmp alltraps
801064c5:	e9 6d f7 ff ff       	jmp    80105c37 <alltraps>

801064ca <vector107>:
.globl vector107
vector107:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $107
801064cc:	6a 6b                	push   $0x6b
  jmp alltraps
801064ce:	e9 64 f7 ff ff       	jmp    80105c37 <alltraps>

801064d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $108
801064d5:	6a 6c                	push   $0x6c
  jmp alltraps
801064d7:	e9 5b f7 ff ff       	jmp    80105c37 <alltraps>

801064dc <vector109>:
.globl vector109
vector109:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $109
801064de:	6a 6d                	push   $0x6d
  jmp alltraps
801064e0:	e9 52 f7 ff ff       	jmp    80105c37 <alltraps>

801064e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $110
801064e7:	6a 6e                	push   $0x6e
  jmp alltraps
801064e9:	e9 49 f7 ff ff       	jmp    80105c37 <alltraps>

801064ee <vector111>:
.globl vector111
vector111:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $111
801064f0:	6a 6f                	push   $0x6f
  jmp alltraps
801064f2:	e9 40 f7 ff ff       	jmp    80105c37 <alltraps>

801064f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $112
801064f9:	6a 70                	push   $0x70
  jmp alltraps
801064fb:	e9 37 f7 ff ff       	jmp    80105c37 <alltraps>

80106500 <vector113>:
.globl vector113
vector113:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $113
80106502:	6a 71                	push   $0x71
  jmp alltraps
80106504:	e9 2e f7 ff ff       	jmp    80105c37 <alltraps>

80106509 <vector114>:
.globl vector114
vector114:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $114
8010650b:	6a 72                	push   $0x72
  jmp alltraps
8010650d:	e9 25 f7 ff ff       	jmp    80105c37 <alltraps>

80106512 <vector115>:
.globl vector115
vector115:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $115
80106514:	6a 73                	push   $0x73
  jmp alltraps
80106516:	e9 1c f7 ff ff       	jmp    80105c37 <alltraps>

8010651b <vector116>:
.globl vector116
vector116:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $116
8010651d:	6a 74                	push   $0x74
  jmp alltraps
8010651f:	e9 13 f7 ff ff       	jmp    80105c37 <alltraps>

80106524 <vector117>:
.globl vector117
vector117:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $117
80106526:	6a 75                	push   $0x75
  jmp alltraps
80106528:	e9 0a f7 ff ff       	jmp    80105c37 <alltraps>

8010652d <vector118>:
.globl vector118
vector118:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $118
8010652f:	6a 76                	push   $0x76
  jmp alltraps
80106531:	e9 01 f7 ff ff       	jmp    80105c37 <alltraps>

80106536 <vector119>:
.globl vector119
vector119:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $119
80106538:	6a 77                	push   $0x77
  jmp alltraps
8010653a:	e9 f8 f6 ff ff       	jmp    80105c37 <alltraps>

8010653f <vector120>:
.globl vector120
vector120:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $120
80106541:	6a 78                	push   $0x78
  jmp alltraps
80106543:	e9 ef f6 ff ff       	jmp    80105c37 <alltraps>

80106548 <vector121>:
.globl vector121
vector121:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $121
8010654a:	6a 79                	push   $0x79
  jmp alltraps
8010654c:	e9 e6 f6 ff ff       	jmp    80105c37 <alltraps>

80106551 <vector122>:
.globl vector122
vector122:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $122
80106553:	6a 7a                	push   $0x7a
  jmp alltraps
80106555:	e9 dd f6 ff ff       	jmp    80105c37 <alltraps>

8010655a <vector123>:
.globl vector123
vector123:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $123
8010655c:	6a 7b                	push   $0x7b
  jmp alltraps
8010655e:	e9 d4 f6 ff ff       	jmp    80105c37 <alltraps>

80106563 <vector124>:
.globl vector124
vector124:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $124
80106565:	6a 7c                	push   $0x7c
  jmp alltraps
80106567:	e9 cb f6 ff ff       	jmp    80105c37 <alltraps>

8010656c <vector125>:
.globl vector125
vector125:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $125
8010656e:	6a 7d                	push   $0x7d
  jmp alltraps
80106570:	e9 c2 f6 ff ff       	jmp    80105c37 <alltraps>

80106575 <vector126>:
.globl vector126
vector126:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $126
80106577:	6a 7e                	push   $0x7e
  jmp alltraps
80106579:	e9 b9 f6 ff ff       	jmp    80105c37 <alltraps>

8010657e <vector127>:
.globl vector127
vector127:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $127
80106580:	6a 7f                	push   $0x7f
  jmp alltraps
80106582:	e9 b0 f6 ff ff       	jmp    80105c37 <alltraps>

80106587 <vector128>:
.globl vector128
vector128:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $128
80106589:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010658e:	e9 a4 f6 ff ff       	jmp    80105c37 <alltraps>

80106593 <vector129>:
.globl vector129
vector129:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $129
80106595:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010659a:	e9 98 f6 ff ff       	jmp    80105c37 <alltraps>

8010659f <vector130>:
.globl vector130
vector130:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $130
801065a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065a6:	e9 8c f6 ff ff       	jmp    80105c37 <alltraps>

801065ab <vector131>:
.globl vector131
vector131:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $131
801065ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065b2:	e9 80 f6 ff ff       	jmp    80105c37 <alltraps>

801065b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $132
801065b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065be:	e9 74 f6 ff ff       	jmp    80105c37 <alltraps>

801065c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $133
801065c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065ca:	e9 68 f6 ff ff       	jmp    80105c37 <alltraps>

801065cf <vector134>:
.globl vector134
vector134:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $134
801065d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065d6:	e9 5c f6 ff ff       	jmp    80105c37 <alltraps>

801065db <vector135>:
.globl vector135
vector135:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $135
801065dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065e2:	e9 50 f6 ff ff       	jmp    80105c37 <alltraps>

801065e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $136
801065e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ee:	e9 44 f6 ff ff       	jmp    80105c37 <alltraps>

801065f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $137
801065f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065fa:	e9 38 f6 ff ff       	jmp    80105c37 <alltraps>

801065ff <vector138>:
.globl vector138
vector138:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $138
80106601:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106606:	e9 2c f6 ff ff       	jmp    80105c37 <alltraps>

8010660b <vector139>:
.globl vector139
vector139:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $139
8010660d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106612:	e9 20 f6 ff ff       	jmp    80105c37 <alltraps>

80106617 <vector140>:
.globl vector140
vector140:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $140
80106619:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010661e:	e9 14 f6 ff ff       	jmp    80105c37 <alltraps>

80106623 <vector141>:
.globl vector141
vector141:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $141
80106625:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010662a:	e9 08 f6 ff ff       	jmp    80105c37 <alltraps>

8010662f <vector142>:
.globl vector142
vector142:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $142
80106631:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106636:	e9 fc f5 ff ff       	jmp    80105c37 <alltraps>

8010663b <vector143>:
.globl vector143
vector143:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $143
8010663d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106642:	e9 f0 f5 ff ff       	jmp    80105c37 <alltraps>

80106647 <vector144>:
.globl vector144
vector144:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $144
80106649:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010664e:	e9 e4 f5 ff ff       	jmp    80105c37 <alltraps>

80106653 <vector145>:
.globl vector145
vector145:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $145
80106655:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010665a:	e9 d8 f5 ff ff       	jmp    80105c37 <alltraps>

8010665f <vector146>:
.globl vector146
vector146:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $146
80106661:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106666:	e9 cc f5 ff ff       	jmp    80105c37 <alltraps>

8010666b <vector147>:
.globl vector147
vector147:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $147
8010666d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106672:	e9 c0 f5 ff ff       	jmp    80105c37 <alltraps>

80106677 <vector148>:
.globl vector148
vector148:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $148
80106679:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010667e:	e9 b4 f5 ff ff       	jmp    80105c37 <alltraps>

80106683 <vector149>:
.globl vector149
vector149:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $149
80106685:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010668a:	e9 a8 f5 ff ff       	jmp    80105c37 <alltraps>

8010668f <vector150>:
.globl vector150
vector150:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $150
80106691:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106696:	e9 9c f5 ff ff       	jmp    80105c37 <alltraps>

8010669b <vector151>:
.globl vector151
vector151:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $151
8010669d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066a2:	e9 90 f5 ff ff       	jmp    80105c37 <alltraps>

801066a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $152
801066a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066ae:	e9 84 f5 ff ff       	jmp    80105c37 <alltraps>

801066b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $153
801066b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ba:	e9 78 f5 ff ff       	jmp    80105c37 <alltraps>

801066bf <vector154>:
.globl vector154
vector154:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $154
801066c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066c6:	e9 6c f5 ff ff       	jmp    80105c37 <alltraps>

801066cb <vector155>:
.globl vector155
vector155:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $155
801066cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066d2:	e9 60 f5 ff ff       	jmp    80105c37 <alltraps>

801066d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $156
801066d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066de:	e9 54 f5 ff ff       	jmp    80105c37 <alltraps>

801066e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $157
801066e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066ea:	e9 48 f5 ff ff       	jmp    80105c37 <alltraps>

801066ef <vector158>:
.globl vector158
vector158:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $158
801066f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066f6:	e9 3c f5 ff ff       	jmp    80105c37 <alltraps>

801066fb <vector159>:
.globl vector159
vector159:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $159
801066fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106702:	e9 30 f5 ff ff       	jmp    80105c37 <alltraps>

80106707 <vector160>:
.globl vector160
vector160:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $160
80106709:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010670e:	e9 24 f5 ff ff       	jmp    80105c37 <alltraps>

80106713 <vector161>:
.globl vector161
vector161:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $161
80106715:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010671a:	e9 18 f5 ff ff       	jmp    80105c37 <alltraps>

8010671f <vector162>:
.globl vector162
vector162:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $162
80106721:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106726:	e9 0c f5 ff ff       	jmp    80105c37 <alltraps>

8010672b <vector163>:
.globl vector163
vector163:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $163
8010672d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106732:	e9 00 f5 ff ff       	jmp    80105c37 <alltraps>

80106737 <vector164>:
.globl vector164
vector164:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $164
80106739:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010673e:	e9 f4 f4 ff ff       	jmp    80105c37 <alltraps>

80106743 <vector165>:
.globl vector165
vector165:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $165
80106745:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010674a:	e9 e8 f4 ff ff       	jmp    80105c37 <alltraps>

8010674f <vector166>:
.globl vector166
vector166:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $166
80106751:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106756:	e9 dc f4 ff ff       	jmp    80105c37 <alltraps>

8010675b <vector167>:
.globl vector167
vector167:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $167
8010675d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106762:	e9 d0 f4 ff ff       	jmp    80105c37 <alltraps>

80106767 <vector168>:
.globl vector168
vector168:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $168
80106769:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010676e:	e9 c4 f4 ff ff       	jmp    80105c37 <alltraps>

80106773 <vector169>:
.globl vector169
vector169:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $169
80106775:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010677a:	e9 b8 f4 ff ff       	jmp    80105c37 <alltraps>

8010677f <vector170>:
.globl vector170
vector170:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $170
80106781:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106786:	e9 ac f4 ff ff       	jmp    80105c37 <alltraps>

8010678b <vector171>:
.globl vector171
vector171:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $171
8010678d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106792:	e9 a0 f4 ff ff       	jmp    80105c37 <alltraps>

80106797 <vector172>:
.globl vector172
vector172:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $172
80106799:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010679e:	e9 94 f4 ff ff       	jmp    80105c37 <alltraps>

801067a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $173
801067a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067aa:	e9 88 f4 ff ff       	jmp    80105c37 <alltraps>

801067af <vector174>:
.globl vector174
vector174:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $174
801067b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067b6:	e9 7c f4 ff ff       	jmp    80105c37 <alltraps>

801067bb <vector175>:
.globl vector175
vector175:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $175
801067bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067c2:	e9 70 f4 ff ff       	jmp    80105c37 <alltraps>

801067c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $176
801067c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067ce:	e9 64 f4 ff ff       	jmp    80105c37 <alltraps>

801067d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $177
801067d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067da:	e9 58 f4 ff ff       	jmp    80105c37 <alltraps>

801067df <vector178>:
.globl vector178
vector178:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $178
801067e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067e6:	e9 4c f4 ff ff       	jmp    80105c37 <alltraps>

801067eb <vector179>:
.globl vector179
vector179:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $179
801067ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067f2:	e9 40 f4 ff ff       	jmp    80105c37 <alltraps>

801067f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $180
801067f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067fe:	e9 34 f4 ff ff       	jmp    80105c37 <alltraps>

80106803 <vector181>:
.globl vector181
vector181:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $181
80106805:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010680a:	e9 28 f4 ff ff       	jmp    80105c37 <alltraps>

8010680f <vector182>:
.globl vector182
vector182:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $182
80106811:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106816:	e9 1c f4 ff ff       	jmp    80105c37 <alltraps>

8010681b <vector183>:
.globl vector183
vector183:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $183
8010681d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106822:	e9 10 f4 ff ff       	jmp    80105c37 <alltraps>

80106827 <vector184>:
.globl vector184
vector184:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $184
80106829:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010682e:	e9 04 f4 ff ff       	jmp    80105c37 <alltraps>

80106833 <vector185>:
.globl vector185
vector185:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $185
80106835:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010683a:	e9 f8 f3 ff ff       	jmp    80105c37 <alltraps>

8010683f <vector186>:
.globl vector186
vector186:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $186
80106841:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106846:	e9 ec f3 ff ff       	jmp    80105c37 <alltraps>

8010684b <vector187>:
.globl vector187
vector187:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $187
8010684d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106852:	e9 e0 f3 ff ff       	jmp    80105c37 <alltraps>

80106857 <vector188>:
.globl vector188
vector188:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $188
80106859:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010685e:	e9 d4 f3 ff ff       	jmp    80105c37 <alltraps>

80106863 <vector189>:
.globl vector189
vector189:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $189
80106865:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010686a:	e9 c8 f3 ff ff       	jmp    80105c37 <alltraps>

8010686f <vector190>:
.globl vector190
vector190:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $190
80106871:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106876:	e9 bc f3 ff ff       	jmp    80105c37 <alltraps>

8010687b <vector191>:
.globl vector191
vector191:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $191
8010687d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106882:	e9 b0 f3 ff ff       	jmp    80105c37 <alltraps>

80106887 <vector192>:
.globl vector192
vector192:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $192
80106889:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010688e:	e9 a4 f3 ff ff       	jmp    80105c37 <alltraps>

80106893 <vector193>:
.globl vector193
vector193:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $193
80106895:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010689a:	e9 98 f3 ff ff       	jmp    80105c37 <alltraps>

8010689f <vector194>:
.globl vector194
vector194:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $194
801068a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068a6:	e9 8c f3 ff ff       	jmp    80105c37 <alltraps>

801068ab <vector195>:
.globl vector195
vector195:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $195
801068ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068b2:	e9 80 f3 ff ff       	jmp    80105c37 <alltraps>

801068b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $196
801068b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068be:	e9 74 f3 ff ff       	jmp    80105c37 <alltraps>

801068c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $197
801068c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068ca:	e9 68 f3 ff ff       	jmp    80105c37 <alltraps>

801068cf <vector198>:
.globl vector198
vector198:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $198
801068d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068d6:	e9 5c f3 ff ff       	jmp    80105c37 <alltraps>

801068db <vector199>:
.globl vector199
vector199:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $199
801068dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068e2:	e9 50 f3 ff ff       	jmp    80105c37 <alltraps>

801068e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $200
801068e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ee:	e9 44 f3 ff ff       	jmp    80105c37 <alltraps>

801068f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $201
801068f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068fa:	e9 38 f3 ff ff       	jmp    80105c37 <alltraps>

801068ff <vector202>:
.globl vector202
vector202:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $202
80106901:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106906:	e9 2c f3 ff ff       	jmp    80105c37 <alltraps>

8010690b <vector203>:
.globl vector203
vector203:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $203
8010690d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106912:	e9 20 f3 ff ff       	jmp    80105c37 <alltraps>

80106917 <vector204>:
.globl vector204
vector204:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $204
80106919:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010691e:	e9 14 f3 ff ff       	jmp    80105c37 <alltraps>

80106923 <vector205>:
.globl vector205
vector205:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $205
80106925:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010692a:	e9 08 f3 ff ff       	jmp    80105c37 <alltraps>

8010692f <vector206>:
.globl vector206
vector206:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $206
80106931:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106936:	e9 fc f2 ff ff       	jmp    80105c37 <alltraps>

8010693b <vector207>:
.globl vector207
vector207:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $207
8010693d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106942:	e9 f0 f2 ff ff       	jmp    80105c37 <alltraps>

80106947 <vector208>:
.globl vector208
vector208:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $208
80106949:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010694e:	e9 e4 f2 ff ff       	jmp    80105c37 <alltraps>

80106953 <vector209>:
.globl vector209
vector209:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $209
80106955:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010695a:	e9 d8 f2 ff ff       	jmp    80105c37 <alltraps>

8010695f <vector210>:
.globl vector210
vector210:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $210
80106961:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106966:	e9 cc f2 ff ff       	jmp    80105c37 <alltraps>

8010696b <vector211>:
.globl vector211
vector211:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $211
8010696d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106972:	e9 c0 f2 ff ff       	jmp    80105c37 <alltraps>

80106977 <vector212>:
.globl vector212
vector212:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $212
80106979:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010697e:	e9 b4 f2 ff ff       	jmp    80105c37 <alltraps>

80106983 <vector213>:
.globl vector213
vector213:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $213
80106985:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010698a:	e9 a8 f2 ff ff       	jmp    80105c37 <alltraps>

8010698f <vector214>:
.globl vector214
vector214:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $214
80106991:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106996:	e9 9c f2 ff ff       	jmp    80105c37 <alltraps>

8010699b <vector215>:
.globl vector215
vector215:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $215
8010699d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069a2:	e9 90 f2 ff ff       	jmp    80105c37 <alltraps>

801069a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $216
801069a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069ae:	e9 84 f2 ff ff       	jmp    80105c37 <alltraps>

801069b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $217
801069b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ba:	e9 78 f2 ff ff       	jmp    80105c37 <alltraps>

801069bf <vector218>:
.globl vector218
vector218:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $218
801069c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069c6:	e9 6c f2 ff ff       	jmp    80105c37 <alltraps>

801069cb <vector219>:
.globl vector219
vector219:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $219
801069cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069d2:	e9 60 f2 ff ff       	jmp    80105c37 <alltraps>

801069d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $220
801069d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069de:	e9 54 f2 ff ff       	jmp    80105c37 <alltraps>

801069e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $221
801069e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069ea:	e9 48 f2 ff ff       	jmp    80105c37 <alltraps>

801069ef <vector222>:
.globl vector222
vector222:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $222
801069f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069f6:	e9 3c f2 ff ff       	jmp    80105c37 <alltraps>

801069fb <vector223>:
.globl vector223
vector223:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $223
801069fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a02:	e9 30 f2 ff ff       	jmp    80105c37 <alltraps>

80106a07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $224
80106a09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a0e:	e9 24 f2 ff ff       	jmp    80105c37 <alltraps>

80106a13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $225
80106a15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a1a:	e9 18 f2 ff ff       	jmp    80105c37 <alltraps>

80106a1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $226
80106a21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a26:	e9 0c f2 ff ff       	jmp    80105c37 <alltraps>

80106a2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $227
80106a2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a32:	e9 00 f2 ff ff       	jmp    80105c37 <alltraps>

80106a37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $228
80106a39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a3e:	e9 f4 f1 ff ff       	jmp    80105c37 <alltraps>

80106a43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $229
80106a45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a4a:	e9 e8 f1 ff ff       	jmp    80105c37 <alltraps>

80106a4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $230
80106a51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a56:	e9 dc f1 ff ff       	jmp    80105c37 <alltraps>

80106a5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $231
80106a5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a62:	e9 d0 f1 ff ff       	jmp    80105c37 <alltraps>

80106a67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $232
80106a69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a6e:	e9 c4 f1 ff ff       	jmp    80105c37 <alltraps>

80106a73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $233
80106a75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a7a:	e9 b8 f1 ff ff       	jmp    80105c37 <alltraps>

80106a7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $234
80106a81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a86:	e9 ac f1 ff ff       	jmp    80105c37 <alltraps>

80106a8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $235
80106a8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a92:	e9 a0 f1 ff ff       	jmp    80105c37 <alltraps>

80106a97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $236
80106a99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a9e:	e9 94 f1 ff ff       	jmp    80105c37 <alltraps>

80106aa3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $237
80106aa5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106aaa:	e9 88 f1 ff ff       	jmp    80105c37 <alltraps>

80106aaf <vector238>:
.globl vector238
vector238:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $238
80106ab1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ab6:	e9 7c f1 ff ff       	jmp    80105c37 <alltraps>

80106abb <vector239>:
.globl vector239
vector239:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $239
80106abd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ac2:	e9 70 f1 ff ff       	jmp    80105c37 <alltraps>

80106ac7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $240
80106ac9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ace:	e9 64 f1 ff ff       	jmp    80105c37 <alltraps>

80106ad3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $241
80106ad5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106ada:	e9 58 f1 ff ff       	jmp    80105c37 <alltraps>

80106adf <vector242>:
.globl vector242
vector242:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $242
80106ae1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ae6:	e9 4c f1 ff ff       	jmp    80105c37 <alltraps>

80106aeb <vector243>:
.globl vector243
vector243:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $243
80106aed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106af2:	e9 40 f1 ff ff       	jmp    80105c37 <alltraps>

80106af7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $244
80106af9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106afe:	e9 34 f1 ff ff       	jmp    80105c37 <alltraps>

80106b03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $245
80106b05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b0a:	e9 28 f1 ff ff       	jmp    80105c37 <alltraps>

80106b0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $246
80106b11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b16:	e9 1c f1 ff ff       	jmp    80105c37 <alltraps>

80106b1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $247
80106b1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b22:	e9 10 f1 ff ff       	jmp    80105c37 <alltraps>

80106b27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $248
80106b29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b2e:	e9 04 f1 ff ff       	jmp    80105c37 <alltraps>

80106b33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $249
80106b35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b3a:	e9 f8 f0 ff ff       	jmp    80105c37 <alltraps>

80106b3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $250
80106b41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b46:	e9 ec f0 ff ff       	jmp    80105c37 <alltraps>

80106b4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $251
80106b4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b52:	e9 e0 f0 ff ff       	jmp    80105c37 <alltraps>

80106b57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $252
80106b59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b5e:	e9 d4 f0 ff ff       	jmp    80105c37 <alltraps>

80106b63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $253
80106b65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b6a:	e9 c8 f0 ff ff       	jmp    80105c37 <alltraps>

80106b6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $254
80106b71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b76:	e9 bc f0 ff ff       	jmp    80105c37 <alltraps>

80106b7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $255
80106b7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b82:	e9 b0 f0 ff ff       	jmp    80105c37 <alltraps>
80106b87:	66 90                	xchg   %ax,%ax
80106b89:	66 90                	xchg   %ax,%ax
80106b8b:	66 90                	xchg   %ax,%ax
80106b8d:	66 90                	xchg   %ax,%ax
80106b8f:	90                   	nop

80106b90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b96:	89 d3                	mov    %edx,%ebx
{
80106b98:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106b9a:	c1 eb 16             	shr    $0x16,%ebx
80106b9d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ba0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ba3:	8b 06                	mov    (%esi),%eax
80106ba5:	a8 01                	test   $0x1,%al
80106ba7:	74 27                	je     80106bd0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ba9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106bb4:	c1 ef 0a             	shr    $0xa,%edi
}
80106bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106bba:	89 fa                	mov    %edi,%edx
80106bbc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bc2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bd0:	85 c9                	test   %ecx,%ecx
80106bd2:	74 2c                	je     80106c00 <walkpgdir+0x70>
80106bd4:	e8 c7 bb ff ff       	call   801027a0 <kalloc>
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	89 c3                	mov    %eax,%ebx
80106bdd:	74 21                	je     80106c00 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106bdf:	83 ec 04             	sub    $0x4,%esp
80106be2:	68 00 10 00 00       	push   $0x1000
80106be7:	6a 00                	push   $0x0
80106be9:	50                   	push   %eax
80106bea:	e8 41 db ff ff       	call   80104730 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bf5:	83 c4 10             	add    $0x10,%esp
80106bf8:	83 c8 07             	or     $0x7,%eax
80106bfb:	89 06                	mov    %eax,(%esi)
80106bfd:	eb b5                	jmp    80106bb4 <walkpgdir+0x24>
80106bff:	90                   	nop
}
80106c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c03:	31 c0                	xor    %eax,%eax
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret    
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c16:	89 d3                	mov    %edx,%ebx
80106c18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c1e:	83 ec 1c             	sub    $0x1c,%esp
80106c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c28:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c33:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c36:	29 df                	sub    %ebx,%edi
80106c38:	83 c8 01             	or     $0x1,%eax
80106c3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c3e:	eb 15                	jmp    80106c55 <mappages+0x45>
    if(*pte & PTE_P)
80106c40:	f6 00 01             	testb  $0x1,(%eax)
80106c43:	75 45                	jne    80106c8a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c45:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c48:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c4b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c4d:	74 31                	je     80106c80 <mappages+0x70>
      break;
    a += PGSIZE;
80106c4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c58:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c5d:	89 da                	mov    %ebx,%edx
80106c5f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c62:	e8 29 ff ff ff       	call   80106b90 <walkpgdir>
80106c67:	85 c0                	test   %eax,%eax
80106c69:	75 d5                	jne    80106c40 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c73:	5b                   	pop    %ebx
80106c74:	5e                   	pop    %esi
80106c75:	5f                   	pop    %edi
80106c76:	5d                   	pop    %ebp
80106c77:	c3                   	ret    
80106c78:	90                   	nop
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c83:	31 c0                	xor    %eax,%eax
}
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
      panic("remap");
80106c8a:	83 ec 0c             	sub    $0xc,%esp
80106c8d:	68 d0 7d 10 80       	push   $0x80107dd0
80106c92:	e8 f9 96 ff ff       	call   80100390 <panic>
80106c97:	89 f6                	mov    %esi,%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ca6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106cae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cb4:	83 ec 1c             	sub    $0x1c,%esp
80106cb7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cba:	39 d3                	cmp    %edx,%ebx
80106cbc:	73 66                	jae    80106d24 <deallocuvm.part.0+0x84>
80106cbe:	89 d6                	mov    %edx,%esi
80106cc0:	eb 3d                	jmp    80106cff <deallocuvm.part.0+0x5f>
80106cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106cc8:	8b 10                	mov    (%eax),%edx
80106cca:	f6 c2 01             	test   $0x1,%dl
80106ccd:	74 26                	je     80106cf5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106ccf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cd5:	74 58                	je     80106d2f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106cd7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cda:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ce3:	52                   	push   %edx
80106ce4:	e8 07 b9 ff ff       	call   801025f0 <kfree>
      *pte = 0;
80106ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cec:	83 c4 10             	add    $0x10,%esp
80106cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106cf5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cfb:	39 f3                	cmp    %esi,%ebx
80106cfd:	73 25                	jae    80106d24 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106cff:	31 c9                	xor    %ecx,%ecx
80106d01:	89 da                	mov    %ebx,%edx
80106d03:	89 f8                	mov    %edi,%eax
80106d05:	e8 86 fe ff ff       	call   80106b90 <walkpgdir>
    if(!pte)
80106d0a:	85 c0                	test   %eax,%eax
80106d0c:	75 ba                	jne    80106cc8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d20:	39 f3                	cmp    %esi,%ebx
80106d22:	72 db                	jb     80106cff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d2a:	5b                   	pop    %ebx
80106d2b:	5e                   	pop    %esi
80106d2c:	5f                   	pop    %edi
80106d2d:	5d                   	pop    %ebp
80106d2e:	c3                   	ret    
        panic("kfree");
80106d2f:	83 ec 0c             	sub    $0xc,%esp
80106d32:	68 26 77 10 80       	push   $0x80107726
80106d37:	e8 54 96 ff ff       	call   80100390 <panic>
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <seginit>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d46:	e8 55 cd ff ff       	call   80103aa0 <cpuid>
80106d4b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106d51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d5a:	c7 80 b8 28 11 80 ff 	movl   $0xffff,-0x7feed748(%eax)
80106d61:	ff 00 00 
80106d64:	c7 80 bc 28 11 80 00 	movl   $0xcf9a00,-0x7feed744(%eax)
80106d6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d6e:	c7 80 c0 28 11 80 ff 	movl   $0xffff,-0x7feed740(%eax)
80106d75:	ff 00 00 
80106d78:	c7 80 c4 28 11 80 00 	movl   $0xcf9200,-0x7feed73c(%eax)
80106d7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d82:	c7 80 c8 28 11 80 ff 	movl   $0xffff,-0x7feed738(%eax)
80106d89:	ff 00 00 
80106d8c:	c7 80 cc 28 11 80 00 	movl   $0xcffa00,-0x7feed734(%eax)
80106d93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d96:	c7 80 d0 28 11 80 ff 	movl   $0xffff,-0x7feed730(%eax)
80106d9d:	ff 00 00 
80106da0:	c7 80 d4 28 11 80 00 	movl   $0xcff200,-0x7feed72c(%eax)
80106da7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106daa:	05 b0 28 11 80       	add    $0x801128b0,%eax
  pd[1] = (uint)p;
80106daf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106db3:	c1 e8 10             	shr    $0x10,%eax
80106db6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dbd:	0f 01 10             	lgdtl  (%eax)
}
80106dc0:	c9                   	leave  
80106dc1:	c3                   	ret    
80106dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd0:	a1 64 55 11 80       	mov    0x80115564,%eax
{
80106dd5:	55                   	push   %ebp
80106dd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ddd:	0f 22 d8             	mov    %eax,%cr3
}
80106de0:	5d                   	pop    %ebp
80106de1:	c3                   	ret    
80106de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <switchuvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
80106df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106dfc:	85 db                	test   %ebx,%ebx
80106dfe:	0f 84 cb 00 00 00    	je     80106ecf <switchuvm+0xdf>
  if(p->kstack == 0)
80106e04:	8b 43 08             	mov    0x8(%ebx),%eax
80106e07:	85 c0                	test   %eax,%eax
80106e09:	0f 84 da 00 00 00    	je     80106ee9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106e12:	85 c0                	test   %eax,%eax
80106e14:	0f 84 c2 00 00 00    	je     80106edc <switchuvm+0xec>
  pushcli();
80106e1a:	e8 31 d7 ff ff       	call   80104550 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e1f:	e8 fc cb ff ff       	call   80103a20 <mycpu>
80106e24:	89 c6                	mov    %eax,%esi
80106e26:	e8 f5 cb ff ff       	call   80103a20 <mycpu>
80106e2b:	89 c7                	mov    %eax,%edi
80106e2d:	e8 ee cb ff ff       	call   80103a20 <mycpu>
80106e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e35:	83 c7 08             	add    $0x8,%edi
80106e38:	e8 e3 cb ff ff       	call   80103a20 <mycpu>
80106e3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e40:	83 c0 08             	add    $0x8,%eax
80106e43:	ba 67 00 00 00       	mov    $0x67,%edx
80106e48:	c1 e8 18             	shr    $0x18,%eax
80106e4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e64:	83 c1 08             	add    $0x8,%ecx
80106e67:	c1 e9 10             	shr    $0x10,%ecx
80106e6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106e70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e7c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e81:	e8 9a cb ff ff       	call   80103a20 <mycpu>
80106e86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e8d:	e8 8e cb ff ff       	call   80103a20 <mycpu>
80106e92:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e96:	8b 73 08             	mov    0x8(%ebx),%esi
80106e99:	e8 82 cb ff ff       	call   80103a20 <mycpu>
80106e9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ea4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ea7:	e8 74 cb ff ff       	call   80103a20 <mycpu>
80106eac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106eb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106eb5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106eb8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ebb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ec0:	0f 22 d8             	mov    %eax,%cr3
}
80106ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec6:	5b                   	pop    %ebx
80106ec7:	5e                   	pop    %esi
80106ec8:	5f                   	pop    %edi
80106ec9:	5d                   	pop    %ebp
  popcli();
80106eca:	e9 c1 d6 ff ff       	jmp    80104590 <popcli>
    panic("switchuvm: no process");
80106ecf:	83 ec 0c             	sub    $0xc,%esp
80106ed2:	68 d6 7d 10 80       	push   $0x80107dd6
80106ed7:	e8 b4 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106edc:	83 ec 0c             	sub    $0xc,%esp
80106edf:	68 01 7e 10 80       	push   $0x80107e01
80106ee4:	e8 a7 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106ee9:	83 ec 0c             	sub    $0xc,%esp
80106eec:	68 ec 7d 10 80       	push   $0x80107dec
80106ef1:	e8 9a 94 ff ff       	call   80100390 <panic>
80106ef6:	8d 76 00             	lea    0x0(%esi),%esi
80106ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f00 <inituvm>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 75 10             	mov    0x10(%ebp),%esi
80106f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f12:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f1b:	77 49                	ja     80106f66 <inituvm+0x66>
  mem = kalloc();
80106f1d:	e8 7e b8 ff ff       	call   801027a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106f22:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f25:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f27:	68 00 10 00 00       	push   $0x1000
80106f2c:	6a 00                	push   $0x0
80106f2e:	50                   	push   %eax
80106f2f:	e8 fc d7 ff ff       	call   80104730 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f34:	58                   	pop    %eax
80106f35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f40:	5a                   	pop    %edx
80106f41:	6a 06                	push   $0x6
80106f43:	50                   	push   %eax
80106f44:	31 d2                	xor    %edx,%edx
80106f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f49:	e8 c2 fc ff ff       	call   80106c10 <mappages>
  memmove(mem, init, sz);
80106f4e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f51:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f54:	83 c4 10             	add    $0x10,%esp
80106f57:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f5d:	5b                   	pop    %ebx
80106f5e:	5e                   	pop    %esi
80106f5f:	5f                   	pop    %edi
80106f60:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f61:	e9 7a d8 ff ff       	jmp    801047e0 <memmove>
    panic("inituvm: more than a page");
80106f66:	83 ec 0c             	sub    $0xc,%esp
80106f69:	68 15 7e 10 80       	push   $0x80107e15
80106f6e:	e8 1d 94 ff ff       	call   80100390 <panic>
80106f73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f80 <loaduvm>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106f89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f90:	0f 85 91 00 00 00    	jne    80107027 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106f96:	8b 75 18             	mov    0x18(%ebp),%esi
80106f99:	31 db                	xor    %ebx,%ebx
80106f9b:	85 f6                	test   %esi,%esi
80106f9d:	75 1a                	jne    80106fb9 <loaduvm+0x39>
80106f9f:	eb 6f                	jmp    80107010 <loaduvm+0x90>
80106fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106fb7:	76 57                	jbe    80107010 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fbf:	31 c9                	xor    %ecx,%ecx
80106fc1:	01 da                	add    %ebx,%edx
80106fc3:	e8 c8 fb ff ff       	call   80106b90 <walkpgdir>
80106fc8:	85 c0                	test   %eax,%eax
80106fca:	74 4e                	je     8010701a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106fcc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106fd1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fdb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fe1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fe4:	01 d9                	add    %ebx,%ecx
80106fe6:	05 00 00 00 80       	add    $0x80000000,%eax
80106feb:	57                   	push   %edi
80106fec:	51                   	push   %ecx
80106fed:	50                   	push   %eax
80106fee:	ff 75 10             	pushl  0x10(%ebp)
80106ff1:	e8 5a ab ff ff       	call   80101b50 <readi>
80106ff6:	83 c4 10             	add    $0x10,%esp
80106ff9:	39 f8                	cmp    %edi,%eax
80106ffb:	74 ab                	je     80106fa8 <loaduvm+0x28>
}
80106ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107005:	5b                   	pop    %ebx
80107006:	5e                   	pop    %esi
80107007:	5f                   	pop    %edi
80107008:	5d                   	pop    %ebp
80107009:	c3                   	ret    
8010700a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107013:	31 c0                	xor    %eax,%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    
      panic("loaduvm: address should exist");
8010701a:	83 ec 0c             	sub    $0xc,%esp
8010701d:	68 2f 7e 10 80       	push   $0x80107e2f
80107022:	e8 69 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107027:	83 ec 0c             	sub    $0xc,%esp
8010702a:	68 d0 7e 10 80       	push   $0x80107ed0
8010702f:	e8 5c 93 ff ff       	call   80100390 <panic>
80107034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010703a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107040 <allocuvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107049:	8b 7d 10             	mov    0x10(%ebp),%edi
8010704c:	85 ff                	test   %edi,%edi
8010704e:	0f 88 8e 00 00 00    	js     801070e2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107054:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107057:	0f 82 93 00 00 00    	jb     801070f0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010705d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107060:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107066:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010706c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010706f:	0f 86 7e 00 00 00    	jbe    801070f3 <allocuvm+0xb3>
80107075:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107078:	8b 7d 08             	mov    0x8(%ebp),%edi
8010707b:	eb 42                	jmp    801070bf <allocuvm+0x7f>
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107080:	83 ec 04             	sub    $0x4,%esp
80107083:	68 00 10 00 00       	push   $0x1000
80107088:	6a 00                	push   $0x0
8010708a:	50                   	push   %eax
8010708b:	e8 a0 d6 ff ff       	call   80104730 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107090:	58                   	pop    %eax
80107091:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107097:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010709c:	5a                   	pop    %edx
8010709d:	6a 06                	push   $0x6
8010709f:	50                   	push   %eax
801070a0:	89 da                	mov    %ebx,%edx
801070a2:	89 f8                	mov    %edi,%eax
801070a4:	e8 67 fb ff ff       	call   80106c10 <mappages>
801070a9:	83 c4 10             	add    $0x10,%esp
801070ac:	85 c0                	test   %eax,%eax
801070ae:	78 50                	js     80107100 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801070b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070b6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070b9:	0f 86 81 00 00 00    	jbe    80107140 <allocuvm+0x100>
    mem = kalloc();
801070bf:	e8 dc b6 ff ff       	call   801027a0 <kalloc>
    if(mem == 0){
801070c4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801070c6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801070c8:	75 b6                	jne    80107080 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070ca:	83 ec 0c             	sub    $0xc,%esp
801070cd:	68 4d 7e 10 80       	push   $0x80107e4d
801070d2:	e8 89 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801070d7:	83 c4 10             	add    $0x10,%esp
801070da:	8b 45 0c             	mov    0xc(%ebp),%eax
801070dd:	39 45 10             	cmp    %eax,0x10(%ebp)
801070e0:	77 6e                	ja     80107150 <allocuvm+0x110>
}
801070e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801070e5:	31 ff                	xor    %edi,%edi
}
801070e7:	89 f8                	mov    %edi,%eax
801070e9:	5b                   	pop    %ebx
801070ea:	5e                   	pop    %esi
801070eb:	5f                   	pop    %edi
801070ec:	5d                   	pop    %ebp
801070ed:	c3                   	ret    
801070ee:	66 90                	xchg   %ax,%ax
    return oldsz;
801070f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801070f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f6:	89 f8                	mov    %edi,%eax
801070f8:	5b                   	pop    %ebx
801070f9:	5e                   	pop    %esi
801070fa:	5f                   	pop    %edi
801070fb:	5d                   	pop    %ebp
801070fc:	c3                   	ret    
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107100:	83 ec 0c             	sub    $0xc,%esp
80107103:	68 65 7e 10 80       	push   $0x80107e65
80107108:	e8 53 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010710d:	83 c4 10             	add    $0x10,%esp
80107110:	8b 45 0c             	mov    0xc(%ebp),%eax
80107113:	39 45 10             	cmp    %eax,0x10(%ebp)
80107116:	76 0d                	jbe    80107125 <allocuvm+0xe5>
80107118:	89 c1                	mov    %eax,%ecx
8010711a:	8b 55 10             	mov    0x10(%ebp),%edx
8010711d:	8b 45 08             	mov    0x8(%ebp),%eax
80107120:	e8 7b fb ff ff       	call   80106ca0 <deallocuvm.part.0>
      kfree(mem);
80107125:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107128:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010712a:	56                   	push   %esi
8010712b:	e8 c0 b4 ff ff       	call   801025f0 <kfree>
      return 0;
80107130:	83 c4 10             	add    $0x10,%esp
}
80107133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107136:	89 f8                	mov    %edi,%eax
80107138:	5b                   	pop    %ebx
80107139:	5e                   	pop    %esi
8010713a:	5f                   	pop    %edi
8010713b:	5d                   	pop    %ebp
8010713c:	c3                   	ret    
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
80107140:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107143:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107146:	5b                   	pop    %ebx
80107147:	89 f8                	mov    %edi,%eax
80107149:	5e                   	pop    %esi
8010714a:	5f                   	pop    %edi
8010714b:	5d                   	pop    %ebp
8010714c:	c3                   	ret    
8010714d:	8d 76 00             	lea    0x0(%esi),%esi
80107150:	89 c1                	mov    %eax,%ecx
80107152:	8b 55 10             	mov    0x10(%ebp),%edx
80107155:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107158:	31 ff                	xor    %edi,%edi
8010715a:	e8 41 fb ff ff       	call   80106ca0 <deallocuvm.part.0>
8010715f:	eb 92                	jmp    801070f3 <allocuvm+0xb3>
80107161:	eb 0d                	jmp    80107170 <deallocuvm>
80107163:	90                   	nop
80107164:	90                   	nop
80107165:	90                   	nop
80107166:	90                   	nop
80107167:	90                   	nop
80107168:	90                   	nop
80107169:	90                   	nop
8010716a:	90                   	nop
8010716b:	90                   	nop
8010716c:	90                   	nop
8010716d:	90                   	nop
8010716e:	90                   	nop
8010716f:	90                   	nop

80107170 <deallocuvm>:
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	8b 55 0c             	mov    0xc(%ebp),%edx
80107176:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107179:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010717c:	39 d1                	cmp    %edx,%ecx
8010717e:	73 10                	jae    80107190 <deallocuvm+0x20>
}
80107180:	5d                   	pop    %ebp
80107181:	e9 1a fb ff ff       	jmp    80106ca0 <deallocuvm.part.0>
80107186:	8d 76 00             	lea    0x0(%esi),%esi
80107189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107190:	89 d0                	mov    %edx,%eax
80107192:	5d                   	pop    %ebp
80107193:	c3                   	ret    
80107194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010719a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071ac:	85 f6                	test   %esi,%esi
801071ae:	74 59                	je     80107209 <freevm+0x69>
801071b0:	31 c9                	xor    %ecx,%ecx
801071b2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071b7:	89 f0                	mov    %esi,%eax
801071b9:	e8 e2 fa ff ff       	call   80106ca0 <deallocuvm.part.0>
801071be:	89 f3                	mov    %esi,%ebx
801071c0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071c6:	eb 0f                	jmp    801071d7 <freevm+0x37>
801071c8:	90                   	nop
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071d0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071d3:	39 fb                	cmp    %edi,%ebx
801071d5:	74 23                	je     801071fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071d7:	8b 03                	mov    (%ebx),%eax
801071d9:	a8 01                	test   $0x1,%al
801071db:	74 f3                	je     801071d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071e2:	83 ec 0c             	sub    $0xc,%esp
801071e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071ed:	50                   	push   %eax
801071ee:	e8 fd b3 ff ff       	call   801025f0 <kfree>
801071f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071f6:	39 fb                	cmp    %edi,%ebx
801071f8:	75 dd                	jne    801071d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107200:	5b                   	pop    %ebx
80107201:	5e                   	pop    %esi
80107202:	5f                   	pop    %edi
80107203:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107204:	e9 e7 b3 ff ff       	jmp    801025f0 <kfree>
    panic("freevm: no pgdir");
80107209:	83 ec 0c             	sub    $0xc,%esp
8010720c:	68 81 7e 10 80       	push   $0x80107e81
80107211:	e8 7a 91 ff ff       	call   80100390 <panic>
80107216:	8d 76 00             	lea    0x0(%esi),%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107220 <setupkvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	56                   	push   %esi
80107224:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107225:	e8 76 b5 ff ff       	call   801027a0 <kalloc>
8010722a:	85 c0                	test   %eax,%eax
8010722c:	89 c6                	mov    %eax,%esi
8010722e:	74 42                	je     80107272 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107230:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107233:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107238:	68 00 10 00 00       	push   $0x1000
8010723d:	6a 00                	push   $0x0
8010723f:	50                   	push   %eax
80107240:	e8 eb d4 ff ff       	call   80104730 <memset>
80107245:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107248:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010724b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010724e:	83 ec 08             	sub    $0x8,%esp
80107251:	8b 13                	mov    (%ebx),%edx
80107253:	ff 73 0c             	pushl  0xc(%ebx)
80107256:	50                   	push   %eax
80107257:	29 c1                	sub    %eax,%ecx
80107259:	89 f0                	mov    %esi,%eax
8010725b:	e8 b0 f9 ff ff       	call   80106c10 <mappages>
80107260:	83 c4 10             	add    $0x10,%esp
80107263:	85 c0                	test   %eax,%eax
80107265:	78 19                	js     80107280 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107267:	83 c3 10             	add    $0x10,%ebx
8010726a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107270:	75 d6                	jne    80107248 <setupkvm+0x28>
}
80107272:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107275:	89 f0                	mov    %esi,%eax
80107277:	5b                   	pop    %ebx
80107278:	5e                   	pop    %esi
80107279:	5d                   	pop    %ebp
8010727a:	c3                   	ret    
8010727b:	90                   	nop
8010727c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107280:	83 ec 0c             	sub    $0xc,%esp
80107283:	56                   	push   %esi
      return 0;
80107284:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107286:	e8 15 ff ff ff       	call   801071a0 <freevm>
      return 0;
8010728b:	83 c4 10             	add    $0x10,%esp
}
8010728e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107291:	89 f0                	mov    %esi,%eax
80107293:	5b                   	pop    %ebx
80107294:	5e                   	pop    %esi
80107295:	5d                   	pop    %ebp
80107296:	c3                   	ret    
80107297:	89 f6                	mov    %esi,%esi
80107299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072a0 <kvmalloc>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072a6:	e8 75 ff ff ff       	call   80107220 <setupkvm>
801072ab:	a3 64 55 11 80       	mov    %eax,0x80115564
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072b0:	05 00 00 00 80       	add    $0x80000000,%eax
801072b5:	0f 22 d8             	mov    %eax,%cr3
}
801072b8:	c9                   	leave  
801072b9:	c3                   	ret    
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072c1:	31 c9                	xor    %ecx,%ecx
{
801072c3:	89 e5                	mov    %esp,%ebp
801072c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072cb:	8b 45 08             	mov    0x8(%ebp),%eax
801072ce:	e8 bd f8 ff ff       	call   80106b90 <walkpgdir>
  if(pte == 0)
801072d3:	85 c0                	test   %eax,%eax
801072d5:	74 05                	je     801072dc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801072d7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072da:	c9                   	leave  
801072db:	c3                   	ret    
    panic("clearpteu");
801072dc:	83 ec 0c             	sub    $0xc,%esp
801072df:	68 92 7e 10 80       	push   $0x80107e92
801072e4:	e8 a7 90 ff ff       	call   80100390 <panic>
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801072f9:	e8 22 ff ff ff       	call   80107220 <setupkvm>
801072fe:	85 c0                	test   %eax,%eax
80107300:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107303:	0f 84 9f 00 00 00    	je     801073a8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107309:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010730c:	85 c9                	test   %ecx,%ecx
8010730e:	0f 84 94 00 00 00    	je     801073a8 <copyuvm+0xb8>
80107314:	31 ff                	xor    %edi,%edi
80107316:	eb 4a                	jmp    80107362 <copyuvm+0x72>
80107318:	90                   	nop
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107320:	83 ec 04             	sub    $0x4,%esp
80107323:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107329:	68 00 10 00 00       	push   $0x1000
8010732e:	53                   	push   %ebx
8010732f:	50                   	push   %eax
80107330:	e8 ab d4 ff ff       	call   801047e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107335:	58                   	pop    %eax
80107336:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010733c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107341:	5a                   	pop    %edx
80107342:	ff 75 e4             	pushl  -0x1c(%ebp)
80107345:	50                   	push   %eax
80107346:	89 fa                	mov    %edi,%edx
80107348:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010734b:	e8 c0 f8 ff ff       	call   80106c10 <mappages>
80107350:	83 c4 10             	add    $0x10,%esp
80107353:	85 c0                	test   %eax,%eax
80107355:	78 61                	js     801073b8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107357:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010735d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107360:	76 46                	jbe    801073a8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107362:	8b 45 08             	mov    0x8(%ebp),%eax
80107365:	31 c9                	xor    %ecx,%ecx
80107367:	89 fa                	mov    %edi,%edx
80107369:	e8 22 f8 ff ff       	call   80106b90 <walkpgdir>
8010736e:	85 c0                	test   %eax,%eax
80107370:	74 61                	je     801073d3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107372:	8b 00                	mov    (%eax),%eax
80107374:	a8 01                	test   $0x1,%al
80107376:	74 4e                	je     801073c6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107378:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010737a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010737f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107388:	e8 13 b4 ff ff       	call   801027a0 <kalloc>
8010738d:	85 c0                	test   %eax,%eax
8010738f:	89 c6                	mov    %eax,%esi
80107391:	75 8d                	jne    80107320 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107393:	83 ec 0c             	sub    $0xc,%esp
80107396:	ff 75 e0             	pushl  -0x20(%ebp)
80107399:	e8 02 fe ff ff       	call   801071a0 <freevm>
  return 0;
8010739e:	83 c4 10             	add    $0x10,%esp
801073a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801073a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ae:	5b                   	pop    %ebx
801073af:	5e                   	pop    %esi
801073b0:	5f                   	pop    %edi
801073b1:	5d                   	pop    %ebp
801073b2:	c3                   	ret    
801073b3:	90                   	nop
801073b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073b8:	83 ec 0c             	sub    $0xc,%esp
801073bb:	56                   	push   %esi
801073bc:	e8 2f b2 ff ff       	call   801025f0 <kfree>
      goto bad;
801073c1:	83 c4 10             	add    $0x10,%esp
801073c4:	eb cd                	jmp    80107393 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801073c6:	83 ec 0c             	sub    $0xc,%esp
801073c9:	68 b6 7e 10 80       	push   $0x80107eb6
801073ce:	e8 bd 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801073d3:	83 ec 0c             	sub    $0xc,%esp
801073d6:	68 9c 7e 10 80       	push   $0x80107e9c
801073db:	e8 b0 8f ff ff       	call   80100390 <panic>

801073e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073e1:	31 c9                	xor    %ecx,%ecx
{
801073e3:	89 e5                	mov    %esp,%ebp
801073e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073eb:	8b 45 08             	mov    0x8(%ebp),%eax
801073ee:	e8 9d f7 ff ff       	call   80106b90 <walkpgdir>
  if((*pte & PTE_P) == 0)
801073f3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073f5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801073f6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073fd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107400:	05 00 00 00 80       	add    $0x80000000,%eax
80107405:	83 fa 05             	cmp    $0x5,%edx
80107408:	ba 00 00 00 00       	mov    $0x0,%edx
8010740d:	0f 45 c2             	cmovne %edx,%eax
}
80107410:	c3                   	ret    
80107411:	eb 0d                	jmp    80107420 <copyout>
80107413:	90                   	nop
80107414:	90                   	nop
80107415:	90                   	nop
80107416:	90                   	nop
80107417:	90                   	nop
80107418:	90                   	nop
80107419:	90                   	nop
8010741a:	90                   	nop
8010741b:	90                   	nop
8010741c:	90                   	nop
8010741d:	90                   	nop
8010741e:	90                   	nop
8010741f:	90                   	nop

80107420 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 1c             	sub    $0x1c,%esp
80107429:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010742c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010742f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107432:	85 db                	test   %ebx,%ebx
80107434:	75 40                	jne    80107476 <copyout+0x56>
80107436:	eb 70                	jmp    801074a8 <copyout+0x88>
80107438:	90                   	nop
80107439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107443:	89 f1                	mov    %esi,%ecx
80107445:	29 d1                	sub    %edx,%ecx
80107447:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010744d:	39 d9                	cmp    %ebx,%ecx
8010744f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107452:	29 f2                	sub    %esi,%edx
80107454:	83 ec 04             	sub    $0x4,%esp
80107457:	01 d0                	add    %edx,%eax
80107459:	51                   	push   %ecx
8010745a:	57                   	push   %edi
8010745b:	50                   	push   %eax
8010745c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010745f:	e8 7c d3 ff ff       	call   801047e0 <memmove>
    len -= n;
    buf += n;
80107464:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107467:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010746a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107470:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107472:	29 cb                	sub    %ecx,%ebx
80107474:	74 32                	je     801074a8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107476:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107478:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010747b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010747e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107484:	56                   	push   %esi
80107485:	ff 75 08             	pushl  0x8(%ebp)
80107488:	e8 53 ff ff ff       	call   801073e0 <uva2ka>
    if(pa0 == 0)
8010748d:	83 c4 10             	add    $0x10,%esp
80107490:	85 c0                	test   %eax,%eax
80107492:	75 ac                	jne    80107440 <copyout+0x20>
  }
  return 0;
}
80107494:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010749c:	5b                   	pop    %ebx
8010749d:	5e                   	pop    %esi
8010749e:	5f                   	pop    %edi
8010749f:	5d                   	pop    %ebp
801074a0:	c3                   	ret    
801074a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074ab:	31 c0                	xor    %eax,%eax
}
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
801074b1:	c3                   	ret    
