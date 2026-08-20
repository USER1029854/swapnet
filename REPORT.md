# Security Audit — SwapNet Router + Aperture "Automan" family
### Arbitrary external-call over standing approvals (Family C)

**Auditor:** Claude (defensive security engagement)
**Date:** 2026-08-20
**Chains in scope:** Ethereum (1), Arbitrum One (42161), Base (8453), BNB Chain (56)
**Verdict:** **CRITICAL — confirmed, exploited in the wild, and structurally unfixable on the immutable members of the family.**

> **Live PoC (added after review):** the flaw was executed against chain state with `debug_traceCall` — see `audit/POC.md`. It is **permissionless** (drains from `0x00…deadbeef`, unrelated to the admin) and **commits at the latest block** (a 1,000,000-USDT drain of a real max-approver). Two honest corrections came out of it: (a) the one "live" ETH row (Truebit) is a **paused** token, so **immediately-realizable exposure right now ≈ $0**; (b) severity is unchanged — the door is open, permissionless, and immutable, and it was already exploited for millions. Realizable-now ($0) and severity (Critical) are different numbers; see `audit/POC.md`.
>
> **What this verdict does and does not cover.** The finding below is proven from on-chain
> behavior (transaction traces + decoded calldata) and confirmed structurally by immutable-bytecode
> analysis. The contracts are **closed-source**; heimdall's Solidity output for them is garbled
> (noted throughout), so every load-bearing claim is anchored to a trace, a decoded calldata word,
> a storage read, or a byte-level opcode scan — never to a decompiler guess. Where a byte reading and
> a behavioral reading could diverge, I use the behavioral one. Coverage gaps (Base/BNB log access,
> full campaign $ netting) are named explicitly in **§10**.

---

## 0. Corrections to the handed premise (read first)

The lead I was given was materially incomplete in three ways, and the corrections are themselves
findings:

1. **The address labelled "Attacker (ETH) `0x5c92884d…`" is not an attacker EOA — it is the
   attacker's throw-away exploit *contract***, deployed (and self-destructed in the same transaction)
   by the real attacker EOA **`0xe3e73f1e6ace2b27891d41369919e8f57129e8ea`**.
   Receipt of `0x8f28a7f6…25a` shows `contractAddress = 0x5c92884d…`, `from = 0xe3e73f…`.

2. **The observed theft did not go through the SwapNet router's approvals — it went through
   Aperture's.** The victim never approved the router. The victim (`0x5240b03b…`) held an **infinite
   WBTC approval to the Aperture contract `0xD83d960d…`** (set block 24285462, before the exploit),
   and Aperture's arbitrary-call flaw was used to `transferFrom` it. The router and Aperture share
   one flaw class; the incident exercised Aperture.

3. **"Both contracts share one address across all four chains" is false.** Only the **router**
   `0x616000…` is deployed (byte-identical) on all four chains. **Aperture `0xD83d960d…` exists only
   on Ethereum and Arbitrum** (no code on Base/BNB — verified on two independent RPCs each), and its
   bytecode **differs between ETH and ARB** (chain-specific constants). A **third, previously
   unlisted** family member — **`0xaf34783a7160ba1bed6dc94dfb6740f73076bb32`** — is also live and was
   also drained in the same campaign.

The real system is: **a family of Aperture "Automan"-style position-automation contracts, plus a
SwapNet UniswapX-filler router, all sharing an unguarded arbitrary-external-call primitive that is
reachable by anyone and executes with the contract's own standing user approvals.**

---

## 1. The vulnerability (Critical)

### 1.1 Statement of the broken invariant

Every one of these contracts holds **standing ERC-20 allowances and per-tokenId Uniswap-V3 NFPM
approvals** granted by users so the contract can pull their tokens to build/rebalance positions.
The security-critical invariant is:

> **A contract may only move a user's approved tokens on behalf of, and at the direction of, that
> same user.**

The Aperture entry function **`0x67b34120`** (and its siblings `0x6377633a`, `0xd2e24ed5`, and the
router's fill path) **breaks this invariant**: it accepts an attacker-supplied list of
`(address target, bytes data)` tuples and executes `target.call(data)` **from the contract's own
context**, with **no restriction on `target`** and **no check binding the `from` field of an embedded
`transferFrom` to `msg.sender`**. An attacker therefore supplies
`target = <any token a victim approved>`, `data = transferFrom(victim, attacker, amount)`, and the
contract — holding the victim's allowance — executes the transfer.

### 1.2 Code-level proof (behavioral + byte-level)

**Byte-level (taint analysis, `audit/taint.py`).** A stack/memory taint pass over the *immutable*
Aperture runtime bytecode flags CALL instructions whose target operand derives from calldata:

```
APERTURE 0xD83d960d…  — CALL sites with calldata/memory-derived target:
   pc=7593  CALL  to = CALLDATA-derived   <== arbitrary external call
   pc=8845  CALL  to = MEM(calldata)      <== arbitrary external call
   pc=10324 CALL  to = CALLDATA-derived   <== arbitrary external call
ROUTER impl 0x46ea7ecf… — CALL sites with calldata/memory-derived target:
   pc=16373 CALL  to = CALLDATA-derived   <== arbitrary external call
   pc=21165 CALL  to = MEM(calldata)      <== arbitrary external call
```

(The tracker is approximate — conservative per-block reset, coarse memory model — so it is
corroboration, not the primary proof. Aperture also has 0 `SELFDESTRUCT`, 0 `DELEGATECALL`.)

**Behavioral (definitive).** The exploit calldata to `0x67b34120`, decoded word-by-word from the
transaction trace, contains the arbitrary call inline:

```
word[26] = 0x…2260fac5e5542a773aa44fbcfedf7c193bc2c599     target   = WBTC
word[28] = 0x…0000000000000064                              data.len = 100 bytes
word[29] = 23b872dd 0000…0000 5240b03be5bc101a0082074666dd89ad   transferFrom(
word[30] = 883e1f9d 0000…0000 e3e73f1e6ace2b27891d41369919e8f5     from = 0x5240b03b (VICTIM),
word[31] = 7129e8ea 0000…0000                                       to   = 0xe3e73f  (ATTACKER),
word[32] = …dc0de334                                                amount = 3,691,897,652 )  = 36.918977 WBTC
```

**The trace then shows Aperture executing exactly that call:**

```
CREATE   ATTACKER_EOA -> EXPLOIT_CONTRACT(0x5c92884d)
  CALL   EXPLOIT_CONTRACT -> APERTURE(0xD83d960d)  0x67b34120
    …(legit-looking cover: WETH.deposit, approve, later NFPM.mint of a 100-wei position)…
    CALL APERTURE -> WBTC.transferFrom(from=VICTIM 0x5240b03b, to=ATTACKER 0xe3e73f, 3,691,897,652)  ← THEFT
  SELFDESTRUCT EXPLOIT_CONTRACT -> ATTACKER_EOA
```

The `transferFrom`'s `from` is the victim and `to` is the attacker — both attacker-chosen, executed
under Aperture's standing allowance. This is the whole bug.

### 1.3 Reachability, cost, and why nothing stops it

- **Permissionless.** The exploit was run by a freshly-deployed contract owned by an ordinary EOA
  with no privilege. `0x67b34120` has no caller allow-list (the only `Unauthorized()` guard in the
  contract is on the empty-calldata *receive* path, not on the swap entrypoints).
- **Attacker cost:** gas only. **Gain:** the victim's entire approved balance (here 36.9 WBTC ≈
  **$2.69M** at the WBTC price of $72,731 observed during the audit). Gain is independent of the
  attacker's own capital → passes the economic test decisively; and as an *unauthorized-access*
  (open-door) finding it qualifies regardless of amount.
- **No guard elsewhere defeats it.** I looked: there is no `from == msg.sender` check, no target
  allow-list, no re-entrancy issue needed (a plain call suffices). The reentrancy guard
  (`store_a == 2`) is present but irrelevant to this flaw.

### 1.4 Severity sizing — and why it is permanent

Severity is measured against the value the broken invariant protects: **every token and NFT position
any user has approved, or will ever approve, to these contracts.** Two structural facts fix this at
Critical:

- **The Aperture members are immutable and un-killable.** `0xD83d960d…` and `0xaf34783a71…` are
  **not proxies** (both EIP-1967 and ZeppelinOS impl slots read zero) and contain **no
  `SELFDESTRUCT`**. I confirmed the runtime bytecode at a block adjacent to the exploit
  (24304371) is **byte-identical** to today (`sha256` prefix `0d1f828c…` on ETH). *The exact code
  that stole the WBTC is running, unchanged, right now, and cannot be patched, paused, or destroyed.*
  The only mitigation is per-user approval revocation. **Confirmed live:** `audit/POC.md` executes `0x67b34120` from an unprivileged address against the latest block and commits a drain.
- **The router is only mitigated by a mutable switch.** Its implementation pointer is currently
  `0x0` on all four chains (bricked), but the **admin EOA `0x9cb8d9ba…` can restore any
  implementation with a single `upgradeTo` call** — it is the same key that set the pointer to zero
  (tx `0x2a183795…`, block 24314422). This is an operational mitigation with a one-transaction
  expiry, **not** a fix.

---

## 2. Current funds at risk (live state as of the audit)

Standing approvals were reconstructed from `Approval`/`ApprovalForAll` events (spender = each
contract), then each `(token, owner)` pair was checked for **current** on-chain
`min(allowance, balanceOf)`. (Methodology note: an earlier pass returned false zeros because a Python
`urllib` transport was silently 403'd by the proxy; results below use a curl transport with an
explicit non-null-response guard — see `audit/check_approvals.py`.)

| Contract | Chain | Approver pairs | **Live-drainable now** | Latent (MAX allowance, 0 balance today) |
|---|---|---:|---|---|
| Aperture `0xD83d960d` | ETH | 63 ERC20 + 47 NFT | **0 realizable** — the 1 live approval (`0x530a445c…`, 3.47M "Truebit") reverts: the token is **paused** (PoC Test B) | USDT×2, WBTC, and others |
| Aperture `0xD83d960d` | ARB | 94 ERC20 + 79 NFT | 0 | **USDC×9, USDT×5, WETH×4, WBTC×3, ARB×2** |
| Sibling `0xaf34783a71` | ETH | 46 ERC20 | 0 | USDC×3, LINK, rETH, USDT, RNDR |
| Router `0x616000` | ETH | 36 ERC20 | 1 dust (RIVER) — **blocked by brick** | USDC×3, USDT×2, RLUSD×2, wstETH, cbBTC, WETH, GHO |
| Router `0x616000` | ARB | 82 ERC20 | 4 incl. ~2,070 USDC — **blocked by brick** | wstETH, WBTC, USD₮0, ARB, CRV |

**Reading this table:**
- The **Aperture/sibling live + latent rows are real, standing exposure** — those contracts are
  immutable and permissionless, so any of those owners is drained **the instant they hold a balance
  while the approval stands.** The blue-chip latent set (USDC/USDT/WETH/WBTC/wstETH/rETH/LINK) is the
  danger: these are approvals users forgot to revoke, currently empty, one deposit away from theft.
  This is a *standing invitation*, not a hypothetical.
- The **router rows are gated behind the brick** — not drainable today, but they become drainable in
  one `upgradeTo` transaction by the admin EOA if a flawed implementation is restored.

Prices used (from DefiLlama during the audit): WBTC $72,731 · WETH $2,313 · USDC/USDT ≈ $1 · ARB
$0.090. "Truebit" (`0xf65b5c51…`) has no price feed and is treated as economically negligible though
technically drainable.

---

## 3. What was actually stolen (flow of funds)

- **Real attacker EOA:** `0xe3e73f1e6ace2b27891d41369919e8f57129e8ea` (nonce ~165; 2 exploit-contract
  deployments: `0x5c92884d…` self-destructing, and `0xdde1dc9069…` at block 24313277).
- **Anchored, fully-traced theft:** **36.918977 WBTC** from victim `0x5240b03b…` (tx `0x8f28a7f6…`,
  block 24313234). The victim now holds 10 wei WBTC.
- **Broader campaign (same flaw, verified by tracing a second transaction `0x60ec7bce…`):** batched
  drains of **multiple victims' Uniswap-V3 position NFTs** (`NFPM.transferFrom(victim, attacker,
  tokenId)`) plus **LINK, USDC, USDT, WETH**, executed by **both** `0xD83d960d…` and the sibling
  `0xaf34783a71…`. The attacker then closed the stolen LP positions (`NFPM.decreaseLiquidity`/
  `collect`, 28+ calls), swapped everything to ETH via the **Uniswap Universal Router**
  (`0x66a9893c…`), and moved proceeds out in repeated **~559.5–560 ETH tranches** to a small set of
  laundering addresses (`0xaef13f71…`, `0xaefd0cfc…`, `0x33eea797…`, `0x33e0831e…`).

I did **not** perform full swap-netting across all 187 attacker transactions, so I do not assert a
single campaign-total figure; **36.9 WBTC (~$2.69M) is the floor** that is directly and unambiguously
attributable to the flaw. The campaign is clearly multiples larger (many victims, many assets, LP
positions).

---

## 4. Resolved system (trust graph)

### 4.1 SwapNet router `0x616000e384Ef1C2B52f5f3A88D57a3B64F23757e` (all 4 chains)
- **Type:** ZeppelinOS `AdminUpgradeabilityProxy` (pre-EIP-1967). Impl slot
  `0x7050c9e0…8ed3f8c3` (`keccak256("org.zeppelinos.proxy.implementation")`); admin slot
  `0x10d6a54a…ff9390b`. Proxy bytecode **byte-identical on all four chains** (`sha256` prefix
  `9aa6ad4a…`). Deterministic deploy confirmed.
- **Admin:** EOA `0x9cb8d9bae84830b7f5f11ee5048c04a80b8514ba` (same on all four chains; `codelen=0`).
  Sole upgrade authority.
- **Implementation now:** `0x0` on **all four chains** (bricked). Confirmed by reading the impl slot
  and by `implementation()` via the admin path.
- **Implementation history** (from `Upgraded` events; addresses differ per chain — CREATE, not
  CREATE2):
  - ETH: `e635c94d → bcfdc7fe → 0e8ac089 → 8d61ce32 → 46ea7ecf` (last live) → `0x0` @ blk 24314422.
  - ARB: `51209993 → ee9fd334 → 83ade0f9 → 712a5e1f → 63ea8c07 → 77eb212b` (last live) → `0x0` @ blk 425193769.
- **Nature:** DEX-aggregation **UniswapX filler** (entry points include `reactorCallback`,
  `unlockCallback` (UniV4), `uniswapV3SwapCallback`, `pancakeV3SwapCallback`, `withdrawTokens`;
  reads `OWNER()`=`0x9cb8d9ba…`, `PERMIT2()`, `WETH_TOKEN()`, `UNISWAP_V3_POOL_INIT_CODE_HASH()`,
  `UNISWAP_V4_POOL_MANAGER()`). Embeds WETH `0xc02aaa39…`, UniV3 factory `0x1F98431c…`, UniV3 init
  hash `0xe34f199b…`, and a helper `0x6000da47…` (12 KB, unidentified).

### 4.2 Aperture "Automan" `0xD83d960deBEC397fB149b51F8F37DD3B5CFA8913` (ETH + ARB only)
- **Type:** plain immutable contract (not a proxy; no selfdestruct/delegatecall). Created
  2025-12-15 (block 24020090) by `0xbeef63ae…` via factory `0x13b0d85c…`.
- **Bytecode:** ETH `sha256 0d1f828c…`, ARB `sha256 fb080bfd…` (same length 19,443; differ by
  chain-specific constants). **No code on Base/BNB.**
- **Immutables (from constructor / bytecode):** Permit2 `0x000000000022d473030f116ddee9f6b43ac78ba3`,
  Uniswap-V3 NFPM `0xc36442b4a4522e871399cd717abdd847ab11fe88`, UniV3 pool init-code-hash
  `0xe34f199b…`, plus a UniV3 factory read in the constructor.
- **Entry points (6):** `permit2()`, `positionManager()`, `uniswapV3SwapCallback`, **`0x67b34120`
  (exploited)**, `0x6377633a`, `0xd2e24ed5`.

### 4.3 Sibling "Automan" `0xaf34783a7160ba1bed6dc94dfb6740f73076bb32` (ETH; likely ARB)
- Immutable (non-proxy, no selfdestruct), 19,375 bytes, **contains the `0x67b34120` dispatch** and the
  same 20-CALL / arbitrary-call structure. Also drained in the campaign. Its own standing approvals
  (USDC/LINK/rETH/USDT/RNDR) are latent exposure.

### 4.4 Dependencies reached by the code
- **Uniswap V3 NonfungiblePositionManager** `0xc36442b4…` — Automan pulls/mints/transfers user
  positions through it; **arbitrary-call can redirect it to steal position NFTs.**
- **Permit2** `0x000000000022d473…` — alternate pull path (victims also approve it).
- **WETH** `0xc02aaa39…`; **PAXG** `0x45804880…` (a token users approved; queried during exploit).
- **`0x40aa958d…`** (2 KB, unidentified) — Automan grants it transient WETH approvals during a mint.
- **`0x6000da47…`** (12 KB, unidentified) — referenced by the router implementation.

Artifacts on disk: `audit/bytecode/` (all fetched runtime bytecode), `audit/decompiled/`
(heimdall output — garbled, see caveat), `audit/data/` (raw traces, approval logs, receipts),
`audit/analyze.py` / `audit/taint.py` / `audit/check_approvals.py` (tooling).

---

## 5. Entry-point ledger

**Aperture `0xD83d960d` (permissionless unless noted):**

| Selector | Role | Guard | Exploitable? |
|---|---|---|---|
| `0x67b34120` | mint/zap w/ arbitrary call-list | reentrancy guard only | **YES — arbitrary call over approvals (proven)** |
| `0x6377633a` | position op w/ call-list (payable) | reentrancy guard only | **Likely YES — same shape (calldata-derived CALL at pc 8845/10324)** |
| `0xd2e24ed5` | position op w/ call-list | reentrancy guard only | **Likely YES — same shape** |
| `0xfa461e33` | `uniswapV3SwapCallback` | expects to be called mid-swap | Callback; abuse folds into the call-list vector |
| `0x12261ee7` | `permit2()` view | n/a | No |
| `0x791b98bc` | `positionManager()` view | n/a | No |
| *(receive)* | ETH receive | `msg.sender == immutable` | No |

**Router impl `0x46ea7ecf` (21 external selectors)** — key ones: `585da628 reactorCallback`
(UniswapX fill; executes resolved-order callbacks), `91dd7346 unlockCallback` (UniV4),
`fa461e33`/`23a69e75` (V3 swap callbacks), `5ecb16cd withdrawTokens(address[])` (owner sweep),
plus getters. The fill path contains calldata-derived CALL sites (pc 16373/21165). **All neutralized
today by the impl=0 brick**; each becomes live if an implementation is restored.

---

## 6. Dependency / composition map (what reads what)

- `0x67b34120` **writes** arbitrary external state via `target.call(data)` and **reads** the
  contract's own token allowances → the composition *"user grants standing approval"* × *"anyone can
  direct an arbitrary call"* is the exploit. No second function or interleaving is required; a single
  call suffices.
- The NFPM position path **reads** per-tokenId approvals the contract holds → the same arbitrary call
  redirects NFPM to `transferFrom` a victim's position NFT.
- No profitable *splitting*, *read-only-reentrancy*, or *cross-function* interleaving is needed — the
  primitive is already maximally general (it can call anything as the contract), so those advanced
  compositions add nothing beyond it.

---

## 7. Rebuttal register (candidates considered and their status)

| Candidate defense / alt-finding | Outcome |
|---|---|
| "The router holds the approvals, so bricking it (impl=0) closes the risk." | **Rejected as complete mitigation.** Router brick is real but the admin EOA can `upgradeTo` a flawed impl in one tx; and the *observed* theft used Aperture's approvals, which the router brick does not touch. |
| "Aperture must have a caller allow-list / from==sender check." | **Refuted.** Exploit run by an unprivileged fresh contract; trace shows `from=victim` accepted; only guard in bytecode is on the receive path. |
| "The arbitrary call is guarded by the reentrancy lock." | **Rejected** — the lock (`store_a==2`) prevents reentry, not the single-call theft. |
| "Approvals are all revoked, so risk = 0." (my own first result) | **Was a false zero from a 403'd RPC transport.** Corrected: 1 live position + dozens of latent blue-chip MAX approvals remain; on immutable contracts these never expire on their own. |
| "Truebit is worthless, so no finding." | **Severity is not the token I could reach** — it is every asset any approver holds now or later against an unfixable contract. Truebit is merely the one non-empty balance today. |
| "Contracts are verified/audited elsewhere." | **Refuted** — all three are closed-source (Etherscan `getsourcecode` empty on ETH & ARB); no verified twin found. |
| Router impl distinct addresses per chain ⇒ maybe one chain safe. | **Doesn't help** — all impls are `0x0` now (all bricked) and all share the filler flaw when restored; weakest deployment (any restored impl) governs. |

---

## 8. Off-chain components in the trust path

The **router is a UniswapX filler**, so in normal operation it depends on off-chain order flow and an
RFQ/limit-order signer (the bytecode carries Permit2 `LimitOrderWitness` / `TokenPermissions`
type-strings). **The flaw does not depend on any of this** — it is purely on-chain and permissionless
— but note: if a restored router implementation ever trusts a signed order's fields without binding
them, that is a second, independent surface. Not assessable while the router is bricked and
closed-source; flagged for whoever restores it. The Aperture members have **no** off-chain dependency
in the exploit path.

---

## 9. Minimal fixes

- **Immutable Automan members (`0xD83d960d`, `0xaf34783a71`, ETH+ARB):** cannot be patched. The only
  actions are **(a) mass user-communication to revoke all ERC-20 allowances and NFPM approvals** to
  both addresses on both chains, and **(b)** front-end/allowance-manager warnings. Any future user
  approval to these addresses re-arms the bug.
- **A corrected redeployment** must restrict the executable call-list to a vetted target allow-list
  (routers only), forbid the ERC-20 `transferFrom`/`approve`/NFPM-`transferFrom` selectors on
  arbitrary targets, and require any `transferFrom(from, …)` to satisfy `from == msg.sender`.
- **Router:** keep the implementation at `0x0`; if ever restored, apply the same call-list
  restrictions. Consider migrating the upgrade key off a single EOA (it is currently a single hot
  EOA that can re-enable the flaw unilaterally).

---

## 10. What I could not read / assumptions / residual uncertainty

- **Closed source + garbled decompilation.** All three targets are unverified; heimdall v0.9.2's
  Solidity output for them is not faithful. I therefore relied on **transaction traces, decoded
  calldata, storage reads, and byte-level opcode/taint scans**. The behavioral proof (§1.2) is
  independent of the decompiler and is dispositive.
- **Base/BNB router approvals not enumerated.** Free Etherscan-V2 rejects Base/BNB, and full-range
  `eth_getLogs` on public RPCs there was rejected. I **did** confirm from storage that the router's
  implementation is `0x0` (bricked) on Base and BNB, so any approvals there are behind the same
  switch; their sizing is **unassessed** and should be completed with a paid explorer key.
- **Campaign total not netted.** I anchor the verified theft at 36.9 WBTC and describe the wider
  campaign qualitatively; a full figure needs swap-netting across all attacker transactions.
- **Sibling on ARB / other family members.** `0xaf34783a71…` is confirmed on ETH; I did not
  enumerate every Automan deployment on every chain. There may be additional family members with
  their own standing approvals — the factory `0x13b0d85c…` and deployer `0xbeef63ae…` are the leads
  to enumerate them.
- **`0x40aa958d…` and `0x6000da47…`** (a callee and a router helper) were not decompiled; they are
  reached by the code but are not on the theft path.

### Bottom line
A permissionless, unguarded arbitrary-external-call primitive in an immutable family of
position-automation contracts lets anyone drain any user's standing token/position approval. It has
**already been exploited** (≥ 36.9 WBTC / ~$2.69M directly traced, campaign larger). On the immutable
Aperture members the bug is **permanent and unfixable**. Verified by live simulation (`audit/POC.md`):
it is permissionless and commits at the latest block. **Immediately-realizable exposure right now is
≈ $0** — every current approver is empty or holds a paused token — but that is a transient snapshot,
not safety: the blue-chip latent approvals are drained the instant those wallets hold a balance, on
contracts that can never be turned off. The router variant is
**temporarily neutralized by a mutable, EOA-controlled implementation pointer** that can be reverted
in one transaction. This is a **Critical** finding whose current dollar exposure is a snapshot with no
structural floor.
