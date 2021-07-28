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

## 6) Create Account keys 

```
omniflixhubd keys add <key-name>
```

NOTE: Save `mnemonic` and related account details (public key). You will need to use the need mnemonic/private key to recover accounts at a later point in time.

---

**Execute below instructions only after publishing of final genesis file**

genesis file will be published to [Omniflix/testnets/flixnet-1](https://github.com/Omniflix/testnets)




# B) Starting the validator

## 1) Download Final Genesis
Use `curl` to download the genesis file from [Omniflix/testnets](https://github.com/Omniflix/testnets) repository.

```
curl https://raw.githubusercontent.com/OmniFlix/testnets/main/flixnet-1/genesis.json > ~/.omniflixhub/config/genesis.json
```
Verify sha256 hash of genesis file with the below command
```
shasum -a 256 ~/.omniflixhub/config/genesis.json
``` 
The hash should be:
```ced9186f654d7598125fb23756d14ff0692892322d4ff35eebd467166cb0883e```

## 2) Update Peers & Seeds in config.toml
```
seeds="af3b140b9283f568aa49097e9e7dba8a9f3498e3@45.72.100.122:26656"
peers="449848dbf4c9efec273f9014b3e2ff7f2ca468e5@45.72.100.123:26656,086706a33dd2c511bf0162ee3583429a9e2ab1a5@45.72.100.124:26656"

sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.omniflixhub/config/config.toml
```
## 3) Start the Node
Use **3.2** for better approch
### 3.1) Start node with screen session
3.1.1) Update the limit of `number of open files`
```
 ulimit -Sn 65535
 ulimit -Hn 65535

 # Verify the values above are updated accurately
 ulimit -n
```

3.1.2) Install screen if not installed
```
sudo apt-get install screen -y
```

3.1.3) Start new screen with a name
 ```
 screen -Rd omniflix
 ```

3.1.4) Start omniflixhub
 ```
 omniflixhubd unsafe-reset-all 
 omniflixhubd start 
 ```

3.1.5) Use `CTRL+A+D` to detach the `screen`
   
(OR)

#### 3.2) Start node as `systemctl` service

3.2.1) Create the service file

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

3.2.2) Load service and start
```
sudo systemctl daemon-reload
sudo systemctl enable omniflixhubd
sudo systemctl start omniflixhubd
```

3.2.3) Check status of service
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
