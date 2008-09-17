;;; Chapter 4.1.3
;;; Evaluator Data Structures

;; testing of predicates
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

;(apply-primitive-procedure <proc> <args>)
;(primitive-procedure? <proc>)


;; representing procedures
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))  ;; list
;; not (cons 'procedure (cons parameters (cons body env))) 


(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))



;(lookup-variable-value <var> <env>)
;(extend-environment <variables> <values> <base-env>)
;; return a new environment
;; enclosing environemnt is the environment <base-env>

;(define-variable! <var> <val> <env>)
;; adds to the first frame in the environemnt <env> a new binding that associates the varibale <var> with the value <value>
;; "first frame"?

;(set-variable-value! <var> <value> <env>)
;; if the variable is unbound, signals an error


;; env: (first-frame (second-frame ...))
;; operations on environments
(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

;; frame: (cons (var1 var2 ...) (val1 val2 ...))
;; above
(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
	  (error "Too many arguments supplied" vars vals)
	  (error "Too few arguments supplied" vars vals))))

;; look up a variable in a environment
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond [(null? vars)
	     (env-loop (enclosing-environment env))]
	    [(eq? var (car vars))
	     (car vals)]
	    [else (scan (cdr vars) (cdr vals))]))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame)
		(frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond [(null? vars)
	     (env-loop (enclosing-environment env))]
	    [(eq? var (car vars))
	     (set-car! vals val)]
	    [else (scan (cdr vars) (cdr vals))]))
    (if (eq? env the-empty-environment)
	(error "Unbound variable -- SET!" var)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame)
		(frame-values frame)))))
  (env-loop env))

;; set a variable to a new value in a specified environment
(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond [(null? vars)
	     (add-binding-to-frame! var val frame)]
	    [(eq? var (car vars))
	     (set-car! vals val)]
	    [else (scan (cdr vars) (cdr vals))]))
    (scan (frame-variables frame)
	  (frame-values frame))))
