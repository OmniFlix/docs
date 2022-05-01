import json
import time
import shlex
import subprocess

# Add path of your nfts transfers json file
json_file = './test-transfers.json'

# set delay between transactions
sleep_secs = 5

chain_id = 'omniflixhub-1'  # chain_id of the network
rpc_node = 'https://rpc.omniflix.network:443'
fees = '200uflix'  # fees for transaction
fee_account = 'omniflix1q3jnku877fwn9xe8d7a9vsgs29jld4wkpy3lmg'  # fee payer account address

# change this with your key name
account_key_name = ''

broadcast_mode = 'block'  # transaction broadcast mode
keyring_type = 'os'  # keyring backend type


def nft_transfer_cmd(nft_transfer):
    cmd = 'omniflixhubd tx onft transfer {} {} {} '.format(nft_transfer['recipient'], nft_transfer['denom_id'], nft_transfer['nft_id'])
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


print("OmniFlix NFT Transfer ..")

if len(fee_account) == 0:
    print('fee_account not set')
    exit(1)
if len(account_key_name) == 0:
    print('account key name not set')
    exit(1)


print('opening file: {} '.format(json_file))

with open(json_file, 'r') as f:
    nft_transfers = json.loads(f.read())

print('total nfts available to transfer: ', len(nft_transfers))

print('transferring process starting ...')
count = 1
for nft_transfer in nft_transfers:
    print('Count: ', count)
    print('generating nft transfer command ...')
    cmd = nft_transfer_cmd(nft_transfer)
    print(cmd)
    print('------------------------------------------------------\n')
    print('executing transfer command ...')
    execute_cmd(cmd)
    count += 1
    print('-----------------------------------------------------\n')
    print('sleeping for {} seconds ...'.format(sleep_secs))
    time.sleep(sleep_secs)

print('Done.. Successfully completed ')

