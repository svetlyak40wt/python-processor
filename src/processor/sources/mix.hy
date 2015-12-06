(defn mix [&rest sources]
    """Returns messages, taking
    them one by one from each source.

    If source returns None, then it
    should be skipped.
    """
    (setv sources (list (map iter sources)))
    (setv idx 0)

    (while sources
      (setv source (get sources idx))
      
      (try
       (setv value (next source))
       
       (except [e StopIteration]
         (del (get sources idx)))
       
       (else
        (lif value
             (yield value))
        (setv idx (+ idx 1))))

      (if (>= idx (len sources))
        (setv idx 0))))
