# `v2` Upgrade

The upgrade is scheduled for block `TBD`, which should be about `TBD`.

### Go version

go v1.18+


### Manual Method
Wait for Omniflixhub to reach the upgrade height (`TBD`)

Look for a panic message, followed by endless peer logs. Stop the daemon
```
sudo systemctl stop omniflixhubd.service
```

Run the following commands:

```
cd $HOME/omniflixhub
git fetch --all
git checkout v0.5.0
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
version: 0.5.0
commit: 86445088c84564eb0ee0f616af2563fa0ae30c9e
build_tags: netgo,ledger,cosmos-sdk v0.45.6
```
Restart the omniflixhubd service

```
sudo systemctl start omniflixhubd.service
```

### Cosmovisior Method
 - install and setup cosmovisor if you haven't running with cosmovisor

#### Build and Copy Binary

```bash
# get the new version (run inside the repo)
git checkout main && git pull
git checkout v0.5.0
make build && make install

# check the version - should be v0.5.0
$HOME/go/bin/omniflixhubd version --long
> name: OmniFlixHub
> server_name: omniflixhubd
> version: 0.5.0
> commit: 86445088c84564eb0ee0f616af2563fa0ae30c9e
> build_tags: netgo,ledger,cosmos-sdk v0.45.6

# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v2/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/omniflixhubd $DAEMON_HOME/cosmovisor/upgrades/v2/bin

# check new version you are about to run - should be equal to v0.5.0
$DAEMON_HOME/cosmovisor/upgrades/v2/bin/omniflixhubd version

```
