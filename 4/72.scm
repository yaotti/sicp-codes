1.disjoin
2.stream-flatmap

1.
disjoinでのinterleave-delayedの引数はqevalおよびdisjoin自身．
よってqevalのみについて考える．

qevalはsimple-queryとapply-rulesを足し合わせるため，無限ループに陥る可能性がある(原因はapply-rules)．
その場合，disjoinでのinterleave-delayedのqevalが無限ストリームになるため，単純にストリームを足し合わせるだけでは再帰的に呼ぶdisjoinの結果を使うことができない．(正確には先頭の1要素が使われ続ける)

appendの時
(disjoin s1 s2)
=>
(append-stream (eqval ...)
	       (disjoin ...))
=>
(append-stream infinite-stream
	       (disjoin ...))
=>
(infinite-stream-element1
 infinite-stream-element2
 ...
 )
;; (disjoin ...)の要素が出てこない


2.
stream-flatmap
appendで困る状況→引数のストリームが無限だった時．
stream-flatmapの引数はストリームのストリームなよう．
その中の1つのストリームが無限だったとき，問題が起こる．

