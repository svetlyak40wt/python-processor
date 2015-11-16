(import processor)
(import time)
(require processor.utils.macro)


(defn xmpp [jid password host &optional [port 5222] [recipients []]]
  (import-or-error [sleekxmpp [ClientXMPP]]
                   "Please, install 'sleekxmpp' library to use 'xmpp' source.")

  (defclass Bot [ClientXMPP]
    (defn __init__ [self jid password recipients]
      (.__init__ (super Bot self) jid password)
      (setv self.recipients recipients)
      (self.add_event_handler "session_start" self.start))
    
    (defn start [self event]
      (self.send_presence)
      (self.get_roster))
    
    (defn send_to_recipients [self message recipients]
      (setv recipients (or recipients
                           self.recipients))
      (for [recipient recipients]
        (apply self.send_message [] {"mto" recipient "mbody" message}))))
  
  (setv bot (Bot jid password recipients))
  (bot.register_plugin "xep_0030") ;; Service Discovery
  (bot.register_plugin "xep_0199") ;; XMPP Ping


  (bot.connect [host port])

  (processor.on_close (fn [] (do (time.sleep 1)
                                 (apply bot.disconnect [] {"wait" True}))))
  
  (apply bot.process [] {"block" False})

  ;; actual message sending function
  (fn [item]
    (bot.send_to_recipients (item.get "text" "Not given")
                            (item.get "recipients"))))

