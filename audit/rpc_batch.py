import json, subprocess, tempfile, os
RPCS={
 'eth':["https://ethereum-rpc.publicnode.com","https://eth.drpc.org","https://rpc.ankr.com/eth","https://eth.llamarpc.com"],
 'arb':["https://arb1.arbitrum.io/rpc","https://arbitrum-one-rpc.publicnode.com","https://arbitrum.drpc.org"],
 'base':["https://mainnet.base.org","https://base-rpc.publicnode.com","https://base.drpc.org"],
 'bnb':["https://bsc-dataseed.binance.org","https://bsc-rpc.publicnode.com","https://bsc.drpc.org"],
}
def rpc_batch(chain, calls):
    payload=[{"jsonrpc":"2.0","id":i,"method":"eth_call","params":[{"to":to,"data":data},"latest"]} for i,(to,data) in enumerate(calls)]
    body=json.dumps(payload)
    for url in RPCS[chain]:
        try:
            p=subprocess.run(["curl","-sS","--max-time","45","-X","POST",url,"-H","Content-Type: application/json","--data-binary","@-"],
                             input=body.encode(), capture_output=True, timeout=60)
            resp=json.loads(p.stdout.decode())
            if isinstance(resp,list):
                out=[None]*len(calls)
                for r in resp:
                    if 'id' in r: out[r['id']]=r.get('result')
                if any(x is not None for x in out): return out
        except Exception:
            continue
    return [None]*len(calls)
