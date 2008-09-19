(define (let? exp)
  (tagged-list? exp 'let))

(define (let-binds exp)
  (cadr exp))

(define (let-body exp) ;;not (body), body
  (caddr exp))

;; (define (let-vars exp)
;;   (if (null? (let-binds exp))
;;       '()
;;       (cons (caar (let-binds exps))
;; 	    (let-vars (cdr (let-binds exp))))))

;; (define (let-exps exp env)
;;   (if (null? (let-binds exp))
;;       '()
;;       (cons (eval (cadar (let-binds exp)) env)
;; 	    (let-exps (cdr (let-binds exp))))))

;; (define (let->combination exp env)
;;   ;;(list
;;   (cons
;;    (make-lambda (let-vars (let-binds exp))
;; 		(let-body exp))
;;    (let-exps (let-binds exp) env)))

;; fix

(define (let->combination exp)
  (cons
   (make-lambda (map car (let-binds exp))
		(let-body exp))
   (map cdr (let-binds))))

;; evalはしない?
;; =>lambdaに変換してから行う.
;; evalの定義に以下を追加.
((let? exp) (eval (let->combination exp) env))