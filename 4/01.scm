;; 4-1
;; procedure arguments
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
	    (list-of-values (rest-operands exps) env))))

;; left-to-right
(define (l2r-list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((first (eval (first-operand exps) env)))
	(let ((rest (list-of-values (rest-operands exps) env)))
	  (cons first rest)))))

;; right-to-left
(define (r2l-list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((rest (list-of-values (rest-operands exps) env))) ;;is it right?
	(let ((first (eval (first-operand exps) env)))
	  (cons first rest)))))

