import sys, re
from pyevmasm import disassemble_all

def load(path):
    h=open(path).read().strip()
    if h.startswith('0x'): h=h[2:]
    return bytes.fromhex(h)

def selectors(code):
    # Find PUSH4 <sel> ... EQ/DUP..EQ patterns; robust: collect all PUSH4 values compared then JUMPI
    ins=list(disassemble_all(code))
    sels=[]
    for i,op in enumerate(ins):
        if op.name=='PUSH4':
            # look ahead a few for EQ
            for j in range(i+1, min(i+6,len(ins))):
                if ins[j].name in ('EQ','SUB') :
                    sels.append('%08x'%op.operand); break
    # dedup preserve order
    seen=set(); out=[]
    for s in sels:
        if s not in seen and s!='ffffffff': seen.add(s); out.append(s)
    return out

def constants(code):
    ins=list(disassemble_all(code))
    addrs=set(); words=set()
    for op in ins:
        if op.name=='PUSH20':
            addrs.add('0x%040x'%op.operand)
        if op.name=='PUSH32':
            words.add('0x%064x'%op.operand)
    return addrs, words

def callsites(code):
    ins=list(disassemble_all(code))
    res=[]
    for i,op in enumerate(ins):
        if op.name in ('CALL','DELEGATECALL','STATICCALL','CALLCODE'):
            ctx=[ins[k].name for k in range(max(0,i-8),i)]
            res.append((op.pc, op.name, ctx))
    return res

if __name__=='__main__':
    path=sys.argv[1]
    code=load(path)
    print("=== %s  (%d bytes) ==="%(path,len(code)))
    sels=selectors(code)
    print("\n-- Function selectors (%d) --"%len(sels))
    for s in sels: print("  "+s)
    addrs,words=constants(code)
    print("\n-- PUSH20 address constants (%d) --"%len(addrs))
    for a in sorted(addrs): print("  "+a)
    print("\n-- PUSH32 word constants (%d) --"%len(words))
    for w in sorted(words): print("  "+w)
    cs=callsites(code)
    print("\n-- CALL/DELEGATECALL sites (%d) --"%len(cs))
    for pc,name,ctx in cs:
        print("  pc=%d %s  <- ctx: %s"%(pc,name," ".join(ctx)))
