#!/bin/bash
# Multi-endpoint RPC with fallback
declare -A RPCS
RPCS[eth]="https://ethereum-rpc.publicnode.com https://eth.drpc.org https://rpc.ankr.com/eth https://eth.llamarpc.com"
RPCS[arb]="https://arb1.arbitrum.io/rpc https://arbitrum-one-rpc.publicnode.com https://arbitrum.drpc.org"
RPCS[base]="https://mainnet.base.org https://base-rpc.publicnode.com https://base.drpc.org"
RPCS[bnb]="https://bsc-dataseed.binance.org https://bsc-rpc.publicnode.com https://bsc.drpc.org"

rpc() {
  local chain=$1 method=$2 params=$3
  for url in ${RPCS[$chain]}; do
    local resp
    resp=$(curl -sS --max-time 25 -X POST "$url" -H "Content-Type: application/json" \
      --data "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"$method\",\"params\":$params}" 2>/dev/null)
    if echo "$resp" | grep -q '"result"'; then
      echo "$resp"
      return 0
    fi
  done
  echo '{"error":"all endpoints failed"}'
  return 1
}
export -f rpc
export RPCS
