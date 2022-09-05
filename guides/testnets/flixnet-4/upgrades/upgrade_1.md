# `Upgrade 1`

Name: upgrade_1

When: The upgrade is scheduled for block `3030800`, which should be about 11:15 UTC on 6th September 2022.

Details : Check here for detailed change log.

### Go version

go v1.18+

### 1. Manual Method
Wait for Omniflixhub to reach the upgrade height (`3030800`)

Look for a panic message, followed by endless peer logs. Stop the daemon
```
sudo systemctl stop omniflixhubd.service
```

Run the following commands:

```
cd $HOME/omniflixhub
git fetch --all
git checkout v0.6.0
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
version: 0.6.0
commit: 51f70f158b0e25bb5ebe5e73bc4c235dd72399f5
build_tags: netgo,ledger,cosmos-sdk v0.45.6
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
git checkout v0.6.0
make build && make install

# check the version - should be v0.6.0
$HOME/go/bin/omniflixhubd version --long
> name: OmniFlixHub
> server_name: omniflixhubd
> version: 0.6.0
> commit: 51f70f158b0e25bb5ebe5e73bc4c235dd72399f5
> build_tags: netgo,ledger,cosmos-sdk v0.45.6

# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/upgrade_1/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/omniflixhubd $DAEMON_HOME/cosmovisor/upgrades/upgrade_1/bin

# check new version you are about to run - should be equal to v0.6.0
$DAEMON_HOME/cosmovisor/upgrades/upgrade_1/bin/omniflixhubd version

```
