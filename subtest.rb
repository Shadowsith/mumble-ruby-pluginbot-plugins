str = "cmd -xyz && cmd2 && cmd3 ../ && cmd4 ./ | grep"
puts(str)
str = str.gsub("&","").gsub("/","").gsub("~","").gsub("|","")
puts(str)
