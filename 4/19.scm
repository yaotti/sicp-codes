Evaを支持する。
内部手続きにおいては、そのブロックすべてを見えるようにしておくべきである。(つまり逐次でない)

(let ((a 1))
  (define (f x)
    (define b (+ a x))
    (define a 5)
    (+ a b))
  (f 10))

を、

(let ((a 1))
  (define (f x)
    (let ((b '*unassigned*)
	  (a '*unassigned*))
      (set! b (lambda () (+ a x)))
      (set! a 5)
      (+ a (b))))
    (f 10))

内部定義にて定数でない場合は、set!時に評価されないよう遅延評価を利用する(lambdaで実装)
;; 正確にはfもletで*unassigned*に束縛すべきだが、ここでは略


;; 以下解答より
内部定義が
(define a (+ b 1))
(define b (+ a 1))
のような場合があるので、一般的な解法は無理。
例えば
(let ((a 1))
  (define (f x)
    (let ((b '*unassigned*)
	  (a '*unassigned*))
      (set! b (lambda () (+ (a) x)))
      (set! a (lambda () (+ (b) x)))
      (+ (a) (b))))
    (f 10))
だと無限ループ。
;; Gaucheでは、確定する場合はEvaの理論にて評価する。
;; 上記の(f 10)は20を返す。