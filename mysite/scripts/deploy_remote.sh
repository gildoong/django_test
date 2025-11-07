#!/bin/bash
set -euo pipefail

PROJECT_DIR=/home/vagrant/django_git/mysite
REPO_URL=https://github.com/gildoong/django_test.git
BRANCH=main

echo "[1] Cloning repository..."
if [ -d "${PROJECT_DIR}" ]; then
  rm -rf "${PROJECT_DIR}"
fi

mkdir -p "${PROJECT_DIR}"
cd "${PROJECT_DIR}"

git clone -b "${BRANCH}" "${REPO_URL}" .
echo "✅ Repository cloned successfully."

echo "[2] Setting up Python virtual environment..."
python3 -m venv venv || true
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "[3] Running Django migrations and static collection..."
python3 manage.py makemigrations --noinput
python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput

echo "[4] Restarting Django runserver..."
# 이전 프로세스 종료
pkill -f "manage.py runserver" || true
# 새로운 프로세스 실행 (로그 경로를 홈 디렉토리로)
nohup python3 manage.py runserver 0.0.0.0:8000 > ~/pybo_run.log 2>&1 &

echo "✅ DEPLOY_OK $(date)"

