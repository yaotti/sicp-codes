;; not checked
(rule (big-shot ?person ?division)
      (and (job ?person ?division)
	   (supervisor ?person ?person-2)
	   (not (job ?person-2 ?division))))