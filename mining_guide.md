# Mining Guide — TAO Apprentice

> A complete walkthrough for miners (mentors) on TAO Apprentice subnet.

---

## Who Should Mine This Subnet?

This subnet is designed for **experienced Bittensor participants** who want to grow the ecosystem by teaching others. You are a good candidate if:

- You have been active in Bittensor for 3+ years.
- You have previously earned alpha emissions from at least one other subnet.
- You are comfortable with macOS, Windows, or Linux environments.
- You have time and patience to teach someone one-on-one.
- You understand the majority of active Bittensor subnets well enough to recommend one to a newcomer.

---

## Step 1 — Find an Apprentice

Your first job is to find a **real, motivated human being** who wants to mine Bittensor but doesn't know how. Good places to look:

- Bittensor Discord server (newcomers asking questions)
- X / Twitter (people asking about TAO or dTAO)
- Reddit communities (`r/bittensor`, `r/MachineLearning`)
- Local crypto or AI meetups
- Personal network

**Verification requirements:**
- GitHub account (check for real activity, not freshly created)
- X / Twitter account
- Discord account
- Working email address
- Ideally some prior on-chain wallet activity anywhere

> You are responsible for the legitimacy of your apprentice. If a validator scores your pair as suspected sybil, **your payouts are suspended**.

---

## Step 2 — Assess Their Computational Setup

Before recommending a subnet, understand what your apprentice is working with:

**Hardware checklist:**
- [ ] CPU — number of cores, speed
- [ ] RAM — total GB
- [ ] GPU — model, VRAM (if any)
- [ ] Storage — available GB
- [ ] Operating System — macOS / Windows / Linux (which distro?)
- [ ] Internet speed — upload and download Mbps
- [ ] Monthly energy budget — rough estimate of electricity cost

**Time availability:**
- How many hours per day can they dedicate?
- Are they comfortable leaving a machine running overnight?

---

## Step 3 — Assess Their Technical Background

Be honest about this assessment — a bad match hurts both of you.

| Level | Description | Good Subnet Candidates |
|---|---|---|
| **Beginner / Novice** | Little to no tech experience | Subnets with simple setup, good documentation, GUI tools |
| **Intermediate** | Some tech experience, comfortable with terminals | Most standard mining subnets |
| **Moderate** | Comfortable with tech, no coding experience | Subnets that require configuration but not development |
| **Expert** | Coding experience, 5+ hrs/day available | Any subnet including complex or philosophical ones |

---

## Step 4 — Match Them to a Subnet

**Example matches:**

| Apprentice says... | Recommended subnet |
|---|---|
| "I have experience using jailbroken AI / prompt injection" | Subnet 37 — Aurelius |
| "I like bug bounty hunting / security research" | Subnet 100 — Platform |
| "I want to rent out my old gaming GPU" | Subnet 51 — Ilium.io |
| "I want to run inference for AI models" | Various inference subnets |
| "I have a fast internet connection and extra bandwidth" | Various data subnets |

---

## Step 5 — Teach Them

This is the most important step. **Generic instructions are not enough.**

Your teaching must be:
- **Personalized** — tailored to their hardware, OS, and skill level
- **Conversational** — back-and-forth dialogue, not a one-way dump of links
- **Patient** — this process can take hours or days

Acceptable communication methods:
- Discord DMs or voice chat
- X / Twitter DMs
- Email
- FaceTime / WhatsApp / Zoom
- How-to videos (screen recordings)
- Any other method agreed upon by both parties

**What you must cover:**
1. Creating and securing a Bittensor wallet (coldkey + hotkey)
2. Installing the Bittensor CLI (`btcli`)
3. Registering on their target subnet
4. Installing and configuring their miner software
5. Starting the miner and confirming it is receiving queries
6. Monitoring emissions and understanding the dashboard

---

## Step 6 — Register the Apprenticeship On-Chain

Once your apprentice is actively mining and earning emissions, register the pairing:

```bash
# Register an apprentice (hypothetical CLI — pending implementation)
btcli tao-apprentice register \
  --miner.hotkey  YOUR_HOTKEY \
  --apprentice.coldkey APPRENTICE_COLDKEY \
  --apprentice.subnet TARGET_SUBNET_NETUID \
  --wallet.name my_wallet
```

The validator will begin scoring your pair at the next epoch boundary.

---

## Step 7 — Maintain the Relationship

Payouts increase over time only if your apprentice **keeps mining**. If they go dormant, your `activity_score` drops and your LCS may fall below the payout threshold.

Stay in touch. Answer their questions. Help them troubleshoot. That's the job.

---

## Managing Multiple Apprentices

You may have up to **5 active apprentices at once**. To maximize your rewards:

- Spread your apprentices across **different subnets** to earn the Subnet Diversity Bonus (up to +12%).
- Don't take on more apprentices than you can genuinely support — quality of mentorship directly affects your LCS score.
- After each 180-day apprenticeship closes, find a new apprentice. The subnet is designed to reward continuous recruitment.

---

## Reward Summary

Your total epoch reward is:

```
final_reward =
  [ SUM( TER(t_i) * alpha_i * R(alpha_Xi -> TAO) * R(TAO -> alpha_THIS) ) ]
  * (1 + SDB(D))
  * LCS
```

See [`docs/incentive_mechanism.md`](./incentive_mechanism.md) for full formula documentation.
