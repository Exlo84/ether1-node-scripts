#!/usr/bin/env sh
_user="$(id -u -n)"

echo '**************************'
echo 'Installing misc dependencies'
echo '**************************'
# install dependencies
sudo apt-get update && sudo apt-get install systemd unzip wget -y

echo '**************************'
echo 'Installing Ether-1 Node binary'
echo '**************************'
# Download node binary
sudo systemctl stop ether1node

sudo rm geth

wget https://www.dropbox.com/s/c71bea1lrfg4exy/geth-arm.zip

unzip geth-arm.zip

# Make node executable
chmod +x geth

# Remove and cleanup
rm geth-arm.zip

echo '**************************'
echo 'Creating and setting up system service'
echo '**************************'

cat > /tmp/ether1node.service << EOL
[Unit]
Description=Ether1 Masternode/Service Node
After=network.target

[Service]

User=$_user
Group=$_user

Type=simple
Restart=always

ExecStart=/usr/sbin/geth --syncmode=fast --cache=512

[Install]
WantedBy=default.target
EOL
        sudo \mv /tmp/ether1node.service /etc/systemd/system
        sudo \rm /usr/sbin/geth
        sudo \mv geth /usr/sbin/
        sudo systemctl enable ether1node && systemctl stop ether1node && systemctl start ether1node
        systemctl status ether1node --no-pager --full

echo 'Done.'

