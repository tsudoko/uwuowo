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
	(floor(Ent) -> \+ (location(Room-REnt, X-Y), floor(REnt)); true),
	!,
	assert(location(Room-Ent, X-Y)).
put_ent(Room-Ent, X-Y) :-
	\+ location(Room-Ent, X-Y),
	assert(location(Room-Ent, X-Y)).

gen_room_id(ID) :-
	(bagof(X, room(gen-X, _), Xs), max_list(Xs, Y); Y = 0),
	NY is Y + 1,
	ID = gen-NY.

gen_rooms(InitRoom) :-
	gen_room(InitRoom),
	gen_rooms_(InitRoom, 100),
	all_rooms(InitRoom, AllRooms),
	[InitRoom|Rooms] = AllRooms,
	location(ExitRoom-(exit-closed), _),
	list_del_one(Rooms, ExitRoom, RoomsWithoutExit),
	% unique items, should appear exactly once in the entire tree
	list_random_choice(RoomsWithoutExit, KeyRoom), put_ent(KeyRoom-key, random),
	list_random_choice(Rooms, LampRoom), put_ent(LampRoom-lamp, random).

all_rooms(Root, Rooms) :- all_rooms([Root], [], Rooms).
all_rooms([], Rooms, Rooms).
all_rooms([Root|Rest], Acc, Rooms) :-
	findall(Child, location(Root-(_-down-Child), _), Children),
	all_rooms(Children, [], ChildRooms),
	list_concat(ChildRooms, Acc, NewRooms),
	all_rooms(Rest, [Root|NewRooms], Rooms).

gen_rooms_(Parent, Progress) :- Progress > 0,
	gen_room(Room),
	put_ent(Parent-(stairs-down-Room), random),
	put_ent(Room-(stairs-up-Parent), random),
	random_int(0, 50, DP),
	NProgress is Progress - DP,
	(random_int(0, 7, GenMore), GenMore = 0 -> gen_rooms_(Parent, Progress); true),
	(random_int(0, 5, GenCat), GenCat = 0 -> put_ent(Room-cat, random); true),
	(
		\+ btree_maze(Room, _, _, _),
		\+ room(Room, 1-_),
		\+ room(Room, _-1),
		maybe ->
			put_ent(Room-table, random); true),
	gen_rooms_(Room, NProgress).
gen_rooms_(Room, _) :-
	\+ location(_-(exit-closed), _) -> put_ent(Room-(exit-closed), random); true.

gen_room(Room) :-
	list_random_choice([
		gen_empty_room,
		gen_empty_room,
		gen_empty_room,
		gen_btree_room,
		gen_btree_room,
		gen_btree_maze
	], Generator),
	Gen =.. [Generator, Room],
	call(Gen).

gen_empty_room(Room) :-
	(var(Room) -> gen_room_id(Room); true),
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
	(var(Room) -> gen_room_id(Room); true),
	\+ room(Room, _-_),
	random_int(1, 10, W),
	random_int(1, 10, H),
	random_int(0, 0xffff, Seed),
	assert(btree_maze(Room, W-H, RandomUnit, Seed)).
