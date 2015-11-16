(import [pprint [pprint]])

(defn debug []
  (defn debug_processor [item]
    (pprint item)
    item))
