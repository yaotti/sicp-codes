;; (let name ((var1 exp1) (var2 exp2) ...) body)
;; ->
;; ((lambda (var1 var2 ...)
;;    (define name (lambda (var1 var2 ...) body))
;;     (name var1 var2 ...))
;;  exp1 exp2 ...)
;; ->
;; ((lambda (var1 var2 ...)
;;    ((lambda (name) body) (lambda (var1 var2 ...) body))
;;    body)
;;  exp1 exp2 ...)



(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (named-let? exp)
  (symbol? (cadr exp)))
(define (let-bindings exp)
  (if (named-let? exp)
      (caddr exp)
      (cadr exp)))
(define (let-name exp)
  (cadr exp))
(define (let-body exp)
  (if (named-let? exp)
      (cdddr exp)
      (cddr exp)))
(define (let-vars exp)
  (if (null? exp)
      '()
      (map car (let-bindings exp))))

(define (let-exps exp env)
  (if (null? exp)
      '()
      (map (lambda (x) (eval (cadr x) env))
	   (let-bindings exp))))

;; let式からlambda式への変換
(define (let->combination exp env)
  (if (named-let? exp)
      (cons (make-lambda (let-vars exp)
			 (list
			  (list 'define (let-name exp)
				(make-lambda (let-vars exp)
					     #?=(let-body exp)))
			  (cons (let-name exp) (let-vars exp))))
	    (let-exps exp env))
      (cons (make-lambda (let-vars exp)
			 (let-body exp))
	    (let-exps exp env))))
