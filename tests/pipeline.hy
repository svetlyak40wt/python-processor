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


(defn test_source_can_return_lists_of_items_instead_of_dicts []
  "Source can return not a dicionaries, but iterable objects
  then each item in it is processed separately in the rest of the pipeline."
  (setv source [1 [2 3] 4])
  (setv results [])

  (run_pipeline source results.append)
  (eq_ [1 2 3 4] results))


(defn test_any_step_can_return_list_of_items_instead_of_dict []
  "If some pipeline step returns not a dicionary, but iterable object
  then each item in it is processed separately in the rest of the pipeline."
  (setv source [1 2 4])
  (setv results [])

  (defn list_if_two [item]
    (if (= item 2)
      [2 3]
      item))

  (run_pipeline source [list_if_two results.append])
  (eq_ [1 2 3 4] results))

