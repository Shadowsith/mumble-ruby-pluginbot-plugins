# This plugin requires id3v2 console program to set meta tag informations from bot

require "../helpers/id3v2.rb"
require "../helpers/mpd.rb"

class Metadata < Plugin
  include IMpd

  public

  def init(init)
    super
    logger("INFO: INIT plugin #{self.class.name}.")
    @@bot[:meta] = self

    # put translations into member variables to space in code
    @title = I18n.t('plugin_metadata.mtags.title')
    @artist = I18n.t('plugin_metadata.mtags.artist')
    @album = I18n.t('plugin_metadata.mtags.album')
    @genre = I18n.t('plugin_metadata.mtags.genre')
    @date = I18n.t('plugin_metadata.mtags.date')
    @file = I18n.t('plugin_metadata.mtags.file')
    @length = I18n.t('plugin_metadata.mtags.length')

    return @@bot
  end

  def name
    self.class.name
  end

  def help(h)
    h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
    h << "<b>#{Conf.gvalue("main:control:string")}meta</b> " \
      "[title|artist|album|genre|year] #{I18n.t('plugin_metadata.help.meta')}<br>" 
    h << "<b>#{Conf.gvalue("main:control:string")}metaall|mall</b> " \
      "[title|artist|album|genre|year] #{I18n.t('plugin_metadata.help.mall')}<br>" 
    h << "<b>#{Conf.gvalue("main:control:string")}metadata|mdata</b>" \
      "#{I18n.t('plugin_metadata.help.mdata')}<br>" 
    h << "<b>#{Conf.gvalue("main:control:string")}metalist|mlist</b> " \
      "#{I18n.t('plugin_metadata.help.mlist')}<br>" 
    h << "<b>Information:</b> #{Conf.gvalue("main:control:string")}meta</b> " \
      "#{I18n.t('plugin_metadata.help.mp3info')}<br>" 
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    begin
      if parts[0] == "metadata" || parts[0] == "mdata"
        if !parts[1].nil?
          pattern = parts[1..parts.length - 1].join(" ").to_s
          getTags(pattern)
        else
          privatemessage("Usage: #{Conf.gvalue("main:control:string")}metadata [file] - " \
          "show metadata from audiofiles<br>")
        end
      end
      if parts[0] == "metalist" || parts[0] == "mlist"
        if !parts[1].nil?
          pattern = parts[1..parts.length - 1].join(" ").to_s
          songs = getSongs(@@bot, pattern)
          if !songs.nil?
            text = "#{I18n.t('plugin_metadata.mlist')} #{pattern}<br>"
            text += "<table cellspacing=\"5\">"
            text += "<tr>"
            text += getTableHeadCol("#{@file}:")
            text += getTableHeadCol("#{@title}:")
            text += getTableHeadCol("#{@artist}:")
            text += getTableHeadCol("#{@album}:")
            text += getTableHeadCol("#{@genre}:")
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
            privatemessage("#{I18n.t('plugin_metadata.error.fnfpattern')} #{parts[1]}")
          end
        else
          privatemessage("Usage: #{Conf.gvalue("main:control:string")}" \
          "metalist #{I18n.t('plugin_metadata.help.mlist')}")
        end
      end
      if parts[0] == "meta"
        tag = parts[1].to_s
        file = parts[2].to_s
        val = parts[3..parts.length - 1].join(" ").to_s
        if !tag.empty? && !file.empty? && !val.empty?
          # song = @@bot[:mpd].songs.select {
          #   |s|
          #   s.file.to_s.downcase.include? file.downcase
          # }.first
          song = getFirstSong(@@bot, file, "file") 
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
          update(@@bot)
        else
          privatemessage("Wrong number of parameters!")
        end
      end
      if parts[0] == "metaall" || parts[0] == "mall"
        tag = parts[1].to_s
        search = parts[2].to_s
        val = parts[3..parts.length - 1].join(" ").to_s
        if !tag.empty? && !file.empty? && !val.empty?
          songs = getSongs(@@bot, search)
          if !songs.nil?
            for song in songs
              text = @@id3.setTitle(song.file, val) if tag == "title"
              text = @@id3.setArtist(song.file, val) if tag == "artist"
              text = @@id3.setAlbum(song.file, val) if tag == "album"
              text = @@id3.setGenre(song.file, val) if tag == "genre"
              text = @@id3.setYear(song.file, val) if tag == "year"
            end
          else
            text = "file not found"
          end
          privatemessage(text)
          updateBot(@@bot)
        else
          privatemessage("#{I18n.t('plugin_metadata.error.arguments')}")
        end
      end
    rescue Exception => ex
      privatemessage("Metadata #{I18n.t('global.error')}: #{ex.message}")
    end
  end

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

  def getTags(search)
    song = getFirstSong(@@bot, search)
    if !song.nil?
      meta = "<table>"
      meta += getTableRow("#{@title}:", song.title) if !song.title.nil?
      meta += getTableRow("#{@artist}:", song.artist) if !song.artist.nil?
      meta += getTableRow("#{@album}:", song.album) if !song.album.nil?
      meta += getTableRow("#{@genre}:", song.genre) if !song.genre.nil?
      meta += getTableRow("#{@date}:", song.date) if !song.date.nil?
      meta += getTableRow("#{@file}:", song.file) if !song.file.nil?
      meta += getTableRow("#{@length}: #{@@tab}", song.length) if !song.length.nil?
      meta += "</table>"

      privatemessage(meta)
    else
      privatemessage("#{I18n.t('plugin_metadata.error.fnf')}: #{file}")
    end
  end
end
