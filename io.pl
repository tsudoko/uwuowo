write_room(Room) :-
	size(Room, RW, RH),
	write("\x1b[1J"),
	write("\x1b[0;0f"),
	BRW is RW+1, BRH is RH+1,
	write_room(Room, BRW-BRH),
	nl, nl,
	true.

is_rect_border(RW-RH, X-Y) :- X = 0; Y = 0; X = RW; Y = RH.

write_room(Room, RW-RH) :- write_room(Room, RW-RH, 0-0), !.

write_room(_, RW-RH, RW-RH) :-
	write('#').
write_room(Room, RW-RH, RW-Y) :-
	NY is Y + 1,
	write('#'),
	nl,
	write_room(Room, RW-RH, 0-NY).
write_room(Room, RW-RH, X-Y) :- RealX is X-1, RealY is Y-1, location(Room-Ent, RealX-RealY),
	ascii_graphic(Ent, Graphic),
	put_char(Graphic),
	NX is X + 1,
	write_room(Room, RW-RH, NX-Y).
write_room(Room, RW-RH, X-Y) :- is_rect_border(RW-RH, X-Y),
	write('#'),
	NX is X + 1,
	write_room(Room, RW-RH, NX-Y).
write_room(Room, RW-RH, X-Y) :-
	write('.'),
	NX is X + 1,
	write_room(Room, RW-RH, NX-Y).
