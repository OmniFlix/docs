# Upgrade_1_Patch

## set halt height and restart node
set halt height in app.toml 
```
halt-height = 3236500
```
(or) 

start service with --halt-height flag
```
--halt-height=3236500
```

## change binary after halt hight
```
cd $HOME/omniflixhub
git fetch --all
git checkout v0.7.0
make install
```
And restart node
```
sudo systemctl restart omniflixhubd.service
```

For cosmovisor mv the new binary to upgrade_1 folder

```
cd $HOME/omniflixhub
git fetch --all
git checkout v0.7.0
make build

mv build/omniflixhubd $DAEMON_HOME/cosmovisor/upgrades/upgrade_1/bin
```

check version (output should be v0.7.0)
```
cosmovisor version
```

And restart cosmovisor service

