## v0.4.2 Dragonberry Patch

This is a patch for the [Dragonberry Vulnerability](https://forum.cosmos.network/t/ibc-security-advisory-dragonberry/7702).

This is _non consensus breaking_ with respect to v0.4.0 & v0.4.1 validators who can update without needing a co-ordinated chain upgrade via governance.

To patch, follow the below steps:

1) Stop node
```bash
sudo systemctl stop omniflixhubd.service
```

2) Install go v1.18+ 

`to install follow instructions in below link` 
https://hackmd.io/_CNC1LyESk6Rd3fxacNB0w


3) Install patched version
```bash
cd omniflixhub
git fetch --tags && git checkout v0.4.2
make build && make install
# this will return commit 4497bd14f887b932acaa51e344ef5ded9b12d3f9
omniflixhubd version --long
```

4) Before restart update below config in your app.toml below the iavl-cache-size property

```toml
# IAVLDisableFastNode enables or disables the fast node feature of IAVL. 
# Default is true.
iavl-disable-fastnode = true
```

5) Restart node
```bash
sudo systemctl start omniflixhubd.service
```

To check, the validator node should start producing blocks like before. You can check the same on an OmniFlix Hub explorer of your choice.

The output for the below command should include `version : 0.4.2` if everything goes well:
```
curl localhost:26657/abci_info -s
```
