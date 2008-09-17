(define (run-forever) (run-forever))
(define (try p)
  (if (halts? p p) ;;(p p)が止まるか?
      (run-forever)
      'halted))

(p p)が止まるなら永遠に動くrun-forever手続きを呼ぶ。
止まらないならhaltedと表示。


*解答
(try try)を評価する。(以下このS式を(1)とする)

まず、(1)が止まらないなら、この評価は終わらない。

止まるならば、if節の(halts? p p)はtrue。
よって(1)は(run-forever)を呼び、止まらない。
これは矛盾するので(try try)は止まらない。

止まらないならば、'haltedと表示されるはずであるが、そうはならない。
よってこのtry手続きは実装できない。
つまりhalts?が書けるという仮定が誤り。

