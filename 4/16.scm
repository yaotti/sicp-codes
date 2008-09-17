;; a. modify `lookup-variable-value` to support `*unassigned*`
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond [(null? vars)
	     (env-loop (enclosing-environment env))]
	    [(eq? var (car vars))
	     (if (eq? (car vals) '*unassigned*)
		 (error "UNASSIGNED value -- " (car vals))
		 (car vals))]
	    [else (scan (cdr vars) (cdr vals))]))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame)
		(frame-values frame)))))
  (env-loop env))

;; b. scan-out-defines
;; algorythm
1.proc-body内のs式を1つずつscanしていく
2.define節があればlet-valに加える(let-valは*unnasigned*リスト)&set!で束縛する
;; example
(lambda (a)
  (define g
    (lambda (b) (* b b)))
  (define h
    (lambda (p) (+ p p)))
  (g a))
;; =>
(lambda (a)
  (let ((g '*unassigned*)
	(p '*unassigned*))
    (set! g (lambda (b) (* b b)))
    (set! p (lambda (p) (+ p p)))
    (g a)))

;; definition
;; 内部手続きなしも考える
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (cddr p))
(define (scan-out-defines proc)
  (let ((paras (cadr proc))
	(body (cddr proc)))
    (list 'lambda paras (scan-loop body '() '()))))
;; 変換されたlambdaのbodyを作る
(define (scan-loop rest binds assigns)
  (if (eq? 'define (caar rest)) 
      (scan-loop (cdr rest)
		 (append binds
			 (list (list (cadar rest) '*unassigned*))) ;;let
		 (append assigns
			 (list (list 'set! (cadar rest) (caddar rest)))))
      ;;(list 'let binds assigns rest)))
      (append (append (list 'let binds) assigns) rest))) ;;appendがポイント!

;; test
;; input
(scan-out-defines
 '(lambda (x)
    (define id (lambda (p) p))
    (define no (lambda (x) x))
    (* (id x) (id x))))
;; output
;; don't check the answer of c.
(lambda (x)
  (let ((no *unassigned*)
	(id *unassigned*))
    (set! no (lambda (x) x))
    (set! id (lambda (p) p))
    (* (id x) (id x))))


;; c. install "scan-out-defines" into make-procedure or procedure-body
;; old-make-procedure
(define (old-make-procedure parameters body env)
  (list 'procedure parameters body env))


;; test function
(define proc '(lambda (a)
		(define id1 (lambda (p) p))
		(define id2 (lambda (x) x))
		(* (id1 a) (id2 a))))

;; install scan-out-defines in make-procedure
(define (make-procedure parameters body env)
  (list 'procedure parameters (caddr (scan-out-defines body)) env))
;; test
(make-procedure '(x) proc 'env)

;; output
(procedure (x)
	   (let ((id2 *unassigned*)
		 (id1 *unassigned*))
	     (set! id2 (lambda (x) x))
	     (set! id1 (lambda (p) p))
	     (* (id1 a) (id2 a))) env)

;; install scan-out-defines in procedure-body
(define (procedure-body p) (scan-out-defines (caddr p)))
(procedure-body (old-make-procedure '(x) proc 'env))

;; どちらに組込むのがいいか?
;; procedure-bodyがよい
;; 理由：内部手続きの評価を遅らせることができる
;; 手続き作成時ではなく、procedure-bodyを使う時まで評価されない

;; 以下解答より
;; make-procedureがよい
;; procedure-bodyは1つの手続きを作成した後、複数回呼ばれ(う)るが、
;; make-procedureは一度しか呼ばれないから