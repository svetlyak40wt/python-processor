(defn merge-dicts [first &rest others]
  (setv new-dict (.copy first))
  (for [d others]
    (.update new-dict d))
  new-dict)
