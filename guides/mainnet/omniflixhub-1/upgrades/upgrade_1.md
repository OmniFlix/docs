# `Upgrade 1`

Name: **upgrade_1**

When: The upgrade is scheduled for block [4175400](https://www.mintscan.io/omniflix/blocks/4175400), which should be about `11:00 UTC on 30th Nov 2022`.

Version: `v0.8.0`

Details : [Check here](https://github.com/OmniFlix/omniflixhub/releases/tag/v0.8.0) for detailed change log.

### Recommended Specifications:
- 4 Core CPU
- 16GB or more RAM
- 500GB SSD 

### Go version

go v1.19+ (Recommended version v1.19.3 )

### 1. Manual Method
Wait for Omniflixhub to reach the upgrade height (`4175400`)

Look for a panic message, followed by endless peer logs. Stop the daemon
```
sudo systemctl stop omniflixhubd.service
```

Run the following commands:

```
cd $HOME/omniflixhub
git fetch --all
git checkout v0.8.0
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
version: 0.8.0
commit: 7974ee279ae0ebfc5a638beb9849a6e38fc5ad71
build_tags: netgo,ledger,cosmos-sdk v0.45.10
go: go version go1.19.3 linux/amd64
```
Update `iavl` configuration in `app.toml`
### It is very important that you VERIFY and ADD THESE LINES RIGHT BEFORE THE TELEMETRY PART

```
# IAVLDisableFastNode enables or disables the fast node feature of IAVL.
# Default is true.
iavl-disable-fastnode = false
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
git checkout v0.8.0
make build && make install

# check the version - should be v0.8.0
$HOME/go/bin/omniflixhubd version --long
> name: OmniFlixHub
> server_name: omniflixhubd
> version: 0.8.0
> commit: 7974ee279ae0ebfc5a638beb9849a6e38fc5ad71
> build_tags: netgo,ledger,cosmos-sdk v0.45.10
> go: go version go1.19.3 linux/amd64

# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/upgrade_1/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/omniflixhubd $DAEMON_HOME/cosmovisor/upgrades/upgrade_1/bin

# check new version you are about to run - should be equal to v0.8.0
$DAEMON_HOME/cosmovisor/upgrades/upgrade_1/bin/omniflixhubd version

```

**NOTE:**

**Make sure that you have compiled binary with go v1.19.3**

**Don't forget to update this `iavl-disable-fastnode = false` in app.toml before restart** 
