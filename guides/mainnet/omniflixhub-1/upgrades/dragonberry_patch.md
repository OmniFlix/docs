## v0.4.2 Dragonberry Patch

This is a patch for the [Dragonberry Vulnerability](https://forum.cosmos.network/t/ibc-security-advisory-dragonberry/7702).

This is _non consensus breaking_ with respect to v0.4.0 & v0.4.1 Validators can update without needing a co-ordinated chain upgrade via governance.
```bash
# stop node
sudo systemctl stop omniflixhubd.service

# install patched version
cd omniflixhub
git fetch --tags && git checkout v0.4.2
make build && make install
# this will return commit 4497bd14f887b932acaa51e344ef5ded9b12d3f9
omniflixhubd version --long

# restart service
sudo systemctl start omniflixhubd.service
```
