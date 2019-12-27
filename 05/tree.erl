-module(tree).
-export([empty/0, insert/3, lookup/2]).

%% tree = {node, {Key, Value, Smaller, Larger}}
%% empty(p)
%% insert(Key, Val, Tree)
%% lookup(Key, Tree)

empty() -> {node, "nil"}.

insert(NewKey, NewVal, {node, "nil"}) -> {node, {NewKey, NewVal, {node, "nil"}, {node, "nil"}}};
insert(NewKey, NewVal, {node, {Key, Value, Smaller, Larger}}) when NewKey < Key ->
    {node, {Key, Value, insert(NewKey, NewVal, Smaller), Larger}};
insert(NewKey, NewVal, {node, {Key, Value, Smaller, Larger}}) when NewKey > Key ->
    {node, {Key, Value, Smaller, insert(NewKey, NewVal, Larger)}};
insert(NewKey, NewVal, {node, {NewKey, _, Smaller, Larger}}) ->
    {node, {NewKey, NewVal, Smaller, Larger}}.

lookup(_, {node, "nil"}) -> undefined;
lookup(SearchKey, {node, {Key, _, Smaller, _}}) when SearchKey < Key -> lookup(SearchKey, Smaller);
lookup(SearchKey, {node, {Key, _, _, Larger}}) when SearchKey > Key -> lookup(SearchKey, Larger);
lookup(SearchKey, {node, {SearchKey, Value, _, _}}) -> {ok, Value}.
