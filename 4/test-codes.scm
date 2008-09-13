;;; these are test codes for the evaluator implementation

;; for ex 11, 12

;; test codes
(define f (make-frame '(a b c) '(2 4 6)))
;;(frame-variables f)
;; =>(a b c)
;;(frame-values f)
;; =>(2 4 6)
(add-binding-to-frame! 'x 1 f)
;; =>((a . 2) (b . 4) (c . 6) (x . 1))
(extend-environment '(x y z) '(10 20 30) f)
;; =>(((x . 10) (y . 20) (z . 30)) (a . 2) (b . 4) (c . 6) (x . 1))

;; definition of environment
(define global-frame (make-frame '() '()))
(define env (extend-environment (frame-variables f) (frame-values f) global-frame))
;; =>(((a . 2) (b . 4) (c . 6) (x . 1)))
(define ex-env (extend-environment '(x y z) '(10 20 30) env))
ex-env
;; =>(((x . 10) (y . 20) (z . 30)) ((a . 2) (b . 4) (c . 6) (x . 1)))
(lookup-variable-value 'x ex-env)
;; => 10
(lookup-variable-value 'x (enclosing-environment ex-env))
;; => 1
(set-variable-value! 'c 60 env)
(lookup-variable-value 'c env)
;; =>60

;; test "define-variable!"
ex-env
;; =>(((x . 10) (y . 20) (z . 30)) ((a . 2) (b . 4) (c . 60) (x . 1))) 
(define-variable! 'x 2 ex-env)
ex-env
;; =>(((x . 2) (y . 20) (z . 30)) ((a . 2) (b . 4) (c . 60) (x . 1)))
(define-variable! 'a 12 ex-env)
;; =>((x . 2) (y . 20) (z . 30) (a . 12))

;; ex 13
(make-unbound! 'x env)
