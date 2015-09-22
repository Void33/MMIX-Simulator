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
-define(STDOUT, 1).
-define(HALT, 0).

%% API
-export([process_trap/3]).

process_trap(0, ?FPUTS, ?STDOUT) ->
  R = registers:query_register(255),
  io:format("Print out a string at address ~w~n", [R]),
  Txt = memory:get_nstring(R),
  io:format("Which is ~w~n", [Txt]),
  [{display, Txt}];
process_trap(0, ?HALT, 0) ->
  io:format("Halt the program!"),
  [halt];
process_trap(RX, RY, RZ) ->
  io:format("Process an unknown trap ~w ~w ~w~n", [RX, RY, RZ]),
  [unknown].
