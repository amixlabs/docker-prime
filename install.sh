#!/usr/bin/env bash

install_locales() {
  apt-get install -y locales
  locale-gen en_US.UTF-8
  update-locale LANG=en_US.UTF-8
}

install_apache() {
  local names=(
		apache2
    libapache2-mod-fcgid
	)
	apt-get install -y "${names[@]}"
}

install_php() {
  local names=(
    php-common
    php-curl
    php-fpm
    php-pgsql
    php-tidy
    php-xml
    php8.1-cli
    php8.1-common
    php8.1-curl
    php8.1-fpm
    php8.1-opcache
    php8.1-pgsql
    php8.1-readline
    php8.1-tidy
    php8.1-xml
  )
  apt-get install -y "${names[@]}"
}

install_node() {
  curl -fsSL https://deb.nodesource.com/setup_10.x | bash -
  apt-get install -y nodejs npm
}

clean() {
  apt-get dist-clean
  rm -rf /var/lib/apt/lists/*
}

main() {
  install_locales
  install_apache
  install_php
  install_node
  clean
}

main "$@"