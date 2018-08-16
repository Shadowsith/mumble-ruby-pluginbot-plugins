require "yaml"

class MaryTTSHelper
  private

  @@voice = {}
  REQUEST = "http://mary.dfki.de:59125/process?INPUT_TEXT="
  DEFAULT = "&INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&AUDIO=WAVE_FILE"
  LOCALE = "&LOCALE="
  VOICE = "&VOICE="
  FFMPEG = "ffmpeg -loglevel quiet -y -i "
  FF_PARA = " -vn -ar 44100 -ac 2 -ab 192k -f mp3 -metadata title=\"marytts\" -metadata artist=\"marytts\" -filter:a \"volume=2.0\" "

  FILE = "marytts.wav"
  OUTPUT_FILE = "marytts.mp3"
  RM = "rm "

  def init_voices
    @@voice["de_male"] = "bits3"
    @@voice["de_female"] = "bits1"
    @@voice["en_US_male"] = "dfki-spike"
    @@voice["en_US_female"] = "cmu-slt"
  end

  public

  def initialize(path, message, lang, voice)
    if lang == "en"
      lang = "en_US"
    end
    @mpath = path
    init_voices
    @download = "\"" + REQUEST + message + DEFAULT + LOCALE + lang + VOICE + @@voice[lang + "_" + voice] + "\""
    @audio = FFMPEG + @mpath + FILE + FF_PARA + @mpath + OUTPUT_FILE
    @delete = RM + @mpath + FILE
  end

  def getFileName
    return OUTPUT_FILE
  end

  def load
    puts("wget -q " + @download + " -O " + @mpath + FILE + " -T 1 --tries=4")
    system("wget -q " + @download + " -O " + @mpath + FILE + " -T 1 --tries=4")
    system(@audio)
    system(@delete)
  end
end
