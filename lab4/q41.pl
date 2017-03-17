right_side(L, R, [L, R, _, _, _]).
right_side(L, R, [_, L, R, _, _]).
right_side(L, R, [_, _, L, R, _]).
right_side(L, R, [_, _, _, L, R]).
right_side(L, R, [R, _, _, _, L]).

next_to(X, Y, Pond) :- right_side(X, Y, Pond).
next_to(X, Y, Pond) :- right_side(Y, X, Pond).

m(X, Y) :- member(X, Y).

get_pine(Pond, Who) :- 
    Pond = [[T1, M1, F1, B1, S1], % north
              [T2, M2, F2, B2, S2], % east
              [T3, M3, F3, B3, S3], % south-east
              [T4, M4, F4, B4, S4], % south-west
              [T5, M5, F5, B5, S5]], % west
    next_to([_, _, _, tsingtao, _], [_, punk, _, _, _], Pond),
    right_side([pine, _, _, _, _], [willow, _, _, _, _], Pond),
    next_to([_, _, wet_Willy, _, _], [lilies, _, _, _, _], Pond),
    m([willow, _, _, heineken, _], Pond),
    next_to([_, punk, _, _, _], [_, _, _, _, business_school], Pond),
    m([_, rock, _, _, biological_sciences], Pond),
	F1 = wet_Willy,
	m([_, _, leaping_lucy, _, mechanical_and_aerospace_engineering], Pond),
	m([_, _, tommy_toad, budweiser, _], Pond),
	m([pine, _, freaky_frog, _, _], Pond),
	m([palm, thrash_music, _, _, _], Pond),
	B3 = pilsner_urquell,
	next_to([_, _, _, _, electrical_and_electronic_engineering], [_, thrash_music, _, _, _], Pond),
	m([_, k_pop, _, tiger_beer, _], Pond),
	m([_, classical, xena_warrior_frog, _, _], Pond),
	m([_, _, xena_warrior_frog, _, computer_engineering], Pond),
	m([unknown_tree, _, _, _, _], Pond),
	m([palm, _, Who, _, _], Pond).