# Instructions to Run Full Node
Hardware
---
#### Supported
- **Operating System (OS):** Ubuntu 20.04 (minimal)
- **CPU:** 1 core
- **RAM:** 2GB
- **Storage:** 25GB SSD

#### Recommended

- **Operating System (OS):** Ubuntu 20.04 (minimal)
- **CPU:** 2 core
- **RAM:** 4GB
- **Storage:** 50GB SSD

# A) Setup

## 1) Install Golang (go)

1.1) Remove any existing installation of `go`

```
sudo rm -rf /usr/local/go
```

1.2) Install latest/required Go version (installing `go1.16.5`)

```
curl https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
```

1.3) Update env variables to include `go`

```
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF

source $HOME/.profile
```

1.4) Check the version of go installed

```
go version
```

### 2) Install required software packages

```
sudo apt-get install git curl build-essential make jq -y
```

### 3) Install `omniflixhub`

```
git clone https://github.com/Omniflix/omniflixhub.git
cd omniflixhub
git checkout v0.1.0
make install
```

### 4) Verify your installation
```
omniflixhubd version --long
```

On running the above command, you should see a similar response like this. Make sure that the *version* and *commit hash* are accurate

```
name: OmniFlixHub
server_name: omniflixhubd
version: 0.1.0
commit: 95e2aebaf02406bdcc78f9268380528bd1a25617
```

### 5) Initialize Node
 **Not required if you have already initialized before**

```
omniflixhubd init <your-node-moniker> --chain-id flixnet-1 
```
On running the above command, node will be initialized with default configuration. (config files will be saved in node's default home directory (~/.omniflixhub/config)

NOTE: Backup node and validator keys . You will need to use these keys at a later point in time.

### 6) Download Genesis 
Download genesis file from [Omniflix/testnets](https://github.com/Omniflix/testnets) repository

```
curl <genesis-url> > ~/.omniflixhub/config/genesis.json
```

### 7) update peers & seeds
Update below seeds and/or peers in `~/omniflixhub/config/config.toml` file
```
seeds = ""
persistnet_peers = ""
```


# B) Start Node
 - ### 1) Start node with screen session
   1.1) Update no of open files limit
   ```
   ulimit -Sn 65535
   ulimit -Hn 65535

   # verify the values above are updated correctly
   ulimit -n
   ```
   1.2) install screen if not installed
   ```
    sudo apt-get install screen -y
   ```
   1.3) start new screen with a name
   ```
   screen -Rd omniflix
   ```
   1.4) start omniflixhub
   ```
   omniflixhubd unsafe-reset-all 
   omniflixhubd start 
   ```
   1.5) use CTRL+A+D to detach from screen
   
   (OR)
   
 - ### 2) Start node as systemctl service
   2.1) Create service file
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
   2.1) Load service and start
   ```
   sudo systemctl daemon-reload
   sudo systemctl enable omniflixhubd
   sudo systemctl start omniflixhubd 
   ```

   2.2) check status of service
   ```
   sudo systemctl status omniflixhubd
   ```
   2.3) You can use `journalctl` to:
   - check logs
 `journalctl -u omniflixhubd` 

   - most recent logs
`journalctl -xeu omniflixhubd`

   - logs from previous day
`journalctl --since "1 day ago" -u omniflixhubd`  
