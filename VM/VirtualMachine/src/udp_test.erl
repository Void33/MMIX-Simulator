%% Copyright
-module(udp_test).
-author("sedmans").

%% API
-export([start_server/0, client/1, client_term/1]).

start_server() ->
  spawn(fun() -> server(4000) end).

server(Port) ->
  {ok, Socket} = gen_udp:open(Port, [binary]),
  io:format("server open socket:~p~n", [Socket]),
  loop(Socket).

loop(Socket) ->
  receive
    {udp, Socket, Host, Port, Bin} = Msg ->
      io:format("server received:~p~n", [Msg]),
      N = binary_to_term(Bin),
      io:format("decoded to:~p~n", [N]),
      gen_udp:send(Socket, Host, Port, term_to_binary(N)),
      loop(Socket)
    end.

client_term(T) ->
  {ok, Socket} = gen_udp:open(0, [binary]),
  io:format("client opened socket=~p~n",[Socket]),
  ok = gen_udp:send(Socket, "localhost", 4000, term_to_binary(T)),
  Value = receive
            {udp, Socket, _, _, Bin} = Msg ->
              io:format("client received:~p~n", [Msg]),
              binary_to_term(Bin)
  after 2000 ->
    0
          end,
  gen_udp:close(Socket),
  Value.

client(N) ->
  {ok, Socket} = gen_udp:open(0, [binary]),
  io:format("client opened socket=~p~n",[Socket]),
  ok = gen_udp:send(Socket, "localhost", 4000, term_to_binary(N)),
  Value = receive
            {udp, Socket, _, _, Bin} = Msg ->
              io:format("client received:~p~n", [Msg]),
              binary_to_term(Bin)
    after 2000 ->
      0
  end,
  gen_udp:close(Socket),
  Value.

