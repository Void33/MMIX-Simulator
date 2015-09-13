%%%-------------------------------------------------------------------
%%% @author steve edmans
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% The module creates an actor that we use to handle the Arithmetic Status Register (rA).
%%% @end
%%% Created : 13. Sep 2015 11:33
%%%-------------------------------------------------------------------
-module(register_ra).
-author("steveedmans").

-define(ROUND_TO_NEAREST, 0).
-define(ROUND_TO_OFF,     1).
-define(ROUND_TO_UP,      2).
-define(ROUND_TO_DOWN,    3).

%% API
-export([start/0, loop/3]).

start() ->
  register(register_ra, spawn(register_ra, loop, [?ROUND_TO_NEAREST, sets:new(), sets:new()])).

loop(RoundingMode, EnableBits, EventBits) ->
  io:format("The event bits are :- ~w~n", [sets:to_list(EventBits)]),
  receive
    stop ->
      true;
    {From, value} ->
      return_state(From, RoundingMode, EnableBits, EventBits),
      loop(RoundingMode, EnableBits, sets:new());
    {From, rounding_mode} ->
      io:format("The rounding mode is ~w~n",[RoundingMode]),
      From ! {self(), RoundingMode},
      loop(RoundingMode, EnableBits, EventBits);
    {event, Flag} ->
      io:format("Received Event ~w~n", [Flag]),
      loop(RoundingMode, EnableBits, set_flag(EnableBits, EventBits, Flag));
    Msg ->
      io:format("We received this message ~w~n", [Msg]),
      loop(RoundingMode, EnableBits, EventBits)
  end.

return_state(From, RoundingMode, EnableBits, EventBits) ->
  io:format("We need to calculate the current state of the rA register ~w ~w ~w~n", [RoundingMode, sets:to_list(EnableBits), sets:to_list(EventBits)]),
  From ! RoundingMode.

set_flag(EnableBits, EventBits, divide_check) ->
  case sets:is_element(divide_check, EnableBits) of
    true ->
      io:format("Divide Check Disabled~n"),
      EventBits;
    false ->
      io:format("Divide Check Enabled and Set~n"),
      NS = sets:add_element(divide_check, EventBits),
      io:format("The new events are ~w~n", [sets:to_list(NS)]),
      NS
  end;
set_flag(EnableBits, EventBits, overflow) ->
  case sets:is_element(overflow, EnableBits) of
    true ->
      io:format("Overflow Disabled~n"),
      EventBits;
    false ->
      io:format("Overflow Enabled and Set~n"),
      NS = sets:add_element(overflow, EventBits),
      io:format("The new events are ~w~n", [sets:to_list(NS)]),
      NS
  end;
set_flag(EnableBits, EventBits, float_to_fix) ->
  case sets:is_element(float_to_fix, EnableBits) of
    true ->
      io:format("float_to_fix Disabled~n"),
      EventBits;
    false ->
      io:format("float_to_fix Enabled and Set~n"),
      NS = sets:add_element(float_to_fix, EventBits),
      io:format("The new events are ~w~n", [sets:to_list(NS)]),
      NS
  end;
set_flag(EnableBits, EventBits, invalid_operation) ->
  case sets:is_element(invalid_operation, EnableBits) of
    true ->
      io:format("invalid_operation Disabled~n"),
      EventBits;
    false ->
      io:format("invalid_operation Enabled and Set~n"),
      NS = sets:add_element(invalid_operation, EventBits),
      io:format("The new events are ~w~n", [sets:to_list(NS)]),
      NS
  end;
set_flag(EnableBits, EventBits, floating_overflow) ->
  case sets:is_element(floating_overflow, EnableBits) of
    true ->
      io:format("floating_overflow Disabled~n"),
      EventBits;
    false ->
      io:format("floating_overflow Enabled and Set~n"),
      NS = sets:add_element(floating_overflow, EventBits),
      io:format("The new events are ~w~n", [sets:to_list(NS)]),
      NS
  end;
set_flag(EnableBits, EventBits, floating_underflow) ->
  case sets:is_element(floating_underflow, EnableBits) of
    true ->
      io:format("floating_underflow Disabled~n"),
      EventBits;
    false ->
      io:format("floating_underflow Enabled and Set~n"),
      NS = sets:add_element(floating_underflow, EventBits),
      io:format("The new events are ~w~n", [sets:to_list(NS)]),
      NS
  end;
set_flag(EnableBits, EventBits, division_by_zero) ->
  case sets:is_element(division_by_zero, EnableBits) of
    true ->
      io:format("division_by_zero Disabled~n"),
      EventBits;
    false ->
      io:format("division_by_zero Enabled and Set~n"),
      NS = sets:add_element(division_by_zero, EventBits),
      io:format("The new events are ~w~n", [sets:to_list(NS)]),
      NS
  end;
set_flag(EnableBits, EventBits, floating_inexact) ->
  case sets:is_element(floating_inexact, EnableBits) of
    true ->
      io:format("floating_inexact Disabled~n"),
      EventBits;
    false ->
      io:format("floating_inexact Enabled and Set~n"),
      NS = sets:add_element(floating_inexact, EventBits),
      io:format("The new events are ~w~n", [sets:to_list(NS)]),
      NS
  end;
set_flag(_EnableBits, EventBits, _Flag) ->
  io:format("SET FLAG 2"),
  EventBits.