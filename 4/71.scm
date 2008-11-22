Mickyの例のように，探索が止まらなくなる規則があるから?

→誤り．delayを使っても規則の無限ループは止められない．
ただ評価を遅らせることで，assertionの印字は行われる．(止まらない)
ruleの適用は(内部にて)無限に続く．

例
(assert! (loop a))
(assert! (loop b))
(assert! (rule (loop ?x)
	       (loop ?x)))
(loop ?answer)

delayを使わない評価器なら，印字せずにapply-a-ruleが回り続ける

同様にdisjoinでdelayを使わなければ，以下のような規則で印字のないループ
(assert! (loop-2 ?x)
	 (or (job ?x ?y)
	     (loop-2 ?x)))



