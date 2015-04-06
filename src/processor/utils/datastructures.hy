(defn merge-dicts [first &rest others]
  (setv new-dict (.copy first))
  (for [d others]
    (.update new-dict d))
  new-dict)


(defn ensure-list [item]
  (if (isinstance item list)
    item
    [item]))
