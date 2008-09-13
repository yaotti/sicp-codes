;; before using this you have to eval 1-3.scm
;; (definition of enclosing-environment, first-frame and the-empty-environment


;; frame: ((var1 . val1) (var2 . val2) ...)
;; environement: the same
(define (make-frame variables values)
  (map cons variables values))
(define (frame-variables frame) (map car frame))
(define (frame-values frame) (map cdr frame)) ;;pair, not list
(define (add-binding-to-frame! var val frame)
  (append! frame (list (cons var val))))
  ;;(append! frame (list var val))

;; environmentとframeの間の関係は同じ
(define (extend-environment vars vals base-env)
  (append (list (make-frame vars vals)) base-env))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan binds)
      (cond [(null? binds)
	     (env-loop (enclosing-environment env))]
	    [(eq? var (caar binds))
	     (cdar binds)]
	    [else (scan (cdr binds))]))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((frame (first-frame env)))
	  (scan frame))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan binds)
      (cond [(null? binds)
	     (env-loop (enclosing-environment env))]
	    [(eq? var (caar binds))
	     (set-cdr! (car binds) val)]
	    [else (scan (cdr binds))]))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((frame (first-frame env)))
	  (scan frame))))
  (env-loop env))


(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan binds)
      (cond [(null? binds)
	     (add-binding-to-frame! var val frame)]
	    [(eq? var (caar binds))
	     (set-cdr! (car binds) val)]
	    [else (scan (cdr binds))]))
    (scan frame)))
