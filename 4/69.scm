;; not checked

((great grandson) ?g ?ggs)

;; ?relが(great great grandson)のような関係を表すかチェックする規則
(rule (relationship ?rel)
      (or (relationship grandson)
	  (and (relationship (great . ?rel-2))
	       (relationship ?rel-2))))

;; (son a b)のような場合
(rule (?rel ?x ?y)
      (son ?x ?y)
      (wife ?x ?y)
      (grandson ?x ?y))

;; ((great grondson) a b)のような場合
(rule ((great ?rel) ?x ?y)
      (and (relationship ?rel)
	   (son ?x ?s)
	   (?rel ?s ?y)))
	  
	   

