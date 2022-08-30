# Cosmovisor Setup

To install Cosmovisor:

``` {.sh}
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
```

After this, you must make the necessary folders for cosmosvisor in your
daemon home directory (\~/.omniflixhubd).

cosmovisor folder structure
```
.
├── current -> genesis or upgrades/<name>
├── genesis
│   └── bin
│       └── $DAEMON_NAME
└── upgrades
    └── <name>
        └── bin
            └── $DAEMON_NAME
```

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

Setup Systemd Service

```
sudo tee /etc/systemd/system/omniflixhubd.service > /dev/null <<EOF
[Unit]
Description=OmniFlixHub Daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) start
Restart=always
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_NAME=omniflixhubd"
Environment="DAEMON_HOME=/home/$USER/.omniflixhub"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_LOG_BUFFER_SIZE=512"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
```

Load service and start

```
sudo systemctl daemon-reload
sudo systemctl enable omniflixhubd
sudo systemctl start omniflixhubd
```

Check logs

```
journalctl -fu omniflixhubd.service
```
