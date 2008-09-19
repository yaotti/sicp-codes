;;
analyze-sequenceに求められるのは, 
「環境(1)を引数に取り, analyze-sequenceの引数expsの各々をその環境(1)を引数として評価し, 最後の式の評価結果を返す手続き」を返すこと.
解析のみで評価はしない.

(define (analyze-sequence exps)
  (define (execute-sequence procs env)
    (cond ((null? (cdr procs)) ((car procs) env))
	  (else ((car procs) env)
		(execute-sequence (cdr procs) env))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
	(error "Empty sequence -- ANALYZE"))
    (lambda (env) (execute-sequence procs env))))

これでもよさそう...?




(analyze exp)をa-expとおく.
1つの式を与えたとき
*本文の版
(analyze-sequence (exp))
(loop a-exp '())
a-exp

*Alyssaの版
(analyze-sequence (exp))
(lambda (env) (a-exp env))

同じ.


2つの式を与えたとき
*本文の版
(analyze-sequence (exp1 exp2))
(loop a-exp1 (a-exp2))
(loop (lambda (env) (a-exp1 env) (a-exp2 env))
      ())
(lambda (env) (a-exp1 env) (a-exp2 env))

*Alyssaの
(analyze-sequence (exp1 exp2))
(lambda (env) (execute-sequence (a-exp1 a-exp2) env))
(lambda (env)
  (a-exp1 env) (a-exp2 env))

解析時には, この最後の式には到達しない.
つまり実行時にならなければexecute-sequenceは実行されないので, 解析できていないことになる.
(毎回(cdr procs)がnullか調べることになる)

;; 以下誤り!!というか余計なこと.

同じ.

3つのとき
*本文の版
(analyze-sequence (exp1 exp2 exp3))
(loop a-exp1 (a-exp2 a-exp3))
(loop (lambda (env) (a-exp1 env) (a-exp2 env))
      (a-exp3))
(loop (lambda (env)
	((lambda (env) (a-exp1 env) (a-exp2 env)) env)
	(a-exp3 env))
      ())
(lambda (env)
	((lambda (env) (a-exp1 env) (a-exp2 env)) env)
	(a-exp3 env))
;; (a-exp3 env)からはa-exp1やa-exp2の評価結果が見える.

*Alyssaの版
(lambda (env) (execute-sequence (a-exp1 a-exp2 a-exp3) env))
(lambda (env) ((a-exp1 env) (execute-sequence (a-exp2 a-exp3))))
(lambda (env) ((a-exp1 env) (a-exp2 env) (a-exp3 env)))
;; この場合は同じレベルで評価される.

