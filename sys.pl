:- include("basedef.pl").

sight_range(Ent, 8) :- inventory(Ent, Inv), member(lamp, Inv).
sight_range(_, 2.5).

inventory(_, []).
inventory_add(Ent, Item) :-
	once(inventory(Ent, Items)),
	retract(inventory(Ent, Items)),
	assert(inventory(Ent, [Item|Items])).

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
	inventory(Ent, Inv),
	memberchk(key, Inv),
	retract(location(Room-(exit-closed), TargetXY)),
	assert(location(Room-(exit-open), TargetXY)).

act_get(Room-Ent, Direction) :-
	location(Room-Ent, EntXY),
	pair_add(EntXY, Direction, TargetXY),
	once((location(Room-Target, TargetXY), item(Target))),
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
