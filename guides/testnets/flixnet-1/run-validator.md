### Create Validator Post Genesis

1. Run Full Node
2. Create Validator
3. Sync blocks

#### 1.Run Full Node
  - Check "[Run Full Node](https://github.com/OmniFlix/docs/blob/main/guides/testnets/flixnet-1/run-full-node.md)" section to Run a Full Node

#### Create Account Keys 
```
omniflixhubd keys add <key-name>
```

NOTE: Save `mnemonic` and related account details (public key). You will need to use the need mnemonic/private key to recover accounts at a later point in time.
#### Get Test tokens from faucet
 - TBU 
 
#### 2.Create Validator


```
omniflixhubd tx staking create-validator \
  --amount=1000000uflix \
  --pubkey=$(omniflixhubd tendermint show-validator) \
  --moniker="<validator-moniker>" \
  --website="https://yourweb.site" \
  --details="description of your validator" \
  --identity="<your-keybase-identity>" \
  --chain-id=<chain_id> \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --gas="auto" \
  --gas-adjustment="1.2" \
  --gas-prices="0.025uflix" \
  --from=<key_name>
```
`Note:`  Only execute above transaction after complete sync of your full node

#### 3.Sync blocks

To  check sync status use below instruction

`omniflixhubd status 2>&1 | jq -r ".SyncInfo"` 

`catching_up: false` means node is completely synced


