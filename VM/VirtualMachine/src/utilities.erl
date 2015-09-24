%%%-------------------------------------------------------------------
%%% @author steveedmans
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Sep 2015 20:04
%%%-------------------------------------------------------------------
-module(utilities).
-author("Steve Edmans").

%% API
-export([signed_integer16/1, unsigned_integer16/1, hex2int/1, hex2uint/1, get_8_bytes/1]).
-export([get_0_wyde/1,get_1_wyde/1,get_2_wyde/1,get_3_wyde/1]).
-export([get_0_byte/1,get_1_byte/1,get_2_byte/1,get_3_byte/1,get_4_byte/1,get_5_byte/1,get_6_byte/1,get_7_byte/1]).
-export([adjust_location/2, twos_complement/1, minus_one/0]).

hex2uint(L) ->
  << I:64/unsigned-integer >> = hex_to_bin(L),
  I.

hex2int(L) ->
  << I:64/signed-integer >> = hex_to_bin(L),
  I.

hex_to_bin(L) -> << <<(h2i(X)):4>> || X<-L >>.

h2i(X) ->
  case X band 64 of
    64 -> X band 7 + 9;
    _  -> X band 15
  end.

signed_integer16(V) ->
  FV = unsigned_integer16(V),
  case FV >= min_value() of
    false -> FV;
    true  -> -1 * ((minus_one() - FV) + 1)
  end.

unsigned_integer16(V) ->
  twos_complement(twos_complement(V)).#

get_8_bytes(V) ->
  A = integer_to_list(V, 16),
  B = lists:reverse(A),
  C = split_bytes(B, []),
  pad_with_8_zero(C).

split_bytes([], Acc) -> Acc;
split_bytes([B|[]], Acc) -> [{lists:reverse([B | "0"])} | Acc];
split_bytes(X, Acc) ->
  {B, R} = lists:split(2, X),
  NewAcc = [{lists:reverse(B)} | Acc],
  split_bytes(R, NewAcc).

pad_with_8_zero([_,_,_,_,_,_,_,_|[]] = L) -> L;
pad_with_8_zero([_,_,_,_,_,_,_,_|_] = L) ->
  {_Lose, RL} = lists:split(1, L),
  pad_with_8_zero(RL);
pad_with_8_zero(L) ->
  NL = lists:append([{"00"}], L),
  pad_with_8_zero(NL).

get_0_byte(V) ->
  VB = get_8_bytes(V),
  {_, [{B}|_]} = lists:split(7, VB),
  byte_to_int(B).

get_1_byte(V) ->
  VB = get_8_bytes(V),
  {_, [{B}|_]} = lists:split(6, VB),
  byte_to_int(B).

get_2_byte(V) ->
  VB = get_8_bytes(V),
  {_, [{B}|_]} = lists:split(5, VB),
  byte_to_int(B).

get_3_byte(V) ->
  VB = get_8_bytes(V),
  {_, [{B}|_]} = lists:split(4, VB),
  byte_to_int(B).

get_4_byte(V) ->
  VB = get_8_bytes(V),
  {_, [{B}|_]} = lists:split(3, VB),
  byte_to_int(B).

get_5_byte(V) ->
  VB = get_8_bytes(V),
  {_, [{B}|_]} = lists:split(2, VB),
  byte_to_int(B).

get_6_byte(V) ->
  VB = get_8_bytes(V),
  {_, [{B}|_]} = lists:split(1, VB),
  byte_to_int(B).

get_7_byte(V) ->
  VB = get_8_bytes(V),
  [{B}|_] = VB,
  byte_to_int(B).

get_0_wyde(V) ->
  VB = get_8_bytes(V),
  {_, B} = lists:split(6, VB),
  wyde_to_int(B).

get_1_wyde(V) ->
  VB = get_8_bytes(V),
  {_, B} = lists:split(4, VB),
  {C, _} = lists:split(2, B),
  wyde_to_int(C).

get_2_wyde(V) ->
  VB = get_8_bytes(V),
  {B, _} = lists:split(4, VB),
  {_, C} = lists:split(2, B),
  wyde_to_int(C).

get_3_wyde(V) ->
  VB = get_8_bytes(V),
  {B, _} = lists:split(4, VB),
  {C, _} = lists:split(2, B),
  wyde_to_int(C).

byte_to_int(B) ->
  FullByte = lists:append("00000000000000", B),
  hex2int(FullByte).

wyde_to_int(B) ->
  [{M0},{M1}|_] = B,
  Wyde = lists:append(M0,M1),
  FullWyde = lists:append("000000000000", Wyde),
  hex2int(FullWyde).

adjust_location(Location, Scale) ->
  (Location div Scale) * Scale.

min_value() -> utilities:hex2uint("8000000000000000").
minus_one() -> utilities:hex2uint("FFFFFFFFFFFFFFFF").

twos_complement(Value) ->
  Step3 = case Value < 0 of
    false ->
      Step1 = minus_one(),
      Step2 = Value - 1,
      Step1 - Step2;
    true ->
      -1 * Value
  end,
  Step3.