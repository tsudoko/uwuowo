:- include("basedef.pl").

% ugly
room_full(Room) :-
	room(Room, W-H),
	MX is W-1, MY is H-1,
	room_full(Room, MX-MY), !.
room_full(Room, 0-0) :- location(Room-_, 0-0).
room_full(Room, 0-Y) :- location(Room-_, 0-Y),
	room(Room, W-_), MX is W-1,
	NY is Y-1,
	room_full(Room, MX-NY).
room_full(Room, X-Y) :- location(Room-_, X-Y),
	NX is X-1,
	room_full(Room, NX-Y).

put_ent(Room-Ent, random) :-
	room(Room, W-H),
	\+ room_full(Room),
	repeat,
	random_int(0, W, X),
	random_int(0, H, Y),
	empty_tile(Room, X-Y),
	!,
	assert(location(Room-Ent, X-Y)).
put_ent(Room-Ent, X-Y) :-
	\+ location(Room-Ent, X-Y),
	assert(location(Room-Ent, X-Y)).

max_generated_room(Y) :-
	bagof(X, room(gen-X, _), Xs),
	max_list(Xs, Y); Y = 0.

gen_room(Room) :- gen_room(false, false, Room).
gen_room(WithKey, WithExit, Room) :-
	max_generated_room(Max),
	X is Max+1,
	gen-X = Room,
	\+ room(Room, _-_),
	random_int(1, 21, W),
	random_int(1, 21, H),
	assert(room(Room, W-H)),
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
