%%%-------------------------------------------------------------------
%%% @author sedmans
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Feb 2014 13:45
%%%-------------------------------------------------------------------
-module(comm).
-author("sedmans").
-include("memory.hrl").

%% API
-export([start_vm/0, sample/0, start/1, process_next_statement/0]). %%, start_registers/0]).

-export([test/0]).

-define(PORT, 4000).

sample() ->
  [16#8f, 16#ff, 1, 0, 0, 0, 7, 1, 16#f4, 16#ff, 0, 3, 0, 0, 7, 2, 0, 0, 0, 0, 16#2c, 16#20, 16#77, 16#6f, 16#72, 16#6c, 16#64, 10, 0, 10].

test() ->
  false.

start_vm () ->
  registers:init(),
  memory:start_link(),
  start_server().

start_server() ->
  case gen_udp:open(?PORT, [binary]) of
    {ok, Socket} -> loop(Socket);
    Error -> erlang:display(Error)
  end.

loop(Socket) ->
  receive
    {udp, Socket, _Host, _Port, Bin} ->
      N = binary_to_term(Bin),
      process_message(N),
      loop(Socket);
    stop ->
      gen_udp:close(Socket)
  end.

process_message(stop) ->
  self() ! stop;
process_message(N) ->
  erlang:display(N).

process_next_statement() ->
  next_statement(),
  erlang:display("Finished").

next_statement() ->
  erlang:display("Next Statement"),
  PC = registers:query_register(pc),
  erlang:display(PC),
  FullOpCode = memory:get_byte(PC),
  erlang:display(FullOpCode),
  execute(FullOpCode, PC).
%%  case FullOpCode of
%%    {ok, OpCode} -> execute(OpCode, PC)
%%  end.

execute(143, PC) ->
  ldou(PC);
execute(OpCode, _PC) ->
  erlang:display("Execute"),
  erlang:display(OpCode).

three_operands(PC) ->
  First = operand(PC+1),
  Second = operand(PC+2),
  Third = operand(PC+3),
  {First, Second, Third}.

operand(Location) ->
  erlang:display(Location),
  memory:get_byte(Location).
%%  case FullValue of
%%    {ok, Value} -> Value
%%  end.

ldou(PC) ->
  erlang:display("LDOU"),
  {RX, RY, RZ} = three_operands(PC),
  erlang:display(RX),
  erlang:display(RY),
  erlang:display(RZ),
  A = address_two_registers(RY, RZ),
  erlang:display("Address"),
  erlang:display(A).

start(Program)->
  memory:store_program(Program, 0).

address_two_registers(RX, RY) ->
  erlang:display("Determine address from two registers"),
  R1 = registers:query_register(RX),
  erlang:display(R1),
  R2 = registers:query_register(RY),
  erlang:display(R2),
  A = (R1 + R2),
  MaxMemory = math:pow(2, 64),
  if
    A > MaxMemory
      -> (A - MaxMemory);
    true
      -> A
  end.
