(load "./evaluator-lazy-memoized.scm")
(driver-loop)
(define count 0)
(define (id x)
  (set! count (+ count 1))
  x)
(define w (id (id 10)))

まず評価結果の予想.
count
=>0
w
=>10
count
=>2

正解は
count
=>1
w
=>10
count
=>2

(以下wを評価してもcountは2のまま)

間違えたポイントは2つ.
1.wの定義時点で(set! count (+ count 1))が評価されている.
2.w評価時にidは1度しか評価されない.


1はok.

以下2についての考察
(id 10)が評価された時点で, "(id 10)は10を返す"ということがmemoizeされ, set!部が評価されていないのではないか.
検証

(set! the-global-environment (setup-environment))
(load "./evaluator-lazy.scm")
(driver-loop)
(define count 0)
(define (id x)
  (set! count (+ count 1))
  x)
(define w (id (+ 1 (id 10)))) ;;これならばid手続きは2回評価されるはず.
count
;; =>1
w
;; =>11
count
;; =>2
w
;; =>11
count
;; =>2

違う…

基本に戻り考えてみる.
lazy-evaluatorにおいて, 基本手続き以外での引数はnon-strictである.
よってidの引数は実行時(必要になった時)に評価される.
wの定義時にcountが+1されている
=>wが(id (id 10))に束縛される時, (id <thunk>)としてid手続きが1度実行されるから
そしてwを評価する時, 引数である(id 10)も評価されるのでcountが2になる.
その時, wはevaluated-thunkタグを付けられ, 値は10に束縛される.
以降はset!部は評価されない.


(参考)
*メモ化されていない遅延評価器では, wを評価するたびにcountが増える
=>引数はnon-strictなので, (wの定義での)最初のidの引数((id 10)のこと)は毎回評価されるから
=>set!部が毎回実行される

*4.1で実装した評価器では, 最初のcountの評価が2で, wを評価しても増えない
=>wは定数10に束縛されるから