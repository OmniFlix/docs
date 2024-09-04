# `Testnet v5 Upgrade `

**Name**: `v5`

**When**: The upgrade is scheduled for block [14077000](https://testnet.ping.pub/omniflix/block/14077000). (approximately 14:00 UTC, Sep 5th 2024)

**Details** :
- cosmos-sdk v0.50.9
- ibc-go v8.4.0
- cosmwasm v2.1.2
- circuit v0.1.1

**Fixes**
- wasm: wasm statesync snapshot fix
- onft: validation fixes


### Hardware Requirements
- CPU: 4 cores (physical)
- RAM: **recommended** 32GB

### Go version

go v1.22.5+

### 1. Manual Method
Wait for flixnet-4 to reach the upgrade height (`14077000`)

Look for a panic message, followed by endless peer logs. Stop the daemon
```
sudo systemctl stop omniflixhubd.service
```

Install go v1.22.5+
```
# Remove previous installation
sudo rm -rf /usr/local/go
wget -q -O - https://git.io/vQhTU | bash -s -- --remove
wget -q -O - https://git.io/vQhTU | bash -s -- --version 1.22.5

# Check version
go version
```

Run the following commands:

```
cd $HOME/omniflixhub
git fetch --all
git checkout v5.0.0-alpha.2
make install
```
Check Version
```
omniflixhubd version --long
```
output should be
```
commit: e9a09184a1feab5d20f0fad9fa88e04218ceee81
cosmos_sdk_version: v0.50.9
go: go version go1.22.5 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v5.0.0-alpha.2
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
git checkout v5.0.0-alpha.2
make build && make install

# check the version - should be v5.0.0-alpha.2
$HOME/go/bin/omniflixhubd version --long
commit: e9a09184a1feab5d20f0fad9fa88e04218ceee81
cosmos_sdk_version: v0.50.9
go: go version go1.22.5 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v5.0.0-alpha.2

# make a dir if you haven't
mkdir -p $HOME/.omniflixhub/cosmovisor/upgrades/v5/bin

# if you are using cosmovisor you then need to copy this new binary
cp $HOME/go/bin/omniflixhubd $HOME/.omniflixhub/cosmovisor/upgrades/v5/bin

# check new version you are about to run - should be equal to v5.0.0-alpha.2
$HOME/.omniflixhub/cosmovisor/upgrades/v5/bin/omniflixhubd version
