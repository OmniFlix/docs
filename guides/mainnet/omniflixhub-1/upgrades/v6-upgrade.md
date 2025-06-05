# `Mainnet v6 Software Upgrade `

**Name**: `v6`

**When**: The upgrade is scheduled for block `18004800`. (approximately at - `Jun 13th 2025 Friday 14:00 UTC`)

**Details** :
- **New Modules**: 
	- `medianode` (alias: `ofmn`)
  - `feemarket` (v1.1.1)
- **Key Messages & Queries**
    - `MsgRegisterMediaNode`,`MsgLeaseMediaNode`, `MsgExtendLease`, `MsgCancelLease`
    - matching `Query` endpoints `MediaNodes`, `AvailableNodes`, `MediaNodeLease` 
- **Removed Modules**
		- `globalfee` 
    
- **version updates**
  - `nft-transfer` (omniflix fork `v1.1.3-ibc-8.7.0`)


### Hardware Requirements
- CPU: 4 cores (physical)
- RAM: **recommended** 32GB

### Go version

go v1.24.3+

### 1. Manual Method
Wait for Omniflixhub to reach the upgrade height (`18004800`)

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
git checkout v6.0.0
make install
```
Check Version
```
omniflixhubd version --long
```
output should be
```
commit: TBU
cosmos_sdk_version: v0.50.13
go: go version go1.24.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v6.0.0
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
git checkout v6.0.0
make build && make install

# check the version - should be v6.0.0
$HOME/go/bin/omniflixhubd version --long
commit: TBU
cosmos_sdk_version: v0.50.13
go: go version go1.24.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v6.0.0

# make a dir if you haven't
mkdir -p $HOME/.omniflixhub/cosmovisor/upgrades/v6/bin

# if you are using cosmovisor you then need to copy this new binary
cp $HOME/go/bin/omniflixhubd $HOME/.omniflixhub/cosmovisor/upgrades/v6/bin

# check new version you are about to run - should be equal to v6.0.0
$HOME/.omniflixhub/cosmovisor/upgrades/v6/bin/omniflixhubd version
