%%% File    : memory.erl
%%% Description : API and gen_server code to simulate the memory for our virtual machine
-module(memory).
-author("Steve Edmans").

-behaviour(gen_server).

-include("memory.hrl").
-define(MEMORY_TABLE, memory_table).
-define(MEMORY_SERVER, memory_server).

%% API
-export([start_link/0,
  stop/0,
  store_program/1,
  get_byte/1,
  get_wyde/1,
  get_tetrabyte/1,
  get_octabyte/1,
  get_nstring/1,
  set_byte/2,
  set_wyde/2,
  set_tetrabyte/2,
  set_octabyte/2,
  contents/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?MEMORY_SERVER}, ?MODULE, [], []).

%%--------------------------------------------------------------------
%% @doc
%% Store a new program in memory
%%
%% @end
%%--------------------------------------------------------------------
store_program([]) ->
  erlang:display("STORED PROGRAM");
store_program([{StartLocation, Program}|Rest]) ->
  gen_server:call(?MEMORY_SERVER, {store_program, Program, StartLocation}),
  store_program(Rest).

stop() ->
  gen_server:call(?MEMORY_SERVER, stop_program).

contents() ->
  gen_server:call(?MEMORY_SERVER, get_contents).

get_byte(Location) ->
  gen_server:call(?MEMORY_SERVER, {get_byte, Location}).

get_wyde(Location) ->
  gen_server:call(?MEMORY_SERVER, {get_wyde, Location}).

get_tetrabyte(Location) ->
  gen_server:call(?MEMORY_SERVER, {get_tetrabyte, Location}).

get_octabyte(Location) ->
  gen_server:call(?MEMORY_SERVER, {get_octabyte, Location}).

get_nstring(Location) ->
  gen_server:call(?MEMORY_SERVER, {get_nstring, Location}).

set_byte(Location, Value) ->
  gen_server:call(?MEMORY_SERVER, {set_byte, Location, Value}).

set_wyde(Location, Value) ->
  gen_server:call(?MEMORY_SERVER, {set_wyde, Location, Value}).

set_tetrabyte(Location, Value) ->
  gen_server:call(?MEMORY_SERVER, {set_tetrabyte, Location, Value}).

set_octabyte(Location, Value) ->
  gen_server:call(?MEMORY_SERVER, {set_octabyte, Location, Value}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, State :: term()} | {ok, State :: term(), timeout() | hibernate} |
  {stop, Reason :: term()} | ignore).
init([]) ->
  TableId = ets:new(?MEMORY_TABLE, [set, public]),
  {ok, TableId}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: term()) ->
  {reply, Reply :: term(), NewState :: term()} |
  {reply, Reply :: term(), NewState :: term(), timeout() | hibernate} |
  {noreply, NewState :: term()} |
  {noreply, NewState :: term(), timeout() | hibernate} |
  {stop, Reason :: term(), Reply :: term(), NewState :: term()} |
  {stop, Reason :: term(), NewState :: term()}).
handle_call(reset_memory, _From, TableId) ->
  clear_memory(TableId);
handle_call({store_program, Program, StartLocation}, _From, TableId) ->
  store_program(Program, StartLocation, TableId),
  {reply, ok, TableId};
handle_call({get_byte, Location}, _From, TableId) ->
  {reply, get_memory_location_byte(Location, TableId), TableId};
handle_call({get_wyde, Location}, _From, TableId) ->
  {reply, get_memory_location_wyde(Location, TableId), TableId};
handle_call({get_tetrabyte, Location}, _From, TableId) ->
  {reply, get_memory_location_tetrabyte(Location, TableId), TableId};
handle_call({get_octabyte, Location}, _From, TableId) ->
  {reply, get_memory_location_octabyte(Location, TableId), TableId};
handle_call({get_nstring, Location}, _From, TableId) ->
  {reply, get_memory_location_nstring(Location, TableId), TableId};
handle_call({set_byte, Location, Value}, _From, TableId) ->
  {reply, [set_byte(Location, Value, TableId)], TableId};
handle_call({set_wyde, Location, Value}, _From, TableId) ->
  {reply, set_wyde(Location, Value, TableId), TableId};
handle_call({set_octabyte, Location, Value}, _From, TableId) ->
  {reply, set_octabyte(Location, Value, TableId), TableId};
handle_call(stop_program, _From, _TableId) ->
  {stop, normal};
handle_call(get_contents, _From, TableId) ->
  erlang:display(contents(TableId)),
  {reply, ok, TableId};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: term()) ->
  {noreply, NewState :: term()} |
  {noreply, NewState :: term(), timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: term()}).
handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: term()) ->
  {noreply, NewState :: term()} |
  {noreply, NewState :: term(), timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: term()}).
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: term()) -> term()).
terminate(_Reason, _State) ->
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: term(),
    Extra :: term()) ->
  {ok, NewState :: term()} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

contents(TableId) ->
  erlang:display("Contents"),
  ets:tab2list(TableId).

clear_memory(TableId) ->
  erlang:display("Clear Memory"),
  ets:delete_all_objects(TableId).

store_program([], _Location, State) ->
  {ok, State};
store_program([Entry|Rest], Location, TableId) ->
  ets:insert(TableId, {Location, Entry}),
  store_program(Rest, (Location + 1), TableId).

get_memory_location_byte(Location, TableId) ->
  case ets:lookup(TableId, Location) of
    [{_, Byte}] -> Byte;
    _ -> 0
  end.

get_memory_location_wyde(Location, TableId) ->
  AdjustedLocation = utilities:adjust_location(Location, 2),
  Byte0 = case ets:lookup(TableId, AdjustedLocation) of
            [{_, B0}] -> B0;
            _ -> 0
          end,
  Byte1 = case ets:lookup(TableId, AdjustedLocation + 1) of
            [{_, B1}] -> B1;
            _ -> 0
          end,
  Value = (Byte0 * 256) + Byte1,
  Value.

get_memory_location_tetrabyte(Location, TableId) ->
  AdjustedLocation = utilities:adjust_location(Location, 4),
  Byte0 = case ets:lookup(TableId, AdjustedLocation) of
            [{_, B0}] -> B0;
            _ -> 0
          end,
  Byte1 = case ets:lookup(TableId, AdjustedLocation + 1) of
            [{_, B1}] -> B1;
            _ -> 0
          end,
  Byte2 = case ets:lookup(TableId, AdjustedLocation + 2) of
            [{_, B2}] -> B2;
            _ -> 0
          end,
  Byte3 = case ets:lookup(TableId, AdjustedLocation + 3) of
            [{_, B3}] -> B3;
            _ -> 0
          end,
  Value = (((((Byte0 * 256) + Byte1) * 256) + Byte2) * 256) + Byte3,
  Value.

get_memory_location_octabyte(Location, TableId) ->
  AdjustedLocation = utilities:adjust_location(Location, 8),
  Byte0 = case ets:lookup(TableId, AdjustedLocation) of
            [{_, B0}] -> B0;
            _ -> 0
          end,
  Byte1 = case ets:lookup(TableId, AdjustedLocation + 1) of
            [{_, B1}] -> B1;
            _ -> 0
          end,
  Byte2 = case ets:lookup(TableId, AdjustedLocation + 2) of
            [{_, B2}] -> B2;
            _ -> 0
          end,
  Byte3 = case ets:lookup(TableId, AdjustedLocation + 3) of
            [{_, B3}] -> B3;
            _ -> 0
          end,
  Byte4 = case ets:lookup(TableId, AdjustedLocation) of
            [{_, B4}] -> B4;
            _ -> 0
          end,
  Byte5 = case ets:lookup(TableId, AdjustedLocation + 1) of
            [{_, B5}] -> B5;
            _ -> 0
          end,
  Byte6 = case ets:lookup(TableId, AdjustedLocation + 2) of
            [{_, B6}] -> B6;
            _ -> 0
          end,
  Byte7 = case ets:lookup(TableId, AdjustedLocation + 3) of
            [{_, B7}] -> B7;
            _ -> 0
          end,
  Value = (((((((((((((Byte0 * 256) + Byte1) * 256) + Byte2) * 256) + Byte3) * 256) + Byte4) * 256) + Byte5) * 256) + Byte6) * 256) + Byte7,
  Value.

get_memory_location_nstring(Location, TableId) ->
  get_memory_location_nstring(Location, TableId, []).

get_memory_location_nstring(Location, TableId, Accumulator) ->
  CurrentByte = get_memory_location_byte(Location, TableId),
  case CurrentByte of
    0 -> lists:reverse(Accumulator);
    _ -> get_memory_location_nstring((Location + 1), TableId, [CurrentByte | Accumulator])
  end.

set_byte(Location, Value, TableId) ->
  io:format("Set the memory location ~w in the table to ~w~n", [Location, Value]),
  ets:insert(TableId, {Location, Value}),
  {Location, Value}.

set_wyde(Location, Value, TableId) ->
  Adjusted_Location = utilities:adjust_location(Location, 2),
  B0 = utilities:get_0_byte(Value),
  B1 = utilities:get_1_byte(Value),
  C0 = set_byte(Adjusted_Location, B1, TableId),
  C1 = set_byte((Adjusted_Location + 1), B0, TableId),
  [C0, C1].

set_octabyte(Location, Value, TableId) ->
  Adjusted_Location = utilities:adjust_location(Location, 8),
  B0 = utilities:get_0_byte(Value),
  B1 = utilities:get_1_byte(Value),
  B2 = utilities:get_2_byte(Value),
  B3 = utilities:get_3_byte(Value),
  B4 = utilities:get_4_byte(Value),
  B5 = utilities:get_5_byte(Value),
  B6 = utilities:get_6_byte(Value),
  B7 = utilities:get_7_byte(Value),
  C0 = set_byte(Adjusted_Location, B7, TableId),
  C1 = set_byte((Adjusted_Location + 1), B6, TableId),
  C2 = set_byte((Adjusted_Location + 2), B5, TableId),
  C3 = set_byte((Adjusted_Location + 3), B4, TableId),
  C4 = set_byte((Adjusted_Location + 4), B3, TableId),
  C5 = set_byte((Adjusted_Location + 5), B2, TableId),
  C6 = set_byte((Adjusted_Location + 6), B1, TableId),
  C7 = set_byte((Adjusted_Location + 7), B0, TableId),
  [C0, C1, C2, C3, C4, C5, C6, C7].
