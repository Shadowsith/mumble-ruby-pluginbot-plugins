class RemoveHelper
  private

  RM = "rm -f "
  FIND = "find $HOME/music/ -name "

  def validate(string)
    !string.match(/\A[a-zA-Z0-9.\-_\s]*\z/).nil?
  end

  public

  def initialize(searchstr)
    @search = searchstr
  end

  def delete
    if validate(@search)
      @search = FIND + "*#{@search}*" + " | head -n 1"
      match = %x(#{@search})
      if match.to_s.empty? || match.to_s == "\r\n" ||
         match.to_s == "\n"
        return "no such file exists"
      else
        system(RM + "\"" + match + "\"")
        #return "file "+match+" sucessfully deleted"
        return RM + "\"" + match[0, match.length - 1] + "\""
      end
    else
      return "The parameter [file] contains invalid characters"
    end
  end
end
