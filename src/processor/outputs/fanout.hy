(import [processor.utils.datastructures [ensure-list]])


(defn fanout [&rest pipelines]
  (setv pipelines (list (map ensure-list pipelines)))
  
  (fn [input]
    (for [pipeline pipelines]
      (setv msg input)
      
      (for [output pipeline]
        (setv msg (output msg))
        (if-not msg
                (break))))))
