-module(recursive).
-export([fac/1,
         fac_ptn/1,
         len/1,
         duplicate/2,
         reverse/1,
         sublist/2,
         zip/2,
         quicksort/1
        ]).

%% fac
fac(N) when N == 0 -> 1;
fac(N) when N > 0 -> N*fac(N-1).

fac_ptn(0) -> 1;
fac_ptn(N) when N > 0 -> N*fac(N-1).

%% len
len([]) -> 0;
len([_|T]) -> 1 + len(T).

%% duplicate
duplicate(0, _) ->
    [];
duplicate(N, Term) when N > 0 ->
    [Term|duplicate(N-1, Term)].

%% reverse
reverse([]) -> [];
reverse([H|T]) -> reverse(T)++[H].

%% sublist
sublist(_, 0) -> [];
sublist([], _) -> [];
sublist([H|T], N) when N > 0 ->
    [H|sublist(T, N-1)].

%% zip
zip(_,[]) -> [];
zip([],_) -> [];
zip([X|Y],[P|Q]) -> [{X, P}|zip(Y, Q)].

%% quick sort
partition(_, [], Smaller, Larger) -> {Smaller, Larger};
partition(Pivot, [H|T], Smaller, Larger) ->
    if H =< Pivot -> partition(Pivot, T, [H|Smaller], Larger);
       H > Pivot -> partition(Pivot, T, Smaller, [H|Larger])
    end.

quicksort([]) -> [];
quicksort([Pivot|Rest]) ->
    {Smaller, Larger} = partition(Pivot, Rest, [], []),
    quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).
