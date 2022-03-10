## Follow below steps to mint NFTs

### 1. Install `omniflixhubd` 
- check below url to install and setup omniflixhubd binary
    https://github.com/OmniFlix/docs/blob/main/guides/mainnet/omniflixhub-1/mint-list-nfts.md#2-download--install-omniflix-hub

### 2. Create / Add your wallet 

- Create

     `omniflixhubd keys add alice --keyring-backend test`

- Restore

     `omniflixhubd keyys add alice --recover --keyring-backend test`

### 3. Install python3

   sudo apt-get install python3 && python3-pip

### 4. Update script variables 
    
   - set collection_id
      update `collection_id` with your colllection id
     `collection_id = 'onftdenom...'`
      
- update nfts json file path
     `json_file = '/path/to/file'`

- update account key name
      account_key_name = 'alice' # change this with your key name

- set fees, fee_account 
      add your feegranter address and fees
      
     omniflix feegranter addess 
     `--fee-account=omniflix1q3jnku877fwn9xe8d7a9vsgs29jld4wkpy3lmg`
     
     can use `200uflix` or `500uflix` as fees

### 5. Start script
- start a screen session
     
    `screen -Rd mint-script`

- run script
      
    `python3 mint_nfts.py`
      
    check logs to know nfts minting or not
 
    use `CNTRL + A + D` to detach from screen  
    you can attach to screen again with below command
     
     `screen -rd mint-script`



