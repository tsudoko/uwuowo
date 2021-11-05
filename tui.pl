get_key(K) :-
	get_single_char(KC),
	KC \= 27 -> K = [KC]; get_escape([27], K).

% FIXME: escape sequences are assumed to be 3 characters long, always
get_escape(L, E) :- length(L, 3), E = L, !.
get_escape(L, E) :-
	get_single_char(K),
	append(L, [K], NE),
	get_escape(NE, E).

run :-
	redraw,
	get_key(KList),
	string_chars(K, KList),
	run_keybind(K),
	!,
	run.
