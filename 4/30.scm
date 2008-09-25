a.
(load "./evaluator-lazy-memoized.scm")
(driver-loop)
(define (for-each proc items)
  (if (null? items)
      'done
      (begin 
	(proc (m-car items))
	(for-each proc (m-cdr items)))))

(for-each (lambda (x) (nl) (display x))
	  (list 1 2))
(define (cube x) (display (* x x x)))
(for-each cube
	  (list 1 2))


displayは基本手続きとして評価器に組み込んであるので, evalでもactual-evalでも評価される.


eval-sequenceでevalだと困るのは, lookup-variable-valueで見つけたものがthunkな時.
しかしこの問題の場合は, 手続きnewline/displayはthunkでない(基本手続き)なので評価される.


;; *参考
;; the-global-environmentでfor-eachは
;; (procedure (proc items) ((if (null? items) 'done (begin (proc (m-car items)) (for-each proc (m-cdr items))))) #0#)
;; に束縛(#0#は環境へのポインタ)

b.
;; 元のeval-sequenceを使ったとき
(load "./evaluator-lazy-memoized.scm")
(driver-loop)
(define (p1 x)
  (set! x (m-cons x '(2)))
  x)
(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (m-cons x '(2)))))
(p1 1)
;; =>(1 2)
(p2 1)
;; 1

;; Cyの提案するeval-sequenceを使ったたとき
(load "./evaluator-lazy-memoized.scm")
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
	(else (actual-value #?=(first-exp exps) env)
	      (eval-sequence (rest-exps exps) env))))
(driver-loop)
(define (p1 x)
  (set! x (m-cons x '(2)))
  x)
(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (m-cons x '(2)))))
(p1 1)
;; =>(1 2)
(p2 1)
;; =>(1 2)

元のeval-sequenceで(p2 1)を評価すると, eval-sequenceの部分は以下のように展開される.

(eval (first-exp exps) env)
(eval x)
=>
(thunk (set! ...))
x

これではthunkが評価されない.
一方Cyの提案するeval-sequenceを使うと,thunkが評価され, 副作用が効く.

c.
thunkでないものに対してはactual-valueはevalと変わらないので, aの例でもきちんと動く.

d.
Cyの提案するように, 並びに含まれる副作用は後の並びの要素に影響すべきである.
