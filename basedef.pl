:- dynamic(location/2).
:- multifile(location/2).
:- dynamic(stat/3).
:- multifile(stat/3).
:- dynamic(room/2).
:- multifile(room/2).
:- dynamic(sight_range/2).
:- multifile(sight_range/2).
:- dynamic(inventory/2).
:- multifile(inventory/2).
:- dynamic(btree_maze/4).
:- multifile(btree_maze/4).

:- dynamic(inventory_cursor/2).
:- multifile(inventory_cursor/2).

:- dynamic(on_get/1).
:- multifile(on_get/1).

% not strictly multifile (these aren't defined anywhere, they're always
% asserted at runtime) but gplc generates duplicate definitions without
% specifying multifile
:- dynamic(status_msg/1).
:- multifile(status_msg/1).
:- dynamic(current_action/1).
:- multifile(current_action/1).

:- multifile(gen_room/3).
:- multifile(put_ent/2).

:- multifile(turn_pass/1).
:- multifile(wall/5).
:- multifile(is_container/2).
