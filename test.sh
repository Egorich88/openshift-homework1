#!/bin/sh

set -e

buildFrontend() {
  ./backend/gradlew clean build -p backend
  DOCKER_BUILDKIT=1 docker build -f frontend.Dockerfile frontend/ --tag frontend:v1.0-"$STUDENT_LABEL"
}

buildBackend() {
  ./backend/gradlew clean build -p backend
  DOCKER_BUILDKIT=1 docker build -f backend.Dockerfile backend/ --tag backend:v1.0-"$STUDENT_LABEL"
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
    frontend-"$STUDENT_LABEL" \
    curl -s http://backend-"$STUDENT_LABEL":8080/api/v1/public/items > /tmp/result-"$STUDENT_LABEL"

    if [ "$(cat /tmp/result-"$STUDENT_LABEL")" != "[]" ]; then 
      echo "Не прошло проверку"
      exit 1
    fi
}

BASE_LABEL=homework1
# TODO student surname name
STUDENT_LABEL=egorich88

echo "=== Создаем серверную часть backend:v1.0-"$STUDENT_LABEL" ==="
buildBackend

echo "=== Создаем интерфейс frontend:v1.0-"$STUDENT_LABEL" ==="
buildFrontend

echo "=== Создать сети между серверной части <-> postgres и черверной части <-> интерфейсом ==="
createNetworks

echo "=== Создаем постоянный том для postgres ==="
createVolume

echo "== Запуск Postgres ==="
runPostgres

echo "=== Запуск backend backend:v1.0-"$STUDENT_LABEL" ==="
runBackend

echo "=== Запуск frontend frontend:v1.0-"$STUDENT_LABEL" ==="
runFrontend

echo "=== Проверка запущена ==="
checkResult
