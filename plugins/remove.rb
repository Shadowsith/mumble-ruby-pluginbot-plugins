require "../helpers/mpd.rb"

class Remove < Plugin
  include IMpd

  public

  def init(init)
    super
    @rm = "rm -f "
    logger("INFO: INIT plugin #{self.class.name}.")
    @@bot[:rm] = self
    return @@bot
  end

  def name
    self.class.name
  end

  def help(h)
    h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
    h << "<b>#{Conf.gvalue("main:control:string")}remove" \
    "#{I18n.t("plugin_delete.help")}<br>"
    h
  end

  def handle_chat(msg, message)
    super
    begin
      msgParts = message.split(" ")
      if msgParts[0] == "remove"
        if !msgParts[1].to_s.empty?
          search = msgParts[1]
          song = getFirstSong(@@bot, search, "file")
          if !song.nil?
            delete(song.file, msg.actor)
            update(@@bot)
          end
        end
      end
    rescue Exception => ex
      privatemessage("Remove #{I18n.t("global.error")}: #{ex.message}")
    end
  end

  private

  def delete(file, actor)
    system("#{@rm} ~/music/\"#{file}\"")
    channelmessage("#{I18n.t("plugin_delete.file")} #{file}" \
    "#{I18n.t("plugin_delete.removed_by")} #{actor}")
  end
end
