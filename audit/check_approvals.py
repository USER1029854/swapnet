import json, sys, time
from rpc_batch import rpc_batch
NFPM='0xc36442b4a4522e871399cd717abdd847ab11fe88'
def chunks(l,n):
    for i in range(0,len(l),n): yield l[i:i+n]
def A(owner,spender): return "0xdd62ed3e"+owner[2:].rjust(64,'0')+spender[2:].rjust(64,'0')
def B(owner): return "0x70a08231"+owner[2:].rjust(64,'0')
def GA(tid): return "0x081812fc"+format(tid,'x').rjust(64,'0')
def OW(tid): return "0x6352211e"+format(tid,'x').rjust(64,'0')
def run(chain, spender, path):
    spender=spender.lower()
    d=json.load(open(path))['result']
    pairs={}
    for l in d:
        pairs[(l['address'].lower(),"0x"+l['topics'][1][-40:])]=int(l['data'],16) if l['data'] not in ('','0x') else 0
    tokens=sorted({t for (t,o) in pairs})
    md=rpc_batch(chain,[(t,"0x313ce567") for t in tokens]); ms=rpc_batch(chain,[(t,"0x95d89b41") for t in tokens])
    meta={}
    for t,dc,sy in zip(tokens,md,ms):
        try: dec=int(dc,16) if dc and dc!='0x' else 18
        except: dec=18
        sym='?'
        if sy and len(sy)>=130:
            try:
                ln=int(sy[66:130],16); raw=sy[130:130+ln*2]; sym=bytes.fromhex(raw).decode('utf8','ignore')
            except: pass
        meta[t]={'d':dec,'s':sym}
    erc20=[(t,o) for (t,o) in pairs if t!=NFPM]
    nft=[(o,pairs[(t,o)]) for (t,o) in pairs if t==NFPM]
    calls=[]
    for (t,o) in erc20: calls+=[(t,A(o,spender)),(t,B(o))]
    res=[]
    for ch in chunks(calls,50): res+=rpc_batch(chain,ch); time.sleep(0.05)
    nonnull=sum(1 for x in res if x is not None)
    assert nonnull>0 or len(calls)==0, f"RPC FAILURE: 0/{len(calls)} non-null for {chain} ERC20 — result invalid"
    atrisk={}; live=[]; maxallow_zerobal={}
    for i,(t,o) in enumerate(erc20):
        a=res[2*i]; b=res[2*i+1]
        a=int(a,16) if a and a!='0x' else 0; b=int(b,16) if b and b!='0x' else 0
        risk=min(a,b)
        if risk>0: atrisk[t]=atrisk.get(t,0)+risk; live.append((t,o,a,b,risk))
        if a>=2**255 and b==0: maxallow_zerobal[t]=maxallow_zerobal.get(t,0)+1
    print(f"=== {chain} spender={spender} ===")
    print(f"ERC20 pairs={len(erc20)} nonnull={nonnull}/{len(calls)} | LIVE(min(allow,bal)>0)={len(live)}")
    print("-- live at-risk by token --")
    for t,amt in sorted(atrisk.items(),key=lambda x:-x[1]):
        m=meta[t]; print(f"  {m['s']:10} {t}: {amt/(10**m['d']):.6f} ({sum(1 for x in live if x[0]==t)} owners)")
    if not atrisk: print("  (none)")
    print("-- top live positions --")
    for t,o,a,b,r in sorted(live,key=lambda x:-x[4])[:15]:
        m=meta[t]; am='MAX' if a>=2**255 else f"{a/(10**m['d']):.4f}"
        print(f"  {m['s']:8} owner={o} allow={am} bal={b/(10**m['d']):.6f} risk={r/(10**m['d']):.6f}")
    print("-- latent (MAX allowance now, but 0 balance -> at risk if they receive tokens) --")
    for t,c in sorted(maxallow_zerobal.items(),key=lambda x:-x[1]):
        print(f"  {meta[t]['s']:10} {t}: {c} owners with MAX allowance & 0 balance")
    # NFTs
    if nft:
        nc=[]
        for (o,tid) in nft: nc+=[(NFPM,GA(tid)),(NFPM,OW(tid))]
        nr=[]
        for ch in chunks(nc,50): nr+=rpc_batch(chain,ch); time.sleep(0.05)
        nnn=sum(1 for x in nr if x is not None)
        assert nnn>0, f"RPC FAILURE nft {chain}"
        nlive=[]
        for i,(o,tid) in enumerate(nft):
            ga=nr[2*i]; ow=nr[2*i+1]
            ga=("0x"+ga[-40:]) if ga and len(ga)>=42 else None
            ow=("0x"+ow[-40:]) if ow and len(ow)>=42 else None
            if ga==spender and ow==o.lower(): nlive.append((tid,o))
        print(f"-- NFPM positions still approved to spender AND owned: {len(nlive)}/{len(nft)} (nonnull={nnn}/{len(nc)}) --")
        for tid,o in nlive[:15]: print(f"   tokenId={tid} owner={o}")
if __name__=='__main__':
    run(sys.argv[1],sys.argv[2],sys.argv[3])
