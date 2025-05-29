# `Testnet v6 Upgrade `

**Name**: `v6`

**When**: The upgrade is scheduled for block [18263400](https://testnet.ping.pub/omniflix/block/18263400). (approximately 13:20 UTC, May 30th 2025)

**New Modules & Features** :
- medianode -- registration & leases of medianodes and lease payment settlements
- feemarket -- implementation of the Additive Increase Multiplicative Decrease (AIMD) EIP-1559 feemarket
- Dynamic NFTs -- NFT collections with updatable data enabled

**Version Updates**
- cosmos-sdk v0.50.13
- ibc-go v8.7.0

**Modules Removed**
- globalfee: replaced with feemarket

### Hardware Requirements
- CPU: 4 cores (physical)
- RAM: **recommended** 32GB

### Go version

go v1.24.3+

### 1. Manual Method
Wait for flixnet-4 to reach the upgrade height (`18263400`)

Look for a panic message, followed by endless peer logs. Stop the daemon
```
sudo systemctl stop omniflixhubd.service
```

Install go v1.24.3+
```
# Remove previous installation
sudo rm -rf /usr/local/go
wget -q -O - https://git.io/vQhTU | bash -s -- --remove
wget -q -O - https://git.io/vQhTU | bash -s -- --version 1.24.3

# Check version
go version
```

Run the following commands:

```
cd $HOME/omniflixhub
git fetch --all
git checkout v6.0.0-alpha.2
make install
```
Check Version
```
omniflixhubd version --long
```
output should be
```
commit: 188e45a32ef117db40e25ab5fb31d5492b385731
cosmos_sdk_version: v0.50.13
go: go version go1.24.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v6.0.0-alpha.2
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
git checkout v6.0.0-alpha.2
make build && make install

# check the version - should be v6.0.0-alpha.2
$HOME/go/bin/omniflixhubd version --long
commit: 188e45a32ef117db40e25ab5fb31d5492b385731
cosmos_sdk_version: v0.50.13
go: go version go1.24.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v6.0.0-alpha.2

# make a dir if you haven't
mkdir -p $HOME/.omniflixhub/cosmovisor/upgrades/v6/bin

# if you are using cosmovisor you then need to copy this new binary
cp $HOME/go/bin/omniflixhubd $HOME/.omniflixhub/cosmovisor/upgrades/v6/bin

# check new version you are about to run - should be equal to v6.0.0-alpha.2
$HOME/.omniflixhub/cosmovisor/upgrades/v6/bin/omniflixhubd version
