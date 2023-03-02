# Game of NFTs Testing

## Overview
  - [Install omniflixhubd](#install-omniflixhubd)
  - [Create Wallet](#create-wallet)
  - [Create Collection](#create-collection)
  - [Query Collection](#query-collection)
  - [Query NFTs](#query-nfts)
  - [Transfer NFT to Different Chain](#transfer-nft-to-different-chain)
  - [Query NFT on destination chain](#query-nft-on-destination-chain)
  

## Install omniflixhubd

#### 1) Install Golang (go)

1.1) Remove any existing installation of `go`

```
sudo rm -rf /usr/local/go
```

1.2) Install latest/required Go version (installing `go1.19`)

```
curl https://dl.google.com/go/go1.19.5.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
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

#### 2) Install required software packages

```
sudo apt-get install git curl build-essential make jq -y
```

#### 3) Install `omniflixhub` from source

```
# clone repo if not cloned previously 
git clone https://github.com/Omniflix/omniflixhub.git

# install latest version 
cd omniflixhub
git fetch --all
git checkout v0.9.0-gon-test2 # or can use omniflix-gon branch directly
go mod tidy
make install
```

#### 4) Verify your installation
```
omniflixhubd version --long
```

On running the above command, you should see a similar response like this. Make sure that the *version* and *commit hash* are accurate

```
name: OmniFlixHub
server_name: omniflixhubd
version: 0.9.0-gon-test2
commit: ee20e3f40112609eae373ffd04fdf5bc17b36589
```
---

## Create Wallet
To restore existing account from mnemonic phrase 
```
omniflixhubd keys add omniflix-account --recover
```

To create new account
```
omniflixhubd keys add omniflix-account
```

NOTE: Save `mnemonic` and related account details (public key). You may need to use the need mnemonic/private key to recover accounts at a later point in time.
##### Get Test tokens from faucet
   - Get test tokens from https://faucet.ping.pub
##### Query balance
   ```bash
    omniflixhubd q bank balances [address] --node "https://rpc.gon-flixnet.omniflix.io:443"
   ```

## Create Collection
- #### Create Denom / Collection
     update below values with your collection details
    ```bash
     NAME="collection-test"
     SYMBOL="collection-test"
     PREVIEW_URI="ipfs://ipfs-hash"
     URI="ipfs://ipfs-hash"
     URI_HASH="ipfs-hash"
     SCHEMA="{}"
     DATA="{\"label\": \"test collection\"}" # JSON String
     DESCRIPTION="this is the description of the collection"
     KEY="omniflix-account" # name of your omniflixhubd wallet
     ```
     
     ```bash
     omniflixhubd tx onft create $SYMBOL --name="${NAME}" \
     --description="${DESCRIPTION}" \
     --preview-uri="${PREVIEW_URI}" \
     --schema="${SCHEMA}" \
     --uri="${URI}" \
     --uri-hash="${URI_HASH}" \
     --data="${DATA}" \
     --chain-id=gon-flixnet-1 \
     --fees=500uflix \
     --from="${KEY}" \
     --node="https://rpc.gon-flixnet.omniflix.io:443" \
     --broadcast-mode=block
    ```
## Query Collection
  Get the collection id from above transaction (starts with `onftdenom`)
  ```bash
  omniflixhubd q onft collection [collection-id] --node "https://rpc.gon-flixnet.omniflix.io:443"
  ```
  you can also query collections by your account address
  ```bash
  omniflixhubd q onft denoms --owner omniflix1... --node "https://rpc.gon-flixnet.omniflix.io:443"
  ```

## Mint NFTs
    Update below values with your NFT details
   ```bash
    COLLECTION_ID="onftdenom123xyz.."  # collection ID from above transaction
    NAME="Test NFT #1"
    DESCRIPTION="This is test nft 1"
    MEDIA_URI="ipfs://ipfs-hash"
    PREVIEW_URI="ipfs://ipfs-hash"    
    DATA="{\"id\":\"test-001\"}"      # additional data for the nft
    URI_HASH="ipfs-hash"
    RECIPIENT="omniflix1xyz.."           # NFT will be minted to this account
    KEY="omniflix-account"            # modify with collection creator account name
   ```
    
   After exporting above values execute below command
    
   ```bash
    omniflixhubd  tx onft mint $COLLECTION_ID \
    --name="${NAME}" \
    --description="${DESCRIPTION}" \
    --media-uri="${MEDIA_URI}" \
    --preview-uri="${PREVIEW_URI}" \
    --data="${DATA}" \
    --uri-hash="${URI_HASH}" \
    --recipient="${RECIPIENT}" \
    --chain-id=gon-flixnet-1 \
    --fees=500uflix \
    --from="${KEY}" \
    --node="https://rpc.gon-flixnet.omniflix.io:443" \
    --broadcast-mode=block
   ```
   
## Query NFTs
  can query nfts using [Collection](## Query Collection)
  For quering nft in a collection use below command
  ```bash
  NFT_ID="onft123xyz.."     # get onft ID from above transaction 
  ```
  query nft
  ```bash
  omniflixhubd q onft asset $COLLECTION_ID $NFT_ID --node "https://rpc.gon-flixnet.omniflix.io:443"
  ```


## Transfer NFT to Different Chain
Identify the channel for destination chain 
[ports/channels table](https://github.com/game-of-nfts/gon-testnets/blob/main/doc/port-channel-table.md)

**IRISnet<>Omniflix** `nft-transfer/channel-0` <> `nft-transfer/channel-24`
```bash
IRIS_ACCOUNT="iaa1..."              # modify with your iris account here
CHANNEL_ID="channel-24"             # channel to irishub testnet
COLLECTION_ID="onftdenom123xyz.."   # modify with your collection id here
NFT_ID="onft123xyz..."              # modify with NFT ID you are trasferrring to another chain
```
Execute below command to transfer nft to another chain
```bash
 omniflixhubd tx nft-transfer transfer nft-transfer $CHANNEL_ID $IRIS_ACCOUNT $COLLECTION_ID $NFT_ID \
 --chain-id=gon-flixnet-1 \
 --fees=500uflix \
 --from "${KEY}" \
 --node="https://rpc.gon-flixnet.omniflx.io:443" \
 --broadcast-mode=block
```

## Query NFT on destination chain
```bash
CLASS_TRACE="nft-transfer/$CHANNEL_ID/$COLLECTION_ID"
```
query Collection ID of the sent NFT in destination chain
```bash
iris q nft-transfer class-hash $CLASS_TRACE --node "https://rpc-gon-irishub.omniflix.io:443"
```
you will recieve a HASH if nft is transferred successfully

Query collection using above HASH

```bash
iris q nft collection ibc/{HASH} --node "https://rpc-gon-irishub.omniflix.io:443"
```

