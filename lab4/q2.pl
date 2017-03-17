spouse(X, Y) :- married(X, Y). % check if X and Y are spouse using the married fact provided in the knowledge base.
spouse(X, Y) :- married(Y, X). % switch the arguments when querying the querying the fact

% Assume gender only applies to human and not cyborgs.
human_husband(H, Y) :- spouse(H, Y), male(H). % if H and Y are spouse and H is male then its true , H, the husband is male human

% H is a human wife of Y
human_wife(H, Y) :- spouse(H, Y), female(H).  % same as above but now with female

% H1 is a spouse of H2, both are humans()
human_couple(H1, H2) :- spouse(H1, H2), human(H1), human(H2). % check if H1 and H2 are spouse and both are human using the human rule provided

% C is a spouse of Y, C is cyborg, Y can be anyone
cyborg_spouse(X, Y) :- spouse(X, Y), cyborg(X). % check if X and Y are spouse and X is a cyborg

% C2 is a spouse of C2, both are cyborgs
cyborg_couple(X, Y) :- spouse(X, Y), cyborg(X), cyborg(Y). % check if X and Y are spouse and both are cyborg

% X and Y are siblings, both humans
human_siblings(X, Y) :- \parent(Z, X), parent(Z, Y), human(X), human(Y). % check if both X and Y have the same parent and X & Y are human

% X is a brother (male human) of a human Y
brother_of_human(X, Y) :- human_siblings(X, Y), male(X).

% X is a sister (female human) of a human Y
sister_of_human(X, Y) :- human_siblings(X, Y), female(X).

% X is an ancestor of Y
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y). 
% using recursion to trace through the ancestory.
% for X to be an ancestor of Y have to find the childrens of X and check if any of them is Y.
% recusion go through layer by layer of X's childeren or grand children.
% check if a layer of children matches Y else go deeper.
% ancestor(X, Y) :- parent(X, Y). is the base case
% consitantly replace parent(X, Y)'s X with the inputed X's children and check if Y is the child, in order to traverse the ancestory.


% C is a cyborg ancestor of Y
cyborg_ancestor(C, Y) :- cyborg(C), ancestor(C, Y).
% same as the above but check if C is a cyborg first.

% C1, C2 and C3 is a family of cyborgs, where C1 and C2 are married cyborgs and C3 is their cyborg
% child if they have multiple children, results will be repeated with different C3
cyborg_family(C1, C2, C3) :- spouse(C1, C2), father(C1,C3), mother(C2,C3).
cyborg_family(C1, C2, C3) :- spouse(C1, C2), father(C2,C3), mother(C1,C3).
% check if C1 and C2 are spouse and C1 is a father of C3 and C2 is a mother of C3
% or C2 is a father of C3 and C1 is a mother of C3

% X is descendant of Y
descendant(X,Y) :- parent(Y, X).
descendant(X,Y) :- parent(Y, Z), descendant(X, Z).
% first check if Y is a parent of X, if its true then is satisfy the rule.
% if not use recursion to find the descendants Y and check if they are the parent X
% use Y to trace through the decedants.

is_human(H) :- human(H).
% using the human rule provided to find if H is human.

is_human_child_of_cyborg_parent(H) :- human(H), parent(Z, H), cyborg(Z).
% check if H is human, get the parents of H then check if any one of the parent is a cyborg.

has_cyborg_ancestor(X) :- parent(Y, X), cyborg(Y).
has_cyborg_ancestor(X) :- parent(Z, X), has_cyborg_ancestor(Z).
% similiar to ancestor rule, with addtional predicate to check if parent is a cyborg.
% first get the parent of X and check if one of parent is cyborg, 
% if its true it will satisify the rule else use recursion to move up the family tree
% and always check against the base case to satisfy the rule.

has_no_cyborg_descendants(X) :- descendant(Z,X), \+ cyborg(Z).
% use the decendant rule created earlier to get the decedants of X and check if all of the decedants is not a cyborg using the negate predicate (\+).

first(0, 1).
first(N, X) :- N>0, N1 is N-1, first(N1,F1), X is N * F1.

second(0, X, X) :- !.
second(X, 0, X) :- !.
second(X, X, X) :- !.
second(A, B, X) :- B>A, C is B-A, second(A, C, X).
second(A, B, X) :- B<A, C is A-B, second(C, B, X).

% Third function
third(0, 0, _) :- !, fail.
third(B, N, X) :- N>0, third(B, N, 1, X).
third(B, N, X) :- N<0, N1 = -N, third(B, N1, 1, X1), X is 1/X1.
third(_, 0, X, X).
third(B, N, T, X) :- N>0, T1 is T*B, N1 is N-1, third(B, N1, T1, X).


numbers_between(L, H, X) :- integer(L), integer(H), X is L, X =< H.
numbers_between(L, H, X) :- L1 is L + 1, L1 =< H, numbers_between(L1, H, X).

lucas(N, X) :- \+ integer(N), !, fail.
lucas(N, X) :- N == 0, X is 2.
lucas(N, X) :- N == 1, X is 1.
lucas(N, X) :- N > 1, N1 is N - 1, N2 is N - 2, lucas(N1, K), lucas(N2, J), X is K + J.
lucas(N, X) :- N < 0, N1 is N + 1, N2 is N + 2, lucas(N1, K), lucas(N2, J), X is J - K.
% 





%% THE RIDDLE:

%% * There are 5 frogs living in ponds next to NTU campus.
%% * The ponds are laid out in a circular shape (cycle graph), first pond is on the north, second
%%   on the east, third on the south-east, fourth on the south-west, fifth on the west.
%% * Each pond has different trees growing around it.
%% * Each frog owns its own pond.
%% * Each frog graduated from different school at NTU.
%% * Each frog listens to different genre of music.
%% * Each frog drinks different beer.
%%
%% * Frog that drinks Tsingtao beer lives next to frog that listens to punk.
%% * Willow pond is counterclockwise adjacent to pine pond.
%% * Wet_Willy lives in a pond adjacent to lilies pond.
%% * Frog from willow pond drinks Heineken.
%% * Frog that likes punk lives adjacent to a frog that graduated from Nanyang Business School.
%% * Frog who likes rock music is a graduate of School of Biological Sciences.
%% * Wet_Willy lives in the northern pond.
%% * Leaping_Lucy graduated from School of Mechanical and Aerospace Engineering.
%% * Tommy_Toad drinks Budweiser.
%% * Freaky_Frog lives in pine pond (pond surrounded by pines).
%% * Frog from palm pond likes thrash metal music.
%% * Xena_Warrior_Frog listens to classical music.
%% * Frog in the south-eastern pond drinks Pilsner Urquell.
%% * Xena_Warrior_Frog graduated from School of Computer Engineering
%% * Frog that graduated from School of Electrical and Electronic Engineering lives adjacent to frog
%%   that listens to thrash metal.
%% * Frog that listens to k-pop drinks Tiger beer.
%% * The goliath frog (Conraua goliath) is the largest living frog on Earth.


%% THE QUESTIONS:

%% How many different frogs can possibly live in the palm pond?  Which frogs are those?

%% How many different combinations (pond X trees surrounding ponds X beer type X music genre X alma
%% mater) are there in total? What are they?


%% WRITE YOUR CODE AND COMMENTS BELOW:
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
    next_to([_, _, wet_willy, _, _], [lilies, _, _, _, _], Pond),
    m([willow, _, _, heineken, _], Pond),
    next_to([_, punk, _, _, _], [_, _, _, _, business_school], Pond),
	m([willow, _, rock, _, biological_sciences], Pond),
	F1 = wet_Willy,
	m([_, _, leaping_lucy, _, mechanical_and_aerospace_engineering], Pond),
	m([_, _, tommy_toad, budweiser, _], Pond),
	m([pine, _, freaky_frog, _, _], Pond),
	m([palm, thrash_music, _, _, _], Pond),
	m([_, classical, xena_warrior_frog, _, _], Pond),
	B3 = pilsner_urquell,
	m([_, _, xena_warrior_frog, _, computer_engineering], Pond),
	next_to([_, _, _, _, electrical_and_electronic_engineering], [_, thrash_music, _, _, _], Pond),
	m([_, k_pop, _, tiger_beer, _], Pond),
	m([pine, _, Who, _, _], Pond).




