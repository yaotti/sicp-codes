;; not checked yet
a.
(or (and (job (Ben Bitdiddle) ?division)
	 (meeting ?div (Friday ?time)))
    (meeting whole-company (Friday ?time)))
b.
(rule (meeting-time ?person ?day-and-time)
      (or (meeting whole-company ?day-and-time)
	  (and (job ?person ?division)
	       (meeting ?division ?day-and-time))))

c.
(meeting-time (Alyssa P Hacker) (Wednesday ?time))