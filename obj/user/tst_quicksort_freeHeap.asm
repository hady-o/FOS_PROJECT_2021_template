
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 10 08 00 00       	call   800846 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 8f 20 00 00       	call   8020e0 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c9 fe ff ff    	lea    -0x137(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 80 27 80 00       	push   $0x802780
  800060:	e8 4a 12 00 00       	call   8012af <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c9 fe ff ff    	lea    -0x137(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 9a 17 00 00       	call   801815 <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 2d 1b 00 00       	call   801bbd <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800096:	a1 24 30 80 00       	mov    0x803024,%eax
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	50                   	push   %eax
  80009f:	e8 7f 03 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS ;
  8000aa:	e8 61 1f 00 00       	call   802010 <sys_calculate_free_frames>
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	e8 73 1f 00 00       	call   802029 <sys_calculate_modified_frames>
  8000b6:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000bc:	29 c2                	sub    %eax,%edx
  8000be:	89 d0                	mov    %edx,%eax
  8000c0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		Elements[NumOfElements] = 10 ;
  8000c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d0:	01 d0                	add    %edx,%eax
  8000d2:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 a0 27 80 00       	push   $0x8027a0
  8000e0:	e8 48 0b 00 00       	call   800c2d <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 c3 27 80 00       	push   $0x8027c3
  8000f0:	e8 38 0b 00 00       	call   800c2d <cprintf>
  8000f5:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	68 d1 27 80 00       	push   $0x8027d1
  800100:	e8 28 0b 00 00       	call   800c2d <cprintf>
  800105:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  800108:	83 ec 0c             	sub    $0xc,%esp
  80010b:	68 e0 27 80 00       	push   $0x8027e0
  800110:	e8 18 0b 00 00       	call   800c2d <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	68 f0 27 80 00       	push   $0x8027f0
  800120:	e8 08 0b 00 00       	call   800c2d <cprintf>
  800125:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800128:	e8 c1 06 00 00       	call   8007ee <getchar>
  80012d:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800130:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	50                   	push   %eax
  800138:	e8 69 06 00 00       	call   8007a6 <cputchar>
  80013d:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	6a 0a                	push   $0xa
  800145:	e8 5c 06 00 00       	call   8007a6 <cputchar>
  80014a:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80014d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800151:	74 0c                	je     80015f <_main+0x127>
  800153:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800157:	74 06                	je     80015f <_main+0x127>
  800159:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80015d:	75 b9                	jne    800118 <_main+0xe0>
	sys_enable_interrupt();
  80015f:	e8 96 1f 00 00       	call   8020fa <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  800164:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800168:	83 f8 62             	cmp    $0x62,%eax
  80016b:	74 1d                	je     80018a <_main+0x152>
  80016d:	83 f8 63             	cmp    $0x63,%eax
  800170:	74 2b                	je     80019d <_main+0x165>
  800172:	83 f8 61             	cmp    $0x61,%eax
  800175:	75 39                	jne    8001b0 <_main+0x178>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	ff 75 ec             	pushl  -0x14(%ebp)
  80017d:	ff 75 e8             	pushl  -0x18(%ebp)
  800180:	e8 e9 04 00 00       	call   80066e <InitializeAscending>
  800185:	83 c4 10             	add    $0x10,%esp
			break ;
  800188:	eb 37                	jmp    8001c1 <_main+0x189>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 ec             	pushl  -0x14(%ebp)
  800190:	ff 75 e8             	pushl  -0x18(%ebp)
  800193:	e8 07 05 00 00       	call   80069f <InitializeDescending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 24                	jmp    8001c1 <_main+0x189>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a6:	e8 29 05 00 00       	call   8006d4 <InitializeSemiRandom>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 11                	jmp    8001c1 <_main+0x189>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b9:	e8 16 05 00 00       	call   8006d4 <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ca:	e8 e4 02 00 00       	call   8004b3 <QuickSort>
  8001cf:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001db:	e8 e4 03 00 00       	call   8005c4 <CheckSorted>
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001ea:	75 14                	jne    800200 <_main+0x1c8>
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	68 fc 27 80 00       	push   $0x8027fc
  8001f4:	6a 57                	push   $0x57
  8001f6:	68 1e 28 80 00       	push   $0x80281e
  8001fb:	e8 8b 07 00 00       	call   80098b <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	68 3c 28 80 00       	push   $0x80283c
  800208:	e8 20 0a 00 00       	call   800c2d <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 70 28 80 00       	push   $0x802870
  800218:	e8 10 0a 00 00       	call   800c2d <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	68 a4 28 80 00       	push   $0x8028a4
  800228:	e8 00 0a 00 00       	call   800c2d <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 d6 28 80 00       	push   $0x8028d6
  800238:	e8 f0 09 00 00       	call   800c2d <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 e8             	pushl  -0x18(%ebp)
  800246:	e8 82 1b 00 00       	call   801dcd <free>
  80024b:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  80024e:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800252:	75 72                	jne    8002c6 <_main+0x28e>
		{
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800254:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80025b:	75 06                	jne    800263 <_main+0x22b>
  80025d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800261:	74 14                	je     800277 <_main+0x23f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	68 ec 28 80 00       	push   $0x8028ec
  80026b:	6a 69                	push   $0x69
  80026d:	68 1e 28 80 00       	push   $0x80281e
  800272:	e8 14 07 00 00       	call   80098b <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800277:	a1 24 30 80 00       	mov    0x803024,%eax
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	50                   	push   %eax
  800280:	e8 9e 01 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80028b:	e8 80 1d 00 00       	call   802010 <sys_calculate_free_frames>
  800290:	89 c3                	mov    %eax,%ebx
  800292:	e8 92 1d 00 00       	call   802029 <sys_calculate_modified_frames>
  800297:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80029a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029d:	29 c2                	sub    %eax,%edx
  80029f:	89 d0                	mov    %edx,%eax
  8002a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002aa:	0f 84 05 01 00 00    	je     8003b5 <_main+0x37d>
  8002b0:	68 3c 29 80 00       	push   $0x80293c
  8002b5:	68 61 29 80 00       	push   $0x802961
  8002ba:	6a 6d                	push   $0x6d
  8002bc:	68 1e 28 80 00       	push   $0x80281e
  8002c1:	e8 c5 06 00 00       	call   80098b <_panic>
		}
		else if (Iteration == 2 )
  8002c6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ca:	75 72                	jne    80033e <_main+0x306>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002cc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002d3:	75 06                	jne    8002db <_main+0x2a3>
  8002d5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 ec 28 80 00       	push   $0x8028ec
  8002e3:	6a 72                	push   $0x72
  8002e5:	68 1e 28 80 00       	push   $0x80281e
  8002ea:	e8 9c 06 00 00       	call   80098b <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ef:	a1 24 30 80 00       	mov    0x803024,%eax
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	50                   	push   %eax
  8002f8:	e8 26 01 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800303:	e8 08 1d 00 00       	call   802010 <sys_calculate_free_frames>
  800308:	89 c3                	mov    %eax,%ebx
  80030a:	e8 1a 1d 00 00       	call   802029 <sys_calculate_modified_frames>
  80030f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800315:	29 c2                	sub    %eax,%edx
  800317:	89 d0                	mov    %edx,%eax
  800319:	89 45 d0             	mov    %eax,-0x30(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80031c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80031f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800322:	0f 84 8d 00 00 00    	je     8003b5 <_main+0x37d>
  800328:	68 3c 29 80 00       	push   $0x80293c
  80032d:	68 61 29 80 00       	push   $0x802961
  800332:	6a 76                	push   $0x76
  800334:	68 1e 28 80 00       	push   $0x80281e
  800339:	e8 4d 06 00 00       	call   80098b <_panic>
		}
		else if (Iteration == 3 )
  80033e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800342:	75 71                	jne    8003b5 <_main+0x37d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800344:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80034b:	75 06                	jne    800353 <_main+0x31b>
  80034d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800351:	74 14                	je     800367 <_main+0x32f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800353:	83 ec 04             	sub    $0x4,%esp
  800356:	68 ec 28 80 00       	push   $0x8028ec
  80035b:	6a 7b                	push   $0x7b
  80035d:	68 1e 28 80 00       	push   $0x80281e
  800362:	e8 24 06 00 00       	call   80098b <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800367:	a1 24 30 80 00       	mov    0x803024,%eax
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	50                   	push   %eax
  800370:	e8 ae 00 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	89 45 cc             	mov    %eax,-0x34(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80037b:	e8 90 1c 00 00       	call   802010 <sys_calculate_free_frames>
  800380:	89 c3                	mov    %eax,%ebx
  800382:	e8 a2 1c 00 00       	call   802029 <sys_calculate_modified_frames>
  800387:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80038a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80038d:	29 c2                	sub    %eax,%edx
  80038f:	89 d0                	mov    %edx,%eax
  800391:	89 45 c8             	mov    %eax,-0x38(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  800394:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800397:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039a:	74 19                	je     8003b5 <_main+0x37d>
  80039c:	68 3c 29 80 00       	push   $0x80293c
  8003a1:	68 61 29 80 00       	push   $0x802961
  8003a6:	68 80 00 00 00       	push   $0x80
  8003ab:	68 1e 28 80 00       	push   $0x80281e
  8003b0:	e8 d6 05 00 00       	call   80098b <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003b5:	e8 26 1d 00 00       	call   8020e0 <sys_disable_interrupt>
		Chose = 0 ;
  8003ba:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003be:	eb 42                	jmp    800402 <_main+0x3ca>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003c0:	83 ec 0c             	sub    $0xc,%esp
  8003c3:	68 76 29 80 00       	push   $0x802976
  8003c8:	e8 60 08 00 00       	call   800c2d <cprintf>
  8003cd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003d0:	e8 19 04 00 00       	call   8007ee <getchar>
  8003d5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003d8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003dc:	83 ec 0c             	sub    $0xc,%esp
  8003df:	50                   	push   %eax
  8003e0:	e8 c1 03 00 00       	call   8007a6 <cputchar>
  8003e5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	6a 0a                	push   $0xa
  8003ed:	e8 b4 03 00 00       	call   8007a6 <cputchar>
  8003f2:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	6a 0a                	push   $0xa
  8003fa:	e8 a7 03 00 00       	call   8007a6 <cputchar>
  8003ff:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800402:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800406:	74 06                	je     80040e <_main+0x3d6>
  800408:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80040c:	75 b2                	jne    8003c0 <_main+0x388>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80040e:	e8 e7 1c 00 00       	call   8020fa <sys_enable_interrupt>

	} while (Chose == 'y');
  800413:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800417:	0f 84 2c fc ff ff    	je     800049 <_main+0x11>
}
  80041d:	90                   	nop
  80041e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800421:	c9                   	leave  
  800422:	c3                   	ret    

00800423 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800423:	55                   	push   %ebp
  800424:	89 e5                	mov    %esp,%ebp
  800426:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800429:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800430:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800437:	eb 68                	jmp    8004a1 <CheckAndCountEmptyLocInWS+0x7e>
	{
		if (myEnv->__uptr_pws[i].empty)
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800442:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800445:	c1 e2 04             	shl    $0x4,%edx
  800448:	01 d0                	add    %edx,%eax
  80044a:	8a 40 04             	mov    0x4(%eax),%al
  80044d:	84 c0                	test   %al,%al
  80044f:	74 05                	je     800456 <CheckAndCountEmptyLocInWS+0x33>
		{
			numOFEmptyLocInWS++;
  800451:	ff 45 f4             	incl   -0xc(%ebp)
  800454:	eb 48                	jmp    80049e <CheckAndCountEmptyLocInWS+0x7b>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800456:	8b 45 08             	mov    0x8(%ebp),%eax
  800459:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80045f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800462:	c1 e2 04             	shl    $0x4,%edx
  800465:	01 d0                	add    %edx,%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80046c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80046f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800474:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800477:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80047a:	85 c0                	test   %eax,%eax
  80047c:	79 20                	jns    80049e <CheckAndCountEmptyLocInWS+0x7b>
  80047e:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  800485:	77 17                	ja     80049e <CheckAndCountEmptyLocInWS+0x7b>
				panic("freeMem didn't remove its page(s) from the WS");
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	68 94 29 80 00       	push   $0x802994
  80048f:	68 9f 00 00 00       	push   $0x9f
  800494:	68 1e 28 80 00       	push   $0x80281e
  800499:	e8 ed 04 00 00       	call   80098b <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  80049e:	ff 45 f0             	incl   -0x10(%ebp)
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	8b 50 74             	mov    0x74(%eax),%edx
  8004a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004aa:	39 c2                	cmp    %eax,%edx
  8004ac:	77 8b                	ja     800439 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004ae:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	48                   	dec    %eax
  8004bd:	50                   	push   %eax
  8004be:	6a 00                	push   $0x0
  8004c0:	ff 75 0c             	pushl  0xc(%ebp)
  8004c3:	ff 75 08             	pushl  0x8(%ebp)
  8004c6:	e8 06 00 00 00       	call   8004d1 <QSort>
  8004cb:	83 c4 10             	add    $0x10,%esp
}
  8004ce:	90                   	nop
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004da:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004dd:	0f 8d de 00 00 00    	jge    8005c1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8004e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e6:	40                   	inc    %eax
  8004e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8004f0:	e9 80 00 00 00       	jmp    800575 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8004f5:	ff 45 f4             	incl   -0xc(%ebp)
  8004f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fb:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004fe:	7f 2b                	jg     80052b <QSort+0x5a>
  800500:	8b 45 10             	mov    0x10(%ebp),%eax
  800503:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	8b 10                	mov    (%eax),%edx
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	01 c8                	add    %ecx,%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	7d cf                	jge    8004f5 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800526:	eb 03                	jmp    80052b <QSort+0x5a>
  800528:	ff 4d f0             	decl   -0x10(%ebp)
  80052b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800531:	7e 26                	jle    800559 <QSort+0x88>
  800533:	8b 45 10             	mov    0x10(%ebp),%eax
  800536:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	01 d0                	add    %edx,%eax
  800542:	8b 10                	mov    (%eax),%edx
  800544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800547:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80054e:	8b 45 08             	mov    0x8(%ebp),%eax
  800551:	01 c8                	add    %ecx,%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	39 c2                	cmp    %eax,%edx
  800557:	7e cf                	jle    800528 <QSort+0x57>

		if (i <= j)
  800559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80055c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80055f:	7f 14                	jg     800575 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800561:	83 ec 04             	sub    $0x4,%esp
  800564:	ff 75 f0             	pushl  -0x10(%ebp)
  800567:	ff 75 f4             	pushl  -0xc(%ebp)
  80056a:	ff 75 08             	pushl  0x8(%ebp)
  80056d:	e8 a9 00 00 00       	call   80061b <Swap>
  800572:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800578:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057b:	0f 8e 77 ff ff ff    	jle    8004f8 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	ff 75 f0             	pushl  -0x10(%ebp)
  800587:	ff 75 10             	pushl  0x10(%ebp)
  80058a:	ff 75 08             	pushl  0x8(%ebp)
  80058d:	e8 89 00 00 00       	call   80061b <Swap>
  800592:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800598:	48                   	dec    %eax
  800599:	50                   	push   %eax
  80059a:	ff 75 10             	pushl  0x10(%ebp)
  80059d:	ff 75 0c             	pushl  0xc(%ebp)
  8005a0:	ff 75 08             	pushl  0x8(%ebp)
  8005a3:	e8 29 ff ff ff       	call   8004d1 <QSort>
  8005a8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005ab:	ff 75 14             	pushl  0x14(%ebp)
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	ff 75 08             	pushl  0x8(%ebp)
  8005b7:	e8 15 ff ff ff       	call   8004d1 <QSort>
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	eb 01                	jmp    8005c2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005c1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005d8:	eb 33                	jmp    80060d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	8b 10                	mov    (%eax),%edx
  8005eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005ee:	40                   	inc    %eax
  8005ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f9:	01 c8                	add    %ecx,%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	39 c2                	cmp    %eax,%edx
  8005ff:	7e 09                	jle    80060a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800601:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800608:	eb 0c                	jmp    800616 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80060a:	ff 45 f8             	incl   -0x8(%ebp)
  80060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800610:	48                   	dec    %eax
  800611:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800614:	7f c4                	jg     8005da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800616:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800619:	c9                   	leave  
  80061a:	c3                   	ret    

0080061b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80061b:	55                   	push   %ebp
  80061c:	89 e5                	mov    %esp,%ebp
  80061e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800621:	8b 45 0c             	mov    0xc(%ebp),%eax
  800624:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	01 d0                	add    %edx,%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800635:	8b 45 0c             	mov    0xc(%ebp),%eax
  800638:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	01 c2                	add    %eax,%edx
  800644:	8b 45 10             	mov    0x10(%ebp),%eax
  800647:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	01 c8                	add    %ecx,%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800657:	8b 45 10             	mov    0x10(%ebp),%eax
  80065a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	01 c2                	add    %eax,%edx
  800666:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800669:	89 02                	mov    %eax,(%edx)
}
  80066b:	90                   	nop
  80066c:	c9                   	leave  
  80066d:	c3                   	ret    

0080066e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80066e:	55                   	push   %ebp
  80066f:	89 e5                	mov    %esp,%ebp
  800671:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800674:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80067b:	eb 17                	jmp    800694 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80067d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800680:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	01 c2                	add    %eax,%edx
  80068c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80068f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800691:	ff 45 fc             	incl   -0x4(%ebp)
  800694:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800697:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80069a:	7c e1                	jl     80067d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80069c:	90                   	nop
  80069d:	c9                   	leave  
  80069e:	c3                   	ret    

0080069f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006ac:	eb 1b                	jmp    8006c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	01 c2                	add    %eax,%edx
  8006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006c3:	48                   	dec    %eax
  8006c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c6:	ff 45 fc             	incl   -0x4(%ebp)
  8006c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006cf:	7c dd                	jl     8006ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006d1:	90                   	nop
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8006e2:	f7 e9                	imul   %ecx
  8006e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e7:	89 d0                	mov    %edx,%eax
  8006e9:	29 c8                	sub    %ecx,%eax
  8006eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8006ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006f5:	eb 1e                	jmp    800715 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8006f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800707:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80070a:	99                   	cltd   
  80070b:	f7 7d f8             	idivl  -0x8(%ebp)
  80070e:	89 d0                	mov    %edx,%eax
  800710:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800712:	ff 45 fc             	incl   -0x4(%ebp)
  800715:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800718:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80071b:	7c da                	jl     8006f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80071d:	90                   	nop
  80071e:	c9                   	leave  
  80071f:	c3                   	ret    

00800720 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800726:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80072d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800734:	eb 42                	jmp    800778 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800739:	99                   	cltd   
  80073a:	f7 7d f0             	idivl  -0x10(%ebp)
  80073d:	89 d0                	mov    %edx,%eax
  80073f:	85 c0                	test   %eax,%eax
  800741:	75 10                	jne    800753 <PrintElements+0x33>
			cprintf("\n");
  800743:	83 ec 0c             	sub    $0xc,%esp
  800746:	68 c2 29 80 00       	push   $0x8029c2
  80074b:	e8 dd 04 00 00       	call   800c2d <cprintf>
  800750:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800756:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	01 d0                	add    %edx,%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	50                   	push   %eax
  800768:	68 c4 29 80 00       	push   $0x8029c4
  80076d:	e8 bb 04 00 00       	call   800c2d <cprintf>
  800772:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800775:	ff 45 f4             	incl   -0xc(%ebp)
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	48                   	dec    %eax
  80077c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80077f:	7f b5                	jg     800736 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800784:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	01 d0                	add    %edx,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	50                   	push   %eax
  800796:	68 c9 29 80 00       	push   $0x8029c9
  80079b:	e8 8d 04 00 00       	call   800c2d <cprintf>
  8007a0:	83 c4 10             	add    $0x10,%esp

}
  8007a3:	90                   	nop
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007b2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	50                   	push   %eax
  8007ba:	e8 55 19 00 00       	call   802114 <sys_cputc>
  8007bf:	83 c4 10             	add    $0x10,%esp
}
  8007c2:	90                   	nop
  8007c3:	c9                   	leave  
  8007c4:	c3                   	ret    

008007c5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007cb:	e8 10 19 00 00       	call   8020e0 <sys_disable_interrupt>
	char c = ch;
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007da:	83 ec 0c             	sub    $0xc,%esp
  8007dd:	50                   	push   %eax
  8007de:	e8 31 19 00 00       	call   802114 <sys_cputc>
  8007e3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8007e6:	e8 0f 19 00 00       	call   8020fa <sys_enable_interrupt>
}
  8007eb:	90                   	nop
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    

008007ee <getchar>:

int
getchar(void)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007fb:	eb 08                	jmp    800805 <getchar+0x17>
	{
		c = sys_cgetc();
  8007fd:	e8 f6 16 00 00       	call   801ef8 <sys_cgetc>
  800802:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800809:	74 f2                	je     8007fd <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80080e:	c9                   	leave  
  80080f:	c3                   	ret    

00800810 <atomic_getchar>:

int
atomic_getchar(void)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800816:	e8 c5 18 00 00       	call   8020e0 <sys_disable_interrupt>
	int c=0;
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800822:	eb 08                	jmp    80082c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800824:	e8 cf 16 00 00       	call   801ef8 <sys_cgetc>
  800829:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80082c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800830:	74 f2                	je     800824 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800832:	e8 c3 18 00 00       	call   8020fa <sys_enable_interrupt>
	return c;
  800837:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <iscons>:

int iscons(int fdnum)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80083f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800844:	5d                   	pop    %ebp
  800845:	c3                   	ret    

00800846 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80084c:	e8 f4 16 00 00       	call   801f45 <sys_getenvindex>
  800851:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800857:	89 d0                	mov    %edx,%eax
  800859:	c1 e0 03             	shl    $0x3,%eax
  80085c:	01 d0                	add    %edx,%eax
  80085e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800865:	01 c8                	add    %ecx,%eax
  800867:	01 c0                	add    %eax,%eax
  800869:	01 d0                	add    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	89 c2                	mov    %eax,%edx
  800871:	c1 e2 05             	shl    $0x5,%edx
  800874:	29 c2                	sub    %eax,%edx
  800876:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800885:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80088a:	a1 24 30 80 00       	mov    0x803024,%eax
  80088f:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800895:	84 c0                	test   %al,%al
  800897:	74 0f                	je     8008a8 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800899:	a1 24 30 80 00       	mov    0x803024,%eax
  80089e:	05 40 3c 01 00       	add    $0x13c40,%eax
  8008a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ac:	7e 0a                	jle    8008b8 <libmain+0x72>
		binaryname = argv[0];
  8008ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	ff 75 08             	pushl  0x8(%ebp)
  8008c1:	e8 72 f7 ff ff       	call   800038 <_main>
  8008c6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008c9:	e8 12 18 00 00       	call   8020e0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008ce:	83 ec 0c             	sub    $0xc,%esp
  8008d1:	68 e8 29 80 00       	push   $0x8029e8
  8008d6:	e8 52 03 00 00       	call   800c2d <cprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008de:	a1 24 30 80 00       	mov    0x803024,%eax
  8008e3:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8008e9:	a1 24 30 80 00       	mov    0x803024,%eax
  8008ee:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	52                   	push   %edx
  8008f8:	50                   	push   %eax
  8008f9:	68 10 2a 80 00       	push   $0x802a10
  8008fe:	e8 2a 03 00 00       	call   800c2d <cprintf>
  800903:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800906:	a1 24 30 80 00       	mov    0x803024,%eax
  80090b:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800911:	a1 24 30 80 00       	mov    0x803024,%eax
  800916:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	52                   	push   %edx
  800920:	50                   	push   %eax
  800921:	68 38 2a 80 00       	push   $0x802a38
  800926:	e8 02 03 00 00       	call   800c2d <cprintf>
  80092b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80092e:	a1 24 30 80 00       	mov    0x803024,%eax
  800933:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	50                   	push   %eax
  80093d:	68 79 2a 80 00       	push   $0x802a79
  800942:	e8 e6 02 00 00       	call   800c2d <cprintf>
  800947:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80094a:	83 ec 0c             	sub    $0xc,%esp
  80094d:	68 e8 29 80 00       	push   $0x8029e8
  800952:	e8 d6 02 00 00       	call   800c2d <cprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80095a:	e8 9b 17 00 00       	call   8020fa <sys_enable_interrupt>

	// exit gracefully
	exit();
  80095f:	e8 19 00 00 00       	call   80097d <exit>
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	6a 00                	push   $0x0
  800972:	e8 9a 15 00 00       	call   801f11 <sys_env_destroy>
  800977:	83 c4 10             	add    $0x10,%esp
}
  80097a:	90                   	nop
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    

0080097d <exit>:

void
exit(void)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800983:	e8 ef 15 00 00       	call   801f77 <sys_env_exit>
}
  800988:	90                   	nop
  800989:	c9                   	leave  
  80098a:	c3                   	ret    

0080098b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800991:	8d 45 10             	lea    0x10(%ebp),%eax
  800994:	83 c0 04             	add    $0x4,%eax
  800997:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80099a:	a1 18 31 80 00       	mov    0x803118,%eax
  80099f:	85 c0                	test   %eax,%eax
  8009a1:	74 16                	je     8009b9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009a3:	a1 18 31 80 00       	mov    0x803118,%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	50                   	push   %eax
  8009ac:	68 90 2a 80 00       	push   $0x802a90
  8009b1:	e8 77 02 00 00       	call   800c2d <cprintf>
  8009b6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009b9:	a1 00 30 80 00       	mov    0x803000,%eax
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	ff 75 08             	pushl  0x8(%ebp)
  8009c4:	50                   	push   %eax
  8009c5:	68 95 2a 80 00       	push   $0x802a95
  8009ca:	e8 5e 02 00 00       	call   800c2d <cprintf>
  8009cf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	e8 e1 01 00 00       	call   800bc2 <vcprintf>
  8009e1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	6a 00                	push   $0x0
  8009e9:	68 b1 2a 80 00       	push   $0x802ab1
  8009ee:	e8 cf 01 00 00       	call   800bc2 <vcprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009f6:	e8 82 ff ff ff       	call   80097d <exit>

	// should not return here
	while (1) ;
  8009fb:	eb fe                	jmp    8009fb <_panic+0x70>

008009fd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a03:	a1 24 30 80 00       	mov    0x803024,%eax
  800a08:	8b 50 74             	mov    0x74(%eax),%edx
  800a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0e:	39 c2                	cmp    %eax,%edx
  800a10:	74 14                	je     800a26 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a12:	83 ec 04             	sub    $0x4,%esp
  800a15:	68 b4 2a 80 00       	push   $0x802ab4
  800a1a:	6a 26                	push   $0x26
  800a1c:	68 00 2b 80 00       	push   $0x802b00
  800a21:	e8 65 ff ff ff       	call   80098b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a34:	e9 b6 00 00 00       	jmp    800aef <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	01 d0                	add    %edx,%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	85 c0                	test   %eax,%eax
  800a4c:	75 08                	jne    800a56 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a4e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a51:	e9 96 00 00 00       	jmp    800aec <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800a56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a64:	eb 5d                	jmp    800ac3 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a66:	a1 24 30 80 00       	mov    0x803024,%eax
  800a6b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a74:	c1 e2 04             	shl    $0x4,%edx
  800a77:	01 d0                	add    %edx,%eax
  800a79:	8a 40 04             	mov    0x4(%eax),%al
  800a7c:	84 c0                	test   %al,%al
  800a7e:	75 40                	jne    800ac0 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a80:	a1 24 30 80 00       	mov    0x803024,%eax
  800a85:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8e:	c1 e2 04             	shl    $0x4,%edx
  800a91:	01 d0                	add    %edx,%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800aa0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ab3:	39 c2                	cmp    %eax,%edx
  800ab5:	75 09                	jne    800ac0 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800ab7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800abe:	eb 12                	jmp    800ad2 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ac0:	ff 45 e8             	incl   -0x18(%ebp)
  800ac3:	a1 24 30 80 00       	mov    0x803024,%eax
  800ac8:	8b 50 74             	mov    0x74(%eax),%edx
  800acb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ace:	39 c2                	cmp    %eax,%edx
  800ad0:	77 94                	ja     800a66 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800ad2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ad6:	75 14                	jne    800aec <CheckWSWithoutLastIndex+0xef>
			panic(
  800ad8:	83 ec 04             	sub    $0x4,%esp
  800adb:	68 0c 2b 80 00       	push   $0x802b0c
  800ae0:	6a 3a                	push   $0x3a
  800ae2:	68 00 2b 80 00       	push   $0x802b00
  800ae7:	e8 9f fe ff ff       	call   80098b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800aec:	ff 45 f0             	incl   -0x10(%ebp)
  800aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800af5:	0f 8c 3e ff ff ff    	jl     800a39 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800afb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b02:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b09:	eb 20                	jmp    800b2b <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b0b:	a1 24 30 80 00       	mov    0x803024,%eax
  800b10:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b16:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b19:	c1 e2 04             	shl    $0x4,%edx
  800b1c:	01 d0                	add    %edx,%eax
  800b1e:	8a 40 04             	mov    0x4(%eax),%al
  800b21:	3c 01                	cmp    $0x1,%al
  800b23:	75 03                	jne    800b28 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800b25:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b28:	ff 45 e0             	incl   -0x20(%ebp)
  800b2b:	a1 24 30 80 00       	mov    0x803024,%eax
  800b30:	8b 50 74             	mov    0x74(%eax),%edx
  800b33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b36:	39 c2                	cmp    %eax,%edx
  800b38:	77 d1                	ja     800b0b <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b3d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b40:	74 14                	je     800b56 <CheckWSWithoutLastIndex+0x159>
		panic(
  800b42:	83 ec 04             	sub    $0x4,%esp
  800b45:	68 60 2b 80 00       	push   $0x802b60
  800b4a:	6a 44                	push   $0x44
  800b4c:	68 00 2b 80 00       	push   $0x802b00
  800b51:	e8 35 fe ff ff       	call   80098b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b56:	90                   	nop
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b62:	8b 00                	mov    (%eax),%eax
  800b64:	8d 48 01             	lea    0x1(%eax),%ecx
  800b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6a:	89 0a                	mov    %ecx,(%edx)
  800b6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6f:	88 d1                	mov    %dl,%cl
  800b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b74:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b82:	75 2c                	jne    800bb0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b84:	a0 28 30 80 00       	mov    0x803028,%al
  800b89:	0f b6 c0             	movzbl %al,%eax
  800b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8f:	8b 12                	mov    (%edx),%edx
  800b91:	89 d1                	mov    %edx,%ecx
  800b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b96:	83 c2 08             	add    $0x8,%edx
  800b99:	83 ec 04             	sub    $0x4,%esp
  800b9c:	50                   	push   %eax
  800b9d:	51                   	push   %ecx
  800b9e:	52                   	push   %edx
  800b9f:	e8 2b 13 00 00       	call   801ecf <sys_cputs>
  800ba4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	8b 40 04             	mov    0x4(%eax),%eax
  800bb6:	8d 50 01             	lea    0x1(%eax),%edx
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bbf:	90                   	nop
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bcb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bd2:	00 00 00 
	b.cnt = 0;
  800bd5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bdc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	ff 75 08             	pushl  0x8(%ebp)
  800be5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800beb:	50                   	push   %eax
  800bec:	68 59 0b 80 00       	push   $0x800b59
  800bf1:	e8 11 02 00 00       	call   800e07 <vprintfmt>
  800bf6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800bf9:	a0 28 30 80 00       	mov    0x803028,%al
  800bfe:	0f b6 c0             	movzbl %al,%eax
  800c01:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c07:	83 ec 04             	sub    $0x4,%esp
  800c0a:	50                   	push   %eax
  800c0b:	52                   	push   %edx
  800c0c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c12:	83 c0 08             	add    $0x8,%eax
  800c15:	50                   	push   %eax
  800c16:	e8 b4 12 00 00       	call   801ecf <sys_cputs>
  800c1b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c1e:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800c25:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <cprintf>:

int cprintf(const char *fmt, ...) {
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c33:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800c3a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	83 ec 08             	sub    $0x8,%esp
  800c46:	ff 75 f4             	pushl  -0xc(%ebp)
  800c49:	50                   	push   %eax
  800c4a:	e8 73 ff ff ff       	call   800bc2 <vcprintf>
  800c4f:	83 c4 10             	add    $0x10,%esp
  800c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c60:	e8 7b 14 00 00       	call   8020e0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c65:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 f4             	pushl  -0xc(%ebp)
  800c74:	50                   	push   %eax
  800c75:	e8 48 ff ff ff       	call   800bc2 <vcprintf>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c80:	e8 75 14 00 00       	call   8020fa <sys_enable_interrupt>
	return cnt;
  800c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	53                   	push   %ebx
  800c8e:	83 ec 14             	sub    $0x14,%esp
  800c91:	8b 45 10             	mov    0x10(%ebp),%eax
  800c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c9d:	8b 45 18             	mov    0x18(%ebp),%eax
  800ca0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ca8:	77 55                	ja     800cff <printnum+0x75>
  800caa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cad:	72 05                	jb     800cb4 <printnum+0x2a>
  800caf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cb2:	77 4b                	ja     800cff <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cb4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cb7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cba:	8b 45 18             	mov    0x18(%ebp),%eax
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	52                   	push   %edx
  800cc3:	50                   	push   %eax
  800cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc7:	ff 75 f0             	pushl  -0x10(%ebp)
  800cca:	e8 35 18 00 00       	call   802504 <__udivdi3>
  800ccf:	83 c4 10             	add    $0x10,%esp
  800cd2:	83 ec 04             	sub    $0x4,%esp
  800cd5:	ff 75 20             	pushl  0x20(%ebp)
  800cd8:	53                   	push   %ebx
  800cd9:	ff 75 18             	pushl  0x18(%ebp)
  800cdc:	52                   	push   %edx
  800cdd:	50                   	push   %eax
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	ff 75 08             	pushl  0x8(%ebp)
  800ce4:	e8 a1 ff ff ff       	call   800c8a <printnum>
  800ce9:	83 c4 20             	add    $0x20,%esp
  800cec:	eb 1a                	jmp    800d08 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	ff 75 20             	pushl  0x20(%ebp)
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	ff d0                	call   *%eax
  800cfc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cff:	ff 4d 1c             	decl   0x1c(%ebp)
  800d02:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d06:	7f e6                	jg     800cee <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d08:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d16:	53                   	push   %ebx
  800d17:	51                   	push   %ecx
  800d18:	52                   	push   %edx
  800d19:	50                   	push   %eax
  800d1a:	e8 f5 18 00 00       	call   802614 <__umoddi3>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	05 d4 2d 80 00       	add    $0x802dd4,%eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	0f be c0             	movsbl %al,%eax
  800d2c:	83 ec 08             	sub    $0x8,%esp
  800d2f:	ff 75 0c             	pushl  0xc(%ebp)
  800d32:	50                   	push   %eax
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	ff d0                	call   *%eax
  800d38:	83 c4 10             	add    $0x10,%esp
}
  800d3b:	90                   	nop
  800d3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d3f:	c9                   	leave  
  800d40:	c3                   	ret    

00800d41 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d44:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d48:	7e 1c                	jle    800d66 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8b 00                	mov    (%eax),%eax
  800d4f:	8d 50 08             	lea    0x8(%eax),%edx
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	89 10                	mov    %edx,(%eax)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	83 e8 08             	sub    $0x8,%eax
  800d5f:	8b 50 04             	mov    0x4(%eax),%edx
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	eb 40                	jmp    800da6 <getuint+0x65>
	else if (lflag)
  800d66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6a:	74 1e                	je     800d8a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8b 00                	mov    (%eax),%eax
  800d71:	8d 50 04             	lea    0x4(%eax),%edx
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	89 10                	mov    %edx,(%eax)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	83 e8 04             	sub    $0x4,%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	ba 00 00 00 00       	mov    $0x0,%edx
  800d88:	eb 1c                	jmp    800da6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	8d 50 04             	lea    0x4(%eax),%edx
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	89 10                	mov    %edx,(%eax)
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	83 e8 04             	sub    $0x4,%eax
  800d9f:	8b 00                	mov    (%eax),%eax
  800da1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800daf:	7e 1c                	jle    800dcd <getint+0x25>
		return va_arg(*ap, long long);
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8b 00                	mov    (%eax),%eax
  800db6:	8d 50 08             	lea    0x8(%eax),%edx
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	89 10                	mov    %edx,(%eax)
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	83 e8 08             	sub    $0x8,%eax
  800dc6:	8b 50 04             	mov    0x4(%eax),%edx
  800dc9:	8b 00                	mov    (%eax),%eax
  800dcb:	eb 38                	jmp    800e05 <getint+0x5d>
	else if (lflag)
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	74 1a                	je     800ded <getint+0x45>
		return va_arg(*ap, long);
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8b 00                	mov    (%eax),%eax
  800dd8:	8d 50 04             	lea    0x4(%eax),%edx
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	89 10                	mov    %edx,(%eax)
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8b 00                	mov    (%eax),%eax
  800de5:	83 e8 04             	sub    $0x4,%eax
  800de8:	8b 00                	mov    (%eax),%eax
  800dea:	99                   	cltd   
  800deb:	eb 18                	jmp    800e05 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	8d 50 04             	lea    0x4(%eax),%edx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	89 10                	mov    %edx,(%eax)
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	83 e8 04             	sub    $0x4,%eax
  800e02:	8b 00                	mov    (%eax),%eax
  800e04:	99                   	cltd   
}
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    

00800e07 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e0f:	eb 17                	jmp    800e28 <vprintfmt+0x21>
			if (ch == '\0')
  800e11:	85 db                	test   %ebx,%ebx
  800e13:	0f 84 af 03 00 00    	je     8011c8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	53                   	push   %ebx
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	ff d0                	call   *%eax
  800e25:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	8d 50 01             	lea    0x1(%eax),%edx
  800e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	0f b6 d8             	movzbl %al,%ebx
  800e36:	83 fb 25             	cmp    $0x25,%ebx
  800e39:	75 d6                	jne    800e11 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e3b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e3f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e46:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e4d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e54:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 10             	mov    %edx,0x10(%ebp)
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	0f b6 d8             	movzbl %al,%ebx
  800e69:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e6c:	83 f8 55             	cmp    $0x55,%eax
  800e6f:	0f 87 2b 03 00 00    	ja     8011a0 <vprintfmt+0x399>
  800e75:	8b 04 85 f8 2d 80 00 	mov    0x802df8(,%eax,4),%eax
  800e7c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e7e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e82:	eb d7                	jmp    800e5b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e84:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e88:	eb d1                	jmp    800e5b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e94:	89 d0                	mov    %edx,%eax
  800e96:	c1 e0 02             	shl    $0x2,%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	01 c0                	add    %eax,%eax
  800e9d:	01 d8                	add    %ebx,%eax
  800e9f:	83 e8 30             	sub    $0x30,%eax
  800ea2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ead:	83 fb 2f             	cmp    $0x2f,%ebx
  800eb0:	7e 3e                	jle    800ef0 <vprintfmt+0xe9>
  800eb2:	83 fb 39             	cmp    $0x39,%ebx
  800eb5:	7f 39                	jg     800ef0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eba:	eb d5                	jmp    800e91 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ebc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebf:	83 c0 04             	add    $0x4,%eax
  800ec2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec8:	83 e8 04             	sub    $0x4,%eax
  800ecb:	8b 00                	mov    (%eax),%eax
  800ecd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ed0:	eb 1f                	jmp    800ef1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ed2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed6:	79 83                	jns    800e5b <vprintfmt+0x54>
				width = 0;
  800ed8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800edf:	e9 77 ff ff ff       	jmp    800e5b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ee4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eeb:	e9 6b ff ff ff       	jmp    800e5b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ef0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ef1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef5:	0f 89 60 ff ff ff    	jns    800e5b <vprintfmt+0x54>
				width = precision, precision = -1;
  800efb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800efe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f01:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f08:	e9 4e ff ff ff       	jmp    800e5b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f0d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f10:	e9 46 ff ff ff       	jmp    800e5b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f15:	8b 45 14             	mov    0x14(%ebp),%eax
  800f18:	83 c0 04             	add    $0x4,%eax
  800f1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	ff 75 0c             	pushl  0xc(%ebp)
  800f2c:	50                   	push   %eax
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			break;
  800f35:	e9 89 02 00 00       	jmp    8011c3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3d:	83 c0 04             	add    $0x4,%eax
  800f40:	89 45 14             	mov    %eax,0x14(%ebp)
  800f43:	8b 45 14             	mov    0x14(%ebp),%eax
  800f46:	83 e8 04             	sub    $0x4,%eax
  800f49:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f4b:	85 db                	test   %ebx,%ebx
  800f4d:	79 02                	jns    800f51 <vprintfmt+0x14a>
				err = -err;
  800f4f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f51:	83 fb 64             	cmp    $0x64,%ebx
  800f54:	7f 0b                	jg     800f61 <vprintfmt+0x15a>
  800f56:	8b 34 9d 40 2c 80 00 	mov    0x802c40(,%ebx,4),%esi
  800f5d:	85 f6                	test   %esi,%esi
  800f5f:	75 19                	jne    800f7a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f61:	53                   	push   %ebx
  800f62:	68 e5 2d 80 00       	push   $0x802de5
  800f67:	ff 75 0c             	pushl  0xc(%ebp)
  800f6a:	ff 75 08             	pushl  0x8(%ebp)
  800f6d:	e8 5e 02 00 00       	call   8011d0 <printfmt>
  800f72:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f75:	e9 49 02 00 00       	jmp    8011c3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f7a:	56                   	push   %esi
  800f7b:	68 ee 2d 80 00       	push   $0x802dee
  800f80:	ff 75 0c             	pushl  0xc(%ebp)
  800f83:	ff 75 08             	pushl  0x8(%ebp)
  800f86:	e8 45 02 00 00       	call   8011d0 <printfmt>
  800f8b:	83 c4 10             	add    $0x10,%esp
			break;
  800f8e:	e9 30 02 00 00       	jmp    8011c3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f93:	8b 45 14             	mov    0x14(%ebp),%eax
  800f96:	83 c0 04             	add    $0x4,%eax
  800f99:	89 45 14             	mov    %eax,0x14(%ebp)
  800f9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9f:	83 e8 04             	sub    $0x4,%eax
  800fa2:	8b 30                	mov    (%eax),%esi
  800fa4:	85 f6                	test   %esi,%esi
  800fa6:	75 05                	jne    800fad <vprintfmt+0x1a6>
				p = "(null)";
  800fa8:	be f1 2d 80 00       	mov    $0x802df1,%esi
			if (width > 0 && padc != '-')
  800fad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb1:	7e 6d                	jle    801020 <vprintfmt+0x219>
  800fb3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fb7:	74 67                	je     801020 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fbc:	83 ec 08             	sub    $0x8,%esp
  800fbf:	50                   	push   %eax
  800fc0:	56                   	push   %esi
  800fc1:	e8 12 05 00 00       	call   8014d8 <strnlen>
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fcc:	eb 16                	jmp    800fe4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fce:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	50                   	push   %eax
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe1:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe8:	7f e4                	jg     800fce <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fea:	eb 34                	jmp    801020 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ff0:	74 1c                	je     80100e <vprintfmt+0x207>
  800ff2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ff5:	7e 05                	jle    800ffc <vprintfmt+0x1f5>
  800ff7:	83 fb 7e             	cmp    $0x7e,%ebx
  800ffa:	7e 12                	jle    80100e <vprintfmt+0x207>
					putch('?', putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	6a 3f                	push   $0x3f
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	ff d0                	call   *%eax
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	eb 0f                	jmp    80101d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	53                   	push   %ebx
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	ff d0                	call   *%eax
  80101a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80101d:	ff 4d e4             	decl   -0x1c(%ebp)
  801020:	89 f0                	mov    %esi,%eax
  801022:	8d 70 01             	lea    0x1(%eax),%esi
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f be d8             	movsbl %al,%ebx
  80102a:	85 db                	test   %ebx,%ebx
  80102c:	74 24                	je     801052 <vprintfmt+0x24b>
  80102e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801032:	78 b8                	js     800fec <vprintfmt+0x1e5>
  801034:	ff 4d e0             	decl   -0x20(%ebp)
  801037:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80103b:	79 af                	jns    800fec <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80103d:	eb 13                	jmp    801052 <vprintfmt+0x24b>
				putch(' ', putdat);
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	ff 75 0c             	pushl  0xc(%ebp)
  801045:	6a 20                	push   $0x20
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	ff d0                	call   *%eax
  80104c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80104f:	ff 4d e4             	decl   -0x1c(%ebp)
  801052:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801056:	7f e7                	jg     80103f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801058:	e9 66 01 00 00       	jmp    8011c3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	ff 75 e8             	pushl  -0x18(%ebp)
  801063:	8d 45 14             	lea    0x14(%ebp),%eax
  801066:	50                   	push   %eax
  801067:	e8 3c fd ff ff       	call   800da8 <getint>
  80106c:	83 c4 10             	add    $0x10,%esp
  80106f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801072:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107b:	85 d2                	test   %edx,%edx
  80107d:	79 23                	jns    8010a2 <vprintfmt+0x29b>
				putch('-', putdat);
  80107f:	83 ec 08             	sub    $0x8,%esp
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	6a 2d                	push   $0x2d
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80108f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801095:	f7 d8                	neg    %eax
  801097:	83 d2 00             	adc    $0x0,%edx
  80109a:	f7 da                	neg    %edx
  80109c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010a2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010a9:	e9 bc 00 00 00       	jmp    80116a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010ae:	83 ec 08             	sub    $0x8,%esp
  8010b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b7:	50                   	push   %eax
  8010b8:	e8 84 fc ff ff       	call   800d41 <getuint>
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010cd:	e9 98 00 00 00       	jmp    80116a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010d2:	83 ec 08             	sub    $0x8,%esp
  8010d5:	ff 75 0c             	pushl  0xc(%ebp)
  8010d8:	6a 58                	push   $0x58
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	ff d0                	call   *%eax
  8010df:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010e2:	83 ec 08             	sub    $0x8,%esp
  8010e5:	ff 75 0c             	pushl  0xc(%ebp)
  8010e8:	6a 58                	push   $0x58
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	ff d0                	call   *%eax
  8010ef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010f2:	83 ec 08             	sub    $0x8,%esp
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	6a 58                	push   $0x58
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	ff d0                	call   *%eax
  8010ff:	83 c4 10             	add    $0x10,%esp
			break;
  801102:	e9 bc 00 00 00       	jmp    8011c3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801107:	83 ec 08             	sub    $0x8,%esp
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	6a 30                	push   $0x30
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	ff d0                	call   *%eax
  801114:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	6a 78                	push   $0x78
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	ff d0                	call   *%eax
  801124:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801127:	8b 45 14             	mov    0x14(%ebp),%eax
  80112a:	83 c0 04             	add    $0x4,%eax
  80112d:	89 45 14             	mov    %eax,0x14(%ebp)
  801130:	8b 45 14             	mov    0x14(%ebp),%eax
  801133:	83 e8 04             	sub    $0x4,%eax
  801136:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801138:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801142:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801149:	eb 1f                	jmp    80116a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80114b:	83 ec 08             	sub    $0x8,%esp
  80114e:	ff 75 e8             	pushl  -0x18(%ebp)
  801151:	8d 45 14             	lea    0x14(%ebp),%eax
  801154:	50                   	push   %eax
  801155:	e8 e7 fb ff ff       	call   800d41 <getuint>
  80115a:	83 c4 10             	add    $0x10,%esp
  80115d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801160:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801163:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80116a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80116e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	52                   	push   %edx
  801175:	ff 75 e4             	pushl  -0x1c(%ebp)
  801178:	50                   	push   %eax
  801179:	ff 75 f4             	pushl  -0xc(%ebp)
  80117c:	ff 75 f0             	pushl  -0x10(%ebp)
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	ff 75 08             	pushl  0x8(%ebp)
  801185:	e8 00 fb ff ff       	call   800c8a <printnum>
  80118a:	83 c4 20             	add    $0x20,%esp
			break;
  80118d:	eb 34                	jmp    8011c3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	ff 75 0c             	pushl  0xc(%ebp)
  801195:	53                   	push   %ebx
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	ff d0                	call   *%eax
  80119b:	83 c4 10             	add    $0x10,%esp
			break;
  80119e:	eb 23                	jmp    8011c3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	6a 25                	push   $0x25
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	ff d0                	call   *%eax
  8011ad:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011b0:	ff 4d 10             	decl   0x10(%ebp)
  8011b3:	eb 03                	jmp    8011b8 <vprintfmt+0x3b1>
  8011b5:	ff 4d 10             	decl   0x10(%ebp)
  8011b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bb:	48                   	dec    %eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3c 25                	cmp    $0x25,%al
  8011c0:	75 f3                	jne    8011b5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011c2:	90                   	nop
		}
	}
  8011c3:	e9 47 fc ff ff       	jmp    800e0f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011c8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011cc:	5b                   	pop    %ebx
  8011cd:	5e                   	pop    %esi
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011d6:	8d 45 10             	lea    0x10(%ebp),%eax
  8011d9:	83 c0 04             	add    $0x4,%eax
  8011dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011df:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e5:	50                   	push   %eax
  8011e6:	ff 75 0c             	pushl  0xc(%ebp)
  8011e9:	ff 75 08             	pushl  0x8(%ebp)
  8011ec:	e8 16 fc ff ff       	call   800e07 <vprintfmt>
  8011f1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011f4:	90                   	nop
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	8b 40 08             	mov    0x8(%eax),%eax
  801200:	8d 50 01             	lea    0x1(%eax),%edx
  801203:	8b 45 0c             	mov    0xc(%ebp),%eax
  801206:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	8b 10                	mov    (%eax),%edx
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	8b 40 04             	mov    0x4(%eax),%eax
  801214:	39 c2                	cmp    %eax,%edx
  801216:	73 12                	jae    80122a <sprintputch+0x33>
		*b->buf++ = ch;
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	8b 00                	mov    (%eax),%eax
  80121d:	8d 48 01             	lea    0x1(%eax),%ecx
  801220:	8b 55 0c             	mov    0xc(%ebp),%edx
  801223:	89 0a                	mov    %ecx,(%edx)
  801225:	8b 55 08             	mov    0x8(%ebp),%edx
  801228:	88 10                	mov    %dl,(%eax)
}
  80122a:	90                   	nop
  80122b:	5d                   	pop    %ebp
  80122c:	c3                   	ret    

0080122d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801247:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80124e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801252:	74 06                	je     80125a <vsnprintf+0x2d>
  801254:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801258:	7f 07                	jg     801261 <vsnprintf+0x34>
		return -E_INVAL;
  80125a:	b8 03 00 00 00       	mov    $0x3,%eax
  80125f:	eb 20                	jmp    801281 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801261:	ff 75 14             	pushl  0x14(%ebp)
  801264:	ff 75 10             	pushl  0x10(%ebp)
  801267:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80126a:	50                   	push   %eax
  80126b:	68 f7 11 80 00       	push   $0x8011f7
  801270:	e8 92 fb ff ff       	call   800e07 <vprintfmt>
  801275:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80127b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80127e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801289:	8d 45 10             	lea    0x10(%ebp),%eax
  80128c:	83 c0 04             	add    $0x4,%eax
  80128f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801292:	8b 45 10             	mov    0x10(%ebp),%eax
  801295:	ff 75 f4             	pushl  -0xc(%ebp)
  801298:	50                   	push   %eax
  801299:	ff 75 0c             	pushl  0xc(%ebp)
  80129c:	ff 75 08             	pushl  0x8(%ebp)
  80129f:	e8 89 ff ff ff       	call   80122d <vsnprintf>
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b9:	74 13                	je     8012ce <readline+0x1f>
		cprintf("%s", prompt);
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	68 50 2f 80 00       	push   $0x802f50
  8012c6:	e8 62 f9 ff ff       	call   800c2d <cprintf>
  8012cb:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	6a 00                	push   $0x0
  8012da:	e8 5d f5 ff ff       	call   80083c <iscons>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012e5:	e8 04 f5 ff ff       	call   8007ee <getchar>
  8012ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f1:	79 22                	jns    801315 <readline+0x66>
			if (c != -E_EOF)
  8012f3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012f7:	0f 84 ad 00 00 00    	je     8013aa <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	ff 75 ec             	pushl  -0x14(%ebp)
  801303:	68 53 2f 80 00       	push   $0x802f53
  801308:	e8 20 f9 ff ff       	call   800c2d <cprintf>
  80130d:	83 c4 10             	add    $0x10,%esp
			return;
  801310:	e9 95 00 00 00       	jmp    8013aa <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801315:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801319:	7e 34                	jle    80134f <readline+0xa0>
  80131b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801322:	7f 2b                	jg     80134f <readline+0xa0>
			if (echoing)
  801324:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801328:	74 0e                	je     801338 <readline+0x89>
				cputchar(c);
  80132a:	83 ec 0c             	sub    $0xc,%esp
  80132d:	ff 75 ec             	pushl  -0x14(%ebp)
  801330:	e8 71 f4 ff ff       	call   8007a6 <cputchar>
  801335:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133b:	8d 50 01             	lea    0x1(%eax),%edx
  80133e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801341:	89 c2                	mov    %eax,%edx
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	01 d0                	add    %edx,%eax
  801348:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80134b:	88 10                	mov    %dl,(%eax)
  80134d:	eb 56                	jmp    8013a5 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80134f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801353:	75 1f                	jne    801374 <readline+0xc5>
  801355:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801359:	7e 19                	jle    801374 <readline+0xc5>
			if (echoing)
  80135b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80135f:	74 0e                	je     80136f <readline+0xc0>
				cputchar(c);
  801361:	83 ec 0c             	sub    $0xc,%esp
  801364:	ff 75 ec             	pushl  -0x14(%ebp)
  801367:	e8 3a f4 ff ff       	call   8007a6 <cputchar>
  80136c:	83 c4 10             	add    $0x10,%esp

			i--;
  80136f:	ff 4d f4             	decl   -0xc(%ebp)
  801372:	eb 31                	jmp    8013a5 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801374:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801378:	74 0a                	je     801384 <readline+0xd5>
  80137a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80137e:	0f 85 61 ff ff ff    	jne    8012e5 <readline+0x36>
			if (echoing)
  801384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801388:	74 0e                	je     801398 <readline+0xe9>
				cputchar(c);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	ff 75 ec             	pushl  -0x14(%ebp)
  801390:	e8 11 f4 ff ff       	call   8007a6 <cputchar>
  801395:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801398:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013a3:	eb 06                	jmp    8013ab <readline+0xfc>
		}
	}
  8013a5:	e9 3b ff ff ff       	jmp    8012e5 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013aa:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013b3:	e8 28 0d 00 00       	call   8020e0 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013bc:	74 13                	je     8013d1 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	68 50 2f 80 00       	push   $0x802f50
  8013c9:	e8 5f f8 ff ff       	call   800c2d <cprintf>
  8013ce:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	6a 00                	push   $0x0
  8013dd:	e8 5a f4 ff ff       	call   80083c <iscons>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8013e8:	e8 01 f4 ff ff       	call   8007ee <getchar>
  8013ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013f4:	79 23                	jns    801419 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8013f6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013fa:	74 13                	je     80140f <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8013fc:	83 ec 08             	sub    $0x8,%esp
  8013ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801402:	68 53 2f 80 00       	push   $0x802f53
  801407:	e8 21 f8 ff ff       	call   800c2d <cprintf>
  80140c:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80140f:	e8 e6 0c 00 00       	call   8020fa <sys_enable_interrupt>
			return;
  801414:	e9 9a 00 00 00       	jmp    8014b3 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801419:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80141d:	7e 34                	jle    801453 <atomic_readline+0xa6>
  80141f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801426:	7f 2b                	jg     801453 <atomic_readline+0xa6>
			if (echoing)
  801428:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80142c:	74 0e                	je     80143c <atomic_readline+0x8f>
				cputchar(c);
  80142e:	83 ec 0c             	sub    $0xc,%esp
  801431:	ff 75 ec             	pushl  -0x14(%ebp)
  801434:	e8 6d f3 ff ff       	call   8007a6 <cputchar>
  801439:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80143c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143f:	8d 50 01             	lea    0x1(%eax),%edx
  801442:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801445:	89 c2                	mov    %eax,%edx
  801447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144a:	01 d0                	add    %edx,%eax
  80144c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80144f:	88 10                	mov    %dl,(%eax)
  801451:	eb 5b                	jmp    8014ae <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801453:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801457:	75 1f                	jne    801478 <atomic_readline+0xcb>
  801459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80145d:	7e 19                	jle    801478 <atomic_readline+0xcb>
			if (echoing)
  80145f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801463:	74 0e                	je     801473 <atomic_readline+0xc6>
				cputchar(c);
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	ff 75 ec             	pushl  -0x14(%ebp)
  80146b:	e8 36 f3 ff ff       	call   8007a6 <cputchar>
  801470:	83 c4 10             	add    $0x10,%esp
			i--;
  801473:	ff 4d f4             	decl   -0xc(%ebp)
  801476:	eb 36                	jmp    8014ae <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801478:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80147c:	74 0a                	je     801488 <atomic_readline+0xdb>
  80147e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801482:	0f 85 60 ff ff ff    	jne    8013e8 <atomic_readline+0x3b>
			if (echoing)
  801488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148c:	74 0e                	je     80149c <atomic_readline+0xef>
				cputchar(c);
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	ff 75 ec             	pushl  -0x14(%ebp)
  801494:	e8 0d f3 ff ff       	call   8007a6 <cputchar>
  801499:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80149c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	01 d0                	add    %edx,%eax
  8014a4:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014a7:	e8 4e 0c 00 00       	call   8020fa <sys_enable_interrupt>
			return;
  8014ac:	eb 05                	jmp    8014b3 <atomic_readline+0x106>
		}
	}
  8014ae:	e9 35 ff ff ff       	jmp    8013e8 <atomic_readline+0x3b>
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c2:	eb 06                	jmp    8014ca <strlen+0x15>
		n++;
  8014c4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014c7:	ff 45 08             	incl   0x8(%ebp)
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 f1                	jne    8014c4 <strlen+0xf>
		n++;
	return n;
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e5:	eb 09                	jmp    8014f0 <strnlen+0x18>
		n++;
  8014e7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 4d 0c             	decl   0xc(%ebp)
  8014f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f4:	74 09                	je     8014ff <strnlen+0x27>
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	84 c0                	test   %al,%al
  8014fd:	75 e8                	jne    8014e7 <strnlen+0xf>
		n++;
	return n;
  8014ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801510:	90                   	nop
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8d 50 01             	lea    0x1(%eax),%edx
  801517:	89 55 08             	mov    %edx,0x8(%ebp)
  80151a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801520:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801523:	8a 12                	mov    (%edx),%dl
  801525:	88 10                	mov    %dl,(%eax)
  801527:	8a 00                	mov    (%eax),%al
  801529:	84 c0                	test   %al,%al
  80152b:	75 e4                	jne    801511 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80152d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80153e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801545:	eb 1f                	jmp    801566 <strncpy+0x34>
		*dst++ = *src;
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8d 50 01             	lea    0x1(%eax),%edx
  80154d:	89 55 08             	mov    %edx,0x8(%ebp)
  801550:	8b 55 0c             	mov    0xc(%ebp),%edx
  801553:	8a 12                	mov    (%edx),%dl
  801555:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	84 c0                	test   %al,%al
  80155e:	74 03                	je     801563 <strncpy+0x31>
			src++;
  801560:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801563:	ff 45 fc             	incl   -0x4(%ebp)
  801566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801569:	3b 45 10             	cmp    0x10(%ebp),%eax
  80156c:	72 d9                	jb     801547 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80156e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80157f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801583:	74 30                	je     8015b5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801585:	eb 16                	jmp    80159d <strlcpy+0x2a>
			*dst++ = *src++;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8d 50 01             	lea    0x1(%eax),%edx
  80158d:	89 55 08             	mov    %edx,0x8(%ebp)
  801590:	8b 55 0c             	mov    0xc(%ebp),%edx
  801593:	8d 4a 01             	lea    0x1(%edx),%ecx
  801596:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801599:	8a 12                	mov    (%edx),%dl
  80159b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80159d:	ff 4d 10             	decl   0x10(%ebp)
  8015a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a4:	74 09                	je     8015af <strlcpy+0x3c>
  8015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	84 c0                	test   %al,%al
  8015ad:	75 d8                	jne    801587 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bb:	29 c2                	sub    %eax,%edx
  8015bd:	89 d0                	mov    %edx,%eax
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015c4:	eb 06                	jmp    8015cc <strcmp+0xb>
		p++, q++;
  8015c6:	ff 45 08             	incl   0x8(%ebp)
  8015c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	84 c0                	test   %al,%al
  8015d3:	74 0e                	je     8015e3 <strcmp+0x22>
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8a 10                	mov    (%eax),%dl
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	8a 00                	mov    (%eax),%al
  8015df:	38 c2                	cmp    %al,%dl
  8015e1:	74 e3                	je     8015c6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	0f b6 d0             	movzbl %al,%edx
  8015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	0f b6 c0             	movzbl %al,%eax
  8015f3:	29 c2                	sub    %eax,%edx
  8015f5:	89 d0                	mov    %edx,%eax
}
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    

008015f9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015fc:	eb 09                	jmp    801607 <strncmp+0xe>
		n--, p++, q++;
  8015fe:	ff 4d 10             	decl   0x10(%ebp)
  801601:	ff 45 08             	incl   0x8(%ebp)
  801604:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801607:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80160b:	74 17                	je     801624 <strncmp+0x2b>
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	84 c0                	test   %al,%al
  801614:	74 0e                	je     801624 <strncmp+0x2b>
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8a 10                	mov    (%eax),%dl
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	38 c2                	cmp    %al,%dl
  801622:	74 da                	je     8015fe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801624:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801628:	75 07                	jne    801631 <strncmp+0x38>
		return 0;
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
  80162f:	eb 14                	jmp    801645 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	0f b6 d0             	movzbl %al,%edx
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	0f b6 c0             	movzbl %al,%eax
  801641:	29 c2                	sub    %eax,%edx
  801643:	89 d0                	mov    %edx,%eax
}
  801645:	5d                   	pop    %ebp
  801646:	c3                   	ret    

00801647 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801650:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801653:	eb 12                	jmp    801667 <strchr+0x20>
		if (*s == c)
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80165d:	75 05                	jne    801664 <strchr+0x1d>
			return (char *) s;
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	eb 11                	jmp    801675 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801664:	ff 45 08             	incl   0x8(%ebp)
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8a 00                	mov    (%eax),%al
  80166c:	84 c0                	test   %al,%al
  80166e:	75 e5                	jne    801655 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801683:	eb 0d                	jmp    801692 <strfind+0x1b>
		if (*s == c)
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80168d:	74 0e                	je     80169d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80168f:	ff 45 08             	incl   0x8(%ebp)
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	84 c0                	test   %al,%al
  801699:	75 ea                	jne    801685 <strfind+0xe>
  80169b:	eb 01                	jmp    80169e <strfind+0x27>
		if (*s == c)
			break;
  80169d:	90                   	nop
	return (char *) s;
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016b5:	eb 0e                	jmp    8016c5 <memset+0x22>
		*p++ = c;
  8016b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ba:	8d 50 01             	lea    0x1(%eax),%edx
  8016bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016c5:	ff 4d f8             	decl   -0x8(%ebp)
  8016c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016cc:	79 e9                	jns    8016b7 <memset+0x14>
		*p++ = c;

	return v;
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016e5:	eb 16                	jmp    8016fd <memcpy+0x2a>
		*d++ = *s++;
  8016e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ea:	8d 50 01             	lea    0x1(%eax),%edx
  8016ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016f6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016f9:	8a 12                	mov    (%edx),%dl
  8016fb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8016fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801700:	8d 50 ff             	lea    -0x1(%eax),%edx
  801703:	89 55 10             	mov    %edx,0x10(%ebp)
  801706:	85 c0                	test   %eax,%eax
  801708:	75 dd                	jne    8016e7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801721:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801724:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801727:	73 50                	jae    801779 <memmove+0x6a>
  801729:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172c:	8b 45 10             	mov    0x10(%ebp),%eax
  80172f:	01 d0                	add    %edx,%eax
  801731:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801734:	76 43                	jbe    801779 <memmove+0x6a>
		s += n;
  801736:	8b 45 10             	mov    0x10(%ebp),%eax
  801739:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80173c:	8b 45 10             	mov    0x10(%ebp),%eax
  80173f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801742:	eb 10                	jmp    801754 <memmove+0x45>
			*--d = *--s;
  801744:	ff 4d f8             	decl   -0x8(%ebp)
  801747:	ff 4d fc             	decl   -0x4(%ebp)
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	8a 10                	mov    (%eax),%dl
  80174f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801752:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	8d 50 ff             	lea    -0x1(%eax),%edx
  80175a:	89 55 10             	mov    %edx,0x10(%ebp)
  80175d:	85 c0                	test   %eax,%eax
  80175f:	75 e3                	jne    801744 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801761:	eb 23                	jmp    801786 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801763:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801766:	8d 50 01             	lea    0x1(%eax),%edx
  801769:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80176c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80176f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801772:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801775:	8a 12                	mov    (%edx),%dl
  801777:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801779:	8b 45 10             	mov    0x10(%ebp),%eax
  80177c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80177f:	89 55 10             	mov    %edx,0x10(%ebp)
  801782:	85 c0                	test   %eax,%eax
  801784:	75 dd                	jne    801763 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80179d:	eb 2a                	jmp    8017c9 <memcmp+0x3e>
		if (*s1 != *s2)
  80179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017a2:	8a 10                	mov    (%eax),%dl
  8017a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	38 c2                	cmp    %al,%dl
  8017ab:	74 16                	je     8017c3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	0f b6 d0             	movzbl %al,%edx
  8017b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	0f b6 c0             	movzbl %al,%eax
  8017bd:	29 c2                	sub    %eax,%edx
  8017bf:	89 d0                	mov    %edx,%eax
  8017c1:	eb 18                	jmp    8017db <memcmp+0x50>
		s1++, s2++;
  8017c3:	ff 45 fc             	incl   -0x4(%ebp)
  8017c6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	75 c9                	jne    80179f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	01 d0                	add    %edx,%eax
  8017eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017ee:	eb 15                	jmp    801805 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	0f b6 d0             	movzbl %al,%edx
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	0f b6 c0             	movzbl %al,%eax
  8017fe:	39 c2                	cmp    %eax,%edx
  801800:	74 0d                	je     80180f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801802:	ff 45 08             	incl   0x8(%ebp)
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80180b:	72 e3                	jb     8017f0 <memfind+0x13>
  80180d:	eb 01                	jmp    801810 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80180f:	90                   	nop
	return (void *) s;
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80181b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801822:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801829:	eb 03                	jmp    80182e <strtol+0x19>
		s++;
  80182b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3c 20                	cmp    $0x20,%al
  801835:	74 f4                	je     80182b <strtol+0x16>
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 09                	cmp    $0x9,%al
  80183e:	74 eb                	je     80182b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	3c 2b                	cmp    $0x2b,%al
  801847:	75 05                	jne    80184e <strtol+0x39>
		s++;
  801849:	ff 45 08             	incl   0x8(%ebp)
  80184c:	eb 13                	jmp    801861 <strtol+0x4c>
	else if (*s == '-')
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	3c 2d                	cmp    $0x2d,%al
  801855:	75 0a                	jne    801861 <strtol+0x4c>
		s++, neg = 1;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801861:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801865:	74 06                	je     80186d <strtol+0x58>
  801867:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80186b:	75 20                	jne    80188d <strtol+0x78>
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	8a 00                	mov    (%eax),%al
  801872:	3c 30                	cmp    $0x30,%al
  801874:	75 17                	jne    80188d <strtol+0x78>
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	40                   	inc    %eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 78                	cmp    $0x78,%al
  80187e:	75 0d                	jne    80188d <strtol+0x78>
		s += 2, base = 16;
  801880:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801884:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80188b:	eb 28                	jmp    8018b5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80188d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801891:	75 15                	jne    8018a8 <strtol+0x93>
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	3c 30                	cmp    $0x30,%al
  80189a:	75 0c                	jne    8018a8 <strtol+0x93>
		s++, base = 8;
  80189c:	ff 45 08             	incl   0x8(%ebp)
  80189f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018a6:	eb 0d                	jmp    8018b5 <strtol+0xa0>
	else if (base == 0)
  8018a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ac:	75 07                	jne    8018b5 <strtol+0xa0>
		base = 10;
  8018ae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	3c 2f                	cmp    $0x2f,%al
  8018bc:	7e 19                	jle    8018d7 <strtol+0xc2>
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	3c 39                	cmp    $0x39,%al
  8018c5:	7f 10                	jg     8018d7 <strtol+0xc2>
			dig = *s - '0';
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	0f be c0             	movsbl %al,%eax
  8018cf:	83 e8 30             	sub    $0x30,%eax
  8018d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018d5:	eb 42                	jmp    801919 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	8a 00                	mov    (%eax),%al
  8018dc:	3c 60                	cmp    $0x60,%al
  8018de:	7e 19                	jle    8018f9 <strtol+0xe4>
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	3c 7a                	cmp    $0x7a,%al
  8018e7:	7f 10                	jg     8018f9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	8a 00                	mov    (%eax),%al
  8018ee:	0f be c0             	movsbl %al,%eax
  8018f1:	83 e8 57             	sub    $0x57,%eax
  8018f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f7:	eb 20                	jmp    801919 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3c 40                	cmp    $0x40,%al
  801900:	7e 39                	jle    80193b <strtol+0x126>
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	8a 00                	mov    (%eax),%al
  801907:	3c 5a                	cmp    $0x5a,%al
  801909:	7f 30                	jg     80193b <strtol+0x126>
			dig = *s - 'A' + 10;
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8a 00                	mov    (%eax),%al
  801910:	0f be c0             	movsbl %al,%eax
  801913:	83 e8 37             	sub    $0x37,%eax
  801916:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80191f:	7d 19                	jge    80193a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801921:	ff 45 08             	incl   0x8(%ebp)
  801924:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801927:	0f af 45 10          	imul   0x10(%ebp),%eax
  80192b:	89 c2                	mov    %eax,%edx
  80192d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801930:	01 d0                	add    %edx,%eax
  801932:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801935:	e9 7b ff ff ff       	jmp    8018b5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80193a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80193b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80193f:	74 08                	je     801949 <strtol+0x134>
		*endptr = (char *) s;
  801941:	8b 45 0c             	mov    0xc(%ebp),%eax
  801944:	8b 55 08             	mov    0x8(%ebp),%edx
  801947:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801949:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80194d:	74 07                	je     801956 <strtol+0x141>
  80194f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801952:	f7 d8                	neg    %eax
  801954:	eb 03                	jmp    801959 <strtol+0x144>
  801956:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <ltostr>:

void
ltostr(long value, char *str)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801961:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801968:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80196f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801973:	79 13                	jns    801988 <ltostr+0x2d>
	{
		neg = 1;
  801975:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801982:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801985:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801990:	99                   	cltd   
  801991:	f7 f9                	idiv   %ecx
  801993:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801996:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801999:	8d 50 01             	lea    0x1(%eax),%edx
  80199c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80199f:	89 c2                	mov    %eax,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 d0                	add    %edx,%eax
  8019a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019a9:	83 c2 30             	add    $0x30,%edx
  8019ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019b6:	f7 e9                	imul   %ecx
  8019b8:	c1 fa 02             	sar    $0x2,%edx
  8019bb:	89 c8                	mov    %ecx,%eax
  8019bd:	c1 f8 1f             	sar    $0x1f,%eax
  8019c0:	29 c2                	sub    %eax,%edx
  8019c2:	89 d0                	mov    %edx,%eax
  8019c4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019cf:	f7 e9                	imul   %ecx
  8019d1:	c1 fa 02             	sar    $0x2,%edx
  8019d4:	89 c8                	mov    %ecx,%eax
  8019d6:	c1 f8 1f             	sar    $0x1f,%eax
  8019d9:	29 c2                	sub    %eax,%edx
  8019db:	89 d0                	mov    %edx,%eax
  8019dd:	c1 e0 02             	shl    $0x2,%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	01 c0                	add    %eax,%eax
  8019e4:	29 c1                	sub    %eax,%ecx
  8019e6:	89 ca                	mov    %ecx,%edx
  8019e8:	85 d2                	test   %edx,%edx
  8019ea:	75 9c                	jne    801988 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f6:	48                   	dec    %eax
  8019f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019fe:	74 3d                	je     801a3d <ltostr+0xe2>
		start = 1 ;
  801a00:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a07:	eb 34                	jmp    801a3d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0f:	01 d0                	add    %edx,%eax
  801a11:	8a 00                	mov    (%eax),%al
  801a13:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1c:	01 c2                	add    %eax,%edx
  801a1e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a24:	01 c8                	add    %ecx,%eax
  801a26:	8a 00                	mov    (%eax),%al
  801a28:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a30:	01 c2                	add    %eax,%edx
  801a32:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a35:	88 02                	mov    %al,(%edx)
		start++ ;
  801a37:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a3a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a40:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a43:	7c c4                	jl     801a09 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a45:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4b:	01 d0                	add    %edx,%eax
  801a4d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a50:	90                   	nop
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	e8 54 fa ff ff       	call   8014b5 <strlen>
  801a61:	83 c4 04             	add    $0x4,%esp
  801a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	e8 46 fa ff ff       	call   8014b5 <strlen>
  801a6f:	83 c4 04             	add    $0x4,%esp
  801a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a83:	eb 17                	jmp    801a9c <strcconcat+0x49>
		final[s] = str1[s] ;
  801a85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a88:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8b:	01 c2                	add    %eax,%edx
  801a8d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	01 c8                	add    %ecx,%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a99:	ff 45 fc             	incl   -0x4(%ebp)
  801a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a9f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801aa2:	7c e1                	jl     801a85 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801aa4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801aab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801ab2:	eb 1f                	jmp    801ad3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ab7:	8d 50 01             	lea    0x1(%eax),%edx
  801aba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801abd:	89 c2                	mov    %eax,%edx
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	01 c2                	add    %eax,%edx
  801ac4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aca:	01 c8                	add    %ecx,%eax
  801acc:	8a 00                	mov    (%eax),%al
  801ace:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ad0:	ff 45 f8             	incl   -0x8(%ebp)
  801ad3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ad9:	7c d9                	jl     801ab4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801adb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ade:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae1:	01 d0                	add    %edx,%eax
  801ae3:	c6 00 00             	movb   $0x0,(%eax)
}
  801ae6:	90                   	nop
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801aec:	8b 45 14             	mov    0x14(%ebp),%eax
  801aef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801af5:	8b 45 14             	mov    0x14(%ebp),%eax
  801af8:	8b 00                	mov    (%eax),%eax
  801afa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b01:	8b 45 10             	mov    0x10(%ebp),%eax
  801b04:	01 d0                	add    %edx,%eax
  801b06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b0c:	eb 0c                	jmp    801b1a <strsplit+0x31>
			*string++ = 0;
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	8d 50 01             	lea    0x1(%eax),%edx
  801b14:	89 55 08             	mov    %edx,0x8(%ebp)
  801b17:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	8a 00                	mov    (%eax),%al
  801b1f:	84 c0                	test   %al,%al
  801b21:	74 18                	je     801b3b <strsplit+0x52>
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	0f be c0             	movsbl %al,%eax
  801b2b:	50                   	push   %eax
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 13 fb ff ff       	call   801647 <strchr>
  801b34:	83 c4 08             	add    $0x8,%esp
  801b37:	85 c0                	test   %eax,%eax
  801b39:	75 d3                	jne    801b0e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	84 c0                	test   %al,%al
  801b42:	74 5a                	je     801b9e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b44:	8b 45 14             	mov    0x14(%ebp),%eax
  801b47:	8b 00                	mov    (%eax),%eax
  801b49:	83 f8 0f             	cmp    $0xf,%eax
  801b4c:	75 07                	jne    801b55 <strsplit+0x6c>
		{
			return 0;
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b53:	eb 66                	jmp    801bbb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b55:	8b 45 14             	mov    0x14(%ebp),%eax
  801b58:	8b 00                	mov    (%eax),%eax
  801b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  801b5d:	8b 55 14             	mov    0x14(%ebp),%edx
  801b60:	89 0a                	mov    %ecx,(%edx)
  801b62:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b69:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6c:	01 c2                	add    %eax,%edx
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b73:	eb 03                	jmp    801b78 <strsplit+0x8f>
			string++;
  801b75:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	8a 00                	mov    (%eax),%al
  801b7d:	84 c0                	test   %al,%al
  801b7f:	74 8b                	je     801b0c <strsplit+0x23>
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	8a 00                	mov    (%eax),%al
  801b86:	0f be c0             	movsbl %al,%eax
  801b89:	50                   	push   %eax
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	e8 b5 fa ff ff       	call   801647 <strchr>
  801b92:	83 c4 08             	add    $0x8,%esp
  801b95:	85 c0                	test   %eax,%eax
  801b97:	74 dc                	je     801b75 <strsplit+0x8c>
			string++;
	}
  801b99:	e9 6e ff ff ff       	jmp    801b0c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b9e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba2:	8b 00                	mov    (%eax),%eax
  801ba4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bab:	8b 45 10             	mov    0x10(%ebp),%eax
  801bae:	01 d0                	add    %edx,%eax
  801bb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bb6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <malloc>:
int sizeofarray=0;
uint32 addresses[1000];
int changed[1000];
int numOfPages[1000];
void* malloc(uint32 size)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
		// Write your code here, remove the panic and write your code
		int num = size /PAGE_SIZE;
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	c1 e8 0c             	shr    $0xc,%eax
  801bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 return_addres;

		if(size%PAGE_SIZE!=0)
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	25 ff 0f 00 00       	and    $0xfff,%eax
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	74 03                	je     801bdb <malloc+0x1e>
			num++;
  801bd8:	ff 45 f4             	incl   -0xc(%ebp)
		if(last_addres==USER_HEAP_START)
  801bdb:	a1 04 30 80 00       	mov    0x803004,%eax
  801be0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  801be5:	75 73                	jne    801c5a <malloc+0x9d>
		{
			sys_allocateMem(USER_HEAP_START,size);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	68 00 00 00 80       	push   $0x80000000
  801bf2:	e8 80 04 00 00       	call   802077 <sys_allocateMem>
  801bf7:	83 c4 10             	add    $0x10,%esp
			return_addres=last_addres;
  801bfa:	a1 04 30 80 00       	mov    0x803004,%eax
  801bff:	89 45 d8             	mov    %eax,-0x28(%ebp)
			last_addres+=num*PAGE_SIZE;
  801c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c05:	c1 e0 0c             	shl    $0xc,%eax
  801c08:	89 c2                	mov    %eax,%edx
  801c0a:	a1 04 30 80 00       	mov    0x803004,%eax
  801c0f:	01 d0                	add    %edx,%eax
  801c11:	a3 04 30 80 00       	mov    %eax,0x803004
			numOfPages[sizeofarray]=num;
  801c16:	a1 30 30 80 00       	mov    0x803030,%eax
  801c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c1e:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
			addresses[sizeofarray]=last_addres;
  801c25:	a1 30 30 80 00       	mov    0x803030,%eax
  801c2a:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801c30:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
			changed[sizeofarray]=1;
  801c37:	a1 30 30 80 00       	mov    0x803030,%eax
  801c3c:	c7 04 85 c0 40 80 00 	movl   $0x1,0x8040c0(,%eax,4)
  801c43:	01 00 00 00 
			sizeofarray++;
  801c47:	a1 30 30 80 00       	mov    0x803030,%eax
  801c4c:	40                   	inc    %eax
  801c4d:	a3 30 30 80 00       	mov    %eax,0x803030
			return (void*)return_addres;
  801c52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c55:	e9 71 01 00 00       	jmp    801dcb <malloc+0x20e>
		}
		else
		{
			if(changes==0)
  801c5a:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	75 71                	jne    801cd4 <malloc+0x117>
			{
				sys_allocateMem(last_addres,size);
  801c63:	a1 04 30 80 00       	mov    0x803004,%eax
  801c68:	83 ec 08             	sub    $0x8,%esp
  801c6b:	ff 75 08             	pushl  0x8(%ebp)
  801c6e:	50                   	push   %eax
  801c6f:	e8 03 04 00 00       	call   802077 <sys_allocateMem>
  801c74:	83 c4 10             	add    $0x10,%esp
				return_addres=last_addres;
  801c77:	a1 04 30 80 00       	mov    0x803004,%eax
  801c7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
				last_addres+=num*PAGE_SIZE;
  801c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c82:	c1 e0 0c             	shl    $0xc,%eax
  801c85:	89 c2                	mov    %eax,%edx
  801c87:	a1 04 30 80 00       	mov    0x803004,%eax
  801c8c:	01 d0                	add    %edx,%eax
  801c8e:	a3 04 30 80 00       	mov    %eax,0x803004
				numOfPages[sizeofarray]=num;
  801c93:	a1 30 30 80 00       	mov    0x803030,%eax
  801c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c9b:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
				addresses[sizeofarray]=return_addres;
  801ca2:	a1 30 30 80 00       	mov    0x803030,%eax
  801ca7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801caa:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
				changed[sizeofarray]=1;
  801cb1:	a1 30 30 80 00       	mov    0x803030,%eax
  801cb6:	c7 04 85 c0 40 80 00 	movl   $0x1,0x8040c0(,%eax,4)
  801cbd:	01 00 00 00 
				sizeofarray++;
  801cc1:	a1 30 30 80 00       	mov    0x803030,%eax
  801cc6:	40                   	inc    %eax
  801cc7:	a3 30 30 80 00       	mov    %eax,0x803030
				return (void*)return_addres;
  801ccc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ccf:	e9 f7 00 00 00       	jmp    801dcb <malloc+0x20e>
			}
			else{
				int count=0;
  801cd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				int min=1000;
  801cdb:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
				int index=-1;
  801ce2:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801ce9:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  801cf0:	eb 7c                	jmp    801d6e <malloc+0x1b1>
				{
					uint32 *pg=NULL;
  801cf2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					for(int j=0;j<sizeofarray;j++)
  801cf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801d00:	eb 1a                	jmp    801d1c <malloc+0x15f>
					{
						if(addresses[j]==i)
  801d02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d05:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  801d0c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801d0f:	75 08                	jne    801d19 <malloc+0x15c>
						{
							index=j;
  801d11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d14:	89 45 e8             	mov    %eax,-0x18(%ebp)
							break;
  801d17:	eb 0d                	jmp    801d26 <malloc+0x169>
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
				{
					uint32 *pg=NULL;
					for(int j=0;j<sizeofarray;j++)
  801d19:	ff 45 dc             	incl   -0x24(%ebp)
  801d1c:	a1 30 30 80 00       	mov    0x803030,%eax
  801d21:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801d24:	7c dc                	jl     801d02 <malloc+0x145>
							index=j;
							break;
						}
					}

					if(index==-1)
  801d26:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801d2a:	75 05                	jne    801d31 <malloc+0x174>
					{
						count++;
  801d2c:	ff 45 f0             	incl   -0x10(%ebp)
  801d2f:	eb 36                	jmp    801d67 <malloc+0x1aa>
					}
					else
					{
						if(changed[index]==0)
  801d31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d34:	8b 04 85 c0 40 80 00 	mov    0x8040c0(,%eax,4),%eax
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	75 05                	jne    801d44 <malloc+0x187>
						{
							count++;
  801d3f:	ff 45 f0             	incl   -0x10(%ebp)
  801d42:	eb 23                	jmp    801d67 <malloc+0x1aa>
						}
						else
						{
							if(count<min&&count>=num)
  801d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d47:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d4a:	7d 14                	jge    801d60 <malloc+0x1a3>
  801d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d52:	7c 0c                	jl     801d60 <malloc+0x1a3>
							{
								min=count;
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d57:	89 45 ec             	mov    %eax,-0x14(%ebp)
								min_addresss=i;
  801d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
							}
							count=0;
  801d60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			else{
				int count=0;
				int min=1000;
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801d67:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801d6e:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801d75:	0f 86 77 ff ff ff    	jbe    801cf2 <malloc+0x135>

					}

					}

				sys_allocateMem(min_addresss,size);
  801d7b:	83 ec 08             	sub    $0x8,%esp
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d84:	e8 ee 02 00 00       	call   802077 <sys_allocateMem>
  801d89:	83 c4 10             	add    $0x10,%esp
				numOfPages[sizeofarray]=num;
  801d8c:	a1 30 30 80 00       	mov    0x803030,%eax
  801d91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d94:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
				addresses[sizeofarray]=last_addres;
  801d9b:	a1 30 30 80 00       	mov    0x803030,%eax
  801da0:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801da6:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
				changed[sizeofarray]=1;
  801dad:	a1 30 30 80 00       	mov    0x803030,%eax
  801db2:	c7 04 85 c0 40 80 00 	movl   $0x1,0x8040c0(,%eax,4)
  801db9:	01 00 00 00 
				sizeofarray++;
  801dbd:	a1 30 30 80 00       	mov    0x803030,%eax
  801dc2:	40                   	inc    %eax
  801dc3:	a3 30 30 80 00       	mov    %eax,0x803030
				return(void*) min_addresss;
  801dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax

		//refer to the project presentation and documentation for details

		return NULL;

}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801dd0:	90                   	nop
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 18             	sub    $0x18,%esp
  801dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddc:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	68 64 2f 80 00       	push   $0x802f64
  801de7:	68 8d 00 00 00       	push   $0x8d
  801dec:	68 87 2f 80 00       	push   $0x802f87
  801df1:	e8 95 eb ff ff       	call   80098b <_panic>

00801df6 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801dfc:	83 ec 04             	sub    $0x4,%esp
  801dff:	68 64 2f 80 00       	push   $0x802f64
  801e04:	68 93 00 00 00       	push   $0x93
  801e09:	68 87 2f 80 00       	push   $0x802f87
  801e0e:	e8 78 eb ff ff       	call   80098b <_panic>

00801e13 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e19:	83 ec 04             	sub    $0x4,%esp
  801e1c:	68 64 2f 80 00       	push   $0x802f64
  801e21:	68 99 00 00 00       	push   $0x99
  801e26:	68 87 2f 80 00       	push   $0x802f87
  801e2b:	e8 5b eb ff ff       	call   80098b <_panic>

00801e30 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	68 64 2f 80 00       	push   $0x802f64
  801e3e:	68 9e 00 00 00       	push   $0x9e
  801e43:	68 87 2f 80 00       	push   $0x802f87
  801e48:	e8 3e eb ff ff       	call   80098b <_panic>

00801e4d <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e53:	83 ec 04             	sub    $0x4,%esp
  801e56:	68 64 2f 80 00       	push   $0x802f64
  801e5b:	68 a4 00 00 00       	push   $0xa4
  801e60:	68 87 2f 80 00       	push   $0x802f87
  801e65:	e8 21 eb ff ff       	call   80098b <_panic>

00801e6a <shrink>:
}
void shrink(uint32 newSize)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	68 64 2f 80 00       	push   $0x802f64
  801e78:	68 a8 00 00 00       	push   $0xa8
  801e7d:	68 87 2f 80 00       	push   $0x802f87
  801e82:	e8 04 eb ff ff       	call   80098b <_panic>

00801e87 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e8d:	83 ec 04             	sub    $0x4,%esp
  801e90:	68 64 2f 80 00       	push   $0x802f64
  801e95:	68 ad 00 00 00       	push   $0xad
  801e9a:	68 87 2f 80 00       	push   $0x802f87
  801e9f:	e8 e7 ea ff ff       	call   80098b <_panic>

00801ea4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	57                   	push   %edi
  801ea8:	56                   	push   %esi
  801ea9:	53                   	push   %ebx
  801eaa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ebc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ebf:	cd 30                	int    $0x30
  801ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	5b                   	pop    %ebx
  801ecb:	5e                   	pop    %esi
  801ecc:	5f                   	pop    %edi
  801ecd:	5d                   	pop    %ebp
  801ece:	c3                   	ret    

00801ecf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 04             	sub    $0x4,%esp
  801ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801edb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	52                   	push   %edx
  801ee7:	ff 75 0c             	pushl  0xc(%ebp)
  801eea:	50                   	push   %eax
  801eeb:	6a 00                	push   $0x0
  801eed:	e8 b2 ff ff ff       	call   801ea4 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	90                   	nop
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 01                	push   $0x1
  801f07:	e8 98 ff ff ff       	call   801ea4 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	50                   	push   %eax
  801f20:	6a 05                	push   $0x5
  801f22:	e8 7d ff ff ff       	call   801ea4 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 02                	push   $0x2
  801f3b:	e8 64 ff ff ff       	call   801ea4 <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 03                	push   $0x3
  801f54:	e8 4b ff ff ff       	call   801ea4 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 04                	push   $0x4
  801f6d:	e8 32 ff ff ff       	call   801ea4 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_env_exit>:


void sys_env_exit(void)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 06                	push   $0x6
  801f86:	e8 19 ff ff ff       	call   801ea4 <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	90                   	nop
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	52                   	push   %edx
  801fa1:	50                   	push   %eax
  801fa2:	6a 07                	push   $0x7
  801fa4:	e8 fb fe ff ff       	call   801ea4 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	56                   	push   %esi
  801fb2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fb3:	8b 75 18             	mov    0x18(%ebp),%esi
  801fb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	56                   	push   %esi
  801fc3:	53                   	push   %ebx
  801fc4:	51                   	push   %ecx
  801fc5:	52                   	push   %edx
  801fc6:	50                   	push   %eax
  801fc7:	6a 08                	push   $0x8
  801fc9:	e8 d6 fe ff ff       	call   801ea4 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd4:	5b                   	pop    %ebx
  801fd5:	5e                   	pop    %esi
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    

00801fd8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	52                   	push   %edx
  801fe8:	50                   	push   %eax
  801fe9:	6a 09                	push   $0x9
  801feb:	e8 b4 fe ff ff       	call   801ea4 <syscall>
  801ff0:	83 c4 18             	add    $0x18,%esp
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	ff 75 08             	pushl  0x8(%ebp)
  802004:	6a 0a                	push   $0xa
  802006:	e8 99 fe ff ff       	call   801ea4 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 0b                	push   $0xb
  80201f:	e8 80 fe ff ff       	call   801ea4 <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 0c                	push   $0xc
  802038:	e8 67 fe ff ff       	call   801ea4 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 0d                	push   $0xd
  802051:	e8 4e fe ff ff       	call   801ea4 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	ff 75 0c             	pushl  0xc(%ebp)
  802067:	ff 75 08             	pushl  0x8(%ebp)
  80206a:	6a 11                	push   $0x11
  80206c:	e8 33 fe ff ff       	call   801ea4 <syscall>
  802071:	83 c4 18             	add    $0x18,%esp
	return;
  802074:	90                   	nop
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	ff 75 08             	pushl  0x8(%ebp)
  802086:	6a 12                	push   $0x12
  802088:	e8 17 fe ff ff       	call   801ea4 <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
	return ;
  802090:	90                   	nop
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 0e                	push   $0xe
  8020a2:	e8 fd fd ff ff       	call   801ea4 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	ff 75 08             	pushl  0x8(%ebp)
  8020ba:	6a 0f                	push   $0xf
  8020bc:	e8 e3 fd ff ff       	call   801ea4 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 10                	push   $0x10
  8020d5:	e8 ca fd ff ff       	call   801ea4 <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
}
  8020dd:	90                   	nop
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 14                	push   $0x14
  8020ef:	e8 b0 fd ff ff       	call   801ea4 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	90                   	nop
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 15                	push   $0x15
  802109:	e8 96 fd ff ff       	call   801ea4 <syscall>
  80210e:	83 c4 18             	add    $0x18,%esp
}
  802111:	90                   	nop
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_cputc>:


void
sys_cputc(const char c)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 04             	sub    $0x4,%esp
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802120:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	50                   	push   %eax
  80212d:	6a 16                	push   $0x16
  80212f:	e8 70 fd ff ff       	call   801ea4 <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	90                   	nop
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 17                	push   $0x17
  802149:	e8 56 fd ff ff       	call   801ea4 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	50                   	push   %eax
  802164:	6a 18                	push   $0x18
  802166:	e8 39 fd ff ff       	call   801ea4 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802173:	8b 55 0c             	mov    0xc(%ebp),%edx
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	52                   	push   %edx
  802180:	50                   	push   %eax
  802181:	6a 1b                	push   $0x1b
  802183:	e8 1c fd ff ff       	call   801ea4 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802190:	8b 55 0c             	mov    0xc(%ebp),%edx
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	52                   	push   %edx
  80219d:	50                   	push   %eax
  80219e:	6a 19                	push   $0x19
  8021a0:	e8 ff fc ff ff       	call   801ea4 <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
}
  8021a8:	90                   	nop
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 1a                	push   $0x1a
  8021be:	e8 e1 fc ff ff       	call   801ea4 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	90                   	nop
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	6a 00                	push   $0x0
  8021e1:	51                   	push   %ecx
  8021e2:	52                   	push   %edx
  8021e3:	ff 75 0c             	pushl  0xc(%ebp)
  8021e6:	50                   	push   %eax
  8021e7:	6a 1c                	push   $0x1c
  8021e9:	e8 b6 fc ff ff       	call   801ea4 <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	52                   	push   %edx
  802203:	50                   	push   %eax
  802204:	6a 1d                	push   $0x1d
  802206:	e8 99 fc ff ff       	call   801ea4 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802213:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802216:	8b 55 0c             	mov    0xc(%ebp),%edx
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	51                   	push   %ecx
  802221:	52                   	push   %edx
  802222:	50                   	push   %eax
  802223:	6a 1e                	push   $0x1e
  802225:	e8 7a fc ff ff       	call   801ea4 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802232:	8b 55 0c             	mov    0xc(%ebp),%edx
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	52                   	push   %edx
  80223f:	50                   	push   %eax
  802240:	6a 1f                	push   $0x1f
  802242:	e8 5d fc ff ff       	call   801ea4 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 20                	push   $0x20
  80225b:	e8 44 fc ff ff       	call   801ea4 <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	6a 00                	push   $0x0
  80226d:	ff 75 14             	pushl  0x14(%ebp)
  802270:	ff 75 10             	pushl  0x10(%ebp)
  802273:	ff 75 0c             	pushl  0xc(%ebp)
  802276:	50                   	push   %eax
  802277:	6a 21                	push   $0x21
  802279:	e8 26 fc ff ff       	call   801ea4 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	50                   	push   %eax
  802292:	6a 22                	push   $0x22
  802294:	e8 0b fc ff ff       	call   801ea4 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	90                   	nop
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	50                   	push   %eax
  8022ae:	6a 23                	push   $0x23
  8022b0:	e8 ef fb ff ff       	call   801ea4 <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
}
  8022b8:	90                   	nop
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022c1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022c4:	8d 50 04             	lea    0x4(%eax),%edx
  8022c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	52                   	push   %edx
  8022d1:	50                   	push   %eax
  8022d2:	6a 24                	push   $0x24
  8022d4:	e8 cb fb ff ff       	call   801ea4 <syscall>
  8022d9:	83 c4 18             	add    $0x18,%esp
	return result;
  8022dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022e5:	89 01                	mov    %eax,(%ecx)
  8022e7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	c9                   	leave  
  8022ee:	c2 04 00             	ret    $0x4

008022f1 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	ff 75 10             	pushl  0x10(%ebp)
  8022fb:	ff 75 0c             	pushl  0xc(%ebp)
  8022fe:	ff 75 08             	pushl  0x8(%ebp)
  802301:	6a 13                	push   $0x13
  802303:	e8 9c fb ff ff       	call   801ea4 <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
	return ;
  80230b:	90                   	nop
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <sys_rcr2>:
uint32 sys_rcr2()
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 25                	push   $0x25
  80231d:	e8 82 fb ff ff       	call   801ea4 <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802333:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	50                   	push   %eax
  802340:	6a 26                	push   $0x26
  802342:	e8 5d fb ff ff       	call   801ea4 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
	return ;
  80234a:	90                   	nop
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <rsttst>:
void rsttst()
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 28                	push   $0x28
  80235c:	e8 43 fb ff ff       	call   801ea4 <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
	return ;
  802364:	90                   	nop
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 04             	sub    $0x4,%esp
  80236d:	8b 45 14             	mov    0x14(%ebp),%eax
  802370:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802373:	8b 55 18             	mov    0x18(%ebp),%edx
  802376:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80237a:	52                   	push   %edx
  80237b:	50                   	push   %eax
  80237c:	ff 75 10             	pushl  0x10(%ebp)
  80237f:	ff 75 0c             	pushl  0xc(%ebp)
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	6a 27                	push   $0x27
  802387:	e8 18 fb ff ff       	call   801ea4 <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
	return ;
  80238f:	90                   	nop
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <chktst>:
void chktst(uint32 n)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	ff 75 08             	pushl  0x8(%ebp)
  8023a0:	6a 29                	push   $0x29
  8023a2:	e8 fd fa ff ff       	call   801ea4 <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023aa:	90                   	nop
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <inctst>:

void inctst()
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 2a                	push   $0x2a
  8023bc:	e8 e3 fa ff ff       	call   801ea4 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c4:	90                   	nop
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <gettst>:
uint32 gettst()
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 2b                	push   $0x2b
  8023d6:	e8 c9 fa ff ff       	call   801ea4 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 2c                	push   $0x2c
  8023f2:	e8 ad fa ff ff       	call   801ea4 <syscall>
  8023f7:	83 c4 18             	add    $0x18,%esp
  8023fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023fd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802401:	75 07                	jne    80240a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802403:	b8 01 00 00 00       	mov    $0x1,%eax
  802408:	eb 05                	jmp    80240f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80240a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 2c                	push   $0x2c
  802423:	e8 7c fa ff ff       	call   801ea4 <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
  80242b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80242e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802432:	75 07                	jne    80243b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802434:	b8 01 00 00 00       	mov    $0x1,%eax
  802439:	eb 05                	jmp    802440 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80243b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 2c                	push   $0x2c
  802454:	e8 4b fa ff ff       	call   801ea4 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
  80245c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80245f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802463:	75 07                	jne    80246c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802465:	b8 01 00 00 00       	mov    $0x1,%eax
  80246a:	eb 05                	jmp    802471 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
  802476:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 2c                	push   $0x2c
  802485:	e8 1a fa ff ff       	call   801ea4 <syscall>
  80248a:	83 c4 18             	add    $0x18,%esp
  80248d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802490:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802494:	75 07                	jne    80249d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802496:	b8 01 00 00 00       	mov    $0x1,%eax
  80249b:	eb 05                	jmp    8024a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	ff 75 08             	pushl  0x8(%ebp)
  8024b2:	6a 2d                	push   $0x2d
  8024b4:	e8 eb f9 ff ff       	call   801ea4 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024bc:	90                   	nop
}
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	6a 00                	push   $0x0
  8024d1:	53                   	push   %ebx
  8024d2:	51                   	push   %ecx
  8024d3:	52                   	push   %edx
  8024d4:	50                   	push   %eax
  8024d5:	6a 2e                	push   $0x2e
  8024d7:	e8 c8 f9 ff ff       	call   801ea4 <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	52                   	push   %edx
  8024f4:	50                   	push   %eax
  8024f5:	6a 2f                	push   $0x2f
  8024f7:	e8 a8 f9 ff ff       	call   801ea4 <syscall>
  8024fc:	83 c4 18             	add    $0x18,%esp
}
  8024ff:	c9                   	leave  
  802500:	c3                   	ret    
  802501:	66 90                	xchg   %ax,%ax
  802503:	90                   	nop

00802504 <__udivdi3>:
  802504:	55                   	push   %ebp
  802505:	57                   	push   %edi
  802506:	56                   	push   %esi
  802507:	53                   	push   %ebx
  802508:	83 ec 1c             	sub    $0x1c,%esp
  80250b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80250f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802517:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80251b:	89 ca                	mov    %ecx,%edx
  80251d:	89 f8                	mov    %edi,%eax
  80251f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802523:	85 f6                	test   %esi,%esi
  802525:	75 2d                	jne    802554 <__udivdi3+0x50>
  802527:	39 cf                	cmp    %ecx,%edi
  802529:	77 65                	ja     802590 <__udivdi3+0x8c>
  80252b:	89 fd                	mov    %edi,%ebp
  80252d:	85 ff                	test   %edi,%edi
  80252f:	75 0b                	jne    80253c <__udivdi3+0x38>
  802531:	b8 01 00 00 00       	mov    $0x1,%eax
  802536:	31 d2                	xor    %edx,%edx
  802538:	f7 f7                	div    %edi
  80253a:	89 c5                	mov    %eax,%ebp
  80253c:	31 d2                	xor    %edx,%edx
  80253e:	89 c8                	mov    %ecx,%eax
  802540:	f7 f5                	div    %ebp
  802542:	89 c1                	mov    %eax,%ecx
  802544:	89 d8                	mov    %ebx,%eax
  802546:	f7 f5                	div    %ebp
  802548:	89 cf                	mov    %ecx,%edi
  80254a:	89 fa                	mov    %edi,%edx
  80254c:	83 c4 1c             	add    $0x1c,%esp
  80254f:	5b                   	pop    %ebx
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
  802554:	39 ce                	cmp    %ecx,%esi
  802556:	77 28                	ja     802580 <__udivdi3+0x7c>
  802558:	0f bd fe             	bsr    %esi,%edi
  80255b:	83 f7 1f             	xor    $0x1f,%edi
  80255e:	75 40                	jne    8025a0 <__udivdi3+0x9c>
  802560:	39 ce                	cmp    %ecx,%esi
  802562:	72 0a                	jb     80256e <__udivdi3+0x6a>
  802564:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802568:	0f 87 9e 00 00 00    	ja     80260c <__udivdi3+0x108>
  80256e:	b8 01 00 00 00       	mov    $0x1,%eax
  802573:	89 fa                	mov    %edi,%edx
  802575:	83 c4 1c             	add    $0x1c,%esp
  802578:	5b                   	pop    %ebx
  802579:	5e                   	pop    %esi
  80257a:	5f                   	pop    %edi
  80257b:	5d                   	pop    %ebp
  80257c:	c3                   	ret    
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	31 ff                	xor    %edi,%edi
  802582:	31 c0                	xor    %eax,%eax
  802584:	89 fa                	mov    %edi,%edx
  802586:	83 c4 1c             	add    $0x1c,%esp
  802589:	5b                   	pop    %ebx
  80258a:	5e                   	pop    %esi
  80258b:	5f                   	pop    %edi
  80258c:	5d                   	pop    %ebp
  80258d:	c3                   	ret    
  80258e:	66 90                	xchg   %ax,%ax
  802590:	89 d8                	mov    %ebx,%eax
  802592:	f7 f7                	div    %edi
  802594:	31 ff                	xor    %edi,%edi
  802596:	89 fa                	mov    %edi,%edx
  802598:	83 c4 1c             	add    $0x1c,%esp
  80259b:	5b                   	pop    %ebx
  80259c:	5e                   	pop    %esi
  80259d:	5f                   	pop    %edi
  80259e:	5d                   	pop    %ebp
  80259f:	c3                   	ret    
  8025a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025a5:	89 eb                	mov    %ebp,%ebx
  8025a7:	29 fb                	sub    %edi,%ebx
  8025a9:	89 f9                	mov    %edi,%ecx
  8025ab:	d3 e6                	shl    %cl,%esi
  8025ad:	89 c5                	mov    %eax,%ebp
  8025af:	88 d9                	mov    %bl,%cl
  8025b1:	d3 ed                	shr    %cl,%ebp
  8025b3:	89 e9                	mov    %ebp,%ecx
  8025b5:	09 f1                	or     %esi,%ecx
  8025b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025bb:	89 f9                	mov    %edi,%ecx
  8025bd:	d3 e0                	shl    %cl,%eax
  8025bf:	89 c5                	mov    %eax,%ebp
  8025c1:	89 d6                	mov    %edx,%esi
  8025c3:	88 d9                	mov    %bl,%cl
  8025c5:	d3 ee                	shr    %cl,%esi
  8025c7:	89 f9                	mov    %edi,%ecx
  8025c9:	d3 e2                	shl    %cl,%edx
  8025cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025cf:	88 d9                	mov    %bl,%cl
  8025d1:	d3 e8                	shr    %cl,%eax
  8025d3:	09 c2                	or     %eax,%edx
  8025d5:	89 d0                	mov    %edx,%eax
  8025d7:	89 f2                	mov    %esi,%edx
  8025d9:	f7 74 24 0c          	divl   0xc(%esp)
  8025dd:	89 d6                	mov    %edx,%esi
  8025df:	89 c3                	mov    %eax,%ebx
  8025e1:	f7 e5                	mul    %ebp
  8025e3:	39 d6                	cmp    %edx,%esi
  8025e5:	72 19                	jb     802600 <__udivdi3+0xfc>
  8025e7:	74 0b                	je     8025f4 <__udivdi3+0xf0>
  8025e9:	89 d8                	mov    %ebx,%eax
  8025eb:	31 ff                	xor    %edi,%edi
  8025ed:	e9 58 ff ff ff       	jmp    80254a <__udivdi3+0x46>
  8025f2:	66 90                	xchg   %ax,%ax
  8025f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8025f8:	89 f9                	mov    %edi,%ecx
  8025fa:	d3 e2                	shl    %cl,%edx
  8025fc:	39 c2                	cmp    %eax,%edx
  8025fe:	73 e9                	jae    8025e9 <__udivdi3+0xe5>
  802600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802603:	31 ff                	xor    %edi,%edi
  802605:	e9 40 ff ff ff       	jmp    80254a <__udivdi3+0x46>
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	31 c0                	xor    %eax,%eax
  80260e:	e9 37 ff ff ff       	jmp    80254a <__udivdi3+0x46>
  802613:	90                   	nop

00802614 <__umoddi3>:
  802614:	55                   	push   %ebp
  802615:	57                   	push   %edi
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
  80261b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80261f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802627:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80262b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80262f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802633:	89 f3                	mov    %esi,%ebx
  802635:	89 fa                	mov    %edi,%edx
  802637:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80263b:	89 34 24             	mov    %esi,(%esp)
  80263e:	85 c0                	test   %eax,%eax
  802640:	75 1a                	jne    80265c <__umoddi3+0x48>
  802642:	39 f7                	cmp    %esi,%edi
  802644:	0f 86 a2 00 00 00    	jbe    8026ec <__umoddi3+0xd8>
  80264a:	89 c8                	mov    %ecx,%eax
  80264c:	89 f2                	mov    %esi,%edx
  80264e:	f7 f7                	div    %edi
  802650:	89 d0                	mov    %edx,%eax
  802652:	31 d2                	xor    %edx,%edx
  802654:	83 c4 1c             	add    $0x1c,%esp
  802657:	5b                   	pop    %ebx
  802658:	5e                   	pop    %esi
  802659:	5f                   	pop    %edi
  80265a:	5d                   	pop    %ebp
  80265b:	c3                   	ret    
  80265c:	39 f0                	cmp    %esi,%eax
  80265e:	0f 87 ac 00 00 00    	ja     802710 <__umoddi3+0xfc>
  802664:	0f bd e8             	bsr    %eax,%ebp
  802667:	83 f5 1f             	xor    $0x1f,%ebp
  80266a:	0f 84 ac 00 00 00    	je     80271c <__umoddi3+0x108>
  802670:	bf 20 00 00 00       	mov    $0x20,%edi
  802675:	29 ef                	sub    %ebp,%edi
  802677:	89 fe                	mov    %edi,%esi
  802679:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80267d:	89 e9                	mov    %ebp,%ecx
  80267f:	d3 e0                	shl    %cl,%eax
  802681:	89 d7                	mov    %edx,%edi
  802683:	89 f1                	mov    %esi,%ecx
  802685:	d3 ef                	shr    %cl,%edi
  802687:	09 c7                	or     %eax,%edi
  802689:	89 e9                	mov    %ebp,%ecx
  80268b:	d3 e2                	shl    %cl,%edx
  80268d:	89 14 24             	mov    %edx,(%esp)
  802690:	89 d8                	mov    %ebx,%eax
  802692:	d3 e0                	shl    %cl,%eax
  802694:	89 c2                	mov    %eax,%edx
  802696:	8b 44 24 08          	mov    0x8(%esp),%eax
  80269a:	d3 e0                	shl    %cl,%eax
  80269c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026a4:	89 f1                	mov    %esi,%ecx
  8026a6:	d3 e8                	shr    %cl,%eax
  8026a8:	09 d0                	or     %edx,%eax
  8026aa:	d3 eb                	shr    %cl,%ebx
  8026ac:	89 da                	mov    %ebx,%edx
  8026ae:	f7 f7                	div    %edi
  8026b0:	89 d3                	mov    %edx,%ebx
  8026b2:	f7 24 24             	mull   (%esp)
  8026b5:	89 c6                	mov    %eax,%esi
  8026b7:	89 d1                	mov    %edx,%ecx
  8026b9:	39 d3                	cmp    %edx,%ebx
  8026bb:	0f 82 87 00 00 00    	jb     802748 <__umoddi3+0x134>
  8026c1:	0f 84 91 00 00 00    	je     802758 <__umoddi3+0x144>
  8026c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026cb:	29 f2                	sub    %esi,%edx
  8026cd:	19 cb                	sbb    %ecx,%ebx
  8026cf:	89 d8                	mov    %ebx,%eax
  8026d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026d5:	d3 e0                	shl    %cl,%eax
  8026d7:	89 e9                	mov    %ebp,%ecx
  8026d9:	d3 ea                	shr    %cl,%edx
  8026db:	09 d0                	or     %edx,%eax
  8026dd:	89 e9                	mov    %ebp,%ecx
  8026df:	d3 eb                	shr    %cl,%ebx
  8026e1:	89 da                	mov    %ebx,%edx
  8026e3:	83 c4 1c             	add    $0x1c,%esp
  8026e6:	5b                   	pop    %ebx
  8026e7:	5e                   	pop    %esi
  8026e8:	5f                   	pop    %edi
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    
  8026eb:	90                   	nop
  8026ec:	89 fd                	mov    %edi,%ebp
  8026ee:	85 ff                	test   %edi,%edi
  8026f0:	75 0b                	jne    8026fd <__umoddi3+0xe9>
  8026f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f7:	31 d2                	xor    %edx,%edx
  8026f9:	f7 f7                	div    %edi
  8026fb:	89 c5                	mov    %eax,%ebp
  8026fd:	89 f0                	mov    %esi,%eax
  8026ff:	31 d2                	xor    %edx,%edx
  802701:	f7 f5                	div    %ebp
  802703:	89 c8                	mov    %ecx,%eax
  802705:	f7 f5                	div    %ebp
  802707:	89 d0                	mov    %edx,%eax
  802709:	e9 44 ff ff ff       	jmp    802652 <__umoddi3+0x3e>
  80270e:	66 90                	xchg   %ax,%ax
  802710:	89 c8                	mov    %ecx,%eax
  802712:	89 f2                	mov    %esi,%edx
  802714:	83 c4 1c             	add    $0x1c,%esp
  802717:	5b                   	pop    %ebx
  802718:	5e                   	pop    %esi
  802719:	5f                   	pop    %edi
  80271a:	5d                   	pop    %ebp
  80271b:	c3                   	ret    
  80271c:	3b 04 24             	cmp    (%esp),%eax
  80271f:	72 06                	jb     802727 <__umoddi3+0x113>
  802721:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802725:	77 0f                	ja     802736 <__umoddi3+0x122>
  802727:	89 f2                	mov    %esi,%edx
  802729:	29 f9                	sub    %edi,%ecx
  80272b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80272f:	89 14 24             	mov    %edx,(%esp)
  802732:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802736:	8b 44 24 04          	mov    0x4(%esp),%eax
  80273a:	8b 14 24             	mov    (%esp),%edx
  80273d:	83 c4 1c             	add    $0x1c,%esp
  802740:	5b                   	pop    %ebx
  802741:	5e                   	pop    %esi
  802742:	5f                   	pop    %edi
  802743:	5d                   	pop    %ebp
  802744:	c3                   	ret    
  802745:	8d 76 00             	lea    0x0(%esi),%esi
  802748:	2b 04 24             	sub    (%esp),%eax
  80274b:	19 fa                	sbb    %edi,%edx
  80274d:	89 d1                	mov    %edx,%ecx
  80274f:	89 c6                	mov    %eax,%esi
  802751:	e9 71 ff ff ff       	jmp    8026c7 <__umoddi3+0xb3>
  802756:	66 90                	xchg   %ax,%ax
  802758:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80275c:	72 ea                	jb     802748 <__umoddi3+0x134>
  80275e:	89 d9                	mov    %ebx,%ecx
  802760:	e9 62 ff ff ff       	jmp    8026c7 <__umoddi3+0xb3>
