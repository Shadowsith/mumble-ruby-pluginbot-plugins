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
    h << "<b>#{Conf.gvalue("main:control:string")}sysinfo</b> - information about operating system and mumble-server<br>"
    h
  end

  def handle_chat(msg, message)
    super
    actor = msg.actor
    if message == "sysinfo"
      head = "<br><span style='color:lightblue;'>System information:</span><br>"
      os = %x( uname -smr ) + "<br>"
      messageto(actor, head + os)
    end
  end
end
