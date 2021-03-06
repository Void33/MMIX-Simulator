%%%------------------------------------------------------------------ -
%%% @author Steve Edmans
%%% @copyright (C) 2014, Steve Edmans
%%% @doc
%%% This module contains the functionality for setting and querying
%%% the registers.
%%% @end
%%% Created : 17. Mar 2014 13:09
%%%-------------------------------------------------------------------
-module(registers).
-author("Steve Edmans").

%% API
-export([init/0, contents/0, set_register/2, query_register/1, query_adjusted_register/1, stop/0, set_register_lowwyde/2]).

%% Create a new ETS table and populate it with all of the available
%% registers.
init() ->
  Registers_Table = create_table(),
  create_user_defined_registers(Registers_Table),
  create_mmix_specific_registers(Registers_Table).

stop() ->
  ets:delete(registers).

contents() ->
  FL = ets:tab2list(registers),
  FL.

set_register_lowwyde(RX, RVal) ->
  CVal = query_register(RX),
  CQuot = CVal div 16#10000,
  NVal = CQuot * 16#10000 + RVal,
  {RX, NVal}.

set_register(Register, Value) ->
  ets:update_element(registers, Register, {2, Value}).

query_register(Register) ->
  [{Register, Value}] = ets:lookup(registers,Register),
  Value.

query_adjusted_register(Register) ->
  Unadjusted_Value = query_register(Register),
  utilities:signed_integer16(Unadjusted_Value).

create_table() ->
  ets:new(registers, [set, named_table]).

create_user_defined_registers(Registers) ->
  lists:map(fun(X) -> {ets:insert(Registers,{X, 0})} end, lists:seq(0, 255)).

create_mmix_specific_registers(Registers) ->
  Mmix_registers = [pc,rA, rB, rC, rD, rE, rF, rG, rH, rI, rJ, rK, rL, rM, rN, rO, rP, rQ, rR, rS, rT, rU, rV, rW, rX, rY, rZ, rBB, rTT, rWW, rXX, rYY, rZZ],
  lists:map(fun(X) -> {ets:insert(Registers,{X, 0})} end, Mmix_registers).
