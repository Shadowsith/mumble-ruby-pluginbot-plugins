# requires mplayer console program
require "yaml"
require "../helpers/tts.rb"
require "../helpers/googlettsh.rb"

class GoogleTTS < Plugin
  include ITextToSpeech

  private

  CONFIG = "../plugins/googletts.yml"

  public

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
    h << "<b>#{Conf.gvalue("main:control:string")}gsay [message]</b> - bot speaks from google translator engine<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}glang [language]</b> - set language of the bot<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}gconf</b> - get settings<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    begin
      if parts[0] == "gsay"
        if parts[1] != "" || parts[1] != nil?
          message = message.to_s.sub("gsay", "")
          lang = getLang
          if lang.to_s.empty?
            lang = "en"
          end
          path = Conf.gvalue("plugin:mpd:musicfolder")
          google = GoogleTTSHelper.new(path, message, lang)
          google.load
          updateBot(@@bot)
          play(@@bot, google)
        end
      end
      if parts[0] == "glang"
        if !parts[1].to_s.empty? && parts[1].to_s.length == 2
          setLang(parts[1])
        end
      end
      if parts[0] == "gconf"
        messageto(msg.actor, "<br>Current language: " + getLang + "<br>")
      end
    rescue Exception => ex
      privatemessage("GoogleTTS Error: " + ex.message)
    end
  end

  def getLang
    data = YAML::load(File.open(CONFIG))
    return data["lang"]
  end

  # TODO add checker for all valid google languages
  def setLang(lang)
    data = YAML::load(File.open(CONFIG))
    data["lang"] = lang
    File.open(CONFIG, "w+") {
      |f|
      f.write(data.to_yaml)
    }
  end
end
