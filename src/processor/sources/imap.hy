(import email)
(import pytz)
(import imaplib)
(import datetime)
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
    (do (setv charset (or (message.get_content_charset)
                          "utf-8"))
        (.decode (message.get_payload None True)
                 charset
                 "replace"))
    
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

    (setv search-criterion
          (if (> seen-position 0)
            ;; if this is not a first time when we are fetching data
            ;; then just fetch every new message
            (.format "UID {0}:*" (+ seen-position 1))
            ;; if wer are fetching for the first time, then we have
            ;; to limit message by date because when there is big amount
            ;; of data, then imaplib unable to download that many data at once
            (do 
             (setv since (- (datetime.datetime.utcnow)
                            (datetime.timedelta 1))) ; we are only interested in letters for the last 1 day
             (setv since (imaplib.Time2Internaldate
                          (apply since.replace
                                 []
                                 {"tzinfo" pytz.UTC})))
                                ; now just strip a date part from time part
             (setv since (get (.split (.strip since "\"") " " 1)
                              0))
             (.format "NOT DELETED SINCE {0}" since))))

    ;; docs for the SEARCH command http://tools.ietf.org/html/rfc3501#section-6.4.4
    (setv message-ids (.search server [search-criterion]))
                                ; skip all message ids which are already seen
    (setv message-ids (list-comp id [id message-ids] (> id seen-position)))
    (setv message-ids (slice message-ids (- limit)))
    (setv messages (.fetch server
                           message-ids ["RFC822"]))
    (setv messages (list-comp (get item (.encode "RFC822" "utf-8"))
                              [item (.values messages)]))
    (setv messages (map decode-message messages))
    (setv results (list messages)))
  (if message-ids
    (with-log-fields {"message_ids" message-ids}
      (log.info "We processed some message ids")
      (set-value seen-position-key (max message-ids))))
  results
)
