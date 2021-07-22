# Instructions to Run Full Node

 
### Hardware Requirements

- OS : Ubuntu 20.04
  ### minimal
  
  - CPU: 1 core
  - RAM: 2GB
  - Storage: 25GB SSD
  ### Recommended
  - CPU: 2 core
  - RAM: 4GB
  - Storage: 50GB SSD

### Install Go
```
# Remove existing old Go installation

sudo rm -rf /usr/local/go

# Install latest/required Go version (installing go1.16.5)

curl https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -

# Update env variables to include go

cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF

source $HOME/.profile
```
check installed go version using
```
go version
```
### Install required software packages
```
sudo apt-get install git curl build-essential make jq -y
```

### Install omniflixhub
```
git clone https://github.com/Omniflix/omniflixhub.git
cd omniflixhub
git checkout v0.1.0
make install
```
### Download Genesis 
Download genesis file from [Omniflix/testnets](https://github.com/Omniflix/testnets) repository

```
curl <genesis-url> > ~/.omniflixhub/config/genesis.json
```

### update peers & seeds
Update below seeds and/or peers in config.toml file
```
seeds = ""
persistnet_peers = ""
```


### Start Node
  before starting node update no of open files limit
  ```
   ulimit -Sn 65535
   ulimit -Hn 65535

   # verify the values above are updated correctly
   ulimit -n
  ```
  
  #### Start node with screen session
  install screen if not installed
   ```
    sudo apt-get install screen -y
   ```
  start new screen with a name
   ```
   screen -Rd omniflix
   ```
   start omniflixhub
   ```
   omniflixhubd unsafe-reset-all 
   omniflixhubd start 
   ```
   use CTRL+A+D to detach from screen
   
   (or)
   
 #### Start node as systemctl service
 
 create service file
```
sudo tee /etc/systemd/system/omniflixhubd.service > /dev/null <<EOF  
[Unit]
Description=OmniFlixHub Daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which omniflixhubd) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
load service and start
```
sudo systemctl daemon-reload
sudo systemctl enable omniflixhubd
sudo systemctl start omniflixhubd
```

check status of service
`sudo systemctl status omniflixhubd`
 
 
 we can check full logs of service using `journalctl`
 ```
  journalctl -u omniflixhubd 
  
  #most recent logs
  journalctl -xeu omniflixhubd
  
  #logs from previous day
  journalctl --since "1 day ago" -u omniflixhubd 
