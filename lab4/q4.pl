% NOTE - This may or may not be more efficent. A bit verbose, though.
left_side(L, R, [L, R, _, _, _]).
left_side(L, R, [_, L, R, _, _]).
left_side(L, R, [_, _, L, R, _]).
left_side(L, R, [_, _, _, L, R]).

next_to(X, Y, Pond) :- left_side(X, Y, Pond).
next_to(X, Y, Pond) :- left_side(Y, X, Pond).

m(X, Y) :- member(X, Y).

get_zebra(Pond, Who) :- 
    Pond = [[C1, N1, P1, D1, S1],
              [C2, N2, P2, D2, S2],
              [C3, N3, P3, D3, S3],
              [C4, N4, P4, D4, S4],
              [C5, N5, P5, D5, S5]],
    m([red, english, _, _, _], Pond),
    m([_, swede, dog, _, _], Pond),
    m([_, dane, _, tea, _], Pond),
    left_side([green, _, _, _, _], [white, _, _, _, _], Pond),
    m([green, _, _, coffee, _], Pond),
    m([_, _, birds, _, pallmall], Pond),
    m([yellow, _, _, _, dunhill], Pond),
    D3 = milk,
    N1 = norwegian,
    next_to([_, _, _, _, blend], [_, _, cats, _, _], Pond),
    next_to([_, _, horse, _, _], [_, _, _, _, dunhill], Pond),
    m([_, _, _, beer, bluemaster], Pond),
    m([_, german, _, _, prince], Pond),
    next_to([_, norwegian, _, _, _], [blue, _, _, _, _], Pond),
    next_to([_, _, _, water, _], [_, _, _, _, blend], Pond),
    m([Who, _, zebra, _, _], Pond).





