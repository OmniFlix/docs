# Setting up a Genesis Validator for OmniFlix Testnet (flixnet-2)

Hardware
---
#### Supported
- **Operating System (OS):** Ubuntu 20.04
- **CPU:** 1 core
- **RAM:** 2GB
- **Storage:** 25GB SSD

#### Recommended

- **Operating System (OS):** Ubuntu 20.04
- **CPU:** 2 core
- **RAM:** 4GB
- **Storage:** 50GB SSD

# A) Setup

## 1) Install Golang (go)

1.1) Remove any existing installation of `go`

```
sudo rm -rf /usr/local/go
```

1.2) Install latest/required Go version (installing `go1.16.7`)

```
curl https://dl.google.com/go/go1.16.7.linux-amd64.tar.gz | sudo tar -C /usr/local -zxvf -
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

## 2) Install required software packages

```
sudo apt-get install git curl build-essential make jq -y
```

## 3) Install `omniflixhub`

```
git clone https://github.com/Omniflix/omniflixhub.git
cd omniflixhub
git fetch --all
git checkout v0.2.1
make install
```

## 4) Verify your installation
```
omniflixhubd version --long
```

On running the above command, you should see a similar response like this. Make sure that the *version* and *commit hash* are accurate

```
name: OmniFlixHub
server_name: omniflixhubd
version: 0.2.1
commit: 013609d6c7af71a85e94b8e21514debc5afb8e0c
```

## 5) Initialize Node

```
omniflixhubd init <your-node-moniker> --chain-id flixnet-2 
```
On running the above command, node will be initialized with default configuration. (config files will be saved in node's default home directory (~/.omniflixhub/config)

NOTE: Backup node and validator keys . You will need to use these keys at a later point in time.

## 6) Create Account keys 
if you have participated in previous testnet and have mnemonic phrase, use below command to recover your account
```
omniflixhubd keys add <key-name> --recover
```
to create new account
```
omniflixhubd keys add <key-name>
```

NOTE: Save `mnemonic` and related account details (public key). You will need to use the need mnemonic/private key to recover accounts at a later point in time.

## 7) Add Genesis Account

```
omniflixhubd add-genesis-account <key-name> 50000000uflix
```

## 8) Create Your `gentx`

```
omniflixhubd gentx <key-name> 50000000uflix \
  --pubkey=$(omniflixhubd tendermint show-validator) \
  --chain-id="flixnet-2" \
  --moniker="my-moniker" \
  --website="https://yourweb.site" \
  --details="description of my validator" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" 
```    

Note:

- `<key-name>` and `chain-id` are required. other flags are optional
- Don't change amount value while creating your gentx 
- Genesis transaction file will be saved in `~/.omniflixhub/config/gentx` folder

## 9) Submit Your gentx

Submit your `gentx` file to the [OmniFlix/testnets](https://github.com/OmniFlix/testnets) in the format of 
`<validator-moniker>-gentx.json`

NOTE: (Do NOT use space in the file name) 

To submit the gentx file, follow the below process:
 
 - Fork the [Omniflix/testnets](https://github.com/Omniflix/testnets) repository
 - Upload your gentx file in `flixnet-2/gentxs` folder
 - Submit Pull Request to [OmniFlix/testnets](https://github.com/OmniFlix/testnets) with name `ADD <your-moniker> gentx`

---

**Execute below instructions only after publishing of final genesis file**

genesis file will be published to [Omniflix/testnets/flixnet-2](https://github.com/Omniflix/testnets)




# B) Starting the validator
NOTE: Below instructions are required to perform only after publishing of flixnet-2 genesis file


## 1) Download Final Genesis
Use `curl` to download the genesis file from [Omniflix/testnets](https://github.com/Omniflix/testnets) repository.

```
curl https://raw.githubusercontent.com/OmniFlix/testnets/main/flixnet-2/genesis.json > ~/.omniflixhub/config/genesis.json
```
Verify sha256 hash of genesis file with the below command
```
jq -S -c -M '' ~/.omniflixhub/config/genesis.json | shasum -a 256
```
genesis sha256 hash should be 
```
3287e021470ece9ac6d79bcc0f322fb496dcd27c3cd41e9064e8fbb7c318b68b
```

## 2) Update Peers & Seeds in config.toml

```
seeds="cdd6f704a2ecb6b9e53a9b753c894c95976e5cbe@45.72.100.121:26656,b0679b09bb72dfc29c332b5ea754cd578d106a49@45.72.100.122:26656"
peers="65e362590690cedcddf5c7f4fc1b67c9d7b04fb2@45.72.100.118:26656,368a9a2b5096de253aaae302ff15a0a77fe06416@45.72.100.119:26656,cf8a7600b3daf23e9a3ce67ebe50c4af44701aa8@45.72.100.123:26656,93433a8c325d5ed5d2484d7fd23cda3dac511392@45.72.100.124:26656"

sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.omniflixhub/config/config.toml
```

## 3) Start the Node
#### 3.1) Start node as `systemctl` service

3.1.1) Create the service file
Note: this step is not required if you did setup before

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
