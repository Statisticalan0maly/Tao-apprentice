#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# TAO Apprentice — Miner Installation Script
# ─────────────────────────────────────────────────────────────────────────────
set -e

echo "=============================================="
echo "  TAO Apprentice — Miner Setup"
echo "=============================================="
echo ""

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
REQUIRED="3.10"
echo "[1/5] Checking Python version... $PYTHON_VERSION"
if python3 -c "import sys; exit(0 if sys.version_info >= (3,10) else 1)"; then
    echo "      ✓ Python $PYTHON_VERSION OK"
else
    echo "      ✗ Python 3.10+ required. Current: $PYTHON_VERSION"
    exit 1
fi

# Check pip
echo "[2/5] Checking pip..."
pip3 --version > /dev/null 2>&1 && echo "      ✓ pip found" || { echo "      ✗ pip not found. Install pip first."; exit 1; }

# Install dependencies
echo "[3/5] Installing Python dependencies..."
pip3 install -r requirements.txt
echo "      ✓ Dependencies installed"

# Check btcli
echo "[4/5] Checking Bittensor CLI..."
if command -v btcli &> /dev/null; then
    BTCLI_VERSION=$(btcli --version 2>&1)
    echo "      ✓ btcli found: $BTCLI_VERSION"
else
    echo "      btcli not found. Installing bittensor..."
    pip3 install bittensor
    echo "      ✓ bittensor installed"
fi

# Run setup.py
echo "[5/5] Installing tao-apprentice package..."
pip3 install -e .
echo "      ✓ Package installed"

echo ""
echo "=============================================="
echo "  Installation complete!"
echo ""
echo "  Next steps:"
echo "  1. Create a wallet (if you haven't):"
echo "     btcli wallet new_coldkey --wallet.name my_wallet"
echo "     btcli wallet new_hotkey  --wallet.name my_wallet --wallet.hotkey my_hotkey"
echo ""
echo "  2. Register on the subnet (netuid TBD):"
echo "     btcli subnet register --netuid <TBD> --wallet.name my_wallet --wallet.hotkey my_hotkey"
echo ""
echo "  3. Run the miner:"
echo "     bash run_miner.sh --wallet.name my_wallet --wallet.hotkey my_hotkey"
echo "=============================================="
