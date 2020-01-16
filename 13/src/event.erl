-module(event).
-export([start/2,
         start_link/2,
         init/3,
         cancel/1]).

-record(state, {server,
                name="",
                to_go=0}).


%% インタフェース
start(EventName, Delay) ->
    spawn(?MODULE, init, [self(), EventName, Delay]).

start_link(EventName, Delay) ->
    spawn_link(?MODULE, init, [self(), EventName, Delay]).

cancel(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, cancel},
    receive
        {Ref, canceled} ->
            erlang:demonitor(Ref, [flush]),
            ok;
        {'DOWN', Ref, process, Pid, _Reason} ->
            ok
    end.

%% ---

init(Server, EventName, DateTime) ->
    loop(#state{server=Server,
                name=EventName,
                to_go=time_to_go(DateTime)}).

%% タイマー用ループ
%% to_goの入力はtime_normalize/1で分割されたリストとする
loop(S = #state{server=Server, to_go=[T|Next]}) ->
    receive
        {Server, Ref, cancel} ->
            Server ! {Ref, canceled}
    after
        T*1000 ->
            if
                Next =:= [] ->
                    Server ! {done, S#state.name};
                Next =/= [] ->
                    loop(S#state{to_go=Next})
            end
    end.


%% タイムアウト時間が約49日までしか受け付けられないので分割する
time_normalize(N) ->
    Limit = 49*24*60*60,
    [N rem Limit | lists:duplicate(N div Limit, Limit)].

%% {{年,月,日}, {時,分,秒}} 形式から正規化された秒数のリストに変換する
time_to_go(TimeOut={{_,_,_}, {_,_,_}}) ->
    Now = calendar:local_time(),
    ToGo = calendar:datetime_to_gregorian_seconds(TimeOut) -
        calendar:datetime_to_gregorian_seconds(Now),
    Secs = if ToGo > 0 -> ToGo;
              ToGo =< 0 -> 0
           end,
    time_normalize(Secs).
