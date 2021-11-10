:- include("basedef.pl").

stat(self, sanity, 100).
current_action(act_move).
location(testroom-self, 4-2).

:- [
	"util.pl",
	"cat.pl",
	"testroom.pl",
	"maze_btree.pl",
	"roomgen.pl",
	"entities.pl",
	"sys.pl",
	"tui_draw.pl",
	"tui_tiles.pl",
	"tui_binds.pl",
	"tui.pl"
].

:- (
	gen_room(ExitRoom),
	(\+ btree_maze(ExitRoom, _, _, _), maybe -> put_ent(ExitRoom-table, random); true),
	(maybe -> put_ent(ExitRoom-cat, random); true),
	put_ent(ExitRoom-(exit-closed), random),
	put_ent(ExitRoom-(stairs-up-testroom), random),
	put_ent(testroom-(stairs-down-ExitRoom), random)
).
:- put_ent(testroom-lamp, random).
:- put_ent(testroom-key, random).
