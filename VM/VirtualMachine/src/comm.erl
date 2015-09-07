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
    {udp, Socket, Host, Port, Bin} ->
      io:format("Received Binary ~w~n", [Bin]),
      N = binary_to_term(Bin),
      case process_message(N) of
        {updates, Updates} ->
          gen_udp:send(Socket, Host, Port, term_to_binary({updates, Updates}));
        {all_registers, Registers} ->
          gen_udp:send(Socket, Host, Port, term_to_binary({all_registers, Registers}));
        _ ->
          gen_udp:send(Socket, Host, Port, term_to_binary(finished))
      end,
      loop(Socket);
    stop ->
      gen_udp:close(Socket),
      erlang:display(registers:contents()),
      registers:stop(),
      memory:contents(),
      memory:stop()
  end.

process_message(process_next) ->
  {updates, process_next_statement()};
process_message(stop) ->
  self() ! stop,
  stopping;
process_message({program, Code}) ->
  memory:store_program(Code),
  storing;
process_message({registers, Registers}) ->
  lists:map(fun({X, Y}) -> {registers:set_register(X, Y)} end, Registers),
  Pc = registers:query_register(255),
  registers:set_register(pc, Pc),
  updating;
process_message(get_all_registers) ->
  {all_registers, registers:contents()};
process_message(N) ->
  io:format("Unrecognized Message ~w~n", [N]),
  unknown.

process_next_statement() ->
  next_statement().

next_statement() ->
  PC = registers:query_register(pc),
  FullOpCode = memory:get_byte(PC),
  {Updates, Msgs} = cpu:execute(FullOpCode, PC),
  lists:map(fun({R, V}) -> {registers:set_register(R, V)} end, Updates),
  {Updates, Msgs}.

