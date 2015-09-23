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

%% API
-export([start_vm/0, process_next_statement/0]).

-define(PORT, 4000).

start_vm () ->
  registers:init(),
  case whereis(register_ra) of
    undefined -> true;
    _Pid -> register_ra ! stop
  end,
  register_ra:start(),
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
      N = binary_to_term(Bin),
      case process_message(N) of
        {updates, Updates} ->
          RV = {updates, Updates},
          TTB = term_to_binary(RV),
          gen_udp:send(Socket, Host, Port, TTB);
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
      register_ra ! stop,
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
  registers:stop(),
  registers:init(),
  lists:map(fun({X, Y}) -> {set_unadjusted_register(X, Y)} end, Registers),
  Pc = registers:query_register(255),
  registers:set_register(pc, Pc),
  updating;
process_message(get_all_registers) ->
  {all_registers, registers:contents()};
process_message(N) ->
  io:format("Unrecognized Message ~w~n", [N]),
  unknown.

set_unadjusted_register(R, V) ->
  registers:set_register(R, V).

process_next_statement() ->
  next_statement().

get_special_registers() ->
  Ra = get_register_ra(),
  [Ra].

get_register_ra() ->
  register_ra ! {self(), value},
  receive
    Ra ->
      {rA, Ra}
  end.

next_statement() ->
  PC = registers:query_register(pc),
  FullOpCode = memory:get_byte(PC),
  {Code, Updates, Msgs} = cpu:execute(FullOpCode, PC),
  Upd = get_special_registers(),
  FullUpdates = Updates ++ Upd,
  lists:map(fun({R, V}) -> {registers:set_register(R, V)} end, FullUpdates),
  {Code, FullUpdates, Msgs}.
