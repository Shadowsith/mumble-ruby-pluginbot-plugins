# This plugin shows user type, kernel and architecture of a linux distribution
# please use this plugin only if you have a secure system configuration

class Search < Plugin
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
    h << "<b>#{Conf.gvalue("main:control:string")}search</b> - search file names in the audio folders<br>"
    h
  end

  def handle_chat(msg, message)
    super
    actor = msg.actor
    parts = message.split(" ")
    if parts[0] == "search"
      if parts[1] == "all"
        find = %x( cd ~/music && find ./ -iname '*.opus' -o -iname '*.mp3' | sed 's/$/<br>/g')
      else
        find = %x( cd ~/music && find ./ -iname '*#{parts[1]}*.opus' -o -iname '#{parts[1]}*.mp3' | sed 's/$/<br>/g')
      end
      messageto(actor, "<br>" + find)
    end
  end
end
