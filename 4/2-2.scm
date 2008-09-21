((application? exp)
 (apply (actual-value (operator exp) env)
	(operands exp)
	env))

(define (actual-value exp env)
  (force-it (eval exp env)))

(define (apply procedure argument env)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure
	  procedure
	  (list-of-arg-values arguments env))) ;; changed
	((compound-procedure? procedure)
	 (eval-sequence
	  (procedure-body procedure)
	  (extend-environment
	   (procedure-parameters procedure)
	   (list-of-delayed-args arguments env)
	   (procedure-environment procedure))))
	(else (error "Unknown procedure type -- APPLY" procedure))))

(define (list-of-arg-values exps env)
  (if (no-operands? exps)
      '()
      (cons (actual-value (first-operand exps) env)
	    (list-of-arg-values (rest-operands exps)
				env))))
(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
      '()
      (cons (delay-it (first-operand exps) env)
	    (list-of-delayed-args (rest-operands exps)
				  env))))

(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

;; change `driver-loop`
(define input-prompt ";;; L-Eval input:")
(define output-prompt ";;; L-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (actual-value input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))


;;; FORCE-IT
(define (delay-it exp env)
  (list 'thunk exp env))

(define (thunk? obj)
  (tagged-list? obj 'thunk))

(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))



;; one implementation of `force-it`
(define (force-it obj)
  (if (thunk? obj)
      (actual-value (thunk-exp obj) (thunk-env obj))
      obj))


;; another implementation of `force-it`
;; memoize thunks
(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))

(define (thunk-value evaluated-thunk) (cadr evaluated-thunk))

(define (force-it obj)
  (cond ((thunk? obj)
	 (let ((result (actual-value
			(thunk-exp obj)
			(thunk-env obj))))
	   (set-car! obj 'evaluated-thunk)
	   (set-car! (cdr obj) result) ;;replace `exp` with its value
	   (set-cdr! (cdr obj) '()) ;;forget unneeded `env` (it's GC)
	   result))
	((evaluated-thunk? obj)
	 (thunk-value obj))
	(else obj)))

;; この2つのforce-itは, それ以外の手続きを変更せずにどちらも使える.
;; abstraction barrier




;; test
(load "./evaluator-lazy.scm")
(driver-loop)
(define (try a b)
  (if (= a 0) 1 b))
(try 0 (display 'hoge))
;; =>
;;; L-Eval input:

;;; L-Eval value:
1


(load "./evaluator.scm")
(driver-loop)
(define (try a b)
  (if (= a 0) 1 b))
(try 0 (error "hoge"))
;; =>
;;; M-Eval input:
hoge
;;; M-Eval value:
1


うまく遅延評価されている.