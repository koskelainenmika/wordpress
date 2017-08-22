#!/usr/bin/env bash

prompt_theme_installer() {
  read -r -p"==> Would you like to install the base theme? (y/N)" response
  case "$response" in
    [yY][eE][sS]|[yY])
      theme_installer
    ;;
  *)

    echo "Skipping base theme installation..."
  esac
}

theme_installer() {
  rootwd=$(pwd)
  read -r -p "==> Great! What name do you want to give to it? [A-Za-z0-9_] " themename
  read -r -p "==> And what is the repository URL?  (git@bitbucket...) " repo

  composer require vincit/wordpress-theme-base dev-master --prefer-source
  cd htdocs/wp-content/themes || exit 1
  mv wordpress-theme-base "$themename"
  cd "$themename" || exit 1

  # git remote remove composer
  git remote remove origin
  git remote add origin "$repo"

  recursive_replace "." "*" "wordpress-theme-base" "$themename"

  cd "$rootwd" || exit 1
  recursive_replace "$rootwd" "composer.json" "wordpress-theme-base" "$themename"

  echo "Theme generated. Assuming you provided a valid repository URL, you should be able to just push into it."
  echo "Remember to add it to Private Packagist or Composer will refuse to work: https://packagist.com/orgs/vincit/packages/add"
}
