-module(exceptions).
-compile(export_all).


throws(F) ->
    try F() of
        _ -> ok
    catch
        Throw -> {throw, caught, Throw}
    end.


errors(F) ->
    try F() of
        _ -> ok
    catch
        error:Error -> {error, caught, Error}
    end.


exits(F) ->
    try F() of
        _ -> ok
    catch
        exit:Exit -> {exit, caught, Exit}
    end.


trycatchs(E) when is_function(E, 0) ->
    try E() of
        _ -> "No exception."
    catch
        throw:pat_throw -> "exception thrown.";
        error:pat_error -> "error.";
        exit:pat_exit -> "exit!";
        _:_ -> "catch all."
    end.


many_line_try() ->
    try
        "line1",
        _line2 = "line2!",
        _line3 = [N*2 || N <- lists:seq(1,100)],
        %% throw(up),
        _WillReturnThis = "ret"
    of
        "ret" -> "returned!"

    catch
        Exception:Reason -> {caught, Exception, Reason}
    end.


many_line_try_without_of() ->
    try
        "line1",
        _line2 = "line2!",
        _line3 = [N*2 || N <- lists:seq(1,100)],
        %% throw(up),
        _WillReturnThis = "retruned!"
    catch
        Exception:Reason -> {caught, Exception, Reason}
    end.


my_div(X,Y) ->
    case catch X/Y of
        {'EXIT', {badarith,_}} -> "arithmetic exception!";
        N -> N
    end.


one_or_two(1) -> return;
one_or_two(2) -> throw(return).
