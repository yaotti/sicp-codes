;; 実装してから実験する

;;evaluation must backtrack to a previous choice point.
;;これが今までの実装と違うところ.

;; 35を単に置き換えた式
(define (pythagorean-triples low)
  (let ((i (an-integer-starting-from low)))
    (let ((j (an-integer-starting-from low)))
      (let ((k (an-integer-starting-from low)))
	(require (= (+ (square i) (square j)) (square k)))
	(list i j k)))))

これでは, 2つの値を固定して1つの値のみバックトラックによる試行が行なわれる.
i, j, kの値が
(1 1 1)
(1 1 2)
(1 1 3)
(1 1 4)
...


これを避けるには, 明らかに不要である探索を行わないようにすることが必要.
例えば,  (< (+ (square i) (square j)) (square k))
となった場合はi,jを選び直す, など.


;; まだ試していない.
(define (pythagorean-triples low)
  (let ((i (an-integer-starting-from low))
	(j (an-integer-starting-from low))
	(k (an-integer-starting-from low)))
    (require (< (+ (square i) (square j)) (square k))
    (require (= (+ (square i) (square j)) (square k)))
    (list i j k))))
