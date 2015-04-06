(import [nose.tools [eq_]])
(import [processor [run_pipeline sources outputs]])


(defn test_source_as_a_list []
  (setv results [])
  (run_pipeline [1 2 3 4]
                results.append)
  (eq_ [1 2 3 4] results))


(defn test_source_as_a_function []
  (setv items [1 2 3])
  (setv results [])
  
  (defn source []
    (if items
      (items.pop)))
  
  (run_pipeline source
                results.append)
  (eq_ [3 2 1] results))


(defn test_two_outputs []
    (setv source [{"message" "blah"
                   "level" "WARN"}
                  {"message" "minor"
                   "level" "INFO"}])

    (defn trigger [msg]
        (if (= (msg.get "level") "WARN")
            msg))

    (setv warnings [])

    (run_pipeline source
                  [trigger warnings.append])

    (eq_ 1 (len warnings)))


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
