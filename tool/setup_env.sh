#!/usr/bin/env bash
# Installs the Flutter SDK this project needs and fetches dependencies.
#
# The sandbox this project is developed in ships without Flutter or Dart, and
# the scratchpad is wiped between sessions, so a fresh session has to do this
# once before it can analyze, test or run the data report.
#
# Usage:
#   source tool/setup_env.sh          # keeps PATH in the current shell
#   eval "$(tool/setup_env.sh --path)" # print the export line only
#
# Idempotent: skips the download when the SDK is already unpacked.

set -euo pipefail

# 3.32.5 is required: 3.24.x cannot resolve the pinned intl 0.20.2.
FLUTTER_VERSION="3.32.5"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

# Prefer the session scratchpad; fall back to /tmp when it is not set.
INSTALL_ROOT="${FLUTTER_INSTALL_ROOT:-${SCRATCHPAD:-/tmp/nutri-guide-sdk}}"
FLUTTER_DIR="${INSTALL_ROOT}/flutter"

if [ "${1:-}" = "--path" ]; then
  echo "export PATH=\"${FLUTTER_DIR}/bin:\$PATH\""
  exit 0
fi

mkdir -p "${INSTALL_ROOT}"

if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  echo "Downloading Flutter ${FLUTTER_VERSION} into ${INSTALL_ROOT} ..."
  curl -sSL -o "${INSTALL_ROOT}/flutter.tar.xz" "${FLUTTER_URL}"
  tar xf "${INSTALL_ROOT}/flutter.tar.xz" -C "${INSTALL_ROOT}"
  rm -f "${INSTALL_ROOT}/flutter.tar.xz"
else
  echo "Flutter already present at ${FLUTTER_DIR}"
fi

# The SDK ships as a git checkout; without this the tool refuses to run when
# the directory is owned by a different user than the one invoking it.
git config --global --add safe.directory "${FLUTTER_DIR}" 2>/dev/null || true

export PATH="${FLUTTER_DIR}/bin:${PATH}"

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
cd "${PROJECT_DIR}"
flutter pub get

cat <<EOF

Ready. If you ran this without 'source', add the SDK to PATH yourself:

  export PATH="${FLUTTER_DIR}/bin:\$PATH"

Then verify:
  flutter analyze
  flutter test
  dart run tool/data_report.dart --strict
EOF
