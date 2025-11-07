#!/bin/bash
set -euo pipefail

PROJECT_DIR=/home/vagrant/django_git/mysite
REPO_URL=https://github.com/gildoong/django_test.git
BRANCH=main   # 또는 master

echo "[1] Clean old deployment directory..."
rm -rf ${PROJECT_DIR}
mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}

echo "[2] Clone latest repository..."
git clone -b ${BRANCH} ${REPO_URL} .

echo "[3] Setup Python virtual environment..."
python3 -m venv venv || true
source venv/bin/activate

pip install --upgrade pip
pip install -r mysite/requirements.txt

echo "[4] Run Django setup steps..."
cd mysite  # 🔥 핵심 수정: manage.py가 여기 있음

python3 manage.py makemigrations --noinput
python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput

echo "[5] Restart runserver..."
pkill -f "manage.py runserver" || true
nohup python3 manage.py runserver 0.0.0.0:8000 > /var/log/pybo_run.log 2>&1 &

echo "✅ DEPLOY_OK $(date)"

