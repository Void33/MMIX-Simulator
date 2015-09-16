%%%-------------------------------------------------------------------
%%% @author steveedmans
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Aug 2015 16:56
%%%-------------------------------------------------------------------
-module(cpu).
-author("steveedmans").

-define(TRAP,   0).
-define(FCMP,   16#01).
-define(FUN,    16#02).
-define(FEQL,   16#03).
-define(FADD,   16#04).
-define(FIX,    16#05).
-define(FSUB,   16#06).
-define(FIXU,   16#07).
-define(FLOT,   16#08).
-define(FLOTU,  16#0A).
-define(SFLOT,  16#0C).
-define(SFLOTU, 16#0E).
-define(FMUL,   16#10).
-define(FCMPE,  16#11).
-define(FUNE,   16#12).
-define(FEQLE,  16#13).
-define(FDIV,   16#14).
-define(FSQRT,  16#15).
-define(FREM,   16#16).
-define(FINT,   16#17).
-define(MUL,    16#18).
-define(MULU,   16#1A).
-define(DIV,    16#1C).
-define(DIVI,   16#1D).
-define(DIVU,   16#1E).
-define(ADD,    16#20).
-define(ADDI,   16#21).
-define(ADDU,   16#22).
-define(ADDUI,  16#23).
-define(SUB,    16#24).
-define(SUBU,   16#26).
-define(ADDU2,  16#28).
-define(ADDU4,  16#2A).
-define(ADDU8,  16#2C).
-define(ADDU16, 16#2E).
-define(CMP,    16#30).
-define(CMPI,   16#31).
-define(CMPU,   16#32).
-define(NEG,    16#34).
-define(NEGI,   16#35).
-define(NEGU,   16#36).
-define(SL,     16#38).
-define(SLU,    16#3A).
-define(SR,     16#3C).
-define(SRU,    16#3E).
-define(BN,     16#40).
-define(BZ,     16#42).
-define(BZB,    16#43).
-define(BP,     16#44).
-define(BOD,    16#46).
-define(BNN,    16#48).
-define(BNZ,    16#4A).
-define(BNP,    16#4C).
-define(BNPB,   16#4D).
-define(BEV,    16#4E).
-define(PBN,    16#50).
-define(PBZ,    16#52).
-define(PBP,    16#54).
-define(PBOD,   16#56).
-define(PBNN,   16#58).
-define(PBNZ,   16#5A).
-define(PBNP,   16#5C).
-define(PBEV,   16#5E).
-define(CSN,    16#60).
-define(CSZ,    16#62).
-define(CSP,    16#64).
-define(CSOD,   16#66).
-define(CSNN,   16#68).
-define(CSNZ,   16#6A).
-define(CSNP,   16#6C).
-define(CSEV,   16#6E).
-define(ZSN,    16#70).
-define(ZSZ,    16#72).
-define(ZSP,    16#74).
-define(ZSOD,   16#76).
-define(ZSNN,   16#78).
-define(ZSNZ,   16#7A).
-define(ZSNP,   16#7C).
-define(ZSEV,   16#7E).
-define(LDB,    16#80).
-define(LDBU,   16#82).
-define(LDW,    16#84).
-define(LDWU,   16#86).
-define(LDWUI,  16#87).
-define(LDT,    16#88).
-define(LDTU,   16#8A).
-define(LDO,    16#8C).
-define(LDOU,   16#8E).
-define(LDSF,   16#90).
-define(LDHT,   16#92).
-define(CSWAP,  16#94).
-define(LDUNC,  16#96).
-define(LDVTS,  16#98).
-define(PRELD,  16#9A).
-define(PREGO,  16#9C).
-define(GO,     16#9E).
-define(STB,    16#A0).
-define(STBU,   16#A2).
-define(STBUI,  16#A3).
-define(STW,    16#A4).
-define(STWU,   16#A6).
-define(STWUI,  16#A7).
-define(STT,    16#A8).
-define(STTU,   16#AA).
-define(STO,    16#AC).
-define(STOU,   16#AE).
-define(STOUI,  16#AF).
-define(STSF,   16#B0).
-define(STHT,   16#B2).
-define(STCO,   16#B4).
-define(STUNC,  16#B6).
-define(SYNCD,  16#B8).
-define(PREST,  16#BA).
-define(SYNCID, 16#BC).
-define(PUSHGO, 16#BE).
-define(OR,     16#C0).
-define(ORI,    16#C1).
-define(ORN,    16#C2).
-define(NOR,    16#C4).
-define(XOR,    16#C6).
-define(AND,    16#C8).
-define(ANDN,   16#CA).
-define(NAND,   16#CC).
-define(NXOR,   16#CE).
-define(BDIF,   16#D0).
-define(WDIF,   16#D2).
-define(TDIF,   16#D4).
-define(ODIF,   16#D6).
-define(MUX ,   16#D8).
-define(SADD,   16#DA).
-define(MOR,    16#DC).
-define(MXOR,   16#DE).
-define(SETH,   16#E0).
-define(SETMH,  16#E1).
-define(SETML,  16#E2).
-define(SETL,   16#E3).
-define(INCH,   16#E4).
-define(INCMH,  16#E5).
-define(INCML,  16#E6).
-define(INCL,   16#E7).
-define(ORH,    16#E8).
-define(ORMH,   16#E9).
-define(ORML,   16#EA).
-define(ORL,    16#EB).
-define(ANDNH,  16#EC).
-define(ANDNMH, 16#ED).
-define(ANDNML, 16#EE).
-define(ANDNL,  16#EF).
-define(JMP,    16#F0).
-define(JMPB,   16#F1).
-define(PUSHJ,  16#F2).
-define(GETA,   16#F4).
-define(PUT,    16#F6).
-define(POP,    16#F8).
-define(RESUME, 16#F9).
-define(SAVE,   16#FA).
-define(SYNC,   16#FC).
-define(SWYM,   16#FD).
-define(GET,    16#FE).
-define(TRIP,   16#FF).

%% API
-export([execute/2]).

%% Determine which function we are executing

%% 00-0F

execute(?TRAP, PC) ->
  trap(PC);

%% 10-1F

execute(?DIV, PC) ->
  mmix_div(PC);
execute(?DIVI, PC) ->
  divi(PC);

%% 20-2F

execute(?ADD, PC) ->
  add(PC);
execute(?ADDI, PC) ->
  addi(PC);

execute(?ADDUI, PC) ->
  addui(PC);

%% 30-3F

execute(?CMP, PC) ->
  cmp(PC);
execute(?CMPI, PC) ->
  cmpi(PC);

execute(?NEG, PC) ->
  neg(PC);
execute(?NEGI, PC) ->
  negi(PC);

%% 40-4F

execute(?BZ, PC) ->
  bz(PC);
execute(?BZB, PC) ->
  bzb(PC);
execute(?BNP, PC) ->
  bnp(PC);
execute(?BNPB, PC) ->
  bnpb(PC);

%% 50-5F

%% 60-6F

%% 70-7F

%% 80-8F

execute(?LDWU, PC) ->
  ldwu(PC);
execute(?LDWUI, PC) ->
  ldwui(PC);
execute(?LDOU, PC) ->
  ldou(PC);

%% 90-9F

%% A0-AF

execute(?STBU, PC) ->
  stbu(PC);
execute(?STBUI, PC) ->
  stbui(PC);
execute(?STWU, PC) ->
  stwu(PC);
execute(?STWUI, PC) ->
  stwui(PC);

execute(?STOU, PC) ->
  stou(PC);
execute(?STOUI, PC) ->
  stoui(PC);

%% B0-BF

%% C0-CF

execute(?OR, PC) ->
  mmix_or(PC);
execute(?ORI, PC) ->
  ori(PC);

%% D0-DF

%% E0-EF

execute(?SETL, PC) ->
  setl(PC);
execute(?INCL, PC) ->
  incl(PC);
execute(?ORH, PC) ->
  orh(PC);
execute(?ORL, PC) ->
  orl(PC);

%% F0-FF

execute(?JMP, PC) ->
  jmp(PC);
execute(?JMPB, PC) ->
  jmpb(PC);
execute(?GET, PC) ->
  mmix_get(PC);

execute(OpCode, _PC) ->
  io:format("We encountered a command that we do not recognized ~w~n", [OpCode]),
  {"ERROR", [], []}.

next_command(PC) ->
  {pc, PC + 4}.

%% Execute the individual instructions

%% 00-0F

trap(PC) ->
  io:format("TRAP~n"),
  {RX, RY, RZ} = three_operands(PC),
  Msgs = trap:process_trap(RX, RY, RZ),
  Updates = [next_command(PC)],
  Stmt = lists:flatten(io_lib:format("TRAP ~B, ~B, ~B", [RX, RY, RZ])),
  {Stmt, Updates, Msgs}.

%% 10-1F

mmix_div(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("DIV $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  divi(PC, Stmt, RX, RY, RZVal).
divi(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("DIVI $~.16B, $~.16B, ~B", [RX, RY, RZ])),
  divi(PC, Stmt, RX, RY, RZ).
divi(PC, Stmt, RX, RY, Z) ->
  RYVal = registers:query_register(RY),
  Updates = [next_command(PC)],
  if
    Z == 0 ->
      register_ra ! {event, divide_check},
      XtraUpdates = [{RX, 0}, {rR, RYVal}];
    true ->
      Quot  = RYVal div Z,
      Rem   = RYVal rem Z,
      io:format("When we divide ~w by ~w we get ~w remainder ~w~n", [RYVal, Z, Quot, Rem]),
      XtraUpdates = [{RX, Quot}, {rR, Rem}]
  end,
  FullUpdates = Updates ++ XtraUpdates,
  {Stmt, FullUpdates, []}.

%% 20-2F

add(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("ADD $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  addi(PC, Stmt, RX, RY, RZVal).
addi(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("ADDI $~.16B, $~.16B, ~B", [RX, RY, RZ])),
  addi(PC, Stmt, RX, RY, RZ).
addi(PC, Stmt, RX, RY, Z) ->
  RYVal = registers:query_register(RY),
  {_Overflow, Result} = add_values(RYVal, Z),
  io:format("The Y value is ~.16B and the Result is ~.16B~n", [RYVal, Result]),
  {Stmt, [{RX, Result}, next_command(PC)], []}.

addui(PC) ->
  io:format("ADDUI ~w~n",[PC]),
  {RX, RY, RZ} = three_operands(PC),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  {Overflow, NewValue} = immediate_address(RY, RZ),
  io:format("Registers ~w - ~w~n",[Overflow, NewValue]),
  Updates = [{RX, NewValue}, next_command(PC)],
  io:format("Updates ~w~n",[Updates]),
  NewList = case Overflow of
              overflow ->
                [{rA, 1} | Updates];
              _ ->
                Updates
            end,
  io:format("New List ~w~n",[NewList]),
  Stmt = lists:flatten(io_lib:format("ADDUI $~.16B, $~.16B, ~B", [RX, RY, RZ])),
  {Stmt, NewList, []}.

%% 30-3F

cmp(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CMP $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cmpi(PC, Stmt, RX, RY, RZVal).
cmpi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CMPI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cmpi(PC, Stmt, RX, RY, Z).
cmpi(PC, Stmt, RX, RY, Z) ->
  RYVal = registers:query_register(RY),
  io:format("Compare ~w with ~w~n", [RYVal, Z]),
  NV = if
    RYVal <  Z -> minus_one();
    RYVal >  Z -> 1;
    RYVal == Z -> 0
  end,
  io:format("Compare ~w with ~w which equals ~w~n", [RYVal, Z, NV]),
  {Stmt, [{RX, NV}, next_command(PC)], []}.

neg(PC) ->
  {RX, Y, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("NEG $~.16B, ~B, $~.16B", [RX, Y, RZ])),
  negi(PC, Stmt, RX, Y, RZVal).
negi(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("NEGI $~.16B, ~.B, ~B", [RX, Y, Z])),
  negi(PC, Stmt, RX, Y, Z).
negi(PC, Stmt, RX, Y, Z) ->
  Diff = Y - Z,
  NV = if
         Diff < 0 -> minus_one() + Diff + 1;
         true     -> Diff
       end,
  io:format("The difference is ~w which goes to ~.16B~n", [Diff, NV]),
  {Stmt, [{RX, NV}, next_command(PC)], []}.

%% 40-4F
bz(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BZ $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bz/1, PC, RX, Address, Stmt).

bzb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BZB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bz/1, PC, RX, Address, Stmt).

bnp(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BNP $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bnp/1, PC, RX, Address, Stmt).

bnpb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BNPB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bnp/1, PC, RX, Address, Stmt).

%% 50-5F
%% 60-6F
%% 70-7F
%% 80-8F

ldwu(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("LDWU $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  ldwui(PC, Stmt, RX, RY, RZVal).
ldwui(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("LDWUI $~.16B, $~.16B, ~B", [RX, RY, RZ])),
  ldwui(PC, Stmt, RX, RY, RZ).
ldwui(PC, Stmt, RX, RY, Z) ->
  {_Overflow, Address} = immediate_address(RY, Z),
  Value = memory:get_wyde(Address),
  io:format("Set the register ~w to ~w~n", [RX, Value]),
  {Stmt, [{RX, Value}, next_command(PC)], []}.

ldou(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  {_Overflow, _A} = address_two_registers(RY, RZ),
  Stmt = lists:flatten(io_lib:format("LDOU $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  {Stmt, [], []}.

%% 90-9F
%% A0-AF

stbu(PC) ->
  io:format("STWU ~w~n", [PC]),
  {RX, RY, RZ} = three_operands(PC),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("STBU $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  stbui(PC, Stmt, RX, RY, RZVal).

stbui(PC) ->
  io:format("STWUI ~w~n", [PC]),
  {RX, RY, RZVal} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("STBUI $~.16B, $~.16B, ~B", [RX, RY, RZVal])),
  stbui(PC, Stmt, RX, RY, RZVal).

stbui(PC, Stmt, RX, RY, Z) ->
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, Z]),
  IA = immediate_address(RY, Z),
  case IA of
    {_, Location} ->
      RXVal = registers:query_register(RX),
      io:format("Set the address ~w to the least significant bits of ~w~n", [Location, RXVal]),
      LSB = utilities:get_0_byte(RXVal),
      io:format("Which is ~w~n", [LSB]),
      MemoryChanges = memory:set_byte(Location, LSB),
      io:format("The memory changes are ~w~n", [MemoryChanges]),
      NewMessages = [{memory_change, MemoryChanges}],
      io:format("We are sending back ~w~n", [NewMessages]),
      {Stmt, [next_command(PC)], NewMessages}
  end.

stwu(PC) ->
  io:format("STWU ~w~n", [PC]),
  {RX, RY, RZ} = three_operands(PC),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("STWU $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  stwui(PC, Stmt, RX, RY, RZVal).

stwui(PC) ->
  io:format("STWUI ~w~n", [PC]),
  {RX, RY, RZVal} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("STWUI $~.16B, $~.16B, ~B", [RX, RY, RZVal])),
  stwui(PC, Stmt, RX, RY, RZVal).

stwui(PC, Stmt, RX, RY, Z) ->
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, Z]),
  IA = immediate_address(RY, Z),
  case IA of
    {_, Location} ->
      RXVal = registers:query_register(RX),
      io:format("Set the address ~w to the least significant bits of ~w~n", [Location, RXVal]),
      LSB = utilities:get_0_wyde(RXVal),
      io:format("Which is ~w~n", [LSB]),
      MemoryChanges = memory:set_wyde(Location, LSB),
      io:format("The memory changes are ~w~n", [MemoryChanges]),
      NewMessages = [{memory_change, MemoryChanges}],
      io:format("We are sending back ~w~n", [NewMessages]),
      {Stmt, [next_command(PC)], NewMessages}
  end.

stou(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("STOU $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  stoui(PC, Stmt, RX, RY, RZVal).
stoui(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("STOUI $~.16B, $~.16B, ~B", [RX, RY, RZ])),
  stoui(PC, Stmt, RX, RY, RZ).
stoui(PC, Stmt, RX, RY, Z) ->
  IA = immediate_address(RY, Z),
  case IA of
    {_, Location} ->
      RXVal = registers:query_register(RX),
      io:format("Set the address ~w to ~w~n", [Location, RXVal]),
      MemoryChanges = memory:set_octabyte(Location, RXVal),
      io:format("The changes to memory are ~w~n", [MemoryChanges]),
      NewMessages = [{memory_change, MemoryChanges}],
      {Stmt, [next_command(PC)], NewMessages};
    _ -> {"STOUI Address Error", [], []}
  end.

%% B0-BF
%% C0-CF

mmix_or(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("OR $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  ori(PC, Stmt, RX, RY, RZVal).

ori(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("ORI $~.16B, $~.16B, ~B", [RX, RY, RZ])),
  ori(PC, Stmt, RX, RY, RZ).

ori(PC, Stmt, RX, RY, Z) ->
  RYVal = registers:query_register(RY),
  NVal = RYVal bor Z,
  io:format("ORI ~w ~w (~w) ~w = (~w)~n", [RX, RY, RYVal, Z, NVal]),
  {Stmt, [{RX, NVal}, next_command(PC)], []}.

%% D0-DF
%% E0-EF

setl(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  io:format("SETL~n", []),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  RVal = rval(RY, RZ),
  Update = registers:set_register_lowwyde(RX, RVal),
  Stmt = lists:flatten(io_lib:format("SETL $~.16B, ~B", [RX, RVal])),
  {Stmt, [Update, next_command(PC)], []}.

incl(PC) ->
  io:format("Process INCL~n"),
  {RX, RY, RZ} = three_operands(PC),
  RVal = rval(RY, RZ),
  Stmt = lists:flatten(io_lib:format("INCL $~.16B, ~B", [RX, RVal])),
  RXVal = registers:query_register(RX),
  {_Overflow, NV} = add_values(RXVal, RVal),
  io:format("We will add ~w to ~w and we get ~w~n", [RVal, RXVal, NV]),
  {Stmt, [{RX, NV}, next_command(PC)], []}.

orh(PC) ->
  io:format("Process ORH~n"),
  {RX, RY, RZ} = three_operands(PC),
  RVal = rval(RY, RZ),
  Stmt = lists:flatten(io_lib:format("ORH $~.16B, ~B", [RX, RVal])),
  {Stmt, [], []}.

orl(PC) ->
  io:format("Process ORL ~w~n", [PC]),
  {"ORL", [], []}.

%% F0-FF

jmp(PC) ->
  {X, Y, Z} = three_operands(PC),
  Address = rval(rval(X, Y), Z),
  Stmt = lists:flatten(io_lib:format("JMP ~B", [Address])),
  branch:branch_forward(fun branch:jmp/1, PC, X, Address, Stmt).

jmpb(PC) ->
  {X, Y, Z} = three_operands(PC),
  Address = rval(rval(X, Y), Z),
  Stmt = lists:flatten(io_lib:format("JMPB ~B", [Address])),
  branch:branch_backward(fun branch:jmp/1, PC, X, Address, Stmt).

mmix_get(PC) ->
  {RX, _RY, RZ} = three_operands(PC),
  SR = operand_to_special_register(RZ),
  RegVal = registers:query_register(SR),
  Stmt = lists:flatten(io_lib:format("GET $~.16B, ~w", [RX, SR])),
  {Stmt, [{RX, RegVal}, next_command(PC)], []}.

%% Utilities

operand_to_special_register(0)  -> rB;
operand_to_special_register(1)  -> rD;
operand_to_special_register(2)  -> rE;
operand_to_special_register(3)  -> rH;
operand_to_special_register(4)  -> rJ;
operand_to_special_register(5)  -> rM;
operand_to_special_register(6)  -> rR;
operand_to_special_register(7)  -> rBB;
operand_to_special_register(8)  -> rC;
operand_to_special_register(9)  -> rN;
operand_to_special_register(10) -> rO;
operand_to_special_register(11) -> rS;
operand_to_special_register(12) -> rI;
operand_to_special_register(13) -> rT;
operand_to_special_register(14) -> rTT;
operand_to_special_register(15) -> rK;
operand_to_special_register(16) -> rQ;
operand_to_special_register(17) -> rU;
operand_to_special_register(18) -> rW;
operand_to_special_register(19) -> rG;
operand_to_special_register(20) -> rL;
operand_to_special_register(21) -> rA;
operand_to_special_register(22) -> rF;
operand_to_special_register(23) -> rP;
operand_to_special_register(24) -> rW;
operand_to_special_register(25) -> rX;
operand_to_special_register(26) -> rY;
operand_to_special_register(27) -> rZ;
operand_to_special_register(28) -> rWW;
operand_to_special_register(29) -> rXX;
operand_to_special_register(30) -> rYY;
operand_to_special_register(31) -> rZZ.

rval(RY, RZ) ->
  (RY * 256) + RZ.

three_operands(PC) ->
  First = operand(PC+1),
  Second = operand(PC+2),
  Third = operand(PC+3),
  {First, Second, Third}.

operand(Location) ->
  memory:get_byte(Location).

address_two_registers(RX, RY) ->
  R1 = registers:query_register(RX),
  R2 = registers:query_register(RY),
  add_values(R1, R2).

immediate_address(RY, RZ) ->
  R1 = registers:query_register(RY),
  io:format("The other value is ~w~n", [R1]),
  add_values(R1, RZ).

minus_one() -> utilities:hex2uint("FFFFFFFFFFFFFFFF").

add_values(V1, V2) ->
  A = (V1 + V2),
  io:format("The total is ~w~n", [A]),
  MaxMemory = minus_one(),
  if
    A > MaxMemory
      ->
        register_ra ! {event, overflow},
        {overflow,(A - (MaxMemory + 1))};
    true
      -> {no_overflow, A}
  end.
