-module(tree_search).
-compile(export_all).


%% depth-first search
has_value(_, {node, 'nil'}) ->
    false;
has_value(Val, {node, {_, Val, _, _}}) ->
    true;
has_value(Val, {node, {_, _, Left, Right}}) ->
    case has_value(Val, Left) of
        true -> true;
        false -> has_value(Val, Right)
    end.


has_value_try(Val, Tree) ->
    try has_value_try(Val, Tree) of
        false -> false
    catch
        true -> true
    end.
has_value_try1(_, {node, 'nil'}) ->
    false;
has_value_try1(Val, {node, {_, Val, _, _}}) ->
    throw(true);
has_value_try1(Val, {node, {_, _, Left, Right}}) ->
    has_value_try(Val, Left),
    has_value_try(Val, Right).
