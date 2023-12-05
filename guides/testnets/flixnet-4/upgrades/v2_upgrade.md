# `Testnet v2 Upgrade `

**Name**: `v2`

**When**: The upgrade is scheduled for block [9929200](https://testnet.ping.pub/omniflix/block/9929200). (approximately 14:00 UTC, Dec 6th 2023)

**Details** :
- cosmos-sdk v0.47.5
- cometbft v0.37.2
- ibc-go v7.3.1
- nft-transfer v1.1.3-ibc-v7.3.0
- streampay v2.2.0-alpha.2

**Migrations**:
- x/params module migration: all modules params will be stored on it's own store instead of params subspace
- onft migration: onft module store migration to x/nft (cosmos-sdk nft module) to be compatible with ics721 nft transfers
- ibc-go migrations: migrating ibc-go v4.4.x to v7.3.x

**New Modules**:
- globalfee
- tokenfactory
- icq (interchain query)
- group (cosmos-sdk)
- nft-transfer (ics721 ibc nft transfer)

### Hardware Requirements
- CPU: 8 cores
- RAM: **recommended** 64GB, if not possible minimum required 32GB + 16GB can be added as SWAP memory

Short version swap setup instructions:

``` {.sh}
sudo swapoff -a
sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

To persist swap after restart:

``` {.sh}
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

In depth swap setup instructions:
<https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-20-04>

Note: `after successful upgrade you can change back to previous hardware specification`
### Go version

go v1.21.3+

### 1. Manual Method
Wait for Omniflixhub to reach the upgrade height (`TBA`)

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
git checkout v2.0.0-beta.1
make install
```
Check Version
```
omniflixhubd version --long
```
output should be
```
commit: a0406fca291f41bb3f4ca4b89df1f2eccb5aaaab
cosmos_sdk_version: v0.47.5
go: go version go1.21.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v2.0.0-beta.1
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
git checkout v2.0.0-beta.1
make build && make install

# check the version - should be v2.0.0-beta.1
$HOME/go/bin/omniflixhubd version --long
commit: a0406fca291f41bb3f4ca4b89df1f2eccb5aaaab
cosmos_sdk_version: v0.47.5
go: go version go1.21.3 linux/amd64
name: OmniFlixHub
server_name: omniflixhubd
version: v2.0.0-beta.1

# make a dir if you haven't
mkdir -p $HOME/.omniflixhub/cosmovisor/upgrades/v2/bin

# if you are using cosmovisor you then need to copy this new binary
cp $HOME/go/bin/omniflixhubd $HOME/.omniflixhub/cosmovisor/upgrades/v2/bin

# check new version you are about to run - should be equal to v2.0.0-beta.1
$HOME/.omniflixhub/cosmovisor/upgrades/v2/bin/omniflixhubd version
