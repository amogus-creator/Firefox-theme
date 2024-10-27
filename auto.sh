#! /usr/bin/env bash

set -Eeo pipefail

readonly REPO_DIR="$(dirname "$(readlink -m "${0}")")"
MY_USERNAME="${SUDO_USER:-$(logname 2> /dev/null || echo "${USER}")}"
MY_HOME=$(getent passwd "${MY_USERNAME}" | cut -d: -f6)

THEME_NAME="WhiteSur"
SRC_DIR="${REPO_DIR}/src"

# Firefox
FIREFOX_DIR_HOME="${MY_HOME}/.mozilla/firefox"
FIREFOX_THEME_DIR="${MY_HOME}/.mozilla/firefox/firefox-themes"

# Создание каталогов
mkdir -p "${FIREFOX_THEME_DIR}"

# Установка темы
install_firefox_theme() {
  local target="${FIREFOX_THEME_DIR}"

  echo "Установка темы '${THEME_NAME}' для Firefox..."

  mkdir -p "${target}"
  cp -rf "${SRC_DIR}/${THEME_NAME}" "${target}"
  cp -rf "${SRC_DIR}/customChrome.css" "${target}"
  cp -rf "${SRC_DIR}/userChrome-${THEME_NAME}.css" "${target}/userChrome.css"
  cp -rf "${SRC_DIR}/userContent-${THEME_NAME}.css" "${target}/userContent.css"

  echo "Тема '${THEME_NAME}' успешно установлена."
}

# Установка темы
install_firefox_theme
