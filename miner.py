"""
TAO Apprentice — Miner Neuron (Theoretical Stub)

This is a placeholder implementation for the TAO Apprentice miner.
Full implementation is pending mainnet subnet registration and community development.

The miner's role on this subnet is mentorship, not computation.
The primary software responsibilities are:
  - Registering apprenticeship pairs on-chain
  - Submitting identity proof hashes for validator scoring
  - Responding to validator queries about active apprenticeships
"""

import bittensor as bt
import argparse


def get_config():
    parser = argparse.ArgumentParser()
    parser.add_argument("--netuid",              type=int,   default=1)
    parser.add_argument("--wallet.name",         type=str,   default="default")
    parser.add_argument("--wallet.hotkey",       type=str,   default="default")
    parser.add_argument("--subtensor.network",   type=str,   default="finney")
    parser.add_argument("--logging.debug",       action="store_true")
    bt.subtensor.add_args(parser)
    bt.logging.add_args(parser)
    bt.wallet.add_args(parser)
    bt.axon.add_args(parser)
    config = bt.config(parser)
    return config


def main():
    config = get_config()
    bt.logging(config=config)
    bt.logging.info("TAO Apprentice Miner starting...")

    wallet    = bt.wallet(config=config)
    subtensor = bt.subtensor(config=config)
    metagraph = subtensor.metagraph(config.netuid)

    bt.logging.info(f"Wallet:    {wallet}")
    bt.logging.info(f"Subtensor: {subtensor}")
    bt.logging.info(f"Metagraph: {metagraph}")
    bt.logging.info("Miner stub running. Full implementation pending.")

    # TODO: Implement apprenticeship registration protocol
    # TODO: Implement validator query handler
    # TODO: Implement on-chain identity proof submission


if __name__ == "__main__":
    main()
