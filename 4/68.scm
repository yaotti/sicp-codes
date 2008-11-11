;; not checked

;; 1 atomをどう表現する?
;; (rule (revert ?x ?x))だと(revert (1 2) (1 2))にマッチする
;; =>append-to-formを使えば表現できる


(rule (revert (?x) (?x))
      (append-to-form ?x () (?x))) ;;ok?

(rule (revert (?x . (?a)) (?a . ?y))
      (revert ?x ?y))

両方答えられる．