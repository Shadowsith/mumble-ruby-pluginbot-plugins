class RemoveHelper
  private
    RM = "rm "
    FIND = "find $HOME/music/ -name"

    def validate(string)
        !string.match(/\A[a-zA-Z0-9.\-_\s]*\z/).nil?
    end
    
  public
    def initialize(searchstr)
        @search = FIND+" *#{searchstr}*"+" -print -quit"
    end

    def delete
        if validate(@search)
            match = %x(#{@search})
            if match.to_s.empty? || match.to_s == "\r\n" ||
                    match.to_s == "\n"
                return "no such file exists" 
            else
                system(RM+match)
                return "file sucessfully deleted"
            end
        else
            return "The parameter [file] contains invalid characters"
        end
    end
end
