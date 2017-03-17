%%%% CZ3005 2015 Semester 2: Lab 4 (Total Marks: 100)
%%%%
%%%% Due two weeks from the lab.
%%%%
%%%% Submission procedure will be announced during the lecture or the
%%%% lab session.
%%%%
%%%% This file is a loadable Lisp file.  You are to modify this file and
%%%% add your answers.  Then CHECK TO MAKE SURE that the file still loads
%%%% properly into the Prolog system. You will be penalized in case the file
%%%% is not loadable.
%%%%
%%%% Name your lab 4 Prolog code as  "LAB4-<YOUR_MATRICULATION_NUMBER>.pl"
%%%%
%%%% Before you submit your code, be sure to test it in Swi-Prolog.
%%%% We'll be using Swi_Prolog v. 6.6.* to check your solutions.
%%%%
%%%% If we cannot run your code, including our automatic checker, your answer
%%%% will not be considered at all. If our checker detects wrong output, you may
%%%% still get partial marks for such problem.
%%%%
%%%% No external code is allowed in this assignment. All code and text has to be your
%%%% original work.
%%%%
%%%% COMMENT EXCESSIVELY -- In Prolog, the code is usually very concise. It is very
%%%% important that you comment everything. In most of the programming questions, up to
%%%% 50% of the marks is awarded for comments!



%%%% QUESTION 1     [ 5 marks for thorough explanation
%%%%                  5 marks for derivation tree ]

%% Suppose that, in program P [p.pl], we change the clause #2 to this:

%% p(X) :- q(X), !, r(X).

%% What answers can now be produced by the goal ?-p(X)? Why? Test it. Draw the corresponding Prolog
%% derivation  tree (modified to suit the new rule).

%% Please draw the derivation tree in ASCII below. You may use the one from lab4.pl as a base.

%% the cut operator prevents any backtracking hence anything beyond q(X) wont be backtracked
%% which is shown in the diagram below.
%% the function did not backtrack back to q(X) and p(X) hence p(X) cannot test other variables such as b, c, d.
%% cut operator is useful for pruning and increase the efficent of the function, when we dont need backtracking.
%% eg. DFS when the function finds a solution to the goal we dont need to bactrack back to the starting
%% its also if 1 solution is enough and dont need to know the other solution.

%%                     p(a)/p(X)
%%          ________ ___|_________
%%          |           |         
%%          |#1(X=a)    |#2       
%%          |           |         
%%        true      q(X), !, r(X)   
%%        X=a           |         
%%                      |#4       
%%                      |         
%%                  s(X),r(X)    
%%                      |        
%%           ___________|
%%           |         
%%           |#7(X=a)  
%%           |        
%%          r(a)     
%%      _____|____ 
%%      |        |  
%%      |#5    #6| 
%%      |        |  
%%      true  fail  
%%      X=a 
%%      cutoff            

%%                     p(b)
%%          ____________|
%%          |           |         
%%          |#1(X=b)    |#2       
%%          |           |         
%%        fail      q(X), !, r(X)    
%%                      |         
%%                      |#4       
%%                      |         
%%                  s(X),r(X)    
%%                      |        
%%                      |
%%                      |           
%%                      |#8(X=b)   
%%                      |           
%%                     r(b)        
%%                  ____|_____  
%%                  |        |  
%%                  |#5    #6| 
%%                  |        |  
%%                  fail  true  
%%                         X=b 
%%                        cutoff 

%%                     p(c)
%%          ________ ___|
%%          |           |         
%%          |           |#2     
%%          |           |         
%%        fail      q(X), !, r(X)     
%%                      |         
%%                      |#4       
%%                      |         
%%                  s(X),r(X)    
%%                      |        
%%                      |____________
%%                                  |
%%                                  |#9(X=c)
%%                                  |
%%                                 r(c)
%%                              ____|_____
%%                              |        |
%%                              |#5    #6|
%%                              |        |
%%                              fail  fail
 

%%                     p(d)
%%          ________ ___|_________
%%          |           |         |
%%          |           |#2       |
%%          |           |         |
%%        fail      q(X),!,r(X)  u(X)
%%                      |         |
%%                      |#4       |(X=d)
%%                      |         |
%%                  s(X),r(X)    true
%%                      |        X=d
%%                      |____________
%%                                  |
%%                                  |
%%                                  |
%%                                 r(c)
%%                              ____|_____
%%                              |        |
%%                              |#5    #6|
%%                              |        |
%%                              fail  fail
                             

%%%% QUESTION 2     [ 20 marks total ]

%% A common example of a knowledge base in Prolog is a family tree. Unfortunately, in the 21st
%% century, technology advances and human ignorance have cause a wide-spread integration of
%% cybernetic organisms (also known as cyborgs) into the human race. In the new society, it is
%% possible for newborn children to be transformed into cyborgs! They can get married and even have
%% children themselves, although cyborgs don't have genders!

%% You are given a family tree of a large family infested with cyborgs. See the file "family-hw.pl".

%% Your task is to write several very simple Prolog rules, so that we can easily analyze the
%% relationships withing this cyborg infested family.

%% The file consists of the following facts:

%% male(X).
%% female(X).
%% cyborg(X). % first three facts are exclusive
%% parent(X,Y). % X is parent of Y
%% married(X,Y). % X is married to Y, always accompanied by reverse fact

%% And the following rules:

%% human(H) :- male(H).
%% human(H) :- female(H).
%% father(F,C) :- male(F),parent(F,C).
%% mother(M,C) :- female(M),parent(M,C).
%% is_father(F) :- father(F,_).
%% is_mother(M) :- mother(M,_).

%% Your task is to to define all the following rules.

%% NOTE that not all the rules are very simple and sometimes you have to create multiple rules or
%% use recursive rules in order to achieve your goal.

% X is a spouse of Y
spouse(X, Y) :- married(X, Y). % check if X and Y are spouse using the married fact provided in the knowledge base.
spouse(X, Y) :- married(Y, X). % switch the arguments when querying the querying the fact

% H is a human husband of Y
% Assume gender only applies to human and not cyborgs.
human_husband(H, Y) :- spouse(H, Y), male(H). % if H and Y are spouse and H is male then its true , H, the husband is male human

% H is a human wife of Y
human_wife(H, Y) :- spouse(H, Y), female(H).  % same as above but now with female

% H1 is a spouse of H2, both are humans
human_couple(H1, H2) :- spouse(H1, H2), human(H1), human(H2). % check if H1 and H2 are spouse and both are human using the human rule provided

% C is a spouse of Y, C is cyborg, Y can be anyone
cyborg_spouse(X, Y) :- spouse(X, Y), cyborg(X). % check if X and Y are spouse and X is a cyborg

% C2 is a spouse of C2, both are cyborgs
cyborg_couple(X, Y) :- spouse(X, Y), cyborg(X), cyborg(Y). % check if X and Y are spouse and both are cyborg

% X and Y are siblings, both humans
human_siblings(X, Y) :- X \= Y, parent(Z, X), parent(Z, Y), human(X), human(Y). % check if both X and Y have the same parent and X & Y are human and X and Y is not the same person

% X is a brother (male human) of a human Y
brother_of_human(X, Y) :- human_siblings(X, Y), male(X). % check reuse the human_siblings rule and check if X is male

% X is a sister (female human) of a human Y
sister_of_human(X, Y) :- human_siblings(X, Y), female(X). % check reuse the human_siblings rule and check if X is female

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

% C is cyborg descendant of Y
cyborg_descendant(C,Y) :- cyborg(C), descendant(C,Y).
% check if C is cyborg then check if its a descendant of Y by reusing the descendant rule

% X is aunt or uncle of Y, X is human
human_auntoruncle(X, Y) :- parent(Z, Y), human_siblings(X, Z).
% reuse the human_siblings rule created earlier and check if the parent of Y is human sibling of X.

% A few simple rules now, if these the variable is not bounded, iterate through all those who
% fulfill the condition, e.g. is_cyborg(X). iterates through all cyborgs
is_cyborg(C) :- cyborg(C).
% using the cyborg rule provided to find if C is cyborg.

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



%%%% QUESTION 3     [ 30 marks total (half of the marks is for comments,
%%%%                   5 marks for first function,
%%%%                   5 marks for second function,
%%%%                  10 marks for third function) ]

%% Can you recognize the following three functions? If so, write the common name of each function
%% with detailed explanation how the evaluation works and how you figured out which function it is.
%% You may want to include a simple example. Imagine you are explaining this to your friend who is
%% proficient in computer science, but has no clue what logic programming and Prolog are.

%% It is possible that you may get an instantiation_error error when trying the function. Just try
%% to use it differently, you may assume that variable X gets bound to the result.

% First function
first(0, 1).
first(N, X) :- N>0, N1 is N-1, first(N1,F1), X is N * F1.
% Factorial fn
% recursively reduce N by 1 for every instance of first() and store it in N1
% until N is 0 assign 1 to X, which is F1
% then pop the stack returning X is N * F1
% as the stack is popped it accumulates the result until first instance of the called function

% Second function
second(0, X, X) :- !.
second(X, 0, X) :- !.
second(X, X, X) :- !.
second(A, B, X) :- B>A, C is B-A, second(A, C, X).
second(A, B, X) :- B<A, C is A-B, second(C, B, X).
% GCD, Greatest Common Divisor fn
% get the difference of the 2 input arguement and recursively substract the greater one with the lesser one.
% until both A and B have the same value assign the value to X and return the result.
% if there any of the input is 0 it simply return the non zero value
% if both input are the same it return the same value

% Third function
third(0, 0, _) :- !, fail.
third(B, N, X) :- N>0, third(B, N, 1, X).
third(B, N, X) :- N<0, N1 = -N, third(B, N1, 1, X1), X is 1/X1.
third(_, 0, X, X).
third(B, N, T, X) :- N>0, T1 is T*B, N1 is N-1, third(B, N1, T1, X).
% exponential function
% B is the base and N is the exponent
% third(B, N, T, X)  does the computation, it multiply T with B, initally T is 1, T is the accumulator of the result
% third(B, N, T, X) is called N times, so it multipies B with itself for N times, which is stored in T everything it mulitply
% N is reduce by 1 everytime third(B, N, T, X) is called, hence return the result when N is 0.
% When the exponent is negative, when the final result from third(B, N, T, X) is return to third(B, N, X) 
% it will return 1 / result of third(B, N, T, X), which is X is 1/X1 in the code.



%%%% QUESTION 4     [ 30 marks total, (10 for each function: 5 for correctness, 5 for comments) ]

%% Your task in this question is to write the following predicates in Prolog. Note that the predicates
%% may consist of several clauses and may be recursive. You shouldn't need to use any techniques
%% we haven't gone through during the lab (lab4.pl). If you do, justify it.

%% Describe thoroughly how you reached the solutions. Just writing the function is not enough.

%% Test your predicates well. Don't forget invalid values, unbounded variables, border conditions.

% L and H are integers, such that L <= H. If X is an integer, numbers_between is true for L <= X <=
% H. When X is a variable it is successively bound to all integers between L and H.
numbers_between(L, H, X) :- integer(L), integer(H), X is L, X =< H.
numbers_between(L, H, X) :- L1 is L + 1, L1 =< H, numbers_between(L1, H, X).
% the first line checks if L and H are integers and assign L to X and return X if X is less than or equal to H
% the first line is important to return inputed L value because the 2nd line increments L
% the 2nd line increments L and call the function again with the new L.
% we check L1 =< H again on the 2nd line so it wont have "ERROR: Out of local stack" when using ; to print all the values.

% This predicate computes both the Quotient and Remainder of two integers: Dividend / Divisor.
% Quotient  is Dividend div Divisor; Remainder is Dividend mod Divisor

divmod(Dividend, Divisor, Quotient, Remainder) :- Dividend < 1, !, fail. % dividend have to be more than 0
divmod(Dividend, Divisor, Quotient, Remainder) :- Divisor == 0, !, fail. % divisor cannot be 0
divmod(Dividend, Divisor, Quotient, Remainder) :- divmod(Dividend, Divisor, Quotient, Remainder, 0). % set accumulator to 0

% base case, if Dividend is less than Divisor, return Remainder same as Dividend and Quotient same as the accumulator
% initally the accumulator is to set 0 as mention above.
divmod(Dividend, Divisor, Acc, Dividend, Acc) :-
    Dividend < Divisor, !.

% the accumulator will only increase if the function below is executed
% rercursively increase the accumulator by 1 and substract Dividened with Divisor until the base case is satisfied.
divmod(Dividend , Divisor, Q, R, Acc) :-
    Dividend >= Divisor,
    D1 is Dividend - Divisor,
    A1 is Acc + 1,
    divmod(D1, Divisor, Q, R, A1).

% lucas predicate computes the Nth Lucas number (https://en.wikipedia.org/wiki/Lucas_number)
lucas(N, X) :- \+ integer(N), !, fail. % dont allow non integer N value
lucas(N, X) :- N == 0, X is 2. % return 2 if N is 0
lucas(N, X) :- N == 1, X is 1. % return 1 if N is 1
lucas(N, X) :- N > 1, N1 is N - 1, N2 is N - 2, lucas(N1, K), lucas(N2, J), X is K + J.
lucas(N, X) :- N < 0, N1 is N + 1, N2 is N + 2, lucas(N1, K), lucas(N2, J), X is J - K.
% lucas series is similiar to fibonacci sequence.
% the function first check if N is integer, if its not it return false, for error checking
% the function works for both postive Nth and negative Nth.
% the recursion function produce a binary tree through recursion constantly N - 1 and N - 2 at each node, until N==0 or N==1,
% if its positive Nth, it then add the result as it pop the stack or return from the functions in the recursion stack
% same with negative Nth but only constantly substract when returning the functions in the recursion stack.




%%%% QUESTION 5     [ 20 marks for working solution (half of the marks is for comments) ]

%% You are given a logical riddle. Unlike conventional riddles with a single solutions, this one has
%% plenty of solutions. That's why Prolog is better than pen and paper. By a solution, we mean all
%% possible valid combinations.

%% Use Prolog to solve the riddle and successively evaluate the solutions. You have to create
%% several predicates, model the problem properly, test it thoroughly. For convenience, you may want
%% to go through tutorial on lists in Prolog (https://en.wikibooks.org/wiki/Prolog/Lists). It makes
%% the problem modeling process simpler.

%% Describe your thinking process. Why did you chose to model this and that constraint using certain
%% model and not a different one? What is the purpose of each predicate?

%% Note that there is plenty of different ways how to model your problem. Don't get stuck with one.
%% No outline is given to you. Use your creativity.


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
%%  2 different frogs. Wet Willy and Tommy toad.

%% How many different combinations (pond X trees surrounding ponds X beer type X music genre X alma
%% mater) are there in total? What are they?


%% WRITE YOUR CODE AND COMMENTS BELOW:
% model to find the adjacent ponds in a circular manner
right_side(R, L, [L, R, _, _, _]).
right_side(R, L, [_, L, R, _, _]).
right_side(R, L, [_, _, L, R, _]).
right_side(R, L, [_, _, _, L, R]).
right_side(R, L, [R, _, _, _, L]).

% look for adjacent ponds on the left and on the right
next_to(X, Y, Pond) :- right_side(X, Y, Pond).
next_to(X, Y, Pond) :- right_side(Y, X, Pond).

m(X, Y) :- member(X, Y).

palm_frog(Who) :-
  ponds(Pond, Who),
  m([palm, _, Who, _, _], Pond).

palm_frog(Who) :-
  ponds(Pond, Who),
  m([palm, _, Who, _, _], Pond).

ponds(Pond, Who) :- 
    Pond = [[T1, M1, F1, B1, S1], % north pond
              [T2, M2, F2, B2, S2], % east pond
              [T3, M3, F3, B3, S3], % south-east pond
              [T4, M4, F4, B4, S4], % south-west pond
              [T5, M5, F5, B5, S5]], % west pond 

    % below are the above statements.
    next_to([_, _, _, tsingtao, _], [_, punk, _, _, _], Pond),

    right_side([willow, _, _, _, _], [pine, _, _, _, _], Pond),

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
	m([unknown_tree, _, _, _, _], Pond). % have to include this tree because the statements did not mention the 5th tree

%% the problem is modeled similiar to constraint satisfaction problem
%% then let prolog permutate and find a solution 
%% i use this solution because its simple and straightforward
%% i tried modeling the problem with proposition logic or similiar but its pretty difficult

