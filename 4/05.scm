;; check every clauses
;; (eq? '=> (cadr clause))

;; (predicate action)
;; (predicate => recipient)
;; recipient is a procedure of one argument
(define (expand-clauses-imp clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(if (cond-else-clause? first)
	    (if (null? rest)
		(sequence->exp (cond-actions first))
		(error "ELSE clause isn't last -- COND->IF" clauses))
	    (if (eq? '=> (cadr first))
		(let ((test (cond-predicate first))
		      (recipient (caddr first)))
		  (make-if test
			   (recipient test)
			   (expand-clauses rest))))))))


;; 節単位
;; 1.null?
;; 2.else?
;; 2=#t 最後の節かどうか、違うならエラー
;; 3.testを評価
;; 4.trueなら=>かどうか評価する
;; 5.falseなら次の節に


(define (expand-clauses-ex clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(if (cond-else-clause? first) ;;else節かどうか
	    (if (null? rest)	      ;;else節はcondの最後にある
		(cond-actions first)
		(error "ELSE clause isn't last -- COND->IF" clauses))
	    (let ((test (cond-predicate first))) ;;else節でない
	      (make-if  test
			(if (eq? '=> (cadr first))
			    ((caddr first) test)
			    (sequence->exp (cond-actions first)))
			(expand-clauses-ex rest)))))))

;; definition for test

(define (sequence->exp seq)
  (cond ((null? seq) seq)
	((last-exp? seq) (first-exp seq))
	(else (make-begin seq))))
(define (cond-clauses exp)
  (cdr exp))
(define (cond-predicate clause)
  (car clause))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-actions clause)
  (cdr clause))
(define (cond->if exp)
  (expand-clauses-ex (cond-clauses exp)))
      



(cond->if '(cond ((#f 1)
		  (#t 2))))