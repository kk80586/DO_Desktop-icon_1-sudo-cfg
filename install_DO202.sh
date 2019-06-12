# install-DeepOnion_202.sh
# This script is an update of the one script install. This includes Desktop icon and complete 
# configuration with one sudo for configuration after reboot.
# If you download from pastebin you need to install and run dos2unix on the file.
# This file should be placed in /home/amnesia/Persistent/ and run by user amnesia.
#
# This script automatically installs DeepOnion Wallet Ver.2.0.2 (DV) .deb package from
# the DeepOnion repository. The only interaction required is sudo password about 14 times and
# 2 copy/pastes. I started Tails with a very short password for the setup of Wallet. Your choice.
# NOTE: If you do not want DeepVault version just make appropriate edits. 
#
# I used a 16Gb SanDisk Cruzer Glide slider type USB2.0/3.0 (~$7). A fresh install of 
# latest version of Tails (3.14). 'Personal Data' and 'Additional software' and 'Dotfiles' should be 
# turned on in "Configure persistent volume" setup.
# 
# You should read and somewhat understand this script before running it. Not so much the code
# but the text will help you understand when and why the script will stop and wait for action.
# First section is the commands from: 
# https://deeponion.org/community/threads/official-tails-debian-and-ubuntu-install-guide.39319/
#
# The next 2 commands sometimes fail to connect and download. Watch output in terminal window
# and if one or both fail just <CTRL-C> and run them manually in the terminal window.
# You can then comment out the 2 lines if you want. Then restart the script. 
read -p " IF EITHER OF THE NEXT 2 COMMANDS FAIL THEN <CRTL-C>.  Press ENTER to continue."
#  
wget http://ppa.deeponion.org.uk/bitcoin.gpg
wget http://ppa.deeponion.org.uk/pgp.key
#
read -p " <CTRL-C> to quit  OR   Press ENTER to continue."
#
sudo install -d -m 755 /live/persistence/TailsData_unlocked/apt-sources.list.d
echo "/etc/apt/sources.list.d source=apt-sources.list.d,link" | sudo tee --append /live/persistence/TailsData_unlocked/persistence.conf
echo "deb tor+http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu xenial main" | sudo tee --append /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list
echo "deb [arch=amd64] tor+http://ppa.deeponion.org.uk/debian stretch main" | sudo tee --append /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list
sudo chown root:root /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list
sudo chmod 644 /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list
sudo ln -s /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list /etc/apt/sources.list.d/deeponion.list
echo "deeponion-qt-dv" | sudo tee --append /live/persistence/TailsData_unlocked/live-additional-software.conf
echo "deeponiond-dv" | sudo tee --append /live/persistence/TailsData_unlocked/live-additional-software.conf
## wget http://ppa.deeponion.org.uk/bitcoin.gpg
sudo apt-key add bitcoin.gpg
## wget http://ppa.deeponion.org.uk/pgp.key
sudo apt-key add pgp.key
sudo apt-get update
sudo apt-get install unzip
# sudo apt-get install deeponion-qt deeponiond -y
sudo apt-get install deeponion-qt-dv deeponiond-dv -y
# This section creates directories, DeepOnion.conf, firewall conf and downloads/unzips blockchain.
# **********************************************************************************************
cd /home/amnesia/Persistent/
mkdir /home/amnesia/.config/DeepOnion
mkdir /home/amnesia/Persistent/.DeepOnion/
mkdir /home/amnesia/Persistent/.DeepOnion/wallets/
mkdir /home/amnesia/Persistent/.DeepOnion/conf_files/
mkdir /home/amnesia/Persistent/.DeepOnion/conf_files/ferm/
mkdir /home/amnesia/Persistent/.DeepOnion/conf_files/dot-config
mkdir /home/amnesia/Persistent/.DeepOnion/conf_files/desktop
mkdir /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/
mkdir /home/amnesia/Persistent/.DeepOnion/conf_files/icons/
#
###################################################################################################
cd /home/amnesia/Persistent/.DeepOnion/
#  ******** I could not get this command to work in Tails so we'll do it differently *********
#  Get Fresh Nodes:
#  curl -o DeepOnion.conf https://deeponion.org/conf_file/DeepOnion.conf
#  *******************************************************************************************
#  Tor browser will start and open https://deeponion.org/DeepOnion.conf.php
#  Copy (select->right-click->copy) Then close browser. DeepOnion.conf will open. Paste.
read -p " CLOSE BROWSER after selecting required text.  Press ENTER to continue."
/usr/local/lib/tor-browser/firefox.real -allow-remote --class Tor Browser -profile /home/amnesia/.tor-browser/profile.default https://deeponion.org/conf_file/DeepOnion.conf
#  https://deeponion.org/DeepOnion.conf.php
#  download it or copy/paste by executing next 2 lines:
touch DeepOnion.conf
read -p " AFTER COPY/PASTE <CTRL=X> THEN 'y'.       Press ENTER to continue."
nano DeepOnion.conf
# **********************************************************************************************
#  Copy ferm.conf and edit:
#  !!!!!!!!      BE CAREFUL!! THIS IS THE FIREWALL CONFIG!!     !!!!!!!!!
#  !!  If you make a mistake do not abort install. you can edit later. !! 
cp /etc/ferm/ferm.conf /home/amnesia/Persistent/.DeepOnion/conf_files/ferm/
read -p " CLOSE BROWSER after selecting required text.  Press ENTER to continue."
/usr/local/lib/tor-browser/firefox.real -allow-remote --class Tor Browser -profile /home/amnesia/.tor-browser/profile.default https://deeponion.org/conf_file/DeepOnion.conf https://deeponion.org/community/threads/official-tails-debian-and-ubuntu-install-guide.39319/
#
#  !!!!!!!!    BE CAREFUL!! THIS IS THE FIREWALL CONFIG!!    !!!!!!
read -p " AFTER COPY/PASTE <CTRL=X> THEN 'y'.       Press ENTER to continue."
nano /home/amnesia/Persistent/.DeepOnion/conf_files/ferm/ferm.conf
# ***********************************************************************************************
# Edit system menu icon to exec DeepOnion using torsocks.
#
echo "[Desktop Entry]" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Version=2.0" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Name=DeepOnion Core" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Comment=Connect to the DeepOnion Tor P2P Network" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Comment[de]=Verbinde mit dem DeepOnion Tor peer-to-peer Netzwerk" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Comment[fr]=DeepOnion, monnaie virtuelle cryptographique pair à pair" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Comment[tr]=DeepOnion, eşten eşe kriptografik sanal para birimi" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Exec=torsocks DeepOnion-qt -datadir=/home/amnesia/Persistent/.DeepOnion" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Terminal=false" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Type=Application" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Icon=deeponion128" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "MimeType=x-scheme-handler/DeepOnion;" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "Categories=Office;Finance;" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
echo "StartupWMClass=DeepOnion-qt" >> /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop
# ******************************************************************************************
# create default DeepOnion-Qt.conf used for settings/configuration.
#
cd /home/amnesia/Persistent/.DeepOnion/conf_files/dot-config/
touch DeepOnion-Qt.conf
echo "[General]" >> DeepOnion-Qt.conf
echo 'addrProxy="127.0.0.1:%2"' >> DeepOnion-Qt.conf
echo 'addrSeparateProxyTor="127.0.0.1:%2"' >> DeepOnion-Qt.conf
echo "bSpendZeroConfChange=true" >> DeepOnion-Qt.conf
echo "fCoinControlFeatures=false" >> DeepOnion-Qt.conf
echo "fHideTrayIcon=false" >> DeepOnion-Qt.conf
echo "fListen=true" >> DeepOnion-Qt.conf
echo "fMinimizeOnClose=false" >> DeepOnion-Qt.conf
echo "fMinimizeToTray=false" >> DeepOnion-Qt.conf
echo "fRestartRequired=false" >> DeepOnion-Qt.conf
echo "fUseProxy=false" >> DeepOnion-Qt.conf
echo "fUseSeparateProxyTor=false" >> DeepOnion-Qt.conf
echo "fUseUPnP=false" >> DeepOnion-Qt.conf
echo "language=" >> DeepOnion-Qt.conf
echo "nDatabaseCache=450" >> DeepOnion-Qt.conf
echo "nDisplayUnit=0" >> DeepOnion-Qt.conf
echo "nSettingsVersion=2000200" >> DeepOnion-Qt.conf
echo "nThreadsScriptVerif=0" >> DeepOnion-Qt.conf
# echo "strDataDir=/home/amnesia/.DeepOnion" >> DeepOnion-Qt.conf
echo "strDataDir=/home/amnesia/Persistent/.DeepOnion" >> DeepOnion-Qt.conf
echo "strThirdPartyTxUrls=" >> DeepOnion-Qt.conf
echo "theme=" >> DeepOnion-Qt.conf
# ******************************************************************************************
# Make dirs for autostart
mkdir /live/persistence/TailsData_unlocked/dotfiles/.config/
mkdir /live/persistence/TailsData_unlocked/dotfiles/.config/autostart/
mkdir /live/persistence/TailsData_unlocked/dotfiles/.config/DeepOnion/
# ******************************************************************************************
# create /live/persistence/TailsData_unlocked/dotfiles/.config/autostart/startmeup.desktop
#
cd /live/persistence/TailsData_unlocked/dotfiles/.config/autostart/
touch startmeup.desktop
echo "[Desktop Entry]" >> startmeup.desktop
echo "Version=2.0.2" >> startmeup.desktop
echo "Encoding=UTF-8" >> startmeup.desktop
echo "X-GNOME-Autostart-enabled=true" >> startmeup.desktop
echo "Exec=/home/amnesia/Persistent/.DeepOnion/conf_files/scripts/startmeup.sh" >> startmeup.desktop
echo "Type=Application" >> startmeup.desktop
echo "Name=autostart" >> startmeup.desktop
echo "Terminal=true" >> startmeup.desktop
echo "StartupWMClass=DeepOnion-qt" >> startmeup.desktop
chmod +x startmeup.desktop
# ********************************************************************************************
# create /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/DeepOnion-Core.desktop
#
cd /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/
touch DeepOnion-Core.desktop
echo "[Desktop Entry]" >> DeepOnion-Core.desktop
echo "Version=2.0.2" >> DeepOnion-Core.desktop
echo "Encoding=UTF-8" >> DeepOnion-Core.desktop
echo "Name=DeepOnion Core" >> DeepOnion-Core.desktop
echo "Comment=Connect to the DeepOnion Tor P2P Network" >> DeepOnion-Core.desktop
echo "Exec=torsocks DeepOnion-qt -datadir=/home/amnesia/Persistent/.DeepOnion" >> DeepOnion-Core.desktop
echo "Type=Application" >> DeepOnion-Core.desktop
echo "Icon=deeponion128" >> DeepOnion-Core.desktop
echo "MimeType=x-scheme-handler/DeepOnion;" >> DeepOnion-Core.desktop
echo "Name=DeepOnion Core" >> DeepOnion-Core.desktop
chmod +x DeepOnion-Core.desktop
# ********************************************************************************************
# create /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/startmeup.sh
cd /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/
touch startmeup.sh
echo 'echo "Wait for TOR to connect and enter sudo password to continue. "' >> startmeup.sh
echo "cp /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/DeepOnion-Core.desktop /home/amnesia/Desktop/" >> startmeup.sh
echo "gio set /home/amnesia/Desktop/DeepOnion-Core.desktop metadata::trusted yes" >> startmeup.sh
echo "chmod +x /home/amnesia/Desktop/DeepOnion-Core.desktop" >> startmeup.sh
# echo "read -n 1 -s -r" >> startmeup.sh
echo "sudo /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/startup2.sh" >> startmeup.sh
chmod +x startmeup.sh
# ********************************************************************************************
# create /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/startup2.sh
cd /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/
touch startup2.sh
echo "cp /home/amnesia/Persistent/.DeepOnion/conf_files/ferm/ferm.conf /etc/ferm/ferm.conf && ferm /etc/ferm/ferm.conf" >> startup2.sh
echo "cp /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop /usr/share/applications/" >> startup2.sh
echo "chmod +x /usr/share/applications/deeponion-qt-dv.desktop" >> startup2.sh
chmod +x startup2.sh
# ********************************************************************************************
# Some configuration so that DeepOnion Wallet will start and run without rebooting first time only.
# 
cp /home/amnesia/Persistent/.DeepOnion/conf_files/scripts/DeepOnion-Core.desktop /home/amnesia/Desktop/
gio set /home/amnesia/Desktop/DeepOnion-Core.desktop metadata::trusted yes
chmod +x /home/amnesia/Desktop/DeepOnion-Core.desktop
# cp /home/amnesia/Persistent/.DeepOnion/conf_files/dot-config/DeepOnion-Qt.conf /home/amnesia/.config/DeepOnion/
cp /home/amnesia/Persistent/.DeepOnion/conf_files/dot-config/DeepOnion-Qt.conf /live/persistence/TailsData_unlocked/dotfiles/.config/DeepOnion/DeepOnion-Qt.conf
ln -s /live/persistence/TailsData_unlocked/dotfiles/.config/DeepOnion/DeepOnion-Qt.conf /home/amnesia/.config/DeepOnion/DeepOnion-Qt.conf
sudo cp /home/amnesia/Persistent/.DeepOnion/conf_files/desktop/deeponion-qt-dv.desktop /usr/share/applications/deeponion-qt-dv.desktop
sudo chmod +x /usr/share/applications/deeponion-qt-dv.desktop
sudo cp /home/amnesia/Persistent/.DeepOnion/conf_files/ferm/ferm.conf /etc/ferm/ferm.conf && sudo ferm /etc/ferm/ferm.conf

# ********************************************************************************************
# ############################################################################################
read -p "Blockchain download next. <CTRL-C> to skip.  Press ENTER to continue."
#  Get DeepOnion legacy chain:
#  https://deeponion.org/blockchainlegacy
#  Get V2+ blockchain
cd /home/amnesia/Persistent/.DeepOnion/
wget https://www.dropbox.com/s/dl/pjqmyl6q32g9g56/blockchain_rebased.zip
#  Be sure it is placed in .DeepOnion folder.
#  Execute next line:
unzip -o blockchain_rebased.zip
# ********************************************************************************************
# ***********                     RUN config-DeepOnion.sh SCRIPT                          *************
# 
#

echo "Congratulations!! You should be ready to start DeepOnion Wallet Ver. 2.0.2-DV on Tails. . Locate the start icon on the Desktop or in the Tails menu, 'Applications' --> 'Office' --> 'DeepOnion Core'."
#************************************************************************************************* 
#  
#  ************************************************************************************
#
#  ***                          GENERAL INSTRUCTIONS                                           ***
#
#     These instructions are done in the script now but I left then in for reference.
#   ***************************  EDIT FIREWALL FOR DeepOnion   *********************************
#  This is ONE TIME only:
#  Copy pre-edited ferm.conf to allow DeepOnion and execute ferm to take effect
#  Put copy of edited ferm.conf in /home/amnesia/Persistent/.DeepOnion/conf-files/ferm/
#  
#  
#   Insert the following lines into ferm.conf:
#   See Official Instructions: 
#   reference:https://deeponion.org/community/threads/official-tails-debian-and-ubuntu-install-guide.39319/
#
#   *********  below here **************  The first line is a comment. Leave one (#).
#     # White-list access to DeepOnion
#     daddr 127.0.0.1 proto tcp syn dport 9081 {
#         mod owner uid-owner \$amnesia_uid ACCEPT;
#     }
#   **********  above here *************
#   ***************************************************************************************************
#***************                                                   **************** 
#   ****************   SAVE WALLET SETTINGS FOR AFTER REBOOT   ******************
#  This is ONE TIME only: (not needed when using dotfiles)
#  If you make changes to configuration you want to save, you'll need to execute the 
#   command again before rebooting.
#  Copy Wallet configuration of your preferred settings to backup. 
#   cp /home/amnesia/.config/DeepOnion/DeepOnion-Qt.conf /home/amnesia/Persistence/.DeepOnion/conf_files/dot-config/DeepOnion-Qt.conf
#    The first time you run, do setup configuation (coin control, language, theme, etc.) THEN:
#   ************************************************************************************************
#
#***********************  WHEN EVERYTHING ABOVE IS DONE   **************************************
#   START WALLET!! :)
#   ******   Execute ./config-DeepOnion.sh after reboot and BEFORE starting DeepOnion wallet  *******
#   DO NOT START WALLET BEFORE ALL SETUP IS FINISHED!!
#
#    *******************      PUBLIC SERVICE ANNOUNCEMENT    ******************
#    IF YOU MAKE CHANGES TO YOUR PREFERENCES: (not needed when using dotfiles)
#  DON'T FORGET TO SET PREFERENCES AND COPY FILE from /home/amnesia/.config/DeepOnion/DeepOnion-Qt.conf to  /home/amnesia/Persistence/.DeepOnion/conf_files/dot-config/DeepOnion-Qt.conf
#
#            !!!!!!!!!!!!!!!!!!!!! FINALLY!!!  HERE IT IS !!!!!!!!!!!!!!!!!
###############################################################################################
#**********************************************************************************************
##############          CLICK 'Applications' --> 'Office' --> 'DeepOnion Core'  ###############
##############                     OR the link icon on Desktop                  ############### 
#**********************************************************************************************
###############################################################################################
