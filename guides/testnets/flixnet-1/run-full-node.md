### Download Genesis 
Download genesis file from [Omniflix/testnets](https://github.com/Omniflix/testnets) repository

```
curl <genesis-url> > ~/.omniflixhub/config/genesis.json
```

### update peers & seeds
Update below seeds and/or peers in config.toml file
```
seeds = ""
persistnet_peers = ""
```


### start node
  ##### start node with screen session
  install screen if not installed
   ```
    sudo apt-get install screen -y
   ```
  start new screen with a name
   ```
   screen -Rd omniflix
   ```
   start omniflixhub
   ```
   omniflixhubd unsafe-reset-all 
   omniflixhubd start 
   ```
   use CTRL+A+D to detach from screen
   
   (or)
   
 ##### start node as systemctl service
 create service file
```
sudo tee /etc/systemd/system/omniflixhubd.service > /dev/null <<EOF  
[Unit]
Description=OmniFlixHub Daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which omniflixhubd) start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```
load service and start
```
sudo systemctl daemon-reload
sudo systemctl enable omniflixhubd
sudo systemctl start omniflixhubd
```

check status of service
`sudo systemctl status omniflixhubd`
 
 
 we can check full logs of service using `journalctl`
 ```
  journalctl -u omniflixhubd 
  
  #most recent logs
  journalctl -xeu omniflixhubd
  
  #logs from previous day
  journalctl --since "1 day ago" -u omniflixhubd 
