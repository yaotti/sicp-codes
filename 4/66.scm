;; not checked
Benのシステム
質問をqvalに送りこむ→満たすフレームのストリームを生成する
→各フレームの変数を取り出し(map)，accumulate-functionに渡す

うまくいきそう．きちんとした結果が得られないのはCy D Fectの部分&無限ループ(例で出ていたmarried)関係だけ?


対処
変数(問題での<variable>)を一意に決める他の変数の重複を許さないようにする．
例えば問題のsumならば，(salary ?x ?amount)の?xは重複しないように．

Ex 67にも繋がる．