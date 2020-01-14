-module(linkmon).
-compile(export_all).

myproc() ->
    io:format("proc: ~p~n", [self()]),
    timer:sleep(5000),
    exit(reason).


chain(0) ->
    receive
        _ -> ok
    after 2000 ->
        exit("chain dies here")
    end;

chain(N) ->
    Pid = spawn(fun() -> chain(N-1) end),
    io:format("spawn: ~p~n", [Pid]),
    link(Pid),
    receive
        _ -> ok
    end.
