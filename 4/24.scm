(use gauche.time)
(load "./evaluator.scm")
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
    25))
 )
; real   7.307
; user   6.820
; sys    0.030


(load "./evaluator-analyze.scm")
(define (eval-one exp)
  (let ((output (eval exp the-global-environment)))
    (announce-output output-prompt)
    (user-print output)))

(time
 (eval-one
  ((lambda (n)
       ((lambda (fib)
	  (fib fib n))
	(lambda (fb k)
	  (cond ((<= k 0) 0)
		((= k 1) 1)
		(else (+ (fb fb (- k 1))
			 (fb fb (- k 2))))))))
   25))
 )
; real   0.021
; user   0.010
; sys    0.010

