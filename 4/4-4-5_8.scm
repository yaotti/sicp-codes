;; 4.4.4.5 Maintaining the Data base

(define THE-ASSERTIONS the-empty-stream)

(define (fetch-assertions pattern frame)
  (if (use-index? pattern)
      (get-indexed-assertions pattern)
      (get-all-assertions)))

(define (get-all-assertions) THE-ASSERTIONS)

(define (get-indexed-assertions pattern)
  (get-stream (index-key-of pattern) 'assertion-stream))

(define (get-stream key1 key2)
  (let ((s (get key1 key2)))
    (if s s the-empty-stream)))


(define THE-RULES the-empty-stream)

(define (fetch-rules pattern frame)
  (if (use-index? pattern)
      (get-indexed-rules pattern)
      (get-all-rules)))

(define (get-all-rules) THE-RULES)

(define (get-indexed-rules pattern)
  (stream-append
   (get-stream (index-key-of pattern) 'rule-stream)
   (get-stream '? 'rule-stream)))


(define (add-rule-or-assertion! assertion)
  (if (rule? assertion)
      (add-rule! assertion)
      (add-assertion! assertion)))

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
	  (stream-cons assertion old-assertions))
    'ok))

(define (add-rule! rule)
  (store-rule-in-index rule)
  (let ((old-rules THE-RULES))
    (set! THE-RULES (stream-cons rule old-rules))
    'ok))

(define (store-assertion-in-index assertion)
  (if (indexable? assertion)
      (let ((key (index-key-of assertion)))
	(let ((current-assertion-stream
	       (get-stream key 'assertion-stream)))
	  (put key
	       'assertion-stream
	       (stream-cons assertion
			    current-assertion-stream))))))


(define (store-rule-in-index rule)
  (if (indexable? rule)
      (let ((key (index-key-of rule)))
	(let ((current-rule-stream
	       (get-stream key 'rule-stream)))
	  (put key
	       'rule-stream
	       (stream-cons rule
			    current-rule-stream))))))


(define (indexable? pat)
  (or (constant-symbol? (car pat))
      (var? (car pat)))) ;;!!

;; パターンのcarが変数ならkeyは"?"，そうでないならcar
;; このindexを使って表へ格納する
(define (index-key-of pat)
  (let ((key (car pat)))
    (if (var? key) '? key)))

;; (put 'key 'rule/assertion-stream
;;           (stream-cons rule/assertion concurrent-rule/assertion-stream))

(define (use-index? pat)
  (constant-symbol? (car pat)))



;; 4.4.4.6 Stream Operations

(define (stream-append-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (stream-cons
       (stream-car s1)
       (stream-append-delayed (stream-cdr s1) delayed-s2))))

(define (interleave-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (stream-cons
       (stream-car s1)
       (interleave-delayed (force delayed-s2)
			   (delay (stream-cdr s1))))))

(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))

(define (flatten-stream stream)
  (if (stream-null? stream)
      the-empty-stream
      (interleave-delayed
       (stream-car stream)
       (delay (flatten-stream (stream-cdr stream))))))

;;; test begin
(use util.stream)
(define s1 (stream-cons 1 s1))
(define s2 (stream-cons 2 s2))
(define s1-append-s2
  (stream-append-delayed s1 (delay s2)))
(define s1-inter-s2
  (interleave-delayed s1 (delay s2)))
(stream->list (stream-take s1-append-s2 10))
;; gosh> (1 1 1 1 1 1 1 1 1 1)
(stream->list (stream-take s1-inter-s2 10))
;; gosh> (1 2 1 2 1 2 1 2 1 2)
;;; test end


(define (singleton-stream x)
  (stream-cons x the-empty-stream))


;; 4.4.4.7 Query Syntax Procedures

(define (type exp)
  (if (pair? exp)
      (car exp)
      (error "Unknown expression TYPE" exp)))

(define (contents exp)
  (if (pair? exp)
      (cdr exp)
      (error "Unknown expression CONTENTS" exp)))

(define (assertion-to-be-added? exp)
  (eq? (type exp) 'assert!))

(define (add-assertion-body exp)
  (car (contents exp)))

;; and
(define (empty-conjunction? exp) (null? exp))
(define (first-conjunct exps) (car exps))
(define (rest-conjunct exps) (cdr exps))

;; or
(define (empty-disjunction? exp) (null? exp))
(define (first-disjunct exps) (car exps))
(define (rest-disjunct exps) (cdr exps))

;; not
(define (negated-query exps) (car exps))

;; lisp-value
(define (predicate exps) (car exps))
(define (args exps) (cdr exps))


(define (rule? statement)
  (tagged-list? statement 'rule))

(define (conclusion rule) (cadr rule))

(define (rule-body rule)
  (if (null? (cddr rule)
	     '(always-true)
	     (caddr rule))))


;; `query-driver-loop' calls `query-syntax-process' to transform patterns
;; like `?symbol' to `(? symbol)'

(define (query-syntax-process exp)
  (map-over-symbols expand-question-mark exp))

(define (map-over-symbols proc exp)
  (cond ((pair? exp)
	 (cons (map-over-symbols proc (car exp))
	       (map-over-symbols proc (cdr exp))))
	((symbol? exp) (proc exp))
	(else exp)))

(define (expand-question-mark symbol)
  (let ((chars (symbol->string symbol)))
    (if (string=? (substring chars 0 1) "?")
	(list '?
	      (string->symbol
	       (substring chars 1 (string-length chars))))
	symbol)))

;; test
;; (query-syntax-process '(?a ?b))
;; gosh> map-over-symbols


(define (var? exp)
  (tagged-list? exp '?))

(define (constant-symbol? exp) (symbol? exp))

(define  rule-counter 0)

(define (new-rule-application-id)
  (set! rule-counter (+ 1 rule-counter))
  rule-counter)

(define (make-new-variable var rule-application-id)
  (cons '? (cons rule-application-id (cdr var))))


(define (contract-question-mark variable)
  (string->symbol
   (string-append "?"
		  (if (number? (cadr variable))
		      (string-append (symbol->string (caddr variable))
				     "-"
				     (number->string (cadr variable)))
		      (symbol->string (cadr variable))))))

;; 4.4.4.8
(define (make-binding variable value)
  (cons variable value))

(define (binding-variable binding)
  (car binding))

(define (binding-value binding)
  (cdr binding))

(define (binding-in-frame variable frame)
  (assoc variable frame))

(define (extend variable value frame)
  (cons (make-binding variable value) frame))
