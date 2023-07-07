## Official IBC Channels for the OmniFlix Hub

Below is a list of IBC channels setup for the OmniFlix Hub.

| source chain-id  | source channel  | destination chain | destination chain-id  | destination channel | comments |
| -----------------| --------------- | --------------------- | ------------------ | ------------------ | --------------------- |
| omniflixhub-1 | channel-1 | Osmosis | osmosis-1 | channel-199 | No change |
| omniflixhub-1 | channel-4 | Terra | columbus-5 | channel-27 | No change |
| omniflixhub-1 | channel-5 | Chihuahua| chihuahua-1 | channel-17 | No change |
| omniflixhub-1 | channel-8 |  Stargaze | stargaze-1 | channel-36 | No change |
| omniflixhub-1 | channel-12 |  Cosmos Hub | cosmoshub-4 | channel-306 | Updated from `ch-0` on OmniFlix and `ch-290` on the Cosmos Hub |
| omniflixhub-1 | channel-14 | Gravity Bridge | gravity-bridge-3 | channel-51 | Updated from `ch-3` on OmniFlix and `ch-35` on the Gravity Bridge |
| omniflixhub-1 | channel-15 | Sifchain | sifchain-1 | channel-49 | Updated from `ch-6` on OmniFlix and `ch-44` on the Sifchain |
| omniflixhub-1 | channel-16 |  Akash Net | akashnet-2 | channel-42 | Updated from `ch-7` on OmniFlix and `ch-39` on the Akash Network |
| omniflixhub-1 | channel-17 |  Ki Chain | kichain-2 | channel-13 | Updated from `ch-9` on OmniFlix and `ch-10` on the Ki Chain |
| omniflixhub-1 | channel-18 |  Sentinel Hub | sentinelhub-2 | channel-54 | Updated from `ch-10` on OmniFlix and `ch-53` on the Sentinel Hub |
| omniflixhub-1 | channel-19 |  Crypto.org / Cronos | crypto-org-chain-mainnet-1 | channel-55 | Updated from `ch-11` on OmniFlix and `ch-54` on the the Crypto.com chain |
| omniflixhub-1 | channel-20 | Juno Network | juno-1 | channel-78 | Updated from `ch-13` on OmniFlix and `ch-74` on the Juno Network. Before these, the channels were `ch-2` on OmniFlix and `ch-63` on the Juno Network |
| omniflixhub-1 | channel-27 | Axelar | axelar-dojo-1 | channel-77 | New Channel |
| omniflixhub-1 | channel-29 | Agoric | agoric-3 | channel-54 | New Channel |

## Credits
The above table, as of 9-Apr-2022, is an extract from the Hermes setup guide for OmniFlix Hub by [@clemensgg](https://github.com/clemensgg/RELAYER-dev-crew/blob/main/HERMES/omniflix/relayer-doc.md) and will be updated going forward. [Notional DAO](https://twitter.com/@notionaldao) and [Crypto Crew Validators](https://twitter.com/crypto_crew) have been highly instrumental in setting up the entire Relayer and IBC infrastructure around OmniFlix along with the feegrant module that piqued interest from around the ecosystem.
