require "yaml"
require "../helpers/marytts.rb"

class MaryTTS < Plugin
    private
    CONFIG = "../plugins/mtts.yml"

    public
    def init(init)
        super
        logger("INFO: INIT plugin #{self.class.name}.")
        @@bot[:mtts] = self
        return @@bot
    end

    def name
        self.class.name
    end

    def help(h)
        h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
        h << "<b>#{Conf.gvalue("main:control:string")}say [message]</b> - bot says the message<br>"
        h << "<b>#{Conf.gvalue("main:control:string")}mlang [de|en]</b> - change language of the bot<br>"
        h << "<b>#{Conf.gvalue("main:control:string")}mvoice [male|female]</b> - change voice of the bot<br>"
        h << "<b>#{Conf.gvalue("main:control:string")}mttsconf - get settings<br>"
        h
    end

    def handle_chat(msg, message)
        super
        parts = message.split(" ")
        begin
        if parts[0] == "say"
            if parts[1] != "" || parts[1] != nil?
                message = message.to_s.sub("say","")
                lang = getLang
                if lang.to_s.empty? || lang == "en"
                    lang = "en_US"
                end
                voice = getVoice
                if voice.to_s.empty?
                    voice = "male"
                end
                mary = MaryTtsHelper.new(message,lang,voice)
                mary.load
                @@bot[:mpd].update
                @@bot[:mpd].add("marytts.mp3")
                if @@bot[:mpd].queue.length > 0
                    lastsongid = @@bot[:mpd].queue.length.to_i - 1
                    @@bot[:mpd].play (lastsongid)
                    @@bot[:cli].me.deafen false if @@bot[:cli].me.deafened?
                    @@bot[:cli].me.mute false if @@bot[:cli].me.muted?
                end
            end
            return 0
        end
        if parts[0] == "mlang"
            if !parts[1].to_s.empty? 
                lang = parts[1]
                if lang == "de" || lang == "en"
                    setLang(lang)
                end
            end
            return 0
        end
        if parts[0] == "mvoice"
            if !parts[1].to_s.empty? 
                voice = parts[1]
                if voice == "male" || voice == "female"
                    setVoice(voice)
                end
            end
            return 0
        end
        if parts[0] == "mttsconf"
            messageto(msg.actor,"<br>Language: "+getLang+"<br> Voice: "+getVoice+"<br>")
        end
        rescue Exception => ex
            messageto(msg.actor,"MarryTTS Error: "+ex.message)
        end
    end

    def getLang
        data = YAML::load(File.open(CONFIG))
        return data["lang"]
    end

    def getVoice
        data = YAML::load(File.open(CONFIG))
        return data["voice"]
    end

    def setLang(lang)
        data = YAML::load(File.open(CONFIG))
        data["lang"] = lang
        File.open(CONFIG, "w+") {
            |f| f.write(data.to_yaml)
        }
    end

    def setVoice(voice)
        data = YAML::load(File.open(CONFIG))
        data["voice"] = voice
        File.open(CONFIG, "w+") {
            |f| f.write(data.to_yaml)
        }
    end
end
