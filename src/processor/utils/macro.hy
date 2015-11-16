(defmacro with-log-fields [fields &rest body]
  `(do
    (import [twiggy_goodies.threading [log]])
    (with [(apply log.fields [] ~fields)]
          ~@body)))


(defmacro with-log-name-and-fields [name fields &rest body]
  `(do
    (import [twiggy_goodies.threading [log]])
    (with [(apply log.name_and_fields [~name] ~fields)]
          ~@body)))


(defmacro with-log-name [name &rest body]
  `(with-log-name-and-fields ~name {} ~@body))


(defmacro import-or-error [args message]
  `(try (import ~args)
        (except [e ImportError]
          (print ~message)
          (import sys)
          (sys.exit 1))))
