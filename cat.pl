:- include("basedef.pl").

turn_pass(Room-cat) :- maybe,
	location(Room-cat, _-_),
	random_int(-1, 2, DX),
	random_int(-1, 2, DY),
	act_move(Room-cat, DX-DY).
turn_pass(_-cat).
