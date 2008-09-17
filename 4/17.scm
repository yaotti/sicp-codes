;; まだ解けてない
;; 解答チェックはまだ


;; 環境図はノートに

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
行動が同じなのは、lambdaを評価するとき内側のフレームを見るため、*unassigned*のフレームを見ることはないから
余分なフレームを作らないには?
