key_chars(C, [C]) :- C =< 255.
key_chars(321, "\x1b\[A").
key_chars(322, "\x1b\[B").
key_chars(323, "\x1b\[C").
key_chars(324, "\x1b\[D").

get_key_(C) :-
	get_key_no_echo(K),
	key_chars(K, C).
