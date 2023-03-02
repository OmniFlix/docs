



## Install omniflixhubd
# A) Setup

## 1) Install Golang (go)

1.1) Remove any existing installation of `go`

```
sudo rm -rf /usr/local/go
```

1.2) Install latest/required Go version (installing `go1.19`)

```
curl https://dl.google.com/go/go1.19.5.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
```

1.3) Update env variables to include `go`
    
   - **Not required if you have already done this before**
```
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF

source $HOME/.profile
```

1.4) Check the version of go installed

```
go version
```

### 2) Install required software packages

```
sudo apt-get install git curl build-essential make jq -y
```

### 3) Install `omniflixhub`

```
# clone repo if not cloned previously 
git clone https://github.com/Omniflix/omniflixhub.git

# install latest version 
cd omniflixhub
git fetch --all
git checkout v0.9.0-gon-test2 # or can use omniflix-gon branch directly
go mod tidy
make install
```

### 4) Verify your installation
```
omniflixhubd version --long
```

On running the above command, you should see a similar response like this. Make sure that the *version* and *commit hash* are accurate

```
name: OmniFlixHub
server_name: omniflixhubd
version: 0.9.0-gon-test2
commit: ee20e3f40112609eae373ffd04fdf5bc17b36589
```

## Create Collection


## Mint NFTs


## Transfer NFT to Different Chain


## Transfer Back to source chain
