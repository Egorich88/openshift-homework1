#!/bin/sh

set -e
e
buildFrontend() {
  ./backend/gradlew clean build -p backend
  DOCKER_BUILDKIT=1 docker build -f frontend.Dockerfile frontend/ --tag frontend:v1.0-egorich88
}

buildBackend() {
  ./backend/gradlew clean build -p backend
  DOCKER_BUILDKIT=1 docker build -f backend.Dockerfile backend/ --tag backend:v1.0-egorich88
}

createNetworks() {
  echo "Создаем сеть докера"
}

createVolume() {
  echo "Создаем "звук" докера для Посгреса"
}

runPostgres() {
  echo "Запуск докера Посгреса"
}

runBackend() {
  echo "Запуск докера серверной части"
}

runFrontend() {
  echo "Запуск интерфейса докера"
}

checkResult() {
  sleep 10
  docker exec \
    frontend-egorich88 \
    curl -s http://backend-egorich88:8080/api/v1/public/items > /tmp/result-egorich88

    if [ "$(cat /tmp/result-egorich88)" != "[]" ]; then
      echo "Не прошло проверку"
      exit 1
    fi
}

BASE_LABEL=homework1
# TODO student surname name
STUDENT_LABEL=egorich88

echo "=== Создаем серверную часть backend:v1.0-egorich88 ==="
buildBackend

echo "=== Создаем интерфейс frontend:v1.0-egorich88 ==="
buildFrontend

echo "=== Создать сети между серверной части <-> postgres и черверной части <-> интерфейсом ==="
createNetworks

echo "=== Создаем постоянный том для postgres ==="
createVolume

echo "== Запуск Postgres ==="
runPostgres

echo "=== Запуск backend backend:v1.0-egorich88 ==="
runBackend

echo "=== Запуск frontend frontend:v1.0-egorich88 ==="
runFrontend

echo "=== Проверка запущена ==="
checkResult
