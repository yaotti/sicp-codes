;; my justifications...

;; -if we can't find the given variable in the first environment, we research the enclosing environment
;; -even if a variable is bound also in the enclosing environment in which the 'make-unbound!' expression is evaluated, we should NOT remove the binding from the enclosing environment

;; 与えられた変数が最初の環境で束縛されていない場合は、外側の環境も見に行くべき。
;; もし与えられた変数が、その環境だけでなくその外側の環境でも束縛されていたとしても、現在の環境以外からは束縛を取り除くべきではない。



;; definition of make-unbound!
;; based on ex 11
;; representing bindings as (var . val)

;; これは破壊的でない
;; make-unbound!は環境を返す
;; なぜ破壊的でない?
;; →参照する対象(set!の第一引数)がglobalではないから?

;; wrong answer
;; 
(define (make-unbound! var env)
  (define (env-loop env searched-env)
    (define (scan binds searched-b)
      (cond [(null? binds)
	     (env-loop (enclosing-environment env)
		       (append searched-env (searched-b)))]
	    [(eq? var (caar binds))
 	     (set! env (list (append searched-env (append searched-b (cdr binds)))
 			     (cdr env)))]
	    [else (scan (cdr binds) (append searched-b (list (car binds))))]))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((frame (first-frame env)))
	  (scan frame '()))))
  (env-loop env '()))


  
;; correct answer
(define (make-unbound! var env)
  (define (env-loop env)
    (define (scan binds)
      (cond [(null? binds)
	     (env-loop (enclosing-environment env))]
	    [(eq? var (caar binds))
 	     (set-car! binds '())] ;;!!!!
	    [else (scan (cdr binds))]))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((frame (first-frame env)))
	  (scan frame))))
  (env-loop env))

