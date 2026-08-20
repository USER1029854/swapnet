# PoC / simulation results — does it actually work, and how much is at risk?

All three simulations use `debug_traceCall` (read-only, no state written to chain) against live
public RPC (`https://eth.merkle.io`) with `callTracer`. Foundry/anvil was unavailable (installer
hit a GitHub 403), so state was injected with geth `stateOverrides` where noted. Scripts and raw
traces are in `audit/` (`data/testA_trace.json`, `data/testB_trace.json`, `data/testC_trace.json`).

## Test A — "nothing gates it / it is not behind admin" (definitive)

Replay the **exact** on-chain exploit calldata to `Aperture.0x67b34120`, but with
`from = 0x00000000000000000000000000000000deadbeef` — a random address with no code, no history, and
no relation to the admin `0x9cb8d9ba…` — at the pre-exploit block (24313233).

```
top-level error:            None                      ← call SUCCEEDS from an unprivileged caller
WBTC.transferFrom(from=0x5240b03b VICTIM, to=0xe3e73f, 3,691,897,652)  err=None   ← 36.9 WBTC drained
```

**Conclusion:** the entry point is fully permissionless. The caller's identity is irrelevant; there
is no owner/admin/allow-list check on the fund-moving path (the contract's only `Unauthorized()`
guard is on the empty-calldata *receive* path). Admin plays **no** role. Not exaggerated — this is
the real exploit, reproduced from a nobody address.

## Test C — "it still works against current chain state" (definitive, latest block)

Call `Aperture.0x67b34120` from `0x…deadbeef` at **block = latest**, retargeting the embedded
arbitrary call to `USDT.transferFrom(<a real current max-approver>, attacker, 1,000,000 USDT)`.
Two adjustments make the *cover* mint valid today (they do **not** touch the theft logic):
- the reused `deadline` word (`0x69765c9b` ≈ 2026-01, now expired) patched to the future — otherwise
  the cover-mint's deadline check reverts the tx;
- the max-approver's USDT balance injected via `stateOverrides` (they currently hold 0 — see sizing).

```
top-level error:  None            ← whole transaction commits at the latest block
first revert:     None
USDT.transferFrom(0x0d331650… max-approver → attacker, 1,000,000 USDT)  err=None   ← drained & committed
```

**Conclusion:** the code path that steals a max-approver's tokens executes and commits against
*today's* immutable Aperture bytecode, from an unprivileged caller. The balance injection only
supplies what the approver would hold — it demonstrates that **the instant any current max-approver
holds a balance, anyone drains it in one call.**

## Test B — the honest catch that corrects the report

Same as Test C but targeting the one approver who *does* hold a live-approved balance today —
`0x530a445c…` with 3.47M "Truebit" (`0xf65b5c51…`). Result:

```
TRU.transferFrom(...)  →  revert: "ERC20Pausable: token transfer while paused"
```

The revert is **the Truebit token being paused**, not any guard in Aperture. So the single
"live at-risk" row in the first report is **not actually realizable** — that token is frozen.

## How much is at risk — measured, not estimated

Reconstructed every `Approval`/`ApprovalForAll` (spender = each family contract) and checked
**current** on-chain `min(allowance, balanceOf)` / NFT `getApproved`+`ownerOf` (full non-null
transport confirmed):

| Contract | Chain | Live ERC20 (allow∧bal) | Live NFT positions | setApprovalForAll | Realizable **now** |
|---|---|---|---|---|---|
| Aperture `0xD83d960d` | ETH | 1 (Truebit — **paused**) | 0 / 47 | 0 | **≈ $0** |
| Aperture `0xD83d960d` | ARB | 0 | 0 / 79 | 0 | **$0** |
| Sibling `0xaf34783a71` | ETH | 0 | — | — | **$0** |
| Router `0x616000` | ETH/ARB/Base/BNB | (dust) | — | — | **$0 — behind impl=0 brick** |

**Immediately-realizable exposure at this snapshot ≈ $0.** Every current approver either holds no
balance, holds only a paused/valueless token, or is a position that's already closed; the router is
bricked.

**This is a transient condition, not a fix.** Severity and current-realizable are different numbers:

- **Severity: CRITICAL and structural.** The flaw is an open door (unauthorized access → qualifies
  regardless of amount), permissionless (Test A/C), and — on the immutable Aperture members —
  **permanent and unpatchable**. It was already exploited for millions (36.9 WBTC directly traced,
  campaign larger).
- **Per-victim magnitude: unbounded by attacker capital.** Demonstrated at 36.9 WBTC (~$2.69M, Test A,
  real) and 1,000,000 USDT (Test C, current-block). Whatever a victim holds under a live approval is
  the loss.
- **Latent set that re-arms it the moment they hold funds:** dozens of MAX-approval owners on
  blue-chips — ETH: USDT×2, WBTC, + sibling USDC×3/LINK/rETH/USDT; **ARB: USDC×9, USDT×5, WETH×4,
  WBTC×3, ARB×2**; router (if restored): USDC/USDT/wstETH/cbBTC/WETH/GHO. Each is one deposit away
  from a total drain, and the Aperture contracts can never be turned off.

**Bottom line:** the vulnerability is real, live, permissionless, admin-independent, and immutable —
verified by executing it at the latest block. It is **not** exaggerated. What *is* small is the
amount sitting behind a live approval **at this instant** (~$0), because the approver balances are
currently empty and the one exception is a paused token. The exposure is structural and unbounded,
not a fixed dollar figure.
