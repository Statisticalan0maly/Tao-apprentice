# Incentive Mechanism — TAO Apprentice

> Full technical specification of all reward formulas, validation logic, and payout mechanics.

---

## Table of Contents

1. [Overview](#overview)
2. [Formula 0 — TAO Conversion Pipeline](#formula-0--tao-conversion-pipeline)
3. [Formula 1 — Tenure Emission Rate (TER)](#formula-1--tenure-emission-rate-ter)
4. [Formula 2 — Subnet Diversity Bonus (SDB)](#formula-2--subnet-diversity-bonus-sdb)
5. [Formula 3 — Legitimacy Confidence Score (LCS)](#formula-3--legitimacy-confidence-score-lcs)
6. [Final Combined Reward Formula](#final-combined-reward-formula)
7. [Payout Schedule & Epoch Definition](#payout-schedule--epoch-definition)
8. [Validator Scoring Logic](#validator-scoring-logic)
9. [Anti-Sybil Mechanisms](#anti-sybil-mechanisms)

---

## Overview

Every miner payout on TAO Apprentice is governed by four formulas applied in sequence:

```
Step 1: Convert apprentice alpha earnings → TAO → this subnet's alpha  (Formula 0)
Step 2: Apply tenure-based percentage                                   (Formula 1)
Step 3: Apply subnet diversity multiplier                               (Formula 2)
Step 4: Gate by legitimacy confidence score                             (Formula 3)
```

The final output is a single `final_reward` value denominated in this subnet's alpha token, paid to the miner's registered hotkey at the end of each 30-day epoch.

---

## Formula 0 — TAO Conversion Pipeline

### Purpose
TAO is the **universal base currency** of the Bittensor ecosystem. All miner rewards on this subnet are calculated by first converting an apprentice's raw alpha earnings to TAO, then converting that TAO into this subnet's alpha. This ensures:

- Payouts are fairly valued regardless of which subnet an apprentice mines.
- Miners are not unfairly advantaged or penalized by volatility in any individual subnet's alpha price.
- The process is transparent and auditable using on-chain spot rates.

### Pipeline

```
STEP 1:  Apprentice earns alpha on Subnet X over the 30-day pay period.
         alpha_earned = total alpha tokens earned on Subnet X

STEP 2:  Convert apprentice alpha -> TAO at end-of-period spot rate.
         TAO_value = alpha_earned * R(alpha_X -> TAO)

         Where:
           R(alpha_X -> TAO) = spot rate of Subnet X alpha to TAO at conversion time

STEP 3:  Convert TAO -> this subnet's alpha at end-of-period spot rate.
         subnet_alpha = TAO_value * R(TAO -> alpha_THIS)

         Where:
           R(TAO -> alpha_THIS) = spot rate of TAO to this subnet's alpha at conversion time

STEP 4:  Apply miner's Tenure Emission Rate to the converted subnet_alpha.
         miner_payout = TER(t) * subnet_alpha
```

### Full Single-Payout Formula
```
miner_payout(t) = TER(t) * [ alpha_earned * R(alpha_X -> TAO) * R(TAO -> alpha_THIS) ]
```

| Variable | Definition |
|---|---|
| `t` | Days apprentice has been active |
| `TER(t)` | Tenure Emission Rate (see Formula 1) |
| `alpha_earned` | Alpha tokens earned by apprentice on Subnet X this pay period |
| `R(alpha_X -> TAO)` | End-of-period spot rate: apprentice's subnet alpha → TAO |
| `R(TAO -> alpha_THIS)` | End-of-period spot rate: TAO → this subnet's alpha token |

---

## Formula 1 — Tenure Emission Rate (TER)

### Purpose
The TER rewards miners whose apprentices remain active and earning over longer periods. It directly penalizes low-effort onboarding by paying nothing in the first 30 days, and rewards sustained mentorship with increasing percentages up to the 180-day cap.

### Step Function Table

| Days Active | TER Value | Miner Receives |
|---|---|---|
| 0 – 29 | 0.01 | 1% of converted alpha |
| 30 – 59 | 0.025 | 2.5% |
| 60 – 89 | 0.05 | 5% |
| 90 – 119 | 0.08 | 8% |
| 120 – 149 | 0.12 | 12% |
| 150 – 179 | 0.15 | 15% |
| 180 (cap) | 0.18 | 18% — final epoch, apprenticeship closes |

### Formal Expression
```
TER(t) = { 0.01,  t < 30
         { 0.025, 30 <= t < 60
         { 0.05,  60 <= t < 90
         { 0.08,  90 <= t < 120
         { 0.12,  120 <= t < 150
         { 0.15,  150 <= t < 180
         { 0.18,  t = 180
```

> **Design note:** The low initial rate (1%) during days 0–29 — rather than zero — provides a small signal incentive to begin the relationship, while the real rewards only materialize once the apprentice demonstrates sustained mining activity.

---

## Formula 2 — Subnet Diversity Bonus (SDB)

### Purpose
The SDB rewards miners who spread their apprentices across multiple different Bittensor subnets. A miner with 5 apprentices all mining Subnet X contributes less educational value to the ecosystem than one whose apprentices mine 5 different subnets.

### Diversity Tier Table

| Distinct Active Subnets (D) | SDB Value | Bonus |
|---|---|---|
| 1 | 0.01 | +1% |
| 2 | 0.02 | +2% |
| 3 | 0.05 | +5% |
| 4 | 0.08 | +8% |
| 5 | 0.12 | +12% |

### Total Epoch Reward Formula (Per Miner, With TAO Conversion)
```
total_reward =
  [ SUM( TER(t_i) * alpha_i * R(alpha_Xi -> TAO) * R(TAO -> alpha_THIS) ) ]
  * (1 + SDB(D))

Where:
  i                     = index over all active apprentices (max 5)
  t_i                   = days apprentice i has been active
  alpha_i               = alpha earned by apprentice i on their subnet this epoch
  R(alpha_Xi -> TAO)    = spot rate: apprentice i's subnet alpha -> TAO
  R(TAO -> alpha_THIS)  = spot rate: TAO -> this subnet's alpha
  D                     = number of distinct subnets across all active apprentices
  SDB(D)                = diversity bonus from table above
```

---

## Formula 3 — Legitimacy Confidence Score (LCS)

### Purpose
The LCS is a per-epoch validator score that gates payouts. It is the anti-sybil and anti-fraud mechanism. No payout occurs for any pair scoring below 0.50.

### LCS Calculation
```
LCS = (identity_score * 0.40) + (activity_score * 0.40) + (subnet_diversity_score * 0.20)
```

### Component Definitions

| Component | Weight | Definition | Range |
|---|---|---|---|
| `identity_score` | 40% | Verified real human: GitHub account age, X account, email, wallet age, cross-subnet activity | 0.0 – 1.0 |
| `activity_score` | 40% | Apprentice is consistently earning emissions (not just registered, not stale) | 0.0 – 1.0 |
| `subnet_diversity_score` | 20% | Apprentice is mining a subnet OTHER than TAO Apprentice | 0 or 1 |

### Suspension Rule
```
IF LCS < 0.50:
  payout = 0
  flag miner-apprentice pair for validator review
  emit on-chain warning event
```

---

## Final Combined Reward Formula

```
final_reward =
  [ SUM( TER(t_i) * alpha_i * R(alpha_Xi -> TAO) * R(TAO -> alpha_THIS) ) ]
  * (1 + SDB(D))
  * LCS
```

This single formula governs every miner payout epoch. It encodes:
- **Fairness** via TAO conversion
- **Quality incentive** via tenure scaling
- **Ecosystem breadth** via diversity bonus
- **Fraud resistance** via legitimacy gating

---

## Payout Schedule & Epoch Definition

| Parameter | Value |
|---|---|
| Pay period length | 30 days |
| Spot rate snapshot | End-of-period block |
| Max apprenticeship duration | 180 days (6 epochs) |
| Max concurrent apprentices per miner | 5 |
| Payout token | This subnet's alpha (TAO-converted) |

---

## Validator Scoring Logic

Each epoch, validators must:

1. Query on-chain alpha emission records for every registered apprentice coldkey.
2. Verify the apprentice is earning from a subnet other than TAO Apprentice (netuid ≠ this subnet).
3. Pull identity verification signals (wallet age, cross-subnet history, off-chain proofs).
4. Calculate `LCS` for each miner-apprentice pair.
5. Calculate `R(alpha_Xi -> TAO)` and `R(TAO -> alpha_THIS)` from end-of-period spot prices.
6. Compute `final_reward` for each miner.
7. Submit weights to the chain.

---

## Anti-Sybil Mechanisms

| Threat | Mitigation |
|---|---|
| Miner registers fake second wallet as apprentice | Wallet age check + cross-subnet activity history; new wallets with no independent on-chain history score near 0 on identity_score |
| Miner coaches apprentice to mine this subnet itself | subnet_diversity_score = 0 if apprentice is on this subnet; payout blocked |
| Miner keeps one apprentice forever for passive income | 180-day hard cap; apprenticeship closes automatically |
| Miner registers 100 apprentices | Hard cap of 5 concurrent apprentices enforced by validator registry |
| Bot network mimicking apprentice activity | activity_score weighted toward sustained, varied on-chain behavior, not just block-by-block presence |
