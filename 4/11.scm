;; not checked yet

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

;; test codes
(define f (make-frame '(a b c) '(2 4 6)))
;;(frame-variables f)
;; =>(a b c)
;;(frame-values f)
;; =>(2 4 6)
(add-binding-to-frame! 'x 1 f)
;; =>((a . 2) (b . 4) (c . 6) (x . 1))
(extend-environment '(x y z) '(10 20 30) f)
;; =>(((x . 10) (y . 20) (z . 30)) (a . 2) (b . 4) (c . 6) (x . 1))

;; definition of environment
(define global-frame (make-frame '() '()))
(define env (extend-environment (frame-variables f) (frame-values f) global-frame))
;; =>(((a . 2) (b . 4) (c . 6) (x . 1)))
(define ex-env (extend-environment '(x y z) '(10 20 30) env))
ex-env
;; =>(((x . 10) (y . 20) (z . 30)) ((a . 2) (b . 4) (c . 6) (x . 1)))
(lookup-variable-value 'x ex-env)
;; => 10
(lookup-variable-value 'x (enclosing-environment ex-env))
;; => 1
(set-variable-value! 'c 60 env)
(lookup-variable-value 'c ex-env)
;; =>60

;; test "define-variable!"
ex-env
;; =>(((x . 10) (y . 20) (z . 30)) ((a . 2) (b . 4) (c . 60) (x . 1))) 
(define-variable! 'x 2 ex-env)
ex-env
;; =>(((x . 2) (y . 20) (z . 30)) ((a . 2) (b . 4) (c . 60) (x . 1)))
(define-variable! 'a 12 ex-env)
;; =>((x . 2) (y . 20) (z . 30) (a . 12))
