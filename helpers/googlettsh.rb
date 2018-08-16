# This plugin requires mplayer

class GoogleTtsHelper
  private

  REQUEST = "http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0&textlen=32&client=tw-ob&q="
  @@lang = "&tl="
  MPLAYER = "mplayer "
  MP_PARA = " -vc null -vo null -ao pcm:fast:waveheader:file="
  FFMPEG = "ffmpeg -y -i "
  FF_PARA = "-vn -ar 44100 -ac 2 -ab 192k -f mp3 -metadata title=\"google\" -metadata artist=\"google\" "
  FILE = "google.wav "
  OUTPUT_FILE = "google.mp3"
  CD = "cd ~/music && "
  RM = "rm "
  @@download = ""
  @@delete = ""
  @@audio = ""

  public

  def initialize(message, lang)
    @message = "\"" + REQUEST + message + @@lang + lang + "\""
    @@download = CD + MPLAYER + @message + MP_PARA + FILE
    @@delete = CD + RM + FILE
    @@audio = CD + FFMPEG + FILE + FF_PARA + OUTPUT_FILE
  end

  def getFileName
    return OUTPUT_FILE
  end

  def load
    system(@@download)
    system(@@audio)
    system(@@delete)
  end
end
