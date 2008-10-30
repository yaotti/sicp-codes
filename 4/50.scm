;; not checked

;; remove first element equal to item from list
;; ここでは1つだけ取り除く．全て取り除いたほうがいいかもしれない
(define (remove item lis)
  (cond [(null? lis) '()]
	[(eq? item (car lis)) ;;eq? equal? eqv?
	 (cdr lis)]
	[else
	 (cons (car lis) (remove item (cdr lis)))]))

(define (random-choice lis)
  (nth lis
       (remainder (sys-random) (length lis))))

(define (nth lis index)
  (cond [(null? lis) '()]
	[(= index 0) (car lis)]
	[else
	 (nth (cdr lis)
	      (- index 1))]))


(define (analyze-ramb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	    (fail)
	    ((ramdom-choice choices) env
	     succeed
	     (lambda ()
	       (try-next
		(remove (car item) choices)))))) ;; remove chosen item
      (try-next cprocs))))
