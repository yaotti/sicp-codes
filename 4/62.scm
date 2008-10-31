;; not checked

(rule (last-pair ?x ?x))
(rule (last-pair (?y . ?z) ?x)
      (last-pair ?z ?x))


;; 空リストを考慮していないので修正
(rule (last-pair (?x) (?x)))
(rule (last-pair (?y . ?z) (?x))
      (last-pair ?z (?x)))

(last-pair ?x (3))を評価
最後が3であるリストは無限にあるため，この質問は正しく働かないと考えられる．