(load "./evaluator.scm")
(driver-loop)

(if (> 2 1) 2 1)
;; => 2
(load "./evaluator.scm")
(driver-loop)
(define (test a)
  (if (> a 0)
	   'p
	   'n))
(test 10)
(define (add a b)
  a)
(add 1 10)
;; => *** ERROR: Unbound variable if

