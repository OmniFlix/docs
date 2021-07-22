# Setting Up a Genesis Validator for OmniFlix Testnet (flixnet-1)

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
  

Setup 
---
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
check installed go version
`go version`
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
verify your installation
```
omniflixhubd version --long
```
should see similar response like this.. make sure version and commit hash are correct
  ```
 name: OmniFlixHub
server_name: omniflixhubd
version: 0.1.0
commit: 95e2aebaf02406bdcc78f9268380528bd1a25617
```
### Initialize Node
```
omniflixhubd init <your-node-moniker> --chain-id flixnet-1 
```
Above command will initialize node with default configuration (config files will be saved at  ~/.omniflixhub/config)

Backup your node and validator keys. you may need these keys in later phases

### Create Account keys 
```
omniflixhubd keys add <key-name>
```
save mnemonic and account details . we need mnemonic/private key to recover accounts 

### Add Genesis Account
```
omniflixhubd add-genesis-account <key-name> 50000000uflix
```
### Create Your GenTx
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
`<key-name>` and `chain-id` are required. other flags are optional

Note: Don't change amount value in above command 

genesis tx will be saved in `~/.omniflixhub/config/gentx` folder

### Submit Your GenTx
submit your gentx file to [Omniflix/testnets](https://github.com/Omniflix/testnets) repository in the format `<validator-moniker>-gentx.json` (don\'t use spaces in file names) 


 To submit gentx
 
   - Fork [Omniflix/testnets](https://github.com/Omniflix/testnets) repository
   - Upload your gentx file in `flixnet-1/gentxs` folder with file name format as {moniker}-gentx.json
   - Submit Pull request to [Omniflix/testnets](https://github.com/Omniflix/testnets) with name `ADD <your-moniker> GenTx`

---



**Execute below instructions only after publish of final genesis**

genesis file will be published to [Omniflix/testnets/flixnet-1](https://github.com/Omniflix/testnets)  

 #### Download Genesis 
 ```
 TBU
 ```

#### Start Validator
 ```
TBU
```

