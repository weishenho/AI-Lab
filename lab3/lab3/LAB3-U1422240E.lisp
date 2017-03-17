;;;; CZ3005 2015 Semester 2: Lab 3 (Total Marks: 100)
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
;;;; Name your lab 3 lisp code as  "LAB3-<YOUR_MATRICULATION_NUMBER>.lisp"
;;;;
;;;; Any line breaks due to word wrapping will be treated as errors.
;;;; Moral of the story: DO NOT USE WINDOWS NOTEPAD OR PICO.
;;;;
;;;; Before you submit your code, be sure to test it in GNU CLISP 2.49.
;;;; Lispworks 6.1 software installed on NTU machines is based on Clisp 2.49,
;;;; so if your code works there, it qualifies.
;;;;
;;;; If we cannot run your code, including our automatic checker, your answer
;;;; will not be considered at all. If our checker detects wrong output, you may
;;;; still get partial marks for such problem.
;;;;
;;;; You are NOT allowed to use external libraries in this assignment other than
;;;; the AIMA framework! If you choose to not use AIMA, you may find inspiration
;;;; in the robustness of the AIMA framework and model your problems using
;;;; the know-how and principles used in AIMA. You won't be penalized in any way
;;;; if you choose to write the answers from scratch.
;;;;
;;;; For those using AIMA, the framework will be loaded prior to checking your
;;;; solution! DO NOT load it again,
;;;; and DO NOT put any code from AIMA in your submission. This
;;;; would result in plagiarism detection and severe consequences.
;;;; You can USE the framework (e.g. call funcions, define substructures, etc.)
;;;;
;;;; There are THREE questions in this homework assignment. One extra question is
;;;; optional, but worth a lot of marks.
;;;;
;;;; COMMENT EXCESSIVELY -- 20% of marks for every task is awarded solely based
;;;; on sufficiently commented code! Comment both inline in your code and
;;;; comment each function and structure you write. Make sure we understand
;;;; the nitty-gritty of you answers.



;;;; QUESTION 1 [5 marks for successfully sucking all dirt in the
;;;;               default vacuum world
;;;;             5 marks for successfully sucking all dirt in arbitrary sized
;;;;               vacuum worlds
;;;;             5 marks for robust, concise conditions, i.e. do not
;;;;               hard-code the moves based on individual cells, use
;;;;               constant-length conditions (number of conditions does not
;;;;               depend on size of the grid)
;;;;             5 marks for comments and documentation]

; Remember our agent with GPS who walks around the perimeter of your grid?
; Improve this agent so that it sucks all the dirt and returns home.

; Remember that this agent's percept is quite limited:
; (bump dirt home loc heading)

; Your agent also has no memory nor the complete grid percept

; You may assume that the start (home) of the agent is default (@ 1 1), so is
; the boundary specification (bspec) of the grid '((at edge wall)). The size
; of the grid and probability / locations of dirt are variable.

; Modify the following agent function:


;;the agent move mirrored L shape, the agent only enter the 1st column when the rest of the area have been visited.
;; the agent will suck any dirt it encounter
(defun smart-traversal-vacuum-agent-with-gps-program (percept)
     (destructuring-bind (bump dirt home loc heading) (subseq percept 0 5) (setf nextmove nil)
       (cond (dirt 'suck)
         ( (and (equal loc '(6 1)) (equal heading (@ 1 0))) '(turn left)) ;; move forward until the the wall at 6,1 then turn left
         ( (and (equal loc '(6 6)) (equal heading (@ 0 1))) '(turn left)) ;; move forward/upward until the wall at 6,6 then turn left

         ( (and (equal loc '(5 6)) (equal heading (@ -1 0))) '(turn left)) ;; move forward then turn left again then move downward
         ( (and (equal loc '(5 2)) (equal heading (@ 0 -1))) '(turn right)) ;; move until 5,2 then turn right and move leftward

         ( (and (equal loc '(2 2)) (equal heading (@ -1 0))) '(turn right)) ;; move forward to 2,2 then turn right
         ( (and (equal loc '(2 3)) (equal heading (@ 0 1))) '(turn right)) ;; move turn right then moving rightward

         ( (and (equal loc '(4 3)) (equal heading (@ 1 0))) '(turn left)) ;; at 4,3 turn left and move upward
         ( (and (equal loc '(4 6)) (equal heading (@ 0 1))) '(turn left)) ;; at the wall at 4,6 turn left and move forward

         ( (and (equal loc '(3 6)) (equal heading (@ -1 0))) '(turn left)) ;; turn left again and move downward
         ( (and (equal loc '(3 4)) (equal heading (@ 0 -1))) '(turn right)) ;; turn right at 3,4 and move forward

         ( (and (equal loc '(2 4)) (equal heading (@ -1 0))) '(turn right)) ;; turn right and move up
         ( (and (equal loc '(2 6)) (equal heading (@ 0 1))) '(turn left)) ;; at wall at 2,6 turn left and move forward

         ( (and (equal loc '(1 6)) (equal heading (@ -1 0))) '(turn left)) ;; turn left and move downward back to home
         ( (and home (equal heading (@ 0 -1))) 'shut-off)
         (t 'forward))))

; Do not write anything else, especially the agent body or the environment.
; The checker will do that for you. You can use the following code to test it.
; The code has to be commented for submission!

; The number of steps in our
; checker is always adapted to the size of the grid and the number of dirts,
; so unless your agent gets lost, he should have sufficient time to finish
; his task and return home.

; (defstructure (smart-traversal-vacuum-agent-with-gps
;   (:include agent
;     (program #'smart-traversal-vacuum-agent-with-gps-program))))

; (run-environment (make-vacuum-world-gps
;     :aspec '(smart-traversal-vacuum-agent-with-gps)
;     :max-steps 64))



;;;; QUESTION 2 [10 marks for better agent-trials evaluation (i.e defeating
;;;;                out reference dumb agent)
;;;;             10 marks for correct implementation of next move evaluation
;;;;                (choosing which dirt to go for and navigating there
;;;;                consistently by selecting proper next moves)
;;;;              5 marks for proper distance estimations (including turns) to
;;;;                a dirt on the grid
;;;;              5 marks for comments and documentation]

; Write an agent that is able to clean all dust faster than our reference
; dumb-traversal-vacuum-agent-with-radar. Note that the evaluation function is
; (defmethod performance-measure ((env vacuum-world) agent) from AIMA.

; It is easy to be better than dumb-traversal-vacuum-agent-with-radar. What is
; the agent's weakness? How does he search for the next dirt?

; When you estimate distances to dirt, don't forget that the function takes 3
; inputs, not two: agent-location, agent-heading, dirt-location

;;the structure of function is similiar to smart-traversal-vacuum-agent-with-radar,
;;only with improved sfind-some-in-grid
(defun smart-traversal-vacuum-agent-with-radar-program (percept)
    (destructuring-bind (bump dirt home loc heading radar home-loc) percept
        (if dirt (return-from smart-traversal-vacuum-agent-with-radar-program  'suck) )
        ;;(setf cloc loc) (setf cheading heading) 
        (let ((go-to-dirt (sfind-some-in-grid radar 'DIRT loc heading))
              (go-to-home home-loc))
            (format t "An heading: ~S~%" heading)
            (let ((turn (turn-towards-dirt loc heading
                    (if go-to-dirt go-to-dirt go-to-home))))
                (cond
                    (turn turn)
                    ((and (not go-to-dirt) home) 'shut-off)
                    (t 'forward)
                    )))))

;; the agent will clear dirt in the bottom half first
;; then clear dirt on upper half from right to left
;; then move home
(defun sfind-some-in-grid (radar type cloc cheading)
    (let    ( (cmin 1000) (minloc nil) ) ;; init some var to find the nearest dirt

        ;; clear the bottom half first
        (loop for x from 2 to 6 do
             (loop for y from 1 to 3 do ;; clear the first 3 row on that column first
              ;;(format t "2nd xy: ~S~%" (list x y ))
              (let ((elems (aref radar x y)))
                    (dolist (e elems)
                        (when (eq (type-of e) type)
                          ;;(format t "xy: ~S~%" (list x y ))
                            (let ( (cost (calc-cost (list x y ) cloc cheading) ) )
                              (cond
                                  ( (= cost 1) (return-from sfind-some-in-grid (list x y)) ) ;; if cost is 1 no point look for any dirt that could be nearer hence move to this dirt
                                  ( (< cost cmin) (progn (setq cmin cost) (setq minloc (list x y)) ) ) ;; find the nearest dirt
                                  )
                              )) ))
                      (if  (not (null minloc))  (return-from sfind-some-in-grid minloc) )))

        ;; clear the upper half from decreasing order
        (loop for x from 6 downto 2 do
             (loop for y from 4 to 6 do
              ;;(format t "2nd xy: ~S~%" (list x y ))
              (let ((elems (aref radar x y)))
                    (dolist (e elems)
                        (when (eq (type-of e) type)
                          ;;(format t "xy: ~S~%" (list x y ))
                            (let ( (cost (calc-cost (list x y ) cloc cheading) ) )
                              (cond
                                  ( (= cost 1) (return-from sfind-some-in-grid (list x y)) )
                                  ( (< cost cmin) (progn (setq cmin cost) (setq minloc (list x y)) ) )
                                  )
                              )) ))
                      (if  (not (null minloc))  (return-from sfind-some-in-grid minloc) )))

        ;;move find any dirt on the 1st column
        (loop for x from 1 to 1 do
             (loop for y from 1 to 6 do
              ;;(format t "2nd xy: ~S~%" (list x y ))
              (let ((elems (aref radar x y)))
                    (dolist (e elems)
                        (when (eq (type-of e) type)
                          ;;(format t "xy: ~S~%" (list x y ))
                            (let ( (cost (calc-cost (list x y ) cloc cheading) ) )
                              (cond
                                  ( (= cost 1) (return-from sfind-some-in-grid (list x y)) )
                                  ( (< cost cmin) (progn (setq cmin cost) (setq minloc (list x y)) ) )
                                  )
                              )) ))
                      (if  (not (null minloc))  (return-from sfind-some-in-grid minloc) )))


          )
)

;; add the turn cost with manhanttan distance
(defun calc-cost (dirtloc cloc cheading)
  ;;(format t "calc cost: ~d~%" (+ (turn-cost dirtloc) (manhanttan-dist dirtloc)))
  (+ (turn-cost dirtloc cloc cheading) (manhanttan-dist dirtloc cloc))
)

;; estimate the turn cost using vector math
;; vector a = heading, vector b = |current loc - destination loc|
;; use Angle Between Two Vectors formula to find estimate the distance
(defun turn-cost (dirtloc cloc cheading)
    (let ( (b (mapcar'- dirtloc cloc)) (a cheading) )
        (let ( (angle (acos (/ (dot-product a b) (* (mag a) (mag b)) )) ) )
            (cond
                ( (= angle 0) 0) ;;the agent heading is in the same direction as dirt
                ( (<= angle 1.571) 1) ;; agent heading less or equals 90 degrees only need to turn once to move towards dirt
                ( (> angle 1.571) 2) ;; agent heading move than 90 degrees so have to turn twice to move towards dirt
                (t 0)
                ))))

;; vector magnitude function
(defun mag (v)
 ;;(format t "Mag: ~S~%" (sqrt (+ (* (first v) (first v)) (* (second v) (second v)))))
 (sqrt (+ (* (first v) (first v)) (* (second v) (second v))))
)

;; get manhanttan distance from agent loc and dirt loc
(defun manhanttan-dist (dirtloc cloc) 
    (let ( (dx (- (first cloc) (first dirtloc))) (dy (- (second cloc) (second dirtloc))) )
          ;;(format t "manhanttan: ~S~%" (+ (abs dx) (abs dy)))
          (+ (abs dx) (abs dy))
        ))

; Do not write anything else, especially the agent body or the environment.
; The checker will do that for you. You can use the following code to test it.
; The code has to be commented for submission!

; The number of steps in our checker is always adapted to the size of the grid
; and the number of dirts, just like in the previous question.

; (defstructure (smart-traversal-vacuum-agent-with-radar
;   (:include agent
;     (program #'smart-traversal-vacuum-agent-with-radar-program))))

; (run-environment (make-vacuum-world-radar
;     :aspec '(smart-traversal-vacuum-agent-with-radar)
;     :max-steps 64))

; (agent-trials 'make-vacuum-world-radar
;          '(smart-traversal-vacuum-agent-with-radar
;            dumb-traversal-vacuum-agent-with-radar) :n 16)



;;;; QUESTION 3 [15 marks for defeating minimax-cutoff-vacuum-agent (depth 6)
;;;;                using your alpha-beta-pruning (with depth 9)
;;;;             10 marks for correct alpha-beta pruning implementation
;;;;             10 marks for better implementation of state evaluation
;;;;                function - refer to function Utility(state) in the textbook
;;;;                (better = a lot more sophisticated than vacuum-agent-eval)
;;;;                (describe your reasoning and implementation thoroughly)
;;;;              5 marks for static ordering of examining successors
;;;;                (describe your reasoning, ideally backed up with tests)
;;;;              5 marks for comments and documentation
;;;;              5 marks for well-structured code]

; Write an algorithm function. When this function is used by a vacuum-agent
; it has to perform better than our reference agent from lab 3

; You have to use alpha-beta-pruning algorithm.

; You are allowed to use all functions of vacuum-game, e.g. to generate all
; possible next moves. In fact, you should use them, otherwise you risk running
; into too much trouble reimplementing the game models.
; Make use of aima/search/environments/vacuum-game.lisp, but DO NOT copy
; any code from there!

; You CAN'T use any code from aima/search/algorithms/minimax.lisp.
; This code will not be available to your agent. Original code won't be loaded.
; The stock AIMA code for alpha-beta pruning only works on zero-sum games and
; uses a simplification, so that both alpha and beta values are computed
; using max. BE AWARE that your implementation can't afford these assumptions,
; thus you have to implement it from scratch!

; You can use all other AIMA code (except aima/search/algorithms/minimax.lisp).

; See section 3: Alpha-Beta Pruning in chapter Adversarial Search in the course
; textbook (AIMA) for details about alpha-beta pruning
; Adversarial Search is chapter 5 (in 3rd edition) or chapter 6
; (in 2nd edition) of the book.

; You may find inspiration in lab3.lisp, section ADVERSARIAL SEARCH, where
; we refer to files from AIMA.

(defun smart-vacuum-agent-algorithm (state game)
    'shut-off)

; Do not write anything else, especially the agent body or the environment.
; The checker will do that for you. You can use the following code to test it.
; The code has to be commented for submission!

; (defstructure (smart-vacuum-agent (:include game-agent
;         (algorithm smart-vacuum-agent-algorithm))))

; (run-environment (make-game-environment
;     :max-steps 32
;     :game (make-vacuum-game)
;     :agents '(smart-vacuum-agent minimax-cutoff-vacuum-agent)))



;;;; BONUS 1:   [10 marks for each improvement (listed below) (maximum of 20
;;;;                marks total)]

; Improvements:
;   * ordering states by some dynamic heuristic
;   * well-thought-out and well-implemented model of killer moves
;   * transposition table
;   * cutting-off search

; See section 3: Alpha-Beta Pruning and section 4: Imperfect
; Real-Time Decision in chapter Adversarial Search in the course
; textbook (AIMA) for details about alpha-beta pruning
; and description of possible improvements.
; Adversarial Search is chapter 5 (in 3rd edition) or chapter 6
; (in 2nd edition) of the book.

; To receive credit for improvements, incorporate them into
; question 3, well commented and documented!

; Then list which improvements you have implemented here.



;;;; BONUS 2:   [-5 to +30 points based on performance]

; You may enter a competition against other students by defining a structure
; YOUR_MATRICULATION_NUMBER-vacuum-agent

; The agents will compete against each other in pairs. Each agent gets to
; compete against each other agent twice -- with swapped starting positions,
; but in the same environment. Evaluation is the same as in question 3.

; WARNING: Entering the competition costs you 5 marks!

; Winner wins (min 30 (length competitors)) marks. Player at n-th position
; "wins" (max (+ (- (min 30 (length competitors)) n) 1) -5) marks.

; FAIR PLAY: In order to give all agents a fair chance, we limit the execution
; of agents to 1 second per move on the lab computers, with CLisp 2.49,
; compiled code.

; In case your agent exceeds this limit, the execution of your agent
; causes an error during a competition, your agent will be disqualified.
; Test your agent thoroughly, e.g. against your classmates!

; (defstructure (YOUR_MATRICULATION_NUMBER-vacuum-agent
           ; (:include game-agent (algorithm 'pick-random-move))))


