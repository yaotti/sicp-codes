;; ex11を使ってvar, valのpairで環境を表現

;; define-variable!のみ外の環境を見にいかず、そのフレームに束縛を追加する
;; この違いはどう吸収する?
;; => define-variable?を作る?(abstract procedureの引数に渡すしかない)
;; => 可変長引数で区別する

;; an implementation based on the second idea
(define (env-loop env proc var . val)
  (define (scan binds)
    (cond [(and (null? #?=binds) (not (null? (car val))))
	   (add-binding-to-frame! var (car val) #?=(first-frame env))]
	  [(null? binds)
	   (env-loop (enclosing-environment env) proc var val)]
	  [(eq? var (caar binds))
	   (proc #?=binds)]
	  [else (scan (cdr binds))]))
  (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env)))
	(scan frame))))

(define (define-variable! var val env)
  (env-loop env (lambda (binds) (set-cdr! (car binds) val)) var val))
(define (lookup-variable-value var env)
  (env-loop env (lambda (binds) (cdar binds)) var))
(define (set-variable-value! var val env)
  (env-loop env (lambda (binds) (set-cdr! (car binds) val)) var val))
