
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 75 12 00 00       	call   8012b8 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 60 1d 80 00       	push   $0x801d60
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 0c 11 00 00       	call   801162 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 62 1d 80 00       	push   $0x801d62
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 f6 10 00 00       	call   801162 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 69 1d 80 00       	push   $0x801d69
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 e0 10 00 00       	call   801162 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 77 1d 80 00       	push   $0x801d77
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 45 14 00 00       	call   8014e7 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 64 15 00 00       	call   801615 <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 82 17 00 00       	call   80185b <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 24 15 00 00       	call   801615 <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 42 17 00 00       	call   80185b <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 e5 14 00 00       	call   801615 <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 03 17 00 00       	call   80185b <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 29 11 00 00       	call   80129f <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80018a:	01 c8                	add    %ecx,%eax
  80018c:	01 c0                	add    %eax,%eax
  80018e:	01 d0                	add    %edx,%eax
  800190:	01 c0                	add    %eax,%eax
  800192:	01 d0                	add    %edx,%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	c1 e2 05             	shl    $0x5,%edx
  800199:	29 c2                	sub    %eax,%edx
  80019b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001a2:	89 c2                	mov    %eax,%edx
  8001a4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001aa:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001af:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b4:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001ba:	84 c0                	test   %al,%al
  8001bc:	74 0f                	je     8001cd <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001be:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c3:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001c8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d1:	7e 0a                	jle    8001dd <libmain+0x72>
		binaryname = argv[0];
  8001d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d6:	8b 00                	mov    (%eax),%eax
  8001d8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	ff 75 0c             	pushl  0xc(%ebp)
  8001e3:	ff 75 08             	pushl  0x8(%ebp)
  8001e6:	e8 4d fe ff ff       	call   800038 <_main>
  8001eb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ee:	e8 47 12 00 00       	call   80143a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	68 94 1d 80 00       	push   $0x801d94
  8001fb:	e8 84 01 00 00       	call   800384 <cprintf>
  800200:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800203:	a1 20 30 80 00       	mov    0x803020,%eax
  800208:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80020e:	a1 20 30 80 00       	mov    0x803020,%eax
  800213:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	52                   	push   %edx
  80021d:	50                   	push   %eax
  80021e:	68 bc 1d 80 00       	push   $0x801dbc
  800223:	e8 5c 01 00 00       	call   800384 <cprintf>
  800228:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80022b:	a1 20 30 80 00       	mov    0x803020,%eax
  800230:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800236:	a1 20 30 80 00       	mov    0x803020,%eax
  80023b:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	52                   	push   %edx
  800245:	50                   	push   %eax
  800246:	68 e4 1d 80 00       	push   $0x801de4
  80024b:	e8 34 01 00 00       	call   800384 <cprintf>
  800250:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800253:	a1 20 30 80 00       	mov    0x803020,%eax
  800258:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	50                   	push   %eax
  800262:	68 25 1e 80 00       	push   $0x801e25
  800267:	e8 18 01 00 00       	call   800384 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 94 1d 80 00       	push   $0x801d94
  800277:	e8 08 01 00 00       	call   800384 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80027f:	e8 d0 11 00 00       	call   801454 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800284:	e8 19 00 00 00       	call   8002a2 <exit>
}
  800289:	90                   	nop
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 00                	push   $0x0
  800297:	e8 cf 0f 00 00       	call   80126b <sys_env_destroy>
  80029c:	83 c4 10             	add    $0x10,%esp
}
  80029f:	90                   	nop
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <exit>:

void
exit(void)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002a8:	e8 24 10 00 00       	call   8012d1 <sys_env_exit>
}
  8002ad:	90                   	nop
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b9:	8b 00                	mov    (%eax),%eax
  8002bb:	8d 48 01             	lea    0x1(%eax),%ecx
  8002be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c1:	89 0a                	mov    %ecx,(%edx)
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c6:	88 d1                	mov    %dl,%cl
  8002c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d2:	8b 00                	mov    (%eax),%eax
  8002d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d9:	75 2c                	jne    800307 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002db:	a0 24 30 80 00       	mov    0x803024,%al
  8002e0:	0f b6 c0             	movzbl %al,%eax
  8002e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e6:	8b 12                	mov    (%edx),%edx
  8002e8:	89 d1                	mov    %edx,%ecx
  8002ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ed:	83 c2 08             	add    $0x8,%edx
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	50                   	push   %eax
  8002f4:	51                   	push   %ecx
  8002f5:	52                   	push   %edx
  8002f6:	e8 2e 0f 00 00       	call   801229 <sys_cputs>
  8002fb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	8b 40 04             	mov    0x4(%eax),%eax
  80030d:	8d 50 01             	lea    0x1(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	89 50 04             	mov    %edx,0x4(%eax)
}
  800316:	90                   	nop
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800322:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800329:	00 00 00 
	b.cnt = 0;
  80032c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800333:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800336:	ff 75 0c             	pushl  0xc(%ebp)
  800339:	ff 75 08             	pushl  0x8(%ebp)
  80033c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800342:	50                   	push   %eax
  800343:	68 b0 02 80 00       	push   $0x8002b0
  800348:	e8 11 02 00 00       	call   80055e <vprintfmt>
  80034d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800350:	a0 24 30 80 00       	mov    0x803024,%al
  800355:	0f b6 c0             	movzbl %al,%eax
  800358:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	50                   	push   %eax
  800362:	52                   	push   %edx
  800363:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800369:	83 c0 08             	add    $0x8,%eax
  80036c:	50                   	push   %eax
  80036d:	e8 b7 0e 00 00       	call   801229 <sys_cputs>
  800372:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800375:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80037c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <cprintf>:

int cprintf(const char *fmt, ...) {
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80038a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800391:	8d 45 0c             	lea    0xc(%ebp),%eax
  800394:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a0:	50                   	push   %eax
  8003a1:	e8 73 ff ff ff       	call   800319 <vcprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003af:	c9                   	leave  
  8003b0:	c3                   	ret    

008003b1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003b7:	e8 7e 10 00 00       	call   80143a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	83 ec 08             	sub    $0x8,%esp
  8003c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003cb:	50                   	push   %eax
  8003cc:	e8 48 ff ff ff       	call   800319 <vcprintf>
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003d7:	e8 78 10 00 00       	call   801454 <sys_enable_interrupt>
	return cnt;
  8003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	53                   	push   %ebx
  8003e5:	83 ec 14             	sub    $0x14,%esp
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003ff:	77 55                	ja     800456 <printnum+0x75>
  800401:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800404:	72 05                	jb     80040b <printnum+0x2a>
  800406:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800409:	77 4b                	ja     800456 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80040b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80040e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800411:	8b 45 18             	mov    0x18(%ebp),%eax
  800414:	ba 00 00 00 00       	mov    $0x0,%edx
  800419:	52                   	push   %edx
  80041a:	50                   	push   %eax
  80041b:	ff 75 f4             	pushl  -0xc(%ebp)
  80041e:	ff 75 f0             	pushl  -0x10(%ebp)
  800421:	e8 ba 16 00 00       	call   801ae0 <__udivdi3>
  800426:	83 c4 10             	add    $0x10,%esp
  800429:	83 ec 04             	sub    $0x4,%esp
  80042c:	ff 75 20             	pushl  0x20(%ebp)
  80042f:	53                   	push   %ebx
  800430:	ff 75 18             	pushl  0x18(%ebp)
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	ff 75 0c             	pushl  0xc(%ebp)
  800438:	ff 75 08             	pushl  0x8(%ebp)
  80043b:	e8 a1 ff ff ff       	call   8003e1 <printnum>
  800440:	83 c4 20             	add    $0x20,%esp
  800443:	eb 1a                	jmp    80045f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	ff 75 0c             	pushl  0xc(%ebp)
  80044b:	ff 75 20             	pushl  0x20(%ebp)
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800456:	ff 4d 1c             	decl   0x1c(%ebp)
  800459:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80045d:	7f e6                	jg     800445 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800462:	bb 00 00 00 00       	mov    $0x0,%ebx
  800467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80046d:	53                   	push   %ebx
  80046e:	51                   	push   %ecx
  80046f:	52                   	push   %edx
  800470:	50                   	push   %eax
  800471:	e8 7a 17 00 00       	call   801bf0 <__umoddi3>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	05 54 20 80 00       	add    $0x802054,%eax
  80047e:	8a 00                	mov    (%eax),%al
  800480:	0f be c0             	movsbl %al,%eax
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 0c             	pushl  0xc(%ebp)
  800489:	50                   	push   %eax
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	ff d0                	call   *%eax
  80048f:	83 c4 10             	add    $0x10,%esp
}
  800492:	90                   	nop
  800493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800496:	c9                   	leave  
  800497:	c3                   	ret    

00800498 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80049b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80049f:	7e 1c                	jle    8004bd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	8d 50 08             	lea    0x8(%eax),%edx
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	89 10                	mov    %edx,(%eax)
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	83 e8 08             	sub    $0x8,%eax
  8004b6:	8b 50 04             	mov    0x4(%eax),%edx
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	eb 40                	jmp    8004fd <getuint+0x65>
	else if (lflag)
  8004bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004c1:	74 1e                	je     8004e1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	8d 50 04             	lea    0x4(%eax),%edx
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	89 10                	mov    %edx,(%eax)
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	83 e8 04             	sub    $0x4,%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	ba 00 00 00 00       	mov    $0x0,%edx
  8004df:	eb 1c                	jmp    8004fd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 50 04             	lea    0x4(%eax),%edx
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	89 10                	mov    %edx,(%eax)
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	83 e8 04             	sub    $0x4,%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    

008004ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800502:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800506:	7e 1c                	jle    800524 <getint+0x25>
		return va_arg(*ap, long long);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 08             	lea    0x8(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 08             	sub    $0x8,%eax
  80051d:	8b 50 04             	mov    0x4(%eax),%edx
  800520:	8b 00                	mov    (%eax),%eax
  800522:	eb 38                	jmp    80055c <getint+0x5d>
	else if (lflag)
  800524:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800528:	74 1a                	je     800544 <getint+0x45>
		return va_arg(*ap, long);
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	8d 50 04             	lea    0x4(%eax),%edx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	89 10                	mov    %edx,(%eax)
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	83 e8 04             	sub    $0x4,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	99                   	cltd   
  800542:	eb 18                	jmp    80055c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	8d 50 04             	lea    0x4(%eax),%edx
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	89 10                	mov    %edx,(%eax)
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	83 e8 04             	sub    $0x4,%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	99                   	cltd   
}
  80055c:	5d                   	pop    %ebp
  80055d:	c3                   	ret    

0080055e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	56                   	push   %esi
  800562:	53                   	push   %ebx
  800563:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800566:	eb 17                	jmp    80057f <vprintfmt+0x21>
			if (ch == '\0')
  800568:	85 db                	test   %ebx,%ebx
  80056a:	0f 84 af 03 00 00    	je     80091f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	ff 75 0c             	pushl  0xc(%ebp)
  800576:	53                   	push   %ebx
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	ff d0                	call   *%eax
  80057c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80057f:	8b 45 10             	mov    0x10(%ebp),%eax
  800582:	8d 50 01             	lea    0x1(%eax),%edx
  800585:	89 55 10             	mov    %edx,0x10(%ebp)
  800588:	8a 00                	mov    (%eax),%al
  80058a:	0f b6 d8             	movzbl %al,%ebx
  80058d:	83 fb 25             	cmp    $0x25,%ebx
  800590:	75 d6                	jne    800568 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800592:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800596:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80059d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b5:	8d 50 01             	lea    0x1(%eax),%edx
  8005b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bb:	8a 00                	mov    (%eax),%al
  8005bd:	0f b6 d8             	movzbl %al,%ebx
  8005c0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005c3:	83 f8 55             	cmp    $0x55,%eax
  8005c6:	0f 87 2b 03 00 00    	ja     8008f7 <vprintfmt+0x399>
  8005cc:	8b 04 85 78 20 80 00 	mov    0x802078(,%eax,4),%eax
  8005d3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005d5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d9:	eb d7                	jmp    8005b2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005db:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005df:	eb d1                	jmp    8005b2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005eb:	89 d0                	mov    %edx,%eax
  8005ed:	c1 e0 02             	shl    $0x2,%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	01 c0                	add    %eax,%eax
  8005f4:	01 d8                	add    %ebx,%eax
  8005f6:	83 e8 30             	sub    $0x30,%eax
  8005f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ff:	8a 00                	mov    (%eax),%al
  800601:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800604:	83 fb 2f             	cmp    $0x2f,%ebx
  800607:	7e 3e                	jle    800647 <vprintfmt+0xe9>
  800609:	83 fb 39             	cmp    $0x39,%ebx
  80060c:	7f 39                	jg     800647 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80060e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800611:	eb d5                	jmp    8005e8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 c0 04             	add    $0x4,%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	83 e8 04             	sub    $0x4,%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800627:	eb 1f                	jmp    800648 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800629:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062d:	79 83                	jns    8005b2 <vprintfmt+0x54>
				width = 0;
  80062f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800636:	e9 77 ff ff ff       	jmp    8005b2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80063b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800642:	e9 6b ff ff ff       	jmp    8005b2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800647:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064c:	0f 89 60 ff ff ff    	jns    8005b2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800655:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800658:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80065f:	e9 4e ff ff ff       	jmp    8005b2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800664:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800667:	e9 46 ff ff ff       	jmp    8005b2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 c0 04             	add    $0x4,%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	83 e8 04             	sub    $0x4,%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	50                   	push   %eax
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	ff d0                	call   *%eax
  800689:	83 c4 10             	add    $0x10,%esp
			break;
  80068c:	e9 89 02 00 00       	jmp    80091a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 c0 04             	add    $0x4,%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	83 e8 04             	sub    $0x4,%eax
  8006a0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006a2:	85 db                	test   %ebx,%ebx
  8006a4:	79 02                	jns    8006a8 <vprintfmt+0x14a>
				err = -err;
  8006a6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a8:	83 fb 64             	cmp    $0x64,%ebx
  8006ab:	7f 0b                	jg     8006b8 <vprintfmt+0x15a>
  8006ad:	8b 34 9d c0 1e 80 00 	mov    0x801ec0(,%ebx,4),%esi
  8006b4:	85 f6                	test   %esi,%esi
  8006b6:	75 19                	jne    8006d1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b8:	53                   	push   %ebx
  8006b9:	68 65 20 80 00       	push   $0x802065
  8006be:	ff 75 0c             	pushl  0xc(%ebp)
  8006c1:	ff 75 08             	pushl  0x8(%ebp)
  8006c4:	e8 5e 02 00 00       	call   800927 <printfmt>
  8006c9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006cc:	e9 49 02 00 00       	jmp    80091a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006d1:	56                   	push   %esi
  8006d2:	68 6e 20 80 00       	push   $0x80206e
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	ff 75 08             	pushl  0x8(%ebp)
  8006dd:	e8 45 02 00 00       	call   800927 <printfmt>
  8006e2:	83 c4 10             	add    $0x10,%esp
			break;
  8006e5:	e9 30 02 00 00       	jmp    80091a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 c0 04             	add    $0x4,%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	83 e8 04             	sub    $0x4,%eax
  8006f9:	8b 30                	mov    (%eax),%esi
  8006fb:	85 f6                	test   %esi,%esi
  8006fd:	75 05                	jne    800704 <vprintfmt+0x1a6>
				p = "(null)";
  8006ff:	be 71 20 80 00       	mov    $0x802071,%esi
			if (width > 0 && padc != '-')
  800704:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800708:	7e 6d                	jle    800777 <vprintfmt+0x219>
  80070a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80070e:	74 67                	je     800777 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800710:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	50                   	push   %eax
  800717:	56                   	push   %esi
  800718:	e8 0c 03 00 00       	call   800a29 <strnlen>
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800723:	eb 16                	jmp    80073b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800725:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	50                   	push   %eax
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073f:	7f e4                	jg     800725 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800741:	eb 34                	jmp    800777 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800743:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800747:	74 1c                	je     800765 <vprintfmt+0x207>
  800749:	83 fb 1f             	cmp    $0x1f,%ebx
  80074c:	7e 05                	jle    800753 <vprintfmt+0x1f5>
  80074e:	83 fb 7e             	cmp    $0x7e,%ebx
  800751:	7e 12                	jle    800765 <vprintfmt+0x207>
					putch('?', putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	6a 3f                	push   $0x3f
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	eb 0f                	jmp    800774 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	53                   	push   %ebx
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800774:	ff 4d e4             	decl   -0x1c(%ebp)
  800777:	89 f0                	mov    %esi,%eax
  800779:	8d 70 01             	lea    0x1(%eax),%esi
  80077c:	8a 00                	mov    (%eax),%al
  80077e:	0f be d8             	movsbl %al,%ebx
  800781:	85 db                	test   %ebx,%ebx
  800783:	74 24                	je     8007a9 <vprintfmt+0x24b>
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	78 b8                	js     800743 <vprintfmt+0x1e5>
  80078b:	ff 4d e0             	decl   -0x20(%ebp)
  80078e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800792:	79 af                	jns    800743 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800794:	eb 13                	jmp    8007a9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	6a 20                	push   $0x20
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	ff d0                	call   *%eax
  8007a3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a6:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ad:	7f e7                	jg     800796 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007af:	e9 66 01 00 00       	jmp    80091a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bd:	50                   	push   %eax
  8007be:	e8 3c fd ff ff       	call   8004ff <getint>
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d2:	85 d2                	test   %edx,%edx
  8007d4:	79 23                	jns    8007f9 <vprintfmt+0x29b>
				putch('-', putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	6a 2d                	push   $0x2d
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	ff d0                	call   *%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ec:	f7 d8                	neg    %eax
  8007ee:	83 d2 00             	adc    $0x0,%edx
  8007f1:	f7 da                	neg    %edx
  8007f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800800:	e9 bc 00 00 00       	jmp    8008c1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 e8             	pushl  -0x18(%ebp)
  80080b:	8d 45 14             	lea    0x14(%ebp),%eax
  80080e:	50                   	push   %eax
  80080f:	e8 84 fc ff ff       	call   800498 <getuint>
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80081d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800824:	e9 98 00 00 00       	jmp    8008c1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 58                	push   $0x58
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	6a 58                	push   $0x58
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	ff d0                	call   *%eax
  800846:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	6a 58                	push   $0x58
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	ff d0                	call   *%eax
  800856:	83 c4 10             	add    $0x10,%esp
			break;
  800859:	e9 bc 00 00 00       	jmp    80091a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	6a 30                	push   $0x30
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	6a 78                	push   $0x78
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80088f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800892:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800899:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008a0:	eb 1f                	jmp    8008c1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ab:	50                   	push   %eax
  8008ac:	e8 e7 fb ff ff       	call   800498 <getuint>
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c8:	83 ec 04             	sub    $0x4,%esp
  8008cb:	52                   	push   %edx
  8008cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	ff 75 08             	pushl  0x8(%ebp)
  8008dc:	e8 00 fb ff ff       	call   8003e1 <printnum>
  8008e1:	83 c4 20             	add    $0x20,%esp
			break;
  8008e4:	eb 34                	jmp    80091a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	ff d0                	call   *%eax
  8008f2:	83 c4 10             	add    $0x10,%esp
			break;
  8008f5:	eb 23                	jmp    80091a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	6a 25                	push   $0x25
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800907:	ff 4d 10             	decl   0x10(%ebp)
  80090a:	eb 03                	jmp    80090f <vprintfmt+0x3b1>
  80090c:	ff 4d 10             	decl   0x10(%ebp)
  80090f:	8b 45 10             	mov    0x10(%ebp),%eax
  800912:	48                   	dec    %eax
  800913:	8a 00                	mov    (%eax),%al
  800915:	3c 25                	cmp    $0x25,%al
  800917:	75 f3                	jne    80090c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800919:	90                   	nop
		}
	}
  80091a:	e9 47 fc ff ff       	jmp    800566 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80091f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800920:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800923:	5b                   	pop    %ebx
  800924:	5e                   	pop    %esi
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80092d:	8d 45 10             	lea    0x10(%ebp),%eax
  800930:	83 c0 04             	add    $0x4,%eax
  800933:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800936:	8b 45 10             	mov    0x10(%ebp),%eax
  800939:	ff 75 f4             	pushl  -0xc(%ebp)
  80093c:	50                   	push   %eax
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	ff 75 08             	pushl  0x8(%ebp)
  800943:	e8 16 fc ff ff       	call   80055e <vprintfmt>
  800948:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80094b:	90                   	nop
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    

0080094e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	8b 40 08             	mov    0x8(%eax),%eax
  800957:	8d 50 01             	lea    0x1(%eax),%edx
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800960:	8b 45 0c             	mov    0xc(%ebp),%eax
  800963:	8b 10                	mov    (%eax),%edx
  800965:	8b 45 0c             	mov    0xc(%ebp),%eax
  800968:	8b 40 04             	mov    0x4(%eax),%eax
  80096b:	39 c2                	cmp    %eax,%edx
  80096d:	73 12                	jae    800981 <sprintputch+0x33>
		*b->buf++ = ch;
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	8d 48 01             	lea    0x1(%eax),%ecx
  800977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097a:	89 0a                	mov    %ecx,(%edx)
  80097c:	8b 55 08             	mov    0x8(%ebp),%edx
  80097f:	88 10                	mov    %dl,(%eax)
}
  800981:	90                   	nop
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8d 50 ff             	lea    -0x1(%eax),%edx
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	01 d0                	add    %edx,%eax
  80099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a9:	74 06                	je     8009b1 <vsnprintf+0x2d>
  8009ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009af:	7f 07                	jg     8009b8 <vsnprintf+0x34>
		return -E_INVAL;
  8009b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8009b6:	eb 20                	jmp    8009d8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b8:	ff 75 14             	pushl  0x14(%ebp)
  8009bb:	ff 75 10             	pushl  0x10(%ebp)
  8009be:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c1:	50                   	push   %eax
  8009c2:	68 4e 09 80 00       	push   $0x80094e
  8009c7:	e8 92 fb ff ff       	call   80055e <vprintfmt>
  8009cc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e0:	8d 45 10             	lea    0x10(%ebp),%eax
  8009e3:	83 c0 04             	add    $0x4,%eax
  8009e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	ff 75 08             	pushl  0x8(%ebp)
  8009f6:	e8 89 ff ff ff       	call   800984 <vsnprintf>
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a13:	eb 06                	jmp    800a1b <strlen+0x15>
		n++;
  800a15:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a18:	ff 45 08             	incl   0x8(%ebp)
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8a 00                	mov    (%eax),%al
  800a20:	84 c0                	test   %al,%al
  800a22:	75 f1                	jne    800a15 <strlen+0xf>
		n++;
	return n;
  800a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a27:	c9                   	leave  
  800a28:	c3                   	ret    

00800a29 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a36:	eb 09                	jmp    800a41 <strnlen+0x18>
		n++;
  800a38:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3b:	ff 45 08             	incl   0x8(%ebp)
  800a3e:	ff 4d 0c             	decl   0xc(%ebp)
  800a41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a45:	74 09                	je     800a50 <strnlen+0x27>
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	84 c0                	test   %al,%al
  800a4e:	75 e8                	jne    800a38 <strnlen+0xf>
		n++;
	return n;
  800a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a61:	90                   	nop
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8d 50 01             	lea    0x1(%eax),%edx
  800a68:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a71:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a74:	8a 12                	mov    (%edx),%dl
  800a76:	88 10                	mov    %dl,(%eax)
  800a78:	8a 00                	mov    (%eax),%al
  800a7a:	84 c0                	test   %al,%al
  800a7c:	75 e4                	jne    800a62 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a96:	eb 1f                	jmp    800ab7 <strncpy+0x34>
		*dst++ = *src;
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8d 50 01             	lea    0x1(%eax),%edx
  800a9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa4:	8a 12                	mov    (%edx),%dl
  800aa6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	8a 00                	mov    (%eax),%al
  800aad:	84 c0                	test   %al,%al
  800aaf:	74 03                	je     800ab4 <strncpy+0x31>
			src++;
  800ab1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab4:	ff 45 fc             	incl   -0x4(%ebp)
  800ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aba:	3b 45 10             	cmp    0x10(%ebp),%eax
  800abd:	72 d9                	jb     800a98 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800abf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad4:	74 30                	je     800b06 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ad6:	eb 16                	jmp    800aee <strlcpy+0x2a>
			*dst++ = *src++;
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8d 50 01             	lea    0x1(%eax),%edx
  800ade:	89 55 08             	mov    %edx,0x8(%ebp)
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ae7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aea:	8a 12                	mov    (%edx),%dl
  800aec:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af5:	74 09                	je     800b00 <strlcpy+0x3c>
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	84 c0                	test   %al,%al
  800afe:	75 d8                	jne    800ad8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b06:	8b 55 08             	mov    0x8(%ebp),%edx
  800b09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b0c:	29 c2                	sub    %eax,%edx
  800b0e:	89 d0                	mov    %edx,%eax
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b15:	eb 06                	jmp    800b1d <strcmp+0xb>
		p++, q++;
  800b17:	ff 45 08             	incl   0x8(%ebp)
  800b1a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	74 0e                	je     800b34 <strcmp+0x22>
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8a 10                	mov    (%eax),%dl
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	38 c2                	cmp    %al,%dl
  800b32:	74 e3                	je     800b17 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 d0             	movzbl %al,%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f b6 c0             	movzbl %al,%eax
  800b44:	29 c2                	sub    %eax,%edx
  800b46:	89 d0                	mov    %edx,%eax
}
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b4d:	eb 09                	jmp    800b58 <strncmp+0xe>
		n--, p++, q++;
  800b4f:	ff 4d 10             	decl   0x10(%ebp)
  800b52:	ff 45 08             	incl   0x8(%ebp)
  800b55:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b5c:	74 17                	je     800b75 <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	84 c0                	test   %al,%al
  800b65:	74 0e                	je     800b75 <strncmp+0x2b>
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8a 10                	mov    (%eax),%dl
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	8a 00                	mov    (%eax),%al
  800b71:	38 c2                	cmp    %al,%dl
  800b73:	74 da                	je     800b4f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b79:	75 07                	jne    800b82 <strncmp+0x38>
		return 0;
  800b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b80:	eb 14                	jmp    800b96 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 d0             	movzbl %al,%edx
  800b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	0f b6 c0             	movzbl %al,%eax
  800b92:	29 c2                	sub    %eax,%edx
  800b94:	89 d0                	mov    %edx,%eax
}
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	83 ec 04             	sub    $0x4,%esp
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba4:	eb 12                	jmp    800bb8 <strchr+0x20>
		if (*s == c)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bae:	75 05                	jne    800bb5 <strchr+0x1d>
			return (char *) s;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	eb 11                	jmp    800bc6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bb5:	ff 45 08             	incl   0x8(%ebp)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	84 c0                	test   %al,%al
  800bbf:	75 e5                	jne    800ba6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 04             	sub    $0x4,%esp
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bd4:	eb 0d                	jmp    800be3 <strfind+0x1b>
		if (*s == c)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bde:	74 0e                	je     800bee <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800be0:	ff 45 08             	incl   0x8(%ebp)
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	84 c0                	test   %al,%al
  800bea:	75 ea                	jne    800bd6 <strfind+0xe>
  800bec:	eb 01                	jmp    800bef <strfind+0x27>
		if (*s == c)
			break;
  800bee:	90                   	nop
	return (char *) s;
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c06:	eb 0e                	jmp    800c16 <memset+0x22>
		*p++ = c;
  800c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c16:	ff 4d f8             	decl   -0x8(%ebp)
  800c19:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c1d:	79 e9                	jns    800c08 <memset+0x14>
		*p++ = c;

	return v;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c36:	eb 16                	jmp    800c4e <memcpy+0x2a>
		*d++ = *s++;
  800c38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3b:	8d 50 01             	lea    0x1(%eax),%edx
  800c3e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c47:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c4a:	8a 12                	mov    (%edx),%dl
  800c4c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c54:	89 55 10             	mov    %edx,0x10(%ebp)
  800c57:	85 c0                	test   %eax,%eax
  800c59:	75 dd                	jne    800c38 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c75:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c78:	73 50                	jae    800cca <memmove+0x6a>
  800c7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	01 d0                	add    %edx,%eax
  800c82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c85:	76 43                	jbe    800cca <memmove+0x6a>
		s += n;
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c90:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c93:	eb 10                	jmp    800ca5 <memmove+0x45>
			*--d = *--s;
  800c95:	ff 4d f8             	decl   -0x8(%ebp)
  800c98:	ff 4d fc             	decl   -0x4(%ebp)
  800c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9e:	8a 10                	mov    (%eax),%dl
  800ca0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ca3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cab:	89 55 10             	mov    %edx,0x10(%ebp)
  800cae:	85 c0                	test   %eax,%eax
  800cb0:	75 e3                	jne    800c95 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cb2:	eb 23                	jmp    800cd7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb7:	8d 50 01             	lea    0x1(%eax),%edx
  800cba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cc6:	8a 12                	mov    (%edx),%dl
  800cc8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	75 dd                	jne    800cb4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cee:	eb 2a                	jmp    800d1a <memcmp+0x3e>
		if (*s1 != *s2)
  800cf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf3:	8a 10                	mov    (%eax),%dl
  800cf5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	38 c2                	cmp    %al,%dl
  800cfc:	74 16                	je     800d14 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 d0             	movzbl %al,%edx
  800d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 c0             	movzbl %al,%eax
  800d0e:	29 c2                	sub    %eax,%edx
  800d10:	89 d0                	mov    %edx,%eax
  800d12:	eb 18                	jmp    800d2c <memcmp+0x50>
		s1++, s2++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
  800d17:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d20:	89 55 10             	mov    %edx,0x10(%ebp)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	75 c9                	jne    800cf0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	01 d0                	add    %edx,%eax
  800d3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d3f:	eb 15                	jmp    800d56 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f b6 d0             	movzbl %al,%edx
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	0f b6 c0             	movzbl %al,%eax
  800d4f:	39 c2                	cmp    %eax,%edx
  800d51:	74 0d                	je     800d60 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d5c:	72 e3                	jb     800d41 <memfind+0x13>
  800d5e:	eb 01                	jmp    800d61 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d60:	90                   	nop
	return (void *) s;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d73:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7a:	eb 03                	jmp    800d7f <strtol+0x19>
		s++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 20                	cmp    $0x20,%al
  800d86:	74 f4                	je     800d7c <strtol+0x16>
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 09                	cmp    $0x9,%al
  800d8f:	74 eb                	je     800d7c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	3c 2b                	cmp    $0x2b,%al
  800d98:	75 05                	jne    800d9f <strtol+0x39>
		s++;
  800d9a:	ff 45 08             	incl   0x8(%ebp)
  800d9d:	eb 13                	jmp    800db2 <strtol+0x4c>
	else if (*s == '-')
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	3c 2d                	cmp    $0x2d,%al
  800da6:	75 0a                	jne    800db2 <strtol+0x4c>
		s++, neg = 1;
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db6:	74 06                	je     800dbe <strtol+0x58>
  800db8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800dbc:	75 20                	jne    800dde <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	3c 30                	cmp    $0x30,%al
  800dc5:	75 17                	jne    800dde <strtol+0x78>
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	40                   	inc    %eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	3c 78                	cmp    $0x78,%al
  800dcf:	75 0d                	jne    800dde <strtol+0x78>
		s += 2, base = 16;
  800dd1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dd5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ddc:	eb 28                	jmp    800e06 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de2:	75 15                	jne    800df9 <strtol+0x93>
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	3c 30                	cmp    $0x30,%al
  800deb:	75 0c                	jne    800df9 <strtol+0x93>
		s++, base = 8;
  800ded:	ff 45 08             	incl   0x8(%ebp)
  800df0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800df7:	eb 0d                	jmp    800e06 <strtol+0xa0>
	else if (base == 0)
  800df9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfd:	75 07                	jne    800e06 <strtol+0xa0>
		base = 10;
  800dff:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 2f                	cmp    $0x2f,%al
  800e0d:	7e 19                	jle    800e28 <strtol+0xc2>
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	3c 39                	cmp    $0x39,%al
  800e16:	7f 10                	jg     800e28 <strtol+0xc2>
			dig = *s - '0';
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	0f be c0             	movsbl %al,%eax
  800e20:	83 e8 30             	sub    $0x30,%eax
  800e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e26:	eb 42                	jmp    800e6a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 60                	cmp    $0x60,%al
  800e2f:	7e 19                	jle    800e4a <strtol+0xe4>
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	3c 7a                	cmp    $0x7a,%al
  800e38:	7f 10                	jg     800e4a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be c0             	movsbl %al,%eax
  800e42:	83 e8 57             	sub    $0x57,%eax
  800e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e48:	eb 20                	jmp    800e6a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 40                	cmp    $0x40,%al
  800e51:	7e 39                	jle    800e8c <strtol+0x126>
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	3c 5a                	cmp    $0x5a,%al
  800e5a:	7f 30                	jg     800e8c <strtol+0x126>
			dig = *s - 'A' + 10;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f be c0             	movsbl %al,%eax
  800e64:	83 e8 37             	sub    $0x37,%eax
  800e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e70:	7d 19                	jge    800e8b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e72:	ff 45 08             	incl   0x8(%ebp)
  800e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e78:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e86:	e9 7b ff ff ff       	jmp    800e06 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e8b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e90:	74 08                	je     800e9a <strtol+0x134>
		*endptr = (char *) s;
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e9e:	74 07                	je     800ea7 <strtol+0x141>
  800ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea3:	f7 d8                	neg    %eax
  800ea5:	eb 03                	jmp    800eaa <strtol+0x144>
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <ltostr>:

void
ltostr(long value, char *str)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ec0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ec4:	79 13                	jns    800ed9 <ltostr+0x2d>
	{
		neg = 1;
  800ec6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ed3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ed6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ee1:	99                   	cltd   
  800ee2:	f7 f9                	idiv   %ecx
  800ee4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ee7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eea:	8d 50 01             	lea    0x1(%eax),%edx
  800eed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef0:	89 c2                	mov    %eax,%edx
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800efa:	83 c2 30             	add    $0x30,%edx
  800efd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800eff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f02:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f07:	f7 e9                	imul   %ecx
  800f09:	c1 fa 02             	sar    $0x2,%edx
  800f0c:	89 c8                	mov    %ecx,%eax
  800f0e:	c1 f8 1f             	sar    $0x1f,%eax
  800f11:	29 c2                	sub    %eax,%edx
  800f13:	89 d0                	mov    %edx,%eax
  800f15:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f1b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f20:	f7 e9                	imul   %ecx
  800f22:	c1 fa 02             	sar    $0x2,%edx
  800f25:	89 c8                	mov    %ecx,%eax
  800f27:	c1 f8 1f             	sar    $0x1f,%eax
  800f2a:	29 c2                	sub    %eax,%edx
  800f2c:	89 d0                	mov    %edx,%eax
  800f2e:	c1 e0 02             	shl    $0x2,%eax
  800f31:	01 d0                	add    %edx,%eax
  800f33:	01 c0                	add    %eax,%eax
  800f35:	29 c1                	sub    %eax,%ecx
  800f37:	89 ca                	mov    %ecx,%edx
  800f39:	85 d2                	test   %edx,%edx
  800f3b:	75 9c                	jne    800ed9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f47:	48                   	dec    %eax
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f4f:	74 3d                	je     800f8e <ltostr+0xe2>
		start = 1 ;
  800f51:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f58:	eb 34                	jmp    800f8e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c2                	add    %eax,%edx
  800f6f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	01 c8                	add    %ecx,%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	01 c2                	add    %eax,%edx
  800f83:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f86:	88 02                	mov    %al,(%edx)
		start++ ;
  800f88:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f8b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f91:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f94:	7c c4                	jl     800f5a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f96:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	01 d0                	add    %edx,%eax
  800f9e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 54 fa ff ff       	call   800a06 <strlen>
  800fb2:	83 c4 04             	add    $0x4,%esp
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	e8 46 fa ff ff       	call   800a06 <strlen>
  800fc0:	83 c4 04             	add    $0x4,%esp
  800fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fd4:	eb 17                	jmp    800fed <strcconcat+0x49>
		final[s] = str1[s] ;
  800fd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	01 c2                	add    %eax,%edx
  800fde:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	01 c8                	add    %ecx,%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fea:	ff 45 fc             	incl   -0x4(%ebp)
  800fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff3:	7c e1                	jl     800fd6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ff5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ffc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801003:	eb 1f                	jmp    801024 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801005:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801008:	8d 50 01             	lea    0x1(%eax),%edx
  80100b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80100e:	89 c2                	mov    %eax,%edx
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	01 c2                	add    %eax,%edx
  801015:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	01 c8                	add    %ecx,%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801021:	ff 45 f8             	incl   -0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80102a:	7c d9                	jl     801005 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	01 d0                	add    %edx,%eax
  801034:	c6 00 00             	movb   $0x0,(%eax)
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	8b 00                	mov    (%eax),%eax
  80104b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80105d:	eb 0c                	jmp    80106b <strsplit+0x31>
			*string++ = 0;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8d 50 01             	lea    0x1(%eax),%edx
  801065:	89 55 08             	mov    %edx,0x8(%ebp)
  801068:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	84 c0                	test   %al,%al
  801072:	74 18                	je     80108c <strsplit+0x52>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f be c0             	movsbl %al,%eax
  80107c:	50                   	push   %eax
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	e8 13 fb ff ff       	call   800b98 <strchr>
  801085:	83 c4 08             	add    $0x8,%esp
  801088:	85 c0                	test   %eax,%eax
  80108a:	75 d3                	jne    80105f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	84 c0                	test   %al,%al
  801093:	74 5a                	je     8010ef <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801095:	8b 45 14             	mov    0x14(%ebp),%eax
  801098:	8b 00                	mov    (%eax),%eax
  80109a:	83 f8 0f             	cmp    $0xf,%eax
  80109d:	75 07                	jne    8010a6 <strsplit+0x6c>
		{
			return 0;
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a4:	eb 66                	jmp    80110c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a9:	8b 00                	mov    (%eax),%eax
  8010ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8010ae:	8b 55 14             	mov    0x14(%ebp),%edx
  8010b1:	89 0a                	mov    %ecx,(%edx)
  8010b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bd:	01 c2                	add    %eax,%edx
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c4:	eb 03                	jmp    8010c9 <strsplit+0x8f>
			string++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	84 c0                	test   %al,%al
  8010d0:	74 8b                	je     80105d <strsplit+0x23>
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f be c0             	movsbl %al,%eax
  8010da:	50                   	push   %eax
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	e8 b5 fa ff ff       	call   800b98 <strchr>
  8010e3:	83 c4 08             	add    $0x8,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	74 dc                	je     8010c6 <strsplit+0x8c>
			string++;
	}
  8010ea:	e9 6e ff ff ff       	jmp    80105d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010ef:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f3:	8b 00                	mov    (%eax),%eax
  8010f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801107:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <malloc>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
void* malloc(uint32 size)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	68 d0 21 80 00       	push   $0x8021d0
  80111c:	6a 16                	push   $0x16
  80111e:	68 f5 21 80 00       	push   $0x8021f5
  801123:	e8 e7 07 00 00       	call   80190f <_panic>

00801128 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	68 04 22 80 00       	push   $0x802204
  801136:	6a 2e                	push   $0x2e
  801138:	68 f5 21 80 00       	push   $0x8021f5
  80113d:	e8 cd 07 00 00       	call   80190f <_panic>

00801142 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 18             	sub    $0x18,%esp
  801148:	8b 45 10             	mov    0x10(%ebp),%eax
  80114b:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  80114e:	83 ec 04             	sub    $0x4,%esp
  801151:	68 28 22 80 00       	push   $0x802228
  801156:	6a 3b                	push   $0x3b
  801158:	68 f5 21 80 00       	push   $0x8021f5
  80115d:	e8 ad 07 00 00       	call   80190f <_panic>

00801162 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801168:	83 ec 04             	sub    $0x4,%esp
  80116b:	68 28 22 80 00       	push   $0x802228
  801170:	6a 41                	push   $0x41
  801172:	68 f5 21 80 00       	push   $0x8021f5
  801177:	e8 93 07 00 00       	call   80190f <_panic>

0080117c <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801182:	83 ec 04             	sub    $0x4,%esp
  801185:	68 28 22 80 00       	push   $0x802228
  80118a:	6a 47                	push   $0x47
  80118c:	68 f5 21 80 00       	push   $0x8021f5
  801191:	e8 79 07 00 00       	call   80190f <_panic>

00801196 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80119c:	83 ec 04             	sub    $0x4,%esp
  80119f:	68 28 22 80 00       	push   $0x802228
  8011a4:	6a 4c                	push   $0x4c
  8011a6:	68 f5 21 80 00       	push   $0x8021f5
  8011ab:	e8 5f 07 00 00       	call   80190f <_panic>

008011b0 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8011b6:	83 ec 04             	sub    $0x4,%esp
  8011b9:	68 28 22 80 00       	push   $0x802228
  8011be:	6a 52                	push   $0x52
  8011c0:	68 f5 21 80 00       	push   $0x8021f5
  8011c5:	e8 45 07 00 00       	call   80190f <_panic>

008011ca <shrink>:
}
void shrink(uint32 newSize)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	68 28 22 80 00       	push   $0x802228
  8011d8:	6a 56                	push   $0x56
  8011da:	68 f5 21 80 00       	push   $0x8021f5
  8011df:	e8 2b 07 00 00       	call   80190f <_panic>

008011e4 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8011ea:	83 ec 04             	sub    $0x4,%esp
  8011ed:	68 28 22 80 00       	push   $0x802228
  8011f2:	6a 5b                	push   $0x5b
  8011f4:	68 f5 21 80 00       	push   $0x8021f5
  8011f9:	e8 11 07 00 00       	call   80190f <_panic>

008011fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	57                   	push   %edi
  801202:	56                   	push   %esi
  801203:	53                   	push   %ebx
  801204:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801210:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801213:	8b 7d 18             	mov    0x18(%ebp),%edi
  801216:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801219:	cd 30                	int    $0x30
  80121b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80121e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 04             	sub    $0x4,%esp
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801235:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	6a 00                	push   $0x0
  80123e:	6a 00                	push   $0x0
  801240:	52                   	push   %edx
  801241:	ff 75 0c             	pushl  0xc(%ebp)
  801244:	50                   	push   %eax
  801245:	6a 00                	push   $0x0
  801247:	e8 b2 ff ff ff       	call   8011fe <syscall>
  80124c:	83 c4 18             	add    $0x18,%esp
}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <sys_cgetc>:

int
sys_cgetc(void)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801255:	6a 00                	push   $0x0
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 01                	push   $0x1
  801261:	e8 98 ff ff ff       	call   8011fe <syscall>
  801266:	83 c4 18             	add    $0x18,%esp
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	50                   	push   %eax
  80127a:	6a 05                	push   $0x5
  80127c:	e8 7d ff ff ff       	call   8011fe <syscall>
  801281:	83 c4 18             	add    $0x18,%esp
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 02                	push   $0x2
  801295:	e8 64 ff ff ff       	call   8011fe <syscall>
  80129a:	83 c4 18             	add    $0x18,%esp
}
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 03                	push   $0x3
  8012ae:	e8 4b ff ff ff       	call   8011fe <syscall>
  8012b3:	83 c4 18             	add    $0x18,%esp
}
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 04                	push   $0x4
  8012c7:	e8 32 ff ff ff       	call   8011fe <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <sys_env_exit>:


void sys_env_exit(void)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 06                	push   $0x6
  8012e0:	e8 19 ff ff ff       	call   8011fe <syscall>
  8012e5:	83 c4 18             	add    $0x18,%esp
}
  8012e8:	90                   	nop
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	52                   	push   %edx
  8012fb:	50                   	push   %eax
  8012fc:	6a 07                	push   $0x7
  8012fe:	e8 fb fe ff ff       	call   8011fe <syscall>
  801303:	83 c4 18             	add    $0x18,%esp
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	56                   	push   %esi
  80130c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80130d:	8b 75 18             	mov    0x18(%ebp),%esi
  801310:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801313:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801316:	8b 55 0c             	mov    0xc(%ebp),%edx
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	56                   	push   %esi
  80131d:	53                   	push   %ebx
  80131e:	51                   	push   %ecx
  80131f:	52                   	push   %edx
  801320:	50                   	push   %eax
  801321:	6a 08                	push   $0x8
  801323:	e8 d6 fe ff ff       	call   8011fe <syscall>
  801328:	83 c4 18             	add    $0x18,%esp
}
  80132b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80132e:	5b                   	pop    %ebx
  80132f:	5e                   	pop    %esi
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    

00801332 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801335:	8b 55 0c             	mov    0xc(%ebp),%edx
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	52                   	push   %edx
  801342:	50                   	push   %eax
  801343:	6a 09                	push   $0x9
  801345:	e8 b4 fe ff ff       	call   8011fe <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	ff 75 0c             	pushl  0xc(%ebp)
  80135b:	ff 75 08             	pushl  0x8(%ebp)
  80135e:	6a 0a                	push   $0xa
  801360:	e8 99 fe ff ff       	call   8011fe <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 0b                	push   $0xb
  801379:	e8 80 fe ff ff       	call   8011fe <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 0c                	push   $0xc
  801392:	e8 67 fe ff ff       	call   8011fe <syscall>
  801397:	83 c4 18             	add    $0x18,%esp
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 0d                	push   $0xd
  8013ab:	e8 4e fe ff ff       	call   8011fe <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	6a 11                	push   $0x11
  8013c6:	e8 33 fe ff ff       	call   8011fe <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
	return;
  8013ce:	90                   	nop
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	ff 75 08             	pushl  0x8(%ebp)
  8013e0:	6a 12                	push   $0x12
  8013e2:	e8 17 fe ff ff       	call   8011fe <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ea:	90                   	nop
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 0e                	push   $0xe
  8013fc:	e8 fd fd ff ff       	call   8011fe <syscall>
  801401:	83 c4 18             	add    $0x18,%esp
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	ff 75 08             	pushl  0x8(%ebp)
  801414:	6a 0f                	push   $0xf
  801416:	e8 e3 fd ff ff       	call   8011fe <syscall>
  80141b:	83 c4 18             	add    $0x18,%esp
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 10                	push   $0x10
  80142f:	e8 ca fd ff ff       	call   8011fe <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	90                   	nop
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 14                	push   $0x14
  801449:	e8 b0 fd ff ff       	call   8011fe <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 15                	push   $0x15
  801463:	e8 96 fd ff ff       	call   8011fe <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	90                   	nop
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_cputc>:


void
sys_cputc(const char c)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 04             	sub    $0x4,%esp
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80147a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	50                   	push   %eax
  801487:	6a 16                	push   $0x16
  801489:	e8 70 fd ff ff       	call   8011fe <syscall>
  80148e:	83 c4 18             	add    $0x18,%esp
}
  801491:	90                   	nop
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 17                	push   $0x17
  8014a3:	e8 56 fd ff ff       	call   8011fe <syscall>
  8014a8:	83 c4 18             	add    $0x18,%esp
}
  8014ab:	90                   	nop
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	ff 75 0c             	pushl  0xc(%ebp)
  8014bd:	50                   	push   %eax
  8014be:	6a 18                	push   $0x18
  8014c0:	e8 39 fd ff ff       	call   8011fe <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	52                   	push   %edx
  8014da:	50                   	push   %eax
  8014db:	6a 1b                	push   $0x1b
  8014dd:	e8 1c fd ff ff       	call   8011fe <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	52                   	push   %edx
  8014f7:	50                   	push   %eax
  8014f8:	6a 19                	push   $0x19
  8014fa:	e8 ff fc ff ff       	call   8011fe <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	52                   	push   %edx
  801515:	50                   	push   %eax
  801516:	6a 1a                	push   $0x1a
  801518:	e8 e1 fc ff ff       	call   8011fe <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	90                   	nop
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	83 ec 04             	sub    $0x4,%esp
  801529:	8b 45 10             	mov    0x10(%ebp),%eax
  80152c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80152f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801532:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	6a 00                	push   $0x0
  80153b:	51                   	push   %ecx
  80153c:	52                   	push   %edx
  80153d:	ff 75 0c             	pushl  0xc(%ebp)
  801540:	50                   	push   %eax
  801541:	6a 1c                	push   $0x1c
  801543:	e8 b6 fc ff ff       	call   8011fe <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801550:	8b 55 0c             	mov    0xc(%ebp),%edx
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	52                   	push   %edx
  80155d:	50                   	push   %eax
  80155e:	6a 1d                	push   $0x1d
  801560:	e8 99 fc ff ff       	call   8011fe <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80156d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801570:	8b 55 0c             	mov    0xc(%ebp),%edx
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	51                   	push   %ecx
  80157b:	52                   	push   %edx
  80157c:	50                   	push   %eax
  80157d:	6a 1e                	push   $0x1e
  80157f:	e8 7a fc ff ff       	call   8011fe <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80158c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	52                   	push   %edx
  801599:	50                   	push   %eax
  80159a:	6a 1f                	push   $0x1f
  80159c:	e8 5d fc ff ff       	call   8011fe <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 20                	push   $0x20
  8015b5:	e8 44 fc ff ff       	call   8011fe <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	ff 75 14             	pushl  0x14(%ebp)
  8015ca:	ff 75 10             	pushl  0x10(%ebp)
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	50                   	push   %eax
  8015d1:	6a 21                	push   $0x21
  8015d3:	e8 26 fc ff ff       	call   8011fe <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	50                   	push   %eax
  8015ec:	6a 22                	push   $0x22
  8015ee:	e8 0b fc ff ff       	call   8011fe <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	90                   	nop
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	50                   	push   %eax
  801608:	6a 23                	push   $0x23
  80160a:	e8 ef fb ff ff       	call   8011fe <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	90                   	nop
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80161b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80161e:	8d 50 04             	lea    0x4(%eax),%edx
  801621:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	52                   	push   %edx
  80162b:	50                   	push   %eax
  80162c:	6a 24                	push   $0x24
  80162e:	e8 cb fb ff ff       	call   8011fe <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
	return result;
  801636:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801639:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163f:	89 01                	mov    %eax,(%ecx)
  801641:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	c9                   	leave  
  801648:	c2 04 00             	ret    $0x4

0080164b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	ff 75 10             	pushl  0x10(%ebp)
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	ff 75 08             	pushl  0x8(%ebp)
  80165b:	6a 13                	push   $0x13
  80165d:	e8 9c fb ff ff       	call   8011fe <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
	return ;
  801665:	90                   	nop
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_rcr2>:
uint32 sys_rcr2()
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 25                	push   $0x25
  801677:	e8 82 fb ff ff       	call   8011fe <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80168d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	50                   	push   %eax
  80169a:	6a 26                	push   $0x26
  80169c:	e8 5d fb ff ff       	call   8011fe <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a4:	90                   	nop
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <rsttst>:
void rsttst()
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 28                	push   $0x28
  8016b6:	e8 43 fb ff ff       	call   8011fe <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016be:	90                   	nop
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8016d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016d4:	52                   	push   %edx
  8016d5:	50                   	push   %eax
  8016d6:	ff 75 10             	pushl  0x10(%ebp)
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	6a 27                	push   $0x27
  8016e1:	e8 18 fb ff ff       	call   8011fe <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e9:	90                   	nop
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <chktst>:
void chktst(uint32 n)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	ff 75 08             	pushl  0x8(%ebp)
  8016fa:	6a 29                	push   $0x29
  8016fc:	e8 fd fa ff ff       	call   8011fe <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
	return ;
  801704:	90                   	nop
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <inctst>:

void inctst()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 2a                	push   $0x2a
  801716:	e8 e3 fa ff ff       	call   8011fe <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
	return ;
  80171e:	90                   	nop
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <gettst>:
uint32 gettst()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 2b                	push   $0x2b
  801730:	e8 c9 fa ff ff       	call   8011fe <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 2c                	push   $0x2c
  80174c:	e8 ad fa ff ff       	call   8011fe <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
  801754:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801757:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80175b:	75 07                	jne    801764 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80175d:	b8 01 00 00 00       	mov    $0x1,%eax
  801762:	eb 05                	jmp    801769 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 2c                	push   $0x2c
  80177d:	e8 7c fa ff ff       	call   8011fe <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
  801785:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801788:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80178c:	75 07                	jne    801795 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80178e:	b8 01 00 00 00       	mov    $0x1,%eax
  801793:	eb 05                	jmp    80179a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 2c                	push   $0x2c
  8017ae:	e8 4b fa ff ff       	call   8011fe <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
  8017b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017b9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017bd:	75 07                	jne    8017c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c4:	eb 05                	jmp    8017cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 2c                	push   $0x2c
  8017df:	e8 1a fa ff ff       	call   8011fe <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
  8017e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017ee:	75 07                	jne    8017f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f5:	eb 05                	jmp    8017fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	6a 2d                	push   $0x2d
  80180e:	e8 eb f9 ff ff       	call   8011fe <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
	return ;
  801816:	90                   	nop
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80181d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801820:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	53                   	push   %ebx
  80182c:	51                   	push   %ecx
  80182d:	52                   	push   %edx
  80182e:	50                   	push   %eax
  80182f:	6a 2e                	push   $0x2e
  801831:	e8 c8 f9 ff ff       	call   8011fe <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	52                   	push   %edx
  80184e:	50                   	push   %eax
  80184f:	6a 2f                	push   $0x2f
  801851:	e8 a8 f9 ff ff       	call   8011fe <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801861:	8b 55 08             	mov    0x8(%ebp),%edx
  801864:	89 d0                	mov    %edx,%eax
  801866:	c1 e0 02             	shl    $0x2,%eax
  801869:	01 d0                	add    %edx,%eax
  80186b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801872:	01 d0                	add    %edx,%eax
  801874:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80187b:	01 d0                	add    %edx,%eax
  80187d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801884:	01 d0                	add    %edx,%eax
  801886:	c1 e0 04             	shl    $0x4,%eax
  801889:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80188c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801893:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	50                   	push   %eax
  80189a:	e8 76 fd ff ff       	call   801615 <sys_get_virtual_time>
  80189f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8018a2:	eb 41                	jmp    8018e5 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8018a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018a7:	83 ec 0c             	sub    $0xc,%esp
  8018aa:	50                   	push   %eax
  8018ab:	e8 65 fd ff ff       	call   801615 <sys_get_virtual_time>
  8018b0:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8018b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b9:	29 c2                	sub    %eax,%edx
  8018bb:	89 d0                	mov    %edx,%eax
  8018bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8018c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c6:	89 d1                	mov    %edx,%ecx
  8018c8:	29 c1                	sub    %eax,%ecx
  8018ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d0:	39 c2                	cmp    %eax,%edx
  8018d2:	0f 97 c0             	seta   %al
  8018d5:	0f b6 c0             	movzbl %al,%eax
  8018d8:	29 c1                	sub    %eax,%ecx
  8018da:	89 c8                	mov    %ecx,%eax
  8018dc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8018df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	72 b7                	jb     8018a4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8018f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8018fd:	eb 03                	jmp    801902 <busy_wait+0x12>
  8018ff:	ff 45 fc             	incl   -0x4(%ebp)
  801902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801905:	3b 45 08             	cmp    0x8(%ebp),%eax
  801908:	72 f5                	jb     8018ff <busy_wait+0xf>
	return i;
  80190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801915:	8d 45 10             	lea    0x10(%ebp),%eax
  801918:	83 c0 04             	add    $0x4,%eax
  80191b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80191e:	a1 18 31 80 00       	mov    0x803118,%eax
  801923:	85 c0                	test   %eax,%eax
  801925:	74 16                	je     80193d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801927:	a1 18 31 80 00       	mov    0x803118,%eax
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	50                   	push   %eax
  801930:	68 4c 22 80 00       	push   $0x80224c
  801935:	e8 4a ea ff ff       	call   800384 <cprintf>
  80193a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80193d:	a1 00 30 80 00       	mov    0x803000,%eax
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	50                   	push   %eax
  801949:	68 51 22 80 00       	push   $0x802251
  80194e:	e8 31 ea ff ff       	call   800384 <cprintf>
  801953:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801956:	8b 45 10             	mov    0x10(%ebp),%eax
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	ff 75 f4             	pushl  -0xc(%ebp)
  80195f:	50                   	push   %eax
  801960:	e8 b4 e9 ff ff       	call   800319 <vcprintf>
  801965:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801968:	83 ec 08             	sub    $0x8,%esp
  80196b:	6a 00                	push   $0x0
  80196d:	68 6d 22 80 00       	push   $0x80226d
  801972:	e8 a2 e9 ff ff       	call   800319 <vcprintf>
  801977:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80197a:	e8 23 e9 ff ff       	call   8002a2 <exit>

	// should not return here
	while (1) ;
  80197f:	eb fe                	jmp    80197f <_panic+0x70>

00801981 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801987:	a1 20 30 80 00       	mov    0x803020,%eax
  80198c:	8b 50 74             	mov    0x74(%eax),%edx
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	39 c2                	cmp    %eax,%edx
  801994:	74 14                	je     8019aa <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	68 70 22 80 00       	push   $0x802270
  80199e:	6a 26                	push   $0x26
  8019a0:	68 bc 22 80 00       	push   $0x8022bc
  8019a5:	e8 65 ff ff ff       	call   80190f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019b8:	e9 b6 00 00 00       	jmp    801a73 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	01 d0                	add    %edx,%eax
  8019cc:	8b 00                	mov    (%eax),%eax
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	75 08                	jne    8019da <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8019d2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019d5:	e9 96 00 00 00       	jmp    801a70 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8019da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019e8:	eb 5d                	jmp    801a47 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8019ef:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8019f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019f8:	c1 e2 04             	shl    $0x4,%edx
  8019fb:	01 d0                	add    %edx,%eax
  8019fd:	8a 40 04             	mov    0x4(%eax),%al
  801a00:	84 c0                	test   %al,%al
  801a02:	75 40                	jne    801a44 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a04:	a1 20 30 80 00       	mov    0x803020,%eax
  801a09:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801a0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a12:	c1 e2 04             	shl    $0x4,%edx
  801a15:	01 d0                	add    %edx,%eax
  801a17:	8b 00                	mov    (%eax),%eax
  801a19:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a24:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a29:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	01 c8                	add    %ecx,%eax
  801a35:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a37:	39 c2                	cmp    %eax,%edx
  801a39:	75 09                	jne    801a44 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801a3b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a42:	eb 12                	jmp    801a56 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a44:	ff 45 e8             	incl   -0x18(%ebp)
  801a47:	a1 20 30 80 00       	mov    0x803020,%eax
  801a4c:	8b 50 74             	mov    0x74(%eax),%edx
  801a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a52:	39 c2                	cmp    %eax,%edx
  801a54:	77 94                	ja     8019ea <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a56:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a5a:	75 14                	jne    801a70 <CheckWSWithoutLastIndex+0xef>
			panic(
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	68 c8 22 80 00       	push   $0x8022c8
  801a64:	6a 3a                	push   $0x3a
  801a66:	68 bc 22 80 00       	push   $0x8022bc
  801a6b:	e8 9f fe ff ff       	call   80190f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a70:	ff 45 f0             	incl   -0x10(%ebp)
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a79:	0f 8c 3e ff ff ff    	jl     8019bd <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a7f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a8d:	eb 20                	jmp    801aaf <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a8f:	a1 20 30 80 00       	mov    0x803020,%eax
  801a94:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a9d:	c1 e2 04             	shl    $0x4,%edx
  801aa0:	01 d0                	add    %edx,%eax
  801aa2:	8a 40 04             	mov    0x4(%eax),%al
  801aa5:	3c 01                	cmp    $0x1,%al
  801aa7:	75 03                	jne    801aac <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801aa9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aac:	ff 45 e0             	incl   -0x20(%ebp)
  801aaf:	a1 20 30 80 00       	mov    0x803020,%eax
  801ab4:	8b 50 74             	mov    0x74(%eax),%edx
  801ab7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aba:	39 c2                	cmp    %eax,%edx
  801abc:	77 d1                	ja     801a8f <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ac4:	74 14                	je     801ada <CheckWSWithoutLastIndex+0x159>
		panic(
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	68 1c 23 80 00       	push   $0x80231c
  801ace:	6a 44                	push   $0x44
  801ad0:	68 bc 22 80 00       	push   $0x8022bc
  801ad5:	e8 35 fe ff ff       	call   80190f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801ada:	90                   	nop
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    
  801add:	66 90                	xchg   %ax,%ax
  801adf:	90                   	nop

00801ae0 <__udivdi3>:
  801ae0:	55                   	push   %ebp
  801ae1:	57                   	push   %edi
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 1c             	sub    $0x1c,%esp
  801ae7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aeb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801af3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801af7:	89 ca                	mov    %ecx,%edx
  801af9:	89 f8                	mov    %edi,%eax
  801afb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aff:	85 f6                	test   %esi,%esi
  801b01:	75 2d                	jne    801b30 <__udivdi3+0x50>
  801b03:	39 cf                	cmp    %ecx,%edi
  801b05:	77 65                	ja     801b6c <__udivdi3+0x8c>
  801b07:	89 fd                	mov    %edi,%ebp
  801b09:	85 ff                	test   %edi,%edi
  801b0b:	75 0b                	jne    801b18 <__udivdi3+0x38>
  801b0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b12:	31 d2                	xor    %edx,%edx
  801b14:	f7 f7                	div    %edi
  801b16:	89 c5                	mov    %eax,%ebp
  801b18:	31 d2                	xor    %edx,%edx
  801b1a:	89 c8                	mov    %ecx,%eax
  801b1c:	f7 f5                	div    %ebp
  801b1e:	89 c1                	mov    %eax,%ecx
  801b20:	89 d8                	mov    %ebx,%eax
  801b22:	f7 f5                	div    %ebp
  801b24:	89 cf                	mov    %ecx,%edi
  801b26:	89 fa                	mov    %edi,%edx
  801b28:	83 c4 1c             	add    $0x1c,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    
  801b30:	39 ce                	cmp    %ecx,%esi
  801b32:	77 28                	ja     801b5c <__udivdi3+0x7c>
  801b34:	0f bd fe             	bsr    %esi,%edi
  801b37:	83 f7 1f             	xor    $0x1f,%edi
  801b3a:	75 40                	jne    801b7c <__udivdi3+0x9c>
  801b3c:	39 ce                	cmp    %ecx,%esi
  801b3e:	72 0a                	jb     801b4a <__udivdi3+0x6a>
  801b40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b44:	0f 87 9e 00 00 00    	ja     801be8 <__udivdi3+0x108>
  801b4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4f:	89 fa                	mov    %edi,%edx
  801b51:	83 c4 1c             	add    $0x1c,%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5f                   	pop    %edi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    
  801b59:	8d 76 00             	lea    0x0(%esi),%esi
  801b5c:	31 ff                	xor    %edi,%edi
  801b5e:	31 c0                	xor    %eax,%eax
  801b60:	89 fa                	mov    %edi,%edx
  801b62:	83 c4 1c             	add    $0x1c,%esp
  801b65:	5b                   	pop    %ebx
  801b66:	5e                   	pop    %esi
  801b67:	5f                   	pop    %edi
  801b68:	5d                   	pop    %ebp
  801b69:	c3                   	ret    
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	89 d8                	mov    %ebx,%eax
  801b6e:	f7 f7                	div    %edi
  801b70:	31 ff                	xor    %edi,%edi
  801b72:	89 fa                	mov    %edi,%edx
  801b74:	83 c4 1c             	add    $0x1c,%esp
  801b77:	5b                   	pop    %ebx
  801b78:	5e                   	pop    %esi
  801b79:	5f                   	pop    %edi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    
  801b7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b81:	89 eb                	mov    %ebp,%ebx
  801b83:	29 fb                	sub    %edi,%ebx
  801b85:	89 f9                	mov    %edi,%ecx
  801b87:	d3 e6                	shl    %cl,%esi
  801b89:	89 c5                	mov    %eax,%ebp
  801b8b:	88 d9                	mov    %bl,%cl
  801b8d:	d3 ed                	shr    %cl,%ebp
  801b8f:	89 e9                	mov    %ebp,%ecx
  801b91:	09 f1                	or     %esi,%ecx
  801b93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b97:	89 f9                	mov    %edi,%ecx
  801b99:	d3 e0                	shl    %cl,%eax
  801b9b:	89 c5                	mov    %eax,%ebp
  801b9d:	89 d6                	mov    %edx,%esi
  801b9f:	88 d9                	mov    %bl,%cl
  801ba1:	d3 ee                	shr    %cl,%esi
  801ba3:	89 f9                	mov    %edi,%ecx
  801ba5:	d3 e2                	shl    %cl,%edx
  801ba7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bab:	88 d9                	mov    %bl,%cl
  801bad:	d3 e8                	shr    %cl,%eax
  801baf:	09 c2                	or     %eax,%edx
  801bb1:	89 d0                	mov    %edx,%eax
  801bb3:	89 f2                	mov    %esi,%edx
  801bb5:	f7 74 24 0c          	divl   0xc(%esp)
  801bb9:	89 d6                	mov    %edx,%esi
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	f7 e5                	mul    %ebp
  801bbf:	39 d6                	cmp    %edx,%esi
  801bc1:	72 19                	jb     801bdc <__udivdi3+0xfc>
  801bc3:	74 0b                	je     801bd0 <__udivdi3+0xf0>
  801bc5:	89 d8                	mov    %ebx,%eax
  801bc7:	31 ff                	xor    %edi,%edi
  801bc9:	e9 58 ff ff ff       	jmp    801b26 <__udivdi3+0x46>
  801bce:	66 90                	xchg   %ax,%ax
  801bd0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bd4:	89 f9                	mov    %edi,%ecx
  801bd6:	d3 e2                	shl    %cl,%edx
  801bd8:	39 c2                	cmp    %eax,%edx
  801bda:	73 e9                	jae    801bc5 <__udivdi3+0xe5>
  801bdc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bdf:	31 ff                	xor    %edi,%edi
  801be1:	e9 40 ff ff ff       	jmp    801b26 <__udivdi3+0x46>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	31 c0                	xor    %eax,%eax
  801bea:	e9 37 ff ff ff       	jmp    801b26 <__udivdi3+0x46>
  801bef:	90                   	nop

00801bf0 <__umoddi3>:
  801bf0:	55                   	push   %ebp
  801bf1:	57                   	push   %edi
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 1c             	sub    $0x1c,%esp
  801bf7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bfb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c0f:	89 f3                	mov    %esi,%ebx
  801c11:	89 fa                	mov    %edi,%edx
  801c13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c17:	89 34 24             	mov    %esi,(%esp)
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	75 1a                	jne    801c38 <__umoddi3+0x48>
  801c1e:	39 f7                	cmp    %esi,%edi
  801c20:	0f 86 a2 00 00 00    	jbe    801cc8 <__umoddi3+0xd8>
  801c26:	89 c8                	mov    %ecx,%eax
  801c28:	89 f2                	mov    %esi,%edx
  801c2a:	f7 f7                	div    %edi
  801c2c:	89 d0                	mov    %edx,%eax
  801c2e:	31 d2                	xor    %edx,%edx
  801c30:	83 c4 1c             	add    $0x1c,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
  801c38:	39 f0                	cmp    %esi,%eax
  801c3a:	0f 87 ac 00 00 00    	ja     801cec <__umoddi3+0xfc>
  801c40:	0f bd e8             	bsr    %eax,%ebp
  801c43:	83 f5 1f             	xor    $0x1f,%ebp
  801c46:	0f 84 ac 00 00 00    	je     801cf8 <__umoddi3+0x108>
  801c4c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c51:	29 ef                	sub    %ebp,%edi
  801c53:	89 fe                	mov    %edi,%esi
  801c55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c59:	89 e9                	mov    %ebp,%ecx
  801c5b:	d3 e0                	shl    %cl,%eax
  801c5d:	89 d7                	mov    %edx,%edi
  801c5f:	89 f1                	mov    %esi,%ecx
  801c61:	d3 ef                	shr    %cl,%edi
  801c63:	09 c7                	or     %eax,%edi
  801c65:	89 e9                	mov    %ebp,%ecx
  801c67:	d3 e2                	shl    %cl,%edx
  801c69:	89 14 24             	mov    %edx,(%esp)
  801c6c:	89 d8                	mov    %ebx,%eax
  801c6e:	d3 e0                	shl    %cl,%eax
  801c70:	89 c2                	mov    %eax,%edx
  801c72:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c76:	d3 e0                	shl    %cl,%eax
  801c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c80:	89 f1                	mov    %esi,%ecx
  801c82:	d3 e8                	shr    %cl,%eax
  801c84:	09 d0                	or     %edx,%eax
  801c86:	d3 eb                	shr    %cl,%ebx
  801c88:	89 da                	mov    %ebx,%edx
  801c8a:	f7 f7                	div    %edi
  801c8c:	89 d3                	mov    %edx,%ebx
  801c8e:	f7 24 24             	mull   (%esp)
  801c91:	89 c6                	mov    %eax,%esi
  801c93:	89 d1                	mov    %edx,%ecx
  801c95:	39 d3                	cmp    %edx,%ebx
  801c97:	0f 82 87 00 00 00    	jb     801d24 <__umoddi3+0x134>
  801c9d:	0f 84 91 00 00 00    	je     801d34 <__umoddi3+0x144>
  801ca3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ca7:	29 f2                	sub    %esi,%edx
  801ca9:	19 cb                	sbb    %ecx,%ebx
  801cab:	89 d8                	mov    %ebx,%eax
  801cad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cb1:	d3 e0                	shl    %cl,%eax
  801cb3:	89 e9                	mov    %ebp,%ecx
  801cb5:	d3 ea                	shr    %cl,%edx
  801cb7:	09 d0                	or     %edx,%eax
  801cb9:	89 e9                	mov    %ebp,%ecx
  801cbb:	d3 eb                	shr    %cl,%ebx
  801cbd:	89 da                	mov    %ebx,%edx
  801cbf:	83 c4 1c             	add    $0x1c,%esp
  801cc2:	5b                   	pop    %ebx
  801cc3:	5e                   	pop    %esi
  801cc4:	5f                   	pop    %edi
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    
  801cc7:	90                   	nop
  801cc8:	89 fd                	mov    %edi,%ebp
  801cca:	85 ff                	test   %edi,%edi
  801ccc:	75 0b                	jne    801cd9 <__umoddi3+0xe9>
  801cce:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd3:	31 d2                	xor    %edx,%edx
  801cd5:	f7 f7                	div    %edi
  801cd7:	89 c5                	mov    %eax,%ebp
  801cd9:	89 f0                	mov    %esi,%eax
  801cdb:	31 d2                	xor    %edx,%edx
  801cdd:	f7 f5                	div    %ebp
  801cdf:	89 c8                	mov    %ecx,%eax
  801ce1:	f7 f5                	div    %ebp
  801ce3:	89 d0                	mov    %edx,%eax
  801ce5:	e9 44 ff ff ff       	jmp    801c2e <__umoddi3+0x3e>
  801cea:	66 90                	xchg   %ax,%ax
  801cec:	89 c8                	mov    %ecx,%eax
  801cee:	89 f2                	mov    %esi,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	3b 04 24             	cmp    (%esp),%eax
  801cfb:	72 06                	jb     801d03 <__umoddi3+0x113>
  801cfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d01:	77 0f                	ja     801d12 <__umoddi3+0x122>
  801d03:	89 f2                	mov    %esi,%edx
  801d05:	29 f9                	sub    %edi,%ecx
  801d07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d0b:	89 14 24             	mov    %edx,(%esp)
  801d0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d12:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d16:	8b 14 24             	mov    (%esp),%edx
  801d19:	83 c4 1c             	add    $0x1c,%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5f                   	pop    %edi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    
  801d21:	8d 76 00             	lea    0x0(%esi),%esi
  801d24:	2b 04 24             	sub    (%esp),%eax
  801d27:	19 fa                	sbb    %edi,%edx
  801d29:	89 d1                	mov    %edx,%ecx
  801d2b:	89 c6                	mov    %eax,%esi
  801d2d:	e9 71 ff ff ff       	jmp    801ca3 <__umoddi3+0xb3>
  801d32:	66 90                	xchg   %ax,%ax
  801d34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d38:	72 ea                	jb     801d24 <__umoddi3+0x134>
  801d3a:	89 d9                	mov    %ebx,%ecx
  801d3c:	e9 62 ff ff ff       	jmp    801ca3 <__umoddi3+0xb3>
