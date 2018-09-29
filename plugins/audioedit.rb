require "../helpers/mpd.rb"
require "../helpers/ffmpeg.rb"

class AudioEdit < Plugin
  include IMpd

  def init(init)
    super
    logger("INFO: INIT plugin #{self.class.name}.")
    @@bot[:audiocut] = self
    return @@bot
  end

  def name
    self.class.name
  end

  def help(h)
    h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
    h << "<b>#{Conf.gvalue("main:control:string")}dplay|dpl</b> - " \
    "#{I18n.t("plugin_dplay.help")}<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    if parts[0] == "audiocut" || parts[0] == "acut"
      if parts[1] == "head"
        if !parts[2].to_s.nil? && !parts[3].to_s.nil?
          song = getFirstSong(@@bot, parts[2], "file")
          cutter = FFmpeg.new(song)
          cutter.cutHead(parts[3].to_i)
        end
      end
      if parts[1] == "tail"
        if !parts[2].to_s.nil? && !parts[3].to_s.nil? 
          song = getFirstSong(@@bot, part[2], "file") 
          cutter = FFmpeg.new(song)
          cutter.cutTail(parts[3].to_i)
          
        end
      end
    end
  end
end
