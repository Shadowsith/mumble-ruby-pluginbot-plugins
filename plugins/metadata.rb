class Metadata < Plugin
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
    h << "<b>#{Conf.gvalue("main:control:string")}meta [title|artist] [value] [file] - add/change metadata from audiofiles<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}meta [file] - show metadata from audiofiles<br>"
    h
  end

  def handle_chat(msg, message)
    super
    if message == "meta"
    end
  end
end
