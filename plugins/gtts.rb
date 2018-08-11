# requires mplayer console program
require "../helpers/google.rb"

class GoogleTTS < Plugin

    def init(init)
        super
        logger("INFO: INIT plugin #{self.class.name}.")
        @@bot[:gtts] = self
        return @@bot
    end

    def name
        self.class.name
    end

    def help(h)
        h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
        h << "<b>#{Conf.gvalue("main:control:string")}gsay [message] [language]</b> - bot speaks from google translator engine<br>"
        h
    end

    def handle_chat(msg, message) 
        super
        parts = message.split(" ")
        if parts[0] == "gsay"
            if parts[1] != "" || parts[1] != nil?
                message = parts[1]
                if parts[2] != "" || parts[2] != nil?
                    lang = parts[2]
                else
                    lang = "en"
                end
                google = GoogleTtsHelper.new(message,lang)
                th1 = Thread.new {
                    google.load
                }
                th1.join

                @@bot[:mpd].add(google.getFileName)
                if @@bot[:mpd].queue.length > 0
                    lastsongid = @@bot[:mpd].queue.length.to_i - 1
                    @@bot[:mpd].play (lastsongid)
                    @@bot[:cli].me.deafen false if @@bot[:cli].me.deafened?
                    @@bot[:cli].me.mute false if @@bot[:cli].me.muted?
                end
            end
        end
    end
end

