;; 解答チェックはまだ

;; 環境図はノートに
(lambda (vars)
  (define u <e1>)
  (define v <e2>)
  <e3>)

(lambda (vars)
  (let ((u '*unassigned*)
	(v '*unassigned*))
    (set! u <e1>)
    (set! v <e2>))
  <e3>)
letをlambdaにして書きなおすと、
(lambda (vars)
  ((lambda (u v)
     (set! u <e1>)
     (set! v <e2>))
   '*unassigned* '*unassigned*)
  <e3>)
となる

無駄な環境ができるのはletで最初にフレームを作るから(*unassigned*に束縛)
行動が同じなのは、(lambda (vars) ...)を評価するときはuやvが*unassigned*に束縛されたのより外側のフレームで評価されるため、*unassigned*のフレームを見ることはないから

余分なフレームを作らないには?
varsの束縛されるフレームにunassignedの束縛も入れる。=>無理
大域環境で*unassigned*に束縛=>荒い

(define u '*unassigned*)
(define v '*unassigned*)
(lambda (vars)
  (set! u <e1>)
  (set! v <e2>)
  <e3>)