
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 57 05 00 00       	call   80058d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	c1 e2 04             	shl    $0x4,%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8a 40 04             	mov    0x4(%eax),%al
  800062:	84 c0                	test   %al,%al
  800064:	74 06                	je     80006c <_main+0x34>
			{
				fullWS = 0;
  800066:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006a:	eb 12                	jmp    80007e <_main+0x46>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006c:	ff 45 f0             	incl   -0x10(%ebp)
  80006f:	a1 20 30 80 00       	mov    0x803020,%eax
  800074:	8b 50 74             	mov    0x74(%eax),%edx
  800077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	77 ce                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800082:	74 14                	je     800098 <_main+0x60>
  800084:	83 ec 04             	sub    $0x4,%esp
  800087:	68 c0 20 80 00       	push   $0x8020c0
  80008c:	6a 12                	push   $0x12
  80008e:	68 dc 20 80 00       	push   $0x8020dc
  800093:	e8 3a 06 00 00       	call   8006d2 <_panic>
	}

	cprintf("************************************************\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 f4 20 80 00       	push   $0x8020f4
  8000a0:	e8 cf 08 00 00       	call   800974 <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	68 28 21 80 00       	push   $0x802128
  8000b0:	e8 bf 08 00 00       	call   800974 <cprintf>
  8000b5:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 84 21 80 00       	push   $0x802184
  8000c0:	e8 af 08 00 00       	call   800974 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000c8:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000cf:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000d6:	e8 9b 17 00 00       	call   801876 <sys_getenvid>
  8000db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	68 b8 21 80 00       	push   $0x8021b8
  8000e6:	e8 89 08 00 00       	call   800974 <cprintf>
  8000eb:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000ee:	e8 67 18 00 00       	call   80195a <sys_calculate_free_frames>
  8000f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 01                	push   $0x1
  8000fb:	68 00 10 00 00       	push   $0x1000
  800100:	68 e7 21 80 00       	push   $0x8021e7
  800105:	e8 28 16 00 00       	call   801732 <smalloc>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800110:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 ec 21 80 00       	push   $0x8021ec
  800121:	6a 21                	push   $0x21
  800123:	68 dc 20 80 00       	push   $0x8020dc
  800128:	e8 a5 05 00 00       	call   8006d2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80012d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800130:	e8 25 18 00 00       	call   80195a <sys_calculate_free_frames>
  800135:	29 c3                	sub    %eax,%ebx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	83 f8 04             	cmp    $0x4,%eax
  80013c:	74 14                	je     800152 <_main+0x11a>
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	68 58 22 80 00       	push   $0x802258
  800146:	6a 22                	push   $0x22
  800148:	68 dc 20 80 00       	push   $0x8020dc
  80014d:	e8 80 05 00 00       	call   8006d2 <_panic>

		sfree(x);
  800152:	83 ec 0c             	sub    $0xc,%esp
  800155:	ff 75 dc             	pushl  -0x24(%ebp)
  800158:	e8 0f 16 00 00       	call   80176c <sfree>
  80015d:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800160:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800163:	e8 f2 17 00 00       	call   80195a <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	89 d8                	mov    %ebx,%eax
  80016c:	83 f8 02             	cmp    $0x2,%eax
  80016f:	75 14                	jne    800185 <_main+0x14d>
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 d8 22 80 00       	push   $0x8022d8
  800179:	6a 25                	push   $0x25
  80017b:	68 dc 20 80 00       	push   $0x8020dc
  800180:	e8 4d 05 00 00       	call   8006d2 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800185:	e8 d0 17 00 00       	call   80195a <sys_calculate_free_frames>
  80018a:	89 c2                	mov    %eax,%edx
  80018c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80018f:	39 c2                	cmp    %eax,%edx
  800191:	74 14                	je     8001a7 <_main+0x16f>
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	68 30 23 80 00       	push   $0x802330
  80019b:	6a 26                	push   $0x26
  80019d:	68 dc 20 80 00       	push   $0x8020dc
  8001a2:	e8 2b 05 00 00       	call   8006d2 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 60 23 80 00       	push   $0x802360
  8001af:	e8 c0 07 00 00       	call   800974 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 84 23 80 00       	push   $0x802384
  8001bf:	e8 b0 07 00 00       	call   800974 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001c7:	e8 8e 17 00 00       	call   80195a <sys_calculate_free_frames>
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 01                	push   $0x1
  8001d4:	68 00 10 00 00       	push   $0x1000
  8001d9:	68 b4 23 80 00       	push   $0x8023b4
  8001de:	e8 4f 15 00 00       	call   801732 <smalloc>
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	6a 01                	push   $0x1
  8001ee:	68 00 10 00 00       	push   $0x1000
  8001f3:	68 e7 21 80 00       	push   $0x8021e7
  8001f8:	e8 35 15 00 00       	call   801732 <smalloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800203:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 d8 22 80 00       	push   $0x8022d8
  800211:	6a 32                	push   $0x32
  800213:	68 dc 20 80 00       	push   $0x8020dc
  800218:	e8 b5 04 00 00       	call   8006d2 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  80021d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800220:	e8 35 17 00 00       	call   80195a <sys_calculate_free_frames>
  800225:	29 c3                	sub    %eax,%ebx
  800227:	89 d8                	mov    %ebx,%eax
  800229:	83 f8 07             	cmp    $0x7,%eax
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 b8 23 80 00       	push   $0x8023b8
  800236:	6a 34                	push   $0x34
  800238:	68 dc 20 80 00       	push   $0x8020dc
  80023d:	e8 90 04 00 00       	call   8006d2 <_panic>

		sfree(z);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	ff 75 d4             	pushl  -0x2c(%ebp)
  800248:	e8 1f 15 00 00       	call   80176c <sfree>
  80024d:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800250:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800253:	e8 02 17 00 00       	call   80195a <sys_calculate_free_frames>
  800258:	29 c3                	sub    %eax,%ebx
  80025a:	89 d8                	mov    %ebx,%eax
  80025c:	83 f8 04             	cmp    $0x4,%eax
  80025f:	74 14                	je     800275 <_main+0x23d>
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	68 0d 24 80 00       	push   $0x80240d
  800269:	6a 37                	push   $0x37
  80026b:	68 dc 20 80 00       	push   $0x8020dc
  800270:	e8 5d 04 00 00       	call   8006d2 <_panic>

		sfree(x);
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	ff 75 d0             	pushl  -0x30(%ebp)
  80027b:	e8 ec 14 00 00       	call   80176c <sfree>
  800280:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800283:	e8 d2 16 00 00       	call   80195a <sys_calculate_free_frames>
  800288:	89 c2                	mov    %eax,%edx
  80028a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80028d:	39 c2                	cmp    %eax,%edx
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 0d 24 80 00       	push   $0x80240d
  800299:	6a 3a                	push   $0x3a
  80029b:	68 dc 20 80 00       	push   $0x8020dc
  8002a0:	e8 2d 04 00 00       	call   8006d2 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	68 2c 24 80 00       	push   $0x80242c
  8002ad:	e8 c2 06 00 00       	call   800974 <cprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	68 50 24 80 00       	push   $0x802450
  8002bd:	e8 b2 06 00 00       	call   800974 <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 90 16 00 00       	call   80195a <sys_calculate_free_frames>
  8002ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	6a 01                	push   $0x1
  8002d2:	68 01 30 00 00       	push   $0x3001
  8002d7:	68 80 24 80 00       	push   $0x802480
  8002dc:	e8 51 14 00 00       	call   801732 <smalloc>
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	6a 01                	push   $0x1
  8002ec:	68 00 10 00 00       	push   $0x1000
  8002f1:	68 82 24 80 00       	push   $0x802482
  8002f6:	e8 37 14 00 00       	call   801732 <smalloc>
  8002fb:	83 c4 10             	add    $0x10,%esp
  8002fe:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800301:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800304:	e8 51 16 00 00       	call   80195a <sys_calculate_free_frames>
  800309:	29 c3                	sub    %eax,%ebx
  80030b:	89 d8                	mov    %ebx,%eax
  80030d:	83 f8 0a             	cmp    $0xa,%eax
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 58 22 80 00       	push   $0x802258
  80031a:	6a 46                	push   $0x46
  80031c:	68 dc 20 80 00       	push   $0x8020dc
  800321:	e8 ac 03 00 00       	call   8006d2 <_panic>

		sfree(w);
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	ff 75 c8             	pushl  -0x38(%ebp)
  80032c:	e8 3b 14 00 00       	call   80176c <sfree>
  800331:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800334:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800337:	e8 1e 16 00 00       	call   80195a <sys_calculate_free_frames>
  80033c:	29 c3                	sub    %eax,%ebx
  80033e:	89 d8                	mov    %ebx,%eax
  800340:	83 f8 04             	cmp    $0x4,%eax
  800343:	74 14                	je     800359 <_main+0x321>
  800345:	83 ec 04             	sub    $0x4,%esp
  800348:	68 0d 24 80 00       	push   $0x80240d
  80034d:	6a 49                	push   $0x49
  80034f:	68 dc 20 80 00       	push   $0x8020dc
  800354:	e8 79 03 00 00       	call   8006d2 <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	6a 01                	push   $0x1
  80035e:	68 ff 1f 00 00       	push   $0x1fff
  800363:	68 84 24 80 00       	push   $0x802484
  800368:	e8 c5 13 00 00       	call   801732 <smalloc>
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800373:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800376:	e8 df 15 00 00       	call   80195a <sys_calculate_free_frames>
  80037b:	29 c3                	sub    %eax,%ebx
  80037d:	89 d8                	mov    %ebx,%eax
  80037f:	83 f8 08             	cmp    $0x8,%eax
  800382:	74 14                	je     800398 <_main+0x360>
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	68 58 22 80 00       	push   $0x802258
  80038c:	6a 4e                	push   $0x4e
  80038e:	68 dc 20 80 00       	push   $0x8020dc
  800393:	e8 3a 03 00 00       	call   8006d2 <_panic>

		sfree(o);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	ff 75 c0             	pushl  -0x40(%ebp)
  80039e:	e8 c9 13 00 00       	call   80176c <sfree>
  8003a3:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003a6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003a9:	e8 ac 15 00 00       	call   80195a <sys_calculate_free_frames>
  8003ae:	29 c3                	sub    %eax,%ebx
  8003b0:	89 d8                	mov    %ebx,%eax
  8003b2:	83 f8 04             	cmp    $0x4,%eax
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 0d 24 80 00       	push   $0x80240d
  8003bf:	6a 51                	push   $0x51
  8003c1:	68 dc 20 80 00       	push   $0x8020dc
  8003c6:	e8 07 03 00 00       	call   8006d2 <_panic>

		sfree(u);
  8003cb:	83 ec 0c             	sub    $0xc,%esp
  8003ce:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d1:	e8 96 13 00 00       	call   80176c <sfree>
  8003d6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003d9:	e8 7c 15 00 00       	call   80195a <sys_calculate_free_frames>
  8003de:	89 c2                	mov    %eax,%edx
  8003e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e3:	39 c2                	cmp    %eax,%edx
  8003e5:	74 14                	je     8003fb <_main+0x3c3>
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	68 0d 24 80 00       	push   $0x80240d
  8003ef:	6a 54                	push   $0x54
  8003f1:	68 dc 20 80 00       	push   $0x8020dc
  8003f6:	e8 d7 02 00 00       	call   8006d2 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  8003fb:	e8 5a 15 00 00       	call   80195a <sys_calculate_free_frames>
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800406:	89 c2                	mov    %eax,%edx
  800408:	01 d2                	add    %edx,%edx
  80040a:	01 d0                	add    %edx,%eax
  80040c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	6a 01                	push   $0x1
  800414:	50                   	push   %eax
  800415:	68 80 24 80 00       	push   $0x802480
  80041a:	e8 13 13 00 00       	call   801732 <smalloc>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800428:	89 d0                	mov    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	01 c0                	add    %eax,%eax
  800430:	01 d0                	add    %edx,%eax
  800432:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	6a 01                	push   $0x1
  80043a:	50                   	push   %eax
  80043b:	68 82 24 80 00       	push   $0x802482
  800440:	e8 ed 12 00 00       	call   801732 <smalloc>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80044b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80044e:	01 c0                	add    %eax,%eax
  800450:	89 c2                	mov    %eax,%edx
  800452:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800455:	01 d0                	add    %edx,%eax
  800457:	83 ec 04             	sub    $0x4,%esp
  80045a:	6a 01                	push   $0x1
  80045c:	50                   	push   %eax
  80045d:	68 84 24 80 00       	push   $0x802484
  800462:	e8 cb 12 00 00       	call   801732 <smalloc>
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80046d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800470:	e8 e5 14 00 00       	call   80195a <sys_calculate_free_frames>
  800475:	29 c3                	sub    %eax,%ebx
  800477:	89 d8                	mov    %ebx,%eax
  800479:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 58 22 80 00       	push   $0x802258
  800488:	6a 5d                	push   $0x5d
  80048a:	68 dc 20 80 00       	push   $0x8020dc
  80048f:	e8 3e 02 00 00       	call   8006d2 <_panic>

		sfree(o);
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	ff 75 c0             	pushl  -0x40(%ebp)
  80049a:	e8 cd 12 00 00       	call   80176c <sfree>
  80049f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004a5:	e8 b0 14 00 00       	call   80195a <sys_calculate_free_frames>
  8004aa:	29 c3                	sub    %eax,%ebx
  8004ac:	89 d8                	mov    %ebx,%eax
  8004ae:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b3:	74 14                	je     8004c9 <_main+0x491>
  8004b5:	83 ec 04             	sub    $0x4,%esp
  8004b8:	68 0d 24 80 00       	push   $0x80240d
  8004bd:	6a 60                	push   $0x60
  8004bf:	68 dc 20 80 00       	push   $0x8020dc
  8004c4:	e8 09 02 00 00       	call   8006d2 <_panic>

		sfree(w);
  8004c9:	83 ec 0c             	sub    $0xc,%esp
  8004cc:	ff 75 c8             	pushl  -0x38(%ebp)
  8004cf:	e8 98 12 00 00       	call   80176c <sfree>
  8004d4:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004d7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004da:	e8 7b 14 00 00       	call   80195a <sys_calculate_free_frames>
  8004df:	29 c3                	sub    %eax,%ebx
  8004e1:	89 d8                	mov    %ebx,%eax
  8004e3:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004e8:	74 14                	je     8004fe <_main+0x4c6>
  8004ea:	83 ec 04             	sub    $0x4,%esp
  8004ed:	68 0d 24 80 00       	push   $0x80240d
  8004f2:	6a 63                	push   $0x63
  8004f4:	68 dc 20 80 00       	push   $0x8020dc
  8004f9:	e8 d4 01 00 00       	call   8006d2 <_panic>

		sfree(u);
  8004fe:	83 ec 0c             	sub    $0xc,%esp
  800501:	ff 75 c4             	pushl  -0x3c(%ebp)
  800504:	e8 63 12 00 00       	call   80176c <sfree>
  800509:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80050c:	e8 49 14 00 00       	call   80195a <sys_calculate_free_frames>
  800511:	89 c2                	mov    %eax,%edx
  800513:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800516:	39 c2                	cmp    %eax,%edx
  800518:	74 14                	je     80052e <_main+0x4f6>
  80051a:	83 ec 04             	sub    $0x4,%esp
  80051d:	68 0d 24 80 00       	push   $0x80240d
  800522:	6a 66                	push   $0x66
  800524:	68 dc 20 80 00       	push   $0x8020dc
  800529:	e8 a4 01 00 00       	call   8006d2 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	68 88 24 80 00       	push   $0x802488
  800536:	e8 39 04 00 00       	call   800974 <cprintf>
  80053b:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  80053e:	83 ec 0c             	sub    $0xc,%esp
  800541:	68 ac 24 80 00       	push   $0x8024ac
  800546:	e8 29 04 00 00       	call   800974 <cprintf>
  80054b:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80054e:	e8 55 13 00 00       	call   8018a8 <sys_getparentenvid>
  800553:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  800556:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  80055a:	7e 2b                	jle    800587 <_main+0x54f>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80055c:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	68 f8 24 80 00       	push   $0x8024f8
  80056b:	ff 75 bc             	pushl  -0x44(%ebp)
  80056e:	e8 df 11 00 00       	call   801752 <sget>
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  800579:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	8d 50 01             	lea    0x1(%eax),%edx
  800581:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800584:	89 10                	mov    %edx,(%eax)
	}
	return;
  800586:	90                   	nop
  800587:	90                   	nop
}
  800588:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058b:	c9                   	leave  
  80058c:	c3                   	ret    

0080058d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80058d:	55                   	push   %ebp
  80058e:	89 e5                	mov    %esp,%ebp
  800590:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800593:	e8 f7 12 00 00       	call   80188f <sys_getenvindex>
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80059b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80059e:	89 d0                	mov    %edx,%eax
  8005a0:	c1 e0 03             	shl    $0x3,%eax
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005ac:	01 c8                	add    %ecx,%eax
  8005ae:	01 c0                	add    %eax,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	c1 e2 05             	shl    $0x5,%edx
  8005bb:	29 c2                	sub    %eax,%edx
  8005bd:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8005c4:	89 c2                	mov    %eax,%edx
  8005c6:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8005cc:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d6:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8005dc:	84 c0                	test   %al,%al
  8005de:	74 0f                	je     8005ef <libmain+0x62>
		binaryname = myEnv->prog_name;
  8005e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e5:	05 40 3c 01 00       	add    $0x13c40,%eax
  8005ea:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f3:	7e 0a                	jle    8005ff <libmain+0x72>
		binaryname = argv[0];
  8005f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 08             	pushl  0x8(%ebp)
  800608:	e8 2b fa ff ff       	call   800038 <_main>
  80060d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800610:	e8 15 14 00 00       	call   801a2a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800615:	83 ec 0c             	sub    $0xc,%esp
  800618:	68 20 25 80 00       	push   $0x802520
  80061d:	e8 52 03 00 00       	call   800974 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800625:	a1 20 30 80 00       	mov    0x803020,%eax
  80062a:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800630:	a1 20 30 80 00       	mov    0x803020,%eax
  800635:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80063b:	83 ec 04             	sub    $0x4,%esp
  80063e:	52                   	push   %edx
  80063f:	50                   	push   %eax
  800640:	68 48 25 80 00       	push   $0x802548
  800645:	e8 2a 03 00 00       	call   800974 <cprintf>
  80064a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80064d:	a1 20 30 80 00       	mov    0x803020,%eax
  800652:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800658:	a1 20 30 80 00       	mov    0x803020,%eax
  80065d:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800663:	83 ec 04             	sub    $0x4,%esp
  800666:	52                   	push   %edx
  800667:	50                   	push   %eax
  800668:	68 70 25 80 00       	push   $0x802570
  80066d:	e8 02 03 00 00       	call   800974 <cprintf>
  800672:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800675:	a1 20 30 80 00       	mov    0x803020,%eax
  80067a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	50                   	push   %eax
  800684:	68 b1 25 80 00       	push   $0x8025b1
  800689:	e8 e6 02 00 00       	call   800974 <cprintf>
  80068e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	68 20 25 80 00       	push   $0x802520
  800699:	e8 d6 02 00 00       	call   800974 <cprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006a1:	e8 9e 13 00 00       	call   801a44 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a6:	e8 19 00 00 00       	call   8006c4 <exit>
}
  8006ab:	90                   	nop
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	6a 00                	push   $0x0
  8006b9:	e8 9d 11 00 00       	call   80185b <sys_env_destroy>
  8006be:	83 c4 10             	add    $0x10,%esp
}
  8006c1:	90                   	nop
  8006c2:	c9                   	leave  
  8006c3:	c3                   	ret    

008006c4 <exit>:

void
exit(void)
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006ca:	e8 f2 11 00 00       	call   8018c1 <sys_env_exit>
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8006db:	83 c0 04             	add    $0x4,%eax
  8006de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006e1:	a1 18 31 80 00       	mov    0x803118,%eax
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	74 16                	je     800700 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006ea:	a1 18 31 80 00       	mov    0x803118,%eax
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	50                   	push   %eax
  8006f3:	68 c8 25 80 00       	push   $0x8025c8
  8006f8:	e8 77 02 00 00       	call   800974 <cprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800700:	a1 00 30 80 00       	mov    0x803000,%eax
  800705:	ff 75 0c             	pushl  0xc(%ebp)
  800708:	ff 75 08             	pushl  0x8(%ebp)
  80070b:	50                   	push   %eax
  80070c:	68 cd 25 80 00       	push   $0x8025cd
  800711:	e8 5e 02 00 00       	call   800974 <cprintf>
  800716:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800719:	8b 45 10             	mov    0x10(%ebp),%eax
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 f4             	pushl  -0xc(%ebp)
  800722:	50                   	push   %eax
  800723:	e8 e1 01 00 00       	call   800909 <vcprintf>
  800728:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	6a 00                	push   $0x0
  800730:	68 e9 25 80 00       	push   $0x8025e9
  800735:	e8 cf 01 00 00       	call   800909 <vcprintf>
  80073a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073d:	e8 82 ff ff ff       	call   8006c4 <exit>

	// should not return here
	while (1) ;
  800742:	eb fe                	jmp    800742 <_panic+0x70>

00800744 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80074a:	a1 20 30 80 00       	mov    0x803020,%eax
  80074f:	8b 50 74             	mov    0x74(%eax),%edx
  800752:	8b 45 0c             	mov    0xc(%ebp),%eax
  800755:	39 c2                	cmp    %eax,%edx
  800757:	74 14                	je     80076d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800759:	83 ec 04             	sub    $0x4,%esp
  80075c:	68 ec 25 80 00       	push   $0x8025ec
  800761:	6a 26                	push   $0x26
  800763:	68 38 26 80 00       	push   $0x802638
  800768:	e8 65 ff ff ff       	call   8006d2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800774:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80077b:	e9 b6 00 00 00       	jmp    800836 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800783:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	01 d0                	add    %edx,%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	85 c0                	test   %eax,%eax
  800793:	75 08                	jne    80079d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800795:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800798:	e9 96 00 00 00       	jmp    800833 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80079d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ab:	eb 5d                	jmp    80080a <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bb:	c1 e2 04             	shl    $0x4,%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	8a 40 04             	mov    0x4(%eax),%al
  8007c3:	84 c0                	test   %al,%al
  8007c5:	75 40                	jne    800807 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8007cc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d5:	c1 e2 04             	shl    $0x4,%edx
  8007d8:	01 d0                	add    %edx,%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ec:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	01 c8                	add    %ecx,%eax
  8007f8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007fa:	39 c2                	cmp    %eax,%edx
  8007fc:	75 09                	jne    800807 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8007fe:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800805:	eb 12                	jmp    800819 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800807:	ff 45 e8             	incl   -0x18(%ebp)
  80080a:	a1 20 30 80 00       	mov    0x803020,%eax
  80080f:	8b 50 74             	mov    0x74(%eax),%edx
  800812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800815:	39 c2                	cmp    %eax,%edx
  800817:	77 94                	ja     8007ad <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800819:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80081d:	75 14                	jne    800833 <CheckWSWithoutLastIndex+0xef>
			panic(
  80081f:	83 ec 04             	sub    $0x4,%esp
  800822:	68 44 26 80 00       	push   $0x802644
  800827:	6a 3a                	push   $0x3a
  800829:	68 38 26 80 00       	push   $0x802638
  80082e:	e8 9f fe ff ff       	call   8006d2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800833:	ff 45 f0             	incl   -0x10(%ebp)
  800836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800839:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80083c:	0f 8c 3e ff ff ff    	jl     800780 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800842:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800849:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800850:	eb 20                	jmp    800872 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800852:	a1 20 30 80 00       	mov    0x803020,%eax
  800857:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80085d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800860:	c1 e2 04             	shl    $0x4,%edx
  800863:	01 d0                	add    %edx,%eax
  800865:	8a 40 04             	mov    0x4(%eax),%al
  800868:	3c 01                	cmp    $0x1,%al
  80086a:	75 03                	jne    80086f <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80086c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086f:	ff 45 e0             	incl   -0x20(%ebp)
  800872:	a1 20 30 80 00       	mov    0x803020,%eax
  800877:	8b 50 74             	mov    0x74(%eax),%edx
  80087a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80087d:	39 c2                	cmp    %eax,%edx
  80087f:	77 d1                	ja     800852 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800884:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800887:	74 14                	je     80089d <CheckWSWithoutLastIndex+0x159>
		panic(
  800889:	83 ec 04             	sub    $0x4,%esp
  80088c:	68 98 26 80 00       	push   $0x802698
  800891:	6a 44                	push   $0x44
  800893:	68 38 26 80 00       	push   $0x802638
  800898:	e8 35 fe ff ff       	call   8006d2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80089d:	90                   	nop
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b1:	89 0a                	mov    %ecx,(%edx)
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b6:	88 d1                	mov    %dl,%cl
  8008b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008c9:	75 2c                	jne    8008f7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008cb:	a0 24 30 80 00       	mov    0x803024,%al
  8008d0:	0f b6 c0             	movzbl %al,%eax
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d6:	8b 12                	mov    (%edx),%edx
  8008d8:	89 d1                	mov    %edx,%ecx
  8008da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dd:	83 c2 08             	add    $0x8,%edx
  8008e0:	83 ec 04             	sub    $0x4,%esp
  8008e3:	50                   	push   %eax
  8008e4:	51                   	push   %ecx
  8008e5:	52                   	push   %edx
  8008e6:	e8 2e 0f 00 00       	call   801819 <sys_cputs>
  8008eb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fa:	8b 40 04             	mov    0x4(%eax),%eax
  8008fd:	8d 50 01             	lea    0x1(%eax),%edx
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	89 50 04             	mov    %edx,0x4(%eax)
}
  800906:	90                   	nop
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800912:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800919:	00 00 00 
	b.cnt = 0;
  80091c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800923:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800932:	50                   	push   %eax
  800933:	68 a0 08 80 00       	push   $0x8008a0
  800938:	e8 11 02 00 00       	call   800b4e <vprintfmt>
  80093d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800940:	a0 24 30 80 00       	mov    0x803024,%al
  800945:	0f b6 c0             	movzbl %al,%eax
  800948:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80094e:	83 ec 04             	sub    $0x4,%esp
  800951:	50                   	push   %eax
  800952:	52                   	push   %edx
  800953:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800959:	83 c0 08             	add    $0x8,%eax
  80095c:	50                   	push   %eax
  80095d:	e8 b7 0e 00 00       	call   801819 <sys_cputs>
  800962:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800965:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80096c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800972:	c9                   	leave  
  800973:	c3                   	ret    

00800974 <cprintf>:

int cprintf(const char *fmt, ...) {
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80097a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800981:	8d 45 0c             	lea    0xc(%ebp),%eax
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	ff 75 f4             	pushl  -0xc(%ebp)
  800990:	50                   	push   %eax
  800991:	e8 73 ff ff ff       	call   800909 <vcprintf>
  800996:	83 c4 10             	add    $0x10,%esp
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009a7:	e8 7e 10 00 00       	call   801a2a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	e8 48 ff ff ff       	call   800909 <vcprintf>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009c7:	e8 78 10 00 00       	call   801a44 <sys_enable_interrupt>
	return cnt;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	53                   	push   %ebx
  8009d5:	83 ec 14             	sub    $0x14,%esp
  8009d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009e4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009ef:	77 55                	ja     800a46 <printnum+0x75>
  8009f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009f4:	72 05                	jb     8009fb <printnum+0x2a>
  8009f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009f9:	77 4b                	ja     800a46 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009fb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009fe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a01:	8b 45 18             	mov    0x18(%ebp),%eax
  800a04:	ba 00 00 00 00       	mov    $0x0,%edx
  800a09:	52                   	push   %edx
  800a0a:	50                   	push   %eax
  800a0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a11:	e8 36 14 00 00       	call   801e4c <__udivdi3>
  800a16:	83 c4 10             	add    $0x10,%esp
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	ff 75 20             	pushl  0x20(%ebp)
  800a1f:	53                   	push   %ebx
  800a20:	ff 75 18             	pushl  0x18(%ebp)
  800a23:	52                   	push   %edx
  800a24:	50                   	push   %eax
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	ff 75 08             	pushl  0x8(%ebp)
  800a2b:	e8 a1 ff ff ff       	call   8009d1 <printnum>
  800a30:	83 c4 20             	add    $0x20,%esp
  800a33:	eb 1a                	jmp    800a4f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	ff 75 0c             	pushl  0xc(%ebp)
  800a3b:	ff 75 20             	pushl  0x20(%ebp)
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a46:	ff 4d 1c             	decl   0x1c(%ebp)
  800a49:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a4d:	7f e6                	jg     800a35 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a4f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5d:	53                   	push   %ebx
  800a5e:	51                   	push   %ecx
  800a5f:	52                   	push   %edx
  800a60:	50                   	push   %eax
  800a61:	e8 f6 14 00 00       	call   801f5c <__umoddi3>
  800a66:	83 c4 10             	add    $0x10,%esp
  800a69:	05 14 29 80 00       	add    $0x802914,%eax
  800a6e:	8a 00                	mov    (%eax),%al
  800a70:	0f be c0             	movsbl %al,%eax
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	50                   	push   %eax
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
}
  800a82:	90                   	nop
  800a83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a8f:	7e 1c                	jle    800aad <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	8d 50 08             	lea    0x8(%eax),%edx
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	89 10                	mov    %edx,(%eax)
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 00                	mov    (%eax),%eax
  800aa3:	83 e8 08             	sub    $0x8,%eax
  800aa6:	8b 50 04             	mov    0x4(%eax),%edx
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	eb 40                	jmp    800aed <getuint+0x65>
	else if (lflag)
  800aad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab1:	74 1e                	je     800ad1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	8d 50 04             	lea    0x4(%eax),%edx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	89 10                	mov    %edx,(%eax)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	83 e8 04             	sub    $0x4,%eax
  800ac8:	8b 00                	mov    (%eax),%eax
  800aca:	ba 00 00 00 00       	mov    $0x0,%edx
  800acf:	eb 1c                	jmp    800aed <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	8d 50 04             	lea    0x4(%eax),%edx
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	89 10                	mov    %edx,(%eax)
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	83 e8 04             	sub    $0x4,%eax
  800ae6:	8b 00                	mov    (%eax),%eax
  800ae8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af6:	7e 1c                	jle    800b14 <getint+0x25>
		return va_arg(*ap, long long);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	8d 50 08             	lea    0x8(%eax),%edx
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 10                	mov    %edx,(%eax)
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	83 e8 08             	sub    $0x8,%eax
  800b0d:	8b 50 04             	mov    0x4(%eax),%edx
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	eb 38                	jmp    800b4c <getint+0x5d>
	else if (lflag)
  800b14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b18:	74 1a                	je     800b34 <getint+0x45>
		return va_arg(*ap, long);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	8d 50 04             	lea    0x4(%eax),%edx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 10                	mov    %edx,(%eax)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	83 e8 04             	sub    $0x4,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	99                   	cltd   
  800b32:	eb 18                	jmp    800b4c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	8d 50 04             	lea    0x4(%eax),%edx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 10                	mov    %edx,(%eax)
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	83 e8 04             	sub    $0x4,%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	99                   	cltd   
}
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	56                   	push   %esi
  800b52:	53                   	push   %ebx
  800b53:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b56:	eb 17                	jmp    800b6f <vprintfmt+0x21>
			if (ch == '\0')
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	0f 84 af 03 00 00    	je     800f0f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	53                   	push   %ebx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b72:	8d 50 01             	lea    0x1(%eax),%edx
  800b75:	89 55 10             	mov    %edx,0x10(%ebp)
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	0f b6 d8             	movzbl %al,%ebx
  800b7d:	83 fb 25             	cmp    $0x25,%ebx
  800b80:	75 d6                	jne    800b58 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b82:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b86:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b8d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b9b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	8d 50 01             	lea    0x1(%eax),%edx
  800ba8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bab:	8a 00                	mov    (%eax),%al
  800bad:	0f b6 d8             	movzbl %al,%ebx
  800bb0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bb3:	83 f8 55             	cmp    $0x55,%eax
  800bb6:	0f 87 2b 03 00 00    	ja     800ee7 <vprintfmt+0x399>
  800bbc:	8b 04 85 38 29 80 00 	mov    0x802938(,%eax,4),%eax
  800bc3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bc5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bc9:	eb d7                	jmp    800ba2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bcb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bcf:	eb d1                	jmp    800ba2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bdb:	89 d0                	mov    %edx,%eax
  800bdd:	c1 e0 02             	shl    $0x2,%eax
  800be0:	01 d0                	add    %edx,%eax
  800be2:	01 c0                	add    %eax,%eax
  800be4:	01 d8                	add    %ebx,%eax
  800be6:	83 e8 30             	sub    $0x30,%eax
  800be9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bec:	8b 45 10             	mov    0x10(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf4:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf7:	7e 3e                	jle    800c37 <vprintfmt+0xe9>
  800bf9:	83 fb 39             	cmp    $0x39,%ebx
  800bfc:	7f 39                	jg     800c37 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c01:	eb d5                	jmp    800bd8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c03:	8b 45 14             	mov    0x14(%ebp),%eax
  800c06:	83 c0 04             	add    $0x4,%eax
  800c09:	89 45 14             	mov    %eax,0x14(%ebp)
  800c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0f:	83 e8 04             	sub    $0x4,%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c17:	eb 1f                	jmp    800c38 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1d:	79 83                	jns    800ba2 <vprintfmt+0x54>
				width = 0;
  800c1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c26:	e9 77 ff ff ff       	jmp    800ba2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c2b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c32:	e9 6b ff ff ff       	jmp    800ba2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c37:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3c:	0f 89 60 ff ff ff    	jns    800ba2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c4f:	e9 4e ff ff ff       	jmp    800ba2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c54:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c57:	e9 46 ff ff ff       	jmp    800ba2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5f:	83 c0 04             	add    $0x4,%eax
  800c62:	89 45 14             	mov    %eax,0x14(%ebp)
  800c65:	8b 45 14             	mov    0x14(%ebp),%eax
  800c68:	83 e8 04             	sub    $0x4,%eax
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	50                   	push   %eax
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	ff d0                	call   *%eax
  800c79:	83 c4 10             	add    $0x10,%esp
			break;
  800c7c:	e9 89 02 00 00       	jmp    800f0a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c81:	8b 45 14             	mov    0x14(%ebp),%eax
  800c84:	83 c0 04             	add    $0x4,%eax
  800c87:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8d:	83 e8 04             	sub    $0x4,%eax
  800c90:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c92:	85 db                	test   %ebx,%ebx
  800c94:	79 02                	jns    800c98 <vprintfmt+0x14a>
				err = -err;
  800c96:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c98:	83 fb 64             	cmp    $0x64,%ebx
  800c9b:	7f 0b                	jg     800ca8 <vprintfmt+0x15a>
  800c9d:	8b 34 9d 80 27 80 00 	mov    0x802780(,%ebx,4),%esi
  800ca4:	85 f6                	test   %esi,%esi
  800ca6:	75 19                	jne    800cc1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ca8:	53                   	push   %ebx
  800ca9:	68 25 29 80 00       	push   $0x802925
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	ff 75 08             	pushl  0x8(%ebp)
  800cb4:	e8 5e 02 00 00       	call   800f17 <printfmt>
  800cb9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cbc:	e9 49 02 00 00       	jmp    800f0a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cc1:	56                   	push   %esi
  800cc2:	68 2e 29 80 00       	push   $0x80292e
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 08             	pushl  0x8(%ebp)
  800ccd:	e8 45 02 00 00       	call   800f17 <printfmt>
  800cd2:	83 c4 10             	add    $0x10,%esp
			break;
  800cd5:	e9 30 02 00 00       	jmp    800f0a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	83 c0 04             	add    $0x4,%eax
  800ce0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce6:	83 e8 04             	sub    $0x4,%eax
  800ce9:	8b 30                	mov    (%eax),%esi
  800ceb:	85 f6                	test   %esi,%esi
  800ced:	75 05                	jne    800cf4 <vprintfmt+0x1a6>
				p = "(null)";
  800cef:	be 31 29 80 00       	mov    $0x802931,%esi
			if (width > 0 && padc != '-')
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	7e 6d                	jle    800d67 <vprintfmt+0x219>
  800cfa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cfe:	74 67                	je     800d67 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	50                   	push   %eax
  800d07:	56                   	push   %esi
  800d08:	e8 0c 03 00 00       	call   801019 <strnlen>
  800d0d:	83 c4 10             	add    $0x10,%esp
  800d10:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d13:	eb 16                	jmp    800d2b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d15:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	50                   	push   %eax
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d28:	ff 4d e4             	decl   -0x1c(%ebp)
  800d2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2f:	7f e4                	jg     800d15 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d31:	eb 34                	jmp    800d67 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d33:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d37:	74 1c                	je     800d55 <vprintfmt+0x207>
  800d39:	83 fb 1f             	cmp    $0x1f,%ebx
  800d3c:	7e 05                	jle    800d43 <vprintfmt+0x1f5>
  800d3e:	83 fb 7e             	cmp    $0x7e,%ebx
  800d41:	7e 12                	jle    800d55 <vprintfmt+0x207>
					putch('?', putdat);
  800d43:	83 ec 08             	sub    $0x8,%esp
  800d46:	ff 75 0c             	pushl  0xc(%ebp)
  800d49:	6a 3f                	push   $0x3f
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	ff d0                	call   *%eax
  800d50:	83 c4 10             	add    $0x10,%esp
  800d53:	eb 0f                	jmp    800d64 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	53                   	push   %ebx
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d64:	ff 4d e4             	decl   -0x1c(%ebp)
  800d67:	89 f0                	mov    %esi,%eax
  800d69:	8d 70 01             	lea    0x1(%eax),%esi
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	0f be d8             	movsbl %al,%ebx
  800d71:	85 db                	test   %ebx,%ebx
  800d73:	74 24                	je     800d99 <vprintfmt+0x24b>
  800d75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d79:	78 b8                	js     800d33 <vprintfmt+0x1e5>
  800d7b:	ff 4d e0             	decl   -0x20(%ebp)
  800d7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d82:	79 af                	jns    800d33 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d84:	eb 13                	jmp    800d99 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	6a 20                	push   $0x20
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	ff d0                	call   *%eax
  800d93:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d96:	ff 4d e4             	decl   -0x1c(%ebp)
  800d99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9d:	7f e7                	jg     800d86 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d9f:	e9 66 01 00 00       	jmp    800f0a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800da4:	83 ec 08             	sub    $0x8,%esp
  800da7:	ff 75 e8             	pushl  -0x18(%ebp)
  800daa:	8d 45 14             	lea    0x14(%ebp),%eax
  800dad:	50                   	push   %eax
  800dae:	e8 3c fd ff ff       	call   800aef <getint>
  800db3:	83 c4 10             	add    $0x10,%esp
  800db6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc2:	85 d2                	test   %edx,%edx
  800dc4:	79 23                	jns    800de9 <vprintfmt+0x29b>
				putch('-', putdat);
  800dc6:	83 ec 08             	sub    $0x8,%esp
  800dc9:	ff 75 0c             	pushl  0xc(%ebp)
  800dcc:	6a 2d                	push   $0x2d
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	ff d0                	call   *%eax
  800dd3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ddc:	f7 d8                	neg    %eax
  800dde:	83 d2 00             	adc    $0x0,%edx
  800de1:	f7 da                	neg    %edx
  800de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800de9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800df0:	e9 bc 00 00 00       	jmp    800eb1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800df5:	83 ec 08             	sub    $0x8,%esp
  800df8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dfb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dfe:	50                   	push   %eax
  800dff:	e8 84 fc ff ff       	call   800a88 <getuint>
  800e04:	83 c4 10             	add    $0x10,%esp
  800e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e0d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e14:	e9 98 00 00 00       	jmp    800eb1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	6a 58                	push   $0x58
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	ff d0                	call   *%eax
  800e26:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e29:	83 ec 08             	sub    $0x8,%esp
  800e2c:	ff 75 0c             	pushl  0xc(%ebp)
  800e2f:	6a 58                	push   $0x58
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	ff d0                	call   *%eax
  800e36:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e39:	83 ec 08             	sub    $0x8,%esp
  800e3c:	ff 75 0c             	pushl  0xc(%ebp)
  800e3f:	6a 58                	push   $0x58
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	ff d0                	call   *%eax
  800e46:	83 c4 10             	add    $0x10,%esp
			break;
  800e49:	e9 bc 00 00 00       	jmp    800f0a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e4e:	83 ec 08             	sub    $0x8,%esp
  800e51:	ff 75 0c             	pushl  0xc(%ebp)
  800e54:	6a 30                	push   $0x30
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	ff d0                	call   *%eax
  800e5b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e5e:	83 ec 08             	sub    $0x8,%esp
  800e61:	ff 75 0c             	pushl  0xc(%ebp)
  800e64:	6a 78                	push   $0x78
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	ff d0                	call   *%eax
  800e6b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e71:	83 c0 04             	add    $0x4,%eax
  800e74:	89 45 14             	mov    %eax,0x14(%ebp)
  800e77:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7a:	83 e8 04             	sub    $0x4,%eax
  800e7d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e89:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e90:	eb 1f                	jmp    800eb1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	ff 75 e8             	pushl  -0x18(%ebp)
  800e98:	8d 45 14             	lea    0x14(%ebp),%eax
  800e9b:	50                   	push   %eax
  800e9c:	e8 e7 fb ff ff       	call   800a88 <getuint>
  800ea1:	83 c4 10             	add    $0x10,%esp
  800ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eb1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb8:	83 ec 04             	sub    $0x4,%esp
  800ebb:	52                   	push   %edx
  800ebc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ec3:	ff 75 f0             	pushl  -0x10(%ebp)
  800ec6:	ff 75 0c             	pushl  0xc(%ebp)
  800ec9:	ff 75 08             	pushl  0x8(%ebp)
  800ecc:	e8 00 fb ff ff       	call   8009d1 <printnum>
  800ed1:	83 c4 20             	add    $0x20,%esp
			break;
  800ed4:	eb 34                	jmp    800f0a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	ff 75 0c             	pushl  0xc(%ebp)
  800edc:	53                   	push   %ebx
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	ff d0                	call   *%eax
  800ee2:	83 c4 10             	add    $0x10,%esp
			break;
  800ee5:	eb 23                	jmp    800f0a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 25                	push   $0x25
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ef7:	ff 4d 10             	decl   0x10(%ebp)
  800efa:	eb 03                	jmp    800eff <vprintfmt+0x3b1>
  800efc:	ff 4d 10             	decl   0x10(%ebp)
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	48                   	dec    %eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	3c 25                	cmp    $0x25,%al
  800f07:	75 f3                	jne    800efc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f09:	90                   	nop
		}
	}
  800f0a:	e9 47 fc ff ff       	jmp    800b56 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f0f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f13:	5b                   	pop    %ebx
  800f14:	5e                   	pop    %esi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f1d:	8d 45 10             	lea    0x10(%ebp),%eax
  800f20:	83 c0 04             	add    $0x4,%eax
  800f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f26:	8b 45 10             	mov    0x10(%ebp),%eax
  800f29:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2c:	50                   	push   %eax
  800f2d:	ff 75 0c             	pushl  0xc(%ebp)
  800f30:	ff 75 08             	pushl  0x8(%ebp)
  800f33:	e8 16 fc ff ff       	call   800b4e <vprintfmt>
  800f38:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f3b:	90                   	nop
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	8b 40 08             	mov    0x8(%eax),%eax
  800f47:	8d 50 01             	lea    0x1(%eax),%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 10                	mov    (%eax),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8b 40 04             	mov    0x4(%eax),%eax
  800f5b:	39 c2                	cmp    %eax,%edx
  800f5d:	73 12                	jae    800f71 <sprintputch+0x33>
		*b->buf++ = ch;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 00                	mov    (%eax),%eax
  800f64:	8d 48 01             	lea    0x1(%eax),%ecx
  800f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6a:	89 0a                	mov    %ecx,(%edx)
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	88 10                	mov    %dl,(%eax)
}
  800f71:	90                   	nop
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	01 d0                	add    %edx,%eax
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f99:	74 06                	je     800fa1 <vsnprintf+0x2d>
  800f9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f9f:	7f 07                	jg     800fa8 <vsnprintf+0x34>
		return -E_INVAL;
  800fa1:	b8 03 00 00 00       	mov    $0x3,%eax
  800fa6:	eb 20                	jmp    800fc8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fa8:	ff 75 14             	pushl  0x14(%ebp)
  800fab:	ff 75 10             	pushl  0x10(%ebp)
  800fae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fb1:	50                   	push   %eax
  800fb2:	68 3e 0f 80 00       	push   $0x800f3e
  800fb7:	e8 92 fb ff ff       	call   800b4e <vprintfmt>
  800fbc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fc2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fc8:	c9                   	leave  
  800fc9:	c3                   	ret    

00800fca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fd0:	8d 45 10             	lea    0x10(%ebp),%eax
  800fd3:	83 c0 04             	add    $0x4,%eax
  800fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fdf:	50                   	push   %eax
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	ff 75 08             	pushl  0x8(%ebp)
  800fe6:	e8 89 ff ff ff       	call   800f74 <vsnprintf>
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801003:	eb 06                	jmp    80100b <strlen+0x15>
		n++;
  801005:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	84 c0                	test   %al,%al
  801012:	75 f1                	jne    801005 <strlen+0xf>
		n++;
	return n;
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801026:	eb 09                	jmp    801031 <strnlen+0x18>
		n++;
  801028:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102b:	ff 45 08             	incl   0x8(%ebp)
  80102e:	ff 4d 0c             	decl   0xc(%ebp)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 09                	je     801040 <strnlen+0x27>
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	84 c0                	test   %al,%al
  80103e:	75 e8                	jne    801028 <strnlen+0xf>
		n++;
	return n;
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    

00801045 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801051:	90                   	nop
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8d 50 01             	lea    0x1(%eax),%edx
  801058:	89 55 08             	mov    %edx,0x8(%ebp)
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801061:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801064:	8a 12                	mov    (%edx),%dl
  801066:	88 10                	mov    %dl,(%eax)
  801068:	8a 00                	mov    (%eax),%al
  80106a:	84 c0                	test   %al,%al
  80106c:	75 e4                	jne    801052 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80106e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80107f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801086:	eb 1f                	jmp    8010a7 <strncpy+0x34>
		*dst++ = *src;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 08             	mov    %edx,0x8(%ebp)
  801091:	8b 55 0c             	mov    0xc(%ebp),%edx
  801094:	8a 12                	mov    (%edx),%dl
  801096:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	84 c0                	test   %al,%al
  80109f:	74 03                	je     8010a4 <strncpy+0x31>
			src++;
  8010a1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010a4:	ff 45 fc             	incl   -0x4(%ebp)
  8010a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010aa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ad:	72 d9                	jb     801088 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010b2:	c9                   	leave  
  8010b3:	c3                   	ret    

008010b4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c4:	74 30                	je     8010f6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010c6:	eb 16                	jmp    8010de <strlcpy+0x2a>
			*dst++ = *src++;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010da:	8a 12                	mov    (%edx),%dl
  8010dc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010de:	ff 4d 10             	decl   0x10(%ebp)
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 09                	je     8010f0 <strlcpy+0x3c>
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	84 c0                	test   %al,%al
  8010ee:	75 d8                	jne    8010c8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fc:	29 c2                	sub    %eax,%edx
  8010fe:	89 d0                	mov    %edx,%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801105:	eb 06                	jmp    80110d <strcmp+0xb>
		p++, q++;
  801107:	ff 45 08             	incl   0x8(%ebp)
  80110a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	84 c0                	test   %al,%al
  801114:	74 0e                	je     801124 <strcmp+0x22>
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 10                	mov    (%eax),%dl
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	38 c2                	cmp    %al,%dl
  801122:	74 e3                	je     801107 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	0f b6 d0             	movzbl %al,%edx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 c0             	movzbl %al,%eax
  801134:	29 c2                	sub    %eax,%edx
  801136:	89 d0                	mov    %edx,%eax
}
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80113d:	eb 09                	jmp    801148 <strncmp+0xe>
		n--, p++, q++;
  80113f:	ff 4d 10             	decl   0x10(%ebp)
  801142:	ff 45 08             	incl   0x8(%ebp)
  801145:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	74 17                	je     801165 <strncmp+0x2b>
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	84 c0                	test   %al,%al
  801155:	74 0e                	je     801165 <strncmp+0x2b>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 10                	mov    (%eax),%dl
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	38 c2                	cmp    %al,%dl
  801163:	74 da                	je     80113f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801165:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801169:	75 07                	jne    801172 <strncmp+0x38>
		return 0;
  80116b:	b8 00 00 00 00       	mov    $0x0,%eax
  801170:	eb 14                	jmp    801186 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f b6 d0             	movzbl %al,%edx
  80117a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f b6 c0             	movzbl %al,%eax
  801182:	29 c2                	sub    %eax,%edx
  801184:	89 d0                	mov    %edx,%eax
}
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 04             	sub    $0x4,%esp
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801194:	eb 12                	jmp    8011a8 <strchr+0x20>
		if (*s == c)
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80119e:	75 05                	jne    8011a5 <strchr+0x1d>
			return (char *) s;
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	eb 11                	jmp    8011b6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011a5:	ff 45 08             	incl   0x8(%ebp)
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	84 c0                	test   %al,%al
  8011af:	75 e5                	jne    801196 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011c4:	eb 0d                	jmp    8011d3 <strfind+0x1b>
		if (*s == c)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ce:	74 0e                	je     8011de <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011d0:	ff 45 08             	incl   0x8(%ebp)
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	84 c0                	test   %al,%al
  8011da:	75 ea                	jne    8011c6 <strfind+0xe>
  8011dc:	eb 01                	jmp    8011df <strfind+0x27>
		if (*s == c)
			break;
  8011de:	90                   	nop
	return (char *) s;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011f6:	eb 0e                	jmp    801206 <memset+0x22>
		*p++ = c;
  8011f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fb:	8d 50 01             	lea    0x1(%eax),%edx
  8011fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801201:	8b 55 0c             	mov    0xc(%ebp),%edx
  801204:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801206:	ff 4d f8             	decl   -0x8(%ebp)
  801209:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80120d:	79 e9                	jns    8011f8 <memset+0x14>
		*p++ = c;

	return v;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801226:	eb 16                	jmp    80123e <memcpy+0x2a>
		*d++ = *s++;
  801228:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122b:	8d 50 01             	lea    0x1(%eax),%edx
  80122e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801231:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801234:	8d 4a 01             	lea    0x1(%edx),%ecx
  801237:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80123a:	8a 12                	mov    (%edx),%dl
  80123c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	8d 50 ff             	lea    -0x1(%eax),%edx
  801244:	89 55 10             	mov    %edx,0x10(%ebp)
  801247:	85 c0                	test   %eax,%eax
  801249:	75 dd                	jne    801228 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801262:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	73 50                	jae    8012ba <memmove+0x6a>
  80126a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126d:	8b 45 10             	mov    0x10(%ebp),%eax
  801270:	01 d0                	add    %edx,%eax
  801272:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801275:	76 43                	jbe    8012ba <memmove+0x6a>
		s += n;
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801283:	eb 10                	jmp    801295 <memmove+0x45>
			*--d = *--s;
  801285:	ff 4d f8             	decl   -0x8(%ebp)
  801288:	ff 4d fc             	decl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	8a 10                	mov    (%eax),%dl
  801290:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801293:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801295:	8b 45 10             	mov    0x10(%ebp),%eax
  801298:	8d 50 ff             	lea    -0x1(%eax),%edx
  80129b:	89 55 10             	mov    %edx,0x10(%ebp)
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	75 e3                	jne    801285 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012a2:	eb 23                	jmp    8012c7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012b3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012b6:	8a 12                	mov    (%edx),%dl
  8012b8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	75 dd                	jne    8012a4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012de:	eb 2a                	jmp    80130a <memcmp+0x3e>
		if (*s1 != *s2)
  8012e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e3:	8a 10                	mov    (%eax),%dl
  8012e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	38 c2                	cmp    %al,%dl
  8012ec:	74 16                	je     801304 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	0f b6 d0             	movzbl %al,%edx
  8012f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	0f b6 c0             	movzbl %al,%eax
  8012fe:	29 c2                	sub    %eax,%edx
  801300:	89 d0                	mov    %edx,%eax
  801302:	eb 18                	jmp    80131c <memcmp+0x50>
		s1++, s2++;
  801304:	ff 45 fc             	incl   -0x4(%ebp)
  801307:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80130a:	8b 45 10             	mov    0x10(%ebp),%eax
  80130d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801310:	89 55 10             	mov    %edx,0x10(%ebp)
  801313:	85 c0                	test   %eax,%eax
  801315:	75 c9                	jne    8012e0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801324:	8b 55 08             	mov    0x8(%ebp),%edx
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80132f:	eb 15                	jmp    801346 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	0f b6 d0             	movzbl %al,%edx
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	0f b6 c0             	movzbl %al,%eax
  80133f:	39 c2                	cmp    %eax,%edx
  801341:	74 0d                	je     801350 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801343:	ff 45 08             	incl   0x8(%ebp)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80134c:	72 e3                	jb     801331 <memfind+0x13>
  80134e:	eb 01                	jmp    801351 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801350:	90                   	nop
	return (void *) s;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80135c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801363:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80136a:	eb 03                	jmp    80136f <strtol+0x19>
		s++;
  80136c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	3c 20                	cmp    $0x20,%al
  801376:	74 f4                	je     80136c <strtol+0x16>
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	3c 09                	cmp    $0x9,%al
  80137f:	74 eb                	je     80136c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	3c 2b                	cmp    $0x2b,%al
  801388:	75 05                	jne    80138f <strtol+0x39>
		s++;
  80138a:	ff 45 08             	incl   0x8(%ebp)
  80138d:	eb 13                	jmp    8013a2 <strtol+0x4c>
	else if (*s == '-')
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	3c 2d                	cmp    $0x2d,%al
  801396:	75 0a                	jne    8013a2 <strtol+0x4c>
		s++, neg = 1;
  801398:	ff 45 08             	incl   0x8(%ebp)
  80139b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a6:	74 06                	je     8013ae <strtol+0x58>
  8013a8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013ac:	75 20                	jne    8013ce <strtol+0x78>
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	3c 30                	cmp    $0x30,%al
  8013b5:	75 17                	jne    8013ce <strtol+0x78>
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	40                   	inc    %eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	3c 78                	cmp    $0x78,%al
  8013bf:	75 0d                	jne    8013ce <strtol+0x78>
		s += 2, base = 16;
  8013c1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013c5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013cc:	eb 28                	jmp    8013f6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d2:	75 15                	jne    8013e9 <strtol+0x93>
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	8a 00                	mov    (%eax),%al
  8013d9:	3c 30                	cmp    $0x30,%al
  8013db:	75 0c                	jne    8013e9 <strtol+0x93>
		s++, base = 8;
  8013dd:	ff 45 08             	incl   0x8(%ebp)
  8013e0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013e7:	eb 0d                	jmp    8013f6 <strtol+0xa0>
	else if (base == 0)
  8013e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ed:	75 07                	jne    8013f6 <strtol+0xa0>
		base = 10;
  8013ef:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	3c 2f                	cmp    $0x2f,%al
  8013fd:	7e 19                	jle    801418 <strtol+0xc2>
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	3c 39                	cmp    $0x39,%al
  801406:	7f 10                	jg     801418 <strtol+0xc2>
			dig = *s - '0';
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	0f be c0             	movsbl %al,%eax
  801410:	83 e8 30             	sub    $0x30,%eax
  801413:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801416:	eb 42                	jmp    80145a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	3c 60                	cmp    $0x60,%al
  80141f:	7e 19                	jle    80143a <strtol+0xe4>
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 7a                	cmp    $0x7a,%al
  801428:	7f 10                	jg     80143a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	0f be c0             	movsbl %al,%eax
  801432:	83 e8 57             	sub    $0x57,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801438:	eb 20                	jmp    80145a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	3c 40                	cmp    $0x40,%al
  801441:	7e 39                	jle    80147c <strtol+0x126>
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	3c 5a                	cmp    $0x5a,%al
  80144a:	7f 30                	jg     80147c <strtol+0x126>
			dig = *s - 'A' + 10;
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	0f be c0             	movsbl %al,%eax
  801454:	83 e8 37             	sub    $0x37,%eax
  801457:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80145a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801460:	7d 19                	jge    80147b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801462:	ff 45 08             	incl   0x8(%ebp)
  801465:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801468:	0f af 45 10          	imul   0x10(%ebp),%eax
  80146c:	89 c2                	mov    %eax,%edx
  80146e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801471:	01 d0                	add    %edx,%eax
  801473:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801476:	e9 7b ff ff ff       	jmp    8013f6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80147b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80147c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801480:	74 08                	je     80148a <strtol+0x134>
		*endptr = (char *) s;
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8b 55 08             	mov    0x8(%ebp),%edx
  801488:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80148a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80148e:	74 07                	je     801497 <strtol+0x141>
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801493:	f7 d8                	neg    %eax
  801495:	eb 03                	jmp    80149a <strtol+0x144>
  801497:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <ltostr>:

void
ltostr(long value, char *str)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014b4:	79 13                	jns    8014c9 <ltostr+0x2d>
	{
		neg = 1;
  8014b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014c3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014c6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014d1:	99                   	cltd   
  8014d2:	f7 f9                	idiv   %ecx
  8014d4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	89 c2                	mov    %eax,%edx
  8014e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e5:	01 d0                	add    %edx,%eax
  8014e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014ea:	83 c2 30             	add    $0x30,%edx
  8014ed:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014f7:	f7 e9                	imul   %ecx
  8014f9:	c1 fa 02             	sar    $0x2,%edx
  8014fc:	89 c8                	mov    %ecx,%eax
  8014fe:	c1 f8 1f             	sar    $0x1f,%eax
  801501:	29 c2                	sub    %eax,%edx
  801503:	89 d0                	mov    %edx,%eax
  801505:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801508:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801510:	f7 e9                	imul   %ecx
  801512:	c1 fa 02             	sar    $0x2,%edx
  801515:	89 c8                	mov    %ecx,%eax
  801517:	c1 f8 1f             	sar    $0x1f,%eax
  80151a:	29 c2                	sub    %eax,%edx
  80151c:	89 d0                	mov    %edx,%eax
  80151e:	c1 e0 02             	shl    $0x2,%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	01 c0                	add    %eax,%eax
  801525:	29 c1                	sub    %eax,%ecx
  801527:	89 ca                	mov    %ecx,%edx
  801529:	85 d2                	test   %edx,%edx
  80152b:	75 9c                	jne    8014c9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80152d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801534:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801537:	48                   	dec    %eax
  801538:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80153b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80153f:	74 3d                	je     80157e <ltostr+0xe2>
		start = 1 ;
  801541:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801548:	eb 34                	jmp    80157e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	8a 00                	mov    (%eax),%al
  801554:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155d:	01 c2                	add    %eax,%edx
  80155f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	01 c8                	add    %ecx,%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80156b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 c2                	add    %eax,%edx
  801573:	8a 45 eb             	mov    -0x15(%ebp),%al
  801576:	88 02                	mov    %al,(%edx)
		start++ ;
  801578:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80157b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80157e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801581:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801584:	7c c4                	jl     80154a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801586:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	01 d0                	add    %edx,%eax
  80158e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801591:	90                   	nop
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80159a:	ff 75 08             	pushl  0x8(%ebp)
  80159d:	e8 54 fa ff ff       	call   800ff6 <strlen>
  8015a2:	83 c4 04             	add    $0x4,%esp
  8015a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	e8 46 fa ff ff       	call   800ff6 <strlen>
  8015b0:	83 c4 04             	add    $0x4,%esp
  8015b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c4:	eb 17                	jmp    8015dd <strcconcat+0x49>
		final[s] = str1[s] ;
  8015c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cc:	01 c2                	add    %eax,%edx
  8015ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	01 c8                	add    %ecx,%eax
  8015d6:	8a 00                	mov    (%eax),%al
  8015d8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015da:	ff 45 fc             	incl   -0x4(%ebp)
  8015dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015e3:	7c e1                	jl     8015c6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015f3:	eb 1f                	jmp    801614 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f8:	8d 50 01             	lea    0x1(%eax),%edx
  8015fb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015fe:	89 c2                	mov    %eax,%edx
  801600:	8b 45 10             	mov    0x10(%ebp),%eax
  801603:	01 c2                	add    %eax,%edx
  801605:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160b:	01 c8                	add    %ecx,%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801611:	ff 45 f8             	incl   -0x8(%ebp)
  801614:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801617:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161a:	7c d9                	jl     8015f5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80161c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161f:	8b 45 10             	mov    0x10(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	c6 00 00             	movb   $0x0,(%eax)
}
  801627:	90                   	nop
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80162d:	8b 45 14             	mov    0x14(%ebp),%eax
  801630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801636:	8b 45 14             	mov    0x14(%ebp),%eax
  801639:	8b 00                	mov    (%eax),%eax
  80163b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801642:	8b 45 10             	mov    0x10(%ebp),%eax
  801645:	01 d0                	add    %edx,%eax
  801647:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164d:	eb 0c                	jmp    80165b <strsplit+0x31>
			*string++ = 0;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	8a 00                	mov    (%eax),%al
  801660:	84 c0                	test   %al,%al
  801662:	74 18                	je     80167c <strsplit+0x52>
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	0f be c0             	movsbl %al,%eax
  80166c:	50                   	push   %eax
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	e8 13 fb ff ff       	call   801188 <strchr>
  801675:	83 c4 08             	add    $0x8,%esp
  801678:	85 c0                	test   %eax,%eax
  80167a:	75 d3                	jne    80164f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 5a                	je     8016df <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801685:	8b 45 14             	mov    0x14(%ebp),%eax
  801688:	8b 00                	mov    (%eax),%eax
  80168a:	83 f8 0f             	cmp    $0xf,%eax
  80168d:	75 07                	jne    801696 <strsplit+0x6c>
		{
			return 0;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
  801694:	eb 66                	jmp    8016fc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801696:	8b 45 14             	mov    0x14(%ebp),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	8d 48 01             	lea    0x1(%eax),%ecx
  80169e:	8b 55 14             	mov    0x14(%ebp),%edx
  8016a1:	89 0a                	mov    %ecx,(%edx)
  8016a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ad:	01 c2                	add    %eax,%edx
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b4:	eb 03                	jmp    8016b9 <strsplit+0x8f>
			string++;
  8016b6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 8b                	je     80164d <strsplit+0x23>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 b5 fa ff ff       	call   801188 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	74 dc                	je     8016b6 <strsplit+0x8c>
			string++;
	}
  8016da:	e9 6e ff ff ff       	jmp    80164d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016df:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e3:	8b 00                	mov    (%eax),%eax
  8016e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ef:	01 d0                	add    %edx,%eax
  8016f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <malloc>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
void* malloc(uint32 size)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801704:	83 ec 04             	sub    $0x4,%esp
  801707:	68 90 2a 80 00       	push   $0x802a90
  80170c:	6a 16                	push   $0x16
  80170e:	68 b5 2a 80 00       	push   $0x802ab5
  801713:	e8 ba ef ff ff       	call   8006d2 <_panic>

00801718 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	68 c4 2a 80 00       	push   $0x802ac4
  801726:	6a 2e                	push   $0x2e
  801728:	68 b5 2a 80 00       	push   $0x802ab5
  80172d:	e8 a0 ef ff ff       	call   8006d2 <_panic>

00801732 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	83 ec 18             	sub    $0x18,%esp
  801738:	8b 45 10             	mov    0x10(%ebp),%eax
  80173b:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	68 e8 2a 80 00       	push   $0x802ae8
  801746:	6a 3b                	push   $0x3b
  801748:	68 b5 2a 80 00       	push   $0x802ab5
  80174d:	e8 80 ef ff ff       	call   8006d2 <_panic>

00801752 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	68 e8 2a 80 00       	push   $0x802ae8
  801760:	6a 41                	push   $0x41
  801762:	68 b5 2a 80 00       	push   $0x802ab5
  801767:	e8 66 ef ff ff       	call   8006d2 <_panic>

0080176c <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	68 e8 2a 80 00       	push   $0x802ae8
  80177a:	6a 47                	push   $0x47
  80177c:	68 b5 2a 80 00       	push   $0x802ab5
  801781:	e8 4c ef ff ff       	call   8006d2 <_panic>

00801786 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	68 e8 2a 80 00       	push   $0x802ae8
  801794:	6a 4c                	push   $0x4c
  801796:	68 b5 2a 80 00       	push   $0x802ab5
  80179b:	e8 32 ef ff ff       	call   8006d2 <_panic>

008017a0 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	68 e8 2a 80 00       	push   $0x802ae8
  8017ae:	6a 52                	push   $0x52
  8017b0:	68 b5 2a 80 00       	push   $0x802ab5
  8017b5:	e8 18 ef ff ff       	call   8006d2 <_panic>

008017ba <shrink>:
}
void shrink(uint32 newSize)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 e8 2a 80 00       	push   $0x802ae8
  8017c8:	6a 56                	push   $0x56
  8017ca:	68 b5 2a 80 00       	push   $0x802ab5
  8017cf:	e8 fe ee ff ff       	call   8006d2 <_panic>

008017d4 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 e8 2a 80 00       	push   $0x802ae8
  8017e2:	6a 5b                	push   $0x5b
  8017e4:	68 b5 2a 80 00       	push   $0x802ab5
  8017e9:	e8 e4 ee ff ff       	call   8006d2 <_panic>

008017ee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	57                   	push   %edi
  8017f2:	56                   	push   %esi
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801800:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801803:	8b 7d 18             	mov    0x18(%ebp),%edi
  801806:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801809:	cd 30                	int    $0x30
  80180b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80180e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	5b                   	pop    %ebx
  801815:	5e                   	pop    %esi
  801816:	5f                   	pop    %edi
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    

00801819 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 04             	sub    $0x4,%esp
  80181f:	8b 45 10             	mov    0x10(%ebp),%eax
  801822:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801825:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	52                   	push   %edx
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	50                   	push   %eax
  801835:	6a 00                	push   $0x0
  801837:	e8 b2 ff ff ff       	call   8017ee <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	90                   	nop
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_cgetc>:

int
sys_cgetc(void)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 01                	push   $0x1
  801851:	e8 98 ff ff ff       	call   8017ee <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	50                   	push   %eax
  80186a:	6a 05                	push   $0x5
  80186c:	e8 7d ff ff ff       	call   8017ee <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 02                	push   $0x2
  801885:	e8 64 ff ff ff       	call   8017ee <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 03                	push   $0x3
  80189e:	e8 4b ff ff ff       	call   8017ee <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 04                	push   $0x4
  8018b7:	e8 32 ff ff ff       	call   8017ee <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_env_exit>:


void sys_env_exit(void)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 06                	push   $0x6
  8018d0:	e8 19 ff ff ff       	call   8017ee <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	52                   	push   %edx
  8018eb:	50                   	push   %eax
  8018ec:	6a 07                	push   $0x7
  8018ee:	e8 fb fe ff ff       	call   8017ee <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018fd:	8b 75 18             	mov    0x18(%ebp),%esi
  801900:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801903:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	56                   	push   %esi
  80190d:	53                   	push   %ebx
  80190e:	51                   	push   %ecx
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 08                	push   $0x8
  801913:	e8 d6 fe ff ff       	call   8017ee <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5e                   	pop    %esi
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    

00801922 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	6a 09                	push   $0x9
  801935:	e8 b4 fe ff ff       	call   8017ee <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 0a                	push   $0xa
  801950:	e8 99 fe ff ff       	call   8017ee <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 0b                	push   $0xb
  801969:	e8 80 fe ff ff       	call   8017ee <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 0c                	push   $0xc
  801982:	e8 67 fe ff ff       	call   8017ee <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 0d                	push   $0xd
  80199b:	e8 4e fe ff ff       	call   8017ee <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	6a 11                	push   $0x11
  8019b6:	e8 33 fe ff ff       	call   8017ee <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
	return;
  8019be:	90                   	nop
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	ff 75 08             	pushl  0x8(%ebp)
  8019d0:	6a 12                	push   $0x12
  8019d2:	e8 17 fe ff ff       	call   8017ee <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019da:	90                   	nop
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 0e                	push   $0xe
  8019ec:	e8 fd fd ff ff       	call   8017ee <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	ff 75 08             	pushl  0x8(%ebp)
  801a04:	6a 0f                	push   $0xf
  801a06:	e8 e3 fd ff ff       	call   8017ee <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 10                	push   $0x10
  801a1f:	e8 ca fd ff ff       	call   8017ee <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 14                	push   $0x14
  801a39:	e8 b0 fd ff ff       	call   8017ee <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 15                	push   $0x15
  801a53:	e8 96 fd ff ff       	call   8017ee <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	90                   	nop
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 04             	sub    $0x4,%esp
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a6a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	50                   	push   %eax
  801a77:	6a 16                	push   $0x16
  801a79:	e8 70 fd ff ff       	call   8017ee <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 17                	push   $0x17
  801a93:	e8 56 fd ff ff       	call   8017ee <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	90                   	nop
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 0c             	pushl  0xc(%ebp)
  801aad:	50                   	push   %eax
  801aae:	6a 18                	push   $0x18
  801ab0:	e8 39 fd ff ff       	call   8017ee <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 1b                	push   $0x1b
  801acd:	e8 1c fd ff ff       	call   8017ee <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ada:	8b 55 0c             	mov    0xc(%ebp),%edx
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	6a 19                	push   $0x19
  801aea:	e8 ff fc ff ff       	call   8017ee <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	90                   	nop
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	6a 1a                	push   $0x1a
  801b08:	e8 e1 fc ff ff       	call   8017ee <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	90                   	nop
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b1f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b22:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	51                   	push   %ecx
  801b2c:	52                   	push   %edx
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	50                   	push   %eax
  801b31:	6a 1c                	push   $0x1c
  801b33:	e8 b6 fc ff ff       	call   8017ee <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 1d                	push   $0x1d
  801b50:	e8 99 fc ff ff       	call   8017ee <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	51                   	push   %ecx
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 1e                	push   $0x1e
  801b6f:	e8 7a fc ff ff       	call   8017ee <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	52                   	push   %edx
  801b89:	50                   	push   %eax
  801b8a:	6a 1f                	push   $0x1f
  801b8c:	e8 5d fc ff ff       	call   8017ee <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 20                	push   $0x20
  801ba5:	e8 44 fc ff ff       	call   8017ee <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	ff 75 14             	pushl  0x14(%ebp)
  801bba:	ff 75 10             	pushl  0x10(%ebp)
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	50                   	push   %eax
  801bc1:	6a 21                	push   $0x21
  801bc3:	e8 26 fc ff ff       	call   8017ee <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	50                   	push   %eax
  801bdc:	6a 22                	push   $0x22
  801bde:	e8 0b fc ff ff       	call   8017ee <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	90                   	nop
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	50                   	push   %eax
  801bf8:	6a 23                	push   $0x23
  801bfa:	e8 ef fb ff ff       	call   8017ee <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	90                   	nop
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0e:	8d 50 04             	lea    0x4(%eax),%edx
  801c11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	52                   	push   %edx
  801c1b:	50                   	push   %eax
  801c1c:	6a 24                	push   $0x24
  801c1e:	e8 cb fb ff ff       	call   8017ee <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return result;
  801c26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c2f:	89 01                	mov    %eax,(%ecx)
  801c31:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	c9                   	leave  
  801c38:	c2 04 00             	ret    $0x4

00801c3b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	ff 75 10             	pushl  0x10(%ebp)
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	6a 13                	push   $0x13
  801c4d:	e8 9c fb ff ff       	call   8017ee <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return ;
  801c55:	90                   	nop
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 25                	push   $0x25
  801c67:	e8 82 fb ff ff       	call   8017ee <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c7d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	50                   	push   %eax
  801c8a:	6a 26                	push   $0x26
  801c8c:	e8 5d fb ff ff       	call   8017ee <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
	return ;
  801c94:	90                   	nop
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <rsttst>:
void rsttst()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 28                	push   $0x28
  801ca6:	e8 43 fb ff ff       	call   8017ee <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
	return ;
  801cae:	90                   	nop
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cbd:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc4:	52                   	push   %edx
  801cc5:	50                   	push   %eax
  801cc6:	ff 75 10             	pushl  0x10(%ebp)
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	ff 75 08             	pushl  0x8(%ebp)
  801ccf:	6a 27                	push   $0x27
  801cd1:	e8 18 fb ff ff       	call   8017ee <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd9:	90                   	nop
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <chktst>:
void chktst(uint32 n)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	ff 75 08             	pushl  0x8(%ebp)
  801cea:	6a 29                	push   $0x29
  801cec:	e8 fd fa ff ff       	call   8017ee <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <inctst>:

void inctst()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 2a                	push   $0x2a
  801d06:	e8 e3 fa ff ff       	call   8017ee <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0e:	90                   	nop
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <gettst>:
uint32 gettst()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 2b                	push   $0x2b
  801d20:	e8 c9 fa ff ff       	call   8017ee <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 2c                	push   $0x2c
  801d3c:	e8 ad fa ff ff       	call   8017ee <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
  801d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d47:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d4b:	75 07                	jne    801d54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d52:	eb 05                	jmp    801d59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 2c                	push   $0x2c
  801d6d:	e8 7c fa ff ff       	call   8017ee <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
  801d75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d78:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d7c:	75 07                	jne    801d85 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d83:	eb 05                	jmp    801d8a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 2c                	push   $0x2c
  801d9e:	e8 4b fa ff ff       	call   8017ee <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
  801da6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dad:	75 07                	jne    801db6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801daf:	b8 01 00 00 00       	mov    $0x1,%eax
  801db4:	eb 05                	jmp    801dbb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 2c                	push   $0x2c
  801dcf:	e8 1a fa ff ff       	call   8017ee <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dda:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dde:	75 07                	jne    801de7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de0:	b8 01 00 00 00       	mov    $0x1,%eax
  801de5:	eb 05                	jmp    801dec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	6a 2d                	push   $0x2d
  801dfe:	e8 eb f9 ff ff       	call   8017ee <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
	return ;
  801e06:	90                   	nop
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	6a 00                	push   $0x0
  801e1b:	53                   	push   %ebx
  801e1c:	51                   	push   %ecx
  801e1d:	52                   	push   %edx
  801e1e:	50                   	push   %eax
  801e1f:	6a 2e                	push   $0x2e
  801e21:	e8 c8 f9 ff ff       	call   8017ee <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	52                   	push   %edx
  801e3e:	50                   	push   %eax
  801e3f:	6a 2f                	push   $0x2f
  801e41:	e8 a8 f9 ff ff       	call   8017ee <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    
  801e4b:	90                   	nop

00801e4c <__udivdi3>:
  801e4c:	55                   	push   %ebp
  801e4d:	57                   	push   %edi
  801e4e:	56                   	push   %esi
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 1c             	sub    $0x1c,%esp
  801e53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e63:	89 ca                	mov    %ecx,%edx
  801e65:	89 f8                	mov    %edi,%eax
  801e67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e6b:	85 f6                	test   %esi,%esi
  801e6d:	75 2d                	jne    801e9c <__udivdi3+0x50>
  801e6f:	39 cf                	cmp    %ecx,%edi
  801e71:	77 65                	ja     801ed8 <__udivdi3+0x8c>
  801e73:	89 fd                	mov    %edi,%ebp
  801e75:	85 ff                	test   %edi,%edi
  801e77:	75 0b                	jne    801e84 <__udivdi3+0x38>
  801e79:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7e:	31 d2                	xor    %edx,%edx
  801e80:	f7 f7                	div    %edi
  801e82:	89 c5                	mov    %eax,%ebp
  801e84:	31 d2                	xor    %edx,%edx
  801e86:	89 c8                	mov    %ecx,%eax
  801e88:	f7 f5                	div    %ebp
  801e8a:	89 c1                	mov    %eax,%ecx
  801e8c:	89 d8                	mov    %ebx,%eax
  801e8e:	f7 f5                	div    %ebp
  801e90:	89 cf                	mov    %ecx,%edi
  801e92:	89 fa                	mov    %edi,%edx
  801e94:	83 c4 1c             	add    $0x1c,%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5f                   	pop    %edi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    
  801e9c:	39 ce                	cmp    %ecx,%esi
  801e9e:	77 28                	ja     801ec8 <__udivdi3+0x7c>
  801ea0:	0f bd fe             	bsr    %esi,%edi
  801ea3:	83 f7 1f             	xor    $0x1f,%edi
  801ea6:	75 40                	jne    801ee8 <__udivdi3+0x9c>
  801ea8:	39 ce                	cmp    %ecx,%esi
  801eaa:	72 0a                	jb     801eb6 <__udivdi3+0x6a>
  801eac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801eb0:	0f 87 9e 00 00 00    	ja     801f54 <__udivdi3+0x108>
  801eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebb:	89 fa                	mov    %edi,%edx
  801ebd:	83 c4 1c             	add    $0x1c,%esp
  801ec0:	5b                   	pop    %ebx
  801ec1:	5e                   	pop    %esi
  801ec2:	5f                   	pop    %edi
  801ec3:	5d                   	pop    %ebp
  801ec4:	c3                   	ret    
  801ec5:	8d 76 00             	lea    0x0(%esi),%esi
  801ec8:	31 ff                	xor    %edi,%edi
  801eca:	31 c0                	xor    %eax,%eax
  801ecc:	89 fa                	mov    %edi,%edx
  801ece:	83 c4 1c             	add    $0x1c,%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5f                   	pop    %edi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    
  801ed6:	66 90                	xchg   %ax,%ax
  801ed8:	89 d8                	mov    %ebx,%eax
  801eda:	f7 f7                	div    %edi
  801edc:	31 ff                	xor    %edi,%edi
  801ede:	89 fa                	mov    %edi,%edx
  801ee0:	83 c4 1c             	add    $0x1c,%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5f                   	pop    %edi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    
  801ee8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801eed:	89 eb                	mov    %ebp,%ebx
  801eef:	29 fb                	sub    %edi,%ebx
  801ef1:	89 f9                	mov    %edi,%ecx
  801ef3:	d3 e6                	shl    %cl,%esi
  801ef5:	89 c5                	mov    %eax,%ebp
  801ef7:	88 d9                	mov    %bl,%cl
  801ef9:	d3 ed                	shr    %cl,%ebp
  801efb:	89 e9                	mov    %ebp,%ecx
  801efd:	09 f1                	or     %esi,%ecx
  801eff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f03:	89 f9                	mov    %edi,%ecx
  801f05:	d3 e0                	shl    %cl,%eax
  801f07:	89 c5                	mov    %eax,%ebp
  801f09:	89 d6                	mov    %edx,%esi
  801f0b:	88 d9                	mov    %bl,%cl
  801f0d:	d3 ee                	shr    %cl,%esi
  801f0f:	89 f9                	mov    %edi,%ecx
  801f11:	d3 e2                	shl    %cl,%edx
  801f13:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f17:	88 d9                	mov    %bl,%cl
  801f19:	d3 e8                	shr    %cl,%eax
  801f1b:	09 c2                	or     %eax,%edx
  801f1d:	89 d0                	mov    %edx,%eax
  801f1f:	89 f2                	mov    %esi,%edx
  801f21:	f7 74 24 0c          	divl   0xc(%esp)
  801f25:	89 d6                	mov    %edx,%esi
  801f27:	89 c3                	mov    %eax,%ebx
  801f29:	f7 e5                	mul    %ebp
  801f2b:	39 d6                	cmp    %edx,%esi
  801f2d:	72 19                	jb     801f48 <__udivdi3+0xfc>
  801f2f:	74 0b                	je     801f3c <__udivdi3+0xf0>
  801f31:	89 d8                	mov    %ebx,%eax
  801f33:	31 ff                	xor    %edi,%edi
  801f35:	e9 58 ff ff ff       	jmp    801e92 <__udivdi3+0x46>
  801f3a:	66 90                	xchg   %ax,%ax
  801f3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f40:	89 f9                	mov    %edi,%ecx
  801f42:	d3 e2                	shl    %cl,%edx
  801f44:	39 c2                	cmp    %eax,%edx
  801f46:	73 e9                	jae    801f31 <__udivdi3+0xe5>
  801f48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f4b:	31 ff                	xor    %edi,%edi
  801f4d:	e9 40 ff ff ff       	jmp    801e92 <__udivdi3+0x46>
  801f52:	66 90                	xchg   %ax,%ax
  801f54:	31 c0                	xor    %eax,%eax
  801f56:	e9 37 ff ff ff       	jmp    801e92 <__udivdi3+0x46>
  801f5b:	90                   	nop

00801f5c <__umoddi3>:
  801f5c:	55                   	push   %ebp
  801f5d:	57                   	push   %edi
  801f5e:	56                   	push   %esi
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 1c             	sub    $0x1c,%esp
  801f63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f67:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f7b:	89 f3                	mov    %esi,%ebx
  801f7d:	89 fa                	mov    %edi,%edx
  801f7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f83:	89 34 24             	mov    %esi,(%esp)
  801f86:	85 c0                	test   %eax,%eax
  801f88:	75 1a                	jne    801fa4 <__umoddi3+0x48>
  801f8a:	39 f7                	cmp    %esi,%edi
  801f8c:	0f 86 a2 00 00 00    	jbe    802034 <__umoddi3+0xd8>
  801f92:	89 c8                	mov    %ecx,%eax
  801f94:	89 f2                	mov    %esi,%edx
  801f96:	f7 f7                	div    %edi
  801f98:	89 d0                	mov    %edx,%eax
  801f9a:	31 d2                	xor    %edx,%edx
  801f9c:	83 c4 1c             	add    $0x1c,%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    
  801fa4:	39 f0                	cmp    %esi,%eax
  801fa6:	0f 87 ac 00 00 00    	ja     802058 <__umoddi3+0xfc>
  801fac:	0f bd e8             	bsr    %eax,%ebp
  801faf:	83 f5 1f             	xor    $0x1f,%ebp
  801fb2:	0f 84 ac 00 00 00    	je     802064 <__umoddi3+0x108>
  801fb8:	bf 20 00 00 00       	mov    $0x20,%edi
  801fbd:	29 ef                	sub    %ebp,%edi
  801fbf:	89 fe                	mov    %edi,%esi
  801fc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fc5:	89 e9                	mov    %ebp,%ecx
  801fc7:	d3 e0                	shl    %cl,%eax
  801fc9:	89 d7                	mov    %edx,%edi
  801fcb:	89 f1                	mov    %esi,%ecx
  801fcd:	d3 ef                	shr    %cl,%edi
  801fcf:	09 c7                	or     %eax,%edi
  801fd1:	89 e9                	mov    %ebp,%ecx
  801fd3:	d3 e2                	shl    %cl,%edx
  801fd5:	89 14 24             	mov    %edx,(%esp)
  801fd8:	89 d8                	mov    %ebx,%eax
  801fda:	d3 e0                	shl    %cl,%eax
  801fdc:	89 c2                	mov    %eax,%edx
  801fde:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fe2:	d3 e0                	shl    %cl,%eax
  801fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fec:	89 f1                	mov    %esi,%ecx
  801fee:	d3 e8                	shr    %cl,%eax
  801ff0:	09 d0                	or     %edx,%eax
  801ff2:	d3 eb                	shr    %cl,%ebx
  801ff4:	89 da                	mov    %ebx,%edx
  801ff6:	f7 f7                	div    %edi
  801ff8:	89 d3                	mov    %edx,%ebx
  801ffa:	f7 24 24             	mull   (%esp)
  801ffd:	89 c6                	mov    %eax,%esi
  801fff:	89 d1                	mov    %edx,%ecx
  802001:	39 d3                	cmp    %edx,%ebx
  802003:	0f 82 87 00 00 00    	jb     802090 <__umoddi3+0x134>
  802009:	0f 84 91 00 00 00    	je     8020a0 <__umoddi3+0x144>
  80200f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802013:	29 f2                	sub    %esi,%edx
  802015:	19 cb                	sbb    %ecx,%ebx
  802017:	89 d8                	mov    %ebx,%eax
  802019:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80201d:	d3 e0                	shl    %cl,%eax
  80201f:	89 e9                	mov    %ebp,%ecx
  802021:	d3 ea                	shr    %cl,%edx
  802023:	09 d0                	or     %edx,%eax
  802025:	89 e9                	mov    %ebp,%ecx
  802027:	d3 eb                	shr    %cl,%ebx
  802029:	89 da                	mov    %ebx,%edx
  80202b:	83 c4 1c             	add    $0x1c,%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5f                   	pop    %edi
  802031:	5d                   	pop    %ebp
  802032:	c3                   	ret    
  802033:	90                   	nop
  802034:	89 fd                	mov    %edi,%ebp
  802036:	85 ff                	test   %edi,%edi
  802038:	75 0b                	jne    802045 <__umoddi3+0xe9>
  80203a:	b8 01 00 00 00       	mov    $0x1,%eax
  80203f:	31 d2                	xor    %edx,%edx
  802041:	f7 f7                	div    %edi
  802043:	89 c5                	mov    %eax,%ebp
  802045:	89 f0                	mov    %esi,%eax
  802047:	31 d2                	xor    %edx,%edx
  802049:	f7 f5                	div    %ebp
  80204b:	89 c8                	mov    %ecx,%eax
  80204d:	f7 f5                	div    %ebp
  80204f:	89 d0                	mov    %edx,%eax
  802051:	e9 44 ff ff ff       	jmp    801f9a <__umoddi3+0x3e>
  802056:	66 90                	xchg   %ax,%ax
  802058:	89 c8                	mov    %ecx,%eax
  80205a:	89 f2                	mov    %esi,%edx
  80205c:	83 c4 1c             	add    $0x1c,%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5f                   	pop    %edi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    
  802064:	3b 04 24             	cmp    (%esp),%eax
  802067:	72 06                	jb     80206f <__umoddi3+0x113>
  802069:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80206d:	77 0f                	ja     80207e <__umoddi3+0x122>
  80206f:	89 f2                	mov    %esi,%edx
  802071:	29 f9                	sub    %edi,%ecx
  802073:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802077:	89 14 24             	mov    %edx,(%esp)
  80207a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80207e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802082:	8b 14 24             	mov    (%esp),%edx
  802085:	83 c4 1c             	add    $0x1c,%esp
  802088:	5b                   	pop    %ebx
  802089:	5e                   	pop    %esi
  80208a:	5f                   	pop    %edi
  80208b:	5d                   	pop    %ebp
  80208c:	c3                   	ret    
  80208d:	8d 76 00             	lea    0x0(%esi),%esi
  802090:	2b 04 24             	sub    (%esp),%eax
  802093:	19 fa                	sbb    %edi,%edx
  802095:	89 d1                	mov    %edx,%ecx
  802097:	89 c6                	mov    %eax,%esi
  802099:	e9 71 ff ff ff       	jmp    80200f <__umoddi3+0xb3>
  80209e:	66 90                	xchg   %ax,%ax
  8020a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020a4:	72 ea                	jb     802090 <__umoddi3+0x134>
  8020a6:	89 d9                	mov    %ebx,%ecx
  8020a8:	e9 62 ff ff ff       	jmp    80200f <__umoddi3+0xb3>
