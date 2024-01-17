# `Testnet v2-testnet-patch-1 Upgrade `

**Name**: `v2-testnet-patch-1`

**When**: The upgrade is scheduled for block [10580000](https://testnet.ping.pub/omniflix/block/10580000). (approximately 14:00 UTC, Jan 18th 2023)

**Details** :
- cosmos-sdk v0.47.5
- cometbft v0.37.2
- ibc-go v7.3.1
- nft-transfer v1.1.3-ibc-v7.3.0
- streampay v2.2.0


### Hardware Requirements
- CPU: 4 cores
- RAM: 24GB 

### Go version

go v1.21.3+

### 1. Manual Method
Wait for Omniflixhub to reach the upgrade height (`10580000`)

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
git checkout v2.0.0-testnet.1
make install
```
Check Version
```
omniflixhubd version --long
```
output should be
```
commit: dd6c6acdf25e294b743f5880df54002f86ce9683
cosmos_sdk_version: v0.47.5
go: go version go1.21.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v2.0.0-testnet.1
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
git checkout v2.0.0-testnet.1
make build && make install

# check the version - should be v2.0.0-testnet.1
$HOME/go/bin/omniflixhubd version --long
commit: dd6c6acdf25e294b743f5880df54002f86ce9683
cosmos_sdk_version: v0.47.5
go: go version go1.21.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v2.0.0-testnet.1

# make a dir if you haven't
mkdir -p $HOME/.omniflixhub/cosmovisor/upgrades/v2-testnet-patch-1/bin

# if you are using cosmovisor you then need to copy this new binary
cp $HOME/go/bin/omniflixhubd $HOME/.omniflixhub/cosmovisor/upgrades/v2-testnet-patch-1/bin

# check new version you are about to run - should be equal to v2.0.0-testnet.1
$HOME/.omniflixhub/cosmovisor/upgrades/v2-testnet-patch-1/bin/omniflixhubd version
