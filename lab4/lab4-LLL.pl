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


%% P(X). only traverse for the 'a' branch because of the cut operator prevents the function from backtracking to the root node.
%% due to this it can try other variables, 'b', 'c' and 'd'.

%%                     p(X)
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
spouse(X, Y) :- married(X, Y).
% the rule holds if X and Y are married.

% H is a human husband of Y
human_husband(H, Y) :- male(H), spouse(H, Y). 
% using the spouse rule from before, H and Y are spouses and H is male.

% H is a human wife of Y
human_wife(H, Y) :- female(H), spouse(H, Y).
% this rule check whether Y is female instead of H is male.

% H1 is a spouse of H2, both are humans
human_couple(H1, H2) :- human(H1), human(H2), spouse(H1, H2). 
% using the human ruled already implemented, determine if H1 and H2 are human and their spouse as well.

% C is a spouse of Y, C is cyborg, Y can be anyone
cyborg_spouse(X, Y) :- cyborg(X), spouse(X, Y). 
% the rule holds if X is a cyborg and is a spouse of anyone.

% C2 is a spouse of C2, both are cyborgs
cyborg_couple(X, Y) :- cyborg(X), cyborg(Y), spouse(X, Y). 
% determine both X and Y are cybrog and both are spouse of each other

% X and Y are siblings, both humans
human_siblings(X, Y) :- X \= Y, human(X), human(Y), parent(Z, X), parent(Z, Y). 
% X and Y cannot be the same person and they are both human and they have same parent to be siblings.

% X is a brother (male human) of a human Y
brother_of_human(X, Y) :- male(X), human_siblings(X, Y). 
% X is a male and sibling of Y, using the human_siblings above.

% X is a sister (female human) of a human Y
sister_of_human(X, Y) :- female(X), human_siblings(X, Y). 
% same as brother_of_human(X, Y) but check if X is female instead of male

% X is an ancestor of Y
ancestor(X, Y) :- parent(X, Y). % base case or terminating case
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).  % recursion function
% through recursion,  keep getting child of X and determine if their parent and child.

% C is a cyborg ancestor of Y
cyborg_ancestor(C, Y) :- cyborg(C), ancestor(C, Y).
% first, determine if C is cyborg then use the ancestor rule to determine if its a ancestor of Y.

% C1, C2 and C3 is a family of cyborgs, where C1 and C2 are married cyborgs and C3 is their cyborg
% child if they have multiple children, results will be repeated with different C3
cyborg_family(C1, C2, C3) :- spouse(C1, C2), parent(C1,C3), parent(C2,C3).
%% determine if C1 and C2 are spouse they have a child C3.

% X is descendant of Y
descendant(X,Y) :- parent(Y, X).
descendant(X,Y) :- parent(Y, Z), descendant(X, Z).
% similiar to the ancestor rule, but in reverse.

% C is cyborg descendant of Y
cyborg_descendant(C,Y) :- cyborg(C), descendant(C,Y).
% using the descendant rule created earlier, first determine if C is cyborg and determine if it have a descendant Y.

% X is aunt or uncle of Y, X is human
human_auntoruncle(X, Y) :- parent(Z, Y), human_siblings(X, Z).
% using the human siblings rule first get the parent of Y and check if the parent is siblings with X.

% A few simple rules now, if these the variable is not bounded, iterate through all those who
% fulfill the condition, e.g. is_cyborg(X). iterates through all cyborgs
is_cyborg(C) :- cyborg(C).
% use cyborg to determine if C is cyborg

is_human(H) :- human(H).
% use human rule to determine if H is human

is_human_child_of_cyborg_parent(H) :- human(H), parent(Z, H), cyborg(Z).
% first determine if H is human, then get it's parents, after that check if the parent is a cyborg.

has_cyborg_ancestor(X) :- ancestor(Y, X), cyborg(Y).
% get the ancestors of X then determine if any of them is a cyborg.

has_no_cyborg_descendants(X) :- \+ cyborg(Z), descendant(Z,X).
% reusing the deccendant rule, get all child / grand child etc.. from X and determine if any of them is cyborg.
% if none of them is a cyborg it returns true using the negation predicate \t.

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
% repeat the function until first(0, 1). using N-1
% then backtrack with N * F1.

% Second function
second(0, X, X) :- !.
second(X, 0, X) :- !.
second(X, X, X) :- !.
second(A, B, X) :- B>A, C is B-A, second(A, C, X).
second(A, B, X) :- B<A, C is A-B, second(C, B, X).
% GCD, Greatest Common Divisor fn
% find which is greater A or B then substract the greater value with the lesser value.
% substract recursively until A and B have the same value.

% Third function
third(0, 0, _) :- !, fail.
third(B, N, X) :- N>0, third(B, N, 1, X).
third(B, N, X) :- N<0, N1 = -N, third(B, N1, 1, X1), X is 1/X1.
third(_, 0, X, X).
third(B, N, T, X) :- N>0, T1 is T*B, N1 is N-1, third(B, N1, T1, X).
% exponential function
% B is the base value and N is the exponent
% the function multiple B but itself N times
% example B^3, the function will do B*B*B recursively
% it everytime it multiples it accumulates in T.



%%%% QUESTION 4     [ 30 marks total, (10 for each function: 5 for correctness, 5 for comments) ]

%% Your task in this question is to write the following predicates in Prolog. Note that the predicates
%% may consist of several clauses and may be recursive. You shouldn't need to use any techniques
%% we haven't gone through during the lab (lab4.pl). If you do, justify it.

%% Describe thoroughly how you reached the solutions. Just writing the function is not enough.

%% Test your predicates well. Don't forget invalid values, unbounded variables, border conditions.

% L and H are integers, such that L <= H. If X is an integer, numbers_between is true for L <= X <=
% H. When X is a variable it is successively bound to all integers between L and H.
numbers_between(L,H,X) :- L =< H.
numbers_between(L,H,X) :- L < H, L1 is L+1, between_(L1,H,X).
% keep increasing L by 1 until it is greater than H.



% This predicate computes both the Quotient and Remainder of two integers: Dividend / Divisor.
% Quotient  is Dividend div Divisor; Remainder is Dividend mod Divisor

divmod(Dividend, Divisor, Quotient, Remainder) :- Divisor == 0, !, fail. % prevent division by 0.
divmod(Dividend, Divisor, Quotient, Remainder) :- Dividend < 1, !, fail. % dividend have to greater than 0
divmod(Dividend, Divisor, Quotient, Remainder) :- divmod(Dividend, Divisor, Quotient, Remainder, 0). % set accumlate to 0

% base case 
divmod(Dividend, Divisor, Acc, Dividend, Acc) :-
    Dividend < Divisor, !.

% Acc is needed to calculate the quoient
divmod(Dividend , Divisor, Q, R, Acc) :-
    A is Acc + 1,
    D is Dividend - Divisor,
    divmod(D, Divisor, Q, R, A).


% lucas predicate computes the Nth Lucas number (https://en.wikipedia.org/wiki/Lucas_number)
lucas(N, X) :- \+ integer(N), !, fail. % valid values are integer
lucas(N, X) :- N == 1, X is 1. % return 1 when N equals 1
lucas(N, X) :- N == 0, X is 2. % return 2 when N equals 2
lucas(N, X) :- N < 0, N1 is N + 1, N2 is N + 2, lucas(N1, L1), lucas(N2, L2), X is L2 - L1.
lucas(N, X) :- N > 1, N1 is N - 1, N2 is N - 2, lucas(N1, L1), lucas(N2, L2), X is L2 + L1.
% keep branching into 2 nodes until they reach the base case N==0 or N==1.
% then backtracking from the binary tree at the same time compute X is K + J.

