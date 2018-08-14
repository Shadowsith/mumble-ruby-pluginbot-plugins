class MaryTtsHelper

  private
    @@voice = {}
    CD = "cd $HOME/music && "
    REQUEST     ="http://mary.dfki.de:59125/process?INPUT_TEXT="
    DEFAULT  = "&INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&AUDIO=WAVE_FILE"
    LOCALE      = "&LOCALE="
    VOICE       = "&VOICE="        
    FFMPEG = "ffmpeg -y -i "
    FF_PARA = " -vn -ar 44100 -ac 2 -ab 192k -f mp3 -metadata title=\"marytts\" -metadata artist=\"marytts\" "


    FILE = "marytts.wav"
    OUTPUT_FILE = "marytts.mp3"
    @@download = ""        
    RM = "rm "
    @@delete = ""
    @@audio = ""

    def init_voices
        @@voice["de_male"] = "bits3"
        @@voice["de_female"] = "bits1"
        @@voice["en_US_male"] = "dfki-spike"
        @@voice["en_US_female"] = "cmu-slt"
    end

  public
    def initialize(message, lang, voice)
        init_voices
        puts(lang+" "+voice)
        if (lang != "de"&& lang != "en_US")
            lang = "en_US"
        end
        
        if (voice != "male" && voice != "female") 
            voice = "male"
        end
        @@download = "\""+REQUEST+message+DEFAULT+LOCALE+lang+VOICE+@@voice[lang+"_"+voice]+"\""
        @@audio = CD+FFMPEG+FILE+FF_PARA+OUTPUT_FILE
        @@delete = CD+RM+FILE
    end

    def getFileName
        return OUTPUT_FILE
    end

    def load
        system(CD+"wget "+@@download+" -O"+ FILE)
        system(@@audio)
        system(@@delete+" && pwd")
    end
end
