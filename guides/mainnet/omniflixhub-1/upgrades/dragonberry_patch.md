## v0.4.2 Dragonberry Patch

This is a patch for the [Dragonberry Vulnerability](https://forum.cosmos.network/t/ibc-security-advisory-dragonberry/7702).

This is _non consensus breaking_ with respect to v0.4.0 & v0.4.1 Validators can update without needing a co-ordinated chain upgrade via governance.

Stop node
```bash
sudo systemctl stop omniflixhubd.service
```
Install go v1.18+ 

`to install follow instructions in below link` 
https://hackmd.io/_CNC1LyESk6Rd3fxacNB0w

Install patched version
```bash
cd omniflixhub
git fetch --tags && git checkout v0.4.2
make build && make install
# this will return commit 4497bd14f887b932acaa51e344ef5ded9b12d3f9
omniflixhubd version --long
```
Before restart update below config in your app.toml below the iavl-cache-size property

```toml
# IAVLDisableFastNode enables or disables the fast node feature of IAVL. 
# Default is true.
iavl-disable-fastnode = true
```
Restart node
```bash
sudo systemctl start omniflixhubd.service
```
