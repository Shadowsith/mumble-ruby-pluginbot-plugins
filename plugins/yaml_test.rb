require 'yaml'
filename = "mtts.yml"
data = YAML::load(File.open(filename))
puts data["lang"]
data["lang"] = "de"
File.open(filename, "w+") {
    |f| f.write(data.to_yaml)
}
