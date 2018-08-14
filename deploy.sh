# Deploys all plugins to the bot at user botmaster
# later you will be ask for each plugin
cp -f ./helpers/* /home/botmaster/src/mumble-ruby-pluginbot/helpers/
cp -f ./plugins/* /home/botmaster/src/mumble-ruby-pluginbot/plugins/
sudo chown -R botmaster:botmaster /home/botmaster/src/mumble-ruby-pluginbot/
exit
