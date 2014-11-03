one    GREG   3
two    GREG   2
result GREG   @
       LOC    #2000
output BYTE   "? Answer",0
outloc GREG   @

       LOC    Data_Segment
t1     GREG   @
txt    BYTE   "Hello world!",10,0

       LOC    #100
Main   ADD    result,one,two
       ADD    $4,result,64

       STB    $4,t1,0

       LDA    $255,txt
       TRAP   0,Fputs,StdOut

       TRAP   0,Halt,0
