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

%% API
-export([execute/2]).

-include("cpu_execute.hrl").

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

sub(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("SUB $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  subi(PC, Stmt, RX, RY, RZVal).
subi(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("SUBI $~.16B, $~.16B, ~B", [RX, RY, RZ])),
  subi(PC, Stmt, RX, RY, RZ).
subi(PC, Stmt, RX, RY, Z) ->
  RYVal = registers:query_register(RY),
  ZNeg = utilities:twos_complement(Z),
  {_Overflow, Subtraction} = add_values(RYVal, ZNeg),
  {Stmt, [{RX, Subtraction}, next_command(PC)], []}.
subu(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("SUBU $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  Result = subi(PC, Stmt, RX, RY, RZVal),
  register_ra ! {remove, overflow},
  Result.
subui(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("SUBUI $~.16B, $~.16B, ~B", [RX, RY, RZ])),
  Result = subi(PC, Stmt, RX, RY, RZ),
  register_ra ! {remove, overflow},
  Result.

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
    RYVal <  Z -> utilities:minus_one();
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
         Diff < 0 -> utilities:minus_one() + Diff + 1;
         true     -> Diff
       end,
  io:format("The difference is ~w which goes to ~.16B~n", [Diff, NV]),
  {Stmt, [{RX, NV}, next_command(PC)], []}.

%% 40-4F

bn(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BN $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bn/1, PC, RX, Address, Stmt).
bnb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BNB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bn/1, PC, RX, Address, Stmt).

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

bp(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BP $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bp/1, PC, RX, Address, Stmt).
bpb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BPB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bp/1, PC, RX, Address, Stmt).

bod(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BOD $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bod/1, PC, RX, Address, Stmt).
bodb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BODB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bod/1, PC, RX, Address, Stmt).

bnn(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BNN $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bnn/1, PC, RX, Address, Stmt).
bnnb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BNNB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bnn/1, PC, RX, Address, Stmt).

bnz(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BNZ $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bnz/1, PC, RX, Address, Stmt).
bnzb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BNZB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bnz/1, PC, RX, Address, Stmt).

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

bev(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BEV $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bev/1, PC, RX, Address, Stmt).
bevb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("BEVB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bev/1, PC, RX, Address, Stmt).

%% 50-5F

pbn(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBN $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bn/1, PC, RX, Address, Stmt).
pbnb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBNB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bn/1, PC, RX, Address, Stmt).

pbz(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBZ $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bz/1, PC, RX, Address, Stmt).
pbzb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBZB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bz/1, PC, RX, Address, Stmt).

pbp(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBP $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bp/1, PC, RX, Address, Stmt).
pbpb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBPB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bp/1, PC, RX, Address, Stmt).

pbod(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBOD $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bod/1, PC, RX, Address, Stmt).
pbodb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBODB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bod/1, PC, RX, Address, Stmt).

pbnn(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBNN $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bnn/1, PC, RX, Address, Stmt).
pbnnb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBNNB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bnn/1, PC, RX, Address, Stmt).

pbnz(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBNZ $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bnz/1, PC, RX, Address, Stmt).
pbnzb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBNZB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bnz/1, PC, RX, Address, Stmt).

pbnp(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBNP $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bnp/1, PC, RX, Address, Stmt).
pbnpb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBNPB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bnp/1, PC, RX, Address, Stmt).

pbev(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBEV $~.16B, ~B", [RX, Address])),
  branch:branch_forward(fun branch:bev/1, PC, RX, Address, Stmt).
pbevb(PC) ->
  {RX, Y, Z} = three_operands(PC),
  Address = rval(Y, Z),
  Stmt = lists:flatten(io_lib:format("PBEVB $~.16B, ~B", [RX, Address])),
  branch:branch_backward(fun branch:bev/1, PC, RX, Address, Stmt).

%% 60-6F

csn(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSN $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cs(fun branch:bn/1, PC, Stmt, RX, RY, RZVal).
csni(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSNI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cs(fun branch:bn/1, PC, Stmt, RX, RY, Z).

csz(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSZ $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cs(fun branch:bz/1, PC, Stmt, RX, RY, RZVal).
cszi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSZI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cs(fun branch:bz/1, PC, Stmt, RX, RY, Z).

csp(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSP $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cs(fun branch:bp/1, PC, Stmt, RX, RY, RZVal).
cspi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSPI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cs(fun branch:bp/1, PC, Stmt, RX, RY, Z).

csod(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSOD $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cs(fun branch:bod/1, PC, Stmt, RX, RY, RZVal).
csodi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSODI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cs(fun branch:bod/1, PC, Stmt, RX, RY, Z).

csnn(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSNN $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cs(fun branch:bnn/1, PC, Stmt, RX, RY, RZVal).
csnni(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSNNI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cs(fun branch:bnn/1, PC, Stmt, RX, RY, Z).

csnz(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSNZ $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cs(fun branch:bnz/1, PC, Stmt, RX, RY, RZVal).
csnzi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSNZI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cs(fun branch:bnz/1, PC, Stmt, RX, RY, Z).

csnp(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSNP $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cs(fun branch:bnp/1, PC, Stmt, RX, RY, RZVal).
csnpi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSNPI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cs(fun branch:bnp/1, PC, Stmt, RX, RY, Z).

csev(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSEV $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  cs(fun branch:bev/1, PC, Stmt, RX, RY, RZVal).
csevi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSEVI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  cs(fun branch:bev/1, PC, Stmt, RX, RY, Z).

cs(Fun, PC, Stmt, RX, RY, Z) ->
  Updates = case Fun(RY) of
              true  -> [{RX, Z}, next_command(PC)];
              false -> [next_command(PC)]
            end,
  {Stmt, Updates, []}.

%% 70-7F

zsn(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSN $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  zs(fun branch:bn/1, PC, Stmt, RX, RY, RZVal).
zsni(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSNI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  zs(fun branch:bn/1, PC, Stmt, RX, RY, Z).

zsz(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSZ $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  zs(fun branch:bz/1, PC, Stmt, RX, RY, RZVal).
zszi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSZI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  zs(fun branch:bz/1, PC, Stmt, RX, RY, Z).

zsp(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSP $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  zs(fun branch:bp/1, PC, Stmt, RX, RY, RZVal).
zspi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSPI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  zs(fun branch:bp/1, PC, Stmt, RX, RY, Z).

zsod(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSOD $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  zs(fun branch:bod/1, PC, Stmt, RX, RY, RZVal).
zsodi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSODI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  zs(fun branch:bod/1, PC, Stmt, RX, RY, Z).

zsnn(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSNN $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  zs(fun branch:bnn/1, PC, Stmt, RX, RY, RZVal).
zsnni(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSNNI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  zs(fun branch:bnn/1, PC, Stmt, RX, RY, Z).

zsnz(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSNZ $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  zs(fun branch:bnz/1, PC, Stmt, RX, RY, RZVal).
zsnzi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSNZI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  zs(fun branch:bnz/1, PC, Stmt, RX, RY, Z).

zsnp(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSNP $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  zs(fun branch:bnp/1, PC, Stmt, RX, RY, RZVal).
zsnpi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSNPI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  zs(fun branch:bnp/1, PC, Stmt, RX, RY, Z).

zsev(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("CSEV $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  zs(fun branch:bev/1, PC, Stmt, RX, RY, RZVal).
zsevi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("CSEVI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  zs(fun branch:bev/1, PC, Stmt, RX, RY, Z).

zs(Fun, PC, Stmt, RX, RY, Z) ->
  Updates = case Fun(RY) of
              true  -> [{RX, Z}, next_command(PC)];
              false -> [{RX, 0}, next_command(PC)]
            end,
  {Stmt, Updates, []}.

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

ldo(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("LDO $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  RZVal = registers:query_register(RZ),
  ldoui(PC, Stmt, RX, RY, RZVal).
ldoi(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("LDOI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  ldoui(PC, Stmt, RX, RY, Z).

ldou(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("LDOU $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  RZVal = registers:query_register(RZ),
  ldoui(PC, Stmt, RX, RY, RZVal).
ldoui(PC) ->
  {RX, RY, Z} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("LDOUI $~.16B, $~.16B, ~B", [RX, RY, Z])),
  ldoui(PC, Stmt, RX, RY, Z).
ldoui(PC, Stmt, RX, RY, Z) ->
  {_Overflow, Address} = immediate_address(RY, Z),
  Value = memory:get_octabyte(Address),
  io:format("Set the register ~w to ~w~n", [RX, Value]),
  {Stmt, [{RX, Value}, next_command(PC)], []}.

%% 90-9F
%% A0-AF

stb(PC) ->
  io:format("STB ~w~n", [PC]),
  {RX, RY, RZ} = three_operands(PC),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("STB $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  stbui(PC, Stmt, RX, RY, RZVal).
stbi(PC) ->
  io:format("STBI ~w~n", [PC]),
  {RX, RY, RZVal} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("STBI $~.16B, $~.16B, ~B", [RX, RY, RZVal])),
  stbui(PC, Stmt, RX, RY, RZVal).
stbu(PC) ->
  io:format("STBU ~w~n", [PC]),
  {RX, RY, RZ} = three_operands(PC),
  io:format("Registers ~w - ~w - ~w~n",[RX, RY, RZ]),
  RZVal = registers:query_register(RZ),
  Stmt = lists:flatten(io_lib:format("STBU $~.16B, $~.16B, $~.16B", [RX, RY, RZ])),
  Result = stbui(PC, Stmt, RX, RY, RZVal),
  register_ra ! {remove, overflow},
  Result.
stbui(PC) ->
  io:format("STBUI ~w~n", [PC]),
  {RX, RY, RZVal} = three_operands(PC),
  Stmt = lists:flatten(io_lib:format("STBUI $~.16B, $~.16B, ~B", [RX, RY, RZVal])),
  Result = stbui(PC, Stmt, RX, RY, RZVal),
  register_ra ! {remove, overflow},
  Result.
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
  {RX, RY, RZ} = three_operands(PC),
  RVal = rval(RY, RZ),
  RValA = RVal bsl 48,
  RXVal = registers:query_register(RX),
  NV = RXVal bor RValA,
  Stmt = lists:flatten(io_lib:format("ORH $~.16B, ~B", [RX, RVal])),
  {Stmt, [{RX, NV}, next_command(PC)], []}.

ormh(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RVal = rval(RY, RZ),
  RValA = RVal bsl 32,
  RXVal = registers:query_register(RX),
  NV = RXVal bor RValA,
  Stmt = lists:flatten(io_lib:format("ORMH $~.16B, ~B", [RX, RVal])),
  {Stmt, [{RX, NV}, next_command(PC)], []}.

orml(PC) ->
  io:format("Process ORH~n"),
  {RX, RY, RZ} = three_operands(PC),
  RVal = rval(RY, RZ),
  RValA = RVal bsl 16,
  RXVal = registers:query_register(RX),
  NV = RXVal bor RValA,
  Stmt = lists:flatten(io_lib:format("ORML $~.16B, ~B", [RX, RVal])),
  {Stmt, [{RX, NV}, next_command(PC)], []}.

orl(PC) ->
  {RX, RY, RZ} = three_operands(PC),
  RVal = rval(RY, RZ),
  RXVal = registers:query_register(RX),
  NV = RXVal bor RVal,
  Stmt = lists:flatten(io_lib:format("ORL $~.16B, ~B", [RX, RVal])),
  {Stmt, [{RX, NV}, next_command(PC)], []}.

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

add_values(V1, V2) ->
  A = (V1 + V2),
  io:format("The total is ~w~n", [A]),
  MaxMemory = utilities:minus_one(),
  if
    A > MaxMemory
      ->
        register_ra ! {event, overflow},
        {overflow,(A - (MaxMemory + 1))};
    true
      -> {no_overflow, A}
  end.
