(rule (replaceable ?person-1 ?person-2)
      (and (job ?person-1 ?job-1)
	   (job ?person-2 ?job-2)
	   (can-do-job ?job-1 ?job-2)
	   (not (same ?person-1 ?person-2))))
;; can-do-jobが(can-do-job a a)でも良いならこれでok．
;; 引数が同じ職業なら満たさないとすると，orでjobが同じ条件と繋ぐ
;; わかりにくいので式で書くと以下
(rule (replaceable ?person-1 ?person-2)
      (and (or (and (job ?person-1 ?job-1)
		    (job ?person-2 ?job-2)
		    (can-do-job ?job-1 ?job-2))
	       (and (job ?person-1 ?job)
		    (job ?person-2 ?job)))
	   (not (same ?person-1 ?person-2))))

a.
(replaceable ?person (Cy D Fect))

b.
(and (replaceable ?person-1 ?person-2)
     (salary ?person-1 ?amount-1)
     (salary ?person-2 ?amount-2)
     (lisp-value > ?amount-2 ?amount-1))
