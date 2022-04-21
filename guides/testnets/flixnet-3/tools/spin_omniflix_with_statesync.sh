#!/bin/bash
CHAIN="omniflix" # use to fetch chain-registry
NODED="omniflixhubd"
GOLINK="https://git.io/vQhTU"
DATABASE="goleveldb"
TRUST_PERIOD="336h0m0s"
HEIGHT_DIFF="3000"
FIX_CHAINID="flixnet-3"
FIX_VERSION="v0.3.0"
FIX_RPCS="https://omniflix-rpc.bloqhub.net,https://omniflix-rpc.bloqhub.net"
FIX_SEEDS="75a6d3a3b387947e272dab5b4647556e8a3f9fc1@45.72.100.122:26656"
FIX_PEERS="f05968e78c84fd3997583fabeb3733a4861f53bf@45.72.100.120:26656,b29fad915c9bcaf866b0a8ad88493224118e8b78@104.154.172.193:26656,28ea934fbe330df2ca8f0ddd7a57a8a68c39a1a2@45.72.100.110:26656,94326ddc5661a1b571ea10c0626f6411f4926230@45.72.100.111:26656"
FIX_REPO="https://github.com/OmniFlix/omniflixhub"
FIX_GENESIS="https://raw.githubusercontent.com/OmniFlix/testnets/main/flixnet-3/genesis.json"
NODE_HOME_DIR=$HOME/.omniflixhub
echo "---------------------- S T A T E - S Y N C ----------------------"

    #main
main() {
    install_dependencies
    install_go
    #fetch_cr
    fix_print
    check_rpc
    build_init
    config
    start
}

    #helperfunction check unique vaulues
unique_values() {
    typeset i
    for i do
        [ "$1" = "$i" ] || return 1
    done
    return 0
}

    #install basic dependencies
install_dependencies() {
    echo "> updating dependencies..."
    sudo apt update -qq && sudo apt upgrade -qq
    sudo apt install -qq build-essential git curl jq wget
}

    #install go
install_go() {
    echo "> installing go..."
    wget -q -O - $GOLINK | bash && source $HOME/.bashrc
}

    #fetch chain-registry
fetch_cr() {
    echo "> fetching chain-registry..."
    echo "-----------------------------------------------------------------"   

    CHAIN_JSON=$(curl -s ${GIT_LINK}/$CHAIN/chain.json)
    NODE_HOME_DIR=$(echo $CHAIN_JSON | jq -r '.node_home') 
    NODE_HOME_DIR=$(eval echo $NODE_HOME_DIR)
    CHAIN_NAME=$(echo $CHAIN_JSON | jq -r '.chain_name')
    CHAIN_ID=$(echo $CHAIN_JSON | jq -r '.chain_id')
    NODED=$(echo $CHAIN_JSON | jq -r '.daemon_name')
    GEN_URL=$(echo $CHAIN_JSON | jq -r '.genesis.genesis_url')
    DPATH=$(echo $CHAIN_JSON | jq -r '.slip44')
    GIT_REPO=$(echo $CHAIN_JSON | jq -r '.codebase.git_repo')
    VERSION=$(echo $CHAIN_JSON | jq -r '.codebase.recommended_version')
    SEEDS=$(echo $CHAIN_JSON | jq -r '.peers.seeds')
    RPC_SERVERS=$(echo $CHAIN_JSON | jq -r '.apis.rpc')
    SEEDLIST=""
    RPCLIST=""

    readarray -t arr < <(jq -c '.[]' <<< $SEEDS)
    for item in ${arr[@]}; do
        ID=$(echo $item | jq -r '.id')
        ADD=$(echo $item | jq -r '.address')
        SEEDLIST="${SEEDLIST},${ID}@${ADD}"
    done
    readarray -t arr < <(jq -c '.[]' <<< $RPC_SERVERS)
    for item in ${arr[@]}; do
        ADD=$(echo $item | jq -r '.address')
        RPCLIST="${RPCLIST},${ADD}"
    done
    SEEDLIST="${SEEDLIST:1}"
    RPCLIST="${RPCLIST:1}"
}

    # fix overwrites & tell user what we do
fix_print(){ 
    
    if [ ! -z "$FIX_VERSION" ] ; then
        VERSION=$FIX_VERSION
    fi  
    if [ ! -z "$FIX_REPO" ] ; then
        GIT_REPO=$FIX_REPO
    fi 
    if [ ! -z "$FIX_RPCS" ] ; then
        RPCLIST=$FIX_RPCS
    fi 
    if [ ! -z "$FIX_SEEDS" ] ; then
        SEEDLIST=$FIX_SEEDS
    fi 
    if [ ! -z "$FIX_GENESIS" ] ; then
        GEN_URL=$FIX_GENESIS
    fi 
    if [ ! -z "$FIX_CHAINID" ] ; then
        CHAIN_ID=$FIX_CHAINID
    fi

    echo "home dir: $NODE_HOME_DIR"
    echo "chain name: $CHAIN_NAME"
    echo "chain id: $CHAIN_ID"
    echo "daemon name: $NODED"
    echo "genesis file url: $GEN_URL"
    echo "git repo: $GIT_REPO"
    echo "version: $VERSION"
    echo "seeds: $SEEDLIST"
    echo "rpc servers: $RPCLIST"
}

    #check rpc connectivity, query trust hash
check_rpc(){
    HASHES=""
    echo "> checking RPC connectivity..."
    IFS=',' read -ra rpcarr <<< "$RPCLIST"
    for rpc in ${rpcarr[@]}; do
        RES=""
        RPCNUM=$((RPCNUM+1))
        RES=$(curl -s $rpc/status --connect-timeout 3 --show-error) || true
        if [ -z "$RES" ] || [[ "$RES" == *"Forbidden"* ]]; then
            echo "> $rpc didn't respond. dropping..."
        else
            HEIGHT=$(echo $RES | jq -r '.result.sync_info.latest_block_height')
            CHECKHEIGHT=$(($HEIGHT-$HEIGHT_DIFF))
            RES=$(curl -s "$rpc/commit?height=$CHECKHEIGHT")
            HASH=$(echo $RES | jq -r '.result.signed_header.commit.block_id.hash')
            TRUSTHASH=$HASH
            HASHES="${HASHES},${HASH}"
            re='.*[0-9].*'
            if [[ "$rpc" == *"https://"* ]] && [[ ! $rpc =~ $re ]] ; then
                if [[ "${rpc: -1}" == "/" ]] ; then
                    rpc="${rpc::-1}"
                fi
                rpc=$rpc:443
            fi
            RPCLIST_FINAL="${RPCLIST_FINAL},${rpc}"
        fi
    done

    if [ -z "$TRUSTHASH" ] ; then
        echo "> trust hash empty. couldn't connect to any RPCs. exiting..."
        exit
    fi
    HASHES="${HASHES:1}"

    RPCLIST_FINAL="${RPCLIST_FINAL:1}"
    echo "working rpc list: $RPCLIST_FINAL"

    if unique_values "${HASHES[@]}"; then
        echo "> hash checks passed!"
        echo "> trust hash: $TRUSTHASH"
    else
        echo "> hash checks failed, exiting..."
        exit
    fi
    echo "-----------------------------------------------------------------"
    read -p "press enter to continue..."
}

    #build and initialize node
build_init(){
    echo "> building $NODED $VERSION from $GIT_REPO..."
    if [ -d "$HOME/$CHAIN_NAME-core" ] ; then
        cd $HOME/$CHAIN_NAME-core && git fetch
    else
        mkdir -p $HOME/$CHAIN_NAME-core
        git clone $GIT_REPO $HOME/$CHAIN_NAME-core && cd $HOME/$CHAIN_NAME-core
    fi
    git checkout $VERSION && make install && cd

    RAND=$(echo $RANDOM | md5sum | head -c 6; echo;)
    echo "> initializing $NODED with moniker $RAND"
    echo "> home dir: ${NODE_HOME_DIR}"
    
    $NODED init $RAND --chain-id=$CHAIN_ID  --home $NODE_HOME_DIR -o

    echo "> downloading genesis from $GEN_URL..."
    rm ${NODE_HOME_DIR}/config/genesis.json
    if [[ "$GEN_URL" == *".gz"* ]]; then
        wget -q $GEN_URL -O genesis.json.gz
        gunzip -df genesis.json.gz && mv genesis.json ${NODE_HOME_DIR}/config/genesis.json
    else
        wget -q $GEN_URL -O ${NODE_HOME_DIR}/config/genesis.json
    fi
}

    #configure state-sync
config() {
    echo "> configuring seeds & state-sync"
    MEP2P=$(curl -s ifconfig.me):26656
    sed -i '/rpc_servers = ""/c rpc_servers = "'$RPCLIST_FINAL'"' $NODE_HOME_DIR/config/config.toml
    sed -i 's/external_address = ""/external_address = "'$MEP2P'"/g' $NODE_HOME_DIR/config/config.toml
    sed -i 's/seeds = .*/seeds = "'$SEEDLIST'"/g' $NODE_HOME_DIR/config/config.toml
    sed -i 's/enable = false/enable = true/g' $NODE_HOME_DIR/config/config.toml
    sed -i 's/trust_height.*/trust_height = '$CHECKHEIGHT'/g' $NODE_HOME_DIR/config/config.toml
    sed -i 's/trust_hash.*/trust_hash = "'$TRUSTHASH'"/g' $NODE_HOME_DIR/config/config.toml
    sed -i 's/trust_period.*/trust_period = "'$TRUST_PERIOD'"/g' $NODE_HOME_DIR/config/config.toml
}

    #spin up node
start() {
    echo "> starting $NODED..."
    $NODED unsafe-reset-all --home $NODE_HOME_DIR
    $NODED start --home $NODE_HOME_DIR --x-crisis-skip-assert-invariants --db_backend $DATABASE || true
    echo "done!"
}


main; exit
