-module(ptn).

-export([same/2, valid_time/1, drivable_age/1]).

same(X, X) ->
    true;
same(_, _) ->
    false.

valid_time({Date = {Y,M,D}, Time = {H,Min,S}}) ->
    io:format("correct data.~n"),
    io:format("date ~p => ~p/~p/~p~n", [Date, Y, M, D]),
    io:format("time ~p => ~p:~p:~p~n", [Time, H, Min, S]);
valid_time(_) ->
    io:format("wrong data.~n").

drivable_age(X) when X >= 18, X =< 80 ->
    true;
drivable_age(_) ->
    false.
