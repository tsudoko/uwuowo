:- include("basedef.pl").

on_get(_-cat) :-
	assertz(status_msg("m-meow?")).

turn_pass(Room-cat) :- maybe,
	location(Room-cat, _-_),
	random_int(-1, 2, DX),
	random_int(-1, 2, DY),
	act_move(Room-cat, DX-DY).
turn_pass(_-cat).
