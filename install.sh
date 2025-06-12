#!/bin/bash

set -e

# Цвета
GREEN="\033[0;32m"
RESET="\033[0m"

echo -e "${GREEN}🔧 Установка Zsh и Oh My Zsh...${RESET}"

# 1. Установка Zsh (если не установлен)
if ! command -v zsh &> /dev/null; then
  echo -e "${GREEN}📦 Устанавливаем zsh...${RESET}"
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update && sudo apt install -y zsh curl git
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install zsh
  else
    echo "❌ Неизвестная ОС. Установи Zsh вручную."
    exit 1
  fi
else
  echo -e "${GREEN}✅ Zsh уже установлен.${RESET}"
fi

# 2. Установка Oh My Zsh (если не установлен)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${GREEN}📥 Устанавливаем Oh My Zsh...${RESET}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo -e "${GREEN}✅ Oh My Zsh уже установлен.${RESET}"
fi

# 3. Путь к кастомным плагинам
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 4. Список плагинов
declare -A plugins=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
  [zsh-history-substring-search]="https://github.com/zsh-users/zsh-history-substring-search"
  [zsh-completions]="https://github.com/zsh-users/zsh-completions"
  [zsh-interactive-cd]="https://github.com/changyuheng/zsh-interactive-cd"
)

echo -e "${GREEN}🔌 Установка Zsh-плагинов...${RESET}"

for plugin in "${!plugins[@]}"; do
  plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
  repo_url="${plugins[$plugin]}"

  if [ -d "$plugin_dir" ]; then
    echo "🔁 $plugin уже установлен, обновляем..."
    git -C "$plugin_dir" pull
  else
    echo "📥 Устанавливаем $plugin..."
    git clone "$repo_url" "$plugin_dir"
  fi
done

# 5. Сделать zsh оболочкой по умолчанию
if [ "$SHELL" != "$(which zsh)" ]; then
  echo -e "${GREEN}🔄 Меняем оболочку на zsh по умолчанию...${RESET}"
  chsh -s "$(which zsh)"
fi

echo -e "${GREEN}✅ Установка завершена. Перезапусти терминал или введи 'zsh'.${RESET}"
