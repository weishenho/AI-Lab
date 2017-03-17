; Define vacuum-game structure as a subclass of game

; It is possible to pass in the dirt locations as a list of len 2 lists - for
; testing and competitive purposes

(defstructure (vacuum-game (:include game) (:constructor create-vacuum-game))
    (size 8)
    (dirt nil) ; If dirt is empty, dirt will be randomly generated based
    (dirt-probability 0.25)) ; on dirt probability

; Define a single state representation as a subclass of game-state

(defstructure (vacuum-game-state (:include game-state))
  (agents '(          ; list of agent's (location heading on/off)
    ((1 1) (0 1) t)
    ((6 6) (0 -1) t)))
  dirts               ; list of dirt locations
  (m 8)
  (n 8))

; game and game-state structrues for reference:

; (defstructure game
;   "A game is defined in terms of the starting position (the initial-state),
;   the rewards for winning and losing, and three generic functions:
;   LEGAL-MOVES: a list of moves that can be made in this state
;   MAKE-MOVE: generate a new state
;   GAME-OVER?: are we finished?
;   You provide methods for these for each new subtype of game."
;   initial-state             ; a state in the domain
;   (best +1)             ; Best score (for winning the game)
;   (worst -1)                ; Worst score (for losing the game)
;   )

; (defstructure game-state
;   "Everything you need to know about the state of the game. The players
;   are given as a list of names, with the player whose move it is
;   first.  A property list keeps the scores for each player.  In some
;   games, scores are accumulated as you go, in others a score is
;   awarded only at the end."
;   board               ; the current state of the game board
;   (players '(X O))    ; list of the players, current player to move first
;   (scores '(X 0 O 0)) ; Plist of scores for each player
;   (terminal? nil)     ; Does this state end the game?
;   (previous-move nil) ; The move just made to get to this position
;   )

; Constructor for vacuum-game
(defun make-vacuum-game (&key (size 8) (dirt nil) (dirt-probability 0.25))
   (create-vacuum-game
       :size 8
       :dirt nil
       :dirt-probability 0.25
       :initial-state
        (make-vacuum-game-state
            :agents `(          ; list of agent's location, heading, on/off
                ((1 1) (0 1) t)
                ((,(- size 2) ,(- size 2)) (0 -1) t))
            :m size
            :n size
            :board (fill-board)
            :players (list 'A 'B)
            :scores (list 'A 0 'B 0)
            :dirts (or dirt
                       (dotimes (x size dirt)
                         (dotimes (y size)
                           (when (< (random 1.0) dirt-probability)
                             (push (@ x y) dirt))))))))

(defmethod legal-moves ((game vacuum-game) state)
    (declare-ignore state)
    '(suck forward (turn left) (turn right) shut-off))

; Note that for performance purposes, this implementation does NOT use board
;
; If you feel like you need this, you can write your own fill-board function
; to create a similar grid percept -- known as radar from previous tasks.
; See the usage in make-vacuum-game.
; Then you also can change the print-vacuum-game-state function to print
; your board.
; The default fill-board doesn't do anything as it potentially slows down
; all the state generating algorithms.
(defun fill-board (&optional agents dirt m n)
    (declare-ignore agents dirt m n)
    nil)
; (defun fill-board (&optional agents dirt m n)
;     (make-array (list 1 1) :initial-element 'NA))

; It is necessary to extend the game-environment that runs the vacuum-game
; with custom display-environment method.
; Unfortunately AIMA doesn't have any callback to print / access
; the environment
(defmethod display-environment ((env game-environment))
  (let ((stream (environment-stream env))
    (state (environment-state env)))
    (when stream
        (if (eq (type-of state) 'VACUUM-GAME-STATE)
          ; vacuum-game-state
          (print-vacuum-game-state state stream)
          ; game-state
          (progn
              (when (game-state-previous-move state)
            (format stream "~&~A moved to ~A.~%" (previous-player state)
                (game-state-previous-move state)))
              (print-grid (game-state-board state) :stream stream)
              (format stream "~&~A to move:" (current-player state)))))))


(defun print-vacuum-game-state (state stream)
    (let* ( (agents (vacuum-game-state-agents state))
            (dirts (vacuum-game-state-dirts state))
            (m (vacuum-game-state-m state))
            (n (vacuum-game-state-n state))
            (players (vacuum-game-state-players state))
            (scores (vacuum-game-state-scores state))
            (prev (vacuum-game-state-previous-move state)))
        (declare-ignore m n)
        (destructuring-bind (my-agent foe-agent) agents
            (declare-ignore foe-agent)
            (destructuring-bind (my-loc my-heading my-on) my-agent
                (when prev
                    (format stream "~&Moves: ~A~%"
                        prev))
                (format stream "~&---~%")
                (format stream "~&Agent ~A to move...~%" (first players))
                (format stream "~&  loc: ~A\, heading: ~A, on: ~A ~%"
                    my-loc my-heading my-on)
                (format stream "~&Dirts: ~A~%" dirts)
                (format stream "~&Players: ~A~%" players)
                (format stream "~&Scores: ~A~%" scores)
                (format stream "~&Eval: ~5$ ~5$ ~%"
                    (first (vacuum-agent-eval state))
                    (second (vacuum-agent-eval state)))
                ))))

(defmethod make-move ((game vacuum-game) state move)
  (let (
        (agents (vacuum-game-state-agents state))
        (dirts (vacuum-game-state-dirts state))
        (n (vacuum-game-state-n state))
        (m (vacuum-game-state-m state))
        (players (vacuum-game-state-players state))
        (scores (vacuum-game-state-scores state))
        (prev (vacuum-game-state-previous-move state)))
    (declare-ignore prev)
    (destructuring-bind (my-agent foe-agent) agents
      (destructuring-bind (my-loc my-heading my-on) my-agent
        (let* ((my-loc-new
                (if (and (equal move 'forward)
                    (inside (xy-add my-loc my-heading) n m))
                  (xy-add my-loc my-heading)
                  my-loc))
              (my-heading-new
                (cond
                  ((equal move '(turn left)) (rotate my-heading 0 -1 1 0))
                  ((equal move '(turn right)) (rotate my-heading 0 1 -1 0))
                  (t my-heading)))
              (my-on-new
                (if (equal move 'shut-off) nil my-on))
              (my-agent-new
                (list my-loc-new my-heading-new my-on-new))
              (dirts-new
                (if (and (equal move 'suck)
                         (member my-loc dirts :test #'xy-equal))
                  (remove my-loc dirts :test #'xy-equal)
                  dirts))
              (players-new
                (if (nth 2 foe-agent) ; if second agent is still on
                  (left-rotate players) ; transfer turn to him
                  players)) ; otherwise keep turn
              (agents-new
                (if (nth 2 foe-agent) ; if second agent is still on
                  (list foe-agent my-agent-new)
                  (list my-agent-new foe-agent)))
              (my-score (getf scores (first players)))
              (foe-score (getf scores (second players)))
              (scores-new (copy-list scores)))
          (declare-ignore foe-score)
          (setf (getf scores-new (first players))
            (if (and (equal move 'suck)
                     (member my-loc dirts :test #'xy-equal))
                (- (+ my-score 10) 1)
                (- my-score 1)))
          (make-vacuum-game-state
            :agents agents-new
            :dirts dirts-new
            :m m :n n
            :players players-new
            :scores scores-new
            :board (fill-board)
            :previous-move move))))))

(defmethod game-over? ((game vacuum-game) state)
  (let ((agents (vacuum-game-state-agents state)))
    (or (not (or (nth 2 (first agents)) (nth 2 (second agents))))
        (eq 0 (length (vacuum-game-state-dirts state))))))
