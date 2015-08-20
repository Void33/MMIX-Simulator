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
  get_octabyte/1,
  get_nstring/1,
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

get_octabyte(Location) ->
  gen_server:call(?MEMORY_SERVER, {get_octabyte, Location}).

get_nstring(Location) ->
  gen_server:call(?MEMORY_SERVER, {get_nstring, Location}).

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
handle_call({get_nstring, Location}, _From, TableId) ->
  {reply, get_memory_location_nstring(Location, TableId), TableId};
handle_call(stop_program, _From, _TableId) ->
  {stop, normal};
handle_call(get_contents, _From, TableId) ->
  erlang:display(contents(TableId));
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
  [{Location, Value}] = ets:lookup(TableId, Location),
  Value.

get_memory_location_nstring(Location, TableId) ->
  get_memory_location_nstring(Location, TableId, []).

get_memory_location_nstring(Location, TableId, Accumulator) ->
  CurrentByte = get_memory_location_byte(Location, TableId),
  case CurrentByte of
    0 -> lists:reverse(Accumulator);
    _ -> get_memory_location_nstring((Location + 1), TableId, [CurrentByte | Accumulator])
  end.