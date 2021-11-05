:- include("basedef.pl").

stat(self, sanity, 100).
location(testroom-self, 4-2).

:- [
	"util.pl",
	"testroom.pl",
	"roomgen.pl",
	"entities.pl",
	"sys.pl",
	"tui_draw.pl",
	"tui_tiles.pl",
	"tui_binds.pl",
	"tui.pl"
].
