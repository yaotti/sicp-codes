(define (let? exp)
  (tagged-list? exp 'let))

(define (let-binds exp)
  (cadr exp))

(define (let-body exp) ;;not (body), body
  (caddr exp))

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
  (list (make-lambda (let-vars (let-binds exp))
		     (let-body exp))
	(let-exps (let-binds exp) env)))