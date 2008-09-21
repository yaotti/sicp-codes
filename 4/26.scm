Ben:
it's possible to implement `unless` in applicative order as a special form.

Alyssa:
if one did (as Ben said), `unless` would be merely syntax, not a procedure


drived expressionとして組込む
;; (unless conditional exceptional-value usual-value)
;; (unless false 1)は'falseを返す
(define (unless? exp) (tagged-list? exp 'unless))
(define (unless-conditional exp) (cadr exp))
(define (unless-exceptional exp) (caddr exp))
(define (unless-usual exp)
  (if (not (null? (cadddr exp)))
      (cadddr exp)
      false))
(define (unless->if exp)
  (let ((conditinal (unless-conditional exp))
	(exceptional (lambda () (unless-exceptional exp)))
	(usual (lambda () (unless-usual exp))))
    (make-if conditinal
	(usual)
	(exceptional))))
;; evalに追加
((unless? exp) (eval (unless->if exp) env))
(load "./evaluator.scm")
(driver-loop)

(define (fact n)
  (unless (= n 1)
    (* n (fact (- n 1)))
    1))
(fact 10)
;; output
;;; M-Eval value:
3628800

ok.


syntaxは高階手続きの引数に使えない.
よってunlessは手続きとしてあったほうがいい, というのがAlyssaの意見.

有用である例は, unlessを高階手続きに組込みたいとき.(ifのような条件分岐を引数にとりたいとき)
=>具体例が思い浮ばない
