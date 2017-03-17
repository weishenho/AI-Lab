;;;; CZ3005 2015 Semester 2: Lab 1 (Total Marks: 100)
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
;;;; Name your lab 1 lisp code as  "LAB1-<YOUR_MATRICULATION_NUMBER>.lisp"
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
;;;; You are NOT allowed to use any external libraries!
;;;;
;;;; There are FIVE questions in this homework assignment.  If your answer
;;;; is supposed to be computer code, you should type the code directly
;;;; in this file (the file is a loadable Lisp file). There are function
;;;; definitions provided, where you are expected to write your answer.
;;;;  If your answer is supposed to be textual, you should provide it as a
;;;; Lisp comment.
;;;;
;;;; COMMENT EXCESSIVELY -- 20% of marks for every task is awarded solely based
;;;; on sufficiently commented code! Comment both inline in your code and
;;;; comment each function and structure you write. Make sure we understand
;;;; the nitty-gritty of you answers.





;;;; QUESTION 1 [10 marks]

;;; What is printed and returned by the following expressions, and why?

(sqrt (- (+ 1/2 1/3 1/6)))
;;The output is #C(0.0, 1.0), its 1i in complex number.
;;The most inner expression is evaluated first, which sum up all the fractions.
;;The subsequent inner expression change the sign of the result to negative.
;;Finally square root is applied on the result.

(quote (sqrt (- (+ 1/2 1/3 1/6))))
;;The output is (SQRT (- (+ 1/2 1/3 1/6))).
;;quote bypass evaluation within it's parentheses, hence the result.

'(sqrt (- (+ 1/2 1/3 1/6)))
;;Same as the above but this time use a short-form of quote.

;;; [I commented this out so that the file would load, but you should
;;; uncomment it and see what it does so you can explain it ]

;;   (sqrt (quote (- (+ 1/2 1/3 1/6))))
;;its an error because its trying to square root (- (+ 1/2 1/3 1/6)) as it is, its like square rooting a string in some other programming language.

(print (sqrt (- (+ 1/2 1/3 1/6))))
;;It print out #C(0.0, 1.0) on to the terminal, as print will display the result of the expression, usually on the terminal.
;;The result from above expressions will not be printed if the code is loaded and executed from a file.




;;;;; QUESTION 2 [10 marks for each expression, 20 marks total]

;;; Create Lisp expressions which perform the same function as the
;;; following C expressions:
;;; If you do not know C/C++, please refer to the programming manual.

;;; a + b * c - d


(defun dosomething (a b c d)
(- (+ a (* b c)) d)) ; write the expression here
 

;;; if (a==b)
;;; {
;;;     return max(4 * 3 + cos(2.1),  7 / log(1.2));
;;; }
;;; else
;;; {
;;;     return exp(abs (a-b) * (3 % a))
;;; }


(defun dosomething2 (a b)
(if (= a b) (max (+ (* 4 3) (cos 2.1)) (/ 7 (log 1.2)))
	(exp (abs (* (- a b) (mod 3 a))))
)) ; write the expression here



;;;;; QUESTION 3  [10 marks for riddle, 20 marks for enigma]

;;; What do the following functions do?  I'm looking for BOTH a specific
;;; description of the operation of the function AND some insight
;;; into what purpose you'd use it for.

;;; Function 1: RIDDLE
;;; pass in a list for LIS
;;; example:     (riddle '(a b c d e f g))
(defun riddle (lis)
  (if (not (null lis))  ;; if lis is non-empty (it's not NIL)
      (progn
        (riddle (rest lis))
        (print (first lis))))
  "All Done")
;; The function output a list in reverse and a "All Done" at the end
;; it first check if the inputed list is not empty. 
;; if the list is not empty, it call itself but without the first element of the list.
;; it do this over and over again until the list is empty, the function also place in a LIFO stack as it is doing this.
;; after it call itself it then print the 1st element of list it inputed, hence the reverse effect.
;; progn allows more then 1 expression to be executed in the body

  
  
;;; Function 2: ENIGMA

(defun enigma-h (lis d)
  "This is a private function and should only be called from ENIGMA"
  (if (atom lis) 0
    (apply #'+ (length lis) d
      (mapcar #'enigma-h lis
        (make-list (length lis) :initial-element (+ d 1))))))

(defun enigma (lis)
  (enigma-h lis 0))

; Example:
(enigma '(1 2 3 (4 5) 6 7))

(enigma '(defun mystery (n)
    (+ (if (<= n 1) 0
         (mystery (1- n)))
       (/ (if (evenp n) -4 4)
                  (1- (* 2 n))))))


;;The enigma function is quite a complicated function, in addition its a recursion function as well.
;;The function count the number of atoms, nested atoms and atoms inside them in a given list/expression.
;;I shall use the expression "(enigma '(1 2 3 (4 5) 6 7))" as an example the enigma function
;;The list and d=0 is input to the function, the fuction then check its not atom hence execute the apply expression
;;it gets the length of the list which is 6, d=0, hence now we get 6 + 0 + (mapcar expression...)
;;The make list expression within the mapcar expression creates a list and each element is (d + 1), 
;;the number of elements in the list is the length of lis which is 6 in this case, hence we get '(1, 1, 1, 1, 1, 1) 
;;mapcar input each element of the both list into the function engima-h, the 2 list are '(1 2 3 (4 5) 6 7)) and '(1, 1, 1, 1, 1, 1)
;;The result of the mapcar expression is '(0, 0, 0, 3, 0, 0), 
;;the 0s in the list because they trigger base case "if (atom lis) 0" when they are enter the engima-h function.
;;The 3 is because the apply expression is applied hence (length '(4, 5)) => 2, d=1 and (long story short) the mapcar result is (0, 0)
;;hence 3 + 0 + 0 = 3
;;returning to the first iteration of the function we get 6 + 0 + (0, 0, 0, 3, 0, 0) => 6 + 0 + 0 + 0 + 0 + 3 + 0 + 0 = 9, 
;;hence the result of the function (defun enigma-h (enigma '(1 2 3 (4 5) 6 7)))



;;;;; QUESTION 4  [10 marks]

;; A function that returns the sum of the positive numbers less than n from the lab 1
;; Note that this function uses iteration; But the iteration is not necessary
;; Write the function sum-rec as a recursive version of sum1.

(defun sum1 (n)
  (let ((s 0))
    (dotimes (i n s)
      (incf s i))))

(defun sum-rec (n)
(if (= n 1) 0
(+ (- n 1) (sum-rec (- n 1)))
)
)



;;;;; QUESTION 5  [10 marks for each variant, 30 marks total]

;;; Write a function called euclidean-distance, which takes two lists of the same length. These lists represent
;;; vectors in euclidean space.
;;;
;;; https://en.wikipedia.org/wiki/Euclidean_distance
;;;
;;; Write this function THREE WAYS:
;;;
;;; - Using iteration
;;; - Using recursion and NO variables (parameters passed in don't
;;;   count as variables in this context)
;;; - Using mapping and apply
;;;
;;; You are welcome to make subsidiary functions if that would help
;;; you.  I think the only case where this is needed is in the recursive
;;; version.
;;;
;;; Hints: (null foo) returns true if the expression foo is nil
;;;


(defun euclidean-distance-it (p q)
(sqrt(loop for x in p
      for y in q
      sum  (expt (- x y) 2)))
)
;;; Code tested with: (euclidean-distance-it '(1 2 3 4 5) '(6 7 8 9 10)) => 11.18034


(defun euclidean-distance-rec (p q &optional (d 0))
(if (null p) (sqrt d)
(euclidean-distance-rec (cdr p) (cdr q) (+ (expt (- (car p) (car q)) 2) d))
)
)
;;; Code tested with: (euclidean-distance-rec '(1 2 3 4 5) '(6 7 8 9 10)) => 11.18034

(defun euclidean-distance-map (p q)
(sqrt (apply #'+ (mapcar #'(lambda (x y) (expt (- x y) 2)) p q)))
)
;;; Code tested with: (euclidean-distance-map '(1 2 3 4 5) '(6 7 8 9 10)) => 11.18034


;;;;; BONUS: [Additional 10 marks for a winner of each of the three functions]

;;; Bonus marks for the students who write a function in QUESTION 5 such that,
;;; when the whole function is passed to the ENIGMA function, ENIGMA returns
;;; the smallest number.

;;; Note that you may want to redefine the function again if you are going for
;;; the bonus question, as optimizing for the bonus criteria could result in
;;; messy or hard to understand code, which could cost you marks in question 5

;;; You can test it like this:
;;;
;;; (enigma '(defun euclidean-distance-it (p q) nil ))
;;; (enigma '(defun euclidean-distance-rec (p q) nil ))
;;; (enigma '(defun euclidean-distance-map (p q) nil ))

; (defun euclidean-distance-it (p q) nil )
; (defun euclidean-distance-rec (p q) nil )
; (defun euclidean-distance-map (p q) nil )

