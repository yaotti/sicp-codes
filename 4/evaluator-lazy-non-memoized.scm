;; this is a non-memoized lazy evaluator
(define apply-in-underlying-scheme (with-module gauche apply))
(load "./1-1.scm")
(load "./1-2.scm")
(load "./1-3.scm")
(load "./1-4.scm")


(define (actual-value exp env)
  (force-it (eval exp env)))
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
	((quoted? exp) (text-of-quotation exp))
	((assignment? exp) (eval-assignment exp env))
	((definition? exp) (eval-definition exp env))
	((if? exp) (eval-if exp env))
	((lambda? exp)
	 (make-procedure (lambda-parameters exp)
			 (lambda-body exp)
			 env))
	((begin? exp) (eval-sequence (begin-actions exp) env))
	((cond? exp) (eval (cond->if exp) env))
	((application? exp) ;;change
	 (apply (actual-value (operator exp) env)
         ;;(apply (eval (operator exp) env)  ;; for ex28 
		(operands exp)
		env))
	(else
	 (error "Unknown expression type -- EVAL" exp))))

(define (apply procedure arguments env)
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
(define input-prompt ";;; L-Eval(non-memoized) input:")
(define output-prompt ";;; L-Eval(non-memoized) value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (actual-value input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))


(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))

(define (delay-it exp env)
  (list 'thunk exp env))
(define (thunk? obj)
  (tagged-list? obj 'thunk))
(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))

(define (thunk-value evaluated-thunk) (cadr evaluated-thunk))

;;; FORCE-IT
;; memoize version
;; (define (force-it obj)
;;   (cond ((thunk? obj)
;; 	 (let ((result (actual-value
;; 			(thunk-exp obj)
;; 			(thunk-env obj))))
;; 	   (set-car! obj 'evaluated-thunk)
;; 	   (set-car! (cdr obj) result) ;;replace `exp` with its value
;; 	   (set-cdr! (cdr obj) '()) ;;forget unneeded `env` (it's GC)
;; 	   result))
;; 	((evaluated-thunk? obj)
;; 	 (thunk-value obj))
;; 	(else obj)))


;; non-memoize version
(define (force-it obj)
  (if (thunk? obj)
      (actual-value (thunk-exp obj) (thunk-env obj))
      obj))
