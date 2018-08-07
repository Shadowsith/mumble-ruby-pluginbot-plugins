class MaryTTS

    private
        @@voice = {}
        REQUEST     ="http://mary.dfki.de:59125/process?INPUT_TEXT="
        DEFAULT  = "&INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&AUDIO=WAVE_FILE"
        LOCALE      = "&LOCALE="
        VOICE       = "&VOICE="

        @@output = "-O bot_tts.wav"
        @@connection = ""        

        def init_voices
            @@voice["de_male"] = "bits3"
            @@voice["de_female"] = "bits1"
            @@voice["en_US_male"] = "dfki-spike"
            @@voice["en_US_female"] = "cmu-slt"
        end

    public
        def initialize(message, locale, voice)
            init_voices
            puts(locale+" "+voice)
            if (locale != "de"&& locale != "en")
                locale = "en_US"
            end
            
            if (voice != "male" && voice != "female") 
                voice = "male"
            end
            @@connection = "\""+REQUEST+message+DEFAULT+LOCALE+locale+VOICE+@@voice[locale+"_"+voice]+"\""
        end

        def download
            system("wget "+@@connection+" "+@@output)
        end
end
