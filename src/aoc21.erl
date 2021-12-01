-module(aoc21).
-author("hypothermic").

-export([
    main/1
]).

load_day(0) ->
    ok;

load_day(Day) ->
    Path = "day" ++ integer_to_list(Day),

    case code:load_file(list_to_atom(Path)) of
        {module, Module} ->
            {ok, Data} = file:read_file(Path ++ ".txt"),

            Input = lists:filtermap(fun (Binary) ->
                case byte_size(Binary) of
                    0 -> false;
                    _ -> {true, list_to_integer(binary_to_list(Binary))}
                end
            end, binary:split(Data, [<<"\n">>], [global])),

            io:format("Day ~B part 1 answer: ~B, part 2 answer: ~B\n", [
                Day,
                Module:first(Input),
                Module:second(Input)
            ]);
        _ -> ok
    end,

    load_day(Day-1).

%% escript Entry point
main(_Args) ->
    ok = load_day(21),

    erlang:halt(0).
