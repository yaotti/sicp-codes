;;(load "./amb.scm")
;;(driver-loop)
;; Parsing natural language
(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))

(define (parse-sentence)
  (list 'sentence
	(parse-noun-phrase)
	(parse-word verbs)))

(define (parse-noun-phrase)
  (list 'noun-phrase
	(parse-word articles)
	(parse-word nouns)))

;; memq
;; xを走査し，itemに等しい要素以下のリストを返す
;; gaucheでは組み込み
(define (memq item x)
  (cond ((null? x) false)
	((eq? item (car x)) x)
	(else (memq item (cdr x)))))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))

(define *unparsed* '())

(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))

(define prepositions '(prep for to in by with))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
	(parse-word prepositions)
	(parse-noun-phrase)))

(define (parse-sentence)
  (list 'sentence
	(parse-noun-phrase)
	(parse-verb-phrase)))

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
	 (maybe-extend (list 'verb-phrase
			     verb-phrase
			     (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))