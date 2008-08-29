;; how to use
(define (sum n)
  (let ((result 0))
    (for (i 0) (<= i 5) (set! i (+ i 1))
	 (set! result (+ result i)))))
=> 15

;; form
(for (var exp) pred proc body)

loop process
1. binding var to exp
2. check pred whether it is true or false
3. if pred is true, eval body(returns nothing)
3'. if pred is false, return the value of body evaled at the process 2 of the previous loop
4. eval proc (returns nothing)
5. return the process 2

* if the first check of pred is false, return error


1. varをexpに束縛する
2. predの真偽を調べる
3. predがtrueなら、bodyを評価する(値は返さない)
3'. predが偽なら、前のループで評価された時のbodyの値を返す
4. procを評価する(値は返さない)
5. 2に戻る

* 最初のループでpredが偽と評価された場合はエラーを返す


;; derived expression
;; iteration

;; bodyの評価の問題(引数として評価してはいけない)
(define (for-iter pred proc body result)
  (if pred
      result
      (begin proc
	     (for-iter pred proc body body))))
	

(define (for init pred proc body)
  ;; initialize
  (let ((var (car init))
	(init-val (cadr init)))
    (let ((var init-val)
	  (val body))
      (for-iter pred proc body val))))