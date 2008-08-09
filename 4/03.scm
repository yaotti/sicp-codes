;; 自信ない:p
(define (eval exp env)
  (cond [(self-evaluating? exp) exp]
	[(variable? exp) (lookup-variable-value exp env)]
	[(quoted? exp) (text-of-quotation exp)]
	[else ((get 'eval (type exp)) (list-of-values (body exp)))]))

(define (body exp) (cdr exp))
