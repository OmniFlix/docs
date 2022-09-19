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
start node
```
sudo systemctl restart omniflixhubd.service
```

## change binary after halt hight
```
cd $HOME/omniflixhub
git fetch --all
git checkout v0.7.0
make install
```

set halt-height to `0` or remove --halt-hight flag

```
halt-height = 0
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
Unset halt-height

```
halt-height = 0
```

And restart cosmovisor service

