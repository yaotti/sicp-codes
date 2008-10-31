(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
	(hsq (square high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (square i) (square j))))
	(require (>= hsq ksq))
	(let ((k (sqrt ksq)))
	  (require (integer? k))
	  (list i j k))))))


この定義なら, (square high)と (+ (square i) (square j))の大きさを比較しているため,
明らかに誤りである選択肢を探索しない.
対して35では全ての整数の組合せから選択する.
