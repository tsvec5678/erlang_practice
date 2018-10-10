%%%-------------------------------------------------------------------
%% @doc erl_prac public API
%% @end
%%%-------------------------------------------------------------------

-module(erl_prac_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    erl_prac_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================