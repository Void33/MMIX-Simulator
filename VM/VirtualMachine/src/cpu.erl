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
-define(DIVU,   16#1E).
-define(ADD,    16#20).
-define(ADDU,   16#22).
-define(ADDUI,  16#23).
-define(SUB,    16#24).
-define(SUBU,   16#26).
-define(ADDU2,  16#28).
-define(ADDU4,  16#2A).
-define(ADDU8,  16#2C).
-define(ADDU16, 16#2E).
-define(CMP,    16#30).
-define(CMPU,   16#32).
-define(NEG,    16#34).
-define(NEGU,   16#36).
-define(SL,     16#38).
-define(SLU,    16#3A).
-define(SR,     16#3C).
-define(SRU,    16#3E).
-define(BN,     16#40).
-define(BZ,     16#42).
-define(BP,     16#44).
-define(BOD,    16#46).
-define(BNN,    16#48).
-define(BNZ,    16#4A).
-define(BNP,    16#4C).
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
-define(STW,    16#A4).
-define(STWU,   16#A6).
-define(STWUI,  16#A7).
-define(STT,    16#A8).
-define(STTU,   16#AA).
-define(STO,    16#AC).
-define(STOU,   16#AE).
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

%% 20-2F
execute(?ADDUI, PC) ->
  addi(PC);
%% 30-3F
%% 40-4F
%% 50-5F
%% 60-6F
%% 70-7F
%% 80-8F
execute(?LDOU, PC) ->
  ldou(PC);
%% 90-9F
%% A0-AF
execute(?STWU, PC) ->
  stwu(PC);
execute(?STWUI, PC) ->
  stwui(PC);
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
%% F0-FF
execute(OpCode, _PC) ->
  erlang:display("Execute"),
  erlang:display(OpCode).


%% Execute the individual instructions

%% 00-0F

trap(PC) ->
  io:format("TRAP~n"),
  {RX, RY, RZ} = three_operands(PC),
  Msgs = trap:process_trap(RX, RY, RZ),
  Updates = [{pc, (PC + 4)}],
  {Updates, Msgs}.

%% 10-1F
%% 20-2F

addi(PC) ->
  io:format("ADDUI ~w~n",[PC]),
  {RX, RY, RZ} = three_operands(PC),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  {Overflow, NewValue} = immediate_address(RY, RZ),
  io:format("Registers ~w - ~w~n",[Overflow, NewValue]),
  Updates = [{RX, NewValue}, {pc, (PC + 4)}],
  io:format("Updates ~w~n",[Updates]),
  NewList = case Overflow of
              overflow ->
                [{rA, 1} | Updates];
              _ ->
                Updates
            end,
  io:format("New List ~w~n",[NewList]),
  {NewList, []}.

%% 30-3F
%% 40-4F
%% 50-5F
%% 60-6F
%% 70-7F
%% 80-8F

ldou(PC) ->
  {_RX, RY, RZ} = three_operands(PC),
  {_Overflow, _A} = address_two_registers(RY, RZ).

%% 90-9F
%% A0-AF

stwu(PC) ->
  io:format("STWU ~w~n", [PC]),
  {RX, RY, RZ} = three_operands(PC),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  RZVal = registers:query_register(RZ),
  stwui(PC, RX, RY, RZVal).

stwui(PC) ->
  io:format("STWUI ~w~n", [PC]),
  {RX, RY, RZVal} = three_operands(PC),
  stwui(PC, RX, RY, RZVal).

hex2int(L) ->
  << I:64/signed-integer >> = hex_to_bin(L),
  I.

hex_to_bin(L) -> << <<(h2i(X)):4>> || X<-L >>.

h2i(X) ->
  case X band 64 of
    64 -> X band 7 + 9;
    _  -> X band 15
  end.

stwui(_PC, RX, RY, Z) ->
  io:format("Registers ~w - ~w - ~18.16.0B~n",[RX, RY, Z]),
  TH = integer_to_list(Z, 16),
  TR = hex2int(TH),
  TV = hex2int("7FFFFFFFFFFFFFFF"),
  io:format("The values are ~w ~w ~w ~n", [TH, TR, TV]),
  IA = immediate_address(RY, Z),
  RXVal = registers:query_register(RX),
  io:format("Set the address ~w to the least significant bits of ~w~n", [IA, RXVal]),
  {[], []}.

%% B0-BF
%% C0-CF

mmix_or(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  ori(PC, RX, RY, RZVal).

ori(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  ori(PC, RX, RY, RZ).

ori(PC, RX, RY, Z) ->
  RYVal = registers:query_register(RY),
  NVal = RYVal bor Z,
  io:format("ORI ~w ~w (~w) ~w = (~w)~n", [RX, RY, RYVal, Z, NVal]),
  {[{RX, NVal}, {pc, PC + 4}], []}.

%% D0-DF
%% E0-EF

setl(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  io:format("SETL~n", []),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  RVal = (RZ * 256) + RY,
  Update = registers:set_register_lowwyde(RX, RVal),
  {[Update, {pc, (PC + 4)}], []}.

%% F0-FF

%% Utilities

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
  add_values(R1, RZ).

add_values(V1, V2) ->
  A = (V1 + V2),
  MaxMemory = math:pow(2, 64),
  if
    A > MaxMemory
      -> {overflow,(A - MaxMemory)};
    true
      -> {no_overflow, A}
  end.
