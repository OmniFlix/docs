import json
import time
import shlex
import subprocess

# Add path of your nfts json file
json_file = './test-listings.json'

# set delay between transactions
sleep_secs = 5

chain_id = 'omniflixhub-1'  # chain_id of the network
rpc_node = 'https://rpc.omniflix.network:443'
fees = '200uflix'  # fees for transaction
fee_account = 'omniflix1q3jnku877fwn9xe8d7a9vsgs29jld4wkpy3lmg'  # fee payer account address

# change this with your key name
account_key_name = ''

broadcast_mode = 'block'  # transaction broadcast mode
keyring_type = 'test'  # keyring backend type


def nft_list_cmd(listing):
    price_str = '{}{}'.format(listing['price']['amount'], listing['price']['denom'])
    cmd = 'omniflixhubd tx marketplace list-nft '
    cmd += '--denom-id="{}" --nft-id="{}" --price="{}" '.format(
        listing['denom_id'], listing['nft_id'], price_str)
    if 'split_shares' in listing:
        split_shares = []
        for share in listing['split_shares']:
            split_shares.append('{}:{}'.format(share['address'], share['weight']))
        split_shares_str = ','.join(split_shares)
        cmd += '--split-shares "{}" '.format(split_shares_str)

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


print("OmniFlix NFT Listing ..")

if len(fee_account) == 0:
    print('fee_account not set')
    exit(1)
if len(account_key_name) == 0:
    print('account key name not set')
    exit(1)


print('opening file: {} '.format(json_file))

with open(json_file, 'r') as f:
    listings = json.loads(f.read())

print('total nfts available to list on marketplace: ', len(listings))

print('listing process starting ...')
count = 1
for listing in listings:
    print('Count: ', count)
    print('generating nft marketplace list command ...')
    cmd = nft_list_cmd(listing)
    print(cmd)
    print('------------------------------------------------------\n')
    print('executing list command ...')
    execute_cmd(cmd)
    count += 1
    print('-----------------------------------------------------\n')
    print('sleeping for {} seconds ...'.format(sleep_secs))
    time.sleep(sleep_secs)

print('Done.. Successfully completed ')

