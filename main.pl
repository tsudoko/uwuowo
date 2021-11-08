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
	put_ent(ExitRoom-(stairs-up-testroom), random),
	put_ent(testroom-(stairs-down-ExitRoom), random)
).
:- put_ent(testroom-lamp, random).
:- put_ent(testroom-key, random).
