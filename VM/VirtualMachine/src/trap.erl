%%%-------------------------------------------------------------------
%%% @author steveedmans
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Aug 2015 11:12
%%%-------------------------------------------------------------------
-module(trap).
-author("steveedmans").

-define(FPUTS, 7).
-define(STDOUT, 0).
-define(HALT, 0).

%% API
-export([process_trap/3]).

process_trap(0, ?FPUTS, ?STDOUT) ->
  R = registers:query_register(255),
  Txt = memory:get_nstring(R),
  [{display, Txt}];
process_trap(0, ?HALT, 0) ->
  [halt];
process_trap(_RX, _RY, _RZ) ->
  erlang:display("PROCESS A TRAP").