# NFTs Minting & Listing on OmniFlix Hub Chain


## Overview
1. Requirements
2. Download and Install OmniFlix Hub binary (`omniflixhubd`)
3. Setup Wallet
4. Get Tokens or FeeGrant 
5. Create Collection
6. Mint oNFT
7. List oNFT on Marketplace
8. Conclusion


### 1. Requirements
  - Linux Operating System (ubuntu 20.04) 
  - Git
  - go 1.17+ ([check here](https://hackmd.io/_CNC1LyESk6Rd3fxacNB0w))
  - RPC endpoint (for tx broadcasting) 
     - https://rpc.omniflix.network:443

### 2. Download & Install OmniFlix Hub
  
 - install required software packages
     ```
    sudo apt-get install git wget build-essential make jq -y
    ```
 - Clone omniflixhub repo and install 
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
 - check version
 ```
 omniflixhubd version
 ```

             (or)
 
  Download binary for linux-amd64 architecture from github release
 ```
 wget https://github.com/OmniFlix/omniflixhub/releases/download/v0.4.0/omniflixhubd -O omniflixhubd

 chmod +x omniflixhubd

 sudo mv omniflixhubd /usr/local/bin/

 omniflixhubd version
```

### 3. Setup Wallet

- Recover your old account using mnemonic
    
```
    omniflixhubd keys add <key-name> --recover
```
- Create new account
```
    omniflixhubd keys add <key-name>
```


NOTE: Save `mnemonic` and related account details. You will need to use the need mnemonic/private key to recover accounts at a later point in time.

- Check keys list
  ```
  omniflixhubd keys list
  ```

### 4. Get Tokens or FeeGrant
  To execute transactions on chain we need fees
  1. Get some tokens (or)
     check balance: https://rest.omniflix.network/bank/balances/{address}
  2. Receive FeeGrant from other account
     check allowance: https://rest.omniflix.network/cosmos/feegrant/v1beta1/allowances/{address} 
  
  
  
### 5. Create Denom (Collection)
  #### Params:
   - **Symbol** - Collection Symbol (short Name/ID)
  #### Flags:
   - **name** - Name of the collection
   - **description** - Collection description
   - **schema** - Json schema for collection (will be used to add additional data for nfts while minting)
   - **preview-uri** - Collection display/profile picture

  **Example Tx**:  
  Replace below values with yours
  ```
  Symbol="DCA"
  Name="Digital Color Arts"
  Description="This collection contains beautiful digital arts"
  Schema=""
  KeyName="mykey"
  Preview="https://ipfs.omniflix.studio/ipfs/QmZLPTGBi3LwXFacAvfCNsUUSNbPfwh9NrufXeSxh9dNzp"
  ```
  
```
omniflixhubd tx onft create $Symbol \
 --name="$Name" \
 --description="$Description" \
 --preview-uri="$Preview" \
 --schema="$Schema" \
 --chain-id=omniflixhub-1 \
 --node=https://rpc.omniflix.network:443 \
 --fees=200uflix \
 --from="$KeyName" 
```
Use `--fee-account <feegranter-address>` flag if you have feegrant available

  **Check your denoms/collections:**
   - https://rest.omniflix.network/omniflix/onft/v1beta1/denoms?owner={your-address} 


### 6. Mint oNFT
  #### Params:
   - **DenomID** - id of the denom (or collection)
  
  #### Flags:
  - **name** : name of denom/collection (string)
  - **description**: description of the denom (string)
  - **media-uri**: ipfs uri of the nft (url)
  - **preview-uri**: preview uri of the nft (url)
  - **data**: additional nft properties (json string)
  - **recipient**: recipient of the nft (optional, default: minter of the nft)
  - **non-transferable**:  to mint non-transferable nft (optional, default: false)
  - **inextensible** : to mint inextensible nft (optional, default false)
  - **nsfw**: not safe for work flag for the nft (optional, default: false)  
 - **royalty-share**: royalty share for nft (optional, default: 0.00)

  **Example Tx**:  
  Replace below values with yours
  ```
  DenomID="onftdenom..."
  Name="First NFT"
  Description="This is First NFT"
  MediaURI="https://ipfs.omniflix.studio/ipfs/QmZLPTGBi3LwXFacAvfCNsUUSNbPfwh9NrufXeSxh9dNzp"
  PreviewURI="https://ipfs.omniflix.studio/ipfs/QmZLPTGBi3LwXFacAvfCNsUUSNbPfwh9NrufXeSxh9dNzp"
  Data=""  
  RoyaltyShare="0.01" # 1%
  KeyName="mykey"
  ```
  
```
omniflixhubd tx onft mint $DenomID \
    --name="$Name" \ 
    --description="$Description" \ 
    --media-uri="$MediaURI"  \
    --preview-uri="$PreviewURI" \ 
    --data=""$Data"   \
    --chain-id=omniflixhub-1 \
    --fees=200uflix \
    --from="$KeyName" 
```
For Royalty share
    ```
    --royalty-share="$RoyaltyShare"
    ```
    
Aditional optional flags
    ```
     --non-transferable
     --inextensible
     --nsfw
    ```

Use `--fee-account <feegranter-address>` flag if you have feegrant available

### 7. List oNFT on Marketplace
Replace below values with yours
```
    DenomID="onftdenom..."    
    NftID="onft..."
    Price="100000000uflix" # 100 FLIX
    KeyName="mykey"
```
   If you want to list with IBC tokens check token details here
     https://api.omniflix.studio/tokens
     
    replace uflix with respective ibc denom
    
    ex for ATOM: `ibc/27394FB092D2ECCD56123C74F36E4C1F926001CEADA9CA97EA622B25F41E5EB2`
    
  ```
    omniflixhubd tx marketplace list-nft \
      --nft-id="$NftID" \
      --denom-id="$DenomID" \
      --price=10000000uflix \
      --chain-id=omniflixhub-1 \
      --node="https://rpc.omniflix.network:443" \
      --fees=200uflix \
      --from="$KeyName" 
  ```
   - For splitting sale amount between multiple accounts use `split-shares`
   ```
   --split-shares="address:percentage,address:percentage"
   ```
   Example:
   ```
  --split-shares "omniflix1e49p22vz8w5nyer77gl0nhs2puumu3jdel822w:0.70,omniflix1muyp5qvz7e6qd8wkpxex0h963um962qcd777ez:0.30"
   ```
   
   Use `--fee-account <feegranter-address>` flag if you have feegrant available
   
   - Check your listings
   https://rest.omniflix.network/omniflix/marketplace/v1beta1/listings?owner={address}
    
### 8. Conclusion

   Now you have learned minting and listing NFTs on OmniFlix
