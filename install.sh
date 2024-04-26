#/bin/bash
set -euo pipefail
cd $(dirname $0)

cd /opt/gmt
export GMT_GLOBAL=`pwd`
export GMT_LOCAL=`pwd`
source $GMT_GLOBAL/bin/gmt_env.sh

python -m venv python_modules --prompt gmt

source $GMT_GLOBAL/bin/gmt_env.sh
npm install --no-audit --progress=false
pip install -r requirements.txt -r requirements-dev.txt
