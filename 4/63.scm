;; not checked

(rule (grandson ?s ?g)
      (and (son ?s ?f)
	   (son ?f ?g)))

(rule (son2 ?s ?m)
      (and (wife ?w ?m)
	   (son ?s ?w)))
