(import [http.server [HTTPServer BaseHTTPRequestHandler]])
(import [queue [Queue]])
(import [threading [Thread]])
(import [cgi [parse_header]])
(import [urllib.parse [parse_qs]])
(import json)


(defn parse-headers [headers]
  (dict headers))


(defn parse-data [request]
  (setv ctype (.lower (request.headers.get
                       "content-type"
                       "")))
  (setv [ctype ctype_opts] (parse_header ctype))
  
  (setv content-length (int (request.headers.get
                             "content-length"
                             "0")))
  (setv data (request.rfile.read content-length))
  
  (cond [(= ctype "application/json")
         (json.loads (data.decode (ctype_opts.get "charset" "utf-8")))]
        [(> content-length 0) (if (in "charset" ctype_opts)
                                (data.decode (get ctype_opts "charset"))
                                data)]
        [True None]))


(defn parse-query [request]
  (setv splitted (request.path.split "?" 1))
  (if (= (len splitted) 2)
    [(get splitted 0) (parse_qs (get splitted 1))]
    [(get splitted 0) None]))


(defn create-request-processor [queue]
  (fn [request]
    (setv [path query] (parse-query request))
    
    (queue.put {"type" "http-request"
                "source" "web.hook"
                "path" path
                "query" query
                "headers" (parse-headers request.headers)
                "method" request.command
                "data" (parse-data request)})
  
    (request.send_response 200)
    (request.send_header "Content-type" "text/plain")
    (request.end_headers)))


(defn hook [&optional [host "127.0.0.1"] [port "8000"]]
  (setv queue (Queue))
  (setv process-request (create-request-processor queue))
  
  (defclass Handler [BaseHTTPRequestHandler]
    [server_version "python-processor"
     sys_version ""
     do_GET process-request
     do_POST process-request])
  
  (setv server (HTTPServer (tuple [host (int port)]) Handler))
  (setv worker (apply Thread [] {"target" server.serve_forever}))
  (setv worker.daemon True)
  (worker.start)

  (while True
    (yield (queue.get))))
