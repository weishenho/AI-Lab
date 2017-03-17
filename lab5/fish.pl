
whale(X) :- X is whale.
mammal(X) :- X is mammal.

john :- beautiful, rich.


immortal(x).
mammal(x).
horned(x).
magical(x). 
mythical(x).

is_magical(X) :- 
\+ mythical(X) ,
( \+ mythical(X) ; immortal(X) ) ,
( mythical(X) ; \+ immortal(X) ) ,
( mythical(X) ; mammal(X) ) ,
( \+ immortal(X) ; horned(X) ) ,
( \+ mammal(X) ; horned(X) ) ,
( \+ horned(X) ; magical(X) ).


works_smart(querk_jr).
consultations(X).
finish_assignments(X) :- consultations(X).
finish_assignments(X) :- works_smart(X).
mental_health(X) :- works_smart(X).
mastermind(X) :- third_assignment(X), mental_health(X).
third_assignment(X) :- finish_assignments(X).

fulladder0(A_in, B_in, Carry_in, Sum_out, Carry_out) :- fulladder(A_in, B_in, Carry_in, Sum_out, Carry_out).
fulladder1(A_in, B_in, Carry_in, Sum_out, Carry_out) :- fulladder(A_in, B_in, Carry_in, Sum_out, Carry_out).
fulladder2(A_in, B_in, Carry_in, Sum_out, Carry_out) :- fulladder(A_in, B_in, Carry_in, Sum_out, Carry_out).
fulladder3(A_in, B_in, Carry_in, Sum_out, Carry_out) :- fulladder(A_in, B_in, Carry_in, Sum_out, Carry_out).

four_bit_full_adder(Cin, A3, A2, A1, A0, B3, B2, B1, B0, S3, S2, S1, S0, Cout) :- 
fulladder0(A0, B0, Cin, S0, C0),
fulladder1(A1, B1, C0, S1, C1),
fulladder2(A2, B2, C1, S2, C2),
fulladder3(A3, B3, C2, S3, Cout).

four_bit_full_substr(A3, A2, A1, A0, B3, B2, B1, B0, S3, S2, S1, S0, Cout) :- 
not(B0, Nb0),
not(B1, Nb1),
not(B2, Nb2),
not(B3, Nb3),
fulladder0(A0, Nb0, 1, S0, C0),
fulladder1(A1, Nb1, C0, S1, C1),
fulladder2(A2, Nb2, C1, S2, C2),
fulladder3(A3, Nb3, C2, S3, Cout).


four_bit_priority_encoder(D3, D2, D1, D0, Y1, Y0, V) :-
or(D3, D2, Y1),
not(D2, Nd2),
and(D1, Nd2, X),
or(X, D3, Y0),
or(D0, D1, V0),
or(D2, D3, V1),
or(V0, V1, V).
