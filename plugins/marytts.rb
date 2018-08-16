require "yaml"
require "../helpers/maryttsh.rb"

class MaryTTS < Plugin
  private

  CONFIG = "../plugins/marytts.yml"

  def getLang
    data = YAML::load(File.open(CONFIG))
    return data["lang"]
  end

  def getVoice
    data = YAML::load(File.open(CONFIG))
    return data["voice"]
  end

  def getSize
    data = YAML::load(File.open(CONFIG))
    return data["size"]
  end

  def setLang(lang)
    if lang != "de" && lang != "en"
      lang = "en"
    end
    data = YAML::load(File.open(CONFIG))
    data["lang"] = lang
    File.open(CONFIG, "w+") {
      |f|
      f.write(data.to_yaml)
    }
  end

  def setVoice(voice)
    if voice != "male" && voice != "female"
      voice = "male"
    end
    data = YAML::load(File.open(CONFIG))
    data["voice"] = voice
    File.open(CONFIG, "w+") {
      |f|
      f.write(data.to_yaml)
    }
  end

  def setSize(size)
    size = size.to_i
    if size <= 200
      data = YAML::load(File.open(CONFIG))
      data["size"] = size
      File.open(CONFIG, "w+") {
        |f|
        f.write(data.to_yaml)
      }
    else
      privatemessage("TTS message can't be greater than 200 characters")
    end
  end

  def updateBot
    @@bot[:mpd].update
    while @@bot[:mpd].status[:updating_db]
      sleep 0.5
    end
  end

  def play(mary)
    @@bot[:mpd].add(mary.getFileName)
    if @@bot[:mpd].queue.length > 0
      lastsongid = @@bot[:mpd].queue.length.to_i - 1
      @@bot[:mpd].play (lastsongid)
      @@bot[:cli].me.deafen false if @@bot[:cli].me.deafened?
      @@bot[:cli].me.mute false if @@bot[:cli].me.muted?
      clearQueue(mary)
    end
  end

  def clearQueue(mary)
    songnr = 0
    @@bot[:mpd].queue.each do |song|
      if @@bot[:mpd].queue.length - 1 <= songnr
        break
      elsif song.file == mary.getFileName
        @@bot[:mpd].delete songnr.to_s
        songnr -= 1
      end
      songnr += 1
    end
  end

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
    h << "<b>#{Conf.gvalue("main:control:string")}msize [number]</b> - allowed number of characters (max 200)<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}mconf - get settings<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    begin
      if parts[0] == "say"
        if parts[1] != "" || parts[1] != nil?
          message = message.to_s.sub("say", "").gsub("<br>", " ")
          if message.length <= getSize.to_i
            lang = getLang
            if lang.to_s.empty?
              lang = "en_US"
            end
            voice = getVoice
            if voice.to_s.empty?
              voice = "male"
            end
            path = Conf.gvalue("plugin:mpd:musicfolder")
            mary = MaryTTSHelper.new(path, message, lang, voice)
            mary.load
            updateBot
            play(mary)
          else
            privatemessage("The message is greater than the allowed limit of " + getSize.to_s + " characters!")
          end
        end
      end
      if parts[0] == "mlang"
        setLang(parts[1])
      end
      if parts[0] == "mvoice"
        setVoice(parts[1])
      end
      if parts[0] == "msize"
        setSize(parts[1])
      end
      if parts[0] == "mconf"
        messageto(msg.actor, "<br>Language: " + getLang + "<br>Voice: " + getVoice + "<br>Max Characters: " + getSize.to_s + "<br>")
      end
      if parts[0] == "fconf"
        privatemessage(@@bot[:mpd].config.instance_variables.to_s)
      end
    rescue Exception => ex
      messageto(msg.actor, "MarryTTS Error: " + ex.message)
    end
  end
end
