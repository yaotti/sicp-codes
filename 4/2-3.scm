;; All we need to do is to arrange matters so that `cons' is non-strict.
;; consはprimitiveである必要がないので, 実装するとよい.

(define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))
(define (cdr z)
  (z (lambda (p q) q)))

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

(define (map proc items)
  (if (null? items)
      '()
      (cons (proc (car items))
	    (map proc (cdr items)))))

(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))

(define (add-lists list1 list2)
  (cond ((null? list1) list2)
	((null? list2) list1)
	(else (cons (+ (car list1) (car list2))
		    (add-lists (cdr list1) (cdr list2))))))


;; 要素が1の無限リスト
(define ones (cons 1 ones))

(define integers (cons 1 (add-lists ones integers)))

;; 以上をlazy-evaluatorで評価
(load "./evaluator-lazy-memoized.scm")
(driver-loop)

(list-ref integers 17)
;; => 18

