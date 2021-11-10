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

gen_room_id(ID) :-
	(bagof(X, room(gen-X, _), Xs), max_list(Xs, Y); Y = 0),
	NY is Y + 1,
	ID = gen-NY.

gen_room(Room) :-
	list_random_choice([
		gen_empty_room,
		gen_btree_room,
		gen_btree_maze
	], Generator),
	Gen =.. [Generator, Room],
	call(Gen).

gen_empty_room(Room) :-
	gen_room_id(Room), % TODO: allow setting name with var/1?
	\+ room(Room, _-_),
	random_int(1, 21, W),
	random_int(1, 21, H),
	assert(room(Room, W-H)).

gen_btree_maze(Room) :-
	gen_btree_maze_(Room, tile).

gen_btree_room(Room) :-
	list_random_choice([column, row], RandomUnit),
	gen_btree_maze_(Room, RandomUnit).

gen_btree_maze_(Room, RandomUnit) :-
	gen_room_id(Room), % TODO: allow setting name with var/1?
	\+ room(Room, _-_),
	random_int(1, 10, W),
	random_int(1, 10, H),
	random_int(0, 16'ffffffffffffffff, Seed),
	assert(btree_maze(Room, W-H, RandomUnit, Seed)).
