require "../helpers/deleteh.rb"
class Delete < Plugin

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
        h << "<b>#{Conf.gvalue("main:control:string")}delete [file] - delete file from bot music folder<br>"
        h
    end

    def handle_chat(msg, message) 
        super
        msgParts = message.split(" ")
        if msgParts[0] == "delete"
            if !msgParts[1].to_s.empty? 
                file = msgParts[1]
                d = DeleteHelper.new(file)
                privatemessage(d.delete)
            end
        end
    end
end

