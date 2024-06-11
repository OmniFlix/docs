# Instructions to Run Full Node
Hardware Specification
---
#### Recommended

- **Operating System (OS):** Ubuntu 22.04
- **CPU:** 8 core
- **RAM:** 32GB
- **Storage:** 1TB SSD

# A) Setup

## 1) Install Golang (go)


1.1) Install latest/required Go version (installing `go1.21.3+`)

```
sudo rm -rf /usr/local/go
wget -q -O - https://git.io/vQhTU | bash -s -- --remove
wget -q -O - https://git.io/vQhTU | bash -s -- --version 1.21.3
source $HOME/.bashrc
```

1.2) Check the version of go installed

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
git checkout v4.1.1
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
version: 4.1.1
commit: 83f984cd55bb42b3001c5c741614b03aa6d8b6bc
```

### 5) Initialize Node
 
 - **Not required if you have already initialized before**

```
omniflixhubd init <your-node-moniker> --chain-id omniflixhub-1
```


---


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
seeds="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:16956"
peers="4ef7c84feb3aa9135e75aab3b41ea76fd300d63a@136.243.4.177:26656,7c9041b9cd72ec78d8333e15c43bb78ce9f5b96f@88.198.230.27:26656"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.omniflixhub/config/config.toml
```
Additionally you can download addrbook file from here
[https://polkachu.com/addrbooks/omniflix](https://polkachu.com/addrbooks/omniflix)

   - Set minimum-gas-price in app.toml
    
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
