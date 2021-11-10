room(Room, RW-RH) :- btree_maze(Room, W-H, _),
	RW is W*2+1, RH is H*2+1.

location(Room-wall, X-Y) :- btree_maze(Room, W-H, Seed),
	divmod(X, 2, TileX, MX),
	divmod(Y, 2, TileY, MY),
	TileX < W, TileY < H,
	HashInput is Seed + (TileX+TileY*W),
	fnv1a(64, HashInput, Directions),
	D is (Directions >> 6) /\ 1,
	\+ btree_maze_floor(D, MX-MY).

btree_maze_floor(0, 1-0).
btree_maze_floor(1, 0-1).
btree_maze_floor(_, 0-0).
