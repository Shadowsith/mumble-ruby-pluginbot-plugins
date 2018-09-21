# requires mplayer console program
require "yaml"
require "../helpers/tts.rb"
require "../helpers/googlettsh.rb"

class GoogleTTS < Plugin
  include ITextToSpeech

  private

  CONFIG = "../plugins/googletts.yml"

  def addTranslation
    @help_gsay = I18n.t("plugin_googletts.help.gsay")
    @help_glang = I18n.t("plugin_googletts.help.glang")
    @help_gconf = I18n.t("plugin_googletts.help.gconf")
  end

  public

  def init(init)
    super
    logger("INFO: INIT plugin #{self.class.name}.")
    @@bot[:google] = self
    addTranslation()
    return @@bot
  end

  def name
    self.class.name
  end

  def help(h)
    h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
    h << "<b>#{Conf.gvalue("main:control:string")}gsay</b> #{@help_gsay}<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}glang</b> #{@help_glang}<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}gconf</b> - #{@help_gconf}<br>"
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
        privatemessage("<br>#{I18n.t("plugin_googletts.gconf")}: #{getLang}<br>")
      end
    rescue Exception => ex
      privatemessage("GoogleTTS #{I18n.t("global.error")}: " + ex.message)
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
