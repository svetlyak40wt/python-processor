(import pudb)
(import [hashlib [md5]])
(import [processor.storage [get-storage]])
(import [feedgen.feed [FeedGenerator]])

;; Uses http://lkiesow.github.io/python-feedgen/

(defn create-feed [data]
  (setv feed (FeedGenerator))
  (.title feed "Some title")
  (.link feed {"rel" "alternate"
               "href" "some link"})
  (.description feed "Some description")
  
  (for [item data]
    (setv feed-item (.add_entry feed))
    
    (setv headers (get item "headers"))
    (setv subject (get headers "subject"))
    
    (.id feed-item (.hexdigest (md5 (.encode subject "utf-8"))))
    (.title feed-item subject))
  (apply .rss_str [feed] {"pretty" True}))


(defn rss-target [filename &optional [limit 10]]
  (setv [get-value set-value] (get-storage "rss-target"))
  
  (defn rss-updater [obj]
    (setv data (get-value filename []))
    
    (.append data obj)
    (setv data (slice data (- limit)))
    
    (set-value filename data)
    
    (with [[f (open filename "w")]]
          (.write f (create-feed data)))))
