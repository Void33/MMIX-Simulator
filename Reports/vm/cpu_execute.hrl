%%%-------------------------------------------------------------------
%%% @author steveedmans
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% This header file contains the execute command
%%% @end
%%% Created : 17. Sep 2015 15:47
%%%-------------------------------------------------------------------
-author("steveedmans").

-include("cpu.hrl").

%% Determine which function we are executing

%% 00-0F

execute(?TRAP, PC) ->
  trap(PC);

%% 10-1F

execute(?MUL, PC) ->
  mul(PC);
execute(?MULI, PC) ->
  muli(PC);

execute(?MULU, PC) ->
  mulu(PC);
execute(?MULUI, PC) ->
  mului(PC);

execute(?DIV, PC) ->
  mmix_div(PC);
execute(?DIVI, PC) ->
  divi(PC);

execute(?DIVU, PC) ->
  divu(PC);
execute(?DIVUI, PC) ->
  divui(PC);

%% 20-2F

execute(?ADD, PC) ->
  add(PC);
execute(?ADDI, PC) ->
  addi(PC);

execute(?ADDU, PC) ->
  addu(PC);
execute(?ADDUI, PC) ->
  addui(PC);

execute(?SUB, PC) ->
  sub(PC);
execute(?SUBI, PC) ->
  subi(PC);

execute(?SUBU, PC) ->
  subu(PC);
execute(?SUBUI, PC) ->
  subui(PC);

execute(?ADDU2, PC) ->
  addu2(PC);
execute(?ADDU2I, PC) ->
  addu2i(PC);

execute(?ADDU4, PC) ->
  addu4(PC);
execute(?ADDU4I, PC) ->
  addu4i(PC);

execute(?ADDU8, PC) ->
  addu8(PC);
execute(?ADDU8I, PC) ->
  addu8i(PC);

execute(?ADDU16, PC) ->
  addu16(PC);
execute(?ADDU16I, PC) ->
  addu16i(PC);

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

execute(?BN, PC) ->
  bn(PC);
execute(?BNB, PC) ->
  bnb(PC);
execute(?BZ, PC) ->
  bz(PC);
execute(?BZB, PC) ->
  bzb(PC);
execute(?BP, PC) ->
  bp(PC);
execute(?BPB, PC) ->
  bpb(PC);
execute(?BOD, PC) ->
  bod(PC);
execute(?BODB, PC) ->
  bodb(PC);
execute(?BNN, PC) ->
  bnn(PC);
execute(?BNNB, PC) ->
  bnnb(PC);
execute(?BNZ, PC) ->
  bnz(PC);
execute(?BNZB, PC) ->
  bnzb(PC);
execute(?BNP, PC) ->
  bnp(PC);
execute(?BNPB, PC) ->
  bnpb(PC);
execute(?BEV, PC) ->
  bev(PC);
execute(?BEVB, PC) ->
  bevb(PC);

%% 50-5F

execute(?PBN, PC) ->
  pbn(PC);
execute(?PBNB, PC) ->
  pbnb(PC);
execute(?PBZ, PC) ->
  pbz(PC);
execute(?PBZB, PC) ->
  pbzb(PC);
execute(?PBP, PC) ->
  pbp(PC);
execute(?PBPB, PC) ->
  pbpb(PC);
execute(?PBOD, PC) ->
  pbod(PC);
execute(?PBODB, PC) ->
  pbodb(PC);
execute(?PBNN, PC) ->
  pbnn(PC);
execute(?PBNNB, PC) ->
  pbnnb(PC);
execute(?PBNZ, PC) ->
  pbnz(PC);
execute(?PBNZB, PC) ->
  pbnzb(PC);
execute(?PBNP, PC) ->
  pbnp(PC);
execute(?PBNPB, PC) ->
  pbnpb(PC);
execute(?PBEV, PC) ->
  pbev(PC);
execute(?PBEVB, PC) ->
  pbevb(PC);

%% 60-6F

execute(?CSN, PC) ->
  csn(PC);
execute(?CSNI, PC) ->
  csni(PC);

execute(?CSZ, PC) ->
  csz(PC);
execute(?CSZI, PC) ->
  cszi(PC);

execute(?CSP, PC) ->
  csp(PC);
execute(?CSPI, PC) ->
  cspi(PC);

execute(?CSOD, PC) ->
  csod(PC);
execute(?CSODI, PC) ->
  csodi(PC);

execute(?CSNN, PC) ->
  csnn(PC);
execute(?CSNNI, PC) ->
  csnni(PC);

execute(?CSNZ, PC) ->
  csnz(PC);
execute(?CSNZI, PC) ->
  csnzi(PC);

execute(?CSNP, PC) ->
  csnp(PC);
execute(?CSNPI, PC) ->
  csnpi(PC);

execute(?CSEV, PC) ->
  csev(PC);
execute(?CSEVI, PC) ->
  csevi(PC);

%% 70-7F

execute(?ZSN, PC) ->
  zsn(PC);
execute(?ZSNI, PC) ->
  zsni(PC);

execute(?ZSZ, PC) ->
  zsz(PC);
execute(?ZSZI, PC) ->
  zszi(PC);

execute(?ZSP, PC) ->
  zsp(PC);
execute(?ZSPI, PC) ->
  zspi(PC);

execute(?ZSOD, PC) ->
  zsod(PC);
execute(?ZSODI, PC) ->
  zsodi(PC);

execute(?ZSNN, PC) ->
  zsnn(PC);
execute(?ZSNNI, PC) ->
  zsnni(PC);

execute(?ZSNZ, PC) ->
  zsnz(PC);
execute(?ZSNZI, PC) ->
  zsnzi(PC);

execute(?ZSNP, PC) ->
  zsnp(PC);
execute(?ZSNPI, PC) ->
  zsnpi(PC);

execute(?ZSEV, PC) ->
  zsev(PC);
execute(?ZSEVI, PC) ->
  zsevi(PC);

%% 80-8F

execute(?LDB, PC) ->
  ldb(PC);
execute(?LDBI, PC) ->
  ldbi(PC);
execute(?LDBU, PC) ->
  ldbu(PC);
execute(?LDBUI, PC) ->
  ldbui(PC);
execute(?LDW, PC) ->
  ldw(PC);
execute(?LDWI, PC) ->
  ldwi(PC);
execute(?LDWU, PC) ->
  ldwu(PC);
execute(?LDWUI, PC) ->
  ldwui(PC);
execute(?LDT, PC) ->
  ldt(PC);
execute(?LDTI, PC) ->
  ldti(PC);
execute(?LDTU, PC) ->
  ldtu(PC);
execute(?LDTUI, PC) ->
  ldtui(PC);
execute(?LDO, PC) ->
  ldo(PC);
execute(?LDOI, PC) ->
  ldoi(PC);
execute(?LDOU, PC) ->
  ldou(PC);
execute(?LDOUI, PC) ->
  ldoui(PC);

%% 90-9F

%% A0-AF

execute(?STB, PC) ->
  stb(PC);
execute(?STBI, PC) ->
  stbi(PC);
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
execute(?ORMH, PC) ->
  ormh(PC);
execute(?ORML, PC) ->
  orml(PC);
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
