
obj/user/tst_mod_2:     file format elf32-i386


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
  800031:	e8 2b 08 00 00       	call   800861 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */
#include <inc/lib.h>

int CheckWSEntries(volatile struct Env* e, uint32 startVA, uint32 endVA) ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	int envID = sys_getenvid();
  800042:	e8 fa 1c 00 00       	call   801d41 <sys_getenvid>
  800047:	89 45 e8             	mov    %eax,-0x18(%ebp)
	cprintf("envID = %d\n",envID);
  80004a:	83 ec 08             	sub    $0x8,%esp
  80004d:	ff 75 e8             	pushl  -0x18(%ebp)
  800050:	68 80 25 80 00       	push   $0x802580
  800055:	e8 ee 0b 00 00       	call   800c48 <cprintf>
  80005a:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  80005d:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  800064:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)

	int numOfFreeWSEntries = 0;
  80006b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//("STEP 0: checking Initial WS free size...\n");
	{
		int i;
		for (i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800079:	eb 20                	jmp    80009b <_main+0x63>
		{
			if( myEnv->__uptr_pws[i].empty == 1)
  80007b:	a1 20 40 80 00       	mov    0x804020,%eax
  800080:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800086:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800089:	c1 e2 04             	shl    $0x4,%edx
  80008c:	01 d0                	add    %edx,%eax
  80008e:	8a 40 04             	mov    0x4(%eax),%al
  800091:	3c 01                	cmp    $0x1,%al
  800093:	75 03                	jne    800098 <_main+0x60>
				numOfFreeWSEntries++ ;
  800095:	ff 45 f4             	incl   -0xc(%ebp)

	int numOfFreeWSEntries = 0;
	//("STEP 0: checking Initial WS free size...\n");
	{
		int i;
		for (i = 0; i < myEnv->page_WS_max_size; ++i)
  800098:	ff 45 f0             	incl   -0x10(%ebp)
  80009b:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a0:	8b 50 74             	mov    0x74(%eax),%edx
  8000a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a6:	39 c2                	cmp    %eax,%edx
  8000a8:	77 d1                	ja     80007b <_main+0x43>
		{
			if( myEnv->__uptr_pws[i].empty == 1)
				numOfFreeWSEntries++ ;
		}

		assert(numOfFreeWSEntries == (myEnv->page_WS_max_size - myEnv->page_last_WS_index));
  8000aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8000af:	8b 50 74             	mov    0x74(%eax),%edx
  8000b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8000b7:	8b 80 18 3c 01 00    	mov    0x13c18(%eax),%eax
  8000bd:	29 c2                	sub    %eax,%edx
  8000bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c2:	39 c2                	cmp    %eax,%edx
  8000c4:	74 16                	je     8000dc <_main+0xa4>
  8000c6:	68 8c 25 80 00       	push   $0x80258c
  8000cb:	68 d8 25 80 00       	push   $0x8025d8
  8000d0:	6a 19                	push   $0x19
  8000d2:	68 ed 25 80 00       	push   $0x8025ed
  8000d7:	e8 ca 08 00 00       	call   8009a6 <_panic>
	}


	{
		//allocate Half WS free size in the heap [Should alloc in RAM and Page File]
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000dc:	e8 c7 1d 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  8000e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000e4:	e8 3c 1d 00 00       	call   801e25 <sys_calculate_free_frames>
  8000e9:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int numOfReqPages1 = numOfFreeWSEntries/2 ;
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	89 c2                	mov    %eax,%edx
  8000f1:	c1 ea 1f             	shr    $0x1f,%edx
  8000f4:	01 d0                	add    %edx,%eax
  8000f6:	d1 f8                	sar    %eax
  8000f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int numOfReqTables1 = ROUNDUP(numOfReqPages1, 1024) / 1024;
  8000fb:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
  800102:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800105:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800108:	01 d0                	add    %edx,%eax
  80010a:	48                   	dec    %eax
  80010b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80010e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800111:	ba 00 00 00 00       	mov    $0x0,%edx
  800116:	f7 75 d0             	divl   -0x30(%ebp)
  800119:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80011c:	29 d0                	sub    %edx,%eax
  80011e:	85 c0                	test   %eax,%eax
  800120:	79 05                	jns    800127 <_main+0xef>
  800122:	05 ff 03 00 00       	add    $0x3ff,%eax
  800127:	c1 f8 0a             	sar    $0xa,%eax
  80012a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int size1 = numOfReqPages1 * PAGE_SIZE;
  80012d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800130:	c1 e0 0c             	shl    $0xc,%eax
  800133:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int8 *x1 = malloc(size1) ;
  800136:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	50                   	push   %eax
  80013d:	e8 90 18 00 00       	call   8019d2 <malloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 c0             	mov    %eax,-0x40(%ebp)
		assert((uint32) x1 == USER_HEAP_START);
  800148:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80014b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800150:	74 16                	je     800168 <_main+0x130>
  800152:	68 00 26 80 00       	push   $0x802600
  800157:	68 d8 25 80 00       	push   $0x8025d8
  80015c:	6a 26                	push   $0x26
  80015e:	68 ed 25 80 00       	push   $0x8025ed
  800163:	e8 3e 08 00 00       	call   8009a6 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (2*numOfReqTables1 + numOfReqPages1));
  800168:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80016b:	e8 b5 1c 00 00       	call   801e25 <sys_calculate_free_frames>
  800170:	29 c3                	sub    %eax,%ebx
  800172:	89 da                	mov    %ebx,%edx
  800174:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800177:	01 c0                	add    %eax,%eax
  800179:	89 c1                	mov    %eax,%ecx
  80017b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80017e:	01 c8                	add    %ecx,%eax
  800180:	39 c2                	cmp    %eax,%edx
  800182:	74 16                	je     80019a <_main+0x162>
  800184:	68 20 26 80 00       	push   $0x802620
  800189:	68 d8 25 80 00       	push   $0x8025d8
  80018e:	6a 27                	push   $0x27
  800190:	68 ed 25 80 00       	push   $0x8025ed
  800195:	e8 0c 08 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == numOfReqPages1);
  80019a:	e8 09 1d 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  80019f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8001a2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001a5:	74 16                	je     8001bd <_main+0x185>
  8001a7:	68 74 26 80 00       	push   $0x802674
  8001ac:	68 d8 25 80 00       	push   $0x8025d8
  8001b1:	6a 28                	push   $0x28
  8001b3:	68 ed 25 80 00       	push   $0x8025ed
  8001b8:	e8 e9 07 00 00       	call   8009a6 <_panic>
		assert(CheckWSEntries(myEnv, (uint32)x1, (uint32)x1+size1) == numOfReqPages1);
  8001bd:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8001c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8001c6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	51                   	push   %ecx
  8001d2:	52                   	push   %edx
  8001d3:	50                   	push   %eax
  8001d4:	e8 e7 05 00 00       	call   8007c0 <CheckWSEntries>
  8001d9:	83 c4 10             	add    $0x10,%esp
  8001dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001df:	74 16                	je     8001f7 <_main+0x1bf>
  8001e1:	68 bc 26 80 00       	push   $0x8026bc
  8001e6:	68 d8 25 80 00       	push   $0x8025d8
  8001eb:	6a 29                	push   $0x29
  8001ed:	68 ed 25 80 00       	push   $0x8025ed
  8001f2:	e8 af 07 00 00       	call   8009a6 <_panic>

		//allocate original WS free size in the heap [should not be all. in RAM]
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f7:	e8 ac 1c 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  8001fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001ff:	e8 21 1c 00 00       	call   801e25 <sys_calculate_free_frames>
  800204:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int numOfReqPages2 = numOfFreeWSEntries ;
  800207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80020a:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int numOfReqTables2 = (ROUNDUP(numOfReqPages1+numOfReqPages2, 1024) - ROUNDUP(numOfReqPages1, 1024)) / 1024;
  80020d:	c7 45 b8 00 04 00 00 	movl   $0x400,-0x48(%ebp)
  800214:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800217:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80021a:	01 d0                	add    %edx,%eax
  80021c:	89 c2                	mov    %eax,%edx
  80021e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800221:	01 d0                	add    %edx,%eax
  800223:	48                   	dec    %eax
  800224:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800227:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80022a:	ba 00 00 00 00       	mov    $0x0,%edx
  80022f:	f7 75 b8             	divl   -0x48(%ebp)
  800232:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800235:	29 d0                	sub    %edx,%eax
  800237:	89 c1                	mov    %eax,%ecx
  800239:	c7 45 b0 00 04 00 00 	movl   $0x400,-0x50(%ebp)
  800240:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800243:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	48                   	dec    %eax
  800249:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80024c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80024f:	ba 00 00 00 00       	mov    $0x0,%edx
  800254:	f7 75 b0             	divl   -0x50(%ebp)
  800257:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80025a:	29 d0                	sub    %edx,%eax
  80025c:	29 c1                	sub    %eax,%ecx
  80025e:	89 c8                	mov    %ecx,%eax
  800260:	85 c0                	test   %eax,%eax
  800262:	79 05                	jns    800269 <_main+0x231>
  800264:	05 ff 03 00 00       	add    $0x3ff,%eax
  800269:	c1 f8 0a             	sar    $0xa,%eax
  80026c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int size2 = numOfReqPages2 * PAGE_SIZE;
  80026f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800272:	c1 e0 0c             	shl    $0xc,%eax
  800275:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		int8 *x2 = malloc(size2);
  800278:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	50                   	push   %eax
  80027f:	e8 4e 17 00 00       	call   8019d2 <malloc>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 a0             	mov    %eax,-0x60(%ebp)
		assert((uint32) x2 == USER_HEAP_START + size1);
  80028a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80028d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800293:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800296:	39 c2                	cmp    %eax,%edx
  800298:	74 16                	je     8002b0 <_main+0x278>
  80029a:	68 04 27 80 00       	push   $0x802704
  80029f:	68 d8 25 80 00       	push   $0x8025d8
  8002a4:	6a 32                	push   $0x32
  8002a6:	68 ed 25 80 00       	push   $0x8025ed
  8002ab:	e8 f6 06 00 00       	call   8009a6 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1*numOfReqTables2));
  8002b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8002b3:	e8 6d 1b 00 00       	call   801e25 <sys_calculate_free_frames>
  8002b8:	29 c3                	sub    %eax,%ebx
  8002ba:	89 da                	mov    %ebx,%edx
  8002bc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002bf:	39 c2                	cmp    %eax,%edx
  8002c1:	74 16                	je     8002d9 <_main+0x2a1>
  8002c3:	68 2c 27 80 00       	push   $0x80272c
  8002c8:	68 d8 25 80 00       	push   $0x8025d8
  8002cd:	6a 33                	push   $0x33
  8002cf:	68 ed 25 80 00       	push   $0x8025ed
  8002d4:	e8 cd 06 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == numOfReqPages2);
  8002d9:	e8 ca 1b 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  8002de:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002e1:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8002e4:	74 16                	je     8002fc <_main+0x2c4>
  8002e6:	68 70 27 80 00       	push   $0x802770
  8002eb:	68 d8 25 80 00       	push   $0x8025d8
  8002f0:	6a 34                	push   $0x34
  8002f2:	68 ed 25 80 00       	push   $0x8025ed
  8002f7:	e8 aa 06 00 00       	call   8009a6 <_panic>
		assert(CheckWSEntries(myEnv, (uint32)x2, (uint32)x2+size2) == 0);
  8002fc:	8b 55 a0             	mov    -0x60(%ebp),%edx
  8002ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800302:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800305:	8b 55 a0             	mov    -0x60(%ebp),%edx
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	51                   	push   %ecx
  800311:	52                   	push   %edx
  800312:	50                   	push   %eax
  800313:	e8 a8 04 00 00       	call   8007c0 <CheckWSEntries>
  800318:	83 c4 10             	add    $0x10,%esp
  80031b:	85 c0                	test   %eax,%eax
  80031d:	74 16                	je     800335 <_main+0x2fd>
  80031f:	68 b8 27 80 00       	push   $0x8027b8
  800324:	68 d8 25 80 00       	push   $0x8025d8
  800329:	6a 35                	push   $0x35
  80032b:	68 ed 25 80 00       	push   $0x8025ed
  800330:	e8 71 06 00 00       	call   8009a6 <_panic>

		//allocate Half the remaining WS free size in the heap [Should alloc in RAM and Page File]
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800335:	e8 6e 1b 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  80033a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80033d:	e8 e3 1a 00 00       	call   801e25 <sys_calculate_free_frames>
  800342:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int numOfReqPages3 = (numOfFreeWSEntries - numOfReqPages1) /2 ;
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80034b:	89 c2                	mov    %eax,%edx
  80034d:	c1 ea 1f             	shr    $0x1f,%edx
  800350:	01 d0                	add    %edx,%eax
  800352:	d1 f8                	sar    %eax
  800354:	89 45 9c             	mov    %eax,-0x64(%ebp)
		int numOfReqTables3 = (ROUNDUP(numOfReqPages1+numOfReqPages2+numOfReqPages3, 1024) - ROUNDUP(numOfReqPages1+numOfReqPages2, 1024)) / 1024;
  800357:	c7 45 98 00 04 00 00 	movl   $0x400,-0x68(%ebp)
  80035e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800361:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	89 c2                	mov    %eax,%edx
  80036d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	48                   	dec    %eax
  800373:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800376:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800379:	ba 00 00 00 00       	mov    $0x0,%edx
  80037e:	f7 75 98             	divl   -0x68(%ebp)
  800381:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800384:	29 d0                	sub    %edx,%eax
  800386:	89 c1                	mov    %eax,%ecx
  800388:	c7 45 90 00 04 00 00 	movl   $0x400,-0x70(%ebp)
  80038f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800392:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	89 c2                	mov    %eax,%edx
  800399:	8b 45 90             	mov    -0x70(%ebp),%eax
  80039c:	01 d0                	add    %edx,%eax
  80039e:	48                   	dec    %eax
  80039f:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8003a2:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	f7 75 90             	divl   -0x70(%ebp)
  8003ad:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003b0:	29 d0                	sub    %edx,%eax
  8003b2:	29 c1                	sub    %eax,%ecx
  8003b4:	89 c8                	mov    %ecx,%eax
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	79 05                	jns    8003bf <_main+0x387>
  8003ba:	05 ff 03 00 00       	add    $0x3ff,%eax
  8003bf:	c1 f8 0a             	sar    $0xa,%eax
  8003c2:	89 45 88             	mov    %eax,-0x78(%ebp)
		int extraTable = 0;
  8003c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (numOfReqTables2 > 0)
  8003cc:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  8003d0:	7e 07                	jle    8003d9 <_main+0x3a1>
			extraTable = 1; //as numOfReqTables2 is not allocated in RAM for the prev. alloc.
  8003d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
		int size3 = numOfReqPages3 * PAGE_SIZE;
  8003d9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003dc:	c1 e0 0c             	shl    $0xc,%eax
  8003df:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int8 *x3 = malloc(size3);
  8003e2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 e4 15 00 00       	call   8019d2 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 80             	mov    %eax,-0x80(%ebp)
		assert((uint32) x3 == USER_HEAP_START + size1 + size2);
  8003f4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	01 d0                	add    %edx,%eax
  8003fc:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800402:	8b 45 80             	mov    -0x80(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	74 16                	je     80041f <_main+0x3e7>
  800409:	68 f4 27 80 00       	push   $0x8027f4
  80040e:	68 d8 25 80 00       	push   $0x8025d8
  800413:	6a 41                	push   $0x41
  800415:	68 ed 25 80 00       	push   $0x8025ed
  80041a:	e8 87 05 00 00       	call   8009a6 <_panic>
//		cprintf("startVA = %x, size = %x, numOfReqTables = %d, numOfReqPages = %d\n", x3, size3, numOfReqTables3,numOfReqPages3);
//		cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames());
		assert((freeFrames - sys_calculate_free_frames()) == (extraTable + 2*numOfReqTables3 + numOfReqPages3));
  80041f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800422:	e8 fe 19 00 00       	call   801e25 <sys_calculate_free_frames>
  800427:	29 c3                	sub    %eax,%ebx
  800429:	89 da                	mov    %ebx,%edx
  80042b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80042e:	01 c0                	add    %eax,%eax
  800430:	89 c1                	mov    %eax,%ecx
  800432:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800435:	01 c1                	add    %eax,%ecx
  800437:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	74 16                	je     800456 <_main+0x41e>
  800440:	68 24 28 80 00       	push   $0x802824
  800445:	68 d8 25 80 00       	push   $0x8025d8
  80044a:	6a 44                	push   $0x44
  80044c:	68 ed 25 80 00       	push   $0x8025ed
  800451:	e8 50 05 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == numOfReqPages3);
  800456:	e8 4d 1a 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  80045b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80045e:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800461:	74 16                	je     800479 <_main+0x441>
  800463:	68 84 28 80 00       	push   $0x802884
  800468:	68 d8 25 80 00       	push   $0x8025d8
  80046d:	6a 45                	push   $0x45
  80046f:	68 ed 25 80 00       	push   $0x8025ed
  800474:	e8 2d 05 00 00       	call   8009a6 <_panic>
		assert(CheckWSEntries(myEnv, (uint32)x3, (uint32)x3+size3) == numOfReqPages3);
  800479:	8b 55 80             	mov    -0x80(%ebp),%edx
  80047c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80047f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800482:	8b 55 80             	mov    -0x80(%ebp),%edx
  800485:	a1 20 40 80 00       	mov    0x804020,%eax
  80048a:	83 ec 04             	sub    $0x4,%esp
  80048d:	51                   	push   %ecx
  80048e:	52                   	push   %edx
  80048f:	50                   	push   %eax
  800490:	e8 2b 03 00 00       	call   8007c0 <CheckWSEntries>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80049b:	74 16                	je     8004b3 <_main+0x47b>
  80049d:	68 cc 28 80 00       	push   $0x8028cc
  8004a2:	68 d8 25 80 00       	push   $0x8025d8
  8004a7:	6a 46                	push   $0x46
  8004a9:	68 ed 25 80 00       	push   $0x8025ed
  8004ae:	e8 f3 04 00 00       	call   8009a6 <_panic>

		//allocate half original WS free size in the heap [should not be all. in RAM]
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004b3:	e8 f0 19 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  8004b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8004bb:	e8 65 19 00 00       	call   801e25 <sys_calculate_free_frames>
  8004c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int numOfReqPages4 = numOfFreeWSEntries/2 ;
  8004c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c6:	89 c2                	mov    %eax,%edx
  8004c8:	c1 ea 1f             	shr    $0x1f,%edx
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	d1 f8                	sar    %eax
  8004cf:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		int numOfReqTables4 = (ROUNDUP(numOfReqPages1+numOfReqPages2+numOfReqPages3+numOfReqPages4, 1024) - ROUNDUP(numOfReqPages1+numOfReqPages2+numOfReqPages3, 1024)) / 1024;
  8004d5:	c7 85 78 ff ff ff 00 	movl   $0x400,-0x88(%ebp)
  8004dc:	04 00 00 
  8004df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004e5:	01 c2                	add    %eax,%edx
  8004e7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ea:	01 c2                	add    %eax,%edx
  8004ec:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	89 c2                	mov    %eax,%edx
  8004f6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004fc:	01 d0                	add    %edx,%eax
  8004fe:	48                   	dec    %eax
  8004ff:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  800505:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80050b:	ba 00 00 00 00       	mov    $0x0,%edx
  800510:	f7 b5 78 ff ff ff    	divl   -0x88(%ebp)
  800516:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80051c:	29 d0                	sub    %edx,%eax
  80051e:	89 c1                	mov    %eax,%ecx
  800520:	c7 85 70 ff ff ff 00 	movl   $0x400,-0x90(%ebp)
  800527:	04 00 00 
  80052a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80052d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800530:	01 c2                	add    %eax,%edx
  800532:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	89 c2                	mov    %eax,%edx
  800539:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	48                   	dec    %eax
  800542:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800548:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80054e:	ba 00 00 00 00       	mov    $0x0,%edx
  800553:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  800559:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80055f:	29 d0                	sub    %edx,%eax
  800561:	29 c1                	sub    %eax,%ecx
  800563:	89 c8                	mov    %ecx,%eax
  800565:	85 c0                	test   %eax,%eax
  800567:	79 05                	jns    80056e <_main+0x536>
  800569:	05 ff 03 00 00       	add    $0x3ff,%eax
  80056e:	c1 f8 0a             	sar    $0xa,%eax
  800571:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		int size4 = numOfReqPages4 * PAGE_SIZE;
  800577:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80057d:	c1 e0 0c             	shl    $0xc,%eax
  800580:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		int8 *x4 = malloc(size4);
  800586:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	50                   	push   %eax
  800590:	e8 3d 14 00 00       	call   8019d2 <malloc>
  800595:	83 c4 10             	add    $0x10,%esp
  800598:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		assert((uint32) x4 == USER_HEAP_START + size1 + size2 + size3);
  80059e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005a1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8005a4:	01 c2                	add    %eax,%edx
  8005a6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8005b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8005b7:	39 c2                	cmp    %eax,%edx
  8005b9:	74 16                	je     8005d1 <_main+0x599>
  8005bb:	68 14 29 80 00       	push   $0x802914
  8005c0:	68 d8 25 80 00       	push   $0x8025d8
  8005c5:	6a 4f                	push   $0x4f
  8005c7:	68 ed 25 80 00       	push   $0x8025ed
  8005cc:	e8 d5 03 00 00       	call   8009a6 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1*numOfReqTables4));
  8005d1:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005d4:	e8 4c 18 00 00       	call   801e25 <sys_calculate_free_frames>
  8005d9:	29 c3                	sub    %eax,%ebx
  8005db:	89 da                	mov    %ebx,%edx
  8005dd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8005e3:	39 c2                	cmp    %eax,%edx
  8005e5:	74 16                	je     8005fd <_main+0x5c5>
  8005e7:	68 4c 29 80 00       	push   $0x80294c
  8005ec:	68 d8 25 80 00       	push   $0x8025d8
  8005f1:	6a 50                	push   $0x50
  8005f3:	68 ed 25 80 00       	push   $0x8025ed
  8005f8:	e8 a9 03 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == numOfReqPages4);
  8005fd:	e8 a6 18 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  800602:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800605:	3b 85 7c ff ff ff    	cmp    -0x84(%ebp),%eax
  80060b:	74 16                	je     800623 <_main+0x5eb>
  80060d:	68 90 29 80 00       	push   $0x802990
  800612:	68 d8 25 80 00       	push   $0x8025d8
  800617:	6a 51                	push   $0x51
  800619:	68 ed 25 80 00       	push   $0x8025ed
  80061e:	e8 83 03 00 00       	call   8009a6 <_panic>
		assert(CheckWSEntries(myEnv, (uint32)x4, (uint32)x4+size4) == 0);
  800623:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800629:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80062f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800632:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800638:	a1 20 40 80 00       	mov    0x804020,%eax
  80063d:	83 ec 04             	sub    $0x4,%esp
  800640:	51                   	push   %ecx
  800641:	52                   	push   %edx
  800642:	50                   	push   %eax
  800643:	e8 78 01 00 00       	call   8007c0 <CheckWSEntries>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	85 c0                	test   %eax,%eax
  80064d:	74 16                	je     800665 <_main+0x62d>
  80064f:	68 d8 29 80 00       	push   $0x8029d8
  800654:	68 d8 25 80 00       	push   $0x8025d8
  800659:	6a 52                	push   $0x52
  80065b:	68 ed 25 80 00       	push   $0x8025ed
  800660:	e8 41 03 00 00       	call   8009a6 <_panic>

		//Access already allocated in RAM and Page File
		freeFrames = sys_calculate_free_frames() ;
  800665:	e8 bb 17 00 00       	call   801e25 <sys_calculate_free_frames>
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80066d:	e8 36 18 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  800672:	89 45 dc             	mov    %eax,-0x24(%ebp)
		{
			x1[0] = -1 ;
  800675:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800678:	c6 00 ff             	movb   $0xff,(%eax)
			x3[0] = -1 ;
  80067b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80067e:	c6 00 ff             	movb   $0xff,(%eax)
		}
		assert(x1[0] == -1);
  800681:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800684:	8a 00                	mov    (%eax),%al
  800686:	3c ff                	cmp    $0xff,%al
  800688:	74 16                	je     8006a0 <_main+0x668>
  80068a:	68 11 2a 80 00       	push   $0x802a11
  80068f:	68 d8 25 80 00       	push   $0x8025d8
  800694:	6a 5b                	push   $0x5b
  800696:	68 ed 25 80 00       	push   $0x8025ed
  80069b:	e8 06 03 00 00       	call   8009a6 <_panic>
		assert(x3[0] == -1);
  8006a0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8006a3:	8a 00                	mov    (%eax),%al
  8006a5:	3c ff                	cmp    $0xff,%al
  8006a7:	74 16                	je     8006bf <_main+0x687>
  8006a9:	68 1d 2a 80 00       	push   $0x802a1d
  8006ae:	68 d8 25 80 00       	push   $0x8025d8
  8006b3:	6a 5c                	push   $0x5c
  8006b5:	68 ed 25 80 00       	push   $0x8025ed
  8006ba:	e8 e7 02 00 00       	call   8009a6 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 0 );
  8006bf:	e8 61 17 00 00       	call   801e25 <sys_calculate_free_frames>
  8006c4:	89 c2                	mov    %eax,%edx
  8006c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c9:	39 c2                	cmp    %eax,%edx
  8006cb:	74 16                	je     8006e3 <_main+0x6ab>
  8006cd:	68 2c 2a 80 00       	push   $0x802a2c
  8006d2:	68 d8 25 80 00       	push   $0x8025d8
  8006d7:	6a 5d                	push   $0x5d
  8006d9:	68 ed 25 80 00       	push   $0x8025ed
  8006de:	e8 c3 02 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  8006e3:	e8 c0 17 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  8006e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006eb:	74 16                	je     800703 <_main+0x6cb>
  8006ed:	68 5c 2a 80 00       	push   $0x802a5c
  8006f2:	68 d8 25 80 00       	push   $0x8025d8
  8006f7:	6a 5e                	push   $0x5e
  8006f9:	68 ed 25 80 00       	push   $0x8025ed
  8006fe:	e8 a3 02 00 00       	call   8009a6 <_panic>

		//Access allocated in Page File ONLY
		freeFrames = sys_calculate_free_frames() ;
  800703:	e8 1d 17 00 00       	call   801e25 <sys_calculate_free_frames>
  800708:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80070b:	e8 98 17 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  800710:	89 45 dc             	mov    %eax,-0x24(%ebp)
		{
			x2[0] = -1 ;
  800713:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800716:	c6 00 ff             	movb   $0xff,(%eax)
			x4[0] = -1 ;
  800719:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80071f:	c6 00 ff             	movb   $0xff,(%eax)
		}
		assert(x2[0] == -1);
  800722:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800725:	8a 00                	mov    (%eax),%al
  800727:	3c ff                	cmp    $0xff,%al
  800729:	74 16                	je     800741 <_main+0x709>
  80072b:	68 96 2a 80 00       	push   $0x802a96
  800730:	68 d8 25 80 00       	push   $0x8025d8
  800735:	6a 67                	push   $0x67
  800737:	68 ed 25 80 00       	push   $0x8025ed
  80073c:	e8 65 02 00 00       	call   8009a6 <_panic>
		assert(x4[0] == -1);
  800741:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800747:	8a 00                	mov    (%eax),%al
  800749:	3c ff                	cmp    $0xff,%al
  80074b:	74 16                	je     800763 <_main+0x72b>
  80074d:	68 a2 2a 80 00       	push   $0x802aa2
  800752:	68 d8 25 80 00       	push   $0x8025d8
  800757:	6a 68                	push   $0x68
  800759:	68 ed 25 80 00       	push   $0x8025ed
  80075e:	e8 43 02 00 00       	call   8009a6 <_panic>
		
		assert((freeFrames - sys_calculate_free_frames()) >= 2);
  800763:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800766:	e8 ba 16 00 00       	call   801e25 <sys_calculate_free_frames>
  80076b:	29 c3                	sub    %eax,%ebx
  80076d:	89 d8                	mov    %ebx,%eax
  80076f:	83 f8 01             	cmp    $0x1,%eax
  800772:	77 16                	ja     80078a <_main+0x752>
  800774:	68 b0 2a 80 00       	push   $0x802ab0
  800779:	68 d8 25 80 00       	push   $0x8025d8
  80077e:	6a 6a                	push   $0x6a
  800780:	68 ed 25 80 00       	push   $0x8025ed
  800785:	e8 1c 02 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  80078a:	e8 19 17 00 00       	call   801ea8 <sys_pf_calculate_allocated_pages>
  80078f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800792:	74 16                	je     8007aa <_main+0x772>
  800794:	68 5c 2a 80 00       	push   $0x802a5c
  800799:	68 d8 25 80 00       	push   $0x8025d8
  80079e:	6a 6b                	push   $0x6b
  8007a0:	68 ed 25 80 00       	push   $0x8025ed
  8007a5:	e8 fc 01 00 00       	call   8009a6 <_panic>

	}
	cprintf("Congratulations!! your modification is completed successfully.\n");
  8007aa:	83 ec 0c             	sub    $0xc,%esp
  8007ad:	68 e0 2a 80 00       	push   $0x802ae0
  8007b2:	e8 91 04 00 00       	call   800c48 <cprintf>
  8007b7:	83 c4 10             	add    $0x10,%esp

	return;
  8007ba:	90                   	nop
}
  8007bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <CheckWSEntries>:



int CheckWSEntries(volatile struct Env* e, uint32 startVA, uint32 endVA)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 20             	sub    $0x20,%esp
	uint32 va ;
	startVA = ROUNDDOWN(startVA, PAGE_SIZE);
  8007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 45 0c             	mov    %eax,0xc(%ebp)
	endVA = ROUNDUP(endVA, PAGE_SIZE);
  8007d7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8007de:	8b 55 10             	mov    0x10(%ebp),%edx
  8007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e4:	01 d0                	add    %edx,%eax
  8007e6:	48                   	dec    %eax
  8007e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8007ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f2:	f7 75 ec             	divl   -0x14(%ebp)
  8007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007f8:	29 d0                	sub    %edx,%eax
  8007fa:	89 45 10             	mov    %eax,0x10(%ebp)
	int totalNumOfFound = 0 ;
  8007fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (va = startVA; va < endVA; va+=PAGE_SIZE)
  800804:	8b 45 0c             	mov    0xc(%ebp),%eax
  800807:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80080a:	eb 48                	jmp    800854 <CheckWSEntries+0x94>
	{
		int i;
		for (i = 0; i < e->page_WS_max_size; ++i)
  80080c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800813:	eb 2b                	jmp    800840 <CheckWSEntries+0x80>
		{
			if( ROUNDDOWN(e->__uptr_pws[i].virtual_address,PAGE_SIZE) == va)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80081e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800821:	c1 e2 04             	shl    $0x4,%edx
  800824:	01 d0                	add    %edx,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80082b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80082e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800833:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800836:	75 05                	jne    80083d <CheckWSEntries+0x7d>
			{
				totalNumOfFound++ ;
  800838:	ff 45 f8             	incl   -0x8(%ebp)
				break;
  80083b:	eb 10                	jmp    80084d <CheckWSEntries+0x8d>
	endVA = ROUNDUP(endVA, PAGE_SIZE);
	int totalNumOfFound = 0 ;
	for (va = startVA; va < endVA; va+=PAGE_SIZE)
	{
		int i;
		for (i = 0; i < e->page_WS_max_size; ++i)
  80083d:	ff 45 f4             	incl   -0xc(%ebp)
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	8b 50 74             	mov    0x74(%eax),%edx
  800846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800849:	39 c2                	cmp    %eax,%edx
  80084b:	77 c8                	ja     800815 <CheckWSEntries+0x55>
{
	uint32 va ;
	startVA = ROUNDDOWN(startVA, PAGE_SIZE);
	endVA = ROUNDUP(endVA, PAGE_SIZE);
	int totalNumOfFound = 0 ;
	for (va = startVA; va < endVA; va+=PAGE_SIZE)
  80084d:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%ebp)
  800854:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800857:	3b 45 10             	cmp    0x10(%ebp),%eax
  80085a:	72 b0                	jb     80080c <CheckWSEntries+0x4c>
				totalNumOfFound++ ;
				break;
			}
		}
	}
	return totalNumOfFound;
  80085c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800867:	e8 ee 14 00 00       	call   801d5a <sys_getenvindex>
  80086c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80086f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800872:	89 d0                	mov    %edx,%eax
  800874:	c1 e0 03             	shl    $0x3,%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800880:	01 c8                	add    %ecx,%eax
  800882:	01 c0                	add    %eax,%eax
  800884:	01 d0                	add    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	89 c2                	mov    %eax,%edx
  80088c:	c1 e2 05             	shl    $0x5,%edx
  80088f:	29 c2                	sub    %eax,%edx
  800891:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800898:	89 c2                	mov    %eax,%edx
  80089a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8008a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8008a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8008aa:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8008b0:	84 c0                	test   %al,%al
  8008b2:	74 0f                	je     8008c3 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8008b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8008b9:	05 40 3c 01 00       	add    $0x13c40,%eax
  8008be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008c7:	7e 0a                	jle    8008d3 <libmain+0x72>
		binaryname = argv[0];
  8008c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	ff 75 08             	pushl  0x8(%ebp)
  8008dc:	e8 57 f7 ff ff       	call   800038 <_main>
  8008e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008e4:	e8 0c 16 00 00       	call   801ef5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008e9:	83 ec 0c             	sub    $0xc,%esp
  8008ec:	68 38 2b 80 00       	push   $0x802b38
  8008f1:	e8 52 03 00 00       	call   800c48 <cprintf>
  8008f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8008fe:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800904:	a1 20 40 80 00       	mov    0x804020,%eax
  800909:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80090f:	83 ec 04             	sub    $0x4,%esp
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	68 60 2b 80 00       	push   $0x802b60
  800919:	e8 2a 03 00 00       	call   800c48 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800921:	a1 20 40 80 00       	mov    0x804020,%eax
  800926:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80092c:	a1 20 40 80 00       	mov    0x804020,%eax
  800931:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800937:	83 ec 04             	sub    $0x4,%esp
  80093a:	52                   	push   %edx
  80093b:	50                   	push   %eax
  80093c:	68 88 2b 80 00       	push   $0x802b88
  800941:	e8 02 03 00 00       	call   800c48 <cprintf>
  800946:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800949:	a1 20 40 80 00       	mov    0x804020,%eax
  80094e:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	50                   	push   %eax
  800958:	68 c9 2b 80 00       	push   $0x802bc9
  80095d:	e8 e6 02 00 00       	call   800c48 <cprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800965:	83 ec 0c             	sub    $0xc,%esp
  800968:	68 38 2b 80 00       	push   $0x802b38
  80096d:	e8 d6 02 00 00       	call   800c48 <cprintf>
  800972:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800975:	e8 95 15 00 00       	call   801f0f <sys_enable_interrupt>

	// exit gracefully
	exit();
  80097a:	e8 19 00 00 00       	call   800998 <exit>
}
  80097f:	90                   	nop
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800988:	83 ec 0c             	sub    $0xc,%esp
  80098b:	6a 00                	push   $0x0
  80098d:	e8 94 13 00 00       	call   801d26 <sys_env_destroy>
  800992:	83 c4 10             	add    $0x10,%esp
}
  800995:	90                   	nop
  800996:	c9                   	leave  
  800997:	c3                   	ret    

00800998 <exit>:

void
exit(void)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80099e:	e8 e9 13 00 00       	call   801d8c <sys_env_exit>
}
  8009a3:	90                   	nop
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    

008009a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8009af:	83 c0 04             	add    $0x4,%eax
  8009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b5:	a1 18 41 80 00       	mov    0x804118,%eax
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	74 16                	je     8009d4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009be:	a1 18 41 80 00       	mov    0x804118,%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	50                   	push   %eax
  8009c7:	68 e0 2b 80 00       	push   $0x802be0
  8009cc:	e8 77 02 00 00       	call   800c48 <cprintf>
  8009d1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d4:	a1 00 40 80 00       	mov    0x804000,%eax
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	ff 75 08             	pushl  0x8(%ebp)
  8009df:	50                   	push   %eax
  8009e0:	68 e5 2b 80 00       	push   $0x802be5
  8009e5:	e8 5e 02 00 00       	call   800c48 <cprintf>
  8009ea:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 e1 01 00 00       	call   800bdd <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	6a 00                	push   $0x0
  800a04:	68 01 2c 80 00       	push   $0x802c01
  800a09:	e8 cf 01 00 00       	call   800bdd <vcprintf>
  800a0e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a11:	e8 82 ff ff ff       	call   800998 <exit>

	// should not return here
	while (1) ;
  800a16:	eb fe                	jmp    800a16 <_panic+0x70>

00800a18 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1e:	a1 20 40 80 00       	mov    0x804020,%eax
  800a23:	8b 50 74             	mov    0x74(%eax),%edx
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	39 c2                	cmp    %eax,%edx
  800a2b:	74 14                	je     800a41 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a2d:	83 ec 04             	sub    $0x4,%esp
  800a30:	68 04 2c 80 00       	push   $0x802c04
  800a35:	6a 26                	push   $0x26
  800a37:	68 50 2c 80 00       	push   $0x802c50
  800a3c:	e8 65 ff ff ff       	call   8009a6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4f:	e9 b6 00 00 00       	jmp    800b0a <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	01 d0                	add    %edx,%eax
  800a63:	8b 00                	mov    (%eax),%eax
  800a65:	85 c0                	test   %eax,%eax
  800a67:	75 08                	jne    800a71 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a69:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a6c:	e9 96 00 00 00       	jmp    800b07 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800a71:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a78:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7f:	eb 5d                	jmp    800ade <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a81:	a1 20 40 80 00       	mov    0x804020,%eax
  800a86:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8f:	c1 e2 04             	shl    $0x4,%edx
  800a92:	01 d0                	add    %edx,%eax
  800a94:	8a 40 04             	mov    0x4(%eax),%al
  800a97:	84 c0                	test   %al,%al
  800a99:	75 40                	jne    800adb <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9b:	a1 20 40 80 00       	mov    0x804020,%eax
  800aa0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800aa6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aa9:	c1 e2 04             	shl    $0x4,%edx
  800aac:	01 d0                	add    %edx,%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ab3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ab6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800abb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	01 c8                	add    %ecx,%eax
  800acc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ace:	39 c2                	cmp    %eax,%edx
  800ad0:	75 09                	jne    800adb <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800ad2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ad9:	eb 12                	jmp    800aed <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800adb:	ff 45 e8             	incl   -0x18(%ebp)
  800ade:	a1 20 40 80 00       	mov    0x804020,%eax
  800ae3:	8b 50 74             	mov    0x74(%eax),%edx
  800ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ae9:	39 c2                	cmp    %eax,%edx
  800aeb:	77 94                	ja     800a81 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800aed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af1:	75 14                	jne    800b07 <CheckWSWithoutLastIndex+0xef>
			panic(
  800af3:	83 ec 04             	sub    $0x4,%esp
  800af6:	68 5c 2c 80 00       	push   $0x802c5c
  800afb:	6a 3a                	push   $0x3a
  800afd:	68 50 2c 80 00       	push   $0x802c50
  800b02:	e8 9f fe ff ff       	call   8009a6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b07:	ff 45 f0             	incl   -0x10(%ebp)
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b10:	0f 8c 3e ff ff ff    	jl     800a54 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b24:	eb 20                	jmp    800b46 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b26:	a1 20 40 80 00       	mov    0x804020,%eax
  800b2b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b34:	c1 e2 04             	shl    $0x4,%edx
  800b37:	01 d0                	add    %edx,%eax
  800b39:	8a 40 04             	mov    0x4(%eax),%al
  800b3c:	3c 01                	cmp    $0x1,%al
  800b3e:	75 03                	jne    800b43 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800b40:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b43:	ff 45 e0             	incl   -0x20(%ebp)
  800b46:	a1 20 40 80 00       	mov    0x804020,%eax
  800b4b:	8b 50 74             	mov    0x74(%eax),%edx
  800b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	77 d1                	ja     800b26 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b58:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b5b:	74 14                	je     800b71 <CheckWSWithoutLastIndex+0x159>
		panic(
  800b5d:	83 ec 04             	sub    $0x4,%esp
  800b60:	68 b0 2c 80 00       	push   $0x802cb0
  800b65:	6a 44                	push   $0x44
  800b67:	68 50 2c 80 00       	push   $0x802c50
  800b6c:	e8 35 fe ff ff       	call   8009a6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b71:	90                   	nop
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	8b 00                	mov    (%eax),%eax
  800b7f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b85:	89 0a                	mov    %ecx,(%edx)
  800b87:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8a:	88 d1                	mov    %dl,%cl
  800b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	8b 00                	mov    (%eax),%eax
  800b98:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b9d:	75 2c                	jne    800bcb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b9f:	a0 24 40 80 00       	mov    0x804024,%al
  800ba4:	0f b6 c0             	movzbl %al,%eax
  800ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800baa:	8b 12                	mov    (%edx),%edx
  800bac:	89 d1                	mov    %edx,%ecx
  800bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb1:	83 c2 08             	add    $0x8,%edx
  800bb4:	83 ec 04             	sub    $0x4,%esp
  800bb7:	50                   	push   %eax
  800bb8:	51                   	push   %ecx
  800bb9:	52                   	push   %edx
  800bba:	e8 25 11 00 00       	call   801ce4 <sys_cputs>
  800bbf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	8b 40 04             	mov    0x4(%eax),%eax
  800bd1:	8d 50 01             	lea    0x1(%eax),%edx
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bda:	90                   	nop
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800be6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bed:	00 00 00 
	b.cnt = 0;
  800bf0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bf7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 74 0b 80 00       	push   $0x800b74
  800c0c:	e8 11 02 00 00       	call   800e22 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c14:	a0 24 40 80 00       	mov    0x804024,%al
  800c19:	0f b6 c0             	movzbl %al,%eax
  800c1c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c22:	83 ec 04             	sub    $0x4,%esp
  800c25:	50                   	push   %eax
  800c26:	52                   	push   %edx
  800c27:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c2d:	83 c0 08             	add    $0x8,%eax
  800c30:	50                   	push   %eax
  800c31:	e8 ae 10 00 00       	call   801ce4 <sys_cputs>
  800c36:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c39:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800c40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c4e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800c55:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 f4             	pushl  -0xc(%ebp)
  800c64:	50                   	push   %eax
  800c65:	e8 73 ff ff ff       	call   800bdd <vcprintf>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c7b:	e8 75 12 00 00       	call   801ef5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c80:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8f:	50                   	push   %eax
  800c90:	e8 48 ff ff ff       	call   800bdd <vcprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c9b:	e8 6f 12 00 00       	call   801f0f <sys_enable_interrupt>
	return cnt;
  800ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca3:	c9                   	leave  
  800ca4:	c3                   	ret    

00800ca5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 14             	sub    $0x14,%esp
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cb8:	8b 45 18             	mov    0x18(%ebp),%eax
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc3:	77 55                	ja     800d1a <printnum+0x75>
  800cc5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc8:	72 05                	jb     800ccf <printnum+0x2a>
  800cca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ccd:	77 4b                	ja     800d1a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ccf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cd2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cd5:	8b 45 18             	mov    0x18(%ebp),%eax
  800cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdd:	52                   	push   %edx
  800cde:	50                   	push   %eax
  800cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce5:	e8 2e 16 00 00       	call   802318 <__udivdi3>
  800cea:	83 c4 10             	add    $0x10,%esp
  800ced:	83 ec 04             	sub    $0x4,%esp
  800cf0:	ff 75 20             	pushl  0x20(%ebp)
  800cf3:	53                   	push   %ebx
  800cf4:	ff 75 18             	pushl  0x18(%ebp)
  800cf7:	52                   	push   %edx
  800cf8:	50                   	push   %eax
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	ff 75 08             	pushl  0x8(%ebp)
  800cff:	e8 a1 ff ff ff       	call   800ca5 <printnum>
  800d04:	83 c4 20             	add    $0x20,%esp
  800d07:	eb 1a                	jmp    800d23 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 20             	pushl  0x20(%ebp)
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	ff d0                	call   *%eax
  800d17:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d1a:	ff 4d 1c             	decl   0x1c(%ebp)
  800d1d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d21:	7f e6                	jg     800d09 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d23:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d31:	53                   	push   %ebx
  800d32:	51                   	push   %ecx
  800d33:	52                   	push   %edx
  800d34:	50                   	push   %eax
  800d35:	e8 ee 16 00 00       	call   802428 <__umoddi3>
  800d3a:	83 c4 10             	add    $0x10,%esp
  800d3d:	05 14 2f 80 00       	add    $0x802f14,%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	0f be c0             	movsbl %al,%eax
  800d47:	83 ec 08             	sub    $0x8,%esp
  800d4a:	ff 75 0c             	pushl  0xc(%ebp)
  800d4d:	50                   	push   %eax
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
}
  800d56:	90                   	nop
  800d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d5f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d63:	7e 1c                	jle    800d81 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	8d 50 08             	lea    0x8(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	89 10                	mov    %edx,(%eax)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	83 e8 08             	sub    $0x8,%eax
  800d7a:	8b 50 04             	mov    0x4(%eax),%edx
  800d7d:	8b 00                	mov    (%eax),%eax
  800d7f:	eb 40                	jmp    800dc1 <getuint+0x65>
	else if (lflag)
  800d81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d85:	74 1e                	je     800da5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	8d 50 04             	lea    0x4(%eax),%edx
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 10                	mov    %edx,(%eax)
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8b 00                	mov    (%eax),%eax
  800d99:	83 e8 04             	sub    $0x4,%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800da3:	eb 1c                	jmp    800dc1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	8d 50 04             	lea    0x4(%eax),%edx
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 10                	mov    %edx,(%eax)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 00                	mov    (%eax),%eax
  800dbc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dc6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dca:	7e 1c                	jle    800de8 <getint+0x25>
		return va_arg(*ap, long long);
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 00                	mov    (%eax),%eax
  800dd1:	8d 50 08             	lea    0x8(%eax),%edx
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	89 10                	mov    %edx,(%eax)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	83 e8 08             	sub    $0x8,%eax
  800de1:	8b 50 04             	mov    0x4(%eax),%edx
  800de4:	8b 00                	mov    (%eax),%eax
  800de6:	eb 38                	jmp    800e20 <getint+0x5d>
	else if (lflag)
  800de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dec:	74 1a                	je     800e08 <getint+0x45>
		return va_arg(*ap, long);
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	8d 50 04             	lea    0x4(%eax),%edx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 10                	mov    %edx,(%eax)
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8b 00                	mov    (%eax),%eax
  800e00:	83 e8 04             	sub    $0x4,%eax
  800e03:	8b 00                	mov    (%eax),%eax
  800e05:	99                   	cltd   
  800e06:	eb 18                	jmp    800e20 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8b 00                	mov    (%eax),%eax
  800e0d:	8d 50 04             	lea    0x4(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	89 10                	mov    %edx,(%eax)
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8b 00                	mov    (%eax),%eax
  800e1a:	83 e8 04             	sub    $0x4,%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	99                   	cltd   
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2a:	eb 17                	jmp    800e43 <vprintfmt+0x21>
			if (ch == '\0')
  800e2c:	85 db                	test   %ebx,%ebx
  800e2e:	0f 84 af 03 00 00    	je     8011e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	53                   	push   %ebx
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	ff d0                	call   *%eax
  800e40:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e43:	8b 45 10             	mov    0x10(%ebp),%eax
  800e46:	8d 50 01             	lea    0x1(%eax),%edx
  800e49:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	0f b6 d8             	movzbl %al,%ebx
  800e51:	83 fb 25             	cmp    $0x25,%ebx
  800e54:	75 d6                	jne    800e2c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e56:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e5a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e68:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	8d 50 01             	lea    0x1(%eax),%edx
  800e7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	0f b6 d8             	movzbl %al,%ebx
  800e84:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e87:	83 f8 55             	cmp    $0x55,%eax
  800e8a:	0f 87 2b 03 00 00    	ja     8011bb <vprintfmt+0x399>
  800e90:	8b 04 85 38 2f 80 00 	mov    0x802f38(,%eax,4),%eax
  800e97:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e99:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e9d:	eb d7                	jmp    800e76 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e9f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ea3:	eb d1                	jmp    800e76 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800eaf:	89 d0                	mov    %edx,%eax
  800eb1:	c1 e0 02             	shl    $0x2,%eax
  800eb4:	01 d0                	add    %edx,%eax
  800eb6:	01 c0                	add    %eax,%eax
  800eb8:	01 d8                	add    %ebx,%eax
  800eba:	83 e8 30             	sub    $0x30,%eax
  800ebd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ec8:	83 fb 2f             	cmp    $0x2f,%ebx
  800ecb:	7e 3e                	jle    800f0b <vprintfmt+0xe9>
  800ecd:	83 fb 39             	cmp    $0x39,%ebx
  800ed0:	7f 39                	jg     800f0b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ed2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ed5:	eb d5                	jmp    800eac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ed7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eda:	83 c0 04             	add    $0x4,%eax
  800edd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee3:	83 e8 04             	sub    $0x4,%eax
  800ee6:	8b 00                	mov    (%eax),%eax
  800ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800eeb:	eb 1f                	jmp    800f0c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800eed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef1:	79 83                	jns    800e76 <vprintfmt+0x54>
				width = 0;
  800ef3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800efa:	e9 77 ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800eff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f06:	e9 6b ff ff ff       	jmp    800e76 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f0b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f10:	0f 89 60 ff ff ff    	jns    800e76 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f23:	e9 4e ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f28:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f2b:	e9 46 ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f30:	8b 45 14             	mov    0x14(%ebp),%eax
  800f33:	83 c0 04             	add    $0x4,%eax
  800f36:	89 45 14             	mov    %eax,0x14(%ebp)
  800f39:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3c:	83 e8 04             	sub    $0x4,%eax
  800f3f:	8b 00                	mov    (%eax),%eax
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	50                   	push   %eax
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
			break;
  800f50:	e9 89 02 00 00       	jmp    8011de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f55:	8b 45 14             	mov    0x14(%ebp),%eax
  800f58:	83 c0 04             	add    $0x4,%eax
  800f5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f61:	83 e8 04             	sub    $0x4,%eax
  800f64:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f66:	85 db                	test   %ebx,%ebx
  800f68:	79 02                	jns    800f6c <vprintfmt+0x14a>
				err = -err;
  800f6a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f6c:	83 fb 64             	cmp    $0x64,%ebx
  800f6f:	7f 0b                	jg     800f7c <vprintfmt+0x15a>
  800f71:	8b 34 9d 80 2d 80 00 	mov    0x802d80(,%ebx,4),%esi
  800f78:	85 f6                	test   %esi,%esi
  800f7a:	75 19                	jne    800f95 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f7c:	53                   	push   %ebx
  800f7d:	68 25 2f 80 00       	push   $0x802f25
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	ff 75 08             	pushl  0x8(%ebp)
  800f88:	e8 5e 02 00 00       	call   8011eb <printfmt>
  800f8d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f90:	e9 49 02 00 00       	jmp    8011de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f95:	56                   	push   %esi
  800f96:	68 2e 2f 80 00       	push   $0x802f2e
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	e8 45 02 00 00       	call   8011eb <printfmt>
  800fa6:	83 c4 10             	add    $0x10,%esp
			break;
  800fa9:	e9 30 02 00 00       	jmp    8011de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fae:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb1:	83 c0 04             	add    $0x4,%eax
  800fb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fba:	83 e8 04             	sub    $0x4,%eax
  800fbd:	8b 30                	mov    (%eax),%esi
  800fbf:	85 f6                	test   %esi,%esi
  800fc1:	75 05                	jne    800fc8 <vprintfmt+0x1a6>
				p = "(null)";
  800fc3:	be 31 2f 80 00       	mov    $0x802f31,%esi
			if (width > 0 && padc != '-')
  800fc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcc:	7e 6d                	jle    80103b <vprintfmt+0x219>
  800fce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fd2:	74 67                	je     80103b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	50                   	push   %eax
  800fdb:	56                   	push   %esi
  800fdc:	e8 0c 03 00 00       	call   8012ed <strnlen>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fe7:	eb 16                	jmp    800fff <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fe9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	ff 75 0c             	pushl  0xc(%ebp)
  800ff3:	50                   	push   %eax
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	ff d0                	call   *%eax
  800ff9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ffc:	ff 4d e4             	decl   -0x1c(%ebp)
  800fff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801003:	7f e4                	jg     800fe9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801005:	eb 34                	jmp    80103b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801007:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80100b:	74 1c                	je     801029 <vprintfmt+0x207>
  80100d:	83 fb 1f             	cmp    $0x1f,%ebx
  801010:	7e 05                	jle    801017 <vprintfmt+0x1f5>
  801012:	83 fb 7e             	cmp    $0x7e,%ebx
  801015:	7e 12                	jle    801029 <vprintfmt+0x207>
					putch('?', putdat);
  801017:	83 ec 08             	sub    $0x8,%esp
  80101a:	ff 75 0c             	pushl  0xc(%ebp)
  80101d:	6a 3f                	push   $0x3f
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	ff d0                	call   *%eax
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	eb 0f                	jmp    801038 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	ff 75 0c             	pushl  0xc(%ebp)
  80102f:	53                   	push   %ebx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	ff d0                	call   *%eax
  801035:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801038:	ff 4d e4             	decl   -0x1c(%ebp)
  80103b:	89 f0                	mov    %esi,%eax
  80103d:	8d 70 01             	lea    0x1(%eax),%esi
  801040:	8a 00                	mov    (%eax),%al
  801042:	0f be d8             	movsbl %al,%ebx
  801045:	85 db                	test   %ebx,%ebx
  801047:	74 24                	je     80106d <vprintfmt+0x24b>
  801049:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80104d:	78 b8                	js     801007 <vprintfmt+0x1e5>
  80104f:	ff 4d e0             	decl   -0x20(%ebp)
  801052:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801056:	79 af                	jns    801007 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801058:	eb 13                	jmp    80106d <vprintfmt+0x24b>
				putch(' ', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 20                	push   $0x20
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80106a:	ff 4d e4             	decl   -0x1c(%ebp)
  80106d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801071:	7f e7                	jg     80105a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801073:	e9 66 01 00 00       	jmp    8011de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	ff 75 e8             	pushl  -0x18(%ebp)
  80107e:	8d 45 14             	lea    0x14(%ebp),%eax
  801081:	50                   	push   %eax
  801082:	e8 3c fd ff ff       	call   800dc3 <getint>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801096:	85 d2                	test   %edx,%edx
  801098:	79 23                	jns    8010bd <vprintfmt+0x29b>
				putch('-', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 2d                	push   $0x2d
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b0:	f7 d8                	neg    %eax
  8010b2:	83 d2 00             	adc    $0x0,%edx
  8010b5:	f7 da                	neg    %edx
  8010b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c4:	e9 bc 00 00 00       	jmp    801185 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8010d2:	50                   	push   %eax
  8010d3:	e8 84 fc ff ff       	call   800d5c <getuint>
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010e8:	e9 98 00 00 00       	jmp    801185 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 58                	push   $0x58
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	ff 75 0c             	pushl  0xc(%ebp)
  801103:	6a 58                	push   $0x58
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	ff d0                	call   *%eax
  80110a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	ff 75 0c             	pushl  0xc(%ebp)
  801113:	6a 58                	push   $0x58
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
			break;
  80111d:	e9 bc 00 00 00       	jmp    8011de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	6a 30                	push   $0x30
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	ff d0                	call   *%eax
  80112f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801132:	83 ec 08             	sub    $0x8,%esp
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	6a 78                	push   $0x78
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	ff d0                	call   *%eax
  80113f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801142:	8b 45 14             	mov    0x14(%ebp),%eax
  801145:	83 c0 04             	add    $0x4,%eax
  801148:	89 45 14             	mov    %eax,0x14(%ebp)
  80114b:	8b 45 14             	mov    0x14(%ebp),%eax
  80114e:	83 e8 04             	sub    $0x4,%eax
  801151:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801153:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80115d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801164:	eb 1f                	jmp    801185 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801166:	83 ec 08             	sub    $0x8,%esp
  801169:	ff 75 e8             	pushl  -0x18(%ebp)
  80116c:	8d 45 14             	lea    0x14(%ebp),%eax
  80116f:	50                   	push   %eax
  801170:	e8 e7 fb ff ff       	call   800d5c <getuint>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80117e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801185:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80118c:	83 ec 04             	sub    $0x4,%esp
  80118f:	52                   	push   %edx
  801190:	ff 75 e4             	pushl  -0x1c(%ebp)
  801193:	50                   	push   %eax
  801194:	ff 75 f4             	pushl  -0xc(%ebp)
  801197:	ff 75 f0             	pushl  -0x10(%ebp)
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	ff 75 08             	pushl  0x8(%ebp)
  8011a0:	e8 00 fb ff ff       	call   800ca5 <printnum>
  8011a5:	83 c4 20             	add    $0x20,%esp
			break;
  8011a8:	eb 34                	jmp    8011de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011aa:	83 ec 08             	sub    $0x8,%esp
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	53                   	push   %ebx
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	ff d0                	call   *%eax
  8011b6:	83 c4 10             	add    $0x10,%esp
			break;
  8011b9:	eb 23                	jmp    8011de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 25                	push   $0x25
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011cb:	ff 4d 10             	decl   0x10(%ebp)
  8011ce:	eb 03                	jmp    8011d3 <vprintfmt+0x3b1>
  8011d0:	ff 4d 10             	decl   0x10(%ebp)
  8011d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d6:	48                   	dec    %eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	3c 25                	cmp    $0x25,%al
  8011db:	75 f3                	jne    8011d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011dd:	90                   	nop
		}
	}
  8011de:	e9 47 fc ff ff       	jmp    800e2a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e7:	5b                   	pop    %ebx
  8011e8:	5e                   	pop    %esi
  8011e9:	5d                   	pop    %ebp
  8011ea:	c3                   	ret    

008011eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8011f4:	83 c0 04             	add    $0x4,%eax
  8011f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801200:	50                   	push   %eax
  801201:	ff 75 0c             	pushl  0xc(%ebp)
  801204:	ff 75 08             	pushl  0x8(%ebp)
  801207:	e8 16 fc ff ff       	call   800e22 <vprintfmt>
  80120c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80120f:	90                   	nop
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801215:	8b 45 0c             	mov    0xc(%ebp),%eax
  801218:	8b 40 08             	mov    0x8(%eax),%eax
  80121b:	8d 50 01             	lea    0x1(%eax),%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	8b 10                	mov    (%eax),%edx
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	8b 40 04             	mov    0x4(%eax),%eax
  80122f:	39 c2                	cmp    %eax,%edx
  801231:	73 12                	jae    801245 <sprintputch+0x33>
		*b->buf++ = ch;
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 48 01             	lea    0x1(%eax),%ecx
  80123b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123e:	89 0a                	mov    %ecx,(%edx)
  801240:	8b 55 08             	mov    0x8(%ebp),%edx
  801243:	88 10                	mov    %dl,(%eax)
}
  801245:	90                   	nop
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    

00801248 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801269:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126d:	74 06                	je     801275 <vsnprintf+0x2d>
  80126f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801273:	7f 07                	jg     80127c <vsnprintf+0x34>
		return -E_INVAL;
  801275:	b8 03 00 00 00       	mov    $0x3,%eax
  80127a:	eb 20                	jmp    80129c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80127c:	ff 75 14             	pushl  0x14(%ebp)
  80127f:	ff 75 10             	pushl  0x10(%ebp)
  801282:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801285:	50                   	push   %eax
  801286:	68 12 12 80 00       	push   $0x801212
  80128b:	e8 92 fb ff ff       	call   800e22 <vprintfmt>
  801290:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801296:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801299:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a7:	83 c0 04             	add    $0x4,%eax
  8012aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b3:	50                   	push   %eax
  8012b4:	ff 75 0c             	pushl  0xc(%ebp)
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	e8 89 ff ff ff       	call   801248 <vsnprintf>
  8012bf:	83 c4 10             	add    $0x10,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d7:	eb 06                	jmp    8012df <strlen+0x15>
		n++;
  8012d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012dc:	ff 45 08             	incl   0x8(%ebp)
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	84 c0                	test   %al,%al
  8012e6:	75 f1                	jne    8012d9 <strlen+0xf>
		n++;
	return n;
  8012e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fa:	eb 09                	jmp    801305 <strnlen+0x18>
		n++;
  8012fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ff:	ff 45 08             	incl   0x8(%ebp)
  801302:	ff 4d 0c             	decl   0xc(%ebp)
  801305:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801309:	74 09                	je     801314 <strnlen+0x27>
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	84 c0                	test   %al,%al
  801312:	75 e8                	jne    8012fc <strnlen+0xf>
		n++;
	return n;
  801314:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801325:	90                   	nop
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8d 50 01             	lea    0x1(%eax),%edx
  80132c:	89 55 08             	mov    %edx,0x8(%ebp)
  80132f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801332:	8d 4a 01             	lea    0x1(%edx),%ecx
  801335:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801338:	8a 12                	mov    (%edx),%dl
  80133a:	88 10                	mov    %dl,(%eax)
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	84 c0                	test   %al,%al
  801340:	75 e4                	jne    801326 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801342:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80134d:	8b 45 08             	mov    0x8(%ebp),%eax
  801350:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801353:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135a:	eb 1f                	jmp    80137b <strncpy+0x34>
		*dst++ = *src;
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8d 50 01             	lea    0x1(%eax),%edx
  801362:	89 55 08             	mov    %edx,0x8(%ebp)
  801365:	8b 55 0c             	mov    0xc(%ebp),%edx
  801368:	8a 12                	mov    (%edx),%dl
  80136a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	84 c0                	test   %al,%al
  801373:	74 03                	je     801378 <strncpy+0x31>
			src++;
  801375:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801378:	ff 45 fc             	incl   -0x4(%ebp)
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801381:	72 d9                	jb     80135c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801383:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 30                	je     8013ca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139a:	eb 16                	jmp    8013b2 <strlcpy+0x2a>
			*dst++ = *src++;
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8d 50 01             	lea    0x1(%eax),%edx
  8013a2:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ae:	8a 12                	mov    (%edx),%dl
  8013b0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b2:	ff 4d 10             	decl   0x10(%ebp)
  8013b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b9:	74 09                	je     8013c4 <strlcpy+0x3c>
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	84 c0                	test   %al,%al
  8013c2:	75 d8                	jne    80139c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d0:	29 c2                	sub    %eax,%edx
  8013d2:	89 d0                	mov    %edx,%eax
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013d9:	eb 06                	jmp    8013e1 <strcmp+0xb>
		p++, q++;
  8013db:	ff 45 08             	incl   0x8(%ebp)
  8013de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	84 c0                	test   %al,%al
  8013e8:	74 0e                	je     8013f8 <strcmp+0x22>
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 10                	mov    (%eax),%dl
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	38 c2                	cmp    %al,%dl
  8013f6:	74 e3                	je     8013db <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	0f b6 d0             	movzbl %al,%edx
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	0f b6 c0             	movzbl %al,%eax
  801408:	29 c2                	sub    %eax,%edx
  80140a:	89 d0                	mov    %edx,%eax
}
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801411:	eb 09                	jmp    80141c <strncmp+0xe>
		n--, p++, q++;
  801413:	ff 4d 10             	decl   0x10(%ebp)
  801416:	ff 45 08             	incl   0x8(%ebp)
  801419:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801420:	74 17                	je     801439 <strncmp+0x2b>
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	84 c0                	test   %al,%al
  801429:	74 0e                	je     801439 <strncmp+0x2b>
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8a 10                	mov    (%eax),%dl
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	38 c2                	cmp    %al,%dl
  801437:	74 da                	je     801413 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801439:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143d:	75 07                	jne    801446 <strncmp+0x38>
		return 0;
  80143f:	b8 00 00 00 00       	mov    $0x0,%eax
  801444:	eb 14                	jmp    80145a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	0f b6 d0             	movzbl %al,%edx
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	0f b6 c0             	movzbl %al,%eax
  801456:	29 c2                	sub    %eax,%edx
  801458:	89 d0                	mov    %edx,%eax
}
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 04             	sub    $0x4,%esp
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801468:	eb 12                	jmp    80147c <strchr+0x20>
		if (*s == c)
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801472:	75 05                	jne    801479 <strchr+0x1d>
			return (char *) s;
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	eb 11                	jmp    80148a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801479:	ff 45 08             	incl   0x8(%ebp)
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	84 c0                	test   %al,%al
  801483:	75 e5                	jne    80146a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801485:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801498:	eb 0d                	jmp    8014a7 <strfind+0x1b>
		if (*s == c)
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a2:	74 0e                	je     8014b2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a4:	ff 45 08             	incl   0x8(%ebp)
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	84 c0                	test   %al,%al
  8014ae:	75 ea                	jne    80149a <strfind+0xe>
  8014b0:	eb 01                	jmp    8014b3 <strfind+0x27>
		if (*s == c)
			break;
  8014b2:	90                   	nop
	return (char *) s;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014ca:	eb 0e                	jmp    8014da <memset+0x22>
		*p++ = c;
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	8d 50 01             	lea    0x1(%eax),%edx
  8014d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014da:	ff 4d f8             	decl   -0x8(%ebp)
  8014dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e1:	79 e9                	jns    8014cc <memset+0x14>
		*p++ = c;

	return v;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fa:	eb 16                	jmp    801512 <memcpy+0x2a>
		*d++ = *s++;
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	8d 50 01             	lea    0x1(%eax),%edx
  801502:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801505:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801508:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80150e:	8a 12                	mov    (%edx),%dl
  801510:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801512:	8b 45 10             	mov    0x10(%ebp),%eax
  801515:	8d 50 ff             	lea    -0x1(%eax),%edx
  801518:	89 55 10             	mov    %edx,0x10(%ebp)
  80151b:	85 c0                	test   %eax,%eax
  80151d:	75 dd                	jne    8014fc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801536:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801539:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153c:	73 50                	jae    80158e <memmove+0x6a>
  80153e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801541:	8b 45 10             	mov    0x10(%ebp),%eax
  801544:	01 d0                	add    %edx,%eax
  801546:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801549:	76 43                	jbe    80158e <memmove+0x6a>
		s += n;
  80154b:	8b 45 10             	mov    0x10(%ebp),%eax
  80154e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801551:	8b 45 10             	mov    0x10(%ebp),%eax
  801554:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801557:	eb 10                	jmp    801569 <memmove+0x45>
			*--d = *--s;
  801559:	ff 4d f8             	decl   -0x8(%ebp)
  80155c:	ff 4d fc             	decl   -0x4(%ebp)
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8a 10                	mov    (%eax),%dl
  801564:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801567:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801569:	8b 45 10             	mov    0x10(%ebp),%eax
  80156c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80156f:	89 55 10             	mov    %edx,0x10(%ebp)
  801572:	85 c0                	test   %eax,%eax
  801574:	75 e3                	jne    801559 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801576:	eb 23                	jmp    80159b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801578:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157b:	8d 50 01             	lea    0x1(%eax),%edx
  80157e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801581:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801584:	8d 4a 01             	lea    0x1(%edx),%ecx
  801587:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158a:	8a 12                	mov    (%edx),%dl
  80158c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	8d 50 ff             	lea    -0x1(%eax),%edx
  801594:	89 55 10             	mov    %edx,0x10(%ebp)
  801597:	85 c0                	test   %eax,%eax
  801599:	75 dd                	jne    801578 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015af:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b2:	eb 2a                	jmp    8015de <memcmp+0x3e>
		if (*s1 != *s2)
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 10                	mov    (%eax),%dl
  8015b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	38 c2                	cmp    %al,%dl
  8015c0:	74 16                	je     8015d8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	0f b6 d0             	movzbl %al,%edx
  8015ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cd:	8a 00                	mov    (%eax),%al
  8015cf:	0f b6 c0             	movzbl %al,%eax
  8015d2:	29 c2                	sub    %eax,%edx
  8015d4:	89 d0                	mov    %edx,%eax
  8015d6:	eb 18                	jmp    8015f0 <memcmp+0x50>
		s1++, s2++;
  8015d8:	ff 45 fc             	incl   -0x4(%ebp)
  8015db:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	75 c9                	jne    8015b4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fe:	01 d0                	add    %edx,%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801603:	eb 15                	jmp    80161a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	8a 00                	mov    (%eax),%al
  80160a:	0f b6 d0             	movzbl %al,%edx
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	0f b6 c0             	movzbl %al,%eax
  801613:	39 c2                	cmp    %eax,%edx
  801615:	74 0d                	je     801624 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801620:	72 e3                	jb     801605 <memfind+0x13>
  801622:	eb 01                	jmp    801625 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801624:	90                   	nop
	return (void *) s;
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801630:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801637:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163e:	eb 03                	jmp    801643 <strtol+0x19>
		s++;
  801640:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	3c 20                	cmp    $0x20,%al
  80164a:	74 f4                	je     801640 <strtol+0x16>
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	3c 09                	cmp    $0x9,%al
  801653:	74 eb                	je     801640 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2b                	cmp    $0x2b,%al
  80165c:	75 05                	jne    801663 <strtol+0x39>
		s++;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	eb 13                	jmp    801676 <strtol+0x4c>
	else if (*s == '-')
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	3c 2d                	cmp    $0x2d,%al
  80166a:	75 0a                	jne    801676 <strtol+0x4c>
		s++, neg = 1;
  80166c:	ff 45 08             	incl   0x8(%ebp)
  80166f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801676:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167a:	74 06                	je     801682 <strtol+0x58>
  80167c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801680:	75 20                	jne    8016a2 <strtol+0x78>
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	3c 30                	cmp    $0x30,%al
  801689:	75 17                	jne    8016a2 <strtol+0x78>
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	40                   	inc    %eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	3c 78                	cmp    $0x78,%al
  801693:	75 0d                	jne    8016a2 <strtol+0x78>
		s += 2, base = 16;
  801695:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801699:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a0:	eb 28                	jmp    8016ca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a6:	75 15                	jne    8016bd <strtol+0x93>
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	3c 30                	cmp    $0x30,%al
  8016af:	75 0c                	jne    8016bd <strtol+0x93>
		s++, base = 8;
  8016b1:	ff 45 08             	incl   0x8(%ebp)
  8016b4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016bb:	eb 0d                	jmp    8016ca <strtol+0xa0>
	else if (base == 0)
  8016bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c1:	75 07                	jne    8016ca <strtol+0xa0>
		base = 10;
  8016c3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	3c 2f                	cmp    $0x2f,%al
  8016d1:	7e 19                	jle    8016ec <strtol+0xc2>
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	3c 39                	cmp    $0x39,%al
  8016da:	7f 10                	jg     8016ec <strtol+0xc2>
			dig = *s - '0';
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	0f be c0             	movsbl %al,%eax
  8016e4:	83 e8 30             	sub    $0x30,%eax
  8016e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ea:	eb 42                	jmp    80172e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	8a 00                	mov    (%eax),%al
  8016f1:	3c 60                	cmp    $0x60,%al
  8016f3:	7e 19                	jle    80170e <strtol+0xe4>
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	3c 7a                	cmp    $0x7a,%al
  8016fc:	7f 10                	jg     80170e <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f be c0             	movsbl %al,%eax
  801706:	83 e8 57             	sub    $0x57,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170c:	eb 20                	jmp    80172e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	3c 40                	cmp    $0x40,%al
  801715:	7e 39                	jle    801750 <strtol+0x126>
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	3c 5a                	cmp    $0x5a,%al
  80171e:	7f 30                	jg     801750 <strtol+0x126>
			dig = *s - 'A' + 10;
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	83 e8 37             	sub    $0x37,%eax
  80172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801731:	3b 45 10             	cmp    0x10(%ebp),%eax
  801734:	7d 19                	jge    80174f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801736:	ff 45 08             	incl   0x8(%ebp)
  801739:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801740:	89 c2                	mov    %eax,%edx
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174a:	e9 7b ff ff ff       	jmp    8016ca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80174f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801750:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801754:	74 08                	je     80175e <strtol+0x134>
		*endptr = (char *) s;
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	8b 55 08             	mov    0x8(%ebp),%edx
  80175c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80175e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801762:	74 07                	je     80176b <strtol+0x141>
  801764:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801767:	f7 d8                	neg    %eax
  801769:	eb 03                	jmp    80176e <strtol+0x144>
  80176b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <ltostr>:

void
ltostr(long value, char *str)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801776:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80177d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801784:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801788:	79 13                	jns    80179d <ltostr+0x2d>
	{
		neg = 1;
  80178a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801797:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a5:	99                   	cltd   
  8017a6:	f7 f9                	idiv   %ecx
  8017a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ae:	8d 50 01             	lea    0x1(%eax),%edx
  8017b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b4:	89 c2                	mov    %eax,%edx
  8017b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b9:	01 d0                	add    %edx,%eax
  8017bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017be:	83 c2 30             	add    $0x30,%edx
  8017c1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017cb:	f7 e9                	imul   %ecx
  8017cd:	c1 fa 02             	sar    $0x2,%edx
  8017d0:	89 c8                	mov    %ecx,%eax
  8017d2:	c1 f8 1f             	sar    $0x1f,%eax
  8017d5:	29 c2                	sub    %eax,%edx
  8017d7:	89 d0                	mov    %edx,%eax
  8017d9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017df:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e4:	f7 e9                	imul   %ecx
  8017e6:	c1 fa 02             	sar    $0x2,%edx
  8017e9:	89 c8                	mov    %ecx,%eax
  8017eb:	c1 f8 1f             	sar    $0x1f,%eax
  8017ee:	29 c2                	sub    %eax,%edx
  8017f0:	89 d0                	mov    %edx,%eax
  8017f2:	c1 e0 02             	shl    $0x2,%eax
  8017f5:	01 d0                	add    %edx,%eax
  8017f7:	01 c0                	add    %eax,%eax
  8017f9:	29 c1                	sub    %eax,%ecx
  8017fb:	89 ca                	mov    %ecx,%edx
  8017fd:	85 d2                	test   %edx,%edx
  8017ff:	75 9c                	jne    80179d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801801:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801808:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180b:	48                   	dec    %eax
  80180c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80180f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801813:	74 3d                	je     801852 <ltostr+0xe2>
		start = 1 ;
  801815:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181c:	eb 34                	jmp    801852 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80181e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	01 d0                	add    %edx,%eax
  801826:	8a 00                	mov    (%eax),%al
  801828:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801831:	01 c2                	add    %eax,%edx
  801833:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	01 c8                	add    %ecx,%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80183f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801842:	8b 45 0c             	mov    0xc(%ebp),%eax
  801845:	01 c2                	add    %eax,%edx
  801847:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184a:	88 02                	mov    %al,(%edx)
		start++ ;
  80184c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80184f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801858:	7c c4                	jl     80181e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80185d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801860:	01 d0                	add    %edx,%eax
  801862:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801865:	90                   	nop
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	e8 54 fa ff ff       	call   8012ca <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	e8 46 fa ff ff       	call   8012ca <strlen>
  801884:	83 c4 04             	add    $0x4,%esp
  801887:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801891:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801898:	eb 17                	jmp    8018b1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189d:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a0:	01 c2                	add    %eax,%edx
  8018a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	01 c8                	add    %ecx,%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018ae:	ff 45 fc             	incl   -0x4(%ebp)
  8018b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018b7:	7c e1                	jl     80189a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018c7:	eb 1f                	jmp    8018e8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cc:	8d 50 01             	lea    0x1(%eax),%edx
  8018cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d2:	89 c2                	mov    %eax,%edx
  8018d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d7:	01 c2                	add    %eax,%edx
  8018d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	01 c8                	add    %ecx,%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e5:	ff 45 f8             	incl   -0x8(%ebp)
  8018e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018ee:	7c d9                	jl     8018c9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f6:	01 d0                	add    %edx,%eax
  8018f8:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fb:	90                   	nop
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801901:	8b 45 14             	mov    0x14(%ebp),%eax
  801904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190a:	8b 45 14             	mov    0x14(%ebp),%eax
  80190d:	8b 00                	mov    (%eax),%eax
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 d0                	add    %edx,%eax
  80191b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	eb 0c                	jmp    80192f <strsplit+0x31>
			*string++ = 0;
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8d 50 01             	lea    0x1(%eax),%edx
  801929:	89 55 08             	mov    %edx,0x8(%ebp)
  80192c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	8a 00                	mov    (%eax),%al
  801934:	84 c0                	test   %al,%al
  801936:	74 18                	je     801950 <strsplit+0x52>
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	8a 00                	mov    (%eax),%al
  80193d:	0f be c0             	movsbl %al,%eax
  801940:	50                   	push   %eax
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	e8 13 fb ff ff       	call   80145c <strchr>
  801949:	83 c4 08             	add    $0x8,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	75 d3                	jne    801923 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	84 c0                	test   %al,%al
  801957:	74 5a                	je     8019b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801959:	8b 45 14             	mov    0x14(%ebp),%eax
  80195c:	8b 00                	mov    (%eax),%eax
  80195e:	83 f8 0f             	cmp    $0xf,%eax
  801961:	75 07                	jne    80196a <strsplit+0x6c>
		{
			return 0;
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
  801968:	eb 66                	jmp    8019d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	8b 00                	mov    (%eax),%eax
  80196f:	8d 48 01             	lea    0x1(%eax),%ecx
  801972:	8b 55 14             	mov    0x14(%ebp),%edx
  801975:	89 0a                	mov    %ecx,(%edx)
  801977:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197e:	8b 45 10             	mov    0x10(%ebp),%eax
  801981:	01 c2                	add    %eax,%edx
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801988:	eb 03                	jmp    80198d <strsplit+0x8f>
			string++;
  80198a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	8a 00                	mov    (%eax),%al
  801992:	84 c0                	test   %al,%al
  801994:	74 8b                	je     801921 <strsplit+0x23>
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	0f be c0             	movsbl %al,%eax
  80199e:	50                   	push   %eax
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	e8 b5 fa ff ff       	call   80145c <strchr>
  8019a7:	83 c4 08             	add    $0x8,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	74 dc                	je     80198a <strsplit+0x8c>
			string++;
	}
  8019ae:	e9 6e ff ff ff       	jmp    801921 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b7:	8b 00                	mov    (%eax),%eax
  8019b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <malloc>:
int sizeofarray=0;
uint32 addresses[1000];
int changed[1000];
int numOfPages[1000];
void* malloc(uint32 size)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
		// Write your code here, remove the panic and write your code
		int num = size /PAGE_SIZE;
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	c1 e8 0c             	shr    $0xc,%eax
  8019de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 return_addres;

		if(size%PAGE_SIZE!=0)
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	74 03                	je     8019f0 <malloc+0x1e>
			num++;
  8019ed:	ff 45 f4             	incl   -0xc(%ebp)
		if(last_addres==USER_HEAP_START)
  8019f0:	a1 04 40 80 00       	mov    0x804004,%eax
  8019f5:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8019fa:	75 73                	jne    801a6f <malloc+0x9d>
		{
			sys_allocateMem(USER_HEAP_START,size);
  8019fc:	83 ec 08             	sub    $0x8,%esp
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	68 00 00 00 80       	push   $0x80000000
  801a07:	e8 80 04 00 00       	call   801e8c <sys_allocateMem>
  801a0c:	83 c4 10             	add    $0x10,%esp
			return_addres=last_addres;
  801a0f:	a1 04 40 80 00       	mov    0x804004,%eax
  801a14:	89 45 d8             	mov    %eax,-0x28(%ebp)
			last_addres+=num*PAGE_SIZE;
  801a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1a:	c1 e0 0c             	shl    $0xc,%eax
  801a1d:	89 c2                	mov    %eax,%edx
  801a1f:	a1 04 40 80 00       	mov    0x804004,%eax
  801a24:	01 d0                	add    %edx,%eax
  801a26:	a3 04 40 80 00       	mov    %eax,0x804004
			numOfPages[sizeofarray]=num;
  801a2b:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a33:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
			addresses[sizeofarray]=last_addres;
  801a3a:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a3f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a45:	89 14 85 20 41 80 00 	mov    %edx,0x804120(,%eax,4)
			changed[sizeofarray]=1;
  801a4c:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a51:	c7 04 85 c0 50 80 00 	movl   $0x1,0x8050c0(,%eax,4)
  801a58:	01 00 00 00 
			sizeofarray++;
  801a5c:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a61:	40                   	inc    %eax
  801a62:	a3 2c 40 80 00       	mov    %eax,0x80402c
			return (void*)return_addres;
  801a67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a6a:	e9 71 01 00 00       	jmp    801be0 <malloc+0x20e>
		}
		else
		{
			if(changes==0)
  801a6f:	a1 28 40 80 00       	mov    0x804028,%eax
  801a74:	85 c0                	test   %eax,%eax
  801a76:	75 71                	jne    801ae9 <malloc+0x117>
			{
				sys_allocateMem(last_addres,size);
  801a78:	a1 04 40 80 00       	mov    0x804004,%eax
  801a7d:	83 ec 08             	sub    $0x8,%esp
  801a80:	ff 75 08             	pushl  0x8(%ebp)
  801a83:	50                   	push   %eax
  801a84:	e8 03 04 00 00       	call   801e8c <sys_allocateMem>
  801a89:	83 c4 10             	add    $0x10,%esp
				return_addres=last_addres;
  801a8c:	a1 04 40 80 00       	mov    0x804004,%eax
  801a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
				last_addres+=num*PAGE_SIZE;
  801a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a97:	c1 e0 0c             	shl    $0xc,%eax
  801a9a:	89 c2                	mov    %eax,%edx
  801a9c:	a1 04 40 80 00       	mov    0x804004,%eax
  801aa1:	01 d0                	add    %edx,%eax
  801aa3:	a3 04 40 80 00       	mov    %eax,0x804004
				numOfPages[sizeofarray]=num;
  801aa8:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab0:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
				addresses[sizeofarray]=return_addres;
  801ab7:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801abc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801abf:	89 14 85 20 41 80 00 	mov    %edx,0x804120(,%eax,4)
				changed[sizeofarray]=1;
  801ac6:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801acb:	c7 04 85 c0 50 80 00 	movl   $0x1,0x8050c0(,%eax,4)
  801ad2:	01 00 00 00 
				sizeofarray++;
  801ad6:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801adb:	40                   	inc    %eax
  801adc:	a3 2c 40 80 00       	mov    %eax,0x80402c
				return (void*)return_addres;
  801ae1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ae4:	e9 f7 00 00 00       	jmp    801be0 <malloc+0x20e>
			}
			else{
				int count=0;
  801ae9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				int min=1000;
  801af0:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
				int index=-1;
  801af7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801afe:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  801b05:	eb 7c                	jmp    801b83 <malloc+0x1b1>
				{
					uint32 *pg=NULL;
  801b07:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					for(int j=0;j<sizeofarray;j++)
  801b0e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801b15:	eb 1a                	jmp    801b31 <malloc+0x15f>
					{
						if(addresses[j]==i)
  801b17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b1a:	8b 04 85 20 41 80 00 	mov    0x804120(,%eax,4),%eax
  801b21:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b24:	75 08                	jne    801b2e <malloc+0x15c>
						{
							index=j;
  801b26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b29:	89 45 e8             	mov    %eax,-0x18(%ebp)
							break;
  801b2c:	eb 0d                	jmp    801b3b <malloc+0x169>
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
				{
					uint32 *pg=NULL;
					for(int j=0;j<sizeofarray;j++)
  801b2e:	ff 45 dc             	incl   -0x24(%ebp)
  801b31:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b36:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801b39:	7c dc                	jl     801b17 <malloc+0x145>
							index=j;
							break;
						}
					}

					if(index==-1)
  801b3b:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801b3f:	75 05                	jne    801b46 <malloc+0x174>
					{
						count++;
  801b41:	ff 45 f0             	incl   -0x10(%ebp)
  801b44:	eb 36                	jmp    801b7c <malloc+0x1aa>
					}
					else
					{
						if(changed[index]==0)
  801b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b49:	8b 04 85 c0 50 80 00 	mov    0x8050c0(,%eax,4),%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	75 05                	jne    801b59 <malloc+0x187>
						{
							count++;
  801b54:	ff 45 f0             	incl   -0x10(%ebp)
  801b57:	eb 23                	jmp    801b7c <malloc+0x1aa>
						}
						else
						{
							if(count<min&&count>=num)
  801b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801b5f:	7d 14                	jge    801b75 <malloc+0x1a3>
  801b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c 0c                	jl     801b75 <malloc+0x1a3>
							{
								min=count;
  801b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
								min_addresss=i;
  801b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
							}
							count=0;
  801b75:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			else{
				int count=0;
				int min=1000;
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801b7c:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801b83:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801b8a:	0f 86 77 ff ff ff    	jbe    801b07 <malloc+0x135>

					}

					}

				sys_allocateMem(min_addresss,size);
  801b90:	83 ec 08             	sub    $0x8,%esp
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b99:	e8 ee 02 00 00       	call   801e8c <sys_allocateMem>
  801b9e:	83 c4 10             	add    $0x10,%esp
				numOfPages[sizeofarray]=num;
  801ba1:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba9:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
				addresses[sizeofarray]=last_addres;
  801bb0:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bb5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bbb:	89 14 85 20 41 80 00 	mov    %edx,0x804120(,%eax,4)
				changed[sizeofarray]=1;
  801bc2:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bc7:	c7 04 85 c0 50 80 00 	movl   $0x1,0x8050c0(,%eax,4)
  801bce:	01 00 00 00 
				sizeofarray++;
  801bd2:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bd7:	40                   	inc    %eax
  801bd8:	a3 2c 40 80 00       	mov    %eax,0x80402c
				return(void*) min_addresss;
  801bdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax

		//refer to the project presentation and documentation for details

		return NULL;

}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801be5:	90                   	nop
  801be6:	5d                   	pop    %ebp
  801be7:	c3                   	ret    

00801be8 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 18             	sub    $0x18,%esp
  801bee:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf1:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	68 90 30 80 00       	push   $0x803090
  801bfc:	68 8d 00 00 00       	push   $0x8d
  801c01:	68 b3 30 80 00       	push   $0x8030b3
  801c06:	e8 9b ed ff ff       	call   8009a6 <_panic>

00801c0b <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	68 90 30 80 00       	push   $0x803090
  801c19:	68 93 00 00 00       	push   $0x93
  801c1e:	68 b3 30 80 00       	push   $0x8030b3
  801c23:	e8 7e ed ff ff       	call   8009a6 <_panic>

00801c28 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	68 90 30 80 00       	push   $0x803090
  801c36:	68 99 00 00 00       	push   $0x99
  801c3b:	68 b3 30 80 00       	push   $0x8030b3
  801c40:	e8 61 ed ff ff       	call   8009a6 <_panic>

00801c45 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	68 90 30 80 00       	push   $0x803090
  801c53:	68 9e 00 00 00       	push   $0x9e
  801c58:	68 b3 30 80 00       	push   $0x8030b3
  801c5d:	e8 44 ed ff ff       	call   8009a6 <_panic>

00801c62 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	68 90 30 80 00       	push   $0x803090
  801c70:	68 a4 00 00 00       	push   $0xa4
  801c75:	68 b3 30 80 00       	push   $0x8030b3
  801c7a:	e8 27 ed ff ff       	call   8009a6 <_panic>

00801c7f <shrink>:
}
void shrink(uint32 newSize)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	68 90 30 80 00       	push   $0x803090
  801c8d:	68 a8 00 00 00       	push   $0xa8
  801c92:	68 b3 30 80 00       	push   $0x8030b3
  801c97:	e8 0a ed ff ff       	call   8009a6 <_panic>

00801c9c <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	68 90 30 80 00       	push   $0x803090
  801caa:	68 ad 00 00 00       	push   $0xad
  801caf:	68 b3 30 80 00       	push   $0x8030b3
  801cb4:	e8 ed ec ff ff       	call   8009a6 <_panic>

00801cb9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	57                   	push   %edi
  801cbd:	56                   	push   %esi
  801cbe:	53                   	push   %ebx
  801cbf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cce:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cd4:	cd 30                	int    $0x30
  801cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5f                   	pop    %edi
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    

00801ce4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 04             	sub    $0x4,%esp
  801cea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ced:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cf0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	52                   	push   %edx
  801cfc:	ff 75 0c             	pushl  0xc(%ebp)
  801cff:	50                   	push   %eax
  801d00:	6a 00                	push   $0x0
  801d02:	e8 b2 ff ff ff       	call   801cb9 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	90                   	nop
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_cgetc>:

int
sys_cgetc(void)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 01                	push   $0x1
  801d1c:	e8 98 ff ff ff       	call   801cb9 <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	50                   	push   %eax
  801d35:	6a 05                	push   $0x5
  801d37:	e8 7d ff ff ff       	call   801cb9 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 02                	push   $0x2
  801d50:	e8 64 ff ff ff       	call   801cb9 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 03                	push   $0x3
  801d69:	e8 4b ff ff ff       	call   801cb9 <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 04                	push   $0x4
  801d82:	e8 32 ff ff ff       	call   801cb9 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_env_exit>:


void sys_env_exit(void)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 06                	push   $0x6
  801d9b:	e8 19 ff ff ff       	call   801cb9 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	90                   	nop
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	52                   	push   %edx
  801db6:	50                   	push   %eax
  801db7:	6a 07                	push   $0x7
  801db9:	e8 fb fe ff ff       	call   801cb9 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dc8:	8b 75 18             	mov    0x18(%ebp),%esi
  801dcb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	56                   	push   %esi
  801dd8:	53                   	push   %ebx
  801dd9:	51                   	push   %ecx
  801dda:	52                   	push   %edx
  801ddb:	50                   	push   %eax
  801ddc:	6a 08                	push   $0x8
  801dde:	e8 d6 fe ff ff       	call   801cb9 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de9:	5b                   	pop    %ebx
  801dea:	5e                   	pop    %esi
  801deb:	5d                   	pop    %ebp
  801dec:	c3                   	ret    

00801ded <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801df0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	52                   	push   %edx
  801dfd:	50                   	push   %eax
  801dfe:	6a 09                	push   $0x9
  801e00:	e8 b4 fe ff ff       	call   801cb9 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	ff 75 08             	pushl  0x8(%ebp)
  801e19:	6a 0a                	push   $0xa
  801e1b:	e8 99 fe ff ff       	call   801cb9 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 0b                	push   $0xb
  801e34:	e8 80 fe ff ff       	call   801cb9 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 0c                	push   $0xc
  801e4d:	e8 67 fe ff ff       	call   801cb9 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 0d                	push   $0xd
  801e66:	e8 4e fe ff ff       	call   801cb9 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	ff 75 08             	pushl  0x8(%ebp)
  801e7f:	6a 11                	push   $0x11
  801e81:	e8 33 fe ff ff       	call   801cb9 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
	return;
  801e89:	90                   	nop
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	ff 75 0c             	pushl  0xc(%ebp)
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	6a 12                	push   $0x12
  801e9d:	e8 17 fe ff ff       	call   801cb9 <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea5:	90                   	nop
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 0e                	push   $0xe
  801eb7:	e8 fd fd ff ff       	call   801cb9 <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	ff 75 08             	pushl  0x8(%ebp)
  801ecf:	6a 0f                	push   $0xf
  801ed1:	e8 e3 fd ff ff       	call   801cb9 <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 10                	push   $0x10
  801eea:	e8 ca fd ff ff       	call   801cb9 <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
}
  801ef2:	90                   	nop
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 14                	push   $0x14
  801f04:	e8 b0 fd ff ff       	call   801cb9 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	90                   	nop
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 15                	push   $0x15
  801f1e:	e8 96 fd ff ff       	call   801cb9 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	90                   	nop
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 04             	sub    $0x4,%esp
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f35:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	50                   	push   %eax
  801f42:	6a 16                	push   $0x16
  801f44:	e8 70 fd ff ff       	call   801cb9 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	90                   	nop
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 17                	push   $0x17
  801f5e:	e8 56 fd ff ff       	call   801cb9 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	90                   	nop
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	ff 75 0c             	pushl  0xc(%ebp)
  801f78:	50                   	push   %eax
  801f79:	6a 18                	push   $0x18
  801f7b:	e8 39 fd ff ff       	call   801cb9 <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	52                   	push   %edx
  801f95:	50                   	push   %eax
  801f96:	6a 1b                	push   $0x1b
  801f98:	e8 1c fd ff ff       	call   801cb9 <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	52                   	push   %edx
  801fb2:	50                   	push   %eax
  801fb3:	6a 19                	push   $0x19
  801fb5:	e8 ff fc ff ff       	call   801cb9 <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
}
  801fbd:	90                   	nop
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	52                   	push   %edx
  801fd0:	50                   	push   %eax
  801fd1:	6a 1a                	push   $0x1a
  801fd3:	e8 e1 fc ff ff       	call   801cb9 <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
}
  801fdb:	90                   	nop
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	6a 00                	push   $0x0
  801ff6:	51                   	push   %ecx
  801ff7:	52                   	push   %edx
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	50                   	push   %eax
  801ffc:	6a 1c                	push   $0x1c
  801ffe:	e8 b6 fc ff ff       	call   801cb9 <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80200b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	52                   	push   %edx
  802018:	50                   	push   %eax
  802019:	6a 1d                	push   $0x1d
  80201b:	e8 99 fc ff ff       	call   801cb9 <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802028:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	51                   	push   %ecx
  802036:	52                   	push   %edx
  802037:	50                   	push   %eax
  802038:	6a 1e                	push   $0x1e
  80203a:	e8 7a fc ff ff       	call   801cb9 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	52                   	push   %edx
  802054:	50                   	push   %eax
  802055:	6a 1f                	push   $0x1f
  802057:	e8 5d fc ff ff       	call   801cb9 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 20                	push   $0x20
  802070:	e8 44 fc ff ff       	call   801cb9 <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	6a 00                	push   $0x0
  802082:	ff 75 14             	pushl  0x14(%ebp)
  802085:	ff 75 10             	pushl  0x10(%ebp)
  802088:	ff 75 0c             	pushl  0xc(%ebp)
  80208b:	50                   	push   %eax
  80208c:	6a 21                	push   $0x21
  80208e:	e8 26 fc ff ff       	call   801cb9 <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	50                   	push   %eax
  8020a7:	6a 22                	push   $0x22
  8020a9:	e8 0b fc ff ff       	call   801cb9 <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	90                   	nop
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	50                   	push   %eax
  8020c3:	6a 23                	push   $0x23
  8020c5:	e8 ef fb ff ff       	call   801cb9 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	90                   	nop
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020d9:	8d 50 04             	lea    0x4(%eax),%edx
  8020dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	52                   	push   %edx
  8020e6:	50                   	push   %eax
  8020e7:	6a 24                	push   $0x24
  8020e9:	e8 cb fb ff ff       	call   801cb9 <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020fa:	89 01                	mov    %eax,(%ecx)
  8020fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	c9                   	leave  
  802103:	c2 04 00             	ret    $0x4

00802106 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	ff 75 10             	pushl  0x10(%ebp)
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	ff 75 08             	pushl  0x8(%ebp)
  802116:	6a 13                	push   $0x13
  802118:	e8 9c fb ff ff       	call   801cb9 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
	return ;
  802120:	90                   	nop
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <sys_rcr2>:
uint32 sys_rcr2()
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 25                	push   $0x25
  802132:	e8 82 fb ff ff       	call   801cb9 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802148:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	50                   	push   %eax
  802155:	6a 26                	push   $0x26
  802157:	e8 5d fb ff ff       	call   801cb9 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
	return ;
  80215f:	90                   	nop
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <rsttst>:
void rsttst()
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 28                	push   $0x28
  802171:	e8 43 fb ff ff       	call   801cb9 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
	return ;
  802179:	90                   	nop
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	8b 45 14             	mov    0x14(%ebp),%eax
  802185:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802188:	8b 55 18             	mov    0x18(%ebp),%edx
  80218b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80218f:	52                   	push   %edx
  802190:	50                   	push   %eax
  802191:	ff 75 10             	pushl  0x10(%ebp)
  802194:	ff 75 0c             	pushl  0xc(%ebp)
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	6a 27                	push   $0x27
  80219c:	e8 18 fb ff ff       	call   801cb9 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a4:	90                   	nop
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <chktst>:
void chktst(uint32 n)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	ff 75 08             	pushl  0x8(%ebp)
  8021b5:	6a 29                	push   $0x29
  8021b7:	e8 fd fa ff ff       	call   801cb9 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021bf:	90                   	nop
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <inctst>:

void inctst()
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 2a                	push   $0x2a
  8021d1:	e8 e3 fa ff ff       	call   801cb9 <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d9:	90                   	nop
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <gettst>:
uint32 gettst()
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 2b                	push   $0x2b
  8021eb:	e8 c9 fa ff ff       	call   801cb9 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 2c                	push   $0x2c
  802207:	e8 ad fa ff ff       	call   801cb9 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
  80220f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802212:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802216:	75 07                	jne    80221f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802218:	b8 01 00 00 00       	mov    $0x1,%eax
  80221d:	eb 05                	jmp    802224 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 2c                	push   $0x2c
  802238:	e8 7c fa ff ff       	call   801cb9 <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
  802240:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802243:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802247:	75 07                	jne    802250 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802249:	b8 01 00 00 00       	mov    $0x1,%eax
  80224e:	eb 05                	jmp    802255 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802250:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 2c                	push   $0x2c
  802269:	e8 4b fa ff ff       	call   801cb9 <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
  802271:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802274:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802278:	75 07                	jne    802281 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80227a:	b8 01 00 00 00       	mov    $0x1,%eax
  80227f:	eb 05                	jmp    802286 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802281:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 2c                	push   $0x2c
  80229a:	e8 1a fa ff ff       	call   801cb9 <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
  8022a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022a5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022a9:	75 07                	jne    8022b2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b0:	eb 05                	jmp    8022b7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	ff 75 08             	pushl  0x8(%ebp)
  8022c7:	6a 2d                	push   $0x2d
  8022c9:	e8 eb f9 ff ff       	call   801cb9 <syscall>
  8022ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d1:	90                   	nop
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	6a 00                	push   $0x0
  8022e6:	53                   	push   %ebx
  8022e7:	51                   	push   %ecx
  8022e8:	52                   	push   %edx
  8022e9:	50                   	push   %eax
  8022ea:	6a 2e                	push   $0x2e
  8022ec:	e8 c8 f9 ff ff       	call   801cb9 <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	52                   	push   %edx
  802309:	50                   	push   %eax
  80230a:	6a 2f                	push   $0x2f
  80230c:	e8 a8 f9 ff ff       	call   801cb9 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    
  802316:	66 90                	xchg   %ax,%ax

00802318 <__udivdi3>:
  802318:	55                   	push   %ebp
  802319:	57                   	push   %edi
  80231a:	56                   	push   %esi
  80231b:	53                   	push   %ebx
  80231c:	83 ec 1c             	sub    $0x1c,%esp
  80231f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802323:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802327:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80232b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80232f:	89 ca                	mov    %ecx,%edx
  802331:	89 f8                	mov    %edi,%eax
  802333:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802337:	85 f6                	test   %esi,%esi
  802339:	75 2d                	jne    802368 <__udivdi3+0x50>
  80233b:	39 cf                	cmp    %ecx,%edi
  80233d:	77 65                	ja     8023a4 <__udivdi3+0x8c>
  80233f:	89 fd                	mov    %edi,%ebp
  802341:	85 ff                	test   %edi,%edi
  802343:	75 0b                	jne    802350 <__udivdi3+0x38>
  802345:	b8 01 00 00 00       	mov    $0x1,%eax
  80234a:	31 d2                	xor    %edx,%edx
  80234c:	f7 f7                	div    %edi
  80234e:	89 c5                	mov    %eax,%ebp
  802350:	31 d2                	xor    %edx,%edx
  802352:	89 c8                	mov    %ecx,%eax
  802354:	f7 f5                	div    %ebp
  802356:	89 c1                	mov    %eax,%ecx
  802358:	89 d8                	mov    %ebx,%eax
  80235a:	f7 f5                	div    %ebp
  80235c:	89 cf                	mov    %ecx,%edi
  80235e:	89 fa                	mov    %edi,%edx
  802360:	83 c4 1c             	add    $0x1c,%esp
  802363:	5b                   	pop    %ebx
  802364:	5e                   	pop    %esi
  802365:	5f                   	pop    %edi
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    
  802368:	39 ce                	cmp    %ecx,%esi
  80236a:	77 28                	ja     802394 <__udivdi3+0x7c>
  80236c:	0f bd fe             	bsr    %esi,%edi
  80236f:	83 f7 1f             	xor    $0x1f,%edi
  802372:	75 40                	jne    8023b4 <__udivdi3+0x9c>
  802374:	39 ce                	cmp    %ecx,%esi
  802376:	72 0a                	jb     802382 <__udivdi3+0x6a>
  802378:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80237c:	0f 87 9e 00 00 00    	ja     802420 <__udivdi3+0x108>
  802382:	b8 01 00 00 00       	mov    $0x1,%eax
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d 76 00             	lea    0x0(%esi),%esi
  802394:	31 ff                	xor    %edi,%edi
  802396:	31 c0                	xor    %eax,%eax
  802398:	89 fa                	mov    %edi,%edx
  80239a:	83 c4 1c             	add    $0x1c,%esp
  80239d:	5b                   	pop    %ebx
  80239e:	5e                   	pop    %esi
  80239f:	5f                   	pop    %edi
  8023a0:	5d                   	pop    %ebp
  8023a1:	c3                   	ret    
  8023a2:	66 90                	xchg   %ax,%ax
  8023a4:	89 d8                	mov    %ebx,%eax
  8023a6:	f7 f7                	div    %edi
  8023a8:	31 ff                	xor    %edi,%edi
  8023aa:	89 fa                	mov    %edi,%edx
  8023ac:	83 c4 1c             	add    $0x1c,%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    
  8023b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023b9:	89 eb                	mov    %ebp,%ebx
  8023bb:	29 fb                	sub    %edi,%ebx
  8023bd:	89 f9                	mov    %edi,%ecx
  8023bf:	d3 e6                	shl    %cl,%esi
  8023c1:	89 c5                	mov    %eax,%ebp
  8023c3:	88 d9                	mov    %bl,%cl
  8023c5:	d3 ed                	shr    %cl,%ebp
  8023c7:	89 e9                	mov    %ebp,%ecx
  8023c9:	09 f1                	or     %esi,%ecx
  8023cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023cf:	89 f9                	mov    %edi,%ecx
  8023d1:	d3 e0                	shl    %cl,%eax
  8023d3:	89 c5                	mov    %eax,%ebp
  8023d5:	89 d6                	mov    %edx,%esi
  8023d7:	88 d9                	mov    %bl,%cl
  8023d9:	d3 ee                	shr    %cl,%esi
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e2                	shl    %cl,%edx
  8023df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023e3:	88 d9                	mov    %bl,%cl
  8023e5:	d3 e8                	shr    %cl,%eax
  8023e7:	09 c2                	or     %eax,%edx
  8023e9:	89 d0                	mov    %edx,%eax
  8023eb:	89 f2                	mov    %esi,%edx
  8023ed:	f7 74 24 0c          	divl   0xc(%esp)
  8023f1:	89 d6                	mov    %edx,%esi
  8023f3:	89 c3                	mov    %eax,%ebx
  8023f5:	f7 e5                	mul    %ebp
  8023f7:	39 d6                	cmp    %edx,%esi
  8023f9:	72 19                	jb     802414 <__udivdi3+0xfc>
  8023fb:	74 0b                	je     802408 <__udivdi3+0xf0>
  8023fd:	89 d8                	mov    %ebx,%eax
  8023ff:	31 ff                	xor    %edi,%edi
  802401:	e9 58 ff ff ff       	jmp    80235e <__udivdi3+0x46>
  802406:	66 90                	xchg   %ax,%ax
  802408:	8b 54 24 08          	mov    0x8(%esp),%edx
  80240c:	89 f9                	mov    %edi,%ecx
  80240e:	d3 e2                	shl    %cl,%edx
  802410:	39 c2                	cmp    %eax,%edx
  802412:	73 e9                	jae    8023fd <__udivdi3+0xe5>
  802414:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802417:	31 ff                	xor    %edi,%edi
  802419:	e9 40 ff ff ff       	jmp    80235e <__udivdi3+0x46>
  80241e:	66 90                	xchg   %ax,%ax
  802420:	31 c0                	xor    %eax,%eax
  802422:	e9 37 ff ff ff       	jmp    80235e <__udivdi3+0x46>
  802427:	90                   	nop

00802428 <__umoddi3>:
  802428:	55                   	push   %ebp
  802429:	57                   	push   %edi
  80242a:	56                   	push   %esi
  80242b:	53                   	push   %ebx
  80242c:	83 ec 1c             	sub    $0x1c,%esp
  80242f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802433:	8b 74 24 34          	mov    0x34(%esp),%esi
  802437:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80243b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80243f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802443:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802447:	89 f3                	mov    %esi,%ebx
  802449:	89 fa                	mov    %edi,%edx
  80244b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80244f:	89 34 24             	mov    %esi,(%esp)
  802452:	85 c0                	test   %eax,%eax
  802454:	75 1a                	jne    802470 <__umoddi3+0x48>
  802456:	39 f7                	cmp    %esi,%edi
  802458:	0f 86 a2 00 00 00    	jbe    802500 <__umoddi3+0xd8>
  80245e:	89 c8                	mov    %ecx,%eax
  802460:	89 f2                	mov    %esi,%edx
  802462:	f7 f7                	div    %edi
  802464:	89 d0                	mov    %edx,%eax
  802466:	31 d2                	xor    %edx,%edx
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	39 f0                	cmp    %esi,%eax
  802472:	0f 87 ac 00 00 00    	ja     802524 <__umoddi3+0xfc>
  802478:	0f bd e8             	bsr    %eax,%ebp
  80247b:	83 f5 1f             	xor    $0x1f,%ebp
  80247e:	0f 84 ac 00 00 00    	je     802530 <__umoddi3+0x108>
  802484:	bf 20 00 00 00       	mov    $0x20,%edi
  802489:	29 ef                	sub    %ebp,%edi
  80248b:	89 fe                	mov    %edi,%esi
  80248d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e0                	shl    %cl,%eax
  802495:	89 d7                	mov    %edx,%edi
  802497:	89 f1                	mov    %esi,%ecx
  802499:	d3 ef                	shr    %cl,%edi
  80249b:	09 c7                	or     %eax,%edi
  80249d:	89 e9                	mov    %ebp,%ecx
  80249f:	d3 e2                	shl    %cl,%edx
  8024a1:	89 14 24             	mov    %edx,(%esp)
  8024a4:	89 d8                	mov    %ebx,%eax
  8024a6:	d3 e0                	shl    %cl,%eax
  8024a8:	89 c2                	mov    %eax,%edx
  8024aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024ae:	d3 e0                	shl    %cl,%eax
  8024b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024b8:	89 f1                	mov    %esi,%ecx
  8024ba:	d3 e8                	shr    %cl,%eax
  8024bc:	09 d0                	or     %edx,%eax
  8024be:	d3 eb                	shr    %cl,%ebx
  8024c0:	89 da                	mov    %ebx,%edx
  8024c2:	f7 f7                	div    %edi
  8024c4:	89 d3                	mov    %edx,%ebx
  8024c6:	f7 24 24             	mull   (%esp)
  8024c9:	89 c6                	mov    %eax,%esi
  8024cb:	89 d1                	mov    %edx,%ecx
  8024cd:	39 d3                	cmp    %edx,%ebx
  8024cf:	0f 82 87 00 00 00    	jb     80255c <__umoddi3+0x134>
  8024d5:	0f 84 91 00 00 00    	je     80256c <__umoddi3+0x144>
  8024db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024df:	29 f2                	sub    %esi,%edx
  8024e1:	19 cb                	sbb    %ecx,%ebx
  8024e3:	89 d8                	mov    %ebx,%eax
  8024e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024e9:	d3 e0                	shl    %cl,%eax
  8024eb:	89 e9                	mov    %ebp,%ecx
  8024ed:	d3 ea                	shr    %cl,%edx
  8024ef:	09 d0                	or     %edx,%eax
  8024f1:	89 e9                	mov    %ebp,%ecx
  8024f3:	d3 eb                	shr    %cl,%ebx
  8024f5:	89 da                	mov    %ebx,%edx
  8024f7:	83 c4 1c             	add    $0x1c,%esp
  8024fa:	5b                   	pop    %ebx
  8024fb:	5e                   	pop    %esi
  8024fc:	5f                   	pop    %edi
  8024fd:	5d                   	pop    %ebp
  8024fe:	c3                   	ret    
  8024ff:	90                   	nop
  802500:	89 fd                	mov    %edi,%ebp
  802502:	85 ff                	test   %edi,%edi
  802504:	75 0b                	jne    802511 <__umoddi3+0xe9>
  802506:	b8 01 00 00 00       	mov    $0x1,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	f7 f7                	div    %edi
  80250f:	89 c5                	mov    %eax,%ebp
  802511:	89 f0                	mov    %esi,%eax
  802513:	31 d2                	xor    %edx,%edx
  802515:	f7 f5                	div    %ebp
  802517:	89 c8                	mov    %ecx,%eax
  802519:	f7 f5                	div    %ebp
  80251b:	89 d0                	mov    %edx,%eax
  80251d:	e9 44 ff ff ff       	jmp    802466 <__umoddi3+0x3e>
  802522:	66 90                	xchg   %ax,%ax
  802524:	89 c8                	mov    %ecx,%eax
  802526:	89 f2                	mov    %esi,%edx
  802528:	83 c4 1c             	add    $0x1c,%esp
  80252b:	5b                   	pop    %ebx
  80252c:	5e                   	pop    %esi
  80252d:	5f                   	pop    %edi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    
  802530:	3b 04 24             	cmp    (%esp),%eax
  802533:	72 06                	jb     80253b <__umoddi3+0x113>
  802535:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802539:	77 0f                	ja     80254a <__umoddi3+0x122>
  80253b:	89 f2                	mov    %esi,%edx
  80253d:	29 f9                	sub    %edi,%ecx
  80253f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802543:	89 14 24             	mov    %edx,(%esp)
  802546:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80254a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80254e:	8b 14 24             	mov    (%esp),%edx
  802551:	83 c4 1c             	add    $0x1c,%esp
  802554:	5b                   	pop    %ebx
  802555:	5e                   	pop    %esi
  802556:	5f                   	pop    %edi
  802557:	5d                   	pop    %ebp
  802558:	c3                   	ret    
  802559:	8d 76 00             	lea    0x0(%esi),%esi
  80255c:	2b 04 24             	sub    (%esp),%eax
  80255f:	19 fa                	sbb    %edi,%edx
  802561:	89 d1                	mov    %edx,%ecx
  802563:	89 c6                	mov    %eax,%esi
  802565:	e9 71 ff ff ff       	jmp    8024db <__umoddi3+0xb3>
  80256a:	66 90                	xchg   %ax,%ax
  80256c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802570:	72 ea                	jb     80255c <__umoddi3+0x134>
  802572:	89 d9                	mov    %ebx,%ecx
  802574:	e9 62 ff ff ff       	jmp    8024db <__umoddi3+0xb3>
