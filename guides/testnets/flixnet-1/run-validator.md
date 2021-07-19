### Create Validator Post Genesis

1. Create Full Node
2. Become Validator

##### Create Full Node
 see run-full-node.md

#### Create Validator


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

To  check sync status use below instruction

`omniflixhubd status 2>&1 | jq -r ".SyncInfo"` 

`catching_up: false` means node is completely synced


