#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build-smoke"
FIXTURE="$(mktemp "${TMPDIR:-/tmp}/memvanta-smoke.XXXXXX.gguf")"

cleanup() {
    rm -f "${FIXTURE}"
}

trap cleanup EXIT

echo "== MemVanta local smoke test =="

echo "[1/5] Configuring Release build..."
cmake -S "${ROOT_DIR}" -B "${BUILD_DIR}" -DCMAKE_BUILD_TYPE=Release

echo "[2/5] Building MemVanta..."
cmake --build "${BUILD_DIR}" -j

echo "[3/5] Running tests..."
ctest --test-dir "${BUILD_DIR}" --output-on-failure

echo "[4/5] Creating a tiny local GGUF fixture..."
python3 "${ROOT_DIR}/scripts/make_tiny_gguf.py" "${FIXTURE}"

echo "[5/5] Running the streaming runtime..."
"${BUILD_DIR}/memvanta" run "${FIXTURE}" --passes 1

echo
echo "Smoke test completed successfully."
echo "No network access or external model download was required."
