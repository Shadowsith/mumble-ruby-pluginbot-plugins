require "../helpers/google.rb"

class GoogleSpeaker < Plugin

    def init(init)
        super
        logger("INFO: INIT plugin #{self.class.name}.")
        @@bot[:bot] = self
        return @@bot
    end

    def name
        self.class.name
    end

    def help(h)
        h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
        h << "<b>#{Conf.gvalue("main:control:string")}.gsay [message] [language]</b> - bot speaks from google translator engine<br>"
        h
    end

    def handle_chat(msg, message) 
        super
        #actor = msg.actor
        parts = message.split(" ")
        if parts[0] == "gsay"
            if parts[1] != "" || parts[1] != nil?
                message = parts[1]
                if parts[2] != "" || parts[2] != nil?
                    lang = parts[2]
                else
                    lang = "en"
                end
                google = GoogleTTS.new(message,lang)
                google.load
            end
        end
    end
end

