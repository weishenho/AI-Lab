;;;; CZ3005 2015 Semester 2: Lab 3

;; INTRODUCTION TO LISP

;; Lisp
;; 1) imperative language: LISP program describe HOW to perform an algorithm
;; 2) functional: its syntax and semantics are derived from the mathematical
;; theory of recursive functions.
;; 3) Oldest Language still in use after FORTRAN. (started in 1958)
;; 4) Software written in Lisp: e.g. EMACS text editor.

;; LISP MANUALS:

;; Note is is essential that you use the reference documentation throughout the
;; labs. Not all aspects of the language are explained here. Large amount of
;; lisp functions are not intuitive and require you to find out the exact
;; syntax and usage.

;; Tutorials:
;; http://www.tutorialspoint.com/lisp/

;; Simple reference:
;; http://www.jtra.cz/stuff/lisp/sclr/index.html

;; Complete reference:
;; http://www.lispworks.com/documentation/HyperSpec/Front/index.htm

;; NOTE -- You WILL need the previous references throughout the labs!
;; Don't ask questions such as: "What does aref do?"


;; SECTION 1: BASICS
;;
;; 1) ALL Lisp expressions are either ATOMS or LISTS,
;; consist of zero or more expressions enclosed in parentheses.
;;
;; 2) Prefix Notation

2

3.14159

'(+ 2 3)

(+ 2 3)

(+ 2 3 4)

(/ (- 7 1) (- 4 2))

;; Lisp evaluates (- 7 1): 7 evaluates to 7 and 1 evaluates to 1
;; 7 and 1 are passed to the function -, which returns 6.

;; Lisp evaluates (- 4 2): 4 evaluates to 4 and 2 evaluates to 2
;; 4 and 2 are passed to the function -, which returns 2.

;; The values 6 and 2 are passed to the function /, which returns 3.

;; remember parse trees in CS540!!

;; atom
;; An atom is a number or string of contiguous characters. It includes numbers and special characters.

;; list
;; A list is a sequence of atoms and/or other lists enclosed in parentheses.


;; quote

(quote shen-shyang)

'shen-shyang

(quote (shen-shyang))

'(shen-shyang)

;; See http://stackoverflow.com/questions/134887/when-to-use-quote-in-lisp



;; SECTION 2: LIST OPERATION

(car '(4 6 1 2))

(cdr '(4 6 1 2))

(cons 'a 'b)

(cons 'a '(b c d))

(cons '(a e) '(b c d))

;; cons combines two objects into a two-part object called a "cons".
;; Conceptually, a "cons" is a pair of pointers; the first one is the
;; "car" and the second is the "cdr"

(car (cdr (cdr (cdr '(1 2 3 4 5 6 7 8)))))

(cadddr '(1 2 3 4 5 6 7 8))
;; Are they identical??

(caaddr '((1 2) (3 4) (5 6) (7 8)))
;; What is the output of this?



;; SECTION 3: PREDICATE
;; A function that returns a value of either true or false depending
;; on whether or not its arguments possess some property

(= 9 (+ 4 5))

(numberp 10)

(atom '(1 2 3))

(listp '(1 2 3))



;; SECTION 4: OUTPUT

(print (+ 4 5))

(format t "~%~A + ~A = ~A. ~%" 4 5 (+ 4 5))
;; t : default place, i.e. terminal.
;; ~%: newline
;; ~A: position to be filled

;; Input: READ.



;; SECTION 5: Global/Local variables

;; local variable: variables are valid within the scope of "let"

;; let consist of two parts :
;;  1. Variable binding: Done in parallel
;;  2. Expressions: evaluated in order like a normal function, the last value
;;     is returned (works like progn)
;;     [Hint: look up progn]

(let ((x 0) (y 5) (z 8))
  (print (+ x z))
  (- z y))

;; local variables with sequential evaluation
(let* ((x 1) (y (+ x 1)) (z (+ y 1)))
  (print (list x y z)))

;; global

(defparameter *counter* 0)

(defconstant PI_user_defined 3.14159)

;; assignment operator: setf.

;; assigning local variables
(let ((x 0) (y 5) (z 8))
  (print (+ x z))
  (setf z 3)
  (- z y))

;; NOTE:
;; if variable is not initialized as local variable,
;; it will be assigned as a global variable.



;; SECTION 6: FUNCTION, #', Lambda expression, funcall, apply, eval

(defun fun1 (x y &optional (z1 0) (z2 10))
  (+ x y z1 z2))

;;APPLY: call supplied function with specified arguments
;; z set to lists of all remaining arguments
(defun fun2 (x y &rest z)
  (apply (function +) x y z))

;; z1 z2 z3 are optional
;; try (fun3 1 2 :z1 5 :z3 10)
;; default value of unassigned arguments is NIL
(defun fun3 (x y &key z1 z2 z3)
  (list x y z1 z2 z3))

;; Assigning default values to optional arguments
;; try (fun3 1 2)
;; try (fun3 1 2 :z2 50)
(defun fun3 (x y &key (z1 10) (z2 20) (z3 30))
  (list x y z1 z2 z3))


;; abbreviation for #' and function operator
;;   #'functionname   is a shorter notation of   (function functionname)
(apply (function +) '(1 2 3))

(apply #'+ '(1 2 3))

;; funcall does the same thing as apply
;; but does not require the arguments to be packaged in a list

(apply #'+ '(1 2 3))

(funcall #'+ 1 2 3)

;; eval takes an expression, evaluates it and returns its value

(eval '(+ 1 2 3))

;; A tradition: Lambda expression
;; In earlier dialects of Lisp, functions were represented
;; internally as LISTS and the way to tell a function
;; from an ordinary list was to check if the first element
;; was the symbol "lambda".

(apply #'(lambda (x y) (+ x y)) '(4 5))

(apply #'(lambda (x y) (+ (expt x 2) (expt y 2))) '(4 5))

;; We can call functions in apply.
;; The previous example can be rewritten as
(defun sum-sqr (x y)
  (+ (expt x 2) (expt y 2)))

(apply #'sum-sqr '(4 5))


;; SECTION 7: CONDITIONS
;; if statements, cond statements, when, unless, case ....
;;  (if (test)
;;      (action) ; if test true
;;      (else-action)) ; if test false

(defun fun4a (x y)
  (if (> x y)
      (- x y) ;; if true, execute this parenthesis
    (- y x)))  ;; if false, execute this parenthesis

(defun fun4 (x y)
 (if (> x y)
     (format t "~% ~A is larger than ~A ~%" x y)
   (if (< x y) ;; else if
      (format t "~% ~A is larger than ~A ~%" y x)
   (format t "~% The two numbers are equal ~%"))))  ;;else


;;  (cond   (test1    action1)
;;          (test2    action2)
;;            ...
;;          (testn   actionn))

;; Each clause within the cond statement consists of a conditional test and
;; an action to be performed.
;; If the first test following cond, test1, is evaluated to be true, then the
;; related action part, action1, is executed, its value is returned and the
;; rest of the clauses are skipped.


(defun fun5 (x y)
   (cond ((> x y) (format t "~% ~A is larger than ~A ~%" x y))
         ((< x y) (format t "~% ~A is larger than ~A ~%" y x))
         (t (format t "~% The two numbers are equal ~%"))))



;; SECTION 8: ITERATIONS
;; do, dotimes, dolist
;; (variable initial update)

;; from 0 to x-1
(defun fun7 (x)
  (dotimes (y x)
    (format t "~A ~%" (* y y))))

(defun fun8 (&optional (lst '(1 2 3 4 5 6 7 8 9 10)))
  (let ((z nil))
  (dolist (y lst z)
    (setf z (cons (* y y) z))
    (format t "~A ~%" (* y y)))))



;; SECTION 9: RECURSIONS
;; Recursion plays a greater role in Lisp than in most other languages.

;; To solve a problem using recursion, you have to
;; do two things:
;; 1) Show how to solve the smallest version of the problem - the base case
;; by some finite number of operations.
;; 2) Show how to solve the problem  in the general case by breaking it down
;; into finite number of similar, but smaller, problems.

;; count the number of 'a in the list
;; e.g. lst = '(a a 3 w q a) => 3
;; LISP function: count-if
(defun count_a (lst)
  (cond ((null lst) 0) ;; base case
        (t (if (eql (car lst) 'a)  ;; general case
               (+ 1 (count_a (cdr lst)))
             ;;else
             (+ 0 (count_a (cdr lst)))))))

;; Note: The values do not satisfy the BST Property. (CS583)
;; We just want to show the tree traversal

(setq lst '(1 (2 (3 4 5) (10 11 12)) (6 () (7 () 8))))

;; inorder-nested: visit left subtree, node, right subtree
(defun inorder-nested (tree)
  (cond ((null tree) nil)
        ((atom tree) (list tree))
        (t (append (inorder-nested(second tree)) (list (car tree))
            (inorder-nested(third tree))))))

;; preorder-nested: visit node, left subtree, right subtree
(defun preorder-nested (tree)
  (cond ((null tree) nil)
        ((atom tree) (list tree))
        (t (append (list (car tree)) (preorder-nested(second tree))
            (preorder-nested(third tree))))))

;; postorder-nested: visit left subtree, right subtree, node
(defun postorder-nested (tree)
````  (cond ((null tree) nil)
        ((atom tree) (list tree))
        (t (append (postorder-nested(second tree))
            (postorder-nested(third tree)) (list (car tree))))))



;; SECTION 10: Mapping functions
;; mapcar: takes a function and one or more lists and returns
;; the result of applying the function to elements taken from each
;; list, until list runs out.

(defun fun9 ()
    (mapcar #'(lambda (x) (+ x 10)) '(1 2 3)))

(defun fun10 ()
    (mapcar #'cdr '((1 a) (2 b) (3 c))))



;; SECTION 11: trace, load and compile-file

 (trace count_a)
 (count_a '(a a 3 w q a))
;; (untrace count_a)

;; (load "lab1.lisp")

;; (compile-file "lab1.lisp")
;; Then (load "lab1.lisp.XXX") where XXX depends on which
;; LISP system you use.

;; OTHER REFERENCE:
;; [1] Graham, P.: ANSI Common Lisp, Prentice Hall, 1996.
;; [2] Lugar, G.: Artificial Intelligence, 4th Ed. Addison-Wesley, 2002.
;; [3] http://www.gigamonkeys.com/book/
