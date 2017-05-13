#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
# Created by twitter.com/Kurobeats


# Install

DIRECTORY=".twister"
ip_address="127.0.0.1"

echo -e "Please setup the username and password.\n"
echo -e "Username: "

read user

echo -e "\nPassword: "

read passwd


if [ ! -d ~/${DIRECTORY} ]; then
	echo -e "\nCreating $DIRECTORY directory\n"
	mkdir ~/${DIRECTORY}
fi

cd ~/${DIRECTORY}

echo -e "Installing needed packages\n"

sudo apt update && sudo apt -y install git autoconf libtool build-essential libboost-all-dev libssl-dev libdb++-dev libminiupnpc-dev automake

echo -e "Downloading required packages\n"

git clone https://github.com/miguelfreitas/twister-core.git

cd ./twister-core
./autotool.sh
./configure
make

# Configuration & web gui

echo -e "rpcuser=${user}\nrpcpassword=${passwd}" > ~/.twister/twister.conf
chmod 600 ~/.twister/twister.conf
git clone https://github.com/miguelfreitas/twister-html.git ~/.twister/html

# Start

./twisterd -rpcuser=${user} -rpcpassword=${passwd} -rpcallowip=${ip_address} &
disown

echo -e "Service started at http://localhost:28332/index.html"

exit
