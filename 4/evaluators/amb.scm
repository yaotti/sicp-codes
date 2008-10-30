;; 4.3.3
;; non-deterministic evaluator

(define apply-in-underlying-scheme (with-module gauche apply))
(load "../1-2.scm")
(load "../1-3.scm")
(load "../1-4.scm")

;; おそらく不要
;; (define (eval exp env)
;;   ((analyze exp) env))

(define (analyze exp)
  (cond ((self-evaluating? exp)
	 (analyze-self-evaluating exp))
	((quoted? exp) (analyze-quoted exp))
	((variable? exp) (analyze-variable exp))
	((assignment? exp) (analyze-assignment exp))
	((definition? exp) (analyze-definition exp))
	((if? exp) (analyze-if exp))
	((let? exp) (analyze (let->combination exp))) ;;modify
	((lambda? exp) (analyze-lambda exp))
	((begin? exp) (analyze-sequence (begin-actions exp)))
	((cond? exp) (analyze (cond->if exp)))
	((amb? exp) (analyze-amb exp)) ;; modify
	;; right?
	(#?=(require? #?=exp) (require exp))
	((application? exp) (analyze-application exp))
	(else
	 (error "Unknown expression type -- ANALYZE" exp))))


;; amb
(define (amb? exp) (tagged-list? exp 'amb))
(define (amb-choices exp) (cdr exp))
(define (ambeval exp env succeed fail)
  ((analyze exp) env succeed fail))


(define (require p)
  (if (not p) (amb)))
(define (require? exp) (tagged-list? exp 'require))

;; for let
(define (let? exp)
  (tagged-list? exp 'let))
(define (let-binds exp)
  (cadr exp))
(define (let-body exp)
  (cddr exp))
(define (let->combination exp)
  (cons
   (make-lambda (map car (let-binds exp))
		(let-body exp))
   (map cadr (let-binds exp))))



(define (analyze-self-evaluating exp)
  (lambda (env succeed fail)
    (succeed exp fail)))

(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env succeed fail)
      (succeed qval fail))))

(define (analyze-variable exp)
  (lambda (env succeed fail)
    (succeed (lookup-variable-value exp env)
	     fail)))

(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
	(bproc (analyze-sequence (lambda-body exp))))
    (lambda (env succeed fail)
      (succeed (make-procedure vars bproc env)
	       fail))))

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
	(cproc (analyze (if-consequent exp)))
	(aproc (analyze (if-alternative exp))))
    (lambda (env succeed fail)
      (pproc env
	     ;; success continuation for evaluating the predicate
	     ;; to obtain `pred-value`
	     (lambda (pred-value fail2)
	       (if (true? pred-value)
		   (cproc env succeed fail2)
		   (aproc env succeed fail2)))
	     ;; failure continuation for evaluating the predicate
	     fail))))

(define (analyze-sequence exps)
  (define (sequentially a b)
    (lambda (env succeed fail)
      (a env
	 (lambda (a-value fail2)
	   (b env succeed fail2))
	 fail)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
	first-proc
	(loop (sequentially first-proc (car rest-procs))
	      (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
	(error "Empty sequence -- ANALYZE")
	(loop (car procs) (cdr procs)))))

;; Definitions and assignments
(define (analyze-definition exp)
  (let ((var (definition-variable exp))
	(vproc (analyze (definition-value exp))))
    (lambda (env succeed fail)
      (vproc env
	     (lambda (val fail2)
	       (define-variable! var val env)
	       (succeed 'ok fail2))
	     fail))))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
	(val (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
	     (lambda (val fail2)
	       (let ((old-value
		      (lookup-variable-value var env)))
		 (set-variable-value! var val env)
		 (succeed 'ok
			  (lambda ()
			    (set-variable-value! var
						 old-value
						 env)
			    (fail2)))))
	     fail))))

(define (analyze-application exp)
  (let ((pproc #?=(analyze #?=(operator exp)))
	(aprocs (map analyze (operands exp))))
    (lambda (env succeed fail)
      (pproc env
	     (lambda (proc fail2)
	       (get-args aprocs
			 env
			 (lambda (args fail3)
			   (execute-application
			    proc #?=args succeed fail3))
			 fail2))
	     fail))))

(define (get-args aprocs env succeed fail)
  (if (null? aprocs)
      (succeed '() fail)
      ((car aprocs) env
       ;; succeess continuation for this `aproc'
       (lambda (arg fail2)
	 (get-args (cdr aprocs)
		   env
		   ;; success continuation for recursive
		   ;; call to `get-args'
		   (lambda (args fail3)
		     (succeed (cons arg args)
			      fail3))
		   fail2))
       fail)))

(define (execute-application proc args succeed fail)
  (cond ((primitive-procedure? #?=proc)
	 (succeed (apply-primitive-procedure proc args)
		  fail))
	((compound-procedure? proc)
	 ((procedure-body proc)
	  (extend-environment (procedure-parameters proc)
			      args
			      (procedure-environment proc))
	  succeed
	  fail))
	(else
	 (error
	  "Unknown procedure type -- EXECUTE-APPLICATION"
	  proc))))


(define (analyze-amb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	    (fail)
	    ((car choices) env
	     succeed
	     (lambda ()
	       (try-next (cdr choices))))))
      (try-next cprocs))))

;; Driver Loop
(define input-prompt ";;; Amb-Eval input:")
(define output-prompt ";;; Amb-Eval value:")

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
	  (try-again)
	  (begin
	    (newline)
	    (display ";;; Starting a new problem ")
	    (ambeval input
		     the-global-environment
		     ;; `ambeval' success
		     (lambda (val next-alternative)
		       (announce-output output-prompt)
		       (user-print val)
		       (internal-loop next-alternative))
		     ;; `ambeval' failure
		     (lambda ()
		       (announce-output
			";;; There are no more values of")
		       (user-print input)
		       (driver-loop)))))))
  (internal-loop
   (lambda ()
     (newline)
     (display ";;; There is no current problem")
     (driver-loop))))

