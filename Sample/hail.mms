Assembled code  Line LABEL  OP    EXPR            Remarks
                  01 argv   IS    $1              The argument vector
                  02        LOC   #100
#100 #8f ff 01 00 03 Main   LDCU  $255,argv,0     $255 <- address of program name
#104 #00 00 07 01 04        TRAP  0,Fputs,StdOut  Print that name
#108 #f4 ff 00 03 05        GETA  $255,String     $255 <- address of ", world"
#10c #00 00 07 02 06        TRAP  0,Fputs,StdOut  Print that string.
#110 #00 00 00 00 07        TRAP  0,Halt,0        Stop.
#114 #2c 20 77 6f 08 String BTYE  ", world",#a,0  String of characters
#118 #72 6c 64 0a 09                                   with newline
#11c #00          10                                   and terminator.
