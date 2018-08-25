# This plugin requires id3v2 console program to set meta tag informations from bot

require "../helpers/id3v2.rb"

class Metadata < Plugin
  private

  def getTableRow(col1, col2)
    row = "<tr>"
    row += "<td style=\"color:lightseagreen;\"><b>#{col1}</b></td>"
    row += "<td>#{col2}</td>"
    row += "</tr>"
    return row
  end

  def getListRow(val)
    row = "<style=\"padding: 0 10px 0 10px\";><td>#{val}</td></style>"
    return row
  end

  def getTableHeadCol(name)
    col = "<td style=\"color:lightseagreen;\"><b>#{name}</b></td>"
    return col
  end

  @@tab = "&#160;&#160;&#160;"

  @@id3 = ID3v2.new

  def getSongs(search)
    songs = []
    for song in @@bot[:mpd].songs
      if song.title.to_s.downcase.include? search.to_s.downcase
        songs.push(song); next
      end
      if song.artist.to_s.downcase.include? search.to_s.downcase
        songs.push(song); next
      end
      if song.album.to_s.downcase.include? search.to_s.downcase
        songs.push(song); next
      end
      if song.genre.to_s.downcase.include? search.to_s.downcase
        songs.push(song); next
      end
      if song.file.to_s.downcase.include? search.to_s.downcase
        songs.push(song)
      end
    end
    return songs
  end

  def getSong(search)
    song = @@bot[:mpd].songs.select { |s|
      s.title.to_s.downcase.include? search.to_s.downcase
    }.first
    if song.nil?
      song = @@bot[:mpd].songs.select { |s|
        s.artist.to_s.downcase.include? search.to_s.downcase
      }.first
    end
    if song.nil?
      song = @@bot[:mpd].songs.select { |s|
        s.album.to_s.downcase.include? search.to_s.downcase
      }.first
    end
    if song.nil?
      song = @@bot[:mpd].songs.select { |s|
        s.file.to_s.downcase.include? search.to_s.downcase
      }.first
    end
    return song
  end

  def getTags(search)
    song = getSong(search)
    if !song.nil?
      meta = "<table>"
      meta += getTableRow("Title:", song.title) if !song.title.nil?
      meta += getTableRow("Artist:", song.artist) if !song.artist.nil?
      meta += getTableRow("Album:", song.album) if !song.album.nil?
      meta += getTableRow("Genre:", song.genre) if !song.genre.nil?
      meta += getTableRow("Date:", song.date) if !song.date.nil?
      meta += getTableRow("File:", song.file) if !song.file.nil?
      meta += getTableRow("Length:#{@@tab}", song.length) if !song.length.nil?
      meta += "</table>"

      privatemessage(meta)
    else
      privatemessage("No file with pattern #{file} found")
    end
  end

  public

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
    h << "<b>#{Conf.gvalue("main:control:string")}meta [title|artist|album|genre|year|comment]" \
    " [pattern] [value] - add/change metadata from first file with search pattern<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}metadata [pattern] - show metadata from first audiofile with search pattern<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}metalist [pattern] - list all files with same pattern<br>"
    h << "<b>Information:</b> #{Conf.gvalue("main:control:string")}meta command works only with mp3 files<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    begin
      if parts[0] == "metadata"
        if !parts[1].nil?
          pattern = parts[1..parts.length - 1].join(" ").to_s
          getTags(pattern)
        else
          privatemessage("Usage: #{Conf.gvalue("main:control:string")}metadata [file] - " \
          "show metadata from audiofiles<br>")
        end
      end
      if parts[0] == "metalist"
        if !parts[1].nil?
          pattern = parts[1..parts.length - 1].join(" ").to_s
          songs = getSongs(pattern)
          if !songs.nil?
            text = "All songs with meta tags including search pattern #{pattern}<br>"
            text += "<table cellspacing=\"5\">"
            text += "<tr>"
            text += getTableHeadCol("File:")
            text += getTableHeadCol("Title:")
            text += getTableHeadCol("Artist:")
            text += getTableHeadCol("Album:")
            text += getTableHeadCol("Genre:")
            text += "</tr>"
            for song in songs
              text += "<tr>"
              text += "<td>#{song.file}#{@@tab}</td>"
              text += "<td>#{song.title}#{@@tab}</td>" if !song.title.nil?
              text += "<td>#{song.artist}#{@@tab}</td>" if !song.artist.nil?
              text += "<td>#{song.album}#{@@tab}</td>" if !song.album.nil?
              text += "<td>#{song.genre}#{@@tab}</td>" if !song.genre.nil?
              text += "</tr>"
            end
            text += "</table>"
            privatemessage(text)
          else
            privatemessage("No file with pattern #{parts[1]} found")
          end
        else
          privatemessage("Usage: #{Conf.gvalue("main:control:string")}metalist [pattern] -" \
          "list all files with same pattern")
        end
      end
      if parts[0] == "meta"
        tag = parts[1].to_s
        file = parts[2].to_s
        val = parts[3..parts.length - 1].join(" ").to_s
        if !tag.empty? && !file.empty? && !val.empty?
          song = @@bot[:mpd].songs.select { |s| s.file.to_s.downcase.include? file.downcase }.first
          if !song.nil?
            text = @@id3.setTitle(song.file, val) if tag == "title"
            text = @@id3.setArtist(song.file, val) if tag == "artist"
            text = @@id3.setAlbum(song.file, val) if tag == "album"
            text = @@id3.setGenre(song.file, val) if tag == "genre"
            text = @@id3.setYear(song.file, val) if tag == "year"
          else
            text = "No file found"
          end
          privatemessage(text)
          @@bot[:mpd].update
        else
          privatemessage("Wrong number of parameters!")
        end
      end
    rescue Exception => ex
      privatemessage("Metadata Error: #{ex.message}")
    end
  end
end
