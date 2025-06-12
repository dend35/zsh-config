#!/bin/bash

# Папка для пользовательских плагинов Oh My Zsh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Список плагинов и их репозиториев
declare -A plugins=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
  [zsh-history-substring-search]="https://github.com/zsh-users/zsh-history-substring-search"
  [zsh-completions]="https://github.com/zsh-users/zsh-completions"
  [zsh-interactive-cd]="https://github.com/changyuheng/zsh-interactive-cd"
)

echo "🛠 Установка Zsh-плагинов..."

for plugin in "${!plugins[@]}"; do
  plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
  repo_url="${plugins[$plugin]}"
  
  if [ -d "$plugin_dir" ]; then
    echo "🔁 Плагин $plugin уже установлен. Обновляем..."
    git -C "$plugin_dir" pull
  else
    echo "📥 Устанавливаем $plugin..."
    git clone "$repo_url" "$plugin_dir"
  fi
done

echo "✅ Все плагины установлены или обновлены."
