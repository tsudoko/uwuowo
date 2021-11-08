:- include("basedef.pl").
room(testroom, 20-20).

location(testroom-cat, 5-5).
location(testroom-table, 4-3).
location(testroom-knife, 4-3).
location(testroom-(can-0), 4-3).
contents(can-0, beer).
on(Item, Entity) :- item(Item), location(Entity, X-Y), location(Item, X-Y).

wall(testroom, 1-1, 18-1).
wall(testroom, 1-18, 18-18).
