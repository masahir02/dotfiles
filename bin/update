#!/usr/bin/env zsh

source ~/.zshrc

brew update
brew upgrade
brew bundle --global
brew cleanup --prune=all
brew bundle cleanup --force --global

gibo update

gcloud components update --quiet

asdf plugin update --all

zinit self-update
zinit update --all --quiet

nvim --headless "+Lazy! sync" +MasonUpdate +qa
