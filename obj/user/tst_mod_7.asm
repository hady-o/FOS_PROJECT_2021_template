
obj/user/tst_mod_7:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 08 0a 00 00       	call   800a3e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>
extern void freeHeap();

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 74             	sub    $0x74,%esp
	int envID = sys_getenvid();
  80003f:	e8 e3 1c 00 00       	call   801d27 <sys_getenvid>
  800044:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//	cprintf("envID = %d\n",envID);

	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int Mega = 1024*1024;
  80004e:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int freeFrames, origFreeFrames, usedDiskPages, origDiskPages;
	uint32 size ;
	/// testing freeHeap()
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800055:	e8 b1 1d 00 00       	call   801e0b <sys_calculate_free_frames>
  80005a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		origFreeFrames = freeFrames ;
  80005d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800060:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800063:	e8 26 1e 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800068:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		origDiskPages = usedDiskPages ;
  80006b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80006e:	89 45 d0             	mov    %eax,-0x30(%ebp)

		size = 1*Mega;
  800071:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800074:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800077:	83 ec 0c             	sub    $0xc,%esp
  80007a:	ff 75 cc             	pushl  -0x34(%ebp)
  80007d:	e8 2d 1b 00 00       	call   801baf <malloc>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 c8             	mov    %eax,-0x38(%ebp)

		assert((uint32) x == USER_HEAP_START);
  800088:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80008b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800090:	74 16                	je     8000a8 <_main+0x70>
  800092:	68 60 25 80 00       	push   $0x802560
  800097:	68 7e 25 80 00       	push   $0x80257e
  80009c:	6a 1c                	push   $0x1c
  80009e:	68 93 25 80 00       	push   $0x802593
  8000a3:	e8 db 0a 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 1);
  8000a8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8000ab:	e8 5b 1d 00 00       	call   801e0b <sys_calculate_free_frames>
  8000b0:	29 c3                	sub    %eax,%ebx
  8000b2:	89 d8                	mov    %ebx,%eax
  8000b4:	83 f8 01             	cmp    $0x1,%eax
  8000b7:	74 16                	je     8000cf <_main+0x97>
  8000b9:	68 a4 25 80 00       	push   $0x8025a4
  8000be:	68 7e 25 80 00       	push   $0x80257e
  8000c3:	6a 1d                	push   $0x1d
  8000c5:	68 93 25 80 00       	push   $0x802593
  8000ca:	e8 b4 0a 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1*Mega/PAGE_SIZE);
  8000cf:	e8 ba 1d 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  8000d4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	79 05                	jns    8000e5 <_main+0xad>
  8000e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8000e5:	c1 f8 0c             	sar    $0xc,%eax
  8000e8:	39 c2                	cmp    %eax,%edx
  8000ea:	74 16                	je     800102 <_main+0xca>
  8000ec:	68 d4 25 80 00       	push   $0x8025d4
  8000f1:	68 7e 25 80 00       	push   $0x80257e
  8000f6:	6a 1e                	push   $0x1e
  8000f8:	68 93 25 80 00       	push   $0x802593
  8000fd:	e8 81 0a 00 00       	call   800b83 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 04 1d 00 00       	call   801e0b <sys_calculate_free_frames>
  800107:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 7f 1d 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  80010f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 1*Mega;
  800112:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800115:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *t1 = malloc(sizeof(unsigned char)*size) ;
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	ff 75 cc             	pushl  -0x34(%ebp)
  80011e:	e8 8c 1a 00 00       	call   801baf <malloc>
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		assert((uint32) t1 == USER_HEAP_START + 1*Mega);
  800129:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012c:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800132:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800135:	39 c2                	cmp    %eax,%edx
  800137:	74 16                	je     80014f <_main+0x117>
  800139:	68 20 26 80 00       	push   $0x802620
  80013e:	68 7e 25 80 00       	push   $0x80257e
  800143:	6a 27                	push   $0x27
  800145:	68 93 25 80 00       	push   $0x802593
  80014a:	e8 34 0a 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 0);
  80014f:	e8 b7 1c 00 00       	call   801e0b <sys_calculate_free_frames>
  800154:	89 c2                	mov    %eax,%edx
  800156:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800159:	39 c2                	cmp    %eax,%edx
  80015b:	74 16                	je     800173 <_main+0x13b>
  80015d:	68 48 26 80 00       	push   $0x802648
  800162:	68 7e 25 80 00       	push   $0x80257e
  800167:	6a 28                	push   $0x28
  800169:	68 93 25 80 00       	push   $0x802593
  80016e:	e8 10 0a 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1*Mega/PAGE_SIZE);
  800173:	e8 16 1d 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800178:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80017b:	89 c2                	mov    %eax,%edx
  80017d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800180:	85 c0                	test   %eax,%eax
  800182:	79 05                	jns    800189 <_main+0x151>
  800184:	05 ff 0f 00 00       	add    $0xfff,%eax
  800189:	c1 f8 0c             	sar    $0xc,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 16                	je     8001a6 <_main+0x16e>
  800190:	68 d4 25 80 00       	push   $0x8025d4
  800195:	68 7e 25 80 00       	push   $0x80257e
  80019a:	6a 29                	push   $0x29
  80019c:	68 93 25 80 00       	push   $0x802593
  8001a1:	e8 dd 09 00 00       	call   800b83 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8001a6:	e8 60 1c 00 00       	call   801e0b <sys_calculate_free_frames>
  8001ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ae:	e8 db 1c 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  8001b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 2*Mega;
  8001b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b9:	01 c0                	add    %eax,%eax
  8001bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *t2 = malloc(sizeof(unsigned char)*size) ;
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	ff 75 cc             	pushl  -0x34(%ebp)
  8001c4:	e8 e6 19 00 00       	call   801baf <malloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 c0             	mov    %eax,-0x40(%ebp)

		assert((uint32) t2 == USER_HEAP_START + 2*Mega);
  8001cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d2:	01 c0                	add    %eax,%eax
  8001d4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001da:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001dd:	39 c2                	cmp    %eax,%edx
  8001df:	74 16                	je     8001f7 <_main+0x1bf>
  8001e1:	68 78 26 80 00       	push   $0x802678
  8001e6:	68 7e 25 80 00       	push   $0x80257e
  8001eb:	6a 32                	push   $0x32
  8001ed:	68 93 25 80 00       	push   $0x802593
  8001f2:	e8 8c 09 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 0);
  8001f7:	e8 0f 1c 00 00       	call   801e0b <sys_calculate_free_frames>
  8001fc:	89 c2                	mov    %eax,%edx
  8001fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800201:	39 c2                	cmp    %eax,%edx
  800203:	74 16                	je     80021b <_main+0x1e3>
  800205:	68 48 26 80 00       	push   $0x802648
  80020a:	68 7e 25 80 00       	push   $0x80257e
  80020f:	6a 33                	push   $0x33
  800211:	68 93 25 80 00       	push   $0x802593
  800216:	e8 68 09 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2*Mega/PAGE_SIZE);
  80021b:	e8 6e 1c 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800220:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800223:	89 c2                	mov    %eax,%edx
  800225:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800228:	01 c0                	add    %eax,%eax
  80022a:	85 c0                	test   %eax,%eax
  80022c:	79 05                	jns    800233 <_main+0x1fb>
  80022e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800233:	c1 f8 0c             	sar    $0xc,%eax
  800236:	39 c2                	cmp    %eax,%edx
  800238:	74 16                	je     800250 <_main+0x218>
  80023a:	68 a0 26 80 00       	push   $0x8026a0
  80023f:	68 7e 25 80 00       	push   $0x80257e
  800244:	6a 34                	push   $0x34
  800246:	68 93 25 80 00       	push   $0x802593
  80024b:	e8 33 09 00 00       	call   800b83 <_panic>

		//Allocate 4 MB
		freeFrames = sys_calculate_free_frames() ;
  800250:	e8 b6 1b 00 00       	call   801e0b <sys_calculate_free_frames>
  800255:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800258:	e8 31 1c 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  80025d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 4*Mega;
  800260:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800263:	c1 e0 02             	shl    $0x2,%eax
  800266:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *t3 = malloc(sizeof(unsigned char)*size) ;
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	ff 75 cc             	pushl  -0x34(%ebp)
  80026f:	e8 3b 19 00 00       	call   801baf <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 bc             	mov    %eax,-0x44(%ebp)

		assert((uint32) t3 == USER_HEAP_START + 4*Mega);
  80027a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80027d:	c1 e0 02             	shl    $0x2,%eax
  800280:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800286:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800289:	39 c2                	cmp    %eax,%edx
  80028b:	74 16                	je     8002a3 <_main+0x26b>
  80028d:	68 ec 26 80 00       	push   $0x8026ec
  800292:	68 7e 25 80 00       	push   $0x80257e
  800297:	6a 3d                	push   $0x3d
  800299:	68 93 25 80 00       	push   $0x802593
  80029e:	e8 e0 08 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  8002a3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002a6:	e8 60 1b 00 00       	call   801e0b <sys_calculate_free_frames>
  8002ab:	29 c3                	sub    %eax,%ebx
  8002ad:	89 d8                	mov    %ebx,%eax
  8002af:	83 f8 01             	cmp    $0x1,%eax
  8002b2:	74 16                	je     8002ca <_main+0x292>
  8002b4:	68 14 27 80 00       	push   $0x802714
  8002b9:	68 7e 25 80 00       	push   $0x80257e
  8002be:	6a 3e                	push   $0x3e
  8002c0:	68 93 25 80 00       	push   $0x802593
  8002c5:	e8 b9 08 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 4*Mega/PAGE_SIZE);
  8002ca:	e8 bf 1b 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  8002cf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8002d2:	89 c2                	mov    %eax,%edx
  8002d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d7:	c1 e0 02             	shl    $0x2,%eax
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	79 05                	jns    8002e3 <_main+0x2ab>
  8002de:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002e3:	c1 f8 0c             	sar    $0xc,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 16                	je     800300 <_main+0x2c8>
  8002ea:	68 48 27 80 00       	push   $0x802748
  8002ef:	68 7e 25 80 00       	push   $0x80257e
  8002f4:	6a 3f                	push   $0x3f
  8002f6:	68 93 25 80 00       	push   $0x802593
  8002fb:	e8 83 08 00 00       	call   800b83 <_panic>

		//Allocate 4 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 06 1b 00 00       	call   801e0b <sys_calculate_free_frames>
  800305:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800308:	e8 81 1b 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  80030d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 4*Mega;
  800310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800313:	c1 e0 02             	shl    $0x2,%eax
  800316:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *t4 = malloc(sizeof(unsigned char)*size) ;
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	ff 75 cc             	pushl  -0x34(%ebp)
  80031f:	e8 8b 18 00 00       	call   801baf <malloc>
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	89 45 b8             	mov    %eax,-0x48(%ebp)

		assert((uint32) t4 == USER_HEAP_START + 8*Mega);
  80032a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032d:	c1 e0 03             	shl    $0x3,%eax
  800330:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800336:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 16                	je     800353 <_main+0x31b>
  80033d:	68 94 27 80 00       	push   $0x802794
  800342:	68 7e 25 80 00       	push   $0x80257e
  800347:	6a 48                	push   $0x48
  800349:	68 93 25 80 00       	push   $0x802593
  80034e:	e8 30 08 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  800353:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800356:	e8 b0 1a 00 00       	call   801e0b <sys_calculate_free_frames>
  80035b:	29 c3                	sub    %eax,%ebx
  80035d:	89 d8                	mov    %ebx,%eax
  80035f:	83 f8 01             	cmp    $0x1,%eax
  800362:	74 16                	je     80037a <_main+0x342>
  800364:	68 14 27 80 00       	push   $0x802714
  800369:	68 7e 25 80 00       	push   $0x80257e
  80036e:	6a 49                	push   $0x49
  800370:	68 93 25 80 00       	push   $0x802593
  800375:	e8 09 08 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 4*Mega/PAGE_SIZE);
  80037a:	e8 0f 1b 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  80037f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	85 c0                	test   %eax,%eax
  80038c:	79 05                	jns    800393 <_main+0x35b>
  80038e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800393:	c1 f8 0c             	sar    $0xc,%eax
  800396:	39 c2                	cmp    %eax,%edx
  800398:	74 16                	je     8003b0 <_main+0x378>
  80039a:	68 48 27 80 00       	push   $0x802748
  80039f:	68 7e 25 80 00       	push   $0x80257e
  8003a4:	6a 4a                	push   $0x4a
  8003a6:	68 93 25 80 00       	push   $0x802593
  8003ab:	e8 d3 07 00 00       	call   800b83 <_panic>

		//Allocate 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8003b0:	e8 56 1a 00 00       	call   801e0b <sys_calculate_free_frames>
  8003b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003b8:	e8 d1 1a 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  8003bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 2*kilo;
  8003c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003c3:	01 c0                	add    %eax,%eax
  8003c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *y = malloc(sizeof(unsigned char)*size) ;
  8003c8:	83 ec 0c             	sub    $0xc,%esp
  8003cb:	ff 75 cc             	pushl  -0x34(%ebp)
  8003ce:	e8 dc 17 00 00       	call   801baf <malloc>
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		assert((uint32) y == USER_HEAP_START + 12*Mega);
  8003d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003dc:	89 d0                	mov    %edx,%eax
  8003de:	01 c0                	add    %eax,%eax
  8003e0:	01 d0                	add    %edx,%eax
  8003e2:	c1 e0 02             	shl    $0x2,%eax
  8003e5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8003eb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	74 16                	je     800408 <_main+0x3d0>
  8003f2:	68 bc 27 80 00       	push   $0x8027bc
  8003f7:	68 7e 25 80 00       	push   $0x80257e
  8003fc:	6a 53                	push   $0x53
  8003fe:	68 93 25 80 00       	push   $0x802593
  800403:	e8 7b 07 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 1);
  800408:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80040b:	e8 fb 19 00 00       	call   801e0b <sys_calculate_free_frames>
  800410:	29 c3                	sub    %eax,%ebx
  800412:	89 d8                	mov    %ebx,%eax
  800414:	83 f8 01             	cmp    $0x1,%eax
  800417:	74 16                	je     80042f <_main+0x3f7>
  800419:	68 a4 25 80 00       	push   $0x8025a4
  80041e:	68 7e 25 80 00       	push   $0x80257e
  800423:	6a 54                	push   $0x54
  800425:	68 93 25 80 00       	push   $0x802593
  80042a:	e8 54 07 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  80042f:	e8 5a 1a 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800434:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800437:	83 f8 01             	cmp    $0x1,%eax
  80043a:	74 16                	je     800452 <_main+0x41a>
  80043c:	68 e4 27 80 00       	push   $0x8027e4
  800441:	68 7e 25 80 00       	push   $0x80257e
  800446:	6a 55                	push   $0x55
  800448:	68 93 25 80 00       	push   $0x802593
  80044d:	e8 31 07 00 00       	call   800b83 <_panic>

		//Memory access
		freeFrames = sys_calculate_free_frames() ;
  800452:	e8 b4 19 00 00       	call   801e0b <sys_calculate_free_frames>
  800457:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80045a:	e8 2f 1a 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  80045f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		x[1]='A';
  800462:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800465:	40                   	inc    %eax
  800466:	c6 00 41             	movb   $0x41,(%eax)
		x[512*kilo]='B';
  800469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046c:	c1 e0 09             	shl    $0x9,%eax
  80046f:	89 c2                	mov    %eax,%edx
  800471:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800474:	01 d0                	add    %edx,%eax
  800476:	c6 00 42             	movb   $0x42,(%eax)
		x[1*Mega] = 'C' ;
  800479:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80047f:	01 d0                	add    %edx,%eax
  800481:	c6 00 43             	movb   $0x43,(%eax)
		x[8*Mega] = 'D';
  800484:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800487:	c1 e0 03             	shl    $0x3,%eax
  80048a:	89 c2                	mov    %eax,%edx
  80048c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80048f:	01 d0                	add    %edx,%eax
  800491:	c6 00 44             	movb   $0x44,(%eax)
		y[0] = 'E';
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	c6 00 45             	movb   $0x45,(%eax)

		assert(x[1]='A');
  80049a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80049d:	40                   	inc    %eax
  80049e:	c6 00 41             	movb   $0x41,(%eax)
		assert(x[512*kilo]='B');
  8004a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a4:	c1 e0 09             	shl    $0x9,%eax
  8004a7:	89 c2                	mov    %eax,%edx
  8004a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ac:	01 d0                	add    %edx,%eax
  8004ae:	c6 00 42             	movb   $0x42,(%eax)
		assert(x[1*Mega] == 'C' );
  8004b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8a 00                	mov    (%eax),%al
  8004bb:	3c 43                	cmp    $0x43,%al
  8004bd:	74 16                	je     8004d5 <_main+0x49d>
  8004bf:	68 1e 28 80 00       	push   $0x80281e
  8004c4:	68 7e 25 80 00       	push   $0x80257e
  8004c9:	6a 63                	push   $0x63
  8004cb:	68 93 25 80 00       	push   $0x802593
  8004d0:	e8 ae 06 00 00       	call   800b83 <_panic>
		assert(x[8*Mega] == 'D');
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	c1 e0 03             	shl    $0x3,%eax
  8004db:	89 c2                	mov    %eax,%edx
  8004dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e0:	01 d0                	add    %edx,%eax
  8004e2:	8a 00                	mov    (%eax),%al
  8004e4:	3c 44                	cmp    $0x44,%al
  8004e6:	74 16                	je     8004fe <_main+0x4c6>
  8004e8:	68 2f 28 80 00       	push   $0x80282f
  8004ed:	68 7e 25 80 00       	push   $0x80257e
  8004f2:	6a 64                	push   $0x64
  8004f4:	68 93 25 80 00       	push   $0x802593
  8004f9:	e8 85 06 00 00       	call   800b83 <_panic>
		assert(y[0] == 'E');
  8004fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800501:	8a 00                	mov    (%eax),%al
  800503:	3c 45                	cmp    $0x45,%al
  800505:	74 16                	je     80051d <_main+0x4e5>
  800507:	68 40 28 80 00       	push   $0x802840
  80050c:	68 7e 25 80 00       	push   $0x80257e
  800511:	6a 65                	push   $0x65
  800513:	68 93 25 80 00       	push   $0x802593
  800518:	e8 66 06 00 00       	call   800b83 <_panic>

		assert((freeFrames - sys_calculate_free_frames()) == 3 + 5);
  80051d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800520:	e8 e6 18 00 00       	call   801e0b <sys_calculate_free_frames>
  800525:	29 c3                	sub    %eax,%ebx
  800527:	89 d8                	mov    %ebx,%eax
  800529:	83 f8 08             	cmp    $0x8,%eax
  80052c:	74 16                	je     800544 <_main+0x50c>
  80052e:	68 4c 28 80 00       	push   $0x80284c
  800533:	68 7e 25 80 00       	push   $0x80257e
  800538:	6a 67                	push   $0x67
  80053a:	68 93 25 80 00       	push   $0x802593
  80053f:	e8 3f 06 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  800544:	e8 45 19 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800549:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054c:	74 16                	je     800564 <_main+0x52c>
  80054e:	68 80 28 80 00       	push   $0x802880
  800553:	68 7e 25 80 00       	push   $0x80257e
  800558:	6a 68                	push   $0x68
  80055a:	68 93 25 80 00       	push   $0x802593
  80055f:	e8 1f 06 00 00       	call   800b83 <_panic>

		//Free 2nd 1 MB
		int freeFrames = sys_calculate_free_frames() ;
  800564:	e8 a2 18 00 00       	call   801e0b <sys_calculate_free_frames>
  800569:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80056c:	e8 1d 19 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800571:	89 45 ac             	mov    %eax,-0x54(%ebp)
		free(t1);
  800574:	83 ec 0c             	sub    $0xc,%esp
  800577:	ff 75 c4             	pushl  -0x3c(%ebp)
  80057a:	e8 4a 16 00 00       	call   801bc9 <free>
  80057f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800582:	e8 07 19 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800587:	8b 55 ac             	mov    -0x54(%ebp),%edx
  80058a:	29 c2                	sub    %eax,%edx
  80058c:	89 d0                	mov    %edx,%eax
  80058e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800593:	74 14                	je     8005a9 <_main+0x571>
  800595:	83 ec 04             	sub    $0x4,%esp
  800598:	68 bc 28 80 00       	push   $0x8028bc
  80059d:	6a 6e                	push   $0x6e
  80059f:	68 93 25 80 00       	push   $0x802593
  8005a4:	e8 da 05 00 00       	call   800b83 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8005a9:	e8 5d 18 00 00       	call   801e0b <sys_calculate_free_frames>
  8005ae:	89 c2                	mov    %eax,%edx
  8005b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005b3:	29 c2                	sub    %eax,%edx
  8005b5:	89 d0                	mov    %edx,%eax
  8005b7:	83 f8 01             	cmp    $0x1,%eax
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 f8 28 80 00       	push   $0x8028f8
  8005c4:	6a 6f                	push   $0x6f
  8005c6:	68 93 25 80 00       	push   $0x802593
  8005cb:	e8 b3 05 00 00       	call   800b83 <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005d7:	eb 50                	jmp    800629 <_main+0x5f1>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(x[1*Mega])), PAGE_SIZE))
  8005d9:	a1 20 40 80 00       	mov    0x804020,%eax
  8005de:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005e7:	c1 e2 04             	shl    $0x4,%edx
  8005ea:	01 d0                	add    %edx,%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8005f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8005f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f9:	89 c1                	mov    %eax,%ecx
  8005fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800601:	01 d0                	add    %edx,%eax
  800603:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800606:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800609:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80060e:	39 c1                	cmp    %eax,%ecx
  800610:	75 14                	jne    800626 <_main+0x5ee>
				panic("free: page is not removed from WS");
  800612:	83 ec 04             	sub    $0x4,%esp
  800615:	68 44 29 80 00       	push   $0x802944
  80061a:	6a 74                	push   $0x74
  80061c:	68 93 25 80 00       	push   $0x802593
  800621:	e8 5d 05 00 00       	call   800b83 <_panic>
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(t1);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800626:	ff 45 f4             	incl   -0xc(%ebp)
  800629:	a1 20 40 80 00       	mov    0x804020,%eax
  80062e:	8b 50 74             	mov    0x74(%eax),%edx
  800631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800634:	39 c2                	cmp    %eax,%edx
  800636:	77 a1                	ja     8005d9 <_main+0x5a1>


		//Free the entire Heap

		{
			freeHeap();
  800638:	e8 48 16 00 00       	call   801c85 <freeHeap>

			//cprintf("diff = %d\n", origFreeFrames - sys_calculate_free_frames());

			assert((origFreeFrames - sys_calculate_free_frames()) == 4);
  80063d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800640:	e8 c6 17 00 00       	call   801e0b <sys_calculate_free_frames>
  800645:	29 c3                	sub    %eax,%ebx
  800647:	89 d8                	mov    %ebx,%eax
  800649:	83 f8 04             	cmp    $0x4,%eax
  80064c:	74 16                	je     800664 <_main+0x62c>
  80064e:	68 68 29 80 00       	push   $0x802968
  800653:	68 7e 25 80 00       	push   $0x80257e
  800658:	6a 7f                	push   $0x7f
  80065a:	68 93 25 80 00       	push   $0x802593
  80065f:	e8 1f 05 00 00       	call   800b83 <_panic>
			assert((sys_pf_calculate_allocated_pages() - origDiskPages) == 0);
  800664:	e8 25 18 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800669:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80066c:	74 19                	je     800687 <_main+0x64f>
  80066e:	68 9c 29 80 00       	push   $0x80299c
  800673:	68 7e 25 80 00       	push   $0x80257e
  800678:	68 80 00 00 00       	push   $0x80
  80067d:	68 93 25 80 00       	push   $0x802593
  800682:	e8 fc 04 00 00       	call   800b83 <_panic>

		//Check memory access after kfreeall
		{
			//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
			//and continue executing the remaining code
			sys_bypassPageFault(3);
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	6a 03                	push   $0x3
  80068c:	e8 91 1a 00 00       	call   802122 <sys_bypassPageFault>
  800691:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800694:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800697:	40                   	inc    %eax
  800698:	c6 00 ff             	movb   $0xff,(%eax)
			assert(sys_rcr2() == (uint32)&(x[1]));
  80069b:	e8 69 1a 00 00       	call   802109 <sys_rcr2>
  8006a0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006a3:	42                   	inc    %edx
  8006a4:	39 d0                	cmp    %edx,%eax
  8006a6:	74 19                	je     8006c1 <_main+0x689>
  8006a8:	68 d6 29 80 00       	push   $0x8029d6
  8006ad:	68 7e 25 80 00       	push   $0x80257e
  8006b2:	68 8a 00 00 00       	push   $0x8a
  8006b7:	68 93 25 80 00       	push   $0x802593
  8006bc:	e8 c2 04 00 00       	call   800b83 <_panic>

			x[8*Mega] = -1;
  8006c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c4:	c1 e0 03             	shl    $0x3,%eax
  8006c7:	89 c2                	mov    %eax,%edx
  8006c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006cc:	01 d0                	add    %edx,%eax
  8006ce:	c6 00 ff             	movb   $0xff,(%eax)
			assert(sys_rcr2() == (uint32)&(x[8*Mega]));
  8006d1:	e8 33 1a 00 00       	call   802109 <sys_rcr2>
  8006d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d9:	c1 e2 03             	shl    $0x3,%edx
  8006dc:	89 d1                	mov    %edx,%ecx
  8006de:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006e1:	01 ca                	add    %ecx,%edx
  8006e3:	39 d0                	cmp    %edx,%eax
  8006e5:	74 19                	je     800700 <_main+0x6c8>
  8006e7:	68 f4 29 80 00       	push   $0x8029f4
  8006ec:	68 7e 25 80 00       	push   $0x80257e
  8006f1:	68 8d 00 00 00       	push   $0x8d
  8006f6:	68 93 25 80 00       	push   $0x802593
  8006fb:	e8 83 04 00 00       	call   800b83 <_panic>

			x[512*kilo]=-1;
  800700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800703:	c1 e0 09             	shl    $0x9,%eax
  800706:	89 c2                	mov    %eax,%edx
  800708:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80070b:	01 d0                	add    %edx,%eax
  80070d:	c6 00 ff             	movb   $0xff,(%eax)
			assert(sys_rcr2() == (uint32)&(x[512*kilo]));
  800710:	e8 f4 19 00 00       	call   802109 <sys_rcr2>
  800715:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800718:	c1 e2 09             	shl    $0x9,%edx
  80071b:	89 d1                	mov    %edx,%ecx
  80071d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800720:	01 ca                	add    %ecx,%edx
  800722:	39 d0                	cmp    %edx,%eax
  800724:	74 19                	je     80073f <_main+0x707>
  800726:	68 18 2a 80 00       	push   $0x802a18
  80072b:	68 7e 25 80 00       	push   $0x80257e
  800730:	68 90 00 00 00       	push   $0x90
  800735:	68 93 25 80 00       	push   $0x802593
  80073a:	e8 44 04 00 00       	call   800b83 <_panic>

			y[0] = -1;
  80073f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800742:	c6 00 ff             	movb   $0xff,(%eax)
			assert(sys_rcr2() == (uint32)&(y[0]));
  800745:	e8 bf 19 00 00       	call   802109 <sys_rcr2>
  80074a:	89 c2                	mov    %eax,%edx
  80074c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80074f:	39 c2                	cmp    %eax,%edx
  800751:	74 19                	je     80076c <_main+0x734>
  800753:	68 3d 2a 80 00       	push   $0x802a3d
  800758:	68 7e 25 80 00       	push   $0x80257e
  80075d:	68 93 00 00 00       	push   $0x93
  800762:	68 93 25 80 00       	push   $0x802593
  800767:	e8 17 04 00 00       	call   800b83 <_panic>

			//set it to 0 again to cancel the bypassing option
			sys_bypassPageFault(0);
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	6a 00                	push   $0x0
  800771:	e8 ac 19 00 00       	call   802122 <sys_bypassPageFault>
  800776:	83 c4 10             	add    $0x10,%esp

		//Checking if freeHeap RESET the HEAP POINTER or not
		{

			//1 KB
			freeFrames = sys_calculate_free_frames() ;
  800779:	e8 8d 16 00 00       	call   801e0b <sys_calculate_free_frames>
  80077e:	89 45 b0             	mov    %eax,-0x50(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800781:	e8 08 17 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800786:	89 45 ac             	mov    %eax,-0x54(%ebp)

			unsigned char *w = malloc(sizeof(unsigned char)*kilo) ;
  800789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80078c:	83 ec 0c             	sub    $0xc,%esp
  80078f:	50                   	push   %eax
  800790:	e8 1a 14 00 00       	call   801baf <malloc>
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	89 45 a0             	mov    %eax,-0x60(%ebp)

			assert((uint32)w == USER_HEAP_START);
  80079b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80079e:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8007a3:	74 19                	je     8007be <_main+0x786>
  8007a5:	68 5b 2a 80 00       	push   $0x802a5b
  8007aa:	68 7e 25 80 00       	push   $0x80257e
  8007af:	68 a2 00 00 00       	push   $0xa2
  8007b4:	68 93 25 80 00       	push   $0x802593
  8007b9:	e8 c5 03 00 00       	call   800b83 <_panic>
			assert((freeFrames - sys_calculate_free_frames()) == 0);
  8007be:	e8 48 16 00 00       	call   801e0b <sys_calculate_free_frames>
  8007c3:	89 c2                	mov    %eax,%edx
  8007c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8007c8:	39 c2                	cmp    %eax,%edx
  8007ca:	74 19                	je     8007e5 <_main+0x7ad>
  8007cc:	68 48 26 80 00       	push   $0x802648
  8007d1:	68 7e 25 80 00       	push   $0x80257e
  8007d6:	68 a3 00 00 00       	push   $0xa3
  8007db:	68 93 25 80 00       	push   $0x802593
  8007e0:	e8 9e 03 00 00       	call   800b83 <_panic>
			assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  8007e5:	e8 a4 16 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  8007ea:	2b 45 ac             	sub    -0x54(%ebp),%eax
  8007ed:	83 f8 01             	cmp    $0x1,%eax
  8007f0:	74 19                	je     80080b <_main+0x7d3>
  8007f2:	68 e4 27 80 00       	push   $0x8027e4
  8007f7:	68 7e 25 80 00       	push   $0x80257e
  8007fc:	68 a4 00 00 00       	push   $0xa4
  800801:	68 93 25 80 00       	push   $0x802593
  800806:	e8 78 03 00 00       	call   800b83 <_panic>

			//1 B
			freeFrames = sys_calculate_free_frames() ;
  80080b:	e8 fb 15 00 00       	call   801e0b <sys_calculate_free_frames>
  800810:	89 45 b0             	mov    %eax,-0x50(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800813:	e8 76 16 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800818:	89 45 ac             	mov    %eax,-0x54(%ebp)

			unsigned char *f = malloc(sizeof(unsigned char)*1) ;
  80081b:	83 ec 0c             	sub    $0xc,%esp
  80081e:	6a 01                	push   $0x1
  800820:	e8 8a 13 00 00       	call   801baf <malloc>
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	89 45 9c             	mov    %eax,-0x64(%ebp)

			assert((uint32)f == USER_HEAP_START + PAGE_SIZE);
  80082b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80082e:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800833:	74 19                	je     80084e <_main+0x816>
  800835:	68 78 2a 80 00       	push   $0x802a78
  80083a:	68 7e 25 80 00       	push   $0x80257e
  80083f:	68 ac 00 00 00       	push   $0xac
  800844:	68 93 25 80 00       	push   $0x802593
  800849:	e8 35 03 00 00       	call   800b83 <_panic>
			assert((freeFrames - sys_calculate_free_frames()) == 0);
  80084e:	e8 b8 15 00 00       	call   801e0b <sys_calculate_free_frames>
  800853:	89 c2                	mov    %eax,%edx
  800855:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800858:	39 c2                	cmp    %eax,%edx
  80085a:	74 19                	je     800875 <_main+0x83d>
  80085c:	68 48 26 80 00       	push   $0x802648
  800861:	68 7e 25 80 00       	push   $0x80257e
  800866:	68 ad 00 00 00       	push   $0xad
  80086b:	68 93 25 80 00       	push   $0x802593
  800870:	e8 0e 03 00 00       	call   800b83 <_panic>
			assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  800875:	e8 14 16 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  80087a:	2b 45 ac             	sub    -0x54(%ebp),%eax
  80087d:	83 f8 01             	cmp    $0x1,%eax
  800880:	74 19                	je     80089b <_main+0x863>
  800882:	68 e4 27 80 00       	push   $0x8027e4
  800887:	68 7e 25 80 00       	push   $0x80257e
  80088c:	68 ae 00 00 00       	push   $0xae
  800891:	68 93 25 80 00       	push   $0x802593
  800896:	e8 e8 02 00 00       	call   800b83 <_panic>

			f[0] = -1;
  80089b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80089e:	c6 00 ff             	movb   $0xff,(%eax)

			//1 MB
			freeFrames = sys_calculate_free_frames() ;
  8008a1:	e8 65 15 00 00       	call   801e0b <sys_calculate_free_frames>
  8008a6:	89 45 b0             	mov    %eax,-0x50(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008a9:	e8 e0 15 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  8008ae:	89 45 ac             	mov    %eax,-0x54(%ebp)

			unsigned char *z = malloc(sizeof(unsigned char)*Mega) ;
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 0c             	sub    $0xc,%esp
  8008b7:	50                   	push   %eax
  8008b8:	e8 f2 12 00 00       	call   801baf <malloc>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	89 45 98             	mov    %eax,-0x68(%ebp)

			assert((uint32)z == USER_HEAP_START + 2*PAGE_SIZE);
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	3d 00 20 00 80       	cmp    $0x80002000,%eax
  8008cb:	74 19                	je     8008e6 <_main+0x8ae>
  8008cd:	68 a4 2a 80 00       	push   $0x802aa4
  8008d2:	68 7e 25 80 00       	push   $0x80257e
  8008d7:	68 b8 00 00 00       	push   $0xb8
  8008dc:	68 93 25 80 00       	push   $0x802593
  8008e1:	e8 9d 02 00 00       	call   800b83 <_panic>
			assert((freeFrames - sys_calculate_free_frames()) == 0);
  8008e6:	e8 20 15 00 00       	call   801e0b <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 19                	je     80090d <_main+0x8d5>
  8008f4:	68 48 26 80 00       	push   $0x802648
  8008f9:	68 7e 25 80 00       	push   $0x80257e
  8008fe:	68 b9 00 00 00       	push   $0xb9
  800903:	68 93 25 80 00       	push   $0x802593
  800908:	e8 76 02 00 00       	call   800b83 <_panic>
			assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == Mega/PAGE_SIZE);
  80090d:	e8 7c 15 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800912:	2b 45 ac             	sub    -0x54(%ebp),%eax
  800915:	89 c2                	mov    %eax,%edx
  800917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091a:	85 c0                	test   %eax,%eax
  80091c:	79 05                	jns    800923 <_main+0x8eb>
  80091e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800923:	c1 f8 0c             	sar    $0xc,%eax
  800926:	39 c2                	cmp    %eax,%edx
  800928:	74 19                	je     800943 <_main+0x90b>
  80092a:	68 d0 2a 80 00       	push   $0x802ad0
  80092f:	68 7e 25 80 00       	push   $0x80257e
  800934:	68 ba 00 00 00       	push   $0xba
  800939:	68 93 25 80 00       	push   $0x802593
  80093e:	e8 40 02 00 00       	call   800b83 <_panic>

			//Free 1 KB
			int freeFrames = sys_calculate_free_frames() ;
  800943:	e8 c3 14 00 00       	call   801e0b <sys_calculate_free_frames>
  800948:	89 45 94             	mov    %eax,-0x6c(%ebp)
			int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80094b:	e8 3e 15 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800950:	89 45 90             	mov    %eax,-0x70(%ebp)
			free(w);
  800953:	83 ec 0c             	sub    $0xc,%esp
  800956:	ff 75 a0             	pushl  -0x60(%ebp)
  800959:	e8 6b 12 00 00       	call   801bc9 <free>
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  800961:	e8 28 15 00 00       	call   801e8e <sys_pf_calculate_allocated_pages>
  800966:	8b 55 90             	mov    -0x70(%ebp),%edx
  800969:	29 c2                	sub    %eax,%edx
  80096b:	89 d0                	mov    %edx,%eax
  80096d:	83 f8 01             	cmp    $0x1,%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	83 ec 04             	sub    $0x4,%esp
  800975:	68 bc 28 80 00       	push   $0x8028bc
  80097a:	68 c0 00 00 00       	push   $0xc0
  80097f:	68 93 25 80 00       	push   $0x802593
  800984:	e8 fa 01 00 00       	call   800b83 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 0 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800989:	e8 7d 14 00 00       	call   801e0b <sys_calculate_free_frames>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	83 ec 04             	sub    $0x4,%esp
  80099a:	68 f8 28 80 00       	push   $0x8028f8
  80099f:	68 c1 00 00 00       	push   $0xc1
  8009a4:	68 93 25 80 00       	push   $0x802593
  8009a9:	e8 d5 01 00 00       	call   800b83 <_panic>
			int var;
			int found = 0;
  8009ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8009b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009bc:	eb 3e                	jmp    8009fc <_main+0x9c4>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(f[0])), PAGE_SIZE))
  8009be:	a1 20 40 80 00       	mov    0x804020,%eax
  8009c3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8009cc:	c1 e2 04             	shl    $0x4,%edx
  8009cf:	01 d0                	add    %edx,%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8009d6:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8009d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009de:	89 c2                	mov    %eax,%edx
  8009e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8009e3:	89 45 88             	mov    %eax,-0x78(%ebp)
  8009e6:	8b 45 88             	mov    -0x78(%ebp),%eax
  8009e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009ee:	39 c2                	cmp    %eax,%edx
  8009f0:	75 07                	jne    8009f9 <_main+0x9c1>
					found = 1;
  8009f2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			free(w);
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
			if ((sys_calculate_free_frames() - freeFrames) != 0 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
			int var;
			int found = 0;
			for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8009f9:	ff 45 f0             	incl   -0x10(%ebp)
  8009fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800a01:	8b 50 74             	mov    0x74(%eax),%edx
  800a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	77 b3                	ja     8009be <_main+0x986>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(f[0])), PAGE_SIZE))
					found = 1;
			}

			if (!found)
  800a0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a0f:	75 17                	jne    800a28 <_main+0x9f0>
				panic("free: variables are not removed correctly");
  800a11:	83 ec 04             	sub    $0x4,%esp
  800a14:	68 18 2b 80 00       	push   $0x802b18
  800a19:	68 cb 00 00 00       	push   $0xcb
  800a1e:	68 93 25 80 00       	push   $0x802593
  800a23:	e8 5b 01 00 00       	call   800b83 <_panic>

		}



		cprintf("Congratulations!! your modification is completed successfully.\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 44 2b 80 00       	push   $0x802b44
  800a30:	e8 f0 03 00 00       	call   800e25 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp

	}

	return;
  800a38:	90                   	nop
}
  800a39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a3c:	c9                   	leave  
  800a3d:	c3                   	ret    

00800a3e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800a44:	e8 f7 12 00 00       	call   801d40 <sys_getenvindex>
  800a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4f:	89 d0                	mov    %edx,%eax
  800a51:	c1 e0 03             	shl    $0x3,%eax
  800a54:	01 d0                	add    %edx,%eax
  800a56:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800a5d:	01 c8                	add    %ecx,%eax
  800a5f:	01 c0                	add    %eax,%eax
  800a61:	01 d0                	add    %edx,%eax
  800a63:	01 c0                	add    %eax,%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	89 c2                	mov    %eax,%edx
  800a69:	c1 e2 05             	shl    $0x5,%edx
  800a6c:	29 c2                	sub    %eax,%edx
  800a6e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800a7d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a82:	a1 20 40 80 00       	mov    0x804020,%eax
  800a87:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800a8d:	84 c0                	test   %al,%al
  800a8f:	74 0f                	je     800aa0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800a91:	a1 20 40 80 00       	mov    0x804020,%eax
  800a96:	05 40 3c 01 00       	add    $0x13c40,%eax
  800a9b:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800aa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa4:	7e 0a                	jle    800ab0 <libmain+0x72>
		binaryname = argv[0];
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	ff 75 08             	pushl  0x8(%ebp)
  800ab9:	e8 7a f5 ff ff       	call   800038 <_main>
  800abe:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800ac1:	e8 15 14 00 00       	call   801edb <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ac6:	83 ec 0c             	sub    $0xc,%esp
  800ac9:	68 9c 2b 80 00       	push   $0x802b9c
  800ace:	e8 52 03 00 00       	call   800e25 <cprintf>
  800ad3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ad6:	a1 20 40 80 00       	mov    0x804020,%eax
  800adb:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800ae1:	a1 20 40 80 00       	mov    0x804020,%eax
  800ae6:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800aec:	83 ec 04             	sub    $0x4,%esp
  800aef:	52                   	push   %edx
  800af0:	50                   	push   %eax
  800af1:	68 c4 2b 80 00       	push   $0x802bc4
  800af6:	e8 2a 03 00 00       	call   800e25 <cprintf>
  800afb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800afe:	a1 20 40 80 00       	mov    0x804020,%eax
  800b03:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800b09:	a1 20 40 80 00       	mov    0x804020,%eax
  800b0e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800b14:	83 ec 04             	sub    $0x4,%esp
  800b17:	52                   	push   %edx
  800b18:	50                   	push   %eax
  800b19:	68 ec 2b 80 00       	push   $0x802bec
  800b1e:	e8 02 03 00 00       	call   800e25 <cprintf>
  800b23:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800b26:	a1 20 40 80 00       	mov    0x804020,%eax
  800b2b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	50                   	push   %eax
  800b35:	68 2d 2c 80 00       	push   $0x802c2d
  800b3a:	e8 e6 02 00 00       	call   800e25 <cprintf>
  800b3f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800b42:	83 ec 0c             	sub    $0xc,%esp
  800b45:	68 9c 2b 80 00       	push   $0x802b9c
  800b4a:	e8 d6 02 00 00       	call   800e25 <cprintf>
  800b4f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800b52:	e8 9e 13 00 00       	call   801ef5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800b57:	e8 19 00 00 00       	call   800b75 <exit>
}
  800b5c:	90                   	nop
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800b65:	83 ec 0c             	sub    $0xc,%esp
  800b68:	6a 00                	push   $0x0
  800b6a:	e8 9d 11 00 00       	call   801d0c <sys_env_destroy>
  800b6f:	83 c4 10             	add    $0x10,%esp
}
  800b72:	90                   	nop
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <exit>:

void
exit(void)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800b7b:	e8 f2 11 00 00       	call   801d72 <sys_env_exit>
}
  800b80:	90                   	nop
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800b89:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8c:	83 c0 04             	add    $0x4,%eax
  800b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800b92:	a1 18 41 80 00       	mov    0x804118,%eax
  800b97:	85 c0                	test   %eax,%eax
  800b99:	74 16                	je     800bb1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800b9b:	a1 18 41 80 00       	mov    0x804118,%eax
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	50                   	push   %eax
  800ba4:	68 44 2c 80 00       	push   $0x802c44
  800ba9:	e8 77 02 00 00       	call   800e25 <cprintf>
  800bae:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800bb1:	a1 00 40 80 00       	mov    0x804000,%eax
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	50                   	push   %eax
  800bbd:	68 49 2c 80 00       	push   $0x802c49
  800bc2:	e8 5e 02 00 00       	call   800e25 <cprintf>
  800bc7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd3:	50                   	push   %eax
  800bd4:	e8 e1 01 00 00       	call   800dba <vcprintf>
  800bd9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	6a 00                	push   $0x0
  800be1:	68 65 2c 80 00       	push   $0x802c65
  800be6:	e8 cf 01 00 00       	call   800dba <vcprintf>
  800beb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800bee:	e8 82 ff ff ff       	call   800b75 <exit>

	// should not return here
	while (1) ;
  800bf3:	eb fe                	jmp    800bf3 <_panic+0x70>

00800bf5 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800bfb:	a1 20 40 80 00       	mov    0x804020,%eax
  800c00:	8b 50 74             	mov    0x74(%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	39 c2                	cmp    %eax,%edx
  800c08:	74 14                	je     800c1e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	68 68 2c 80 00       	push   $0x802c68
  800c12:	6a 26                	push   $0x26
  800c14:	68 b4 2c 80 00       	push   $0x802cb4
  800c19:	e8 65 ff ff ff       	call   800b83 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800c1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800c25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c2c:	e9 b6 00 00 00       	jmp    800ce7 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	85 c0                	test   %eax,%eax
  800c44:	75 08                	jne    800c4e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800c46:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800c49:	e9 96 00 00 00       	jmp    800ce4 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800c4e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800c5c:	eb 5d                	jmp    800cbb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800c5e:	a1 20 40 80 00       	mov    0x804020,%eax
  800c63:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800c69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c6c:	c1 e2 04             	shl    $0x4,%edx
  800c6f:	01 d0                	add    %edx,%eax
  800c71:	8a 40 04             	mov    0x4(%eax),%al
  800c74:	84 c0                	test   %al,%al
  800c76:	75 40                	jne    800cb8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c78:	a1 20 40 80 00       	mov    0x804020,%eax
  800c7d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800c83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c86:	c1 e2 04             	shl    $0x4,%edx
  800c89:	01 d0                	add    %edx,%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c98:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	01 c8                	add    %ecx,%eax
  800ca9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800cab:	39 c2                	cmp    %eax,%edx
  800cad:	75 09                	jne    800cb8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800caf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800cb6:	eb 12                	jmp    800cca <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cb8:	ff 45 e8             	incl   -0x18(%ebp)
  800cbb:	a1 20 40 80 00       	mov    0x804020,%eax
  800cc0:	8b 50 74             	mov    0x74(%eax),%edx
  800cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800cc6:	39 c2                	cmp    %eax,%edx
  800cc8:	77 94                	ja     800c5e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800cca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800cce:	75 14                	jne    800ce4 <CheckWSWithoutLastIndex+0xef>
			panic(
  800cd0:	83 ec 04             	sub    $0x4,%esp
  800cd3:	68 c0 2c 80 00       	push   $0x802cc0
  800cd8:	6a 3a                	push   $0x3a
  800cda:	68 b4 2c 80 00       	push   $0x802cb4
  800cdf:	e8 9f fe ff ff       	call   800b83 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ce4:	ff 45 f0             	incl   -0x10(%ebp)
  800ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ced:	0f 8c 3e ff ff ff    	jl     800c31 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800cf3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cfa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800d01:	eb 20                	jmp    800d23 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800d03:	a1 20 40 80 00       	mov    0x804020,%eax
  800d08:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d11:	c1 e2 04             	shl    $0x4,%edx
  800d14:	01 d0                	add    %edx,%eax
  800d16:	8a 40 04             	mov    0x4(%eax),%al
  800d19:	3c 01                	cmp    $0x1,%al
  800d1b:	75 03                	jne    800d20 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800d1d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d20:	ff 45 e0             	incl   -0x20(%ebp)
  800d23:	a1 20 40 80 00       	mov    0x804020,%eax
  800d28:	8b 50 74             	mov    0x74(%eax),%edx
  800d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d2e:	39 c2                	cmp    %eax,%edx
  800d30:	77 d1                	ja     800d03 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d35:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800d38:	74 14                	je     800d4e <CheckWSWithoutLastIndex+0x159>
		panic(
  800d3a:	83 ec 04             	sub    $0x4,%esp
  800d3d:	68 14 2d 80 00       	push   $0x802d14
  800d42:	6a 44                	push   $0x44
  800d44:	68 b4 2c 80 00       	push   $0x802cb4
  800d49:	e8 35 fe ff ff       	call   800b83 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800d4e:	90                   	nop
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	8d 48 01             	lea    0x1(%eax),%ecx
  800d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d62:	89 0a                	mov    %ecx,(%edx)
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	88 d1                	mov    %dl,%cl
  800d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8b 00                	mov    (%eax),%eax
  800d75:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d7a:	75 2c                	jne    800da8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800d7c:	a0 24 40 80 00       	mov    0x804024,%al
  800d81:	0f b6 c0             	movzbl %al,%eax
  800d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d87:	8b 12                	mov    (%edx),%edx
  800d89:	89 d1                	mov    %edx,%ecx
  800d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8e:	83 c2 08             	add    $0x8,%edx
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	50                   	push   %eax
  800d95:	51                   	push   %ecx
  800d96:	52                   	push   %edx
  800d97:	e8 2e 0f 00 00       	call   801cca <sys_cputs>
  800d9c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8b 40 04             	mov    0x4(%eax),%eax
  800dae:	8d 50 01             	lea    0x1(%eax),%edx
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	89 50 04             	mov    %edx,0x4(%eax)
}
  800db7:	90                   	nop
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800dc3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800dca:	00 00 00 
	b.cnt = 0;
  800dcd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800dd4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800dd7:	ff 75 0c             	pushl  0xc(%ebp)
  800dda:	ff 75 08             	pushl  0x8(%ebp)
  800ddd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 51 0d 80 00       	push   $0x800d51
  800de9:	e8 11 02 00 00       	call   800fff <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800df1:	a0 24 40 80 00       	mov    0x804024,%al
  800df6:	0f b6 c0             	movzbl %al,%eax
  800df9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800dff:	83 ec 04             	sub    $0x4,%esp
  800e02:	50                   	push   %eax
  800e03:	52                   	push   %edx
  800e04:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800e0a:	83 c0 08             	add    $0x8,%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 b7 0e 00 00       	call   801cca <sys_cputs>
  800e13:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800e16:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800e1d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <cprintf>:

int cprintf(const char *fmt, ...) {
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800e2b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800e32:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	83 ec 08             	sub    $0x8,%esp
  800e3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e41:	50                   	push   %eax
  800e42:	e8 73 ff ff ff       	call   800dba <vcprintf>
  800e47:	83 c4 10             	add    $0x10,%esp
  800e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800e58:	e8 7e 10 00 00       	call   801edb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800e5d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6c:	50                   	push   %eax
  800e6d:	e8 48 ff ff ff       	call   800dba <vcprintf>
  800e72:	83 c4 10             	add    $0x10,%esp
  800e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800e78:	e8 78 10 00 00       	call   801ef5 <sys_enable_interrupt>
	return cnt;
  800e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	53                   	push   %ebx
  800e86:	83 ec 14             	sub    $0x14,%esp
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e95:	8b 45 18             	mov    0x18(%ebp),%eax
  800e98:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ea0:	77 55                	ja     800ef7 <printnum+0x75>
  800ea2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ea5:	72 05                	jb     800eac <printnum+0x2a>
  800ea7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eaa:	77 4b                	ja     800ef7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800eac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800eaf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800eb2:	8b 45 18             	mov    0x18(%ebp),%eax
  800eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eba:	52                   	push   %edx
  800ebb:	50                   	push   %eax
  800ebc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ebf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ec2:	e8 35 14 00 00       	call   8022fc <__udivdi3>
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	ff 75 20             	pushl  0x20(%ebp)
  800ed0:	53                   	push   %ebx
  800ed1:	ff 75 18             	pushl  0x18(%ebp)
  800ed4:	52                   	push   %edx
  800ed5:	50                   	push   %eax
  800ed6:	ff 75 0c             	pushl  0xc(%ebp)
  800ed9:	ff 75 08             	pushl  0x8(%ebp)
  800edc:	e8 a1 ff ff ff       	call   800e82 <printnum>
  800ee1:	83 c4 20             	add    $0x20,%esp
  800ee4:	eb 1a                	jmp    800f00 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	ff 75 0c             	pushl  0xc(%ebp)
  800eec:	ff 75 20             	pushl  0x20(%ebp)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ef7:	ff 4d 1c             	decl   0x1c(%ebp)
  800efa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800efe:	7f e6                	jg     800ee6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800f00:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800f03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0e:	53                   	push   %ebx
  800f0f:	51                   	push   %ecx
  800f10:	52                   	push   %edx
  800f11:	50                   	push   %eax
  800f12:	e8 f5 14 00 00       	call   80240c <__umoddi3>
  800f17:	83 c4 10             	add    $0x10,%esp
  800f1a:	05 74 2f 80 00       	add    $0x802f74,%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	0f be c0             	movsbl %al,%eax
  800f24:	83 ec 08             	sub    $0x8,%esp
  800f27:	ff 75 0c             	pushl  0xc(%ebp)
  800f2a:	50                   	push   %eax
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	ff d0                	call   *%eax
  800f30:	83 c4 10             	add    $0x10,%esp
}
  800f33:	90                   	nop
  800f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f3c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f40:	7e 1c                	jle    800f5e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8b 00                	mov    (%eax),%eax
  800f47:	8d 50 08             	lea    0x8(%eax),%edx
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	89 10                	mov    %edx,(%eax)
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8b 00                	mov    (%eax),%eax
  800f54:	83 e8 08             	sub    $0x8,%eax
  800f57:	8b 50 04             	mov    0x4(%eax),%edx
  800f5a:	8b 00                	mov    (%eax),%eax
  800f5c:	eb 40                	jmp    800f9e <getuint+0x65>
	else if (lflag)
  800f5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f62:	74 1e                	je     800f82 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8b 00                	mov    (%eax),%eax
  800f69:	8d 50 04             	lea    0x4(%eax),%edx
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	89 10                	mov    %edx,(%eax)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8b 00                	mov    (%eax),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f80:	eb 1c                	jmp    800f9e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8b 00                	mov    (%eax),%eax
  800f87:	8d 50 04             	lea    0x4(%eax),%edx
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	89 10                	mov    %edx,(%eax)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8b 00                	mov    (%eax),%eax
  800f94:	83 e8 04             	sub    $0x4,%eax
  800f97:	8b 00                	mov    (%eax),%eax
  800f99:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800fa3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800fa7:	7e 1c                	jle    800fc5 <getint+0x25>
		return va_arg(*ap, long long);
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8b 00                	mov    (%eax),%eax
  800fae:	8d 50 08             	lea    0x8(%eax),%edx
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	89 10                	mov    %edx,(%eax)
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8b 00                	mov    (%eax),%eax
  800fbb:	83 e8 08             	sub    $0x8,%eax
  800fbe:	8b 50 04             	mov    0x4(%eax),%edx
  800fc1:	8b 00                	mov    (%eax),%eax
  800fc3:	eb 38                	jmp    800ffd <getint+0x5d>
	else if (lflag)
  800fc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc9:	74 1a                	je     800fe5 <getint+0x45>
		return va_arg(*ap, long);
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8b 00                	mov    (%eax),%eax
  800fd0:	8d 50 04             	lea    0x4(%eax),%edx
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	89 10                	mov    %edx,(%eax)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8b 00                	mov    (%eax),%eax
  800fdd:	83 e8 04             	sub    $0x4,%eax
  800fe0:	8b 00                	mov    (%eax),%eax
  800fe2:	99                   	cltd   
  800fe3:	eb 18                	jmp    800ffd <getint+0x5d>
	else
		return va_arg(*ap, int);
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8b 00                	mov    (%eax),%eax
  800fea:	8d 50 04             	lea    0x4(%eax),%edx
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	89 10                	mov    %edx,(%eax)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	83 e8 04             	sub    $0x4,%eax
  800ffa:	8b 00                	mov    (%eax),%eax
  800ffc:	99                   	cltd   
}
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801007:	eb 17                	jmp    801020 <vprintfmt+0x21>
			if (ch == '\0')
  801009:	85 db                	test   %ebx,%ebx
  80100b:	0f 84 af 03 00 00    	je     8013c0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801011:	83 ec 08             	sub    $0x8,%esp
  801014:	ff 75 0c             	pushl  0xc(%ebp)
  801017:	53                   	push   %ebx
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	ff d0                	call   *%eax
  80101d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801020:	8b 45 10             	mov    0x10(%ebp),%eax
  801023:	8d 50 01             	lea    0x1(%eax),%edx
  801026:	89 55 10             	mov    %edx,0x10(%ebp)
  801029:	8a 00                	mov    (%eax),%al
  80102b:	0f b6 d8             	movzbl %al,%ebx
  80102e:	83 fb 25             	cmp    $0x25,%ebx
  801031:	75 d6                	jne    801009 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801033:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801037:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80103e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801045:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80104c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	8d 50 01             	lea    0x1(%eax),%edx
  801059:	89 55 10             	mov    %edx,0x10(%ebp)
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	0f b6 d8             	movzbl %al,%ebx
  801061:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801064:	83 f8 55             	cmp    $0x55,%eax
  801067:	0f 87 2b 03 00 00    	ja     801398 <vprintfmt+0x399>
  80106d:	8b 04 85 98 2f 80 00 	mov    0x802f98(,%eax,4),%eax
  801074:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801076:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80107a:	eb d7                	jmp    801053 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80107c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801080:	eb d1                	jmp    801053 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801082:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801089:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80108c:	89 d0                	mov    %edx,%eax
  80108e:	c1 e0 02             	shl    $0x2,%eax
  801091:	01 d0                	add    %edx,%eax
  801093:	01 c0                	add    %eax,%eax
  801095:	01 d8                	add    %ebx,%eax
  801097:	83 e8 30             	sub    $0x30,%eax
  80109a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80109d:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8010a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8010a8:	7e 3e                	jle    8010e8 <vprintfmt+0xe9>
  8010aa:	83 fb 39             	cmp    $0x39,%ebx
  8010ad:	7f 39                	jg     8010e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8010af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8010b2:	eb d5                	jmp    801089 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	83 c0 04             	add    $0x4,%eax
  8010ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8010bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c0:	83 e8 04             	sub    $0x4,%eax
  8010c3:	8b 00                	mov    (%eax),%eax
  8010c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8010c8:	eb 1f                	jmp    8010e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8010ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ce:	79 83                	jns    801053 <vprintfmt+0x54>
				width = 0;
  8010d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8010d7:	e9 77 ff ff ff       	jmp    801053 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8010dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8010e3:	e9 6b ff ff ff       	jmp    801053 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8010e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	0f 89 60 ff ff ff    	jns    801053 <vprintfmt+0x54>
				width = precision, precision = -1;
  8010f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801100:	e9 4e ff ff ff       	jmp    801053 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801105:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801108:	e9 46 ff ff ff       	jmp    801053 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80110d:	8b 45 14             	mov    0x14(%ebp),%eax
  801110:	83 c0 04             	add    $0x4,%eax
  801113:	89 45 14             	mov    %eax,0x14(%ebp)
  801116:	8b 45 14             	mov    0x14(%ebp),%eax
  801119:	83 e8 04             	sub    $0x4,%eax
  80111c:	8b 00                	mov    (%eax),%eax
  80111e:	83 ec 08             	sub    $0x8,%esp
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	50                   	push   %eax
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	ff d0                	call   *%eax
  80112a:	83 c4 10             	add    $0x10,%esp
			break;
  80112d:	e9 89 02 00 00       	jmp    8013bb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801132:	8b 45 14             	mov    0x14(%ebp),%eax
  801135:	83 c0 04             	add    $0x4,%eax
  801138:	89 45 14             	mov    %eax,0x14(%ebp)
  80113b:	8b 45 14             	mov    0x14(%ebp),%eax
  80113e:	83 e8 04             	sub    $0x4,%eax
  801141:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801143:	85 db                	test   %ebx,%ebx
  801145:	79 02                	jns    801149 <vprintfmt+0x14a>
				err = -err;
  801147:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801149:	83 fb 64             	cmp    $0x64,%ebx
  80114c:	7f 0b                	jg     801159 <vprintfmt+0x15a>
  80114e:	8b 34 9d e0 2d 80 00 	mov    0x802de0(,%ebx,4),%esi
  801155:	85 f6                	test   %esi,%esi
  801157:	75 19                	jne    801172 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801159:	53                   	push   %ebx
  80115a:	68 85 2f 80 00       	push   $0x802f85
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	ff 75 08             	pushl  0x8(%ebp)
  801165:	e8 5e 02 00 00       	call   8013c8 <printfmt>
  80116a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80116d:	e9 49 02 00 00       	jmp    8013bb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801172:	56                   	push   %esi
  801173:	68 8e 2f 80 00       	push   $0x802f8e
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	ff 75 08             	pushl  0x8(%ebp)
  80117e:	e8 45 02 00 00       	call   8013c8 <printfmt>
  801183:	83 c4 10             	add    $0x10,%esp
			break;
  801186:	e9 30 02 00 00       	jmp    8013bb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80118b:	8b 45 14             	mov    0x14(%ebp),%eax
  80118e:	83 c0 04             	add    $0x4,%eax
  801191:	89 45 14             	mov    %eax,0x14(%ebp)
  801194:	8b 45 14             	mov    0x14(%ebp),%eax
  801197:	83 e8 04             	sub    $0x4,%eax
  80119a:	8b 30                	mov    (%eax),%esi
  80119c:	85 f6                	test   %esi,%esi
  80119e:	75 05                	jne    8011a5 <vprintfmt+0x1a6>
				p = "(null)";
  8011a0:	be 91 2f 80 00       	mov    $0x802f91,%esi
			if (width > 0 && padc != '-')
  8011a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a9:	7e 6d                	jle    801218 <vprintfmt+0x219>
  8011ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8011af:	74 67                	je     801218 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	50                   	push   %eax
  8011b8:	56                   	push   %esi
  8011b9:	e8 0c 03 00 00       	call   8014ca <strnlen>
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8011c4:	eb 16                	jmp    8011dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8011c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8011ca:	83 ec 08             	sub    $0x8,%esp
  8011cd:	ff 75 0c             	pushl  0xc(%ebp)
  8011d0:	50                   	push   %eax
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8011dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e0:	7f e4                	jg     8011c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011e2:	eb 34                	jmp    801218 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8011e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011e8:	74 1c                	je     801206 <vprintfmt+0x207>
  8011ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8011ed:	7e 05                	jle    8011f4 <vprintfmt+0x1f5>
  8011ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8011f2:	7e 12                	jle    801206 <vprintfmt+0x207>
					putch('?', putdat);
  8011f4:	83 ec 08             	sub    $0x8,%esp
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	6a 3f                	push   $0x3f
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	ff d0                	call   *%eax
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	eb 0f                	jmp    801215 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	ff 75 0c             	pushl  0xc(%ebp)
  80120c:	53                   	push   %ebx
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	ff d0                	call   *%eax
  801212:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801215:	ff 4d e4             	decl   -0x1c(%ebp)
  801218:	89 f0                	mov    %esi,%eax
  80121a:	8d 70 01             	lea    0x1(%eax),%esi
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f be d8             	movsbl %al,%ebx
  801222:	85 db                	test   %ebx,%ebx
  801224:	74 24                	je     80124a <vprintfmt+0x24b>
  801226:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80122a:	78 b8                	js     8011e4 <vprintfmt+0x1e5>
  80122c:	ff 4d e0             	decl   -0x20(%ebp)
  80122f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801233:	79 af                	jns    8011e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801235:	eb 13                	jmp    80124a <vprintfmt+0x24b>
				putch(' ', putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	6a 20                	push   $0x20
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	ff d0                	call   *%eax
  801244:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801247:	ff 4d e4             	decl   -0x1c(%ebp)
  80124a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80124e:	7f e7                	jg     801237 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801250:	e9 66 01 00 00       	jmp    8013bb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801255:	83 ec 08             	sub    $0x8,%esp
  801258:	ff 75 e8             	pushl  -0x18(%ebp)
  80125b:	8d 45 14             	lea    0x14(%ebp),%eax
  80125e:	50                   	push   %eax
  80125f:	e8 3c fd ff ff       	call   800fa0 <getint>
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801273:	85 d2                	test   %edx,%edx
  801275:	79 23                	jns    80129a <vprintfmt+0x29b>
				putch('-', putdat);
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	ff 75 0c             	pushl  0xc(%ebp)
  80127d:	6a 2d                	push   $0x2d
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	ff d0                	call   *%eax
  801284:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128d:	f7 d8                	neg    %eax
  80128f:	83 d2 00             	adc    $0x0,%edx
  801292:	f7 da                	neg    %edx
  801294:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801297:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80129a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8012a1:	e9 bc 00 00 00       	jmp    801362 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8012ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8012af:	50                   	push   %eax
  8012b0:	e8 84 fc ff ff       	call   800f39 <getuint>
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8012be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8012c5:	e9 98 00 00 00       	jmp    801362 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	6a 58                	push   $0x58
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	6a 58                	push   $0x58
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	ff d0                	call   *%eax
  8012e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8012ea:	83 ec 08             	sub    $0x8,%esp
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	6a 58                	push   $0x58
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	ff d0                	call   *%eax
  8012f7:	83 c4 10             	add    $0x10,%esp
			break;
  8012fa:	e9 bc 00 00 00       	jmp    8013bb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8012ff:	83 ec 08             	sub    $0x8,%esp
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	6a 30                	push   $0x30
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	ff d0                	call   *%eax
  80130c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80130f:	83 ec 08             	sub    $0x8,%esp
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	6a 78                	push   $0x78
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	ff d0                	call   *%eax
  80131c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80131f:	8b 45 14             	mov    0x14(%ebp),%eax
  801322:	83 c0 04             	add    $0x4,%eax
  801325:	89 45 14             	mov    %eax,0x14(%ebp)
  801328:	8b 45 14             	mov    0x14(%ebp),%eax
  80132b:	83 e8 04             	sub    $0x4,%eax
  80132e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801330:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80133a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801341:	eb 1f                	jmp    801362 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801343:	83 ec 08             	sub    $0x8,%esp
  801346:	ff 75 e8             	pushl  -0x18(%ebp)
  801349:	8d 45 14             	lea    0x14(%ebp),%eax
  80134c:	50                   	push   %eax
  80134d:	e8 e7 fb ff ff       	call   800f39 <getuint>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801358:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80135b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801362:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801366:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801369:	83 ec 04             	sub    $0x4,%esp
  80136c:	52                   	push   %edx
  80136d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801370:	50                   	push   %eax
  801371:	ff 75 f4             	pushl  -0xc(%ebp)
  801374:	ff 75 f0             	pushl  -0x10(%ebp)
  801377:	ff 75 0c             	pushl  0xc(%ebp)
  80137a:	ff 75 08             	pushl  0x8(%ebp)
  80137d:	e8 00 fb ff ff       	call   800e82 <printnum>
  801382:	83 c4 20             	add    $0x20,%esp
			break;
  801385:	eb 34                	jmp    8013bb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	ff 75 0c             	pushl  0xc(%ebp)
  80138d:	53                   	push   %ebx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	ff d0                	call   *%eax
  801393:	83 c4 10             	add    $0x10,%esp
			break;
  801396:	eb 23                	jmp    8013bb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801398:	83 ec 08             	sub    $0x8,%esp
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	6a 25                	push   $0x25
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	ff d0                	call   *%eax
  8013a5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013a8:	ff 4d 10             	decl   0x10(%ebp)
  8013ab:	eb 03                	jmp    8013b0 <vprintfmt+0x3b1>
  8013ad:	ff 4d 10             	decl   0x10(%ebp)
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	48                   	dec    %eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	3c 25                	cmp    $0x25,%al
  8013b8:	75 f3                	jne    8013ad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8013ba:	90                   	nop
		}
	}
  8013bb:	e9 47 fc ff ff       	jmp    801007 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8013c0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8013c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c4:	5b                   	pop    %ebx
  8013c5:	5e                   	pop    %esi
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8013ce:	8d 45 10             	lea    0x10(%ebp),%eax
  8013d1:	83 c0 04             	add    $0x4,%eax
  8013d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8013d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013da:	ff 75 f4             	pushl  -0xc(%ebp)
  8013dd:	50                   	push   %eax
  8013de:	ff 75 0c             	pushl  0xc(%ebp)
  8013e1:	ff 75 08             	pushl  0x8(%ebp)
  8013e4:	e8 16 fc ff ff       	call   800fff <vprintfmt>
  8013e9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8b 40 08             	mov    0x8(%eax),%eax
  8013f8:	8d 50 01             	lea    0x1(%eax),%edx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	8b 10                	mov    (%eax),%edx
  801406:	8b 45 0c             	mov    0xc(%ebp),%eax
  801409:	8b 40 04             	mov    0x4(%eax),%eax
  80140c:	39 c2                	cmp    %eax,%edx
  80140e:	73 12                	jae    801422 <sprintputch+0x33>
		*b->buf++ = ch;
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	8d 48 01             	lea    0x1(%eax),%ecx
  801418:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141b:	89 0a                	mov    %ecx,(%edx)
  80141d:	8b 55 08             	mov    0x8(%ebp),%edx
  801420:	88 10                	mov    %dl,(%eax)
}
  801422:	90                   	nop
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	8d 50 ff             	lea    -0x1(%eax),%edx
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	01 d0                	add    %edx,%eax
  80143c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80143f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801446:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144a:	74 06                	je     801452 <vsnprintf+0x2d>
  80144c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801450:	7f 07                	jg     801459 <vsnprintf+0x34>
		return -E_INVAL;
  801452:	b8 03 00 00 00       	mov    $0x3,%eax
  801457:	eb 20                	jmp    801479 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801459:	ff 75 14             	pushl  0x14(%ebp)
  80145c:	ff 75 10             	pushl  0x10(%ebp)
  80145f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	68 ef 13 80 00       	push   $0x8013ef
  801468:	e8 92 fb ff ff       	call   800fff <vprintfmt>
  80146d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801473:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801476:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801481:	8d 45 10             	lea    0x10(%ebp),%eax
  801484:	83 c0 04             	add    $0x4,%eax
  801487:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	ff 75 f4             	pushl  -0xc(%ebp)
  801490:	50                   	push   %eax
  801491:	ff 75 0c             	pushl  0xc(%ebp)
  801494:	ff 75 08             	pushl  0x8(%ebp)
  801497:	e8 89 ff ff ff       	call   801425 <vsnprintf>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8014a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b4:	eb 06                	jmp    8014bc <strlen+0x15>
		n++;
  8014b6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014b9:	ff 45 08             	incl   0x8(%ebp)
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	84 c0                	test   %al,%al
  8014c3:	75 f1                	jne    8014b6 <strlen+0xf>
		n++;
	return n;
  8014c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d7:	eb 09                	jmp    8014e2 <strnlen+0x18>
		n++;
  8014d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014dc:	ff 45 08             	incl   0x8(%ebp)
  8014df:	ff 4d 0c             	decl   0xc(%ebp)
  8014e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e6:	74 09                	je     8014f1 <strnlen+0x27>
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	84 c0                	test   %al,%al
  8014ef:	75 e8                	jne    8014d9 <strnlen+0xf>
		n++;
	return n;
  8014f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801502:	90                   	nop
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8d 50 01             	lea    0x1(%eax),%edx
  801509:	89 55 08             	mov    %edx,0x8(%ebp)
  80150c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801512:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801515:	8a 12                	mov    (%edx),%dl
  801517:	88 10                	mov    %dl,(%eax)
  801519:	8a 00                	mov    (%eax),%al
  80151b:	84 c0                	test   %al,%al
  80151d:	75 e4                	jne    801503 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80151f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801530:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801537:	eb 1f                	jmp    801558 <strncpy+0x34>
		*dst++ = *src;
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8d 50 01             	lea    0x1(%eax),%edx
  80153f:	89 55 08             	mov    %edx,0x8(%ebp)
  801542:	8b 55 0c             	mov    0xc(%ebp),%edx
  801545:	8a 12                	mov    (%edx),%dl
  801547:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	84 c0                	test   %al,%al
  801550:	74 03                	je     801555 <strncpy+0x31>
			src++;
  801552:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801555:	ff 45 fc             	incl   -0x4(%ebp)
  801558:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155e:	72 d9                	jb     801539 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801560:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801571:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801575:	74 30                	je     8015a7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801577:	eb 16                	jmp    80158f <strlcpy+0x2a>
			*dst++ = *src++;
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8d 50 01             	lea    0x1(%eax),%edx
  80157f:	89 55 08             	mov    %edx,0x8(%ebp)
  801582:	8b 55 0c             	mov    0xc(%ebp),%edx
  801585:	8d 4a 01             	lea    0x1(%edx),%ecx
  801588:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80158b:	8a 12                	mov    (%edx),%dl
  80158d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80158f:	ff 4d 10             	decl   0x10(%ebp)
  801592:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801596:	74 09                	je     8015a1 <strlcpy+0x3c>
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	8a 00                	mov    (%eax),%al
  80159d:	84 c0                	test   %al,%al
  80159f:	75 d8                	jne    801579 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8015aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ad:	29 c2                	sub    %eax,%edx
  8015af:	89 d0                	mov    %edx,%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015b6:	eb 06                	jmp    8015be <strcmp+0xb>
		p++, q++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
  8015bb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	84 c0                	test   %al,%al
  8015c5:	74 0e                	je     8015d5 <strcmp+0x22>
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 10                	mov    (%eax),%dl
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	38 c2                	cmp    %al,%dl
  8015d3:	74 e3                	je     8015b8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	0f b6 d0             	movzbl %al,%edx
  8015dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	0f b6 c0             	movzbl %al,%eax
  8015e5:	29 c2                	sub    %eax,%edx
  8015e7:	89 d0                	mov    %edx,%eax
}
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    

008015eb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015ee:	eb 09                	jmp    8015f9 <strncmp+0xe>
		n--, p++, q++;
  8015f0:	ff 4d 10             	decl   0x10(%ebp)
  8015f3:	ff 45 08             	incl   0x8(%ebp)
  8015f6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015fd:	74 17                	je     801616 <strncmp+0x2b>
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	8a 00                	mov    (%eax),%al
  801604:	84 c0                	test   %al,%al
  801606:	74 0e                	je     801616 <strncmp+0x2b>
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 10                	mov    (%eax),%dl
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	38 c2                	cmp    %al,%dl
  801614:	74 da                	je     8015f0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801616:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161a:	75 07                	jne    801623 <strncmp+0x38>
		return 0;
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	eb 14                	jmp    801637 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	0f b6 d0             	movzbl %al,%edx
  80162b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	0f b6 c0             	movzbl %al,%eax
  801633:	29 c2                	sub    %eax,%edx
  801635:	89 d0                	mov    %edx,%eax
}
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    

00801639 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801645:	eb 12                	jmp    801659 <strchr+0x20>
		if (*s == c)
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80164f:	75 05                	jne    801656 <strchr+0x1d>
			return (char *) s;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	eb 11                	jmp    801667 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801656:	ff 45 08             	incl   0x8(%ebp)
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8a 00                	mov    (%eax),%al
  80165e:	84 c0                	test   %al,%al
  801660:	75 e5                	jne    801647 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801662:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801672:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801675:	eb 0d                	jmp    801684 <strfind+0x1b>
		if (*s == c)
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8a 00                	mov    (%eax),%al
  80167c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80167f:	74 0e                	je     80168f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801681:	ff 45 08             	incl   0x8(%ebp)
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	84 c0                	test   %al,%al
  80168b:	75 ea                	jne    801677 <strfind+0xe>
  80168d:	eb 01                	jmp    801690 <strfind+0x27>
		if (*s == c)
			break;
  80168f:	90                   	nop
	return (char *) s;
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016a7:	eb 0e                	jmp    8016b7 <memset+0x22>
		*p++ = c;
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	8d 50 01             	lea    0x1(%eax),%edx
  8016af:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016b7:	ff 4d f8             	decl   -0x8(%ebp)
  8016ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016be:	79 e9                	jns    8016a9 <memset+0x14>
		*p++ = c;

	return v;
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016d7:	eb 16                	jmp    8016ef <memcpy+0x2a>
		*d++ = *s++;
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8d 50 01             	lea    0x1(%eax),%edx
  8016df:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016e8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016eb:	8a 12                	mov    (%edx),%dl
  8016ed:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8016ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	75 dd                	jne    8016d9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801713:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801719:	73 50                	jae    80176b <memmove+0x6a>
  80171b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171e:	8b 45 10             	mov    0x10(%ebp),%eax
  801721:	01 d0                	add    %edx,%eax
  801723:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801726:	76 43                	jbe    80176b <memmove+0x6a>
		s += n;
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801734:	eb 10                	jmp    801746 <memmove+0x45>
			*--d = *--s;
  801736:	ff 4d f8             	decl   -0x8(%ebp)
  801739:	ff 4d fc             	decl   -0x4(%ebp)
  80173c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173f:	8a 10                	mov    (%eax),%dl
  801741:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801744:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801746:	8b 45 10             	mov    0x10(%ebp),%eax
  801749:	8d 50 ff             	lea    -0x1(%eax),%edx
  80174c:	89 55 10             	mov    %edx,0x10(%ebp)
  80174f:	85 c0                	test   %eax,%eax
  801751:	75 e3                	jne    801736 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801753:	eb 23                	jmp    801778 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801755:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801758:	8d 50 01             	lea    0x1(%eax),%edx
  80175b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80175e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801761:	8d 4a 01             	lea    0x1(%edx),%ecx
  801764:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801767:	8a 12                	mov    (%edx),%dl
  801769:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801771:	89 55 10             	mov    %edx,0x10(%ebp)
  801774:	85 c0                	test   %eax,%eax
  801776:	75 dd                	jne    801755 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80178f:	eb 2a                	jmp    8017bb <memcmp+0x3e>
		if (*s1 != *s2)
  801791:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801794:	8a 10                	mov    (%eax),%dl
  801796:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	38 c2                	cmp    %al,%dl
  80179d:	74 16                	je     8017b5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	0f b6 d0             	movzbl %al,%edx
  8017a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	0f b6 c0             	movzbl %al,%eax
  8017af:	29 c2                	sub    %eax,%edx
  8017b1:	89 d0                	mov    %edx,%eax
  8017b3:	eb 18                	jmp    8017cd <memcmp+0x50>
		s1++, s2++;
  8017b5:	ff 45 fc             	incl   -0x4(%ebp)
  8017b8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	75 c9                	jne    801791 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017db:	01 d0                	add    %edx,%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017e0:	eb 15                	jmp    8017f7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 d0             	movzbl %al,%edx
  8017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ed:	0f b6 c0             	movzbl %al,%eax
  8017f0:	39 c2                	cmp    %eax,%edx
  8017f2:	74 0d                	je     801801 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017f4:	ff 45 08             	incl   0x8(%ebp)
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017fd:	72 e3                	jb     8017e2 <memfind+0x13>
  8017ff:	eb 01                	jmp    801802 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801801:	90                   	nop
	return (void *) s;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80180d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801814:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80181b:	eb 03                	jmp    801820 <strtol+0x19>
		s++;
  80181d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	3c 20                	cmp    $0x20,%al
  801827:	74 f4                	je     80181d <strtol+0x16>
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	3c 09                	cmp    $0x9,%al
  801830:	74 eb                	je     80181d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	8a 00                	mov    (%eax),%al
  801837:	3c 2b                	cmp    $0x2b,%al
  801839:	75 05                	jne    801840 <strtol+0x39>
		s++;
  80183b:	ff 45 08             	incl   0x8(%ebp)
  80183e:	eb 13                	jmp    801853 <strtol+0x4c>
	else if (*s == '-')
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	3c 2d                	cmp    $0x2d,%al
  801847:	75 0a                	jne    801853 <strtol+0x4c>
		s++, neg = 1;
  801849:	ff 45 08             	incl   0x8(%ebp)
  80184c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801853:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801857:	74 06                	je     80185f <strtol+0x58>
  801859:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80185d:	75 20                	jne    80187f <strtol+0x78>
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 30                	cmp    $0x30,%al
  801866:	75 17                	jne    80187f <strtol+0x78>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	40                   	inc    %eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 78                	cmp    $0x78,%al
  801870:	75 0d                	jne    80187f <strtol+0x78>
		s += 2, base = 16;
  801872:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801876:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80187d:	eb 28                	jmp    8018a7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80187f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801883:	75 15                	jne    80189a <strtol+0x93>
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8a 00                	mov    (%eax),%al
  80188a:	3c 30                	cmp    $0x30,%al
  80188c:	75 0c                	jne    80189a <strtol+0x93>
		s++, base = 8;
  80188e:	ff 45 08             	incl   0x8(%ebp)
  801891:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801898:	eb 0d                	jmp    8018a7 <strtol+0xa0>
	else if (base == 0)
  80189a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189e:	75 07                	jne    8018a7 <strtol+0xa0>
		base = 10;
  8018a0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	3c 2f                	cmp    $0x2f,%al
  8018ae:	7e 19                	jle    8018c9 <strtol+0xc2>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	3c 39                	cmp    $0x39,%al
  8018b7:	7f 10                	jg     8018c9 <strtol+0xc2>
			dig = *s - '0';
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	8a 00                	mov    (%eax),%al
  8018be:	0f be c0             	movsbl %al,%eax
  8018c1:	83 e8 30             	sub    $0x30,%eax
  8018c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c7:	eb 42                	jmp    80190b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3c 60                	cmp    $0x60,%al
  8018d0:	7e 19                	jle    8018eb <strtol+0xe4>
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	8a 00                	mov    (%eax),%al
  8018d7:	3c 7a                	cmp    $0x7a,%al
  8018d9:	7f 10                	jg     8018eb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	0f be c0             	movsbl %al,%eax
  8018e3:	83 e8 57             	sub    $0x57,%eax
  8018e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018e9:	eb 20                	jmp    80190b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8a 00                	mov    (%eax),%al
  8018f0:	3c 40                	cmp    $0x40,%al
  8018f2:	7e 39                	jle    80192d <strtol+0x126>
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8a 00                	mov    (%eax),%al
  8018f9:	3c 5a                	cmp    $0x5a,%al
  8018fb:	7f 30                	jg     80192d <strtol+0x126>
			dig = *s - 'A' + 10;
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8a 00                	mov    (%eax),%al
  801902:	0f be c0             	movsbl %al,%eax
  801905:	83 e8 37             	sub    $0x37,%eax
  801908:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801911:	7d 19                	jge    80192c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801913:	ff 45 08             	incl   0x8(%ebp)
  801916:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801919:	0f af 45 10          	imul   0x10(%ebp),%eax
  80191d:	89 c2                	mov    %eax,%edx
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801927:	e9 7b ff ff ff       	jmp    8018a7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80192c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80192d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801931:	74 08                	je     80193b <strtol+0x134>
		*endptr = (char *) s;
  801933:	8b 45 0c             	mov    0xc(%ebp),%eax
  801936:	8b 55 08             	mov    0x8(%ebp),%edx
  801939:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80193b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80193f:	74 07                	je     801948 <strtol+0x141>
  801941:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801944:	f7 d8                	neg    %eax
  801946:	eb 03                	jmp    80194b <strtol+0x144>
  801948:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <ltostr>:

void
ltostr(long value, char *str)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801953:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80195a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801961:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801965:	79 13                	jns    80197a <ltostr+0x2d>
	{
		neg = 1;
  801967:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801974:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801977:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801982:	99                   	cltd   
  801983:	f7 f9                	idiv   %ecx
  801985:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801988:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80198b:	8d 50 01             	lea    0x1(%eax),%edx
  80198e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801991:	89 c2                	mov    %eax,%edx
  801993:	8b 45 0c             	mov    0xc(%ebp),%eax
  801996:	01 d0                	add    %edx,%eax
  801998:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80199b:	83 c2 30             	add    $0x30,%edx
  80199e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019a8:	f7 e9                	imul   %ecx
  8019aa:	c1 fa 02             	sar    $0x2,%edx
  8019ad:	89 c8                	mov    %ecx,%eax
  8019af:	c1 f8 1f             	sar    $0x1f,%eax
  8019b2:	29 c2                	sub    %eax,%edx
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019c1:	f7 e9                	imul   %ecx
  8019c3:	c1 fa 02             	sar    $0x2,%edx
  8019c6:	89 c8                	mov    %ecx,%eax
  8019c8:	c1 f8 1f             	sar    $0x1f,%eax
  8019cb:	29 c2                	sub    %eax,%edx
  8019cd:	89 d0                	mov    %edx,%eax
  8019cf:	c1 e0 02             	shl    $0x2,%eax
  8019d2:	01 d0                	add    %edx,%eax
  8019d4:	01 c0                	add    %eax,%eax
  8019d6:	29 c1                	sub    %eax,%ecx
  8019d8:	89 ca                	mov    %ecx,%edx
  8019da:	85 d2                	test   %edx,%edx
  8019dc:	75 9c                	jne    80197a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019e8:	48                   	dec    %eax
  8019e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019f0:	74 3d                	je     801a2f <ltostr+0xe2>
		start = 1 ;
  8019f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019f9:	eb 34                	jmp    801a2f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8019fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a01:	01 d0                	add    %edx,%eax
  801a03:	8a 00                	mov    (%eax),%al
  801a05:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	01 c2                	add    %eax,%edx
  801a10:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a16:	01 c8                	add    %ecx,%eax
  801a18:	8a 00                	mov    (%eax),%al
  801a1a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a22:	01 c2                	add    %eax,%edx
  801a24:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a27:	88 02                	mov    %al,(%edx)
		start++ ;
  801a29:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a2c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a35:	7c c4                	jl     8019fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a37:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	01 d0                	add    %edx,%eax
  801a3f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a42:	90                   	nop
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a4b:	ff 75 08             	pushl  0x8(%ebp)
  801a4e:	e8 54 fa ff ff       	call   8014a7 <strlen>
  801a53:	83 c4 04             	add    $0x4,%esp
  801a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	e8 46 fa ff ff       	call   8014a7 <strlen>
  801a61:	83 c4 04             	add    $0x4,%esp
  801a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a75:	eb 17                	jmp    801a8e <strcconcat+0x49>
		final[s] = str1[s] ;
  801a77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7d:	01 c2                	add    %eax,%edx
  801a7f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	01 c8                	add    %ecx,%eax
  801a87:	8a 00                	mov    (%eax),%al
  801a89:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a8b:	ff 45 fc             	incl   -0x4(%ebp)
  801a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a91:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a94:	7c e1                	jl     801a77 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801aa4:	eb 1f                	jmp    801ac5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aaf:	89 c2                	mov    %eax,%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ac2:	ff 45 f8             	incl   -0x8(%ebp)
  801ac5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801acb:	7c d9                	jl     801aa6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801acd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad3:	01 d0                	add    %edx,%eax
  801ad5:	c6 00 00             	movb   $0x0,(%eax)
}
  801ad8:	90                   	nop
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ade:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aea:	8b 00                	mov    (%eax),%eax
  801aec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af3:	8b 45 10             	mov    0x10(%ebp),%eax
  801af6:	01 d0                	add    %edx,%eax
  801af8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801afe:	eb 0c                	jmp    801b0c <strsplit+0x31>
			*string++ = 0;
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8d 50 01             	lea    0x1(%eax),%edx
  801b06:	89 55 08             	mov    %edx,0x8(%ebp)
  801b09:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	8a 00                	mov    (%eax),%al
  801b11:	84 c0                	test   %al,%al
  801b13:	74 18                	je     801b2d <strsplit+0x52>
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	8a 00                	mov    (%eax),%al
  801b1a:	0f be c0             	movsbl %al,%eax
  801b1d:	50                   	push   %eax
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	e8 13 fb ff ff       	call   801639 <strchr>
  801b26:	83 c4 08             	add    $0x8,%esp
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	75 d3                	jne    801b00 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	8a 00                	mov    (%eax),%al
  801b32:	84 c0                	test   %al,%al
  801b34:	74 5a                	je     801b90 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b36:	8b 45 14             	mov    0x14(%ebp),%eax
  801b39:	8b 00                	mov    (%eax),%eax
  801b3b:	83 f8 0f             	cmp    $0xf,%eax
  801b3e:	75 07                	jne    801b47 <strsplit+0x6c>
		{
			return 0;
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
  801b45:	eb 66                	jmp    801bad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b47:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4a:	8b 00                	mov    (%eax),%eax
  801b4c:	8d 48 01             	lea    0x1(%eax),%ecx
  801b4f:	8b 55 14             	mov    0x14(%ebp),%edx
  801b52:	89 0a                	mov    %ecx,(%edx)
  801b54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5e:	01 c2                	add    %eax,%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b65:	eb 03                	jmp    801b6a <strsplit+0x8f>
			string++;
  801b67:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	8a 00                	mov    (%eax),%al
  801b6f:	84 c0                	test   %al,%al
  801b71:	74 8b                	je     801afe <strsplit+0x23>
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	8a 00                	mov    (%eax),%al
  801b78:	0f be c0             	movsbl %al,%eax
  801b7b:	50                   	push   %eax
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	e8 b5 fa ff ff       	call   801639 <strchr>
  801b84:	83 c4 08             	add    $0x8,%esp
  801b87:	85 c0                	test   %eax,%eax
  801b89:	74 dc                	je     801b67 <strsplit+0x8c>
			string++;
	}
  801b8b:	e9 6e ff ff ff       	jmp    801afe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b90:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	8b 00                	mov    (%eax),%eax
  801b96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba0:	01 d0                	add    %edx,%eax
  801ba2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ba8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <malloc>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
void* malloc(uint32 size)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	68 f0 30 80 00       	push   $0x8030f0
  801bbd:	6a 16                	push   $0x16
  801bbf:	68 15 31 80 00       	push   $0x803115
  801bc4:	e8 ba ef ff ff       	call   800b83 <_panic>

00801bc9 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	68 24 31 80 00       	push   $0x803124
  801bd7:	6a 2e                	push   $0x2e
  801bd9:	68 15 31 80 00       	push   $0x803115
  801bde:	e8 a0 ef ff ff       	call   800b83 <_panic>

00801be3 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 18             	sub    $0x18,%esp
  801be9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bec:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	68 48 31 80 00       	push   $0x803148
  801bf7:	6a 3b                	push   $0x3b
  801bf9:	68 15 31 80 00       	push   $0x803115
  801bfe:	e8 80 ef ff ff       	call   800b83 <_panic>

00801c03 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	68 48 31 80 00       	push   $0x803148
  801c11:	6a 41                	push   $0x41
  801c13:	68 15 31 80 00       	push   $0x803115
  801c18:	e8 66 ef ff ff       	call   800b83 <_panic>

00801c1d <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	68 48 31 80 00       	push   $0x803148
  801c2b:	6a 47                	push   $0x47
  801c2d:	68 15 31 80 00       	push   $0x803115
  801c32:	e8 4c ef ff ff       	call   800b83 <_panic>

00801c37 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c3d:	83 ec 04             	sub    $0x4,%esp
  801c40:	68 48 31 80 00       	push   $0x803148
  801c45:	6a 4c                	push   $0x4c
  801c47:	68 15 31 80 00       	push   $0x803115
  801c4c:	e8 32 ef ff ff       	call   800b83 <_panic>

00801c51 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	68 48 31 80 00       	push   $0x803148
  801c5f:	6a 52                	push   $0x52
  801c61:	68 15 31 80 00       	push   $0x803115
  801c66:	e8 18 ef ff ff       	call   800b83 <_panic>

00801c6b <shrink>:
}
void shrink(uint32 newSize)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	68 48 31 80 00       	push   $0x803148
  801c79:	6a 56                	push   $0x56
  801c7b:	68 15 31 80 00       	push   $0x803115
  801c80:	e8 fe ee ff ff       	call   800b83 <_panic>

00801c85 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	68 48 31 80 00       	push   $0x803148
  801c93:	6a 5b                	push   $0x5b
  801c95:	68 15 31 80 00       	push   $0x803115
  801c9a:	e8 e4 ee ff ff       	call   800b83 <_panic>

00801c9f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	57                   	push   %edi
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cb7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cba:	cd 30                	int    $0x30
  801cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	5b                   	pop    %ebx
  801cc6:	5e                   	pop    %esi
  801cc7:	5f                   	pop    %edi
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    

00801cca <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cd6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	52                   	push   %edx
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	50                   	push   %eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	e8 b2 ff ff ff       	call   801c9f <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	90                   	nop
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 01                	push   $0x1
  801d02:	e8 98 ff ff ff       	call   801c9f <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	50                   	push   %eax
  801d1b:	6a 05                	push   $0x5
  801d1d:	e8 7d ff ff ff       	call   801c9f <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 02                	push   $0x2
  801d36:	e8 64 ff ff ff       	call   801c9f <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 03                	push   $0x3
  801d4f:	e8 4b ff ff ff       	call   801c9f <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 04                	push   $0x4
  801d68:	e8 32 ff ff ff       	call   801c9f <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_env_exit>:


void sys_env_exit(void)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 06                	push   $0x6
  801d81:	e8 19 ff ff ff       	call   801c9f <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	90                   	nop
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 07                	push   $0x7
  801d9f:	e8 fb fe ff ff       	call   801c9f <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dae:	8b 75 18             	mov    0x18(%ebp),%esi
  801db1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
  801dbf:	51                   	push   %ecx
  801dc0:	52                   	push   %edx
  801dc1:	50                   	push   %eax
  801dc2:	6a 08                	push   $0x8
  801dc4:	e8 d6 fe ff ff       	call   801c9f <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	52                   	push   %edx
  801de3:	50                   	push   %eax
  801de4:	6a 09                	push   $0x9
  801de6:	e8 b4 fe ff ff       	call   801c9f <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	ff 75 0c             	pushl  0xc(%ebp)
  801dfc:	ff 75 08             	pushl  0x8(%ebp)
  801dff:	6a 0a                	push   $0xa
  801e01:	e8 99 fe ff ff       	call   801c9f <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 0b                	push   $0xb
  801e1a:	e8 80 fe ff ff       	call   801c9f <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 0c                	push   $0xc
  801e33:	e8 67 fe ff ff       	call   801c9f <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 0d                	push   $0xd
  801e4c:	e8 4e fe ff ff       	call   801c9f <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	ff 75 08             	pushl  0x8(%ebp)
  801e65:	6a 11                	push   $0x11
  801e67:	e8 33 fe ff ff       	call   801c9f <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
	return;
  801e6f:	90                   	nop
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	ff 75 0c             	pushl  0xc(%ebp)
  801e7e:	ff 75 08             	pushl  0x8(%ebp)
  801e81:	6a 12                	push   $0x12
  801e83:	e8 17 fe ff ff       	call   801c9f <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8b:	90                   	nop
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 0e                	push   $0xe
  801e9d:	e8 fd fd ff ff       	call   801c9f <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	6a 0f                	push   $0xf
  801eb7:	e8 e3 fd ff ff       	call   801c9f <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 10                	push   $0x10
  801ed0:	e8 ca fd ff ff       	call   801c9f <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	90                   	nop
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 14                	push   $0x14
  801eea:	e8 b0 fd ff ff       	call   801c9f <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
}
  801ef2:	90                   	nop
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 15                	push   $0x15
  801f04:	e8 96 fd ff ff       	call   801c9f <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	90                   	nop
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_cputc>:


void
sys_cputc(const char c)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	50                   	push   %eax
  801f28:	6a 16                	push   $0x16
  801f2a:	e8 70 fd ff ff       	call   801c9f <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	90                   	nop
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 17                	push   $0x17
  801f44:	e8 56 fd ff ff       	call   801c9f <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	90                   	nop
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	50                   	push   %eax
  801f5f:	6a 18                	push   $0x18
  801f61:	e8 39 fd ff ff       	call   801c9f <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	52                   	push   %edx
  801f7b:	50                   	push   %eax
  801f7c:	6a 1b                	push   $0x1b
  801f7e:	e8 1c fd ff ff       	call   801c9f <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	52                   	push   %edx
  801f98:	50                   	push   %eax
  801f99:	6a 19                	push   $0x19
  801f9b:	e8 ff fc ff ff       	call   801c9f <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	90                   	nop
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	52                   	push   %edx
  801fb6:	50                   	push   %eax
  801fb7:	6a 1a                	push   $0x1a
  801fb9:	e8 e1 fc ff ff       	call   801c9f <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	90                   	nop
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 04             	sub    $0x4,%esp
  801fca:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fd0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fd3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	6a 00                	push   $0x0
  801fdc:	51                   	push   %ecx
  801fdd:	52                   	push   %edx
  801fde:	ff 75 0c             	pushl  0xc(%ebp)
  801fe1:	50                   	push   %eax
  801fe2:	6a 1c                	push   $0x1c
  801fe4:	e8 b6 fc ff ff       	call   801c9f <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ff1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	52                   	push   %edx
  801ffe:	50                   	push   %eax
  801fff:	6a 1d                	push   $0x1d
  802001:	e8 99 fc ff ff       	call   801c9f <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80200e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802011:	8b 55 0c             	mov    0xc(%ebp),%edx
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	51                   	push   %ecx
  80201c:	52                   	push   %edx
  80201d:	50                   	push   %eax
  80201e:	6a 1e                	push   $0x1e
  802020:	e8 7a fc ff ff       	call   801c9f <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80202d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	52                   	push   %edx
  80203a:	50                   	push   %eax
  80203b:	6a 1f                	push   $0x1f
  80203d:	e8 5d fc ff ff       	call   801c9f <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 20                	push   $0x20
  802056:	e8 44 fc ff ff       	call   801c9f <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	6a 00                	push   $0x0
  802068:	ff 75 14             	pushl  0x14(%ebp)
  80206b:	ff 75 10             	pushl  0x10(%ebp)
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	50                   	push   %eax
  802072:	6a 21                	push   $0x21
  802074:	e8 26 fc ff ff       	call   801c9f <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	50                   	push   %eax
  80208d:	6a 22                	push   $0x22
  80208f:	e8 0b fc ff ff       	call   801c9f <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	90                   	nop
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	50                   	push   %eax
  8020a9:	6a 23                	push   $0x23
  8020ab:	e8 ef fb ff ff       	call   801c9f <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
}
  8020b3:	90                   	nop
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020bc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020bf:	8d 50 04             	lea    0x4(%eax),%edx
  8020c2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	52                   	push   %edx
  8020cc:	50                   	push   %eax
  8020cd:	6a 24                	push   $0x24
  8020cf:	e8 cb fb ff ff       	call   801c9f <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
	return result;
  8020d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020e0:	89 01                	mov    %eax,(%ecx)
  8020e2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	c9                   	leave  
  8020e9:	c2 04 00             	ret    $0x4

008020ec <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	ff 75 10             	pushl  0x10(%ebp)
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	6a 13                	push   $0x13
  8020fe:	e8 9c fb ff ff       	call   801c9f <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
	return ;
  802106:	90                   	nop
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_rcr2>:
uint32 sys_rcr2()
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 25                	push   $0x25
  802118:	e8 82 fb ff ff       	call   801c9f <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80212e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	50                   	push   %eax
  80213b:	6a 26                	push   $0x26
  80213d:	e8 5d fb ff ff       	call   801c9f <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
	return ;
  802145:	90                   	nop
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <rsttst>:
void rsttst()
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 28                	push   $0x28
  802157:	e8 43 fb ff ff       	call   801c9f <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
	return ;
  80215f:	90                   	nop
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	8b 45 14             	mov    0x14(%ebp),%eax
  80216b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80216e:	8b 55 18             	mov    0x18(%ebp),%edx
  802171:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802175:	52                   	push   %edx
  802176:	50                   	push   %eax
  802177:	ff 75 10             	pushl  0x10(%ebp)
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	ff 75 08             	pushl  0x8(%ebp)
  802180:	6a 27                	push   $0x27
  802182:	e8 18 fb ff ff       	call   801c9f <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
	return ;
  80218a:	90                   	nop
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <chktst>:
void chktst(uint32 n)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	ff 75 08             	pushl  0x8(%ebp)
  80219b:	6a 29                	push   $0x29
  80219d:	e8 fd fa ff ff       	call   801c9f <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a5:	90                   	nop
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <inctst>:

void inctst()
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 2a                	push   $0x2a
  8021b7:	e8 e3 fa ff ff       	call   801c9f <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021bf:	90                   	nop
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <gettst>:
uint32 gettst()
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 2b                	push   $0x2b
  8021d1:	e8 c9 fa ff ff       	call   801c9f <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 2c                	push   $0x2c
  8021ed:	e8 ad fa ff ff       	call   801c9f <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
  8021f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021f8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021fc:	75 07                	jne    802205 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802203:	eb 05                	jmp    80220a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 2c                	push   $0x2c
  80221e:	e8 7c fa ff ff       	call   801c9f <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
  802226:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802229:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80222d:	75 07                	jne    802236 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80222f:	b8 01 00 00 00       	mov    $0x1,%eax
  802234:	eb 05                	jmp    80223b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 2c                	push   $0x2c
  80224f:	e8 4b fa ff ff       	call   801c9f <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
  802257:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80225a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80225e:	75 07                	jne    802267 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802260:	b8 01 00 00 00       	mov    $0x1,%eax
  802265:	eb 05                	jmp    80226c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 2c                	push   $0x2c
  802280:	e8 1a fa ff ff       	call   801c9f <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
  802288:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80228b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80228f:	75 07                	jne    802298 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802291:	b8 01 00 00 00       	mov    $0x1,%eax
  802296:	eb 05                	jmp    80229d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	ff 75 08             	pushl  0x8(%ebp)
  8022ad:	6a 2d                	push   $0x2d
  8022af:	e8 eb f9 ff ff       	call   801c9f <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b7:	90                   	nop
}
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	6a 00                	push   $0x0
  8022cc:	53                   	push   %ebx
  8022cd:	51                   	push   %ecx
  8022ce:	52                   	push   %edx
  8022cf:	50                   	push   %eax
  8022d0:	6a 2e                	push   $0x2e
  8022d2:	e8 c8 f9 ff ff       	call   801c9f <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	52                   	push   %edx
  8022ef:	50                   	push   %eax
  8022f0:	6a 2f                	push   $0x2f
  8022f2:	e8 a8 f9 ff ff       	call   801c9f <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <__udivdi3>:
  8022fc:	55                   	push   %ebp
  8022fd:	57                   	push   %edi
  8022fe:	56                   	push   %esi
  8022ff:	53                   	push   %ebx
  802300:	83 ec 1c             	sub    $0x1c,%esp
  802303:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802307:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80230b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80230f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802313:	89 ca                	mov    %ecx,%edx
  802315:	89 f8                	mov    %edi,%eax
  802317:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80231b:	85 f6                	test   %esi,%esi
  80231d:	75 2d                	jne    80234c <__udivdi3+0x50>
  80231f:	39 cf                	cmp    %ecx,%edi
  802321:	77 65                	ja     802388 <__udivdi3+0x8c>
  802323:	89 fd                	mov    %edi,%ebp
  802325:	85 ff                	test   %edi,%edi
  802327:	75 0b                	jne    802334 <__udivdi3+0x38>
  802329:	b8 01 00 00 00       	mov    $0x1,%eax
  80232e:	31 d2                	xor    %edx,%edx
  802330:	f7 f7                	div    %edi
  802332:	89 c5                	mov    %eax,%ebp
  802334:	31 d2                	xor    %edx,%edx
  802336:	89 c8                	mov    %ecx,%eax
  802338:	f7 f5                	div    %ebp
  80233a:	89 c1                	mov    %eax,%ecx
  80233c:	89 d8                	mov    %ebx,%eax
  80233e:	f7 f5                	div    %ebp
  802340:	89 cf                	mov    %ecx,%edi
  802342:	89 fa                	mov    %edi,%edx
  802344:	83 c4 1c             	add    $0x1c,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5f                   	pop    %edi
  80234a:	5d                   	pop    %ebp
  80234b:	c3                   	ret    
  80234c:	39 ce                	cmp    %ecx,%esi
  80234e:	77 28                	ja     802378 <__udivdi3+0x7c>
  802350:	0f bd fe             	bsr    %esi,%edi
  802353:	83 f7 1f             	xor    $0x1f,%edi
  802356:	75 40                	jne    802398 <__udivdi3+0x9c>
  802358:	39 ce                	cmp    %ecx,%esi
  80235a:	72 0a                	jb     802366 <__udivdi3+0x6a>
  80235c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802360:	0f 87 9e 00 00 00    	ja     802404 <__udivdi3+0x108>
  802366:	b8 01 00 00 00       	mov    $0x1,%eax
  80236b:	89 fa                	mov    %edi,%edx
  80236d:	83 c4 1c             	add    $0x1c,%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	31 c0                	xor    %eax,%eax
  80237c:	89 fa                	mov    %edi,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	66 90                	xchg   %ax,%ax
  802388:	89 d8                	mov    %ebx,%eax
  80238a:	f7 f7                	div    %edi
  80238c:	31 ff                	xor    %edi,%edi
  80238e:	89 fa                	mov    %edi,%edx
  802390:	83 c4 1c             	add    $0x1c,%esp
  802393:	5b                   	pop    %ebx
  802394:	5e                   	pop    %esi
  802395:	5f                   	pop    %edi
  802396:	5d                   	pop    %ebp
  802397:	c3                   	ret    
  802398:	bd 20 00 00 00       	mov    $0x20,%ebp
  80239d:	89 eb                	mov    %ebp,%ebx
  80239f:	29 fb                	sub    %edi,%ebx
  8023a1:	89 f9                	mov    %edi,%ecx
  8023a3:	d3 e6                	shl    %cl,%esi
  8023a5:	89 c5                	mov    %eax,%ebp
  8023a7:	88 d9                	mov    %bl,%cl
  8023a9:	d3 ed                	shr    %cl,%ebp
  8023ab:	89 e9                	mov    %ebp,%ecx
  8023ad:	09 f1                	or     %esi,%ecx
  8023af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023b3:	89 f9                	mov    %edi,%ecx
  8023b5:	d3 e0                	shl    %cl,%eax
  8023b7:	89 c5                	mov    %eax,%ebp
  8023b9:	89 d6                	mov    %edx,%esi
  8023bb:	88 d9                	mov    %bl,%cl
  8023bd:	d3 ee                	shr    %cl,%esi
  8023bf:	89 f9                	mov    %edi,%ecx
  8023c1:	d3 e2                	shl    %cl,%edx
  8023c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023c7:	88 d9                	mov    %bl,%cl
  8023c9:	d3 e8                	shr    %cl,%eax
  8023cb:	09 c2                	or     %eax,%edx
  8023cd:	89 d0                	mov    %edx,%eax
  8023cf:	89 f2                	mov    %esi,%edx
  8023d1:	f7 74 24 0c          	divl   0xc(%esp)
  8023d5:	89 d6                	mov    %edx,%esi
  8023d7:	89 c3                	mov    %eax,%ebx
  8023d9:	f7 e5                	mul    %ebp
  8023db:	39 d6                	cmp    %edx,%esi
  8023dd:	72 19                	jb     8023f8 <__udivdi3+0xfc>
  8023df:	74 0b                	je     8023ec <__udivdi3+0xf0>
  8023e1:	89 d8                	mov    %ebx,%eax
  8023e3:	31 ff                	xor    %edi,%edi
  8023e5:	e9 58 ff ff ff       	jmp    802342 <__udivdi3+0x46>
  8023ea:	66 90                	xchg   %ax,%ax
  8023ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023f0:	89 f9                	mov    %edi,%ecx
  8023f2:	d3 e2                	shl    %cl,%edx
  8023f4:	39 c2                	cmp    %eax,%edx
  8023f6:	73 e9                	jae    8023e1 <__udivdi3+0xe5>
  8023f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023fb:	31 ff                	xor    %edi,%edi
  8023fd:	e9 40 ff ff ff       	jmp    802342 <__udivdi3+0x46>
  802402:	66 90                	xchg   %ax,%ax
  802404:	31 c0                	xor    %eax,%eax
  802406:	e9 37 ff ff ff       	jmp    802342 <__udivdi3+0x46>
  80240b:	90                   	nop

0080240c <__umoddi3>:
  80240c:	55                   	push   %ebp
  80240d:	57                   	push   %edi
  80240e:	56                   	push   %esi
  80240f:	53                   	push   %ebx
  802410:	83 ec 1c             	sub    $0x1c,%esp
  802413:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802417:	8b 74 24 34          	mov    0x34(%esp),%esi
  80241b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80241f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802423:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802427:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80242b:	89 f3                	mov    %esi,%ebx
  80242d:	89 fa                	mov    %edi,%edx
  80242f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802433:	89 34 24             	mov    %esi,(%esp)
  802436:	85 c0                	test   %eax,%eax
  802438:	75 1a                	jne    802454 <__umoddi3+0x48>
  80243a:	39 f7                	cmp    %esi,%edi
  80243c:	0f 86 a2 00 00 00    	jbe    8024e4 <__umoddi3+0xd8>
  802442:	89 c8                	mov    %ecx,%eax
  802444:	89 f2                	mov    %esi,%edx
  802446:	f7 f7                	div    %edi
  802448:	89 d0                	mov    %edx,%eax
  80244a:	31 d2                	xor    %edx,%edx
  80244c:	83 c4 1c             	add    $0x1c,%esp
  80244f:	5b                   	pop    %ebx
  802450:	5e                   	pop    %esi
  802451:	5f                   	pop    %edi
  802452:	5d                   	pop    %ebp
  802453:	c3                   	ret    
  802454:	39 f0                	cmp    %esi,%eax
  802456:	0f 87 ac 00 00 00    	ja     802508 <__umoddi3+0xfc>
  80245c:	0f bd e8             	bsr    %eax,%ebp
  80245f:	83 f5 1f             	xor    $0x1f,%ebp
  802462:	0f 84 ac 00 00 00    	je     802514 <__umoddi3+0x108>
  802468:	bf 20 00 00 00       	mov    $0x20,%edi
  80246d:	29 ef                	sub    %ebp,%edi
  80246f:	89 fe                	mov    %edi,%esi
  802471:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802475:	89 e9                	mov    %ebp,%ecx
  802477:	d3 e0                	shl    %cl,%eax
  802479:	89 d7                	mov    %edx,%edi
  80247b:	89 f1                	mov    %esi,%ecx
  80247d:	d3 ef                	shr    %cl,%edi
  80247f:	09 c7                	or     %eax,%edi
  802481:	89 e9                	mov    %ebp,%ecx
  802483:	d3 e2                	shl    %cl,%edx
  802485:	89 14 24             	mov    %edx,(%esp)
  802488:	89 d8                	mov    %ebx,%eax
  80248a:	d3 e0                	shl    %cl,%eax
  80248c:	89 c2                	mov    %eax,%edx
  80248e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802492:	d3 e0                	shl    %cl,%eax
  802494:	89 44 24 04          	mov    %eax,0x4(%esp)
  802498:	8b 44 24 08          	mov    0x8(%esp),%eax
  80249c:	89 f1                	mov    %esi,%ecx
  80249e:	d3 e8                	shr    %cl,%eax
  8024a0:	09 d0                	or     %edx,%eax
  8024a2:	d3 eb                	shr    %cl,%ebx
  8024a4:	89 da                	mov    %ebx,%edx
  8024a6:	f7 f7                	div    %edi
  8024a8:	89 d3                	mov    %edx,%ebx
  8024aa:	f7 24 24             	mull   (%esp)
  8024ad:	89 c6                	mov    %eax,%esi
  8024af:	89 d1                	mov    %edx,%ecx
  8024b1:	39 d3                	cmp    %edx,%ebx
  8024b3:	0f 82 87 00 00 00    	jb     802540 <__umoddi3+0x134>
  8024b9:	0f 84 91 00 00 00    	je     802550 <__umoddi3+0x144>
  8024bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024c3:	29 f2                	sub    %esi,%edx
  8024c5:	19 cb                	sbb    %ecx,%ebx
  8024c7:	89 d8                	mov    %ebx,%eax
  8024c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024cd:	d3 e0                	shl    %cl,%eax
  8024cf:	89 e9                	mov    %ebp,%ecx
  8024d1:	d3 ea                	shr    %cl,%edx
  8024d3:	09 d0                	or     %edx,%eax
  8024d5:	89 e9                	mov    %ebp,%ecx
  8024d7:	d3 eb                	shr    %cl,%ebx
  8024d9:	89 da                	mov    %ebx,%edx
  8024db:	83 c4 1c             	add    $0x1c,%esp
  8024de:	5b                   	pop    %ebx
  8024df:	5e                   	pop    %esi
  8024e0:	5f                   	pop    %edi
  8024e1:	5d                   	pop    %ebp
  8024e2:	c3                   	ret    
  8024e3:	90                   	nop
  8024e4:	89 fd                	mov    %edi,%ebp
  8024e6:	85 ff                	test   %edi,%edi
  8024e8:	75 0b                	jne    8024f5 <__umoddi3+0xe9>
  8024ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ef:	31 d2                	xor    %edx,%edx
  8024f1:	f7 f7                	div    %edi
  8024f3:	89 c5                	mov    %eax,%ebp
  8024f5:	89 f0                	mov    %esi,%eax
  8024f7:	31 d2                	xor    %edx,%edx
  8024f9:	f7 f5                	div    %ebp
  8024fb:	89 c8                	mov    %ecx,%eax
  8024fd:	f7 f5                	div    %ebp
  8024ff:	89 d0                	mov    %edx,%eax
  802501:	e9 44 ff ff ff       	jmp    80244a <__umoddi3+0x3e>
  802506:	66 90                	xchg   %ax,%ax
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	89 f2                	mov    %esi,%edx
  80250c:	83 c4 1c             	add    $0x1c,%esp
  80250f:	5b                   	pop    %ebx
  802510:	5e                   	pop    %esi
  802511:	5f                   	pop    %edi
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    
  802514:	3b 04 24             	cmp    (%esp),%eax
  802517:	72 06                	jb     80251f <__umoddi3+0x113>
  802519:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80251d:	77 0f                	ja     80252e <__umoddi3+0x122>
  80251f:	89 f2                	mov    %esi,%edx
  802521:	29 f9                	sub    %edi,%ecx
  802523:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802527:	89 14 24             	mov    %edx,(%esp)
  80252a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80252e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802532:	8b 14 24             	mov    (%esp),%edx
  802535:	83 c4 1c             	add    $0x1c,%esp
  802538:	5b                   	pop    %ebx
  802539:	5e                   	pop    %esi
  80253a:	5f                   	pop    %edi
  80253b:	5d                   	pop    %ebp
  80253c:	c3                   	ret    
  80253d:	8d 76 00             	lea    0x0(%esi),%esi
  802540:	2b 04 24             	sub    (%esp),%eax
  802543:	19 fa                	sbb    %edi,%edx
  802545:	89 d1                	mov    %edx,%ecx
  802547:	89 c6                	mov    %eax,%esi
  802549:	e9 71 ff ff ff       	jmp    8024bf <__umoddi3+0xb3>
  80254e:	66 90                	xchg   %ax,%ax
  802550:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802554:	72 ea                	jb     802540 <__umoddi3+0x134>
  802556:	89 d9                	mov    %ebx,%ecx
  802558:	e9 62 ff ff ff       	jmp    8024bf <__umoddi3+0xb3>
