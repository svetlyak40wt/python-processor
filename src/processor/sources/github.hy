(require processor.utils.macro)

(import re)
(import [processor.storage [get-storage]])


(defn get-api-url [base-url handle]
  (setv match (re.match
               "^https?://github.com/(?P<repo>[^/]+)/(?P<username>[^/]+)"
               base-url))
  (when match
    (setv data (match.groupdict))
    (assoc data "handle" handle)
    (setv format (getattr "https://api.github.com/repos/{repo}/{username}/{handle}" "format"))
    (apply format [] data)))


(defn releases [repo-url &optional access-token]
  (import-or-error [requests]
                   "Please, install 'requests' library to use 'slack' output.")
  
  (setv url (get-api-url repo-url "releases"))
  (setv headers
        (if access-token
          {"Authorization" (+ "token " access-token)}
          {}))
  
  (setv response (apply requests.get [url] {"headers" headers}))

  (setv [get-value set-value] (get-storage "github"))
  (setv seen-id-key (.join ":" [url "seen-id"]))
  (setv seen-id (get-value seen-id-key 0))

  (setv items (list-comp item [item (response.json)]
                         (> (get item "id") seen-id)))
  (items.reverse)

  (defn format-item [item]
    {"source" "github.releases"
     "type" "github.release"
     "payload" item})
  
  (for [item items]
    (setv item-id (get item "id"))
    (yield (format-item item))
    (set-value seen-id-key item-id)))
