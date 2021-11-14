% requires shell/1 and stty, ugly
:- initialization(shell('stty -g > /tmp/_get_single_char_stty')).

% FIXME: escape sequences are assumed to be 3 characters long, always
get_escape(L, E) :- list_length(L, 3), E = L, !.
get_escape(L, E) :-
	get_code(K),
	list_concat(L, [K], NE),
	get_escape(NE, E).

get_key_(K) :-
	shell('stty raw -echo'),
	(get_code(KC), KC \= 27 -> K = [KC]; get_escape([27], K); true),
	shell('stty `cat /tmp/_get_single_char_stty`').
