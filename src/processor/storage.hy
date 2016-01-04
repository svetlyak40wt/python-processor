(import os)
(import pickle)
(import json)
(require processor.utils.macro)

(setv not-given (object))


(defn get-storage [plugin-name &optional [db-filename not-given]]

  (setv db-filename (if (is not-given db-filename)
                      (os.environ.get "PROCESSOR_DB" "processor.db")
                      db-filename))
  
  (with-log-fields {"db_filename" db-filename}
    (log.info "Will use this file to store data"))
  
  (defn get-plugin-data []
    (setv data (if (os.path.exists db-filename)
                 (with [f (open db-filename "r")]
                       (json.load f))
                 {}))
    (.setdefault data plugin-name {})
    (get data plugin-name))

  (defn save-plugin-data [plugin-data]
    (setv data (if (os.path.exists db-filename)
                 (with [f (open db-filename "r")]
                       (json.load f))
                 {}))
    (assoc data plugin-name plugin-data)
    (with [f (open db-filename "w")]
          (apply json.dump [data f] {"sort_keys" True "indent" 4})))

  (defn get-value [key &optional [default not-given]]
    (setv db-filename "processor.db")
    (setv plugin-data (get-plugin-data))

    (if (= default not-given)
      (.get plugin-data key)
      (.get plugin-data key default)))
  
  (defn set-value [key &optional value]
    (setv plugin-data (get-plugin-data))
    (assoc plugin-data key value)
    (save-plugin-data plugin-data))
  
  [get-value set-value])
