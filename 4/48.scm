;; not checked yet
;; 4.3.3にて実装後試す

;; implementing the adjective parser
(define adjectives
  '(good bad old new))
(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
	(parse-word articles)
	(parse-word adjectives)
	(parse-word nouns)))

(parse '(This is a good cat))

;; implementing the adverb parser