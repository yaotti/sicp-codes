;; to avoid masking the definition of the underlying 'apply'
;; should evaluate this before defining the metacircular 'apply'
(define apply-in-underlying-scheme (with-module gauche apply))
;; with-module gauche applyとしているのは、2回目以降の評価ではapplyがmetacircularのapplyになるから
(load "../1-1.scm")
(load "../1-2.scm")
(load "../1-3.scm")
(load "../1-4.scm")
