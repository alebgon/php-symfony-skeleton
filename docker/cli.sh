#!/usr/bin/env bash

# Fail on error, undeclared variable substitution, pipe error
set -Eeuo pipefail

method="$1"
shift

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export DOCKER_COMPOSE="docker compose -f $SCRIPT_DIR/docker-compose.yaml"

bash() {
  ${DOCKER_COMPOSE} exec -it php-fpm bash
}

composer() {
  ${DOCKER_COMPOSE} run composer composer "$@"
  ${DOCKER_COMPOSE} down composer --remove-orphans -v --rmi local
}

console() {
  ${DOCKER_COMPOSE} run --rm php-cli php bin/console "$@"
}

console-xdebug() {
  ${DOCKER_COMPOSE} run php-cli-xdebug php bin/console "$@"
  ${DOCKER_COMPOSE} down php-cli-xdebug --remove-orphans -v --rmi local
}

test() {
  ${DOCKER_COMPOSE} run --build --rm php-cli-test vendor/bin/phpunit -d memory_limit=-1 "$@"
  echo $?
  ${DOCKER_COMPOSE} down php-cli-test --remove-orphans -v --rmi local
}

test-coverage() {
  ${DOCKER_COMPOSE} run php-cli-test-coverage vendor/bin/phpunit -d memory_limit=-1 --coverage-html build/coverage/html
  ${DOCKER_COMPOSE} down php-cli-test-coverage --remove-orphans -v --rmi local
}

test-xdebug() {
  ${DOCKER_COMPOSE} run --build --rm php-cli-test-xdebug vendor/bin/phpunit -d memory_limit=-1 "$@"
  echo $?
  ${DOCKER_COMPOSE} down php-cli-test-xdebug --remove-orphans -v --rmi local
}

logs() {
  CONTAINER_ID=$(${DOCKER_COMPOSE} ps -q php-fpm)
  docker logs -f ${CONTAINER_ID}
}

up() {
  ${DOCKER_COMPOSE} up --build nginx -d
}

down() {
  ${DOCKER_COMPOSE} down --remove-orphans -v --rmi local
}

start() {
  ${DOCKER_COMPOSE} up -d
}

stop() {
  ${DOCKER_COMPOSE} stop "$@"
}

restart() {
    ${DOCKER_COMPOSE} down
    ${DOCKER_COMPOSE} up -d
}

build() {
  docker build --no-cache --platform="$3" -f "$SCRIPT_DIR/$4" -t "$1:$2" "$SCRIPT_DIR/../"
}

docker-save() {
  docker save -o "$1" $2:$3
}

docker-load() {
  docker load -i "$1"
}

push() {
  docker push "$1:$2"
}

create-manifest() {
  docker manifest create "$1:$2" --amend "$1:$2"_linux.amd64 --amend "$1:$2"_linux.arm64
}

push-manifest() {
  docker manifest push --purge "$1:$2"
}

case "$method" in
  setup)
    composer install -n --no-scripts
    console migrate
    composer install -n
    ;;
  bash)
    bash
    ;;
  composer)
    composer "$@"
    ;;
  console)
    console "$@"
    ;;
  console-xdebug)
    console-xdebug "$@"
    ;;
  test)
    test "$@"
    ;;
  test-coverage)
    test-coverage "$@"
    ;;
  test-xdebug)
    test-xdebug "$@"
    ;;
  logs)
    logs "$@"
    ;;
  up)
    up "$@"
    ;;
  rebuild)
    up "$@"
    ;;
  down)
    down "$@"
    ;;
  start)
    start "$@"
    ;;
  stop)
    stop "$@"
    ;;
  restart)
    restart "$@"
    ;;
  build)
    build "$@"
    ;;
  docker-save)
    docker-save "$@"
    ;;
  docker-load)
    docker-load "$@"
    ;;
  push)
    push "$@"
    ;;
  create-manifest)
    create-manifest "$@"
    ;;
  push-manifest)
    push-manifest "$@"
    ;;
  *)
    echo "You must provide a method to execute [bash, composer, rector, csfixer, console, console-xdebug, test, test-coverage, test-xdebug, up, down, start, stop, restart, build, docker-save, docker-load, push, create-manifest, push-manifest]"
esac