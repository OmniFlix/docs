# `Mainnet v4 Software Upgrade `

**Name**: `v4`

**When**: The upgrade is scheduled for block [11914000](https://mintscan.io/omniflix/block/11914000). (approximately at - `May 2nd 2024 13:30 - 14:00 UTC`)

**Details** :
- **version updates**
  - cosmos-sdk v0.47.10
- **New Modules**
  - ibc-hooks (v7)
- **Fixes & Improvements**
   - ibc-go patch (v7.4.0)
   - Channel creation from cosmwasm contracts
   - NFT mint naming style and index selection for itc campaign
   - Increased whitelist accounts for auctions
     
### Go version
go v1.21.3+

### 1. Manual Method
Wait for Omniflixhub to reach the upgrade height (`11914000`)

Look for a panic message, followed by endless peer logs. Stop the daemon
```
sudo systemctl stop omniflixhubd.service
```

Install go v1.21.3+
```
# Remove previous installation
sudo rm -rf /usr/local/go

# Install correct Go version
curl https://dl.google.com/go/go1.21.3.linux-amd64.tar.gz | sudo tar -C /usr/local -zxvf -

# Check version
go version
```

Run the following commands:

```
cd $HOME/omniflixhub
git fetch --all
git checkout v4.0.0
make install
```
Check Version
```
omniflixhubd version --long
```
output should be
```
commit: 5c34921deef25edb7e8fdaaacc7e217d91135a83
cosmos_sdk_version: v0.47.10
go: go version go1.21.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v4.0.0
```
Restart the omniflixhubd service

```
sudo systemctl start omniflixhubd.service
```

### 2. Cosmovisior Method
#### Install and setup cosmovisor if you haven't running with cosmovisor

  [cosmovisor-setup.md](https://github.com/OmniFlix/docs/blob/main/guides/mainnet/omniflixhub-1/cosmovisor-setup.md)


#### Build and Copy Binary

```bash
git checkout main && git pull
git checkout v4.0.0
make build && make install

# check the version - should be v4.0.0
$HOME/go/bin/omniflixhubd version --long
commit: 5c34921deef25edb7e8fdaaacc7e217d91135a83
cosmos_sdk_version: v0.47.10
go: go version go1.21.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v4.0.0

# make a dir if you haven't
mkdir -p $HOME/.omniflixhub/cosmovisor/upgrades/v4/bin

# if you are using cosmovisor you then need to copy this new binary
cp $HOME/go/bin/omniflixhubd $HOME/.omniflixhub/cosmovisor/upgrades/v4/bin

# check new version you are about to run - should be equal to v4.0.0
$HOME/.omniflixhub/cosmovisor/upgrades/v4/bin/omniflixhubd version
