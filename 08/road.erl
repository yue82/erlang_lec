-module(road).
-export([main/1]).


main([FileName]) ->
    {ok, Bin} = file:read_file(FileName),
    OptimalPath = optimal_path(group_vals(parse_map(Bin), [])),
    io:format("~p~n", [OptimalPath]),
    erlang:halt(0).

%% バイナリを読み取ってリストにする
parse_map(Bin) when is_binary(Bin) ->
    parse_map(binary_to_list(Bin));
parse_map(Str) when is_list(Str) ->
    [list_to_integer(X) || X <- string:tokens(Str,"\r\n\t ")].

%% 3つの数字毎にタプルにする
%% {A側の道の距離、B側の道の距離、その間を渡るXの道の距離}
group_vals([], Acc) ->
    lists:reverse(Acc);
group_vals([A, B, X|Rest], Acc) ->
    group_vals(Rest, [{A, B, X} | Acc]).

%% Xの道毎に、A側の角とB側の角のそれぞれに到達するための最小経路を求める
%% 1本の道はタプル {通る道, 距離} で表す (ex. {a, A})
%% 経路の選択肢は {距離, 経路} で表す。min()で距離の小さいものを選ぶために距離を先にする。
shortest_step({A, B, X}, {{DistA, PathA}, {DistB, PathB}}) ->
    AtoA = {DistA + A, [{a, A}|PathA]},
    BtoA = {DistB + B + X, [{x, X}, {b, B}|PathB]},
    AtoB = {DistA + A + X, [{x, X}, {a, A}|PathA]},
    BtoB = {DistB + B, [{b, B}|PathB]},
    {erlang:min(AtoA, BtoA), erlang:min(AtoB, BtoB)}.

%% 全体を通して最小の経路を求める
%% 最後に求められたA, Bはどちらも同じ距離になっている(最後のXの道が距離0なので)
%% 回答に最後のXの道({x, 0})は余分なので、それが含まれていない方を答える
optimal_path(Map) ->
    {A, B} = lists:foldl(fun shortest_step/2, {{0, []}, {0, []}}, Map),
    {_Dist, Path} = if hd(element(2,A)) =/= {x, 0} -> A;
                       hd(element(2,B)) =/= {x, 0} -> B
                    end,
    lists:reverse(Path).
