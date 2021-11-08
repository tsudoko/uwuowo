:- include("basedef.pl").

stat(self, sanity, 100).
current_action(act_move).
location(testroom-self, 4-2).

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

:- (
	gen_room(false, true, ExitRoom),
	assert(room_linked(testroom-down, ExitRoom-up)),
	assert(room_linked(ExitRoom-up, testroom-down)),
	put_ent(ExitRoom-(stairs-up), random)
).
:- put_ent(testroom-(stairs-down), random).
:- put_ent(testroom-lamp, random).
:- put_ent(testroom-key, random).
