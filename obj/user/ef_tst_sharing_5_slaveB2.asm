
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 71 01 00 00       	call   8001a7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 23                	jmp    80006e <_main+0x36>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	c1 e2 04             	shl    $0x4,%edx
  80005c:	01 d0                	add    %edx,%eax
  80005e:	8a 40 04             	mov    0x4(%eax),%al
  800061:	84 c0                	test   %al,%al
  800063:	74 06                	je     80006b <_main+0x33>
			{
				fullWS = 0;
  800065:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800069:	eb 12                	jmp    80007d <_main+0x45>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006b:	ff 45 f0             	incl   -0x10(%ebp)
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 50 74             	mov    0x74(%eax),%edx
  800076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800079:	39 c2                	cmp    %eax,%edx
  80007b:	77 ce                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800081:	74 14                	je     800097 <_main+0x5f>
  800083:	83 ec 04             	sub    $0x4,%esp
  800086:	68 80 1f 80 00       	push   $0x801f80
  80008b:	6a 12                	push   $0x12
  80008d:	68 9c 1f 80 00       	push   $0x801f9c
  800092:	e8 55 02 00 00       	call   8002ec <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  800097:	e8 1d 16 00 00       	call   8016b9 <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 bc 1f 80 00       	push   $0x801fbc
  8000a4:	50                   	push   %eax
  8000a5:	e8 a7 14 00 00       	call   801551 <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 c0 1f 80 00       	push   $0x801fc0
  8000b8:	e8 d1 04 00 00       	call   80058e <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 e8 1f 80 00       	push   $0x801fe8
  8000c8:	e8 c1 04 00 00       	call   80058e <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 28 23 00 00       	push   $0x2328
  8000d8:	e8 7f 1b 00 00       	call   801c5c <env_sleep>
  8000dd:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 86 16 00 00       	call   80176b <sys_calculate_free_frames>
  8000e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 7b 14 00 00       	call   80156e <sfree>
  8000f3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 08 20 80 00       	push   $0x802008
  8000fe:	e8 8b 04 00 00       	call   80058e <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800106:	e8 60 16 00 00       	call   80176b <sys_calculate_free_frames>
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800110:	29 c2                	sub    %eax,%edx
  800112:	89 d0                	mov    %edx,%eax
  800114:	83 f8 04             	cmp    $0x4,%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 20 20 80 00       	push   $0x802020
  800121:	6a 20                	push   $0x20
  800123:	68 9c 1f 80 00       	push   $0x801f9c
  800128:	e8 bf 01 00 00       	call   8002ec <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  80012d:	e8 f0 19 00 00       	call   801b22 <gettst>
  800132:	83 f8 02             	cmp    $0x2,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 c0 20 80 00       	push   $0x8020c0
  80013f:	6a 23                	push   $0x23
  800141:	68 9c 1f 80 00       	push   $0x801f9c
  800146:	e8 a1 01 00 00       	call   8002ec <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	68 cc 20 80 00       	push   $0x8020cc
  800153:	e8 36 04 00 00       	call   80058e <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 f0 20 80 00       	push   $0x8020f0
  800163:	e8 26 04 00 00       	call   80058e <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80016b:	e8 49 15 00 00       	call   8016b9 <sys_getparentenvid>
  800170:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800173:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800177:	7e 2b                	jle    8001a4 <_main+0x16c>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800180:	83 ec 08             	sub    $0x8,%esp
  800183:	68 3c 21 80 00       	push   $0x80213c
  800188:	ff 75 e4             	pushl  -0x1c(%ebp)
  80018b:	e8 c1 13 00 00       	call   801551 <sget>
  800190:	83 c4 10             	add    $0x10,%esp
  800193:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  800196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800199:	8b 00                	mov    (%eax),%eax
  80019b:	8d 50 01             	lea    0x1(%eax),%edx
  80019e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a1:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a3:	90                   	nop
  8001a4:	90                   	nop
}
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ad:	e8 ee 14 00 00       	call   8016a0 <sys_getenvindex>
  8001b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	c1 e0 03             	shl    $0x3,%eax
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001c6:	01 c8                	add    %ecx,%eax
  8001c8:	01 c0                	add    %eax,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	01 c0                	add    %eax,%eax
  8001ce:	01 d0                	add    %edx,%eax
  8001d0:	89 c2                	mov    %eax,%edx
  8001d2:	c1 e2 05             	shl    $0x5,%edx
  8001d5:	29 c2                	sub    %eax,%edx
  8001d7:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001de:	89 c2                	mov    %eax,%edx
  8001e0:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001e6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f0:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001f6:	84 c0                	test   %al,%al
  8001f8:	74 0f                	je     800209 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ff:	05 40 3c 01 00       	add    $0x13c40,%eax
  800204:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80020d:	7e 0a                	jle    800219 <libmain+0x72>
		binaryname = argv[0];
  80020f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800212:	8b 00                	mov    (%eax),%eax
  800214:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	ff 75 0c             	pushl  0xc(%ebp)
  80021f:	ff 75 08             	pushl  0x8(%ebp)
  800222:	e8 11 fe ff ff       	call   800038 <_main>
  800227:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80022a:	e8 0c 16 00 00       	call   80183b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 64 21 80 00       	push   $0x802164
  800237:	e8 52 03 00 00       	call   80058e <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80023f:	a1 20 30 80 00       	mov    0x803020,%eax
  800244:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80024a:	a1 20 30 80 00       	mov    0x803020,%eax
  80024f:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800255:	83 ec 04             	sub    $0x4,%esp
  800258:	52                   	push   %edx
  800259:	50                   	push   %eax
  80025a:	68 8c 21 80 00       	push   $0x80218c
  80025f:	e8 2a 03 00 00       	call   80058e <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800267:	a1 20 30 80 00       	mov    0x803020,%eax
  80026c:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800272:	a1 20 30 80 00       	mov    0x803020,%eax
  800277:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80027d:	83 ec 04             	sub    $0x4,%esp
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 b4 21 80 00       	push   $0x8021b4
  800287:	e8 02 03 00 00       	call   80058e <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028f:	a1 20 30 80 00       	mov    0x803020,%eax
  800294:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 f5 21 80 00       	push   $0x8021f5
  8002a3:	e8 e6 02 00 00       	call   80058e <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 64 21 80 00       	push   $0x802164
  8002b3:	e8 d6 02 00 00       	call   80058e <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002bb:	e8 95 15 00 00       	call   801855 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002c0:	e8 19 00 00 00       	call   8002de <exit>
}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 00                	push   $0x0
  8002d3:	e8 94 13 00 00       	call   80166c <sys_env_destroy>
  8002d8:	83 c4 10             	add    $0x10,%esp
}
  8002db:	90                   	nop
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <exit>:

void
exit(void)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002e4:	e8 e9 13 00 00       	call   8016d2 <sys_env_exit>
}
  8002e9:	90                   	nop
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f5:	83 c0 04             	add    $0x4,%eax
  8002f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002fb:	a1 18 31 80 00       	mov    0x803118,%eax
  800300:	85 c0                	test   %eax,%eax
  800302:	74 16                	je     80031a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800304:	a1 18 31 80 00       	mov    0x803118,%eax
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	50                   	push   %eax
  80030d:	68 0c 22 80 00       	push   $0x80220c
  800312:	e8 77 02 00 00       	call   80058e <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80031a:	a1 00 30 80 00       	mov    0x803000,%eax
  80031f:	ff 75 0c             	pushl  0xc(%ebp)
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	50                   	push   %eax
  800326:	68 11 22 80 00       	push   $0x802211
  80032b:	e8 5e 02 00 00       	call   80058e <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800333:	8b 45 10             	mov    0x10(%ebp),%eax
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 75 f4             	pushl  -0xc(%ebp)
  80033c:	50                   	push   %eax
  80033d:	e8 e1 01 00 00       	call   800523 <vcprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	6a 00                	push   $0x0
  80034a:	68 2d 22 80 00       	push   $0x80222d
  80034f:	e8 cf 01 00 00       	call   800523 <vcprintf>
  800354:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800357:	e8 82 ff ff ff       	call   8002de <exit>

	// should not return here
	while (1) ;
  80035c:	eb fe                	jmp    80035c <_panic+0x70>

0080035e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800364:	a1 20 30 80 00       	mov    0x803020,%eax
  800369:	8b 50 74             	mov    0x74(%eax),%edx
  80036c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036f:	39 c2                	cmp    %eax,%edx
  800371:	74 14                	je     800387 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800373:	83 ec 04             	sub    $0x4,%esp
  800376:	68 30 22 80 00       	push   $0x802230
  80037b:	6a 26                	push   $0x26
  80037d:	68 7c 22 80 00       	push   $0x80227c
  800382:	e8 65 ff ff ff       	call   8002ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800395:	e9 b6 00 00 00       	jmp    800450 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	75 08                	jne    8003b7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003af:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b2:	e9 96 00 00 00       	jmp    80044d <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c5:	eb 5d                	jmp    800424 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d5:	c1 e2 04             	shl    $0x4,%edx
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	8a 40 04             	mov    0x4(%eax),%al
  8003dd:	84 c0                	test   %al,%al
  8003df:	75 40                	jne    800421 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ef:	c1 e2 04             	shl    $0x4,%edx
  8003f2:	01 d0                	add    %edx,%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800401:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800406:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	01 c8                	add    %ecx,%eax
  800412:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800414:	39 c2                	cmp    %eax,%edx
  800416:	75 09                	jne    800421 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800418:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80041f:	eb 12                	jmp    800433 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800421:	ff 45 e8             	incl   -0x18(%ebp)
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8b 50 74             	mov    0x74(%eax),%edx
  80042c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80042f:	39 c2                	cmp    %eax,%edx
  800431:	77 94                	ja     8003c7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800437:	75 14                	jne    80044d <CheckWSWithoutLastIndex+0xef>
			panic(
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	68 88 22 80 00       	push   $0x802288
  800441:	6a 3a                	push   $0x3a
  800443:	68 7c 22 80 00       	push   $0x80227c
  800448:	e8 9f fe ff ff       	call   8002ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80044d:	ff 45 f0             	incl   -0x10(%ebp)
  800450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800453:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800456:	0f 8c 3e ff ff ff    	jl     80039a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80045c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800463:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80046a:	eb 20                	jmp    80048c <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80046c:	a1 20 30 80 00       	mov    0x803020,%eax
  800471:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800477:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047a:	c1 e2 04             	shl    $0x4,%edx
  80047d:	01 d0                	add    %edx,%eax
  80047f:	8a 40 04             	mov    0x4(%eax),%al
  800482:	3c 01                	cmp    $0x1,%al
  800484:	75 03                	jne    800489 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800486:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800489:	ff 45 e0             	incl   -0x20(%ebp)
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 50 74             	mov    0x74(%eax),%edx
  800494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800497:	39 c2                	cmp    %eax,%edx
  800499:	77 d1                	ja     80046c <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80049b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004a1:	74 14                	je     8004b7 <CheckWSWithoutLastIndex+0x159>
		panic(
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 dc 22 80 00       	push   $0x8022dc
  8004ab:	6a 44                	push   $0x44
  8004ad:	68 7c 22 80 00       	push   $0x80227c
  8004b2:	e8 35 fe ff ff       	call   8002ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8004c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cb:	89 0a                	mov    %ecx,(%edx)
  8004cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d0:	88 d1                	mov    %dl,%cl
  8004d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004e3:	75 2c                	jne    800511 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004e5:	a0 24 30 80 00       	mov    0x803024,%al
  8004ea:	0f b6 c0             	movzbl %al,%eax
  8004ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f0:	8b 12                	mov    (%edx),%edx
  8004f2:	89 d1                	mov    %edx,%ecx
  8004f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f7:	83 c2 08             	add    $0x8,%edx
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	50                   	push   %eax
  8004fe:	51                   	push   %ecx
  8004ff:	52                   	push   %edx
  800500:	e8 25 11 00 00       	call   80162a <sys_cputs>
  800505:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	8b 40 04             	mov    0x4(%eax),%eax
  800517:	8d 50 01             	lea    0x1(%eax),%edx
  80051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800520:	90                   	nop
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80052c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800533:	00 00 00 
	b.cnt = 0;
  800536:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80053d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	ff 75 08             	pushl  0x8(%ebp)
  800546:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054c:	50                   	push   %eax
  80054d:	68 ba 04 80 00       	push   $0x8004ba
  800552:	e8 11 02 00 00       	call   800768 <vprintfmt>
  800557:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80055a:	a0 24 30 80 00       	mov    0x803024,%al
  80055f:	0f b6 c0             	movzbl %al,%eax
  800562:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	50                   	push   %eax
  80056c:	52                   	push   %edx
  80056d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800573:	83 c0 08             	add    $0x8,%eax
  800576:	50                   	push   %eax
  800577:	e8 ae 10 00 00       	call   80162a <sys_cputs>
  80057c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80057f:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800586:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <cprintf>:

int cprintf(const char *fmt, ...) {
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800594:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80059b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005aa:	50                   	push   %eax
  8005ab:	e8 73 ff ff ff       	call   800523 <vcprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c1:	e8 75 12 00 00       	call   80183b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005c6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	e8 48 ff ff ff       	call   800523 <vcprintf>
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005e1:	e8 6f 12 00 00       	call   801855 <sys_enable_interrupt>
	return cnt;
  8005e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e9:	c9                   	leave  
  8005ea:	c3                   	ret    

008005eb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	53                   	push   %ebx
  8005ef:	83 ec 14             	sub    $0x14,%esp
  8005f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800609:	77 55                	ja     800660 <printnum+0x75>
  80060b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80060e:	72 05                	jb     800615 <printnum+0x2a>
  800610:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800613:	77 4b                	ja     800660 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800615:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800618:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80061b:	8b 45 18             	mov    0x18(%ebp),%eax
  80061e:	ba 00 00 00 00       	mov    $0x0,%edx
  800623:	52                   	push   %edx
  800624:	50                   	push   %eax
  800625:	ff 75 f4             	pushl  -0xc(%ebp)
  800628:	ff 75 f0             	pushl  -0x10(%ebp)
  80062b:	e8 e0 16 00 00       	call   801d10 <__udivdi3>
  800630:	83 c4 10             	add    $0x10,%esp
  800633:	83 ec 04             	sub    $0x4,%esp
  800636:	ff 75 20             	pushl  0x20(%ebp)
  800639:	53                   	push   %ebx
  80063a:	ff 75 18             	pushl  0x18(%ebp)
  80063d:	52                   	push   %edx
  80063e:	50                   	push   %eax
  80063f:	ff 75 0c             	pushl  0xc(%ebp)
  800642:	ff 75 08             	pushl  0x8(%ebp)
  800645:	e8 a1 ff ff ff       	call   8005eb <printnum>
  80064a:	83 c4 20             	add    $0x20,%esp
  80064d:	eb 1a                	jmp    800669 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	ff 75 20             	pushl  0x20(%ebp)
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	ff d0                	call   *%eax
  80065d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800660:	ff 4d 1c             	decl   0x1c(%ebp)
  800663:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800667:	7f e6                	jg     80064f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800669:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80066c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800677:	53                   	push   %ebx
  800678:	51                   	push   %ecx
  800679:	52                   	push   %edx
  80067a:	50                   	push   %eax
  80067b:	e8 a0 17 00 00       	call   801e20 <__umoddi3>
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	05 54 25 80 00       	add    $0x802554,%eax
  800688:	8a 00                	mov    (%eax),%al
  80068a:	0f be c0             	movsbl %al,%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 0c             	pushl  0xc(%ebp)
  800693:	50                   	push   %eax
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	ff d0                	call   *%eax
  800699:	83 c4 10             	add    $0x10,%esp
}
  80069c:	90                   	nop
  80069d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a0:	c9                   	leave  
  8006a1:	c3                   	ret    

008006a2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006a2:	55                   	push   %ebp
  8006a3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a9:	7e 1c                	jle    8006c7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	8d 50 08             	lea    0x8(%eax),%edx
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	89 10                	mov    %edx,(%eax)
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	83 e8 08             	sub    $0x8,%eax
  8006c0:	8b 50 04             	mov    0x4(%eax),%edx
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	eb 40                	jmp    800707 <getuint+0x65>
	else if (lflag)
  8006c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cb:	74 1e                	je     8006eb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	8d 50 04             	lea    0x4(%eax),%edx
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	89 10                	mov    %edx,(%eax)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	83 e8 04             	sub    $0x4,%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e9:	eb 1c                	jmp    800707 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800707:	5d                   	pop    %ebp
  800708:	c3                   	ret    

00800709 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80070c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800710:	7e 1c                	jle    80072e <getint+0x25>
		return va_arg(*ap, long long);
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	8d 50 08             	lea    0x8(%eax),%edx
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	89 10                	mov    %edx,(%eax)
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	83 e8 08             	sub    $0x8,%eax
  800727:	8b 50 04             	mov    0x4(%eax),%edx
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	eb 38                	jmp    800766 <getint+0x5d>
	else if (lflag)
  80072e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800732:	74 1a                	je     80074e <getint+0x45>
		return va_arg(*ap, long);
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	8d 50 04             	lea    0x4(%eax),%edx
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	89 10                	mov    %edx,(%eax)
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	83 e8 04             	sub    $0x4,%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	99                   	cltd   
  80074c:	eb 18                	jmp    800766 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	8d 50 04             	lea    0x4(%eax),%edx
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	89 10                	mov    %edx,(%eax)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	83 e8 04             	sub    $0x4,%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	99                   	cltd   
}
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	56                   	push   %esi
  80076c:	53                   	push   %ebx
  80076d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800770:	eb 17                	jmp    800789 <vprintfmt+0x21>
			if (ch == '\0')
  800772:	85 db                	test   %ebx,%ebx
  800774:	0f 84 af 03 00 00    	je     800b29 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 0c             	pushl  0xc(%ebp)
  800780:	53                   	push   %ebx
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	ff d0                	call   *%eax
  800786:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800789:	8b 45 10             	mov    0x10(%ebp),%eax
  80078c:	8d 50 01             	lea    0x1(%eax),%edx
  80078f:	89 55 10             	mov    %edx,0x10(%ebp)
  800792:	8a 00                	mov    (%eax),%al
  800794:	0f b6 d8             	movzbl %al,%ebx
  800797:	83 fb 25             	cmp    $0x25,%ebx
  80079a:	75 d6                	jne    800772 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80079c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007a0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007a7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8d 50 01             	lea    0x1(%eax),%edx
  8007c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c5:	8a 00                	mov    (%eax),%al
  8007c7:	0f b6 d8             	movzbl %al,%ebx
  8007ca:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007cd:	83 f8 55             	cmp    $0x55,%eax
  8007d0:	0f 87 2b 03 00 00    	ja     800b01 <vprintfmt+0x399>
  8007d6:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  8007dd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007df:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007e3:	eb d7                	jmp    8007bc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007e5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e9:	eb d1                	jmp    8007bc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007f5:	89 d0                	mov    %edx,%eax
  8007f7:	c1 e0 02             	shl    $0x2,%eax
  8007fa:	01 d0                	add    %edx,%eax
  8007fc:	01 c0                	add    %eax,%eax
  8007fe:	01 d8                	add    %ebx,%eax
  800800:	83 e8 30             	sub    $0x30,%eax
  800803:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800806:	8b 45 10             	mov    0x10(%ebp),%eax
  800809:	8a 00                	mov    (%eax),%al
  80080b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80080e:	83 fb 2f             	cmp    $0x2f,%ebx
  800811:	7e 3e                	jle    800851 <vprintfmt+0xe9>
  800813:	83 fb 39             	cmp    $0x39,%ebx
  800816:	7f 39                	jg     800851 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800818:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80081b:	eb d5                	jmp    8007f2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 c0 04             	add    $0x4,%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	83 e8 04             	sub    $0x4,%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800831:	eb 1f                	jmp    800852 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800833:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800837:	79 83                	jns    8007bc <vprintfmt+0x54>
				width = 0;
  800839:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800840:	e9 77 ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800845:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80084c:	e9 6b ff ff ff       	jmp    8007bc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800851:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800852:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800856:	0f 89 60 ff ff ff    	jns    8007bc <vprintfmt+0x54>
				width = precision, precision = -1;
  80085c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800862:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800869:	e9 4e ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80086e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800871:	e9 46 ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	50                   	push   %eax
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	ff d0                	call   *%eax
  800893:	83 c4 10             	add    $0x10,%esp
			break;
  800896:	e9 89 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 c0 04             	add    $0x4,%eax
  8008a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	83 e8 04             	sub    $0x4,%eax
  8008aa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ac:	85 db                	test   %ebx,%ebx
  8008ae:	79 02                	jns    8008b2 <vprintfmt+0x14a>
				err = -err;
  8008b0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008b2:	83 fb 64             	cmp    $0x64,%ebx
  8008b5:	7f 0b                	jg     8008c2 <vprintfmt+0x15a>
  8008b7:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  8008be:	85 f6                	test   %esi,%esi
  8008c0:	75 19                	jne    8008db <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008c2:	53                   	push   %ebx
  8008c3:	68 65 25 80 00       	push   $0x802565
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 5e 02 00 00       	call   800b31 <printfmt>
  8008d3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008d6:	e9 49 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008db:	56                   	push   %esi
  8008dc:	68 6e 25 80 00       	push   $0x80256e
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	ff 75 08             	pushl  0x8(%ebp)
  8008e7:	e8 45 02 00 00       	call   800b31 <printfmt>
  8008ec:	83 c4 10             	add    $0x10,%esp
			break;
  8008ef:	e9 30 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 c0 04             	add    $0x4,%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 30                	mov    (%eax),%esi
  800905:	85 f6                	test   %esi,%esi
  800907:	75 05                	jne    80090e <vprintfmt+0x1a6>
				p = "(null)";
  800909:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  80090e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800912:	7e 6d                	jle    800981 <vprintfmt+0x219>
  800914:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800918:	74 67                	je     800981 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	50                   	push   %eax
  800921:	56                   	push   %esi
  800922:	e8 0c 03 00 00       	call   800c33 <strnlen>
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80092d:	eb 16                	jmp    800945 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80092f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	50                   	push   %eax
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	ff d0                	call   *%eax
  80093f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800942:	ff 4d e4             	decl   -0x1c(%ebp)
  800945:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800949:	7f e4                	jg     80092f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094b:	eb 34                	jmp    800981 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80094d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800951:	74 1c                	je     80096f <vprintfmt+0x207>
  800953:	83 fb 1f             	cmp    $0x1f,%ebx
  800956:	7e 05                	jle    80095d <vprintfmt+0x1f5>
  800958:	83 fb 7e             	cmp    $0x7e,%ebx
  80095b:	7e 12                	jle    80096f <vprintfmt+0x207>
					putch('?', putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	6a 3f                	push   $0x3f
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	ff d0                	call   *%eax
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	eb 0f                	jmp    80097e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80097e:	ff 4d e4             	decl   -0x1c(%ebp)
  800981:	89 f0                	mov    %esi,%eax
  800983:	8d 70 01             	lea    0x1(%eax),%esi
  800986:	8a 00                	mov    (%eax),%al
  800988:	0f be d8             	movsbl %al,%ebx
  80098b:	85 db                	test   %ebx,%ebx
  80098d:	74 24                	je     8009b3 <vprintfmt+0x24b>
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	78 b8                	js     80094d <vprintfmt+0x1e5>
  800995:	ff 4d e0             	decl   -0x20(%ebp)
  800998:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80099c:	79 af                	jns    80094d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80099e:	eb 13                	jmp    8009b3 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	6a 20                	push   $0x20
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b7:	7f e7                	jg     8009a0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b9:	e9 66 01 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c7:	50                   	push   %eax
  8009c8:	e8 3c fd ff ff       	call   800709 <getint>
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009dc:	85 d2                	test   %edx,%edx
  8009de:	79 23                	jns    800a03 <vprintfmt+0x29b>
				putch('-', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 2d                	push   $0x2d
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f6:	f7 d8                	neg    %eax
  8009f8:	83 d2 00             	adc    $0x0,%edx
  8009fb:	f7 da                	neg    %edx
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 bc 00 00 00       	jmp    800acb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 e8             	pushl  -0x18(%ebp)
  800a15:	8d 45 14             	lea    0x14(%ebp),%eax
  800a18:	50                   	push   %eax
  800a19:	e8 84 fc ff ff       	call   8006a2 <getuint>
  800a1e:	83 c4 10             	add    $0x10,%esp
  800a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a27:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a2e:	e9 98 00 00 00       	jmp    800acb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	6a 58                	push   $0x58
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 58                	push   $0x58
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 58                	push   $0x58
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 bc 00 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 30                	push   $0x30
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	6a 78                	push   $0x78
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	ff d0                	call   *%eax
  800a85:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 c0 04             	add    $0x4,%eax
  800a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	83 e8 04             	sub    $0x4,%eax
  800a97:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aa3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aaa:	eb 1f                	jmp    800acb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	e8 e7 fb ff ff       	call   8006a2 <getuint>
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ac4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800acb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	52                   	push   %edx
  800ad6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 00 fb ff ff       	call   8005eb <printnum>
  800aeb:	83 c4 20             	add    $0x20,%esp
			break;
  800aee:	eb 34                	jmp    800b24 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	53                   	push   %ebx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			break;
  800aff:	eb 23                	jmp    800b24 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	6a 25                	push   $0x25
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b11:	ff 4d 10             	decl   0x10(%ebp)
  800b14:	eb 03                	jmp    800b19 <vprintfmt+0x3b1>
  800b16:	ff 4d 10             	decl   0x10(%ebp)
  800b19:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1c:	48                   	dec    %eax
  800b1d:	8a 00                	mov    (%eax),%al
  800b1f:	3c 25                	cmp    $0x25,%al
  800b21:	75 f3                	jne    800b16 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b23:	90                   	nop
		}
	}
  800b24:	e9 47 fc ff ff       	jmp    800770 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b29:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b2d:	5b                   	pop    %ebx
  800b2e:	5e                   	pop    %esi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b37:	8d 45 10             	lea    0x10(%ebp),%eax
  800b3a:	83 c0 04             	add    $0x4,%eax
  800b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b40:	8b 45 10             	mov    0x10(%ebp),%eax
  800b43:	ff 75 f4             	pushl  -0xc(%ebp)
  800b46:	50                   	push   %eax
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	ff 75 08             	pushl  0x8(%ebp)
  800b4d:	e8 16 fc ff ff       	call   800768 <vprintfmt>
  800b52:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b55:	90                   	nop
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 40 08             	mov    0x8(%eax),%eax
  800b61:	8d 50 01             	lea    0x1(%eax),%edx
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 10                	mov    (%eax),%edx
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	8b 40 04             	mov    0x4(%eax),%eax
  800b75:	39 c2                	cmp    %eax,%edx
  800b77:	73 12                	jae    800b8b <sprintputch+0x33>
		*b->buf++ = ch;
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	8d 48 01             	lea    0x1(%eax),%ecx
  800b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b84:	89 0a                	mov    %ecx,(%edx)
  800b86:	8b 55 08             	mov    0x8(%ebp),%edx
  800b89:	88 10                	mov    %dl,(%eax)
}
  800b8b:	90                   	nop
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	01 d0                	add    %edx,%eax
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800baf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb3:	74 06                	je     800bbb <vsnprintf+0x2d>
  800bb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb9:	7f 07                	jg     800bc2 <vsnprintf+0x34>
		return -E_INVAL;
  800bbb:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc0:	eb 20                	jmp    800be2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bc2:	ff 75 14             	pushl  0x14(%ebp)
  800bc5:	ff 75 10             	pushl  0x10(%ebp)
  800bc8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bcb:	50                   	push   %eax
  800bcc:	68 58 0b 80 00       	push   $0x800b58
  800bd1:	e8 92 fb ff ff       	call   800768 <vprintfmt>
  800bd6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bdc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bea:	8d 45 10             	lea    0x10(%ebp),%eax
  800bed:	83 c0 04             	add    $0x4,%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf6:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf9:	50                   	push   %eax
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 89 ff ff ff       	call   800b8e <vsnprintf>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1d:	eb 06                	jmp    800c25 <strlen+0x15>
		n++;
  800c1f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c22:	ff 45 08             	incl   0x8(%ebp)
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	84 c0                	test   %al,%al
  800c2c:	75 f1                	jne    800c1f <strlen+0xf>
		n++;
	return n;
  800c2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c31:	c9                   	leave  
  800c32:	c3                   	ret    

00800c33 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c40:	eb 09                	jmp    800c4b <strnlen+0x18>
		n++;
  800c42:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c45:	ff 45 08             	incl   0x8(%ebp)
  800c48:	ff 4d 0c             	decl   0xc(%ebp)
  800c4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4f:	74 09                	je     800c5a <strnlen+0x27>
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	84 c0                	test   %al,%al
  800c58:	75 e8                	jne    800c42 <strnlen+0xf>
		n++;
	return n;
  800c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c6b:	90                   	nop
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8d 50 01             	lea    0x1(%eax),%edx
  800c72:	89 55 08             	mov    %edx,0x8(%ebp)
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c7e:	8a 12                	mov    (%edx),%dl
  800c80:	88 10                	mov    %dl,(%eax)
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	84 c0                	test   %al,%al
  800c86:	75 e4                	jne    800c6c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca0:	eb 1f                	jmp    800cc1 <strncpy+0x34>
		*dst++ = *src;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8d 50 01             	lea    0x1(%eax),%edx
  800ca8:	89 55 08             	mov    %edx,0x8(%ebp)
  800cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cae:	8a 12                	mov    (%edx),%dl
  800cb0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	84 c0                	test   %al,%al
  800cb9:	74 03                	je     800cbe <strncpy+0x31>
			src++;
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cbe:	ff 45 fc             	incl   -0x4(%ebp)
  800cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc7:	72 d9                	jb     800ca2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cde:	74 30                	je     800d10 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ce0:	eb 16                	jmp    800cf8 <strlcpy+0x2a>
			*dst++ = *src++;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8d 50 01             	lea    0x1(%eax),%edx
  800ce8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf4:	8a 12                	mov    (%edx),%dl
  800cf6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf8:	ff 4d 10             	decl   0x10(%ebp)
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	74 09                	je     800d0a <strlcpy+0x3c>
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	84 c0                	test   %al,%al
  800d08:	75 d8                	jne    800ce2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d16:	29 c2                	sub    %eax,%edx
  800d18:	89 d0                	mov    %edx,%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d1f:	eb 06                	jmp    800d27 <strcmp+0xb>
		p++, q++;
  800d21:	ff 45 08             	incl   0x8(%ebp)
  800d24:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	84 c0                	test   %al,%al
  800d2e:	74 0e                	je     800d3e <strcmp+0x22>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 10                	mov    (%eax),%dl
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	38 c2                	cmp    %al,%dl
  800d3c:	74 e3                	je     800d21 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	0f b6 d0             	movzbl %al,%edx
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	0f b6 c0             	movzbl %al,%eax
  800d4e:	29 c2                	sub    %eax,%edx
  800d50:	89 d0                	mov    %edx,%eax
}
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d57:	eb 09                	jmp    800d62 <strncmp+0xe>
		n--, p++, q++;
  800d59:	ff 4d 10             	decl   0x10(%ebp)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	74 17                	je     800d7f <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 0e                	je     800d7f <strncmp+0x2b>
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	38 c2                	cmp    %al,%dl
  800d7d:	74 da                	je     800d59 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d83:	75 07                	jne    800d8c <strncmp+0x38>
		return 0;
  800d85:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8a:	eb 14                	jmp    800da0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d0             	movzbl %al,%edx
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	0f b6 c0             	movzbl %al,%eax
  800d9c:	29 c2                	sub    %eax,%edx
  800d9e:	89 d0                	mov    %edx,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 04             	sub    $0x4,%esp
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dae:	eb 12                	jmp    800dc2 <strchr+0x20>
		if (*s == c)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db8:	75 05                	jne    800dbf <strchr+0x1d>
			return (char *) s;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	eb 11                	jmp    800dd0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	84 c0                	test   %al,%al
  800dc9:	75 e5                	jne    800db0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 04             	sub    $0x4,%esp
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dde:	eb 0d                	jmp    800ded <strfind+0x1b>
		if (*s == c)
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de8:	74 0e                	je     800df8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dea:	ff 45 08             	incl   0x8(%ebp)
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	84 c0                	test   %al,%al
  800df4:	75 ea                	jne    800de0 <strfind+0xe>
  800df6:	eb 01                	jmp    800df9 <strfind+0x27>
		if (*s == c)
			break;
  800df8:	90                   	nop
	return (char *) s;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e10:	eb 0e                	jmp    800e20 <memset+0x22>
		*p++ = c;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e15:	8d 50 01             	lea    0x1(%eax),%edx
  800e18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e27:	79 e9                	jns    800e12 <memset+0x14>
		*p++ = c;

	return v;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e40:	eb 16                	jmp    800e58 <memcpy+0x2a>
		*d++ = *s++;
  800e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e45:	8d 50 01             	lea    0x1(%eax),%edx
  800e48:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e51:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e54:	8a 12                	mov    (%edx),%dl
  800e56:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	75 dd                	jne    800e42 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e82:	73 50                	jae    800ed4 <memmove+0x6a>
  800e84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	01 d0                	add    %edx,%eax
  800e8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e8f:	76 43                	jbe    800ed4 <memmove+0x6a>
		s += n;
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e9d:	eb 10                	jmp    800eaf <memmove+0x45>
			*--d = *--s;
  800e9f:	ff 4d f8             	decl   -0x8(%ebp)
  800ea2:	ff 4d fc             	decl   -0x4(%ebp)
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 10                	mov    (%eax),%dl
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ead:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	75 e3                	jne    800e9f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ebc:	eb 23                	jmp    800ee1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec1:	8d 50 01             	lea    0x1(%eax),%edx
  800ec4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ecd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ed0:	8a 12                	mov    (%edx),%dl
  800ed2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eda:	89 55 10             	mov    %edx,0x10(%ebp)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 dd                	jne    800ebe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ef8:	eb 2a                	jmp    800f24 <memcmp+0x3e>
		if (*s1 != *s2)
  800efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efd:	8a 10                	mov    (%eax),%dl
  800eff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	38 c2                	cmp    %al,%dl
  800f06:	74 16                	je     800f1e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	0f b6 d0             	movzbl %al,%edx
  800f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f b6 c0             	movzbl %al,%eax
  800f18:	29 c2                	sub    %eax,%edx
  800f1a:	89 d0                	mov    %edx,%eax
  800f1c:	eb 18                	jmp    800f36 <memcmp+0x50>
		s1++, s2++;
  800f1e:	ff 45 fc             	incl   -0x4(%ebp)
  800f21:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	75 c9                	jne    800efa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 d0                	add    %edx,%eax
  800f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f49:	eb 15                	jmp    800f60 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	0f b6 c0             	movzbl %al,%eax
  800f59:	39 c2                	cmp    %eax,%edx
  800f5b:	74 0d                	je     800f6a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f5d:	ff 45 08             	incl   0x8(%ebp)
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f66:	72 e3                	jb     800f4b <memfind+0x13>
  800f68:	eb 01                	jmp    800f6b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f6a:	90                   	nop
	return (void *) s;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6e:	c9                   	leave  
  800f6f:	c3                   	ret    

00800f70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f84:	eb 03                	jmp    800f89 <strtol+0x19>
		s++;
  800f86:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 20                	cmp    $0x20,%al
  800f90:	74 f4                	je     800f86 <strtol+0x16>
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 09                	cmp    $0x9,%al
  800f99:	74 eb                	je     800f86 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	3c 2b                	cmp    $0x2b,%al
  800fa2:	75 05                	jne    800fa9 <strtol+0x39>
		s++;
  800fa4:	ff 45 08             	incl   0x8(%ebp)
  800fa7:	eb 13                	jmp    800fbc <strtol+0x4c>
	else if (*s == '-')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 2d                	cmp    $0x2d,%al
  800fb0:	75 0a                	jne    800fbc <strtol+0x4c>
		s++, neg = 1;
  800fb2:	ff 45 08             	incl   0x8(%ebp)
  800fb5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc0:	74 06                	je     800fc8 <strtol+0x58>
  800fc2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fc6:	75 20                	jne    800fe8 <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 30                	cmp    $0x30,%al
  800fcf:	75 17                	jne    800fe8 <strtol+0x78>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	40                   	inc    %eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 78                	cmp    $0x78,%al
  800fd9:	75 0d                	jne    800fe8 <strtol+0x78>
		s += 2, base = 16;
  800fdb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fdf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fe6:	eb 28                	jmp    801010 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fe8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fec:	75 15                	jne    801003 <strtol+0x93>
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 30                	cmp    $0x30,%al
  800ff5:	75 0c                	jne    801003 <strtol+0x93>
		s++, base = 8;
  800ff7:	ff 45 08             	incl   0x8(%ebp)
  800ffa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801001:	eb 0d                	jmp    801010 <strtol+0xa0>
	else if (base == 0)
  801003:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801007:	75 07                	jne    801010 <strtol+0xa0>
		base = 10;
  801009:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 2f                	cmp    $0x2f,%al
  801017:	7e 19                	jle    801032 <strtol+0xc2>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 39                	cmp    $0x39,%al
  801020:	7f 10                	jg     801032 <strtol+0xc2>
			dig = *s - '0';
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f be c0             	movsbl %al,%eax
  80102a:	83 e8 30             	sub    $0x30,%eax
  80102d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801030:	eb 42                	jmp    801074 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 60                	cmp    $0x60,%al
  801039:	7e 19                	jle    801054 <strtol+0xe4>
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	3c 7a                	cmp    $0x7a,%al
  801042:	7f 10                	jg     801054 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	0f be c0             	movsbl %al,%eax
  80104c:	83 e8 57             	sub    $0x57,%eax
  80104f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801052:	eb 20                	jmp    801074 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 40                	cmp    $0x40,%al
  80105b:	7e 39                	jle    801096 <strtol+0x126>
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3c 5a                	cmp    $0x5a,%al
  801064:	7f 30                	jg     801096 <strtol+0x126>
			dig = *s - 'A' + 10;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	0f be c0             	movsbl %al,%eax
  80106e:	83 e8 37             	sub    $0x37,%eax
  801071:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801077:	3b 45 10             	cmp    0x10(%ebp),%eax
  80107a:	7d 19                	jge    801095 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80107c:	ff 45 08             	incl   0x8(%ebp)
  80107f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801082:	0f af 45 10          	imul   0x10(%ebp),%eax
  801086:	89 c2                	mov    %eax,%edx
  801088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801090:	e9 7b ff ff ff       	jmp    801010 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801095:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801096:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109a:	74 08                	je     8010a4 <strtol+0x134>
		*endptr = (char *) s;
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010a8:	74 07                	je     8010b1 <strtol+0x141>
  8010aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ad:	f7 d8                	neg    %eax
  8010af:	eb 03                	jmp    8010b4 <strtol+0x144>
  8010b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <ltostr>:

void
ltostr(long value, char *str)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ce:	79 13                	jns    8010e3 <ltostr+0x2d>
	{
		neg = 1;
  8010d0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010dd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010eb:	99                   	cltd   
  8010ec:	f7 f9                	idiv   %ecx
  8010ee:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8d 50 01             	lea    0x1(%eax),%edx
  8010f7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801104:	83 c2 30             	add    $0x30,%edx
  801107:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801109:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801111:	f7 e9                	imul   %ecx
  801113:	c1 fa 02             	sar    $0x2,%edx
  801116:	89 c8                	mov    %ecx,%eax
  801118:	c1 f8 1f             	sar    $0x1f,%eax
  80111b:	29 c2                	sub    %eax,%edx
  80111d:	89 d0                	mov    %edx,%eax
  80111f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801125:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80112a:	f7 e9                	imul   %ecx
  80112c:	c1 fa 02             	sar    $0x2,%edx
  80112f:	89 c8                	mov    %ecx,%eax
  801131:	c1 f8 1f             	sar    $0x1f,%eax
  801134:	29 c2                	sub    %eax,%edx
  801136:	89 d0                	mov    %edx,%eax
  801138:	c1 e0 02             	shl    $0x2,%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	01 c0                	add    %eax,%eax
  80113f:	29 c1                	sub    %eax,%ecx
  801141:	89 ca                	mov    %ecx,%edx
  801143:	85 d2                	test   %edx,%edx
  801145:	75 9c                	jne    8010e3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801147:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	48                   	dec    %eax
  801152:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801155:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801159:	74 3d                	je     801198 <ltostr+0xe2>
		start = 1 ;
  80115b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801162:	eb 34                	jmp    801198 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	01 d0                	add    %edx,%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	01 c2                	add    %eax,%edx
  801179:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c8                	add    %ecx,%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801185:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801190:	88 02                	mov    %al,(%edx)
		start++ ;
  801192:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801195:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80119e:	7c c4                	jl     801164 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ab:	90                   	nop
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011b4:	ff 75 08             	pushl  0x8(%ebp)
  8011b7:	e8 54 fa ff ff       	call   800c10 <strlen>
  8011bc:	83 c4 04             	add    $0x4,%esp
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011c2:	ff 75 0c             	pushl  0xc(%ebp)
  8011c5:	e8 46 fa ff ff       	call   800c10 <strlen>
  8011ca:	83 c4 04             	add    $0x4,%esp
  8011cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011de:	eb 17                	jmp    8011f7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	01 c8                	add    %ecx,%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011f4:	ff 45 fc             	incl   -0x4(%ebp)
  8011f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011fd:	7c e1                	jl     8011e0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80120d:	eb 1f                	jmp    80122e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801212:	8d 50 01             	lea    0x1(%eax),%edx
  801215:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801218:	89 c2                	mov    %eax,%edx
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	01 c2                	add    %eax,%edx
  80121f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	01 c8                	add    %ecx,%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80122b:	ff 45 f8             	incl   -0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801234:	7c d9                	jl     80120f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801236:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801239:	8b 45 10             	mov    0x10(%ebp),%eax
  80123c:	01 d0                	add    %edx,%eax
  80123e:	c6 00 00             	movb   $0x0,(%eax)
}
  801241:	90                   	nop
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801250:	8b 45 14             	mov    0x14(%ebp),%eax
  801253:	8b 00                	mov    (%eax),%eax
  801255:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125c:	8b 45 10             	mov    0x10(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801267:	eb 0c                	jmp    801275 <strsplit+0x31>
			*string++ = 0;
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8d 50 01             	lea    0x1(%eax),%edx
  80126f:	89 55 08             	mov    %edx,0x8(%ebp)
  801272:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	84 c0                	test   %al,%al
  80127c:	74 18                	je     801296 <strsplit+0x52>
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	50                   	push   %eax
  801287:	ff 75 0c             	pushl  0xc(%ebp)
  80128a:	e8 13 fb ff ff       	call   800da2 <strchr>
  80128f:	83 c4 08             	add    $0x8,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	75 d3                	jne    801269 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	74 5a                	je     8012f9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	83 f8 0f             	cmp    $0xf,%eax
  8012a7:	75 07                	jne    8012b0 <strsplit+0x6c>
		{
			return 0;
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb 66                	jmp    801316 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8012b8:	8b 55 14             	mov    0x14(%ebp),%edx
  8012bb:	89 0a                	mov    %ecx,(%edx)
  8012bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	01 c2                	add    %eax,%edx
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ce:	eb 03                	jmp    8012d3 <strsplit+0x8f>
			string++;
  8012d0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	84 c0                	test   %al,%al
  8012da:	74 8b                	je     801267 <strsplit+0x23>
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f be c0             	movsbl %al,%eax
  8012e4:	50                   	push   %eax
  8012e5:	ff 75 0c             	pushl  0xc(%ebp)
  8012e8:	e8 b5 fa ff ff       	call   800da2 <strchr>
  8012ed:	83 c4 08             	add    $0x8,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	74 dc                	je     8012d0 <strsplit+0x8c>
			string++;
	}
  8012f4:	e9 6e ff ff ff       	jmp    801267 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801311:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <malloc>:
int sizeofarray=0;
uint32 addresses[1000];
int changed[1000];
int numOfPages[1000];
void* malloc(uint32 size)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
		// Write your code here, remove the panic and write your code
		int num = size /PAGE_SIZE;
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	c1 e8 0c             	shr    $0xc,%eax
  801324:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 return_addres;

		if(size%PAGE_SIZE!=0)
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80132f:	85 c0                	test   %eax,%eax
  801331:	74 03                	je     801336 <malloc+0x1e>
			num++;
  801333:	ff 45 f4             	incl   -0xc(%ebp)
		if(last_addres==USER_HEAP_START)
  801336:	a1 04 30 80 00       	mov    0x803004,%eax
  80133b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  801340:	75 73                	jne    8013b5 <malloc+0x9d>
		{
			sys_allocateMem(USER_HEAP_START,size);
  801342:	83 ec 08             	sub    $0x8,%esp
  801345:	ff 75 08             	pushl  0x8(%ebp)
  801348:	68 00 00 00 80       	push   $0x80000000
  80134d:	e8 80 04 00 00       	call   8017d2 <sys_allocateMem>
  801352:	83 c4 10             	add    $0x10,%esp
			return_addres=last_addres;
  801355:	a1 04 30 80 00       	mov    0x803004,%eax
  80135a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			last_addres+=num*PAGE_SIZE;
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	c1 e0 0c             	shl    $0xc,%eax
  801363:	89 c2                	mov    %eax,%edx
  801365:	a1 04 30 80 00       	mov    0x803004,%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	a3 04 30 80 00       	mov    %eax,0x803004
			numOfPages[sizeofarray]=num;
  801371:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801379:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
			addresses[sizeofarray]=last_addres;
  801380:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801385:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80138b:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
			changed[sizeofarray]=1;
  801392:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801397:	c7 04 85 c0 40 80 00 	movl   $0x1,0x8040c0(,%eax,4)
  80139e:	01 00 00 00 
			sizeofarray++;
  8013a2:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8013a7:	40                   	inc    %eax
  8013a8:	a3 2c 30 80 00       	mov    %eax,0x80302c
			return (void*)return_addres;
  8013ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013b0:	e9 71 01 00 00       	jmp    801526 <malloc+0x20e>
		}
		else
		{
			if(changes==0)
  8013b5:	a1 28 30 80 00       	mov    0x803028,%eax
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	75 71                	jne    80142f <malloc+0x117>
			{
				sys_allocateMem(last_addres,size);
  8013be:	a1 04 30 80 00       	mov    0x803004,%eax
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	ff 75 08             	pushl  0x8(%ebp)
  8013c9:	50                   	push   %eax
  8013ca:	e8 03 04 00 00       	call   8017d2 <sys_allocateMem>
  8013cf:	83 c4 10             	add    $0x10,%esp
				return_addres=last_addres;
  8013d2:	a1 04 30 80 00       	mov    0x803004,%eax
  8013d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				last_addres+=num*PAGE_SIZE;
  8013da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dd:	c1 e0 0c             	shl    $0xc,%eax
  8013e0:	89 c2                	mov    %eax,%edx
  8013e2:	a1 04 30 80 00       	mov    0x803004,%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	a3 04 30 80 00       	mov    %eax,0x803004
				numOfPages[sizeofarray]=num;
  8013ee:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8013f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f6:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
				addresses[sizeofarray]=return_addres;
  8013fd:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801402:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801405:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
				changed[sizeofarray]=1;
  80140c:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801411:	c7 04 85 c0 40 80 00 	movl   $0x1,0x8040c0(,%eax,4)
  801418:	01 00 00 00 
				sizeofarray++;
  80141c:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801421:	40                   	inc    %eax
  801422:	a3 2c 30 80 00       	mov    %eax,0x80302c
				return (void*)return_addres;
  801427:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80142a:	e9 f7 00 00 00       	jmp    801526 <malloc+0x20e>
			}
			else{
				int count=0;
  80142f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				int min=1000;
  801436:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
				int index=-1;
  80143d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801444:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  80144b:	eb 7c                	jmp    8014c9 <malloc+0x1b1>
				{
					uint32 *pg=NULL;
  80144d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					for(int j=0;j<sizeofarray;j++)
  801454:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80145b:	eb 1a                	jmp    801477 <malloc+0x15f>
					{
						if(addresses[j]==i)
  80145d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801460:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  801467:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80146a:	75 08                	jne    801474 <malloc+0x15c>
						{
							index=j;
  80146c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146f:	89 45 e8             	mov    %eax,-0x18(%ebp)
							break;
  801472:	eb 0d                	jmp    801481 <malloc+0x169>
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
				{
					uint32 *pg=NULL;
					for(int j=0;j<sizeofarray;j++)
  801474:	ff 45 dc             	incl   -0x24(%ebp)
  801477:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80147c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  80147f:	7c dc                	jl     80145d <malloc+0x145>
							index=j;
							break;
						}
					}

					if(index==-1)
  801481:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801485:	75 05                	jne    80148c <malloc+0x174>
					{
						count++;
  801487:	ff 45 f0             	incl   -0x10(%ebp)
  80148a:	eb 36                	jmp    8014c2 <malloc+0x1aa>
					}
					else
					{
						if(changed[index]==0)
  80148c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148f:	8b 04 85 c0 40 80 00 	mov    0x8040c0(,%eax,4),%eax
  801496:	85 c0                	test   %eax,%eax
  801498:	75 05                	jne    80149f <malloc+0x187>
						{
							count++;
  80149a:	ff 45 f0             	incl   -0x10(%ebp)
  80149d:	eb 23                	jmp    8014c2 <malloc+0x1aa>
						}
						else
						{
							if(count<min&&count>=num)
  80149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8014a5:	7d 14                	jge    8014bb <malloc+0x1a3>
  8014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ad:	7c 0c                	jl     8014bb <malloc+0x1a3>
							{
								min=count;
  8014af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
								min_addresss=i;
  8014b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
							}
							count=0;
  8014bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			else{
				int count=0;
				int min=1000;
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  8014c2:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8014c9:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8014d0:	0f 86 77 ff ff ff    	jbe    80144d <malloc+0x135>

					}

					}

				sys_allocateMem(min_addresss,size);
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	ff 75 08             	pushl  0x8(%ebp)
  8014dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014df:	e8 ee 02 00 00       	call   8017d2 <sys_allocateMem>
  8014e4:	83 c4 10             	add    $0x10,%esp
				numOfPages[sizeofarray]=num;
  8014e7:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8014ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ef:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
				addresses[sizeofarray]=last_addres;
  8014f6:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8014fb:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801501:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
				changed[sizeofarray]=1;
  801508:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80150d:	c7 04 85 c0 40 80 00 	movl   $0x1,0x8040c0(,%eax,4)
  801514:	01 00 00 00 
				sizeofarray++;
  801518:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80151d:	40                   	inc    %eax
  80151e:	a3 2c 30 80 00       	mov    %eax,0x80302c
				return(void*) min_addresss;
  801523:	8b 45 e4             	mov    -0x1c(%ebp),%eax

		//refer to the project presentation and documentation for details

		return NULL;

}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  80152b:	90                   	nop
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    

0080152e <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 18             	sub    $0x18,%esp
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  80153a:	83 ec 04             	sub    $0x4,%esp
  80153d:	68 d0 26 80 00       	push   $0x8026d0
  801542:	68 8d 00 00 00       	push   $0x8d
  801547:	68 f3 26 80 00       	push   $0x8026f3
  80154c:	e8 9b ed ff ff       	call   8002ec <_panic>

00801551 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	68 d0 26 80 00       	push   $0x8026d0
  80155f:	68 93 00 00 00       	push   $0x93
  801564:	68 f3 26 80 00       	push   $0x8026f3
  801569:	e8 7e ed ff ff       	call   8002ec <_panic>

0080156e <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	68 d0 26 80 00       	push   $0x8026d0
  80157c:	68 99 00 00 00       	push   $0x99
  801581:	68 f3 26 80 00       	push   $0x8026f3
  801586:	e8 61 ed ff ff       	call   8002ec <_panic>

0080158b <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	68 d0 26 80 00       	push   $0x8026d0
  801599:	68 9e 00 00 00       	push   $0x9e
  80159e:	68 f3 26 80 00       	push   $0x8026f3
  8015a3:	e8 44 ed ff ff       	call   8002ec <_panic>

008015a8 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	68 d0 26 80 00       	push   $0x8026d0
  8015b6:	68 a4 00 00 00       	push   $0xa4
  8015bb:	68 f3 26 80 00       	push   $0x8026f3
  8015c0:	e8 27 ed ff ff       	call   8002ec <_panic>

008015c5 <shrink>:
}
void shrink(uint32 newSize)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	68 d0 26 80 00       	push   $0x8026d0
  8015d3:	68 a8 00 00 00       	push   $0xa8
  8015d8:	68 f3 26 80 00       	push   $0x8026f3
  8015dd:	e8 0a ed ff ff       	call   8002ec <_panic>

008015e2 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8015e8:	83 ec 04             	sub    $0x4,%esp
  8015eb:	68 d0 26 80 00       	push   $0x8026d0
  8015f0:	68 ad 00 00 00       	push   $0xad
  8015f5:	68 f3 26 80 00       	push   $0x8026f3
  8015fa:	e8 ed ec ff ff       	call   8002ec <_panic>

008015ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	57                   	push   %edi
  801603:	56                   	push   %esi
  801604:	53                   	push   %ebx
  801605:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801611:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801614:	8b 7d 18             	mov    0x18(%ebp),%edi
  801617:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80161a:	cd 30                	int    $0x30
  80161c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	5b                   	pop    %ebx
  801626:	5e                   	pop    %esi
  801627:	5f                   	pop    %edi
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    

0080162a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	8b 45 10             	mov    0x10(%ebp),%eax
  801633:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801636:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	52                   	push   %edx
  801642:	ff 75 0c             	pushl  0xc(%ebp)
  801645:	50                   	push   %eax
  801646:	6a 00                	push   $0x0
  801648:	e8 b2 ff ff ff       	call   8015ff <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	90                   	nop
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_cgetc>:

int
sys_cgetc(void)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 01                	push   $0x1
  801662:	e8 98 ff ff ff       	call   8015ff <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	50                   	push   %eax
  80167b:	6a 05                	push   $0x5
  80167d:	e8 7d ff ff ff       	call   8015ff <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 02                	push   $0x2
  801696:	e8 64 ff ff ff       	call   8015ff <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 03                	push   $0x3
  8016af:	e8 4b ff ff ff       	call   8015ff <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 04                	push   $0x4
  8016c8:	e8 32 ff ff ff       	call   8015ff <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_env_exit>:


void sys_env_exit(void)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 06                	push   $0x6
  8016e1:	e8 19 ff ff ff       	call   8015ff <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	90                   	nop
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	52                   	push   %edx
  8016fc:	50                   	push   %eax
  8016fd:	6a 07                	push   $0x7
  8016ff:	e8 fb fe ff ff       	call   8015ff <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80170e:	8b 75 18             	mov    0x18(%ebp),%esi
  801711:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801714:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	51                   	push   %ecx
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 08                	push   $0x8
  801724:	e8 d6 fe ff ff       	call   8015ff <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172f:	5b                   	pop    %ebx
  801730:	5e                   	pop    %esi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    

00801733 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801736:	8b 55 0c             	mov    0xc(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	6a 09                	push   $0x9
  801746:	e8 b4 fe ff ff       	call   8015ff <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	ff 75 08             	pushl  0x8(%ebp)
  80175f:	6a 0a                	push   $0xa
  801761:	e8 99 fe ff ff       	call   8015ff <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 0b                	push   $0xb
  80177a:	e8 80 fe ff ff       	call   8015ff <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 0c                	push   $0xc
  801793:	e8 67 fe ff ff       	call   8015ff <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 0d                	push   $0xd
  8017ac:	e8 4e fe ff ff       	call   8015ff <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	ff 75 08             	pushl  0x8(%ebp)
  8017c5:	6a 11                	push   $0x11
  8017c7:	e8 33 fe ff ff       	call   8015ff <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
	return;
  8017cf:	90                   	nop
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	ff 75 08             	pushl  0x8(%ebp)
  8017e1:	6a 12                	push   $0x12
  8017e3:	e8 17 fe ff ff       	call   8015ff <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017eb:	90                   	nop
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 0e                	push   $0xe
  8017fd:	e8 fd fd ff ff       	call   8015ff <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	6a 0f                	push   $0xf
  801817:	e8 e3 fd ff ff       	call   8015ff <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 10                	push   $0x10
  801830:	e8 ca fd ff ff       	call   8015ff <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	90                   	nop
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 14                	push   $0x14
  80184a:	e8 b0 fd ff ff       	call   8015ff <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	90                   	nop
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 15                	push   $0x15
  801864:	e8 96 fd ff ff       	call   8015ff <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	90                   	nop
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_cputc>:


void
sys_cputc(const char c)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80187b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	50                   	push   %eax
  801888:	6a 16                	push   $0x16
  80188a:	e8 70 fd ff ff       	call   8015ff <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	90                   	nop
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 17                	push   $0x17
  8018a4:	e8 56 fd ff ff       	call   8015ff <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	90                   	nop
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	50                   	push   %eax
  8018bf:	6a 18                	push   $0x18
  8018c1:	e8 39 fd ff ff       	call   8015ff <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	52                   	push   %edx
  8018db:	50                   	push   %eax
  8018dc:	6a 1b                	push   $0x1b
  8018de:	e8 1c fd ff ff       	call   8015ff <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 19                	push   $0x19
  8018fb:	e8 ff fc ff ff       	call   8015ff <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	50                   	push   %eax
  801917:	6a 1a                	push   $0x1a
  801919:	e8 e1 fc ff ff       	call   8015ff <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	8b 45 10             	mov    0x10(%ebp),%eax
  80192d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801930:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801933:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	6a 00                	push   $0x0
  80193c:	51                   	push   %ecx
  80193d:	52                   	push   %edx
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	50                   	push   %eax
  801942:	6a 1c                	push   $0x1c
  801944:	e8 b6 fc ff ff       	call   8015ff <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801951:	8b 55 0c             	mov    0xc(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	52                   	push   %edx
  80195e:	50                   	push   %eax
  80195f:	6a 1d                	push   $0x1d
  801961:	e8 99 fc ff ff       	call   8015ff <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80196e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801971:	8b 55 0c             	mov    0xc(%ebp),%edx
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	51                   	push   %ecx
  80197c:	52                   	push   %edx
  80197d:	50                   	push   %eax
  80197e:	6a 1e                	push   $0x1e
  801980:	e8 7a fc ff ff       	call   8015ff <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80198d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 1f                	push   $0x1f
  80199d:	e8 5d fc ff ff       	call   8015ff <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 20                	push   $0x20
  8019b6:	e8 44 fc ff ff       	call   8015ff <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 14             	pushl  0x14(%ebp)
  8019cb:	ff 75 10             	pushl  0x10(%ebp)
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	50                   	push   %eax
  8019d2:	6a 21                	push   $0x21
  8019d4:	e8 26 fc ff ff       	call   8015ff <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	50                   	push   %eax
  8019ed:	6a 22                	push   $0x22
  8019ef:	e8 0b fc ff ff       	call   8015ff <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	50                   	push   %eax
  801a09:	6a 23                	push   $0x23
  801a0b:	e8 ef fb ff ff       	call   8015ff <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	90                   	nop
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a1f:	8d 50 04             	lea    0x4(%eax),%edx
  801a22:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	52                   	push   %edx
  801a2c:	50                   	push   %eax
  801a2d:	6a 24                	push   $0x24
  801a2f:	e8 cb fb ff ff       	call   8015ff <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
	return result;
  801a37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a40:	89 01                	mov    %eax,(%ecx)
  801a42:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	c9                   	leave  
  801a49:	c2 04 00             	ret    $0x4

00801a4c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	ff 75 10             	pushl  0x10(%ebp)
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	6a 13                	push   $0x13
  801a5e:	e8 9c fb ff ff       	call   8015ff <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
	return ;
  801a66:	90                   	nop
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 25                	push   $0x25
  801a78:	e8 82 fb ff ff       	call   8015ff <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 04             	sub    $0x4,%esp
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a8e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	50                   	push   %eax
  801a9b:	6a 26                	push   $0x26
  801a9d:	e8 5d fb ff ff       	call   8015ff <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa5:	90                   	nop
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <rsttst>:
void rsttst()
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 28                	push   $0x28
  801ab7:	e8 43 fb ff ff       	call   8015ff <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
	return ;
  801abf:	90                   	nop
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  801acb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ace:	8b 55 18             	mov    0x18(%ebp),%edx
  801ad1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad5:	52                   	push   %edx
  801ad6:	50                   	push   %eax
  801ad7:	ff 75 10             	pushl  0x10(%ebp)
  801ada:	ff 75 0c             	pushl  0xc(%ebp)
  801add:	ff 75 08             	pushl  0x8(%ebp)
  801ae0:	6a 27                	push   $0x27
  801ae2:	e8 18 fb ff ff       	call   8015ff <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aea:	90                   	nop
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <chktst>:
void chktst(uint32 n)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	ff 75 08             	pushl  0x8(%ebp)
  801afb:	6a 29                	push   $0x29
  801afd:	e8 fd fa ff ff       	call   8015ff <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
	return ;
  801b05:	90                   	nop
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <inctst>:

void inctst()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 2a                	push   $0x2a
  801b17:	e8 e3 fa ff ff       	call   8015ff <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1f:	90                   	nop
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <gettst>:
uint32 gettst()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 2b                	push   $0x2b
  801b31:	e8 c9 fa ff ff       	call   8015ff <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 2c                	push   $0x2c
  801b4d:	e8 ad fa ff ff       	call   8015ff <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
  801b55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b58:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b5c:	75 07                	jne    801b65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b63:	eb 05                	jmp    801b6a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 2c                	push   $0x2c
  801b7e:	e8 7c fa ff ff       	call   8015ff <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
  801b86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b89:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b8d:	75 07                	jne    801b96 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b94:	eb 05                	jmp    801b9b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 2c                	push   $0x2c
  801baf:	e8 4b fa ff ff       	call   8015ff <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
  801bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bba:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bbe:	75 07                	jne    801bc7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bc0:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc5:	eb 05                	jmp    801bcc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 2c                	push   $0x2c
  801be0:	e8 1a fa ff ff       	call   8015ff <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
  801be8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801beb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bef:	75 07                	jne    801bf8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bf1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf6:	eb 05                	jmp    801bfd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	ff 75 08             	pushl  0x8(%ebp)
  801c0d:	6a 2d                	push   $0x2d
  801c0f:	e8 eb f9 ff ff       	call   8015ff <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
	return ;
  801c17:	90                   	nop
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c1e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	53                   	push   %ebx
  801c2d:	51                   	push   %ecx
  801c2e:	52                   	push   %edx
  801c2f:	50                   	push   %eax
  801c30:	6a 2e                	push   $0x2e
  801c32:	e8 c8 f9 ff ff       	call   8015ff <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	52                   	push   %edx
  801c4f:	50                   	push   %eax
  801c50:	6a 2f                	push   $0x2f
  801c52:	e8 a8 f9 ff ff       	call   8015ff <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801c62:	8b 55 08             	mov    0x8(%ebp),%edx
  801c65:	89 d0                	mov    %edx,%eax
  801c67:	c1 e0 02             	shl    $0x2,%eax
  801c6a:	01 d0                	add    %edx,%eax
  801c6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c73:	01 d0                	add    %edx,%eax
  801c75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c7c:	01 d0                	add    %edx,%eax
  801c7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c85:	01 d0                	add    %edx,%eax
  801c87:	c1 e0 04             	shl    $0x4,%eax
  801c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801c8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801c94:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	50                   	push   %eax
  801c9b:	e8 76 fd ff ff       	call   801a16 <sys_get_virtual_time>
  801ca0:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801ca3:	eb 41                	jmp    801ce6 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801ca5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	50                   	push   %eax
  801cac:	e8 65 fd ff ff       	call   801a16 <sys_get_virtual_time>
  801cb1:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801cb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cba:	29 c2                	sub    %eax,%edx
  801cbc:	89 d0                	mov    %edx,%eax
  801cbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801cc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc7:	89 d1                	mov    %edx,%ecx
  801cc9:	29 c1                	sub    %eax,%ecx
  801ccb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd1:	39 c2                	cmp    %eax,%edx
  801cd3:	0f 97 c0             	seta   %al
  801cd6:	0f b6 c0             	movzbl %al,%eax
  801cd9:	29 c1                	sub    %eax,%ecx
  801cdb:	89 c8                	mov    %ecx,%eax
  801cdd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801ce0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cec:	72 b7                	jb     801ca5 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801cee:	90                   	nop
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801cf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801cfe:	eb 03                	jmp    801d03 <busy_wait+0x12>
  801d00:	ff 45 fc             	incl   -0x4(%ebp)
  801d03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d06:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d09:	72 f5                	jb     801d00 <busy_wait+0xf>
	return i;
  801d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <__udivdi3>:
  801d10:	55                   	push   %ebp
  801d11:	57                   	push   %edi
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	83 ec 1c             	sub    $0x1c,%esp
  801d17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d27:	89 ca                	mov    %ecx,%edx
  801d29:	89 f8                	mov    %edi,%eax
  801d2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d2f:	85 f6                	test   %esi,%esi
  801d31:	75 2d                	jne    801d60 <__udivdi3+0x50>
  801d33:	39 cf                	cmp    %ecx,%edi
  801d35:	77 65                	ja     801d9c <__udivdi3+0x8c>
  801d37:	89 fd                	mov    %edi,%ebp
  801d39:	85 ff                	test   %edi,%edi
  801d3b:	75 0b                	jne    801d48 <__udivdi3+0x38>
  801d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d42:	31 d2                	xor    %edx,%edx
  801d44:	f7 f7                	div    %edi
  801d46:	89 c5                	mov    %eax,%ebp
  801d48:	31 d2                	xor    %edx,%edx
  801d4a:	89 c8                	mov    %ecx,%eax
  801d4c:	f7 f5                	div    %ebp
  801d4e:	89 c1                	mov    %eax,%ecx
  801d50:	89 d8                	mov    %ebx,%eax
  801d52:	f7 f5                	div    %ebp
  801d54:	89 cf                	mov    %ecx,%edi
  801d56:	89 fa                	mov    %edi,%edx
  801d58:	83 c4 1c             	add    $0x1c,%esp
  801d5b:	5b                   	pop    %ebx
  801d5c:	5e                   	pop    %esi
  801d5d:	5f                   	pop    %edi
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    
  801d60:	39 ce                	cmp    %ecx,%esi
  801d62:	77 28                	ja     801d8c <__udivdi3+0x7c>
  801d64:	0f bd fe             	bsr    %esi,%edi
  801d67:	83 f7 1f             	xor    $0x1f,%edi
  801d6a:	75 40                	jne    801dac <__udivdi3+0x9c>
  801d6c:	39 ce                	cmp    %ecx,%esi
  801d6e:	72 0a                	jb     801d7a <__udivdi3+0x6a>
  801d70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d74:	0f 87 9e 00 00 00    	ja     801e18 <__udivdi3+0x108>
  801d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7f:	89 fa                	mov    %edi,%edx
  801d81:	83 c4 1c             	add    $0x1c,%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5f                   	pop    %edi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    
  801d89:	8d 76 00             	lea    0x0(%esi),%esi
  801d8c:	31 ff                	xor    %edi,%edi
  801d8e:	31 c0                	xor    %eax,%eax
  801d90:	89 fa                	mov    %edi,%edx
  801d92:	83 c4 1c             	add    $0x1c,%esp
  801d95:	5b                   	pop    %ebx
  801d96:	5e                   	pop    %esi
  801d97:	5f                   	pop    %edi
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    
  801d9a:	66 90                	xchg   %ax,%ax
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	f7 f7                	div    %edi
  801da0:	31 ff                	xor    %edi,%edi
  801da2:	89 fa                	mov    %edi,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	bd 20 00 00 00       	mov    $0x20,%ebp
  801db1:	89 eb                	mov    %ebp,%ebx
  801db3:	29 fb                	sub    %edi,%ebx
  801db5:	89 f9                	mov    %edi,%ecx
  801db7:	d3 e6                	shl    %cl,%esi
  801db9:	89 c5                	mov    %eax,%ebp
  801dbb:	88 d9                	mov    %bl,%cl
  801dbd:	d3 ed                	shr    %cl,%ebp
  801dbf:	89 e9                	mov    %ebp,%ecx
  801dc1:	09 f1                	or     %esi,%ecx
  801dc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dc7:	89 f9                	mov    %edi,%ecx
  801dc9:	d3 e0                	shl    %cl,%eax
  801dcb:	89 c5                	mov    %eax,%ebp
  801dcd:	89 d6                	mov    %edx,%esi
  801dcf:	88 d9                	mov    %bl,%cl
  801dd1:	d3 ee                	shr    %cl,%esi
  801dd3:	89 f9                	mov    %edi,%ecx
  801dd5:	d3 e2                	shl    %cl,%edx
  801dd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ddb:	88 d9                	mov    %bl,%cl
  801ddd:	d3 e8                	shr    %cl,%eax
  801ddf:	09 c2                	or     %eax,%edx
  801de1:	89 d0                	mov    %edx,%eax
  801de3:	89 f2                	mov    %esi,%edx
  801de5:	f7 74 24 0c          	divl   0xc(%esp)
  801de9:	89 d6                	mov    %edx,%esi
  801deb:	89 c3                	mov    %eax,%ebx
  801ded:	f7 e5                	mul    %ebp
  801def:	39 d6                	cmp    %edx,%esi
  801df1:	72 19                	jb     801e0c <__udivdi3+0xfc>
  801df3:	74 0b                	je     801e00 <__udivdi3+0xf0>
  801df5:	89 d8                	mov    %ebx,%eax
  801df7:	31 ff                	xor    %edi,%edi
  801df9:	e9 58 ff ff ff       	jmp    801d56 <__udivdi3+0x46>
  801dfe:	66 90                	xchg   %ax,%ax
  801e00:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e04:	89 f9                	mov    %edi,%ecx
  801e06:	d3 e2                	shl    %cl,%edx
  801e08:	39 c2                	cmp    %eax,%edx
  801e0a:	73 e9                	jae    801df5 <__udivdi3+0xe5>
  801e0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e0f:	31 ff                	xor    %edi,%edi
  801e11:	e9 40 ff ff ff       	jmp    801d56 <__udivdi3+0x46>
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	31 c0                	xor    %eax,%eax
  801e1a:	e9 37 ff ff ff       	jmp    801d56 <__udivdi3+0x46>
  801e1f:	90                   	nop

00801e20 <__umoddi3>:
  801e20:	55                   	push   %ebp
  801e21:	57                   	push   %edi
  801e22:	56                   	push   %esi
  801e23:	53                   	push   %ebx
  801e24:	83 ec 1c             	sub    $0x1c,%esp
  801e27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e3f:	89 f3                	mov    %esi,%ebx
  801e41:	89 fa                	mov    %edi,%edx
  801e43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e47:	89 34 24             	mov    %esi,(%esp)
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	75 1a                	jne    801e68 <__umoddi3+0x48>
  801e4e:	39 f7                	cmp    %esi,%edi
  801e50:	0f 86 a2 00 00 00    	jbe    801ef8 <__umoddi3+0xd8>
  801e56:	89 c8                	mov    %ecx,%eax
  801e58:	89 f2                	mov    %esi,%edx
  801e5a:	f7 f7                	div    %edi
  801e5c:	89 d0                	mov    %edx,%eax
  801e5e:	31 d2                	xor    %edx,%edx
  801e60:	83 c4 1c             	add    $0x1c,%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5f                   	pop    %edi
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    
  801e68:	39 f0                	cmp    %esi,%eax
  801e6a:	0f 87 ac 00 00 00    	ja     801f1c <__umoddi3+0xfc>
  801e70:	0f bd e8             	bsr    %eax,%ebp
  801e73:	83 f5 1f             	xor    $0x1f,%ebp
  801e76:	0f 84 ac 00 00 00    	je     801f28 <__umoddi3+0x108>
  801e7c:	bf 20 00 00 00       	mov    $0x20,%edi
  801e81:	29 ef                	sub    %ebp,%edi
  801e83:	89 fe                	mov    %edi,%esi
  801e85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	d3 e0                	shl    %cl,%eax
  801e8d:	89 d7                	mov    %edx,%edi
  801e8f:	89 f1                	mov    %esi,%ecx
  801e91:	d3 ef                	shr    %cl,%edi
  801e93:	09 c7                	or     %eax,%edi
  801e95:	89 e9                	mov    %ebp,%ecx
  801e97:	d3 e2                	shl    %cl,%edx
  801e99:	89 14 24             	mov    %edx,(%esp)
  801e9c:	89 d8                	mov    %ebx,%eax
  801e9e:	d3 e0                	shl    %cl,%eax
  801ea0:	89 c2                	mov    %eax,%edx
  801ea2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ea6:	d3 e0                	shl    %cl,%eax
  801ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eac:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eb0:	89 f1                	mov    %esi,%ecx
  801eb2:	d3 e8                	shr    %cl,%eax
  801eb4:	09 d0                	or     %edx,%eax
  801eb6:	d3 eb                	shr    %cl,%ebx
  801eb8:	89 da                	mov    %ebx,%edx
  801eba:	f7 f7                	div    %edi
  801ebc:	89 d3                	mov    %edx,%ebx
  801ebe:	f7 24 24             	mull   (%esp)
  801ec1:	89 c6                	mov    %eax,%esi
  801ec3:	89 d1                	mov    %edx,%ecx
  801ec5:	39 d3                	cmp    %edx,%ebx
  801ec7:	0f 82 87 00 00 00    	jb     801f54 <__umoddi3+0x134>
  801ecd:	0f 84 91 00 00 00    	je     801f64 <__umoddi3+0x144>
  801ed3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ed7:	29 f2                	sub    %esi,%edx
  801ed9:	19 cb                	sbb    %ecx,%ebx
  801edb:	89 d8                	mov    %ebx,%eax
  801edd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ee1:	d3 e0                	shl    %cl,%eax
  801ee3:	89 e9                	mov    %ebp,%ecx
  801ee5:	d3 ea                	shr    %cl,%edx
  801ee7:	09 d0                	or     %edx,%eax
  801ee9:	89 e9                	mov    %ebp,%ecx
  801eeb:	d3 eb                	shr    %cl,%ebx
  801eed:	89 da                	mov    %ebx,%edx
  801eef:	83 c4 1c             	add    $0x1c,%esp
  801ef2:	5b                   	pop    %ebx
  801ef3:	5e                   	pop    %esi
  801ef4:	5f                   	pop    %edi
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    
  801ef7:	90                   	nop
  801ef8:	89 fd                	mov    %edi,%ebp
  801efa:	85 ff                	test   %edi,%edi
  801efc:	75 0b                	jne    801f09 <__umoddi3+0xe9>
  801efe:	b8 01 00 00 00       	mov    $0x1,%eax
  801f03:	31 d2                	xor    %edx,%edx
  801f05:	f7 f7                	div    %edi
  801f07:	89 c5                	mov    %eax,%ebp
  801f09:	89 f0                	mov    %esi,%eax
  801f0b:	31 d2                	xor    %edx,%edx
  801f0d:	f7 f5                	div    %ebp
  801f0f:	89 c8                	mov    %ecx,%eax
  801f11:	f7 f5                	div    %ebp
  801f13:	89 d0                	mov    %edx,%eax
  801f15:	e9 44 ff ff ff       	jmp    801e5e <__umoddi3+0x3e>
  801f1a:	66 90                	xchg   %ax,%ax
  801f1c:	89 c8                	mov    %ecx,%eax
  801f1e:	89 f2                	mov    %esi,%edx
  801f20:	83 c4 1c             	add    $0x1c,%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5f                   	pop    %edi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    
  801f28:	3b 04 24             	cmp    (%esp),%eax
  801f2b:	72 06                	jb     801f33 <__umoddi3+0x113>
  801f2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f31:	77 0f                	ja     801f42 <__umoddi3+0x122>
  801f33:	89 f2                	mov    %esi,%edx
  801f35:	29 f9                	sub    %edi,%ecx
  801f37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f3b:	89 14 24             	mov    %edx,(%esp)
  801f3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f42:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f46:	8b 14 24             	mov    (%esp),%edx
  801f49:	83 c4 1c             	add    $0x1c,%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5f                   	pop    %edi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    
  801f51:	8d 76 00             	lea    0x0(%esi),%esi
  801f54:	2b 04 24             	sub    (%esp),%eax
  801f57:	19 fa                	sbb    %edi,%edx
  801f59:	89 d1                	mov    %edx,%ecx
  801f5b:	89 c6                	mov    %eax,%esi
  801f5d:	e9 71 ff ff ff       	jmp    801ed3 <__umoddi3+0xb3>
  801f62:	66 90                	xchg   %ax,%ax
  801f64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f68:	72 ea                	jb     801f54 <__umoddi3+0x134>
  801f6a:	89 d9                	mov    %ebx,%ecx
  801f6c:	e9 62 ff ff ff       	jmp    801ed3 <__umoddi3+0xb3>
