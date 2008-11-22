(load "./evaluators/query-system.scm")
(define (uniquely-asserted unique-query frame-stream)
  (stream-flatmap
   (lambda (frame)
     (let ((s (qeval (car unique-query) (singleton-stream frame))))
       (cond ((stream-null? s) the-empty-stream)
	     ((stream-null? (stream-cdr s))
		 (singleton-stream frame))
	     (else the-empty-stream))
       ))
   frame-stream))
(put 'unique 'qeval uniquely-asserted)

;; test
(query-driver-loop)
;; after evaluating microshaft database.
(unique (job ?x (computer wizard)))
(and (job ?x ?j)
     (unique (job ?anyone ?j)))

;;ok