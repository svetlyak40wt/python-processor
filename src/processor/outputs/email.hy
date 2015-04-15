(require processor.utils.macro)


(defn email [&optional mail_to mail_from [host "localhost"] [port 25] [ssl False] user password]
  (import-or-error [emails [html]]
                   "Please, install 'email' library to use 'email' output.")
  
  (fn [&optional item]
    (setv message (apply html [] {"html" (get item "body")
                                         "subject" (get item "subject")
                                         "mail_from" mail_from}))
    (setv response (apply message.send [] {"to" mail_to
                                           "smtp" {"host" host
                                                   "port" port
                                                   "ssl" ssl
                                                   "user" user
                                                   "password" password}}))
    (if-not (= response.status_code 250)
            (raise (RuntimeError (.format "Bad SMTP status code: {0}" response.status_code))))
    None))
  
