# Instructions to Run Full Node
Hardware
---
#### Recommended

- **Operating System (OS):** Ubuntu 20.04
- **CPU:** 2 core
- **RAM:** 4GB
- **Storage:** 250GB SSD

# A) Setup

## 1) Install Golang (go)

1.1) Remove any existing installation of `go`

```
sudo rm -rf /usr/local/go
```

1.2) Install latest/required Go version (installing `go1.17`)

```
curl https://dl.google.com/go/go1.17.3.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
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
# clone repo if not cloned previously 
git clone https://github.com/Omniflix/omniflixhub.git

# install latest version 
cd omniflixhub
git fetch --all
git checkout v0.3.0
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
version: 0.3.0
commit: <version-commit>
```

### 5) Initialize Node
 **Not required if you have already initialized before**

```
omniflixhubd init <your-node-moniker> --chain-id flixnet-3
```
On running the above command, node will be initialized with default configuration. (config files will be saved in node's default home directory (~/.omniflixhub/config)

NOTE: Backup node and validator keys . You will need to use these keys at a later point in time.

---

**Execute below instructions only after publishing of final genesis file**

genesis file will be published to [Omniflix/testnets/flixnet-3](https://github.com/Omniflix/testnets)




# B) Starting Node

## 1) Download Final Genesis
Use `curl` to download the genesis file from [Omniflix/testnets](https://github.com/Omniflix/testnets) repository.

```
curl https://raw.githubusercontent.com/OmniFlix/testnets/main/flixnet-3/genesis.json > ~/.omniflixhub/config/genesis.json
```
Verify sha256 hash of genesis file with the below command
```
jq -S -c -M '' ~/.omniflixhub/config/genesis.json | shasum -a 256
```
genesis sha256 hash should be 
```
To be updated
```

## 2) Update Peers & Seeds in config.toml

```
seeds=""
peers=""
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.omniflixhub/config/config.toml
```

## 3) Start the Node

#### 3.1) Start node as `systemctl` service

3.1.1) Create the service file

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

3.1.2) Load service and start
```
sudo systemctl daemon-reload
sudo systemctl enable omniflixhubd
sudo systemctl start omniflixhubd
```

3.1.3) Check status of service
```
sudo systemctl status omniflixhubd
```

`NOTE:`
A helpful command here is `journalctl` that can be used to:

  a) check logs
  ```
  journalctl -u omniflixhubd
  ```

  b) most recent logs
  ```
  journalctl -xeu omniflixhubd
  ```

  c) logs from previous day
  ```
  journalctl --since "1 day ago" -u omniflixhubd
  ```

  d) Check logs with follow flag
  ```
  journalctl -f -u omniflixhubd
  ```
