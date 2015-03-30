(import email)
(require processor.utils.macro)

(import [processor.storage [get-storage]])


(defn decode-header [text]
  (setv decoded (email.header.decode_header text))
  (setv parts (list (genexpr (if (isinstance part str)
                               part
                               (.decode part (or encoding
                                                 "utf-8")))
                             [[part encoding] decoded])))
  (.join " " parts))


(defn email-headers [msg]
  (dict (genexpr [(.lower key) (decode-header value)]
                 [[key value] (msg.items)])))


(defn first-not-null [items]
  (setv result None)
  (for [item items]
    (lisp-if item
             (do (setv result item)
                 (break))))
  result)


(defn email-body [message content_type]
  (if (= (message.get_content_type) content_type)
    (.decode (message.get_payload None True)
             (or (message.get_content_charset)
                 "utf-8"))
    
    (if (message.is_multipart)
      (first-not-null (genexpr (email-body item content_type)
                               [item (message.get_payload)])))))


(defn decode-message [item]
  (setv msg (email.message_from_bytes item))
  {"type" "email"
   "source" "imap"
   "headers" (email-headers msg)
   "plain-body" (email-body msg "text/plain")
   "html-body" (email-body msg "text/html")})


(defn imap [hostname username password folder &optional [limit 10]]
  (import-or-error [imapclient [IMAPClient]]
                   "Please, install 'imapclient' library to use 'imap' source.")

  (setv server (apply IMAPClient [hostname] {"use_uid" True
                                                     "ssl" True}))
  (setv [get-value set-value] (get-storage "imap-source"))
  (setv seen-position-key (.join ":" [server.host folder "position"]))
  (setv seen-position (get-value seen-position-key -1))

  (with-log-fields {"seen_position" seen-position
                    "server" hostname
                    "username" username                
                    "folder" folder}
    (log.info "Checking IMAP folder")
    
    (.login server username password)
    (.select_folder server folder)
    
    (setv message-ids (.search server ["NOT DELETED"]))

                                ; skip all message ids which are already seen
    (setv message-ids (list-comp id [id message-ids] (> id seen-position)))
    (setv message-ids (slice message-ids (- limit)))
    (setv messages (.fetch server
                           message-ids ["RFC822"]))
    (setv messages (list-comp (get item (.encode "RFC822" "utf-8"))
                              [item (.values messages)]))
    (setv messages (map decode-message messages))
    (setv results (list messages))
    (if message-ids
      (with-log-fields {"message_ids" message-ids}
        (log.info "We processed some message ids")
        (set-value seen-position-key (max message-ids)))))
  results
)
