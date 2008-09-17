;; not checked yet
a.導出された式としてletrecを定義

(letrec ((var1 exp1) (var2 exp2) ...)
  body)
を
(let ((var1 '*unassigned*)
      (var2 '*unassigned*)
      ...)
  (set! var1 exp1)
  (set! var2 exp2)
  ...
  body)
にする。
;; mapを超循環器で定義済みとする
(define (letrec->let exp)
  (let ((binds (cadr exp))
	(body (cddr exp))) ;;not (caddr exp)
    (cons 'let
	  (cons (map (lambda (x) (list (car x) ''*unassigned*)) binds)
		(append (map (lambda (x) (list 'set! (car x) (cadr x))) binds) body)))))
;; test
;; input
(letrec->let '(letrec ((fact
			(lambda (n)
			  (if (= n 1)
			      1
			      (* n (fact (- n 1)))))))
		(fact 10)))
;; output
(let ((fact '*unassigned*))
  (set! fact
	(lambda (n)
	  (if (= n 1)
	      1
	      (* n (fact (- n 1))))))
  (fact 10))

;; input
(letrec->let '(letrec ((even?
                      (lambda (n)
                        (if (= n 0)
                            true
                            (odd? (- n 1)))))
                     (odd?
                      (lambda (n)
                        (if (= n 0)
                            false
                            (even? (- n 1))))))
		'<REST OF BODY>))
;; output
(let ((even? #0='*unassigned*)
      (odd? #0#))
  (set! even? (lambda (n)
		(if (= n 0) true (odd? (- n 1)))))
  (set! odd? (lambda (n) (if (= n 0) false (even? (- n 1)))))
  '<REST OF BODY>)


b.困難の理由は、defineはそのブロック全てを見るが、letは逐次である、ということ。
2つの環境図はノートに。(まだ)