;; すべての可能性のリストからなるリストを作り, チェックしたのち表示する．
;; 改善の余地あり
(define (flatmap proc seq)
  (if (null? seq)
      '()
      (append (car (map proc seq))
		(flatmap proc (cdr seq)))))
(define (permutations s)
  (if (null? s)                 
      (list s)
      (flatmap (lambda (x)
		 (map (lambda (p) (cons x p))
		      (permutations (remove x s))))
	       s)))
(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
	  sequence))
(permutations '(1 2 3))

;; make all lists
;; 要素が1~nであるすべてのリストのリストを返す
(use srfi-1)
(define (multiple-dwelling)
  (define (check elt)
    (let ((baker (car elt))
	  (cooper (cadr elt))
	  (fletcher (caddr elt))
	  (miller (cadddr elt))
	  (smith (caddr (cddr elt))))
      (if (and (not (= baker 5))
	       (not (= cooper 1))
	       (not (= fletcher 5))
	       (not (= fletcher 1))
	       (> miller cooper)
	       (not (= (abs (- smith fletcher)) 1))
	       (not (= (abs (- fletcher cooper)) 1)))
	  (list (list 'baker baker)
		(list 'cooper cooper)
		(list 'fletcher fletcher)
		(list 'miller miller)
		(list 'smith smith))
	  '())))
  (flatmap check (permutations (iota 5 1))))
  




;; my worse answer
(define (flatmap proc seq)
  (if (null? seq)
      '()
      (append (car (map proc seq))
		(flatmap proc (cdr seq)))))
;; n番目に要素を追加する手続き
(define (add-atom elt atom n)
  (cond ((> n (length elt))
	 (append elt (list n)))
	((= n 0) (cons atom elt))
	(else (cons (car elt)
		    (add-atom (cdr elt) atom (- n 1))))))
;; 1つ要素を追加したリスト群を作る手続き
(define (add-atom-lists elt atom)
  (define (iter num)
    (if (< num 0)
	'()
	(cons (add-atom elt atom num)
	      (iter (- num 1)))))
  (iter (length elt)))
(define (make-lists n)
  (define (iter num)
    (if (= num 0)
	(list '())
	(flatmap (lambda (elt) (add-atom-lists elt num))
		 (iter (- num 1)))))
  (iter n))

(define (multiple-dwelling2)
  (define (check elt)
    (let ((baker (car elt))
	  (cooper (cadr elt))
	  (fletcher (caddr elt))
	  (miller (cadddr elt))
	  (smith (cadddr (cdr elt))))
      (if (and (> miller cooper)
	       (not (= baker 5))
	       (not (= cooper 1))
	       (not (= fletcher 5))
	       (not (= fletcher 1))
	       (> miller cooper)
	       (not (= (abs (- smith fletcher)) 1))
	       (not (= (abs (- fletcher cooper)) 1)))
	  (list (list 'baker baker)
		(list 'cooper cooper)
		(list 'fletcher fletcher)
		(list 'miller miller)
		(list 'smith smith))
	  '())))
  (flatmap check (make-lists 5)))

(use gauche.time)
(time (multiple-dwelling))
;; output
;(time (multiple-dwelling))
; real   0.020
; user   0.020
; sys    0.000
((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))


(time (multiple-dwelling2))
;; output
;(time (multiple-dwelling2))
; real   0.004
; user   0.000
; sys    0.000
((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
