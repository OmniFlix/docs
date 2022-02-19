# Submit GenTx for OmniFlix Mainnet (omniflixhub-1)

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

1.2) Install latest/required Go version (installing `go1.17.5`)

```
curl https://dl.google.com/go/go1.17.5.linux-amd64.tar.gz | sudo tar -C /usr/local -zxvf -
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
sudo apt-get install git build-essential make jq -y
```

## 3) Install `omniflixhub`

```
git clone https://github.com/Omniflix/omniflixhub.git
cd omniflixhub
git fetch --all
git checkout v0.4.0
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
version: 0.4.0
commit: 43e65a64a878b2efa0a51ed29aa8e631f4b5b8bc
```

## 5) Initialize Node

```
omniflixhubd init <your-node-moniker> --chain-id omniflixhub-1
```

## 6) Create Account keys 
use below command to recover your account
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
omniflixhubd add-genesis-account <key-name> 10000000uflix
```

## 8) Create Your `gentx`

```
omniflixhubd gentx <key-name> 10000000uflix \
  --pubkey=$(omniflixhubd tendermint show-validator) \
  --chain-id="omniflixhub-1" \
  --moniker="validator-name" \
  --website="https://yourweb.site" \
  --details="description of validator" \
  --commission-rate="0.05" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" 
```    


## 9) Submit Your gentx

Submit your `gentx` file to the [OmniFlix/mainnet](https://github.com/OmniFlix/mainnet) in the format of 
`<validator-moniker>-gentx.json`

NOTE: (Do NOT use space in the file name) 

To submit the gentx file, follow the below process:
 
 - Fork the [Omniflix/mainnet](https://github.com/Omniflix/mainnet) repository
 - Upload your gentx file in `omniflixhub-1/gentxs` folder
 - Submit Pull Request to [OmniFlix/mainnet](https://github.com/OmniFlix/mainnet) with name `ADD <your-moniker> gentx`

---


NOTE: **Only selected mainnet validator PRs will be accepted**

genesis file will be published to [Omniflix/mainnet/omniflixhub-1](https://github.com/Omniflix/mainnet)

