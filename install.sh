#!/usr/bin/env bash
set -e

# ------ ОБНОВЛЁННЫЙ install.sh ------

# Установка Zsh, Oh My Zsh, плагинов и eza

echo "🔧 Проверка и установка zsh..."
if ! command -v zsh &>/dev/null; then
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update
    sudo apt install -y zsh curl git
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install zsh curl git
  else
    echo "❌ Не удалось определить ОС для установки zsh."
    exit 1
  fi
fi

echo "🔧 Проверка и установка eza (modern ls)..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if ! command -v eza &>/dev/null; then
    sudo apt update
    sudo apt install -y eza || echo "⚠️ Пакет eza недоступен, установи вручную."
  else
    echo "✅ eza уже установлен."
  fi
fi

echo "🔧 Установка Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "🔌 Установка плагинов..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
declare -A plugins=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
  [zsh-history-substring-search]="https://github.com/zsh-users/zsh-history-substring-search"
  [zsh-completions]="https://github.com/zsh-users/zsh-completions"
  [zsh-interactive-cd]="https://github.com/changyuheng/zsh-interactive-cd"
)
for plugin in "${!plugins[@]}"; do
  dir="$ZSH_CUSTOM/plugins/$plugin"
  if [ -d "$dir" ]; then
    git -C "$dir" pull
  else
    git clone "${plugins[$plugin]}" "$dir"
  fi
done

# Настройка .zshrc: включить алиас для eza
ZSHRC="$HOME/.zshrc"
if ! grep -q "alias ls='eza" "$ZSHRC"; then
  cat << 'EOF' >> "$ZSHRC"

# Использовать eza вместо ls
if command -v eza &>/dev/null; then
  alias ls='eza -la --icons --group-directories-first'
fi
EOF
fi

# Сделать zsh оболочкой по умолчанию
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

echo "🎉 Установка завершена! Перезапусти терминал или запусти 'zsh'."
