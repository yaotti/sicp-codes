a.
(define (simple-stream-flatmap proc s)
  (simple-flatten (stream-map proc s)))

(define (simple-flatten stream)
  (stream-map
   stream-car
   (stream-filter
    (lambda (s) (not (stream-null? s)))
    stream)))

b.
it works well, i think.


なぜ本文でこうしてないのか(interleaveを使っているのか)不明．
何をしているかはわかる．結局はfilteringかな．

