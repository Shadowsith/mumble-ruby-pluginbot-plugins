require "../helpers/marytts.rb"

class MaryTTS < Plugin
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
        h << "<b>#{Conf.gvalue("main:control:string")}say [message] [lang] [voice]</b> - bot says the message<br>"
        h << "<b>#{Conf.gvalue("main:control:string")}say [message]</b> - bot says the message<br>"
        h << "<b>#{Conf.gvalue("main:control:string")}mlang [de|en]</b> - change language of the bot<br>"
        h << "<b>#{Conf.gvalue("main:control:string")}mvoice [male|female]</b> - change voice of the bot<br>"
        h
    end

    def handle_chat(msg, message)
        super
        parts = message.split(" ")
        if parts[0] == "say"
            if parts[1] != "" || parts[1] != nil?
                message = parts[1]
                if parts[2] != "" || parts[2] != nil?
                    lang = parts[2]
                else
                    lang = "en"
                end
                if parts[3] != "" || parts[3] != nil?
                    voice = parts[3]
                else
                    voice = "male"
                end
            end
            mary = MaryTtsHelper.new(message,lang,voice)
            th1 = Thread.new {
                mary.load
            }
            th1.join

            @@bot[:mpd].add(mary.getFileName)
            if @@bot[:mpd].queue.length > 0
                lastsongid = @@bot[:mpd].queue.length.to_i - 1
                @@bot[:mpd].play (lastsongid)
                @@bot[:cli].me.deafen false if @@bot[:cli].me.deafened?
                @@bot[:cli].me.mute false if @@bot[:cli].me.muted?
            end
        end
    end
end
