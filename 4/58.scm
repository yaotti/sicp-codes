;; not correct
(rule (big-shot ?person ?division)
      (and (job ?person ?division)
	   (supervisor ?person ?person-2)
	   (not (job ?person-2 ?division))))

;; supervisorがいない場合&部署の区分の対応が抜けている

(rule (big-shot ?person ?division)
      (and (job ?person (?division . ?r))
	   (or (not (supervisor ?person ?boss))
	       (and (supervisor ?person ?boss)
		    (not (job ?person-2 (?division . ?q)))))))

;; ?r, ?qは部署の細かい分類．