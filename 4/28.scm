なぜoperatorにactual-valueを使うか.
((application? exp)
 (apply (actual-value (operator exp) env)
	(operands exp)
	env))

actual-valueを使う(つまり手続きをthunkにする)のは, 引数に手続きを取るとき.
引数に取られた手続きはthunk化されるが, それをoperatorとして使う時にforce-itしなければ手続きとして使えない.

例
(load "./evaluator-lazy.scm")
(driver-loop)
(define add (lambda (x) (+ x 1)))
(define (f proc arg) (proc arg))
(f add 10)

ここで, actual-valueを使わなければ(<thunked-object> 10)となりエラー.
