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
-export([start_vm/0, process_next_statement/0]). %%, start_registers/0]).

-define(PORT, 4000).

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
      gen_udp:close(Socket),
      erlang:display(registers:contents()),
      registers:stop(),
      memory:contents(),
      memory:stop()
  end.

process_message(process_next) ->
  process_next_statement();
process_message(stop) ->
  self() ! stop;
process_message({program, Code}) ->
  memory:store_program(Code);
process_message({registers, Registers}) ->
  lists:map(fun({X, Y}) -> {registers:set_register(X, Y)} end, Registers),
  Pc = registers:query_register(255),
  registers:set_register(pc, Pc);
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
  cpu:execute(FullOpCode, PC).
%%  case FullOpCode of
%%    {ok, OpCode} -> execute(OpCode, PC)
%%  end.

