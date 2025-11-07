#!/bin/bash
set -euo pipefail

PROJECT_DIR=/home/vagrant/django_git/mysite
REPO_URL=https://github.com/gildoong/django_test.git
BRANCH=main

echo "[1] Clone latest repository..."
if [ ! -d "${PROJECT_DIR}" ]; then
  mkdir -p ${PROJECT_DIR}
  git clone -b ${BRANCH} ${REPO_URL} ${PROJECT_DIR}
else
  cd ${PROJECT_DIR}
  git fetch origin
  git reset --hard origin/${BRANCH}
fi

cd ${PROJECT_DIR}/mysite

echo "[2] Setup Python virtual environment..."
python3 -m venv venv || true
source venv/bin/activate

pip install --upgrade pip
pip install -r mysite/requirements.txt

echo "[3] Run Django setup steps..."
python3 manage.py makemigrations --noinput
python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput

echo "[4] Restart runserver..."
pkill -f "manage.py runserver" || true
nohup python3 manage.py runserver 0.0.0.0:8000 > ~/pybo_run.log 2>&1 &

echo "✅ DEPLOY_OK $(date)"

