-module(run).
-author("hypothermic").

-export([
	do_years/1
]).

-define(START_YEAR, 2021).
-define(END_YEAR, 2022).
-define(START_DAY, 1).
-define(END_DAY, 25).

-spec do_years({
		Mode :: atom(),
		Year :: pos_integer() | all,
		Day :: pos_integer() | all
	}) -> ok.
do_years({Mode, Year, Day}) ->
	case Year of
		all ->
			iter_years({Mode, ?END_YEAR, Day});
		_ ->
			do_days({Mode, Year, Day})
	end.

iter_years({_, ?START_YEAR-1, _}) ->
	ok;
iter_years({Mode, Year, Day} = Settings) ->
	do_days(Settings),
	iter_years({Mode, Year-1, Day}).

do_days({Mode, Year, Day} = Settings) ->
	case Day of
		all ->
			iter_days({Mode, Year, ?END_DAY});
		_ ->
			module:exec_day(Settings)
	end.

iter_days({_, _, ?START_DAY-1}) ->
	ok;

iter_days({Mode, Year, Day} = Settings) ->
	module:exec_day(Settings),
	iter_days({Mode, Year, Day-1}).
