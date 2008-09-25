;; 
(load "./evaluator-lazy-memoized.scm")
(driver-loop)
(define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))
(define (cdr z)
  (z (lambda (p q) q)))
;; ここまで前準備

;;(car (list 1 2 3))
;;=> error. listは遅延評価向けの定義をしていない.
(car (cons 1 2))
;; => 1
(car '(1 2))
;; => error.
;; '(1 2)は(lambda (m) (m x y))ではなく,(1 2)なので
(car z)
=>
(z (lambda (p q) p))
=>
((1 2) (lambda (p q) p))
;;で,エラー.

;;改善するには, '(a b c)を (cons a (cons b (cons c '())))と置き換える必要がある.
;; 1-2.scmの
(define (text-of-quotation exp) (cadr exp))
;; を変更する.

;; 以下を評価

(load "./evaluator-lazy-memoized.scm")
(define (text-of-quotation exp env)
  (let ((quoted-text (cadr exp)))
    (if (pair? quoted-text)
	(eval (quote->list quoted-text) env)
	quoted-text)))
;; これに対応して, evalの定義のtext-of-quotationが環境を見るように変更.
(define (quote->list q)
  (if (null? q)
      '()
      (list 'cons
       (car q)
       (quote->list (cdr q)))))
(driver-loop)
(define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))
(define (cdr z)
  (z (lambda (p q) q)))

'(1 2)
;; =>(compound-procedure (m) ((m x y)) <procedure-env>)
(car '(1 2))
;; => 1
ok.