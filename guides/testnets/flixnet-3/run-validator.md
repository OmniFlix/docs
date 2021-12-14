### Create Validator Post Genesis

1. Run Full Node
2. Create Account and Get test tokens
3. Create Validator


### 1.Run Full Node
  - Check "[Run Full Node](https://github.com/OmniFlix/docs/blob/main/guides/testnets/flixnet-3/run-full-node.md)" section to Run a Full Node

### 2. Create Account & Get test tokens 
To restore existing account from mnemonic phrase 
```
omniflixhubd keys add <key-name> --recover
```

To create new account
```
omniflixhubd keys add <key-name>
```

NOTE: Save `mnemonic` and related account details (public key). You will need to use the need mnemonic/private key to recover accounts at a later point in time.
##### Get Test tokens from faucet
 - TBU 
 
### 3.Create Validator
 - ##### Check full node sync status
     
     `omniflixhubd status  | jq -r ".SyncInfo"` 

   `catching_up: false` means node is completely synced
 - ##### Create validator 
 `Note:`  Only execute below transaction after complete sync of your full node

```
omniflixhubd tx staking create-validator \
  --amount=1000000uflix \
  --pubkey=$(omniflixhubd tendermint show-validator) \
  --moniker="my-moniker" \
  --website="https://myweb.site" \
  --details="description of your validator" \
  --chain-id="flixnet-3" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --gas="auto" \
  --gas-adjustment="1.2" \
  --gas-prices="0.001uflix" \
  --from=<key_name>
```
