class MoveHelper
  private
    MV = "mv "
    FIND = "find $HOME/music/ -name "

    def validate(string)
        !string.match(/\A[a-zA-Z0-9.\-_\s]*\z/).nil?
    end
    
  public
    def initialize(searchstr, newName)
        @search = searchstr
        @newName = newName
    end

    def move
        if !validate(@newName)
            return "The parameter [new name] contains invalid characters"
        end
        if validate(@search)
            @search = FIND+"*#{@search}*"+" | head -n 1"
            match = %x(#{@search})
            match = match[0,match.length-1]
            if match.to_s.empty? || match.to_s == "\r\n" ||
                    match.to_s == "\n"
                return "no such file exists" 
            else
                system(MV+"\""+match+"\""+" $HOME/music/"+@newName)
                return "file "+match+" sucessfully renamed to "+@newName
            end
        else
            return "The parameter [file] contains invalid characters"
        end
    end
end
