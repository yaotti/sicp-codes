;; まだ試していない．

;; Mary Ann Moore, Colonel Downing, Mr. Hall, Sir Barnacle Hood, and Dr.  Parker
;; (list father daughter yacht)

father:   moore   downing   hall   hood   paker
daughter: moore-d downing-d hall-d hood-d paker-d
yacht:    moore-y downing-y hall-y hood-y paker-y

;; リストで表現する．
(list "father's name" "daughter's name" "yacht's name")

(define (daughter-puzzle)
  (define (get-d elt)
    (cadr elt))
  (define (get-y elt)
    (caddr elt))
  (define (check-y-d elt)
    (equal? (cadr elt) (caddr elt)))
;;   (let ((daughters (list 'gabrielle 'lorna 'rosalind 'melissa))
;; 	(yachts (list 'gabrielle 'lorna 'rosalind 'melissa 'mary)))
  (let ((daughters '(gabrielle lorna rosalind melissa))
	(yachts '(gabrielle lorna rosalind melissa mary)))
    (display "here")
    (let ((moore (list 'moore 'mary (amb yachts)))
	  (downing (list 'downing (amb daughters) (amb yachts)))
	  (hall (list 'hall (amb daughters) (amb yachts)))
	  (hood (list 'hood (amb daughters) (amb yachts)))
	  (paker (list 'paker (amb daughters) (amb yachts))))
      ;; different name between the yacht and the daughter respectively
      (require (not (check-y-d moore)))
      (require (not (check-y-d downing)))
      (require (not (check-y-d hall)))
      (require (not (check-y-d hood)))
      (require (not (check-y-d paker)))
      ;; each condition
      (require (equal? (get-y hood) 'gabrielle))
      (require (equal? (get-y moore) 'lorna))
      (require (equal? (get-y hall) 'rosalind))
      (require (equal? (get-y downing) 'melissa))
      (require (equal? (get-d hood) 'melissa))
      (let ((gab-father (amb (moore downing hall hood paker))))
	(require (equal? (get-y gab-father) (get-d paker)))
	(list moore downing hall hood paker)))))