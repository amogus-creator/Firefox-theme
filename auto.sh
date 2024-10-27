#!/usr/bin/env bash

set -Eeo pipefail

readonly REPO_DIR="$(dirname "$(readlink -m "${0}")")"
MY_USERNAME="${SUDO_USER:-$(logname 2> /dev/null || echo "${USER}")}"
MY_HOME=$(getent passwd "${MY_USERNAME}" | cut -d: -f6)

THEME_NAME="WhiteSur"
SRC_DIR="${REPO_DIR}/src"
FIREFOX_THEME_DIR="${MY_HOME}/.mozilla/firefox/firefox-themes"

# Загрузка и установка темы
download_and_install_theme() {
  echo "Загрузка темы ${THEME_NAME}..."
  git clone --depth 1 https://github.com/vinceliuice/WhiteSur-firefox-theme.git "${SRC_DIR}/${THEME_NAME}"

  install_firefox_theme "${FIREFOX_THEME_DIR}"
  echo "Тема '${THEME_NAME}' успешно установлена."
}

install_firefox_theme() {
  local target="${1}"
  mkdir -p "${target}"
  cp -rf "${SRC_DIR}/${THEME_NAME}" "${target}"
  cp -rf "${SRC_DIR}/${THEME_NAME}/customChrome.css" "${target}"
  cp -rf "${SRC_DIR}/${THEME_NAME}/userChrome-${THEME_NAME}.css" "${target}/userChrome.css"
  cp -rf "${SRC_DIR}/${THEME_NAME}/userContent-${THEME_NAME}.css" "${target}/userContent.css"
}

remove_firefox_theme() {
  rm -rf "${FIREFOX_THEME_DIR}/${THEME_NAME}"
  [[ -f "${FIREFOX_THEME_DIR}/customChrome.css" ]] && rm -f "${FIREFOX_THEME_DIR}/customChrome.css"
  [[ -f "${FIREFOX_THEME_DIR}/userChrome.css" ]] && rm -f "${FIREFOX_THEME_DIR}/userChrome.css"
}

# Создание директории для темы, если она не существует
mkdir -p "${SRC_DIR}"

# Установка темы по умолчанию
download_and_install_theme

# Если передан параметр для удаления
if [[ "$1" == "-r" || "$1" == "--remove" ]]; then
  remove_firefox_theme
  echo "Тема '${THEME_NAME}' успешно удалена."
fi
