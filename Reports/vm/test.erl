%%%-------------------------------------------------------------------
%%% @author steveedmans
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Sep 2015 12:01
%%%-------------------------------------------------------------------
-module(test).
-author("steveedmans").

%% API
-export([setup_branch/0]).

setup_branch() ->
  registers:init(),
  registers:set_register(1, 0),
  registers:set_register(2, -1),
  registers:set_register(3, 1),
  registers:set_register(4, 202),
  registers:set_register(5, utilities:minus_one()).
