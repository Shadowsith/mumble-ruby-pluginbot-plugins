# This plugin shows user type, kernel and architecture of a linux distribution
# please use this plugin only if you have a secure system configuration

class System < Plugin
  def init(init)
    super
    logger("INFO: INIT plugin #{self.class.name}.")
    @@bot[:bot] = self
    return @@bot
  end

  def name
    self.class.name
  end

  def help(h)
    h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
    h << "<b>#{Conf.gvalue("main:control:string")}sysinfo</b> - " \
    "#{I18n.t("plugin_system.help")}<br>"
    h
  end

  def handle_chat(msg, message)
    super
    if message == "sysinfo"
      begin
        head = "<br><span style='color:lightblue;'><b>" \
        "#{I18n.t("plugin_system.info")}:</b></span><br>"
        os = %x( uname -smr ) + "<br>"
        system("murmurd -version > /tmp/murmurd.txt 2>&1")
        mumble = File.open("/tmp/murmurd.txt", &:readline)
        mumble = mumble[mumble.to_s.index("--") + 3..mumble.to_s.length]
        mumble = "Mumble-Server Version: #{mumble}<br>"
        privatemessage(head + os + mumble)
      rescue Exception => ex
        privatemessage("Sysinfo #{I18n.t("global.error")}: #{ex.message}")
      end
    end
  end
end
