# requires svox pico console program
require "yaml"
require "../helpers/tts.rb"
require "../helpers/picottsh.rb"

class PicoTTS < Plugin
  include ITextToSpeech

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
    h << "<b>#{Conf.gvalue("main:control:string")}say</b> - " \
    "#{I18n.t("plugin_picotts.help.msg")}<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}plang</b> - " \
    "#{I18n.t("plugin_picotts.help.lang")}<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}pconf</b> - " \
    "#{I18n.t("plugin_picotts.help.conf")}<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    init_languages
    begin
      if parts[0] == "say"
        if parts[1] != "" || parts[1] != nil?
          message = message.to_s.sub("say", "")
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
          "<b>All avalible languages for plang [lang]:</b></span><br>"
          for i in 0..@@lang.length - 1
            text += @@lang.keys[i].to_s + " - " + @@ldef[@@lang.keys[i]] + "<br>"
          end
          privatemessage(text)
        end
      end
      if parts[0] == "pconf"
        privatemessage("<br>#{I18n.t("plugin_picotts.cur_lang")}: " + getLang + "<br>")
      end
    rescue Exception => ex
      privatemessage("PicoTTS #{I18n.t("global.error")}: " + ex.message)
    end
  end

  private

  @@lang = {}
  @@ldef = {}
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
    @@lang["gb"] = "en-GB"
    @@lang["us"] = "en-US"
    @@lang["es"] = "es-ES"
    @@lang["fr"] = "fr-FR"
    @@lang["it"] = "it-IT"

    @@ldef["de"] = "German"
    @@ldef["gb"] = "British English"
    @@ldef["us"] = "US English"
    @@ldef["es"] = "Spanish"
    @@ldef["fr"] = "French"
    @@ldef["it"] = "Italian"
  end
end
