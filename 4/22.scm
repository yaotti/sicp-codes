;; 解答を見た...
;; http://eli.thegreenplace.net/2007/12/14/sicp-sections-416-417/
((let? exp) (analyze (let->combination exp)))
をanalyzeに追加.
lambdaに変換したあとはlambdaと同じ.