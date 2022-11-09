# `Testnet Upgrade 2`

Name: testnet_upgrade_2

When: The upgrade is scheduled for block `4013000`.

Details : 
 - dragonberry patch
 - ibc-go v3.3.1

### Go version

go v1.18+

### 1. Manual Method
Wait for Omniflixhub to reach the upgrade height (`4013000`)

Look for a panic message, followed by endless peer logs. Stop the daemon
```
sudo systemctl stop omniflixhubd.service
```

Install go v1.18
```
# Remove previous installation
sudo rm -rf /usr/local/go

# Install correct Go version
curl https://dl.google.com/go/go1.18.7.linux-amd64.tar.gz | sudo tar -C /usr/local -zxvf -

# Check version
go version
```

Run the following commands:

```
cd $HOME/omniflixhub
git fetch --all
git checkout v0.8.0-testnet
make install
```
Check Version
```
omniflxihubd version --long
```
output should be
```
name: OmniFlixHub
server_name: omniflixhubd
version: 0.8.0-testnet
commit: 61365cef935b664d191a8ec2a35bf12791ba81d0
build_tags: netgo,ledger,cosmos-sdk v0.45.10 github.com/confio/ics23/go
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
git checkout v0.8.0-testnet
make build && make install

# check the version - should be v0.8.0-testnet
$HOME/go/bin/omniflixhubd version --long
> name: OmniFlixHub
> server_name: omniflixhubd
> version: 0.8.0-testnet
> commit: 61365cef935b664d191a8ec2a35bf12791ba81d0
> build_tags: netgo,ledger,cosmos-sdk v0.45.10 github.com/confio/ics23/go

# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/testnet_upgrade_2/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/omniflixhubd $DAEMON_HOME/cosmovisor/upgrades/testnet_upgrade_2/bin

# check new version you are about to run - should be equal to v0.8.0-testnet
$DAEMON_HOME/cosmovisor/upgrades/testnet_upgrade_2/bin/omniflixhubd version

```
