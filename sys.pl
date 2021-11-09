:- include("basedef.pl").

sight_range(Ent, 8) :- inventory(Ent, Inv), member(lamp, Inv).
sight_range(_, 2.5).

is_visible(X-Y) :-
	location(_-self, SX-SY),
	sight_range(self, SR),
	in_circle(SX-SY, SR, X-Y).

toplevel_ent(X) :-
	\+ solid(X),
	\+ item(X),
	\+ floor(X).

visible_location(Room-Ent, X-Y) :-
	(
		(room(Room, RW-RH), (X = -1; Y = -1; X is RW; Y is RH), Ent = wall);
		(\+ is_visible(X-Y), Ent = darkness);
		(location(Room-Ent, X-Y), toplevel_ent(Ent));
		(location(Room-Ent, X-Y), item(Ent));
		(location(Room-Ent, X-Y), solid(Ent));
		(location(Room-Ent, X-Y), floor(Ent));
		location(Room-Ent, X-Y)
	);
	Ent = floor.

inventory(_, []).
inventory_add(Ent, Item) :-
	once(inventory(Ent, Items)),
	retract(inventory(Ent, Items)),
	assert(inventory(Ent, [Item|Items])).
inventory_del(Ent, Item) :-
	once(inventory(Ent, Items)),
	list_del_one(Item, Items, NewItems),
	retract(inventory(Ent, Items)),
	assert(inventory(Ent, NewItems)).

% FIXME: doesn't work with more generalized queries like (someroom, X-Y), needs clpfd and probably something else than \+
empty_tile(Room, X-Y) :-
	room(Room, RX1-RY1),
	\+ (location(Room-Ent, X-Y), solid(Ent)),
	X >= 0, Y >= 0, X < RX1, Y < RY1.

teleport(Ent, X-Y) :-
	Room-_ = Ent,
	empty_tile(Room, X-Y),
	retract(location(Ent, _-_)),
	assert(location(Ent, X-Y)).

rel_direction_to(EX-EY, TX-TY, OutX-OutY) :-
	OutX is floor(-sign(EX-TX)),
	OutY is floor(-sign(EY-TY)).

act_open(Room-Ent, Direction) :-
	location(Room-Ent, EntXY),
	pair_add(EntXY, Direction, TargetXY),
	location(Room-(exit-closed), TargetXY),
	(inventory_del(Ent, key); assert(status_msg("You need a key to open this door")), false),
	retract(location(Room-(exit-closed), TargetXY)),
	assert(location(Room-(exit-open), TargetXY)).

act_get(Room-Ent, Direction) :-
	location(Room-Ent, EntXY),
	pair_add(EntXY, Direction, TargetXY),
	once((location(Room-Target, TargetXY), item(Target))),
	on_get(Room-Target),
	inventory_add(Ent, Target),
	retract(location(Room-Target, TargetXY)).

opposite_dir_(up, down).
opposite_dir_(left, right).
opposite_dir(X, Y) :- opposite_dir_(X, Y); opposite_dir_(Y, X).
room_leave(Room-Ent, SourceDir) :-
	location(Room-(stairs-SourceDir-TargetRoom), X-Y),
	location(Room-Ent, X-Y),
	opposite_dir(SourceDir, TargetDir),
	location(TargetRoom-(stairs-TargetDir-Room), TargetXY),
	retract(location(Room-Ent, _)),
	assert(location(TargetRoom-Ent, TargetXY)).
room_leave(Room-Ent, _) :-
	location(Room-(exit-open), X-Y),
	location(Room-Ent, X-Y),
	abort.

act_move(Room-Ent, Direction) :-
	location(Room-Ent, EntXY),
	pair_add(EntXY, Direction, MoveXY),
	teleport(Room-Ent, MoveXY).

move_towards(Room-Ent, Room-Target) :-
	location(Room-Ent, EntXY),
	location(Room-Target, TargetXY),
	rel_direction_to(EntXY, TargetXY, Direction),
	act_move(Room-Ent, Direction).

move_up(Ent) :-
	location(Ent, X-Y),
	NewX is X+1,
	teleport(Ent, NewX-Y).

move_down(Ent) :-
	location(Ent, X-Y),
	NewX is X-1,
	teleport(Ent, NewX-Y).

move_left(Ent) :-
	location(Ent, X-Y),
	NewY is Y-1,
	teleport(Ent, X-NewY).

move_right(Ent) :-
	location(Ent, X-Y),
	NewY is Y+1,
	teleport(Ent, X-NewY).
