;; maybe correct:p
全てのパターンと，その時のフレームの組が必要．
パターンではなくruleでも良いかもしれない．

e.g.
(married ?who Mickey)
=>
(married Minnie Mickey)
(married Mickey ?who)
=>(1つ目は停止，2つ目をパターンマッチorユニフィケーション)
(married ?who Mickey)

ここで止まってほしい．しかし現在の実装では最初に戻って止まらない．


対処
((married (?who Mickey)
	  (Mickey ?who)
	  (Minnie Mickey))
 (job (hoge fuga)
      ...))

のように，ルールorパターンと，その引数を，パターンマッチ&ユニフィケーションを行うごとに保存する．
そしてパターンマッチ&ユニフィケーションのたびにデータベースと同様検索を行い，同じものがないか見にいく．
あれば停止する．

