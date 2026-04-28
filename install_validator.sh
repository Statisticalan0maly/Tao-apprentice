#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# TAO Apprentice — Validator Installation Script
# ─────────────────────────────────────────────────────────────────────────────
set -e

echo "=============================================="
echo "  TAO Apprentice — Validator Setup"
echo "=============================================="
echo ""

echo "[1/5] Checking Python version..."
if python3 -c "import sys; exit(0 if sys.version_info >= (3,10) else 1)"; then
    echo "      ✓ Python OK"
else
    echo "      ✗ Python 3.10+ required."
    exit 1
fi

echo "[2/5] Checking pip..."
pip3 --version > /dev/null 2>&1 && echo "      ✓ pip found" || { echo "      ✗ pip not found."; exit 1; }

echo "[3/5] Installing Python dependencies..."
pip3 install -r requirements.txt
echo "      ✓ Dependencies installed"

echo "[4/5] Checking Bittensor CLI..."
if command -v btcli &> /dev/null; then
    echo "      ✓ btcli found"
else
    echo "      Installing bittensor..."
    pip3 install bittensor
    echo "      ✓ bittensor installed"
fi

echo "[5/5] Installing tao-apprentice package..."
pip3 install -e .
echo "      ✓ Package installed"

echo ""
echo "=============================================="
echo "  Validator installation complete!"
echo ""
echo "  Next steps:"
echo "  1. Register on the subnet (netuid TBD):"
echo "     btcli subnet register --netuid <TBD> --wallet.name my_wallet --wallet.hotkey my_hotkey"
echo ""
echo "  2. Ensure sufficient TAO stake for validation."
echo ""
echo "  3. Run the validator:"
echo "     bash run_validator.sh --wallet.name my_wallet --wallet.hotkey my_hotkey"
echo "=============================================="
