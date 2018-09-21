class DirectPlay < Plugin
  def init(init)
    super
    logger("INFO: INIT plugin #{self.class.name}.")
    @@bot[:dplay] = self
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
    if parts[0] == "dplay" || parts[0] == "dpl"
      if !parts[1].to_s.empty?
        text_out = "#{I18n.t("plugin_mpd.add.added")}<br/>"
        count = 0
        @@bot[:mpd].where(any: "#{parts[1]}").each do |song|
          text_out << "add #{song.file}<br/>"
          @@bot[:mpd].add(song)
          count += 1
          break
        end
        if count == 0
          text_out = I18n.t("plugin_mpd.add.nothing")
        else
          lastsongid = @@bot[:mpd].queue.length.to_i - 1
          @@bot[:mpd].play lastsongid
          @@bot[:cli].me.deafen false if @@bot[:cli].me.deafened?
          @@bot[:cli].me.mute false if @@bot[:cli].me.muted?
          privatemessage(I18n.t("plugin_mpd.play.last", :id => lastsongid))
        end
      else
        text_out = I18n.t("plugin_mpd.add.empty")
      end
    end
    privatemessage(text_out)
  end
end
