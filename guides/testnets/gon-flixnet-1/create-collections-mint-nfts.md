


## CLI Commands to Query Collections/NFTs, Create Collections & Mint NFTs

### Queries
  - #### Get List of denoms (collections)
    ```bash
    omniflixhubd query onft denoms
    ```
  - #### Get Denom details by it's Id
     ```bash
    omniflixhubd query onft denom <denom-id>
    ```    
  - #### Get List of NFTs in a collection
    ```bash
    omniflixhubd query onft collection <denom-id>
    ```
  - #### Get Total Count of NFTs in a collection
    ```bash
    omniflixhubd query onft supply <denom-id>
    ```
  - #### Get NFT details by it's Id
    ```bash
    omniflixhubd query onft asset <denom-id> <nft-id>
    ```
  - #### Get All NFTs owned by an address
    ```bash
    omniflixhubd query onft owner <account-address>
    ```
    
### Transactions
  - #### Create Denom / Collection
    Usage
    ```bash
    omniflixhubd tx onft create [symbol] [flags] 
    ```
    
    Flags:
      - **name** : name of denom/collection
      - **description**: description for the denom
      - **preview-uri**: display picture url for denom
      - **schema**: json schema for additional properties
      - **uri**: denom uri (reference to class uri)
      - **uri-hash**: denom uri hash
      - **data**: additional data for the denom
      
    Example:
    ```bash
    onftd tx onft create <symbol>  
     --name=<name>
     --description=<description>
     --preview-uri=<preview-uri>
     --schema=<schema>
     --uri=<denom-uri>
     --uri-hash=<denom-uri-hash>
     --chain-id=<chain-id>
     --fees=<fee>
     --from=<key-name>
    ```
  - #### Mint NFT
    Usage
    ```bash
    omniflixhubd tx onft mint [denom-id] [flags]
    ```
    
    Flags:
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
      - **uri-hash**: uri hash of the nft
      
    Example:
    ```bash
    omniflixhubd  tx onft mint <denom-id>
     --name=<name>
     --description=<description>
     --media-uri=<preview-uri>
     --preview-uri=<preview-uri>
     --data=<additional nft data json string>
     --uri-hash=<uri hash of the nft>
     --recipient=<recipient-account-address>
     --chain-id=<chain-id>
     --fees=<fee>
     --from=<key-name>
      ```
    ```bash
    omniflixhubd  tx onft mint <denom-id>
    --name="NFT name" 
    --description="NFT description" 
    --media-uri="https://ipfs.io/ipfs/...." 
    --preview-uri="https://ipfs.io/ipfs/...." 
    --data="" 
    --uri-hash="urihash"
    --recipient="" 
    --non-transferable 
    --inextensible 
    --nsfw 
    --chain-id=<chain-id>
    --fees=<fee>
    --from=<key-name>
      ```
    For Royalty share
    ```bash
    --royalty-share="0.05" # 5% 
    ```
  - #### Transfer NFT
    Usage
    ```bash
    omniflixhubd tx onft transfer [recipient] [denom-id] [onft-id] [flags]
    ```
    
    Example:
    ```bash
    omniflixhubd  tx onft transfer <recipient> <denom-id> <nft-id>
     --chain-id=<chain-id>
     --fees=<fee>
     --from=<key-name>
    ```

  - #### Burn NFT
    Usage
    ```bash
    omniflixhubd tx onft burn [denom-id] [onft-id] [flags]
    ```
    
    Example:
    ```bash
    onftd  tx onft burn <denom-id> <nft-id>
     --chain-id=<chain-id>
     --fees=<fee>
     --from=<key-name>
    ```
