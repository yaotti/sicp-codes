;; 問題のように、まずbodyを束縛する意味は?
;; =>特になさそう。実験的なもの。


(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

;; 問題文のように掃き出す
(define solve
  (lambda (f y0 dt)
    (let ((y '*unassigned*)
	  (dy '*unassigned*))
      (let ((a (integral (delay dy) y0 dt))
	    (b (stream-map f y)))
	(set! y a)
	(set! dy b)))
    y))

;; 動かないはず。(stream-map f y)でyは*unassigned*なのでエラー。

;; 本文のように掃き出す

(define solve
  (lambda (f y0 dt)
    (let ((y '*unassigned*)
	  (dy '*unassigned*))
      (set! y (integral (delay dy) y0 dt))
      (set! dy (stream-map f y))
      y)))

;; 動くはず。yは(stream-map f y)の前に束縛される。
;; integralの方はdelayに包まれているので、set!の時点では評価されない。