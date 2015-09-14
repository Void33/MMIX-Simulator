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
-export([start/0, loop/3, calculate_byte/2]).

start() ->
  register(register_ra, spawn(register_ra, loop, [?ROUND_TO_NEAREST, sets:new(), sets:new()])).

loop(RoundingMode, EnableBits, EventBits) ->
  receive
    stop ->
      true;
    {From, value} ->
      RAVal = return_state(From, RoundingMode, EnableBits, EventBits),
      io:format("The rA Value is ~w~n", [RAVal]),
      loop(RoundingMode, EnableBits, sets:new());
    {From, rounding_mode} ->
      From ! {self(), RoundingMode},
      loop(RoundingMode, EnableBits, EventBits);
    {event, Flag} ->
      loop(RoundingMode, EnableBits, set_flag(EnableBits, EventBits, Flag));
    Msg ->
      io:format("We received this message ~w~n", [Msg]),
      loop(RoundingMode, EnableBits, EventBits)
  end.

return_state(From, RoundingMode, EnableBits, EventBits) ->
  EventValue = calculate_byte(sets:to_list(EventBits), 0),
  EnableValue = calculate_byte(sets:to_list(EnableBits), 0),
  Value = ((RoundingMode * 256) + EnableValue) * 256 + EventValue,
  From ! Value.

calculate_byte([floating_inexact|Rest], Total) -> calculate_byte(Rest, Total + 1);
calculate_byte([division_by_zero|Rest], Total) -> calculate_byte(Rest, Total + 2);
calculate_byte([floating_underflow|Rest], Total) -> calculate_byte(Rest, Total + 4);
calculate_byte([floating_overflow|Rest], Total) -> calculate_byte(Rest, Total + 8);
calculate_byte([invalid_operation|Rest], Total) -> calculate_byte(Rest, Total + 16);
calculate_byte([float_to_fix|Rest], Total) -> calculate_byte(Rest, Total + 32);
calculate_byte([overflow|Rest], Total) -> calculate_byte(Rest, Total + 64);
calculate_byte([divide_check|Rest], Total) -> calculate_byte(Rest, Total + 128);
calculate_byte(_, Total) -> Total.

set_flag(EnableBits, EventBits, divide_check) ->
  case sets:is_element(divide_check, EnableBits) of
    true ->
      EventBits;
    false ->
      sets:add_element(divide_check, EventBits)
  end;
set_flag(EnableBits, EventBits, overflow) ->
  case sets:is_element(overflow, EnableBits) of
    true ->
      EventBits;
    false ->
      sets:add_element(overflow, EventBits)
  end;
set_flag(EnableBits, EventBits, float_to_fix) ->
  case sets:is_element(float_to_fix, EnableBits) of
    true ->
      EventBits;
    false ->
      sets:add_element(float_to_fix, EventBits)
  end;
set_flag(EnableBits, EventBits, invalid_operation) ->
  case sets:is_element(invalid_operation, EnableBits) of
    true ->
      EventBits;
    false ->
      sets:add_element(invalid_operation, EventBits)
  end;
set_flag(EnableBits, EventBits, floating_overflow) ->
  case sets:is_element(floating_overflow, EnableBits) of
    true ->
      EventBits;
    false ->
      sets:add_element(floating_overflow, EventBits)
  end;
set_flag(EnableBits, EventBits, floating_underflow) ->
  case sets:is_element(floating_underflow, EnableBits) of
    true ->
      EventBits;
    false ->
      sets:add_element(floating_underflow, EventBits)
  end;
set_flag(EnableBits, EventBits, division_by_zero) ->
  case sets:is_element(division_by_zero, EnableBits) of
    true ->
      EventBits;
    false ->
      sets:add_element(division_by_zero, EventBits)
  end;
set_flag(EnableBits, EventBits, floating_inexact) ->
  case sets:is_element(floating_inexact, EnableBits) of
    true ->
      EventBits;
    false ->
      sets:add_element(floating_inexact, EventBits)
  end;
set_flag(_EnableBits, EventBits, _Flag) ->
  EventBits.