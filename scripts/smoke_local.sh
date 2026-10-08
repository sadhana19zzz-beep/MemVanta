#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build-smoke"

echo "== MemVanta local smoke test =="

echo "[1/4] Configuring Release build..."
cmake -S "${ROOT_DIR}" -B "${BUILD_DIR}" -DCMAKE_BUILD_TYPE=Release

echo "[2/4] Building MemVanta..."
cmake --build "${BUILD_DIR}" -j

echo "[3/4] Running tests..."
ctest --test-dir "${BUILD_DIR}" --output-on-failure

echo "[4/4] Checking the MemVanta executable..."
"${BUILD_DIR}/memvanta" 2>&1 | grep -q "memvanta run"

echo
echo "Smoke test completed successfully."
echo "Build directory: ${BUILD_DIR}"
echo "No external model download was required."
