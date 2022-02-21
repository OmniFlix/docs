# Instructions to Run Full Node
Hardware Specification
---
#### Recommended

- **Operating System (OS):** Ubuntu 20.04
- **CPU:** 2 core
- **RAM:** 8GB
- **Storage:** 200GB SSD

# A) Setup

## 1) Install Golang (go)

1.1) Remove any existing installation of `go`

```
sudo rm -rf /usr/local/go
```

1.2) Install latest/required Go version (installing `go1.17`)

```
curl https://dl.google.com/go/go1.17.5.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
```

1.3) Update env variables to include `go`
    
   - **Not required if you have already done this before**
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
sudo apt-get install git build-essential make jq -y
```

### 3) Install `omniflixhub`

```
# clone repo if not cloned previously 
git clone https://github.com/Omniflix/omniflixhub.git

# install latest version 
cd omniflixhub
git fetch --all
git checkout v0.4.0
go mod tidy
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
version: 0.4.0
commit: 43e65a64a878b2efa0a51ed29aa8e631f4b5b8bc
```

### 5) Initialize Node
 
 - **Not required if you have already initialized before**

```
omniflixhubd init <your-node-moniker> --chain-id omniflixhub-1
```


---

**Execute below instructions only after publishing of final genesis file**

genesis file will be published to [Omniflix/mainnet/omniflixhub-1](https://github.com/Omniflix/mainnet)




# B) Starting Node

## 1) Download Final Genesis
Use `curl` to download the genesis file from [Omniflix/mainnet](https://github.com/Omniflix/mainnet) repository.

```
curl https://raw.githubusercontent.com/OmniFlix/mainnet/main/omniflixhub-1/genesis.json > ~/.omniflixhub/config/genesis.json
```
Verify sha256 hash of genesis file with the below command
```
jq -S -c -M '' ~/.omniflixhub/config/genesis.json | shasum -a 256
```
genesis sha256 hash should be 
```
3c01dd89ae10f3dc247648831ef9e8168afd020946a13055d92a7fe2f50050a0
```

## 2) Update Config 
   - Update Peers & Seeds in config.toml

```
seeds="9d75a06ebd3732a041df459849c21b87b2c55cde@35.187.240.195:26656,19feae28207474eb9f168fff9720fd4d418df1ed@35.240.196.102:26656"
peers="2df1f357f08049ba0c0dddfffe805f0e135e54ec@35.247.185.216:26656,6198ac4bc907f6d1a78309ef58491370afc49799@34.124.195.219:26656"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.omniflixhub/config/config.toml
```
   - Set minimum-gas-price
    
    minimum-gas-prices = "0.001uflix"
    

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
