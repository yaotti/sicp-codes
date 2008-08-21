;; evalへの組込み->eval定義のcond節へ追加

(define (and? exp) (tagged-list? exp 'and))
(define (or? exp) (tagged-list? exp 'or))

(define (and-seq exp) (cdr exp))
(define (or-seq exp) (cdr exp))

(define (eval-and exp env)
  (let ((body (and-seq exp)))
    (if (null? body)
	'true
	(let ((first (eval (car body) env))
	      (rest (cdr body)))
	  (if first
	      (if (null? rest)
		  first
		  (eval-and rest env))
	      'false)))))

(define (eval-or exp env)
  (let ((body (or-seq exp)))
    (if (null? body)
	'false
	(let ((first (eval (car body) env))
	      (rest (cdr body)))
	  (if first
	      first
	      (eval-or (cdr rest) env))))))


;;; ifから導出する
(and) =>
'true

(and a1) =>
(let ((body a1))
  (if body body 'false))

(and a1 a2) =>
(let ((first a1)
      (second a2))
  (if first
      (if second
	  second
	  'false)
      'false))
;; letを使うのは評価を1度だけにするため(代入だと2度評価するとまずい)

(or) =>
'false

(or a1) =>
(if a1 a1 'false)

(or a1 a2) =>
(let ((first a1)
      (second a2))
  (if first
      first
      (if second
	  second
	  'false)))



;; 以上からand/orをifより導出
;; 節が1つの時は挙動一緒なんだな
(define (and->if body)
  (cond [(null? body) 'true]
	[(null? (cdr body))
	 (let ((body (car body)))
	   (make-if body body 'false))]
	[else (let ((first (car body))
		    (rest (cdr body)))
		(make-if first
			 (and->if rest)
			 'false))]))

(define (or->if body)
  (cond [(null? body) 'false]
	[(null? (cdr body))
	 (let ((body (car body)))
	   (make-if body body 'false))]
	[else (let ((first (car body))
		    (rest (cdr body)))
		(make-if first
			 first
			 (or->if rest)))]))
	 
  