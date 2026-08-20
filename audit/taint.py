import sys
from pyevmasm import disassemble_all
# Basic-block-level taint: within each block, track stack taint.
# Tags: 'CD' calldata-derived, 'MEMCD' memory loaded from CD-written region, 'C:val' constant, '?' unknown
def analyze(path,label):
    code=bytes.fromhex(open(path).read().strip()[2:])
    ins=list(disassemble_all(code))
    idx={op.pc:i for i,op in enumerate(ins)}
    # find basic block boundaries (JUMPDEST starts, JUMP/JUMPI/STOP/RETURN/REVERT/INVALID ends)
    hits=[]
    # simple linear taint reset at block boundaries
    stack=[]
    memcd=set()  # tainted memory offsets (approx, constant offsets only)
    def push(t): stack.append(t)
    def pop():
        return stack.pop() if stack else '?'
    for i,op in enumerate(ins):
        n=op.name
        if n=='JUMPDEST':
            stack=[]; # reset taint at block entry (conservative)
        if n=='CALLDATALOAD':
            pop(); push('CD')
        elif n=='CALLDATACOPY':
            dst=pop(); pop(); pop()  # destOffset, offset, length
            # if dst constant, mark region tainted (approx: mark 'MEMCD_ALL')
            memcd.add('ALL')
        elif n in ('CALLDATASIZE',):
            push('C:cds')
        elif n.startswith('PUSH'):
            try: push('C:%x'%op.operand)
            except: push('C:?')
        elif n.startswith('DUP'):
            k=int(n[3:]); 
            if len(stack)>=k: push(stack[-k])
            else: push('?')
        elif n.startswith('SWAP'):
            k=int(n[4:])
            if len(stack)>k: stack[-1],stack[-1-k]=stack[-1-k],stack[-1]
        elif n=='POP': pop()
        elif n=='MLOAD':
            off=pop()
            push('MEMCD' if 'ALL' in memcd else '?')
        elif n=='MSTORE':
            off=pop(); val=pop()
        elif n in ('AND','OR','ADD','SUB','MUL','DIV','SHL','SHR','XOR','MOD'):
            a=pop(); b=pop()
            # address mask AND: if one side CD and other is address mask const, keep CD
            if 'CD' in (a,) or a=='MEMCD' or b=='CD' or b=='MEMCD':
                push('CD' if (a in('CD','MEMCD') or b in('CD','MEMCD')) else '?')
            else: push('?')
        elif n in ('CALL','CALLCODE','DELEGATECALL','STATICCALL'):
            # stack (top-first): gas, to, [value], argsOff, argsLen, retOff, retLen
            gas=pop(); to=pop()
            if n in ('CALL','CALLCODE'): value=pop()
            argsOff=pop(); argsLen=pop(); retOff=pop(); retLen=pop()
            tainted = to in ('CD','MEMCD')
            hits.append((op.pc,n,to,tainted))
            push('?')
        else:
            # generic: pop input count unknown -> best effort for common ops
            eats={'ISZERO':1,'NOT':1,'BALANCE':1,'EXTCODESIZE':1,'EXTCODEHASH':1,'BLOCKHASH':1,'SLOAD':1,
                  'LT':2,'GT':2,'SLT':2,'SGT':2,'EQ':2,'BYTE':2,'SHA3':2,'KECCAK256':2,'SSTORE':2,'RETURN':2,'REVERT':2,
                  'ADDMOD':3,'MULMOD':3,'RETURNDATACOPY':3,'EXTCODECOPY':4,
                  'ADDRESS':0,'ORIGIN':0,'CALLER':0,'CALLVALUE':0,'GAS':0,'MSIZE':0,'PC':0,'GASPRICE':0,'TIMESTAMP':0,'NUMBER':0,'DIFFICULTY':0,'GASLIMIT':0,'CHAINID':0,'SELFBALANCE':0,'BASEFEE':0,'COINBASE':0,'RETURNDATASIZE':0}
            e=eats.get(n,0)
            for _ in range(e): pop()
            outs={'ISZERO':1,'NOT':1,'BALANCE':1,'EXTCODESIZE':1,'EXTCODEHASH':1,'SLOAD':1,'LT':1,'GT':1,'SLT':1,'SGT':1,'EQ':1,'BYTE':1,'SHA3':1,'KECCAK256':1,'ADDMOD':1,'MULMOD':1,
                  'ADDRESS':1,'ORIGIN':1,'CALLER':1,'CALLVALUE':1,'GAS':1,'MSIZE':1,'PC':1,'GASPRICE':1,'TIMESTAMP':1,'NUMBER':1,'CHAINID':1,'SELFBALANCE':1,'RETURNDATASIZE':1,'COINBASE':1}
            for _ in range(outs.get(n,0)): push('CALLER' if n=='CALLER' else '?')
    print(f"=== {label} ({path}) — CALL sites ===")
    arb=[h for h in hits if h[3]]
    for pc,n,to,t in hits:
        mark=' <== ARBITRARY (target=calldata/mem-derived)' if t else ''
        if t or to.startswith('C:') is False:
            print(f"  pc={pc} {n} to_taint={to}{mark}")
    print(f"  --> {len(arb)} CALL site(s) with calldata/memory-derived target out of {len(hits)}")
analyze(sys.argv[1], sys.argv[2])
