class Move < Plugin
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
    h << "<b>#{Conf.gvalue("main:control:string")}move [file] [new name] - rename file<br>"
    h
  end

  def handle_chat(msg, message)
    super
    msgParts = message.split(" ")
    if msgParts[0] == "move"
      if !msgParts[1].to_s.empty? && !msgParts[2].to_s.empty?
        file = msgParts[1]
        rename = msgParts[2]
        m = MoveHelper.new(file, rename)
        @@bot[:mpd].update
        privatemessage(m.move)
      end
    end
  end
end
