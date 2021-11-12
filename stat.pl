% TODO: add human-readable non-exact descriptions of stats (as a list of words probably)

% stat(Ent, Stat, N)

add_stat(X, Stat, N) :-
	stat(X, Stat, OldN),
	retract(stat(X, Stat, OldN)),
	NewN is OldN + N,
	assertz(stat(X, Stat, NewN)).

sub_stat(X, Stat, N) :-
	stat(X, Stat, OldN),
	retract(stat(X, Stat, OldN)),
	NewN is OldN - N,
	assertz(stat(X, Stat, NewN)).
