	%%%% CZ3005 2015 Semester 2: Lab 4 (Total Marks: 100)
%%%%
%%%% Due two weeks from the lab.
%%%%
%%%% Submission procedure will be announced during the lecture or the
%%%% lab session.
%%%%
%%%% This file is a loadable Prolog file.  You are to modify this file and
%%%% add your answers.  Then CHECK TO MAKE SURE that the file still loads
%%%% properly into the Prolog system. You will be penalized in case the file
%%%% is not loadable.
%%%%
%%%% Name your lab 5 Prolog code as  "LAB5-<YOUR_MATRICULATION_NUMBER>.pl"
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
%%%% No synopsis and outlines are given for any question. You have to figure out the format of the
%%%% predicates yourself.
%%%%
%%%% COMMENT EXCESSIVELY -- In Prolog, the code is usually very concise. It is very
%%%% important that you comment everything. In most of the programming questions, up to
%%%% 50% of the marks is awarded for comments!


%%%% QUESTION 1     [ 20 marks (10 marks for each task) ]

%% Anyone who goes to consultations or works smart can finish all his assignments. Anyone who works
%% smart maintains his mental health. Anyone who finished the third assignment of CZ3005 and
%% maintains his mental health is a mastermind. Quek Jr. did not go to consultations, but he works
%% smart.

%% Convert these sentences into first order logic (like you did in the tutorial). Note you may use
%% textual representation, such as: forall students exists student such that ...

%% forall person x, consultations(x) v works_smart(x) -> finish_assignments(x)
%% forall person x, works_smart(x) -> mental_health(x)
%% forall person x, third_assignment(x) ^ mental_health(x) -> mastermind(x)
%% not( consultations(Quek Jr.) ) ^ works_smart(Quek Jr.)
%%
%% not( consultations(Quek Jr.) ) 
%% works_smart(Quek Jr.)


%% Use Prolog to prove or disprove this:
%%     Quek Jr. is a mastermind

%% WRITE YOUR CODE AND COMMENTS BELOW THIS LINE:





%%%% QUESTION 2     [ 20 marks (10 marks for each task) ]

%% If the unicorn is mythical, then it's immortal, but if it is not mythical, then it is a mortal
%% mammal. If the unicorn is either immortal or a mammal, then it is horned. The unicorn is magical
%% if it is horned.
 
%% Convert these sentences into first order logic.
%% forall unicorn x, if x is mythical then x is immortal.
%% forall unicorn x, if x is not mythical then x is a mortal.
%% forall unicorn X, if X is immortal or mammal x it is horned
%% forall unicorn x, if x is horned then x is magical.

%% Use Prolog to find answers (or find that we cannot give an answer) for the following:

%%     Is the unicorn mythical?
%%     Is the unicorn magical?
%%     Is the unicorn horned?

%% WRITE YOUR CODE AND COMMENTS BELOW THIS LINE:

immortal(X)     :-      mythical(X).
mammal(X)       :-      \+ mythical(X).
horned(X)       :-      immortal(X);mammal(X).
magical(X)      :-      horned(X).
mythical(X) :- fail.




%%%% QUESTION 3     [ 20 marks (10 for correctness, 10 for comments) ]

%% Consult file logical-gates.pl. It contains predicates for a few basic logical gates.
%% Consult http://www.tutorialspoint.com/computer_logical_organization/combinational_circuits.htm
%% Your task is to write predicates for more sophisticated logical gates.

%% Write predicates for:

%%     4-bit full added
%%     4-bit full subtractor
%%     4-bit priority encoder (4th input variable has highest priority)

%% WRITE YOUR CODE AND COMMENTS BELOW THIS LINE:




%%%% QUESTION 4     [ 40 marks (20 for working solution and correct answers, 20 for comments) ]

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

%% * There are 5 frogs living in ponds on NTU campus.
%% * The ponds are laid out in a circular shape (cycle graph), first pond is on the north, second
%%   on the east, third on the south-east, fourth on the south-west, fifth on the west.
%% * Each pond has different trees growing around it.
%% * Each frog owns its own pond.
%% * Each frog graduated from different school at NTU.
%% * Each frog listens to different genre of music.
%% * Each frog drinks different beer.
%%
%% * Frog that drinks Tsingtao beer lives adjacent to frog that listens to punk.
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
%% * The largest living frog on Earth is the goliath frog (Conraua goliath) :-).


%% THE QUESTIONS:

%% How many different frogs can possibly live in the palm pond?  Which frogs are those?

%% How many different combinations (pond X trees surrounding ponds X beer type X music genre X alma
%% mater) are there in total? What are they?


%% WRITE YOUR CODE AND COMMENTS BELOW THIS LINE:

