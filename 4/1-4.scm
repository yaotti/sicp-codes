;; 4.1.4 Running the Evaluator as a Program

(define primitive-procedures
  (list (list '+ +)
	(list '- -)
	(list '* *)
	(list '/ /)
	(list 'm-car car)
	(list 'm-cdr cdr)
	(list 'm-cons cons)
	(list 'null? null?)
	(list 'square (lambda (x) (* x x)))
	(list 'p print)
	(list 'append append)
	(list 'display display)
	(list 'nl newline)
	(list 'begin begin)
	(list '> >)
	(list '= =)
	(list '< <)
	(list 'list list)
	;; ex 14
	(list 'm-map2 map)
	(list 'm-func (lambda (proc arg1 arg2) proc arg1 arg2))
	;;(list 'm-func (lambda (proc arg1 arg2) (apply proc (list arg1 arg2))))
	
	))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (setup-environment)
  (let ((initial-env
	(extend-environment (primitive-procedure-names)
			    (primitive-procedure-objects)
			    the-empty-environment)))
    (define-variable! 'true #t initial-env)
    (define-variable! 'false #f initial-env)
    initial-env))

(define the-global-environment (setup-environment))
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme ;;this is the apply of GAUCHE
   (primitive-implementation proc) args))

;; driver loop
(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

;; applyは定義したのにevalはそのまま?=>ここでのapplyは1-1.scmで定義したapply
;; つまりここで出てくるapply/evalはmetacircularのもの
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
		     (procedure-parameters object)
		     (procedure-body object)
		     '<procedure-env>))
      (display object)))
