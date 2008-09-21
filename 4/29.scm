(load "./evaluator-lazy-non-memoized.scm")
(define (eval-one exp)
  (let ((output (eval exp the-global-environment)))
    (announce-output output-prompt)
    (user-print output)))
(time
 (eval-one
  '((lambda (n)
       ((lambda (fib)
	  (fib fib n))
	(lambda (fb k)
	  (cond ((<= k 0) 0)
		((= k 1) 1)
		(else (+ (fb fb (- k 1))
			 (fb fb (- k 2))))))))
    20))
)
; real   4.200
; user   4.140
; sys    0.020

(load "./evaluator-lazy-memoized.scm")
(define (eval-one exp)
  (let ((output (eval exp the-global-environment)))
    (announce-output output-prompt)
    (user-print output)))
(time
 (eval-one
  '((lambda (n)
       ((lambda (fib)
	  (fib fib n))
	(lambda (fb k)
	  (cond ((<= k 0) 0)
		((= k 1) 1)
		(else (+ (fb fb (- k 1))
			 (fb fb (- k 2))))))))
    20))
)
; real   0.784
; user   0.780
; sys    0.000


;;;;;

(load "./evaluator-lazy-memoized.scm")
(driver-loop)
(define count 0)
(define (id x)
  (set! count (+ count 1))
  x)

(define (square x)
  (* x x))
(square (id 10))
count
;; =>1

(load "./evaluator-lazy-non-memoized.scm")
(driver-loop)
(define count 0)
(define (id x)
  (set! count (+ count 1))
  x)

(define (square x)
  (* x x))
(square (id 10))
count
;; =>2

メモ化すると(id 10)はevaluated-thunkになるので, 1度しか評価されない.
メモ化しないと(id 10)が2回評価されるので, countが2回setされる.

