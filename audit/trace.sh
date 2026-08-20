#!/bin/bash
# try debug_traceTransaction callTracer across tracing-capable endpoints
TX=$1
for url in https://eth.drpc.org https://ethereum-rpc.publicnode.com https://rpc.ankr.com/eth https://eth.llamarpc.com; do
  resp=$(curl -sS --max-time 40 -X POST "$url" -H "Content-Type: application/json" \
    --data "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"debug_traceTransaction\",\"params\":[\"$TX\",{\"tracer\":\"callTracer\"}]}" 2>/dev/null)
  if echo "$resp" | grep -q '"result"'; then echo "$resp"; echo "SOURCE:$url" >&2; return 0 2>/dev/null; break; fi
done
echo "$resp"
