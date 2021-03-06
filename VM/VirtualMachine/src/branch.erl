%%%-------------------------------------------------------------------
%%% @author steveedmans
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Sep 2015 20:04
%%%-------------------------------------------------------------------
-module(branch).
-author("Steve Edmans").

%% API
-export([bn/1, bz/1, bp/1, bod/1, bnn/1, bnz/1, bnp/1, bev/1, jmp/1]).
-export([branch_forward/5, branch_backward/5]).

branch_forward(Fun, PC, RX, Address, Stmt) ->
  NewPC = case Fun(RX) of
            false -> PC + 4;
            true  -> PC + (4 * Address)
          end,
  {Stmt, [{pc, NewPC}], []}.

branch_backward(Fun, PC, RX, Address, Stmt) ->
  NewPC = case Fun(RX) of
            false -> PC + 4;
            true  -> PC - (4 * Address)
          end,
  {Stmt, [{pc, NewPC}], []}.

bn(RX) ->
  RXVal = registers:query_adjusted_register(RX),
  RXVal < 0.

bz(RX) ->
  RXVal = registers:query_adjusted_register(RX),
  RXVal == 0.

bp(RX) ->
  RXVal = registers:query_adjusted_register(RX),
  RXVal > 0.

bod(RX) ->
  RXVal = registers:query_adjusted_register(RX),
  (RXVal rem 2) /= 0.

bnn(RX) ->
  bn(RX) == false.

bnz(RX) ->
  bz(RX) == false.

bnp(RX) ->
  bp(RX) == false.

bev(RX) ->
  bod(RX) == false.

jmp(_RX) -> true.
