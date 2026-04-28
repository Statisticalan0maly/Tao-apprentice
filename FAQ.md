# FAQ — TAO Apprentice

---

**Q: Is this subnet live on mainnet?**

A: Not yet. This is a theoretical specification and pre-registration proposal. The goal is to present the concept professionally to the Bittensor community and potential investors before pursuing mainnet registration.

---

**Q: What subnet number will TAO Apprentice use?**

A: Netuid is TBD — pending community review, feedback, and mainnet registration.

---

**Q: Do I need a GPU to mine this subnet?**

A: No. This subnet does not require any GPU. The work is mentorship, not computation. The minimum hardware requirement is a computer with 8 GB RAM and a stable internet connection.

---

**Q: What counts as a valid apprentice?**

A: A real human being with verifiable online presence (GitHub, X, Discord, email) who has little to no prior Bittensor mining experience, and who goes on to actively earn alpha emissions from a different Bittensor subnet under your guidance.

---

**Q: Can I register a friend who already mines Bittensor?**

A: No. Apprentices must have little to no previous mining experience on Bittensor. Existing miners do not qualify.

---

**Q: What happens after 180 days?**

A: The apprenticeship closes automatically. You may then begin a new apprenticeship with a different person. The 180-day cap is intentional — it prevents permanent passive income and keeps miners actively recruiting and teaching.

---

**Q: What if my apprentice stops mining after a few weeks?**

A: Your `activity_score` for that pair drops, reducing your LCS. If the LCS falls below 0.50, payouts for that pair are suspended. You have an ongoing incentive to support your apprentice's success.

---

**Q: Can I have apprentices mining the same subnet?**

A: Yes, but you will earn a higher Subnet Diversity Bonus (SDB) if your apprentices mine different subnets. 5 apprentices on 5 different subnets earns a +12% bonus vs. +1% for all on the same subnet.

---

**Q: How are conversions from alpha to TAO calculated?**

A: At the end of each 30-day pay period, validators snapshot the on-chain spot rate of the apprentice's subnet alpha to TAO, and the spot rate of TAO to this subnet's alpha. Both rates are verifiable on-chain. See [`docs/incentive_mechanism.md`](./docs/incentive_mechanism.md) for the full pipeline.

---

**Q: What if a validator falsely flags my pair?**

A: The dispute mechanism is TBD and will be formalized before mainnet launch. Flags will be logged on-chain with the LCS score breakdown, so miners can review the specific component that dropped below threshold.

---

**Q: Where can I discuss this proposal?**

A: Reach out on Discord (Santideva) or X [@Tek_Savvy](https://x.com/Tek_Savvy).
