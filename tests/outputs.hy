(import [nose.tools [eq_]])
(import [processor [run_pipeline sources outputs]])


(defn test_fanout_with_functions []
  (setv source [1 2 3 4 5 6 7])
  (setv odds [])
  (setv evens [])

  (run_pipeline source (outputs.fanout
                        (fn [item]
                          (if (odd? item)
                            (odds.append item)))
                        (fn [item]
                          (if (even? item)
                            (evens.append item)))))
  (eq_ [1 3 5 7] odds)
  (eq_ [2 4 6] evens))


(defn test_fanout_with_chains []
  (setv source [1 2 3 4 5 6 7])
  (setv odds [])
  (setv evens [])

  (run_pipeline source (outputs.fanout
                        [(fn [item] (if (odd? item)
                                      item))
                         odds.append]
                        [(fn [item]  (if (even? item)
                                       item))
                         evens.append]))
  (eq_ [1 3 5 7] odds)
  (eq_ [2 4 6] evens))


(defn test_fanout_outputs_items []
  (setv source [1 2])
  (setv results [])

  ;; here we use `identity` function to make
  ;; pipeline longer and ensure that intermediate
  ;; items are not yielded from `fanout`
  (run-pipeline source
                [(outputs.fanout
                  [identity
                   (fn [item] (+ item 10))]
                  [identity
                   (fn [item] (* item item))])
                 results.append])

  (eq_ [11 1 12 4] results))
