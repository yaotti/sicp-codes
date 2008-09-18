((lambda (n)
  ((lambda (fact)
     (fact fact n))
   (lambda (ft k)
     (if (= k 1)
	 1
	 (* k (ft ft (- k 1)))))
   ))
10)

各lambda式をlambda-n, lambda-f, lambda-ftと呼ぶことにする.

lambda-nはlambda-fを引数lambda-ftで実行した結果できる手続き.

3の階乗を考えてみる.
(fact fact 3)
(* 3 (fact fact 2))
(* 3 (* 2 (fact fact 1)))
(* 3 (* 2 1))
置き替えていく.
((lambda (fact)
   (fact fact 3))
 (lambda (ft k)
   (if (= k 1)
       1
       (* k (ft ft (- k 1))))))

((lambda (ft k)
   (if (= k 1)
       1
       (* k (ft ft (- k 1)))))
 (lambda (ft k)
   (if (= k 1)
       1
       (* k (ft ft (- k 1)))))
 3)

(* 3
   ((lambda (ft k)
   (if (= k 1)
       1
       (* k (ft ft (- k 1)))))
    (lambda (ft k)
      (if (= k 1)
	  1
	  (* k (ft ft (- k 1)))))
    2))
...

a. fibonacchiを考える.
(fib fib n)
(+ (fib fib (- n 1))
   (fib fib (- n 2)))

(use srfi-1)
(map (lambda (n)
       ((lambda (fib)
	  (fib fib n))
	(lambda (fb k)
	  (cond [(<= k 0) 0]
		[(= k 1) 1]
		[else (+ (fb fb (- k 1))
			 (fb fb (- k 2)))]))))
     (iota 10 1))
;; output
(1 1 2 3 5 8 13 21 34 55)
;; ok 


b.

(define (f x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) true (od? <1> <2> <3>)))
   (lambda (ev? od? n)
     (if (= n 0) false (ev? <4> <5> <6>)))))

<3>, <6>は(- n 1)となるはず.

順にlambda1, lambda2, lambda3と呼ぶことにする.

lambda2はevenならtrue
lambda3はevenならfalse

lambda1より, (lambda2 lambda2 lambda3 n)
0でないなら, lambda3に移る.
lambda3に移ったあと, 0でなければlambda2に戻ってくるので


(define (f x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) true (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) false (ev? ev? od? (- n 1))))))
