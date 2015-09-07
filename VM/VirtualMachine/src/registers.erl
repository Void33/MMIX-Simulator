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
-export([init/0, contents/0, set_register/2, query_register/1, stop/0]).

%% Create a new ETS table and populate it with all of the available
%% registers.
init() ->
%%  Info = ets:info(registers),
%%  case Info of
%%    undefined -> true;
%%    _ -> ets:delete(registers)
%%  end,
  Registers_Table = create_table(),
  create_user_defined_registers(Registers_Table),
  create_mmix_specific_registers(Registers_Table).

stop() ->
  ets:delete(registers).

contents() ->
  FL = ets:tab2list(registers),
  lists:filter(fun(X) -> tst_filter(X) end, FL).
%%  FL.

tst_filter(X) ->
  {_, V} = X,
  V /= 0.

set_register(Register, Value) ->
  io:format("Set Register ~w to ~w~n",[Register, Value]),
  ets:update_element(registers, Register, {2, Value}).

query_register(Register) ->
  [{Register, Value}] = ets:lookup(registers,Register),
  Value.

create_table() ->
  ets:new(registers, [set, named_table]).

create_user_defined_registers(Registers) ->
  lists:map(fun(X) -> {ets:insert(Registers,{X, 0})} end, lists:seq(0, 255)).

create_mmix_specific_registers(Registers) ->
  Mmix_registers = [pc,rA, rB, rC, rD, rE, rF, rG, rH, rI, rJ, rK, rL, rM, rN, rO, rP, rQ, rR, rS, rT, rU, rV, rW, rX, rY, rZ, rBB, rTT, rWW, rXX, rYY, rZZ],
  lists:map(fun(X) -> {ets:insert(Registers,{X, 0})} end, Mmix_registers).
