:- include("basedef.pl").

stat(self, sanity, 100).
current_action(move_rel).
location(testroom-self, 4-2).
sight_range(_, 2.5).
room_linked(testroom-down, exitroom-up).

:- [
	"util.pl",
	"cat.pl",
	"testroom.pl",
	"roomgen.pl",
	"entities.pl",
	"sys.pl",
	"tui_draw.pl",
	"tui_tiles.pl",
	"tui_binds.pl",
	"tui.pl"
].

:- gen_room(exitroom, false, true).
:- put_ent(exitroom-(stairs-up), random).
:- put_ent(testroom-(stairs-down), random).
:- put_ent(testroom-key, random).
