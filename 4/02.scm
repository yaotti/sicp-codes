a. 代入の前に持ってくると、evalで(define x 3)はapplicationであると判定され、(apply (eval 'define env) (list-of-values '(x 3) env))のように展開される。これはdefineという手続きを(x 3)というリストに作用されると判断されてしまう。

b.application?を以下のように変更する
(define (application? exp) (tagged-list? exp 'call))
また、evalのcond節のapplication部分を以下のよう変更
((application? exp) (let ((body (cdr exp)))
		      (apply (eval (operator exp) env)
			     (list-of-values (operands exp) exp))))


						   