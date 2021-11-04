write_room(Room) :-
	size(Room, RW, RH),
	write("\x1b[0;0f"),
	BRW is RW+1, BRH is RH+1,
	write_rect(BRW-BRH),
	(
		location(Room-Ent, EX-EY),
		BEX is EX+2, BEY is EY+2,
		write_entity(Ent, BEX-BEY),
		fail;
		true
	),
	Bottom is BRH+1,
	write("\x1b["), write(Bottom), write(";0f"),
	% TODO: items
	true.

write_entity(Ent, EX-EY) :-
	write("\x1b["), write(EX), write(";"), write(EY), write("f"),
	ascii_graphic(Ent, Graphic),
	put_char(Graphic).

is_rect_border(RW-RH, X-Y) :- X = 0; Y = 0; X = RW; Y = RH.

write_rect(RW-RH) :- write_rect(RW-RH, 0-0), !.

write_rect(RW-RH, RW-RH) :-
	write('#').
write_rect(RW-RH, RW-Y) :-
	NY is Y + 1,
	write('#'),
	nl,
	write_rect(RW-RH, 0-NY).
write_rect(RW-RH, X-Y) :- is_rect_border(RW-RH, X-Y),
	write('#'),
	NX is X + 1,
	write_rect(RW-RH, NX-Y).
write_rect(RW-RH, X-Y) :-
	write('.'),
	NX is X + 1,
	write_rect(RW-RH, NX-Y).
