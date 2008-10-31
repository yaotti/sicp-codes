a.
(meeting ?div (Friday . ?time))
b.
(rule (meeting-time ?person ?day-and-time)
      (or (meeting whole-company ?day-and-time)
;; 	  (and (job ?person ?division)
;; 	       (meeting ?division ?day-and-time))
	  (and (job ?person (?div . ?r))
	       (meeting ?div ?day-and-time))
	  ))

c.
(meeting-time (Alyssa P Hacker) (Wednesday ?time))