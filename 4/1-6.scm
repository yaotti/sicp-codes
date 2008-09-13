The scope of the name `odd?' is the entire body of `f',
not just the portion of the body of `f' starting at the point where the
`define' for `odd?' occurs.

More generally, in block structure, the scope of a local name is the
entire procedure body in which the `define' is evaluated.

just create all local variables that will be in the current environment before
evaluating any of the value expressions



For example, the procedure
(lambda <VARS>
  (define u <E1>)
  (define v <E2>)
  <E3>)

would be transformed into
(lambda <VARS>
  (let ((u '*unassigned*)
	(v '*unassigned*))
    (set! u <E1>)
    (set! v <E2>)
    <E3>))


;; ??
Unlike the transformation shown above,
this enforces the restriction that the defined variables' values can be
evaluated without using any of the variables' values.(2)


