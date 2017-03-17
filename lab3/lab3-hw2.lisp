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



;;;; QUESTION 1 [20 marks]

; Remember our agent with GPS who walks around the perimeter of your grid?
; Improve this agent so that it sucks all the dirt and returns home.

; Remember that this agent's percept is quite limited:
; (bump dirt home loc heading)

; Your agent also has no memory nor the complete grid percept

; Modify the following agent function:

(defun smart-traversal-vacuum-agent-with-gps-program (percept)
     (destructuring-bind (bump dirt home loc heading) percept
       'shut-off))

; Do not write anything else, especially the agent body or the environment.
; The checker will do that for you. You can use the following code to test it.
; The code has to be commented for submission!

 (defstructure (smart-traversal-vacuum-agent-with-gps
   (:include agent
     (program #'smart-traversal-vacuum-agent-with-gps-program))))

 (run-environment (make-vacuum-world-gps
     :aspec '(smart-traversal-vacuum-agent-with-gps)
     :max-steps 64))



;;;; QUESTION 2 [10 marks for better agent-trials evaluation (i.e defeating
;;;;                out reference dumb agent)
;;;;             10 marks for proper distance estimations including turns
;;;;             10 marks for full problem space search, i.e. optimal trajectory]

; Write an agent that is able to clean all dust faster than our reference
; dumb-traversal-vacuum-agent-with-radar. Note that the evaluation function is
; (defmethod performance-measure ((env vacuum-world) agent) from AIMA.

; It is easy to be better than dumb-traversal-vacuum-agent-with-radar. What is
; the agent's weakness? How does he search for the next dirt?

; When you estimate distances to dirt, don't forget that the function takes 3
; inputs, not two: agent-location, agent-heading, dirt-location

; To search the whole problem space, you should think through how you are going
; to model the states of your agent.

; First make sure you agent fulfills the first task, then improve it for
; extra marks.

(defstructure (vacuum-world-gps (:include vacuum-world)))


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



(defun turn-towards-dirt (loc heading go-to-dirt)
    (let ((vdiff (- (first go-to-dirt) (first loc)))
          (hdiff (if (= (- (first go-to-dirt) (first loc)) 0) (- (second go-to-dirt) (second loc)) 0))
          (vheading (first heading))
          (hheading (second heading)))
        (let ((vdiffn (if (= vdiff 0) 0 (/ vdiff (abs vdiff))))
              (hdiffn (if (= hdiff 0) 0 (/ hdiff (abs hdiff)))))
            (let ((cprodz
                (-  (* vdiffn hheading)
                    (* hdiffn vheading))))
                ; (format t "~%loc: ~A, heading: ~A, go-to-dirt: ~A, cprodz: ~A, diffn: ~A ~A ~%" loc heading go-to-dirt cprodz vdiffn hdiffn)
                (cond
                    ((or (= (abs (- vdiffn vheading)) 2)
                        (= (abs (- hdiffn hheading)) 2)) '(turn right))
                    ((> cprodz 0) '(turn right))
                    ((< cprodz 0) '(turn left))
                    (t nil))))))


(defun sfind-some-in-grid (radar type)
    (let    (  (que (make-q)) )
      (setf cmin 1000) (setf minloc nil)
        (dotimes (x (car (array-dimensions radar)))
            (dotimes (y (/ (cadr (array-dimensions radar)) 2))
                (let ((elems (aref radar x y)))
                    (dolist (e elems)
                        (when (eq (type-of e) type)
                          (format t "xy: ~S~%" (list x y ))
                            (let ( (cost (calc-cost (list x y )) ) )
                              (cond
                                  ( (= cost 1) (return-from sfind-some-in-grid (list x y)) )
                                  ( (< cost cmin) (progn (setf cmin cost) (setf minloc (list x y)) ) )
                                  )
                              )

                             ) ) nil)))
        (if  (not (null minloc))  (return-from sfind-some-in-grid minloc) )

        (loop for x from 1 to 6 do
             (loop for y from 4 to 6 do
              (format t "2nd xy: ~S~%" (list x y ))
              (let ((elems (aref radar x y)))
                    (dolist (e elems)
                        (when (eq (type-of e) type)
                          (format t "xy: ~S~%" (list x y ))
                            (let ( (cost (calc-cost (list x y )) ) )
                              (cond
                                  ( (= cost 1) (return-from sfind-some-in-grid (list x y)) )
                                  ( (< cost cmin) (progn (setf cmin cost) (setf minloc (list x y)) ) )
                                  )
                              )) ))
              ))
        (if  (not (null minloc))  (return-from sfind-some-in-grid minloc) )
          
          )
)

(defun sfind-some-in-grid (radar type cloc cheading)
    (let    (  (que (make-q)) (cmin 1000) (minloc nil) )
        (loop for x from 2 to 6 do
             (loop for y from 1 to 3 do
              ;;(format t "2nd xy: ~S~%" (list x y ))
              (let ((elems (aref radar x y)))
                    (dolist (e elems)
                        (when (eq (type-of e) type)
                          (format t "xy: ~S~%" (list x y ))
                            (let ( (cost (calc-cost (list x y ) cloc cheading) ) )
                              (cond
                                  ( (= cost 1) (return-from sfind-some-in-grid (list x y)) )
                                  ( (< cost cmin) (progn (setq cmin cost) (setq minloc (list x y)) ) )
                                  )
                              )) ))
                      (if  (not (null minloc))  (return-from sfind-some-in-grid minloc) )))

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



(defun calc-cost (dirtloc cloc cheading)
  ;;(format t "calc cost: ~d~%" (+ (turn-cost dirtloc) (manhanttan-dist dirtloc)))
  (+ (turn-cost dirtloc cloc cheading) (manhanttan-dist dirtloc cloc))
)

(defun turn-cost (dirtloc cloc cheading)
    (let ( (b (mapcar'- dirtloc cloc)) (a cheading) )
        (let ( (angle (acos (/ (dot-product a b) (* (mag a) (mag b)) )) ) )
            (cond
                ( (= angle 0) 0)
                ( (<= angle 1.571) 1)
                ( (> angle 1.571) 2)
                (t 0)
                ))))

(defun mag (v)
 ;;(format t "Mag: ~S~%" (sqrt (+ (* (first v) (first v)) (* (second v) (second v)))))
 (sqrt (+ (* (first v) (first v)) (* (second v) (second v))))
)


(defun manhanttan-dist (dirtloc cloc) 
    (let ( (dx (- (first cloc) (first dirtloc))) (dy (- (second cloc) (second dirtloc))) )
          (format t "manhanttan: ~S~%" (+ (abs dx) (abs dy)))
          (+ (abs dx) (abs dy))
        ))

; Do not write anything else, especially the agent body or the environment.
; The checker will do that for you. You can use the following code to test it.
; The code has to be commented for submission!

(defstructure (vacuum-world-gps (:include vacuum-world)))

; get information ; 2 perecept location and home
(defmethod get-percept ((env vacuum-world-gps) agent)
  (let ((loc (object-loc (agent-body agent)))
        (heading (object-heading (agent-body agent))))
    (append (call-next-method) (list loc heading))))

(defstructure (vacuum-world-radar (:include vacuum-world-gps)))

(defstructure (home (:include object (name "H") (size 0.01))))

(defmethod get-percept ((env vacuum-world-radar) agent)
  (let ((grid (copy-array (vacuum-world-grid env)))
        (home (grid-environment-start env)))
    (append (call-next-method) (list grid (grid-environment-start env)))))

 (defstructure (smart-traversal-vacuum-agent-with-radar
   (:include agent
     (program #'smart-traversal-vacuum-agent-with-radar-program))))



;;run agent
 (run-environment (make-vacuum-world-radar
     :aspec '(smart-traversal-vacuum-agent-with-radar)
     :max-steps 64))

 (run-environment (make-vacuum-world-radar
     :aspec '(dumb-traversal-vacuum-agent-with-radar)
     :max-steps 64))


 (agent-trials 'make-vacuum-world-radar
          '(smart-traversal-vacuum-agent-with-radar
            dumb-traversal-vacuum-agent-with-radar) :n 16)


(defstructure (dumb-traversal-vacuum-agent-with-radar
  (:include agent
    (program #'dumb-traversal-vacuum-agent-with-radar-program))))

(defun dumb-traversal-vacuum-agent-with-radar-program (percept)
    (destructuring-bind (bump dirt home loc heading radar home-loc) percept
        (let ((go-to-dirt (find-some-in-grid radar 'DIRT))
              (go-to-home home-loc))
            (let ((turn (turn-towards-dirt loc heading
                    (if go-to-dirt go-to-dirt go-to-home))))
                (cond
                    (turn turn)
                    (dirt 'suck)
                    ((and (not go-to-dirt) home) 'shut-off)
                    (t 'forward)
                    )))))

(defun find-some-in-grid (radar type)
    (dotimes (x (car (array-dimensions radar)))
        (dotimes (y (cadr (array-dimensions radar)))
            (let ((elems (aref radar x y)))
                (dolist (e elems)
                    (when (eq (type-of e) type)
                        (return-from find-some-in-grid (list x y)))) nil))))


;;;; QUESTION 3 [10 marks for defeating minimax-cutoff-vacuum-agent (limit 3)
;;;;             10 marks for defeating alpha-beta-vacuum-agent (limit 5)
;;;;             10 marks for cutting off search with
;;;;                proper / sophisticated state evaluation function
;;;;             10 marks for 1 improvement (listed below)
;;;;             10 marks for 1 additional improvement ]
;;;;
;;;;             Improvements:
;;;;               * randomized ordering of states
;;;;               * ordering states by some heuristic
;;;;               * well-thought-out and well-implemented model of killer moves
;;;;               * transposition table
;;;;			   * cutting-off search
;;;;			   * forward pruning
;;;;
;;;;		     See section 3: Alpha-Beta Pruning and section 4: Imperfect
;;;;   			 Real-Time Decision in chapter Adversarial Search in the course
;;;;			 textbook (AIMA) for details of the improvements.
;;;;			 Adversarial Search is chapter 5 (in 3rd edition) or chapter 6
;;;;			 (in 2nd edition) of the book.


; Write an algorithm function. When this function is used by a vacuum-agent
; it has to perform better than our reference agents from lab 3

; You are allowed to use all functions of vacuum-game, e.g. to generate all
; possible next moves. In fact, you should use them, otherwise you risk running
; into too much trouble reimplementing the game models.

; You have to use alpha-beta-pruning algorithm.

; The evaluation function and improvements have to be well documented and the code
; especially-well commented and understandable. If you do not describe thoroughly
; how the improvements and the related code work, we'll assume you have not
; implemented them at all.

; You CAN'T use any code from aima/search/algorithms/minimax.lisp. This code will
; not be available to your agent. Original code will be unloaded and our
; alpha-beta-vacuum-agent will use it's own copy of the code.
;
; You can use all other AIMA code (except aima/search/algorithms/minimax.lisp).


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
;     :agents '(smart-vacuum-agent alpha-beta-vacuum-agent)))




;;;; BONUS: [-5 to +30 points based on performance]

; You may enter a competition against other students by defining a structure
; YOUR_MATRICULATION_NUMBER-vacuum-agent

; The agents will compete against each other in pairs. Each agent gets to
; compete against each other agent twice -- with swapped starting positions,
; but in the same environment. Evaluation is the same as in question 3.

; WARNING: Entering the competition costs you 5 marks!

; Winner wins (min 30 (length competitors)) marks. Player at n-th position
; "wins" (max (+ (- (min 30 (length '(1 2 3 4 5))) n) 1) -5) marks.

; FAIR PLAY: In order to give all agents a fair chance, we limit the execution
; of agents to 1 second per move on the lab computers, with CLisp 2.49, compiled
; code. In case your agent exceeds this limit, the thread will be killed and
; a random move will be executed.
; If the execution of your agent causes an error during a competition, your
; agent will be disqualified.
; Test your agent thoroughly, e.g. against your classmates!

(defstructure (YOUR_MATRICULATION_NUMBER-vacuum-agent
           (:include game-agent (algorithm 'pick-random-move))))


