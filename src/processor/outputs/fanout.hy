(import [processor.utils.datastructures [ensure-list]])


(defn fanout [&rest pipelines]
  (setv pipelines (list (map ensure-list pipelines)))
  
  (fn [input]
    (setv results [])

    (for [pipeline pipelines]
      (setv msg input)
      
      (for [output pipeline]
        (setv msg (output msg))
        (lisp-if-not msg
                     (break)))

      ;; at the end of each pipeline
      ;; we yield result if any
      (lisp-if msg
               (yield msg)))))
