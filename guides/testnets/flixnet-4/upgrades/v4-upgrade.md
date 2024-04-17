# `Testnet v4 Upgrade `

**Name**: `v4`

**When**: The upgrade is scheduled for block [11942400](https://testnet.ping.pub/omniflix/block/11942400). (approximately 14:00 UTC, Apr 18th 2024)

**Details** :
- cosmos-sdk v0.47.10
- ibc-hooks v7

**Fixes**
- wasm: ibc channels creation with wasm contracts
- itc: nft minting title format
- marketplace: auction whitelist limit restriction fixes

### Hardware Requirements
- CPU: 4 cores
- RAM: **recommended** 32GB

### Go version

go v1.21.3+

### 1. Manual Method
Wait for flixnet-4 to reach the upgrade height (`11942400`)

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
git checkout v4.0.0-alpha.1
make install
```
Check Version
```
omniflixhubd version --long
```
output should be
```
commit: aa0c729bb4e82bc007207016feb73a2e6f80dc34
cosmos_sdk_version: v0.47.10
go: go version go1.21.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v4.0.0-alpha.1
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
git checkout v4.0.0-alpha.1
make build && make install

# check the version - should be v4.0.0-alpha.1
$HOME/go/bin/omniflixhubd version --long
commit: aa0c729bb4e82bc007207016feb73a2e6f80dc34
cosmos_sdk_version: v0.47.10
go: go version go1.21.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v4.0.0-alpha.1

# make a dir if you haven't
mkdir -p $HOME/.omniflixhub/cosmovisor/upgrades/v4/bin

# if you are using cosmovisor you then need to copy this new binary
cp $HOME/go/bin/omniflixhubd $HOME/.omniflixhub/cosmovisor/upgrades/v4/bin

# check new version you are about to run - should be equal to v4.0.0-alpha.1
$HOME/.omniflixhub/cosmovisor/upgrades/v4/bin/omniflixhubd version
