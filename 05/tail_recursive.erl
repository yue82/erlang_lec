-module(tail_recursive).
-export([fac/1,
         len/1,
         duplicate/2,
         reverse/1,
         sublist/2,
         zip/2
        ]).

%% fac
fac(0, A) -> A;
fac(N, A) when N > 0 -> fac(N-1, A*N).

fac(N) -> fac(N, 1).

%% len
len([], N) -> N;
len([_|T], N) -> len(T, N+1).

len(L) -> len(L, 0).

%% duplicate
duplicate(0, _, List) ->
    List;
duplicate(N, Term, List) when N > 0 ->
    duplicate(N-1, Term, [Term | List]).

duplicate(N, Term) -> duplicate(N, Term, []).

%% reverse
reverse([], X) -> X;
reverse([H|T], X) -> reverse(T, [H|X]).

reverse(L) -> reverse(L, []).

%% sublist
sublist(_, 0, S) -> S;
sublist([], _, S) -> S;
sublist([H|T], N, S) when N > 0 ->
    sublist(T, N-1, [H|S]).

sublist(L, N) -> reverse(sublist(L, N, [])).

%% zip
zip(_,[], Z) -> Z;
zip([],_, Z) -> Z;
zip([X|Y],[P|Q], Z) -> zip(Y, Q, [{X, P}|Z]).

zip(X, P) -> reverse(zip(X, P, [])).

%% quick sort
