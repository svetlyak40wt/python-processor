(defmacro with-log-fields [fields &rest body]
  `(with [[(apply log.fields [] ~fields)]]
         ~@body))

(defmacro hello [world]
  `(print (+ "Hello " (str ~world))))


(defn hello2 [world]
  (print "Hello" world))
