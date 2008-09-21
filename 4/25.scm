(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))
(define (factorial n)
  (unless (= n 1)
    (* n (factorial (- n 1)))
    1))
(factorial 3)
;; => enter an infinite loop.

正規順序ならexceptional-valueは必要なときしか評価されないので, うまく動く.

