# Setting up a Genesis Validator for OmniFlix Testnet (flixnet-1)

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
curl https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz | sudo tar -C /usr/local -zxvf -
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
git checkout v0.1.0
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
version: 0.1.0
commit: 95e2aebaf02406bdcc78f9268380528bd1a25617
```

## 5) Initialize Node

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

## 7) Add Genesis Account

```
omniflixhubd add-genesis-account <key-name> 50000000uflix
```

## 8) Create Your `gentx`

```
omniflixhubd gentx <key-name> 50000000uflix \
  --pubkey=$(omniflixhubd tendermint show-validator) \
  --chain-id="flixnet-1" \
  --moniker=<validator-moniker> \
  --website="https://yourweb.site" \
  --details="description of your validator" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --identity="<your-keybase-identity>" 
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
 - Upload your gentx file in `flixnet-1/gentxs` folder
 - Submit Pull Request to [OmniFlix/testnets](https://github.com/OmniFlix/testnets) with name `ADD <your-moniker> gentx`

---

**Execute below instructions only after publishing of final genesis file**

genesis file will be published to [Omniflix/testnets/flixnet-1](https://github.com/Omniflix/testnets)




# B) Starting the validator

## 1) Download Final Genesis
download genis file from [Omniflix/testnets](https://github.com/Omniflix/testnets) repository

TBU

## 2) Peers & Seeds

TBU

## 3) Start the Node

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
