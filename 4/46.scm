;; maybe it's right:p
parse-verb-phraseやparse-noun-phraseで，(amb sth self)と右側の被演算子に自分自身を置いているため，右側から評価すると自身を呼び出しつづける無限ループに陥るため．