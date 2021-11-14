% FIXME: escape sequences are assumed to be 3 characters long, always
get_escape(L, E) :- list_length(L, 3), E = L, !.
get_escape(L, E) :-
	get_single_char(K),
	list_concat(L, [K], NE),
	get_escape(NE, E).

get_key_(K) :-
	get_single_char(KC),
	KC \= 27 -> K = [KC]; get_escape([27], K).
