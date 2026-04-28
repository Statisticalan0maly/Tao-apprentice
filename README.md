# 🎓 TAO APPRENTICE — Bittensor Subnet Proposal

### **Decentralized Mentorship Network: Incentivizing Miners to Onboard New Miners to Bittensor**

> **⚠️ STATUS: THEORETICAL SPECIFICATION — Pre-registration proposal. All mechanics described herein are designed for review, community feedback, and investor evaluation prior to mainnet deployment.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bittensor](https://img.shields.io/badge/bittensor-subnet-blue)](https://bittensor.com)
[![Status](https://img.shields.io/badge/status-proposal-orange)](https://github.com)
[![Discord](https://img.shields.io/badge/discord-Santideva-black?logo=discord)](https://discord.com)
[![X / Twitter](https://img.shields.io/badge/x-@Tek__Savvy-black?logo=x)](https://x.com/Tek_Savvy)

---

*Conceived by **Santideva** (Discord) • [@Tek_Savvy](https://x.com/Tek_Savvy) (X.com)*

---"Simplicity is the ultimate sophistication" is widely attributed to Leonardo da Vinci

## Overview

**TAO Apprentice** is a proposed Bittensor subnet whose mission is to open-source knowledge about the Bittensor ecosystem via structured, incentivized word-of-mouth mentorship.

Miners on this subnet are rewarded for successfully teaching **new, verified human miners** how to earn alpha emissions on *other* Bittensor subnets. The longer and more consistently an apprentice earns emissions, the greater the reward to their mentor miner — creating a direct, on-chain incentive for high-quality, personalized education.

**The core loop:**
1. A miner finds a real person interested in Bittensor mining.
2. The miner teaches them — one-on-one — how to set up and mine on a subnet suited to their skills.
3. Once the apprentice earns emissions on another subnet, the miner begins receiving a percentage of those emissions (converted through TAO) as a reward.
4. Validators verify legitimacy, prevent sybil attacks, and score each pair continuously.

---

## Table of Contents

1. [Incentive Mechanism](#incentive-mechanism)
   - [Owner Role](#owner-role)
   - [Validator Role](#validator-role)
   - [Miner Role](#miner-role)
2. [Emission & Reward Formulas](#emission--reward-formulas)
   - [Formula 0 — TAO Conversion Pipeline](#formula-0--tao-conversion-pipeline)
   - [Formula 1 — Tenure Emission Rate (TER)](#formula-1--tenure-emission-rate-ter)
   - [Formula 2 — Subnet Diversity Bonus (SDB)](#formula-2--subnet-diversity-bonus-sdb)
   - [Formula 3 — Legitimacy Confidence Score (LCS)](#formula-3--legitimacy-confidence-score-lcs)
   - [Final Combined Reward Formula](#final-combined-reward-formula)
3. [Constraints & Hard Caps](#constraints--hard-caps)
4. [Requirements](#requirements)
   - [Miners / Validators](#miners--validators)
   - [Apprentices](#apprentices)
5. [How to Mine — Step by Step](#how-to-mine--step-by-step)
6. [Installation](#installation)
   - [Prerequisites](#prerequisites)
   - [Install Miner](#install-miner)
   - [Install Validator](#install-validator)
7. [Running](#running)
   - [Run Miner](#run-miner)
   - [Run Validator](#run-validator)
8. [Minimum Compute Requirements](#minimum-compute-requirements)
9. [Technical & Intellectual Considerations](#technical--intellectual-considerations)
10. [FAQ](./FAQ.md)
11. [License](#license)

---

## Incentive Mechanism

### Owner Role

The subnet owner is responsible for:
- Designing, publishing, and maintaining the incentive parameters and emission schedule.
- Ensuring validators are correctly scoring miner-apprentice pairs.
- Updating the LCS weighting and TER step function as the subnet matures.
- Verifying that apprentice identity proofs meet the required standard.
- Preventing collusion between miners and validators.

### Validator Role

Validators act as the **watchdog layer** of the subnet. Their responsibilities are:

- Continuously verify that each registered apprentice is a distinct, real human being (not a bot, duplicate wallet, or sockpuppet of the miner).
- Monitor on-chain activity to confirm apprentices are actively earning alpha emissions from a subnet *other than* this one.
- Calculate the **Legitimacy Confidence Score (LCS)** for each miner-apprentice pair each epoch.
- Execute the **TAO Conversion Pipeline** at the end of each 30-day pay period to determine correct payout amounts.
- Flag any LCS < 0.50 and suspend payouts pending review.
- Maintain a registry of active apprenticeships (miner coldkey → apprentice coldkey → subnet → start date).

### Miner Role

Miners on this subnet are **mentors**. Their job is to:

- Find real, motivated people who want to mine Bittensor but don't know how.
- Assess the apprentice's hardware, time availability, and technical background.
- Match the apprentice to the most suitable Bittensor subnet for their profile.
- Teach the apprentice — through direct, personalized communication — how to register a wallet, set up their miner, and begin earning emissions.
- Maintain an active mentorship relationship for the full tenure period (up to 180 days per apprentice).
- Register up to **5 active apprentices** simultaneously.

> Miners earn a percentage of their apprentices' alpha emissions, converted through TAO, paid in this subnet's alpha token. Rewards scale with apprenticeship duration and subnet diversity.

---

## Emission & Reward Formulas

> For full technical documentation see [`docs/incentive_mechanism.md`](./docs/incentive_mechanism.md)

---

### Formula 0 — TAO Conversion Pipeline

> **TAO is the base currency standard for all payouts on this subnet.**

At the end of every 30-day pay period, an apprentice's alpha emissions are **not** paid directly to the miner. They are first converted to TAO at the current market rate, then converted into this subnet's own alpha token before the miner receives their percentage.

```
STEP 1:  alpha_earned  = total alpha tokens earned by apprentice on Subnet X

STEP 2:  TAO_value     = alpha_earned * R(alpha_X -> TAO)
         # R(alpha_X -> TAO) = end-of-period spot rate: apprentice subnet alpha -> TAO

STEP 3:  subnet_alpha  = TAO_value * R(TAO -> alpha_THIS)
         # R(TAO -> alpha_THIS) = end-of-period spot rate: TAO -> this subnet's alpha

STEP 4:  miner_payout  = TER(t) * subnet_alpha
```

**Full single-payout formula:**
```
miner_payout(t) = TER(t) * [ alpha_earned * R(alpha_X -> TAO) * R(TAO -> alpha_THIS) ]
```

| Variable | Definition |
|---|---|
| `t` | Days apprentice has been active |
| `TER(t)` | Tenure Emission Rate (see Formula 1) |
| `alpha_earned` | Alpha tokens earned by apprentice on their subnet this period |
| `R(alpha_X -> TAO)` | End-of-period spot rate: apprentice's subnet alpha → TAO |
| `R(TAO -> alpha_THIS)` | End-of-period spot rate: TAO → this subnet's alpha token |

**Why TAO as the standard?**
- TAO is the universal base currency of Bittensor. Routing through TAO ensures payouts are fairly valued regardless of which subnet an apprentice mines.
- Alpha prices fluctuate independently per subnet. Converting through TAO first prevents miners from being unfairly rewarded or penalized due to volatility in their apprentice's subnet.
- All conversions use end-of-period spot rates — transparent, auditable, and consistent with how dTAO emissions already function on-chain.

---

### Formula 1 — Tenure Emission Rate (TER)

The TER is a **piecewise step function**. It rewards miners whose apprentices remain active and earning over time, directly incentivizing mentorship quality over quick onboarding.

| Days Active | Miner Receives (% of converted alpha) |
|---|---|
| 0 – 29 | 1% |
| 30 – 59 | 2.5% |
| 60 – 89 | 5% |
| 90 – 119 | 8% |
| 120 – 149 | 12% |
| 150 – 179 | 15% |
| 180 (cap) | 18% |

**Formal expression:**
```
TER(t) = { 0.01,  t < 30
         { 0.025, 30 <= t < 60
         { 0.05,  60 <= t < 90
         { 0.08,  90 <= t < 120
         { 0.12,  120 <= t < 150
         { 0.15,  150 <= t < 180
         { 0.18,  t = 180  (final epoch — apprenticeship closes)
```

> **Note:** All percentages apply to the TAO-converted value of the apprentice's alpha emissions, not raw alpha.

---

### Formula 2 — Subnet Diversity Bonus (SDB)

Miners whose apprentices mine across *multiple different subnets* receive a bonus multiplier on their total epoch reward. This incentivizes broad ecosystem education rather than funneling everyone into a single subnet.

| Distinct Subnets (D) | Bonus |
|---|---|
| 1 | +1% |
| 2 | +2% |
| 3 | +5% |
| 4 | +8% |
| 5 | +12% |

**Total epoch reward formula (with TAO conversion):**
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
  SDB(D)                = diversity bonus (0.01, 0.02, 0.05, 0.08, or 0.12)
```

---

### Formula 3 — Legitimacy Confidence Score (LCS)

Validators score each miner-apprentice pair every epoch. This is the **anti-sybil, anti-fraud layer** of the subnet.

```
LCS = (identity_score * 0.40) + (activity_score * 0.40) + (subnet_diversity_score * 0.20)

Components:
  identity_score         ->  Verified real human (GitHub, X, email, wallet age)  ->  0.0 – 1.0
  activity_score         ->  Apprentice consistently earning emissions            ->  0.0 – 1.0
  subnet_diversity_score ->  Apprentice mining a subnet OTHER than this one       ->  0 or 1
```

> Any LCS < 0.50 triggers a validator flag and **suspends payouts** for that pair pending review.

---

### Final Combined Reward Formula

```
final_reward =
  [ SUM( TER(t_i) * alpha_i * R(alpha_Xi -> TAO) * R(TAO -> alpha_THIS) ) ]
  * (1 + SDB(D))
  * LCS
```

This is the single formula that governs every miner payout. It incorporates:
- **TAO conversion** (Formula 0) — fair cross-subnet valuation
- **Tenure scaling** (Formula 1) — rewards long-term mentorship
- **Diversity multiplier** (Formula 2) — rewards broad ecosystem education
- **Legitimacy gating** (Formula 3) — filters fraud and sybil attacks

---

## Constraints & Hard Caps

| Rule | Value | Reason |
|---|---|---|
| Max apprentices per miner | 5 | Prevents passive rent-seeking; maintains mentorship quality |
| Max apprenticeship duration | 6 months / 180 days | Forces continued recruitment; prevents permanent passive income |
| Minimum payout threshold | Days 0–29 = 1% only | Filters low-effort, ghost-after-onboarding behavior |
| Sybil LCS threshold | LCS < 0.50 = suspended | Stops fake account farming |
| Conversion standard | All payouts route through TAO | Ensures consistent, fair cross-subnet valuation |
| Subnet restriction | Apprentice must mine a DIFFERENT subnet | Prevents circular emissions exploitation |

---

## Requirements

### Miners / Validators

- Basic working knowledge of **macOS (Sequoia+)**, **Windows 11**, and **Linux (Ubuntu 22.04+)**
- Minimum **3+ years** invested in the Bittensor ecosystem (holding TAO, dTAO, etc.)
- **3+ years** of developer experience with coding or programming in the crypto/AI space
- Knowledge of the majority of active Bittensor subnets and their functionality, verified by the subnet owner
- Must have previously **earned alpha emissions** from another Bittensor subnet
- Ability to dedicate time to **direct, personalized communication** with apprentices

### Apprentices

- A computer with at least **8 GB RAM**, **100 GB storage**, and a stable internet connection
- **Little to no previous experience** mining on Bittensor
- An open-minded, positive attitude and sincere interest in Bittensor, crypto, and AI decentralization

---

## How to Mine — Step by Step

> See full guide: [`docs/mining_guide.md`](./docs/mining_guide.md)

### Step 1 — Find an Apprentice
Find real people interested in mining Bittensor. Verify identity with GitHub, X, Discord, email, etc.

### Step 2 — Assess Their Setup
Ask about hardware (RAM, GPU, CPU, VRAM), bandwidth, monthly energy cost, and time availability.

### Step 3 — Assess Their Tech Level
- **Beginner / Novice:** Little to no tech experience
- **Intermediate:** Some experience
- **Moderate:** Comfortable with tech, no coding experience
- **Expert:** Coding experience, 5+ hrs/day available

### Step 4 — Match to a Subnet & Teach
Based on their profile, guide the apprentice to a suitable subnet. Teaching must be **direct, personalized, and conversational** — not a generic wiki link.

**Example matches:**
- *"I have experience with jailbroken AI"* → Subnet 37 (Aurelius)
- *"I like bug bounty hunting"* → Subnet 100 (Platform)
- *"I want to rent out my gaming GPU"* → Subnet 51 (Ilium.io)

### Step 5 — Register the Apprenticeship
Once the apprentice is earning emissions, register the pairing on-chain and submit to the validator for LCS scoring.

---

## Installation

### Prerequisites

The following must be installed before running miner or validator software:

```bash
# Python 3.10 or higher
python3 --version

# pip
pip3 --version

# git
git --version

# Bittensor CLI
pip install bittensor

# Verify btcli installation
btcli --version
```

You will also need:
- A **Bittensor wallet** (coldkey + hotkey)
- **TAO** for subnet registration fees
- A registered hotkey on the TAO Apprentice subnet (netuid TBD — pending mainnet registration)

**Create a wallet if you don't have one:**
```bash
btcli wallet new_coldkey --wallet.name my_wallet
btcli wallet new_hotkey  --wallet.name my_wallet --wallet.hotkey my_hotkey
```

**Register on the subnet:**
```bash
btcli subnet register --netuid <TBD> --wallet.name my_wallet --wallet.hotkey my_hotkey
```

---

### Install Miner

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/tao-apprentice.git
cd tao-apprentice

# Install dependencies
pip install -r requirements.txt

# Or use the install script
bash install_miner.sh
```

---

### Install Validator

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/tao-apprentice.git
cd tao-apprentice

# Install dependencies
pip install -r requirements.txt

# Or use the install script
bash install_validator.sh
```

---

## Running

### Run Miner

```bash
python neurons/miner/miner.py \
  --netuid <TBD> \
  --wallet.name my_wallet \
  --wallet.hotkey my_hotkey \
  --subtensor.network finney \
  --logging.debug
```

Or use the shell script:
```bash
bash run_miner.sh --wallet.name my_wallet --wallet.hotkey my_hotkey
```

### Run Validator

```bash
python neurons/validator/validator.py \
  --netuid <TBD> \
  --wallet.name my_wallet \
  --wallet.hotkey my_hotkey \
  --subtensor.network finney \
  --logging.debug
```

Or use the shell script:
```bash
bash run_validator.sh --wallet.name my_wallet --wallet.hotkey my_hotkey
```

---

## Minimum Compute Requirements

See [`min_compute.yml`](./min_compute.yml) for the full specification.

| Role | CPU | RAM | Storage | GPU | Network |
|---|---|---|---|---|---|
| Miner | 4 cores | 8 GB | 100 GB SSD | Not required | 25 Mbps |
| Validator | 8 cores | 16 GB | 200 GB SSD | Not required | 100 Mbps |

> This subnet is intentionally designed to be **accessible without GPU requirements** for miners. The work is mentorship, not computation.

---

## Technical & Intellectual Considerations

Some subnets are more challenging to teach than others and carry higher earning potential for experienced mentors. For example, **Subnet 37 (Aurelius)** is philosophical in nature and requires a particularly well-matched apprentice — but a miner who finds that match stands to earn substantially more than one teaching a simpler subnet.

**Sybil resistance is the primary technical challenge.** The validator watchdog role is the right approach, but the final implementation will need to get specific about what "proof of distinct personhood" looks like on-chain. Wallet age, cross-referencing on-chain activity across subnets, and off-chain identity proofs (GitHub, X, Discord) all help but none are individually sufficient. Consultation with identity-focused subnet teams is strongly recommended before mainnet launch.

---

## Personal Statement

*For someone who doesn't come from a tech background, I know firsthand how confusing and challenging navigating this AI/crypto space can be. I come from a writing and art background — specifically, a degree in Broadcasting (Film) with a minor in Journalism from the University of Central Michigan.*

*I believe for this ecosystem to truly succeed it needs teachers and students, as well as people willing to commit time to individualized attention — helping others one-on-one to teach what they've learned.*

*— Santideva • [@Tek_Savvy](https://x.com/Tek_Savvy)*

---

## License

[MIT License](./LICENSE) — © 2025 Santideva / @Tek_Savvy

---

*Thank you for reading the TAO Apprentice Subnet Proposition. I love the Bittensor community and am grateful for this incredible moment in AI and decentralization.*
