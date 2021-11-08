:- include("basedef.pl").

% ugly
room_full(Room) :-
	size(Room, W-H),
	MX is W-1, MY is H-1,
	room_full(Room, MX-MY), !.
room_full(Room, 0-0) :- location(Room-_, 0-0).
room_full(Room, 0-Y) :- location(Room-_, 0-Y),
	size(Room, W-_), MX is W-1,
	NY is Y-1,
	room_full(Room, MX-NY).
room_full(Room, X-Y) :- location(Room-_, X-Y),
	NX is X-1,
	room_full(Room, NX-Y).

put_ent(Room-Ent, random) :-
	size(Room, W-H),
	MX is W-1, MY is H-1,
	\+ room_full(Room),
	repeat,
	random_int(0, MX, X),
	random_int(0, MY, Y),
	empty_tile(Room, X-Y),
	!,
	assert(location(Room-Ent, X-Y)).
put_ent(Room-Ent, X-Y) :-
	\+ location(Room-Ent, X-Y),
	assert(location(Room-Ent, X-Y)).

max_generated_room(Y) :-
	bagof(X, size(gen-X, _), Xs),
	max_list(Xs, Y); Y = 0.

gen_room(Room) :- gen_room(false, false, Room).
gen_room(WithKey, WithExit, Room) :-
	max_generated_room(Max),
	X is Max+1,
	gen-X = Room,
	\+ size(Room, _-_),
	random_int(0, 20, W),
	random_int(0, 20, H),
	assert(size(Room, W-H)),
	(
		maybe,
		put_ent(Room-table, random)
		; true
	),!,
	(
		maybe,
		put_ent(Room-cat, random)
		; true
	),!,
	(
		WithKey,
		put_ent(Room-key, random)
		; true
	),!,
	(
		WithExit,
		put_ent(Room-(exit-closed), random)
		; true
	),!.
