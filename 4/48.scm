;; not checked yet
;; 4.3.3にて実装後試す

;; implementing the adjective parser
(define adjectives
  '(adjective good bad old new))
(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
	(parse-word articles)
	(parse-word adjectives)
	(parse-word nouns)))
;;=>誤り．adjectiveがあるとは限らない．
;; 以下解答
(define (parse-simple-noun-phrase)
  (amb (list 'simple-noun-phrase
	     (parse-word articles)
	     (parse-word nouns))
       (list 'adjective-noun-phrase
	     (parse-word articles)
	     (parse-word adjectives)
	     (parse-word nouns))))



(parse '(This is a good cat))

;; undefined?

;; implementing the adverb parser