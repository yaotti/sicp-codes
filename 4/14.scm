(load "./evaluator.scm")
(driver-loop)
;; 超循環評価器内で以下を定義
(define (iter rest result proc)
  (if (null? rest)
      result
      (iter (cdr rest)
	    (append result (list (proc (car rest))))
	    proc)))
(define (m-map1 proc elt)
  (iter elt '() proc) the-global-environment)
(m-map1 square '(1 2 3))
;; =>iterが返される、評価してくれない
;; squareと同じになっているみたい
((m-map1 square '(1 2 3)) 3)
;; => 9
m-map1
;; => (compound-procedure (proc elt) (iter elt '() proc) <procedure-env>) 
(iter '(1 2) '() square)
;; => *** ERROR: Unbound variable if
(if true 1 2)
;; 関数定義の部分がうまくいってない


;; 内部定義は無理なようなので外部で定義する

;; metacircularのprimitive-proceduresに以下を追加してみる
(list 'm-map2 map)


;; test
(driver-loop)
(m-map2 (lambda (x) (* x x)) '(1 2 3))
;; output
*** ERROR: invalid application: ((procedure (x) (* x x) (((false true + - * / m-car m-cdr m-cons null? square p append define m-map2 m-func) #f #t (primitive #<subr +>) (primitive #<subr ->) (primitive #<subr *>) (primitive #<subr />) (primitive #<subr car>) (primitive #<subr cdr>) (primitive #<subr cons>) (primitive #<subr null?>) (primitive #<closure primitive-procedures>) (primitive #<closure print>) (primitive #<subr append>) (primitive #<syntax define>) (primitive #<subr map>) (primitive #<closure primitive-procedures>)))) 1)

;; 関数を引数にとるのが無理?
;; procをarg1, arg2に適用させるm-funcを基本手続きとして組み込んでみる
(m-func proc arg1 arg2)

;; 無理なよう