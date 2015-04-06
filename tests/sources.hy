(import [nose.tools [eq_]])
(import [processor [sources]])


(defn test_mix []
  (setv source1 [1 2 3 4 5])
  (setv source2 [6 7 None 8])
  (setv desired_result [1 6 2 7 3 4 8 5])
  (setv result (list (sources.mix source1 source2)))
  (eq_ desired_result result))
