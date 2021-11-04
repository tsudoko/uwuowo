redraw :-
	write("\x1b[1J"),
	write("\x1b[0;0f"),
	location(Room-self, _),
	write_room(Room),
	nl, nl.

write_room(Room) :-
	size(Room, RW, RH),
	BRW is RW+1, BRH is RH+1,
	write_room(Room, BRW-BRH).

is_rect_border(RW-RH, X-Y) :- X = 0; Y = 0; X = RW; Y = RH.

write_room(Room, RW-RH) :- write_room(Room, RW-RH, 0-0), !.

write_room(_, RW-RH, RW-RH) :-
	tile(wall, T), put_char(T).
write_room(Room, RW-RH, RW-Y) :-
	NY is Y + 1,
	tile(wall, T), put_char(T),
	nl,
	write_room(Room, RW-RH, 0-NY).
write_room(Room, RW-RH, X-Y) :- RealX is X-1, RealY is Y-1, item_location(Room-Ent, RealX-RealY),
	tile(Ent, T), put_char(T),
	NX is X + 1,
	write_room(Room, RW-RH, NX-Y).
write_room(Room, RW-RH, X-Y) :- RealX is X-1, RealY is Y-1, location(Room-Ent, RealX-RealY),
	tile(Ent, T), put_char(T),
	NX is X + 1,
	write_room(Room, RW-RH, NX-Y).
write_room(Room, RW-RH, X-Y) :- is_rect_border(RW-RH, X-Y),
	tile(wall, T), put_char(T),
	NX is X + 1,
	write_room(Room, RW-RH, NX-Y).
write_room(Room, RW-RH, X-Y) :-
	tile(floor, T), put_char(T),
	NX is X + 1,
	write_room(Room, RW-RH, NX-Y).
