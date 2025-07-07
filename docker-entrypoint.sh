#!/bin/sh
set -e

# Determine config file location (use current directory if /app doesn't exist)
CONFIG_FILE="/app/config.json"
if [ ! -d "/app" ]; then
    CONFIG_FILE="./config.json"
fi

# Generate config.json from environment variables
cat > "$CONFIG_FILE" << EOF
{
  "port": "${COCE_PORT:-8080}",
  "providers": [$(echo "${COCE_PROVIDERS:-gb,aws,ol}" | sed 's/,/","/g' | sed 's/^/"/' | sed 's/$/"/')],
  "timeout": ${COCE_TIMEOUT:-8000},
  "redis": {
    "host": "${REDIS_HOST:-redis}",
    "port": ${REDIS_PORT:-6379},
    "timeout": ${REDIS_TIMEOUT:-5000}
  },
  "cache": {
    "path": "${COCE_CACHE_PATH:-/app/covers}",
    "url": "${COCE_CACHE_URL:-http://localhost:8080/covers}"
  },
  "gb": {
    "timeout": ${COCE_GB_TIMEOUT:-86400}
  },
  "aws": {
    "timeout": ${COCE_AWS_TIMEOUT:-86400},
    "imageSize": "${COCE_AWS_IMAGE_SIZE:-MediumImage}"
  },
  "ol": {
    "timeout": ${COCE_OL_TIMEOUT:-86400},
    "imageSize": "${COCE_OL_IMAGE_SIZE:-medium}"
  },
  "orb": {
    "timeout": ${COCE_ORB_TIMEOUT:-86400},
    "user": "${COCE_ORB_USER:-}",
    "key": "${COCE_ORB_KEY:-}",
    "cache": ${COCE_ORB_CACHE:-true}
  }
}
EOF

echo "Generated config at $CONFIG_FILE:"
cat "$CONFIG_FILE"

# Execute the main command
exec "$@"
