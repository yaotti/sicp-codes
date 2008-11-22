;; examples using the stream `ones`
(use util.stream)
(define ones1 (stream-cons 1 a))
(define ones2 (stream-cons 1 a))
(stream-ref ones1 10)
;; gosh> 1


(define (append-zero-to-ones1)
  (let ((ones ones1))
    (set! ones1
	  (stream-cons 0 ones))
    'ok))

(define (append-zero-to-ones2)
  (set! ones2
	(stream-cons 0 ones2))
  'ok)

(append-zero-to-ones1)
(stream->list (stream-take ones1 10))
;; gosh> (0 1 1 1 1 1 1 1 1 1)

(append-zero-to-ones2)
(stream->list (stream-take ones2 10))
;; gosh> (0 0 0 0 0 0 0 0 0 0)


;;ones2ではset!が再帰的に評価されている．(再帰的といってもstreamなので遅延評価)
;;なのでstreamをletによって別の局所変数に退避させ，それを利用して代入を行えばここで意図した通りになる．