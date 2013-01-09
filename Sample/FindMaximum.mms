LABEL    OP    EXPR      Times    Remark
j        IS    $0                 j
m        IS    $1                 m
kk       IS    $2                 8k
xk       IS    $3                 X[k]
t        IS    $255               Temp storage
         LOC   #100
Maximum  SL    kk,$0,3   1        M1.Initialie. k<-n, j<-n
         LDO   m,x0,kk   1        m <- X[n]
         JMP   DecrK     1        To M2 with k<-n-1
Loop     LDO   xk,x0,kk  n-1      M3.Compare
         CMP   t,xk,m    n-1      t<-[X[k] > m] - [X[k] < m].
         PBNP  t, DecrK  n-1      To M5 if X[k] <= m
ChangeM  SET   m,xk      A        M4. Change M m<- X[k]
         SR    j,kk,3    A        j<-k
DecrK    SUB   kk,kk,8   n        M5. Decrease k k<-k-1
         PBP   kk,Loop   n        M2 All tested? To M3 if k > 0
         POP   2,0       1        Return to main program.   