(import requests)
(import json)

(import [processor.utils [merge-dicts]])


(defn slack [url &optional [defaults {"renderer" "markdown"
                                      "username" "Processor"}]]
  "Output to Slack.
   Each object should have field 'text' and could have other
   optional fields which Slack supports in the payload, for example:
   - renderer: which engine use to render text (by default 'markdown');
   - username: username (by default 'Processor');
   - icon_emoji: an icon the the posts (by default None, choose one here: http://www.emoji-cheat-sheet.com);
   - channel: a channel where to post, could be #something or @somebody."

  (defn send-to-slack [obj]
    (setv data (merge-dicts defaults obj))
    (requests.post url (json.dumps data))))
