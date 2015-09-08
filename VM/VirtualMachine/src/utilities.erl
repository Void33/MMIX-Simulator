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
-export([signed_integer16/1]).

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
  FV = io_lib:format("~16.16.0B", [V]),
  FV1 = lists:flatten(FV),
  hex2int(FV1).
