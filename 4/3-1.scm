;; Nondeterministic computing
(define (prime-sum-pair list1 list2)
  (let ((a (an-element-of list1))
	(b (an-element-of list2)))
    (require (prime? (+ a b)))
    (list a b)))


(define (require p)
  (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

;;The stream procedure returns an object that represents the sequence of all
;;integers beginning with n, whereas the `amb' procedure returns a single
;;integer.(2)


  
