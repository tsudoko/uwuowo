:- include("basedef.pl").
size(testroom, 20, 20).

location(testroom-table, 4-3).
item_location(testroom-knife, 4-3).
item_location(testroom-beer_can, 4-3).
on(Item, Entity) :- location(Entity, X-Y), item_location(Item, X-Y).

wall(testroom, 1, 1, 18, 1).
