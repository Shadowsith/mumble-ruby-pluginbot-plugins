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
    h << "<b>#{Conf.gvalue("main:control:string")}audiocut|acut</b> - " \
      "#{I18n.t("plugin_audioedit.help.acut")}<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}audiocut|acut</b> - " \
      "#{I18n.t("plugin_audioedit.help.acut_center")}<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    begin
    if parts[0] == "audiocut" || parts[0] == "acut"
      if parts[1] == "head"
        if !parts[2].nil? && !parts[3].nil?
          time = parts[2].to_i 
          file = parts[3..parts.length-1].join(" ").to_s
          song = getFirstSong(@@bot, file, "file")
          if !song.nil? 
            cutter = FFmpeg.new(song)
            status = cutter.cutHead(time)
            printStatus(status, song.file)
          else
            privatemessage("#{I18n.t("plugin_audioedit.err.fnf")}")
          end
        else privatemessage("#{I18n.t("global.error.arg")}")
        end
      elsif parts[1] == "center"
        if !parts[2].to_s.nil? && !parts[3].to_s.nil? && parts[4].to_s.nil?
          time = parts[2].to_i 
          duration = parts[3].to_i
          file = parts[4..parts.length-1].join(" ").to_s
          song = getFirstSong(@@bot, file, "file") 
          if !song.nil?
            cutter = FFmpeg.new(song)
            cutter.cutCenter(time, duration)
            printStatus(status, song.file)
          else
            privatemessage("#{I18n.t("plugin_audioedit.err.fnf")}")
          end
        else privatemessage("#{I18n.t("global.arg")}")
        end
      elsif parts[1] == "tail"
        if !parts[2].to_s.nil? && !parts[3].to_s.nil? 
          time = parts[2].to_i 
          file = parts[3..parts.length-1].join(" ").to_s
          song = getFirstSong(@@bot, file, "file") 
          if !song.nil?
            cutter = FFmpeg.new(song)
            status = cutter.cutTail(time)
            printStatus(status, song.file)
          else
            privatemessage("#{I18n.t("plugin_audioedit.err.fnf")}")
          end
        else privatemessage("#{I18n.t("global.error.arg")}")
        end
      else
        privatemessage("#{I18n.t("plugin_audioedit.err.arg")} #{parts[1]}")
      end
    end
    rescue Exception => ex
      privatemessage("AudioEdit #{I18n.t("global.error")}: #{ex.message}")
    end
  end

  def printStatus(status, file = nil)
    case status
    when FFmpeg::Status::SUCCESS
      privatemessage("#{file} #{I18n.t("plugin_audioedit.acut.success")}")
    when FFmpeg::Status::FTYPE
      privatemessage("#{I18n.t("plugin_audioedit.err.ftype")}")
    when FFmpeg::Status::FLEN
      privatemessage("#{I18n.t("plugin_audioedit.err.flen")}")
    end
  end
end
