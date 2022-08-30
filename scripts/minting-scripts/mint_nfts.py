import json
import time
import shlex
import subprocess

# Add your collection id here eg: onftdenom952b646050314191939b886098e62b..
collection_id = ''

# Add path of your nfts json file                                    
json_file = ''

# set delay between transactions                                
sleep_secs = 5

### Do not edit!
chain_id = 'omniflixhub-1'  # chain_id of the network
rpc_node = 'https://rpc.omniflix.network:443'
fees = '200uflix'  # fees for transaction
fee_account = 'omniflix1q3jnku877fwn9xe8d7a9vsgs29jld4wkpy3lmg'  # fee payer/granter account address used for fee allowance.
broadcast_mode = 'block'  # transaction broadcast mode
### Do not edit!

# keyring backend type. If you are using os keyring, change this value to 'os'
keyring_type = 'test'  

# change this with your key name from local keyring test/os
account_key_name = ''

def nft_mint_cmd(collection_id, nft):
    datajstr = ''
    if 'data' in nft:
        jsonstr = json.dumps(nft['data'])
        datajstr = jsonstr.replace('"', '\\"').replace('\n', '\\n')

    cmd = 'omniflixhubd tx onft mint {} '.format(collection_id)
    cmd += '--name="{}" --description="{}" --media-uri="{}" --preview-uri="{}" --data="{}" '.format(
        nft['name'], nft['description'], nft['media_uri'], nft['preview_uri'], datajstr)

    if 'royalty_share' in nft:
        cmd += '--royalty-share={} '.format(nft['royalty_share'])
    if 'transferable' in nft and not nft['transferable']:
        cmd += '--non-transferable '
    if 'extensible' in nft and not nft['extensible']:
        cmd += '--inextensible '
    if 'nsfw' in nft and nft['nsfw']:
        cmd += '--nsfw '
    if 'recipient' in nft and nft['recipient']:
        cmd += '--recipient {} '.format(nft['recipient'])

    cmd += '--chain-id {} --node "{}" --fees {} --fee-account {} --from {} -b {} --keyring-backend {} -o json -y '.format(
        chain_id, rpc_node, fees, fee_account, account_key_name, broadcast_mode, keyring_type)
    return cmd


def execute_cmd(cmd):
    try:
        args = shlex.split(cmd)
        output = subprocess.check_output(args).decode('utf-8')
        json_out = json.loads(output)
        print(json_out)
    except Exception as e:
        print(e)


print("OmniFlix NFT minting ..")

if len(collection_id) == 0:
    print('collection id not set')
    exit(1)
if len(fee_account) == 0:
    print('fee_account not set')
    exit(1)
if len(account_key_name) == 0:
    print('account key name not set')
    exit(1)

print('Collection ID: ', collection_id)

print('opening file: {} '.format(json_file))

with open(json_file, 'r') as f:
    nfts = json.loads(f.read())

print('total nfts available to mint: ', len(nfts))

print('mint process starting ...')
count = 1
for nft in nfts:
    print('Count: ', count)
    print('generating nft mint command ...')
    cmd = nft_mint_cmd(collection_id, nft)
    print(cmd)
    print('------------------------------------------------------\n')
    print('executing mint command ...')
    execute_cmd(cmd)
    count += 1
    print('-----------------------------------------------------\n')
    print('sleeping for {} seconds ...'.format(sleep_secs))
    time.sleep(sleep_secs)

print('Done.. Successfully completed ')
