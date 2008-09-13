;; Chapter 4.1.5 Data as Programs

;; have to translate
This would be a circuit that takes
as input a signal encoding the plans for some other circuit, such as a
filter.

   Another striking aspect of the evaluator is that it acts as a bridge
between the data objects that are manipulated by our programming
language and the programming language itself.
評価器はプログラミング言語とデータオブジェクトの橋渡しをする(?)



for user: program
for evaluator: data

;; h t t
   (3) Warning: This `eval' primitive is not identical to the `eval'
procedure we implemented in section *Note 4-1-1::, because it uses
_actual_ Scheme environments rather than the sample environment
structures we built in section *Note 4-1-3::.  These actual
environments cannot be manipulated by the user as ordinary lists; they
must be accessed via `eval' or other special operations.  Similarly,
the `apply' primitive we saw earlier is not identical to the
metacircular `apply', because it uses actual Scheme procedures rather
than the procedure objects we constructed in sections *Note 4-1-3:: and
*Note 4-1-4::.
