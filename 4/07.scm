;; ex 4.7
(define (let*-binds exp) (cadr exp))
(define (let*-body exp) (caddr exp))
(define (make-nested-lets binds body)
  (if (null? binds)
      body
      (list 'let (list (car binds))
	    (make-nested-lets (cdr binds) body))))
(define (let*->nested-lets exp)
  (make-nested-lets (let*-binds exp)
		    (let*-body exp)))

;; test
(let*->nested-lets '(let* ((a 1) (b 2))
		      (lambda (x) (+ x a b))))
;;=>(let ((a 1)) (let ((b 2)) (lambda (x) (+ x a b))))
;; (let ((a 1))
;;   (let ((b 2))
;;     (lambda (x) (+ x a b))))
