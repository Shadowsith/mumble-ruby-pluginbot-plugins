class TextToSpeech < Plugin

    def init(init)
        super
        if @@bot[:texttospeech].nil?
            logger("INFO: INIT plugin #{self.class.name}.")
            @priv_notify = Hash.new(0)
            @@bot[:texttospeech] = self
        end
        return @@bot
    end

    def name
        if @@bot[:texttospeech]
            "TextToSpeech"
        else
            self.class.name
        end
    end

    #TODO
    def help(h)
        h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
        h << "<b>#{Conf.gvalue("main:control:string")}+ #(<i>Hashtag</i>)</b> - #{I18n.t("plugin_messages.help.subscribe")}<br>"
        h << "<b>#{Conf.gvalue("main:control:string")}- #(<i>Hashtag</i>)</b> - #{I18n.t("plugin_messages.help.unsubscribe")}<br>"
        h << "#{I18n.t("plugin_messages.help.values")}<br>"
        h << "volume, random, update, single, xfade, consume, repeat, state<br>"
        h << "<b>#{Conf.gvalue("main:control:string")}*</b> - #{I18n.t("plugin_messages.help.list")}<br>"
        h << "<br />#{I18n.t("plugin_messages.help.example", :controlstring => Conf.gvalue("main:control:string"))}"
    end

    #TODO
    def handle_chat(msg, message) 
        if message == "say"
            
        end
    end
end
