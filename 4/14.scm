(load "./evaluator.scm")
(driver-loop)
;; (1)超循環評価器内で以下を定義
(define (iter rest result proc)
  (if (null? rest)
      result
      (iter (m-cdr rest)
	    (append result (list (proc (m-car rest))))
	    proc)))
(define (m-map1 proc elt) (iter elt '() proc))
(m-map1 square '(1 2 3))
;; (1 4 9)
;; ok

;; (2)元のschemeのmapを使う
;; metacircularのprimitive-proceduresに以下を追加
;; (list 'm-map2 map)
(m-map2 square '(1 2 3))
;; output
;; *** ERROR: invalid application: ((primitive #<subr map>) (primitive #<closure primitive-procedures>) (1 2 3))

;; 以下テスト
;; 関数を引数にとるのが無理?
;; procをarg1, arg2に適用させるm-funcを基本手続きとして組み込んでみる
;; (list 'm-func (lambda (proc arg1 arg2) (proc arg1 arg2)))
(load "./evaluator.scm")
(driver-loop)
(m-func + 1 2)
;; => *** ERROR: invalid application: ((primitive #<subr +>) 1 2)
;; (apply m-func (+ 1 2))
;; (apply (lambda (proc arg1 arg2) (proc arg1 arg2)) (+ 1 2))
;; これではリストを返すだけ
;; これは動く
;; (list 'm-func (lambda (proc arg1 arg2) (apply proc (list arg1 arg2))))



;; 以下解答
;; システムのmapとmetacircular evaluatorのmapは引数にとる手続きの表現が違う。
;; metacircularl evaluatorはprocedureから始まるリスト。