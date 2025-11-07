#!/bin/bash
set -euo pipefail

PROJECT_DIR=/home/vagrant/django_test/mysite
REPO_URL=https://github.com/gildoong/django_test.git
BRANCH=main

echo "[1] Cleaning and cloning project..."
rm -rf "${PROJECT_DIR}"
mkdir -p "${PROJECT_DIR}"
cd "${PROJECT_DIR}"

git clone -b "${BRANCH}" "${REPO_URL}" .
echo "✅ Repository cloned."

echo "[2] Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "[3] Running Django migrations..."
python3 manage.py makemigrations --noinput
python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput

echo "[4] Restarting Django server..."
pkill -f "manage.py runserver" || true
nohup python3 manage.py runserver 0.0.0.0:8000 > ~/pybo_run.log 2>&1 &

echo "✅ DEPLOY_OK $(date)"

