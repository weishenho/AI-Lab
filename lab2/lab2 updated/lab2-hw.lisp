;;;; CZ3005 2015 Semester 2: Lab 2 (Total Marks: 100)
;;;;
;;;; Due two weeks from the lab.
;;;;
;;;; Submission procedure will be announced during the lecture or the
;;;; lab session.
;;;;
;;;; This file is a loadable Lisp file.  You are to modify this file and
;;;; add your answers.  Then CHECK TO MAKE SURE that the file still loads
;;;; properly into the Lisp system.
;;;;
;;;; Name your lab 2 lisp code as  "LAB2-<YOUR_MATRICULATION_NUMBER>.lisp"
;;;;
;;;; Any line breaks due to word wrapping will be treated as errors.
;;;; Moral of the story: DO NOT USE WINDOWS NOTEPAD OR PICO.
;;;;
;;;; Before you submit your code, be sure to test it in GNU CLISP 2.49.
;;;; Lispworks 6.1 software installed on NTU machines is based on Clisp 2.49,
;;;; so if your code works there, it qualifies.
;;;;
;;;; If our checker detects wrong output, you may still get partial marks for
;;;; such problem. If we cannot run your code, including our automatic checker,
;;;; you cannot get marks for correct answer.
;;;;
;;;; You are NOT allowed to use external libraries in this assignment other than
;;;; the AIMA framework! If you choose to not use AIMA, you may find inspiration
;;;; in the robustness of the AIMA framework and model your problems using
;;;; the know-how and principles used in AIMA. You won't be penalized in any way
;;;; if you choose to write the answers from scratch.
;;;;
;;;; For those using AIMA, the framework will be loaded prior to checking your
;;;; solution! DO NOT load it again,
;;;; and DO NOT include any AIMA functions or code in your submission. This
;;;; would result in plagiarism detection and severe consequences.
;;;;
;;;; There are TWO questions in this homework assignment. Function definitions
;;;; of functions that will be checked are provided.
;;;;
;;;; COMMENT EXCESSIVELY -- 20% of marks for every task is awarded solely based
;;;; on sufficiently commented code! Comment both inline in your code and
;;;; comment each function and structure you write. Make sure we understand
;;;; the nitty-gritty of you answers.



;;;; INTRO

; The knight's tour problem is a problem of finding a sequence of moves of
; a knight on a chessboard such that the knight must not step on the same
; square more than once and the knight visits all the squares of the
; chessboard.

; See https://en.wikipedia.org/wiki/Knight%27s_tour for details



;;;; QUESTION 1 [70 marks total:
;;;;             10 marks for correct state representation
;;;;             10 marks for correct successor state generation
;;;;              5 marks for final state detection / validation
;;;;              5 marks for detection of nonexistence of any solution
;;;;             15 marks for correct results
;;;;              5 marks for more effective detection of visited states
;;;;                (constant time, check for visited states not by
;;;;                 iteration through a list of all positions visited)
;;;;              5 marks for more effective final / solution state detection
;;;;                (constant time, i.e. no length or list-length)
;;;;             10 marks for comments and documentation
;;;;              5 marks for well-structured code]

; On a MxN chessboard, given the initial coordinates, find one open
; knight's tour. Start with 5x5 chessboard. Note that there are no closed
; knight's tours on 5x5 chessboard.

; Use a depth first search with backtracking, i.e. in every step,
; visit all the available squares (that have not been visited in any previous
; step). You have to be able to effectively generate the successor states
; and check for already visited states.
; Do not use naive brute force algorithm that generates all possible
; sequences of M*N positions - including invalid knight's moves or visiting
; previously visited states.
; Note that it is possible to use brute force algorithm that does not check
; for revisiting states, but generates paths according to the knight's
; moves, which are then filtered. However, such algorithm is too slow.

; The input to your function is a list with four integers, indicating the
; starting position of the tour and the size of the chessboard.
; Coordinates range from 1 to M, resp 1 to N.

; The output is a list of length M*N consisting of cons cells,
; indicating the position on a chessboard visited by the knight. The first
; position is identical to (x y) from the input.
; Please note that the output is not a list of lists of length 2!
; In case there is no solution, return nil or empty list ().

; Example:
;     (knights-tour-backtracking (1 1 5 5)) -> ((1 . 1) (3 . 2) (5 . 1) ... )

; You are allowed to add any number of functions into this file, as the whole
; file will be loaded, but only the knights-tour-backtracking function will be
; checked for correctness. If the correctness check passes, the whole code will
; be checked for correct use of backtracking method.

; All code in this assignment has to be your own. No external library is
; allowed (except for AIMA).

; Test it on 5x5 chessboard, optionally on 6x6, 7x7 and 8x8 chessboard.
; Please comment out any excessive calls you used for debugging or testing.

;;check if a move is possible
(defun check-move (x y)
;; check if a move is not outside the board and the move is not part of solution path yet
(and (<= 1 x) (<= x h) (<= 1 y) (<= y w) (find-item-list (cons x y) sollist) ))

(defun find-item-list (item lis)
(loop for elem in lis
	do (if (equal elem item) (return-from find-item-list nil)))
(return-from find-item-list t)
)

;;Execute DFS to find a path to a solution
(defun find-solution-with-DFS (x y)
(if (check-move x y) ;;check if a move is possible then proceed to make that move
(progn 
(incf moves) ;; increment the number of moves
(setf sollist (push (cons x y) sollist) );; add knight's position to solution path

(loop for elem in (mapcar (lambda (offx offy) (list (+ x offx) (+ y offy))) offsetx offsety)
      do (if (= totalmoves moves) (return-from find-solution-with-DFS) (find-solution-with-DFS (first elem) (second elem))))

(if (= totalmoves moves) (return-from find-solution-with-DFS))
;;backtrack if reach a dead end
(decf moves) ;;decrement the number of moves
(pop sollist);;remove last position on the solution path
)))


;;initialize the some variables and find a solution base of the positon given by x and y
(defun knights-tour-backtracking (x y m n)
(setq h m) ;;board's height
(setq w n) ;;board's width
(setq totalmoves (* h w)) ;;the totalmoves possible and also the goal
(setq moves 0) ;;initalize number of moves taken to 0
;;These offsets are to find the possible moves relative to the knight's position
(setf offsetx (list +2 +2 -1 +1 +1 -1 -2 -2))
(setf offsety (list +1 -1 +2 +2 -2 -2 +1 -1))
(setf sollist (list)) ;;initalize the solution path
(find-solution-with-DFS x y)
;;check if we have reach the goal, if the no. of moves is the no. of squares on the board else Fail
(if (= totalmoves moves) (return-from knights-tour-backtracking (reverse sollist))  (print "Can't Find a Solution") ))



;;;; QUESTION 2 [30 marks total:
;;;;              5 marks for correct Warnsdorff's heuristic implementation
;;;;             10 marks for correct results
;;;;              5 marks for effective implementation of the heuristic
;;;;                (constant time evaluation instead of generating set of
;;;;                 neighbors for each of the successor states and then
;;;;                 computing the length of the list of successor states)
;;;;              5 marks for comments and documentation
;;;;              5 marks for well-structured code
;;;;                (i.e. high code reuse from question 1)]

; Since backtracking approach is not very effective, we have to use something
; more sophisticated. A greedy best-first search with Warnsdorff's heuristic
; seems like a significantly better approach.

; Warnsdorff's heuristic evaluates moves based on the number of available
; squares for the next move. Applying this heuristic to our greedy best-first
; search, we will always choose the move with the lowest number of subsequent
; moves from that square. Resolution of ties is not specified, you may choose
; randomly.

; You are again allowed to add any number of functions, but only the
; knights-tour-greedy function will be checked for correctness. If the
; correctness check passes, the whole code will be checked for correct
; use of greedy best-first search method.

; All code in this assignment has to be your own. No external library is
; allowed.

; Input and output formats remain the same.

; Test it on 8x8 chessboard, optionally on larger chessboards.
; Please comment out any excessive calls you used for debugging or testing.

(defun knights-tour-greedy (x y m n) nil)



;;;; BONUS: [Additional up 15 points for better tie resolution]

; If you try your own heuristic for tie resolution, please describe thoroughly
; how it works.

; Or you can use an existing one. For example:
; http://slac.stanford.edu/pubs/slacpubs/0250/slac-pub-0261.pdf
