# requires mplayer console program
require "yaml"
require "../helpers/googlettsh.rb"

class GoogleTTS < Plugin
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
    if parts[0] == "gsay"
      if parts[1] != "" || parts[1] != nil?
        message = message.to_s.sub("gsay", "")
        lang = getLang
        google = GoogleTtsHelper.new(message, lang)
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
    if parts[0] == "glang"
      if !parts[1].to_s.empty? && parts[1].to_s.length == 2
        setLang(parts[1])
      end
    end
    if parts[0] == "gconf"
      messageto(msg.actor, "<br>Current language: " + getLang + "<br>")
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
