
obj/user/quicksort_interrupt:     file format elf32-i386


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
  800031:	e8 e6 05 00 00       	call   80061c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 fa 1d 00 00       	call   801e48 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 0c 1e 00 00       	call   801e61 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_disable_interrupt();

		sys_disable_interrupt();
  80005d:	e8 b6 1e 00 00       	call   801f18 <sys_disable_interrupt>
			readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 a0 25 80 00       	push   $0x8025a0
  800071:	e8 0f 10 00 00       	call   801085 <readline>
  800076:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 5f 15 00 00       	call   8015eb <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 f2 18 00 00       	call   801993 <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	68 c0 25 80 00       	push   $0x8025c0
  8000af:	e8 4f 09 00 00       	call   800a03 <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 e3 25 80 00       	push   $0x8025e3
  8000bf:	e8 3f 09 00 00       	call   800a03 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 f1 25 80 00       	push   $0x8025f1
  8000cf:	e8 2f 09 00 00       	call   800a03 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 00 26 80 00       	push   $0x802600
  8000df:	e8 1f 09 00 00       	call   800a03 <cprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
					do
					{
						cprintf("Select: ") ;
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 10 26 80 00       	push   $0x802610
  8000ef:	e8 0f 09 00 00       	call   800a03 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp
						Chose = getchar() ;
  8000f7:	e8 c8 04 00 00       	call   8005c4 <getchar>
  8000fc:	88 45 e7             	mov    %al,-0x19(%ebp)
						cputchar(Chose);
  8000ff:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	50                   	push   %eax
  800107:	e8 70 04 00 00       	call   80057c <cputchar>
  80010c:	83 c4 10             	add    $0x10,%esp
						cputchar('\n');
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	6a 0a                	push   $0xa
  800114:	e8 63 04 00 00       	call   80057c <cputchar>
  800119:	83 c4 10             	add    $0x10,%esp
					} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80011c:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  800120:	74 0c                	je     80012e <_main+0xf6>
  800122:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800126:	74 06                	je     80012e <_main+0xf6>
  800128:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  80012c:	75 b9                	jne    8000e7 <_main+0xaf>
							sys_enable_interrupt();
  80012e:	e8 ff 1d 00 00       	call   801f32 <sys_enable_interrupt>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800133:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800137:	83 f8 62             	cmp    $0x62,%eax
  80013a:	74 1d                	je     800159 <_main+0x121>
  80013c:	83 f8 63             	cmp    $0x63,%eax
  80013f:	74 2b                	je     80016c <_main+0x134>
  800141:	83 f8 61             	cmp    $0x61,%eax
  800144:	75 39                	jne    80017f <_main+0x147>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800146:	83 ec 08             	sub    $0x8,%esp
  800149:	ff 75 ec             	pushl  -0x14(%ebp)
  80014c:	ff 75 e8             	pushl  -0x18(%ebp)
  80014f:	e8 e6 02 00 00       	call   80043a <InitializeAscending>
  800154:	83 c4 10             	add    $0x10,%esp
			break ;
  800157:	eb 37                	jmp    800190 <_main+0x158>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	ff 75 ec             	pushl  -0x14(%ebp)
  80015f:	ff 75 e8             	pushl  -0x18(%ebp)
  800162:	e8 04 03 00 00       	call   80046b <InitializeDescending>
  800167:	83 c4 10             	add    $0x10,%esp
			break ;
  80016a:	eb 24                	jmp    800190 <_main+0x158>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 ec             	pushl  -0x14(%ebp)
  800172:	ff 75 e8             	pushl  -0x18(%ebp)
  800175:	e8 26 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80017a:	83 c4 10             	add    $0x10,%esp
			break ;
  80017d:	eb 11                	jmp    800190 <_main+0x158>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 ec             	pushl  -0x14(%ebp)
  800185:	ff 75 e8             	pushl  -0x18(%ebp)
  800188:	e8 13 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80018d:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 e1 00 00 00       	call   80027f <QuickSort>
  80019e:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 e1 01 00 00       	call   800390 <CheckSorted>
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001b9:	75 14                	jne    8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 1c 26 80 00       	push   $0x80261c
  8001c3:	6a 46                	push   $0x46
  8001c5:	68 3e 26 80 00       	push   $0x80263e
  8001ca:	e8 92 05 00 00       	call   800761 <_panic>
		else
		{ 
			sys_disable_interrupt();
  8001cf:	e8 44 1d 00 00       	call   801f18 <sys_disable_interrupt>
				cprintf("\n===============================================\n") ;
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	68 5c 26 80 00       	push   $0x80265c
  8001dc:	e8 22 08 00 00       	call   800a03 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 90 26 80 00       	push   $0x802690
  8001ec:	e8 12 08 00 00       	call   800a03 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 c4 26 80 00       	push   $0x8026c4
  8001fc:	e8 02 08 00 00       	call   800a03 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800204:	e8 29 1d 00 00       	call   801f32 <sys_enable_interrupt>
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		sys_disable_interrupt();
  800209:	e8 0a 1d 00 00       	call   801f18 <sys_disable_interrupt>
			cprintf("Freeing the Heap...\n\n") ;
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	68 f6 26 80 00       	push   $0x8026f6
  800216:	e8 e8 07 00 00       	call   800a03 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
		sys_enable_interrupt();
  80021e:	e8 0f 1d 00 00       	call   801f32 <sys_enable_interrupt>

		//freeHeap() ;

		///========================================================================
	//sys_disable_interrupt();
		sys_disable_interrupt();
  800223:	e8 f0 1c 00 00       	call   801f18 <sys_disable_interrupt>
			cprintf("Do you want to repeat (y/n): ") ;
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	68 0c 27 80 00       	push   $0x80270c
  800230:	e8 ce 07 00 00       	call   800a03 <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800238:	e8 87 03 00 00       	call   8005c4 <getchar>
  80023d:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  800240:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	e8 2f 03 00 00       	call   80057c <cputchar>
  80024d:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 0a                	push   $0xa
  800255:	e8 22 03 00 00       	call   80057c <cputchar>
  80025a:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	6a 0a                	push   $0xa
  800262:	e8 15 03 00 00       	call   80057c <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
	//sys_enable_interrupt();
		sys_enable_interrupt();
  80026a:	e8 c3 1c 00 00       	call   801f32 <sys_enable_interrupt>

	} while (Chose == 'y');
  80026f:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800273:	0f 84 d0 fd ff ff    	je     800049 <_main+0x11>

}
  800279:	90                   	nop
  80027a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	48                   	dec    %eax
  800289:	50                   	push   %eax
  80028a:	6a 00                	push   $0x0
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 06 00 00 00       	call   80029d <QSort>
  800297:	83 c4 10             	add    $0x10,%esp
}
  80029a:	90                   	nop
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a6:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a9:	0f 8d de 00 00 00    	jge    80038d <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002af:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b2:	40                   	inc    %eax
  8002b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002bc:	e9 80 00 00 00       	jmp    800341 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002c1:	ff 45 f4             	incl   -0xc(%ebp)
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ca:	7f 2b                	jg     8002f7 <QSort+0x5a>
  8002cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	01 c8                	add    %ecx,%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	39 c2                	cmp    %eax,%edx
  8002f0:	7d cf                	jge    8002c1 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002f2:	eb 03                	jmp    8002f7 <QSort+0x5a>
  8002f4:	ff 4d f0             	decl   -0x10(%ebp)
  8002f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002fd:	7e 26                	jle    800325 <QSort+0x88>
  8002ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800302:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	01 d0                	add    %edx,%eax
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800313:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	01 c8                	add    %ecx,%eax
  80031f:	8b 00                	mov    (%eax),%eax
  800321:	39 c2                	cmp    %eax,%edx
  800323:	7e cf                	jle    8002f4 <QSort+0x57>

		if (i <= j)
  800325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800328:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80032b:	7f 14                	jg     800341 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80032d:	83 ec 04             	sub    $0x4,%esp
  800330:	ff 75 f0             	pushl  -0x10(%ebp)
  800333:	ff 75 f4             	pushl  -0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	e8 a9 00 00 00       	call   8003e7 <Swap>
  80033e:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800347:	0f 8e 77 ff ff ff    	jle    8002c4 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	ff 75 f0             	pushl  -0x10(%ebp)
  800353:	ff 75 10             	pushl  0x10(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	e8 89 00 00 00       	call   8003e7 <Swap>
  80035e:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	48                   	dec    %eax
  800365:	50                   	push   %eax
  800366:	ff 75 10             	pushl  0x10(%ebp)
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	ff 75 08             	pushl  0x8(%ebp)
  80036f:	e8 29 ff ff ff       	call   80029d <QSort>
  800374:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800377:	ff 75 14             	pushl  0x14(%ebp)
  80037a:	ff 75 f4             	pushl  -0xc(%ebp)
  80037d:	ff 75 0c             	pushl  0xc(%ebp)
  800380:	ff 75 08             	pushl  0x8(%ebp)
  800383:	e8 15 ff ff ff       	call   80029d <QSort>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	eb 01                	jmp    80038e <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80038d:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800396:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80039d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003a4:	eb 33                	jmp    8003d9 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	8b 10                	mov    (%eax),%edx
  8003b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ba:	40                   	inc    %eax
  8003bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	7e 09                	jle    8003d6 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003d4:	eb 0c                	jmp    8003e2 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003d6:	ff 45 f8             	incl   -0x8(%ebp)
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	48                   	dec    %eax
  8003dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003e0:	7f c4                	jg     8003a6 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	01 d0                	add    %edx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800401:	8b 45 0c             	mov    0xc(%ebp),%eax
  800404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	01 c2                	add    %eax,%edx
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	01 c2                	add    %eax,%edx
  800432:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800435:	89 02                	mov    %eax,(%edx)
}
  800437:	90                   	nop
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800447:	eb 17                	jmp    800460 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c2                	add    %eax,%edx
  800458:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045b:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80045d:	ff 45 fc             	incl   -0x4(%ebp)
  800460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800463:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800466:	7c e1                	jl     800449 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800468:	90                   	nop
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800478:	eb 1b                	jmp    800495 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80047a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	01 c2                	add    %eax,%edx
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80048f:	48                   	dec    %eax
  800490:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	ff 45 fc             	incl   -0x4(%ebp)
  800495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800498:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049b:	7c dd                	jl     80047a <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80049d:	90                   	nop
  80049e:	c9                   	leave  
  80049f:	c3                   	ret    

008004a0 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a9:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ae:	f7 e9                	imul   %ecx
  8004b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8004b3:	89 d0                	mov    %edx,%eax
  8004b5:	29 c8                	sub    %ecx,%eax
  8004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004c1:	eb 1e                	jmp    8004e1 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d6:	99                   	cltd   
  8004d7:	f7 7d f8             	idivl  -0x8(%ebp)
  8004da:	89 d0                	mov    %edx,%eax
  8004dc:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004de:	ff 45 fc             	incl   -0x4(%ebp)
  8004e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e7:	7c da                	jl     8004c3 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004e9:	90                   	nop
  8004ea:	c9                   	leave  
  8004eb:	c3                   	ret    

008004ec <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004ec:	55                   	push   %ebp
  8004ed:	89 e5                	mov    %esp,%ebp
  8004ef:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004f2:	e8 21 1a 00 00       	call   801f18 <sys_disable_interrupt>
		int i ;
		int NumsPerLine = 20 ;
  8004f7:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8004fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800505:	eb 42                	jmp    800549 <PrintElements+0x5d>
		{
			if (i%NumsPerLine == 0)
  800507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050a:	99                   	cltd   
  80050b:	f7 7d f0             	idivl  -0x10(%ebp)
  80050e:	89 d0                	mov    %edx,%eax
  800510:	85 c0                	test   %eax,%eax
  800512:	75 10                	jne    800524 <PrintElements+0x38>
				cprintf("\n");
  800514:	83 ec 0c             	sub    $0xc,%esp
  800517:	68 2a 27 80 00       	push   $0x80272a
  80051c:	e8 e2 04 00 00       	call   800a03 <cprintf>
  800521:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  800524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800527:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	01 d0                	add    %edx,%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	50                   	push   %eax
  800539:	68 2c 27 80 00       	push   $0x80272c
  80053e:	e8 c0 04 00 00       	call   800a03 <cprintf>
  800543:	83 c4 10             	add    $0x10,%esp
void PrintElements(int *Elements, int NumOfElements)
{
	sys_disable_interrupt();
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800546:	ff 45 f4             	incl   -0xc(%ebp)
  800549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054c:	48                   	dec    %eax
  80054d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800550:	7f b5                	jg     800507 <PrintElements+0x1b>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	01 d0                	add    %edx,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	50                   	push   %eax
  800567:	68 31 27 80 00       	push   $0x802731
  80056c:	e8 92 04 00 00       	call   800a03 <cprintf>
  800571:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800574:	e8 b9 19 00 00       	call   801f32 <sys_enable_interrupt>
}
  800579:	90                   	nop
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800588:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	50                   	push   %eax
  800590:	e8 b7 19 00 00       	call   801f4c <sys_cputc>
  800595:	83 c4 10             	add    $0x10,%esp
}
  800598:	90                   	nop
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a1:	e8 72 19 00 00       	call   801f18 <sys_disable_interrupt>
	char c = ch;
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005ac:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b0:	83 ec 0c             	sub    $0xc,%esp
  8005b3:	50                   	push   %eax
  8005b4:	e8 93 19 00 00       	call   801f4c <sys_cputc>
  8005b9:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005bc:	e8 71 19 00 00       	call   801f32 <sys_enable_interrupt>
}
  8005c1:	90                   	nop
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <getchar>:

int
getchar(void)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005d1:	eb 08                	jmp    8005db <getchar+0x17>
	{
		c = sys_cgetc();
  8005d3:	e8 58 17 00 00       	call   801d30 <sys_cgetc>
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005df:	74 f2                	je     8005d3 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ec:	e8 27 19 00 00       	call   801f18 <sys_disable_interrupt>
	int c=0;
  8005f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f8:	eb 08                	jmp    800602 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005fa:	e8 31 17 00 00       	call   801d30 <sys_cgetc>
  8005ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800606:	74 f2                	je     8005fa <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800608:	e8 25 19 00 00       	call   801f32 <sys_enable_interrupt>
	return c;
  80060d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800610:	c9                   	leave  
  800611:	c3                   	ret    

00800612 <iscons>:

int iscons(int fdnum)
{
  800612:	55                   	push   %ebp
  800613:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800615:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80061a:	5d                   	pop    %ebp
  80061b:	c3                   	ret    

0080061c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061c:	55                   	push   %ebp
  80061d:	89 e5                	mov    %esp,%ebp
  80061f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800622:	e8 56 17 00 00       	call   801d7d <sys_getenvindex>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	89 d0                	mov    %edx,%eax
  80062f:	c1 e0 03             	shl    $0x3,%eax
  800632:	01 d0                	add    %edx,%eax
  800634:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80063b:	01 c8                	add    %ecx,%eax
  80063d:	01 c0                	add    %eax,%eax
  80063f:	01 d0                	add    %edx,%eax
  800641:	01 c0                	add    %eax,%eax
  800643:	01 d0                	add    %edx,%eax
  800645:	89 c2                	mov    %eax,%edx
  800647:	c1 e2 05             	shl    $0x5,%edx
  80064a:	29 c2                	sub    %eax,%edx
  80064c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800653:	89 c2                	mov    %eax,%edx
  800655:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80065b:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800660:	a1 24 30 80 00       	mov    0x803024,%eax
  800665:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80066b:	84 c0                	test   %al,%al
  80066d:	74 0f                	je     80067e <libmain+0x62>
		binaryname = myEnv->prog_name;
  80066f:	a1 24 30 80 00       	mov    0x803024,%eax
  800674:	05 40 3c 01 00       	add    $0x13c40,%eax
  800679:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80067e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800682:	7e 0a                	jle    80068e <libmain+0x72>
		binaryname = argv[0];
  800684:	8b 45 0c             	mov    0xc(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	ff 75 08             	pushl  0x8(%ebp)
  800697:	e8 9c f9 ff ff       	call   800038 <_main>
  80069c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80069f:	e8 74 18 00 00       	call   801f18 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006a4:	83 ec 0c             	sub    $0xc,%esp
  8006a7:	68 50 27 80 00       	push   $0x802750
  8006ac:	e8 52 03 00 00       	call   800a03 <cprintf>
  8006b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006b4:	a1 24 30 80 00       	mov    0x803024,%eax
  8006b9:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8006bf:	a1 24 30 80 00       	mov    0x803024,%eax
  8006c4:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	68 78 27 80 00       	push   $0x802778
  8006d4:	e8 2a 03 00 00       	call   800a03 <cprintf>
  8006d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8006dc:	a1 24 30 80 00       	mov    0x803024,%eax
  8006e1:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8006e7:	a1 24 30 80 00       	mov    0x803024,%eax
  8006ec:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	52                   	push   %edx
  8006f6:	50                   	push   %eax
  8006f7:	68 a0 27 80 00       	push   $0x8027a0
  8006fc:	e8 02 03 00 00       	call   800a03 <cprintf>
  800701:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800704:	a1 24 30 80 00       	mov    0x803024,%eax
  800709:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	50                   	push   %eax
  800713:	68 e1 27 80 00       	push   $0x8027e1
  800718:	e8 e6 02 00 00       	call   800a03 <cprintf>
  80071d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800720:	83 ec 0c             	sub    $0xc,%esp
  800723:	68 50 27 80 00       	push   $0x802750
  800728:	e8 d6 02 00 00       	call   800a03 <cprintf>
  80072d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800730:	e8 fd 17 00 00       	call   801f32 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800735:	e8 19 00 00 00       	call   800753 <exit>
}
  80073a:	90                   	nop
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800743:	83 ec 0c             	sub    $0xc,%esp
  800746:	6a 00                	push   $0x0
  800748:	e8 fc 15 00 00       	call   801d49 <sys_env_destroy>
  80074d:	83 c4 10             	add    $0x10,%esp
}
  800750:	90                   	nop
  800751:	c9                   	leave  
  800752:	c3                   	ret    

00800753 <exit>:

void
exit(void)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800759:	e8 51 16 00 00       	call   801daf <sys_env_exit>
}
  80075e:	90                   	nop
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800767:	8d 45 10             	lea    0x10(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800770:	a1 18 31 80 00       	mov    0x803118,%eax
  800775:	85 c0                	test   %eax,%eax
  800777:	74 16                	je     80078f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800779:	a1 18 31 80 00       	mov    0x803118,%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	50                   	push   %eax
  800782:	68 f8 27 80 00       	push   $0x8027f8
  800787:	e8 77 02 00 00       	call   800a03 <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80078f:	a1 00 30 80 00       	mov    0x803000,%eax
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	50                   	push   %eax
  80079b:	68 fd 27 80 00       	push   $0x8027fd
  8007a0:	e8 5e 02 00 00       	call   800a03 <cprintf>
  8007a5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b1:	50                   	push   %eax
  8007b2:	e8 e1 01 00 00       	call   800998 <vcprintf>
  8007b7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	6a 00                	push   $0x0
  8007bf:	68 19 28 80 00       	push   $0x802819
  8007c4:	e8 cf 01 00 00       	call   800998 <vcprintf>
  8007c9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007cc:	e8 82 ff ff ff       	call   800753 <exit>

	// should not return here
	while (1) ;
  8007d1:	eb fe                	jmp    8007d1 <_panic+0x70>

008007d3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d9:	a1 24 30 80 00       	mov    0x803024,%eax
  8007de:	8b 50 74             	mov    0x74(%eax),%edx
  8007e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e4:	39 c2                	cmp    %eax,%edx
  8007e6:	74 14                	je     8007fc <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e8:	83 ec 04             	sub    $0x4,%esp
  8007eb:	68 1c 28 80 00       	push   $0x80281c
  8007f0:	6a 26                	push   $0x26
  8007f2:	68 68 28 80 00       	push   $0x802868
  8007f7:	e8 65 ff ff ff       	call   800761 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800803:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80080a:	e9 b6 00 00 00       	jmp    8008c5 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80080f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800812:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	01 d0                	add    %edx,%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	85 c0                	test   %eax,%eax
  800822:	75 08                	jne    80082c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800824:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800827:	e9 96 00 00 00       	jmp    8008c2 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80082c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800833:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80083a:	eb 5d                	jmp    800899 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80083c:	a1 24 30 80 00       	mov    0x803024,%eax
  800841:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800847:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80084a:	c1 e2 04             	shl    $0x4,%edx
  80084d:	01 d0                	add    %edx,%eax
  80084f:	8a 40 04             	mov    0x4(%eax),%al
  800852:	84 c0                	test   %al,%al
  800854:	75 40                	jne    800896 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800856:	a1 24 30 80 00       	mov    0x803024,%eax
  80085b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800861:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800864:	c1 e2 04             	shl    $0x4,%edx
  800867:	01 d0                	add    %edx,%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80086e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800871:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800876:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	01 c8                	add    %ecx,%eax
  800887:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800889:	39 c2                	cmp    %eax,%edx
  80088b:	75 09                	jne    800896 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80088d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800894:	eb 12                	jmp    8008a8 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800896:	ff 45 e8             	incl   -0x18(%ebp)
  800899:	a1 24 30 80 00       	mov    0x803024,%eax
  80089e:	8b 50 74             	mov    0x74(%eax),%edx
  8008a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	77 94                	ja     80083c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ac:	75 14                	jne    8008c2 <CheckWSWithoutLastIndex+0xef>
			panic(
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	68 74 28 80 00       	push   $0x802874
  8008b6:	6a 3a                	push   $0x3a
  8008b8:	68 68 28 80 00       	push   $0x802868
  8008bd:	e8 9f fe ff ff       	call   800761 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c2:	ff 45 f0             	incl   -0x10(%ebp)
  8008c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cb:	0f 8c 3e ff ff ff    	jl     80080f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008df:	eb 20                	jmp    800901 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e1:	a1 24 30 80 00       	mov    0x803024,%eax
  8008e6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8008ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ef:	c1 e2 04             	shl    $0x4,%edx
  8008f2:	01 d0                	add    %edx,%eax
  8008f4:	8a 40 04             	mov    0x4(%eax),%al
  8008f7:	3c 01                	cmp    $0x1,%al
  8008f9:	75 03                	jne    8008fe <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8008fb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fe:	ff 45 e0             	incl   -0x20(%ebp)
  800901:	a1 24 30 80 00       	mov    0x803024,%eax
  800906:	8b 50 74             	mov    0x74(%eax),%edx
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	39 c2                	cmp    %eax,%edx
  80090e:	77 d1                	ja     8008e1 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800913:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800916:	74 14                	je     80092c <CheckWSWithoutLastIndex+0x159>
		panic(
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 c8 28 80 00       	push   $0x8028c8
  800920:	6a 44                	push   $0x44
  800922:	68 68 28 80 00       	push   $0x802868
  800927:	e8 35 fe ff ff       	call   800761 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80092c:	90                   	nop
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    

0080092f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800935:	8b 45 0c             	mov    0xc(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	8d 48 01             	lea    0x1(%eax),%ecx
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800940:	89 0a                	mov    %ecx,(%edx)
  800942:	8b 55 08             	mov    0x8(%ebp),%edx
  800945:	88 d1                	mov    %dl,%cl
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	3d ff 00 00 00       	cmp    $0xff,%eax
  800958:	75 2c                	jne    800986 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80095a:	a0 28 30 80 00       	mov    0x803028,%al
  80095f:	0f b6 c0             	movzbl %al,%eax
  800962:	8b 55 0c             	mov    0xc(%ebp),%edx
  800965:	8b 12                	mov    (%edx),%edx
  800967:	89 d1                	mov    %edx,%ecx
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096c:	83 c2 08             	add    $0x8,%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	51                   	push   %ecx
  800974:	52                   	push   %edx
  800975:	e8 8d 13 00 00       	call   801d07 <sys_cputs>
  80097a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80097d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800986:	8b 45 0c             	mov    0xc(%ebp),%eax
  800989:	8b 40 04             	mov    0x4(%eax),%eax
  80098c:	8d 50 01             	lea    0x1(%eax),%edx
  80098f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800992:	89 50 04             	mov    %edx,0x4(%eax)
}
  800995:	90                   	nop
  800996:	c9                   	leave  
  800997:	c3                   	ret    

00800998 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009a8:	00 00 00 
	b.cnt = 0;
  8009ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009b2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	ff 75 08             	pushl  0x8(%ebp)
  8009bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c1:	50                   	push   %eax
  8009c2:	68 2f 09 80 00       	push   $0x80092f
  8009c7:	e8 11 02 00 00       	call   800bdd <vprintfmt>
  8009cc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009cf:	a0 28 30 80 00       	mov    0x803028,%al
  8009d4:	0f b6 c0             	movzbl %al,%eax
  8009d7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009dd:	83 ec 04             	sub    $0x4,%esp
  8009e0:	50                   	push   %eax
  8009e1:	52                   	push   %edx
  8009e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009e8:	83 c0 08             	add    $0x8,%eax
  8009eb:	50                   	push   %eax
  8009ec:	e8 16 13 00 00       	call   801d07 <sys_cputs>
  8009f1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009f4:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  8009fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a09:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800a10:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1f:	50                   	push   %eax
  800a20:	e8 73 ff ff ff       	call   800998 <vcprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a36:	e8 dd 14 00 00       	call   801f18 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a3b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4a:	50                   	push   %eax
  800a4b:	e8 48 ff ff ff       	call   800998 <vcprintf>
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a56:	e8 d7 14 00 00       	call   801f32 <sys_enable_interrupt>
	return cnt;
  800a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5e:	c9                   	leave  
  800a5f:	c3                   	ret    

00800a60 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	53                   	push   %ebx
  800a64:	83 ec 14             	sub    $0x14,%esp
  800a67:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a73:	8b 45 18             	mov    0x18(%ebp),%eax
  800a76:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a7e:	77 55                	ja     800ad5 <printnum+0x75>
  800a80:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a83:	72 05                	jb     800a8a <printnum+0x2a>
  800a85:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a88:	77 4b                	ja     800ad5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a8d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a90:	8b 45 18             	mov    0x18(%ebp),%eax
  800a93:	ba 00 00 00 00       	mov    $0x0,%edx
  800a98:	52                   	push   %edx
  800a99:	50                   	push   %eax
  800a9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa0:	e8 97 18 00 00       	call   80233c <__udivdi3>
  800aa5:	83 c4 10             	add    $0x10,%esp
  800aa8:	83 ec 04             	sub    $0x4,%esp
  800aab:	ff 75 20             	pushl  0x20(%ebp)
  800aae:	53                   	push   %ebx
  800aaf:	ff 75 18             	pushl  0x18(%ebp)
  800ab2:	52                   	push   %edx
  800ab3:	50                   	push   %eax
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	ff 75 08             	pushl  0x8(%ebp)
  800aba:	e8 a1 ff ff ff       	call   800a60 <printnum>
  800abf:	83 c4 20             	add    $0x20,%esp
  800ac2:	eb 1a                	jmp    800ade <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	ff 75 20             	pushl  0x20(%ebp)
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	ff d0                	call   *%eax
  800ad2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad5:	ff 4d 1c             	decl   0x1c(%ebp)
  800ad8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800adc:	7f e6                	jg     800ac4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ade:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ae1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aec:	53                   	push   %ebx
  800aed:	51                   	push   %ecx
  800aee:	52                   	push   %edx
  800aef:	50                   	push   %eax
  800af0:	e8 57 19 00 00       	call   80244c <__umoddi3>
  800af5:	83 c4 10             	add    $0x10,%esp
  800af8:	05 34 2b 80 00       	add    $0x802b34,%eax
  800afd:	8a 00                	mov    (%eax),%al
  800aff:	0f be c0             	movsbl %al,%eax
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	50                   	push   %eax
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
}
  800b11:	90                   	nop
  800b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b15:	c9                   	leave  
  800b16:	c3                   	ret    

00800b17 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b1e:	7e 1c                	jle    800b3c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	8d 50 08             	lea    0x8(%eax),%edx
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 10                	mov    %edx,(%eax)
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	83 e8 08             	sub    $0x8,%eax
  800b35:	8b 50 04             	mov    0x4(%eax),%edx
  800b38:	8b 00                	mov    (%eax),%eax
  800b3a:	eb 40                	jmp    800b7c <getuint+0x65>
	else if (lflag)
  800b3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b40:	74 1e                	je     800b60 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8b 00                	mov    (%eax),%eax
  800b47:	8d 50 04             	lea    0x4(%eax),%edx
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 10                	mov    %edx,(%eax)
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	83 e8 04             	sub    $0x4,%eax
  800b57:	8b 00                	mov    (%eax),%eax
  800b59:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5e:	eb 1c                	jmp    800b7c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	8d 50 04             	lea    0x4(%eax),%edx
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	89 10                	mov    %edx,(%eax)
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	83 e8 04             	sub    $0x4,%eax
  800b75:	8b 00                	mov    (%eax),%eax
  800b77:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b81:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b85:	7e 1c                	jle    800ba3 <getint+0x25>
		return va_arg(*ap, long long);
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	8b 00                	mov    (%eax),%eax
  800b8c:	8d 50 08             	lea    0x8(%eax),%edx
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	89 10                	mov    %edx,(%eax)
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	8b 00                	mov    (%eax),%eax
  800b99:	83 e8 08             	sub    $0x8,%eax
  800b9c:	8b 50 04             	mov    0x4(%eax),%edx
  800b9f:	8b 00                	mov    (%eax),%eax
  800ba1:	eb 38                	jmp    800bdb <getint+0x5d>
	else if (lflag)
  800ba3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba7:	74 1a                	je     800bc3 <getint+0x45>
		return va_arg(*ap, long);
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 00                	mov    (%eax),%eax
  800bae:	8d 50 04             	lea    0x4(%eax),%edx
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	89 10                	mov    %edx,(%eax)
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	8b 00                	mov    (%eax),%eax
  800bbb:	83 e8 04             	sub    $0x4,%eax
  800bbe:	8b 00                	mov    (%eax),%eax
  800bc0:	99                   	cltd   
  800bc1:	eb 18                	jmp    800bdb <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8b 00                	mov    (%eax),%eax
  800bc8:	8d 50 04             	lea    0x4(%eax),%edx
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	89 10                	mov    %edx,(%eax)
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	8b 00                	mov    (%eax),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 00                	mov    (%eax),%eax
  800bda:	99                   	cltd   
}
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be5:	eb 17                	jmp    800bfe <vprintfmt+0x21>
			if (ch == '\0')
  800be7:	85 db                	test   %ebx,%ebx
  800be9:	0f 84 af 03 00 00    	je     800f9e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bef:	83 ec 08             	sub    $0x8,%esp
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	53                   	push   %ebx
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800c01:	8d 50 01             	lea    0x1(%eax),%edx
  800c04:	89 55 10             	mov    %edx,0x10(%ebp)
  800c07:	8a 00                	mov    (%eax),%al
  800c09:	0f b6 d8             	movzbl %al,%ebx
  800c0c:	83 fb 25             	cmp    $0x25,%ebx
  800c0f:	75 d6                	jne    800be7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c11:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c15:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c23:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c2a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c31:	8b 45 10             	mov    0x10(%ebp),%eax
  800c34:	8d 50 01             	lea    0x1(%eax),%edx
  800c37:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3a:	8a 00                	mov    (%eax),%al
  800c3c:	0f b6 d8             	movzbl %al,%ebx
  800c3f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c42:	83 f8 55             	cmp    $0x55,%eax
  800c45:	0f 87 2b 03 00 00    	ja     800f76 <vprintfmt+0x399>
  800c4b:	8b 04 85 58 2b 80 00 	mov    0x802b58(,%eax,4),%eax
  800c52:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c54:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c58:	eb d7                	jmp    800c31 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c5a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c5e:	eb d1                	jmp    800c31 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c60:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c6a:	89 d0                	mov    %edx,%eax
  800c6c:	c1 e0 02             	shl    $0x2,%eax
  800c6f:	01 d0                	add    %edx,%eax
  800c71:	01 c0                	add    %eax,%eax
  800c73:	01 d8                	add    %ebx,%eax
  800c75:	83 e8 30             	sub    $0x30,%eax
  800c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c83:	83 fb 2f             	cmp    $0x2f,%ebx
  800c86:	7e 3e                	jle    800cc6 <vprintfmt+0xe9>
  800c88:	83 fb 39             	cmp    $0x39,%ebx
  800c8b:	7f 39                	jg     800cc6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c90:	eb d5                	jmp    800c67 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c92:	8b 45 14             	mov    0x14(%ebp),%eax
  800c95:	83 c0 04             	add    $0x4,%eax
  800c98:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9e:	83 e8 04             	sub    $0x4,%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ca8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cac:	79 83                	jns    800c31 <vprintfmt+0x54>
				width = 0;
  800cae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cb5:	e9 77 ff ff ff       	jmp    800c31 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cba:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cc1:	e9 6b ff ff ff       	jmp    800c31 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cc6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ccb:	0f 89 60 ff ff ff    	jns    800c31 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cde:	e9 4e ff ff ff       	jmp    800c31 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ce3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ce6:	e9 46 ff ff ff       	jmp    800c31 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cee:	83 c0 04             	add    $0x4,%eax
  800cf1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf7:	83 e8 04             	sub    $0x4,%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	50                   	push   %eax
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	ff d0                	call   *%eax
  800d08:	83 c4 10             	add    $0x10,%esp
			break;
  800d0b:	e9 89 02 00 00       	jmp    800f99 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d10:	8b 45 14             	mov    0x14(%ebp),%eax
  800d13:	83 c0 04             	add    $0x4,%eax
  800d16:	89 45 14             	mov    %eax,0x14(%ebp)
  800d19:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1c:	83 e8 04             	sub    $0x4,%eax
  800d1f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d21:	85 db                	test   %ebx,%ebx
  800d23:	79 02                	jns    800d27 <vprintfmt+0x14a>
				err = -err;
  800d25:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d27:	83 fb 64             	cmp    $0x64,%ebx
  800d2a:	7f 0b                	jg     800d37 <vprintfmt+0x15a>
  800d2c:	8b 34 9d a0 29 80 00 	mov    0x8029a0(,%ebx,4),%esi
  800d33:	85 f6                	test   %esi,%esi
  800d35:	75 19                	jne    800d50 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d37:	53                   	push   %ebx
  800d38:	68 45 2b 80 00       	push   $0x802b45
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	ff 75 08             	pushl  0x8(%ebp)
  800d43:	e8 5e 02 00 00       	call   800fa6 <printfmt>
  800d48:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d4b:	e9 49 02 00 00       	jmp    800f99 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d50:	56                   	push   %esi
  800d51:	68 4e 2b 80 00       	push   $0x802b4e
  800d56:	ff 75 0c             	pushl  0xc(%ebp)
  800d59:	ff 75 08             	pushl  0x8(%ebp)
  800d5c:	e8 45 02 00 00       	call   800fa6 <printfmt>
  800d61:	83 c4 10             	add    $0x10,%esp
			break;
  800d64:	e9 30 02 00 00       	jmp    800f99 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d69:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6c:	83 c0 04             	add    $0x4,%eax
  800d6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d72:	8b 45 14             	mov    0x14(%ebp),%eax
  800d75:	83 e8 04             	sub    $0x4,%eax
  800d78:	8b 30                	mov    (%eax),%esi
  800d7a:	85 f6                	test   %esi,%esi
  800d7c:	75 05                	jne    800d83 <vprintfmt+0x1a6>
				p = "(null)";
  800d7e:	be 51 2b 80 00       	mov    $0x802b51,%esi
			if (width > 0 && padc != '-')
  800d83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d87:	7e 6d                	jle    800df6 <vprintfmt+0x219>
  800d89:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d8d:	74 67                	je     800df6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d92:	83 ec 08             	sub    $0x8,%esp
  800d95:	50                   	push   %eax
  800d96:	56                   	push   %esi
  800d97:	e8 12 05 00 00       	call   8012ae <strnlen>
  800d9c:	83 c4 10             	add    $0x10,%esp
  800d9f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800da2:	eb 16                	jmp    800dba <vprintfmt+0x1dd>
					putch(padc, putdat);
  800da4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	50                   	push   %eax
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e4                	jg     800da4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc0:	eb 34                	jmp    800df6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dc6:	74 1c                	je     800de4 <vprintfmt+0x207>
  800dc8:	83 fb 1f             	cmp    $0x1f,%ebx
  800dcb:	7e 05                	jle    800dd2 <vprintfmt+0x1f5>
  800dcd:	83 fb 7e             	cmp    $0x7e,%ebx
  800dd0:	7e 12                	jle    800de4 <vprintfmt+0x207>
					putch('?', putdat);
  800dd2:	83 ec 08             	sub    $0x8,%esp
  800dd5:	ff 75 0c             	pushl  0xc(%ebp)
  800dd8:	6a 3f                	push   $0x3f
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	ff d0                	call   *%eax
  800ddf:	83 c4 10             	add    $0x10,%esp
  800de2:	eb 0f                	jmp    800df3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	53                   	push   %ebx
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	ff d0                	call   *%eax
  800df0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df3:	ff 4d e4             	decl   -0x1c(%ebp)
  800df6:	89 f0                	mov    %esi,%eax
  800df8:	8d 70 01             	lea    0x1(%eax),%esi
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	0f be d8             	movsbl %al,%ebx
  800e00:	85 db                	test   %ebx,%ebx
  800e02:	74 24                	je     800e28 <vprintfmt+0x24b>
  800e04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e08:	78 b8                	js     800dc2 <vprintfmt+0x1e5>
  800e0a:	ff 4d e0             	decl   -0x20(%ebp)
  800e0d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e11:	79 af                	jns    800dc2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e13:	eb 13                	jmp    800e28 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	6a 20                	push   $0x20
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	ff d0                	call   *%eax
  800e22:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e25:	ff 4d e4             	decl   -0x1c(%ebp)
  800e28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2c:	7f e7                	jg     800e15 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e2e:	e9 66 01 00 00       	jmp    800f99 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e33:	83 ec 08             	sub    $0x8,%esp
  800e36:	ff 75 e8             	pushl  -0x18(%ebp)
  800e39:	8d 45 14             	lea    0x14(%ebp),%eax
  800e3c:	50                   	push   %eax
  800e3d:	e8 3c fd ff ff       	call   800b7e <getint>
  800e42:	83 c4 10             	add    $0x10,%esp
  800e45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e51:	85 d2                	test   %edx,%edx
  800e53:	79 23                	jns    800e78 <vprintfmt+0x29b>
				putch('-', putdat);
  800e55:	83 ec 08             	sub    $0x8,%esp
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	6a 2d                	push   $0x2d
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	ff d0                	call   *%eax
  800e62:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6b:	f7 d8                	neg    %eax
  800e6d:	83 d2 00             	adc    $0x0,%edx
  800e70:	f7 da                	neg    %edx
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e78:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7f:	e9 bc 00 00 00       	jmp    800f40 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8d:	50                   	push   %eax
  800e8e:	e8 84 fc ff ff       	call   800b17 <getuint>
  800e93:	83 c4 10             	add    $0x10,%esp
  800e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e9c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ea3:	e9 98 00 00 00       	jmp    800f40 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	6a 58                	push   $0x58
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	ff d0                	call   *%eax
  800eb5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	ff 75 0c             	pushl  0xc(%ebp)
  800ebe:	6a 58                	push   $0x58
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	ff d0                	call   *%eax
  800ec5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec8:	83 ec 08             	sub    $0x8,%esp
  800ecb:	ff 75 0c             	pushl  0xc(%ebp)
  800ece:	6a 58                	push   $0x58
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
			break;
  800ed8:	e9 bc 00 00 00       	jmp    800f99 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800edd:	83 ec 08             	sub    $0x8,%esp
  800ee0:	ff 75 0c             	pushl  0xc(%ebp)
  800ee3:	6a 30                	push   $0x30
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	ff d0                	call   *%eax
  800eea:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	ff 75 0c             	pushl  0xc(%ebp)
  800ef3:	6a 78                	push   $0x78
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	ff d0                	call   *%eax
  800efa:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800efd:	8b 45 14             	mov    0x14(%ebp),%eax
  800f00:	83 c0 04             	add    $0x4,%eax
  800f03:	89 45 14             	mov    %eax,0x14(%ebp)
  800f06:	8b 45 14             	mov    0x14(%ebp),%eax
  800f09:	83 e8 04             	sub    $0x4,%eax
  800f0c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f18:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f1f:	eb 1f                	jmp    800f40 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	ff 75 e8             	pushl  -0x18(%ebp)
  800f27:	8d 45 14             	lea    0x14(%ebp),%eax
  800f2a:	50                   	push   %eax
  800f2b:	e8 e7 fb ff ff       	call   800b17 <getuint>
  800f30:	83 c4 10             	add    $0x10,%esp
  800f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f40:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f47:	83 ec 04             	sub    $0x4,%esp
  800f4a:	52                   	push   %edx
  800f4b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f4e:	50                   	push   %eax
  800f4f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f52:	ff 75 f0             	pushl  -0x10(%ebp)
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	ff 75 08             	pushl  0x8(%ebp)
  800f5b:	e8 00 fb ff ff       	call   800a60 <printnum>
  800f60:	83 c4 20             	add    $0x20,%esp
			break;
  800f63:	eb 34                	jmp    800f99 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	53                   	push   %ebx
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff d0                	call   *%eax
  800f71:	83 c4 10             	add    $0x10,%esp
			break;
  800f74:	eb 23                	jmp    800f99 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 25                	push   $0x25
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f86:	ff 4d 10             	decl   0x10(%ebp)
  800f89:	eb 03                	jmp    800f8e <vprintfmt+0x3b1>
  800f8b:	ff 4d 10             	decl   0x10(%ebp)
  800f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f91:	48                   	dec    %eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 25                	cmp    $0x25,%al
  800f96:	75 f3                	jne    800f8b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f98:	90                   	nop
		}
	}
  800f99:	e9 47 fc ff ff       	jmp    800be5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f9e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fa2:	5b                   	pop    %ebx
  800fa3:	5e                   	pop    %esi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fac:	8d 45 10             	lea    0x10(%ebp),%eax
  800faf:	83 c0 04             	add    $0x4,%eax
  800fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 08             	pushl  0x8(%ebp)
  800fc2:	e8 16 fc ff ff       	call   800bdd <vprintfmt>
  800fc7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fca:	90                   	nop
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	8b 40 08             	mov    0x8(%eax),%eax
  800fd6:	8d 50 01             	lea    0x1(%eax),%edx
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	8b 10                	mov    (%eax),%edx
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	8b 40 04             	mov    0x4(%eax),%eax
  800fea:	39 c2                	cmp    %eax,%edx
  800fec:	73 12                	jae    801000 <sprintputch+0x33>
		*b->buf++ = ch;
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 00                	mov    (%eax),%eax
  800ff3:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff9:	89 0a                	mov    %ecx,(%edx)
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	88 10                	mov    %dl,(%eax)
}
  801000:	90                   	nop
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	8d 50 ff             	lea    -0x1(%eax),%edx
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	01 d0                	add    %edx,%eax
  80101a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801024:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801028:	74 06                	je     801030 <vsnprintf+0x2d>
  80102a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102e:	7f 07                	jg     801037 <vsnprintf+0x34>
		return -E_INVAL;
  801030:	b8 03 00 00 00       	mov    $0x3,%eax
  801035:	eb 20                	jmp    801057 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801037:	ff 75 14             	pushl  0x14(%ebp)
  80103a:	ff 75 10             	pushl  0x10(%ebp)
  80103d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801040:	50                   	push   %eax
  801041:	68 cd 0f 80 00       	push   $0x800fcd
  801046:	e8 92 fb ff ff       	call   800bdd <vprintfmt>
  80104b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80104e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801051:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801054:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80105f:	8d 45 10             	lea    0x10(%ebp),%eax
  801062:	83 c0 04             	add    $0x4,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	ff 75 f4             	pushl  -0xc(%ebp)
  80106e:	50                   	push   %eax
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	ff 75 08             	pushl  0x8(%ebp)
  801075:	e8 89 ff ff ff       	call   801003 <vsnprintf>
  80107a:	83 c4 10             	add    $0x10,%esp
  80107d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801080:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801083:	c9                   	leave  
  801084:	c3                   	ret    

00801085 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80108b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80108f:	74 13                	je     8010a4 <readline+0x1f>
		cprintf("%s", prompt);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 08             	pushl  0x8(%ebp)
  801097:	68 b0 2c 80 00       	push   $0x802cb0
  80109c:	e8 62 f9 ff ff       	call   800a03 <cprintf>
  8010a1:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ab:	83 ec 0c             	sub    $0xc,%esp
  8010ae:	6a 00                	push   $0x0
  8010b0:	e8 5d f5 ff ff       	call   800612 <iscons>
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010bb:	e8 04 f5 ff ff       	call   8005c4 <getchar>
  8010c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010c7:	79 22                	jns    8010eb <readline+0x66>
			if (c != -E_EOF)
  8010c9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010cd:	0f 84 ad 00 00 00    	je     801180 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8010d9:	68 b3 2c 80 00       	push   $0x802cb3
  8010de:	e8 20 f9 ff ff       	call   800a03 <cprintf>
  8010e3:	83 c4 10             	add    $0x10,%esp
			return;
  8010e6:	e9 95 00 00 00       	jmp    801180 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010eb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010ef:	7e 34                	jle    801125 <readline+0xa0>
  8010f1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010f8:	7f 2b                	jg     801125 <readline+0xa0>
			if (echoing)
  8010fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010fe:	74 0e                	je     80110e <readline+0x89>
				cputchar(c);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	ff 75 ec             	pushl  -0x14(%ebp)
  801106:	e8 71 f4 ff ff       	call   80057c <cputchar>
  80110b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80110e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801111:	8d 50 01             	lea    0x1(%eax),%edx
  801114:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801117:	89 c2                	mov    %eax,%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 d0                	add    %edx,%eax
  80111e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801121:	88 10                	mov    %dl,(%eax)
  801123:	eb 56                	jmp    80117b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801125:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801129:	75 1f                	jne    80114a <readline+0xc5>
  80112b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80112f:	7e 19                	jle    80114a <readline+0xc5>
			if (echoing)
  801131:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801135:	74 0e                	je     801145 <readline+0xc0>
				cputchar(c);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 ec             	pushl  -0x14(%ebp)
  80113d:	e8 3a f4 ff ff       	call   80057c <cputchar>
  801142:	83 c4 10             	add    $0x10,%esp

			i--;
  801145:	ff 4d f4             	decl   -0xc(%ebp)
  801148:	eb 31                	jmp    80117b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80114a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80114e:	74 0a                	je     80115a <readline+0xd5>
  801150:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801154:	0f 85 61 ff ff ff    	jne    8010bb <readline+0x36>
			if (echoing)
  80115a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80115e:	74 0e                	je     80116e <readline+0xe9>
				cputchar(c);
  801160:	83 ec 0c             	sub    $0xc,%esp
  801163:	ff 75 ec             	pushl  -0x14(%ebp)
  801166:	e8 11 f4 ff ff       	call   80057c <cputchar>
  80116b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80116e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	01 d0                	add    %edx,%eax
  801176:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801179:	eb 06                	jmp    801181 <readline+0xfc>
		}
	}
  80117b:	e9 3b ff ff ff       	jmp    8010bb <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801180:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801189:	e8 8a 0d 00 00       	call   801f18 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  80118e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801192:	74 13                	je     8011a7 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	68 b0 2c 80 00       	push   $0x802cb0
  80119f:	e8 5f f8 ff ff       	call   800a03 <cprintf>
  8011a4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011ae:	83 ec 0c             	sub    $0xc,%esp
  8011b1:	6a 00                	push   $0x0
  8011b3:	e8 5a f4 ff ff       	call   800612 <iscons>
  8011b8:	83 c4 10             	add    $0x10,%esp
  8011bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011be:	e8 01 f4 ff ff       	call   8005c4 <getchar>
  8011c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011ca:	79 23                	jns    8011ef <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011cc:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011d0:	74 13                	je     8011e5 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011d2:	83 ec 08             	sub    $0x8,%esp
  8011d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011d8:	68 b3 2c 80 00       	push   $0x802cb3
  8011dd:	e8 21 f8 ff ff       	call   800a03 <cprintf>
  8011e2:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011e5:	e8 48 0d 00 00       	call   801f32 <sys_enable_interrupt>
			return;
  8011ea:	e9 9a 00 00 00       	jmp    801289 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011ef:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011f3:	7e 34                	jle    801229 <atomic_readline+0xa6>
  8011f5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011fc:	7f 2b                	jg     801229 <atomic_readline+0xa6>
			if (echoing)
  8011fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801202:	74 0e                	je     801212 <atomic_readline+0x8f>
				cputchar(c);
  801204:	83 ec 0c             	sub    $0xc,%esp
  801207:	ff 75 ec             	pushl  -0x14(%ebp)
  80120a:	e8 6d f3 ff ff       	call   80057c <cputchar>
  80120f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801215:	8d 50 01             	lea    0x1(%eax),%edx
  801218:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80121b:	89 c2                	mov    %eax,%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
  801227:	eb 5b                	jmp    801284 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801229:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80122d:	75 1f                	jne    80124e <atomic_readline+0xcb>
  80122f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801233:	7e 19                	jle    80124e <atomic_readline+0xcb>
			if (echoing)
  801235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801239:	74 0e                	je     801249 <atomic_readline+0xc6>
				cputchar(c);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	e8 36 f3 ff ff       	call   80057c <cputchar>
  801246:	83 c4 10             	add    $0x10,%esp
			i--;
  801249:	ff 4d f4             	decl   -0xc(%ebp)
  80124c:	eb 36                	jmp    801284 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80124e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801252:	74 0a                	je     80125e <atomic_readline+0xdb>
  801254:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801258:	0f 85 60 ff ff ff    	jne    8011be <atomic_readline+0x3b>
			if (echoing)
  80125e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801262:	74 0e                	je     801272 <atomic_readline+0xef>
				cputchar(c);
  801264:	83 ec 0c             	sub    $0xc,%esp
  801267:	ff 75 ec             	pushl  -0x14(%ebp)
  80126a:	e8 0d f3 ff ff       	call   80057c <cputchar>
  80126f:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801272:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80127d:	e8 b0 0c 00 00       	call   801f32 <sys_enable_interrupt>
			return;
  801282:	eb 05                	jmp    801289 <atomic_readline+0x106>
		}
	}
  801284:	e9 35 ff ff ff       	jmp    8011be <atomic_readline+0x3b>
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801298:	eb 06                	jmp    8012a0 <strlen+0x15>
		n++;
  80129a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80129d:	ff 45 08             	incl   0x8(%ebp)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	84 c0                	test   %al,%al
  8012a7:	75 f1                	jne    80129a <strlen+0xf>
		n++;
	return n;
  8012a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012bb:	eb 09                	jmp    8012c6 <strnlen+0x18>
		n++;
  8012bd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c0:	ff 45 08             	incl   0x8(%ebp)
  8012c3:	ff 4d 0c             	decl   0xc(%ebp)
  8012c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012ca:	74 09                	je     8012d5 <strnlen+0x27>
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	84 c0                	test   %al,%al
  8012d3:	75 e8                	jne    8012bd <strnlen+0xf>
		n++;
	return n;
  8012d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012e6:	90                   	nop
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8d 50 01             	lea    0x1(%eax),%edx
  8012ed:	89 55 08             	mov    %edx,0x8(%ebp)
  8012f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012f9:	8a 12                	mov    (%edx),%dl
  8012fb:	88 10                	mov    %dl,(%eax)
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	84 c0                	test   %al,%al
  801301:	75 e4                	jne    8012e7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801303:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80131b:	eb 1f                	jmp    80133c <strncpy+0x34>
		*dst++ = *src;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8d 50 01             	lea    0x1(%eax),%edx
  801323:	89 55 08             	mov    %edx,0x8(%ebp)
  801326:	8b 55 0c             	mov    0xc(%ebp),%edx
  801329:	8a 12                	mov    (%edx),%dl
  80132b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	84 c0                	test   %al,%al
  801334:	74 03                	je     801339 <strncpy+0x31>
			src++;
  801336:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801339:	ff 45 fc             	incl   -0x4(%ebp)
  80133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801342:	72 d9                	jb     80131d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801344:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801355:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801359:	74 30                	je     80138b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80135b:	eb 16                	jmp    801373 <strlcpy+0x2a>
			*dst++ = *src++;
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	8d 50 01             	lea    0x1(%eax),%edx
  801363:	89 55 08             	mov    %edx,0x8(%ebp)
  801366:	8b 55 0c             	mov    0xc(%ebp),%edx
  801369:	8d 4a 01             	lea    0x1(%edx),%ecx
  80136c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80136f:	8a 12                	mov    (%edx),%dl
  801371:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801373:	ff 4d 10             	decl   0x10(%ebp)
  801376:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137a:	74 09                	je     801385 <strlcpy+0x3c>
  80137c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137f:	8a 00                	mov    (%eax),%al
  801381:	84 c0                	test   %al,%al
  801383:	75 d8                	jne    80135d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80138b:	8b 55 08             	mov    0x8(%ebp),%edx
  80138e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801391:	29 c2                	sub    %eax,%edx
  801393:	89 d0                	mov    %edx,%eax
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80139a:	eb 06                	jmp    8013a2 <strcmp+0xb>
		p++, q++;
  80139c:	ff 45 08             	incl   0x8(%ebp)
  80139f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	84 c0                	test   %al,%al
  8013a9:	74 0e                	je     8013b9 <strcmp+0x22>
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	8a 10                	mov    (%eax),%dl
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	38 c2                	cmp    %al,%dl
  8013b7:	74 e3                	je     80139c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8a 00                	mov    (%eax),%al
  8013be:	0f b6 d0             	movzbl %al,%edx
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	0f b6 c0             	movzbl %al,%eax
  8013c9:	29 c2                	sub    %eax,%edx
  8013cb:	89 d0                	mov    %edx,%eax
}
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    

008013cf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013d2:	eb 09                	jmp    8013dd <strncmp+0xe>
		n--, p++, q++;
  8013d4:	ff 4d 10             	decl   0x10(%ebp)
  8013d7:	ff 45 08             	incl   0x8(%ebp)
  8013da:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	74 17                	je     8013fa <strncmp+0x2b>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	84 c0                	test   %al,%al
  8013ea:	74 0e                	je     8013fa <strncmp+0x2b>
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 10                	mov    (%eax),%dl
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	38 c2                	cmp    %al,%dl
  8013f8:	74 da                	je     8013d4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fe:	75 07                	jne    801407 <strncmp+0x38>
		return 0;
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	eb 14                	jmp    80141b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	0f b6 d0             	movzbl %al,%edx
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	0f b6 c0             	movzbl %al,%eax
  801417:	29 c2                	sub    %eax,%edx
  801419:	89 d0                	mov    %edx,%eax
}
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	8b 45 0c             	mov    0xc(%ebp),%eax
  801426:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801429:	eb 12                	jmp    80143d <strchr+0x20>
		if (*s == c)
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801433:	75 05                	jne    80143a <strchr+0x1d>
			return (char *) s;
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	eb 11                	jmp    80144b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80143a:	ff 45 08             	incl   0x8(%ebp)
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	84 c0                	test   %al,%al
  801444:	75 e5                	jne    80142b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801446:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 04             	sub    $0x4,%esp
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801459:	eb 0d                	jmp    801468 <strfind+0x1b>
		if (*s == c)
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801463:	74 0e                	je     801473 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801465:	ff 45 08             	incl   0x8(%ebp)
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8a 00                	mov    (%eax),%al
  80146d:	84 c0                	test   %al,%al
  80146f:	75 ea                	jne    80145b <strfind+0xe>
  801471:	eb 01                	jmp    801474 <strfind+0x27>
		if (*s == c)
			break;
  801473:	90                   	nop
	return (char *) s;
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801485:	8b 45 10             	mov    0x10(%ebp),%eax
  801488:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80148b:	eb 0e                	jmp    80149b <memset+0x22>
		*p++ = c;
  80148d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801490:	8d 50 01             	lea    0x1(%eax),%edx
  801493:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801496:	8b 55 0c             	mov    0xc(%ebp),%edx
  801499:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80149b:	ff 4d f8             	decl   -0x8(%ebp)
  80149e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014a2:	79 e9                	jns    80148d <memset+0x14>
		*p++ = c;

	return v;
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014bb:	eb 16                	jmp    8014d3 <memcpy+0x2a>
		*d++ = *s++;
  8014bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	75 dd                	jne    8014bd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014fd:	73 50                	jae    80154f <memmove+0x6a>
  8014ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150a:	76 43                	jbe    80154f <memmove+0x6a>
		s += n;
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801512:	8b 45 10             	mov    0x10(%ebp),%eax
  801515:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801518:	eb 10                	jmp    80152a <memmove+0x45>
			*--d = *--s;
  80151a:	ff 4d f8             	decl   -0x8(%ebp)
  80151d:	ff 4d fc             	decl   -0x4(%ebp)
  801520:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801523:	8a 10                	mov    (%eax),%dl
  801525:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801528:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80152a:	8b 45 10             	mov    0x10(%ebp),%eax
  80152d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801530:	89 55 10             	mov    %edx,0x10(%ebp)
  801533:	85 c0                	test   %eax,%eax
  801535:	75 e3                	jne    80151a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801537:	eb 23                	jmp    80155c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801539:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153c:	8d 50 01             	lea    0x1(%eax),%edx
  80153f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801542:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801545:	8d 4a 01             	lea    0x1(%edx),%ecx
  801548:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80154b:	8a 12                	mov    (%edx),%dl
  80154d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80154f:	8b 45 10             	mov    0x10(%ebp),%eax
  801552:	8d 50 ff             	lea    -0x1(%eax),%edx
  801555:	89 55 10             	mov    %edx,0x10(%ebp)
  801558:	85 c0                	test   %eax,%eax
  80155a:	75 dd                	jne    801539 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80156d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801570:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801573:	eb 2a                	jmp    80159f <memcmp+0x3e>
		if (*s1 != *s2)
  801575:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801578:	8a 10                	mov    (%eax),%dl
  80157a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157d:	8a 00                	mov    (%eax),%al
  80157f:	38 c2                	cmp    %al,%dl
  801581:	74 16                	je     801599 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801583:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	0f b6 d0             	movzbl %al,%edx
  80158b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	0f b6 c0             	movzbl %al,%eax
  801593:	29 c2                	sub    %eax,%edx
  801595:	89 d0                	mov    %edx,%eax
  801597:	eb 18                	jmp    8015b1 <memcmp+0x50>
		s1++, s2++;
  801599:	ff 45 fc             	incl   -0x4(%ebp)
  80159c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80159f:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	75 c9                	jne    801575 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	01 d0                	add    %edx,%eax
  8015c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015c4:	eb 15                	jmp    8015db <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	0f b6 d0             	movzbl %al,%edx
  8015ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d1:	0f b6 c0             	movzbl %al,%eax
  8015d4:	39 c2                	cmp    %eax,%edx
  8015d6:	74 0d                	je     8015e5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015d8:	ff 45 08             	incl   0x8(%ebp)
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015e1:	72 e3                	jb     8015c6 <memfind+0x13>
  8015e3:	eb 01                	jmp    8015e6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015e5:	90                   	nop
	return (void *) s;
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ff:	eb 03                	jmp    801604 <strtol+0x19>
		s++;
  801601:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 20                	cmp    $0x20,%al
  80160b:	74 f4                	je     801601 <strtol+0x16>
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3c 09                	cmp    $0x9,%al
  801614:	74 eb                	je     801601 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8a 00                	mov    (%eax),%al
  80161b:	3c 2b                	cmp    $0x2b,%al
  80161d:	75 05                	jne    801624 <strtol+0x39>
		s++;
  80161f:	ff 45 08             	incl   0x8(%ebp)
  801622:	eb 13                	jmp    801637 <strtol+0x4c>
	else if (*s == '-')
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	3c 2d                	cmp    $0x2d,%al
  80162b:	75 0a                	jne    801637 <strtol+0x4c>
		s++, neg = 1;
  80162d:	ff 45 08             	incl   0x8(%ebp)
  801630:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801637:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163b:	74 06                	je     801643 <strtol+0x58>
  80163d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801641:	75 20                	jne    801663 <strtol+0x78>
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	3c 30                	cmp    $0x30,%al
  80164a:	75 17                	jne    801663 <strtol+0x78>
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	40                   	inc    %eax
  801650:	8a 00                	mov    (%eax),%al
  801652:	3c 78                	cmp    $0x78,%al
  801654:	75 0d                	jne    801663 <strtol+0x78>
		s += 2, base = 16;
  801656:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80165a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801661:	eb 28                	jmp    80168b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801663:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801667:	75 15                	jne    80167e <strtol+0x93>
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	8a 00                	mov    (%eax),%al
  80166e:	3c 30                	cmp    $0x30,%al
  801670:	75 0c                	jne    80167e <strtol+0x93>
		s++, base = 8;
  801672:	ff 45 08             	incl   0x8(%ebp)
  801675:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80167c:	eb 0d                	jmp    80168b <strtol+0xa0>
	else if (base == 0)
  80167e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801682:	75 07                	jne    80168b <strtol+0xa0>
		base = 10;
  801684:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	3c 2f                	cmp    $0x2f,%al
  801692:	7e 19                	jle    8016ad <strtol+0xc2>
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	8a 00                	mov    (%eax),%al
  801699:	3c 39                	cmp    $0x39,%al
  80169b:	7f 10                	jg     8016ad <strtol+0xc2>
			dig = *s - '0';
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	0f be c0             	movsbl %al,%eax
  8016a5:	83 e8 30             	sub    $0x30,%eax
  8016a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ab:	eb 42                	jmp    8016ef <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8a 00                	mov    (%eax),%al
  8016b2:	3c 60                	cmp    $0x60,%al
  8016b4:	7e 19                	jle    8016cf <strtol+0xe4>
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	8a 00                	mov    (%eax),%al
  8016bb:	3c 7a                	cmp    $0x7a,%al
  8016bd:	7f 10                	jg     8016cf <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	0f be c0             	movsbl %al,%eax
  8016c7:	83 e8 57             	sub    $0x57,%eax
  8016ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016cd:	eb 20                	jmp    8016ef <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	3c 40                	cmp    $0x40,%al
  8016d6:	7e 39                	jle    801711 <strtol+0x126>
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	8a 00                	mov    (%eax),%al
  8016dd:	3c 5a                	cmp    $0x5a,%al
  8016df:	7f 30                	jg     801711 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	0f be c0             	movsbl %al,%eax
  8016e9:	83 e8 37             	sub    $0x37,%eax
  8016ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016f5:	7d 19                	jge    801710 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016f7:	ff 45 08             	incl   0x8(%ebp)
  8016fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016fd:	0f af 45 10          	imul   0x10(%ebp),%eax
  801701:	89 c2                	mov    %eax,%edx
  801703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801706:	01 d0                	add    %edx,%eax
  801708:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80170b:	e9 7b ff ff ff       	jmp    80168b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801710:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801715:	74 08                	je     80171f <strtol+0x134>
		*endptr = (char *) s;
  801717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171a:	8b 55 08             	mov    0x8(%ebp),%edx
  80171d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80171f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801723:	74 07                	je     80172c <strtol+0x141>
  801725:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801728:	f7 d8                	neg    %eax
  80172a:	eb 03                	jmp    80172f <strtol+0x144>
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <ltostr>:

void
ltostr(long value, char *str)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801737:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80173e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801745:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801749:	79 13                	jns    80175e <ltostr+0x2d>
	{
		neg = 1;
  80174b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801758:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80175b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801766:	99                   	cltd   
  801767:	f7 f9                	idiv   %ecx
  801769:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80176c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176f:	8d 50 01             	lea    0x1(%eax),%edx
  801772:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801775:	89 c2                	mov    %eax,%edx
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	01 d0                	add    %edx,%eax
  80177c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80177f:	83 c2 30             	add    $0x30,%edx
  801782:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801784:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801787:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80178c:	f7 e9                	imul   %ecx
  80178e:	c1 fa 02             	sar    $0x2,%edx
  801791:	89 c8                	mov    %ecx,%eax
  801793:	c1 f8 1f             	sar    $0x1f,%eax
  801796:	29 c2                	sub    %eax,%edx
  801798:	89 d0                	mov    %edx,%eax
  80179a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80179d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017a5:	f7 e9                	imul   %ecx
  8017a7:	c1 fa 02             	sar    $0x2,%edx
  8017aa:	89 c8                	mov    %ecx,%eax
  8017ac:	c1 f8 1f             	sar    $0x1f,%eax
  8017af:	29 c2                	sub    %eax,%edx
  8017b1:	89 d0                	mov    %edx,%eax
  8017b3:	c1 e0 02             	shl    $0x2,%eax
  8017b6:	01 d0                	add    %edx,%eax
  8017b8:	01 c0                	add    %eax,%eax
  8017ba:	29 c1                	sub    %eax,%ecx
  8017bc:	89 ca                	mov    %ecx,%edx
  8017be:	85 d2                	test   %edx,%edx
  8017c0:	75 9c                	jne    80175e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cc:	48                   	dec    %eax
  8017cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017d4:	74 3d                	je     801813 <ltostr+0xe2>
		start = 1 ;
  8017d6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017dd:	eb 34                	jmp    801813 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	01 d0                	add    %edx,%eax
  8017e7:	8a 00                	mov    (%eax),%al
  8017e9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f2:	01 c2                	add    %eax,%edx
  8017f4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fa:	01 c8                	add    %ecx,%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801800:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	01 c2                	add    %eax,%edx
  801808:	8a 45 eb             	mov    -0x15(%ebp),%al
  80180b:	88 02                	mov    %al,(%edx)
		start++ ;
  80180d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801810:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801816:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801819:	7c c4                	jl     8017df <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80181b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80181e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801821:	01 d0                	add    %edx,%eax
  801823:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801826:	90                   	nop
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	e8 54 fa ff ff       	call   80128b <strlen>
  801837:	83 c4 04             	add    $0x4,%esp
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	e8 46 fa ff ff       	call   80128b <strlen>
  801845:	83 c4 04             	add    $0x4,%esp
  801848:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80184b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801852:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801859:	eb 17                	jmp    801872 <strcconcat+0x49>
		final[s] = str1[s] ;
  80185b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80185e:	8b 45 10             	mov    0x10(%ebp),%eax
  801861:	01 c2                	add    %eax,%edx
  801863:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	01 c8                	add    %ecx,%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80186f:	ff 45 fc             	incl   -0x4(%ebp)
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801878:	7c e1                	jl     80185b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80187a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801881:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801888:	eb 1f                	jmp    8018a9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80188a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80188d:	8d 50 01             	lea    0x1(%eax),%edx
  801890:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801893:	89 c2                	mov    %eax,%edx
  801895:	8b 45 10             	mov    0x10(%ebp),%eax
  801898:	01 c2                	add    %eax,%edx
  80189a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80189d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a0:	01 c8                	add    %ecx,%eax
  8018a2:	8a 00                	mov    (%eax),%al
  8018a4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018a6:	ff 45 f8             	incl   -0x8(%ebp)
  8018a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018af:	7c d9                	jl     80188a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	c6 00 00             	movb   $0x0,(%eax)
}
  8018bc:	90                   	nop
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ce:	8b 00                	mov    (%eax),%eax
  8018d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018e2:	eb 0c                	jmp    8018f0 <strsplit+0x31>
			*string++ = 0;
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	8d 50 01             	lea    0x1(%eax),%edx
  8018ea:	89 55 08             	mov    %edx,0x8(%ebp)
  8018ed:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	84 c0                	test   %al,%al
  8018f7:	74 18                	je     801911 <strsplit+0x52>
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	0f be c0             	movsbl %al,%eax
  801901:	50                   	push   %eax
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	e8 13 fb ff ff       	call   80141d <strchr>
  80190a:	83 c4 08             	add    $0x8,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	75 d3                	jne    8018e4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	8a 00                	mov    (%eax),%al
  801916:	84 c0                	test   %al,%al
  801918:	74 5a                	je     801974 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80191a:	8b 45 14             	mov    0x14(%ebp),%eax
  80191d:	8b 00                	mov    (%eax),%eax
  80191f:	83 f8 0f             	cmp    $0xf,%eax
  801922:	75 07                	jne    80192b <strsplit+0x6c>
		{
			return 0;
  801924:	b8 00 00 00 00       	mov    $0x0,%eax
  801929:	eb 66                	jmp    801991 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80192b:	8b 45 14             	mov    0x14(%ebp),%eax
  80192e:	8b 00                	mov    (%eax),%eax
  801930:	8d 48 01             	lea    0x1(%eax),%ecx
  801933:	8b 55 14             	mov    0x14(%ebp),%edx
  801936:	89 0a                	mov    %ecx,(%edx)
  801938:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80193f:	8b 45 10             	mov    0x10(%ebp),%eax
  801942:	01 c2                	add    %eax,%edx
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801949:	eb 03                	jmp    80194e <strsplit+0x8f>
			string++;
  80194b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8a 00                	mov    (%eax),%al
  801953:	84 c0                	test   %al,%al
  801955:	74 8b                	je     8018e2 <strsplit+0x23>
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	0f be c0             	movsbl %al,%eax
  80195f:	50                   	push   %eax
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	e8 b5 fa ff ff       	call   80141d <strchr>
  801968:	83 c4 08             	add    $0x8,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	74 dc                	je     80194b <strsplit+0x8c>
			string++;
	}
  80196f:	e9 6e ff ff ff       	jmp    8018e2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801974:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	8b 00                	mov    (%eax),%eax
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 d0                	add    %edx,%eax
  801986:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80198c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <malloc>:
int changes = 0;
int sizeofarray = 0;
uint32 addresses[100000];
int changed[100000];
int numOfPages[100000];
void* malloc(uint32 size) {
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	int num = size / PAGE_SIZE;
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	c1 e8 0c             	shr    $0xc,%eax
  80199f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 return_addres;
	//sizeofarray++;
	if (size % PAGE_SIZE != 0)
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	74 03                	je     8019b1 <malloc+0x1e>
		num++;
  8019ae:	ff 45 f4             	incl   -0xc(%ebp)
//		addresses[sizeofarray] = last_addres;
//		changed[sizeofarray] = 1;
//		sizeofarray++;
//		return (void*) return_addres;
	//} else {
	if (changes == 0) {
  8019b1:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	75 71                	jne    801a2b <malloc+0x98>
		sys_allocateMem(last_addres, size);
  8019ba:	a1 04 30 80 00       	mov    0x803004,%eax
  8019bf:	83 ec 08             	sub    $0x8,%esp
  8019c2:	ff 75 08             	pushl  0x8(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	e8 e4 04 00 00       	call   801eaf <sys_allocateMem>
  8019cb:	83 c4 10             	add    $0x10,%esp
		return_addres = last_addres;
  8019ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8019d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		last_addres += num * PAGE_SIZE;
  8019d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d9:	c1 e0 0c             	shl    $0xc,%eax
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	a1 04 30 80 00       	mov    0x803004,%eax
  8019e3:	01 d0                	add    %edx,%eax
  8019e5:	a3 04 30 80 00       	mov    %eax,0x803004
		numOfPages[sizeofarray] = num;
  8019ea:	a1 30 30 80 00       	mov    0x803030,%eax
  8019ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f2:	89 14 85 20 66 8c 00 	mov    %edx,0x8c6620(,%eax,4)
		addresses[sizeofarray] = return_addres;
  8019f9:	a1 30 30 80 00       	mov    0x803030,%eax
  8019fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a01:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
		changed[sizeofarray] = 1;
  801a08:	a1 30 30 80 00       	mov    0x803030,%eax
  801a0d:	c7 04 85 a0 4b 86 00 	movl   $0x1,0x864ba0(,%eax,4)
  801a14:	01 00 00 00 
		sizeofarray++;
  801a18:	a1 30 30 80 00       	mov    0x803030,%eax
  801a1d:	40                   	inc    %eax
  801a1e:	a3 30 30 80 00       	mov    %eax,0x803030
		return (void*) return_addres;
  801a23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a26:	e9 f7 00 00 00       	jmp    801b22 <malloc+0x18f>
	} else {
		int count = 0;
  801a2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int min = 1000;
  801a32:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
		int index = -1;
  801a39:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		uint32 min_addresss;
		for (uint32 i = USER_HEAP_START; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801a40:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  801a47:	eb 7c                	jmp    801ac5 <malloc+0x132>
		{
			uint32 *pg = NULL;
  801a49:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			for (int j = 0; j < sizeofarray; j++) {
  801a50:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801a57:	eb 1a                	jmp    801a73 <malloc+0xe0>
				if (addresses[j] == i) {
  801a59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a5c:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  801a63:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801a66:	75 08                	jne    801a70 <malloc+0xdd>
					index = j;
  801a68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					break;
  801a6e:	eb 0d                	jmp    801a7d <malloc+0xea>
		int index = -1;
		uint32 min_addresss;
		for (uint32 i = USER_HEAP_START; i < USER_HEAP_MAX; i += PAGE_SIZE)
		{
			uint32 *pg = NULL;
			for (int j = 0; j < sizeofarray; j++) {
  801a70:	ff 45 dc             	incl   -0x24(%ebp)
  801a73:	a1 30 30 80 00       	mov    0x803030,%eax
  801a78:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801a7b:	7c dc                	jl     801a59 <malloc+0xc6>
					index = j;
					break;
				}
			}

			if (index == -1) {
  801a7d:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801a81:	75 05                	jne    801a88 <malloc+0xf5>
				count++;
  801a83:	ff 45 f0             	incl   -0x10(%ebp)
  801a86:	eb 36                	jmp    801abe <malloc+0x12b>
			} else {
				if (changed[index] == 0) {
  801a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a8b:	8b 04 85 a0 4b 86 00 	mov    0x864ba0(,%eax,4),%eax
  801a92:	85 c0                	test   %eax,%eax
  801a94:	75 05                	jne    801a9b <malloc+0x108>
					count++;
  801a96:	ff 45 f0             	incl   -0x10(%ebp)
  801a99:	eb 23                	jmp    801abe <malloc+0x12b>
				} else {
					if (count < min && count >= num) {
  801a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801aa1:	7d 14                	jge    801ab7 <malloc+0x124>
  801aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801aa9:	7c 0c                	jl     801ab7 <malloc+0x124>
						min = count;
  801aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
						min_addresss = i;
  801ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					}
					count = 0;
  801ab7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	} else {
		int count = 0;
		int min = 1000;
		int index = -1;
		uint32 min_addresss;
		for (uint32 i = USER_HEAP_START; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801abe:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801ac5:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801acc:	0f 86 77 ff ff ff    	jbe    801a49 <malloc+0xb6>

			}

		}

		sys_allocateMem(min_addresss, size);
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	ff 75 08             	pushl  0x8(%ebp)
  801ad8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801adb:	e8 cf 03 00 00       	call   801eaf <sys_allocateMem>
  801ae0:	83 c4 10             	add    $0x10,%esp
		numOfPages[sizeofarray] = num;
  801ae3:	a1 30 30 80 00       	mov    0x803030,%eax
  801ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aeb:	89 14 85 20 66 8c 00 	mov    %edx,0x8c6620(,%eax,4)
		addresses[sizeofarray] = last_addres;
  801af2:	a1 30 30 80 00       	mov    0x803030,%eax
  801af7:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801afd:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
		changed[sizeofarray] = 1;
  801b04:	a1 30 30 80 00       	mov    0x803030,%eax
  801b09:	c7 04 85 a0 4b 86 00 	movl   $0x1,0x864ba0(,%eax,4)
  801b10:	01 00 00 00 
		sizeofarray++;
  801b14:	a1 30 30 80 00       	mov    0x803030,%eax
  801b19:	40                   	inc    %eax
  801b1a:	a3 30 30 80 00       	mov    %eax,0x803030
		return (void*) min_addresss;
  801b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

	//refer to the project presentation and documentation for details

	return NULL;

}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 28             	sub    $0x28,%esp
		cprintf("at index %d adders = %x\n", j, addresses[j]);
		cprintf("at index %d the size is %d \n", j, numOfPages[j] * PAGE_SIZE);
	}
	cprintf("---------------------------------------------------\n");*/
	//---------------------------
	uint32 va = (uint32) virtual_address;
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 size;
	int is_found = 0;
  801b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int index;
	for (int i = 0; i < sizeofarray; i++) {
  801b37:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801b3e:	eb 30                	jmp    801b70 <free+0x4c>
		if (addresses[i] == va && changed[i] == 1) {
  801b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b43:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  801b4a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b4d:	75 1e                	jne    801b6d <free+0x49>
  801b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b52:	8b 04 85 a0 4b 86 00 	mov    0x864ba0(,%eax,4),%eax
  801b59:	83 f8 01             	cmp    $0x1,%eax
  801b5c:	75 0f                	jne    801b6d <free+0x49>
			is_found = 1;
  801b5e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
			index = i;
  801b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  801b6b:	eb 0d                	jmp    801b7a <free+0x56>
	//---------------------------
	uint32 va = (uint32) virtual_address;
	uint32 size;
	int is_found = 0;
	int index;
	for (int i = 0; i < sizeofarray; i++) {
  801b6d:	ff 45 ec             	incl   -0x14(%ebp)
  801b70:	a1 30 30 80 00       	mov    0x803030,%eax
  801b75:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801b78:	7c c6                	jl     801b40 <free+0x1c>
			is_found = 1;
			index = i;
			break;
		}
	}
	if (is_found == 1) {
  801b7a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801b7e:	75 4f                	jne    801bcf <free+0xab>
		size = numOfPages[index] * PAGE_SIZE;
  801b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b83:	8b 04 85 20 66 8c 00 	mov    0x8c6620(,%eax,4),%eax
  801b8a:	c1 e0 0c             	shl    $0xc,%eax
  801b8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		cprintf("the size form the free is %d \n", size);
  801b90:	83 ec 08             	sub    $0x8,%esp
  801b93:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b96:	68 c4 2c 80 00       	push   $0x802cc4
  801b9b:	e8 63 ee ff ff       	call   800a03 <cprintf>
  801ba0:	83 c4 10             	add    $0x10,%esp
		sys_freeMem(va, size);
  801ba3:	83 ec 08             	sub    $0x8,%esp
  801ba6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ba9:	ff 75 e8             	pushl  -0x18(%ebp)
  801bac:	e8 e2 02 00 00       	call   801e93 <sys_freeMem>
  801bb1:	83 c4 10             	add    $0x10,%esp
		changed[index] = 0;
  801bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb7:	c7 04 85 a0 4b 86 00 	movl   $0x0,0x864ba0(,%eax,4)
  801bbe:	00 00 00 00 
		changes++;
  801bc2:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801bc7:	40                   	inc    %eax
  801bc8:	a3 2c 30 80 00       	mov    %eax,0x80302c
		sys_freeMem(va, size);
		changed[index] = 0;
	}

	//refer to the project presentation and documentation for details
}
  801bcd:	eb 39                	jmp    801c08 <free+0xe4>
		cprintf("the size form the free is %d \n", size);
		sys_freeMem(va, size);
		changed[index] = 0;
		changes++;
	} else {
		size = 513 * PAGE_SIZE;
  801bcf:	c7 45 e4 00 10 20 00 	movl   $0x201000,-0x1c(%ebp)
		cprintf("the size form the free is %d \n", size);
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bdc:	68 c4 2c 80 00       	push   $0x802cc4
  801be1:	e8 1d ee ff ff       	call   800a03 <cprintf>
  801be6:	83 c4 10             	add    $0x10,%esp
		sys_freeMem(va, size);
  801be9:	83 ec 08             	sub    $0x8,%esp
  801bec:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bef:	ff 75 e8             	pushl  -0x18(%ebp)
  801bf2:	e8 9c 02 00 00       	call   801e93 <sys_freeMem>
  801bf7:	83 c4 10             	add    $0x10,%esp
		changed[index] = 0;
  801bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfd:	c7 04 85 a0 4b 86 00 	movl   $0x0,0x864ba0(,%eax,4)
  801c04:	00 00 00 00 
	}

	//refer to the project presentation and documentation for details
}
  801c08:	90                   	nop
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <smalloc>:

//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 18             	sub    $0x18,%esp
  801c11:	8b 45 10             	mov    0x10(%ebp),%eax
  801c14:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	68 e4 2c 80 00       	push   $0x802ce4
  801c1f:	68 9d 00 00 00       	push   $0x9d
  801c24:	68 07 2d 80 00       	push   $0x802d07
  801c29:	e8 33 eb ff ff       	call   800761 <_panic>

00801c2e <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName) {
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	68 e4 2c 80 00       	push   $0x802ce4
  801c3c:	68 a2 00 00 00       	push   $0xa2
  801c41:	68 07 2d 80 00       	push   $0x802d07
  801c46:	e8 16 eb ff ff       	call   800761 <_panic>

00801c4b <sfree>:
	return 0;
}

void sfree(void* virtual_address) {
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c51:	83 ec 04             	sub    $0x4,%esp
  801c54:	68 e4 2c 80 00       	push   $0x802ce4
  801c59:	68 a7 00 00 00       	push   $0xa7
  801c5e:	68 07 2d 80 00       	push   $0x802d07
  801c63:	e8 f9 ea ff ff       	call   800761 <_panic>

00801c68 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size) {
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	68 e4 2c 80 00       	push   $0x802ce4
  801c76:	68 ab 00 00 00       	push   $0xab
  801c7b:	68 07 2d 80 00       	push   $0x802d07
  801c80:	e8 dc ea ff ff       	call   800761 <_panic>

00801c85 <expand>:
	return 0;
}

void expand(uint32 newSize) {
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	68 e4 2c 80 00       	push   $0x802ce4
  801c93:	68 b0 00 00 00       	push   $0xb0
  801c98:	68 07 2d 80 00       	push   $0x802d07
  801c9d:	e8 bf ea ff ff       	call   800761 <_panic>

00801ca2 <shrink>:
}
void shrink(uint32 newSize) {
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	68 e4 2c 80 00       	push   $0x802ce4
  801cb0:	68 b3 00 00 00       	push   $0xb3
  801cb5:	68 07 2d 80 00       	push   $0x802d07
  801cba:	e8 a2 ea ff ff       	call   800761 <_panic>

00801cbf <freeHeap>:
}

void freeHeap(void* virtual_address) {
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	68 e4 2c 80 00       	push   $0x802ce4
  801ccd:	68 b7 00 00 00       	push   $0xb7
  801cd2:	68 07 2d 80 00       	push   $0x802d07
  801cd7:	e8 85 ea ff ff       	call   800761 <_panic>

00801cdc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	57                   	push   %edi
  801ce0:	56                   	push   %esi
  801ce1:	53                   	push   %ebx
  801ce2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cf4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cf7:	cd 30                	int    $0x30
  801cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5e                   	pop    %esi
  801d04:	5f                   	pop    %edi
  801d05:	5d                   	pop    %ebp
  801d06:	c3                   	ret    

00801d07 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d13:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	52                   	push   %edx
  801d1f:	ff 75 0c             	pushl  0xc(%ebp)
  801d22:	50                   	push   %eax
  801d23:	6a 00                	push   $0x0
  801d25:	e8 b2 ff ff ff       	call   801cdc <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	90                   	nop
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 01                	push   $0x1
  801d3f:	e8 98 ff ff ff       	call   801cdc <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	50                   	push   %eax
  801d58:	6a 05                	push   $0x5
  801d5a:	e8 7d ff ff ff       	call   801cdc <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 02                	push   $0x2
  801d73:	e8 64 ff ff ff       	call   801cdc <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 03                	push   $0x3
  801d8c:	e8 4b ff ff ff       	call   801cdc <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 04                	push   $0x4
  801da5:	e8 32 ff ff ff       	call   801cdc <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_env_exit>:


void sys_env_exit(void)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 06                	push   $0x6
  801dbe:	e8 19 ff ff ff       	call   801cdc <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
}
  801dc6:	90                   	nop
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	6a 07                	push   $0x7
  801ddc:	e8 fb fe ff ff       	call   801cdc <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	56                   	push   %esi
  801dea:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801deb:	8b 75 18             	mov    0x18(%ebp),%esi
  801dee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	56                   	push   %esi
  801dfb:	53                   	push   %ebx
  801dfc:	51                   	push   %ecx
  801dfd:	52                   	push   %edx
  801dfe:	50                   	push   %eax
  801dff:	6a 08                	push   $0x8
  801e01:	e8 d6 fe ff ff       	call   801cdc <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5d                   	pop    %ebp
  801e0f:	c3                   	ret    

00801e10 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	6a 09                	push   $0x9
  801e23:	e8 b4 fe ff ff       	call   801cdc <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 0a                	push   $0xa
  801e3e:	e8 99 fe ff ff       	call   801cdc <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 0b                	push   $0xb
  801e57:	e8 80 fe ff ff       	call   801cdc <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 0c                	push   $0xc
  801e70:	e8 67 fe ff ff       	call   801cdc <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 0d                	push   $0xd
  801e89:	e8 4e fe ff ff       	call   801cdc <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	6a 11                	push   $0x11
  801ea4:	e8 33 fe ff ff       	call   801cdc <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return;
  801eac:	90                   	nop
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	ff 75 0c             	pushl  0xc(%ebp)
  801ebb:	ff 75 08             	pushl  0x8(%ebp)
  801ebe:	6a 12                	push   $0x12
  801ec0:	e8 17 fe ff ff       	call   801cdc <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec8:	90                   	nop
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 0e                	push   $0xe
  801eda:	e8 fd fd ff ff       	call   801cdc <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	ff 75 08             	pushl  0x8(%ebp)
  801ef2:	6a 0f                	push   $0xf
  801ef4:	e8 e3 fd ff ff       	call   801cdc <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_scarce_memory>:

void sys_scarce_memory()
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 10                	push   $0x10
  801f0d:	e8 ca fd ff ff       	call   801cdc <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	90                   	nop
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 14                	push   $0x14
  801f27:	e8 b0 fd ff ff       	call   801cdc <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	90                   	nop
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 15                	push   $0x15
  801f41:	e8 96 fd ff ff       	call   801cdc <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	90                   	nop
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_cputc>:


void
sys_cputc(const char c)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 04             	sub    $0x4,%esp
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f58:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	50                   	push   %eax
  801f65:	6a 16                	push   $0x16
  801f67:	e8 70 fd ff ff       	call   801cdc <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
}
  801f6f:	90                   	nop
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 17                	push   $0x17
  801f81:	e8 56 fd ff ff       	call   801cdc <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	90                   	nop
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	50                   	push   %eax
  801f9c:	6a 18                	push   $0x18
  801f9e:	e8 39 fd ff ff       	call   801cdc <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	52                   	push   %edx
  801fb8:	50                   	push   %eax
  801fb9:	6a 1b                	push   $0x1b
  801fbb:	e8 1c fd ff ff       	call   801cdc <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	52                   	push   %edx
  801fd5:	50                   	push   %eax
  801fd6:	6a 19                	push   $0x19
  801fd8:	e8 ff fc ff ff       	call   801cdc <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	90                   	nop
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	52                   	push   %edx
  801ff3:	50                   	push   %eax
  801ff4:	6a 1a                	push   $0x1a
  801ff6:	e8 e1 fc ff ff       	call   801cdc <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	90                   	nop
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	8b 45 10             	mov    0x10(%ebp),%eax
  80200a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80200d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802010:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	6a 00                	push   $0x0
  802019:	51                   	push   %ecx
  80201a:	52                   	push   %edx
  80201b:	ff 75 0c             	pushl  0xc(%ebp)
  80201e:	50                   	push   %eax
  80201f:	6a 1c                	push   $0x1c
  802021:	e8 b6 fc ff ff       	call   801cdc <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80202e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	52                   	push   %edx
  80203b:	50                   	push   %eax
  80203c:	6a 1d                	push   $0x1d
  80203e:	e8 99 fc ff ff       	call   801cdc <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80204b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	51                   	push   %ecx
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 1e                	push   $0x1e
  80205d:	e8 7a fc ff ff       	call   801cdc <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80206a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	52                   	push   %edx
  802077:	50                   	push   %eax
  802078:	6a 1f                	push   $0x1f
  80207a:	e8 5d fc ff ff       	call   801cdc <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 20                	push   $0x20
  802093:	e8 44 fc ff ff       	call   801cdc <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	ff 75 14             	pushl  0x14(%ebp)
  8020a8:	ff 75 10             	pushl  0x10(%ebp)
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	50                   	push   %eax
  8020af:	6a 21                	push   $0x21
  8020b1:	e8 26 fc ff ff       	call   801cdc <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	50                   	push   %eax
  8020ca:	6a 22                	push   $0x22
  8020cc:	e8 0b fc ff ff       	call   801cdc <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	50                   	push   %eax
  8020e6:	6a 23                	push   $0x23
  8020e8:	e8 ef fb ff ff       	call   801cdc <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
}
  8020f0:	90                   	nop
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020f9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020fc:	8d 50 04             	lea    0x4(%eax),%edx
  8020ff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	52                   	push   %edx
  802109:	50                   	push   %eax
  80210a:	6a 24                	push   $0x24
  80210c:	e8 cb fb ff ff       	call   801cdc <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
	return result;
  802114:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80211a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80211d:	89 01                	mov    %eax,(%ecx)
  80211f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	c9                   	leave  
  802126:	c2 04 00             	ret    $0x4

00802129 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	ff 75 10             	pushl  0x10(%ebp)
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	ff 75 08             	pushl  0x8(%ebp)
  802139:	6a 13                	push   $0x13
  80213b:	e8 9c fb ff ff       	call   801cdc <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
	return ;
  802143:	90                   	nop
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_rcr2>:
uint32 sys_rcr2()
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 25                	push   $0x25
  802155:	e8 82 fb ff ff       	call   801cdc <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 04             	sub    $0x4,%esp
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80216b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	50                   	push   %eax
  802178:	6a 26                	push   $0x26
  80217a:	e8 5d fb ff ff       	call   801cdc <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
	return ;
  802182:	90                   	nop
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <rsttst>:
void rsttst()
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 28                	push   $0x28
  802194:	e8 43 fb ff ff       	call   801cdc <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
	return ;
  80219c:	90                   	nop
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021ab:	8b 55 18             	mov    0x18(%ebp),%edx
  8021ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021b2:	52                   	push   %edx
  8021b3:	50                   	push   %eax
  8021b4:	ff 75 10             	pushl  0x10(%ebp)
  8021b7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ba:	ff 75 08             	pushl  0x8(%ebp)
  8021bd:	6a 27                	push   $0x27
  8021bf:	e8 18 fb ff ff       	call   801cdc <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c7:	90                   	nop
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <chktst>:
void chktst(uint32 n)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	ff 75 08             	pushl  0x8(%ebp)
  8021d8:	6a 29                	push   $0x29
  8021da:	e8 fd fa ff ff       	call   801cdc <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e2:	90                   	nop
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <inctst>:

void inctst()
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 2a                	push   $0x2a
  8021f4:	e8 e3 fa ff ff       	call   801cdc <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fc:	90                   	nop
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <gettst>:
uint32 gettst()
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 2b                	push   $0x2b
  80220e:	e8 c9 fa ff ff       	call   801cdc <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 2c                	push   $0x2c
  80222a:	e8 ad fa ff ff       	call   801cdc <syscall>
  80222f:	83 c4 18             	add    $0x18,%esp
  802232:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802235:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802239:	75 07                	jne    802242 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80223b:	b8 01 00 00 00       	mov    $0x1,%eax
  802240:	eb 05                	jmp    802247 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 2c                	push   $0x2c
  80225b:	e8 7c fa ff ff       	call   801cdc <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
  802263:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802266:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80226a:	75 07                	jne    802273 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80226c:	b8 01 00 00 00       	mov    $0x1,%eax
  802271:	eb 05                	jmp    802278 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802273:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 2c                	push   $0x2c
  80228c:	e8 4b fa ff ff       	call   801cdc <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
  802294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802297:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80229b:	75 07                	jne    8022a4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80229d:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a2:	eb 05                	jmp    8022a9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 2c                	push   $0x2c
  8022bd:	e8 1a fa ff ff       	call   801cdc <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
  8022c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022c8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022cc:	75 07                	jne    8022d5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d3:	eb 05                	jmp    8022da <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	ff 75 08             	pushl  0x8(%ebp)
  8022ea:	6a 2d                	push   $0x2d
  8022ec:	e8 eb f9 ff ff       	call   801cdc <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f4:	90                   	nop
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802301:	8b 55 0c             	mov    0xc(%ebp),%edx
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	53                   	push   %ebx
  80230a:	51                   	push   %ecx
  80230b:	52                   	push   %edx
  80230c:	50                   	push   %eax
  80230d:	6a 2e                	push   $0x2e
  80230f:	e8 c8 f9 ff ff       	call   801cdc <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
}
  802317:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80231f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	52                   	push   %edx
  80232c:	50                   	push   %eax
  80232d:	6a 2f                	push   $0x2f
  80232f:	e8 a8 f9 ff ff       	call   801cdc <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    
  802339:	66 90                	xchg   %ax,%ax
  80233b:	90                   	nop

0080233c <__udivdi3>:
  80233c:	55                   	push   %ebp
  80233d:	57                   	push   %edi
  80233e:	56                   	push   %esi
  80233f:	53                   	push   %ebx
  802340:	83 ec 1c             	sub    $0x1c,%esp
  802343:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802347:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80234b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80234f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802353:	89 ca                	mov    %ecx,%edx
  802355:	89 f8                	mov    %edi,%eax
  802357:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80235b:	85 f6                	test   %esi,%esi
  80235d:	75 2d                	jne    80238c <__udivdi3+0x50>
  80235f:	39 cf                	cmp    %ecx,%edi
  802361:	77 65                	ja     8023c8 <__udivdi3+0x8c>
  802363:	89 fd                	mov    %edi,%ebp
  802365:	85 ff                	test   %edi,%edi
  802367:	75 0b                	jne    802374 <__udivdi3+0x38>
  802369:	b8 01 00 00 00       	mov    $0x1,%eax
  80236e:	31 d2                	xor    %edx,%edx
  802370:	f7 f7                	div    %edi
  802372:	89 c5                	mov    %eax,%ebp
  802374:	31 d2                	xor    %edx,%edx
  802376:	89 c8                	mov    %ecx,%eax
  802378:	f7 f5                	div    %ebp
  80237a:	89 c1                	mov    %eax,%ecx
  80237c:	89 d8                	mov    %ebx,%eax
  80237e:	f7 f5                	div    %ebp
  802380:	89 cf                	mov    %ecx,%edi
  802382:	89 fa                	mov    %edi,%edx
  802384:	83 c4 1c             	add    $0x1c,%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5f                   	pop    %edi
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    
  80238c:	39 ce                	cmp    %ecx,%esi
  80238e:	77 28                	ja     8023b8 <__udivdi3+0x7c>
  802390:	0f bd fe             	bsr    %esi,%edi
  802393:	83 f7 1f             	xor    $0x1f,%edi
  802396:	75 40                	jne    8023d8 <__udivdi3+0x9c>
  802398:	39 ce                	cmp    %ecx,%esi
  80239a:	72 0a                	jb     8023a6 <__udivdi3+0x6a>
  80239c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023a0:	0f 87 9e 00 00 00    	ja     802444 <__udivdi3+0x108>
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	89 fa                	mov    %edi,%edx
  8023ad:	83 c4 1c             	add    $0x1c,%esp
  8023b0:	5b                   	pop    %ebx
  8023b1:	5e                   	pop    %esi
  8023b2:	5f                   	pop    %edi
  8023b3:	5d                   	pop    %ebp
  8023b4:	c3                   	ret    
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	31 ff                	xor    %edi,%edi
  8023ba:	31 c0                	xor    %eax,%eax
  8023bc:	89 fa                	mov    %edi,%edx
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	66 90                	xchg   %ax,%ax
  8023c8:	89 d8                	mov    %ebx,%eax
  8023ca:	f7 f7                	div    %edi
  8023cc:	31 ff                	xor    %edi,%edi
  8023ce:	89 fa                	mov    %edi,%edx
  8023d0:	83 c4 1c             	add    $0x1c,%esp
  8023d3:	5b                   	pop    %ebx
  8023d4:	5e                   	pop    %esi
  8023d5:	5f                   	pop    %edi
  8023d6:	5d                   	pop    %ebp
  8023d7:	c3                   	ret    
  8023d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023dd:	89 eb                	mov    %ebp,%ebx
  8023df:	29 fb                	sub    %edi,%ebx
  8023e1:	89 f9                	mov    %edi,%ecx
  8023e3:	d3 e6                	shl    %cl,%esi
  8023e5:	89 c5                	mov    %eax,%ebp
  8023e7:	88 d9                	mov    %bl,%cl
  8023e9:	d3 ed                	shr    %cl,%ebp
  8023eb:	89 e9                	mov    %ebp,%ecx
  8023ed:	09 f1                	or     %esi,%ecx
  8023ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023f3:	89 f9                	mov    %edi,%ecx
  8023f5:	d3 e0                	shl    %cl,%eax
  8023f7:	89 c5                	mov    %eax,%ebp
  8023f9:	89 d6                	mov    %edx,%esi
  8023fb:	88 d9                	mov    %bl,%cl
  8023fd:	d3 ee                	shr    %cl,%esi
  8023ff:	89 f9                	mov    %edi,%ecx
  802401:	d3 e2                	shl    %cl,%edx
  802403:	8b 44 24 08          	mov    0x8(%esp),%eax
  802407:	88 d9                	mov    %bl,%cl
  802409:	d3 e8                	shr    %cl,%eax
  80240b:	09 c2                	or     %eax,%edx
  80240d:	89 d0                	mov    %edx,%eax
  80240f:	89 f2                	mov    %esi,%edx
  802411:	f7 74 24 0c          	divl   0xc(%esp)
  802415:	89 d6                	mov    %edx,%esi
  802417:	89 c3                	mov    %eax,%ebx
  802419:	f7 e5                	mul    %ebp
  80241b:	39 d6                	cmp    %edx,%esi
  80241d:	72 19                	jb     802438 <__udivdi3+0xfc>
  80241f:	74 0b                	je     80242c <__udivdi3+0xf0>
  802421:	89 d8                	mov    %ebx,%eax
  802423:	31 ff                	xor    %edi,%edi
  802425:	e9 58 ff ff ff       	jmp    802382 <__udivdi3+0x46>
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802430:	89 f9                	mov    %edi,%ecx
  802432:	d3 e2                	shl    %cl,%edx
  802434:	39 c2                	cmp    %eax,%edx
  802436:	73 e9                	jae    802421 <__udivdi3+0xe5>
  802438:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80243b:	31 ff                	xor    %edi,%edi
  80243d:	e9 40 ff ff ff       	jmp    802382 <__udivdi3+0x46>
  802442:	66 90                	xchg   %ax,%ax
  802444:	31 c0                	xor    %eax,%eax
  802446:	e9 37 ff ff ff       	jmp    802382 <__udivdi3+0x46>
  80244b:	90                   	nop

0080244c <__umoddi3>:
  80244c:	55                   	push   %ebp
  80244d:	57                   	push   %edi
  80244e:	56                   	push   %esi
  80244f:	53                   	push   %ebx
  802450:	83 ec 1c             	sub    $0x1c,%esp
  802453:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802457:	8b 74 24 34          	mov    0x34(%esp),%esi
  80245b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80245f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802463:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802467:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80246b:	89 f3                	mov    %esi,%ebx
  80246d:	89 fa                	mov    %edi,%edx
  80246f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802473:	89 34 24             	mov    %esi,(%esp)
  802476:	85 c0                	test   %eax,%eax
  802478:	75 1a                	jne    802494 <__umoddi3+0x48>
  80247a:	39 f7                	cmp    %esi,%edi
  80247c:	0f 86 a2 00 00 00    	jbe    802524 <__umoddi3+0xd8>
  802482:	89 c8                	mov    %ecx,%eax
  802484:	89 f2                	mov    %esi,%edx
  802486:	f7 f7                	div    %edi
  802488:	89 d0                	mov    %edx,%eax
  80248a:	31 d2                	xor    %edx,%edx
  80248c:	83 c4 1c             	add    $0x1c,%esp
  80248f:	5b                   	pop    %ebx
  802490:	5e                   	pop    %esi
  802491:	5f                   	pop    %edi
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    
  802494:	39 f0                	cmp    %esi,%eax
  802496:	0f 87 ac 00 00 00    	ja     802548 <__umoddi3+0xfc>
  80249c:	0f bd e8             	bsr    %eax,%ebp
  80249f:	83 f5 1f             	xor    $0x1f,%ebp
  8024a2:	0f 84 ac 00 00 00    	je     802554 <__umoddi3+0x108>
  8024a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8024ad:	29 ef                	sub    %ebp,%edi
  8024af:	89 fe                	mov    %edi,%esi
  8024b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024b5:	89 e9                	mov    %ebp,%ecx
  8024b7:	d3 e0                	shl    %cl,%eax
  8024b9:	89 d7                	mov    %edx,%edi
  8024bb:	89 f1                	mov    %esi,%ecx
  8024bd:	d3 ef                	shr    %cl,%edi
  8024bf:	09 c7                	or     %eax,%edi
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e2                	shl    %cl,%edx
  8024c5:	89 14 24             	mov    %edx,(%esp)
  8024c8:	89 d8                	mov    %ebx,%eax
  8024ca:	d3 e0                	shl    %cl,%eax
  8024cc:	89 c2                	mov    %eax,%edx
  8024ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024d2:	d3 e0                	shl    %cl,%eax
  8024d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024dc:	89 f1                	mov    %esi,%ecx
  8024de:	d3 e8                	shr    %cl,%eax
  8024e0:	09 d0                	or     %edx,%eax
  8024e2:	d3 eb                	shr    %cl,%ebx
  8024e4:	89 da                	mov    %ebx,%edx
  8024e6:	f7 f7                	div    %edi
  8024e8:	89 d3                	mov    %edx,%ebx
  8024ea:	f7 24 24             	mull   (%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d1                	mov    %edx,%ecx
  8024f1:	39 d3                	cmp    %edx,%ebx
  8024f3:	0f 82 87 00 00 00    	jb     802580 <__umoddi3+0x134>
  8024f9:	0f 84 91 00 00 00    	je     802590 <__umoddi3+0x144>
  8024ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  802503:	29 f2                	sub    %esi,%edx
  802505:	19 cb                	sbb    %ecx,%ebx
  802507:	89 d8                	mov    %ebx,%eax
  802509:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80250d:	d3 e0                	shl    %cl,%eax
  80250f:	89 e9                	mov    %ebp,%ecx
  802511:	d3 ea                	shr    %cl,%edx
  802513:	09 d0                	or     %edx,%eax
  802515:	89 e9                	mov    %ebp,%ecx
  802517:	d3 eb                	shr    %cl,%ebx
  802519:	89 da                	mov    %ebx,%edx
  80251b:	83 c4 1c             	add    $0x1c,%esp
  80251e:	5b                   	pop    %ebx
  80251f:	5e                   	pop    %esi
  802520:	5f                   	pop    %edi
  802521:	5d                   	pop    %ebp
  802522:	c3                   	ret    
  802523:	90                   	nop
  802524:	89 fd                	mov    %edi,%ebp
  802526:	85 ff                	test   %edi,%edi
  802528:	75 0b                	jne    802535 <__umoddi3+0xe9>
  80252a:	b8 01 00 00 00       	mov    $0x1,%eax
  80252f:	31 d2                	xor    %edx,%edx
  802531:	f7 f7                	div    %edi
  802533:	89 c5                	mov    %eax,%ebp
  802535:	89 f0                	mov    %esi,%eax
  802537:	31 d2                	xor    %edx,%edx
  802539:	f7 f5                	div    %ebp
  80253b:	89 c8                	mov    %ecx,%eax
  80253d:	f7 f5                	div    %ebp
  80253f:	89 d0                	mov    %edx,%eax
  802541:	e9 44 ff ff ff       	jmp    80248a <__umoddi3+0x3e>
  802546:	66 90                	xchg   %ax,%ax
  802548:	89 c8                	mov    %ecx,%eax
  80254a:	89 f2                	mov    %esi,%edx
  80254c:	83 c4 1c             	add    $0x1c,%esp
  80254f:	5b                   	pop    %ebx
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
  802554:	3b 04 24             	cmp    (%esp),%eax
  802557:	72 06                	jb     80255f <__umoddi3+0x113>
  802559:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80255d:	77 0f                	ja     80256e <__umoddi3+0x122>
  80255f:	89 f2                	mov    %esi,%edx
  802561:	29 f9                	sub    %edi,%ecx
  802563:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802567:	89 14 24             	mov    %edx,(%esp)
  80256a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80256e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802572:	8b 14 24             	mov    (%esp),%edx
  802575:	83 c4 1c             	add    $0x1c,%esp
  802578:	5b                   	pop    %ebx
  802579:	5e                   	pop    %esi
  80257a:	5f                   	pop    %edi
  80257b:	5d                   	pop    %ebp
  80257c:	c3                   	ret    
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	2b 04 24             	sub    (%esp),%eax
  802583:	19 fa                	sbb    %edi,%edx
  802585:	89 d1                	mov    %edx,%ecx
  802587:	89 c6                	mov    %eax,%esi
  802589:	e9 71 ff ff ff       	jmp    8024ff <__umoddi3+0xb3>
  80258e:	66 90                	xchg   %ax,%ax
  802590:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802594:	72 ea                	jb     802580 <__umoddi3+0x134>
  802596:	89 d9                	mov    %ebx,%ecx
  802598:	e9 62 ff ff ff       	jmp    8024ff <__umoddi3+0xb3>
