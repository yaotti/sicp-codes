;; not checked
(rule (replaceable ?person-1 ?person-2)
      (and (job ?person-1 ?job-1)
	   (job ?person-2 ?job-2)
	   (can-do-job ?job-1 ?job-2)
	   (not (same ?person-1 ?person-2))))

a.
(replaceable ?person (Cy D Fect))

b.
(and (replaceable ?person-1 ?person-2)
     (salary ?person-1 ?amount-1)
     (salary ?person-2 ?amount-2)
     (lisp-value > ?amount-1 ?amount-2))
