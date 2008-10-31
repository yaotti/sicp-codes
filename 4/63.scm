;;(son father son)

(rule (grandson ?g ?s)
      (and (son ?f ?s)
	   (son ?g ?f)))

(rule (son2 ?m ?s)
      (and (wife ?m ?w)
	   (son ?w ?s)))
