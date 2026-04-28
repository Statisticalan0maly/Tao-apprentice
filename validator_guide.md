# Validator Guide — TAO Apprentice

> Technical specification for validators on the TAO Apprentice subnet.

---

## Validator Role Summary

Validators on TAO Apprentice serve as the **trust and verification layer** of the subnet. Unlike compute-heavy subnets, validation here is primarily about on-chain data verification, identity scoring, and correct payout calculation.

**Core responsibilities:**
1. Maintain the apprenticeship registry (miner coldkey → apprentice coldkey → target subnet → start date).
2. Calculate the Legitimacy Confidence Score (LCS) for each active pair every epoch.
3. Verify that apprentices are actively earning alpha emissions from a subnet other than this one.
4. Execute the TAO Conversion Pipeline at the end of each 30-day pay period.
5. Submit weights to the chain.
6. Flag and suspend suspicious pairs.

---

## Epoch Cycle

```
[Epoch Start]
    |
    v
Query on-chain emission records for all registered apprentice coldkeys
    |
    v
Verify each apprentice is earning from a DIFFERENT subnet (netuid != this subnet)
    |
    v
Pull identity signals: wallet age, cross-subnet history, off-chain proof hashes
    |
    v
Calculate LCS for each miner-apprentice pair
    |
    v
[End of 30-day pay period]
    |
    v
Snapshot spot rates: R(alpha_Xi -> TAO) and R(TAO -> alpha_THIS)
    |
    v
Calculate total_reward and final_reward for each miner
    |
    v
Submit weights to chain
    |
    v
Flag any LCS < 0.50 pairs — suspend payouts, log event
    |
    v
[Epoch End]
```

---

## LCS Calculation Reference

```
LCS = (identity_score * 0.40) + (activity_score * 0.40) + (subnet_diversity_score * 0.20)
```

| Component | How to Score |
|---|---|
| `identity_score` | Evaluate wallet age (days since first on-chain tx), GitHub account age, X account age, email verification. Score 0.0 for brand-new wallet with no history; up to 1.0 for established multi-year presence. |
| `activity_score` | Check alpha emission records over rolling 30-day window. Consistent daily emissions = 1.0; sporadic = 0.5–0.9; no emissions = 0.0. |
| `subnet_diversity_score` | Binary. If apprentice's registered mining subnet ≠ this subnet's netuid: 1. Otherwise: 0. |

**Suspension rule:**
```
IF LCS < 0.50:
    suspend_payouts(miner_hotkey, apprentice_coldkey)
    emit_flag_event(epoch, pair_id, lcs_score)
```

---

## TAO Conversion Pipeline (Validator Execution)

At the close of each 30-day epoch:

```python
# Pseudocode — hypothetical implementation

def calculate_miner_reward(miner, epoch_end_block):
    total = 0.0
    subnets_seen = set()

    for apprentice in miner.active_apprentices:
        alpha_earned  = query_alpha_emissions(apprentice.coldkey, apprentice.subnet, epoch_end_block)
        R_alpha_to_tao = get_spot_rate(apprentice.subnet, "TAO", epoch_end_block)
        R_tao_to_this  = get_spot_rate("TAO", THIS_SUBNET_NETUID, epoch_end_block)
        ter            = calculate_TER(apprentice.days_active)
        lcs            = calculate_LCS(miner, apprentice)

        if lcs < 0.50:
            flag_pair(miner, apprentice, lcs)
            continue

        converted = alpha_earned * R_alpha_to_tao * R_tao_to_this
        total += ter * converted
        subnets_seen.add(apprentice.subnet)

    sdb = calculate_SDB(len(subnets_seen))
    lcs_miner = calculate_miner_LCS(miner)  # aggregate

    return total * (1 + sdb) * lcs_miner
```

---

## Requirements

- 8-core CPU, 16 GB RAM, 200 GB SSD (see `min_compute.yml`)
- 100 Mbps stable internet connection
- Python 3.10+
- Bittensor CLI installed and configured
- Registered hotkey on this subnet with sufficient TAO stake

---

## Running the Validator

```bash
python neurons/validator/validator.py \
  --netuid <TBD> \
  --wallet.name my_wallet \
  --wallet.hotkey my_hotkey \
  --subtensor.network finney \
  --logging.debug
```

Or:
```bash
bash run_validator.sh --wallet.name my_wallet --wallet.hotkey my_hotkey
```
