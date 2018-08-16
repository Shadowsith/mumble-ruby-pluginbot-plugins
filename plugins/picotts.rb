# requires svox pico console program
require "yaml"
require "../helpers/ttsh.rb"
require "../helpers/picottsh.rb"

class PicoTTS < Plugin
  include ITextToSpeech

  private

  @@lang = {}
  @@l = ["de", "uk", "us", "es", "fr", "it"]
  CONFIG = "../plugins/picotts.yml"

  def getLang
    data = YAML::load(File.open(CONFIG))
    return data["lang"]
  end

  def setLang(lang)
    data = YAML::load(File.open(CONFIG))
    if @@lang[lang].empty?
      data["lang"] = "en-US"
    else
      data["lang"] = lang
    end
    File.open(CONFIG, "w+") {
      |f|
      f.write(data.to_yaml)
    }
  end

  def init_languages
    @@lang["de"] = "de-DE"
    @@lang["uk"] = "en-UK"
    @@lang["us"] = "en-US"
    @@lang["es"] = "es-ES"
    @@lang["fr"] = "fr-FR"
    @@lang["it"] = "it-IT"
  end

  public

  def init(init)
    super
    logger("INFO: INIT plugin #{self.class.name}.")
    @@bot[:pico] = self
    return @@bot
  end

  def name
    self.class.name
  end

  def help(h)
    h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
    h << "<b>#{Conf.gvalue("main:control:string")}psay [message]</b> - bot speaks from pico2wave engine<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}plang [language]</b> - set language of the bot<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}pconf</b> - get settings<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    begin
      if parts[0] == "psay"
        if parts[1] != "" || parts[1] != nil?
          init_languages
          message = message.to_s.sub("psay", "")
          lang = @@lang[getLang]
          if lang.to_s.empty?
            lang = "en-US"
          end
          path = Conf.gvalue("plugin:mpd:musicfolder")
          pico = PicoTTSHelper.new(path, message, lang)
          pico.load
          updateBot(@@bot)
          play(@@bot, pico)
        end
      end
      if parts[0] == "plang"
        if !parts[1].to_s.empty? && parts[1].to_s.length == 2
          setLang(parts[1])
        else
          text = "<br><span style='color:lightblue;'>" \
          "<b>All valid languages:</b></span><br>"
          for i in 0..@@l.length - 1
            text += @@lang[@@l[i]] + "<br>"
          end
          privatemessage(text)
        end
      end
      if parts[0] == "pconf"
        privatemessage("<br>Current language: " + getLang + "<br>")
      end
    rescue Exception => ex
      privatemessage("PicoTTS Error: " + ex.message)
    end
  end
end
