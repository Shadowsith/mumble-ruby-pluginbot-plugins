class DeleteHelper
    private
        RM = "rm "
        FIND = "find ~/music/ -name "
    
    public
        def initialize(searchstr)
            @search = FIND+" *#{searchstr}* | head -n 1"
        end

        def getMatch
            @find = %x(#{@search})
            return @find
        end

        def delete
            match = getMatch
            if match.to_s.empty? || match.to_s == "\r\n" ||
                    match.to_s == "\n"
                return "no such file exists" 
            else
                system(RM+getMatch)
                return "file sucessfully deleted"
            end
        end
end
