;; 4.4 Logic Programming
;; unification

(define (append x y)
  (if (null? x)
	  y
	  (cons (car x) (append (cdr x) y))))

;; the procedure can't answer:
;;      Find a list `y' that `append's with `(a b)' to produce `(a b c d)'.
;;      Find all `x' and `y' that `append' to form `(a b c d)'.

;; 4.4.1 Deductive information Retrieval
;; 推論的情報検索

(table-type (Lastname Firstname) contents)

;;for example
(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))


;; Simple queries

;;; Query input:
(job ?x (computer programmer))

;;; Query results:
(job (Hacker Alyssa P) (computer programmer))
(job (Fect Cy D) (computer programmer))

(address ?x ?y)
;;はすべての社員をリストする．

(job ?x (computer . ?type))



;; Compound queries
and, or, not, lisp-value


(lisp-value <predicate> <arg1> ... <argn>)

;;example
(and (salary ?person ?amount)
	 (lisp-value > ?amount 30000))


;; Rules

(rule (lives-near ?person-1 ?person-2)
	  (and (address ?person-1 (?town . ?rest-1))
		   (address ?person-2 (?town . ?rest-2))
		   (not (same ?person-1 ?person-2))))

(rule <conclusion> <body>)

