#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# TAO Apprentice — Run Miner
# ─────────────────────────────────────────────────────────────────────────────

# Default values
NETUID=${NETUID:-"TBD"}
NETWORK=${NETWORK:-"finney"}
WALLET_NAME=${WALLET_NAME:-"default"}
WALLET_HOTKEY=${WALLET_HOTKEY:-"default"}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --netuid)            NETUID="$2"; shift ;;
        --wallet.name)       WALLET_NAME="$2"; shift ;;
        --wallet.hotkey)     WALLET_HOTKEY="$2"; shift ;;
        --subtensor.network) NETWORK="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

echo "Starting TAO Apprentice Miner..."
echo "  Network:    $NETWORK"
echo "  Netuid:     $NETUID"
echo "  Wallet:     $WALLET_NAME / $WALLET_HOTKEY"
echo ""

python3 neurons/miner/miner.py \
    --netuid "$NETUID" \
    --wallet.name "$WALLET_NAME" \
    --wallet.hotkey "$WALLET_HOTKEY" \
    --subtensor.network "$NETWORK" \
    --logging.debug
