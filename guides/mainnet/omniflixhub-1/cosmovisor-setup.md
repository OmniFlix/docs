# Cosmovisor Setup

To install Cosmovisor:

``` {.sh}
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
```

After this, you must make the necessary folders for cosmosvisor in your
daemon home directory (\~/.omniflixhubd).

``` {.sh}
mkdir -p ~/.omniflixhub/cosmovisor
mkdir -p ~/.omniflixhub/cosmovisor/genesis
mkdir -p ~/.omniflixhub/cosmovisor/genesis/bin
mkdir -p ~/.omniflixhub/cosmovisor/upgrades
```

Copy the current omniflixhubd binary into the
cosmovisor/genesis folder.

```{.sh}
cp $GOPATH/bin/omniflixhubd ~/.omniflixhub/cosmovisor/genesis/bin
mkdir -p ~/.omniflixhub/cosmovisor/upgrades/v2/bin
cp $GOPATH/bin/omniflixhubd ~/.omniflixhub/cosmovisor/upgrades/v2/bin
```

Cosmovisor is now ready to be started. We will now set up Cosmovisor for the upgrade

Set these environment variables:

```{.sh}
echo "# Setup Cosmovisor" >> ~/.profile
echo "export DAEMON_NAME=omniflixhubd" >> ~/.profile
echo "export DAEMON_HOME=$HOME/.omniflixhub" >> ~/.profile
echo "export DAEMON_ALLOW_DOWNLOAD_BINARIES=false" >> ~/.profile
echo "export DAEMON_LOG_BUFFER_SIZE=512" >> ~/.profile
echo "export DAEMON_RESTART_AFTER_UPGRADE=true" >> ~/.profile
echo "export UNSAFE_SKIP_BACKUP=true" >> ~/.profile
source ~/.profile
```
Check version

```{.sh}
cosmovisor version
```