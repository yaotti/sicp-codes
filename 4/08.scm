;; ex 4.8
;; the form of named-let expressions
(let name ((var1 exp1) (var2 exp2) ...) body)
->
((lambda (var1 var2 ...)
   (let ((name (lambda (var1 var2 ...) body)))
     body))
 exp1 exp2 ...)
->
((lambda (var1 var2 ...)
   ((lambda (name) body) (lambda (var1 var2 ...) body))
   body)
 exp1 exp2 ...)


;; answer
;; extend ex4.6 answer for named-let
;; named-let: (let name bindings body)

;; lambda
(define (make-lambda parameters body)
  ;;(list 'lambda parameters body)  ;;not correct
  (cons 'lambda (cons parameters body)))



(define (named-let? exp)
  (symbol? (cadr exp)))
(define (let-binds exp)
  (if (named-let? exp)
      (caddr exp)
      (cadr exp)))
(define (let-body exp)
  (if (named-let? exp)
      (cadddr exp)
      (caddr exp)))
(define (let-vars exp)
  (if (null? (let-binds exp))
      '()
      (cons (caar (let-binds binds))
	    (let-vars (cdr (let-binds exp))))))
  (define (let-exps exp env)
  (if (null? (let-binds exp))
      '()
      (cons (eval (cadar (let-binds exp)) env)
	    (let-exps (cdr (let-binds exp))))))


(define (let->combination exp env)
  (if (named-let? exp)
      (list (make-lambda (let-vars exp)
			 (list (make-lambda (let-name exp)
					    (let-body exp))
			       (make-lambda (let-vars exp)
					    (let-body exp))))
	    (let-exps exp env))
      (list (make-lambda (let-vars (let-binds exp))
			 (let-body exp))
	    (let-exps (let-binds exp) env))))
