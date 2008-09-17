;; 以下を超循環評価器で評価したときの流れを考える
(load "./evaluator.scm")
(driver-loop)
(define (test a)
  (if (> a 0)
      'positive
      'negative))
(test 1)
(test -1)

;; 定義部分
;; (define ...)
*まず(eval '(define ...) the-global-environment)が評価される@1-4.scm
;; ここでのevalは1-1.scmのもの
*次にevalのcond振り分けに入る@1-1.scm
definition?がtrueになるので、(eval-definition exp env)が評価
;; つまり(eval-definition '(define ...) the-global-environment)が評価
*eval-definitionを評価@1-1.scm
(define-variable! (definition-variable '(define ...))
  (eval (definition-value '(define ...)) the-global-environment)
  the-global-environment)

;; (define (definition-variable exp)
;;   (if (symbol? (cadr exp))
;;       (cadr exp)
;;       (caadr exp))) ;;いまの場合こっち
;;
;; (define (definition-value exp)
;;   (if (symbol? (cadr exp))
;;       (caddr exp)
;;       (make-lambda (cdadr exp) ;;こっち
;; 		   (cddr exp)))) 
*eval-definitionの展開(定義は@1-1.scm)
(define-variable! 'test
  (eval (make-lambda '(a) '(if ...)) the-global-environment)
  the-global-environment)

*define-variable!で環境に追加(定義は@1-3.scm)


;; ここまでで定義は終わり、次は評価
;; (test 1) 
*(eval '(test 1) the-global-environment)の評価

*application?にてtrue
以下が評価される@1-1.scm
(apply (eval (operator exp) env)
       (list-of-values (operands exp) env))
展開すると
(apply (eval test the-global-environment)
       (list-of-values '(1) the-global-environment)) ;;=> 評価すると (1)

;; evalの評価結果に含まれるpointerが自分自身を指してる→それはok
(apply (procedure (a) (if (> a 0) 'positive 'negative) (((test fa ...))))
       (1))





;; something i think
評価の形がおかしい?
-procedureとか無視して評価すべき
→実際は?
-@1-1.scmのfirst-expがifになっている
→ここでのptestの場合、first-expはproc本体の全体になるべき
;; とりあえずの解決策
(define (test a)
  ((if (> a 0)
      'positive
      'negative)))
とするとsequenceなのでfirst-expが本体になる



;; バグの原因
lambda-bodyでcddrのところをcaddrとしていた！
